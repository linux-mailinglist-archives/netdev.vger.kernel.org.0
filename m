Return-Path: <netdev+bounces-10861-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B9C373094F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:41:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D8521C20D87
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307E310967;
	Wed, 14 Jun 2023 20:40:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B76EC2C8
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:40:54 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2068.outbound.protection.outlook.com [40.107.6.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F7326B8;
	Wed, 14 Jun 2023 13:40:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAaty/TUrVeXCRRBUKiI7Sn5QVxEYMwCP3KSqN8dTxa6Y4b4SweHPRhF3ki6AVB2umtT0rFPMmpQa8ZOf+S7CK3e+JCemoi5pnlBzMydc7vAbKeTmBprSURYI7JvlhvgRijABcrWlUvX2s0ZkVBBCdyMe/6tIBSO3O7Qrd1WV7cch23C6C4eShmmxNEfZl0U7cIpwYDqJs2RCrwI3HeQCd2FZSsipQUluZF46ujk2WFZmSuirm7dTdtDJoAHoEloVeMN/XRKmi4JY/kgcXn2EZH1dBggMCgE321MmRj45P7Q6qqsWkh0GmiQtdn3q2sUk5SyeepCMzgt3zPqULkN4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VxF6aO35+M+sme2Qg1Fe9eUrqv+idvReFp5nkQhtTSM=;
 b=eLgjBXsk3T4JCHTpB1zFlyTrkN2/0TT4l5vS4FnpY+lh38ZVB/GPkkrn+LwR+GTibhgci1hUEi6nB8FhbsI6bQHNqsAavonoPJm59PV9F0YeSGf34c0LTiRKG0JN3JgL0xlPY+7vn5rQmHkdzcA+5G/kFZI2NZvl9X90Jc9/JAkWlZhjMrby4V+vzu1e6qOdPLQ1oBEfslqin4xzoF5sVAlVm0Q92zmeZ+l44vZXJU0ovrT5YMlHbkWQZa1+N7/eiUFWacvaKF6sC9AeOQ0vSkhVYhdmZJKJ2WSAFhoCLjVo9PDnyf09Pa3SY9c/QbvfnkuL4v6KK9t1veoP023+6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hms.se; dmarc=pass action=none header.from=hms.se; dkim=pass
 header.d=hms.se; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hms.se; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VxF6aO35+M+sme2Qg1Fe9eUrqv+idvReFp5nkQhtTSM=;
 b=LMXUV0sJHQHjjvTcYzn8lfc4i7zoVQPFBKAVzUT9wDVsHvjSi8QDwy31MgOciHXqTJLHCOQPW8od/suVobugyQUusYbPiAtADBhUgihbrKOGI1ESAN5L1E+XUxoKkRWS/soVpJ4lCTAkKeWgpjMV3+YvpYryRzDdQ2e8XMHxenM=
Received: from PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:311::14)
 by AS2PR10MB7226.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:60a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 20:40:43 +0000
Received: from PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7fb8:41fa:a2ba:6b25]) by PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7fb8:41fa:a2ba:6b25%4]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 20:40:42 +0000
From: HMS Incident Management <Incidentmanagement@hms.se>
To: "mkl@pengutronix.de" <mkl@pengutronix.de>, "linux-can@vger.kernel.org"
	<linux-can@vger.kernel.org>, "Thomas.Kopp@microchip.com"
	<Thomas.Kopp@microchip.com>
CC: "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "marex@denx.de"
	<marex@denx.de>, "simon.horman@corigine.com" <simon.horman@corigine.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 1/3] can: length: fix bitstuffing count
Thread-Topic: [PATCH v5 1/3] can: length: fix bitstuffing count
Thread-Index: AQHZnwB80da4Mh/1cU+tsGKhSv3dyA==
Date: Wed, 14 Jun 2023 20:40:42 +0000
Message-ID:
 <PAVPR10MB7209CEA1F5AD12B2E5C8ED86B15AA@PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hms.se;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAVPR10MB7209:EE_|AS2PR10MB7226:EE_
