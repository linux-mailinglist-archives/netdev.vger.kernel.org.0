Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFFB5A9A02
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 16:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbiIAOV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 10:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiIAOVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 10:21:07 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A985243328;
        Thu,  1 Sep 2022 07:21:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZF4l2qBbA/GTr4diSaTEIU72aHyYUmfEBowy0+4ybWBGQSGqO6staDmNC1ihpQtczf8HcorT1SPC7MCcPguK/gMF1eKmzUcqQ4AvcFhJo1RGJ6FC0fLvPc4Z7s6X9DrEpnGgRZNwhwhvpejT/nMoLuGNdXo+25y3S65we/2i3Xv08NTDjeZC8YO7yREzRa14QzKWj62GOuH+HFPihraF3aio0IBW13boXVDXV4uwRBWdrGyB3afC7Bkj3tNBZDZLJlFOsiNBssP31mwzoC3Yc4JDjFaLIeY7YAtbYOEnSX0yFOwXo392P0sXYuV0ql0h4VwEG78crA4XuOB3ShMA8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TetcQo6Slx3iQaRByv9RxzXzo0lNntzkAteTIzw8ubk=;
 b=krWZzWNHdvCiIYkHBp6yLYc8uXx5IkHGsEs5t4fyXkBBlln+ij7HEN3UGvk30BbLiEqBM2oOh/JTg4OHlad6MQpVTr1SZQKV6m3+eC3bstToG3E2Kkn5kQbskcKrQXNBay4sDm79u5MIl/JbMmklBO57Rj/yCINQ4+yJrlP4k34DTsg9yiP6wE/GycQSjQVa1/iNpeAEwHuErRabotthxHrTDk7Z7YCSd+GhtXC9ThdJwSKWnEYuMas3W9627VXMj273/dgX2Ae5YZBk/oeRkXBROMqIqv2wT8UWtlde98DpS/qEa9cr/xlzA7q3tmz3Z9cCfYhXnBWgrQFs9BEWIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TetcQo6Slx3iQaRByv9RxzXzo0lNntzkAteTIzw8ubk=;
 b=j15rZclJEMFlMQtDBxZuMSHDN6PxTAZQ1R4XivSsI+35iPIyAXdVPpRGxBO/UjHyJaWt5AOv7a3BgHA61KoS1Olo5pQ9T2RFuSG8MgcuqLxZkDI0aqCPqkcrQUyGUq4bDWAgNNVICUInubquBvxLtSUqwMAzYOVNHsCm13+9CXaqrzq9nMwxrBgU5Xi2+R5l7zy+fLx7QjNSoidwM/ZkNeenhQ0s2Ix6uYHlUXc+VL7j4HIvbWR2bvLTHWRpv4E172o8JSonnCUuiZVUFjWCmBIe0bH69MFXnVSqd8bgf8C/I2EPw0EnDwlsgYUUGMpmbIn6yNDTw5PzyYd6xMbpgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB5000.namprd12.prod.outlook.com (2603:10b6:a03:1d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 1 Sep
 2022 14:21:03 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.012; Thu, 1 Sep 2022
 14:21:03 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, Leon Romanovsky <leon@kernel.org>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc:     Kamal Heib <kamalheib1@gmail.com>,
        Mohammad Kabat <mohammadkab@nvidia.com>
Subject: [PATCH 1/4] net/mlx5: Add IFC bits for mkey ATS
Date:   Thu,  1 Sep 2022 11:20:53 -0300
Message-Id: <1-v1-bd147097458e+ede-umem_dmabuf_jgg@nvidia.com>
In-Reply-To: <0-v1-bd147097458e+ede-umem_dmabuf_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0020.prod.exchangelabs.com (2603:10b6:208:10c::33)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7b45e0d-59cc-4244-844f-08da8c253389
X-MS-TrafficTypeDiagnostic: BY5PR12MB5000:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJMx1GK/5X6bGaw4rKDULHfRdcmw2BJODwd+WaOWJgjte4q26HoeueMLOWPA6Z1Th19A92dhKrXprykBfH+p0xWOmpVUoIT6SUIfVNa2eSFZDm0YQxJ/ma8PtvgPwn12ekK78lS7E+bLPya5OFol5s2MweTnKLua3zR59D+aQXLcWGNnXbBvxBjfyUU95xeEgd9eCMFBv+yecVg5iEZSj3jcItT5VpkwPaecDEBOzP8LmVYMtVSsUYJI/mhtDzjbtU42pKCODoHQk27N7gl5PkaEQDCiXySUCTTafZr2oHqFsHTK2LK3oK0X6sbwGkPX/7oyjArxpvbxw2NWYVQEtmARbd9lf5sgLbt3PoFxt8yXclfEQX1VacaKOl5BO9qifIMQgjrn+fziP7JAUF4Dl6qjmfvnHWOatJGo5CiiqncKg45gHa9KfjI0666GqGVstIpQuuyQX1SX187J6pcAsO+pyZVWM+DK1JTsR/7mE255KHBaG5uf4B+lEp7ya8e35akDh8EN19275toluaRkoGkVWqHJEjeSEKcNGMOFbf1nA0eu7T4/L5bkvAarGk1sa0nxJty8jfllIuV1lunJX3ojND+u49DJhFeMZaxhMYf9GJAZ6EAbEUP0kX8j408Z74Lm43agd7dczNr44RFNvIXkmSbC1qOVD1b8KqO5POfDPbcLrHDRyQKWzUlMdeRwsPHHY8OZFb3w35Ct7oL8xi0YuBB57qwjl/h9tH5936HEeAMC4pYGXlbhXi7U+Kii
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(6512007)(66946007)(4326008)(5660300002)(66476007)(6666004)(6506007)(478600001)(107886003)(8676002)(66556008)(6486002)(8936002)(86362001)(41300700001)(83380400001)(2906002)(2616005)(26005)(38100700002)(186003)(316002)(36756003)(110136005)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a1NZsy/0nFprincwE7vaAbYPL+ebQyNOGV738qboH6ovKQqBG4CK4aJV3WsK?=
 =?us-ascii?Q?mlwTkUaDfizKVn1i07fQT6uIJzW4y11DNupgRmmekOWh5RS62Ia+tBpqV5ri?=
 =?us-ascii?Q?FzQvPJ1XGodQWBjJKiVA0MpzXPltkP8dFSBBTP9I9A9Ig0RL9yZ3k9hXbWJV?=
 =?us-ascii?Q?7UuwGKVhaBzNR/Yo60ouei2mh51tkb5NPDHTjgVCCVLKdTS53r02yE9y3gJj?=
 =?us-ascii?Q?g4zeVgtWM4zR/rgpdEx557z64iB5VL2Dt4Tobs1J8G1806GE0nSXPJ0ZXhs9?=
 =?us-ascii?Q?8o48az6DuDskYHpT4sH+1+zaA7iiywmmj9korNFeLA1m6Gfa/UBhdZog23Ry?=
 =?us-ascii?Q?uYp6rAfQykLYnl/6XL+ozNPlnWMt2zSp39/Ze82ahkvbeprhltSzY6/m0sTK?=
 =?us-ascii?Q?+pZWZztHWg4wIIrLa/5UM6hxVTr0gXbVeVSELjb4QgP/gMX7kbcfUYsMWd3a?=
 =?us-ascii?Q?t3apaNef6NiCRA0daW5CO8k+Kx5ud3q/L6WGTblyR5v9XJ6T4wubb4ZhrZkp?=
 =?us-ascii?Q?jiG2Y3OcPGeLjtTMuzebD7+2XJOgFf/fGw9IlmDAWYPDZ1624PaxMcJsYSvR?=
 =?us-ascii?Q?LCeHnbsKGcEIsJwwY5MDjk+oDx9RsFo/Oy4dhNamtA6z6yF8FFU7Q9y9UWaV?=
 =?us-ascii?Q?KL6m9ekfrIS+ElvkAhA7Cy04JlOzJ+MRR9S3oGufkKauWREpgqy0GYGVv051?=
 =?us-ascii?Q?PhtfXJXFKQJhUcVwvHZzuc8vFsuUwywjdVdPLdYTfznZvIDFAnZvYr4JV7yJ?=
 =?us-ascii?Q?lO+vlYmKxYwOfVDYKlOgNmUkz/0blRQA0p32VSaUM3nvrk1vj1r7hDrSDHm0?=
 =?us-ascii?Q?wgrYOzPpYGP17ZPpFUvuVlTdz+IEzyWcHACBijXufhHs1Bv7RRmJUjzjsvwk?=
 =?us-ascii?Q?kUVdpuBJDrwU6styQ/nk6V1i5c0l02KXp6ANvjoS+n0WUZVYzLnNfYk6/TbY?=
 =?us-ascii?Q?Eon0mzEaJwGV7DxvI5qUOAkklxMNBsyUW0qjGMnNBrC4ZGE3ExzfxfSgULSm?=
 =?us-ascii?Q?6WfNPTjnpaoG1otOIAbqrTuYoFe9E+mgTV3CoVw2bMkqRm6GhuPuhBmrPlpt?=
 =?us-ascii?Q?0FvTAVRyrTBUKSLOi5f7jZDnSuwtv9lxu9gUL+nEaDfczSPDyuFmUTEmqYS6?=
 =?us-ascii?Q?WHtkNh6Oe+yZI7faUTfjCi46Yhwly/onD7r8HbQFXESLR1c89NACi9dZVLum?=
 =?us-ascii?Q?BnYoafvAAry/ITLXkXnXQIcT/SvMcLrrNRzmRUrR2OR2QHK+2jh8cFU+gfI3?=
 =?us-ascii?Q?fABWUVS/o786wEzoy2CP2P/U08gFQngRigUANnC4TAv8mbe8yVACWp6pcBFz?=
 =?us-ascii?Q?quYXSYNFx9fhxQxcYu0dNg6c5vc7CGRdP4aNNW4ZnrzB+rzHjtsIuS5Nka7C?=
 =?us-ascii?Q?EArxa5XagLr1XDyPiBE2DBiXK4hrO7rQ4iCItsaaER6mE9YD9Q5YmnYplvBG?=
 =?us-ascii?Q?bSJC2MfKHq0REnHLoaHiC80aHR3hFQH3afpPKgwWiMC83gBhbMW2NicT8YBW?=
 =?us-ascii?Q?apkWXB9hT1w6Q+gwgJh0dn5oMyRhw3TZmxHWIdnNyuAi2hb7dujUOc2rVMOP?=
 =?us-ascii?Q?66ym82orULuT2jATON/yizKCwEXVZsCpAGzHnp1I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b45e0d-59cc-4244-844f-08da8c253389
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 14:21:03.4237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qaMiBYTjHTCtmcbCfweY+g8VQd3jdygj9NjSwhlvgSMEEbEoEJOzfDSmhhuUmZQn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5000
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allows telling a mkey to use PCI ATS for DMA that flows through it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 4acd5610e96bc0..92602e33a82c42 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1707,7 +1707,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         steering_format_version[0x4];
 	u8         create_qp_start_hint[0x18];
 
-	u8         reserved_at_460[0x3];
+	u8         reserved_at_460[0x1];
+	u8         ats[0x1];
+	u8         reserved_at_462[0x1];
 	u8         log_max_uctx[0x5];
 	u8         reserved_at_468[0x2];
 	u8         ipsec_offload[0x1];
@@ -3873,7 +3875,9 @@ struct mlx5_ifc_mkc_bits {
 	u8         lw[0x1];
 	u8         lr[0x1];
 	u8         access_mode_1_0[0x2];
-	u8         reserved_at_18[0x8];
+	u8         reserved_at_18[0x2];
+	u8         ma_translation_mode[0x2];
+	u8         reserved_at_1c[0x4];
 
 	u8         qpn[0x18];
 	u8         mkey_7_0[0x8];
@@ -11134,7 +11138,8 @@ struct mlx5_ifc_dealloc_memic_out_bits {
 struct mlx5_ifc_umem_bits {
 	u8         reserved_at_0[0x80];
 
-	u8         reserved_at_80[0x1b];
+	u8         ats[0x1];
+	u8         reserved_at_81[0x1a];
 	u8         log_page_size[0x5];
 
 	u8         page_offset[0x20];
-- 
2.37.2

