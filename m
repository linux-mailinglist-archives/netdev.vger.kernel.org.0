Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FAC6885BB
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjBBRxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjBBRxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:53:35 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E0E68115;
        Thu,  2 Feb 2023 09:53:33 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 1FF6D5C009B;
        Thu,  2 Feb 2023 12:53:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 02 Feb 2023 12:53:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pjd.dev; h=cc:cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1675360413; x=1675446813; bh=AD
        A0MfB2Bn8m0MF+9M36B7RFkDED4j6UmA2ZzwFFajY=; b=tE6IRNo7k0Ex54roZ7
        qUiLhRfRqSizJoQETkz232SF/yy7r2PaMRGRPdASo9F3PHkzqmz/FpmfdSsK0dag
        WtO0X5yTsTJlnUSlHZpXuZbGoaVPw56F655GSMmXKSOSwN79Isw2W+khu/teVBrR
        NS2R2Ypcgql1ZXBJ0rNTXBOcpckXuPwt7BWphk+aIczsw9l5UtmJ0dNksgnZtlJm
        2SZLM2TDyRJluC2OWbQ+t2zznWHdy1Vtz8q3SgCB7a+IM+0H5NZgofa2HPZw8h4c
        TXr9XZko5XNyhKreaUhjJPBfEUwG2sWF2PhdIjNiPRkxcRdCvC+lFF8hSmBlnwq1
        2dMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1675360413; x=1675446813; bh=ADA0MfB2Bn8m0
        MF+9M36B7RFkDED4j6UmA2ZzwFFajY=; b=coK1d3OkHU50gxO+/sCtMYYFOwtd6
        P4jCB3rBTI+ApGkvHXwl4/X7nPAYzEn2wSI/AhCgZw0UxDMnrdYH7ozUjo3KYPRF
        jNz93dsu3deTXBYkva/GXgL2QEnPMG0W3ggRyJ2+bQ1FYS9R6hgbXcanEyVPiugy
        3/jqrMMRgf9R724lDx2LAwYurgoDOy5+8Dv+JcT65dkjtEXtwp8ou67QoXiZV+3A
        kvo0Hz1cTTEZIW5Ss4pVRbYEuewLiDgeQIfo6E6CLlquJaLL2U99Y+q9YlxdwYIv
        5ZQ6tQmeWV3CoCowbkPh3qBCKxW8j4l/PB4ZSboT5zmDBR7iu0h8WNdcw==
X-ME-Sender: <xms:nPjbYxWLseu764yKcwTK0ieu4ng-M-3laAhXXoe9aih01E6hbhyk0Q>
    <xme:nPjbYxky35Jc3Htd5hcMq_UqfX6s6-JXXOm6bbap2L83TT00o4pefgfN61_v_h3xd
    3wLcNwWTCJBR4xxw_w>
X-ME-Received: <xmr:nPjbY9Yid-R_8OGfyEgExXQXjUtuAtPiOlY-oTxkORJOqg31gjUAkFayyibxh87-riuPdIJze92rMTP8pQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefkedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecumhhishhsihhnghcuvffquchfihgvlhguucdlfe
    dtmdenucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefr
    vghtvghrucffvghlvghvohhrhigrshcuoehpvghtvghrsehpjhgurdguvghvqeenucggtf
    frrghtthgvrhhnpeeliedvteeuieekuefhieeghfehueffheeutdduueejiedvfedtudev
    geevhfffhfenucffohhmrghinhepughmthhfrdhorhhgpdifihhkihhpvgguihgrrdhorh
    hgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepphgv
    thgvrhesphhjugdruggvvh
X-ME-Proxy: <xmx:nfjbY0WFMUYkrP986ln5-U3En49yAS1laCLAIXHTGQrEiPmkyKQTXA>
    <xmx:nfjbY7mAsU6ES8WQ0H0nrGxR7MbbFkzINlW_MsaW_1QECcp-Rq9VBg>
    <xmx:nfjbYxehrJQ0GnkBkKHtoY_pS79EgDjwipOr5bX67_RhVjwFhfVWMQ>
    <xmx:nfjbY5V0zQ7P0FKJDmiSLCg5HtT5GJgK72ylIxONxPH17UyJ2SCluw>
Feedback-ID: i9e814621:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Feb 2023 12:53:31 -0500 (EST)
From:   Peter Delevoryas <peter@pjd.dev>
Cc:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, joel@jms.id.au,
        gwshan@linux.vnet.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next PATCH 1/1] net/ncsi: Fix netlink major/minor version numbers
