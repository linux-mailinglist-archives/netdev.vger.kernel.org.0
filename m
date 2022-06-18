Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A90550690
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 21:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbiFRTLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 15:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFRTLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 15:11:40 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464E1BF76
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 12:11:39 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-1013ecaf7e0so9332647fac.13
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 12:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=NoVat6/WLGnX53i/lHWfBT5VyI0YGbSiELYmR/8V4BU=;
        b=QI5tjhR8fiQh1lT8EhM93F0+8deTHKuzTaRGT6BlY2qqv00sd1+erfQoY1xi18oelQ
         E+NyUmXeEA1bAlR2rQrn2tqz9LYTEiKoWgT2BbL2d6MtFWz+aid0Xf0Pa/6MAiSzLU+n
         /9+3dBgQwfzXxVwj1GXrbagwoh41Q7HytLp7ikGfCsUTSGBHDm4ijcAaH9VaNC94M/Vn
         w7zqzLbMMJUBg8e8qDtKtViiEhOZYv5KgiUDVZ4kAbSAXM4X3D4djbI+L/Hs6FdOgJCf
         bCSPrgZe5e9TiZzGX3/ES9GaxVGgTqkfe5UMGUOs/Tm09MhaXwdwN9HzZpqF/hQKBhon
         cjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=NoVat6/WLGnX53i/lHWfBT5VyI0YGbSiELYmR/8V4BU=;
        b=x7AAIxBA8IC6hQJ35WXhD9r+O4P+d5vbsUIAYhFySSz+W3GZityM5TXM+vmZ2ugrU6
         eOZARHySIkF/mPLhNDTqNYoaiTXRTfNxbWvy60W5s9XXwbZSvX4/FCBCARSG+AO6ePB/
         1bJCC7nzHCzxPvSixOh+w/U+nfwpE8xSV7qIHkuJaNAcSUMfKfCL3bzMyp4LQgv6lPMy
         vWYu3xV/rWG5UmhR7w7JnIQpvuI2H4PEFKX+hIdQ8HWN+lqYczV9cUrxn4G7c/zbFcwr
         e4US36z8gaSPEzldbwr2mhF/cOhnePy6+s4QSfjBibUO/La9qDpbz4dF47DyAYOySPyt
         kZkQ==
X-Gm-Message-State: AJIora8dESBJ2iW6zG33/jXbbqg6Sc8lxy4xYWraitPfR4opxbo46HSE
        JxqbR2ACcoeBBWx5YzwGMY8XtTzvTG9ovg==
X-Google-Smtp-Source: AGRyM1uE0QxPHsj5BZ697uaIsy73q1qNF1Cn9pVxxkkaxXTTDKnA+CVF80U6sjCK2D7S+BFz35e21A==
X-Received: by 2002:a05:6870:b381:b0:fe:2004:b3b5 with SMTP id w1-20020a056870b38100b000fe2004b3b5mr8659661oap.63.1655579498416;
        Sat, 18 Jun 2022 12:11:38 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:8e3a:bbb4:4cf8:bf04:4125? ([2804:14c:71:8e3a:bbb4:4cf8:bf04:4125])
        by smtp.gmail.com with ESMTPSA id m12-20020a0568080f0c00b00325643bce40sm4719161oiw.0.2022.06.18.12.11.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 12:11:38 -0700 (PDT)
Message-ID: <8069714f3301862dc8ed64a0cc0ab8c9f29b5f99.camel@gmail.com>
Subject: [PATCH] net: usb: ax88179_178a: ax88179_rx_fixup corrections
From:   Jose Alonso <joalonsof@gmail.com>
To:     netdev@vger.kernel.org
Date:   Sat, 18 Jun 2022 16:11:36 -0300
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects the receiving of packets in ax88179_rx_fixup.

corrections:
- the size check of the bounds of the metadata array.
- remove erroneous call to le32_to_cpus(pkt_hdr).
- correct the treatment of the metadata array.
   The current code is allways exiting with return 0
   while trying to access pkt_hdr out of metadata array and
   generating RX Errors.

Tested with: 0b95:1790 ASIX Electronics Corp. AX88179 Gigabit Ethernet

Signed-off-by: Jose Alonso <joalonsof@gmail.com>

---

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.=
c
index 4704ed6f00ef..1a70b7b2a3f2 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1472,6 +1472,41 @@ static int ax88179_rx_fixup(struct usbnet *dev, stru=
ct sk_buff *skb)
 	 * are bundled into this buffer and where we can find an array of
 	 * per-packet metadata (which contains elements encoded into u16).
 	 */
