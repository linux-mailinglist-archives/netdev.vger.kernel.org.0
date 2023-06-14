Return-Path: <netdev+bounces-10723-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B78D72FFBB
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E60B21C20CC3
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94548AD30;
	Wed, 14 Jun 2023 13:15:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF2F64F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:15:17 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2093.outbound.protection.outlook.com [40.107.255.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F66212A;
	Wed, 14 Jun 2023 06:14:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRG9AOm+txsvbDJCWU6rthLI+OkxwunIBdwGR4PADiG7Vo+FllGqEhFB1Hh3XRr1pw3Z1NC2tkimexu3bOd3yBP3lomLSIZgpUfJfSB1Nq/4vjsZg4H4P1RW9Fvqq09+fAmIuyEPoMVDYLCGxYwgTky5fxfFbRdLJm9DeqClsv0nypuZAbR/yiRJ9zOaPSWN31RKxS70kwKHkickqigq/X9CE5ECrRta7VCq9GeRvsOVoxfiEwUa8akY54amltz9BgT/ruglxsSXUcULeAVdYEQNqdXaP4NPH8RK+Tme9+oAs9A+S1WN56x4apMMvpNvG56a1WnBgJYM6Lbz7/hG4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=it1aEpwD6cSUn26B4plifmRXAsc5ho6Dbm2LpWdUnLo=;
 b=cYvU2SZN7G4jfzs04nEUVJETWGlrMhfeLk8TxzQTQ29r37TXhZztkEVFHM7So09mKRA4TW6/cM0QMtzJSbK2fknPKcDfw4XPJuRCg5C7P8ypm83EStO9pENWkhn9f7vgQlLuoergiKWRO0h+5vQLLrhBvUPnaOYdmlMXhgqYhmmTqJ/ub1Q6vghq19KRJ5swxoyyyw93HA351u+O2ckjiyEkd1ZJcMvZCtH/Z3zlt2Pzl5l1vN4r+Lg/lZIbno0PMJUtBrQSP9tHb74LzEFhHKY02BrtsYnoNUeREH8IOHKn2yAnvOQB9gbg3BWBqw7IvBpLjEw7xPotmQlrVtncFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=it1aEpwD6cSUn26B4plifmRXAsc5ho6Dbm2LpWdUnLo=;
 b=pvsAQyFnDGFGDSF+sJkgGyWbIM2i1AAvPGqNDNhruSH1i3Za+AvS0rQHusD1VSXSuY8fwDlGn6vWEI8R9tG85rQDQ3Kl1Zqi+habbjrcUApWMDqjvsQcCFyiVDWsbHOezbVbxIptc0ZnuPzyqlApF3B6jLRY4bDMv7BMGkJaEV1MrhPmX6hS2GXO2SwbmNptTCBSydbiDolVmCBni3sT/RUvpmluHvt83z23l2zf0AVXuuisFQKzv2kFasRw8XCt8nxROc2C0owePNuzDFl1BwBMC0Wp8rsPvuuytmZYsn4YboxcZlubHFH/E5h0KsTo4TUuK7Ei3uXH7TTINg3w2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com (2603:1096:4:d0::18) by
 TYZPR06MB5249.apcprd06.prod.outlook.com (2603:1096:400:1fb::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.39; Wed, 14 Jun 2023 13:14:23 +0000
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::7dfd:a3ed:33ca:9cc8]) by SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::7dfd:a3ed:33ca:9cc8%6]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 13:14:23 +0000
From: Wang Ming <machel@vivo.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>,
	Mengyuan Lou <mengyuanlou@net-swift.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Wang Ming <machel@vivo.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com
