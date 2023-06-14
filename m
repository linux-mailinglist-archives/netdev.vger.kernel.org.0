Return-Path: <netdev+bounces-10859-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A3BB730948
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:40:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CACE281574
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:40:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869986110;
	Wed, 14 Jun 2023 20:40:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC1629A1
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:40:34 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2041.outbound.protection.outlook.com [40.107.8.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF77268E;
	Wed, 14 Jun 2023 13:40:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lc2nv0dVHqrPJeMHPOkAIifonJZrLB/GvYTDrT+UShMIbkVKjOp9/4lNy1DbW1kDHLwAoJy0vxdOj5ioqt4/vlmqXQNQcEwR5RR284TuB0I42c4CYzfXFg9paOxTNzkIuATYwzai+ziBbSo4RmByWxVOgwOyF2ur1taUaEunXPHFHjOPcPHtiyXcD326gvsGPzrZdXkzDJVDt2njwWt+UvQEMHUIQQSRQUor7HqXOdwvavihc3bzuOnkQCC5FT1FCfykcas+9rkdlup9N735P9hYNDTsm2JP3ZrGSZYwOAYqnqQOSjW4yWGrsMu/yKCZsvHpqRF0PaoikErZdQu/+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NxFAuTQI96ktjPvSl0YpBLLA1BR4br9/RdPNk1sn9eI=;
 b=ggmlkKxBYoj7tPTibKtFuwsu6JkilN4g7zklL7hs+JDfCEKlP6rFt+eaiIYEZldKI5qcX48xcB+OiHSN9lRmnMC3neB1u3sVpOrXCZ3WSORMIvw1YVPrZPam3IkGpbVp0XobG9eJWFSw+yu0+oCJ9pszpetvqtD5VKKy3G9noj8yujd/IfpX+jRi8p1n2HKbHfln0jPdxK+H8qY1/NgvECaXEqIgyk/9VZ+mQ+BpnLyRnnWPkDZn8bTsTaTCGcd4QMDqjZHPDKsHKVdBjFedZOZuoOtoUeUQHYu0bwlJgWkdvPYDUjjpDe55jU/dCUZhb2jrNJ6pdtbMnBfuWS+WPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hms.se; dmarc=pass action=none header.from=hms.se; dkim=pass
 header.d=hms.se; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hms.se; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxFAuTQI96ktjPvSl0YpBLLA1BR4br9/RdPNk1sn9eI=;
 b=dehq4AN6qgJ9EZPjSK8387pKvSE+rzQjzLsRAlLoBBKAGHn+bJf+BgK5e6R9ofFZl3JJiGr2Yle1aWZZKDY3fDTwoiZ3DW121J48od1auMv/dSm/GegTH20vBFvZBmWimpMQocc3+9ro+ni8qDNGTdt28ubhd8QIAqqFQhnvJ48=
Received: from PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:311::14)
 by AS2PR10MB7226.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:60a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 20:40:29 +0000
Received: from PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7fb8:41fa:a2ba:6b25]) by PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7fb8:41fa:a2ba:6b25%4]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 20:40:29 +0000
From: HMS Incident Management <Incidentmanagement@hms.se>
To: "mkl@pengutronix.de" <mkl@pengutronix.de>, "linux-can@vger.kernel.org"
	<linux-can@vger.kernel.org>, "Thomas.Kopp@microchip.com"
	<Thomas.Kopp@microchip.com>
CC: "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "marex@denx.de"
	<marex@denx.de>, "simon.horman@corigine.com" <simon.horman@corigine.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 3/3] can: length: refactor frame lengths definition to add
 size in bits
Thread-Topic: [PATCH v5 3/3] can: length: refactor frame lengths definition to
 add size in bits
Thread-Index: AQHZnwB0tJzSdRUtgES6oX/99kpc1A==
Date: Wed, 14 Jun 2023 20:40:29 +0000
Message-ID:
 <PAVPR10MB720989527F83A44B6CEEE294B15AA@PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hms.se;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAVPR10MB7209:EE_|AS2PR10MB7226:EE_
