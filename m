Return-Path: <netdev+bounces-7598-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2003720C86
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 02:09:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EF991C2123A
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058AB19D;
	Sat,  3 Jun 2023 00:09:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6481197
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 00:09:10 +0000 (UTC)
X-Greylist: delayed 1608 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Jun 2023 17:09:03 PDT
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F96FE49;
	Fri,  2 Jun 2023 17:09:03 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
	by mx0c-0054df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 352NQfg4032013;
	Fri, 2 Jun 2023 19:41:49 -0400
Received: from can01-yqb-obe.outbound.protection.outlook.com (mail-yqbcan01lp2233.outbound.protection.outlook.com [104.47.75.233])
	by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3qucyv8gm2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Jun 2023 19:41:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PErWahYDnvFNOO09Kr08Es7viUMLPPpZTRaJwxsr3zlSwAfOLgA7eq/PBxzL1EG29zGa3SeSNbMoth6rdSwszOq1Q4FvupoXWe0XKHV8OgfW8jLyRdkDTju01RRbi+uyPKuGW3zD8vb6dgrlY6sj0VNHDIrGP0ZCxmGmS+Bx11WQrMGcFELtlY/lPgooFvkjsS9AJjC2BiLCM7BQK2oxq8RnpTZLklUpQSAZoXwdbRzltWwfBUNebUpxLtKvua/8JX5Gh0WA9eXatlwZBQmyjTtowMzHNZEJ7N6+Yiy8dmSpDBGLIQHS8gBTcOFMsLqGv8G6kWKj3I5HRHl5LVMWvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4a1GHjWv48hfwaafWrIPxfPJ79mO/X5LSe03tpJtXQk=;
 b=nKzabZnBAxFSpz4bF5tjHiVZdsraQrPYhoCj82OyRbldzJ3Xh4hLsc5NT9Zn2k6pG98rynUXCX8xujbD2AZqrTKed+ca1s9khrpVf4lrl0vjzVHmq8Zt1Su1Fr+fJJp8zdL9D0UYUQC8J+c6pkEGlnjGzJBjLiDI4j0nAg42y+3HXKbR+FUcZFNiibgLzsp+aV8gKjL2Ib9q6fsiZNK9V3G2yfTWn0l7frHgov+xq/BKoJP3ahHULcDi6JKWCIKzcWSA40XAqiJVda3WkOKBjTCAkznmnOX8mbCZ88ZOn+17YIvxUJXoIkNdhhK3BI8VdpLM8HV+5P58L1pCC2HpfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4a1GHjWv48hfwaafWrIPxfPJ79mO/X5LSe03tpJtXQk=;
 b=pcJuhsBUix4ZPUrTb/Ks+iCNn6zj/YIdzELOdNiKas2N9weS0WNaQn58bvMLORaTZehmu2jDNpyTd2raI5+ilxWzCjIDGys9AvW1+yaiweaB4Z8/Cwg9iW1HwEZua8Sxsv33kugZla0mVcovJqyBYhLfeSpKCREOzLwHajCWpbs=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT1PR01MB8763.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Fri, 2 Jun
 2023 23:41:46 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0%6]) with mapi id 15.20.6455.028; Fri, 2 Jun 2023
 23:41:46 +0000
From: Robert Hancock <robert.hancock@calian.com>
To: Woojung Huh <woojung.huh@microchip.com>, UNGLinuxDriver@microchip.com,
        Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 2/2] net: dsa: microchip: remove KSZ9477 PHY errata handling
Date: Fri,  2 Jun 2023 17:40:19 -0600
Message-Id: <20230602234019.436513-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602234019.436513-1-robert.hancock@calian.com>
References: <20230602234019.436513-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0362.namprd04.prod.outlook.com
 (2603:10b6:303:81::7) To YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:b9::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB8838:EE_|YT1PR01MB8763:EE_
