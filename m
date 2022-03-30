Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B456D4ECBBB
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350031AbiC3SU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349964AbiC3SU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:20:29 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2055.outbound.protection.outlook.com [40.107.96.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A116D1B788;
        Wed, 30 Mar 2022 11:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=haCkwP18Nad3J21+dsXVyG0mNIHtygyZuYjX8yT4nyo=;
 b=WL7vJpPr9I64NwqU2a5dfNBT+rgf1bir97Szfku88WkYVc5X9HgShDVyVe3m7tpzC5MRs/umqrZAVj1QqDX1K9gCpUpa3a251w2kKIMvN9oT1HyJ432knY4NKIGu5BcsocowTR7cYH/ZfXByHrPd0DZ3/Xo4KBHL2qH2mkG8GRM=
Received: from DM6PR07CA0041.namprd07.prod.outlook.com (2603:10b6:5:74::18) by
 BN6PR02MB2209.namprd02.prod.outlook.com (2603:10b6:404:2e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.19; Wed, 30 Mar 2022 18:18:41 +0000
Received: from DM3NAM02FT063.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::92) by DM6PR07CA0041.outlook.office365.com
 (2603:10b6:5:74::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:18:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by DM3NAM02FT063.mail.protection.outlook.com (10.13.5.71) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:18:40 +0000
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 265D03F03B;
        Wed, 30 Mar 2022 18:18:40 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGxv8l+jHXkEuz9AX6W96HOBH5S1sZH3tL91PT14V0j99xBtxeeamwk6Z0JLLyduI14nDsYKgBKffQj7woh7DQZE5+N4ZPZsw8DkvlA+eaTMhUrsUEqfNtyu9vz6NGuhdpA+9T8kRvWa7EeyMCojJPqgSATsFh4mWNQcIDcDdsG2XP1Ib1myP0o5bYbZSlfWUIOvkF4jJWCLDqttgqoBTovju3SuYBsn4WiLhFnHgGkSsIjtkf0W34KdbNhpcY9sQhunFxS0AMT+7lOsY8D6Dkd3Ab3acoDrLFbFJmKc2XiUzuBlZKfe7vYf/XHHGJAZ/4xDSU2n1HfYHvqg0Fk4CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=haCkwP18Nad3J21+dsXVyG0mNIHtygyZuYjX8yT4nyo=;
 b=bY/owhFz1KiNV6Ml4HgAnOVZ6aKDPo2/lVXSrOYgeZrY0bVxn3znKu7ZDCJFlixd47UmQbUmHx9pntGsYxYzD3LCVjMe9GRdlIAOHuM7O/SHmV1HRg4e2hy6Vv8kNB8/4drY9y030eszS6K7NOMjdmuyhzvZ8ntcKYre3JPzX/Ry1Qp3YKhE/23vZg9FDQAYE1klpC2aP9LHnRbolQAbsU4I1FSftTpdlPSZ3L+4BACnC0AHNM6DccxN5u3niQq4uDauqfU+WPpO9taV2JobpPfD0/3OHqsIoMSs6v8jSDPji2xgIPit21Ww4yVWNsnAg1gWOaG15G8zdiGy/i54DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN6PR13CA0001.namprd13.prod.outlook.com (2603:10b6:404:10a::11)
 by MN2PR02MB6032.namprd02.prod.outlook.com (2603:10b6:208:182::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Wed, 30 Mar
 2022 18:18:38 +0000
Received: from BN1NAM02FT019.eop-nam02.prod.protection.outlook.com
 (2603:10b6:404:10a:cafe::50) by BN6PR13CA0001.outlook.office365.com
 (2603:10b6:404:10a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:18:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT019.mail.protection.outlook.com (10.13.3.187) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:18:38 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:18:37 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:18:37 -0700
Envelope-to: mst@redhat.com,
 jasowang@redhat.com,
 elic@nvidia.com,
 sgarzare@redhat.com,
 parav@nvidia.com,
 virtualization@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org,
 netdev@vger.kernel.org,
 habetsm.xilinx@gmail.com,
 ecree.xilinx@gmail.com,
 eperezma@redhat.com,
 wuzongyong@linux.alibaba.com,
 christophe.jaillet@wanadoo.fr,
 lingshan.zhu@intel.com,
 xieyongji@bytedance.com,
 si-wei.liu@oracle.com,
 longpeng2@huawei.com,
 dan.carpenter@oracle.com,
 zhang.min9@zte.com.cn
Received: from [10.170.66.102] (port=44662 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nZctw-000CCQ-ON; Wed, 30 Mar 2022 11:18:37 -0700
From:   Gautam Dawar <gautam.dawar@xilinx.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>, Eli Cohen <elic@nvidia.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <martinh@xilinx.com>, <hanand@xilinx.com>, <martinpo@xilinx.com>,
        <pabloc@xilinx.com>, <dinang@xilinx.com>, <tanuj.kamde@amd.com>,
        <habetsm.xilinx@gmail.com>, <ecree.xilinx@gmail.com>,
        <eperezma@redhat.com>, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Longpeng <longpeng2@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH v2 17/19] vdpa_sim: factor out buffer completion logic
Date:   Wed, 30 Mar 2022 23:33:57 +0530
Message-ID: <20220330180436.24644-18-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 643f9a95-0fd5-41a5-2015-08da1279b7a0
X-MS-TrafficTypeDiagnostic: MN2PR02MB6032:EE_|DM3NAM02FT063:EE_|BN6PR02MB2209:EE_
X-Microsoft-Antispam-PRVS: <BN6PR02MB22099D514CEAFD4CBE98D36AB11F9@BN6PR02MB2209.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: jS8kHlFKTzzimra0VoeU7hLXRgw8BUwT0rIg7oMpsFb2xt7SITRtRXcaL8OVOBHb+h/FuwPX4LWg0FYK7OUfhzyrY0zSatWdGl0o71VGs2LUVmgYxilkqd+IC03RbEBT3s+ukKe4ERPzY5ZWFM1ez3oO2f6eEL2Mmu095JjIYotzwETGCNbtf6i2t6jjgYhvb18Q4PdxVrwdBvlWseto13KjAhWNsfdeqI+mNA8tSg2cYjY1EQ5hgoHnuULGSJTR+G7kkVTl7c0ar1gAU4P2GpKX3ALEEPmYLAFmfhdFM8SXbVRvD1cB60qmt725Mlfy0DdrgrsSCHrsM/GZRKdayf/Hj+xaXT+RPTFaEDgFH55UAZod+yxJcUKYePrdvRcQLEyxbOMHXQN+ej4Jb5id12MSQytD/XWn9nX8LNcAJfg7AH607sZGFw8Uk5RXKkd579hlvBTz0uCsdf8U/WEIXW3Q4Jr3Lye8F7834iqW66E2GVaVHMCvxKItNFVhJnOb34Hu3KINPEStkoMMykZbOMOgo3eIAJ0W0/58a+v5khX82zXIV2pU3iYKK79OSTTktWfEtBNBNFD7UZ/nGzjqgbvRSrvHrI2Fvhi8SJFGIclevUNVI3WQWDVKlVLnhQ9w3Bwhk4jFOLXEecdKEbktkUZBf1HgBKK91cx8TsZ+f/cCVR+158OGiG9nrjF5WwAbm+iFC1gOodaH0COw7e7pftacHWpXn67mRd9ajwHcurU=
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(7416002)(5660300002)(7636003)(356005)(921005)(336012)(426003)(8936002)(36756003)(6666004)(316002)(508600001)(4326008)(40460700003)(9786002)(54906003)(70206006)(70586007)(110136005)(8676002)(44832011)(7696005)(82310400004)(36860700001)(2616005)(1076003)(26005)(186003)(2906002)(83380400001)(47076005)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6032
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DM3NAM02FT063.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: c0770f92-0c06-4d7c-19a8-08da1279b64a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3h0Rcy29Qk7pr9gG+CwF1L+nrkucY6Dp15+budo+76/KRaym9ywdwnos/oVlzehpHdYYSq3npuPvq3mOhgW3jHRpgbSPV1j7wYsI7j6hrC4Jn3p4osQz+l7euyYvIrIx+0IfGF3joteL32nVJDeKaci0Y3qzEoEiKC2kN/fRTcfDshCyPUOLTs0mN9P0ByXYzN3xlSRZBVo8jpV9L3cDxuJixV8Gi9DKkrZAhTEA00XuholWAPxh5tp2bC+mcYg2SUGXPxC5YdV14S+QTQkzoRksRd2CTEBEiwgPV+1vWdhvCuzwvXconoPhylJ2akDcU0Z48Mm2yAoxy2eb76C2IWKjAHNw/X4FYEL5qA31vn38wGVFkhDRKnX/Dp56ffLSGBFoWJt+JPqaOOhXVkXWgoMvCF8ifqsgslGveqjJBKW9KhQRK7IPUahQpHF+zd9Ia0yyRv6nD16UcwBm2BTuhUwlEAAEsG+Z7I5+SpFVPAxkZLK1DzFBFlcpHr2izxf+wGTvw6Rfc5TnHTuLTDRO8PH8Gby5A8L23g+C3MwVLdP27pUbFbSWwaFLYyAAzJKuJtw7NFbysNELZgPYi2oQiZkdjFLgNvBPmPyO2ZQy7tZLNXFt0okPm7kWHbArR9VCfjpSboaA5M0OXDfPXb6oDr9Hc30plVLnMecnIWabtjnBfqORKhQMmcA4h5aIzOKuKsJFiU6prxzyIbAgHfrc0jQvVfMMSn4kUopYl3EjPgWkGXrWnwDQMhKmOk0B9q2gnM+LTFah212Ln6fD6kGfSg==
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(70206006)(8676002)(40460700003)(8936002)(4326008)(316002)(2906002)(44832011)(508600001)(7416002)(6666004)(7696005)(82310400004)(5660300002)(9786002)(26005)(186003)(83380400001)(426003)(36756003)(336012)(47076005)(81166007)(54906003)(110136005)(921005)(2616005)(36860700001)(1076003)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:18:40.6007
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 643f9a95-0fd5-41a5-2015-08da1279b7a0
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-DM3NAM02FT063.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2209
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wrap up common buffer completion logic in to vdpasim_net_complete

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 33 +++++++++++++++-------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index 2d1d8c59d0ea..f4607172b0b8 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -31,6 +31,22 @@
 
 #define VDPASIM_NET_VQ_NUM	2
 
+static void vdpasim_net_complete(struct vdpasim_virtqueue *vq, size_t len)
+{
+	/* Make sure data is wrote before advancing index */
+	smp_wmb();
+
+	vringh_complete_iotlb(&vq->vring, vq->head, len);
+
+	/* Make sure used is visible before rasing the interrupt. */
+	smp_wmb();
+
+	local_bh_disable();
+	if (vringh_need_notify_iotlb(&vq->vring) > 0)
+		vringh_notify(&vq->vring);
+	local_bh_enable();
+}
+
 static void vdpasim_net_work(struct work_struct *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
@@ -78,21 +94,8 @@ static void vdpasim_net_work(struct work_struct *work)
 			total_write += write;
 		}
 
-		/* Make sure data is wrote before advancing index */
-		smp_wmb();
-
-		vringh_complete_iotlb(&txq->vring, txq->head, 0);
-		vringh_complete_iotlb(&rxq->vring, rxq->head, total_write);
-
-		/* Make sure used is visible before rasing the interrupt. */
-		smp_wmb();
-
-		local_bh_disable();
-		if (vringh_need_notify_iotlb(&txq->vring) > 0)
-			vringh_notify(&txq->vring);
-		if (vringh_need_notify_iotlb(&rxq->vring) > 0)
-			vringh_notify(&rxq->vring);
-		local_bh_enable();
+		vdpasim_net_complete(txq, 0);
+		vdpasim_net_complete(rxq, total_write);
 
 		if (++pkts > 4) {
 			schedule_work(&vdpasim->work);
-- 
2.30.1

