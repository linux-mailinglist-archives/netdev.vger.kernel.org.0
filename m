Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2361D4612B4
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350665AbhK2Kp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:45:29 -0500
Received: from mail-eopbgr00129.outbound.protection.outlook.com ([40.107.0.129]:45639
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230099AbhK2Kn2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 05:43:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9o6TBb4jcgTqbAEBcUR/82HS+pVTDBz4IEc50D1B1/5zBNcmI7i2AmfHDGrlY3hoHl7LiPLN1zf0mPGJWJk6tYUiCkmZ/NDJuN8QRhT6ZQ+w3oDzttQ++f/fTt7hYorDhMungJgOeHc2I5qcxprzelpHoQUUk7AioApW9Q5+niq5Ut0WK/Gw+hGBqyUne9TOpSP8nZj+v6gyfh2fedhG31KqhwmPIQoSg6itUECmD1KK0XTZXRuklcT6boIeclQSg+bIio73VWLMAc+QGwprGfoKRJ150aeTwOW8TpqVq5FlIGFm+SlvrcTKUqRk/iMlAKMpKjhEDszUXBu4HrvyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iN4n9eZZkqdBMjVcYiiuXHG9VfCJmP61TndptQOR7LM=;
 b=G9RPvVjBotSWnjmYm+3nZmWJDU/cFu+YPrGThHbFsOokdwscWQbKzM4UzKOmkM/+i4/yPQrNV1F6kOH4xiSpHR5lnH8J+rw5zgwroUdScOvbgiJzNZj1m+D1ELMGpcniiaibVa1t5guZYvzwDKHs0TGkyovS/QEcZEeKgGMcGrZDytBWlQmt0SsKfxMathqy/m4zYhCq/9VVes9zCjkYirvfhyFQdz4PHJlMpnWj+XOASZ4kxzingpZLwvVWMl+pp+ALEu/3QPTpL4BJZxp3nsXn1JDbhIjiAkOuiLcX1JgPGMnIphaDfwgobv9hAT0LawJASWjAfwILOtnH/oKz9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hitachienergy.com; dmarc=pass action=none
 header.from=hitachienergy.com; dkim=pass header.d=hitachienergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iN4n9eZZkqdBMjVcYiiuXHG9VfCJmP61TndptQOR7LM=;
 b=UgnNUp+thoCL852RppIWxlsXUBPaGp++xahxLQ2lsKjOg5pPQRqb2+RlkMWa/dAXZzmzCjbBB6C9KWjN+YKh/UdgtjLA/1AGe2uCsI+m6TEQbLAeqeiBYzuYKY0yrMZVcRk717vZKzOVjH6nbgCj0+4+yLDd4Yk9Y5M5mU92sWDZs8i7UJJxqnuTfdLECU9eqbl5JTgBdoKgJ9FOZNyR6LpuUngOZppivgstDfVy4GG1XA+TTsT5mvqco9hYi9gKg2z5/exQrzjyFLjg93SCG04etD1mIQ8eeoEEYXH/qewdo5aRIxQ2VYub2vr2cm+jfK1v58/VW+JrhFWomXZD7Q==
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com (2603:10a6:208:2::19)
 by AM8PR06MB6993.eurprd06.prod.outlook.com (2603:10a6:20b:1d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21; Mon, 29 Nov
 2021 10:40:09 +0000
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::845d:9ff2:f8d4:779]) by AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::845d:9ff2:f8d4:779%6]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 10:40:09 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
Subject: RE: [PATCH 1/2] Docs/devicetree: add serdes-output-amplitude to
 marvell.txt
Thread-Topic: [PATCH 1/2] Docs/devicetree: add serdes-output-amplitude to
 marvell.txt
Thread-Index: AQHX4txSwM81RW540k+M+AG9/TKpIKwV+fwAgARa8kA=
Date:   Mon, 29 Nov 2021 10:40:09 +0000
Message-ID: <AM0PR0602MB3666EC417E29AEC402E29055F7669@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
 <YaEGfrvdS0h0RAWf@lunn.ch>
