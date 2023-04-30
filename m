Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D900D6F2902
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 15:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjD3NPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 09:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjD3NPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 09:15:34 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2066.outbound.protection.outlook.com [40.107.247.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB7E26A5;
        Sun, 30 Apr 2023 06:15:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FttUPltjV0RdnMnw5BP3akgr6owDfq6+bwnduM0TmM2LthljBqTJs5Nu32XfT8cmMCYufLj26DNSxkbuwe5Z0RckDAIbHxeCBIRoWR1A7U74E1ccrtxg8gRUTYKynLC/N0cwFm2+m7xST5fNB1/0VbHToNlT0ku38uT0lAwGnQCRA4450dp3kqNGpBAeetb39GVCRcj5LzW4k15jRYW1635+EKKVPxKarJsAbBgsKnBM25AsnOPUb6kDUfoxounifaigPVQH+h1v6OM8ltWJP+/dCPgBZ02D2r+N4/W0nmNtif8uRlTBGZoWax7+qp00PJsyznrizL1BJS4EbXedcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=odkZ8HfHiza+jKPAfbqnFPQhDfN4CVkAQMeZK2QeXx4=;
 b=kH7o29vf0c0O17qwQAlGXkgM4lE4qMPH+pzxH9VnkxQI2WDngSzH4E0uBdQz9qCd7Ol5EPRDcoes8IO7Juu6pkhKJpJdBDCF1uIhDLXf1+3xUrx1WB3J4LU4hrxDTrMUI1CFYXfFMcvINoi9j+tGok4YHQn0spVR6PmRm90wcreK6dF/s0Y8IrYAAGfi1PUwhaqdrKj06ALf4silIVgvOKEZOjiDd6BL+u6HeWX98Z1jC4TYJkv7p/bYawJRMiRLhqhU3nWQ+KYLanfj5TIROajmB14halAiBRhAMXhXFZbURGCtf9rDINl10kdZ+Q/wv96tJW6FuR8DzmBKGL+4fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odkZ8HfHiza+jKPAfbqnFPQhDfN4CVkAQMeZK2QeXx4=;
 b=Sd0cycgmlAu9ivKdsCQ0DjjTMcAbXfQR9QoAiPdX+1U84ak8QoG/bWLZy7aJbcqovD0nxu/dyjm5D6hKirSyN9DqZUw1Ga26sawNzX7ntfEYBKFT4DbSsSuAtOwROdq+HbJtlep4Z817ZGDeApjbI/QtzMvg7HsedEkSNoC/Vhk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by AM7PR04MB7142.eurprd04.prod.outlook.com (2603:10a6:20b:113::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.26; Sun, 30 Apr
 2023 13:15:29 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::a5ea:bc1c:6fa6:8106]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::a5ea:bc1c:6fa6:8106%5]) with mapi id 15.20.6340.026; Sun, 30 Apr 2023
 13:15:29 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com,
        Alvaro Karsz <alvaro.karsz@solid-run.com>
