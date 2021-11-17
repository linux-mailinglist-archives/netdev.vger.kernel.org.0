Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A9645422D
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 08:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234016AbhKQH6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 02:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbhKQH6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 02:58:19 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C23C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 23:55:21 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso1847419pjo.3
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 23:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=sMn+kSB0SMtbbATrssAZXo2j9mtwfINp7shAhK0Hg3Q=;
        b=Dtqz9Zpll3J6Dmv7AZRqvZ1dam1bRud/Q/5TkSCwzoe2rImvngB+rdOX59L8zxUKue
         kBqSdWdc6ZV/ycLotIthDYezPOMReEBTfSTUtlPfHTyMN433WYBggGnPIUU6ao4dNA9u
         TyM9GFBvuaaO5/9bZ+N7E/XlgoZh8WY6yGJ7f1lmYpvgUPcIhhJTGhcY9l6slzZj52uA
         uWRx3tKebh6HnW8EM7U4oC/eO9UDefOlQuSZ6F4pmNZxFNBYnIP/B+bSHUbgDGT0M1eu
         xBnfQ5MvbzWzhJhsc1ZAiRhP/ZZa9yeP1f4ek39DV6AVUQQ02DBUqhI4FHSGAWmd1PeU
         JHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=sMn+kSB0SMtbbATrssAZXo2j9mtwfINp7shAhK0Hg3Q=;
        b=Cl6ySpUQgy51Ix5JfDE1T0sfaYlxy1EAKUix0HBXyTITH9gYBGBTSJRKEqXL52W+Dk
         lIhN1os4NouD2hpJYEMars85LGiyXmfKd3GjSmKf1Xlzl15DntBAtJfoqntpdWiettPw
         u8J1UmSfZO5smbwJbhBOYz6rGiZRhZBrjpVjcGuuRoVREb9nLX2my5rDpGP3MPqfFGh5
         zK2rB7Jqq0ngMWxuPEoeb8tDaub/QLvFbbylHp2KkLPXQcr8mrdrarClX0MOWGvDazfQ
         YXOgcyoUNH8Yz04Z4np9jeY6H8hnlXP/rdgXdiwTraz/OtSGkFA+s5zZA/VSD6Q38He2
         07cg==
X-Gm-Message-State: AOAM531+ARgmEf6QfJk2IUoEW0+8gv423ge1IG3L0fqbahStekpGrx4I
        Y0UvmahVziACYJ+EM7okqQE=
X-Google-Smtp-Source: ABdhPJyApPE4b+5l7e4PSnCiyjleMBXoErF+yJ9jBacOCYdXaAkKP6/njIkHGl/3u7f5L7TdRqWQQg==
X-Received: by 2002:a17:90b:3ec6:: with SMTP id rm6mr7136137pjb.41.1637135720945;
        Tue, 16 Nov 2021 23:55:20 -0800 (PST)
Received: from gmail.com ([117.217.177.105])
        by smtp.gmail.com with ESMTPSA id ls14sm4862214pjb.49.2021.11.16.23.55.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Nov 2021 23:55:20 -0800 (PST)
From:   Kumar Thangavel <kumarthangavel.hcl@gmail.com>
X-Google-Original-From: Kumar Thangavel <thangavel.k@hcl.com>
Date:   Wed, 17 Nov 2021 13:25:13 +0530
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     openbmc@lists.ozlabs.org, linux-aspeed@lists.ozlabs.org,
        netdev@vger.kernel.org, patrickw3@fb.com,
        Amithash Prasad <amithash@fb.com>, sdasari@fb.com,
        velumanit@hcl.com
Subject: [PATCH v6] Add payload to be 32-bit aligned to fix dropped packets
Message-ID: <20211117075513.GA12199@gmail.com>
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
  v6:
   - Updated type of padding_bytes variable
   - Updated type of payload variable
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
index ba9ae482141b..78376d88e788 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -18,6 +18,8 @@
 #include "internal.h"
 #include "ncsi-pkt.h"
 
+const int padding_bytes = 26;
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