x-ms-office365-filtering-correlation-id: 3f384a5f-5b14-4534-5b81-08db6d17974d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 W7bufFP5o76NZhvyne4wdvCEOQkDylUiwgvQe5WMuqDFWjaf7h4pA7Iid5slo6oh07SOtHKJ2wrodGSZNNjNltLc3eZ2U1rZCVaW8PCHJcRxbk4miio5NXEXI4CAiVcgjdm4O9lSULd6p89aIaeA4YrKrLHrbG6ZKeN93Wv1xs99LY5ZxrClbXOb9GyY6cHSQlHN3/hpWGTzlRBU7W/MCN5+Vl07t7t5Z4wcVJ2hW1hPB2qMGAUzGSJIxrAyI387KjlEYgzAmxbWGNbzL7vgwenQEQNDz/egP54oDOVZTFfxpzh72NjM7CAd7Rers3W9SPHFhnoFzkD2HvkJC4IQPVBg/JZk3rPYh+Tbc0Jsmh5lCLCeF99zgE7racqvv3j/d39UN4kzmuZYaVyqDW33Y5qDb8dWvmezi74pVm72ddXumg9LBPcX/zPfJezBOiuYM1VRkGL96EIWOTOH076XTrhnrYrMQ6PWIQO0bqcWCpLRfKwsMttyjcqnURbqPJERc5csa3pt0q++x62zJpg3JEF4YzDvlQ1P6KUvsi7N0qyUecncwDuSZYYGIeNHfpGFpP2vBEGf1aSTMzDeCJ16s9oP3iyoTFZmJMp5f6d7aeIeh6Af1IY2iqDFhZlx7V4L
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(376002)(396003)(366004)(346002)(136003)(451199021)(7696005)(71200400001)(55016003)(186003)(6506007)(26005)(9686003)(66946007)(66556008)(4326008)(64756008)(66476007)(66446008)(41300700001)(8676002)(8936002)(122000001)(38070700005)(2906002)(38100700002)(316002)(5660300002)(52536014)(30864003)(76116006)(83380400001)(54906003)(86362001)(110136005)(33656002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?RsK/gKFxrP9fW4Mx55KyMcTvxXmGaT+ApBBj1Hk2ckxSPSFB2ERsR13XI1pR?=
 =?us-ascii?Q?WjDVNt29m2CPFdtV0juV5gZ7IgHJMyN3iUocnmAgNRAI7pjLJb30QABl5LdQ?=
 =?us-ascii?Q?U50nDTpaQ6rmqsYLzgz7tmnj1aMxUt4CRPqHVEcgNioV0m6ddFAPR/khAjKZ?=
 =?us-ascii?Q?ElN4PvNN4eHwrP7AhBzLfNl9qobvoUVhP7su6AhWmtyOKcoBdsDU49b4wJAU?=
 =?us-ascii?Q?nzxehOxyy69cULeOO3ypX/JlA0yIKR3vWDvyQNYKeDCI/Y0t0OVN7oWwvYOw?=
 =?us-ascii?Q?R0r/TFd4DNvqlEnU2cQ8Bfd+3Vgdw+gT8jKSlnHXgxw6i/KftV2m8BQdlAIN?=
 =?us-ascii?Q?oMqQtonPTXhOQAPwuiHRfugsDQg+mW+sUMlZhpVN57KsoYD6GfZxTjJONFJO?=
 =?us-ascii?Q?oAOqAm/reK6F3yxMDDhXQ+P5Gf8bmwTigmcdoNWTslE7Ccb/13Zkn/Q8bP2B?=
 =?us-ascii?Q?nX0/2IdUSZF8unOXdeLIZ7GWDZ8yxv8wz+AargL7EGRPJr6zE9MVJ9+RBUX/?=
 =?us-ascii?Q?A46rbrrJnTZwjUz0Rweji76HfXVdreIItB5Ag3aE3SvPJeyjDeT5k/AwdOW3?=
 =?us-ascii?Q?AIo3ScxKZf+exRgRRx8yZvGJ4eR/rABt3Fww+/FvqVIwzCaxtEwKt5SFAJgC?=
 =?us-ascii?Q?velT2HYdIauD9ruriJfuEL2KeCpNL5b4ys3DQF9i22/pFogB9jNGESUuNqfj?=
 =?us-ascii?Q?DLFoDBY8zJ2l9jWEK9WD8o9qrHkJK81EbXoeOMPoK9W8c1o8ZqrHEUfxFe2C?=
 =?us-ascii?Q?p+hAZ0SVgVoU9gAa28/K/LO16f6aPrB5otQLCXeJUcKSWcMj4pEV8UitQQYj?=
 =?us-ascii?Q?90vm3BTmlS4X8vmcEmCx/Mf3lN2pM3BQFJ9TZ5Ngh5KI0OSExl4PDbc+U4lC?=
 =?us-ascii?Q?zDJLycKyBtJZV3mbLFwgeHGeYwKVHV4KVhD0wjbkblFat8YqZobZXv7WN87X?=
 =?us-ascii?Q?ocMQzViJxzM61l3CHvcFFzqDjnatKVb6BuLWUrWWNND1NnYNnQ7Vjz6iLCuO?=
 =?us-ascii?Q?7+qRBuc2mWjMi+xFOgpR2Ul+x+9XdSKlCDowJN0c1MjZGZ9liaVxAGmQh/X8?=
 =?us-ascii?Q?50qOQTGPYVqvxzNjc72zcJeh0iPbrMS9kmb9CPOI0AFRndq10+uX7DOByJgD?=
 =?us-ascii?Q?8voP9e30oqkdlPYRsxrVzFge5wR3AYHaUwN/NEcgeSjMHowr/ZDM99h/aWDx?=
 =?us-ascii?Q?ogWLjCufZ706uivwf0kkfH9nBN00dvBBH9ypNnA/8A+Inv6XNMolusmSK984?=
 =?us-ascii?Q?fDk1LRHNLsfsdNz8cdEwwAaTWdoO98g44qbqRAtK8NNVlCDmaKRaTOUd1isa?=
 =?us-ascii?Q?IF6tKETb5bYfjsFaF4bSG1YPEXnEvpkAAlD8SeoLoKOfnM3rA+QsWxPA37Xa?=
 =?us-ascii?Q?jdp1I3aug+em3D7EfQjV2NQ0rTmcNQMnG09EbKOydsXElC7c51CXitrKIS+r?=
 =?us-ascii?Q?0xE25J0l8FHUqtdyL6TU846ZptBjxxrRjCRNS7c9/zWN8GqjvZxVQsdTcZrh?=
 =?us-ascii?Q?S3NgKxU2Xpw/P9p+LA38PiPUFXIL5W5kYzIrTB8lcMJrvTiPG9q9E58dqdVi?=
 =?us-ascii?Q?0TkjeSv49c8m3gvlCl0MQTXFN/TFZj/N0r7hjkWr8ZxMPl15u8E04P/AiMWu?=
 =?us-ascii?Q?0IqMMtzbL/jtigdjqo1zrSIPXF5BUUpQJwUjIhTTcL32?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f384a5f-5b14-4534-5b81-08db6d17974d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 20:40:29.2574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5c7c1590-4488-4e42-bc9c-15218f8ac994
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MUEzWYC/aucXVv1JwtQmCEsALgch0IdxbMAYGPvtX5J2IDXbbsnYAjXAmu2er71N5hThAYRUPc+PnevETIU5TpHaJ9JYivwCRaC6uVbQvS4wtgjrjFpxA5hLBwcVSV4bU64DOY8R6XZuaCFoL7z3YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR10MB7226
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

**We apologize for the delay in delivering this email, which was caused by =
a mail incident that occurred over the weekend on June 10th. This email was=
 originally sent from vincent.mailhol@gmail.com on 06/11/2023 02:58:17=20

Introduce a method to calculate the exact size in bits of a CAN(-FD)
frame with or without dynamic bitstuffing.

These are all the possible combinations taken into account:

  - Classical CAN or CAN-FD
  - Standard or Extended frame format
  - CAN-FD CRC17 or CRC21
  - Include or not intermission

Instead of doing several individual macro definitions, declare the
can_frame_bits() function-like macro. To this extent, do a full
refactoring of the length definitions.

In addition add the can_frame_bytes(). This function-like macro
replaces the existing macro:

  - CAN_FRAME_OVERHEAD_SFF: can_frame_bytes(false, false, 0)
  - CAN_FRAME_OVERHEAD_EFF: can_frame_bytes(false, true, 0)
  - CANFD_FRAME_OVERHEAD_SFF: can_frame_bytes(true, false, 0)
  - CANFD_FRAME_OVERHEAD_EFF: can_frame_bytes(true, true, 0)

Function-like macros were chosen over inline functions because they
can be used to initialize const struct fields.

The different maximum frame lengths (maximum data length, including
intermission) are as follow:

   Frame type				bits	bytes
  -------------------------------------------------------
   Classic CAN SFF no bitstuffing	111	14
   Classic CAN EFF no bitstuffing	131	17
   Classic CAN SFF bitstuffing		135	17
   Classic CAN EFF bitstuffing		160	20
   CAN-FD SFF no bitstuffing		579	73
   CAN-FD EFF no bitstuffing		598	75
   CAN-FD SFF bitstuffing		712	89
   CAN-FD EFF bitstuffing		736	92

The macro CAN_FRAME_LEN_MAX and CANFD_FRAME_LEN_MAX are kept as an
alias to, respectively, can_frame_bytes(false, true, CAN_MAX_DLEN) and
can_frame_bytes(true, true, CANFD_MAX_DLEN).

In addition to the above:

 - Use ISO 11898-1:2015 definitions for the names of the CAN frame
   fields.
 - Include linux/bits.h for use of BITS_PER_BYTE.
 - Include linux/math.h for use of mult_frac() and
   DIV_ROUND_UP(). N.B: the use of DIV_ROUND_UP() is not new to this
   patch, but the include was previously omitted.
 - Add copyright 2023 for myself.

Suggested-by: Thomas Kopp=20
Signed-off-by: Vincent Mailhol=20
Reviewed-by: Thomas Kopp=20
---
 drivers/net/can/dev/length.c |  15 +-
 include/linux/can/length.h   | 302 +++++++++++++++++++++++++----------
 2 files changed, 216 insertions(+), 101 deletions(-)

diff --git a/drivers/net/can/dev/length.c b/drivers/net/can/dev/length.c
index b48140b1102e..b7f4d76dd444 100644
--- a/drivers/net/can/dev/length.c
+++ b/drivers/net/can/dev/length.c
@@ -78,18 +78,7 @@ unsigned int can_skb_get_frame_len(const struct sk_buff =
*skb)
 	else
 		len =3D cf->len;
=20
-	if (can_is_canfd_skb(skb)) {
-		if (cf->can_id & CAN_EFF_FLAG)
-			len +=3D CANFD_FRAME_OVERHEAD_EFF;
-		else
-			len +=3D CANFD_FRAME_OVERHEAD_SFF;
-	} else {
-		if (cf->can_id & CAN_EFF_FLAG)
-			len +=3D CAN_FRAME_OVERHEAD_EFF;
-		else
-			len +=3D CAN_FRAME_OVERHEAD_SFF;
-	}
-
-	return len;
+	return can_frame_bytes(can_is_canfd_skb(skb), cf->can_id & CAN_EFF_FLAG,
+			       false, len);
 }
 EXPORT_SYMBOL_GPL(can_skb_get_frame_len);
