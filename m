Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2946874DB
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjBBFBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjBBFBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:01:30 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98CE9762;
        Wed,  1 Feb 2023 21:01:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJhoV1cBJPnoK+FZsMN2gbkudKaQwKpoyE0mLiAjH8N4KNe38yhuBS4WJqSxeRMsgHyMmpp5A28jFdsjhKQizxDx+tZq/YARGs/cCtE8Do7frUMxnfYl2DXMaNbhqWC2hb8ueQE6Q5fLvnhvlsnVs/UBZ6QNZPdsDWrSSZJJ5dCFk9E5jog7zhkzlQHUqMtl73KReGFnWEwnoN4RyuQEWFK3A3DSa+L3QOGiYXUrvwTvDzVxRjFGvidYb+A1JAUQtpZAifnphR6MD1VOaofuYBf8akk2FSWrexYbF5Eyk50O+Z2+j0oecppdNrwSqF/QJmGCnHYuMQS5uAJz8h8CQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZSerDRDYu7C0LTnbh4GWzDDDhHgoKlloW/f/fAH1lmY=;
 b=M77KWS1sS9VomifxhpHw1jKkvQApjqwRTMA7U+Mg1X2MfiVtZHhu9+W0Pe/AqfneLoai28QnW2JX64jhYjHEUQv4YMWXqPpFt9NLgdD+RTw47/wcYqBvfWOFzm4Dlw257RR69ph45Khr74vihjjkaZHRnDPl9nG5G6hpg9UC8qCfloQqOQeRftEfY6Gdw0p4DmzEINT66jxWTsM7ZhS6xwg8gO9hg4HVVCq4mbvHl0S5cCZSqh1YxxhrqT0fxW75kzffMZHGYLZdessTp4YDxqTuRvuQfdu/N0RnLBvQ+cUHDSrXSJ79oUX9Lzvdo9/QYWz1CSZGGQ1baib8uCbwSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZSerDRDYu7C0LTnbh4GWzDDDhHgoKlloW/f/fAH1lmY=;
 b=umpUHJY2/0zq98hIMd63cQVjJSPf1/+xf3SuPgi0V2Nck2aqk4aLP1XmdSahKtWYWm8Ek3S6Fbe8bFP+ZubEBw/V0hJOmVGiEMqjMcWPmzPfKeq/sZlgN4SfpjlgPwnIN99C5RjIDDUp2ruP49Y0h6OWRhFMBaBGIxMYYxjG7TnF8R7cqn6ew0Giz9HDxwegw6LjlYbhCKvMtvX2kqsBaz72UgvNwiHgjduQUaHBzQDB/MEpYh02sjzr+4D1pIlI3YnLAoxEnE9jS273csq6D61LDoRCr6gm3YiHQZbv9gNiBj53ROaLMACllf4AZquFYEAogWKbitEsJrXkj/d6vQ==
Received: from DS7PR06CA0032.namprd06.prod.outlook.com (2603:10b6:8:54::17) by
 LV2PR12MB5944.namprd12.prod.outlook.com (2603:10b6:408:14f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 05:01:11 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:54:cafe::11) by DS7PR06CA0032.outlook.office365.com
 (2603:10b6:8:54::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Thu, 2 Feb 2023 05:01:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.25 via Frontend Transport; Thu, 2 Feb 2023 05:01:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 21:01:00 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 1 Feb 2023 21:00:58 -0800
From:   Parav Pandit <parav@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>,
        "Parav Pandit" <parav@nvidia.com>
Subject: [PATCH 1/2] virtio-net: Keep stop() to follow mirror sequence of open()
Date:   Thu, 2 Feb 2023 07:00:37 +0200
Message-ID: <20230202050038.3187-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20230202050038.3187-1-parav@nvidia.com>
References: <20230202050038.3187-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT060:EE_|LV2PR12MB5944:EE_
X-MS-Office365-Filtering-Correlation-Id: 4da7354a-96ad-4375-b385-08db04da80f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +iljATCJdZdcN7mukaC2Af2ELd9E+kvFo8zRB9VeWWH/fzoyQJZ8yfm71uj9u2xwQ4SyPsvl5VwlB/oOEBN/QlGiBC3diSGFWOlIaLrNKbSfOTbWf/rtILe2huf1vRIj1CtKcAoYdPMMnQ8eRs8rCUBfZ0GPzlWWZFfQuAe6yuvWnOZ/1bi0paGXye/416bv99e1sEJO6RNgkQ7DvHpJMN+QYe6UZdSXLbhGwP+p2+PHOYP/Mw/wVaVMfTjpZjicNbqOwvMcDBEZGHPswsKifLbtBkeOB+62E1cbmOc1JRD3Wi75k8ARXOu4acEPdm+AwYVBsB32heehJbYyc7BZDMiIRxSrddsDGx9TZg8c9FniL+l19hdL05j0VudRYZhnoK6KhTz7BE0zXi7jKtaeyvcLdUBv36x61AFqXQ2C34Jugl4g+/RM9j/GA3Ju//N7tq6tmkm9rWhTnkIsbIxH3idklS3myMEMcbvfTN8sBTkHo5x0bFja7AuQ0klIcT7jWG4z5D6K+CRH4Y1PsaBckrt1LY9UFqpmQpxipDj6ExFjR7/OUhMRYJxWbTc5PrIJyfykuqORych+G85VbbLavnPOaIAz3TOm5BzihZWlFI07gjiRzIBh9OcUD1m/mN8G+rSQ9ya+4md5Nbv3RimhDmHqabB2M5ryM3bjg1NZaOYwt7jAKASb+7mRgE/6tM3XfX/0ZEJ0PV0I7t5wZ+PyEA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39860400002)(396003)(346002)(451199018)(40470700004)(36840700001)(46966006)(2906002)(4326008)(41300700001)(8676002)(70586007)(70206006)(7416002)(8936002)(5660300002)(4744005)(82740400003)(7636003)(40460700003)(36860700001)(107886003)(6666004)(478600001)(40480700001)(2616005)(356005)(186003)(16526019)(1076003)(82310400005)(36756003)(86362001)(26005)(316002)(83380400001)(54906003)(110136005)(426003)(336012)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 05:01:11.4421
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da7354a-96ad-4375-b385-08db04da80f2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5944
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cited commit in fixes tag frees rxq xdp info while RQ NAPI is
still enabled and packet processing may be ongoing.

Follow the mirror sequence of open() in the stop() callback.
This ensures that when rxq info is unregistered, no rx
packet processing is ongoing.

Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7e1a98430190..b7d0b54c3bb0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2279,8 +2279,8 @@ static int virtnet_close(struct net_device *dev)
 	cancel_delayed_work_sync(&vi->refill);
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
 		napi_disable(&vi->rq[i].napi);
+		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
 		virtnet_napi_tx_disable(&vi->sq[i].napi);
 	}
 
-- 
2.26.2

