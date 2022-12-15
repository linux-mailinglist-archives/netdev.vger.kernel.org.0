Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F8264E008
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiLORyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiLORyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:54:37 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCF426A88
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:54:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPJa9b1i0p5xmEIRzcmSphaxMxZ3qKv4JnJ6GmNxwLvRZ0r0a/msdfT6/NBKQ2u0UcGhM7T11usVfbmJWsDkxp846ZdndDFszewxO28Jk7puv1WjBABkGq4BFG5+scGBo041M0lHn97u2jKv5zumnkrkAEnmBFWwwAud5dd6Zo824IVmAHrhaVX+qsS2u/99VAuwtdOTg5D75CVHl4FoBfa4D7JqPadZ8rwYsKH8FV1mhTe3ibEhzllntTlPIDNMUuGIxljG4P1YL7YmVIhzAoS8eBFSRVF7hhoHCkpw/2TfhnIHoD90PdHyydHjLhO95WgPJIwFgsKCM7jyfXmocA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aS7wm2Yt7F8CEO/kqg8ryCMHRn7FUdm6EBxiiG8KKPI=;
 b=VEWchzQnvVk60G9n2O3g3wabPjOJqvqU1cBdfuaxTUXnmrMSo0D4TCgVLrBv8TlrKYvvb02cAXxw87cQPoOhWqb1WW5cFcyGAzYZYd4Tht1ftD9gvTKhB1TWMCXO+YOMr0YQyMhE6Cy0ovuDj39Mu+NA9XvrRrHzGodgO5SrOTW7BgGifMyLvp4eqPtVpctxHK3B+AG3+evhCwoKaie+c1JTrD8f49+CKSmAQWlPFEk79aKxwthdKELaSmZgJmBTKIHoXyD0P9tOXJ+rudQGFQ3yQp9mpSvXHQIMhBG0+FZT+e0CEene0lRfMgBb0f/VTfKj7r9f3DcjjuSHfU/tlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aS7wm2Yt7F8CEO/kqg8ryCMHRn7FUdm6EBxiiG8KKPI=;
 b=HmC7OMisybAZQoSzUNU3/3rNjMbUk6Dzdqr3hh52vIWj32zmaDMl/vVTN/jziRaNUc/QJld0jPB1qT2jnEHdhQ2KF8ELCexKwAOlkeNNYmTzjMBzinvJ4J5WQ37HzUtnxEzFMXSFfW8sVMgK9AN+uGg51trKi/Mof8cbj+mOGf03N7BLrGHKb/g4VR+hyuD19V0qi4Qj+GhmR7f4u/uwQPz11nGPVeGZNiCdVpzkUqL5Cx5uYXDhgDpHIstMjntFagDB1fWxgjYxpnMoMClGVhJtpqisgVcDk3syIxQVOY2+BEtU6uVVt2pby8Z0t3npzoXBzwUIuLBViq0qta24rQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 17:54:33 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:54:33 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 1/6] bridge: mdb: Use a boolean to indicate nest is required