x-ms-office365-filtering-correlation-id: 96670e17-0a6f-4aa8-faf5-08db6d179f6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 siVputgqGTK4xuvfuVFv0ruV3Nl6WUg09hr30eWjssM/7YEsJFEzYspRoB2QpSL9PZsoFPCGSIGXCb0ybrskAU2qWlNpakJaQyny7ezk4IulEhBi6WPzahRChCUYwazxrK+masJXUzdhra5Qp3VpuGOxye5DW+VdopaGv7WxclCKwvODsGDZFFuW1O60BdmPTCDd69NB88lhrC0z/OedROnGHQi16ZSnnAQoRxkJHnUjJuEWmVKTAJuIlBxuPcEPHOiPcwKCIhaXmXK5Fny2gl+ZLBb/UqaMWekNQBfd9gkhUorzmwToGpwWZwcLVpZo/ojohQdeEzsjTayB7AYIIWxY7s3JmId438hyFM+uXjUQGgM2WKsvmzf+JUXTXclUKq27SMoi34NMnvAcuez7SM0q+5r7X/Vtqh9/hhMgb7+SbLsNcdX97ZzTJ2pKjqD3U/2sumpdfwFjOdqOOkkYXlzYp0tSRdpy+Tb7Tr4jrVJVRAHnLqM5Tz3McCflYgZLvPAZQinz+PVfd3/8HMEwUAJt+JqTREd3v9hcG629UHEfq17EgFLhEKS1vTJ54UUFAphXfgKpKDn/o8sJW+UK7pJo8eHCjqWLRd6A96rgEgaC+py0UEh4op4NBzIZWXtj
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(376002)(396003)(366004)(346002)(136003)(451199021)(7696005)(71200400001)(55016003)(186003)(6506007)(26005)(9686003)(66946007)(66556008)(4326008)(64756008)(66476007)(66446008)(41300700001)(8676002)(8936002)(122000001)(38070700005)(2906002)(38100700002)(316002)(5660300002)(52536014)(76116006)(83380400001)(54906003)(86362001)(110136005)(33656002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?BqXCG+HsRuUS1UNaaP4YE39VapRH1uouqTJegB8HsEQ978OUNdVUi86SyH1P?=
 =?us-ascii?Q?RcWZhgesAE1qgMUz3DUZCZy9KqopC/k1pN+dxR5bGjBaj4rhkNba1kkT83HJ?=
 =?us-ascii?Q?cY4VWq9nFzruc4lG2Je3MowWP7UMRU0y89NA/9kXonHBmkWYOXI7dqZPSIZ7?=
 =?us-ascii?Q?KgHdIIR4ryljT8OtkEnaPYL0wB86+wCoBYxx4o9Mv2wDDIU31oeEzlbYMjen?=
 =?us-ascii?Q?tgGDa+IGpNJsRp1GJuwvaJvCCrRORtUoG+gi2hy4oHHUNN1Ng5fhPeCgL115?=
 =?us-ascii?Q?NHg3FoZ9I13cSA/ccbfVgIGQjYsTpk/byJ2QO33THuQOlQztNweBkON52Ap2?=
 =?us-ascii?Q?/02U5WRw503mmMWFkwgbToSF/15IG70WcO8IEDcIvbl2cQktHrqi7Bp0+P9F?=
 =?us-ascii?Q?TZ3gd7V5PZt0FFitgMuweiTj2y8jGxZvQwjjSzVKDF2Eun9kTGKMhnL71yzB?=
 =?us-ascii?Q?peUMQXfEkxnqEwRj70H6kQd8cOCYaYYdXZ5pLaKutIO34xzIcZGdCYBWEftW?=
 =?us-ascii?Q?KB5qY/9nMMC6iuGckn6xucVxQeimEoE9ETNE82+r0kpyM+xAbfRm8q8CNvVb?=
 =?us-ascii?Q?aNSL5JLD3zY7xhQr6HCKLeZlovq1kExejit7DcZC3wiJWZPO/c9Ni1mrvEQx?=
 =?us-ascii?Q?1AKbBeidYsWLO2dNKA7S1zb4qG1HQe2jm8wROFI0ajr9z4mz73hrGBGdrNVf?=
 =?us-ascii?Q?y/ZCZNC1r1seBJjQv+vPqFIJphbjJb98ckU8RrjrJY292xp05QqVpI+oB1ro?=
 =?us-ascii?Q?s2tXRMReWB+Lypl3Rxfzu6X0J0MAgrFwNKFm574AC44WpBWvWqFLo5FFzsOX?=
 =?us-ascii?Q?zwyfHtXl+wdQpiUQHpZRGkZgirWAujfO5hM+wM87UbqmMH3d0XmhpzKLLUD1?=
 =?us-ascii?Q?UQa7Oi6FEH15TpbZYCKzxCBlpYr18uVHhJ/eU2a18V1AVy8+dt29MZ+F60Co?=
 =?us-ascii?Q?VklDJ4RrLd1jj1G/Qfke0ksuBNjDTZ7bqw7Aeb5NtkkFUrfWRNXnQ3ML1kM5?=
 =?us-ascii?Q?xs9SVbv8MFBCRVYXoB6+6k7HWiLsFr7nuGJrXjrQ6S9pN+afocCXQ0+gF/4H?=
 =?us-ascii?Q?1r6Aa2JG0wSAUFhSur6+kkQHstArvAAZTxtPunHx6u+YLMQ42uk6yFn8vFyg?=
 =?us-ascii?Q?Is3lVrbSuScIunvRci7NC+vas/lAzBeO20/jCv0njRy9VugOus+1alsRHOpl?=
 =?us-ascii?Q?mTMfbLhIMnSDoYHeb5nO6W+jd7ngs1szvvZyg4dRXTiVVK8JSi14oi5y0+MU?=
 =?us-ascii?Q?5sBajsWlIXVgLTidxMa6a7tyBv1ea2p8Kt0XpQF4rEyRo4AzzBfWYVGKdS+h?=
 =?us-ascii?Q?ZyJH5FIFZy9szImqsDuOwOqIDOyUhWdAk4CECKzKdH1YHao3ZpK1miav6KdQ?=
 =?us-ascii?Q?O+G7K+wFerQpQeg0HDsoYB6LnlUITCjr/3w26ngWKLlnsKZL8u5hFvYFirtx?=
 =?us-ascii?Q?hHKqXtrTSMBIk5Xp7tNDw66yoTwXRAvXgc+KczIkoU1+cenPJ6o4tRYmC+A1?=
 =?us-ascii?Q?hgblzNRDR440v+RqnhtFyyDsDdH/wZeZeTpYGxNvnSOS1ZIAesmAtDig1W3r?=
 =?us-ascii?Q?Gi+8aGEkQUt+n376xBW2i+AX4kb0WYkLAq5usvg0Q3FHv4RZ0HjN1K2QFMHa?=
 =?us-ascii?Q?uc3QBZ1OGIUop/GItYOGZ3DQnQm+azoYEZdlqw55/YaQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 96670e17-0a6f-4aa8-faf5-08db6d179f6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 20:40:42.9112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5c7c1590-4488-4e42-bc9c-15218f8ac994
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w6c2URbV/sIOG45KA42N+RLD3jvnbPav/sUgGxJimWvGTsANd+VX33yS4WhJTmf0gYy901afUh9RBqQhp4erlt5C2WU/eElRIkuOfST1EdOUCBPYAHiCpTzJTvdo/5xXO6nn2h/vD/Xc+0nJeHEmbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR10MB7226
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

**We apologize for the delay in delivering this email, which was caused by =
a mail incident that occurred over the weekend on June 10th. This email was=
 originally sent from vincent.mailhol@gmail.com on 06/11/2023 02:58:08=20

The Stuff Bit Count is always coded on 4 bits [1]. Update the Stuff
Bit Count size accordingly.

In addition, the CRC fields of CAN FD Frames contain stuff bits at
fixed positions called fixed stuff bits [2]. The CRC field starts with
a fixed stuff bit and then has another fixed stuff bit after each
fourth bit [2], which allows us to derive this formula:

  FSB count =3D 1 + round_down(len(CRC field)/4)

The length of the CRC field is [1]:

  len(CRC field) =3D len(Stuff Bit Count) + len(CRC)
                 =3D 4 + len(CRC)

with len(CRC) either 17 or 21 bits depending of the payload length.

In conclusion, for CRC17:

  FSB count =3D 1 + round_down((4 + 17)/4)
            =3D 6

and for CRC 21:

  FSB count =3D 1 + round_down((4 + 21)/4)
            =3D 7

Add a Fixed Stuff bits (FSB) field with above values and update
CANFD_FRAME_OVERHEAD_SFF and CANFD_FRAME_OVERHEAD_EFF accordingly.

[1] ISO 11898-1:2015 section 10.4.2.6 "CRC field":

  The CRC field shall contain the CRC sequence followed by a recessive
  CRC delimiter. For FD Frames, the CRC field shall also contain the
  stuff count.

  Stuff count

  If FD Frames, the stuff count shall be at the beginning of the CRC
  field. It shall consist of the stuff bit count modulo 8 in a 3-bit
  gray code followed by a parity bit [...]

[2] ISO 11898-1:2015 paragraph 10.5 "Frame coding":

  In the CRC field of FD Frames, the stuff bits shall be inserted at
  fixed positions; they are called fixed stuff bits. There shall be a
  fixed stuff bit before the first bit of the stuff count, even if the
  last bits of the preceding field are a sequence of five consecutive
  bits of identical value, there shall be only the fixed stuff bit,
  there shall not be two consecutive stuff bits. A further fixed stuff
  bit shall be inserted after each fourth bit of the CRC field [...]

Fixes: 85d99c3e2a13 ("can: length: can_skb_get_frame_len(): introduce funct=
ion to get data length of frame in data link layer")
Suggested-by: Thomas Kopp=20
Signed-off-by: Vincent Mailhol=20
Reviewed-by: Thomas Kopp=20
---
 include/linux/can/length.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/can/length.h b/include/linux/can/length.h
index 69336549d24f..b8c12c83bc51 100644
--- a/include/linux/can/length.h
+++ b/include/linux/can/length.h
@@ -72,17 +72,18 @@
  * Error Status Indicator (ESI)		1
  * Data length code (DLC)		4
  * Data field				0...512
- * Stuff Bit Count (SBC)		0...16: 4 20...64:5
+ * Stuff Bit Count (SBC)		4
  * CRC					0...16: 17 20...64:21
  * CRC delimiter (CD)			1
+ * Fixed Stuff bits (FSB)		0...16: 6 20...64:7
  * ACK slot (AS)			1
  * ACK delimiter (AD)			1
  * End-of-frame (EOF)			7
  * Inter frame spacing			3
  *
- * assuming CRC21, rounded up and ignoring bitstuffing
+ * assuming CRC21, rounded up and ignoring dynamic bitstuffing
  */
-#define CANFD_FRAME_OVERHEAD_SFF DIV_ROUND_UP(61, 8)
+#define CANFD_FRAME_OVERHEAD_SFF DIV_ROUND_UP(67, 8)
=20
 /*
  * Size of a CAN-FD Extended Frame
@@ -101,17 +102,18 @@
  * Error Status Indicator (ESI)		1
  * Data length code (DLC)		4
  * Data field				0...512
- * Stuff Bit Count (SBC)		0...16: 4 20...64:5
+ * Stuff Bit Count (SBC)		4
  * CRC					0...16: 17 20...64:21
  * CRC delimiter (CD)			1
+ * Fixed Stuff bits (FSB)		0...16: 6 20...64:7
  * ACK slot (AS)			1
  * ACK delimiter (AD)			1
  * End-of-frame (EOF)			7
  * Inter frame spacing			3
  *
- * assuming CRC21, rounded up and ignoring bitstuffing
+ * assuming CRC21, rounded up and ignoring dynamic bitstuffing
  */
-#define CANFD_FRAME_OVERHEAD_EFF DIV_ROUND_UP(80, 8)
+#define CANFD_FRAME_OVERHEAD_EFF DIV_ROUND_UP(86, 8)
=20
 /*
  * Maximum size of a Classical CAN frame
--=20
2.39.3=

