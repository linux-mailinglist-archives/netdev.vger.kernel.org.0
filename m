Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FE2557D7A
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 16:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiFWOGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 10:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbiFWOGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 10:06:11 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C2C3E0C2
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 07:06:09 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id y77so1091620oia.3
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 07:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=s6ihUjXIvswZqZyVQh/q9ajdsJiEr3DaO1n1iq2+F38=;
        b=dMOUxUWK8QurX/53k4fGyQcdG+/JAGvrbPkLLqVEuJdCDsnBVWSgXs08BJAlM7oCil
         tHsl8Rwf70o7Hiu3qOGDwKcLA+UH3qyDxrPbBhyMA997IvZWMB1ui9bMezJlhj5U8Sjh
         f34Mf3P48ePT51siNWb5vN0IHammPz1xOwpWyrV+jP9r6rBImMMU7b7aAGk0R1Tj2UPC
         EkI8SFYQww2Y5Ge/9SoEb7TFmHww2CgfOx5Ru2dJdpqDQ5+HKgPezIVMD+PSDcCS5dpQ
         JOMqPQGELoTBK5eqGUYx9tXCffyzUcwERwJKyV/+yi/eKziIUBiNipetcyINBV6k0zn2
         vfGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=s6ihUjXIvswZqZyVQh/q9ajdsJiEr3DaO1n1iq2+F38=;
        b=KIHnd90QpPQGWompd3UmYh4xTRqmH3RTUXCWfVvYwwsgupxiIpP2l5X71jwHot8A9f
         AnfulCHtJa+PZr12ZceemZ1O8g947g8LMVIo4zAR/5WhUpUyRQYmLGWgQlIliJ3CyTDZ
         x/QwAgvGG2EiV58VStGKtzuOhyxEYVLUcnlzvEOSqdRwFyFoahDruU7K8t3F/aIGYh6J
         Wq1KZTeJwrmkMQBx15R4t0j62tR3J2pMqPKum5UzQuOkpAq0IaSVJgz385oggJ+Rpd8L
         EC7u0bkSbgDjpA4Th40Md/7uYXqoqFVkDRCmPzjKv09h55m5u2nkuQ78+EW/8KYx7lFR
         pVgg==
X-Gm-Message-State: AJIora9DLt+K/kMWAsUmiI6HOoaZk/gmKDjq0ZiDiQcgINwmB8AYNTim
        i3iZn0jdjxkGiPm92aUzji7OR6ffkQs=
X-Google-Smtp-Source: AGRyM1vMrmK16F/GKzHtX7AVt/6ksHaPrD61g1viy/xvty2+tZlCc7DmlXuBiCoaHtUQbfIm7L07oQ==
X-Received: by 2002:a05:6808:23c3:b0:335:22a0:433d with SMTP id bq3-20020a05680823c300b0033522a0433dmr2302801oib.25.1655993168446;
        Thu, 23 Jun 2022 07:06:08 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:96e6:64c:ef9b:3df0:9e8d? ([2804:14c:71:96e6:64c:ef9b:3df0:9e8d])
        by smtp.gmail.com with ESMTPSA id e17-20020a056808149100b00325cda1ff9esm12918154oiw.29.2022.06.23.07.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 07:06:07 -0700 (PDT)
Message-ID: <9a2a2790acfd45bef2cd786dc92407bcd6c14448.camel@gmail.com>
Subject: [PATCH] net: usb: ax88179_178a: corrects packet receiving
From:   Jose Alonso <joalonsof@gmail.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 23 Jun 2022 11:06:05 -0300
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

This patch corrects the packet receiving in ax88179_rx_fixup.

- problem observed:
  ifconfig shows always a lot of 'RX Errors' while packets
  are received normally.

  This occurs because ax88179_rx_fixup does not recognize properly
  the usb urb received.
  The packets are normally processed and at the end, the code exits
  with 'return 0', generating RX Errors.
  (with pkt_cnt=3D=3D-2 and ptk_hdr over the field rx_hdr trying to identif=
y
   another packet there)

  This is a usb urb received by "tcpdump -i usbmon2 -X":
  0x0000:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
           ^         packet 1 start (pkt_len =3D 0x05ec)
           ^^^^      IP alignment pseudo header
                ^    ethernet frame start
           last byte of packet        vv
           padding (8-bytes aligned)     vvvv vvvv
  0x05e0:  c92d d444 1420 8a69 83dd 272f e82b 9811
  0x05f0:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
  ...      ^ packet 2
  0x0be0:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
  ...
  0x1130:  9d41 9171 8a38 0ec5 eeee f8e3 3b19 87a0
  ...
  0x1720:  8cfc 15ff 5e4c e85c eeee f8e3 3b19 87a0
  ...
  0x1d10:  ecfa 2a3a 19ab c78c eeee f8e3 3b19 87a0
  ...
  0x2070:  eeee f8e3 3b19 87a0 94de 80e3 daac 0800
  ...      ^ packet 7
  0x2120:  7c88 4ca5 5c57 7dcc 0d34 7577 f778 7e0a
  0x2130:  f032 e093 7489 0740 3008 ec05 0000 0080
                               =3D=3D=3D=3D1=3D=3D=3D=3D =3D=3D=3D=3D2=3D=
