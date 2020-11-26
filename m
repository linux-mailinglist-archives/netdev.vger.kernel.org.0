Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482922C5A51
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 18:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404043AbgKZRNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 12:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404008AbgKZRNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 12:13:09 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A998C0613D4;
        Thu, 26 Nov 2020 09:13:08 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id i17so3116523ljd.3;
        Thu, 26 Nov 2020 09:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VpnUj0vwEBxW6p7ITczWY4IsgxvLvEJLYdLmcYXOZkU=;
        b=bNIV9vN0a4JsfmKqZ80aejvtZg4VlBh59eCSvINKkY7gI+B3p+OINaw1WT8TbCuYEp
         w9SieaelhASvFeb55DSGvdrvjXoa8lCwCqZCffodPp7944KO4zJpQSkdVpwDf5B6mmPd
         MmKveMlfHhcEnUbl1FMte4aJpELc8Wtt3ENVKEEVfMGk/tTXcmS+a84sk9XirGRBFa75
         Pz/oTnxPeCwC9u/bNg8DJCn+qRvt7/gQRVVmn2X6jxWNyoVc8ddJy4TbAs/X3poYhsn3
         bhlzF+ZVefYRNx2Hi7+3WG1KJ5joQFxklIMgsIEX/v4JUJ+/WE7VLGCtv0ZhEzJ4cHrj
         L04g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VpnUj0vwEBxW6p7ITczWY4IsgxvLvEJLYdLmcYXOZkU=;
        b=fbpdMkrCJUSaX0YDMSQKe64kZJHhjwwFPzFcOX8PpqRbPb7b9fPmAeFZ7qeFIfQmjo
         hxbrdzx1crE4jwmyaMcVblVDhfztNcSO1evpYFWBL0rXFfY0VLk0kuMytiqUfBD8GVBP
         cTsrXy5zZYhkE3GqFn1wZaOucc7TSYEWbiPjLztIBEtsAFshXpsRrOti+zqIpmvnWtRA
         zsc3CSw9f+MbTkeZehEJcPz2WCWk+xZ3m22CKfqZhVSXs8selzqKq866ivxHQ8iqzpCl
         fkmA2b9nQD+Q0IYjfUm2zZCiXGDBaRVAZHeBV2w0rXXY1OpbwTytgxem9ENuYaf1Fef8
         bgjg==
X-Gm-Message-State: AOAM531yaOiJ7Mnir8MfZjijtEplQtd25gzyyVmmAMSxNgW8wxT4n5Mp
        aPssykWM6lonor6x22vXjLPk5zFj4hBcsz9pVf8=
X-Google-Smtp-Source: ABdhPJy3urs2BeAfWjkHI6bDf9nhnilb7OzdM0ndQotzW8xx/eFGnLcSx3/i/yka1xN40aF1n6yHdaWNpOKCmlEuXMA=
X-Received: by 2002:a2e:9648:: with SMTP id z8mr1567183ljh.91.1606410786463;
 Thu, 26 Nov 2020 09:13:06 -0800 (PST)
MIME-Version: 1.0
References: <20201125030119.2864302-1-guro@fb.com> <20201125030119.2864302-7-guro@fb.com>
 <ef140167-8d80-c581-318c-36c0430e4cfa@iogearbox.net> <20201126023000.GB840171@carbon.dhcp.thefacebook.com>
In-Reply-To: <20201126023000.GB840171@carbon.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 26 Nov 2020 09:12:55 -0800
Message-ID: <CAADnVQ+eohA6drYFbbw4ZD-H91xESf=WjZT-oPK85dpdJJAYhQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 06/34] bpf: prepare for memcg-based memory
 accounting for bpf maps
To:     Roman Gushchin <guro@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 6:30 PM Roman Gushchin <guro@fb.com> wrote:
>
> I did consider this option. There are pros and cons. In general we tend to charge the cgroup
> which actually allocates the memory, and I decided to stick with this rule. I agree, it's fairly
> easy to come with arguments why always charging the map creator is better. The opposite is
> also true: it's not clear why bpf is different here. So I'm fine with both options, if there
> is a wide consensus, I'm happy to switch to the other option. In general, I believe that
> the current scheme is more flexible.

I don't understand the 'more flexible' part.
The current_memcg or map_memcg approach makes it less predictable.
pre-alloc vs not is somewhat orthogonal.
I've grepped through the kernel where set_active_memcg() is used
and couldn't find a conditional pattern of its usage.
If memcg is known it's used. I couldn't come up with the use case where
using current memcg is the more correct thing to do.

> In general we tend to charge the cgroup which actually allocates the memory

that makes sense where allocation is driven by the user process.
Like user space doing a syscall then all kernel allocation would be
from memcg of that process.
But bpf tracing allocations are not something that the user process requested
the kernel to do. It's like another user space process tapped into another.
Arguably when bpf prog is running the two user processes are active.
One that created the map and loaded the prog and another that is being traced.
I think there will be cases where bpf prog will request the kernel to allocate
memory on behalf of the process being traced, but that memory should be
given back to the process and accessible by it in some form.
Like bpf prog could ask the kernel to grow heap of that process or
trigger readahead.
In such case current_memcg would be the right thing to charge.
