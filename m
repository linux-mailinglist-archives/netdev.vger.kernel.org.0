Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53BEB9108
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 15:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387464AbfITNty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 09:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387424AbfITNty (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 09:49:54 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DE062054F;
        Fri, 20 Sep 2019 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568987393;
        bh=JziL+5K0N67ZfzV4tlVfkTPVyCElvzMYgV7JKwZMvak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I3aTruf+IgU+nu2WE9zoVKEsbQiuW1la0SrCePBCYi/j7Jep2PZJEI/aEbQCK2dlD
         FJkBTGSE1Dae8vjnWNYZOGUZtAOcdhrBtwvOMy1GDMt96r5u1dd2sz5lfXy4XASxJo
         Khgn1c3fwX9e7+fy0lwK0UCkXIO/oAu8Q/KnWcIA=
Date:   Fri, 20 Sep 2019 14:49:43 +0100
From:   Will Deacon <will@kernel.org>
To:     Qian Cai <cai@lca.pw>
Cc:     torvalds@linux-foundation.org, ast@kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org,
        jslaby@suse.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, intel-gfx@lists.freedesktop.org,
        tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
        tj@kernel.org, mark@fasheh.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com,
        davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, duyuyang@gmail.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, hannes@cmpxchg.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, alexander.levin@microsoft.com
Subject: Re: [PATCH -next] treewide: remove unused argument in lock_release()
Message-ID: <20190920134942.iiygzg6s7dcay56l@willie-the-truck>
References: <1568909380-32199-1-git-send-email-cai@lca.pw>
 <20190920093700.7nfaghxdrmubp2do@willie-the-truck>
 <1568983836.5576.194.camel@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568983836.5576.194.camel@lca.pw>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 08:50:36AM -0400, Qian Cai wrote:
> On Fri, 2019-09-20 at 10:38 +0100, Will Deacon wrote:
> > On Thu, Sep 19, 2019 at 12:09:40PM -0400, Qian Cai wrote:
> > > Since the commit b4adfe8e05f1 ("locking/lockdep: Remove unused argument
> > > in __lock_release"), @nested is no longer used in lock_release(), so
> > > remove it from all lock_release() calls and friends.
> > > 
> > > Signed-off-by: Qian Cai <cai@lca.pw>
> > > ---
> > 
> > Although this looks fine to me at a first glance, it might be slightly
> > easier to manage if you hit {spin,rwlock,seqcount,mutex,rwsem}_release()
> > first with coccinelle scripts, and then hack lock_release() as a final
> > patch. That way it's easy to regenerate things if needed.
> 
> I am not sure if it worth the extra efforts where I have to retest it on all
> architectures, and the patch is really simple, but I can certainly do that if
> you insist.

I'm not insisting, just thought it might be easier to get it merged that
way. If you prefer to go with the big diff,

Acked-by: Will Deacon <will@kernel.org>

Will