diff --git a/include/linux/can/length.h b/include/linux/can/length.h
index 521fdbce2d69..abc978b38f79 100644
--- a/include/linux/can/length.h
+++ b/include/linux/can/length.h
@@ -1,132 +1,258 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2020 Oliver Hartkopp=20
  * Copyright (C) 2020 Marc Kleine-Budde=20
- * Copyright (C) 2020 Vincent Mailhol=20
+ * Copyright (C) 2020, 2023 Vincent Mailhol=20
  */
=20
 #ifndef _CAN_LENGTH_H
 #define _CAN_LENGTH_H
=20
+#include=20
 #include=20
 #include=20
+#include=20
=20
 /*
- * Size of a Classical CAN Standard Frame
+ * Size of a Classical CAN Standard Frame header in bits
  *
- * Name of Field			Bits
+ * Name of Field				Bits
  * ---------------------------------------------------------
- * Start-of-frame			1
- * Identifier				11
- * Remote transmission request (RTR)	1
- * Identifier extension bit (IDE)	1
- * Reserved bit (r0)			1
- * Data length code (DLC)		4
- * Data field				0...64
- * CRC					15
- * CRC delimiter			1
- * ACK slot				1
- * ACK delimiter			1
- * End-of-frame (EOF)			7
- * Inter frame spacing			3
+ * Start Of Frame (SOF)				1
+ * Arbitration field:
+ *	base ID					11
+ *	Remote Transmission Request (RTR)	1
+ * Control field:
+ *	IDentifier Extension bit (IDE)		1
+ *	FD Format indicator (FDF)		1
+ *	Data Length Code (DLC)			4
+ *
+ * including all fields preceding the data field, ignoring bitstuffing
+ */
+#define CAN_FRAME_HEADER_SFF_BITS 19
+
+/*
+ * Size of a Classical CAN Extended Frame header in bits
  *
- * rounded up and ignoring bitstuffing
+ * Name of Field				Bits
+ * ---------------------------------------------------------
+ * Start Of Frame (SOF)				1
+ * Arbitration field:
+ *	base ID					11
+ *	Substitute Remote Request (SRR)		1
+ *	IDentifier Extension bit (IDE)		1
+ *	ID extension				18
+ *	Remote Transmission Request (RTR)	1
+ * Control field:
+ *	FD Format indicator (FDF)		1
+ *	Reserved bit (r0)			1
+ *	Data length code (DLC)			4
+ *
+ * including all fields preceding the data field, ignoring bitstuffing
  */
