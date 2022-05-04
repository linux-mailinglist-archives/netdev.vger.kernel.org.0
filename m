Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4F351972F
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiEDGHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344825AbiEDGHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:07:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87401D0D9
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCVPh5amVFF11fTzQDFwiEoTzIu+BDDWjiO+Vf6XjEQHPfOnAypZz1on4S9bvRJagucm9cWHs2hDDCVf/v8mOXJSGdHhm5ILY+zk8pAQ93RvRFtUVwM39woU9OYpmiuIpQnuSPGlLgfkHkB1gapgG2axJGqsj1UPxKe6jk89lFSoieu6sE9Q9K0fVN2h1K0A+MdRo6MusXowTtH12/Hfsn0o75Y0bDNW1ZmKoAlPcCzDEkyElwnTciAW1g48dN1XPkQLmG8IC1erW95FoDCUEqGx2vQnoKODtofZgcTs/zBjiogEXZdMuPtMkjMBDN7MKB2p+vA4aCT2UoLW+kixmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVqa9cNLROlKG88cchPZLy98DwfQcgRfHoM7OcAASnI=;
 b=lhVSfAYuPvILsKRA02BdPyhOFDnj1ZGZ8ZkeGKaBTa6gbjbHfX0kPafK2T06VcPyEp4RgtyRdBpCRJ/eI0DnUTnNOXpZzr2jzplbZ2Q+guVRoMRLwpywrRDOKgzLfh+dG0S0Ja0l+OvgI52IbpBrddX1FQmiEJ/QBzBlLVAqPnhbvch8RPux0myAefPC9TqJ5Gd8HCSr9cNEigZJZRZ80gvYVd4R9zd4K4Lca1AajfbBaTPojIW2Ch3FdPt0Ik2fYDdZHSYWGOb3wW1cCSFR/BWTE6rLPkUSXCD4f3ssF8mwaVaRWMJUHhxwbzMzzYBbUh8QTSSsBlnQY5troReilg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVqa9cNLROlKG88cchPZLy98DwfQcgRfHoM7OcAASnI=;
 b=rcWAXGc7L25S+gwH4YU2VG+h+5c65rEoElU7REWd4Tv2taecBLhfLBmknfbWKUKXXv+9y/Yjtzk6lEknyMve4/EtZuqa2r20O4ax6r8ZuwBXnkhWA25EXfvB94iIiGCsUZs2qGiSc0yPXC0bGFVxe5m0wqDZoRoxCJP3KY5mbWvMZJdT10L4k76+ItOSJO/dKehBhiu+R8mufbYzrA1lGAL6WmblyGBcBrzeDZ5oHrw0lOEa0sGNB033Kv9qyF1d2rpxMOW6poIIrnKdn4JzsLlYPl37vyU0wihYYYbIzxptzLHabtGM0k0P6cTt8jmpz72QIdJtxjDFRfrT6srvGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:16 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:16 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 16/17] net/mlx5: Don't perform lookup after already known sec_path
