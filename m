Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071E66B25D5
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbjCINtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbjCINsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:48:30 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4064A7C9C8;
        Thu,  9 Mar 2023 05:48:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhkiIQQqYip/jMDbgRUtpIUjdgqcDEnlNtxpPW9Ra+6k8jnun629KndZAjhW5AJ8XfwsRgq5z3sJL9YF8HRt8n2t7wkbR48lzaaL5m8LETfTe9LO5KSy/6Al+IJOpLSaCRM7ntNuMv3P9+P2wBKUoj2McHaIZChugHXEoDZBsb7VzfG7BSuSknNkxRv/H7esKa51b8BMmdRn264iNxBi2USQ18Joe6koEpgt9gwb0DAskc/miERi3QA+z5PYvOECUyRTxh4ee4Ew6wt5z1XcDYVIRl6HvkWFOIYzQJK4Vc8o89yxwDruDnceW95WY6ktj4kCa0888MNuItA9Vra3Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qe74iVXNKe0Zo48pwXwmd7AxzmshKOCZhUdo3wVNDnU=;
 b=WdKBlsq5dEQD09WzDKYLR6ti6lB8y8ulBLFTFacRXLK+aWuGlSxE3sWuUgZNKU8AJYULGb3NBh4AcnUPO01k2ocokD54HLZc+1yQeKi8ZSWWKORkheGaXYzArlDcwpzke7qBpc7DJuEw5N5fkk3IcWkv/QkfAK7rHwK4StZ6DHcIVXRRXwiuX8VTFEzHtrtrIQNk8c0Ap18eLsCBssv/Y2vr56mFcqNLuDj/uanzl+/H7ZGs0tcvOFOJmoNX5FIcfndRh/qT9rJXpzJ2bCNrrR0m7sa9pYhGhJx7h0MBymP/MJZacjs2FG1MqVXEsmIK9xarjHqtgoYV7v2I/6Nsww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qe74iVXNKe0Zo48pwXwmd7AxzmshKOCZhUdo3wVNDnU=;
 b=ksC/A5P4wSXValZMtSukIZlQc5Yx04aPiogoxAJHo4DqupIj9UPSFMOOfh3uIxa9duNWikwOkRFQ8CUK4cUyilDbX3X4bQSnb4nbqKG7FlNiKg4/6cixqowHF2RKN/gzhanvwrDx8CDIXU+UewK5XRZxMexxe/v5jn+QyLni4fPMWGFgj+kFE5pj8GVH1qd/1ssvGwv3M1akPOMNRsaKsgXYOEIjnWusBSb82SPCD8wifPjVtWiySNanQZMoN08Plw4b5cpljs+IkYUbX72s/ESEXatjM5elj6EjohNOdkJXqLC/xUjXN9CrncCDWbrlM2geMJ78wQmihDC90/hzDg==
Received: from DM6PR10CA0030.namprd10.prod.outlook.com (2603:10b6:5:60::43) by
 DS0PR12MB8368.namprd12.prod.outlook.com (2603:10b6:8:fe::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.29; Thu, 9 Mar 2023 13:48:25 +0000
Received: from DS1PEPF0000E644.namprd02.prod.outlook.com
 (2603:10b6:5:60:cafe::2f) by DM6PR10CA0030.outlook.office365.com
 (2603:10b6:5:60::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Thu, 9 Mar 2023 13:48:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E644.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.13 via Frontend Transport; Thu, 9 Mar 2023 13:48:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 9 Mar 2023
 05:48:14 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 9 Mar 2023
 05:48:10 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v6 4/5] ip_tunnel: Preserve pointer const in ip_tunnel_info_opts
Date:   Thu, 9 Mar 2023 15:47:17 +0200
Message-ID: <20230309134718.306570-5-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230309134718.306570-1-gavinl@nvidia.com>
References: <20230309134718.306570-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E644:EE_|DS0PR12MB8368:EE_
X-MS-Office365-Filtering-Correlation-Id: c4241071-5ad5-41d4-d50d-08db20a4f4aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cSMgeSZjMlrXY2Te+vhPt8lihnDGSN6AmbP+KP6Be8+MVKrDln/56wTzS9KUeZft2SVZNWm39dOB4pcRZq3FUu63DCWBbv1+yJJhS1ygjTb/cO6dZ3aJSF5gZ0HVvVgxqdNyFiMSBkhSOZCkiD4RMmKKNG7l0/dMzc3NDr3ZdpLT5/ai+whV18/xwheeo6xnWwNu1BltNrsXU8oFkQ/N8IoGFUUMm/4IrK5gytoWME/+6NUx9FDT7m2hrZPI4hMiUJdbLHODRg4djcLBHUhPAqA1VH1sPRY10CMCldGBO2pVvHusOOCl2h8tWfms8KFMIdYvv4tu5gJ3cRiuiuo7edeRmAxHycGjj609W5yJmYeHqunLUQQ20yauhvEPpx+cam5DH+v/iHXk4xA3GQqaW2QPBLdyt7g+M1puhnVSZ7UBh1FAobMyuQrjPqQX06SJtnNe52WFsHQQ3i3Ccu4KfP3IkhsgAkz2RKu8pWp1QOdlrGkW9OM9KcNh7SYZ87YgBnOLV2rpeBkZqEfSljFbqhe5yog59DUsCjkFMv1T8uBsi41cA/JaLk3yyXS41o8S/JuN2nykDuxPonZkF9vgSk3qOHRsXvabK18qGmfWlo87UZ04z+Sucv609SxxI0nJzauQkwihA1jcRCP89eWho/sorRNAezWRrkmrKk4Cde5Ui9k153g1epQW5yB/ojTFJGvu6aOj8otdYaeYkOjl6KQkvEcYaBxgC1sCyzBD/+xzyaiPhK/DahhB2FyCD8rS
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199018)(46966006)(36840700001)(40470700004)(47076005)(426003)(336012)(186003)(110136005)(54906003)(316002)(36756003)(40460700003)(86362001)(16526019)(2616005)(40480700001)(36860700001)(356005)(7636003)(55016003)(1076003)(107886003)(82310400005)(26005)(83380400001)(82740400003)(6286002)(7696005)(8936002)(5660300002)(478600001)(4326008)(2906002)(41300700001)(70586007)(8676002)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 13:48:25.3056
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4241071-5ad5-41d4-d50d-08db20a4f4aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E644.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8368
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change ip_tunnel_info_opts( ) from static function to macro to cast return
value and preserve the const-ness of the pointer.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
---
 include/net/ip_tunnels.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index fca357679816..3e5c102b841f 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -67,6 +67,12 @@ struct ip_tunnel_key {
 	GENMASK((sizeof_field(struct ip_tunnel_info,		\
 			      options_len) * BITS_PER_BYTE) - 1, 0)
 
+#define ip_tunnel_info_opts(info)				\
+	_Generic(info,						\
+		const typeof(*(info)) * : ((const void *)((info) + 1)),\
+		default : ((void *)((info) + 1))		\
+	)
+
 struct ip_tunnel_info {
 	struct ip_tunnel_key	key;
 #ifdef CONFIG_DST_CACHE
@@ -485,11 +491,6 @@ static inline void iptunnel_xmit_stats(struct net_device *dev, int pkt_len)
 	}
 }
 
-static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
-{
-	return info + 1;
-}
-
 static inline void ip_tunnel_info_opts_get(void *to,
 					   const struct ip_tunnel_info *info)
 {
-- 
2.31.1

