Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0E8547E25
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 05:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiFMD36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 23:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiFMD35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 23:29:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0125E13F61
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 20:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655090994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aKrLIz2/fH9wSRg7503YdOZi93Zj103cLf7h7Hd63iM=;
        b=CdPQ/MzSOlN7EHxSTAWiKCG20QvSFLAu3ZGSPtXH54whz/g9iYXHDBgSTABPBAhnJV4tV5
        TiVnd3FHaP83/70bXlQxeAuJIx2QXa2nL8Mc+2O6wu5kIc3RBqhM8m7u0W2ONoYU89JRHJ
        0Pc7EQPy9EB/PAHCYNIEh6HTxXXAmf4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-rq6WqYbWN62WxILCcKR50Q-1; Sun, 12 Jun 2022 23:29:53 -0400
X-MC-Unique: rq6WqYbWN62WxILCcKR50Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B91E4802804;
        Mon, 13 Jun 2022 03:29:52 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91D20492C3B;
        Mon, 13 Jun 2022 03:29:52 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     stefan@datenfreihafen.org
Cc:     linux-wpan@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, aahringo@redhat.com
Subject: [PATCH wpan-next 1/2] 6lowpan: nhc: more constify api
Date:   Sun, 12 Jun 2022 23:29:21 -0400
Message-Id: <20220613032922.1030739-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds an const to the return of lowpan_nhc_by_nexthdr(), as we
never modify nhcs.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/6lowpan/nhc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/6lowpan/nhc.h b/net/6lowpan/nhc.h
index ab7b4977c32b..4ba6b2ffcb47 100644
--- a/net/6lowpan/nhc.h
+++ b/net/6lowpan/nhc.h
@@ -66,6 +66,7 @@ struct lowpan_nhc {
 
 	int		(*uncompress)(struct sk_buff *skb, size_t needed);
 	int		(*compress)(struct sk_buff *skb, u8 **hc_ptr);
+
 };
 
 /**
@@ -73,7 +74,7 @@ struct lowpan_nhc {
  *
  * @nexthdr: ipv6 nexthdr value.
  */
-struct lowpan_nhc *lowpan_nhc_by_nexthdr(u8 nexthdr);
+const struct lowpan_nhc *lowpan_nhc_by_nexthdr(u8 nexthdr);
 
 /**
  * lowpan_nhc_check_compression - checks if we support compression format. If
-- 
2.31.1

