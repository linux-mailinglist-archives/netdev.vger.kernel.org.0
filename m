Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A43E652C58
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 06:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiLUFW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 00:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLUFWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 00:22:55 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16DD205C4;
        Tue, 20 Dec 2022 21:22:53 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id ED0E53200928;
        Wed, 21 Dec 2022 00:22:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 21 Dec 2022 00:22:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pjd.dev; h=cc:cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1671600171; x=1671686571; bh=sL
        2oxNr011h7ZeJ2PosuMIR2/IGZMgP1eqdnxe/YkgM=; b=J8twjOE5bulwy00Gf9
        lsqxSQz8vvJeYXmGvteGkxEnewW0YMzDTySrzpEFxbxuFpxtlBVtGN87kfIX/Iug
        qUyv0AYStuiAUJMYkGlD82QvGinaMlKECiz2aKjMUSR0EJzpCz7OH5+MaVZ/IL9F
        99JLNzpmc52Pk1lz/9Vx7qIhGNYGClYqGW+PU7PUvaVpeBKwgIjlDaeKU0ett6MO
        L+VUzf1ZQUtfLsuu72D79Q+IgW2Z02PKNOGz7ef9/mrnXZfLresTgJjvxRtaGB6x
        wZjH+HaARHdLK+kI14pm8ViWikAsGUhEj3s0cKCDyDqjwalthLTgqVNXsa9UEOk9
        eXFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1671600171; x=1671686571; bh=sL2oxNr011h7Z
        eJ2PosuMIR2/IGZMgP1eqdnxe/YkgM=; b=ZHhWAQ+Y7dMLl4lxM3oe5Lt3CRXv4
        Ls0b1HXfluhw4vomW62VviyrU2YKPk0pkMTPY3ckl/oVDzXf54sFqhZfDXpxeEGY
        4fAbdPdxovnFrxIqkpfU0r5Ua4+65aVt83+Yf8okKKObXc4U+uYJPd2a8KghibIH
        E0wutnKEAMt5u9Lx/TkImmMA6za1shaQXtGHvPL2R9JQ93tl3vXdaGmJNkmIigrs
        f+HJKUXUM7GH+ccMJI9Kl4jUKagDWNui9brJHvBYzrQwKXB5yWaXJm+9LiKOlC9A
        Y5E67G/aeCczghq8pYsabAwZO/A5NDnEvGIMr87qMtsuanK3H/se7dvhA==
X-ME-Sender: <xms:K5iiYzW5Cr7m7mT_2ZiAv6uICSW7W5kGHbQEq6TnG3EMfKZE5FjS2g>
    <xme:K5iiY7mVyIcub6OPoEAKyeBkrv3GL1uWpkKXZUt1ggYa4fqUp9OMc1-rmXKdPQ8jI
    eJlvqmyzYi2M6SiP0k>
X-ME-Received: <xmr:K5iiY_ZN2HLPfmPXLXAchvcN5BVn5GTdo3mAgLBvkQNJ74C8OGUA0ayV98mFlSaLjvMQl9RrfE8dPWHniK0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeejgdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecumhhishhsihhnghcuvffquchfihgvlhguucdlfedtmd
    enogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffojghfggfgsedtkeer
    tdertddtnecuhfhrohhmpefrvghtvghrucffvghlvghvohhrhigrshcuoehpvghtvghrse
    hpjhgurdguvghvqeenucggtffrrghtthgvrhhnpeektdeileejieehiedujeehleduueej
    keekjeeggfettdevieevhfeggfeuffeiteenucffohhmrghinhepkhgvrhhnvghlrdhorh
    hgpdhgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehpvghtvghrsehpjhgurdguvghv
X-ME-Proxy: <xmx:K5iiY-Whz7MSZiKZVetbg8QBkctrJq7vfhJrW6T_eJpslgjfJWlpCw>
    <xmx:K5iiY9lwOyyvl7xXOA-VhC_FF9eCqCYKAcfxlpGajTVguLbuu3rrbw>
    <xmx:K5iiY7eepPPgDEqqKIGtV5mKitMmLDUqBLe6OXVB0LOh_0j0JKK7Hg>
    <xmx:K5iiY_6frqQInS4DQ6kNLPKvun0K3pv5qwOpI-e3uWRKA6qQT28zbA>
Feedback-ID: i9e814621:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Dec 2022 00:22:51 -0500 (EST)
From:   Peter Delevoryas <peter@pjd.dev>
Cc:     peter@pjd.dev, sam@mendozajonas.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        joel@jms.id.au, gwshan@linux.vnet.ibm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net/ncsi: Simplify Kconfig/dts control flow
Date:   Tue, 20 Dec 2022 21:22:44 -0800
Message-Id: <20221221052246.519674-2-peter@pjd.dev>
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

Background:

1. CONFIG_NCSI_OEM_CMD_KEEP_PHY

