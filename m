Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D7C652C5F
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 06:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbiLUFXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 00:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiLUFW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 00:22:59 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1950205E4;
        Tue, 20 Dec 2022 21:22:58 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id C4BFB320092A;
        Wed, 21 Dec 2022 00:22:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 21 Dec 2022 00:22:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pjd.dev; h=cc:cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1671600177; x=1671686577; bh=Zg
        fj7AjLpkv1KMNUdbs3vZmEHCz6Q1TCgnvxZx4jkhQ=; b=Kxi9icXfAj7jIkrwcc
        HyM5pl9gUlYpsn/l+wKIQ8QS267FnwPqcSoCKmm9uQqa0r74o9WWeR6ImzZGvsht
        EmaxWGx4sMsXy3tYGGB81FoldaPGRMYqANUKPfbRopLVAP66VRSZty+Bc7+0sPi4
        8bt50qsZkQ/0Pl6/hyXSfcmPctYTwC/gsOVEyD/kFRrv4n5jUlBvxnOGlj3MoRqF
        L3Zah2S/Le2ZcmoL6HcDzXacMl7SVNTlipQ8/Ib7tRO9lrFEuumGvTCgqqlKngvz
        hcwBujO8Wv8v+agjbsEgGERkYsG79EjqPCTWC+LjLevdjKg4Vs3fh+p9MOExzYcj
        BrFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1671600177; x=1671686577; bh=Zgfj7AjLpkv1K
        MNUdbs3vZmEHCz6Q1TCgnvxZx4jkhQ=; b=VJNIvomz9x7pRvkHUQAXfH5U4mEg2
        PBzdTMsxgTqpX6Kx+zNXomNtPFflj6Ptn9EzLqDoTrUyEbDO4+mqxyFEB1/a+py4
        xnFEzvADEWnfOeLwzljCSd/gy0Dmcb9N7BIZd6omKKMyzIF0gRdvg4NWPDSOqPum
        GYboQZTlUcZfYTzL0BUVDSFYtH5DAJM0ZvEoMxmJWOGXAoqMWnqM8Wuk2fLvwIb3
        PSZEOb4n5pSzs0ENZcC81nhsY9Y5qZoJxY1Fjoc8TlAA6eAh+Q66EvzTk1QJOh53
        cmUvgzlbBTyyE/FEPN88bAXFPoPfpDNce/vsT+auFREbtg64YeVFRcpUA==
X-ME-Sender: <xms:MZiiY1HD0bZ0y1c7vkf6PFXr5tLxCPrNYzETreoE2STnhN1-9gD-9g>
    <xme:MZiiY6ULbeFFDRITtxWZRCrVKUV-KBJs7_qugukr_tFHyEuPA18_H8G1ZD0_rjj0n
    APdO8gDHT_z9fZ4Foo>
X-ME-Received: <xmr:MZiiY3KLYL2kC_CMVVSTEI-b8Xni28kSHAeT1nfqT4kloqTBm76ZbFUBPryZl7EzSwhax7vDYOHJjyzwEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeejgdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecumhhishhsihhnghcuvffquchfihgvlhguucdlfedtmd
    enogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffojghfggfgsedtkeer
    tdertddtnecuhfhrohhmpefrvghtvghrucffvghlvghvohhrhigrshcuoehpvghtvghrse
    hpjhgurdguvghvqeenucggtffrrghtthgvrhhnpeefjeejlefggeefueehfeekieetgeeh
    teffhedvtdfgfeevjeefudejjeejjeelkeenucffohhmrghinhepughmthhfrdhorhhgpd
    hgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehpvghtvghrsehpjhgurdguvghv
X-ME-Proxy: <xmx:MZiiY7E3Xw22nE2KMvJPqcAjKu9HBEPIlCf5tPvfh_p577tsZtjgyg>
    <xmx:MZiiY7WAA09KGKO-2vvdk1Qb_89Nmd8xhm_QfWyqSW2ALWD5ta1NNQ>
    <xmx:MZiiY2MH4-fPD6Jr5Z0lxI2ie0BjLEzwoDFfwNNdVb5Thug9NzDqDQ>
    <xmx:MZiiY3o08f27i_TrfZsiDyMZITn_ljhpuDqGbYqqy7WuRSEl8qD9pA>
Feedback-ID: i9e814621:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Dec 2022 00:22:56 -0500 (EST)
From:   Peter Delevoryas <peter@pjd.dev>
Cc:     peter@pjd.dev, sam@mendozajonas.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        joel@jms.id.au, gwshan@linux.vnet.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] net/ncsi: Add NC-SI 1.2 Get MC MAC Address command
Date:   Tue, 20 Dec 2022 21:22:46 -0800
Message-Id: <20221221052246.519674-4-peter@pjd.dev>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221221052246.519674-1-peter@pjd.dev>
References: <20221221052246.519674-1-peter@pjd.dev>
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