-#define CAN_FRAME_OVERHEAD_SFF DIV_ROUND_UP(47, 8)
+#define CAN_FRAME_HEADER_EFF_BITS 39
=20
 /*
- * Size of a Classical CAN Extended Frame
+ * Size of a CAN-FD Standard Frame in bits
+ *
+ * Name of Field				Bits
+ * ---------------------------------------------------------
+ * Start Of Frame (SOF)				1
+ * Arbitration field:
+ *	base ID					11
+ *	Remote Request Substitution (RRS)	1
+ * Control field:
+ *	IDentifier Extension bit (IDE)		1
+ *	FD Format indicator (FDF)		1
+ *	Reserved bit (res)			1
+ *	Bit Rate Switch (BRS)			1
+ *	Error Status Indicator (ESI)		1
+ *	Data length code (DLC)			4
+ *
+ * including all fields preceding the data field, ignoring bitstuffing
+ */
+#define CANFD_FRAME_HEADER_SFF_BITS 22
+
+/*
+ * Size of a CAN-FD Extended Frame in bits
+ *
+ * Name of Field				Bits
+ * ---------------------------------------------------------
+ * Start Of Frame (SOF)				1
+ * Arbitration field:
+ *	base ID					11
+ *	Substitute Remote Request (SRR)		1
+ *	IDentifier Extension bit (IDE)		1
+ *	ID extension				18
+ *	Remote Request Substitution (RRS)	1
+ * Control field:
+ *	FD Format indicator (FDF)		1
+ *	Reserved bit (res)			1
+ *	Bit Rate Switch (BRS)			1
+ *	Error Status Indicator (ESI)		1
+ *	Data length code (DLC)			4
+ *
+ * including all fields preceding the data field, ignoring bitstuffing
+ */
+#define CANFD_FRAME_HEADER_EFF_BITS 41
+
+/*
+ * Size of a CAN CRC Field in bits
  *
  * Name of Field			Bits
  * ---------------------------------------------------------
- * Start-of-frame			1
- * Identifier A				11
- * Substitute remote request (SRR)	1
- * Identifier extension bit (IDE)	1
- * Identifier B				18
- * Remote transmission request (RTR)	1
- * Reserved bits (r1, r0)		2
- * Data length code (DLC)		4
- * Data field				0...64
- * CRC					15
- * CRC delimiter			1
- * ACK slot				1
- * ACK delimiter			1
- * End-of-frame (EOF)			7
- * Inter frame spacing			3
+ * CRC sequence (CRC15)			15
+ * CRC Delimiter			1
+ *
+ * ignoring bitstuffing
+ */
+#define CAN_FRAME_CRC_FIELD_BITS 16
+
+/*
+ * Size of a CAN-FD CRC17 Field in bits (length: 0..16)
  *
- * rounded up and ignoring bitstuffing
+ * Name of Field			Bits
+ * ---------------------------------------------------------
+ * Stuff Count				4
+ * CRC Sequence (CRC17)			17
+ * CRC Delimiter			1
+ * Fixed stuff bits			6
  */
