Return-Path: <netdev+bounces-10996-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7317C73101F
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:06:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 666952816AC
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C81375;
	Thu, 15 Jun 2023 07:06:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848B4A45
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:06:33 +0000 (UTC)
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2134.outbound.protection.outlook.com [40.107.117.134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280BA1BE8;
	Thu, 15 Jun 2023 00:06:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuIhEneyUk+IX/PQ8apr6lHBxl1GC2xqv7Pk2ERB89NOM7gdbj5v3rsSbJCzVFHiUFtpPRqdA16yR0dPyBJdXslCoqUypg76Brmiv2sETDw1uwA6o4KlArMWQoHxDPR3gmlkdFdxTY/8Ma2zxcSBBcobbE00UWP8fM/socAWtgxozrMLnoqw+CXkG3kWjM4sJs+mLipNbAo4KWGE2kbbHVKniLcmOAsKd6eoe3VnGx9wTJddvatoBak5zFPNm+YGZg7vqktMrHi9/sYyHbevupIvDkpQFfJ1z9gUfzlviXTM60BgEA+r9x8h6nowi7cCGfkNUNmlRwJjgSaIfGlqhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S6wQ6J84mff12Z5tx49mM7GeFhrIDY7X75exnXDz5qg=;
 b=Om6b/gLwXWTmMDDloZ1YjqBDBsVQUIfl91zzpK5j8jWuajJwUk77YII3tVn4Rq0rSXhAzci4Z7Z4FDtXhZAXKc9u6dIGsoJM4aqJjlKfCmvjhEfzv3Pb6/zP7OjDRxEMGNRJztZ8A3tg1dE6UVIfHYfR3T9P1Po8kJG9QaMXuj1E/moR6abSOw81MPif8dgY9zz0j+f2A6K5tgnnxTd7RoE7ElosJLXFO/0Uw+aTmuL9ql3mXfNDiQFL8V1SFzv3rdVSwyZzR74bQ6u/dcpj+rKWyShY8l+Mb/ZHOyOFrGOEVeDs0VG/8JfObFHTCoZ1u2BATJdgssHOzvtDQ/Jg9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S6wQ6J84mff12Z5tx49mM7GeFhrIDY7X75exnXDz5qg=;
 b=W8xfaJBUsV03wr9pE4k5io5rSJZ/a+Dx6C1s3+G+MUar7TEozGUG6I4S3xpWKE2vffs6cf7NzwCen7bl73aWaRi2MzZeG5zGuohu/QgOINQNgCTt5hvg8bS6J9pHgnzspgZ/E7tb+KP9yRkSRybunQS1r6QeudPO6qNwiDBw75qgeNfohY5Te6fjd8/L8EPo7iRknPsS7JOIc+FJRiJRvf1YzNQ3DPLGKO5QfvTzQJCFQF4RvGMjjHT97NzmADAm3M2fYyZvdqjE855WOZ+c+MeBIAsQ6UzrNRoCV7/mmkUA7q/ufF5IQARoX2QVvStpOjFFXQJ5kNJrNReeVueXNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com (2603:1096:4:d0::18) by
 KL1PR0601MB4100.apcprd06.prod.outlook.com (2603:1096:820:24::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 07:06:25 +0000
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::7dfd:a3ed:33ca:9cc8]) by SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::7dfd:a3ed:33ca:9cc8%6]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 07:06:25 +0000
From: Wang Ming <machel@vivo.com>
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Wang Ming <machel@vivo.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: opensource.kernel@vivo.com
Subject: [PATCH v1] drivers:net:dsa:Fix resource leaks in fwnode_for_each_child_node() loops 
Date: Thu, 15 Jun 2023 15:04:58 +0800
Message-Id: <20230615070512.6634-1-machel@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: TYWPR01CA0029.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::16) To SG2PR06MB3743.apcprd06.prod.outlook.com
 (2603:1096:4:d0::18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PR06MB3743:EE_|KL1PR0601MB4100:EE_
X-MS-Office365-Filtering-Correlation-Id: e2ed9da8-acda-400a-77f4-08db6d6f0879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TXWSd0w8c1tsjsmLvwTe7fYYh+zHNsi28dP/143A4qeZeM8mDRaFzbvptb74n+JpXgKKYCvJZ0Ofd3SSZ+sqLeaSmCi1jrRkPXq0JLn65XdzARwRvstrBOH8rbJHXy1J3Y8jDmjTg/bvqVDB5t/iZ8N6zRqu6LMOj1DD2THiGv5/qEJZ39khOU9A9p0jJee5XtEsHGgPf6YFyVYdtBN2Pit2N+kB3X/wPZoirD4Q2cmyboJhuw2N1TQm0PzdL7lYRvPUZXovlE9jD6lZsrmqWPsi7tkS8f8x+gLeBJbUtNrDUKzuPgDZUr3BGIL/VZDOgMHz0xsf3EeZ+ViqZ1Vazji6/tScYqXy7Aoi/qZupnmYKW5nSxRYR8OFqa0OkP4RPinGS0PpwXiuEl68WpKLZ8Lbz2ign511FSdaFiqEGr4276jJ8t8TEKMxbkmyIb6pLGt18AUavpqOBjOFdH8N/lkAp/B74x8lbsTyc2Gf2eX8PehUK2F9z9Ir6vfl54/e/t1qdC+SpSduNXee1/gxynakhC7YgsIxPQbAig+anXlPdw33dss69GH2jbb3jfwTTbaRE589ku/4/7A7pXClkc4PdO+d1/9jKyB2i3D1MMctS3jJYD+x/5ihf1ShzQnBjWeTy2uPnLYQlmRJ1rHOiw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3743.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199021)(41300700001)(5660300002)(7416002)(8676002)(8936002)(2906002)(36756003)(478600001)(86362001)(26005)(6512007)(6506007)(1076003)(2616005)(83380400001)(52116002)(6486002)(107886003)(6666004)(921005)(38100700002)(38350700002)(4326008)(66946007)(66556008)(66476007)(316002)(186003)(4743002)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ans2JvnZ7IESSDNaceCa75h8Jdd1lDQBLzqhBMHGmY0hjR3eVJHDGtEusqD7?=
 =?us-ascii?Q?tIcfJg1kJ2TPA2uwzoPMHsnVnR3AuIWGJjFc06h/LVY5V6/aTFrNYWf2MQRr?=
 =?us-ascii?Q?AARet0LfSFp0wm3Tkf7X1xtSVC8jySb02gCewQ+8Wf/71bfm7nlQlMWt8wH2?=
 =?us-ascii?Q?qrefwlt31yiOco++swCbWfsESQAYWvHGpQ9ZVEXJ2HFHXkspuQoYbZq03Veg?=
 =?us-ascii?Q?mE55Pl2qUYCwuf7iuelVey2HqwccvuK/VYxt8e3EeodaG/SB111Pv8j2lFUF?=
 =?us-ascii?Q?pMleOrS6SnuTbexhQ9sSnQGgzfr7AXJJNRLP8XJ5q8sONqTbda6/w3HQP2O7?=
 =?us-ascii?Q?XbTeHxkCDWmnnfrpni+7BNIvWavwYQyrx49B34S73gUXPm1LYztUZL3uodpL?=
 =?us-ascii?Q?T2RYl2eqgsk5cMXiHtVJMyyMDqXGyIm+EtVUOeONQ5Rkk3gkuoKVw52w6pl6?=
 =?us-ascii?Q?73vamztNC7SxL53W18SUA4d3NYi0af9qkIqndx2be4GUdzDrybd6I1QvJGlk?=
 =?us-ascii?Q?dgBT96oeEu/mmJ/MyslH2uJ0uiJlqZmOdbRUWAAXYlaJypSiUT8MWTjY4CSD?=
 =?us-ascii?Q?CK5dvDkZib4wkhpje6l+Z1m02l9Neb25PKesL1Pf8kODPnTVCfYedX+ieUny?=
 =?us-ascii?Q?QgdAyWg7bhZjjQ3BVNFISTZtggX8ofVLJfuOLoT5rq6t8D5pzjZEW9hIoiPt?=
 =?us-ascii?Q?fLZTMRAZTwTsNDdttm3+iHehTYzXMKW8ZhvU/RdlUMq0klzbmIXYrI4OSt2W?=
 =?us-ascii?Q?papvepIdZWB4+T0d54oZU7/QRaRkqhFewN5Fb8yN3NUamOcRrkizYdtB++9l?=
 =?us-ascii?Q?EQ5Etgiy5tArcwZO27zgMw26bpIYJa/POQGDywgXHYg5UyMhT9o+xjj43Wn0?=
 =?us-ascii?Q?cpnO0+tpTQro/yT7sEmDJ6FrijjIa9BW+i1yiqHWRVKaxVG7OHIQAdOozX+9?=
 =?us-ascii?Q?uD4RmaOyiUHljd6JttjUyVakJJ41L18HMwUi9H5f7d/NmNDR70q/+EZyBE6G?=
 =?us-ascii?Q?AOa7SzUVx35UbyEmAyivT7oAXVLDrC+5tQuhofJfIvIvQ2U0T0gHaIEqhXJg?=
 =?us-ascii?Q?2G8W/8CUVCPjPN35jq1j+Ee5IOnlkNPD1gURpczGLkUuZEhr8cTRcSviLZsq?=
 =?us-ascii?Q?/Gl+ZlXeY7noCv7T3IAIM5yckDABSTmK2QI25iPWF28wP5yPel5r4FTOT2YB?=
 =?us-ascii?Q?zlQmmBJggslctEr5oAjyAn9qI/HTgp9S5p1KId+trsRkQDXLXBuBjp0j5bae?=
 =?us-ascii?Q?69HsubNSryeHgR1PwESm2MLHPZB1CK4Ov3qTGN+q/Dep7SuxnrTXatnNMTds?=
 =?us-ascii?Q?O+YZZwEzE75oC64/NTzQl1SBjgxDDC0CjnxGH1W/eyc32U42ryFDuxjf/O51?=
 =?us-ascii?Q?zkFPPQtePNeElhfIbgjtyZGhW/1Ee3g0LKRkVdA6PkLrtuMBKa+5Df4TcFe3?=
 =?us-ascii?Q?TjkUkE1SrUHSvs4KBXlIEG4Ghn7PLbWXM6tm37chKcG0HTaCoVWhQc4QamKk?=
 =?us-ascii?Q?EHDOUqadYEk/GgtuEPNr8ndyGYGfgtNIGP8T1bKSUmfehlm1rI4snmb0zPpv?=
 =?us-ascii?Q?OfvLYjajUmIC7Xcpf0jHbNjetHIm4Hnm6VxlaxXw?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ed9da8-acda-400a-77f4-08db6d6f0879
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3743.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 07:06:25.6330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dTg6AXjO40ONLc1aZIzDIQvvhf7F8/wXNtsfin/vZ7t8wbU73m0qR0/Q/g4XiRG8liThTuZ2sabja5n1QE8Sxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

 The fwnode_for_each_child_node loop in qca8k_setup_led_ctrl should
 have fwnode_handle_put() before return which could avoid resource leaks.
 This patch could fix this bug.

Signed-off-by: Wang Ming <machel@vivo.com>
---
 drivers/net/dsa/qca/qca8k-leds.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-l=
eds.c
index 6f02029b4..d24ee5df9 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -450,8 +450,10 @@ qca8k_setup_led_ctrl(struct qca8k_priv *priv)
                 * the correct port for LED setup.
                 */
                ret =3D qca8k_parse_port_leds(priv, port, qca8k_port_to_phy=
(port_num));
-               if (ret)
+               if (ret) {
+                       fwnode_handle_put(port);
                        return ret;
+               }
        }

        return 0;
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

