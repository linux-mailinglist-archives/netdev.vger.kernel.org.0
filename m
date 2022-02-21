Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7874BD452
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 04:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344380AbiBUDnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 22:43:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344371AbiBUDnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 22:43:08 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742F33C70E;
        Sun, 20 Feb 2022 19:42:45 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 412EC32001BB;
        Sun, 20 Feb 2022 22:42:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 20 Feb 2022 22:42:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=kRJmWAWFjKOALsTRLgibyhb8NsyL7NusOB/YUc9eB
        kM=; b=hd0w/MJf6l//ha5NyaJHPHtK+xblj4CF7MnwjPQP918OiOgwP+vE+zlRl
        vkKsrgeohaO+ZE2PT3ab/v5Bc9Lk+yhUhBm09xahRA0oGJ3NTTz1cuqxoEotitz4
        mjy7FKfgTgsNNgnWzt5bk4ujJFPRPZVdhbEFkj4iCTwJqJ5gnUoKQYC8/t0eQ70k
        HC6j3ozXuG1GM2BG5LH52Y0kkfPIfAxBZPdE/BASgP0MnByqcAXv7wfm+lR+/awr
        aBxwKvbMEafVx1ppp2sukMezYqZmd5zK3LuF8M4os1aelsbNjxNcbeUiW+UdLHLJ
        RmtUwsrOae1YyHt21nbhMq9AKRyNw==
X-ME-Sender: <xms:MwoTYpJAi8YoCYmyuEqg-QdsIRKZ6L7-NhiHdG7SEG7lMyP8nALj6Q>
    <xme:MwoTYlLG2w-RlJ5DEbSD9gPWL9EnEJzkpLT7dJZ6AGwsLgQ0sg7HtN4MHdllqBix3
    ySyHXipQVRB4Q>
X-ME-Received: <xmr:MwoTYht1uRt60FM5guu_6RXFXGIRWdYP2MwQCY0yYop4o7IebxWgUEC7TaiXnHs1h61vX4BDQhy3TGtvonP0XMpRjAOi7nVnKdNSGiTYsaNMmLbA6To>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeehgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhggtghogfesthekredtredtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepffdt
    uefffeduhfelueegvdetheejvdehteelfeetfeekgfekkefggedtgefhieejnecuffhomh
    grihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehmrghrmhgrrhgvkhesihhnvhhishhisghlvghthhhinhhgsh
    hlrggsrdgtohhm
X-ME-Proxy: <xmx:MwoTYqaK9BAcguBxDC2Hd73fGSTVhtfhY7s3hgvK24QFn6aHVI5R-g>
    <xmx:MwoTYgbx--0TdhDf36bHLrCDs32_iWQH7Li3s42yimtcuB6CDw25BA>
    <xmx:MwoTYuCfP5VPhCYLo4ZQbRtRTBc2Eeii-zqjX9Ujjz-bYtDLiypS7g>
    <xmx:MwoTYg6J601ARQwvABPkeNeeDB-PEJwSE5WkMjMDK-spsG7obGyI-g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 20 Feb 2022 22:42:42 -0500 (EST)
From:   =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, stable@vger.kernel.org,
        Michael Brown <mcb30@ipxe.org>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org (moderated list:XEN NETWORK BACKEND
        DRIVER),
        netdev@vger.kernel.org (open list:XEN NETWORK BACKEND DRIVER)
Subject: [PATCH 2/2] Revert "xen-netback: Check for hotplug-status existence before watching"
Date:   Mon, 21 Feb 2022 04:42:13 +0100
Message-Id: <20220221034214.2237097-2-marmarek@invisiblethingslab.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220221034214.2237097-1-marmarek@invisiblethingslab.com>
References: <20220221034214.2237097-1-marmarek@invisiblethingslab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Invisible Things Lab
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 2afeec08ab5c86ae21952151f726bfe184f6b23d.

The reasoning in the commit was wrong - the code expected to setup the
watch even if 'hotplug-status' didn't exist. In fact, it relied on the
watch being fired the first time - to check if maybe 'hotplug-status' is
already set to 'connected'. Not registering a watch for non-existing
path (which is the case if hotplug script hasn't been executed yet),
made the backend not waiting for the hotplug script to execute. This in
turns, made the netfront think the interface is fully operational, while
in fact it was not (the vif interface on xen-netback side might not be
configured yet).

This was a workaround for 'hotplug-status' erroneously being removed.
But since that is reverted now, the workaround is not necessary either.

More discussion at
https://lore.kernel.org/xen-devel/afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org/T/#u

Cc: stable@vger.kernel.org
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
---
I believe this is the same issue as discussed at
https://lore.kernel.org/xen-devel/20220113111946.GA4133739@dingwall.me.uk/
Cc: James Dingwall <james-xen@dingwall.me.uk
Cc: Michael Brown <mcb30@ipxe.org>
---
 drivers/net/xen-netback/xenbus.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index ce0f3035bee8..9d7a3a92959f 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -824,15 +824,11 @@ static void connect(struct backend_info *be)
 	xenvif_carrier_on(be->vif);
 
 	unregister_hotplug_status_watch(be);
-	if (xenbus_exists(XBT_NIL, dev->nodename, "hotplug-status")) {
-		err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch,
-					   NULL, hotplug_status_changed,
-					   "%s/%s", dev->nodename,
-					   "hotplug-status");
-		if (err)
-			goto err;
+	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch, NULL,
+				   hotplug_status_changed,
+				   "%s/%s", dev->nodename, "hotplug-status");
+	if (!err)
 		be->have_hotplug_status_watch = 1;
-	}
 
 	netif_tx_wake_all_queues(be->vif->dev);
 
-- 
2.31.1