+
+	/* SKB contents for current firmware:
+	 *   <packet 1> <padding>
+	 *   ...
+	 *   <packet N> <padding>
+	 *   <per-packet metadata entry 1> <dummy header>
+	 *   ...
+	 *   <per-packet metadata entry N> <dummy header>
+	 *   <padding2> <rx_hdr>
+	 *
+	 * where:
+	 *   <packet N> contains:
+	 *		2 bytes of IP alignment pseudo header
+	 *		packet received
+	 *   <per-packet metadata entry N> contains 4 bytes:
+	 *		size of packet and fields AX_RXHDR_*
+	 *   <padding>	0-7 bytes to terminate at
+	 *		8 bytes boundary (64-bit).
+	 *   <padding2> 4 bytes
+	 *   <dummy-header> contains 4 bytes:
+	 *		size=3D0 & AX_RXHDR_DROP_ERR
+	 *   <rx-hdr>	contains 4 bytes:
+	 *		pkt_cnt and hdr_off (offset of=20
+	 *		  <per-packet metadata entry 1>)
+	 *
+	 * pkt_cnt is number of entrys in the per-packet metadata.
+	 * In current firmware there is 2 entrys per packet.
+	 * The first points to the packet and the
+	 *  second is a dummy header.
+	 * This was done probably to align fields in 64-bit and
+	 *  maintain compatibility with old firmware.
+	 * This code assumes that <dummy header> and <padding2> are
+	 *  optional.
+	 */
+
 	if (skb->len < 4)
 		return 0;
 	skb_trim(skb, skb->len - 4);
@@ -1485,51 +1520,62 @@ static int ax88179_rx_fixup(struct usbnet *dev, str=
uct sk_buff *skb)
 	/* Make sure that the bounds of the metadata array are inside the SKB
 	 * (and in front of the counter at the end).
 	 */
-	if (pkt_cnt * 2 + hdr_off > skb->len)
+	if (pkt_cnt * 4 + hdr_off > skb->len)
 		return 0;
 	pkt_hdr =3D (u32 *)(skb->data + hdr_off);
=20
 	/* Packets must not overlap the metadata array */
 	skb_trim(skb, hdr_off);
=20
-	for (; ; pkt_cnt--, pkt_hdr++) {
+	for (; pkt_cnt > 0; pkt_cnt--, pkt_hdr++) {
 		u16 pkt_len;
+		u16 pkt_len_buf;
=20
-		le32_to_cpus(pkt_hdr);
 		pkt_len =3D (*pkt_hdr >> 16) & 0x1fff;
+		pkt_len_buf =3D (pkt_len + 7) & 0xfff8;
=20
-		if (pkt_len > skb->len)
+		/* Skip dummy header used for alignment
+		 */
+		if (pkt_len =3D=3D 0)
+			continue;
+
+		if (pkt_len_buf > skb->len)
 			return 0;
=20
 		/* Check CRC or runt packet */
-		if (((*pkt_hdr & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) =3D=3D 0) &&
-		    pkt_len >=3D 2 + ETH_HLEN) {
-			bool last =3D (pkt_cnt =3D=3D 0);
-
-			if (last) {
-				ax_skb =3D skb;
-			} else {
-				ax_skb =3D skb_clone(skb, GFP_ATOMIC);
-				if (!ax_skb)
-					return 0;
-			}
-			ax_skb->len =3D pkt_len;
-			/* Skip IP alignment pseudo header */
-			skb_pull(ax_skb, 2);
-			skb_set_tail_pointer(ax_skb, ax_skb->len);
-			ax_skb->truesize =3D pkt_len + sizeof(struct sk_buff);
-			ax88179_rx_checksum(ax_skb, pkt_hdr);
+		if ((*pkt_hdr & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) ||
+		    pkt_len < 2 + ETH_HLEN) {
+			dev->net->stats.rx_errors++;
+			skb_pull(skb, pkt_len_buf);
+			continue;
+		}
=20
-			if (last)
-				return 1;
+		/* last packet */
+		if (pkt_len_buf =3D=3D skb->len) {
+			skb_trim(skb, pkt_len);
=20
-			usbnet_skb_return(dev, ax_skb);
+			/* Skip IP alignment pseudo header */
+			skb_pull(skb, 2);
+
+			ax88179_rx_checksum(skb, pkt_hdr);
+			return 1;
 		}
=20
-		/* Trim this packet away from the SKB */
-		if (!skb_pull(skb, (pkt_len + 7) & 0xFFF8))
+		ax_skb =3D skb_clone(skb, GFP_ATOMIC);
+		if (!ax_skb)
 			return 0;
+		skb_trim(ax_skb, pkt_len);
+
+		/* Skip IP alignment pseudo header */
+		skb_pull(ax_skb, 2);
+
+		ax88179_rx_checksum(ax_skb, pkt_hdr);
+		usbnet_skb_return(dev, ax_skb);
+
+		skb_pull(skb, pkt_len_buf);
 	}
+
+	return 0;
 }
=20
 static struct sk_buff *

--