Subject: [RFC PATCH net 1/3] virtio: re-negotiate features if probe fails and features are blocked
Date:   Sun, 30 Apr 2023 16:15:16 +0300
Message-Id: <20230430131518.2708471-2-alvaro.karsz@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
References: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0191.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::10) To AM0PR04MB4723.eurprd04.prod.outlook.com
 (2603:10a6:208:c0::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB4723:EE_|AM7PR04MB7142:EE_
X-MS-Office365-Filtering-Correlation-Id: 16b0bef8-0f73-4021-9fb6-08db497cf86e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hXM2w5pYxEhvn+bOq/cQOEYlw+Q6qnc/93XLZFlVPQDTcpTdIDVyz4VFCvtLXGDc+eliqthmY1fthjXZTe4zZ8ZBmQVJDaZrQN3eul6w29yLYyqddIgOvyckUEILwlYst1ZGpEaaWeCAiVYNVNBntntl4XZ5CuGqDgcvjkdt2DGTEf52Yu590IE6ph16E1MfogvFKrEbGAYW8V1m7gOQ+B7/gJzgFfL/0Epzwr5LeCe8UYUifvWKXpIzdY1qCbrIlz4zVOYcpep4suGhKnsTZvXATEwhkz9ZYy5VpvjIPr6fPLsPzUjKYkblGK/j98OFtgQT3txQ/28pm4Ggf/VKpNfJJ7CZeNR9ORrNpyqw/8wV/DUmlF7ScJeWe1z8iA5aT8JO68hTaxccNWJ1EKNFya6YXlr8UqMPL4EzbUX3ZaJZLxwEtDYlvVnf+5hUjjkFm6yBL9ZM424ZwYRbFXSrwbCWZyHwxfhJJb4pG1A0YiZgv241QYIJjnaGR3IZTVj8q/oos6QJXp2fYBIuW9bUYWx2L+9Qrbg92RjS9U6wA4rb6i4vqB8+Xp08Q4mEuKvZXN+TSV8WZzBnS1JBvJWP+B2Pbk4Xt4gjNN4LJq6NkrJRHjtQGqJr99YR97BHw2al
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(346002)(396003)(39830400003)(451199021)(86362001)(36756003)(38100700002)(38350700002)(7416002)(5660300002)(15650500001)(4326008)(66946007)(316002)(66476007)(44832011)(8936002)(41300700001)(66556008)(8676002)(2906002)(83380400001)(2616005)(6666004)(52116002)(478600001)(6486002)(6506007)(1076003)(26005)(107886003)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ro8E+mwPuG9JhLh73ArBvdzQD10UpkLpXlcoLWxBfsgcazZdqBrqdZLOshZ?=
 =?us-ascii?Q?Riq6FKL4uyR/F6WxZMADPDJ7t/TqqPbm8XiDSbDZUNsBiT3WIulM2KZRIres?=
 =?us-ascii?Q?ieRTG5WgkPZKmtUWB8Met+EbKYYOx7yMXDe1X6pssXYKhnkDeH5JVPq1aVW9?=
 =?us-ascii?Q?AgNv3sCK2vRthyHxyrQrzMG0qLsD33Mm30SWejCtfyasU4wFiW1o+YPebet+?=
 =?us-ascii?Q?Rulk377kkA0ChM4fu25HvGmeYjMaSC+1iAomFJIlftmG/l47p7DZbuxNoYM0?=
 =?us-ascii?Q?55RM6y6Tp1bH6h+VHV0G3vDm4uMrrWA0LxvxFpBSabObfSdVvwHLOnUZF7pO?=
 =?us-ascii?Q?6zf2HUs3x0rpYnuAt0T/45cPQ2EEGxG5G1U6n7uqyZk4ahNoV9nrjjbSO+ds?=
 =?us-ascii?Q?POez/bT3X+rGrRRXi+tA4M+AsynJl+CIiTUD+FQ8BQiKnEE2CoPbwjEtwY9q?=
 =?us-ascii?Q?fOREyjY0J+I9yYlInWnkG+CgnywKmRWcWMB07BlpNKYjXbLsg+huu5xXRcsi?=
 =?us-ascii?Q?X715E8qzt8Xdmd2v5FBu+ozkoXuhKJLa8UFEwXc+4LAYliYVAuMtTTyIx+5W?=
 =?us-ascii?Q?VOY9dcRLJPNR4MYqUUkPqqZEIUGFMHCFwNHLJXO3NwAJ7z/lJwTSN/aPQlR9?=
 =?us-ascii?Q?RIJV8PX2F/SzEBXvnfFR3izrF7TL3wKWUnZFvotB01P1gJp7KKPC1GffrryJ?=
 =?us-ascii?Q?P0ocX88zCL9D0F9hZpQFE4anuMc7X2ce/+vdKuEHTa9kJk3z68iOi7ia4wMK?=
 =?us-ascii?Q?HXOfJIhADyxcIqc8gkMB0R+T66tG7gi4cwTXqaFERXUy1ltM38pNkPJzu8Qt?=
 =?us-ascii?Q?X1GVLF8wTZMXI3CO6torRmpoOmqHCfzmOrWgh7Putvxx53qzRfofHDQS1552?=
 =?us-ascii?Q?g8wpWuplb4cE8SjDQL6ald3qhG4DGAI58asT2cCbt64lvbbomHBZPIZUPFD7?=
 =?us-ascii?Q?EsByL5p/iLHjpPPlWtkOCfjKv/FlzqaWyetpfqBW5XBL39BzRNrLm8/YJTYz?=
 =?us-ascii?Q?icmhBh+fcSdx9uKljeZHnB3fyZlytmf+MYFs9pHnzKAU7lShVhztUz2yBEOg?=
 =?us-ascii?Q?4/nmNV7sZqXcIdvyZ5891wtYqbz7y+VkRbTKA0NDSk4KPaD/cO0xMSdqWz3f?=
 =?us-ascii?Q?5eJwf09PKx6eTyY+9bbO1oZVHfPh7IAFQhSx5EC2wXxSfStWqX2kBpOS231c?=
 =?us-ascii?Q?7QCsak/ceet8A0QjwpiRPond0nlegXhbwdzGhg/UAv4SFpqN3UFYgyDCtqjI?=
 =?us-ascii?Q?vV3ZSx5jtDBsbAgZoVRatXokDrQ1S28VyOnArKxhCVE3dmq2lFvjtDcR1yg0?=
 =?us-ascii?Q?1bXgF0IJ1gQN6Ey6eSs6V+Mh0FlWwYcHYd9j1WOee9FhnwP6RIK/kZGlVasR?=
 =?us-ascii?Q?cqm7Vo/S9FKjTLld2ziUez0J0TBwe2MzWuMFSUVAX5fBmTPK+7aZStryzo7i?=
 =?us-ascii?Q?9BwrX2OchGW+s5JnLqTdYw60hHK8yD0GB6OBdvrcCoRfYnGp0a8PbAldEmvN?=
 =?us-ascii?Q?cF9BNfZYWD3bWRGKUYhR+UX70MKT2gpM9lbbXR90S63bNj0nLBdeTqvSX3FV?=
 =?us-ascii?Q?gvkwAa5BPPX5L7ny75G3Aej1ktsGhWCgeNghpyE/8lRIr3i4vTo8Y86zx8KW?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b0bef8-0f73-4021-9fb6-08db497cf86e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2023 13:15:29.7749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KhOtNRtHXt4b7rdzP+o8KPj0Y8nGyVd3wie0hsm4+PEI69GK6c07ABlowNcMR0qfqI8T084Fr8D+2LPHjRQC7aV0U7xzKKEulhGmPIEHGis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7142
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch exports a new virtio core function: virtio_block_feature.
The function should be called during a virtio driver probe.

If a virtio driver blocks features during probe and fails probe, virtio
core will reset the device, try to re-negotiate the new features and
probe again.

Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
---
 drivers/virtio/virtio.c | 73 ++++++++++++++++++++++++++++++-----------
 include/linux/virtio.h  |  3 ++
 2 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 3893dc29eb2..eaad5b6a7a9 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -167,6 +167,13 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
 }
 EXPORT_SYMBOL_GPL(virtio_add_status);
 
