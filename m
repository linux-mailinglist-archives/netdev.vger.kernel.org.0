Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2775507CE
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 03:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbiFSAxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 20:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiFSAxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 20:53:40 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C56636F
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 17:53:39 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id l9-20020a056830268900b006054381dd35so5878757otu.4
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 17:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=suxTS94VnwbDcsarZCHL9PTGbGt/5pXp+2DuA0YDEDg=;
        b=W5ZGDFTGJg9l4foaafFEU9A+77aMBYQfE0vQe+FhXFiV/ZpHuy+oiCscn2kG5KBYto
         nL5KKpEXgdS/CHnuR8QDWptIw6PRbCpwKjHJz8DdYlfoaz8VXqDUzAyDilCcSLdVP6J9
         W7TbglcIjP7Zf66TNv14cywCFHTKCsbd6QpPpC7rKPmbUcclHQ5kfXjbyk3L+5xEdgts
         31XtVqdrUH/9bTEx7iP7tGzI4KQJUMeikZ8CypbJVlMSDaIi8qcFNbxbrshNzqKQu58P
         8ATMYZz62j1J09dv+SkpcrURej1hgYSZus539poj3J4YjcK8RDi9jrvuMNL4QJxhGgR2
         2duw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=suxTS94VnwbDcsarZCHL9PTGbGt/5pXp+2DuA0YDEDg=;
        b=0RjHWUgc1r0Zi6RrtixCDhmd0gBWavBZxETczb+TM6UPPnQRA7/Gi4XYPL+nICBZpX
         2P7geiQ59oAoO9vI215VyFz5PsfSExciaVGs+oCGLeATS5Kk92M0/akOWPGoFpzZJY2K
         JTNKyD46L5zmkT5MwcbYPswD/9lYHWfDSBBm2LN5KnTstMj2siDxLYMA/9qcj82U+UOG
         3R6nm74PhffFmZ2SeTQPxKaE3t6ptnIU9WUOjB2LNqc6qMFbHkvU2NJc3K2H1SJzFB0t
         b5T1hhERcSu60IHN7/f6eSPiBf62wHimxnlcBUWbytEQ9tXDUkkJV3OfxZb5smX1p62c
         rCgA==
X-Gm-Message-State: AJIora8r4IeTAl+TugtRD6ewY6ZbnsPgcnX9pC9UdufZi0smgFbtdRAz
        B/T1YLMmqMKNWbb8MRtj4AzZxIE3JHfVFg==
X-Google-Smtp-Source: AGRyM1uNOy883yrzI7edKQQhOgy7SQtnE55KVAOJ4rpGP8vi3S4IYKSYa0WdKmI08QAg1iOOGSesdw==
X-Received: by 2002:a05:6830:1312:b0:60b:f56b:b8de with SMTP id p18-20020a056830131200b0060bf56bb8demr7077960otq.80.1655600018334;
        Sat, 18 Jun 2022 17:53:38 -0700 (PDT)
Received: from ?IPv6:2804:14c:71:8e3a:bbb4:4cf8:bf04:4125? ([2804:14c:71:8e3a:bbb4:4cf8:bf04:4125])
        by smtp.gmail.com with ESMTPSA id m186-20020aca3fc3000000b00328c9e63389sm4951210oia.11.2022.06.18.17.53.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 17:53:37 -0700 (PDT)
Message-ID: <24289408a3d663fa2efedf646b046eb8250772f1.camel@gmail.com>
Subject: [PATCH v2] net: usb: ax88179_178a: ax88179_rx_fixup corrections
From:   Jose Alonso <joalonsof@gmail.com>
To:     netdev@vger.kernel.org
Date:   Sat, 18 Jun 2022 21:53:36 -0300
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
- the handling of the metadata array.
   The current code is allways exiting with return 0
   while trying to access pkt_hdr out of metadata array and
   generating RX Errors.
- avoid changing the skb->data content (reverse bytes) in case
   of big-endian. le32_to_cpus(pkt_hdr)=20

Tested with: 0b95:1790 ASIX Electronics Corp. AX88179 Gigabit Ethernet

Signed-off-by: Jose Alonso <joalonsof@gmail.com>

---

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.=
c
index 4704ed6f00ef..d2f868dd3c10 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1445,18 +1445,18 @@ static void ax88179_unbind(struct usbnet *dev, stru=
ct usb_interface *intf)
 }
=20
 static void
-ax88179_rx_checksum(struct sk_buff *skb, u32 *pkt_hdr)
+ax88179_rx_checksum(struct sk_buff *skb, u32 pkt_hdr_val)
 {
 	skb->ip_summed =3D CHECKSUM_NONE;
=20
 	/* checksum error bit is set */
-	if ((*pkt_hdr & AX_RXHDR_L3CSUM_ERR) ||
-	    (*pkt_hdr & AX_RXHDR_L4CSUM_ERR))
+	if ((pkt_hdr_val & AX_RXHDR_L3CSUM_ERR) ||
+	    (pkt_hdr_val & AX_RXHDR_L4CSUM_ERR))
 		return;
=20
 	/* It must be a TCP or UDP packet with a valid checksum */
-	if (((*pkt_hdr & AX_RXHDR_L4_TYPE_MASK) =3D=3D AX_RXHDR_L4_TYPE_TCP) ||
-	    ((*pkt_hdr & AX_RXHDR_L4_TYPE_MASK) =3D=3D AX_RXHDR_L4_TYPE_UDP))
+	if (((pkt_hdr_val & AX_RXHDR_L4_TYPE_MASK) =3D=3D AX_RXHDR_L4_TYPE_TCP) |=
|
+	    ((pkt_hdr_val & AX_RXHDR_L4_TYPE_MASK) =3D=3D AX_RXHDR_L4_TYPE_UDP))
 		skb->ip_summed =3D CHECKSUM_UNNECESSARY;
 }
=20
@@ -1467,11 +1467,47 @@ static int ax88179_rx_fixup(struct usbnet *dev, str=
uct sk_buff *skb)
 	u32 rx_hdr;
 	u16 hdr_off;
 	u32 *pkt_hdr;
+	u32 pkt_hdr_val;
=20
 	/* At the end of the SKB, there's a header telling us how many packets
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
+	 *   <padding2> 4 bytes
+	 *   <dummy-header> contains 4 bytes:
+	 *		pkt_len=3D0 & AX_RXHDR_DROP_ERR
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
@@ -1485,51 +1521,63 @@ static int ax88179_rx_fixup(struct usbnet *dev, str=
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
-		pkt_len =3D (*pkt_hdr >> 16) & 0x1fff;
+		pkt_hdr_val =3D get_unaligned_le32(pkt_hdr);
+		pkt_len =3D (pkt_hdr_val >> 16) & 0x1fff;
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
+		if ((pkt_hdr_val & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) ||
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
+			ax88179_rx_checksum(skb, pkt_hdr_val);
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
+		ax88179_rx_checksum(ax_skb, pkt_hdr_val);
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
