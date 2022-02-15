Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4F24B7710
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243365AbiBOTFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 14:05:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbiBOTFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 14:05:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81311F94F2
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 11:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644951903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Khg2zhPKJjAqQNeVp8eg/pB+CGYzc/lWCO2af1oISAE=;
        b=XYh3fs45rl90szswkwL2A+L5OdkrRx/LhVfT1ItLSbO919IQIgl7i+sQnh25GwhFsuNUMn
        MpW5Qf9UA43m4Jp79+fL8JmBK1FrzlujMMe3m5620H/xx5a5TEaYRiZ6ckjifyhhXxI8Ew
        Umxwsdyy+xjOQf4jCDRUUCL88UfzCSM=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-0LMZSHb7Ms6jGfwG6hSaEg-1; Tue, 15 Feb 2022 14:05:02 -0500
X-MC-Unique: 0LMZSHb7Ms6jGfwG6hSaEg-1
Received: by mail-oi1-f199.google.com with SMTP id r15-20020a056808210f00b002d0d8b35b4eso5143108oiw.23
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 11:05:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Khg2zhPKJjAqQNeVp8eg/pB+CGYzc/lWCO2af1oISAE=;
        b=CM9DBWku8txsWsaNVf02wtoeS52gAWkeA0cHU4wTIVZWOw8b1Mmbey8Zaa96TICvpP
         FBIW7378GDJEHNHrE45s3zzIL5fSHY5BkBP7BizDIjeN7wA8a7pn9SZoq7fqvAZAzfRJ
         tiY99Mjou9izutw+ugC94PSZMRgJxY7D2Oai4UQHiO2Jq6wnAcTx9P7OOCFg+Mow2Ivh
         j1U66NcwPJ0u6svAmJNI5ISNjIkDaLR34qxqfpMiI62LpHo9JtDEozTF2ZRqmnROObta
         i+Sm5BUXxF+fvjaRn4XkA7IozL5NNvAqYQDqJxPadkP1NvMJQ2GiKekfSrPoRuXXRS7I
         XTxg==
X-Gm-Message-State: AOAM530l3UCHSmAeUC26r2FSFvyfFRuerMDWItHGJo0M4cUFS4l4WqV6
        1rDovQ6N95Lwc/VAzK+UrcFam5Bj08+EW9gbO32rP+QDbfE8s+tIMGOi2cOd7E5KcsIfFfJD7Wq
        HyVLLamg0rNdCsnVl
X-Received: by 2002:a4a:c98a:: with SMTP id u10mr95157ooq.51.1644951900589;
        Tue, 15 Feb 2022 11:05:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyvdkhD/V9LSyFyY/54DrQA0Tk9oyNpd+C13fNRBanqqrOFL+5tgNZyV5oRpwFBG+7STKYwvQ==
X-Received: by 2002:a4a:c98a:: with SMTP id u10mr95146ooq.51.1644951900365;
        Tue, 15 Feb 2022 11:05:00 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id d1sm12295817otk.70.2022.02.15.11.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 11:04:59 -0800 (PST)
From:   trix@redhat.com
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, gary@garyguo.net,
        rdunlap@infradead.org, esben@geanix.com, huangguangbin2@huawei.com,
        michael@walle.cc, moyufeng@huawei.com, arnd@arndb.de,
        chenhao288@hisilicon.com, andrew@lunn.ch,
        prabhakar.mahadev-lad.rj@bp.renesas.com, yuehaibing@huawei.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] net: ethernet: xilinx: cleanup comments
Date:   Tue, 15 Feb 2022 11:04:47 -0800
Message-Id: <20220215190447.3030710-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Remove the second 'the'.
Replacements:
endiannes to endianness
areconnected to are connected
Mamagement to Management
undoccumented to undocumented
Xilink to Xilinx
strucutre to structure

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/xilinx/Kconfig               | 2 +-
 drivers/net/ethernet/xilinx/ll_temac.h            | 4 ++--
 drivers/net/ethernet/xilinx/ll_temac_main.c       | 2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c     | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 911b5ef9e680..0014729b8865 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
-# Xilink device configuration
+# Xilinx device configuration
 #
 
 config NET_VENDOR_XILINX
diff --git a/drivers/net/ethernet/xilinx/ll_temac.h b/drivers/net/ethernet/xilinx/ll_temac.h
index 4a73127e10a6..ad8d29f84be6 100644
--- a/drivers/net/ethernet/xilinx/ll_temac.h
+++ b/drivers/net/ethernet/xilinx/ll_temac.h
@@ -271,7 +271,7 @@ This option defaults to enabled (set) */
 
 #define XTE_TIE_OFFSET			0x000003A4 /* Interrupt enable */
 
-/**  MII Mamagement Control register (MGTCR) */
+/**  MII Management Control register (MGTCR) */
 #define XTE_MGTDR_OFFSET		0x000003B0 /* MII data */
 #define XTE_MIIMAI_OFFSET		0x000003B4 /* MII control */
 
@@ -283,7 +283,7 @@ This option defaults to enabled (set) */
 
 #define STS_CTRL_APP0_ERR         (1 << 31)
 #define STS_CTRL_APP0_IRQONEND    (1 << 30)
-/* undoccumented */
+/* undocumented */
 #define STS_CTRL_APP0_STOPONEND   (1 << 29)
 #define STS_CTRL_APP0_CMPLT       (1 << 28)
 #define STS_CTRL_APP0_SOP         (1 << 27)
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index b900ab5aef2a..7171b5cdec26 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1008,7 +1008,7 @@ static void ll_temac_recv(struct net_device *ndev)
 		    (skb->len > 64)) {
 
 			/* Convert from device endianness (be32) to cpu
-			 * endiannes, and if necessary swap the bytes
+			 * endianness, and if necessary swap the bytes
 			 * (back) for proper IP checksum byte order
 			 * (be16).
 			 */
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index de0a6372ae0e..6eeaab77fbe0 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -537,7 +537,7 @@ static int __axienet_device_reset(struct axienet_local *lp)
  * This function is called to reset and initialize the Axi Ethernet core. This
  * is typically called during initialization. It does a reset of the Axi DMA
  * Rx/Tx channels and initializes the Axi DMA BDs. Since Axi DMA reset lines
- * areconnected to Axi Ethernet reset lines, this in turn resets the Axi
+ * are connected to Axi Ethernet reset lines, this in turn resets the Axi
  * Ethernet core. No separate hardware reset is done for the Axi Ethernet
  * core.
  * Returns 0 on success or a negative error number otherwise.
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 519599480b15..f65a638b7239 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -498,7 +498,7 @@ static void xemaclite_update_address(struct net_local *drvdata,
  * @dev:	Pointer to the network device instance
  * @address:	Void pointer to the sockaddr structure
  *
- * This function copies the HW address from the sockaddr strucutre to the
+ * This function copies the HW address from the sockaddr structure to the
  * net_device structure and updates the address in HW.
  *
  * Return:	Error if the net device is busy or 0 if the addr is set
-- 
2.26.3

