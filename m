Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4950519735
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344827AbiEDGHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344828AbiEDGHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:07:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5FD2AC6A
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2k7G9rzgRPFT6Y9/gouJUfH8lbE11UvXlDFbyQ9T/Hs32EIADi85J/+oPYTUgjcbF6lkQL+1Bzf1FnG67ugLVh2aevtFXUXoGykkPApi13P/ZzC7f+rtCYs1mJJzm6jAiRY+P7r5an88AXq2Di+Uowd5TRPlFa7L7pTJ/XtfSY0jKfKPnOJq6vCT/OU/w3QlX2YMrHcnOjb8mjnlJ8QnHo6oxP0LwO+xfugH6iQZ8Nv2vH1jXaR6iOXkF6o1SsqC+TogoXeeO2VUTaHwj7sdo/zeVyAxey3Fg/d2heQuGljMsy+q86t8pEclNv0prYBlwEaP4cniDbotlpnuCcNyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U6XXcYxyJ1Y/ypQifwdhEXQNhDcfKhV/QLp76HNkpBA=;
 b=jOune2iOmt6s+qN4nizBpTdZU1BTfacopypE4awjDm9tJs35nWRBnq+ZuujvPPPS08eiA1jYpoGrbaASGhPMPgzXAcDiVZtFwqirT82+C8tNXnETN5vF2pXwK3nwVdk7sN1eD6mz+qnYTKeehf5OG7ExRG2jD1cLLDl5XiBQAMjozdeTh3cCcku/XBc5prMApoPetBVR+jjE69glSQJePs39CaoeIgjbye9JmhiXmvn44KIUX1Gz3R4zN2HuqMXb3uKdGE2niIcsvH3c+OugRIhB0FcckFRBQVPETP5gPtyCtkdqLS0dc9PuAPD0McPcH1LCA+NUfCrtsqv90cHx6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6XXcYxyJ1Y/ypQifwdhEXQNhDcfKhV/QLp76HNkpBA=;
 b=CeC4jfnHSDxoN8bcrRGJh6WKiS0UJGlFJmQnnJdg60Sfv58OvCSXq4NGH66sfqj3LV+Hr9oD6i54jDvvF2sHzD4tRog7cekFYewHhx6cEYnDmhJwfLwXOrq+RMvsXRUyoO25HMMzxYo5LaO/b6cF/CqrrZceW2sKps10sBKDNnJfE969BpLc3F6mLK+OzexhRrdlL5MR0AKyW3wDbwub1RfstQQiqaD1Jh4DBgOOFplJKucWXiqEOuWtNDwdwUrzT9L70hqckAgXVQCqkoWIuJgk7k+ikSzTTNkux+IVNjFLnAN8oCPc8hgi/96a1xOKYtRkKs4FQ8CVaXKNUsxelQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:17 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:17 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 17/17] net/mlx5: Allow future addition of IPsec object modifiers