This change adds support for the NC-SI 1.2 Get MC MAC Address command,
specified here:

https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.2WIP90_0.pdf

It serves the exact same function as the existing OEM Get MAC Address
commands, so if a channel reports that it supports NC-SI 1.2, we prefer
to use the standard command rather than the OEM command.

Verified with an invalid MAC address and 2 valid ones:

[   55.137072] ftgmac100 1e690000.ftgmac eth0: NCSI: Received 3 provisioned MAC addresses
[   55.137614] ftgmac100 1e690000.ftgmac eth0: NCSI: MAC address 0: 00:00:00:00:00:00
[   55.138026] ftgmac100 1e690000.ftgmac eth0: NCSI: MAC address 1: fa:ce:b0:0c:20:22
[   55.138528] ftgmac100 1e690000.ftgmac eth0: NCSI: MAC address 2: fa:ce:b0:0c:20:23
[   55.139241] ftgmac100 1e690000.ftgmac eth0: NCSI: Unable to assign 00:00:00:00:00:00 to device
[   55.140098] ftgmac100 1e690000.ftgmac eth0: NCSI: Set MAC address to fa:ce:b0:0c:20:22

IMPORTANT NOTE:

The code I'm submitting here is parsing the MAC addresses as if they are
transmitted in *reverse* order.

This is different from how every other NC-SI command is parsed in the
Linux kernel, even though the spec describes the format in the same way
for every command.

The *reason* for this is that I was able to test this code against the
new 200G Broadcom NIC, which reports that it supports NC-SI 1.2 in Get
Version ID and successfully responds to this command. It transmits the
MAC addresses in reverse byte order.

Nvidia's new 200G NIC doesn't support NC-SI 1.2 yet. I don't know how
they're planning to implement it.

Why did Broadcom do this? Well, they have some of the core NC-SI
specification maintainers there, and at some point they must have
decided that everyone (Linux kernel folks and Nvidia and previous
Broadcom firmware authors) is interpreting the specification
incorrectly. They created a 2nd edition of their OEM Get MAC Address
command that returns the MAC address in reverse order:

https://github.com/facebook/openbmc-linux/commit/a4a3a45809c6d43582a12a25bc45b95a79a4c034

That was never upstreamed, but it's supposed to replace the version we
have in the upstream 6.x kernel today.

So, to summarize: I chose the reverse encoding because that's what the
first NC-SI 1.2 supported NIC is doing, and apparently that might be the
correct way to interpret the spec as we go forward.

Signed-off-by: Peter Delevoryas <peter@pjd.dev>
---
 net/ncsi/ncsi-cmd.c    |  3 ++-
 net/ncsi/ncsi-manage.c |  9 +++++++--
 net/ncsi/ncsi-pkt.h    | 10 ++++++++++
 net/ncsi/ncsi-rsp.c    | 45 +++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index dda8b76b7798..7be177f55173 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -269,7 +269,8 @@ static struct ncsi_cmd_handler {
 	{ NCSI_PKT_CMD_GPS,    0, ncsi_cmd_handler_default },
 	{ NCSI_PKT_CMD_OEM,   -1, ncsi_cmd_handler_oem     },
 	{ NCSI_PKT_CMD_PLDM,   0, NULL                     },
-	{ NCSI_PKT_CMD_GPUUID, 0, ncsi_cmd_handler_default }
+	{ NCSI_PKT_CMD_GPUUID, 0, ncsi_cmd_handler_default },
+	{ NCSI_PKT_CMD_GMCMA,  0, ncsi_cmd_handler_default }
 };
 
 static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index f56795769893..bc1887a2543d 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1038,11 +1038,16 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
 	case ncsi_dev_state_config_oem_gma:
 		nd->state = ncsi_dev_state_config_clear_vids;
 
-		nca.type = NCSI_PKT_CMD_OEM;
 		nca.package = np->id;
 		nca.channel = nc->id;
 		ndp->pending_req_num = 1;
-		ret = ncsi_gma_handler(&nca, nc->version.mf_id);
+		if (nc->version.major >= 1 && nc->version.minor >= 2) {
+			nca.type = NCSI_PKT_CMD_GMCMA;
+			ret = ncsi_xmit_cmd(&nca);
+		} else {
+			nca.type = NCSI_PKT_CMD_OEM;
+			ret = ncsi_gma_handler(&nca, nc->version.mf_id);
+		}
 		if (ret < 0)
 			schedule_work(&ndp->work);
 
diff --git a/net/ncsi/ncsi-pkt.h b/net/ncsi/ncsi-pkt.h
index c9d1da34dc4d..f2f3b5c1b941 100644
--- a/net/ncsi/ncsi-pkt.h
+++ b/net/ncsi/ncsi-pkt.h
@@ -338,6 +338,14 @@ struct ncsi_rsp_gpuuid_pkt {
 	__be32                  checksum;
 };
 
