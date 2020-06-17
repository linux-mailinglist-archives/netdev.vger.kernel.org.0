Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258851FC2DF
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 02:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgFQAh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 20:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFQAhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 20:37:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCECC061573;
        Tue, 16 Jun 2020 17:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wFQoXTSBvbEH49Ty46ov9C8/Nsm6g8zmno6k8zfkw2E=; b=n3JyTVpYYWBeG3//7Dbz6/D0OV
        GzgCh3WX+b3KjXRf4Xu6V0kdWmcuZlo2UQDkR2srryX8xaDqqXUoKDJBqLY7z9Bq/HRtzigf/uuiY
        Sd9jJpet2hC7DsxpwLEdZSe4WrbCxE6M7EuV4BE8Ch3Qujx54e7p1KIWEuHwoa8nTUBRG0qgKm3X8
        u7bLbT0NrHrYEwM3LMHCZKB4a00yRbRrAuqtH54MqoUTLvEdaMZTkNth3X48Dr08NSer2XbXsH4Cc
        9E/jX0kKqgw0X02KSRbK/oP/jsZWfFKLiCNdwF4MOhsJnOh7KhHW+wqMLwNoSKm5xDEvSkWRRH8mP
        +9pgK1yg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jlM4l-0006AH-5o; Wed, 17 Jun 2020 00:37:11 +0000
Date:   Tue, 16 Jun 2020 17:37:11 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     dsterba@suse.cz, Joe Perches <joe@perches.com>,
        Waiman Long <longman@redhat.com>,
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
Message-ID: <20200617003711.GD8681@bombadil.infradead.org>
References: <20200616015718.7812-1-longman@redhat.com>
 <fe3b9a437be4aeab3bac68f04193cb6daaa5bee4.camel@perches.com>
 <20200616230130.GJ27795@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616230130.GJ27795@twin.jikos.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 01:01:30AM +0200, David Sterba wrote:
> On Tue, Jun 16, 2020 at 11:53:50AM -0700, Joe Perches wrote:
> > On Mon, 2020-06-15 at 21:57 -0400, Waiman Long wrote:
> > >  v4:
> > >   - Break out the memzero_explicit() change as suggested by Dan Carpenter
> > >     so that it can be backported to stable.
> > >   - Drop the "crypto: Remove unnecessary memzero_explicit()" patch for
> > >     now as there can be a bit more discussion on what is best. It will be
> > >     introduced as a separate patch later on after this one is merged.
> > 
> > To this larger audience and last week without reply:
> > https://lore.kernel.org/lkml/573b3fbd5927c643920e1364230c296b23e7584d.camel@perches.com/
> > 
> > Are there _any_ fastpath uses of kfree or vfree?
> 
> I'd consider kfree performance critical for cases where it is called
> under locks. If possible the kfree is moved outside of the critical
> section, but we have rbtrees or lists that get deleted under locks and
> restructuring the code to do eg. splice and free it outside of the lock
> is not always possible.

Not just performance critical, but correctness critical.  Since kvfree()
may allocate from the vmalloc allocator, I really think that kvfree()
should assert that it's !in_atomic().  Otherwise we can get into trouble
if we end up calling vfree() and have to take the mutex.
