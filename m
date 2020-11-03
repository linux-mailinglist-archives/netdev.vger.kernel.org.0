Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968EE2A4C8C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgKCRSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:18:30 -0500
Received: from mail-eopbgr00066.outbound.protection.outlook.com ([40.107.0.66]:44311
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727971AbgKCRS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 12:18:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSeDdLdaW3nqUiAv8E8ml+1ZBlPWtEkDaIU5GkK5k5NyTa4X8cDGKo650ApSYfbJfHQVdlUCJfegttODogGFlGffEPqsN7sz2tV7e8GHVuzcwryriCY2sQLIz3Pl6/ZJ8JX2R9Rr+xHSnf8SuJDTe9g8+oivSgj/fcFcMOPyMIcarTGrmN02yEhxRGn2yrw7TVM27OD0F0zNYjgHaRJWs/i7zr12u6VrvcFaSdh5q1qcKlqhP+phjdwymgtaa9ednpI9pOzQ+S0R2sqPpQLBInLc/KQTR7lybHWeZkQqlZL4dTetGWSKBu4WIp0OPgvBSg4X6ekVdzM3mPeN6qGhXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y0jBS0GfzX7wYf/HvsE18X41m7WRPHCVsXKroCF3WJI=;
 b=d1kctfIxGv9eJx4mxBXGnj6uGVZfkYetrXJ9LZmfFQns+mEdmhtKuPU1C4U2S3UVnvUpJ8KVUfnppGTNxVPSlXrnbRLTUs2qP3x9t8khwShNB/CwLQmcHBGFw2DVBQmxuPiIo6M+xyulKzGIaS4wRWTHzk46aSty7HO0pLmElmksl25k/u1HmqAR0uD9B+/YpinSOFKWGRd++MLLlcSMhrhZhBsmuMBtG0tFNH2yLX5SZcuOYqzjWAK8IfZpQOyAduMZ9z8w3ORWbd+ohPt4QnaG8GSLBJDWb6/At/MRuWQrd/qwn9cBf+XrqKAfV24hDqC+3hVLR+F5z9x7ssD0Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y0jBS0GfzX7wYf/HvsE18X41m7WRPHCVsXKroCF3WJI=;
 b=a8gZpfQZe0m+a3A6rOc9OyeQSbpNEKP/8zxy7+4hERCgQyzKLKwCvvGPlXLg+7I2DYN9/CG+wqq8XXtEh0/fDWK142UIlq/lyj6vzFmzJ4cpjzSxXmT2/SQ8CG66H1waXAbaZFjxb4uTblxaFfnfHoCp+WkA6j4u0Eq2r2rj8CU=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB6834.eurprd04.prod.outlook.com (2603:10a6:208:17e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 17:18:25 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 17:18:25 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: RE: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Thread-Topic: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Thread-Index: AQHWrcsPyv6BypdD30yr6oyPLeI0Tqm2nOaAgAAE5QCAAAsikA==
Date:   Tue, 3 Nov 2020 17:18:25 +0000
Message-ID: <AM0PR04MB6754C8F6D12318EF1DD0CA2B96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
        <20201029081057.8506-1-claudiu.manoil@nxp.com>
        <20201103161319.wisvmjbdqhju6vyh@skbuf>
 <20201103083050.100b2568@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201103083050.100b2568@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.27.120.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a2496a1a-52d9-41df-48af-08d8801c7942
x-ms-traffictypediagnostic: AM0PR04MB6834:
x-microsoft-antispam-prvs: <AM0PR04MB6834180D4CAD5801F5D5F1F996110@AM0PR04MB6834.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qlUdBuzQVS9z+hO/xf90Y8nZ5seQznW/Mvi8fQdKyo2MUBQCiktHSxcbDJ8BoHD0GZlfYt4MTJGjcGLFhyPb0j71oXB6OrQ/SBUe1P4MalyoQgMJhohDVN8Y1R970CsbTp459BQ6EOvvlflsyeppEjX5AdM1mj4cY5r44/0cgmgHk16Npf0WRJ3EbLuG/n8PrN4shHUIzXG+4BSudhk5fFAWdbTKOlRPUlvgGUA4yuv2e8E1izGVrrWJIE2eK9c3MMcaiiHPAHqXhNqQ50OIXzWhnGdDv3aGJI1IHD2sAxbLIruOuw0jPp6LNguIyoDz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(396003)(136003)(346002)(376002)(33656002)(26005)(4326008)(71200400001)(6506007)(8936002)(2906002)(83380400001)(44832011)(186003)(8676002)(478600001)(86362001)(76116006)(66556008)(66946007)(64756008)(55016002)(110136005)(9686003)(66476007)(66446008)(7696005)(52536014)(316002)(54906003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: uSKPhLiHUjiHXEHi9l7hfsBryH4iT2l5ofYPjkFqI9JpqH3yq0P/KPs2FgtN9BLeRXY/aW+J/5wzzamHrIzGiccMX8heNVZKuU2lyz12OhutiMToTao8WhvUfn86/+uxnbea3IWhnRFRXRjEeZ/CZMLFo9/cP1YCsu4I4PUCllZ4ibIlBeGdStIUok1D7IAVBxjL03Z/MSVQ9h3W+XcnxssL1Pio8O1SoELR4z2VMD0jBW1bAVyPSSm8nU+wXBiCcJhr1ecpJvCi/ArsUrT7hRYIkfvechvLDnJxAcYTm267ZU3LPpKw/y6TPutpr58S7uZhQ2E9xBuY0h8G0OoqqR6Au+Na3Gt1KRn2gfSao6az/m5h1ED6LhUWyvUg8qF2SHQQnEFYs+DxHQSM7kVaXGShiSBY4mqLNR1gJ7tkz7DwD9pz5oLs/UwFfnpS9za/tsydPNB/6+gPOvPDNxeYILcCLkuE7itw9vrKuGg77v5gvPbmW5zFiu45n8f1wgsgaGO0TcBAX6GLeE/9qU1t+EIQgxm2chOhCrVOb3diMsic4/a9vSL8Kd6ysAOpNtDHOLmHskAQ9V9W35ams5k+MSltrzQ0lhN8udqGSXGBvFo/vLL8SN330ByqZ46jAk4arSUxJ+fbmtK1nfZy1gq6nA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2496a1a-52d9-41df-48af-08d8801c7942
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 17:18:25.4332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pmo14NI+fDQcrd0EIo3Lyuqmr9nQfycjdMmuvqz5GkDNvDmq4iPAAoCxTCqVLRGLU/tk9qvhVLq5RF2cWQoBpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6834
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Tuesday, November 3, 2020 6:31 PM
>To: Vladimir Oltean <olteanv@gmail.com>
>Cc: Claudiu Manoil <claudiu.manoil@nxp.com>; netdev@vger.kernel.org;
>David S . Miller <davem@davemloft.net>; james.jurack@ametek.com
>Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
>skb_cow_head for PTP
>
>On Tue, 3 Nov 2020 18:13:19 +0200 Vladimir Oltean wrote:
>> [14538.046926] PC is at skb_release_data+0x6c/0x14c
>> [14538.051518] LR is at consume_skb+0x38/0xd8
>> [14538.055588] pc : [<c10e439c>]    lr : [<c10e3fac>]    psr: 200f0013
>> [14538.061817] sp : c28f1da8  ip : 00000000  fp : c265aa40
>> [14538.067010] r10: 00000000  r9 : 00000000  r8 : c2f98000
>> [14538.072204] r7 : c511d900  r6 : c3d3d900  r5 : c3d3d900  r4 : 0000000=
0
>> [14538.078693] r3 : 000000d3  r2 : 00000001  r1 : 00000000  r0 : 0000000=
0
>
>> [14538.263039] [<c10e439c>] (skb_release_data) from [<c10e3fac>]
>(consume_skb+0x38/0xd8)
>> [14538.270834] [<c10e3fac>] (consume_skb) from [<c0d529bc>]
>(gfar_start_xmit+0x704/0x784)
>> [14538.278714] [<c0d529bc>] (gfar_start_xmit) from [<c10fcdf8>]
>(dev_hard_start_xmit+0xfc/0x254)
>> [14538.287198] [<c10fcdf8>] (dev_hard_start_xmit) from [<c1158524>]
>(sch_direct_xmit+0x104/0x2e0)
>
>Looks like one of the error paths freeing a wonky skb.
>
>Could you decode these addresses to line numbers?

It's either the dev_kfree_skb_any from the dma mapping error path or the on=
e
from skb_cow_head()'s error path.  A confirmation would help indeed.
