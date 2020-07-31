Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E177F233C8D
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730948AbgGaA0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730916AbgGaA0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:26:16 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2388FC06174A
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 17:26:16 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ha11so6135301pjb.1
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 17:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z3Lm1sGkWQwPe3NkE6iARE36RcrQ0xDQdl/rL+tDjI0=;
        b=sOOQDS6l29PwJncVTdlZkzs7X7QSPkZPgnQAmSIwmUOgSvyL2/q0N7p90FYdSW2s8j
         7CUVCSO8S+NAKPz3nxM6HhwyGHv+sbArXQoh5HbHlu8QYOGJbIQnOYENg9nXxXSjqXmE
         b/NXnhhTJcnAncLg5glbJ16Gmu7U9R7QCPUgEmu8abMsBqnftD0pBFG9svq8rL0X1x/+
         8QDgT9u9tf81CyG+A5/tzVxH58yQi4pFayRE1lwYeGvyydlZNXXPSUdjYJIU9bOJ2Y5Q
         Duxb7LFSRiGHX9usLWXOtYqk0aAF6bIjq1IUM4JvYDAPcBT2UjU0aKEK9VPxeKVm1Hx4
         PkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z3Lm1sGkWQwPe3NkE6iARE36RcrQ0xDQdl/rL+tDjI0=;
        b=R4w1Hdxcro4dksDR96PetFp/4vtQQAtgJ7eUizAzlTaxRfkEfMzMeq/XK0aM2rrGSO
         8BEcd0Iba6m9aUihMNkrgQCik2SDbrEpyLWnDPxns1HreXSohNk2d4FbGhmQEI+R1JO1
         bw7bBYuf7Qw1x1r0qZJ2D/cA9LpFfQwj/XWWA15HcY5IOEmgnAsKKQJio84RYCIVJNiq
         fKQl4kDwvgTGxLN7TeG10uyRkStbEmOr+sr2nTQ/0acuD5Xo8+xZ99PKVIiUvIsdkXja
         nVURp8xeLWZRxJe7RyXL96oAWQm/IuQwF0XVi6YDG0talJ4zb1hzbw/5VxGKsIsRfuU4
         tBMA==
X-Gm-Message-State: AOAM53159VrgIsk48Fno0SXQ1UObMzcLozuJwmMMUDm/YCE4GIkj1cT+
        SlWknLd/X3zDqY3r2Q+OZAStgQ==
X-Google-Smtp-Source: ABdhPJwcr954AG1gqEdKpM5QuRqbV3+wB5pscU2NtJ0l5WoRi0tIaQ0FwOD7I+WVx/5rp3y/anJJGw==
X-Received: by 2002:a63:8c5d:: with SMTP id q29mr1238398pgn.249.1596155175408;
        Thu, 30 Jul 2020 17:26:15 -0700 (PDT)
Received: from google.com (56.4.82.34.bc.googleusercontent.com. [34.82.4.56])
        by smtp.gmail.com with ESMTPSA id p19sm7867698pgj.74.2020.07.30.17.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 17:26:14 -0700 (PDT)
Date:   Fri, 31 Jul 2020 00:26:11 +0000
From:   William Mcvicker <willmcvicker@google.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     security@kernel.org, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH 1/1] netfilter: nat: add range checks for access to
 nf_nat_l[34]protos[]
Message-ID: <20200731002611.GA1035680@google.com>
References: <20200727175720.4022402-1-willmcvicker@google.com>
 <20200727175720.4022402-2-willmcvicker@google.com>
 <20200729214607.GA30831@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729214607.GA30831@salvia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

Yes, I believe this oops is only triggered by userspace when the user
specifically passes in an invalid nf_nat_l3protos index. I'm happy to re-work
the patch to check for this in ctnetlink_create_conntrack().

> BTW, do you have a Fixes: tag for this? This will be useful for
> -stable maintainer to pick up this fix.

Regarding the Fixes: tag, I don't have one offhand since this bug was reported
to me, but I can search through the code history to find the commit that
exposed this vulnerability.

Thanks,
Will

On 07/29/2020, Pablo Neira Ayuso wrote:
> Hi Will,
> 
> On Mon, Jul 27, 2020 at 05:57:20PM +0000, Will McVicker wrote:
> > The indexes to the nf_nat_l[34]protos arrays come from userspace. So we
> > need to make sure that before indexing the arrays, we verify the index
> > is within the array bounds in order to prevent an OOB memory access.
> > Here is an example kernel panic on 4.14.180 when userspace passes in an
> > index greater than NFPROTO_NUMPROTO.
> > 
> > Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> > Modules linked in:...
> > Process poc (pid: 5614, stack limit = 0x00000000a3933121)
> > CPU: 4 PID: 5614 Comm: poc Tainted: G S      W  O    4.14.180-g051355490483
> > Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM
> > task: 000000002a3dfffe task.stack: 00000000a3933121
> > pc : __cfi_check_fail+0x1c/0x24
> > lr : __cfi_check_fail+0x1c/0x24
> > ...
> > Call trace:
> > __cfi_check_fail+0x1c/0x24
> > name_to_dev_t+0x0/0x468
> > nfnetlink_parse_nat_setup+0x234/0x258
> 
> If this oops is only triggerable from userspace, I think a sanity
> check in nfnetlink_parse_nat_setup should suffice to reject
> unsupported layer 3 and layer 4 protocols.
> 
> I mean, in this patch I see more chunks in the packet path, such as
> nf_nat_l3proto_ipv4 that should never happen. I would just fix the
> userspace ctnetlink path.
> 
> BTW, do you have a Fixes: tag for this? This will be useful for
> -stable maintainer to pick up this fix.
> 
> Thanks.
