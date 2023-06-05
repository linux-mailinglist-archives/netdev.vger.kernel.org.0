Return-Path: <netdev+bounces-8207-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B9327231DF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:03:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5ED761C20D61
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE107261EA;
	Mon,  5 Jun 2023 21:02:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9839323E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 21:02:57 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5395FEE;
	Mon,  5 Jun 2023 14:02:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kgiuiu32p7f7vx0ZvO6Cj0jXONqR3E9mGlKSnMJsf5rN08MZUNWjxd1eAO0qJuJCoixhUz+pDE4g8nuscJgntSZOJpquLOkSHG3U88V4CWaDwLIC1JPHj1pVCPQRbBBUp/E3o3oGnXACBkNHzQG3tooBHvqbdDsQkPcBwB+xiZznDuIoGznTZ71x0eyVVkHEdBvwH3vfrR63w1GbsrmA0EXZFCF2mtM3hu8yXIYdbp+Yo+75bfRNKBwIC6qGaJnZrz/+uzi2hRmIWoAmyyUjG9wCFZIRpYmHvMWqIJTelkkWt4zye+KXqXdiewE80TNmK094gy6SFhy1+Wy+4KypTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCDFlm4mgU1SCuMik1qhSnoLJxenSA7DFJawM2C+UZU=;
 b=G4R1IVEOUD/ji7PbtqBYWPrU/CJDvJYjeQn3xm/KdtYLI7nNyuGe/ktqlDPZHcy2yqlu4T6vNMfzMNulSLZqgCWJfP8HiHzytBBRkd+PeWTNhyWGOarg0by17DDICSUQeFVeLSTNOdy+uxFnR7f0V5hVXebPc5DOOvAWRaPeDcJ55fwQwksTP6nMoG4YRMwQue+t/G6yBz6WM8SyUhm4hvyKi8pXC0ra+nEVt2OR/iXCLOr03o+2T+phiiwdQuKuZZh8zjFzyCOR0pAlbv+aeRaoxacVzkzyJkaPcAJfBLAaYqCd59yacAurQGYaEdGcNeNYoY0xXFL/R5aT1Ov0Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCDFlm4mgU1SCuMik1qhSnoLJxenSA7DFJawM2C+UZU=;
 b=PWlJRyfiNT7Y3Va3jT9A+1SPEMyVOyGP7DzQgj7Zw152Wgy6YHTPbBPsRTr7li8ekQ37wciEktIHtAQMs2l7uyi98w8Nb6zH3aUCfM0jc6ijToT/yQFQhZKs2rKBfBGrYipRsHbfthD/xXDG4McvbV9LVBj/cM85dhk7q7uMkLE=
