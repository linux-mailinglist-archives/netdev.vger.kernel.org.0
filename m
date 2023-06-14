Return-Path: <netdev+bounces-10862-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4ED3730952
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:41:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 910582815A4
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A17166D3F;
	Wed, 14 Jun 2023 20:41:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924E2125D5
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 20:41:10 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2068.outbound.protection.outlook.com [40.107.6.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DFB2736;
	Wed, 14 Jun 2023 13:40:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZ5MFcD9pnBPlAvVEsOmF7SabUq1R3ifouNuGwMPEu7MNM5bECdKX3P3s4IEeBpdyw9pde5PFm+2VeqGtQWkxz4EnXBcHe9vCj0Vr48+zYu2YiXM1qJJnrkgJhJ2/2L2eg9fkcYonmkHun7wK32EMKmTktfVTU9jopSmHevmPibIq3NERkJmz/DX1kuoQC3tzExwBjqbSviXRnQi0vVeADakLxiS3LFD5BLwUe0D+vQz5lWQ1mbuf4I4a91fDAyBzaGH8CqxespefKcT/r1s3c+E1M8TFD0xToo1ecb5pJ0n11prdmzVUWJ+n+Zh2y5CEbFMdSMgq0dtvaqkYhcOvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/Qt08hwLn32Gr6xDQ3Iuu0NiF3hAxNnt9jZNjKiz9I=;
 b=Hb3cPq2oEp4Nsu4QghDL+kfhux6j9qiWBiUFapPN2GV5/wsoxTsV0hXx2tNwEqipguALNEhHTGng6bc6TIuCvi8anI74x6qpHD4FIZf3YkM3I2xniIrFygnAoDTShMOrt0XEfXHtYIwYHVq6sNZIm7ZKV2RCoXXTwSZLOBs60b1wiJDF/LmSmAiCgiwGuMG8IWB5Uo3NaNRQftZBC5Wf8YGxKErW/msZtp+tN/d3ugJusBT+FBCDl9DdEJurRd4w0qOmQgPHej1xg4w8U772+1OmtyyqUXQviTzksFa0hOhPT9s6PYF7xWcjXECx9vLt80E9fL1p34zetnX+/PZeIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hms.se; dmarc=pass action=none header.from=hms.se; dkim=pass
 header.d=hms.se; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hms.se; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/Qt08hwLn32Gr6xDQ3Iuu0NiF3hAxNnt9jZNjKiz9I=;
 b=VhyMhaTjWIXTh1Hcp+QEzGq7keAqN3pEdgSkW12ACga4tjbRugOKRhhUg0A2OBG2vkooe2ROqWtzgvxFBkTIcMqaHLp7H8F9tUZZu8OIzKlgUs4+daWlDOhOeqoJaG/azDCZhoPipE11H7d/jxvhxlGHedpoO0hW41izK6wQEs0=
Received: from PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:311::14)
 by AS2PR10MB7226.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:60a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 20:40:49 +0000
Received: from PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7fb8:41fa:a2ba:6b25]) by PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::7fb8:41fa:a2ba:6b25%4]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 20:40:49 +0000
From: HMS Incident Management <Incidentmanagement@hms.se>
To: "mkl@pengutronix.de" <mkl@pengutronix.de>, "linux-can@vger.kernel.org"
	<linux-can@vger.kernel.org>, "Thomas.Kopp@microchip.com"
	<Thomas.Kopp@microchip.com>
CC: "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "marex@denx.de"
	<marex@denx.de>, "simon.horman@corigine.com" <simon.horman@corigine.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 0/3] can: length: fix definitions and add bit length
 calculation
Thread-Topic: [PATCH v5 0/3] can: length: fix definitions and add bit length
 calculation
Thread-Index: AQHZnwCAm9EuWLy1L0qQ8ZLYBaqHug==
Date: Wed, 14 Jun 2023 20:40:49 +0000
Message-ID:
 <PAVPR10MB7209C656747E19BED48FB0DCB15AA@PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hms.se;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAVPR10MB7209:EE_|AS2PR10MB7226:EE_
