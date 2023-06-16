Return-Path: <netdev+bounces-11352-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E153732B3F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:19:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F5F2281669
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2EADF62;
	Fri, 16 Jun 2023 09:19:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B952C8ED
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:19:13 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2131.outbound.protection.outlook.com [40.107.215.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77885213F;
	Fri, 16 Jun 2023 02:19:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJLv4UAmOOJkC1qLw4uopmqfmMSEc4/+zkbsmuqSsV2xADTePEjRSfyDRc+kQRhgsp5rAUt3sRPuQfRnyki0BI/CWcnwXMuqn4gNzh+hipBHIuYDnFZbtqi4rX0ke46xSG3y7gPhGqxzDngwSGPLcwnZJ11baTyoOih25PP5uuL4xl+uwHSRspzTgQUYGl8d4BvcdX+24rif8/SaNANb2JOh7ByHRft3Xr8PhYr90JgCO8yE4ZyrbNwCoCqTQ3YyRdGLLa7P723YofmLKSikguwa/iIJqRppEsVDm/QUr7l+nbf4FqRK+jp/XkXNQLa1ar8JWDZsaYVxSdICAAjRWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1fTmVQ/Nno+8zd0igo4h5Qltk6mA902miwye7qBYgo=;
 b=SGlYBovh7H0RhbiHH5msDkDfEvNrQWpHBr6N9ao6aMiUlv7IThgmDzkVuR9qSRc1SfShvtuFCx882LpWaZHj+Gi8z5m+hb0wfsbAcv2gClqWeRZuRtd20bl2wJntMeIw/vcO2YxK4RVxLmBFKWF8ddrrYyUQrzziEZ++Npt2ZlZrNAX/vXKaErsLbOUVftlsfu26hGI80FBYQl7qSNrdgLDHrCIOhoPIY+t4Ed+TWU111i06j0xfg3KqY5NSuiR52XL9BbgvK+MWDH9Tas7nNzI4MWV2OFzDsuEYymC8rVc2+fb5yPSurUg84o/8P4G2TKfIXb/iuXUjBg/1Z7zgnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1fTmVQ/Nno+8zd0igo4h5Qltk6mA902miwye7qBYgo=;
 b=ZtVYxXlQ1/WbjXDioNoi8UO/jMVzENkS0Ay8D1CEL0+cJ5HxdGIm9HST16CE/mr+VZ65Q6sABZXCrCeEKwq+OS1XqlsjvXTuGGSWzFMmfsC73boYehbbVaF7ivYYEpvxdmJTg+jzoK6dyVd+2SGb0AxDcQIQ6Pw4bMqG4QEP/wd2YZ/oNiajR2id23+aEJn+7KK4z4/StKoScoLUaV1hgF+Y29Ylw7MHFxJpCHKI8eR+kur0bZ/N1o5gKQFiIHFM+4OGEOsVG3RU86f4SVmXG023k4mwYgO8hCqi4biZqFzPPshkUi0qCzRC/S9NvBrXRf715+uSj/YMxdFU6bUdCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from PS1PR0601MB3737.apcprd06.prod.outlook.com
 (2603:1096:300:78::18) by PUZPR06MB5651.apcprd06.prod.outlook.com
 (2603:1096:301:fc::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Fri, 16 Jun
 2023 09:19:03 +0000
Received: from PS1PR0601MB3737.apcprd06.prod.outlook.com
 ([fe80::9531:2f07:fc59:94e]) by PS1PR0601MB3737.apcprd06.prod.outlook.com
 ([fe80::9531:2f07:fc59:94e%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 09:19:02 +0000
From: Wang Ming <machel@vivo.com>
To: =linyunsheng@huawei.com
Cc: opensource.kernel@vivo.com,
	gregkh@linuxfoundation.org,
	Wang Ming <machel@vivo.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-arm-kernel@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] drivers:net:ethernet:Add missing fwnode_handle_put() 
Date: Fri, 16 Jun 2023 17:15:01 +0800
Message-Id: <20230616091549.1384-1-machel@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: TY2PR0101CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::22) To PS1PR0601MB3737.apcprd06.prod.outlook.com
 (2603:1096:300:78::18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PS1PR0601MB3737:EE_|PUZPR06MB5651:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e8e4fb3-9502-467e-ffd9-08db6e4ab98a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4fuSAys2bTH2eIF0bNhr7HgqELNjJjCgwngyp1/bQ8k2UIOTDTcCFtkIuEmZtwRlIVQXgnoWr4wGZUfJTrdCRtaV363JCX/vWkjSsiGqKkFcSUrqgyNV5bc+v7iiu0vfrZ+LBkvF07vZ5yZiVBH+FeM/AoAVHiuApwBBKi2NJ8dFEN+3LbA0ERUt4+qTS7QcIjg1p3pEBZg+uUOyYJ5RnufheEGpAH+QXoveNjLfOsxC2L+yuw8/SJa7mQGZf/r/vnyOqMnL9/AUQo/UBgUhWPOUsclT/OQS7JPSTrwIMUQq7StwfJGG7Nm/MQlmNrCOw2OUZfi1/mAGZUTGhvcgvEUENC3XW2LQxkOw60qzPCpik5t2w4SPQM+4PXANM8Ujy5bw8QDFxcywXZYBGEg9WlvmQrrekNFb7ztnNPZqm+JoO7xsEupttIwc6utwpiyg7N0O0uIDjhrN5MyeOLSoQbtjwsMxjyRFohk8QFWZ1dW+KgbXiGovUgJ3dWzvxj1gtB276/W2S4oJd++XilchVx8rF1PF2SuIiI+yskXb5S/0XqNbaQ6vsDbOz5rMTfoKDoFy4Vd/7khCZyW9WlVAtckW39ZeNwB7crEqwnKCFq1Or2RvhfNk+9KDFsvMDs01
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PR0601MB3737.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(86362001)(7416002)(6486002)(8676002)(316002)(41300700001)(26005)(5660300002)(83380400001)(6512007)(38350700002)(38100700002)(52116002)(1076003)(6506007)(8936002)(66556008)(36756003)(66476007)(4326008)(66946007)(478600001)(186003)(4743002)(54906003)(2906002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rkmg0sF+qynwYuTa7LrQGKzfzXjanMRNDxfUEF1dvuyNh+81lG0oCLSeXhTT?=
 =?us-ascii?Q?q8u0ooqqaT3OaYf3qr5ofS/CF9Gfa/qZI9Sgso/QrvYyw3NpTU5n0Rdo6gzw?=
 =?us-ascii?Q?oAznCD3tIaXtM0lboOe9EJ1KW+j2Tfgu+qsXbgjIEW7ljLgSldLRMs3AmQVB?=
 =?us-ascii?Q?rt9xpsJN1oURBGg0UrfxZ72xMTFymw5L2EiD+JUoaePxvv8D87n9JPVhf1zW?=
 =?us-ascii?Q?ZFOyAr7OS/4bMghoaBnnkDfFkobUi/885699b3TQJpfuk1R0OcHbrBQnU05N?=
 =?us-ascii?Q?wANpz/WPRgJdHCmKMXHY7aXT7KMP8CNkSbD1bnbw5kg3S25N6aJ8XGonUEMK?=
 =?us-ascii?Q?IQk775xf3CbYCz4XaaLBTS/U6LL2MNbr9lUBYVfDHy2i0eDxSCbf5cuBBYZx?=
 =?us-ascii?Q?Zl37ujE5PVguTLutwSEtRlnepQnopAtgA5P34Rjvo5waW8Y9FAauP8Ti/uxI?=
 =?us-ascii?Q?NzykHkyZ+Ny/uJybzk+DBhFOqpqZUUZ6RPijin8n3amVqqkwHMPe9ryWc/3t?=
 =?us-ascii?Q?y8+MOV9vIBQpCUDeFNwQnwSqSWlJBHyw1sbhkNiQAG5s2IRO/vKwZncY4dh2?=
 =?us-ascii?Q?yOfMUqNEhkaI3WWBNndc/SneQpt8L+VYJAgesErL9YwZDFFngaUZEoM48qFh?=
 =?us-ascii?Q?oNiCd5eKQZV8gng14zPtpn1gDm5vCKxkF0cd7pG6nM0oIrOIihC8jewmyuN2?=
 =?us-ascii?Q?0igVwY5aybUimYEeQ2Duo+zm3uTbdSH8ZWOKLgOG62zLDzAtid1BruV6oeed?=
 =?us-ascii?Q?bIojEGOtdyAu9K4g7XV1R2JCTDyB0f+ZvAjDqxoiGn/Yqq3HkEVkqSYzZ5Bs?=
 =?us-ascii?Q?uCIGCyrBrfiCvVjCWwmGfwxkl9vVuvZa3XYEjQNq6ivKF8g7Qb9TD0hUtW1H?=
 =?us-ascii?Q?lFikHkdshd+nOP7s+aO7aN1TTm/O0KxqjdoMNGzp6YcceLxtDr9tD9jDwu0s?=
 =?us-ascii?Q?FA87joQUfGXSKBpzOCmag3g2r6Y2pbr6W/8WjioPUeg+ckHMyZiaQ8sk2zTq?=
 =?us-ascii?Q?8z7RSv+fOt2b9NOfkYovMMNJLEnrIvf55+zPjqSv6Q8Zw607FJ6Nzzf8APEL?=
 =?us-ascii?Q?4nNKUnn2++5KVxgrSMV6eiTDpv8VP6Lok98JT7AK3wxtV4IIwjR02Song9jM?=
 =?us-ascii?Q?9iBiaJyeBSUdF7QwDRT5EGoIipJ8m+rsQLszWvyqBiR3MBW6gkagBc7bQCDF?=
 =?us-ascii?Q?zy2rzebbPCaA0/sN+qTXbiVeNwwBwp0AK5YJBCuCyY9RQ6A7g0U8FLQdJ3SU?=
 =?us-ascii?Q?Fxq39c3bRnNPlZY5ADVOJsZ0o5Q9yONrhXSNP3QJr/BSlkoipvm2SZZfkCO/?=
 =?us-ascii?Q?vPQCqeWSrvd8SqAzmVxtOSE/Pwtv9zSS0PHeIUOh0n3Fop5LFHlXW+dSm0vZ?=
 =?us-ascii?Q?8HWbnB/Vn9kvxWyyPg2w1jlvTvHJcpUL0/EXb8rnR8Btr9zRenB7LmmEpgnw?=
 =?us-ascii?Q?FjM3eV9y3qPwb6EiC/PRXVpv3eAl0CaAEQi2o7Qiz67yYy+GHNjI+TFNaD3s?=
 =?us-ascii?Q?hMAe6XoXJ4N4GyJKEVGUtoApbrLyZ8kkokN7B/Ht+6flVzf3Bb8vE1p0yRQK?=
 =?us-ascii?Q?tyFoOCj7Vzj/6BFGKiamhT0LifVHYnAKdfmAOJsF?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e8e4fb3-9502-467e-ffd9-08db6e4ab98a
X-MS-Exchange-CrossTenant-AuthSource: PS1PR0601MB3737.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 09:19:02.4772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qCIMiZHnIb8k+TG+lhKH+koEp7UlYr1JJGQGv7d2CFuBzeMxJ6f3GwSX8umEsoFm068dOJvJ+J3voPFWJl2CdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5651
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In device_for_each_child_node(), we should have fwnode_handle_put()
when break out of the iteration device_for_each_child_node()
as it will automatically increase and decrease the refcounter.

Signed-off-by: Wang Ming <machel@vivo.com>

Fixes: 53ab6975c12d ("Add linux-next specific files for 20230609")
---
This version adds 'Fixes:tag' compared to previous versions.

 .../net/ethernet/cavium/thunder/thunder_bgx.c | 37 ++++++++++---------
 1 file changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/ne=
t/ethernet/cavium/thunder/thunder_bgx.c
index a317feb8d..d37ee2872 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1478,8 +1478,10 @@ static int bgx_init_of_phy(struct bgx *bgx)
                 * cannot handle it, so exit the loop.
                 */
                node =3D to_of_node(fwn);
-               if (!node)
+               if (!node) {
+                       fwnode_handle_put(fwn);
                        break;
+               }

                of_get_mac_address(node, bgx->lmac[lmac].mac);

@@ -1503,6 +1505,7 @@ static int bgx_init_of_phy(struct bgx *bgx)
                lmac++;
                if (lmac =3D=3D bgx->max_lmac) {
                        of_node_put(node);
+                       fwnode_handle_put(fwn);
                        break;
                }
        }
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

