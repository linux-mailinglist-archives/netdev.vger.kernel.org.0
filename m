Return-Path: <netdev+bounces-11356-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2844D732BDB
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:32:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B4AC1C20F11
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37E0F154BB;
	Fri, 16 Jun 2023 09:32:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249B613AD3
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:32:33 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2135.outbound.protection.outlook.com [40.107.255.135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E212D4A;
	Fri, 16 Jun 2023 02:31:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZvsfP/cmSd0ikLMUDvWgOYgiLrfDEQvLNt4h1KSFK6vFXifbfr6sQnBR24n4vxDewu8HR1UwzDDBCbu1txo2m3AIFu3wsp3E48WmZRY5h7GgBhB68YOT1JLMJz0bnFFzF1juSU50O5KpH+9kIRphRVWnSgn51dhBw5TQ/gp9sL37HhnJnFuqPJ5WRNSqxP/+Z+BInquq4roi+BxjBBvNfb8QZvZDc0ZWwv7aQ6OLw1D/MVvmzjW5Fu7IiqNz/rknuhFzBueXT7RGysJdDUeY4ZmV497PzWeua4dEyYeXO4je2KiafCgmfR4LrwfZswJ9ya66nNLvMYZHpN4+Pdd6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1fTmVQ/Nno+8zd0igo4h5Qltk6mA902miwye7qBYgo=;
 b=oFx5+L/aYA1zrmAn1gxNvYN6t5j9U7jkJi5MdBml3izMya3Hd5mhzG9pIz4mOp7QvSvhg0srpaqUh3nY6GQ3Urkyuupp4JHQcRCQRs3xyfBgDVBhHQz7swRrNQTGa+qULrf+tT7XwyMTfo5yD/wc6KI3HfhVkN3auFdLDRxJWvFL/SlVTmfDRbWA2lbEhmaaqdE5YIsGarCJiEf/5vwsxOVJ94tA3tLTjgIXAzu3IYjDnMfS1OFU35RwCOWvex3XEGggabzgIkrfXldX8RG3vNFdKps0LPrLAV7K46qOUaGIpFdpIa8KT76ENJX8Nc9L4jokGqmP7wLVFenmwQPwOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1fTmVQ/Nno+8zd0igo4h5Qltk6mA902miwye7qBYgo=;
 b=lOHdDWpeTWvAGICDirGm5qypSPQLF8fFTYVGMALiA5HaVN1ctAUZ2YKu76Kd6I/BIQTIY8248DfeE55LUH9yN9ZPPjG+Rr+BQEynYrxkqHJMWd5X+LMhE41QGMJ4mJbDlKQlq33JbN6b9E4u9xEi5O8spmTXVgCE/mGSg+wkwy5ISKH1ul9okOp0VXXAApLfWhVunAbSE09mqr8mInZxQTShPUTL0p/q6VCqc2/aF28Z2unKucO0OfsYkivNaB50exII/Nd+v3l0OtSr6X0J2MxZlNmSIerIzE4VajDd5hhsJSrJ/SaXSsxppDCvuDbhKDuU7FXOJ9ekvD9Um8LpGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from PS1PR0601MB3737.apcprd06.prod.outlook.com
 (2603:1096:300:78::18) by TY0PR06MB5330.apcprd06.prod.outlook.com
 (2603:1096:400:213::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Fri, 16 Jun
 2023 09:31:37 +0000
Received: from PS1PR0601MB3737.apcprd06.prod.outlook.com
 ([fe80::9531:2f07:fc59:94e]) by PS1PR0601MB3737.apcprd06.prod.outlook.com
 ([fe80::9531:2f07:fc59:94e%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 09:31:37 +0000
From: Wang Ming <machel@vivo.com>
To: linyunsheng@huawei.com
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
Date: Fri, 16 Jun 2023 17:27:39 +0800
Message-Id: <20230616092820.1756-1-machel@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: TY2PR0101CA0030.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::16) To PS1PR0601MB3737.apcprd06.prod.outlook.com
 (2603:1096:300:78::18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PS1PR0601MB3737:EE_|TY0PR06MB5330:EE_
X-MS-Office365-Filtering-Correlation-Id: afc7deaa-627a-46f2-71dd-08db6e4c7b91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MCUG8D5tVxp+5v0vSQE1lWOtdw4+5gSk2Yaato9pD1gC3iPakVwpEEDVRdYv2iyTYIjhzeeMJ11rPIYepT0gBTu+HTlJ0supGl1LLYZG4qdHegHX7CG+mdDnFgM7WGpl8yM5AfzMg+Lh6Sp/TzzrbBnm18bT8YEmrUmK9HITX0OSxtCrqXrFl1WT5AjFhf6ZuwA0ocqGejm5ZSHCD7Ghm2POGOeG6LOWKb2AJYc3fA4kki9/8OcQ7am4/DAaxHOLX8m5cgg31qQ+kVovX2WQYYBSItkmrYfcWVcOs98hynZRxqc1kRP1aRegqby24eh2sGZ/j9B8sseQBG4TRi8vM07CWK5OFCRjwyii8E2CXNjBc1RqrMnFK6n0IFusEI1W+d6BDm3mu3gBOwJ8loVnTJmAUETHGASpAv30zw7VhIa930E+wS+DYXyuUBZdDTcdIRTZHuYevndfbt1PxL/PFVMI5Kiz99X3vuad8dQY/SFUc7lhRytiJ5OaFZJpgb3N/GyUgAtxFLuSZi4aJGTi7YFRaMUmP94h7+CCoRSJiYFQw4zuCjzPq0T7Bql41YqzJP3aEL+nN6DyFCSlYgaFi55RMcCq3KFIPGzhzfwjunaZyyUvBInWh3xcMD7PMEvd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PR0601MB3737.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(451199021)(83380400001)(52116002)(6486002)(2616005)(478600001)(6506007)(86362001)(26005)(1076003)(6512007)(186003)(4326008)(6916009)(316002)(66946007)(66476007)(66556008)(4743002)(54906003)(38100700002)(38350700002)(5660300002)(7416002)(2906002)(41300700001)(36756003)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CmW28APg6QxjCl9W76/ozZMHiOxFS/KKHG0VmT1eG7q+nSfvznSAh1goohTC?=
 =?us-ascii?Q?khFSDHf5WlEu1wsKSJR0wz7+TngGkdYgamBD+7wYC1QbJfnLKRQlbMoR7ik5?=
 =?us-ascii?Q?QSS5CAXBjKOYsE+39TvWX4T0IW2oP6+8E2xemexUpFvDYlT1G8dDJ2lVUiRL?=
 =?us-ascii?Q?k2kXIHPyFs0xrW86SF/fYLMNquLUgQS1f1+jp1E97GvEHnYNnoB9qKh4HkGp?=
 =?us-ascii?Q?IFfIjlNV7Iyg7flJ+8hkqAD/dFC49A0skBzmuwKTlCNoEG2LFmdECkdJeYVq?=
 =?us-ascii?Q?fGGLT0tlBIYWuQaDT2JZxhgdOK8/j66bhYh5Kk7I9UIMnMmMlkiPWUkS2G+H?=
 =?us-ascii?Q?nNKfcSG6BqA1Mb/Y+Imzkp4YQuNdS2qpnsv5zYmzu1RsfAJSBPoGQhOCSIZK?=
 =?us-ascii?Q?1N/AfW2WS18ISRpMTuucvidlGJxOD0aJdV+RzHWVmW6x4clPIFccvOGExzc3?=
 =?us-ascii?Q?XOrHiSCdYVKcT3K8HtI4cI20/qXqgfh+t3R4hSEDtmTkMLQcUR4CoyBwqF+H?=
 =?us-ascii?Q?44L1gkPeTAS69pDgtbG/BxTbmXbgC+zIRK5Vd8HIyrOD4WclL2NQksMofqJF?=
 =?us-ascii?Q?1TVRytSvfyE4PqWGQjo/3Dy2ANkOZzSAWjelg0Eq4jjX5uuQISc8WKJVBQx6?=
 =?us-ascii?Q?FtT6pWIwcNhfSvdNQkRTMRrH0h0+97RNSG6hQATlg5foEZch7PUl5y4KwQUs?=
 =?us-ascii?Q?U0PXvmSz8c1pGrGZ4xMmp0DHj58d+I7MwRm4YH3kYwZoL99GhclS1mrp9U3+?=
 =?us-ascii?Q?pX46s28ucxTZ0JA9vjRWa4GgRlZpZn0JkcPEsiNxmILZeDI9+r1u+FXVV6gn?=
 =?us-ascii?Q?JdNKqZm17x0DtJ/Fh36blrGqboDdQ5f87FUiz0PNHXXIgQai2XiqqefmhEcK?=
 =?us-ascii?Q?ZPsxnWwho5uu9gTz6ITAYZdCjuGV50o2UCF5hg84sDaFLB20P7697Eu4r4j6?=
 =?us-ascii?Q?DNtn0pqc0kAkU3Y+Dv5wWDva653B3zHXySs/EcVaztH3cMYZi2cQsczZQBm8?=
 =?us-ascii?Q?KAFd9B/yJuUzAOU/AZj+f8i86InYvslEPuXMfDzjkMEerSIoHSFIqHLQkzwy?=
 =?us-ascii?Q?c5tlF8U/35rsfMKW5u/8npCUk6zXpP8JN1k2DCFTtRZT7Itz4+FLAihh6d7Q?=
 =?us-ascii?Q?s8RkO2yv3Qh5KtAmd0qaSTX3a/P7md0MwqkKrt1eFka6kM2gFN/xLVMS5bk4?=
 =?us-ascii?Q?x7frHKZZ77SYqog/owKlWyNjtDDBPsiOSEgv3kvZid0EsJbx3fBpz8aC4GbF?=
 =?us-ascii?Q?ZgWfN/6MXfc3zhaCwE+5qhhKbn8XjwjId5JdsmX7BDReBlxI+4/nPyUYE0Ai?=
 =?us-ascii?Q?Y53qeX+LoUOeKFce52A+N6cm8z2HQQnhOCFWT1+orDsrIzPer7SZ+cC/VXo7?=
 =?us-ascii?Q?YFw1wWCsYZ93f3/WPopuHb8cxMtRbUteeWFnu58+JV1aQtWsdU9xgu4O1Cns?=
 =?us-ascii?Q?kOT5RTwuvCrQR0X6I2NScz7Woq100it//3cu70ghlewcjbiQyaHNpH3hqCpE?=
 =?us-ascii?Q?K9qwoGjJ7UgK9m0l9qdk9FxqfWFhuGvurgq9TgN4n0k3NM9blhFPvIKWBT5E?=
 =?us-ascii?Q?P0JH9obms/7F08SS5Jj3+/o67LZB9vCvemFWsLau?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afc7deaa-627a-46f2-71dd-08db6e4c7b91
X-MS-Exchange-CrossTenant-AuthSource: PS1PR0601MB3737.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 09:31:37.5900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1PjWz+rctC3OhJ/WWCdSvz7pI3dJqXdJPH9mjoetq9853t+3h2T6NiN8tYtaF9zb/F3TKn9ou0BNO7pbvXfFnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5330
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