+void virtio_block_feature(struct virtio_device *dev, unsigned int f)
+{
+	BUG_ON(f >= 64);
+	dev->blocked_features |= (1ULL << f);
+}
+EXPORT_SYMBOL_GPL(virtio_block_feature);
+
 /* Do some validation, then set FEATURES_OK */
 static int virtio_features_ok(struct virtio_device *dev)
 {
@@ -234,17 +241,13 @@ void virtio_reset_device(struct virtio_device *dev)
 }
 EXPORT_SYMBOL_GPL(virtio_reset_device);
 
-static int virtio_dev_probe(struct device *_d)
+static int virtio_negotiate_features(struct virtio_device *dev)
 {
-	int err, i;
-	struct virtio_device *dev = dev_to_virtio(_d);
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
 	u64 device_features;
 	u64 driver_features;
 	u64 driver_features_legacy;
-
-	/* We have a driver! */
-	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
+	int i, ret;
 
 	/* Figure out what features the device supports. */
 	device_features = dev->config->get_features(dev);
@@ -279,30 +282,61 @@ static int virtio_dev_probe(struct device *_d)
 		if (device_features & (1ULL << i))
 			__virtio_set_bit(dev, i);
 
-	err = dev->config->finalize_features(dev);
-	if (err)
-		goto err;
+	/* Remove blocked features */
+	dev->features &= ~dev->blocked_features;
+
+	ret = dev->config->finalize_features(dev);
+	if (ret)
+		goto exit;
 
 	if (drv->validate) {
 		u64 features = dev->features;
 
-		err = drv->validate(dev);
-		if (err)
-			goto err;
+		ret = drv->validate(dev);
+		if (ret)
+			goto exit;
 
 		/* Did validation change any features? Then write them again. */
 		if (features != dev->features) {
-			err = dev->config->finalize_features(dev);
-			if (err)
-				goto err;
+			ret = dev->config->finalize_features(dev);
+			if (ret)
+				goto exit;
 		}
 	}
 
-	err = virtio_features_ok(dev);
-	if (err)
-		goto err;
+	ret = virtio_features_ok(dev);
+exit:
+	return ret;
+}
+
+static int virtio_dev_probe(struct device *_d)
+{
+	int err;
+	struct virtio_device *dev = dev_to_virtio(_d);
+	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
+	u64 blocked_features;
+	bool renegotiate = true;
+
+	/* We have a driver! */
+	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
+
+	/* Store blocked features and attempt to negotiate features & probe.
+	 * If the probe fails, we check if the driver has blocked any new features.
+	 * If it has, we reset the device and try again with the new features.
+	 */
+	while (renegotiate) {
+		blocked_features = dev->blocked_features;
+		err = virtio_negotiate_features(dev);
+		if (err)
+			break;
+
+		err = drv->probe(dev);
+		if (err && blocked_features != dev->blocked_features)
+			virtio_reset_device(dev);
+		else
+			renegotiate = false;
+	}
 
-	err = drv->probe(dev);
 	if (err)
 		goto err;
 
@@ -319,7 +353,6 @@ static int virtio_dev_probe(struct device *_d)
 err:
 	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
 	return err;
-
 }
 
 static void virtio_dev_remove(struct device *_d)
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index b93238db94e..2de9b2d3ca4 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -109,6 +109,7 @@ int virtqueue_resize(struct virtqueue *vq, u32 num,
  * @vringh_config: configuration ops for host vrings.
  * @vqs: the list of virtqueues for this device.
  * @features: the features supported by both driver and device.
+ * @blocked_features: the features blocked by the driver that can't be negotiated.
  * @priv: private pointer for the driver's use.
  */
 struct virtio_device {
@@ -124,6 +125,7 @@ struct virtio_device {
 	const struct vringh_config_ops *vringh_config;
 	struct list_head vqs;
 	u64 features;
+	u64 blocked_features;
 	void *priv;
 };
 
@@ -133,6 +135,7 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status);
 int register_virtio_device(struct virtio_device *dev);
 void unregister_virtio_device(struct virtio_device *dev);
 bool is_virtio_device(struct device *dev);
+void virtio_block_feature(struct virtio_device *dev, unsigned int f);
 
 void virtio_break_device(struct virtio_device *dev);
 void __virtio_unbreak_device(struct virtio_device *dev);
-- 
2.34.1

