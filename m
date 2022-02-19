Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADA24BC3E6
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 01:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240535AbiBSAxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:53:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240560AbiBSAxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:53:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3FC5227AA1A
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645231974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=bfdSe7lRaptVEMlnEPCAWLVs5ZfvUfB2TPSykKyb3y4=;
        b=FhsCrgcouYfiJvjwiAbMiuw38ONE5XZfU4dLdYK5IG76HYF+jPkJf+uhsLPHLEOmDSIGYt
        A9R6EcDwuGTmikVq5IVi/MthcCp53wxDT72XTAMAsn1Vb4RWgRIpZHoGgowKalmTfZUaSG
        YLMK8OyoQ6N3PfVCZ5A02E7+9iE5JRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-PS1k_-o0MFKRgOLXBFCeEw-1; Fri, 18 Feb 2022 19:52:51 -0500
X-MC-Unique: PS1k_-o0MFKRgOLXBFCeEw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65B031800D50;
        Sat, 19 Feb 2022 00:52:48 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71C1B62D4E;
        Sat, 19 Feb 2022 00:52:39 +0000 (UTC)
From:   Baoquan He <bhe@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, 42.hyeyoo@gmail.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        David.Laight@ACULAB.COM, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: [PATCH 01/22] parisc: pci-dma: remove stale code and comment
Date:   Sat, 19 Feb 2022 08:52:00 +0800
Message-Id: <20220219005221.634-2-bhe@redhat.com>
In-Reply-To: <20220219005221.634-1-bhe@redhat.com>
References: <20220219005221.634-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The gfp assignment has been commented out in ancient times, combined with
the code comment, obviously it's not needed since then. Let's remove the
whole ifdeffery block so that GFP_DMA searching won't point to this.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/parisc/kernel/pci-dma.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index 36a57aa38e87..6c7c6314ef33 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -417,14 +417,6 @@ void *arch_dma_alloc(struct device *dev, size_t size,
 	map_uncached_pages(vaddr, size, paddr);
 	*dma_handle = (dma_addr_t) paddr;
 
-#if 0
-/* This probably isn't needed to support EISA cards.
-** ISA cards will certainly only support 24-bit DMA addressing.
-** Not clear if we can, want, or need to support ISA.
-*/
-	if (!dev || *dev->coherent_dma_mask < 0xffffffff)
-		gfp |= GFP_DMA;
-#endif
 	return (void *)vaddr;
 }
 
-- 
2.17.2