Date:   Thu,  2 Feb 2023 09:53:27 -0800
Message-Id: <20230202175327.23429-2-peter@pjd.dev>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230202175327.23429-1-peter@pjd.dev>
References: <20230202175327.23429-1-peter@pjd.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netlink interface for major and minor version numbers doesn't actually
return the major and minor version numbers.

It reports a u32 that contains the (major, minor, update, alpha1)
components as the major version number, and then alpha2 as the minor
version number.

For whatever reason, the u32 byte order was reversed (ntohl): maybe it was
assumed that the encoded value was a single big-endian u32, and alpha2 was
the minor version.

The correct way to get the supported NC-SI version from the network
controller is to parse the Get Version ID response as described in 8.4.44
of the NC-SI spec[1].

    Get Version ID Response Packet Format

              Bits
            +--------+--------+--------+--------+
     Bytes  | 31..24 | 23..16 | 15..8  | 7..0   |
    +-------+--------+--------+--------+--------+
    | 0..15 | NC-SI Header                      |
    +-------+--------+--------+--------+--------+
    | 16..19| Response code   | Reason code     |
    +-------+--------+--------+--------+--------+
    |20..23 | Major  | Minor  | Update | Alpha1 |
    +-------+--------+--------+--------+--------+
    |24..27 |         reserved         | Alpha2 |
    +-------+--------+--------+--------+--------+
    |            .... other stuff ....          |

The major, minor, and update fields are all binary-coded decimal (BCD)
encoded [2]. The spec provides examples below the Get Version ID response
format in section 8.4.44.1, but for practical purposes, this is an example
from a live network card:

    root@bmc:~# ncsi-util 0x15
    NC-SI Command Response:
    cmd: GET_VERSION_ID(0x15)
    Response: COMMAND_COMPLETED(0x0000)  Reason: NO_ERROR(0x0000)
    Payload length = 40

    20: 0xf1 0xf1 0xf0 0x00 <<<<<<<<< (major, minor, update, alpha1)
    24: 0x00 0x00 0x00 0x00 <<<<<<<<< (_, _, _, alpha2)

    28: 0x6d 0x6c 0x78 0x30
    32: 0x2e 0x31 0x00 0x00
    36: 0x00 0x00 0x00 0x00
    40: 0x16 0x1d 0x07 0xd2
    44: 0x10 0x1d 0x15 0xb3
    48: 0x00 0x17 0x15 0xb3
    52: 0x00 0x00 0x81 0x19

This should be parsed as "1.1.0".

"f" in the upper-nibble means to ignore it, contributing zero.

If both nibbles are "f", I think the whole field is supposed to be ignored.
Major and minor are "required", meaning they're not supposed to be "ff",
but the update field is "optional" so I think it can be ff. I think the
simplest thing to do is just set the major and minor to zero instead of
juggling some conditional logic or something.

bcd2bin() from "include/linux/bcd.h" seems to assume both nibbles are 0-9,
so I've provided a custom BCD decoding function.

Alpha1 and alpha2 are ISO/IEC 8859-1 encoded, which just means ASCII
characters as far as I can tell, although the full encoding table for
non-alphabetic characters is slightly different (I think).

I imagine the alpha fields are just supposed to be alphabetic characters,
but I haven't seen any network cards actually report a non-zero value for
either.

If people wrote software against this netlink behavior, and were parsing
the major and minor versions themselves from the u32, then this would
definitely break their code.

[1] https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.0.0.pdf
[2] https://en.wikipedia.org/wiki/Binary-coded_decimal
[2] https://en.wikipedia.org/wiki/ISO/IEC_8859-1