X-MS-Office365-Filtering-Correlation-Id: 6df65780-0a57-45fc-c425-08db63c2edbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	TinmaWjsB5H5D1DzXLYp1LwHe5QkWy7H9Al2rE5D3rptXsmYCjDJdNdpbab1z2U+HhbkthkmPMdQ+tQpBQsaMfvfG6TgY+AkwGf0fg9eKCYFL1Gy4CPMRw0oMXM92XwhmKvMs/JQeh1P6fX1Fa3UapquCbA0K7W6TzGFal6/HQElHneFeslj/6dmzFp25b00s85reEZA2VDuNrCLW/aag4Yjuz6h7fXp3Kvfjx2ugybtiJqnMThj2MxwKXO0uc1zK+n+qO0Zj8ZwZP9mn0JochQGKCuGf9j1lSB9ajy/KtGI8wJ78ooymBosnhX9koB4TCUUY1OcYMp4goSIGdRkxP6bWbmXk7xh0RjJX6zwdSGVZS9bjc6ujfxnqvjitZ4R1jUkmYBs+CqvaKjTOW0iooqzDYAhKvVGtKA+9J5ZWmPPB1Qmh3Yf5LH3IWNkwe1O5hejzBR1BpEfDjoDVyfDuCHLxUVHKKZtM+1waIiVGClJLD5cOirVgxPSY77UpU4rTprcChrzll3WkZbSxToDHn1q+Y/ykzNbQxzL8Cce1+4nt4W70kDHlsI7HAdx00YJzq0+2gEwuSufSvf4s8zGvHBz/5bk/6jLJl83dtfoeq/cfgZ+bLEa+i8vbZYac3zI2UNVJ2Bs0MjbqfSdBDXqIg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199021)(8676002)(8936002)(6666004)(110136005)(478600001)(921005)(52116002)(316002)(41300700001)(5660300002)(6486002)(186003)(26005)(1076003)(7416002)(107886003)(44832011)(66946007)(66476007)(66556008)(4326008)(6506007)(6512007)(83380400001)(2906002)(86362001)(36756003)(2616005)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?LWXO0mFHXSF8JZFJeAgjI8xXDFO3Q2wp/6nnsfrxInNl9uJALhwsvbbx+6zs?=
 =?us-ascii?Q?AquAEdzMpj1h+1sbsS7mh6Glnu4nBRKFRExfN6O0KKrOPNQuzx9UcgDeinyr?=
 =?us-ascii?Q?XSYX/e8QMCocIL7oaej/QzY8TjystNzu7o1rW5RApzfhqHA7UE8FYWwIi2CX?=
 =?us-ascii?Q?eiJrFj3mpXG2XN4JhW+W+LYwD5/M3N8nTLzX91cclKdC7gMoixuLiMqiGCqc?=
 =?us-ascii?Q?zXCw5i45jImnSKWpzbRnubI4QSkEUYfInqaPaVANjp3157vH7APK6HA335Cw?=
 =?us-ascii?Q?yOSzYSl+JbHv1qfZgE6Zqxoc1jN9x6JTnRwsDJq2cpPupevk/Y8gYASw4u1r?=
 =?us-ascii?Q?RkqdmXnlt8tdQqsu3EpYjfzWmAVnzaXju2iCevfZZ+9ocZRW2mk2VqmJI12R?=
 =?us-ascii?Q?7A1o+MG2Pb4+m9dpkDNapV9C6g2uCfOFc58QWiBQiuVagQraKeLEUDBhtCaQ?=
 =?us-ascii?Q?cdkslZGiCSs3GpCiWrabLJ9Nq/3LyZa+7r5zJrBKYNT4CRXHc5bJ2Oy7jZVI?=
 =?us-ascii?Q?vNmZowMmPK95BW/wccKZhNYv+aom36xris1c25czVjRijArCfckc7Eb7WW2m?=
 =?us-ascii?Q?8r7Kg3Lt26LpBxXrKlmekD2D6axnEdobjGDCwtXTLmeudYeOfHsIfW+7LQ9V?=
 =?us-ascii?Q?K2uHioW/PgziRCcmcdSTtAFmZwOpxOK5fhwAygMSphV5xAcY/drh8RYVcIpe?=
 =?us-ascii?Q?cSsHwf8o1BB/sluMiAfThAp/zRRA7Tq3O0jrd33W9ksX7RFBPN3lrA8tTZta?=
 =?us-ascii?Q?YpX5xSFik/gdijlMjswuudr7QraAwPtYFwDg6aFpr8fbuSHIHYioG6J4DHL3?=
 =?us-ascii?Q?L5FG57sfef1on6FNVaezpvZrqt32Qc2mLYG8SyqYyaX7I1LKeEerVIGMbckh?=
 =?us-ascii?Q?qBbu5nb9zs0bFsA7Sxh7PT6+AbKC47zr3RTd0mqL1RMWUYax9XAAgl1U/YOf?=
 =?us-ascii?Q?yuCA8lvGjy6FEs10L0AIq+yaJjGKFDUeISKo/egYVGNhJfn0c4s01MkAVbUm?=
 =?us-ascii?Q?OJtGuE6RgUymocJvilVANc6UJMzKYDKXfXw26XURLyyDdpYIvJRuZJSgpmcT?=
 =?us-ascii?Q?BP3SG7hJZ5pY71osqczjZTW4Wt+Gcgjo5rmX+MiWPg/UWb4HwvrKe/0bJ7gy?=
 =?us-ascii?Q?iFFqg2o0Bz0Nm7qL2NNTbOhUt8ADA4bKjG9GFmB1Q7kfkjbI+SM8Hud2PiRW?=
 =?us-ascii?Q?83kpf0lS+SGEQbL5UdZ2V7GvkhwDhtQK7cbmWMMRzBnrGlMrHCSQsleK7wit?=
 =?us-ascii?Q?Bhkr/FpgC2uizphJRUHuwbqjeQFDbSO7waf67DWHiz7kLjlpuixt2KpY3Gpb?=
 =?us-ascii?Q?jTN/wkFDYoMpXuN22ac6lJX8DaXlzI+n5BEgDCqKvTkgOIh4jfBtvYxYpbUz?=
 =?us-ascii?Q?V1ZDlaiUQS8ScaqW5V/RLz6f5b3eFVOdThLBbuQb7XzcdYJcBI22G5RDdLZY?=
 =?us-ascii?Q?NI9bB6+ZB41lemVkX7wjoITGQ/LGFSfLaX6jy8m8bwX0enz/duEY7egwR6Ya?=
 =?us-ascii?Q?nCmnVA0TEwHZwiZTAqd3cVqOsptfHjTwUh2wdVlOpcSgC/mvAbvZevx7pTmy?=
 =?us-ascii?Q?JLjnSdsHUb0XbpHCV3vhsDCH5ZzJKakmykkZWeQkxi8bBB31FDjWd628v8Vy?=
 =?us-ascii?Q?Sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?1SMm6GAbaPCjU0aQGKIMTyqvcgqA0zfFvCPtyb2KVvsDQVbyCScfUfLhFquR?=
 =?us-ascii?Q?KTBErQc773GC8V65mKdjDah3zVKtSo+/x4F/KWq0uqudvrgqd+cjZd80BZVN?=
 =?us-ascii?Q?wr1nM0ISpu9hm7hJkIJNkC+lsqcTcLhHYWLsYIT2wBSZU5huw/U2gAIDV4Oj?=
 =?us-ascii?Q?k8u+MfUlPzUcOWUfEY88kKM+WLztut6KKERWeqh0oF3LvY8EQQytRu+GwX1n?=
 =?us-ascii?Q?/tpOW32JTCf2EFVqHGXwO0n8zBj8VM05nCBq4iAJ0cyG7qF6yghCMYo4xpUH?=
 =?us-ascii?Q?+nv0o/zUrVEII815UaTMgsgujpteqxDoia3w/nV3NCErWKrKyaZVQKZz9ErI?=
 =?us-ascii?Q?+Sg6YxMUAxKA2ui1L5lk/j4FwmWp0I6khjqAGSeuUe3cYvjGXiO9kpm3tmJh?=
 =?us-ascii?Q?vgJD+8+4HjHRqoj+OSnn24UB71I/VBvB7sHUEUzurv4lapgY2TFNE98cFoMi?=
 =?us-ascii?Q?VRnseZsF4vqeKOm6c4OLKx3Bqlp9tkPZCdzFyZ2TIzfqsF05bK3Utr4Ikps/?=
 =?us-ascii?Q?GogGrnL+2Z39C+IhwWvgi3AR3vcWmay6QQKydhp52O7YyCypQkx9hO5Bj2HG?=
 =?us-ascii?Q?XkFqrMoWPcvl2VdboKDAVy7ogGKwMBTqlIw/nPkikZE0qy2EbPFgiDx4Ujig?=
 =?us-ascii?Q?goH5tD/wlcDr4iHWdrOginNQv0HaDXlQKOfmI7SWBmaPHzhdGVKt8PHDxRAX?=
 =?us-ascii?Q?Puaptfa844a2Z6J2aZM+JVkgkYWTJt3ngIbD/La765MAdoFQMfK+Qz3JWedK?=
 =?us-ascii?Q?BDQ0m+3WaMoe26xA/fdEka1mXaqaeZYc1+z+1W9KOWYgb6J+UaDnLWbalZ6R?=
 =?us-ascii?Q?9AFBrKQH+VL/5kUNWKeZaidrBWM+O/BcmiPuZAcUcwftEzF3k8XVSGbCCwD1?=
 =?us-ascii?Q?zyN0xZOdnimj2K13WFPbimAruRrAfgCGNLOiuqAqfkmAuVhHojSUUHIzXaBC?=
 =?us-ascii?Q?0b7t+mhDgw6FKR0czUvoEwMmlcrfRzaYkcLECYt23MvvkvQC7kYyDJVy+OlM?=
 =?us-ascii?Q?zAfBGw8M0lOWPYMXJBWfetXRng=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6df65780-0a57-45fc-c425-08db63c2edbf
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 23:41:46.8006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYj7m8UUwMt9UIU7zyrp4uoqTgmueMcvjemgXdoObv4blrAL08Vk2HZK+ACY9wkokYzn0ive0OIDTcqCptwSeAE9wrBRDt44zmhdVkRo68k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8763
X-Proofpoint-ORIG-GUID: LXRadyIcEb0xV-d4heWE9l24ZsFLJNz7
X-Proofpoint-GUID: LXRadyIcEb0xV-d4heWE9l24ZsFLJNz7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_17,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 adultscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306020187
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The KSZ9477 PHY errata handling code has now been moved into the Micrel
PHY driver, so it is no longer needed inside the DSA switch driver.
Remove it.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/dsa/microchip/ksz9477.c    | 74 ++------------------------
 drivers/net/dsa/microchip/ksz_common.c |  4 --
 drivers/net/dsa/microchip/ksz_common.h |  1 -
 3 files changed, 4 insertions(+), 75 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 47b54ecf2c6f..7720d53dc7a9 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -889,62 +889,6 @@ static phy_interface_t ksz9477_get_interface(struct ksz_device *dev, int port)
 	return interface;
 }
 