+/* Get MC MAC Address */
+struct ncsi_rsp_gmcma_pkt {
+	struct ncsi_rsp_pkt_hdr rsp;
+	unsigned char           address_count;
+	unsigned char           reserved[3];
+	unsigned char           addresses[][ETH_ALEN];
+};
+
 /* AEN: Link State Change */
 struct ncsi_aen_lsc_pkt {
 	struct ncsi_aen_pkt_hdr aen;        /* AEN header      */
@@ -398,6 +406,7 @@ struct ncsi_aen_hncdsc_pkt {
 #define NCSI_PKT_CMD_GPUUID	0x52 /* Get package UUID                 */
 #define NCSI_PKT_CMD_QPNPR	0x56 /* Query Pending NC PLDM request */
 #define NCSI_PKT_CMD_SNPR	0x57 /* Send NC PLDM Reply  */
+#define NCSI_PKT_CMD_GMCMA	0x58 /* Get MC MAC Address */
 
 
 /* NCSI packet responses */
@@ -433,6 +442,7 @@ struct ncsi_aen_hncdsc_pkt {
 #define NCSI_PKT_RSP_GPUUID	(NCSI_PKT_CMD_GPUUID + 0x80)
 #define NCSI_PKT_RSP_QPNPR	(NCSI_PKT_CMD_QPNPR   + 0x80)
 #define NCSI_PKT_RSP_SNPR	(NCSI_PKT_CMD_SNPR   + 0x80)
+#define NCSI_PKT_RSP_GMCMA	(NCSI_PKT_CMD_GMCMA  + 0x80)
 
 /* NCSI response code/reason */
 #define NCSI_PKT_RSP_C_COMPLETED	0x0000 /* Command Completed        */
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 7a805b86a12d..28a042688d0b 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -1140,6 +1140,48 @@ static int ncsi_rsp_handler_netlink(struct ncsi_request *nr)
 	return ret;
 }
 
+static int ncsi_rsp_handler_gmcma(struct ncsi_request *nr)
+{
+	struct ncsi_dev_priv *ndp = nr->ndp;
+	struct net_device *ndev = ndp->ndev.dev;
+	struct ncsi_rsp_gmcma_pkt *rsp;
+	struct sockaddr saddr;
+	int ret = -1;
+	int i;
+	int j;
+
+	rsp = (struct ncsi_rsp_gmcma_pkt *)skb_network_header(nr->rsp);
+	saddr.sa_family = ndev->type;
+	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+
+	netdev_warn(ndev, "NCSI: Received %d provisioned MAC addresses\n",
+		    rsp->address_count);
+	for (i = 0; i < rsp->address_count; i++) {
+		netdev_warn(ndev, "NCSI: MAC address %d: "
+			    "%02x:%02x:%02x:%02x:%02x:%02x\n", i,
+			    rsp->addresses[i][5], rsp->addresses[i][4],
+			    rsp->addresses[i][3], rsp->addresses[i][2],
+			    rsp->addresses[i][1], rsp->addresses[i][0]);
+	}
+
+	for (i = 0; i < rsp->address_count; i++) {
+		for (j = 0; j < ETH_ALEN; j++) {
+			saddr.sa_data[j] = rsp->addresses[i][ETH_ALEN - j - 1];
+		}
+		ret = ndev->netdev_ops->ndo_set_mac_address(ndev, &saddr);
+		if (ret < 0) {
+			netdev_warn(ndev, "NCSI: Unable to assign %pM to "
+				    "device\n", saddr.sa_data);
+			continue;
+		}
+		netdev_warn(ndev, "NCSI: Set MAC address to %pM\n", saddr.sa_data);
+		break;
+	}
+
+	ndp->gma_flag = ret == 0;
+	return ret;
+}
+
 static struct ncsi_rsp_handler {
 	unsigned char	type;
 	int             payload;
@@ -1176,7 +1218,8 @@ static struct ncsi_rsp_handler {
 	{ NCSI_PKT_RSP_PLDM,   -1, ncsi_rsp_handler_pldm    },
 	{ NCSI_PKT_RSP_GPUUID, 20, ncsi_rsp_handler_gpuuid  },
 	{ NCSI_PKT_RSP_QPNPR,  -1, ncsi_rsp_handler_pldm    },
-	{ NCSI_PKT_RSP_SNPR,   -1, ncsi_rsp_handler_pldm    }
+	{ NCSI_PKT_RSP_SNPR,   -1, ncsi_rsp_handler_pldm    },
+	{ NCSI_PKT_RSP_GMCMA,  -1, ncsi_rsp_handler_gmcma   },
 };
 
 int ncsi_rcv_rsp(struct sk_buff *skb, struct net_device *dev,
-- 
2.30.2

