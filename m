Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F554455F9B
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbhKRPgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 10:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbhKRPgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 10:36:46 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB48C061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 07:33:46 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so6891302pjb.1
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 07:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ZgnHyTFQ+qW0pv/HKrVWBqMS9x7zALwG/Yk+DsQJW5U=;
        b=hYozuXSJquDE3d3AAMwc/3BXYIgdwNAV0ivXeTBxAlWyjjavrkqlTGUTUlNKaJe/+G
         r/vjWrPUT8mojFYurm/pxYEJdCfQtEzwwDB0xqirQOl0/9MmhGY4XM8NLbBQOJ4HtpZk
         Zd4B0vTyypVwrWXxE5AW7qITHlRp351nS+IXVZiiWzM8Nn2mYqzUanj+VLJXGoX5R45x
         LBTxa3JoyXJRUVyN8OVcNUKvnp16bYS0JBGehM62wgHoOZHv6JaFUEz1KqOHo/1NlmNe
         5YcbQ1ivVxYS3roMkwcLkYo0uJ4jMtZDXZm1QORCAJE+VYEfDP9Y7B8v/SvSP72OYeTp
         5zgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ZgnHyTFQ+qW0pv/HKrVWBqMS9x7zALwG/Yk+DsQJW5U=;
        b=X47WpxfuIhUw5mqyPg9vCPxvIR0u62xOGpB6eG+35CEOcXvKCMR8l5CvekI4rO6R7M
         DPrxQ7dPGKcckt5iOIWMHDZX1tzy9+o61v0x2k1Zd9QkYWPCN4J8F07mC7BDtO6ryT3j
         oqECK2K3u6GZtzh/nW4iJ9h/DjLi7+iC4EmqcDx0e6rjc+TJCBfSJGWFbtzPFXyeONgE
         +pCKqsrh80h+2FzcOFogOynUX7pzPUewV19/1PQ6OxWH34yX0X3aU52jywWhOOHCC/NI
         A5E/sinX1Diue+368IKFxYJsG1JgF8vgRArz2DtF3k4euMqQE2djRpguVsIO40Qf0BIi
         RH4A==
X-Gm-Message-State: AOAM531mgS1Ireau2jHxiOPdZgPRrroV9GmwyQLcEV74trB0NsrvITsK
        zycF/7+un8DQQuY2lwtnSAM=
X-Google-Smtp-Source: ABdhPJysDsGxpmZ9mCoRZ5xgfAUISXGPSnL46PBNO03h5a8wjebQIfvodBRPQIFa6z1ZwsQtgEe46A==
X-Received: by 2002:a17:902:8605:b0:13f:7c1d:56d1 with SMTP id f5-20020a170902860500b0013f7c1d56d1mr67828557plo.57.1637249625577;
        Thu, 18 Nov 2021 07:33:45 -0800 (PST)
Received: from gmail.com ([122.178.80.201])
        by smtp.gmail.com with ESMTPSA id p188sm24682pfg.102.2021.11.18.07.33.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Nov 2021 07:33:45 -0800 (PST)
From:   Kumar Thangavel <kumarthangavel.hcl@gmail.com>
X-Google-Original-From: Kumar Thangavel <thangavel.k@hcl.com>
Date:   Thu, 18 Nov 2021 21:03:38 +0530
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     openbmc@lists.ozlabs.org, linux-aspeed@lists.ozlabs.org,
        netdev@vger.kernel.org, patrickw3@fb.com,
        Amithash Prasad <amithash@fb.com>, sdasari@fb.com,
        velumanit@hcl.com
Subject: [PATCH v7] Add payload to be 32-bit aligned to fix dropped packets
Message-ID: <20211118153338.GA18435@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update NC-SI command handler (both standard and OEM) to take into
account of payload paddings in allocating skb (in case of payload
size is not 32-bit aligned).

The checksum field follows payload field, without taking payload
padding into account can cause checksum being truncated, leading to
dropped packets.

Fixes: fb4ee67529ff ("net/ncsi: Add NCSI OEM command support")
Signed-off-by: Kumar Thangavel <thangavel.k@hcl.com>
Acked-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

---
  v7:
   - Updated padding_bytes as const static int variable

  v6:
   - Updated type of padding_bytes variable
   - Updated type of payload
   - Seperated variable declarations and code

  v5:
   - Added Fixes tag
   - Added const variable for padding_bytes

  v4:
   - Used existing macro for max function

  v3:
   - Added Macro for MAX
   - Fixed the missed semicolon

  v2:
   - Added NC-SI spec version and section
   - Removed blank line
   - corrected spellings

  v1:
   - Initial draft

---
---
 net/ncsi/ncsi-cmd.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index ba9ae482141b..9a6f10f4833e 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -18,6 +18,8 @@
 #include "internal.h"
 #include "ncsi-pkt.h"
 
+const static int padding_bytes = 26;
+
 u32 ncsi_calculate_checksum(unsigned char *data, int len)
 {
 	u32 checksum = 0;
@@ -213,12 +215,17 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,
 {
 	struct ncsi_cmd_oem_pkt *cmd;
 	unsigned int len;
+	int payload;
+	/* NC-SI spec DSP_0222_1.2.0, section 8.2.2.2
+	 * requires payload to be padded with 0 to
+	 * 32-bit boundary before the checksum field.
+	 * Ensure the padding bytes are accounted for in
+	 * skb allocation
+	 */
 
+	payload = ALIGN(nca->payload, 4);
 	len = sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-	if (nca->payload < 26)
-		len += 26;
-	else
-		len += nca->payload;
+	len += max(payload, padding_bytes);
 
 	cmd = skb_put_zero(skb, len);
 	memcpy(&cmd->mfr_id, nca->data, nca->payload);
@@ -272,6 +279,7 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
 	struct net_device *dev = nd->dev;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
+	int payload;
 	int len = hlen + tlen;
 	struct sk_buff *skb;
 	struct ncsi_request *nr;
@@ -281,14 +289,14 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
 		return NULL;
 
 	/* NCSI command packet has 16-bytes header, payload, 4 bytes checksum.
+	 * Payload needs padding so that the checksum field following payload is
+	 * aligned to 32-bit boundary.
 	 * The packet needs padding if its payload is less than 26 bytes to
 	 * meet 64 bytes minimal ethernet frame length.
 	 */
 	len += sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-	if (nca->payload < 26)
-		len += 26;
-	else
-		len += nca->payload;
+	payload = ALIGN(nca->payload, 4);
+	len += max(payload, padding_bytes);
 
 	/* Allocate skb */
 	skb = alloc_skb(len, GFP_ATOMIC);
-- 
2.17.1