Date:   Tue,  3 May 2022 23:02:31 -0700
Message-Id: <20220504060231.668674-18-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3dd42353-c5ad-482c-b95b-08da2d93c82c
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00064FE404C2F0BB512B4790B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xjEMB8bBIAxzPSVlTRwCTszEu4W6oWUkTmVlOWi7xVsprMd95c8hkGftrGP17dHyibfUbk2dEVL/AxVrD4wkX09nZeXZKY3m73rXwwHtGcHHFhyErjrtRuC8+Re03/czg+zxiOGQOoB7l9MsUk6qcIMaVADKieJmyxnKNpiVxf/VmEXbi4WqPiMIJfjY8RuoqBgP66JFp2rLDZygiUJ5g6EGFD8ZOMiMICk7IZdylLxVwftXthvpkUEe4Q8Hv5Zb0Q0L1joDJjOXTdaCAvibWvVoYh6UyWAStUt72oFCF+cU3mJxUEZtPU2uBm1mwYinyMIkKVvhcWFdBwcTTQDX1hQPX91OOtynHTB4n5AQMn/wWs+ZUCuSZUoMGBxTmPZYeU5q1bFWsf926ezRgWXYyv2MsjKoRimlbvKWCe5pd+arv5eVCPrCTFlVi1VA2iX2mpjioTVHMf0geZRp9CXJlYzQxy3GN2/sOlXFFYsUxZlzobV68rU4nVhZ1NWfP+4aHEjuhZvL30UVQK+NyYgJPHFEz+gXoH0ngFN4Veo1JyZOwP7J4oRz/utjJMWzw3hpAUkHKV98rbHkuI9s5jD+6TK8BFqrYqjk1vlCLy5cJmIWLgVuok+eDOeL0/mxt4X92UGeSGodfWKVGQBeTCFHqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f1wXrxf9DeTxdd+MFAVE3T26LB7Oq6HxRUfV9BkdWO4tARpIbyUguzGN5K4A?=
 =?us-ascii?Q?0IizhptM3fi2S5M4k5DDQLMojuyvgaeZOZ64QvwbqKE/ADpuQOteNGh+5HJS?=
 =?us-ascii?Q?8P1lEZESNbrama5vD5a+sfMVQk7OKhjeE/sCf/0P5sJD4Iqefh6EiVblLU8y?=
 =?us-ascii?Q?CME52X/6loxJkytvlWb+jzw0Zyf1mQmdS+UWv3hnSkmMkHn5twfasQExE7hJ?=
 =?us-ascii?Q?NipfBkuMsAzQ5U20+4eC1Xu1FPXsQwURrDWsiKC3aMn3tgsRvyznb9ZzSRs8?=
 =?us-ascii?Q?NzxVNLksdJ8sPSjcJSAuQeogTnDA910qHlwfkUOdWuaOLKIFraarsfIOMi6N?=
 =?us-ascii?Q?LGacYiVY6Ni3sootKTPpm0s2CMiU7CYQobAydNm/Zu1mlQamqXzh2GGCl/cP?=
 =?us-ascii?Q?UwgK1KmcNqT3bBcXhOk8FRDtjP06eeBx0Om4iqFLMX1lB1J6HR0tTrenyPba?=
 =?us-ascii?Q?6+NjcuGaaAoWF3s6oNnyWoAV9+INGEqUffXADmF2/UiKtclP6wBwNyKrFvcj?=
 =?us-ascii?Q?GmTZ+eVAngj+yKFEGN26mD47C/A3JDte+SxFwfvjvY/WsG7PwtwdW2ryjOeO?=
 =?us-ascii?Q?3qQ5qyFHBQisJQXrTMDCYAVxD5r7ULJMymDah2hSJg7qIAvrfdMwrj7c8hA/?=
 =?us-ascii?Q?8DmRdbNmoqTzhdd1AO3aK80Q+G10B10zcF2p8gHPlTb7Xr+CY+iW9SQdNwEu?=
 =?us-ascii?Q?g0O9DdiP8vUp2TkFqKpYvu0V/eCjJD+XDdlJfmjBxg1VDrrXdeCbMaXbk1Sj?=
 =?us-ascii?Q?/kl1f0k7HOgz31e7ZdxFvpNSXvU6t64OBdb2LRm9Iutw76O+s9eUGdbP7t7Q?=
 =?us-ascii?Q?QZ4YnqfzNbly1ZPn2Ax8tktLWUjfKi8UuOhgsjMy7J5UwRpAZwx+bR0gXsWF?=
 =?us-ascii?Q?5kJw0fjAo9zEJTx8yFbM8Vztvrwp4LUZ1/v+b26OeUdkzRzlxme35klYvGII?=
 =?us-ascii?Q?+eXqVfiOC+8HJfz2r4ba+1gqa2pxuelSwYog9RT2+tpJZWN5LZ1osuq4CaUn?=
 =?us-ascii?Q?nERy0UjKJfF5IU64YGkpr44oUtMJ0+MQo4wXYitikQiackUYcNnZk3T3WXl0?=
 =?us-ascii?Q?eSVjFXoZsLwPK8BEX0B7/HzgZ+obaqCyaVPqp1J4AFKV6kz5oPDQWYEScegI?=
 =?us-ascii?Q?WmHSsNG7y5yY7ccRV/YEHKOliImNar0T9U4W3rlDyJJLDNA86VvvpE5qspZC?=
 =?us-ascii?Q?eGdJ7eLAMcm0Te12NXJgadLKeYcIxnlvHiryN6vdyXlA4il4PoxhfDQrW5Ws?=
 =?us-ascii?Q?I/sx58LxVv0l8H7dWEtz25PRz/4JNvlZcI2Et1tnEXCjvqEgj2ZbgEyqDK+p?=
 =?us-ascii?Q?3+g1iukF6AZUC7DxXx0BkHheYk+cdYcTROoa6x7IZ9W09Z+n3hUO3kHZT4LY?=
 =?us-ascii?Q?zY8v91BqDSTLAEBO3TtMAGJeDTE0FD9bFPQ21zVqpKPQsJhc8gPBxxu/UWby?=
 =?us-ascii?Q?h9UHH4W6Uxxgd8SW/r+wVIkEF1YB5+G9UxgpZTY5mS/PJ4G0bIfDQC9GHBuh?=
 =?us-ascii?Q?hl5LYhRihkUQU+fNUtKYL6ckv6bGpRVELr2XEIPNrtetnGhj25NFCl0Dlkt1?=
 =?us-ascii?Q?42bsMeBBLyu7s6nyyFk96bQAO9bJ9OOb144QDoS7sk11eq0i8uvg8Cp0zUE/?=
 =?us-ascii?Q?xFIOMZ1AnnQInjWrCgwPUZsGsBtzoKkftB3IHi2TwvFBA0E2QQG9kLDIESUa?=
 =?us-ascii?Q?PTgzEBy5rO/nvC4JOPQ7oEltGT1GiV6zsn3gqQFZiUbCLFgglJGnSlmX43su?=
 =?us-ascii?Q?IXJb2SM69qmBs5faIfv+L49+PYy9Wrz93VLkdwmGSbWafXR//6ZV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dd42353-c5ad-482c-b95b-08da2d93c82c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:16.9256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bv28ZW67tl7hbsbAAgPAeaxl1exNKDyx7hOvUKPzCpovrvR/15v7wiXjz/zla1be17BXBMqfAAVFCw9R4ZPISQ==
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

Currently, all released FW versions support only two IPsec object
modifiers, and modify_field_select get and set same value with
proper bits.

However, it is not future compatible, as new FW can have more
modifiers and "default" will cause to overwrite not-changed fields.

Fix it by setting explicitly fields that need to be overwritten.

Fixes: 7ed92f97a1ad ("net/mlx5e: IPsec: Add Connect-X IPsec ESN update offload support")
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c   | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index b13e152fe9fc..792724ce7336 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -179,6 +179,9 @@ static int mlx5_modify_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
 		return -EOPNOTSUPP;
 
 	obj = MLX5_ADDR_OF(modify_ipsec_obj_in, in, ipsec_object);
+	MLX5_SET64(ipsec_obj, obj, modify_field_select,
+		   MLX5_MODIFY_IPSEC_BITMASK_ESN_OVERLAP |
+			   MLX5_MODIFY_IPSEC_BITMASK_ESN_MSB);
 	MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
 	if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
 		MLX5_SET(ipsec_obj, obj, esn_overlap, 1);
-- 
2.35.1