-static void ksz9477_port_mmd_write(struct ksz_device *dev, int port,
-				   u8 dev_addr, u16 reg_addr, u16 val)
-{
-	ksz_pwrite16(dev, port, REG_PORT_PHY_MMD_SETUP,
-		     MMD_SETUP(PORT_MMD_OP_INDEX, dev_addr));
-	ksz_pwrite16(dev, port, REG_PORT_PHY_MMD_INDEX_DATA, reg_addr);
-	ksz_pwrite16(dev, port, REG_PORT_PHY_MMD_SETUP,
-		     MMD_SETUP(PORT_MMD_OP_DATA_NO_INCR, dev_addr));
-	ksz_pwrite16(dev, port, REG_PORT_PHY_MMD_INDEX_DATA, val);
-}
-
-static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
-{
-	/* Apply PHY settings to address errata listed in
-	 * KSZ9477, KSZ9897, KSZ9896, KSZ9567, KSZ8565
-	 * Silicon Errata and Data Sheet Clarification documents:
-	 *
-	 * Register settings are needed to improve PHY receive performance
-	 */
-	ksz9477_port_mmd_write(dev, port, 0x01, 0x6f, 0xdd0b);
-	ksz9477_port_mmd_write(dev, port, 0x01, 0x8f, 0x6032);
-	ksz9477_port_mmd_write(dev, port, 0x01, 0x9d, 0x248c);
-	ksz9477_port_mmd_write(dev, port, 0x01, 0x75, 0x0060);
-	ksz9477_port_mmd_write(dev, port, 0x01, 0xd3, 0x7777);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x06, 0x3008);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x08, 0x2001);
-
-	/* Transmit waveform amplitude can be improved
-	 * (1000BASE-T, 100BASE-TX, 10BASE-Te)
-	 */
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x04, 0x00d0);
-
-	/* Energy Efficient Ethernet (EEE) feature select must
-	 * be manually disabled (except on KSZ8565 which is 100Mbit)
-	 */
-	if (dev->info->gbit_capable[port])
-		ksz9477_port_mmd_write(dev, port, 0x07, 0x3c, 0x0000);
-
-	/* Register settings are required to meet data sheet
-	 * supply current specifications
-	 */
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x13, 0x6eff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x14, 0xe6ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x15, 0x6eff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x16, 0xe6ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x17, 0x00ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x18, 0x43ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x19, 0xc3ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1a, 0x6fff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1b, 0x07ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1c, 0x0fff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1d, 0xe7ff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1e, 0xefff);
-	ksz9477_port_mmd_write(dev, port, 0x1c, 0x20, 0xeeee);
-}
-
 void ksz9477_get_caps(struct ksz_device *dev, int port,
 		      struct phylink_config *config)
 {
@@ -1011,20 +955,10 @@ void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	/* enable 802.1p priority */
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_PRIO_ENABLE, true);
 
