Return-Path: <netdev+bounces-10860-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D0DE73094C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE6E91C20DB9
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A54206110;
	Wed, 14 Jun 2023 20:40:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CC311C86
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:40:40 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2065.outbound.protection.outlook.com [40.107.6.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B41526A1;
	Wed, 14 Jun 2023 13:40:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4wCMXDNzySqCpXeoCJJT4eMLYOsCJK3sTEpH9frvU75BHNkbRqML23MGfaKoSvPpNWjzyNnx/p+XrN+b1DIz4OLHv7cBYIGYxXzyp08+os4IFlSGkKt+N3d7F8aimWuAExcjFsODoEewHLjkspv2XPNioE1cqSwT1JM59fXps+JLWj7ulbdinY6lHaFtCrilunGjrEZb01+/OKvf9frElkw0hbDpjvGUyyoK+g48KpgtAgKU09Jrkbd+D/c0WK2tztsdJflcysUsbLdWxJJZ7bPCh92kiZhrJqij15Y3NHRLIbAJHaRP6kPsMW3yoaEg4fMqADpxfnrEoljbGkQgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1fdZXd27DmTfmHg9STrcI+H4kCAA4nzhDZFOdxb9WQ=;
 b=fnCa+C2BPOGG5d9QfMMG9/Z0nM6R3gQ6qyPkST2eUQN/hkWtw8zJvU8InU5nRxopq+EgA15EruP7LYK4Cd0xD4BkEDH8YhHZSOgyLA9szec6rBcNufWkivX/a20r+hM+fz2br9fEAXyFvsyldeIcdz+gEUgY6gjvtn8V/5OEeZ0CkNyAkF5vG8jv/RMa0AKUKcgFqe42lMa7rSfwdWEU5Q6w1uhM3zHzjidlljc6ew4JjoUwEF5Xp0zXeSYozUVo28yiYoo/Bfw5ISmFaXBXimaRfwbFE3hu+K7W29e4uqqScb2AwcQqqyQB5phySCursVw2X/q76JJ8bpBpNEqYFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hms.se; dmarc=pass action=none header.from=hms.se; dkim=pass
 header.d=hms.se; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hms.se; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1fdZXd27DmTfmHg9STrcI+H4kCAA4nzhDZFOdxb9WQ=;
 b=eTGzS23dxPdsp7cSYZTR9EfxARRd4+xcbLoQrmaUCZLTmJ2n2CQCxZn06YtihU88yG6+F2CWGBqqJ1gBz87LCIsQjA0f1VrXbApLMCfvBib2Nlw65Q+0qTNlYl0D2Gcn+Q0bKipQ2YfNie3By/EoHzV8G147qbgIVc9vzBYPGCY=
Received: from PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:311::14)
 by AS2PR10MB7226.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:60a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 20:40:36 +0000
Received: from PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7fb8:41fa:a2ba:6b25]) by PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7fb8:41fa:a2ba:6b25%4]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 20:40:36 +0000
From: HMS Incident Management <Incidentmanagement@hms.se>
To: "mkl@pengutronix.de" <mkl@pengutronix.de>, "linux-can@vger.kernel.org"
	<linux-can@vger.kernel.org>, "Thomas.Kopp@microchip.com"
	<Thomas.Kopp@microchip.com>
CC: "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "marex@denx.de"
	<marex@denx.de>, "simon.horman@corigine.com" <simon.horman@corigine.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 2/3] can: length: fix description of the RRS field
Thread-Topic: [PATCH v5 2/3] can: length: fix description of the RRS field
Thread-Index: AQHZnwB4UV8wLasOFEWs7GpEoVhhWw==
Date: Wed, 14 Jun 2023 20:40:36 +0000
Message-ID:
 <PAVPR10MB7209B55BA47D42F2610851BEB15AA@PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hms.se;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAVPR10MB7209:EE_|AS2PR10MB7226:EE_