-#define CAN_FRAME_OVERHEAD_EFF DIV_ROUND_UP(67, 8)
+#define CANFD_FRAME_CRC17_FIELD_BITS 28
=20
 /*
- * Size of a CAN-FD Standard Frame
+ * Size of a CAN-FD CRC21 Field in bits (length: 20..64)
  *
  * Name of Field			Bits
  * ---------------------------------------------------------
- * Start-of-frame			1
- * Identifier				11
- * Remote Request Substitution (RRS)	1
- * Identifier extension bit (IDE)	1
- * Flexible data rate format (FDF)	1
- * Reserved bit (r0)			1
- * Bit Rate Switch (BRS)		1
- * Error Status Indicator (ESI)		1
- * Data length code (DLC)		4
- * Data field				0...512
- * Stuff Bit Count (SBC)		4
- * CRC					0...16: 17 20...64:21
- * CRC delimiter (CD)			1
- * Fixed Stuff bits (FSB)		0...16: 6 20...64:7
- * ACK slot (AS)			1
- * ACK delimiter (AD)			1
- * End-of-frame (EOF)			7
- * Inter frame spacing			3
- *
- * assuming CRC21, rounded up and ignoring dynamic bitstuffing
- */
-#define CANFD_FRAME_OVERHEAD_SFF DIV_ROUND_UP(67, 8)
+ * Stuff Count				4
+ * CRC sequence (CRC21)			21
+ * CRC Delimiter			1
+ * Fixed stuff bits			7
+ */
+#define CANFD_FRAME_CRC21_FIELD_BITS 33
=20
 /*
- * Size of a CAN-FD Extended Frame
+ * Size of a CAN(-FD) Frame footer in bits
  *
  * Name of Field			Bits
  * ---------------------------------------------------------
- * Start-of-frame			1
- * Identifier A				11
- * Substitute remote request (SRR)	1
- * Identifier extension bit (IDE)	1
- * Identifier B				18
- * Remote Request Substitution (RRS)	1
- * Flexible data rate format (FDF)	1
- * Reserved bit (r0)			1
- * Bit Rate Switch (BRS)		1
- * Error Status Indicator (ESI)		1
- * Data length code (DLC)		4
- * Data field				0...512
- * Stuff Bit Count (SBC)		4
- * CRC					0...16: 17 20...64:21
- * CRC delimiter (CD)			1
- * Fixed Stuff bits (FSB)		0...16: 6 20...64:7
- * ACK slot (AS)			1
- * ACK delimiter (AD)			1
- * End-of-frame (EOF)			7
- * Inter frame spacing			3
- *
- * assuming CRC21, rounded up and ignoring dynamic bitstuffing
- */
-#define CANFD_FRAME_OVERHEAD_EFF DIV_ROUND_UP(86, 8)
+ * ACK slot				1
+ * ACK delimiter			1
+ * End Of Frame (EOF)			7
+ *
+ * including all fields following the CRC field
+ */
+#define CAN_FRAME_FOOTER_BITS 9
+
+/*
+ * First part of the Inter Frame Space
+ * (a.k.a. IMF - intermission field)
+ */
+#define CAN_INTERMISSION_BITS 3
+
+/**
+ * can_bitstuffing_len() - Calculate the maximum length with bitstuffing
+ * @destuffed_len: length of a destuffed bit stream
+ *
+ * The worst bit stuffing case is a sequence in which dominant and
+ * recessive bits alternate every four bits:
+ *
+ *   Destuffed: 1 1111  0000  1111  0000  1111
+ *   Stuffed:   1 1111o 0000i 1111o 0000i 1111o
+ *
+ * Nomenclature
+ *
+ *  - "0": dominant bit
+ *  - "o": dominant stuff bit
+ *  - "1": recessive bit
+ *  - "i": recessive stuff bit
+ *
+ * Aside from the first bit, one stuff bit is added every four bits.
+ *
+ * Return: length of the stuffed bit stream in the worst case scenario.
+ */
+#define can_bitstuffing_len(destuffed_len)			\
+	(destuffed_len + (destuffed_len - 1) / 4)
+
+#define __can_bitstuffing_len(bitstuffing, destuffed_len)	\
+	(bitstuffing ? can_bitstuffing_len(destuffed_len) :	\
+		       destuffed_len)
+
+#define __can_cc_frame_bits(is_eff, bitstuffing,		\
+			    intermission, data_len)		\
+(								\
+	__can_bitstuffing_len(bitstuffing,			\
+		(is_eff ? CAN_FRAME_HEADER_EFF_BITS :		\
+			  CAN_FRAME_HEADER_SFF_BITS) +		\
+		(data_len) * BITS_PER_BYTE +			\
+		CAN_FRAME_CRC_FIELD_BITS) +			\
+	CAN_FRAME_FOOTER_BITS +					\
+	(intermission ? CAN_INTERMISSION_BITS : 0)		\
+)
+
+#define __can_fd_frame_bits(is_eff, bitstuffing,		\
+			    intermission, data_len)		\
+(								\
+	__can_bitstuffing_len(bitstuffing,			\
+		(is_eff ? CANFD_FRAME_HEADER_EFF_BITS :		\
+			  CANFD_FRAME_HEADER_SFF_BITS) +	\
+		(data_len) * BITS_PER_BYTE) +			\
+	((data_len) len. Should be zero for remote frames. No
+ *	sanitization is done on @data_len and it shall have no side
+ *	effects.
+ *
+ * Return: the numbers of bits on the wire of a CAN frame.
+ */
+#define can_frame_bits(is_fd, is_eff, bitstuffing,		\
+		       intermission, data_len)			\
+(								\
+	is_fd ? __can_fd_frame_bits(is_eff, bitstuffing,	\
+				    intermission, data_len) :	\
+		__can_cc_frame_bits(is_eff, bitstuffing,	\
+				    intermission, data_len)	\
+)
+
+/*
+ * Number of bytes in a CAN frame
+ * (rounded up, including intermission)
+ */
+#define can_frame_bytes(is_fd, is_eff, bitstuffing, data_len)	\
+	DIV_ROUND_UP(can_frame_bits(is_fd, is_eff, bitstuffing,	\
+				    true, data_len),		\
+		     BITS_PER_BYTE)
=20
 /*
  * Maximum size of a Classical CAN frame
- * (rounded up and ignoring bitstuffing)
+ * (rounded up, ignoring bitstuffing but including intermission)
  */
-#define CAN_FRAME_LEN_MAX (CAN_FRAME_OVERHEAD_EFF + CAN_MAX_DLEN)
+#define CAN_FRAME_LEN_MAX can_frame_bytes(false, true, false, CAN_MAX_DLEN=
)
=20
 /*
  * Maximum size of a CAN-FD frame
- * (rounded up and ignoring bitstuffing)
+ * (rounded up, ignoring dynamic bitstuffing but including intermission)
  */
-#define CANFD_FRAME_LEN_MAX (CANFD_FRAME_OVERHEAD_EFF + CANFD_MAX_DLEN)
+#define CANFD_FRAME_LEN_MAX can_frame_bytes(true, true, false, CANFD_MAX_D=
LEN)
=20
 /*
  * can_cc_dlc2len(value) - convert a given data length code (dlc) of a
--=20
2.39.3=