-	if (dev->info->internal_phy[port]) {
-		/* do not force flow control */
-		ksz_port_cfg(dev, port, REG_PORT_CTRL_0,
-			     PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
-			     false);
-
-		if (dev->info->phy_errata_9477)
-			ksz9477_phy_errata_setup(dev, port);
-	} else {
-		/* force flow control */
-		ksz_port_cfg(dev, port, REG_PORT_CTRL_0,
-			     PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
-			     true);
-	}
+	/* force flow control for non-PHY ports only */
+	ksz_port_cfg(dev, port, REG_PORT_CTRL_0,
+		     PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
+		     !dev->info->internal_phy[port]);
 
 	if (cpu_port)
 		member = dsa_user_ports(ds);
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 423f944cc34c..42cb5742f552 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1212,7 +1212,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_cnt = 7,		/* total physical port count */
 		.port_nirqs = 4,
 		.ops = &ksz9477_dev_ops,
-		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -1244,7 +1243,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_cnt = 6,		/* total physical port count */
 		.port_nirqs = 2,
 		.ops = &ksz9477_dev_ops,
-		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -1276,7 +1274,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_cnt = 7,		/* total physical port count */
 		.port_nirqs = 2,
 		.ops = &ksz9477_dev_ops,
-		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
@@ -1356,7 +1353,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.port_cnt = 7,		/* total physical port count */
 		.port_nirqs = 3,
 		.ops = &ksz9477_dev_ops,
-		.phy_errata_9477 = true,
 		.mib_names = ksz9477_mib_names,
 		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
 		.reg_mib_cnt = MIB_COUNTER_NUM,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 055d61ff3fb8..9c5e8ea229fa 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -47,7 +47,6 @@ struct ksz_chip_data {
 	int port_cnt;
 	u8 port_nirqs;
 	const struct ksz_dev_ops *ops;
-	bool phy_errata_9477;
 	bool ksz87xx_eee_link_erratum;
 	const struct ksz_mib_names *mib_names;
 	int mib_cnt;
-- 
2.40.1


