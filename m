Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7115845077E
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhKOOwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhKOOv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 09:51:58 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B0AC061767
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 06:48:54 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id g28so14758284pgg.3
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 06:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=W+Hq2phrYgE/sih4cUE4IW0apjvnE17VNBKBZTkliAc=;
        b=k2JqhB/cmW+d3Ry+KWcgnMTDrMNX5/zJ/O8RFNBk24euCCxxA4Tyexx7yMkT0LYfHy
         v7aPrPIDGxUi3hekkp8e0nCUzv/7AcNh9rJSQyA/rJGuj3FlBLF/gMvq+/k+V0/ylUur
         6BgRGIhYkBnKB+Ut4H3SqJWBV20OStlfOWegCGtQ0KsJIWIUziV3fYmVhjAWNwORZwM+
         rHXXfq6cAleFuij0gqs7KBFrFhMoJtDQ9I6jGlzfp0ojuiKQv97/1wzL2ZEBP6TftSwi
         Za00oJ+x4AHk3uq4PBEM9A9mqTarPyC5sTJlxAGXGlxaRvWZjUV3dRzHSe855I8lJwfQ
         nqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=W+Hq2phrYgE/sih4cUE4IW0apjvnE17VNBKBZTkliAc=;
        b=rZH1OkY5SUK6psoXVmOCcUVx++QvQhvDfzIB/wsC+CXG2TskHa4vsPIcKSOnUZWsco
         wGnkJHad8UAZMGtArm33yYZ5sgYidDw0JtjSzU9Dx1lHwaLnZ96536edssXDPngLdOw+
         vNUnHAkufk/9KDok6zF9yH76wiLtrTJjA/mjuT70xooC+pTXI1iyBkFWOrr8Gf7xGxjR
         c4mhCZkrP9dGNsXUm5Bh8ANXIuoxX8tSFDIRyBlUTKNtpMF2D0MYj27UESKKTjTz8xSM
         VnnN/yPdGuNe2HxQutF49FuNXS9HYhXs4TH+VluKFD0QLrUQOvuC65rUTNNgScufrumG
         fhqg==
X-Gm-Message-State: AOAM532L0+8JsARRYKA/lv50bYuXh6TS8Juz2r5iNY6DsvYwCCZYT7sx
        u8rqMJiPy6Ybogelro9S8vGlE6n4jROmig==
X-Google-Smtp-Source: ABdhPJzOmAqRow3mtUBFk7RQe23RjcZmiy9nAKSWNVOi2QDuDIQhChAJ0+z48WxCQvZF62es8IT/Ig==
X-Received: by 2002:a63:a01a:: with SMTP id r26mr24346553pge.88.1636987734391;
        Mon, 15 Nov 2021 06:48:54 -0800 (PST)
Received: from gmail.com ([117.202.1.72])
        by smtp.gmail.com with ESMTPSA id lw1sm20003043pjb.38.2021.11.15.06.48.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Nov 2021 06:48:53 -0800 (PST)
From:   Kumar Thangavel <kumarthangavel.hcl@gmail.com>
X-Google-Original-From: Kumar Thangavel <thangavel.k@hcl.com>
Date:   Mon, 15 Nov 2021 20:18:46 +0530
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     openbmc@lists.ozlabs.org, linux-aspeed@lists.ozlabs.org,
        netdev@vger.kernel.org, patrickw3@fb.com,
        Amithash Prasad <amithash@fb.com>, sdasari@fb.com,
        velumanit@hcl.com
Subject: [PATCH v5] Add payload to be 32-bit aligned to fix dropped packets
Message-ID: <20211115144846.GA12078@gmail.com>
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
 net/ncsi/ncsi-cmd.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index ba9ae482141b..9571bb4dd991 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -18,6 +18,8 @@
 #include "internal.h"
 #include "ncsi-pkt.h"
 
+const unsigned short padding_bytes = 26;
+
 u32 ncsi_calculate_checksum(unsigned char *data, int len)
 {
 	u32 checksum = 0;
@@ -213,12 +215,16 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,
 {
 	struct ncsi_cmd_oem_pkt *cmd;
 	unsigned int len;
+	/* NC-SI spec DSP_0222_1.2.0, section 8.2.2.2
+	 * requires payload to be padded with 0 to
+	 * 32-bit boundary before the checksum field.
+	 * Ensure the padding bytes are accounted for in
+	 * skb allocation
+	 */
 
+	unsigned short payload = ALIGN(nca->payload, 4);
 	len = sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-	if (nca->payload < 26)
-		len += 26;
-	else
-		len += nca->payload;
+	len += max(payload, padding_bytes);
 
 	cmd = skb_put_zero(skb, len);
 	memcpy(&cmd->mfr_id, nca->data, nca->payload);
@@ -272,6 +278,7 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
 	struct net_device *dev = nd->dev;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
+	int payload;
 	int len = hlen + tlen;
 	struct sk_buff *skb;
 	struct ncsi_request *nr;
@@ -281,14 +288,14 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
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

