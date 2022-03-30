Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5644ECB59
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349714AbiC3SI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349755AbiC3SIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:08:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2078.outbound.protection.outlook.com [40.107.93.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8B03D48E;
        Wed, 30 Mar 2022 11:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yvhDDtxMkPbg2jNe02Wu42VkpULzJmgbg7z+jUGBhqg=;
 b=LsbrFve/Y5sdRS1DRnBaSHn+KB9w6b4WyHKzbsX7HyeZ+DG1KGNt+sNxx1B+AF7caTmnTz9tjroEqHUdro3yLXPwF8MIzsIYZmbcxIt4CK33AI1rG7H6A9H0iwEL7+6rmTXEXMsHY0TxHyld5o4Bdsg0LhN/bWUhkppCzquQJmI=
Received: from SA9PR13CA0167.namprd13.prod.outlook.com (2603:10b6:806:28::22)
 by DM6PR02MB6921.namprd02.prod.outlook.com (2603:10b6:5:258::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Wed, 30 Mar
 2022 18:06:48 +0000
Received: from SN1NAM02FT0032.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:28:cafe::14) by SA9PR13CA0167.outlook.office365.com
 (2603:10b6:806:28::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:06:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by SN1NAM02FT0032.mail.protection.outlook.com (10.97.5.58)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:06:47 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 6631741CDE;
        Wed, 30 Mar 2022 18:06:47 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwnw2q7PEEOb/PAB9wfePXTnRyKVFIBeShUJVbPuYN7rCf21MUPfm/EeOlqQw/te7Qh67M4/6ZgBOu31hNQv2Sj3zOrOuXMOgANVrs76nuF5vzJyBJNblSfB61grauxzdKYPCfev1gfDRG+AbpohnxrqJetdkn9csNoJuxwM8BrHGbU1J/vb+a8mNSPCrfU3vb8bZxcA/qLd4vf9izqmo9S6HlllQebTii09qC0KTRxvCzfK8NO5rkXiqtcsTbskvNE8MRnMSQuCfgAClmPw6BUMdonvjCAR8pyTB0q9RzUTXLAv2+2jmo09dhTqhpWDxQ9TeQdyH88ATq7Zi2h+0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yvhDDtxMkPbg2jNe02Wu42VkpULzJmgbg7z+jUGBhqg=;
 b=BCI6yvmMx8ldS+22DYuDJOIc6par8Dbnq5cVeZu6ljIMLBhddcsk4ofLT9c+c0/tsrvVea5gIqq5eTY6vgM7SKimZHW0Q7XsVD43i7US7HkduuO71QtD+TTR6jPhMmfOBsnP0zERxx6uLxL5HP+gPb3YHZtX3eK8HoltZXwlLxVvkt8mGQKbvqrOMxyLZhTyXZKXRbuvxSDG+sOBSoULh3Wb9Xc43ObFNqt2cnjcgjMa5Gl2Frth+wBgGV1MXjwtWQqjPmPI8hq4mxudZmx6koDAyjq9hfjgGU/AzX5UnlkUVmEaM8Nha20rillkTKhFRDWF+QwHkOPn6utUBed4Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN0PR04CA0067.namprd04.prod.outlook.com (2603:10b6:408:ea::12)
 by BN6PR02MB2835.namprd02.prod.outlook.com (2603:10b6:404:fc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Wed, 30 Mar
 2022 18:06:43 +0000
Received: from BN1NAM02FT057.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::e4) by BN0PR04CA0067.outlook.office365.com
 (2603:10b6:408:ea::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:06:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT057.mail.protection.outlook.com (10.13.2.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:06:43 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:06:41 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:06:41 -0700
Envelope-to: mst@redhat.com,
 jasowang@redhat.com,
 kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 habetsm.xilinx@gmail.com,
 ecree.xilinx@gmail.com,
 eperezma@redhat.com,
 wuzongyong@linux.alibaba.com,
 christophe.jaillet@wanadoo.fr,
 elic@nvidia.com,
 lingshan.zhu@intel.com,
 sgarzare@redhat.com,
 xieyongji@bytedance.com,
 si-wei.liu@oracle.com,
 parav@nvidia.com,
 longpeng2@huawei.com,
 dan.carpenter@oracle.com,
 zhang.min9@zte.com.cn
Received: from [10.170.66.102] (port=44662 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nZciO-000CCQ-Mi; Wed, 30 Mar 2022 11:06:41 -0700
From:   Gautam Dawar <gautam.dawar@xilinx.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <martinh@xilinx.com>, <hanand@xilinx.com>, <martinpo@xilinx.com>,
        <pabloc@xilinx.com>, <dinang@xilinx.com>, <tanuj.kamde@amd.com>,
        <habetsm.xilinx@gmail.com>, <ecree.xilinx@gmail.com>,
        <eperezma@redhat.com>, Gautam Dawar <gdawar@xilinx.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eli Cohen <elic@nvidia.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH v2 02/19] virtio-vdpa: don't set callback if virtio doesn't need it
Date:   Wed, 30 Mar 2022 23:33:42 +0530
Message-ID: <20220330180436.24644-3-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 11e8b4a4-418a-4fc4-6e86-08da12780ede
X-MS-TrafficTypeDiagnostic: BN6PR02MB2835:EE_|SN1NAM02FT0032:EE_|DM6PR02MB6921:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB6921D09F2B76C65F83A55650B11F9@DM6PR02MB6921.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: FnNoH6xZgDxz+wrkX5K3pES2GThteypEwrouT2lMdCnuFmBQcQU2Y31aCLhNFZ+2ovl/9dlG/apiwNXXaxWrs38bBr7QrPIR+kZUgB6mFrk1Wz1pPQhpXTWojE74oNMQBbBR3lgxavaeWnBvPVls0gL2qaXuMzp5XkfCBknnHAs/me6Tuc9QOWN9odgElda3KtV5uHPYzM6IRKGMOl+Y4Kpcxt0XLBOT18E4KN8e71TQyK3KLkz9ZPuIF2t+BTb0wZtLsjfSjJmqxvsn4Vx1+/YA2y9WW8LfPLnqjikRzSmnsge32pg6yxrqa1zFyERLoTAWotoT5JnSmfqAStVudLpWrmZRYMWb8/+czH02o6umgt/lvX/AVVAtGjZ5TdkTN9Bq69l6noppUoGEN79o58dEkHkTgvpNuJ3+PSBOSM2QUpIul/I9LcrwGtdBANbHxSTgIHjUmi4kkeTbZGy6fNKWRbPJYtyIUgr/IoLIx4Jkdv+0KNET0SRFRMi8/hphmdzMN9BMUNJzg2HIhNYxU5z1NHLn/xqyAntlJ+OPWvyIk+unlZBizGAmCYKtjFzmILoJ4WH7ojIiaKj3UXqqhOAtgiBdOUFiUM8hMP+puKtPQkd4AQzMFHO0LasqLFugTpUF4rwZ7/LZzQO/CN2O8HZ3sqihWxKsU/Ab50qlG8348PWXPx/JmIxanDWLbGcyqvrREo2SAIf3VrKrF9jR2g==
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(26005)(186003)(7636003)(4326008)(83380400001)(47076005)(426003)(336012)(356005)(2616005)(7416002)(36860700001)(5660300002)(8936002)(9786002)(4744005)(44832011)(1076003)(8676002)(70586007)(508600001)(36756003)(2906002)(7696005)(40460700003)(110136005)(54906003)(82310400004)(316002)(70206006)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2835
X-MS-Exchange-Transport-CrossTenantHeadersStripped: SN1NAM02FT0032.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: b883bca1-1a78-48d7-47b2-08da12780c48
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /tZHUzJbldErK1z+HdaJKNO4gyiVhxFZGaSaU1yAiWWABe4DfTlcFlafIbITPeXrnhaKDq9S+RdRqZ/45saFgvmpeZMLeU7zzPnjoRQ1JmuR4R2AgLuTDtkjNPjXIsuHiYmkThlTXp2/ZFWed7VK/ftdh2Eua5ou8TXl7MXSq9RhX0VnvCEjq+I9Z1o4rWSMkdXXeZYZin1VY8/+luVzww98P6akofjZNcHQBEcF3smUdxjg51KDVRKZKX5ttYxWhdZz22Dy4DkBvgQAcD0UToth6yIIPISStrtJ5yzsTg9dzS0n99VmIjSCx1vMHz2Xb1AhXuYjvSWlSO1tIMlIgNci2HYK0Zrs7JdkEmPYQ8xMe8fG4AclTANu+cMnBTknv9nYsRJkqkLxwbaPv55YtVtsdzU8NoOMM5QDxaD8Xz+hLCfW3qmqzGACTXfFKXs8ksFatBQ2ewyc0ra6o6ogLLlzUUu0rYXxk4zCoOcKAQiAEAVDnkSbiG+mqRz17nXS6wIriK1iK9S5cr1nxrYUjqB5xvt7TpqUEpKHBAjMwYT9d/RuFEmvFaU6VndpopQrQt6KkgHacFNHD0GoYyfwm3N0k3eP7qE4Zv2LK/rQHJ0QtVvo9ALKBQAX1ITiIG6GaBbak3+hiJa8OMKfOa6/0ojMrVVbipU3AjBuTl1AG/9KcxQFNkHB+bn1LKBZxpVxyIcf7pndH74bA7lNfMH9lrirjswvVkTy2zFW87JAGGM=
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(40460700003)(186003)(26005)(83380400001)(36756003)(426003)(70206006)(81166007)(2616005)(1076003)(336012)(9786002)(316002)(110136005)(47076005)(8936002)(5660300002)(7416002)(4744005)(36860700001)(54906003)(82310400004)(2906002)(4326008)(8676002)(508600001)(44832011)(7696005)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:06:47.9774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e8b4a4-418a-4fc4-6e86-08da12780ede
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-SN1NAM02FT0032.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6921
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no need for setting callbacks for the driver that doesn't care
about that.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/virtio/virtio_vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 76504559bc25..46c71653f508 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -184,7 +184,7 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	}
 
 	/* Setup virtqueue callback */
-	cb.callback = virtio_vdpa_virtqueue_cb;
+	cb.callback = callback ? virtio_vdpa_virtqueue_cb : NULL;
 	cb.private = info;
 	ops->set_vq_cb(vdpa, index, &cb);
 	ops->set_vq_num(vdpa, index, virtqueue_get_vring_size(vq));
-- 
2.30.1

