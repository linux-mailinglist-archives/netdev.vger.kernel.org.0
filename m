Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F9F4685C3
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 15:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbhLDOuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 09:50:16 -0500
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:47618
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232056AbhLDOuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 09:50:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlHUJtDprDVgaRWmHqQnGJHuVCD274nxXO6TVae2s3ry4Gxma1NtTY1Wj7N8diI8rHmxpLXGMT5k2ioFMpLimF6tv4x3z8ZS/FzCdt9+1hfeRDizwfcPqfzn99hHIIb+m6mb3+UraHwo7A3z+mXv3j6Lx+wVCVTHXIVPSRdFzi1Inf/5n+AxTQS0FUi2KbuTTfRKDfbXgLex9ELE6tSrIEesBJrBqZx+6g/HQ6UzyruvzLaQPScPmtmtm3Cuho+Gw72EhxiiERGDINWmYls6b/mhNSTt9e4X1JB156Htt82fuTelWoHefhzyoXZAeyscu+AlZpO5PATo5hetLHe3Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t3iCtDAELpRvhbdECVU7y2YEAYBGlup27Fbxj9reSGw=;
 b=nj0TivtfFatR3c16PdcfgZ9/fG5h+KocpI/cz2W+Oxr5dTofPWyhaHjMw7+7lIIV4+tflWlRx/cDWK8meLv0AMsmiV6nYDFaTUWQsbYD1XOLMj29NbWpG8euxRbD6oJD5zALysYP6RdKTsWzHsKLlWG5nkm5xAVjx0lP/1dS4OZHu1b8UTzZq4jRooJjh7dGuYjjWy/4IExzgwQa4c8Ph5+92s4qQ+U7Apb6+hJpi4xcRvBKKB9o20bc+6sisK1Cb3A4unXOzK2v/CSRGCVaduKzQ3ZLYGU4ChtCYEcctpaNaYzgkKUxef3EDTcuHNF5PDFQUniN1eu4224cr6k/wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3iCtDAELpRvhbdECVU7y2YEAYBGlup27Fbxj9reSGw=;
 b=CreIH179xI2U6he/0BOZM/CkPPzhRnoacqEuuVb6gLZPh8xNETM0LQgP23AqQ+OsMsK3ReY7+TEE2idF2qdt5NbzbfezuETcIP7oo7LnCXQEho4+v8ZLmICgZx4Rt3MNRWPrdUN/gcFLZME+xll1m0qHGAoM2b9ibs4LhQXxqB8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3197.eurprd04.prod.outlook.com (2603:10a6:802:b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 4 Dec
 2021 14:46:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 14:46:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.15 65/68] net: mscc: ocelot: create a function
 that replaces an existing VCAP filter
Thread-Topic: [PATCH AUTOSEL 5.15 65/68] net: mscc: ocelot: create a function
 that replaces an existing VCAP filter
Thread-Index: AQHX5fmW9Dfcuyisnkyc81Pq9Pldoqwib5IA
Date:   Sat, 4 Dec 2021 14:46:47 +0000
Message-ID: <20211204144646.jmuoxrfmxyn6jknm@skbuf>
References: <20211130144707.944580-1-sashal@kernel.org>
 <20211130144707.944580-65-sashal@kernel.org>