If this is enabled, we send an extra OEM Intel command in the probe
sequence immediately after discovering a channel (e.g. after "Clear
Initial State").

2. CONFIG_NCSI_OEM_CMD_GET_MAC

If this is enabled, we send one of 3 OEM "Get MAC Address" commands from
Broadcom, Mellanox (Nvidida), and Intel in the *configuration* sequence
for a channel.

3. mellanox,multi-host (or mlx,multi-host)

Introduced by this patch:

https://lore.kernel.org/all/20200108234341.2590674-1-vijaykhemka@fb.com/

Which was actually originally from cosmo.chou@quantatw.com:

https://github.com/facebook/openbmc-linux/commit/9f132a10ec48db84613519258cd8a317fb9c8f1b

Cosmo claimed that the Nvidia ConnectX-4 and ConnectX-6 NIC's don't
respond to Get Version ID, et. al in the probe sequence unless you send
the Set MC Affinity command first.

Problem Statement:

We've been using a combination of #ifdef code blocks and IS_ENABLED()
conditions to conditionally send these OEM commands.

It makes adding any new code around these commands hard to understand.

Solution:

In this patch, I just want to remove the conditionally compiled blocks
of code, and always use IS_ENABLED(...) to do dynamic control flow.

I don't think the small amount of code this adds to non-users of the OEM
Kconfigs is a big deal.

Signed-off-by: Peter Delevoryas <peter@pjd.dev>
---
 net/ncsi/ncsi-manage.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index 80713febfac6..f56795769893 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -689,8 +689,6 @@ static int set_one_vid(struct ncsi_dev_priv *ndp, struct ncsi_channel *nc,
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
-
 static int ncsi_oem_keep_phy_intel(struct ncsi_cmd_arg *nca)
 {
 	unsigned char data[NCSI_OEM_INTEL_CMD_KEEP_PHY_LEN];
@@ -716,10 +714,6 @@ static int ncsi_oem_keep_phy_intel(struct ncsi_cmd_arg *nca)
 	return ret;
 }
 
-#endif
-
-#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
-
 /* NCSI OEM Command APIs */
 static int ncsi_oem_gma_handler_bcm(struct ncsi_cmd_arg *nca)
 {
@@ -856,8 +850,6 @@ static int ncsi_gma_handler(struct ncsi_cmd_arg *nca, unsigned int mf_id)
 	return nch->handler(nca);
 }
 
-#endif /* CONFIG_NCSI_OEM_CMD_GET_MAC */
-
 /* Determine if a given channel from the channel_queue should be used for Tx */
 static bool ncsi_channel_is_tx(struct ncsi_dev_priv *ndp,
 			       struct ncsi_channel *nc)
@@ -1039,20 +1031,18 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
 			goto error;
 		}
 
-		nd->state = ncsi_dev_state_config_oem_gma;
+		nd->state = IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
+			  ? ncsi_dev_state_config_oem_gma
+			  : ncsi_dev_state_config_clear_vids;
 		break;
 	case ncsi_dev_state_config_oem_gma:
 		nd->state = ncsi_dev_state_config_clear_vids;
-		ret = -1;
 
-#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
 		nca.type = NCSI_PKT_CMD_OEM;
 		nca.package = np->id;
 		nca.channel = nc->id;
 		ndp->pending_req_num = 1;
 		ret = ncsi_gma_handler(&nca, nc->version.mf_id);
-#endif /* CONFIG_NCSI_OEM_CMD_GET_MAC */
-
 		if (ret < 0)
 			schedule_work(&ndp->work);
 
@@ -1404,7 +1394,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 
 		schedule_work(&ndp->work);
 		break;
-#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
 	case ncsi_dev_state_probe_mlx_gma:
 		ndp->pending_req_num = 1;
 
@@ -1429,7 +1418,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 
 		nd->state = ncsi_dev_state_probe_cis;
 		break;
-#endif /* CONFIG_NCSI_OEM_CMD_GET_MAC */
 	case ncsi_dev_state_probe_cis:
 		ndp->pending_req_num = NCSI_RESERVED_CHANNEL;
 
@@ -1447,7 +1435,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 		if (IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY))
 			nd->state = ncsi_dev_state_probe_keep_phy;
 		break;
-#if IS_ENABLED(CONFIG_NCSI_OEM_CMD_KEEP_PHY)
 	case ncsi_dev_state_probe_keep_phy:
 		ndp->pending_req_num = 1;
 
@@ -1460,7 +1447,6 @@ static void ncsi_probe_channel(struct ncsi_dev_priv *ndp)
 
 		nd->state = ncsi_dev_state_probe_gvi;
 		break;
-#endif /* CONFIG_NCSI_OEM_CMD_KEEP_PHY */
 	case ncsi_dev_state_probe_gvi:
 	case ncsi_dev_state_probe_gc:
 	case ncsi_dev_state_probe_gls:
-- 
2.30.2

