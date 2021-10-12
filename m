Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF55429D9D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 08:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhJLGYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 02:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbhJLGYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 02:24:49 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68974C061570;
        Mon, 11 Oct 2021 23:22:48 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id t15so3037195pfl.13;
        Mon, 11 Oct 2021 23:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=NEBAU1RWs6YJxzDRg0LMwfxlDVZpKjQ2JmxA/FMQn9I=;
        b=McQMZTzzabqyQoFoDz0StgCDkbRur8jQXp9EFJgKGSMZZmgfGdvhTm38pr4OvcR12i
         4PeD56h//3/bd+QLwPHJLYIBru6UZKbYVU4mXsBDbP8ANmFwUseGimunlsyKK9/GOZI3
         RJ8Gx0lPDlQ504jIHHfRNG+iYpAigd+LGm16vlqDl+jEU8SC/3M+oMOcwyNTjfRWVj+S
         WK//+a+XKGs0MvZvHk2Ia3LjWG2jO2KaoBAkgi4xGLYhad/e83YVZcJ3V4zTGDoivUrT
         Q5e2J7VDTjG9bJirjL3AUh02qdzOR4MfAfdQFwr1HcyWCIAJSrixLQiAQa2FiVkoESJR
         cMvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=NEBAU1RWs6YJxzDRg0LMwfxlDVZpKjQ2JmxA/FMQn9I=;
        b=IqHmtkdAmYql39VZg8DJXuaULEUx10agZNUWRAfiNsHcggcod16Vt/X2Y5g2BW+cRj
         3fLSr0pqnnyG3bkjSxNoLtHNA1HYvFRFXG7U9v6AmuhevDNTKo33y65DQkDU3RIXAfpZ
         gCkCdQdVJNSS++6fJ/ScN8MDRHizT3ohmSuE2+Z+OgGL9Z/FLPVaiFAgVfYv0YYBtXVF
         +fpM8vENYYCHWaZ7pyspnsGpR/6OjIkcpYHBbOtLO89vzKGL6s/brvGaXJfIga4N7VQX
         Wxn1Azi3/tRimc22Deh9Gu2Fx03nStG5SwcNh+fI17tUhojBKtgjl+gDT7u+Z4r6tx4a
         MefA==
X-Gm-Message-State: AOAM533vIHohKBChUmr75qFGAZx8ulWSRDMrJvxeGTmHhP6LP03Ag2/2
        itSVuF//raKEDhV0Tfshq5Y=
X-Google-Smtp-Source: ABdhPJxATpW9oPrVRGySI6PVTwCs5AllHaaU5QwxgAoohRoVLEUprtd6ExSynuJ5fkMIyXgCVd1rzg==
X-Received: by 2002:a63:7447:: with SMTP id e7mr12512872pgn.261.1634019767950;
        Mon, 11 Oct 2021 23:22:47 -0700 (PDT)
Received: from gmail.com ([2401:4900:1733:f30f:252a:9e24:80ca:38da])
        by smtp.gmail.com with ESMTPSA id n207sm9769768pfd.143.2021.10.11.23.22.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Oct 2021 23:22:47 -0700 (PDT)
From:   Kumar Thangavel <kumarthangavel.hcl@gmail.com>
X-Google-Original-From: Kumar Thangavel <thangavel.k@hcl.com>
Date:   Tue, 12 Oct 2021 11:52:40 +0530
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-aspeed@lists.ozlabs.org,
        patrickw3@fb.com, Amithash Prasad <amithash@fb.com>,
        velumanit@hcl.com
Subject: [PATCH] net: ncsi: Adding padding bytes in the payload
Message-ID: <20211012062240.GA5761@gmail.com>
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

Signed-off-by: Kumar Thangavel <thangavel.k@hcl.com>

---
 net/ncsi/ncsi-cmd.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index ba9ae482141b..4625fc935603 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -214,11 +214,19 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,
 	struct ncsi_cmd_oem_pkt *cmd;
 	unsigned int len;
 
+	/* NC-SI spec requires payload to be padded with 0
+	 * to 32-bit boundary before the checksum field.
+	 * Ensure the padding bytes are accounted for in
+	 * skb allocation
+	 */
+
+	unsigned short payload = ALIGN(nca->payload, 4);
+
 	len = sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-	if (nca->payload < 26)
+	if (payload < 26)
 		len += 26;
 	else
-		len += nca->payload;
+		len += payload;
 
 	cmd = skb_put_zero(skb, len);
 	memcpy(&cmd->mfr_id, nca->data, nca->payload);
@@ -272,6 +280,7 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
 	struct net_device *dev = nd->dev;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
+	int payload;
 	int len = hlen + tlen;
 	struct sk_buff *skb;
 	struct ncsi_request *nr;
@@ -281,14 +290,18 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
 		return NULL;
 
 	/* NCSI command packet has 16-bytes header, payload, 4 bytes checksum.
+	 * Payload needs padding so that the checksum field follwoing payload is
+	 * aligned to 32bit boundary.
 	 * The packet needs padding if its payload is less than 26 bytes to
 	 * meet 64 bytes minimal ethernet frame length.
 	 */
 	len += sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-	if (nca->payload < 26)
+
+	payload = ALIGN(nca->payload, 4);
+	if (payload < 26)
 		len += 26;
 	else
-		len += nca->payload;
+		len += payload;
 
 	/* Allocate skb */
 	skb = alloc_skb(len, GFP_ATOMIC);
-- 
2.17.1