x-ms-office365-filtering-correlation-id: 2b9673cf-56ae-4c94-5c98-08db6d179b5f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Jku7fS7hNFlvQqfp61BbccrfZ+scGf6EYI+bDs4InekLd97uUlrgyKriAt8E0cKft/kq8JUFPcI0U+WdbZ1FeXq7Wagl73AtcEjpkmiXa4YuS6gln5S259Crh8ZLUuNiJoJmhMoPXyWiPskKOCzHfb4Wp3DIxjk/LCwzrRHWOVLKma/R/a+gAoCKOdwqLQA+dAL9FjY1wZscTTFjSgLTAQJUMFtF3RnKEAZBgTD6N2+q8DIMDhGCchWWZNDsjOZ20xJUhamOtziUbleXB9t8q7WcDe6vU5OptL9yrx/MGf8OfxbSrZEaMxdGSMWQD/rPpSWMHDzL9Vl8sb0yyQZERK8rDGcezVSRdHInBT8+NnL1klujXoMN9o5tTArxMpYLDtmvfUZdYnerMENocXDNKEkpsTQlyaiRzltnYScdZx+c+de1WYIEm6eNW+nzRjqUwZD+jP80XPFEfqLAOJRYN65CzuuuLxWV/RQkKUauZE7koVPYkAQMeqkuTWAvPP/BbNBWJp6dqjFJFmNUXJKMEBZ21Zdkv1PkfqZRfTiTuSS5xEECdc0qNrN+ia40oiMXTDI/54k+x3ukBGs9HdLFcnws4hXUlSEwkrLo+coKVwXCTAJfYJu58jkZI2mLOMMz
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(376002)(396003)(366004)(346002)(136003)(451199021)(7696005)(71200400001)(55016003)(186003)(6506007)(26005)(9686003)(66946007)(66556008)(4326008)(64756008)(66476007)(66446008)(41300700001)(8676002)(8936002)(122000001)(38070700005)(2906002)(38100700002)(316002)(5660300002)(52536014)(76116006)(83380400001)(54906003)(86362001)(110136005)(33656002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?hNNuont6JeWuopr2WFUQ7unxbeGlSLp3BQgJYqBbL6HT8XVPaTxtgfkmd4R2?=
 =?us-ascii?Q?fWleaP9GrL07gBvwhMRnf+PSd0w7q6WoD1rECTNGqW2mwwtF+Xm1uiwv5kP9?=
 =?us-ascii?Q?Rj8DtnBlSqdj1IA4kz6cj+mpG/tvLIdJUqs4IQJbaIDAqk2AgfME6kb3oIap?=
 =?us-ascii?Q?HEHqtr2l1IAwPkOgF7oNKnZEwI4JZjQemI8Erv7nVZUZJ11gBxJ9KfPuUs3q?=
 =?us-ascii?Q?TbIjgS2l7IvaYru2uvDks3MVPZK1zgkJeGr7wZ1bwwmwQ//28+0DRz4P1ef7?=
 =?us-ascii?Q?MVJi2n6I2G4E+IiMj34/zXiOoQQTC1Dm2ngyTqGjVsxUDARYtP4n3oOnnZ5T?=
 =?us-ascii?Q?N9qEuP6YUK+Eu+2rnNPDy7QcuSYRfiKdiHUlTwFwJyF+QkAout3tomdovYuW?=
 =?us-ascii?Q?ygFXBF6newrYsjyJSZQVH0T7xGU3vF8+KLZh03PqT6im+axMc/6niUPNUkXH?=
 =?us-ascii?Q?DkE+kyGFPkDkQgae84JE+0E7htaUGyNva/7lG2iOIvJUbNjIR2jl+7gUxdV6?=
 =?us-ascii?Q?Wzt4ppu36tAl+u1Oqze1ykh3lUuqP+LL+Wk1hl4yb1u6qJ9gii2Fvi6VBSEg?=
 =?us-ascii?Q?hC/8BDaZvl4+PM3wM0oPiwXQQmu6nRmQ8LRVbXGel1DrGf06ngoo8vqtm6fG?=
 =?us-ascii?Q?E8jyd25Zla2g6oD/L+9QZyIYgGRt1NrXSCUiFSGDrk2cs4qtgNXeo9fnrfIm?=
 =?us-ascii?Q?TeXPWJQemSZQ4VLWH1t4XyLgPDtiVn0mvkPXpstQOHyrYgbW4A/WYyak0wQ7?=
 =?us-ascii?Q?iyuipjykGOFeM/hsv1Waj314EVS1npG7tRWFsJWnGc4LyKjAplvQfCAbCztC?=
 =?us-ascii?Q?oAEWk5bww6ebD0a+6NONpVpIHsXtGt8ibKzAfE09ME2qwYOUO7a1vY53nVKP?=
 =?us-ascii?Q?2sBjgYy/IkSyJdvRUhEF6PpAXb+nC7JbcNSjGZ8zVbcDrfYxmxoF0A9u+tKb?=
 =?us-ascii?Q?XMW0ohub15j+ItXivjypqwiU/hbkreS+wVeB9YkZxklHehnj/7mWhRU76Bg1?=
 =?us-ascii?Q?SEu5Qm7h/cpPYCzhyTOJdX72ZnzC4FzITGY1+0eDneQ12MAap9qN1okeQZSD?=
 =?us-ascii?Q?h/4YDhL8+ZKhNMk6L3tyOEsG0T6DNasrS9rX5FDOWfksyf3ceJShpPciu851?=
 =?us-ascii?Q?PmnbNKBXqJTQd6ffLPJlN/f5WWOXrJIVT8Djhr7JVsyYQkxEUfx/AaPXoFFN?=
 =?us-ascii?Q?Ow0H/Ie0uRNlDwCBf2WmPgP5/t3WxsC/gyQvPkqzzzJGASP233uPOwWIhWJz?=
 =?us-ascii?Q?Y2B2c78fF8B4IAUMmJJodCAZy0yaKn/mC50TRtYtVzewILvMMi6qH2P2h9kh?=
 =?us-ascii?Q?tU3BGfrP4HjbDGNByPQisRP64fWZLHLz86INZS50TYJkJKD32tE0cbU4syYt?=
 =?us-ascii?Q?T3uKGuawC0/qOeQrzNYarSDas93e9RED/7Wz+P8uCTWKaQnqhx729MbXDSOg?=
 =?us-ascii?Q?Vz9zFPjYcIJ19NcTdynxzlklIR+SRqlFW5ereKqheZ5x02H/ohlqsobUHpO3?=
 =?us-ascii?Q?Illb8ATQjkRV9OSCnmIivPRc9ve7c1vPjXljrcpfOTR8vkL7wEBeEazkEKj+?=
 =?us-ascii?Q?HmpqQXI0/Zih+FuHFaRdcgzIlF5wZ+hoHLGK+HpbYwNhpoFDEScjHLrdRVGs?=
 =?us-ascii?Q?W01TZVa+faxIw98OR0qG4Hu+1flB9XYhm67hAtmSQYje?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: hms.se
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b9673cf-56ae-4c94-5c98-08db6d179b5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 20:40:36.1046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5c7c1590-4488-4e42-bc9c-15218f8ac994
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P782T4SGBWBdEPb/5llLxWMaPQ0YFT4cQb+FQ8G/DtXZaGC+A5ouVL4uwY3sYA+mdH1oPiZ+3e+MjhHla3Tn4T9hcPXRvuE8AZkeRiHGf7voGWtts80bO+qm54GXAtfNBBxV6Gs64SRYklFLAzxIxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR10MB7226
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

**We apologize for the delay in delivering this email, which was caused by =
a mail incident that occurred over the weekend on June 10th. This email was=
 originally sent from vincent.mailhol@gmail.com on 06/11/2023 02:58:14=20

The CAN-FD frames only have one reserved bit. The bit corresponding to
Classical CAN frame's RTR bit is called the "Remote Request
Substitution (RRS)" [1].

N.B. The RRS is not to be confused with the Substitute Remote Request
(SRR).

Fix the description in the CANFD_FRAME_OVERHEAD_SFF/EFF macros.

The total remains unchanged, so this is just a documentation fix.

In addition to the above add myself as copyright owner for 2020 (as
coauthor of the initial version, c.f. Fixes tag).

[1] ISO 11898-1:2015 paragraph 10.4.2.3 "Arbitration field":

  RSS bit [only in FD Frames]

    The RRS bit shall be transmitted in FD Frames at the position of
    the RTR bit in Classical Frames. The RRS bit shall be transmitted
    dominant, but receivers shall accept recessive and dominant RRS
    bits.

Fixes: 85d99c3e2a13 ("can: length: can_skb_get_frame_len(): introduce funct=
ion to get data length of frame in data link layer")
Signed-off-by: Vincent Mailhol=20
Reviewed-by: Thomas Kopp=20
---
 include/linux/can/length.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/can/length.h b/include/linux/can/length.h
index b8c12c83bc51..521fdbce2d69 100644
--- a/include/linux/can/length.h
+++ b/include/linux/can/length.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2020 Oliver Hartkopp=20
  * Copyright (C) 2020 Marc Kleine-Budde=20
+ * Copyright (C) 2020 Vincent Mailhol=20
  */
=20
 #ifndef _CAN_LENGTH_H
@@ -64,7 +65,7 @@
  * ---------------------------------------------------------
  * Start-of-frame			1
  * Identifier				11
- * Reserved bit (r1)			1
+ * Remote Request Substitution (RRS)	1
  * Identifier extension bit (IDE)	1
  * Flexible data rate format (FDF)	1
  * Reserved bit (r0)			1
@@ -95,7 +96,7 @@
  * Substitute remote request (SRR)	1
  * Identifier extension bit (IDE)	1
  * Identifier B				18
- * Reserved bit (r1)			1
+ * Remote Request Substitution (RRS)	1
  * Flexible data rate format (FDF)	1
  * Reserved bit (r0)			1
  * Bit Rate Switch (BRS)		1
--=20
2.39.3=

