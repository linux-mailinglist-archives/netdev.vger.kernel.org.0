Return-Path: <netdev+bounces-11028-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF8A3731276
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31B6E2816D7
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C3C1FAC;
	Thu, 15 Jun 2023 08:41:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325CA659
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:41:49 +0000 (UTC)
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2108.outbound.protection.outlook.com [40.107.117.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4228630D6;
	Thu, 15 Jun 2023 01:41:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1DLDP1JXbyfZqapiSrzPKZ+taFALgne8KnbvVZWPdxsyFMM8e+WemVk+TI0DE+SeFotUGzYOaWelNg+trp9jYVsLgtDMBfuO9Ceh0J8p55zTxQzdfPesYzeG/PrNFK0CuYSqN4jES+2xC20qBgYEpbSCURD59/yn+QhDKovgvu7bZ8w/BYUou9O8r1lgqdWp82hGC3Wi+19mKp0QtsCnpvGhktMsbQxLHXhSl5DZW6/sgL1dNFDh4bklg4jzdPaIRzdr/1dhws82pTMsF1bbVHd1RFBPfnSr98IjLaafvBnnq4SMjEddHr7FRFIx56L0gy59H+mIu/ZVM0809L9yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fktDrnNUmhQqThz0W3Jtb3KT+NRL73EOo2ys2DK1Xto=;
 b=NTi8U5xn1IviruMlHpa1LmL9CeG6MSBFKd5NfOi4sA863PHiDrgWjNMOz+kYE6PDKiQsq0hk3nr6FaO1Cr6O+H2l2elTPa/mssQf2MO1bV5Arcg2Mo1LH79QMmSRM66dPnM+zet5dgWqLcd5YuGwupy7LjOkKwTZb4aPH7P7alFPvkznSGoBHlw3V+RIIU7HNcKKcqRSMyUaikHamwHJjFjI7cXmC2PQfR/7tAV+fye60654XbxgBuk/yOTB69F8OROUcFbZOQolj9kDWxhRRSP/Y6rC/aac9NhQ6ngghJcS3LYkLcIm5LsAxEoCWHyvBxAL0FGLbJqFLWUJAGyn+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fktDrnNUmhQqThz0W3Jtb3KT+NRL73EOo2ys2DK1Xto=;
 b=Nsc4s/kAZnZELIkcexQAxdHygS7GGiFi+epnHcP1sGqkPGtq2VdeX5Acl1vUEi9qWcZdRw9PI+Ybdokg5Xb1b0QWb6xlfEvEQ3sWVOXKh4/oGkhzsWm3kFaa6ap602+wB+SvS24/1USnNI9/R98tjgSKMsQPlTrpJF2KPqSTt1yGWKHze+4sPOogj0yhCqgKOwP3vodrinX8iYqOvLBgqTodY3hrPik8mjCdcghkdbVA/4K9eN9V4YAuNUlcSBViaryVef0un9HKfOpEIWzHr0kqxERjCuGmK/ei0w7FUiXsnEyDDQrchfJrBW97cixC0PbSf7BWPq/oNyzfD8S7vg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com (2603:1096:4:d0::18) by
 SEYPR06MB6203.apcprd06.prod.outlook.com (2603:1096:101:c4::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.44; Thu, 15 Jun 2023 08:41:24 +0000
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::7dfd:a3ed:33ca:9cc8]) by SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::7dfd:a3ed:33ca:9cc8%6]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 08:41:24 +0000
From: Wang Ming <machel@vivo.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com,
	Wang Ming <machel@vivo.com>