Date:   Tue,  3 May 2022 23:02:30 -0700
Message-Id: <20220504060231.668674-17-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0040.prod.exchangelabs.com (2603:10b6:a03:94::17)
 To BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f121675d-4b3e-4330-14f8-08da2d93c7a0
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0006D6D6D14F86A0E4E731D8B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u4k1r02GgMINdFvPeO3/hlVG+Jx23YogAjYi9mgdebFL4ZQgDGM0hDnkTWzcB3ga4qEGSIuSzU966+ltBfrVnlRWfsFdw2prPBRMMG8KRHGgve1EMkEj1d4E80CR5OQSt3aC3yqfDaqfmA0zCVV5ocoyshZfMLzr/IFAzXBpTaJ4ZcMpxw6dSy49U6jj/t5qhOPuEVylHg/mkw4tLnOaUqjAF4Aclgp+4tPmrEQ1U9VCNghI96gIiibFS5ArlyyTWjrO5ES77Vl9B9Oeo1fSWspnigTXEnborPgpkpQoBdOMwXUwTVPDEi8OAOFkKFrzeXlnxjHonFL5TWUFP6pSEP2ebooMXC/chd4B+iT/bTVcMms7M/5wrrCMwl0+l0HnDA1O0jhpj5ThYgSjTvzjg7YqDLnfKonq2A7uFAeJGL++sgZnCEIJieZrTt7wlm/f8EOyXdd/29ITtk2uQT9EVYSfmMNEPFGsdQmV5pSyVMj0KPb8AacY0f84T/QBx9ZsBOCDWpXRxI2AzpdNBUGyccZL0kVFVJ2ApTsMcCk9MGPNPO3vHAbOMn8+P29FdJtVjCkqsv9BBG+Aa1VvpW0YZgEQhIiUJFlKhQkCJWX+nC0oQMy9MLZI22ybrCNyk0F6Y25AzLCCjL7eDgYYKMBOyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(83380400001)(4744005)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2MgdYnOmPnrdaaLE7U8N9IhF1vNSvnYDF4P8nHX3dBD911uxkfwEFDrqm7l4?=
 =?us-ascii?Q?4h0Hf6gdJFczutbnQi9/fDGAHDPcyZwsyJQ62kXOGKCsEfQKruIaZNgwEweN?=
 =?us-ascii?Q?12vSoFy9zTYpkVRS02SKwFutdvVTFQR2h65ZA8k6FnflYBx5dQJs1IRoXqYB?=
 =?us-ascii?Q?3Fk88MfCPN8qTe6auOHYeybTmm6qspgkANyYFtGAjeRUEdXX2gHAyexyNRU4?=
 =?us-ascii?Q?W7hS43PFklEjfZ3dInDgCoNngDiT/HF4D8SpJGtXzbAEY/1RT4uTJcUlF3fx?=
 =?us-ascii?Q?/ioi39983K8G3m/uRLo+hM/M8n/6Wr8l2sZuQe86RbqRSKOzZxznQaf3WNZX?=
 =?us-ascii?Q?IxxmeNsfzWMYI7IXQtJpf13B3jZdGna8ZFSC7B0q7A/xxo/sHXjQoB/gtgFJ?=
 =?us-ascii?Q?k7mBlxVNXi0X3ShthYAP2cVP96cVrGWOkHRYGPVMqcmaDzNSs9TYIBJQI40W?=
 =?us-ascii?Q?dEGxZeKKm+lluYa1ycG4IjlreZvOSPHrFTkAFaHPu0eusyogjfTKRVZHr+o3?=
 =?us-ascii?Q?jrMe1abHA72SM/Cy+WmZkv+WGMOxBnhUiJVf65UG894+4Xb3menATs4NhMTP?=
 =?us-ascii?Q?LCQGBoyVj3kCOAQ27NodbHBSHtQlH3RWLzC79ejwbYU6iMGdz/TyLNC7G3N1?=
 =?us-ascii?Q?4nxUGk6AqDsr77NKe4oZrOha9gYvDbztl1rBzEjC0+jgtHUa2V8e8RHev38a?=
 =?us-ascii?Q?ydjdmAU8rrXyXfeMys/dt969I159uT/5AqRO1gXbwcXsmsPzG97SbtNeOY0v?=
 =?us-ascii?Q?QIB4gTE07uO6Xy7gIQy86LzhgJkpSqNhyyqZm1tZz1YoVev4FuM0JpkFbfBS?=
 =?us-ascii?Q?TINOneyIJ5N+z8QP6FmHVUyEZHCAygs0sKUklXJnrjWuNON62KBscWJ8QWXy?=
 =?us-ascii?Q?5f+3PB5LAtSvDpP5AWCOyMVEgIsTPgJcYaWmpfiBofr0KkVqzW62HD3VYcoM?=
 =?us-ascii?Q?g3DoVISAkBJnR5LIhNSa2O9VPHKXSfTynwcLWqU6SxPfK6ED6lmiWY0/6Mrb?=
 =?us-ascii?Q?H6FkVPL80s64Q5Kee+qycvI3DWoLyB2nU/KQXvIs4UZNwXJD6IouJICKJ68i?=
 =?us-ascii?Q?rpY+Pbo790Ch3CMeL+95JNIjUS1dQLIBb4f2Chn8iAxK4jgkM+o7X8nKk2W/?=
 =?us-ascii?Q?wc1EZNYyd2YCa5JBGmcpm5fNYBaUTTPKCwsPzdK1gDjO5LxSLE0OyzMS0LQi?=
 =?us-ascii?Q?Mg7BnLsdqsyLLb20TArveofg1XM9ibNIv7tWW7lsLAeZDLlK/1c6ffNZAR0Z?=
 =?us-ascii?Q?L3+yL384d1lraAC71qj50Ze5QwU6nI2B347TLAoeIAuThK83nJovRYMkWve6?=
 =?us-ascii?Q?Lxr1TuT/0Jl3SPWDHyha2JIAn75alR6zC5pSy4hluWzF0lxC0FiAQKbFFvBA?=
 =?us-ascii?Q?Dafxr6LM7NxJLsocBzRbHuWJwWFVhEFklFlmUrDIej60mvvwe7/iAKXPi4+l?=
 =?us-ascii?Q?gD8W/ODkFl95shnqk0yrnwQEzkGPGXFWAyRvEpFwAn4cadPGcrbszPGNKBTn?=
 =?us-ascii?Q?yRz5YJKWHb4JkJgD7ytO/3THoVdIhSpFJvqhmvAlCW3YcspbzzZjytehSGli?=
 =?us-ascii?Q?d/dHpNpfbWHGEFC1p4s6o6nbDO742+Vip7rajJcQkQhLG9TRZtjuCxxHSYaE?=
 =?us-ascii?Q?0WCgFDoKv/KlkdTdnYq5Q3rie40cM3oh8MNql3kfIJX5jCGJKaGzFkTyA0sN?=
 =?us-ascii?Q?KsecrSMhGinrIQS9TfeNmQqM0L/BUe121dk6lzM9qfqWQ0669MycLG1Zcsir?=
 =?us-ascii?Q?RjHimixq1r5cOh8bpYzUGv+VTFg7DF7imFGRphrzEzOyftlufSiX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f121675d-4b3e-4330-14f8-08da2d93c7a0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:16.0039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kqOfZQtKTg3zZylHLtSLeNsRKrfccrQ8Ibfo0dfxSpUN+gu8s8xpdJe5MoSgwdNsDjw76pzCCgBKOb5wVXuBQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0006
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There is no need to perform extra lookup in order to get already
known sec_path that was set a couple of lines above. Simply reuse it.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index d30922e1b60f..6859f1c1a831 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -332,7 +332,6 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
 		return;
 	}
 
-	sp = skb_sec_path(skb);
 	sp->xvec[sp->len++] = xs;
 	sp->olen++;
 
-- 
2.35.1