x-ms-office365-filtering-correlation-id: 7e2cbfcc-1d3e-44a9-0fa8-08db6d17a375
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 s4/Dx/xzMLFMNsJfcgzZR8yiKfQzL5arspiq2giW9kj2P1G3IvNjUzhrOq06fcZ5Zu5jkzOWtvsONY5Acfk4gQguLa9i7ImLxoJvEFUD/3hevu2KSFGZNd9qMgOF378RnPA2uIPt8cvcil7Y+gPkyi/xcaMUPRs2h6kMwQnaMQxmx8q5Gf9kjM6F/U0Z1vOzxsTueJREqm38Zs8VnrAWKc4FHNSBJNYSpH9T9TOMDqlWKdQZJ0h4g+v5JlD+TTmzoFhRGOVKplPVQYejpcenAnAPiVdi9Duu48fhLOFIoVrV344U3qQL48MDs0dfaPxHacHf/V2C+oPwFwu6GaUhx0cC+DLvm901Oq6VQEMQNltKPC9OXY0O9xE5DdDuzhXY4niOQkqx3KLs6oppgVcVJaWRKEGs7Gc30gA2AkPhI8ICV7D/88io2yy2jeHqUQ5cnqDBpguFGV6SMNOFF9oybL2lhAqTa2ksO6/2BEbM/5mpdZy04sfHO4yAiWJjj0OwhTntmP+idm9EcGgdXUCzLw6cz+T82taVTs8f/r7tx8mAfTneJS0TyyGKLpcgsxe/jgBycYMJt9rJDybCbw6+GZP5sMvaI6W1creDIy9iSqvOhMXN2Gbg8FC605yG++Pn
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(376002)(396003)(366004)(346002)(136003)(451199021)(7696005)(71200400001)(55016003)(966005)(186003)(6506007)(26005)(9686003)(66946007)(66556008)(4326008)(64756008)(66476007)(66446008)(41300700001)(8676002)(8936002)(122000001)(38070700005)(2906002)(38100700002)(316002)(5660300002)(52536014)(76116006)(83380400001)(54906003)(86362001)(110136005)(45080400002)(33656002)(478600001)(3714002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?fpIoP2fpkYdb6C56l9ZCci1sED1q0n1wd8JpPgCLJeVdSeBdEZCKtF96z4ER?=
 =?us-ascii?Q?oi87V0mpIyLdwx0NlSuKXnX/m+/CBa4zDyn14z3GkVqdDa9ecmjPoQ9Oo9dI?=
 =?us-ascii?Q?vMbOMDR/pGsw6Uy6aIicrvwxwF6EXgEYmAsfQ9bQII4qGmB54JXzzDt7pe03?=
 =?us-ascii?Q?8qLgtbpCSHy9UcaF6hq4VGEIzv6lCIpeFxl1yaNaMlslt8lGqiImggjMH/61?=
 =?us-ascii?Q?SXg9zXF3CFDUotLw+1SdEgsVt7SYi9SWZrjkuzXhkH0j89GwXGMO4eudteHY?=
 =?us-ascii?Q?lderN8q0Bsvow7TX/yFrTUR3ioiE6i4tKYi+1j+FyGbkXXd9PZNYlHh1hgN0?=
 =?us-ascii?Q?e5pqI1YmUbh8aBKMVYoLOmz4Pesd+1eRNPheTfH8198lpga8SVzmIOBGPyTH?=
 =?us-ascii?Q?r9WF2mfyxtm/iRdzPuKBYIDYHV6vn0/ebNoj5cN5cMxHezhpO1b29OgZMwTM?=
 =?us-ascii?Q?B7ytoZNCPch+ZG6G7HHseCGw83W2adKmhUDk9wK8duiktzmjOehD3ws4H0ky?=
 =?us-ascii?Q?U6vhDWLB4MzdlFUUVvUmLXNU1JS6jq/AZrbwIY4HXZo/4EYA5BQbesKAHU0i?=
 =?us-ascii?Q?hrk5wQhTnrWXEHvEgx2Dr1SvQHbnIzmcAH5I9e0zZIKGBLX6Rz8YqY82m2h7?=
 =?us-ascii?Q?9+cqsTDCvzYz96Ps0pqJSJp7/OXs8+WJxETMYmuhyya162EU42WAZ2dbQA4O?=
 =?us-ascii?Q?wBbcvRVOymtXCf9+fOWZQIiwJ7FYgJsvBD37j+hvQ06CTMTlHWKvUwyeew/D?=
 =?us-ascii?Q?cXDEFRHkLpH6gzU5w2f2QhHblRKNodxf1nwWtoekbU5ED32V47flbd51mkv2?=
 =?us-ascii?Q?Px+ouw+JlD5OGYZmLBP4dss+CvA/Rvk1to2TLBLhhGzzohJERy1NxrzoAmjg?=
 =?us-ascii?Q?dZWNGg/cWpNpFGZhJR8MOI3+ALNRWLpx163m8W4+MB0CI0xttqBvowxQ+4+k?=
 =?us-ascii?Q?0G3E05hbKe7JsU5feEUyagTvWLt7F2Q1VzQiWuENSSibZIzDibPFfZCHvw0D?=
 =?us-ascii?Q?mQ3FZuWm6VniS8aYfEwGaOCW0v9/8T/AjQ2D5k6GB+IsolfhaGaayHKI0oES?=
 =?us-ascii?Q?T58sZdleHTPx3CiNv2a8pvcNwnwhVjMLHDeigAV3MRO5MOHZlU18nVIgL6mU?=
 =?us-ascii?Q?gFGO93dH3DTNZyh+CPUYcCLgexeN5XJmvT9jRpH7oPGPult+XgYq/dN/4BY3?=
 =?us-ascii?Q?qBcA3RRi4QuPIkqhDEzj8qnwFLduCfHnV4ExEmCwPuDRF6LpdV0OSt2YzstO?=
 =?us-ascii?Q?L43GUZM+4BOtF/Rbqq2gx7gdAG48N6+Y5MrROYr7S8wiD5ajlz4mVU3Wflh6?=
 =?us-ascii?Q?hfwUZfzSGsJ6WK4NSyG40Uq/5acegv1QF7KdXFLCu9oMiPHAC0zmgIs/stDL?=
 =?us-ascii?Q?lpCboMI51oP21Hx9AwMr+rXIC01REFpOr3dmqVkE/+G8lDr0KYbqgygnHAGi?=
 =?us-ascii?Q?htb8e1LtTXHpy0OJmr7G8mqTjSnvlIt4cjjBtNMbkfuz6yyqSM8JAoa64KtC?=
 =?us-ascii?Q?NPCBSo/gu4uyaAdr9m9TYbDuZYrjHHvALNuFVJql1RftaDfXu5xsC6sSWA11?=
 =?us-ascii?Q?KMfH827v91sJnUimc1KSf46Bzo0zo8YaK7PCQsiNGg/1f1+OSMUJ2L0mjtx7?=
 =?us-ascii?Q?1x+nL0YSKnS/VEQq58yPb9clPv7ryuC5OL6QFObn+GzY?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e2cbfcc-1d3e-44a9-0fa8-08db6d17a375
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 20:40:49.6786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5c7c1590-4488-4e42-bc9c-15218f8ac994
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RkhC9vUkyJ+JKB0C6ukpGOfXypGfOjjG+GZBrhcZZkH0zm1hu6qJwW1AQjnTsC66W1q4nuH8qGq8daz0ZiGuJ2HMGNlT6mh/qRhI+eeCm0F/Ua5mUE3fIUCzj+Rs64vZFfdTPCC4eZpundNH2i3vJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR10MB7226
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

**We apologize for the delay in delivering this email, which was caused by =
a mail incident that occurred over the weekend on June 10th. This email was=
 originally sent from vincent.mailhol@gmail.com on 06/11/2023 02:58:07=20

When created in [1], frames length definitions were added to implement
byte queue limits (bql). Because bql expects lengths in bytes, bit
length definitions were not considered back then.
   =20
Recently, a need to refer to the exact frame length in bits, with CAN
bit stuffing, appeared in [2].

This series introduces can_frame_bits(): a function-like macro that
can calculate the exact size of a CAN(-FD) frame in bits with or
without bitsuffing.

[1] commit 85d99c3e2a13 ("can: length: can_skb_get_frame_len(): introduce
    function to get data length of frame in data link layer")
Link: https://git.kernel.org/torvalds/c/85d99c3e2a13

[2] RE: [PATCH] can: mcp251xfd: Increase poll timeout
Link: https://lore.kernel.org/linux-can/BL3PR11MB64846C83ACD04E9330B0FE66FB=
729@BL3PR11MB6484.namprd11.prod.outlook.com/


* Changelog *

v4 -> v5:

  * In __can_cc_frame_bits() and __can_fd_frame_bits(), enclose
    data_len in brackets to prevent operator precedence issues.

  * Add a note in can_frame_bits() documentation to explain that
    data_len shall have no side effects.

  * While at it, make CAN(FD)_FRAME_LEN_MAX definition fit on a single
    line.

  * A few typo/grammar small fixes in the commit descriptions.

Link: https://lore.kernel.org/linux-can/20230601165625.100040-1-mailhol.vin=
cent@wanadoo.fr/

v3 -> v4:

  * No functional changes.

  * as reported by Simon Horman, fix typo in the documentation of
    can_bitstuffing_len(): "bitstream_len" -> "destuffed_len".

  * as reported by Thomas Kopp, fix several other typos:
      - "indicatior" -> "indicator"
      - "in on the wire" -> "on the wire"
      - "bitsuffing" -> "bitstuffing".

  * in CAN_FRAME_LEN_MAX comment: specify that only the dynamic
    bitstuffing gets ignored but that the intermission is included.

  * move the Suggested-by: Thomas Kopp tag from patch 2 to patch 3.

  * add Reviewed-by: Thomas Kopp tag on the full series.

  * add an additional line of comment for the @intermission argument
    of can_frame_bits().

Link: https://lore.kernel.org/linux-can/20230530144637.4746-1-mailhol.vince=
nt@wanadoo.fr/

v2 -> v3:

  * turn can_frame_bits() and can_frame_bytes() into function-like
    macros. The fact that inline functions can not be used to
    initialize constant struct fields was bothering me. I did my best
    to make the macro look as less ugly as possible.

  * as reported by Simon Horman, add missing document for the is_fd
    argument of can_frame_bits().

Link: https://lore.kernel.org/linux-can/20230523065218.51227-1-mailhol.vinc=
ent@wanadoo.fr/

v1 -> v2:

  * as suggested by Thomas Kopp, add a new patch to the series to fix
    the stuff bit count and the fixed stuff bits definitions

  * and another patch to fix documentation of the Remote Request
    Substitution (RRS).

  * refactor the length definition. Instead of using individual macro,
    rely on an inline function. One reason is to minimize the number
    of definitions. Another reason is that because the dynamic bit
    stuff is calculated differently for CAN and CAN-FD, it is just not
    possible to multiply the existing CANFD_FRAME_OVERHEAD_SFF/EFF by
    the overhead ratio to get the bitsuffing: for CAN-FD, the CRC
    field is already stuffed by the fixed stuff bits and is out of
    scope of the dynamic bitstuffing.

Link: https://lore.kernel.org/linux-can/20230507155506.3179711-1-mailhol.vi=
ncent@wanadoo.fr/

Vincent Mailhol (3):
  can: length: fix bitstuffing count
  can: length: fix description of the RRS field
  can: length: refactor frame lengths definition to add size in bits

 drivers/net/can/dev/length.c |  15 +-
 include/linux/can/length.h   | 299 +++++++++++++++++++++++++----------
 2 files changed, 216 insertions(+), 98 deletions(-)

--=20
2.39.3=