Received: from DM6PR08CA0010.namprd08.prod.outlook.com (2603:10b6:5:80::23) by
 PH7PR12MB6978.namprd12.prod.outlook.com (2603:10b6:510:1b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 21:02:52 +0000
Received: from CY4PEPF0000EE36.namprd05.prod.outlook.com
 (2603:10b6:5:80:cafe::81) by DM6PR08CA0010.outlook.office365.com
 (2603:10b6:5:80::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Mon, 5 Jun 2023 21:02:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE36.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.13 via Frontend Transport; Mon, 5 Jun 2023 21:02:52 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Jun
 2023 16:02:48 -0500
From: Brett Creeley <brett.creeley@amd.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <alvaro.karsz@solid-run.com>,
	<pabeni@redhat.com>, <kuba@kernel.org>, <edumazet@google.com>,
	<davem@davemloft.net>, <xuanzhuo@linux.alibaba.com>, <jasowang@redhat.com>,
	<mst@redhat.com>
CC: <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [RFC PATCH net] virtio_net: Prevent napi_weight changes with VIRTIO_NET_F_NOTF_COAL support
Date: Mon, 5 Jun 2023 14:02:36 -0700
Message-ID: <20230605210237.60988-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE36:EE_|PH7PR12MB6978:EE_
X-MS-Office365-Filtering-Correlation-Id: b0e932df-8954-46c0-5a3e-08db66083a24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UcKMaLgz0ojVSk6MUDTJAQVmHi3vWN4o37gWSjdp3OlJZqWtqML7uISJNjbVEo95NmzEq24iiywJcI+SccWw9uW403LQMRHRQQg8gWvG2L4lXVqtSPRcJl3bf+zXdFo41iNKtn335foIgDto8tPO7p9QKniGtirHMlVvlZMuCzc9ycqhnIWgrtw1M+WipPTwKtZ2FFw+AlE1OAV9yH+7fA5g6A1YVFniLVMHf1PVZi3MB3H9TF0mqsmrAcERzkELy2fRqv6Efluv0gT0WOihBbjlFEw34WYegPFQzL0lThnRVd+G/0Cn54Yg7SHwYMAdMtNPgCnjaNwjSe2m33TGu+8Dnag+6BUMn1UMDLNvzbUCLpBdl5hdTpYHTH0U0dX+E7FrslSElxaDVeUJUwXDqQCU1wSn6cmq9z8mSF/FQ0jX1oeX9EmdL7PxqCA8FXE8bvpp8XG4nzkizVs3m9x6M2PLMBNCy3PjQcwllw9sp+p5kHre4F6mwmpdmTJgwCWt4Z2jaiEkhMz5au6vfop3zXlBOI3PZXh2oW899hxXFBryxp3KMvSGKnoXXMYeSTocJ0MOvI/M++UDiy5EUXAk4kuw8A0IT+ZRZyltrRVPl6X7bZgvJ9QxB8HQlh3Lz4j2o4iES2UobI0cZrOMPqJQXWpHQUPz0LEXUAsKecBvp1VUxB3x9RlhE7xQBgtqY19RakywcsmnUL29pjr164+F6hqu/IXPbkv+/X4FLO+ymtWJsskShtMJJDZzOdSN+q2tyEySIz3rDALvL+Fl6tut1odr3nTevGV5OozkCTYNpTYOct6CGQ9/xXvY5aia8sjo
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(8676002)(7416002)(4326008)(5660300002)(8936002)(70586007)(70206006)(316002)(40480700001)(41300700001)(54906003)(110136005)(44832011)(40460700003)(2906002)(478600001)(921005)(82740400003)(81166007)(186003)(356005)(1076003)(26005)(86362001)(16526019)(36756003)(47076005)(36860700001)(2616005)(83380400001)(336012)(82310400005)(426003)(6666004)(16393002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 21:02:52.3195
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0e932df-8954-46c0-5a3e-08db66083a24
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE36.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6978
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Commit 699b045a8e43 ("net: virtio_net: notifications coalescing
support") added support for VIRTIO_NET_F_NOTF_COAL. The get_coalesce
call made changes to report "1" in tx_max_coalesced_frames if
VIRTIO_NET_F_NOTF_COAL is not supported and napi.weight is non-zero.
However, the napi_weight value could still be changed by the
set_coalesce call regardless of whether or not the device supports
VIRTIO_NET_F_NOTF_COAL.

It seems like the tx_max_coalesced_frames value should not control more
than 1 thing (i.e. napi_weight and the device's tx_max_packets). So, fix
this by only allowing the napi_weight change if VIRTIO_NET_F_NOTF_COAL
is not supported by the virtio device.

It wasn't clear to me if this was the intended behavior, so that's why
I'm sending this as an RFC patch initially. Based on the feedback, I
will resubmit as an official patch.

Fixes: 699b045a8e43 ("net: virtio_net: notifications coalescing support")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
---
 drivers/net/virtio_net.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 486b5849033d..e28387866909 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2990,19 +2990,21 @@ static int virtnet_set_coalesce(struct net_device *dev,
 	int ret, i, napi_weight;
 	bool update_napi = false;
 
-	/* Can't change NAPI weight if the link is up */
-	napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
-	if (napi_weight ^ vi->sq[0].napi.weight) {
-		if (dev->flags & IFF_UP)
-			return -EBUSY;
-		else
-			update_napi = true;
-	}
-
-	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL))
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
 		ret = virtnet_send_notf_coal_cmds(vi, ec);
-	else
+	} else {
+		/* Can't change NAPI weight if the link is up */
+		napi_weight = ec->tx_max_coalesced_frames ?
+			NAPI_POLL_WEIGHT : 0;
+		if (napi_weight ^ vi->sq[0].napi.weight) {
+			if (dev->flags & IFF_UP)
+				return -EBUSY;
+			else
+				update_napi = true;
+		}
+
 		ret = virtnet_coal_params_supported(ec);
+	}
 
 	if (ret)
 		return ret;
-- 
2.17.1


