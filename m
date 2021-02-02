Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7F630BABE
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 10:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhBBJQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 04:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbhBBJOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 04:14:39 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF486C06174A
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 01:13:58 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id p20so9439919ejb.6
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 01:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l766AWiQAnfrwWGGPS2NYbzoWAuQuGBLqlv7J+ZF8qM=;
        b=OLkHd63qgXIXWxm+XhoCpx9tkpyu+5ZZzKVuQ+QophlQcbU6tvTvKH5XiQK/JqOqSR
         6WszBk5oD37JjbhXYyatgoyT8TTt45eY+Qwc/ZekwZVjoTMPm/WiuEvMufbdogHVuumW
         cbT4WunYZ6t8xO09efmqvOgYt92gUjWiBxH474CbuxKPC3AG/f9klUH8Gqo8JMjaMdiD
         fyojPkdM2Nz6cy+JgO74OpkUWK/cyHLhMajsx2/j/8bvJWEgH4qg32Za5HBHngoYQvlk
         pyJ0rqMM3IAGX+rPmCIBVldqAv27Rh8smpilyEGsicem+qmox9cBMEYM9omClTxNoTuB
         qedg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l766AWiQAnfrwWGGPS2NYbzoWAuQuGBLqlv7J+ZF8qM=;
        b=SMtFRuU4HtOXGbtqPXcEp6lDJ2D275bJDudt/Si66AYo0aBLFXqY3fpF0Xe66EN1Tk
         bZ5wLslVXTJWzK5MRwseGjqeYth7sfGAtTPdEO/+fGhjf4JnF+kN9/Nuja4408cZo8mP
         fjpbiVUiKgPpos/8fl2CejKWhzJtqJ30A7Ln+QaoD/Od5i7aYSsbB2tAsGF6N0go4tZj
         F1diqAukJWPX+Hzjd/A6aYWQXOfi2dbfUnyAhkIdHyCdX3+RsmvsH/CiGbkmi7KHosQL
         gtgQG6KmadIO/uOcGuDvGcVM/pnlgD4DDlioe2IxXTzouWQLYifBtbmBtQgREoFbRS02
         XuwA==
X-Gm-Message-State: AOAM533Uicwx0X51yARivnFq6uBsmggNYeCLR4mA8sqka5LauyUXVDKm
        0LjMEfyI+epeDA==
X-Google-Smtp-Source: ABdhPJyjUs2PHzKYpzuBXQOk748o35wKkXxKq/+lGfei4HbAQ/Gu1yoS+qOBflN9loO14UXrJE22bg==
X-Received: by 2002:a17:906:f0d0:: with SMTP id dk16mr6119306ejb.533.1612257237538;
        Tue, 02 Feb 2021 01:13:57 -0800 (PST)
Received: from md2k7s8c.ad001.siemens.net ([2a02:810d:9040:4c1f:e0b6:d0e7:64d2:f3a0])
        by smtp.gmail.com with ESMTPSA id u20sm1211770ejx.22.2021.02.02.01.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 01:13:56 -0800 (PST)
From:   Andreas Oetken <ennoerlangen@googlemail.com>
X-Google-Original-From: Andreas Oetken <ennoerlangen@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andreas Oetken <ennoerlangen@gmail.com>,
        Andreas Oetken <andreas.oetken@siemens.com>
Subject: [PATCH v1] net: hsr: align sup_multicast_addr in struct hsr_priv to u16 boundary
Date:   Tue,  2 Feb 2021 10:13:54 +0100
Message-Id: <20210202091354.2743445-1-ennoerlangen@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andreas Oetken <andreas.oetken@siemens.com>

sup_multicast_addr is passed to ether_addr_equal for address comparison
which casts the address inputs to u16 leading to an unaligned access.
Aligning the sup_multicast_addr to u16 boundary fixes the issue.

Signed-off-by: Andreas Oetken <andreas.oetken@siemens.com>
---
 net/hsr/hsr_main.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 7dc92ce5a134..a9c30a608e35 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -217,7 +217,10 @@ struct hsr_priv {
 	u8 net_id;		/* for PRP, it occupies most significant 3 bits
 				 * of lan_id
 				 */
-	unsigned char		sup_multicast_addr[ETH_ALEN];
+	unsigned char		sup_multicast_addr[ETH_ALEN] __aligned(sizeof(u16));
+				/* Align to u16 boundary to avoid unaligned access
+				 * in ether_addr_equal
+				 */
 #ifdef	CONFIG_DEBUG_FS
 	struct dentry *node_tbl_root;
 #endif
-- 
2.30.0