Subject: [PATCH v1] drivers:net:ethernet:Remove unneeded code
Date: Thu, 15 Jun 2023 16:40:56 +0800
Message-Id: <20230615084110.7225-1-machel@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: TY2PR0101CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::17) To SG2PR06MB3743.apcprd06.prod.outlook.com
 (2603:1096:4:d0::18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR06MB3743:EE_|SEYPR06MB6203:EE_
X-MS-Office365-Filtering-Correlation-Id: fea87d7d-b94a-48a4-f5a1-08db6d7c4d2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	krCU7+QfCqkpykwVD+qe+EBj91M4Qhcf9M6tQUBeQ8SORPo8CreDuCJuR/dfVwgETKeczZ1sre2gko7b1oAuusmJS7SkroX6LamJM7vTR3jghUXvpxyuGOIf9SfwIQ4OKUSXqkA95Kj3WZpCc5bPZJL3W2RWFbnKKh3Wq04edy+RPPGeAWfYv+Z8IiBcWl4YaqxXI6lOBha/lBssOgFf3O81SEscZLtghOS/eFN9XEmO1bDhqCJbN1aA120Qa4IgSDso5JOJZM8NTtqRMBUT26Zm5bl7a8UiIg0m+89Mf6rNkMyWCWJmG8hOXCJzTUiwrVQPHZQ2afoFrTTrUfoOy6XcSnbwoxHiQAecALfLnkGNoPORHvkv6k+pGwWjIrZuGgeSnR3mR8Y35MC/IR90JySV8S6fxskpd4RHsB3c4GXdAvc/XfTzNfJM1RycUrO2LmwKRl+lt2K/5fxoG8idQy0yOKlANVtB1+07duMbNUbiLayVEN5rAsh73OsvCgvmNlXJ4ahb5wMn3zW2DxNKbFss3sJgDoQyJjHD76JS19naR5T9Q53FxXSurQHqbkbzOEDJgu29c+fVt3LxgWgLgUlfY9E8wsDJQDZ1QK6ndKH1kTFAbzC8PUnV/p5ijRR7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3743.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199021)(83380400001)(66556008)(66476007)(1076003)(26005)(6506007)(107886003)(6512007)(52116002)(6666004)(8676002)(2616005)(186003)(110136005)(8936002)(478600001)(6486002)(86362001)(5660300002)(2906002)(38100700002)(4326008)(41300700001)(38350700002)(36756003)(316002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BJ+uYrE9Dp42VtB+y5uXbID2pBica+lo8iPnd9rDWRudFjWNj47fXICddQVV?=
 =?us-ascii?Q?/Yg/HoWnEmz40AgR3GXTuHaP7pJ+7SyXxiRMZFJVw+7P1ZcldhDncHuCjliz?=
 =?us-ascii?Q?AMGC/ftXnMC7BgS0RHi1j0Xxmn3Xynpd1T18sTzD8cc1sJZdHcCKbwSxNk9A?=
 =?us-ascii?Q?xmmzYlqESyu7/MbaNuY0yx2xoAxSREjyPX1i9cScG3PeUPBshrfAYFcZdedF?=
 =?us-ascii?Q?aq8IUSqkq5lIyMtUkQe/cibc5BD+r188FLeEsGvSlWsDeeN+Ixaf6ac/TXTo?=
 =?us-ascii?Q?41mcdOhfErOlbQKQvpCCKu5sQC66jHURoXGmz+TaJ3R4HSjIIZ7MWzNSKwVl?=
 =?us-ascii?Q?zMrPDPKR8CSs/yw398LCc3PiS0cLAbsReYNrvWP+RUH4zNTwCYSmDj18ET4O?=
 =?us-ascii?Q?Z0+QuOrE64tlhnMIpRGiStcC+Zq19autJ7UgQK+ntWU/jlU35jlKGoKQm/yD?=
 =?us-ascii?Q?tBAV2cBSBbL50viZY7vZSctyEUQRUph6IrQFA6q/RMtp7mtuh/Yj8VCwSk7h?=
 =?us-ascii?Q?RtQt6xxTT6syeWhCC6RV9KTG/0yiqxwfRDPmntI7WRwLp3yvI/R66jk77mK4?=
 =?us-ascii?Q?7p8oagbUiDmGBSTSpEg2iRnh8iJDWDGy54rYT3+lllROEiZ1WPoMLF+ygGDU?=
 =?us-ascii?Q?86fFoK4Y+M0zs3hWyXlQTnWaEqIAcSNJ/PXX6UhvbgOwbIUAMHJ4ZM5hSRO9?=
 =?us-ascii?Q?YfO2dOovCA/cKfgCpX3E7XUuT14kRR4ql1kA1K9tx3P9bYk41EvUOOst10HA?=
 =?us-ascii?Q?4FUH0lV1DOOBIknBoOHhcuoWG7t8ChgIGZJamWvIC/jyOmGuhhfHGshf+P3J?=
 =?us-ascii?Q?5e9JA/hP08EI60F6nmmRNAdsA68XwlvP9rXaggNnaX6h4KOHenmRYlfgRqiT?=
 =?us-ascii?Q?tQYSAsIGWhRxD3J2ZYSvYjwRmuoQhLGUh4kzBLBjqQRQ4z0ozpVSDijxvmzJ?=
 =?us-ascii?Q?Dj/cbzv7gy3q87Kv32QJ2SlWw/EWBnHZlKgtrofGM6fECGMK/g8BPt4clmID?=
 =?us-ascii?Q?ZOcR5JyndMkACasCcBAZzyUh7zLMrXDb2//UbHcH+CINSbxAaF5i+2a+cyE2?=
 =?us-ascii?Q?ZdcbEuWjbuITMVV3G1mRAcrhsXMo3C3CMtlXZwltUuZUSBH5VpDUJzfro5h0?=
 =?us-ascii?Q?Y2X61IZQceUHQY6q4kZYRi/SyXYcLHCMeU2Ldzj1TY38ivKzo2ojXfVOqS1W?=
 =?us-ascii?Q?T5CrHugOLJerXg1kgMY1X6Pxstq7PzE3/c7kM+xE6zC4Y/qe1w0MX6oiWN59?=
 =?us-ascii?Q?RrqBPOaJ/sXu/bbLb8JC+9BmdePIVLKSt/v6dckytY5tdg0IllNzdYI3SFZc?=
 =?us-ascii?Q?CH/BXusonvvBH65zUxJtiiT2Kcbet/UGTtl8LPYysKTn4vl0P6/l4Mx0Wtoc?=
 =?us-ascii?Q?2VN7oqYnvU4VzS7ju2gJb+EOW69Yu/a0asEbQ37lFyKCWleltPS0bEa+YKWO?=
 =?us-ascii?Q?bi5CX1T72D/vt8cFPBBwLaTGgZmeq9NRiyBPed50ol/KbLj6+3SUKO+2oYui?=
 =?us-ascii?Q?3mzJBF0aMCX08jJBJOghB4lsgVf+VHklVt4qAyQq4L4jtJB7AOB54G8jrGW6?=
 =?us-ascii?Q?Galty2mmI9bF2BMo8wCMlSsu+/Hs5MBthytBgXGo?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fea87d7d-b94a-48a4-f5a1-08db6d7c4d2b
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3743.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 08:41:24.5410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kXhdq5heOGGaj048uYxSYWap5LLxoVEmKYfFkkiu5BFqaG5/4cinKFtTxaJOK4lU/02qiQE0KSm6illLf/TSSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Remove unused helper code.
Fix the following coccicheck warning:

drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:808:34-35:
WARNING: unneeded memset.

Signed-off-by: Wang Ming <machel@vivo.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 31956cd9d..ae0939488 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -805,7 +805,6 @@ static int mlx5_esw_vport_caps_get(struct mlx5_eswitch =
*esw, struct mlx5_vport *
        hca_caps =3D MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability)=
;
        vport->info.roce_enabled =3D MLX5_GET(cmd_hca_cap, hca_caps, roce);

-       memset(query_ctx, 0, query_out_sz);
        err =3D mlx5_vport_get_other_func_cap(esw->dev, vport->vport, query=
_ctx,
                                            MLX5_CAP_GENERAL_2);
        if (err)
--
2.25.1


________________________________
=E6=9C=AC=E9=82=AE=E4=BB=B6=E5=8F=8A=E5=85=B6=E9=99=84=E4=BB=B6=E5=86=85=E5=
=AE=B9=E5=8F=AF=E8=83=BD=E5=90=AB=E6=9C=89=E6=9C=BA=E5=AF=86=E5=92=8C/=E6=
=88=96=E9=9A=90=E7=A7=81=E4=BF=A1=E6=81=AF=EF=BC=8C=E4=BB=85=E4=BE=9B=E6=8C=
=87=E5=AE=9A=E4=B8=AA=E4=BA=BA=E6=88=96=E6=9C=BA=E6=9E=84=E4=BD=BF=E7=94=A8=
=E3=80=82=E8=8B=A5=E6=82=A8=E9=9D=9E=E5=8F=91=E4=BB=B6=E4=BA=BA=E6=8C=87=E5=
=AE=9A=E6=94=B6=E4=BB=B6=E4=BA=BA=E6=88=96=E5=85=B6=E4=BB=A3=E7=90=86=E4=BA=
=BA=EF=BC=8C=E8=AF=B7=E5=8B=BF=E4=BD=BF=E7=94=A8=E3=80=81=E4=BC=A0=E6=92=AD=
=E3=80=81=E5=A4=8D=E5=88=B6=E6=88=96=E5=AD=98=E5=82=A8=E6=AD=A4=E9=82=AE=E4=
=BB=B6=E4=B9=8B=E4=BB=BB=E4=BD=95=E5=86=85=E5=AE=B9=E6=88=96=E5=85=B6=E9=99=
=84=E4=BB=B6=E3=80=82=E5=A6=82=E6=82=A8=E8=AF=AF=E6=94=B6=E6=9C=AC=E9=82=AE=
=E4=BB=B6=EF=BC=8C=E8=AF=B7=E5=8D=B3=E4=BB=A5=E5=9B=9E=E5=A4=8D=E6=88=96=E7=
=94=B5=E8=AF=9D=E6=96=B9=E5=BC=8F=E9=80=9A=E7=9F=A5=E5=8F=91=E4=BB=B6=E4=BA=
=BA=EF=BC=8C=E5=B9=B6=E5=B0=86=E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6=E3=80=81=
=E9=99=84=E4=BB=B6=E5=8F=8A=E5=85=B6=E6=89=80=E6=9C=89=E5=A4=8D=E6=9C=AC=E5=
=88=A0=E9=99=A4=E3=80=82=E8=B0=A2=E8=B0=A2=E3=80=82
The contents of this message and any attachments may contain confidential a=
nd/or privileged information and are intended exclusively for the addressee=
(s). If you are not the intended recipient of this message or their agent, =
please note that any use, dissemination, copying, or storage of this messag=
e or its attachments is not allowed. If you receive this message in error, =
please notify the sender by reply the message or phone and delete this mess=
age, any attachments and any copies immediately.
Thank you

