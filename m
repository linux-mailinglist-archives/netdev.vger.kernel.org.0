Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCF448CD20
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 21:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357650AbiALUhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 15:37:35 -0500
Received: from mail-vi1eur05on2041.outbound.protection.outlook.com ([40.107.21.41]:11360
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229942AbiALUhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 15:37:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIUlZrbkn/PAh9zyNztI5gMaQUteQGNhtvp0hn6dUK7KSKTFdgR2UpEMByP7STKKP6E1kJHVNrj+xYqPGIcnGUsKXSC0SwbkmixLR8UD988EyfxKmw8/BS3X6nNxMvJAk+gwoitEi7H5HTBvELvUbVLQ+wt/O1fJ1AdUAgrFQFLM8cWxn0jTdmxjyeMvemm3zG6j5NjdunUYKB0y+vJonw2aDf+V6WH5xlM0zuDlgCjh09sHWVraKGs1CZJtOcuQ0dYydfEoGvYSJrve9aefgcpbS9IZpbRtTNLh/kKHvry+X0nHYs16jWMTdHQvW1t8gCDQNDhSYvT4bfOA5woj8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h8f72iG1t0MLfYdb9++XQSfV+p4qiNQyZZXLjmwSarg=;
 b=T1Cq5/oG3MwrrlMXXqss/+9VpJTQLMYKxgpvnuq0RPopd8pb4uqVFT+Udzd8PSjO30tbeUaezYgrVLLdphxf1QN6x00DI6qAerSVczePbdMdqOveVlynM1oUyUZTuTE1QrsQbWQFOGbAnyjW09+Q/eq36gDxTSVBC4xovknfLhfO0WnA7zimLIqMEw2kSY9Dg0c/hObB4Mqq5ZZr2lwQ5k1R3hp1oZ0Tg18bR9B2zv4Yxzwy/rynauOOjYqK6Cj7ItjAjbx3lLPO4oWRZJLNKbAkwJDlLkJdLPElPjTpuBfnZRYLyEkj2qbOPeCzaPwHjiAMEB0GZwxZkL8unePh4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8f72iG1t0MLfYdb9++XQSfV+p4qiNQyZZXLjmwSarg=;
 b=nPHp5aw7Spe86KXFKgA0DJLjaie97l9iWJlRKd6pA2Mtocbh7OX5WGxY3qX6VOf+q7awaK3AtRs2LWg7Dox4RXHq5p80XiT5ZBPhdFrttKJBfrhL85hJt5ygpYEEzmL06eS5Us5AwPfD+BwVRTeRVvrr97JKKc3ShOret9Fhi/E=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4223.eurprd04.prod.outlook.com (2603:10a6:803:41::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 12 Jan
 2022 20:37:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4867.012; Wed, 12 Jan 2022
 20:37:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: Re: [PATCH net] net: mscc: ocelot: don't let phylink re-enable TX
 PAUSE on the NPI port
Thread-Topic: [PATCH net] net: mscc: ocelot: don't let phylink re-enable TX
 PAUSE on the NPI port
Thread-Index: AQHYB/IAv+45xoCFcketUCA8SA2bPqxf1ssAgAABwoA=
Date:   Wed, 12 Jan 2022 20:37:31 +0000
Message-ID: <20220112203731.73d7weqpxd2vbvzd@skbuf>
References: <20220112202127.2788856-1-vladimir.oltean@nxp.com>
 <2662f157-fa92-8a99-473a-9ca5f7887d28@gmail.com>
In-Reply-To: <2662f157-fa92-8a99-473a-9ca5f7887d28@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63ee47ca-2b5a-46b8-b7c5-08d9d60b5b8e
x-ms-traffictypediagnostic: VI1PR04MB4223:EE_
x-microsoft-antispam-prvs: <VI1PR04MB422358C1CB538E6AB69A0504E0529@VI1PR04MB4223.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a0+I3w2QHGlXcH1IbbeR7lHtDY8+0eG48jsNK93picnOwTsn5jS7R1jrelw4OLXcOPTgmeKgKBVz2bcWVBqyAEBw4qUdTS8/WdK9k+lqOkEWLTtTr8n/qfyvuI7GX21vyG07cbSESFDPLlmpaBXwT2Kd2o9aGt0yoHD6KFGANb8398YEl3ZoBz/uYT9xn1ydQOjoEUVIN6npNeUf2F8RHA+Pc+yyYw17hRrpj+xvTXhcgx4xaZaB/Tc6OcBXxBYTdnAP69+AzuVswDFVWNu0asWjYjP+HLt0yV1i5vFLj93nV/I9mgtkBrtpo1mynREZInAMx1TGRxvmT/72vNbkerLTokOkZJCSQDK8YM57JEHFCGmzvo2g52i6MDKrUFReoZRSlrQ/ikkZIa9Z2bNNSSYT2djMLNW+naYRIUBJ1Zwst8dGxMbWD5nSdUNaRwFAiQAvVGBRSPmMvFseck2Y+8AVthxFvSY1yM1bozK0oEEE6sMW/IQvus0JsAbiBssFpd4jjTKjmhBDT+T97M7F+sQYAUXPEMXnh586USbJIuYQ8VM3VchY0eSZGD10gXsZj1JWeXqtPRcco+wANnvta+S6BaXFFQE/hc8o+fmt1SJhiwmyy6hnyAH4WmX4zyb26AZeR/SysESqstDE3uKxD4xZxVV+gp1OpEgVoVjKdpUr7Uc77tpkAEJ3IJ9qM7unRK5pdbjSVAQRySNbH/Vhqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(122000001)(508600001)(38070700005)(71200400001)(54906003)(6486002)(86362001)(26005)(186003)(6916009)(76116006)(91956017)(66946007)(64756008)(6512007)(2906002)(9686003)(38100700002)(6506007)(66476007)(66446008)(44832011)(83380400001)(66556008)(4326008)(1076003)(4744005)(316002)(8676002)(33716001)(8936002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lgeDH85a7wgPbhMqysCSVHBNmaxK2QJjXg03fdN6voYDHq6C03ueyAuo6yZO?=
 =?us-ascii?Q?MqNCGs8fS0rv5AjSZeGxDE02Aa8tfwlEw5P2x+VcfUnouIoXd/cgV9esoLwr?=
 =?us-ascii?Q?1vsKcjXYz5MI4YyB2EoOkjg0xlKkME9+3uxM+wMF+mFgcRZZlTv2t46rqZV5?=
 =?us-ascii?Q?coHTYo8N2u0hlNI8LIL63++NZYFb8skTMac4spglw484lxB0Ts3KInFbiZfn?=
 =?us-ascii?Q?f9gQEKqZ32D2nvZLhWQqHWPVBFAG+EqEMDxazVPVi+qDhurYecXy9KjJf07l?=
 =?us-ascii?Q?Atj/BEyUUUuK0qumk5/BThWKHmt7DOZXVBCoo9DozEEgEkqfvEYK7tVZKw4d?=
 =?us-ascii?Q?7MPn2WCO7eg/xibPESIk3Rx04QEG7FR3vh12zoVqGGwnA3Bc4j04GHvgD+De?=
 =?us-ascii?Q?O5pKFTpytq7NYiN2ElDmJtfoDatueZF6U/rWoiK0FycrDZ5eyrqmgRu7jmg1?=
 =?us-ascii?Q?pihqpKuI7EzrAc2yBQ6Ui2pEZteG0eQBr8IsX9nd+fKPEBbIIHvVp85y7hzy?=
 =?us-ascii?Q?Plef751VnA2lGZ7edj5Q+NS+3Idf5aWNbl2rSFPHlIuKbc6vvaIutxnUJYuw?=
 =?us-ascii?Q?uy/XCajOvTCKHkcxz8B2I3BrVggqFRlkzNwhmKd+vKaS85PqVFNQc4PBZid7?=
 =?us-ascii?Q?KOdBXvrEaYe3lL5GQb+OeW15wRm3ar4jKK40IlB1xFm7oo7LPx+sT9J2TNUl?=
 =?us-ascii?Q?riZRZ6GmWZ46QoSyt+oeq+U6n7IuwwafP/8y+S6HH0EPhJbDrl1czAdsxGdK?=
 =?us-ascii?Q?RLUlOS3JrrvGfCIEcd+qiVjY240yhdG3/iSfTh3o+p1cDx90KDWU6x+lfMEY?=
 =?us-ascii?Q?sJ977Nv5CeusD1PVP4xmkzLdvnJdbszs48RUGkDKEwhbx2uXpZSCAt18Ls4s?=
 =?us-ascii?Q?YWr5mkAJQ9I7Ivd0qb+rNEKuAWKaD324A4d1aW6+5gmnm+vSwPV4HYt4vNvJ?=
 =?us-ascii?Q?/3bk5uNjiyphbwxyCXIA1CI1dbOmy6oqP4JjUBL4RHIyVNPf3Q5HRnmcyxbF?=
 =?us-ascii?Q?RU9YVpvH7DBmD/8sqTncEDCGPDebR65axd7nuMf8FQdDQ24wQ7HE8A9Cb7nt?=
 =?us-ascii?Q?DBgfrm+d4uHkJS8x/C2Q5U+tbQTd8jceDEQXJ8PdDSr5g2qfYgQgN1zJHoEp?=
 =?us-ascii?Q?Tog9M+Cj2EsCVtvDwBOi1s0jh9IJ5UsHLwz9J4sT1qjioG/ogu/Iif6TPLrG?=
 =?us-ascii?Q?vIiHdd1nV7bL2g6vwfyCinTqgk0HLAaknqaOHEXSkBNtUEWrJZPdvFfEbiqg?=
 =?us-ascii?Q?E3ISb/JBzLBgappFXNZBv3NWGJq8tW+NVhmhwkrU6JFQEdn8JRAbajFBfCDw?=
 =?us-ascii?Q?GNMwARB0FUYqMYzBU5zn4cE5DJExyMtlqIaJSh/7ymaoGOQXAswL+XJlUG7m?=
 =?us-ascii?Q?oxvinbtgdyPIg+GNhob/nFqp4OLF9E2IB0eaek7U6Mikdu1UnJ6F94m5csft?=
 =?us-ascii?Q?QLDA6ccGzjV1bBz2KoDAVmn1WE42fz3eoUi7sK+CkcEFFA1ffFqt4m0KxB6Q?=
 =?us-ascii?Q?To6TgSOLrar3r0sDOaZa+zuuMT6tIiBv88MNh9r6sUOuFbcI+X3IPD4iAaey?=
 =?us-ascii?Q?MfSRB4Q2PsZi1W+3DpFpPasNyrNKMBCsX4HFjEeQNiQuSTju1BudeumZhB+1?=
 =?us-ascii?Q?p2iLxqysDDLG1cqZHM2E22s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A9A62D7C0767494ABDB7BABC89F65635@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63ee47ca-2b5a-46b8-b7c5-08d9d60b5b8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 20:37:31.7293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s7i2OBKJgolx7p0OSci+zb1cBTK7ArnbiHlqNseb7PlgXqA3fb+xiiQZp4c7wJIwSWwy7Oye5q33lvERlx+dHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 12:31:14PM -0800, Florian Fainelli wrote:
> Still quite a lot of retries, do you know where they are coming from?

Yes, they are coming from the fact that the CPU port runs at 2.5G and
the front port at 1G, and as mentioned, there isn't any flow control
when the CPU port is used in NPI mode.

Flow control on that port pair _is_ available when the CPU port is used
with the ocelot-8021q tagging protocol, which is the reason why I
updated the device tree to declare "pause" for those fixed-links.
We can't enable or disable flow control on a fixed-link at runtime in
Linux.=
