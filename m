Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B9DD0117
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 21:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730250AbfJHTTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 15:19:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43266 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfJHTTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 15:19:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Nx1tfnzncNr1/2YEe91mPr6s9qQb805exoxZT/kE+5Y=; b=j7TTiFOjt+1RkFZcxcir9K79v
        ZPi31CptFJa+ykSk5Z+i5oziljqs8kVg1nPlVm+qbBJFrD7o6IIEEsZQ846CG5HsDnSZmvG+89G2r
        oc2zghrxJEsFKl6qIc4A+oKr3OHRvirmk6PB6iWnregY3vI5UUiMcdToXZQN6biyWfRBsOvjdb3xE
        vfgA+nwWKe+50/+B34tlL7g3aXyfewvRAw9dI0yNHqRBGSbBXWaAgnpWqXiPpsCrdZhrLPzNDnmrW
        6hVi5ESd2k1ui1G1zQoJ7/kcjloHIWCL6wSZGKB/SK/i0nNVSchQ7K7fNquDuo+Dw7VIpR2sMG1rp
        VXOfdODOQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHv0B-0005Vw-5M; Tue, 08 Oct 2019 19:18:31 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5DDCD305EE1;
        Tue,  8 Oct 2019 21:17:34 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 876CE202448A4; Tue,  8 Oct 2019 21:18:25 +0200 (CEST)
Date:   Tue, 8 Oct 2019 21:18:25 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Qian Cai <cai@lca.pw>, akpm@linux-foundation.org, mingo@redhat.com,
        will@kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, sean@poorly.run, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org,
        jslaby@suse.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, intel-gfx@lists.freedesktop.org,
        tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org,
        tj@kernel.org, mark@fasheh.com, jlbec@evilplan.or,
        joseph.qi@linux.alibaba.com, ocfs2-devel@oss.oracle.com,
        davem@davemloft.net, st@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, duyuyang@gmail.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        alexander.levin@microsoft.com
Subject: Re: [PATCH -next] treewide: remove unused argument in lock_release()
Message-ID: <20191008191825.GH2328@hirez.programming.kicks-ass.net>
References: <1568909380-32199-1-git-send-email-cai@lca.pw>
 <20191008163351.GR16989@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008163351.GR16989@phenom.ffwll.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 06:33:51PM +0200, Daniel Vetter wrote:
> On Thu, Sep 19, 2019 at 12:09:40PM -0400, Qian Cai wrote:
> > Since the commit b4adfe8e05f1 ("locking/lockdep: Remove unused argument
> > in __lock_release"), @nested is no longer used in lock_release(), so
> > remove it from all lock_release() calls and friends.
> > 
> > Signed-off-by: Qian Cai <cai@lca.pw>
> 
> Ack on the concept and for the drm parts (and feel free to keep the ack if
> you inevitably have to respin this later on). Might result in some
> conflicts, but welp we need to keep Linus busy :-)
> 
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Thanks Daniel!
