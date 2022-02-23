Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27C94C1D97
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 22:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242535AbiBWVVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 16:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242572AbiBWVUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 16:20:44 -0500
Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3164EA0A;
        Wed, 23 Feb 2022 13:20:15 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 19BF52B001F4;
        Wed, 23 Feb 2022 16:20:14 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 23 Feb 2022 16:20:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=FgfAeo
        xPVPg0MdvPEZQn4ZDYWo1iiSPBcOv7dVpbcZk=; b=bUT6caj46S8Y5uir73PdHp
        VeSZBsQs2ia89NwbEoWUE5jKz56+1HvcKMM/1Xsok9Wu9Uv2ZV/HQK+EAjwN8ID6
        BB39M2IyVs4stGSP4TGQpviphhzW+pGgOP2t88/SvuoW5ewOw2GGN+6/tOs0HZfb
        lzKPzsz+mnAOLCLetL33TYLnAq+UIzmNVkdr7ZAcQlcvyt/khgC1pd6hjNtUXdev
        DHGk8AekGNQspcmrhH2iX1WAQbI25PhOYOr31Qn1dS+W8AsU9q9nORUgcT2zpOx2
        09hOTMHJulMFQKWK3JGTPGJa60Mw2FrX3hwi81rLy1IwVFb3A47UkV0K9JUFvVSw
        ==
X-ME-Sender: <xms:DKUWYrQDmdgl1gpXMU3457DPpHxOUl1wg7J6gGapJ1x9PcmhAexRlA>
    <xme:DKUWYsxnYHws0m4VBnlLmVdJNgglXhp4FNjNWxnsxDuzfXc_qQH3NllqcL6Yxcj3u
    AQGSx0sdU31wQ>
X-ME-Received: <xmr:DKUWYg3SvSGGUK2sYsq46aFBlnA8ZPuSG2Vzh4Eyb724vYl_ihPOFs4dq2-3B9IjEXrZRggSba7uyMaZdAwJfh1k4wQynOD3f70gSzpohGZGm2cFoFY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrledtgddugeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffogggtohfgsehtkeertdertdejnecuhfhrohhmpeforghrvghk
    ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
    hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeegvdef
    hfdtgfekfeevteekhfeivdeuvdejffeugfegfeffvdeuffevgfeuleetheenucffohhmrg
    hinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepmhgrrhhmrghrvghksehinhhvihhsihgslhgvthhhihhnghhslh
    grsgdrtghomh
X-ME-Proxy: <xmx:DKUWYrCJaRde3MQNUsM2eZENESX8A3l9HQB4-NSrF5Ut0L3IvOJpYQ>
    <xmx:DKUWYkiEJ5R_OHhlHmL2V4YMRZeerA2w10C07gzVEfkCLBAtow9DtQ>
    <xmx:DKUWYvqe8nh36FCPyaRt8mNUaB1tqjWKMKKAvNwpm-4DH300mYx_iA>
    <xmx:DKUWYtVXaVIq97oididxrnUJGFMTCH8n8pFWDolQ2SbS1TnseyLocA8VNQ8>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Feb 2022 16:20:10 -0500 (EST)
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
Subject: [PATCH v2] xen/netfront: destroy queues before real_num_tx_queues is zeroed
Date:   Wed, 23 Feb 2022 22:19:54 +0100
Message-Id: <20220223211954.2506824-1-marmarek@invisiblethingslab.com>
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

Fix this by calling xennet_destroy_queues() from xennet_uninit(),
when real_num_tx_queues is still available. This ensures that queues are
destroyed when real_num_tx_queues is set to 0, regardless of how
unregister_netdev() was called.

Originally reported at
https://github.com/QubesOS/qubes-issues/issues/7257

Fixes: d7dac083414eb5bb9 ("net-sysfs: update the queue counts in the unregistration path")
Cc: stable@vger.kernel.org
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

---
Changes in v2:
 - use xennet_uninit, as suggested by Jakub Kicinski
---
 drivers/net/xen-netfront.c | 39 ++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index d514d96027a6..039ca902c5bf 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -842,6 +842,28 @@ static int xennet_close(struct net_device *dev)
 	return 0;
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
+static void xennet_uninit(struct net_device *dev)
+{
+	struct netfront_info *np = netdev_priv(dev);
+	xennet_destroy_queues(np);
+}
+
 static void xennet_set_rx_rsp_cons(struct netfront_queue *queue, RING_IDX val)
 {
 	unsigned long flags;
@@ -1611,6 +1633,7 @@ static int xennet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 }
 
 static const struct net_device_ops xennet_netdev_ops = {
+	.ndo_uninit          = xennet_uninit,
 	.ndo_open            = xennet_open,
 	.ndo_stop            = xennet_close,
 	.ndo_start_xmit      = xennet_start_xmit,
@@ -2103,22 +2126,6 @@ static int write_queue_xenstore_keys(struct netfront_queue *queue,
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

