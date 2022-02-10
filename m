Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5664B0ECA
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242240AbiBJNb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:31:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240549AbiBJNbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:31:25 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0466BBF
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:31:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gE+lLdF9Iz33dwx21kf+cfzOaBVq0X8ERy6kk38bfGgzA8KN5GldQ+De5QV7I7w+eN5t8TWNA6Jn+J097tK3Guewe85WXRaghzum5F/UIKt5czvQ+tB9ekP8+2Apcdx3QOEf6RvdMkkfYQEkvoLD863Xz9Y+my1ldJBFPcoBQN3ximvM6CV7PT39x6t7jOtxvgWroof4yFlO87YPK4GdbEyoFOGtCiAHUg9qa1Sk1QeNw1nvtw5zfitn+lc+CrnJluG6SssZlJrsikUjfKXGNRfV6IW0CZ+/ry3DfNeiPzgL0w6Oj6My6Ay5ruCgufidSpN+Vc24ytAax8pduz7cSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DEXYspyvetfSO/JZLn5KaJGALOTyjyv04/DCckWcPHE=;
 b=nrXlKlTHTKhxyJPK6Iapf35+dx09+DXMeawKmpRGW3oWu1AzeQGw2QJQketc6rxOpRDqpr+/n/dpDWH613pK6ZFkEMuI3SAxfZ/tIObk2eAaKGGHvOLy2l3b9OcqnyP1bbIGhOVJQrUE6xVQKk844OmqOkiKM1UckQc72/AME27jVl5P1tkvWNWT05eHLCOtSCnAPUb9+dq2I6z4XvlxoC48dfIHuAC4f+m+vR9bN2VFwsyt+44Wm0hH1fu39MZEhmmNhSK3jtF7FsNQQSxjMyFy9umzd2ZQ3mKV1wioL6UnD2q899QKO5siKLqLdQG97jMf2qApkkvWo/pIEkVlsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEXYspyvetfSO/JZLn5KaJGALOTyjyv04/DCckWcPHE=;
 b=NbPNZEGcgvoggTmnJnbumUnOxG0dzNrbzsi9iTSf3QrxtQr4b4XzTMMg68bXtTdUj+0LPiRFJer7stID93nvOeKN0Ku5f5MrpjSlB8hQ8WZ5CUGaoHU2A9ChFJ1pD9xk+dfdgh0APGww9XyR0oPVFp0rJLrv8kbECuJxBXeliHmSWX/2a6Yq+f9DU8nncE59rRgsgaMLejoF9qvhzcGN5zy6p6o+TIZTfr9IOXJwHFjH3/wkRWS6pvn/vdyBAUUQXAfD7bMeTNdupUpDncp+qubrwEk4A2HAN2xtX8GNGODDUcRfjc2yDtBYVAqvuKyqaOoGslNk/6W2cS6FgPKFSw==
Received: from MW4PR03CA0028.namprd03.prod.outlook.com (2603:10b6:303:8f::33)
 by DM6PR12MB3130.namprd12.prod.outlook.com (2603:10b6:5:11b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 13:31:25 +0000
Received: from CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::c4) by MW4PR03CA0028.outlook.office365.com
 (2603:10b6:303:8f::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Thu, 10 Feb 2022 13:31:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT064.mail.protection.outlook.com (10.13.175.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 13:31:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 13:31:24 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 05:31:23 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 10 Feb
 2022 05:31:21 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <lulu@redhat.com>, <si-wei.liu@oracle.com>,
        "Eli Cohen" <elic@nvidia.com>, Jianbo Liu <jianbol@mellanox.com>
Subject: [PATCH v1 1/4] vdpa: Remove unsupported command line option
Date:   Thu, 10 Feb 2022 15:31:12 +0200
Message-ID: <20220210133115.115967-2-elic@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210133115.115967-1-elic@nvidia.com>
References: <20220210133115.115967-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a20bf40-5d6f-4990-8ea5-08d9ec99a271
X-MS-TrafficTypeDiagnostic: DM6PR12MB3130:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB31300614F39AFEC1DA946928AB2F9@DM6PR12MB3130.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2OZUmlQZ4ujESiTjN1nSf9kg03gPlOqqkfb6CAVcfO+iPRu75KTtoa24o6OhqMvBFHtMp8TOPDekniuTjdVxQO+NRCFS+nL0BSVGkCBFLoKE24hkHE+9bLYyJ6m1c//bE84r2bpqkqzACiEmWXszuj2Vp7Lpnw0EiMvf1CGCSI/i6LIDlXunRJYtZVvFHmHMKXV2xL7grNKrH9I1nQo1XTNLCVEPNeJl2Es5SALr14D70NzvQnpy192V4iqa994frFnf8QqMZKYq2RuJBwt4Viu9JU0qH3WJjAzHVdWd0N7Rl2UOfDSPqwZhD1Iw+yZKAojHikpQ/cM7oBa4L8IQfcyMYpdpMCjTkOadxK+DYsM2UA9PuHDl+VvhirWWS4Npd/8pZBicxXdnEkv4NBs3rjJLMdpkfsn02qHTDiRipygCTpEV0h85byTUGrCAK6/gu9erwPtSjQlYSodNrVWYSKbptMMMxWQufI4bfXKgg2FkKq3bnHZjg/V35J5WHtPKGSbVPeCCjXzWsHJiu0D6Ctmtb0xQe+7ubuqHK503/iPmR4oj0Kqg/YkSwuFchMkMlu3ro8QZV4+j9gl4+OwFZIyMxJuIbP0aE1CY8FvlDyt7veY6fmJfmbyG6nCC7uhSYJU75FazoS/tfNmrD/GQVjZX8qLEBknQ4MZHA20+LLqgjInNUW3ywwvQ/kftk+kPw/uEqMV0iLL8UPtIUH+E/Q==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(4326008)(508600001)(5660300002)(8936002)(82310400004)(336012)(70206006)(426003)(110136005)(54906003)(186003)(26005)(83380400001)(47076005)(8676002)(2616005)(36756003)(6666004)(7696005)(107886003)(1076003)(356005)(316002)(81166007)(2906002)(40460700003)(70586007)(86362001)(4744005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 13:31:24.8044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a20bf40-5d6f-4990-8ea5-08d9ec99a271
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3130
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"-v[erbose]" option is not supported.
Remove it.

Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
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
2.34.1

