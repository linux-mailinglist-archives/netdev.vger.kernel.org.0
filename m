Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6B964BCEBE
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237969AbiBTNvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:51:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235018AbiBTNvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:51:46 -0500
X-Greylist: delayed 115 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Feb 2022 05:51:25 PST
Received: from wnew2-smtp.messagingengine.com (wnew2-smtp.messagingengine.com [64.147.123.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6365621813;
        Sun, 20 Feb 2022 05:51:25 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 63AE62B00158;
        Sun, 20 Feb 2022 08:49:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 20 Feb 2022 08:49:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Hzfm38
        gwPt5b09qOmLkmmfY2IIYl8DekKzBTC8y6E/4=; b=Mh2eOvmHHkVx++fz80uns8
        7+Y+xWxOHRMVpsAEIc1iX9iGRssSrqTt4DEoPDkKx1zMSVEFmktobYjSc+Q1vqpE
        NB3k0jRzA8yiLumKKiNCTPhOv39knberB8iIy1iNXVam1m3xZ6RSDAXrqrZv8jX+
        22yZfgzepiyULlT8Tz9i7x1r8X55zgZl8EZFYADfPMtKl/mzHfYyUHRn9F32L8x5
        AKBkMSn9RahYlDyjeZLmzBXrhHBv5seX3OlpAlQfvr+eIxQRsqqhKWY76ow10uQ1
        6Mdrffpszfy/cfGdr0ALfw3W1veNut0gsBQH0iw9CHa0rkPUs2n6BxamINmtawbw
        ==
X-ME-Sender: <xms:5kYSYlZgeDpGHPwBYlonXCSlDA0koRyD9axOwL3Z0YRw_CmQo-vWOw>
    <xme:5kYSYsZkDLdYwizt3-sWnDo0Ek_-VY4wz4nUUXDRQm0KjWCCWcgIghGQQDlmgRR1H
    gUdKOwZErNerA>
X-ME-Received: <xmr:5kYSYn8kuaTIvJOQXtNXDSf_ZOaNsWIkXIB_zr2Ob-zXUb5UEpK2gIRWp0tu1j402tCpXi8AMuyBoBnqBS-_PsBDhHnIRE1I6n7OsbTNlbAh77k7t4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeeggdehkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofggtghogfesthekredtredtjeenucfhrhhomhepofgrrhgvkhcu
    ofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinhhvih
    hsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepgedvfefh
    tdfgkeefveetkefhiedvuedvjeffuefggeefffdvueffvefgueelteehnecuffhomhgrih
    hnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehmrghrmhgrrhgvkhesihhnvhhishhisghlvghthhhinhhgshhlrg
    gsrdgtohhm
X-ME-Proxy: <xmx:5kYSYjoQloU_-2nKAY4zkNwVwTH0cnfqm9aPKAwL1aCC9pjApIe0Sg>
    <xmx:5kYSYgrJNDHfSBhfWrXbh6aXi_ynQA1dHd5K9tXEFd7SIoILG-VPjg>
    <xmx:5kYSYpQxN-LOWG68VKFpG8cBbHvCtcI2Y_kJqNdU2_BtkTjlS_xZ3A>
    <xmx:5kYSYscqhqYX42m4acL8gaVOPiOG9sWqWL9OVERVct4UnFI7b5HIcb_l0sI>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 20 Feb 2022 08:49:25 -0500 (EST)
From:   =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        xen-devel@lists.xenproject.org (moderated list:XEN HYPERVISOR INTERFACE),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [PATCH] xen/netfront: destroy queues before real_num_tx_queues is zeroed
Date:   Sun, 20 Feb 2022 14:42:01 +0100
Message-Id: <20220220134202.2187485-1-marmarek@invisiblethingslab.com>
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

xennet_destroy_queues() relies on info->netdev->real_num_tx_queues to
delete queues. Since d7dac083414eb5bb99a6d2ed53dc2c1b405224e5
("net-sysfs: update the queue counts in the unregistration path"),
unregister_netdev() indirectly sets real_num_tx_queues to 0. Those two
facts together means, that xennet_destroy_queues() called from
xennet_remove() cannot do its job, because it's called after
unregister_netdev(). This results in kfree-ing queues that are still
linked in napi, which ultimately crashes:

    BUG: kernel NULL pointer dereference, address: 0000000000000000
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 0 P4D 0
    Oops: 0000 [#1] PREEMPT SMP PTI
    CPU: 1 PID: 52 Comm: xenwatch Tainted: G        W         5.16.10-1.32.fc32.qubes.x86_64+ #226
    RIP: 0010:free_netdev+0xa3/0x1a0
    Code: ff 48 89 df e8 2e e9 00 00 48 8b 43 50 48 8b 08 48 8d b8 a0 fe ff ff 48 8d a9 a0 fe ff ff 49 39 c4 75 26 eb 47 e8 ed c1 66 ff <48> 8b 85 60 01 00 00 48 8d 95 60 01 00 00 48 89 ef 48 2d 60 01 00
    RSP: 0000:ffffc90000bcfd00 EFLAGS: 00010286
    RAX: 0000000000000000 RBX: ffff88800edad000 RCX: 0000000000000000
    RDX: 0000000000000001 RSI: ffffc90000bcfc30 RDI: 00000000ffffffff
    RBP: fffffffffffffea0 R08: 0000000000000000 R09: 0000000000000000
    R10: 0000000000000000 R11: 0000000000000001 R12: ffff88800edad050
    R13: ffff8880065f8f88 R14: 0000000000000000 R15: ffff8880066c6680
    FS:  0000000000000000(0000) GS:ffff8880f3300000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000000000000 CR3: 00000000e998c006 CR4: 00000000003706e0
    Call Trace:
     <TASK>
     xennet_remove+0x13d/0x300 [xen_netfront]
     xenbus_dev_remove+0x6d/0xf0
     __device_release_driver+0x17a/0x240
     device_release_driver+0x24/0x30
     bus_remove_device+0xd8/0x140
     device_del+0x18b/0x410
     ? _raw_spin_unlock+0x16/0x30
     ? klist_iter_exit+0x14/0x20
     ? xenbus_dev_request_and_reply+0x80/0x80
     device_unregister+0x13/0x60
     xenbus_dev_changed+0x18e/0x1f0
     xenwatch_thread+0xc0/0x1a0
     ? do_wait_intr_irq+0xa0/0xa0
     kthread+0x16b/0x190
     ? set_kthread_struct+0x40/0x40
     ret_from_fork+0x22/0x30
     </TASK>

Fix this by calling xennet_destroy_queues() from xennet_close() too,
when real_num_tx_queues is still available. This ensures that queues are
destroyed when real_num_tx_queues is set to 0, regardless of how
unregister_netdev() was called.

Originally reported at
https://github.com/QubesOS/qubes-issues/issues/7257

Fixes: d7dac083414eb5bb9 ("net-sysfs: update the queue counts in the unregistration path")
Cc: stable@vger.kernel.org # 5.16+
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

---
While this fixes the issue, I'm not sure if that is the correct thing
to do. xennet_remove() calls xennet_destroy_queues() under rtnl_lock,
which may be important here? Just moving xennet_destroy_queues() before
unregister_netdev() in xennet_remove() did not helped - it crashed in
another way (use-after-free in xennet_close()).

Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
---
 drivers/net/xen-netfront.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index d514d96027a6..5b69a930581e 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -828,6 +828,22 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 	return NETDEV_TX_OK;
 }
 
+static void xennet_destroy_queues(struct netfront_info *info)
+{
+	unsigned int i;
+
+	for (i = 0; i < info->netdev->real_num_tx_queues; i++) {
+		struct netfront_queue *queue = &info->queues[i];
+
+		if (netif_running(info->netdev))
+			napi_disable(&queue->napi);
+		netif_napi_del(&queue->napi);
+	}
+
+	kfree(info->queues);
+	info->queues = NULL;
+}
+
 static int xennet_close(struct net_device *dev)
 {
 	struct netfront_info *np = netdev_priv(dev);
@@ -839,6 +855,7 @@ static int xennet_close(struct net_device *dev)
 		queue = &np->queues[i];
 		napi_disable(&queue->napi);
 	}
+	xennet_destroy_queues(np);
 	return 0;
 }
 
@@ -2103,22 +2120,6 @@ static int write_queue_xenstore_keys(struct netfront_queue *queue,
 	return err;
 }
 
-static void xennet_destroy_queues(struct netfront_info *info)
-{
-	unsigned int i;
-
-	for (i = 0; i < info->netdev->real_num_tx_queues; i++) {
-		struct netfront_queue *queue = &info->queues[i];
-
-		if (netif_running(info->netdev))
-			napi_disable(&queue->napi);
-		netif_napi_del(&queue->napi);
-	}
-
-	kfree(info->queues);
-	info->queues = NULL;
-}
-
 
 
 static int xennet_create_page_pool(struct netfront_queue *queue)
-- 
2.31.1

