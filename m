Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C08A63E314
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiK3WIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiK3WIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EBA54340
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=LAxzevWS6YPjNXWh31EDfcrFweLPV/vKsTWRIoCwYk8=; b=Q3AOoll1e7TsmpbCt5Usl8uDJ/
        so3m8U9hVMfnRgp7mzSDXMC4JghiFAVwzqVOhZzB9ekBfCj0U7/f/XRfRm7hDAStcHDvXo7Tw9n/s
        dDh4nS2EohevkK9OltPAuW99iVugPDbISJAG/VPZcEju10qexa7pWsqj/Oi5vGO+Aoqo7xiUMLiWC
        j1fZawbP4orkfv6iFv61Go/nfWrdjoPviVCaP+bw2pHZ90VVxXZNfWPg/TEYHAlK5JjBvn8QltV1i
        1jC8+x6Yrw+kooi8Q9xu2l+g6Kh42ahY12wHwtQyc+br2Wj4NyjCgJHeFWmSfAuCWf2RUHDf09JZf
        p5vpbCnA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFO-00FLWY-Iw; Wed, 30 Nov 2022 22:08:06 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 21/24] netmem_to_virt
Date:   Wed, 30 Nov 2022 22:08:00 +0000
Message-Id: <20221130220803.3657490-22-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221130220803.3657490-1-willy@infradead.org>
References: <20221130220803.3657490-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
 include/net/page_pool.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 222eedc39140..e13e3a8e83d3 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -112,6 +112,11 @@ static inline struct netmem *virt_to_netmem(const void *x)
 	return page_netmem(virt_to_head_page(x));
 }
 
+static inline void *netmem_to_virt(const struct netmem *nmem)
+{
+	return page_to_virt(netmem_page(nmem));
+}
+
 static inline int netmem_ref_count(const struct netmem *nmem)
 {
 	return page_ref_count(netmem_page(nmem));
-- 
2.35.1

