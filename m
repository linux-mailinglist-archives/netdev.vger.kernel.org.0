Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA8CC1C14
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 09:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729634AbfI3HaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 03:30:13 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35606 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfI3HaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 03:30:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+RxVhfg/XqKkmLaVbtiYHGOh1FSjmgcY7SoSeeOxLws=; b=RIUESRFxLtDN6yOAeQnqRT2Tl
        imOaYQBEHlXioRQUhAXw+pEyGz4F5u2Xd9pigFxiSivWCGTMUCoGIYzxyVeMIWpaOQZVML65ZJb6C
        ZwefEhmPzjdTla9bwPzNMaDGwktKVErqLCxH1FeWc7vaqZ8Lq2LUsEl4RexprH62pddRzCo6Uv4Hu
        jelEw3faOMfP7i+paWjjWyDnS4IZbf9PHyDhKlqDWzt4zbyzUVAplr6d5tcGTWahipCOzg7QcxRBe
        c984nCz/UvNNxmzCNIkhw3HPOV+VVaGduUTWtfqTOkd+Lu2L75NBXHYFvOO4lOAfqyP5IGXyJuJdW
        jDMQWAJTg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEq7r-00013E-Gb; Mon, 30 Sep 2019 07:29:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E24CE301B59;
        Mon, 30 Sep 2019 09:28:50 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A0F3F2651BB8E; Mon, 30 Sep 2019 09:29:38 +0200 (CEST)
Date:   Mon, 30 Sep 2019 09:29:38 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Qian Cai <cai@lca.pw>
Cc:     akpm@linux-foundation.org, mingo@redhat.com, will@kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
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
Message-ID: <20190930072938.GK4553@hirez.programming.kicks-ass.net>
References: <1568909380-32199-1-git-send-email-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568909380-32199-1-git-send-email-cai@lca.pw>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 12:09:40PM -0400, Qian Cai wrote:
> Since the commit b4adfe8e05f1 ("locking/lockdep: Remove unused argument
> in __lock_release"), @nested is no longer used in lock_release(), so
> remove it from all lock_release() calls and friends.

Right; I never did this cleanup for not wanting the churn, but as long
as it applies I'll take it.

> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  drivers/gpu/drm/drm_connector.c               |  2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_shrinker.c  |  6 +++---
>  drivers/gpu/drm/i915/gt/intel_engine_pm.c     |  2 +-
>  drivers/gpu/drm/i915/i915_request.c           |  2 +-
>  drivers/tty/tty_ldsem.c                       |  8 ++++----
>  fs/dcache.c                                   |  2 +-
>  fs/jbd2/transaction.c                         |  4 ++--
>  fs/kernfs/dir.c                               |  4 ++--
>  fs/ocfs2/dlmglue.c                            |  2 +-
>  include/linux/jbd2.h                          |  2 +-
>  include/linux/lockdep.h                       | 21 ++++++++++-----------
>  include/linux/percpu-rwsem.h                  |  4 ++--
>  include/linux/rcupdate.h                      |  2 +-
>  include/linux/rwlock_api_smp.h                | 16 ++++++++--------
>  include/linux/seqlock.h                       |  4 ++--
>  include/linux/spinlock_api_smp.h              |  8 ++++----
>  include/linux/ww_mutex.h                      |  2 +-
>  include/net/sock.h                            |  2 +-
>  kernel/bpf/stackmap.c                         |  2 +-
>  kernel/cpu.c                                  |  2 +-
>  kernel/locking/lockdep.c                      |  3 +--
>  kernel/locking/mutex.c                        |  4 ++--
>  kernel/locking/rtmutex.c                      |  6 +++---
>  kernel/locking/rwsem.c                        | 10 +++++-----
>  kernel/printk/printk.c                        | 10 +++++-----
>  kernel/sched/core.c                           |  2 +-
>  lib/locking-selftest.c                        | 24 ++++++++++++------------
>  mm/memcontrol.c                               |  2 +-
>  net/core/sock.c                               |  2 +-
>  tools/lib/lockdep/include/liblockdep/common.h |  3 +--
>  tools/lib/lockdep/include/liblockdep/mutex.h  |  2 +-
>  tools/lib/lockdep/include/liblockdep/rwlock.h |  2 +-
>  tools/lib/lockdep/preload.c                   | 16 ++++++++--------
>  33 files changed, 90 insertions(+), 93 deletions(-)

Thanks!
