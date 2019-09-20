Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FDBB8DE5
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 11:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437940AbfITJiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 05:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405989AbfITJiR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 05:38:17 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 921C92086A;
        Fri, 20 Sep 2019 09:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568972296;
        bh=tGK4is/D5yjSmtKMNJsAOY7JysJV6v3B5d+jHSPQihw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pin0EAM6iDgkBVW67KjzDhHgn5lVksFzTRsfquXbR3bJHYdq/O5aV471P+JzSmcS6
         YHKtvlpkzAdl1VYGzcfByN4VuQ4TGD3IU+uGOYlo8hc9sDRuxSD05aPMHw1eu/wEnh
         h/JzstVetnB6YPglx4zQBqM6UU+z/+zyzbI85BIc=
Date:   Fri, 20 Sep 2019 10:38:06 +0100
From:   Will Deacon <will@kernel.org>
To:     Qian Cai <cai@lca.pw>
Cc:     akpm@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
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
        davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, duyuyang@gmail.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, hannes@cmpxchg.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, alexander.levin@microsoft.com
Subject: Re: [PATCH -next] treewide: remove unused argument in lock_release()
Message-ID: <20190920093700.7nfaghxdrmubp2do@willie-the-truck>
References: <1568909380-32199-1-git-send-email-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568909380-32199-1-git-send-email-cai@lca.pw>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 12:09:40PM -0400, Qian Cai wrote:
> Since the commit b4adfe8e05f1 ("locking/lockdep: Remove unused argument
> in __lock_release"), @nested is no longer used in lock_release(), so
> remove it from all lock_release() calls and friends.
> 
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---

Although this looks fine to me at a first glance, it might be slightly
easier to manage if you hit {spin,rwlock,seqcount,mutex,rwsem}_release()
first with coccinelle scripts, and then hack lock_release() as a final
patch. That way it's easy to regenerate things if needed.

Cheers,

Will
