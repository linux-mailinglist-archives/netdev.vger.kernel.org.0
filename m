Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9F32B149B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 04:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgKMDS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 22:18:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgKMDS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 22:18:28 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5117720A8B;
        Fri, 13 Nov 2020 03:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605237507;
        bh=MaaBG4tccxbaQ9aA0t1wzQvpBf1+T4mhBfx53VS77+M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rr+0OHmnci8Dg534Baejpue8Nb3PJ+kZfcIki+m1P0ulo2cK245KXG5af4kDeYI7E
         63I88cgNJzpJGs5tYUUQ/mSQmZZB+VpGgHX5kESj+06yqhE+PIqdd+Q22Vn1/jzIcG
         sIM2UwrmeQ3MyOeHvJCSJEofPX70zpcdRjTLQuYc=
Date:   Thu, 12 Nov 2020 19:18:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Roman Gushchin <guro@fb.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH bpf-next v5 01/34] mm: memcontrol: use helpers to read
 page's memcg data
Message-Id: <20201112191825.1a7c3e0d50cc5e375a4e887c@linux-foundation.org>
In-Reply-To: <20201113030456.drdswcndp65zmt2u@ast-mbp>
References: <20201112221543.3621014-1-guro@fb.com>
        <20201112221543.3621014-2-guro@fb.com>
        <20201113095632.489e66e2@canb.auug.org.au>
        <20201113002610.GB2934489@carbon.dhcp.thefacebook.com>
        <20201113030456.drdswcndp65zmt2u@ast-mbp>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 19:04:56 -0800 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Nov 12, 2020 at 04:26:10PM -0800, Roman Gushchin wrote:
> > 
> > These patches are not intended to be merged through the bpf tree.
> > They are included into the patchset to make bpf selftests pass and for
> > informational purposes.
> > It's written in the cover letter.
> ...
> > Maybe I had to just list their titles in the cover letter. Idk what's
> > the best option for such cross-subsystem dependencies.
> 
> We had several situations in the past releases where dependent patches
> were merged into multiple trees. For that to happen cleanly from git pov
> one of the maintainers need to create a stable branch/tag and let other
> maintainers pull that branch into different trees. This way the sha-s
> stay the same and no conflicts arise during the merge window.
> In this case sounds like the first 4 patches are in mm tree already.
> Is there a branch/tag I can pull to get the first 4 into bpf-next?

Not really, at present.  This is largely by design, although it does cause
this problem once or twice a year.

These four patches:

mm-memcontrol-use-helpers-to-read-pages-memcg-data.patch
mm-memcontrol-slab-use-helpers-to-access-slab-pages-memcg_data.patch
mm-introduce-page-memcg-flags.patch
mm-convert-page-kmemcg-type-to-a-page-memcg-flag.patch

are sufficiently reviewed - please pull them into the bpf tree when
convenient.  Once they hit linux-next, I'll drop the -mm copies and the
bpf tree maintainers will then be responsible for whether & when they
get upstream.  