Date:   Thu, 15 Dec 2022 19:52:25 +0200
Message-Id: <20221215175230.1907938-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221215175230.1907938-1-idosch@nvidia.com>
References: <20221215175230.1907938-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0008.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ0PR12MB5673:EE_
X-MS-Office365-Filtering-Correlation-Id: be3f4a59-05a1-4972-feb9-08dadec56bfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mG/bgHhcPL7rY5r60yYf1mI8VUWrxZcCxBAIFYqDVyU67vvWnC3ANzZZU8WYy6GimE8ezfxS1MCuP55Is0Hd6j5ppJT2Uw8yZArxsbw4g9VC1y2A+igjQoJXGxdr94Amfr5t0l53UzWCj6KM6ABCQ3uxF0g39fjzaV59so5ByM5d1jDQJne+20MuAtuJYQ4Ol6floo2Tvp8PnlIShQR7Wi5qX4StSI2NPqcaGLnRLSJOLNowWNXET0mJntbIGP3ACC+bGN0fswDqHlIe8ESErD1UCcK6Ywv3Ns9fnIN4ap9iJmeeNxNSk31VWNAUyevVhnZSCDdy8DouR81yYm0xjc9Pwsd5RWy1zlct66hQ/x0kap2lFUYV3eKZ4ONLHGeFHx78/wwadxn+ZJdn81ElmnPRtXyFZ2rc2FSeVYYjoN2zzLW79IXVPVpXwXEC9v3wVAVqzv2/c4575OderOihzf68zYfPTXuQ+7ID7NE7GdiT5lLr0C5c5kiI6DwTTHAaNhOCgfoStS5Vzt8oJoMOe5IY/eSFhIvG1i/4KZGEjgNR9oKlhWenIePwlxdLGCYC2Il+AuJ1zdLvZlON/sCbdwdJ2iq/0sBJdygyZx+pMIvroHGa926bBGWcYCPaW/e5QIqnaG61lO4rF29YStmJDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199015)(6486002)(316002)(6506007)(26005)(186003)(6512007)(38100700002)(478600001)(6916009)(107886003)(6666004)(41300700001)(1076003)(8936002)(83380400001)(5660300002)(2616005)(8676002)(66556008)(66946007)(2906002)(4326008)(36756003)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FVYxPe80JknvANiD7x8auPknJ2vjiQwPEtOJRxCEma8b1WMv4gsMTd6O7QAo?=
 =?us-ascii?Q?YEg2dIN61jXcE2PjxE1mwC5RSDhUklpeol3mc1HO7dtIzQw0xy/bhK6kMlY/?=
 =?us-ascii?Q?cAbyrzQdgZLEch/UZ9Q+R8unCQqWCKUiDTXFAG2K75p5meCFB1KF0I8WfxsW?=
 =?us-ascii?Q?PN2Y9ROQv8Np29ikcQd8eTPKy4/kS18uLb+CxBf7wKitLv6CtEmiuAlmFXk9?=
 =?us-ascii?Q?nHBa+Jy3IakyAPMqTnywoWG25RUxnIv1zum/rXPDkbLZUMbmDxeYZk2jdW97?=
 =?us-ascii?Q?wg4fQVkym7q2/C9pRquhuZKUSQUUzjQeCJnrYeMitW/aWabXMeRQavU8k6rg?=
 =?us-ascii?Q?yoTB9HJLaw20OjTdQfK91HXk7pXON6Op5AmbXBRgr1euqYw0kwdKxqDun2+N?=
 =?us-ascii?Q?WjxXgqCwyS94U5z+xeJ1+ooWVG4/LMH/XX1IRWSTINwKrXxX/UHWPLz3Aqbr?=
 =?us-ascii?Q?Fh7PZxdIfGZlm0qlJyummQxcHfejz3N1COIRFgXIByhviig1F59UeaCWeZ9H?=
 =?us-ascii?Q?1l8oEzUo9s+rPMrK7ocuAh+l+9tWclFGs+Wp1fQP8MVoO/NeU8pWYXDvOtjB?=
 =?us-ascii?Q?anjGDy3oOzMnoSYcndGJ4itZmDKZjn2Tgr7UebHLQCKtAU/lsGJb9vXRGBv/?=
 =?us-ascii?Q?tYX8HMll5ym5FZWpcPWJQOENtTP+TzkRfApZK17PhGA0j1TQf+HM/lkBpmNo?=
 =?us-ascii?Q?TsgLDE780cr6K4AjLM9p0GVWoe3KbcH9WdtMPMFTFq3j+8idAP7LwFs60Bju?=
 =?us-ascii?Q?oNPFddjCBLNjuwYvpQp7F6ZKve90WEcWamCw7gEVhd0nk+i3kd14XSxYEkP+?=
 =?us-ascii?Q?xbrapEfruqg+h7gYb03vDjs4m4Zp8HkTNVNvwOhWM5Nrv/Q4mXPTjDlm9uA6?=
 =?us-ascii?Q?g8uGI2GVZzdvSuLJY2J0dl8PlhbV1xDpReBXYyWXgJh+KkKMDcCE3Q0TNGiS?=
 =?us-ascii?Q?3d7LNQLiwM5HTn9n8BV+M3qFqTkZoHhGJ1cFpwiCpsYHxhlKsuIMflFqW5Tf?=
 =?us-ascii?Q?OONMbgA0bhnixUEAp4IazvZ8jJ3UezJBhI7kWCPWhlROz3525bKNcCZjsH/T?=
 =?us-ascii?Q?nGD4evY25x0wYt/Obg4EooEyyhI69TbteDweq1aF5KZxWIAht2GC5XxqnNPQ?=
 =?us-ascii?Q?nJv4QkqF4QUaEwfEO4mpjd2ysNN1JwW0SeVphuPCUmrfVBSk6jUO2CgLWwEO?=
 =?us-ascii?Q?etA1YQiGUehK/4vZruR5aE8ttB4n1IPLshkvGMcprrP4XGFLkb8T69fmlo4o?=
 =?us-ascii?Q?S8WvPaIodSUrOT2Ui6ZzrF9TbHE0Rk5s8CD+9pnTRq5TgYKb4doROC3lvmNx?=
 =?us-ascii?Q?StaMNJOYF7lP3j4FbQ9dcL7HstsLM/5zPUWnUDby8xxpbhKm2FB8n/ONijpR?=
 =?us-ascii?Q?pttGsXqGzJzwHIObYs2tx8EopSVM9S3Z9V3BdHL1iSP2K81RY1umMLHjyklJ?=
 =?us-ascii?Q?GCysRR/UsC6zu+J+nzpsvCEtxZagVulQfU7FHCa0eXTSl3aiBkks87tKdCvJ?=
 =?us-ascii?Q?FMeRz22ue6yQbIqGPWMAe57+h7J4XCJY79L3CHaoNJ37/+T4DA8iYl0lL4Qa?=
 =?us-ascii?Q?cYSxMGHlNG7vN8251yHfkWBv4VMQYHVCfpQuWWSe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be3f4a59-05a1-4972-feb9-08dadec56bfe
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 17:54:32.9080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +sbbBFYp3oCRXsqd2BsIyCb1PVsMukoiERrAvOwewlXIvLIxT8PPyndze0DpDoDo4o0DQkeOpKbjn/J79nm6aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5673
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the only attribute inside the 'MDBA_SET_ENTRY_ATTRS' nest is
'MDBE_ATTR_SOURCE', but subsequent patches are going to add more
attributes to the nest.

Prepare for the addition of these attributes by determining the
necessity of the nest from a boolean variable that is set whenever one
of these attributes is parsed. This avoids the need to have one long
condition that checks for the presence of one of the individual
attributes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/mdb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index d3afc900e798..4ae91f15dac8 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -488,6 +488,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 	};
 	char *d = NULL, *p = NULL, *grp = NULL, *src = NULL;
 	struct br_mdb_entry entry = {};
+	bool set_attrs = false;
 	short vid = 0;
 
 	while (argc > 0) {
@@ -511,6 +512,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 		} else if (strcmp(*argv, "src") == 0) {
 			NEXT_ARG();
 			src = *argv;
+			set_attrs = true;
 		} else {
 			if (matches(*argv, "help") == 0)
 				usage();
@@ -538,7 +540,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 
 	entry.vid = vid;
 	addattr_l(&req.n, sizeof(req), MDBA_SET_ENTRY, &entry, sizeof(entry));
-	if (src) {
+	if (set_attrs) {
 		struct rtattr *nest = addattr_nest(&req.n, sizeof(req),
 						   MDBA_SET_ENTRY_ATTRS);
 		struct in6_addr src_ip6;
-- 
2.37.3