Subject: [PATCH v1] drivers:net:ethernet:remove repeating expression
Date: Wed, 14 Jun 2023 21:13:54 +0800
Message-Id: <20230614131408.3097-1-machel@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: TYAPR01CA0059.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::23) To SG2PR06MB3743.apcprd06.prod.outlook.com
 (2603:1096:4:d0::18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR06MB3743:EE_|TYZPR06MB5249:EE_
X-MS-Office365-Filtering-Correlation-Id: 40c1d1fd-3e19-4f35-a65f-08db6cd945aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	i1pgL+REtID+Qd46LBtZMk59M5cF6yxS0iuKCcfq96xYjj3CCXu5tieacS9uAyn7UP1BU5tvk69zGFeFkHvg8zAbfTaRM17Qz/Ax8CUl+rvUZijAmoy7d7xDNXiMk8K1vr7MIhM4rkLtODHGVmSDMEZ8If4ML7ULd5YSZQyK6rgBSXStUB0SJ1vBIx7de1MUgS/7RONfhZYmFbYZ1V2L4OB3/cnLX0BWwwbUtd2bNBKdlyV+LYwXzLYAxg9EggTcjKjXK6DbyIC7HUEOsvXvw3J+Hvgf7ZYTFVM5uFDxK6UywTg7TWneDthHS/zu7Xq5l7kbP6c0iVSFzAcMkM2i029a62FMwu8f1ECMaUEUhpPJ7Z/h2eHRsDxcHd1N2JxU9sqBCZnNSn0uT60IliWFz0ve4HmSNPQlQLBG5yUBhTtT5Rw3CJdBnHvcREl3uuw+sKGfr241veekjW9ZAS2FThoIWcZvFroIgaq+81jvjOyjE3cVdewn6yJcO9aQ8a6yeh1GaBitBjMxsndz4n3NF0iYImSCMxohMwr4Yq4J0yWgIGY6VwJVT2qDCty0TD3Unhrly7dSWxB7fZNM1IDVwDOlaS2udPGvtt2rnkiwU61PE5sCWDClQEWimdSITm14UEnfqWjrzH7TAEeyaH20Cw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3743.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199021)(66556008)(66476007)(66946007)(6666004)(316002)(107886003)(110136005)(478600001)(4326008)(86362001)(36756003)(6506007)(6512007)(1076003)(26005)(186003)(83380400001)(41300700001)(8676002)(8936002)(2906002)(5660300002)(6486002)(52116002)(921005)(2616005)(38350700002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?30EsM6kV7esIa1VCSr7nZEK9iTL2F2TQhN6ESrN+JvMv8T7CJxiQKribgP4K?=
 =?us-ascii?Q?wUuIv1+XK2jlJgjtpPgR3eC31qcXQ2U0mAVt4xfOnPF4o3EHZRwZ3uOu/0N7?=
 =?us-ascii?Q?xlMRbWRYwccFg+4y2s3jO7ts66RDL8HY78Z1Zb2KK+PbWbRn4UBXrAVap8Bu?=
 =?us-ascii?Q?bub2VbON6IRGOw6/o6DGNMGRYiw0zh4k68ApN8WtmRbms552zYEJz9Zj3W+1?=
 =?us-ascii?Q?jN/WJPxjb+3A7uGwkZx3QHjDHZKvo6QYmD2qdrDY75NqUhP9lHxzcLRM78AF?=
 =?us-ascii?Q?C2pyMTkF4+2L2xT96BBuRc+8IQVlZ9uFuwmiYBrWL9YaA/v5s33ldRoQ9z+O?=
 =?us-ascii?Q?NiLAitrdNx4AtNIbWGcmhlVcGMsIN81RP9XdnQY7vmXlLlZ46RR1gE8+A3Vv?=
 =?us-ascii?Q?O3TuKUG83wHIgA3VsyYPubnEmhj4/9i3eKl2SznsAehwlqt39d14+Utjseu8?=
 =?us-ascii?Q?/2dM2lZz0lPC8INE1ldSjUxAvVZQqW7UXOSIXy+k9D0eFwqFkUiPm7FSdDMb?=
 =?us-ascii?Q?00/2gpOjQnmdPn97IUwnvWppRgeYqHoMIb/BZDGEsJ3oaiiwg4rR4gCUqSCY?=
 =?us-ascii?Q?BoS8nKSuZKGpXhrX5tDKZnpd5fYFOB1Q6REB3Rk4Cq+5OBqanPVRuIQOTU25?=
 =?us-ascii?Q?ZHcYEU0kWWCrsotRVo26esTb8jPX9/F8HkG5OCQfkhI2FoBz40SDfYnvXDpC?=
 =?us-ascii?Q?5UC+7Ge5fF607pVrI71Q2z7LPIiUduRJuUYE1Bw+IqxoeSW5394lcNKFsvWM?=
 =?us-ascii?Q?+g/gWRREcJ3g2l175arZUBgbLoYMz8cKkSKfvW72NFsiYTCJ3nNDisc/db61?=
 =?us-ascii?Q?zPh9MmKVB3/is+Dwl3cDbJjBmUSxHZKdRuTFQktTrjyADuZneLn7sKe3ZByr?=
 =?us-ascii?Q?ca0pY5K+tPTiGOcGfBrWWD0F6oye3WAMkaiz/6gPMu9wJhpbc+wEeg0/J1xF?=
 =?us-ascii?Q?UTbtWiYNFi9hJEEohTBr9UiXAPE1DOjlIGU5AzULapSQePOLBteVxKPDf9tw?=
 =?us-ascii?Q?j8tgxJ08DDdotOf3jAgwcyjEpcbQ1XFnP1g9cYeCB5MBqGaUu/ZOaYdTw91x?=
 =?us-ascii?Q?hoigAikCgtz0S6DP8OWTjsrSCFzqRboxGneXdySnIpNTHQh5pk3LT/jzdwsm?=
 =?us-ascii?Q?eLFEE2qcGVVeT6kR4ftEVsMfY3RQMNXBP/CaR764aDNHTYgiiy+eQBN7a9nQ?=
 =?us-ascii?Q?A0Y3ToEN6jMl29P1mOwtb2gRzi9/rZR4jm1oekgiGeWT+2EUJNKhXTGaknzX?=
 =?us-ascii?Q?YYF4MyUVlQfsyfHdDDDkJhF7c4bQWeRjOnx8Px/0MqPWb8tpkwDXhw6YjJ6t?=
 =?us-ascii?Q?gh52SWxSg2Asbwf7oaIHAhbP3VE0SLzBvb2CxQqTRM4NC1URoNrfluhkjut/?=
 =?us-ascii?Q?mg1ekBPgxqc7BZPE1yDsJPCE6AvwkPAtFdmJ/AXdBUMno0/J5AMCWSvOBRh/?=
 =?us-ascii?Q?cAQFzBKl0/ZfttEPqeaCOjTacyUIArYyisnNwkOw+X6KvK2hAsB2/k7h7vWk?=
 =?us-ascii?Q?cjOg7x8GBjmqgTdmMR/450xaSUXChUsRQvpj3OwdbpscqhXtozF+OsSh0/3w?=
 =?us-ascii?Q?MiHVEY0kh55MTXGEaoh1pXzRWmJwZUW232tBbE7b?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c1d1fd-3e19-4f35-a65f-08db6cd945aa
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3743.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 13:14:23.7389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: omMNUrpBDm2AN+V9VnbzxuxeyndvXvNnrdUp/Y2O5NH1urhUU/gnMyroClwWF2eqxTN29JCQX9hp7oIkq/J42g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5249
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Identify issues that arise by using the tests/doublebitand.cocci
semantic patch.Need to remove duplicate expression in statement.

Signed-off-by: Wang Ming <machel@vivo.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ether=
net/wangxun/libwx/wx_hw.c
index 39a9aeee7..6321178fc 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -1511,7 +1511,6 @@ static void wx_configure_rx(struct wx *wx)
        psrtype =3D WX_RDB_PL_CFG_L4HDR |
                  WX_RDB_PL_CFG_L3HDR |
                  WX_RDB_PL_CFG_L2HDR |
-                 WX_RDB_PL_CFG_TUN_TUNHDR |
                  WX_RDB_PL_CFG_TUN_TUNHDR;
        wr32(wx, WX_RDB_PL_CFG(0), psrtype);

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

