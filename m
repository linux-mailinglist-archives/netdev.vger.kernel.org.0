Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0011FC0C0
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 23:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgFPVPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 17:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgFPVPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 17:15:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E158AC061573;
        Tue, 16 Jun 2020 14:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=leEz1fiyyYNCvStCVFZ11qKUfHMh+AfUoU9zFTvCrqA=; b=oHgSA/KCDX899omYMHX4U2OLjJ
        EwMhiIoHigLxQ+MmRFcXyHzBFlTQmZXr04WRoMkHZe+LheH9bL5uSbscQsM64m29mzWCbQbg2tT8+
        7YVv6xeVy1vViCaTYlOd/6wXfcX6a1cFVTgtaelhNr5Sx0Bq8ty7srr8SsI2tSkKUXRYqisvkGrfi
        sJiaQyRIt9mSxfwey610s9TuikWX8HXsiUmyGfH8ZS9oPdOb24GGhFyI8BfzM4UPPYgOLJ+VdR52j
        Y86D/VTQJXkQsTbKRbFAYueGk1mSp6BZ3PR31zhRZoTaAupph04Ady7RM7jEh9GkVMlChc2sCJczP
        HkwXD4Iw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jlIv1-00069R-Gz; Tue, 16 Jun 2020 21:14:55 +0000
Date:   Tue, 16 Jun 2020 14:14:55 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Joe Perches <joe@perches.com>
Cc:     Waiman Long <longman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Sterba <dsterba@suse.cz>,
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
Message-ID: <20200616211455.GB8681@bombadil.infradead.org>
References: <20200616015718.7812-1-longman@redhat.com>
 <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 11:53:50AM -0700, Joe Perches wrote:
> To this larger audience and last week without reply:
> https://lore.kernel.org/lkml/573b3fbd5927c643920e1364230c296b23e7584d.camel@perches.com/
> 
> Are there _any_ fastpath uses of kfree or vfree?

I worked on adding a 'free' a couple of years ago.  That was capable
of freeing percpu, vmalloc, kmalloc and alloc_pages memory.  I ran into
trouble when I tried to free kmem_cache_alloc memory -- it works for slab
and slub, but not slob (because slob needs the size from the kmem_cache).

My motivation for this was to change kfree_rcu() to just free_rcu().

> To eliminate these mispairings at a runtime cost of four
> comparisons, should the kfree/vfree/kvfree/kfree_const
> functions be consolidated into a single kfree?

I would say to leave kfree() alone and just introduce free() as a new
default.  There's some weird places in the kernel that have a 'free'
symbol of their own, but those should be renamed anyway.
