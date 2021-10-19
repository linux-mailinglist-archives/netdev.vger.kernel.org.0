Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC0B43388D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhJSOns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhJSOnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 10:43:47 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCDEC06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 07:41:35 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id t11so13801477plq.11
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 07:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=DrUUPCizKwC3ksHUSZfDSrYdCien60d8cF3/MHkkAR0=;
        b=D3mEBmuU2Jfs0CVLC4Ty1Y0EGDWYqIwfVWosSjUmWCdJygIoa8WY83TMLm8WTxtQZJ
         7bjkg6KAhunuH2TQ+FcFWCM4wpL3RqAytnDGWxt0QijP8YHDvxs7j9LxARn3d4hnV6iP
         KPCajNapGZz0IJaGH03hUeDRL0IdZuabBYjYKHg2uPG68ehmmNCVg1y7DLk7rT4HeIF6
         Tp0EaaBRRX7HkiJFDME+pfMXeqziOE3ttSXaa6U9/iEU/r5bmld76B8An3jZOXnadUbI
         SuILJz41GhzhN3zbjN0USfISZyGuZ0sOfMMauOWrZXGMHLcRTjAKf1+VEGKpUrsVmYZb
         Yhmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=DrUUPCizKwC3ksHUSZfDSrYdCien60d8cF3/MHkkAR0=;
        b=OSiN6Sh2UQjOMbxsuFWt//L+OEJD60dp0txWCh27LypqbFmQJORgE/QoG8TgB+MW8g
         QtEwOpgqA+g8CCAyDj6OUqAhfdEfeBIrTkY6cSroy88n3rtdTNTX4sZOOI8mz1MsseAz
         WZa0HEUtRjmK5bp1Xy8Kt6g2DFaB7LQ3DoV0kyA8fUalKrCa4OCb/PZkKUgjp6Zu5dR7
         1XLJZy7/1zV4JDnGM3b+FmSI5R7FBl0i4PJhE+dEU9VvS8flWYkPdj3OYtsDQETP9XpV
         HwJqPTvXDZuNcIDeleKQHKJJC7NUUle6tfcBh+kpGw3wKNxTOJrsDBfuQ9wnhUOOKmkF
         Ke+g==
X-Gm-Message-State: AOAM531Ehrh9uHkD8LOR5GdRDON9Sl+T0VEjWrBeSVDhvrBq6dLWS5yt
        e5UqIHRCrS2bKBDWHpn4eLo=
X-Google-Smtp-Source: ABdhPJytA/SP7vE15F+aX1mnXYy3M4wlUUWJxDance6nXshNDMRAD1AJE+MRazc7aj3dqMIS248ibQ==
X-Received: by 2002:a17:90a:8a0b:: with SMTP id w11mr168690pjn.177.1634654494536;
        Tue, 19 Oct 2021 07:41:34 -0700 (PDT)
Received: from gmail.com ([122.178.163.228])
        by smtp.gmail.com with ESMTPSA id t38sm13051952pfg.102.2021.10.19.07.41.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Oct 2021 07:41:34 -0700 (PDT)
From:   Kumar Thangavel <kumarthangavel.hcl@gmail.com>
X-Google-Original-From: Kumar Thangavel <thangavel.k@hcl.com>
Date:   Tue, 19 Oct 2021 20:11:27 +0530
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, openbmc@lists.ozlabs.org,
        linux-aspeed@lists.ozlabs.org, patrickw3@fb.com,
        Amithash Prasad <amithash@fb.com>, velumanit@hcl.com,
        sdasari@fb.com
Subject: [PATCH v2] Add payload to be 32-bit aligned to fix dropped packets
Message-ID: <20211019144127.GA12978@gmail.com>
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
Acked-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

---
  v2:
   - Added NC-SI spec version and section
   - Removed blank line
   - corrected spellings

  v1:
   - Initial draft.

---
 net/ncsi/ncsi-cmd.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index ba9ae482141b..29a75b79a811 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -213,12 +213,19 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,
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
+	if (payload < 26)
 		len += 26;
 	else
-		len += nca->payload;
+		len += payload;
 
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
@@ -281,14 +289,17 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
 		return NULL;
 
 	/* NCSI command packet has 16-bytes header, payload, 4 bytes checksum.
+	 * Payload needs padding so that the checksum field following payload is
+	 * aligned to 32-bit boundary.
 	 * The packet needs padding if its payload is less than 26 bytes to
 	 * meet 64 bytes minimal ethernet frame length.
 	 */
 	len += sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-	if (nca->payload < 26)
+	payload = ALIGN(nca->payload, 4)
+	if (payload < 26)
 		len += 26;
 	else
-		len += nca->payload;
+		len += payload;
 
 	/* Allocate skb */
 	skb = alloc_skb(len, GFP_ATOMIC);
-- 
2.17.1

