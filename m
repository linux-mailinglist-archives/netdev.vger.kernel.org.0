Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB484BEED7
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 02:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237673AbiBVATZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 19:19:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbiBVATL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 19:19:11 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE17925C6B;
        Mon, 21 Feb 2022 16:18:28 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 7647D3200E18;
        Mon, 21 Feb 2022 19:18:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 21 Feb 2022 19:18:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=V9Y0aM
        UYHoxDUjucoxLUoyDrdDFBnSbiTwU4Pu0uuFw=; b=Lk7v6cS86buxdL8uLglrJ8
        gc9GPXof0oIZU84PNZS0mRqvfXb64ccuVy9qySymDTnYJcySt/ZwrRz0HTeVk1CR
        l61CGJ2G87b0Pmmse9ZprfW4w2/RH/6jCsvVm61jxpFdSGc5RjuFjUeL2rNr5RDd
        ulmpGv/OUnMLQSxHyTbIRZStwuzcYkBsljArWHqMossMrQZUttPK/t2pHvrOjPuy
        6E1VIMgHN8sQnTbsOHtm6FuwU4Zxeh//vY9jr50+jJCSvZYMn7ouk1S09tIEsv0S
        YSaXnVWcxH0WIEAPaz0ZMsMN6fbmZ49DeZHEVxgKSVw9CR8N5QcZdtFF1lVZnadQ
        ==
X-ME-Sender: <xms:0isUYhajOZif2OF11acXMQugW-NrH2b_uuhjTeHOte1ytVDE7J4LdA>
    <xme:0isUYoZQTk298bz6NhkJeJo7nh3pTWf_TqtPCeZqxGMcAvB8nZC98OnBF8stf414H
    _ra65IIJq8Q9g>
X-ME-Received: <xmr:0isUYj8Fma0A7ZZPlTu5Ohh-ivjB3OnThldADd9LeVck_MhkjSXkkBpMPGxEEqz1v9r9EtbJM8gDo4y_gW_AN_BwPIglIc29MWH1z2mccvDVaoiFxpg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeejgddvtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofggtghogfesthekredtredtjeenucfhrhhomhepofgrrhgvkhcu
    ofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinhhvih
    hsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhephefhfeet
    ueelvddvtedttdevieeluedtvedtfeejieelhedutdeuheduieejgfegnecuffhomhgrih
    hnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehmrghrmhgrrhgvkhesihhnvhhishhisghlvghthhhinhhgshhlrg
    gsrdgtohhm
X-ME-Proxy: <xmx:0isUYvpB1SHuZaVw5a9ZhadbYdSGae9vJeyV7K4x5gcIdddd6wJkkQ>
    <xmx:0isUYsp3z9sEfUZi6pmTXeG08t01qdZBkrZQzYGtyGS0gnvDoqmjNg>
    <xmx:0isUYlQZFBhIIe7JTbGpftfH5DnpbHB-9W_VdhqSgmxKUVbwYd-ktw>
    <xmx:0ysUYkIIpexJHEw0wIokCFdZ7Y1kjK8qUNuZ1i1wytH5LTyJUaaMIw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Feb 2022 19:18:25 -0500 (EST)
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
Subject: [PATCH v2 1/2] Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"
Date:   Tue, 22 Feb 2022 01:18:16 +0100
Message-Id: <20220222001817.2264967-1-marmarek@invisiblethingslab.com>
X-Mailer: git-send-email 2.31.1
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

This reverts commit 1f2565780e9b7218cf92c7630130e82dcc0fe9c2.

The 'hotplug-status' node should not be removed as long as the vif
device remains configured. Otherwise the xen-netback would wait for
re-running the network script even if it was already called (in case of
the frontent re-connecting). But also, it _should_ be removed when the
vif device is destroyed (for example when unbinding the driver) -
otherwise hotplug script would not configure the device whenever it
re-appear.

Moving removal of the 'hotplug-status' node was a workaround for nothing
calling network script after xen-netback module is reloaded. But when
vif interface is re-created (on xen-netback unbind/bind for example),
the script should be called, regardless of who does that - currently
this case is not handled by the toolstack, and requires manual
script call. Keeping hotplug-status=connected to skip the call is wrong
and leads to not configured interface.

More discussion at
https://lore.kernel.org/xen-devel/afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org/T/#u

Cc: stable@vger.kernel.org
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
---
Cc: Michael Brown <mcb30@ipxe.org>
Changes in v2:
 - build fix, reported by kernel test robot <lkp@intel.com>

---
 drivers/net/xen-netback/xenbus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index d24b7a7993aa..3fad58d22155 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -256,6 +256,7 @@ static void backend_disconnect(struct backend_info *be)
 		unsigned int queue_index;
 
 		xen_unregister_watchers(vif);
+		xenbus_rm(XBT_NIL, be->dev->nodename, "hotplug-status");
 #ifdef CONFIG_DEBUG_FS
 		xenvif_debugfs_delif(vif);
 #endif /* CONFIG_DEBUG_FS */
@@ -675,7 +676,6 @@ static void hotplug_status_changed(struct xenbus_watch *watch,
 
 		/* Not interested in this watch anymore. */
 		unregister_hotplug_status_watch(be);
-		xenbus_rm(XBT_NIL, be->dev->nodename, "hotplug-status");
 	}
 	kfree(str);
 }
-- 
2.31.1