Fixes: 138635cc27c9 ("net/ncsi: NCSI response packet handler")
Signed-off-by: Peter Delevoryas <peter@pjd.dev>
---
 net/ncsi/internal.h     |  7 +++++--
 net/ncsi/ncsi-netlink.c |  4 ++--
 net/ncsi/ncsi-pkt.h     |  7 +++++--
 net/ncsi/ncsi-rsp.c     | 26 ++++++++++++++++++++++++--
 4 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index 03757e76bb6b..374412ed780b 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -105,8 +105,11 @@ enum {
 
 
 struct ncsi_channel_version {
-	u32 version;		/* Supported BCD encoded NCSI version */
-	u32 alpha2;		/* Supported BCD encoded NCSI version */
+	u8   major;		/* NCSI version major */
+	u8   minor;		/* NCSI version minor */
+	u8   update;		/* NCSI version update */
+	char alpha1;		/* NCSI version alpha1 */
+	char alpha2;		/* NCSI version alpha2 */
 	u8  fw_name[12];	/* Firmware name string                */
 	u32 fw_version;		/* Firmware version                   */
 	u16 pci_ids[4];		/* PCI identification                 */
diff --git a/net/ncsi/ncsi-netlink.c b/net/ncsi/ncsi-netlink.c
index d27f4eccce6d..fe681680b5d9 100644
--- a/net/ncsi/ncsi-netlink.c
+++ b/net/ncsi/ncsi-netlink.c
@@ -71,8 +71,8 @@ static int ncsi_write_channel_info(struct sk_buff *skb,
 	if (nc == nc->package->preferred_channel)
 		nla_put_flag(skb, NCSI_CHANNEL_ATTR_FORCED);
 
-	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MAJOR, nc->version.version);
-	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MINOR, nc->version.alpha2);
+	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MAJOR, nc->version.major);
+	nla_put_u32(skb, NCSI_CHANNEL_ATTR_VERSION_MINOR, nc->version.minor);
 	nla_put_string(skb, NCSI_CHANNEL_ATTR_VERSION_STR, nc->version.fw_name);
 
 	vid_nest = nla_nest_start_noflag(skb, NCSI_CHANNEL_ATTR_VLAN_LIST);
diff --git a/net/ncsi/ncsi-pkt.h b/net/ncsi/ncsi-pkt.h
index ba66c7dc3a21..c9d1da34dc4d 100644
--- a/net/ncsi/ncsi-pkt.h
+++ b/net/ncsi/ncsi-pkt.h
@@ -197,9 +197,12 @@ struct ncsi_rsp_gls_pkt {
 /* Get Version ID */
 struct ncsi_rsp_gvi_pkt {
 	struct ncsi_rsp_pkt_hdr rsp;          /* Response header */
-	__be32                  ncsi_version; /* NCSI version    */
+	unsigned char           major;        /* NCSI version major */
+	unsigned char           minor;        /* NCSI version minor */
+	unsigned char           update;       /* NCSI version update */
+	unsigned char           alpha1;       /* NCSI version alpha1 */
 	unsigned char           reserved[3];  /* Reserved        */
-	unsigned char           alpha2;       /* NCSI version    */
+	unsigned char           alpha2;       /* NCSI version alpha2 */
 	unsigned char           fw_name[12];  /* f/w name string */
 	__be32                  fw_version;   /* f/w version     */
 	__be16                  pci_ids[4];   /* PCI IDs         */
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 6447a09932f5..7a805b86a12d 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -19,6 +19,19 @@
 #include "ncsi-pkt.h"
 #include "ncsi-netlink.h"
 
+/* Nibbles within [0xA, 0xF] add zero "0" to the returned value.
+ * Optional fields (encoded as 0xFF) will default to zero.
+ */
+static u8 decode_bcd_u8(u8 x)
+{
+	int lo = x & 0xF;
+	int hi = x >> 4;
+
+	lo = lo < 0xA ? lo : 0;
+	hi = hi < 0xA ? hi : 0;
+	return lo + hi * 10;
+}
+
 static int ncsi_validate_rsp_pkt(struct ncsi_request *nr,
 				 unsigned short payload)
 {
@@ -804,9 +817,18 @@ static int ncsi_rsp_handler_gvi(struct ncsi_request *nr)
 	if (!nc)
 		return -ENODEV;
 
-	/* Update to channel's version info */
+	/* Update channel's version info
+	 *
+	 * Major, minor, and update fields are supposed to be
+	 * unsigned integers encoded as packed BCD.
+	 *
+	 * Alpha1 and alpha2 are ISO/IEC 8859-1 characters.
+	 */
 	ncv = &nc->version;
-	ncv->version = ntohl(rsp->ncsi_version);
+	ncv->major = decode_bcd_u8(rsp->major);
+	ncv->minor = decode_bcd_u8(rsp->minor);
+	ncv->update = decode_bcd_u8(rsp->update);
+	ncv->alpha1 = rsp->alpha1;
 	ncv->alpha2 = rsp->alpha2;
 	memcpy(ncv->fw_name, rsp->fw_name, 12);
 	ncv->fw_version = ntohl(rsp->fw_version);
-- 
2.30.2

