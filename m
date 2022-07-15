Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5FD576989
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbiGOWEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbiGOWDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:46 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00040.outbound.protection.outlook.com [40.107.0.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EA38E4C1;
        Fri, 15 Jul 2022 15:01:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPn5fHtASWxEtWrDtGHmj/PilfMgNA0owgwmNVGPaBEw7MM802bf/6MAyLgFrBfzuF/IcVFrW0VN060VtF+Hlc2f36Hqo5zhA2eUxz7G0Vg9Yd8g3qPOzub9inUE8JEpJ9WVA1Gb5utMxN5g63j2OKEzg/vO98iF7cWAHBaZfX3/7cKKbQB089KGKGz753kk76GLenEfWloZnRBoSkl/dnuMzE5mNDO+cJiWI5sbiCR26WFtqUu4CCmlojZ9sHqU+y19vLuYPFV5Yaim4hE5MBEIdRVK392xfW6tdGAUZ19sSZa8iNzNz/HhXwQ0CMW910tP2Yk7RoHwIoAIm6jOOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P8XFDGC62zD2nXGJTNjkC/0uLCvaGCdRI3Vf97JodPQ=;
 b=bjhk13La4IO6T6s/R6+xpgZ5Q7r5t8ipQt+YWZL7MtnPRUlQMlxPZLi3BKrDLboMa6u/LhkAaBgH/Zr7J5UEygmsMVtGkzu4Q2JqM5r3WtihHGhOtdr2mDZfdXd6E4K5tMj7E4hS2Sv6Ze4MUAPpuCjE779oIspITftBzMMy3yLTxrUmI8lacvWI+vQ9YQVfq0jHQZtylgVorMjdDLrrg2SK/H/7OKprLydd6HpEQtHrMpKyv45yWaJWYb0LM3DhwSMhJ9RkGNI8NC/V0LFWz6B5mPKvDXHxcG6vdMMjkSsqO0UZavy9F095Xu64i7YJtUJjoDhfnz85pfEATBCPow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8XFDGC62zD2nXGJTNjkC/0uLCvaGCdRI3Vf97JodPQ=;
 b=Muwwt1/OFWx5GCo/P+SWJslLfUgR97yUbzLIoyyWiGGMt0GTfcgsCeR+l2twoT/Gm7FcCOn8GgmP71axUYaKHWgiCNrNsH9ykx+Rc3JSxC7iqvq8zwnT3Zs3RkJCbuwW4fHaFD9Q33TkE+VCvIx8s6QK/4gBrjVd6nvhP5H0zfOUhh9cyNnTrDTIZEhr1V3kzBRxNoANKmiqoaTc84EUJXUodoYcDsMH602+okHzGud05J+xYqRrq2Jhb7MhO2MCLIU6IQ4ZODQ52Vz0qgBsTXw5qhDcQGl4EwVm/4mgtGLR4+ChpvywLm/5m6CgPrtakrgREO9i2wIXYpTwQZymDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS4PR03MB8433.eurprd03.prod.outlook.com (2603:10a6:20b:518::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Fri, 15 Jul
 2022 22:01:31 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:31 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 35/47] net: dpaa: Use mac_dev variable in dpaa_netdev_init
Date:   Fri, 15 Jul 2022 17:59:42 -0400
Message-Id: <20220715215954.1449214-36-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0a106fc-0706-4ff2-9c40-08da66ad936b
X-MS-TrafficTypeDiagnostic: AS4PR03MB8433:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bpL6FP0GgAYDDBydnmVxGVXs7pyjgqZbP70U+rZnosbF9WviZNvxoWo3ZFpW8ghD+0upyNaa0XVvgiSXX8vKHnJlaepegvbz+HnpJIpnTDxqSp2VQAkH8qtmrNP07OUMq46oH27AwmOgP7dLp5OV1eqnnVPm/xhgHAMf4JuiDiCdooWoRh1+nf+cA7GdHW5Ebx1rBTEyo39IRZvKz48LXlJQCkTOw+Rdi5X/PVYj0MA+ciVMFuIcblqT2cfUT7eS78lDRROc6S2cYA7TAoDrcYnM6/ciCAtMh51NCoPNPB/3lcFxM9ZGDfoydj2+ZTZ9a87X8x9Mjv1BS25yHubUUApy/74PSE6gm4rXV7f6miUh/thZyrlVXA22NDC15w0AlhocLcw8Mk/5nFhxVOhbybwFS/bimfTd+rtKoh3wPWsbYryMXNAOeuD6tHMlDr0eCA7pDgQREWXtoVBIJlGf8gIAoFmZT46ymVAEOm3R8WHS7CEyGu5sJGZozfqHp6/SOJXvYcDcqrK13b8PJPpfv2NeA28nAHxQhTKkRAEx1tHVOG8og1Rq69ryAs0DKlEZrh4Zzg0B9vy0Zt7ltvA/je0bN3OpX76FrBeIxTfN6Waf7cnxyAeOKJl8E5ylyow4Nn/vQPnmZqCk0B5lBChy/+bJdPbjvGImhxKXwMJGhB2mu5x5XU3+GjhTcvDZOz0Hxyjq7X0H7DoE9NiH4vllRCdfGv+qzf61nKYmls/s63vuK6enP69VkVJS2mVMiJEpQ8popZWmNNhIA+Ymyvo3fCH/QgQnQq8s1e0Y2ACG94WvpEnHwahSTMkqzi83LNfI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(39850400004)(396003)(366004)(136003)(6486002)(478600001)(86362001)(6506007)(41300700001)(6666004)(52116002)(6512007)(26005)(83380400001)(2616005)(54906003)(1076003)(107886003)(316002)(186003)(110136005)(66946007)(2906002)(66476007)(4326008)(66556008)(44832011)(8676002)(5660300002)(8936002)(38350700002)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0KCMGrX+SSOx5LHpbO10T32joajN0tD+9oMjFGkuimUh3gK496C5Yj1UXjz4?=
 =?us-ascii?Q?oXhgNbfx5mfskFobG+RtrNK4bMPx80B95XEpua1S4ZCU9G7oOzQDbCKKPXDK?=
 =?us-ascii?Q?RH0gJA7tTM4Ygm0l0z6hUM6s98lr/2XiOP2padKZBw0XDAGuZWvkWQd6oInp?=
 =?us-ascii?Q?BZJMX1dGnoz36X8HU4ZRTk9vEY0Flenc9eWKc1OXJMEhXhbYWNO+MJFDNvWr?=
 =?us-ascii?Q?mFvywOYJR2VwEj0v4iHeOZjV1L5MR+ytPNelbGb3gCBuMh+WJOO+Ij4CZjdH?=
 =?us-ascii?Q?WqyItM0R+x15b2VLJIwYRYoirXeieVBWggmMXMp7yQyPX9XPp3E2C+Pz38Rg?=
 =?us-ascii?Q?8SBMO4KFQqs+nX19IOB7GRNnlsvgRCAZuxt0r12Qx5n86T2htyrZPr79mBBv?=
 =?us-ascii?Q?XOiEjrudvSz73vpMVG5QLjXMrQTbnO95RkAcLLS0r22JZHmyjWVhzzUdkNV6?=
 =?us-ascii?Q?KNKG22Zh5CpVgPwNcMAWAvkW60hrnnzBCA1wu7oOglGEPwgZ9vG99wY4xCRC?=
 =?us-ascii?Q?cVLWpx18VPU50XSsDHcTByGS1nA8NloKGIfLH7gNZvrIwzcBbrLfZrW1upc8?=
 =?us-ascii?Q?SsyWuXXfrGsRmzz78uZEgRyfWL7XnvcJIen3kAmAqbTbRQ8tvawi2iLXSTbL?=
 =?us-ascii?Q?Qs0bZ7JSpxnuS0zD2wOOhAkQ7lqn3IT7fDbAqmJnchAyzqG6R890s6DUTBEI?=
 =?us-ascii?Q?9HUQMG3y1SvaizhGa16U3t6HdnIijy0peIw+FtOdjJ2nKN5eLbJXWgmk9BNG?=
 =?us-ascii?Q?Fw1pT2e0kTwYRrdFB8olpf/5zTY66sxYlVX+pVCnjZa3mk2hAfxwDnawOhct?=
 =?us-ascii?Q?I2ZBALcfjRwVbbI/Ef1bQ5AhePS0fA52AUVMmaA3hLuh60WUWHdthq02fQQF?=
 =?us-ascii?Q?D4RPQIWKnb4ldPOHYKJXX7YoA1JFKvSzsop4vlVyIFpQsoiKlTFAEd+gllpc?=
 =?us-ascii?Q?G7UjhCw0Rl5obWwSajw3VUmWRG+MdBr4A+CVxUPFLJwVO2SOKfvnYzsMJk8V?=
 =?us-ascii?Q?ntREqrx0ibiXnTrNqiQtrJ3fcHL1lu8AcdR+MhLmPzgzrr5lSdagUm+V/NtR?=
 =?us-ascii?Q?kuHSWj2FX2CuA/F4yCtt3XAQfhgKECJUI6JcW4L6gJSoeBjPEsH7D2o94zsV?=
 =?us-ascii?Q?rzk1tuFl3gFW1+fEhYuWC4Sqi/bQKZAzX5UFXRR/1HtbGVSxiKGyLYOdpFai?=
 =?us-ascii?Q?rnezTk8hmH/IDwgiiD6zPJwNyekSrHKKPDMLfC1Jz9gv3J7K/SVLsQQ5Dr4X?=
 =?us-ascii?Q?3fEdA4DZWpo46t0Q4ufvtiOgoCMYAPFn4rtx9AXDM6zLh4tXIQcNp783OxSZ?=
 =?us-ascii?Q?GfnpxOtPZPjHi5T+zO4OAfEUJX6XVyNAfLZlGvsLFuCa769xozjsGYcGWs4j?=
 =?us-ascii?Q?7weFB8CSSqUsCQ8Z+2DRI1PKWSfTTWL8R8O+wBvqVdIAzHU3Ss/bk4YSIAkU?=
 =?us-ascii?Q?O+GVqYS9LP00Lm5xzY96GrAaLylLpzttngIMKbEU1WqtLiurN8O6K0JGckOX?=
 =?us-ascii?Q?0bIJE1pfyGhTYBDQ7Ir+aApm+LmZTeDA/xfj10ij9bXwmijIKca68dfeccIR?=
 =?us-ascii?Q?P1Y/+v+P35Q0BOh65da61UKEmiESHLA3FtJp6Z/dI+Se6z6fiFU8x+JhkVSA?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a106fc-0706-4ff2-9c40-08da66ad936b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:31.6587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMGKh9qj/CBKugTo33eIo8JxAdgmwrFs13OeJLuDHvMA4zRk8bs9dsIkI9AmVxT3CMOFKaQLleLQoZFtk6DJxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8433
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several references to mac_dev in dpaa_netdev_init. Make things a
bit more concise by adding a local variable for it.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index d378247a6d0c..377e5513a414 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -203,6 +203,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 {
 	struct dpaa_priv *priv = netdev_priv(net_dev);
 	struct device *dev = net_dev->dev.parent;
+	struct mac_device *mac_dev = priv->mac_dev;
 	struct dpaa_percpu_priv *percpu_priv;
 	const u8 *mac_addr;
 	int i, err;
@@ -216,10 +217,10 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	}
 
 	net_dev->netdev_ops = dpaa_ops;
-	mac_addr = priv->mac_dev->addr;
+	mac_addr = mac_dev->addr;
 
-	net_dev->mem_start = (unsigned long)priv->mac_dev->vaddr;
-	net_dev->mem_end = (unsigned long)priv->mac_dev->vaddr_end;
+	net_dev->mem_start = (unsigned long)mac_dev->vaddr;
+	net_dev->mem_end = (unsigned long)mac_dev->vaddr_end;
 
 	net_dev->min_mtu = ETH_MIN_MTU;
 	net_dev->max_mtu = dpaa_get_max_mtu();
@@ -246,7 +247,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 		eth_hw_addr_set(net_dev, mac_addr);
 	} else {
 		eth_hw_addr_random(net_dev);
-		err = priv->mac_dev->change_addr(priv->mac_dev->fman_mac,
+		err = priv->mac_dev->change_addr(mac_dev->fman_mac,
 			(const enet_addr_t *)net_dev->dev_addr);
 		if (err) {
 			dev_err(dev, "Failed to set random MAC address\n");
-- 
2.35.1.1320.gc452695387.dirty

