Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514E745600D
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhKRQGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbhKRQGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 11:06:13 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B9DC061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 08:03:13 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y7so5691147plp.0
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 08:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ZgnHyTFQ+qW0pv/HKrVWBqMS9x7zALwG/Yk+DsQJW5U=;
        b=g0b/96APpudjV6Sa+H3SWzKNyTjnJdPYk2TegdkuwJMisJjlGdK+t3ZB6Lk+M2W6c2
         fs4/lxYbQwT52+E0gMvTfj/rQmpiZBSIJWdMaru0qXfCVYGCQqrwo4f4byD/AB4wDkiw
         DNbTzFefiy+zrhLeBYKqjL2Lk3s2eNl7H1qc8mp0rpltpbRNfDCBaKs7JAoFLkmnjXhn
         we0a9S8c5j5iguYJuCvlL9UTqK1SfOQWRzkUthZD47is1SlJD3DMEtdF59AvjECfKOvR
         oxRU2Fu1H5Z7/0rXb+fRS122Zmiajs/4iGY3kRwx4BQorThnZaX0zGoQ8ku7G88LH7Uk
         QtEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ZgnHyTFQ+qW0pv/HKrVWBqMS9x7zALwG/Yk+DsQJW5U=;
        b=UFEVqDqqhIDYpHerpor3NdgUzz+l6nXpj6QoxQwOM6M+/9UVmH+8bRMEpJR2QDkq6u
         RF/iwwBqAo5reHMwJNHW3Ca27pjLtG9T38f4c9zMDny3uL6R6w4ACzDTxhcPYulujE45
         KX2Xf9NlzoJ5GoIatBYvnFBXTqnn6RmGsXJGqx34rPOMlJze1nngq/kY29TJYjLyJ1Ez
         J6IIoac/Ifx/utCcHt5Sh04/ZJydaaZlPV0FufNd0aFW3SV/gWIBNxI4Ry+qVStVZBnp
         L40XRvvj0alXZGVUmGaEJOtK+IFslOpBvW2BUiE4ZFI7kXHaQjyeVkgevQRfcKGblmbh
         5DSw==
X-Gm-Message-State: AOAM533yy4Ha5P8LN4SULmnbfYnL7cjrb7d2Wgf/82Jx+RvjjDEfCSDF
        pO71szls65T/GJJKUXua1PM=
X-Google-Smtp-Source: ABdhPJwdZgVgtZff0tup4etEV1ghUze5s8BeszB3FZsiMSLSTcwoAcXqMiR/l/e2vewNLb9hpcztTg==
X-Received: by 2002:a17:90a:fd96:: with SMTP id cx22mr11838791pjb.151.1637251391351;
        Thu, 18 Nov 2021 08:03:11 -0800 (PST)
Received: from gmail.com ([122.178.80.201])
        by smtp.gmail.com with ESMTPSA id u13sm115515pgp.27.2021.11.18.08.03.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Nov 2021 08:03:10 -0800 (PST)
From:   Kumar Thangavel <kumarthangavel.hcl@gmail.com>
X-Google-Original-From: Kumar Thangavel <thangavel.k@hcl.com>
Date:   Thu, 18 Nov 2021 21:33:02 +0530
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     openbmc@lists.ozlabs.org, linux-aspeed@lists.ozlabs.org,
        netdev@vger.kernel.org, patrickw3@fb.com,
        Amithash Prasad <amithash@fb.com>, sdasari@fb.com,
        velumanit@hcl.com
Subject: [PATCH v7] Add payload to be 32-bit aligned to fix dropped packets
Message-ID: <20211118160301.GA19542@gmail.com>
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

