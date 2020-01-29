Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3B414CF4F
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 18:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgA2RJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 12:09:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:49012 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbgA2RJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 12:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JBGzCaUSC9Lw4zwXSBacb958kBHmLwh4j+E2NT3N+w8=; b=NhFKnxuoL1ybWnVtBKPDIWMBP
        kobcIUhcIWOiLiG3PhNd1ELyerpA31rPbS6Kk+/rNcGNtdvIwl3PWmij/a9xM6voX6vcQ34B/13tb
        4sU+kkNa7lo/b+1DVlDczi63ra5N/m9v+y0mgHUBdkQYpbYHvL4MFcrF2hKLGtE/SDpRurYO/ZJMU
        3fNEzYX6iMsOEDNCuxNq+MS6nvqCnrBj9PFGyavXJ3LfiH3BOipeubAWMl/VM2NN+GdAtadT2jDC1
        ZhsY2KS8Q6r+OuKBSd1ZSOIe6r+EBoMmmCU1+Zeo7KcL47ocsUHq4SR16gYSJMGUFtfahEHuJSMCK
        tP90C6XjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqqR-00019P-Ug; Wed, 29 Jan 2020 17:09:39 +0000
Date:   Wed, 29 Jan 2020 09:09:39 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Christopher Lameter <cl@linux.com>,
        Kees Cook <keescook@chromium.org>, Jiri Slaby <jslaby@suse.cz>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jan Kara <jack@suse.cz>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rik van Riel <riel@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <20200129170939.GA4277@infradead.org>
References: <1515636190-24061-10-git-send-email-keescook@chromium.org>
 <9519edb7-456a-a2fa-659e-3e5a1ff89466@suse.cz>
 <201911121313.1097D6EE@keescook>
 <201911141327.4DE6510@keescook>
 <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz>
 <202001271519.AA6ADEACF0@keescook>
 <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com>
 <202001281457.FA11CC313A@keescook>
 <alpine.DEB.2.21.2001291640350.1546@www.lameter.com>
 <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 29, 2020 at 06:07:14PM +0100, Christian Borntraeger wrote:
> > DMA can be done to NORMAL memory as well.
> 
> Exactly. 
> I think iucv uses GFP_DMA because z/VM needs those buffers to reside below 2GB (which is ZONA_DMA for s390).

The normal way to allocate memory with addressing limits would be to
use dma_alloc_coherent and friends.  Any chance to switch iucv over to
that?  Or is there no device associated with it?
