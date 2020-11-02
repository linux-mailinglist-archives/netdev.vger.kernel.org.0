Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A973B2A30F3
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgKBRJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:09:13 -0500
Received: from mail-eopbgr60081.outbound.protection.outlook.com ([40.107.6.81]:57408
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726860AbgKBRJN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 12:09:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CogP1jEXbjVx0OPKfIHAfXJne2kTnU4YcIVs1gqXzP10MaBH+G/sXDPcCjI/SXwo3YcBdnOcEVjY7zetLyTMD/gi4W3AiPVWmmnR6JNygZbNb3WBdEsgDeI2n0PtuihUeSDyDBih99Ryhz27cEeJgMuoNIkjW9/vLaXswtpNm4jULi3+19i48nCKSbIJV66BG8PxijDX1R5nHKBJ1PHA/xe7tmtKM7iuQmSqUCgLVy6wn9knRpXxSpDHZTxISCxNpmbzo+CItKWpoeQZ+EMESFtoIPb9r0j32eqJfNUAFB7pfGtFHiFB9txym/iQR+Yrjmzjz6tQXNxittglADrAAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHr4qC+gM4V8k2YIlFxJWap6TUZIV0B4gWhpFdkLeAk=;
 b=bDg5aHeKJI+avqluVGIHjywsPPlzs6uxmQTh6VMYGN/HgeYrjCDXbQwf1dqc/SJvaU2A/v2kf1gJ737woRarM7Y9NQX4Fhzigv8zgSr5FZiboXUalMH93sKb49F9BAq+b5gU5UNSbSLB3bHzTAxK0GP2L+uSaG/LrKWT0p0MXYCt/7bvjPDkc2yrhltyvNgcc6nW/NWucIWlWMWZd8rlNyCV7HC9FA3okeV7nbjpebk6Y8Lt4WFwDjBsgjY0x/6glo2JiMBfGiEAzQCWdpMSxP1BvMqWurYpaBbE62Q6B2CiMH+QFYusSfRaq0sPmGv9Szo0xknsrHbAziuehz9INQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mHr4qC+gM4V8k2YIlFxJWap6TUZIV0B4gWhpFdkLeAk=;
 b=pSw3snJplt4JM5jXoMv58P7egK5BTIF6Li/+OTZ8j7iFQRUpe/J5nHlbGNXjZkJaoEIhPBs7egMGfH4bDIwqjZuHD7fdmtXiLWKhkeuCDXY45peIO2v/E0qwBXkkXlgHMse6kZ4yI1I1TT2uwcHYyvzcUl30teY09JEtQNh8PE8=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB5965.eurprd04.prod.outlook.com (2603:10a6:803:da::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Mon, 2 Nov
 2020 17:09:10 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::41c8:65df:efe8:1f51]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::41c8:65df:efe8:1f51%6]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 17:09:10 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v2 2/2] dpaa_eth: fix the RX headroom size alignment
Thread-Topic: [PATCH net v2 2/2] dpaa_eth: fix the RX headroom size alignment
Thread-Index: AQHWrUkmv1ISD2EXGEWhgHj29onOCKmw8/qAgAQnFiA=
Date:   Mon, 2 Nov 2020 17:09:09 +0000
Message-ID: <VI1PR04MB580769648827F02236580080F2100@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1603899392.git.camelia.groza@nxp.com>
        <5b077d5853123db0c8794af1ed061850b94eae37.1603899392.git.camelia.groza@nxp.com>
 <20201030184347.4a8ad004@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030184347.4a8ad004@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b96980f3-ed68-4ff1-17f8-08d87f5203c4
x-ms-traffictypediagnostic: VI1PR04MB5965:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB596599F1E2238B610BC8CD9BF2100@VI1PR04MB5965.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VbQxsK7puFvP6sGFJZp4up20jECbuO8S4k1n93F0RYK55V2/iLkrcDBbUTPZ7ifLvRurHinIZNe8nCcFj2AO5roA1BcCrncXlbw7JEn6d4XLsHq30QZGy0PamupQttKw1F5yx9YiIZNvBsiq8tWQYqP9rIvGVd49LU7eOmvf3fE42UpGWa8Kqv3jLzCCwlEoqEonAzUAWzVMnQGL8OyEvbD668rgK13HDWS88WX55bijzqyV+KsqG3KsyUYCNjoZGB10thoO/+KOB2nfAlKGym5s6nGFwK6j26lo+8ZdwMGzybKeWMqALyl/48BJ5Yz2YukKj/jjDA1ZKLI76JbO/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(39840400004)(396003)(8936002)(4744005)(86362001)(6506007)(6916009)(66946007)(66556008)(53546011)(66446008)(64756008)(66476007)(7696005)(316002)(2906002)(54906003)(186003)(52536014)(55016002)(5660300002)(83380400001)(71200400001)(4326008)(8676002)(478600001)(26005)(76116006)(9686003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Bj+oATPH1v/NIKaoWXpX3tmjXIUVo5JGzR0IVGd6wXTP+zPAC7ahJWwIlZlvasqGG9C9OJoIJc3BTN0FJZGZI1TT+6y376deWiPR8h9RRMuj5L0kYm9bCCRkyVcOJHj15atrpqeivKyR/HRICb2tyCPwhlSp5FddiwSeBsxFvCwiIDe5SKFLnX6Gu6SoocojsaX4SHUDnk6pK54iCZMR+GYM0bzo1P6Xmn8dRQqhzNMn8SmNmdBfKOa4XlwnhzoxLE3YFLUiwsPRouspluCqcdF2GZMF/4o4E0gchhjeCtoTiTN0UcW1uMfMAiR7cKFwC8OIf1fMtlqsnasvyZgK51GAgUmRhtQQ3uh9vxazgZWePmYv/8ZlWkYKxhtsC7mfR8nR81B8V1ZO1Y9uKNCH0gIRZToVuytVwyuH0VoUfYUa7D9Su+NqfbkyCv1mlG+LfFNzjx3pBloE9G8NJA9xVP7kX2LBZqTCP/1VqyV3sVB7KfB/bkq4R7ccIlmqqJ9sc3/vH81iG+h9wrMgLKBcm4vteRIvF9bvDt8a1UyNXW0i5CDNV3G2Pv6/IQQlwBRbt7FKTThUgCSJxmap42qlsXbXS3XAyOrzayC+Ca96oETCGS5AFI/LEOUGHE4cTsR7rSM6SnyQFPIM7U0EygA1/A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b96980f3-ed68-4ff1-17f8-08d87f5203c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 17:09:09.9584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mrUHXnKCCuwcknioI8gMmeezemOSQOYO/njCZPOlNJ+do9dTwLy/CZDQEYaDvy9RrGl61JsNZeuKhPcvxWnPAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5965
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, October 31, 2020 03:44
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: willemdebruijn.kernel@gmail.com; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; davem@davemloft.net;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net v2 2/2] dpaa_eth: fix the RX headroom size
> alignment
>=20
> On Wed, 28 Oct 2020 18:41:00 +0200 Camelia Groza wrote:
> > @@ -2842,7 +2842,8 @@ static int dpaa_ingress_cgr_init(struct dpaa_priv
> *priv)
> >  	return err;
> >  }
> >
> > -static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
> > +static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl,
> > +				    enum port_type port)
>=20
> Please drop the "inline" while you're touching this definition.
>=20
> The compiler will make the right inlining decision here.

Sure, I'll drop it.
