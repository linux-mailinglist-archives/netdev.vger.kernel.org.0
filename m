Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2B04D7549
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 13:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiCMMr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 08:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbiCMMrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 08:47:53 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2046.outbound.protection.outlook.com [40.107.100.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D841B3D1E3
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 05:46:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdZ1S+jCkKKe02onUwi3iAFPsytitWq8kf/aWwlr3jZcI2t+ykbBDdL7uS1j9lWpx/8K/UgsKRkBMDBK962vT9jF9r1TQqPUglQI0w6XhfrWzwdxLgawzA+/RiNDf0XBY0XeAp6AewFoNtVl+sEFqkaAXW3GfdG/7T7it6CtHvshLeCtaPoNajmS/S29jbypLWDkU7DercseJvWD5feQ19mMS+rdeodll67Crx+4RoTqBmE0n20BCM7G8hxd7+Fl2bJFUTHlqg6EQp4eqgSkhK/IyvhxlWsTiNC9gtzLDqfknN4izugYDJzyzdvvwAAmEzlxASZ+D3JyFg6xPvbQGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elG1J40xfziWfEzxXTaCmVzClifDsoIWJIaSpNtwrfs=;
 b=LY8/ucpUz4Ewr/AT+aIj4uK7DsfyXfx4g+xTGLeZ0Mjh+2IQOBgrQ1IJBGAqg/VVmv8vDFdB+8G4MKXzgmj0fVxGKJfe5+95uha+98HnFrRsFk3WK315w2CkPubrRD7k38BWZ0xDwt0AYlPWnFcSGBeWn3Bqc3sLncDW9DqMvPb/sE2j9ezYUiEIJ2toKbwT6WModZ995QPh3ogVnqxDaP24b28T6N/3Whn+o1IXdzkhwOsXSZXF6qcQhbPEXs2TjgqN37cwVbC328tLjbs3thbdQ1BcjPWLa/PlcjMGzyPjdQLUa1eWERCjodeoXBj5goxJr6YIlLAVH3Reiz9eTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elG1J40xfziWfEzxXTaCmVzClifDsoIWJIaSpNtwrfs=;
 b=idRVbT2Tn35AozgW/zoV1JvJ7WEJKVbtKzLg6STufKxbjZuu7yY04WfRoykE28GZUHSRCHbwiiCQXo9OUfnZViZgyiSrlb+j+ZMt7buzyEt7zBjMqNuXVIRmTl9srFd3SrSaHAO28Fwcx+GTe0wI5qXsvbHX1LdlC8mHirgAGVX8ynXuAfgqS+4Qsskp7dkT1EH/3+LmYNWVPOBVTYlqGLMfWyI8OQ0tk4O1+/ypQsg3WREVJPk6JhaZzCJI7EguWxFuOQa+aELTctJWeyDJ9/EFPBLD98QMhXMQg9LPGMUY7pwIIWxoMtZJiRUFV+RTAfvtsQAPxHm/7ZXI81BiFg==
Received: from MW4PR04CA0343.namprd04.prod.outlook.com (2603:10b6:303:8a::18)
 by BN8PR12MB3169.namprd12.prod.outlook.com (2603:10b6:408:69::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Sun, 13 Mar
 2022 12:46:42 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::8b) by MW4PR04CA0343.outlook.office365.com
 (2603:10b6:303:8a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.20 via Frontend
 Transport; Sun, 13 Mar 2022 12:46:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sun, 13 Mar 2022 12:46:41 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 13 Mar
 2022 12:46:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 13 Mar
 2022 05:46:38 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 13 Mar
 2022 05:46:35 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Jianbo Liu <jianbol@mellanox.com>
Subject: [PATCH v6 1/4] vdpa: Remove unsupported command line option
Date:   Sun, 13 Mar 2022 14:46:26 +0200
Message-ID: <20220313124629.297014-2-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313124629.297014-1-elic@nvidia.com>
References: <20220313124629.297014-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93a8ea3a-4937-40dc-7313-08da04ef85a0
X-MS-TrafficTypeDiagnostic: BN8PR12MB3169:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB31699833D6354E9F802F1EB9AB0E9@BN8PR12MB3169.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qxfEjnAYmrK2RyYx/bQF+AeY46TlUYgo0kGkziOeKsXwheQOID4G8t/z++kM1Gl5V0TLT7HkzBPF0FBs1D5uWY3r7C6Eympv9rbjbKwkbT+yKRHpxb6D8PU65NRArQhnXwyGKo1r9XpYPdWUslWvEWyPUTWjzY/fpHLRUusuMZVIrhIG4W1AgauAZyi17tyImegOSVITfrFVfZjcV0CZ7dmPXX53rQr7CQPnY0bksedmiLf+JDplngdojJBFI9samu8RIlnpxPwfz/nLW6wNG8zMKhikpOhp2ewCzqGaFvcOSy+O37WxpPgYhos6wODzp3l0yxq9cHmFFrujwX7VtEx9mYqP9VuPFtgT0e7vARYYQqRBmVRaG6P6c63mOFiOOlINMVgA0ZSIC28cjUi2gozMeRA+10QsNoGPV4sUDb9RGy6pc9JpXCDoCexzEznyv8DPWyw8jSBJnL/Appyhl4mZryUSBGeknUNnr6FTWN85sw7SP+EtPYMlYJOdTzg/DWdBcTb2W6RC6uc2w76uiupcbfNlT0qH07ESsBa2huN/jhAIXBnwfjBWsRzev0U8IWnHGhLAqz3s2GvPcaGjJ9OwxBifQIkXnNOqGuT+OfX/iT7Vo1HJKqQ7TM36ffCCgaihMnhNVAP8wXcAZ6R26FAs0YaKBTI9YXVtpUZ7YBJC6VDZ/l58QaCqvAMjs9bIrDQFna2+MoWJvLTGJO5ZZA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(81166007)(110136005)(54906003)(356005)(2906002)(4744005)(36756003)(316002)(36860700001)(4326008)(8676002)(70206006)(70586007)(40460700003)(1076003)(426003)(336012)(82310400004)(5660300002)(8936002)(6666004)(7696005)(2616005)(186003)(26005)(86362001)(107886003)(508600001)(47076005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2022 12:46:41.0676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93a8ea3a-4937-40dc-7313-08da04ef85a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3169
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"-v[erbose]" option is not supported.
Remove it.

Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index f048e470c929..4ccb564872a0 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -711,7 +711,7 @@ static void help(void)
 	fprintf(stderr,
 		"Usage: vdpa [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"where  OBJECT := { mgmtdev | dev }\n"
-		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] }\n");
+		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] }\n");
 }
 
 static int vdpa_cmd(struct vdpa *vdpa, int argc, char **argv)
-- 
2.35.1

