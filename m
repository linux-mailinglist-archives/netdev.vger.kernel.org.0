Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A7A1FCD4D
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 14:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgFQMXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 08:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbgFQMXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 08:23:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110BEC061573;
        Wed, 17 Jun 2020 05:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kuxQjzZYMs0tFNd2RWRJXl84IRXkLYtgdsZsfAqzUYg=; b=IQBU2NQmYfbU9KEVYJFVsVFYt3
        +7GWl3H6cqgUcZ3+um4sERSLuBbzrv7jNZkdM2ZwoSGps038Nt8YY6ApW7PCwZCMfBc10Gz0GDyzO
        FLEfO9i0HAYVGksHFDKWFRCvjngG1ecDhElpGpw4HbCuIF3Vgh8+lquymjHTFre2rQkZtiIdou22y
        K/Aznp4o73iZczN2ksz99zOnq95b5QaAhubthCZzggr2DMMUwYzN2WxAT6vZxmfMDafnFj+QcCY/1
        +vXnWv1CMw2nHqOvDrXxSQKys1aoXcvwws0qgcZ/d+QvYDKvCoK1AjvkCvq5Nft1Yp25qyw3Vw/EI
        56Yd0PTA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jlX69-0005Xm-3Z; Wed, 17 Jun 2020 12:23:21 +0000
Date:   Wed, 17 Jun 2020 05:23:21 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     dsterba@suse.cz, Joe Perches <joe@perches.com>,
        Waiman Long <longman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, linux-mm@kvack.org,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, wireguard@lists.zx2c4.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, ecryptfs@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-bluetooth@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH v4 0/3] mm, treewide: Rename kzfree() to kfree_sensitive()
Message-ID: <20200617122321.GJ8681@bombadil.infradead.org>
References: <20200616015718.7812-1-longman@redhat.com>
 <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
 <20200616230130.GJ27795@twin.jikos.cz>
 <20200617003711.GD8681@bombadil.infradead.org>
 <20200617071212.GJ9499@dhcp22.suse.cz>
 <20200617110820.GG8681@bombadil.infradead.org>
 <20200617113157.GM9499@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617113157.GM9499@dhcp22.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 01:31:57PM +0200, Michal Hocko wrote:
> On Wed 17-06-20 04:08:20, Matthew Wilcox wrote:
> > If you call vfree() under
> > a spinlock, you're in trouble.  in_atomic() only knows if we hold a
> > spinlock for CONFIG_PREEMPT, so it's not safe to check for in_atomic()
> > in __vfree().  So we need the warning in order that preempt people can
> > tell those without that there is a bug here.
> 
> ... Unless I am missing something in_interrupt depends on preempt_count() as
> well so neither of the two is reliable without PREEMPT_COUNT configured.

preempt_count() always tracks whether we're in interrupt context,
regardless of CONFIG_PREEMPT.  The difference is that CONFIG_PREEMPT
will track spinlock acquisitions as well.