In-Reply-To: <YaEGfrvdS0h0RAWf@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2a4fede-b356-40e5-27c9-08d9b3249d6d
x-ms-traffictypediagnostic: AM8PR06MB6993:
x-microsoft-antispam-prvs: <AM8PR06MB699385F974F282FB07C4DA53F7669@AM8PR06MB6993.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UltYp44gXMULfQR1Oi51q2S3Jsm0+VmEUDv9V0S/Ph9ley3Y4YdIFBdIgRw+Jj8eN64n1ZMhRluQmVjjbb09HePphwIlGDAl7gZvDA07sLKQprCyFy9njy6+mSMG2SMskyGfkZe6s28a0z+pkjI5kqqEhn7rm8OW22Q1K0OCT3QLYAa0frQxr/6KkGMORwvrOqMFwN8SWuznKPiiS07HETfpFMPJhwDk/YQgsbx3oIa1C4F6mCm8923ONxSQjWzgzocYfpkIvzP3IGDTl6QZ/Vi9MVdxxFQOBg7hg0+OKIDRpb+JCMrnkcaClG31U5BjuakfZvs/6rO4B1+AtOBcqiD/hY57Xz4Y4g1CoUa6Tny8ievUIEXJUTXYL4AswHvMgGcCVcgdOOaItAWfLqbIqWmZD6kw3c7/w6exBmFQllbomt0QzfUxGomJcyPO6Rm6z5lfF1id0t0F2bfkiP/7hU0RFn2RTYNG7GqAXLGrsNHYKVhrsiaROPpeWDGwkmL4B79UzPb2qisjRM5mcPfu4nYIkXVbiRs4d8yAkyGaXb68DJ9K4ss1VO0Nia8l5yQ5mTDn//GF3LMWEoAlU1op4zkZp/PI2H4jjEl6VXqtRBqJtJvy7IcgCgr4rwgvMNOYhMwAx55+h8ILK7fLqQCUTVz4DDroq9iFiFxNDo4lbuVkrNtliuokbUyMpQXZPUMtzjwgZ1xP+TBtHXNgw8L2Vg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3666.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(55016003)(66946007)(7696005)(122000001)(316002)(4326008)(82960400001)(38100700002)(9686003)(33656002)(8676002)(54906003)(71200400001)(44832011)(52536014)(8936002)(6506007)(66556008)(66476007)(64756008)(66446008)(38070700005)(26005)(508600001)(5660300002)(186003)(86362001)(6916009)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?7oPNzmPFsTgK/pjBJvQMTi71hpFM3uV9IjpnqT5hv5rqaSRLKIm/Sgy62r?=
 =?iso-8859-1?Q?5/D1DPp4BLbPerlE1EfRt82Hu61KHnHKjXZCC79HQxSVxP0+AFma+0T/VV?=
 =?iso-8859-1?Q?Z5mSBBEG9+Un3I57XgiRAkqONqpqRtO0FXvx8mQYe72zfd9ZLYlmRDNsFR?=
 =?iso-8859-1?Q?ND39eXtx6MFfZX4F+Sa+Rb6BAXubMQkkZper+EAGbCDrUDfbWD7/exPjzx?=
 =?iso-8859-1?Q?evCB5do2WPeoDaWQSEA3kNXO7F/vu0t2EB3N3H7kXWQmzSilO1iPXxaY/u?=
 =?iso-8859-1?Q?r8r3GtGvms0MdrNMqwVGl2W9tY0nlxy50aZISyuCht1VbXQaO/r4bPNk9G?=
 =?iso-8859-1?Q?Mr5UKeXniQ0zlUwkQhdy7yRVmTMqqZM14gB6LJuVQjAI+iA3JEjy6gra13?=
 =?iso-8859-1?Q?kDNl+L/JC5vkD0SyqzrFMcCnSSi6fbdz8o3IBzdch4GyRhaoO4rvXwvieG?=
 =?iso-8859-1?Q?nDNKJthRZw+D8/JwBb+mgsJL6+TpU5NzKS/tQeb64ttbFr329an2iZguhg?=
 =?iso-8859-1?Q?LKj5F7lbPv2K1yBHsS+/SAjF8OghJ1T2MrJqombnftAu+eVmAQU1cGYHCi?=
 =?iso-8859-1?Q?wtAEcJGlaza0U7RjPuDQbuKqMyxFx9cZ5ewXsmVdG0xpH7+pbDEV61Aw3V?=
 =?iso-8859-1?Q?QVGw/h7nZUKejn7L42QkY9RLBKdzvnr85D+gwv8oncrJNuzmydR6IWC4cJ?=
 =?iso-8859-1?Q?i+Q8KLrOHnwEMnizvU7/azoFXg0JtxOs3zFNgMRe7qZSHWUdC1YVH5nB8i?=
 =?iso-8859-1?Q?QVBbyLCrgkQYf1UjT5rDo1rG3kzKF8y+CJ6uP2ZTdWsT2qJ0UYtdxsLasQ?=
 =?iso-8859-1?Q?ev34yZNfP43LU2+0ya+74Q5oKm9vTaHnwYzdCBHo+1HTnJgcaomLpQv9X+?=
 =?iso-8859-1?Q?9igdusEZ4b0y2Zloa2nVMwGu7hWJ8i5vZsBZvBZibmRAEQUrGO3vUl8sar?=
 =?iso-8859-1?Q?4YDNotWbP/NvtPAa3N5JeL5M/mo5hjZEq/JfWxQQBPOxUrYp9poE5xFy+3?=
 =?iso-8859-1?Q?56KdMaf+//upL0jwmvbZwi7NtoygAj+ayd2/nkSE8KjZ6KfGQtqkPXPMRL?=
 =?iso-8859-1?Q?MklGTwMyYGa5MaPEmO+A7LuU98aAC8ywkdGNAaR4ApHf5fEtX8tum7b9js?=
 =?iso-8859-1?Q?nHjy94I9tbLw0QxVAZdJB1TCRTjCYE3oTFVz/7+o6TOizRK97DYDGegcR2?=
 =?iso-8859-1?Q?qlz41CdC6RitRyhCKhM8mJ285bl5mhyLhpgo7FDo6gHfbigHf6vbNXg62m?=
 =?iso-8859-1?Q?bOdbKJhxgAREVlA8Cs9iJi0920kL+mQ0sJifrfQU6NYurvmfYa+p+5l53u?=
 =?iso-8859-1?Q?xR2dEJhLATMKwxmLRUHbgmAI1r3fcqpMCJk2qXacG9ngoe2heCdJJh0X6C?=
 =?iso-8859-1?Q?n68D0/9xm0fsGGOTGw+tlDrzc/i9nYuRyAcBHoE12xu8fmQPGa+QuUmsEJ?=
 =?iso-8859-1?Q?Q7ita4CKDCdqvCrCYgj2Vc/CO/5Wh3g7eeZUxDrdHpCuuMzWxmZRjRvrEh?=
 =?iso-8859-1?Q?1b7+SDbiPwSbZg9O42+FdMQ3plBalW6nkbeTT8rlH/D4MAy1cDkcJbF9Ii?=
 =?iso-8859-1?Q?d2RSwu9AG5dzFQlzziJ2rBO8FKKsLL15H/8LVWbdcllVLMurZ9cTMuUlf2?=
 =?iso-8859-1?Q?jjjcgUO32XmUXC9++VfIWl8kQs1V2C8BFB5vxzNV+ljq562FUh4ORZLDT3?=
 =?iso-8859-1?Q?04+wxGaSxY0qf2rwTYKDas5ayL9nJn1Pzplxnzt8sX0t2MuoyKML0OfvFy?=
 =?iso-8859-1?Q?MaNA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0602MB3666.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a4fede-b356-40e5-27c9-08d9b3249d6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 10:40:09.0567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hOHExkg4LE3fdziemX9QOSSbC56Di69XbJT7YAH/T42Ey6fKjT2xLN7i0ivIicHWPox5RvJajvuTYsL1a2COLgVmzluA8T4d6XTMBP8ODz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR06MB6993
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, Nov 26, 2021 at 04:42:48PM +0100, Holger Brunck wrote:
> > This can be configured from the device tree. Add this property to the
> > documentation accordingly.
> > The eight different values added in the dt-bindings file correspond to
> > the values we can configure on 88E6352, 88E6240 and 88E6176 switches
> > according to the datasheet.
> >
> > CC: Andrew Lunn <andrew@lunn.ch>
> > CC: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com>
> > ---
> >  .../devicetree/bindings/net/dsa/marvell.txt    |  3 +++
> >  include/dt-bindings/net/mv-88e6xxx.h           | 18 ++++++++++++++++++
> >  2 files changed, 21 insertions(+)
> >  create mode 100644 include/dt-bindings/net/mv-88e6xxx.h
> >
> > diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt
> > b/Documentation/devicetree/bindings/net/dsa/marvell.txt
> > index 2363b412410c..bff397a2dc49 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
> > @@ -46,6 +46,9 @@ Optional properties:
> >  - mdio?              : Container of PHYs and devices on the external M=
DIO
> >                         bus. The node must contains a compatible string=
 of
> >                         "marvell,mv88e6xxx-mdio-external"
> > +- serdes-output-amplitude: Configure the output amplitude of the serde=
s
> > +                        interface.
> > +    serdes-output-amplitude =3D <MV88E6352_SERDES_OUT_AMP_210MV>;
>=20
> Please make this actually millivolts, not an enum. Have the property call=
ed
> serdes-output-amplitude-mv. The driver should convert from a mv value to
> whatever value you need to write to the register, or return -EINVAL.
>=20

ok I will change that.

Best regards
Holger