In-Reply-To: <20211130144707.944580-65-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee40caa3-36cf-4524-ec50-08d9b734e623
x-ms-traffictypediagnostic: VI1PR04MB3197:
x-microsoft-antispam-prvs: <VI1PR04MB31970D52673BC4028A12914FE06B9@VI1PR04MB3197.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HYt5lnM4UsIM04/slD72bsLKhc+b089EKWGs6vaKR/qiSJDS/cQJUpoyYnXvkkTYcYTvRxJK/uT4VkKVe9UEiPCPHOuSlPkfSavKEw91IvCaGqCbOOjugzzijnRWsJDqwXKyFGMpcyiJvhJ+ObAW/yBjQBYkno2tm6xUnz7oT/KBh7MMox5/TnYjrx82L0gMfNdwamqnrW/p0w6dkWONGCjVBF3Y/fU7Ndhwp/AQ9i5ydzyLW/jKQ958bWIlEJOGrekCFkk3HIxULQ/xoKq+eU3/HOJ7AOmthIUPHJOOzD8h6+SCZ1Rl9e1AjCS4VZZ/eS2VtgnrHmHonNQi4mv1x1qltxPArfq3RG2j3Ku1XRyOJLGKqBarSS4/LAPcyBv/+LlN7nSbfYT6nkm2T24+QT0O+Io9sBn6sHX/lyJdZuboFsJ+VngzOeB7HkQB03C5qmw6njzgtv4zQ+q2jSRj8I/Gt3tHXFHyycsiOEerok+iUV92ZYUdnMBITIX9YzCBGjU8DfQ2leq5ID5ijF81V9Ht+4ArXB0Cnfv1UaZK19mjHUhBLOLiJ1u64ytBeKHY7sdezhokrWdnFZwwn1Vt6VMd0HixuFg6K7tEbVkcXzhWBFj96Yema/kUWDcFyOvIMCW2CNscPExtycB+pEQGqCLSDEclic88WbJ4sZUOE3cW+eBWo391fnkeu+W47bKLvf2GaF6bJhoVXhaRZvVT7ZEwEn3qKaxzJoVnzHNYfXpBikPXOmlTy2tX9W53GbZeP6m2J5PlhvGxQr09tP86LSjh8n+jHT6a72erEWNd5HI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(8676002)(6486002)(33716001)(38100700002)(86362001)(508600001)(71200400001)(9686003)(6512007)(122000001)(8936002)(316002)(2906002)(83380400001)(38070700005)(4326008)(5660300002)(6506007)(54906003)(66946007)(966005)(66476007)(64756008)(66556008)(66446008)(91956017)(6916009)(76116006)(44832011)(1076003)(26005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S6peWflFSOEeaox9MgUDFceIMvspdXGgfIxMd4sa4t6KFYIb1tm8uCzBWC9t?=
 =?us-ascii?Q?JUPWtMnt4PenDRNL2BKhuvzlNLljvMRvrTZy3OU5bQci9sGDqyBjGSgwGjeB?=
 =?us-ascii?Q?XHGF8a0W/SH0KZgZI1f3i8wR+YWfGy+35bWeu5mQNK/zLWEN9A3bAuV2EK6h?=
 =?us-ascii?Q?zqRTVYCdS8ZQVBGM3mCcAGi7GPc4CUyJX7y+XT94dVGZE6W3NQqzgAKz9RM6?=
 =?us-ascii?Q?h01jM8e46D2hQiAsRlbs7qem9LScPZtJA/6J9/yD4UOV1asc8uatfxh5osZA?=
 =?us-ascii?Q?8SLWCc2Ac4boef7N0yOjXkWhLNRn/qKx9Ij8vt0SgT9D/v45/okkjx7T5oR4?=
 =?us-ascii?Q?PDiXlWdaKbhL8tlK0CUKpvP4v3GR2vcizU7mQDYgnl/7RynKIiw+tuLD/TaB?=
 =?us-ascii?Q?iZwfSxf2rwATDu1ZfeJaNoF4OuSc5fYYaPPkh80Wp5uPmxbuOTictI6kmv0j?=
 =?us-ascii?Q?enUqlO3Cg89YiHRyVkbLQYMDGZ8RpaSGsviotqjs3VX0acObeWiP9nO+eq8b?=
 =?us-ascii?Q?gTST45roqYvG0JJU1yhC5KYzyfXs6/pJhfC0AUOuSxhpDODaygWwK4WfiRuX?=
 =?us-ascii?Q?y1RVYyRSt+8ixfrJfCYEMq02kaWkjRtN2ebFAgZ233r+MWZv5FKTORFs1WbN?=
 =?us-ascii?Q?5bh1KnvdDYcoilDzKrYo/5ubrvCbmO1//cNq3wZFXlzQR2KC5cL/lkKv4cfJ?=
 =?us-ascii?Q?Wl4Yeos+I3Hb81gGvyRsDkHVK3WoFv/9NssnOfe2sesj88Mtc/c0kNGLdGLT?=
 =?us-ascii?Q?wTzV6qKQ7szsxnV22uFui+/7UQ2SwCcYe66gogGRA/1Bd/HrsOqhkCTTDrKR?=
 =?us-ascii?Q?gw5/kd48/BoR2yPB33U+X9LkpGce0IVBNK5uhmqjSduP4wajO/9dq82WHuae?=
 =?us-ascii?Q?1ZwVLNGzyIyIYqrkEiFQWZxtqCJujxm5MkreoIdOs4vIXKYF6EYjgHmNcbhf?=
 =?us-ascii?Q?po2Rgi8sf/z1moqvVQAhG5t/qHZMnDMPGWkoald6ukEJBkPPtW1HZsnXI3bu?=
 =?us-ascii?Q?duexKe6x+TNfU/GHrsAEVCNejY9rWX1/wsq7lYK0KuODoEOnN/ShDkj5fSO4?=
 =?us-ascii?Q?mE4IdlR9+sQobwQpiZItViBgLfR40uOwfITUNaDlAmI8ptG6K1QBKYS4DDJH?=
 =?us-ascii?Q?k96arTVvuMWGxPK8yC6NoT47gw8xJm+/su0Uai5//qRLgn9Lz1KXv79oQXAC?=
 =?us-ascii?Q?FVhJxe538hh1cCoJ7ZK7wvMTYDKqequ+/rwnTzW43quTZcOVuuvw/84nWe0D?=
 =?us-ascii?Q?TFRv0hYCD+aP4O0iCIoNu8FMH8Z/2MXPgWrJ1+FWoTsc8a17+Aj4arix1zd5?=
 =?us-ascii?Q?m2KpWQvvLVzAEa5aXVUYeeqzp1To8Uc7dl00ZWZy8b9TJGJ9rGL2DzarcajK?=
 =?us-ascii?Q?OP3s7hxaiK+2EfV6WETMRQH1zXI1U8ldSJQIHsaKJf3WIlcCnjFY0WS9JjeV?=
 =?us-ascii?Q?MN7Wp30KPgRbqS/czT+uHRQPK/8tpu11mTTvklHtSAGhGMT5ncfiHYad1YxE?=
 =?us-ascii?Q?oEdzBybMqO3o4o49ZQl4aYFrXWQx6FaIpA9m/IQ34ZozKJVKgShYLuO0SyUn?=
 =?us-ascii?Q?jwP8L+wypaveyKA6goZ52WvDPeT975xciSvupUFK1ZHOwcH7AnwdPBbMayJU?=
 =?us-ascii?Q?hxcmoDjrN4iFkNeg/vsjFds=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11C22F293524D9428C6A2A65A3770256@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee40caa3-36cf-4524-ec50-08d9b734e623
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 14:46:47.6463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NbMMVgVsrpMgtwD2TuWMcQrGocHSI3OfI4XBMYbbtE2LVbVmBTMa1hf1+xaVno4K/UM//+BEPDRw0InMpha/bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3197
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Tue, Nov 30, 2021 at 09:47:01AM -0500, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [ Upstream commit 95706be13b9f755d93b5b82bdc782af439f1ec22 ]
>=20
> VCAP (Versatile Content Aware Processor) is the TCAM-based engine behind
> tc flower offload on ocelot, among other things. The ingress port mask
> on which VCAP rules match is present as a bit field in the actual key of
> the rule. This means that it is possible for a rule to be shared among
> multiple source ports. When the rule is added one by one on each desired
> port, that the ingress port mask of the key must be edited and rewritten
> to hardware.
>=20
> But the API in ocelot_vcap.c does not allow for this. For one thing,
> ocelot_vcap_filter_add() and ocelot_vcap_filter_del() are not symmetric,
> because ocelot_vcap_filter_add() works with a preallocated and
> prepopulated filter and programs it to hardware, and
> ocelot_vcap_filter_del() does both the job of removing the specified
> filter from hardware, as well as kfreeing it. That is to say, the only
> option of editing a filter in place, which is to delete it, modify the
> structure and add it back, does not work because it results in
> use-after-free.
>=20
> This patch introduces ocelot_vcap_filter_replace, which trivially
> reprograms a VCAP entry to hardware, at the exact same index at which it
> existed before, without modifying any list or allocating any memory.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

It looks like something happened and the essence of this series, aka
this patch:
https://patchwork.kernel.org/project/netdevbpf/patch/20211126172845.3149260=
-5-vladimir.oltean@nxp.com/
did not or could not be backported.

In this case I am afraid that all the patches below are useless and can
be dropped:

[PATCH AUTOSEL 4.4 8/9] net: ptp: add a definition for the UDP port for IEE=
E 1588 general messages
[PATCH AUTOSEL 4.9 11/12] net: ptp: add a definition for the UDP port for I=
EEE 1588 general messages
[PATCH AUTOSEL 4.14 13/14] net: ptp: add a definition for the UDP port for =
IEEE 1588 general messages
[PATCH AUTOSEL 4.19 16/17] net: ptp: add a definition for the UDP port for =
IEEE 1588 general messages
[PATCH AUTOSEL 5.4 24/25] net: ptp: add a definition for the UDP port for I=
EEE 1588 general messages
[PATCH AUTOSEL 5.10 42/43] net: ptp: add a definition for the UDP port for =
IEEE 1588 general messages
[PATCH AUTOSEL 5.15 66/68] net: ptp: add a definition for the UDP port for =
IEEE 1588 general messages
[PATCH AUTOSEL 5.15 65/68] net: mscc: ocelot: create a function that replac=
es an existing VCAP filter

Thanks.=
