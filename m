Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EEF4ECBD5
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349981AbiC3SZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350049AbiC3SU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:20:59 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065692DD55;
        Wed, 30 Mar 2022 11:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJw3odgIIm4wktl69JEsN4AFSv2MdB7sBlfl9Y7IHTQ=;
 b=XAiaRbE6aWg481xuOPWHEv1Ika/3P8UCGsjcDEvlrIQ5QVSg/2iNaOnKVobcJmnclUPozhy3fqy1daauniHbui85zjmfGkU1mRHFdesw87vKiKyyklHyOaSorI0P1mqscBfBipoB4gP6dLH4iZAYH4jHeywXyZQpKW8SacBgZJ0=
Received: from DM5PR15CA0037.namprd15.prod.outlook.com (2603:10b6:4:4b::23) by
 BL3PR02MB8018.namprd02.prod.outlook.com (2603:10b6:208:359::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 30 Mar
 2022 18:18:57 +0000
Received: from DM3NAM02FT012.eop-nam02.prod.protection.outlook.com
 (2603:10b6:4:4b:cafe::4d) by DM5PR15CA0037.outlook.office365.com
 (2603:10b6:4:4b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:18:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by DM3NAM02FT012.mail.protection.outlook.com (10.13.5.125)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:18:57 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 91BD541D82;
        Wed, 30 Mar 2022 18:18:56 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9/PXX76sAqIyCyyJnjxPx+TKl/QbO3CwkviFakIIHaqlPdSYOoqxbHvEjFvV9fdDMH5lsujk5gqnT4e1kTQkvGur7S7U+TVRbSe9rx75rB+abqKYVpBvY+i68LmclyNFoJ4BF4+SJFTQT4K+QrZy9CZX/1pOqGOK5vSizahrExWXoAGNT96fC0f43a3GNHD2cuOak9og6YC4O43Ub5wI2kA7BWfqpxb7qbzCRyUnm85PylAaa7CV0uQ6GdbJIAIn7wApg/MlETTFkzPsrs+t4XkuveXT7lAsWnawk3EqeZDRWezxy3g8nm3SLi+Vx7pSZnu8euqPkX6DH764kcjww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xJw3odgIIm4wktl69JEsN4AFSv2MdB7sBlfl9Y7IHTQ=;
 b=mIzfAr1fbNIl3opj30MEu72Dz3KpCdG341UV7kYrFWWdCd1T8bMOgejwnl43GGUqXHs7cnf0ULve8XxRzGkN6V4ObsRPAsB3p71kHsPM6uAkDlGXiFsuEU2LOvojn8FCywu5i7dt/DnMNdsM1659/pswmxtuekJOfrggZ0MlZe3ab+TO2T6i0CQ0k95KHOeK1NSqbbEXO0feXuZoPrrGYv9VCzA0r3qjqR6MRJYTtD1yZoBlj8WGhhYtPcbVquyBml41h3CkbdUOo/zvTikWdpC/5PcEd8MiFeffTUe3RFu+nJpnABb9EXmGwigSz4AMtgw7HNHDTRxSU/tko38ngg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN9P220CA0025.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::30)
 by DM5PR02MB2571.namprd02.prod.outlook.com (2603:10b6:3:3f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Wed, 30 Mar
 2022 18:17:55 +0000
Received: from BN1NAM02FT008.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::7d) by BN9P220CA0025.outlook.office365.com
 (2603:10b6:408:13e::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:17:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT008.mail.protection.outlook.com (10.13.2.126) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:17:54 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:17:51 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:17:51 -0700
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
        id 1nZctD-000CCQ-B8; Wed, 30 Mar 2022 11:17:51 -0700
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
Subject: [PATCH v2 16/19] vdpa_sim: advertise VIRTIO_NET_F_MTU
Date:   Wed, 30 Mar 2022 23:33:56 +0530
Message-ID: <20220330180436.24644-17-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 8e0ed0cd-8855-4a77-e804-08da1279c173
X-MS-TrafficTypeDiagnostic: DM5PR02MB2571:EE_|DM3NAM02FT012:EE_|BL3PR02MB8018:EE_
X-Microsoft-Antispam-PRVS: <BL3PR02MB80189B844E01AABD2070EC81B11F9@BL3PR02MB8018.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: THz0EbVUgHtl7YBV348Ixyr54sT45F3yW9ZZYZrr0cnRFv4/6bg5d28WyZAsxLEzVcpq+9toT05UaSlR0nGqao6sR58p6Ey0Y8afSr3+42HZce9xXfBZKIfidlnCEhb9NbzTFGnNZLEUTRUxS96YLaw0s6hR0wF7uxFQZhBaiGPnYas15BKhUNGdwlJoT0WTw9DLggS47L31u0tzzkOvZRm2xyA9/2+G3VVO6N5t9Zebi1fUInRK6hwdtQCAv5bxc27G6Q6TVzTrcXHgknyA5JZ12vPNSRgXp1tidp66VtPks8kso+UXE8mnHtYtrrMxaY0pzgiBPyRFvrnZhYgNuwvEIh1/UVtdbFGlrB5XvaaORESgZtFFqfGBNA6Ya2tkPU3hgnWo9ErNDi8jBb23rLOi1N9vVAI81ec74WuCjLTyJiztnHmM2G4i5/C+MZSN4nP1Pl5RNjv9TlpBvI9sKPGmvVfkIXTDUN8KtICQDnetJnU30ao8XVVspeN3B1b72/IXChLGFGDLroxSwcl4qNwJ0S8hp69eChoLgiWA46YYEJ4ZhLztSuTqR7pdEbQiKEvQIbJesnLnKY8bsmzU3sGD6j66valribcoS6bct1gDvyJihIWkeWJ72XbNaGUrqYb+uzLC97B8JY8EGleaNT+LsE/cG1G5bxKQceftPprnnF8F0pJ4eUsyQV5LPMs+o5Z6BC5a8u4jPH6CSmNGhXAkPH2ApGTR685e8IroF6o=
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(5660300002)(9786002)(1076003)(7696005)(186003)(26005)(4744005)(82310400004)(2906002)(44832011)(8936002)(2616005)(7416002)(508600001)(7636003)(83380400001)(356005)(336012)(8676002)(70206006)(40460700003)(36860700001)(426003)(47076005)(70586007)(316002)(4326008)(36756003)(54906003)(110136005)(921005)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB2571
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DM3NAM02FT012.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 083a709e-5c02-4323-9783-08da12799c3e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GTEk/1DzgoTJMMWLrudaIhsDaw3fDRvo9oW/kLLkuZSC0mJYDcST4EJpyfcTGjye3pag9gpIzvt4Ya58GQLyvhWALMACnVb+Hwj6kQVdvurC1lT1sECHUGRn98MwO4Ka2oMp9CKRXwfqroLYR38fNd9ttbriKdqz0hjDBDwIhNmoazs6xzvpMGjZVLd6RhHoB9L4EcQNVCeMoztjZ5cdXlQyqwzMcOEIlM9dNWfK80DFSn3+dJEYbvR7SuiX6I3eshidj6ea09/b9ZDmkegRVqQviffyy9eXkdEcnwNISUzARJXqP7EwHFEodYScscS14Q0i8SL5W3qYMdtzvgC+riU3/8upGppgquwmmCKho8AXURcmDckC4ESylEYKMU1Nd7CR7BFQryL2Qh/4aJ3I6cSfijEWfL7vyr4TDOgrMaGurdhHyCahOxkREhDHYgTFUv8XTPa2cxCuMSyt2FtpMN5TF5e4Bn4tdPvH04vDxRBbMBD4PnjvYe3scaniUQUMGxEQNSp1G6WJpEeMxSbomqpRBLKgIvzcjo3z5D6LU2hfqQI4lLYHgDTG5ba4bvJfgkf7PSE0ngJftczwEprXW3/P9bWtfr9tV+ZPI/4cFgjkZlOYTPIpfanAX9Dp19iLhQH9/7Z2pReWBxqQlr1Oamaoz2jKxvhxJUCeRpr8y0i40Lj/6+YCaJhF+QZaQD2Ur0yQvkUD/7iN15i3K2NZhoBV/V0KQUiqOUDpMG8LbUMoJNJbuc8oDlN5tSuSBKQb2ljaQfnzocOekUS1kzgV7A==
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(7696005)(44832011)(8676002)(83380400001)(36860700001)(4326008)(82310400004)(1076003)(26005)(186003)(336012)(426003)(2616005)(4744005)(47076005)(2906002)(70206006)(508600001)(316002)(5660300002)(110136005)(921005)(81166007)(9786002)(54906003)(36756003)(7416002)(40460700003)(8936002)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:18:57.1194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e0ed0cd-8855-4a77-e804-08da1279c173
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-DM3NAM02FT012.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB8018
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We've already reported maximum mtu via config space, so let's
advertise the feature.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index d5324f6fd8c7..2d1d8c59d0ea 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -26,7 +26,8 @@
 #define DRV_LICENSE  "GPL v2"
 
 #define VDPASIM_NET_FEATURES	(VDPASIM_FEATURES | \
-				 (1ULL << VIRTIO_NET_F_MAC))
+				 (1ULL << VIRTIO_NET_F_MAC) | \
+				 (1ULL << VIRTIO_NET_F_MTU))
 
 #define VDPASIM_NET_VQ_NUM	2
 
-- 
2.30.1

