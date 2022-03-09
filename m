Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0159F4D368B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbiCIQ7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbiCIQ7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:59:43 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20622.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::622])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B843CA0F8
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:46:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YF939Kxc0ffPwCz4i9+JDskU2SsV1CsZZpalHSdmT0OD3xhzJ7byB79ii8DXXqpLgkzbRpAKcSVwcDW3co23npy9WQglOGve7zqXO3Fw5dAXBR+OttmWNDGjA4ATRWM/M+d18kds49iQG1x0nt4vMpMP7RcjBM8y3lw4zSk3IaL0OjxCsCsPBiusK7S2T2ieF08njP8HBpuDyl1HkaRUPcxAJFrOylYHyl7hxywymTS2jNLVHdkZRJyPivLu/WtuXduAbvGjWDYSXLDo/6Z4JJfMuBXFUI7D62OymZh3szV/J/7jisIjeAHgc3xth/ClqxOP5+RqXIG2xh2b9f/XBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elG1J40xfziWfEzxXTaCmVzClifDsoIWJIaSpNtwrfs=;
 b=fUAYCeAIp3zCQANG/0FNtXZoiNMSNgAxlaY7Gu3TxVf5fBkH2NZWaIsH1tB1aOAPWRRUmJkJ+5jlbUP1QMzNFdZOkMQntL+3OS6ND3cbCYf/FzPIyrqYbENua8hxZ0B3pHTmnaj66wO1tpcDhIOtryY+xTdxoBGZ7ehWhWPF4dto89PTg9rSbhLgqWwEjYugC9i3YmEWHORqT+RtErd7+VQxSpAWM76cUOgFI+paikVRWmocAMSEjq5rA5waOfcI/Z3l+7gI0WgTjCCIUxH88cSB6Cr2hmBNfgkroNoHirXWHadkGEeDNcOM2l2kCDfB1YQ2EkLvcvYFPxxvQYoHUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elG1J40xfziWfEzxXTaCmVzClifDsoIWJIaSpNtwrfs=;
 b=Pmn3o6PM2VVv/pmQXQ/PecteTab5Kv846wYFkQ7sedIToVxzkSRnEhOYwXiwG6lB6ZdVeZxKFRLJ44eMwa+7YAmHOd90UAnaXXy8wUjsx+osQKGYPioEVqURkD6lYUPRakhs7pb45mLufq5fekS7AcLo6by/L6EffbisbkMM4V/gaey/gb/QVMk52/aKVmV1iyjeOlo90IpbKhJ2pYxdIzkYjY+SYc8zd7vbFO229TDN8z2qcgqXEuhfBbH3NCJfIsKCjmnJdsaJ2n4riIo04QSzFnZS/kFpAJCWQk8mcbnHvzG6P2QeQXiaZqp6R3GbUQiHUe3Ni8GLJWqooyDDJw==
Received: from DM5PR18CA0065.namprd18.prod.outlook.com (2603:10b6:3:22::27) by
 DM4PR12MB5213.namprd12.prod.outlook.com (2603:10b6:5:394::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Wed, 9 Mar 2022 16:46:21 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:22:cafe::ae) by DM5PR18CA0065.outlook.office365.com
 (2603:10b6:3:22::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.29 via Frontend
 Transport; Wed, 9 Mar 2022 16:46:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 9 Mar 2022 16:46:20 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Mar
 2022 16:46:20 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 9 Mar 2022
 08:46:19 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Wed, 9 Mar
 2022 08:46:16 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Jianbo Liu <jianbol@mellanox.com>
Subject: [PATCH v5 1/4] vdpa: Remove unsupported command line option
Date:   Wed, 9 Mar 2022 18:46:06 +0200
Message-ID: <20220309164609.7233-2-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309164609.7233-1-elic@nvidia.com>
References: <20220309164609.7233-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60310f61-7e18-4b8e-432f-08da01ec570c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5213:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5213A3643CA9BE704B6930E1AB0A9@DM4PR12MB5213.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SC+muak+UKyyX56y/clj5FWeQqIHSpA+gpKlUh9+/WWs0J1KCdBngJ1KB3Hg/G3JCN9FeyzIhTnW6D7Be1HQmJMturSVn8ukVIaLg1c+eHSbG2+VVePSkVQ4tfCaSIcVLWGgb7VZubk8MsAmSWnZ40ABOHijy6/BU4SCsooOQYUlbg4cAKGBR8JrLo1PLOqhiPYBWA3hSDTJoI+fIrIZcU27f3GSBZtMm2D+WpgLC8TAFdAUbiPjcEPIwCJIlyeKrX4vllHq78Gc1pE6rttWUZ61BQVsQ6Q9yUUnN8yKyc8MAPJbH0NI1jyFVu2XNvM7OKLX4dPCAA7Pzu+nCJGTFUGgYcc+7sYSgsdj9ec0mhdX211Amjg8YZLiIzNUnvJb5I/saCmC+InjtrWmFoEoWecpNG3wZjSydKgFkSegdqaz+lmLz8SbRTdXb1TTBT1WtOv3VZQCpNRukMtgmhDeK0ygEc6C8MbB+q8I+6AnK8yRp+Bw3ioc5gB0gNLTY0Sc2kSon8djW+nzgxsv1R++bE2YET7eV3hkE7Bt+NyjdvpMze82GeUsdRefPf6Nt44ARyiBdHpkZjzEPyYwMQ4Bs+AD3Lr+xgcNA6MFV0Fikp7AHFtowgcNW5cdv2ZQxtw8K863IJQ+x2wEgbLRzkDel7x6JkjFUvC09giTtyqubta8uBsr7xN+Ky4yo57YAchNKBPBlbc3jpZRBC9lGrCZTA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(82310400004)(70206006)(81166007)(86362001)(2906002)(356005)(4744005)(508600001)(40460700003)(6666004)(7696005)(8676002)(4326008)(316002)(70586007)(110136005)(54906003)(36860700001)(26005)(5660300002)(186003)(1076003)(107886003)(83380400001)(2616005)(336012)(426003)(8936002)(36756003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 16:46:20.9583
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60310f61-7e18-4b8e-432f-08da01ec570c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5213
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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