=3D=3D=3D
           hdr_off             ^
           pkt_len =3D 0x05ec         ^^^^
           AX_RXHDR_*=3D0x00830  ^^^^   ^
           pkt_len =3D 0                        ^^^^
           AX_RXHDR_DROP_ERR=3D0x80000000  ^^^^   ^
  0x2140:  3008 ec05 0000 0080 3008 5805 0000 0080
  0x2150:  3008 ec05 0000 0080 3008 ec05 0000 0080
  0x2160:  3008 5803 0000 0080 3008 c800 0000 0080
           =3D=3D=3D11=3D=3D=3D=3D =3D=3D=3D12=3D=3D=3D=3D =3D=3D=3D13=3D=
=3D=3D=3D =3D=3D=3D14=3D=3D=3D=3D
  0x2170:  0000 0000 0e00 3821
                     ^^^^ ^^^^ rx_hdr
                     ^^^^      pkt_cnt=3D14
                          ^^^^ hdr_off=3D0x2138
           ^^^^ ^^^^           padding

  The dump shows that pkt_cnt is the number of entries in the
  per-packet metadata. It is "2 * packet count".
  Each packet have two entries. The first have a valid
  value (pkt_len and AX_RXHDR_*) and the second have a
  dummy-header 0x80000000 (pkt_len=3D0 with AX_RXHDR_DROP_ERR).
  Why exists dummy-header for each packet?!?
  My guess is that this was done probably to align the
  entry for each packet to 64-bits and maintain compatibility
  with old firmware.
  There is also a padding (0x00000000) before the rx_hdr to
  align the end of rx_hdr to 64-bit.
  Note that packets have a alignment of 64-bits (8-bytes).

  This patch assumes that the dummy-header and the last
  padding are optional. So it preserves semantics and
  recognizes the same valid packets as the current code.
=20
  This patch was made using only the dump file information and
  tested with only one device:
  0b95:1790 ASIX Electronics Corp. AX88179 Gigabit Ethernet

Signed-off-by: Jose Alonso <joalonsof@gmail.com>

---

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.=
c
index 4704ed6f00ef..02bd113c5045 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1472,6 +1472,42 @@ static int ax88179_rx_fixup(struct usbnet *dev, stru=
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
+	 *   <packet N> contains pkt_len bytes:
+	 *		2 bytes of IP alignment pseudo header
+	 *		packet received
+	 *   <per-packet metadata entry N> contains 4 bytes:
+	 *		pkt_len and fields AX_RXHDR_*
+	 *   <padding>	0-7 bytes to terminate at
+	 *		8 bytes boundary (64-bit).
+	 *   <padding2> 4 bytes to make rx_hdr terminate at
+	 *		8 bytes boundary (64-bit)
+	 *   <dummy-header> contains 4 bytes:
+	 *		pkt_len=3D0 and AX_RXHDR_DROP_ERR
+	 *   <rx-hdr>	contains 4 bytes:
+	 *		pkt_cnt and hdr_off (offset of
+	 *		  <per-packet metadata entry 1>)
+	 *
+	 * pkt_cnt is number of entries in the per-packet metadata.
+	 * In current firmware there is 2 entries per packet.
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
@@ -1485,51 +1521,66 @@ static int ax88179_rx_fixup(struct usbnet *dev, str=
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
+		u16 pkt_len_plus_padd;
=20
 		le32_to_cpus(pkt_hdr);
 		pkt_len =3D (*pkt_hdr >> 16) & 0x1fff;
+		pkt_len_plus_padd =3D (pkt_len + 7) & 0xfff8;
=20
-		if (pkt_len > skb->len)
+		/* Skip dummy header used for alignment
+		 */
+		if (pkt_len =3D=3D 0)
+			continue;
+
+		if (pkt_len_plus_padd > skb->len)
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
+			skb_pull(skb, pkt_len_plus_padd);
+			continue;
+		}
=20
-			if (last)
-				return 1;
+		/* last packet */
+		if (pkt_len_plus_padd =3D=3D skb->len) {
+			skb_trim(skb, pkt_len);
=20
-			usbnet_skb_return(dev, ax_skb);
+			/* Skip IP alignment pseudo header */
+			skb_pull(skb, 2);
+
+			skb->truesize =3D SKB_TRUESIZE(pkt_len_plus_padd);
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
+		skb->truesize =3D pkt_len_plus_padd +
+				SKB_DATA_ALIGN(sizeof(struct sk_buff));
+		ax88179_rx_checksum(ax_skb, pkt_hdr);
+		usbnet_skb_return(dev, ax_skb);
+
+		skb_pull(skb, pkt_len_plus_padd);
 	}
+
+	return 0;
 }
=20
 static struct sk_buff *

--

