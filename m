Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50647124B5D
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 16:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfLRPQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 10:16:39 -0500
Received: from mail-eopbgr1400131.outbound.protection.outlook.com ([40.107.140.131]:51664
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726980AbfLRPQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 10:16:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOUSAdIQ+Scqf/rv38S2GgODGavT2YdyMDhe6MVEUiVGqpHAHWJg0UG/O0TZRCqeb72x0+vNTb6cb/iFPd/kMSd7eoii12WGY4lniq4LXwo1IRSlEzpsq5WaBUpOcjQ64s2SPIKf+WwONdVdDPpMxGaLhX6TNYysUAYrXRvOr4Uyrxrx1Vig8oRmZA1PVF/+JxIH2LsIUotR5UbuGKQQE0XEbB81dSmeaZHNAupfbnvnlO1q1NjGvH1v3IlNkHzC7QD5mJ0WV0Dc+pTJlj328vYU+MibagSdH1sIX3xiwals4lRZIeURYikH0bcmhxB3h5h5vVvRR7rwnl4uBheHTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7FjcdGIK3UiRJfhon7B+8hQG+7+14ZYiCK8wBYSczI=;
 b=SDwiLirJ/1p4B20WFfeQmWzjVimuMdor2+NGTbvcRgIxxJP0G0FVfNUQ9G+t2xYm8lx7W5boWXl0oZO2F7BJFqRXkHSA39E+d27E2vhfPgKUj5S4CnNf59aoQMihSmiuLB8/bDg5WcHZkJONI4/Y7Mz0daf2mfpYE9jPDCIM6Weo3WUG6GnP0aTxT1OHgLsxBEPbPaZYOg23hS+K0dFrir3ZOfeaYEs2Xd/DpKc3rBqdtC1bRpn0dI6F9K1G0N8sAZySKuW9BehCfb5CJWYu+gSvGBs+MewWRn6C0wcs1G0st4m5P3lYI7H4buoPjDNmxkXANlXu3OnY5oep7sf4FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7FjcdGIK3UiRJfhon7B+8hQG+7+14ZYiCK8wBYSczI=;
 b=WH4g48sAdFRx1IcxL1rAHYIeGXG3N0ziXjuSaraMSjHZ860eiuqrfsWua/Qn7kDeFCEAI2f8EZ9AjFcTZLSBs2ovpLpWHxxfIiQuuv8Ds1+oAUF5bvs046BR9Dp28G9lyShYR7RFa+NwfrOJspbZfYjUtGMCtKus6QMrYfeBnuA=
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com (52.133.163.13) by
 TY1PR01MB1753.jpnprd01.prod.outlook.com (52.133.160.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 15:16:35 +0000
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::5166:5e51:90f5:3ee1]) by TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::5166:5e51:90f5:3ee1%7]) with mapi id 15.20.2559.012; Wed, 18 Dec 2019
 15:16:35 +0000
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Rob Herring <robh@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: RE: [PATCH net-next v2 2/3] dt-bindings: can: rcar_canfd: document
 r8a774b1 support
Thread-Topic: [PATCH net-next v2 2/3] dt-bindings: can: rcar_canfd: document
 r8a774b1 support
Thread-Index: AQHVf3atPhucSvZbD0uUdhLVXtS2T6dadmyAgGX20DA=
Date:   Wed, 18 Dec 2019 15:16:35 +0000
Message-ID: <TY1PR01MB17703B32045654CB46C2FC8BC0530@TY1PR01MB1770.jpnprd01.prod.outlook.com>
References: <1570717560-7431-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1570717560-7431-3-git-send-email-fabrizio.castro@bp.renesas.com>
 <20191014181035.GA2613@bogus>
In-Reply-To: <20191014181035.GA2613@bogus>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fabrizio.castro@bp.renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5b2fccc8-ba94-4ff1-5e3e-08d783cd4579
x-ms-traffictypediagnostic: TY1PR01MB1753:|TY1PR01MB1753:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TY1PR01MB1753D21403AD20E5A2950791C0530@TY1PR01MB1753.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(189003)(199004)(7416002)(53546011)(6506007)(7696005)(2906002)(33656002)(4326008)(316002)(478600001)(5660300002)(26005)(52536014)(4744005)(54906003)(71200400001)(76116006)(81166006)(6916009)(86362001)(81156014)(44832011)(186003)(64756008)(66556008)(66476007)(66446008)(8676002)(8936002)(55016002)(9686003)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:TY1PR01MB1753;H:TY1PR01MB1770.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nGN6cFuFTs9MkiXxwUnPJQGO2lhvNzodiqIm33HzNIcYfGkLSe8lxn5U6AuJOS9SGWEIHiN6i+PiEU4BMj3McR2krhPlVZzBqLEMfpJw8r6qfmWRBACfWswExJ9d3F1xTwZu4ZmTNEqZanjOmIsTi2imAPs97DX4wuUFEDRG0G7RMR4uDSy2/nTIueLQwRrmSw1JA4J3tnsnjxWjg/PuydAePJHXCb885/5C5XwwkxOByiuiCbfNDIahwwNYPev6yYXZgou/MgrxpJifHK7AxAm6PcEpYQ41fOCxaT5lyIS7tLeaVN6Kmct0iANdzLcuZ1nhg93/+fx4w3X1GBc0gD2ynTip4IU6YEwjtMhjliWZEwbG7ug9QHQ1pd1XJ8hmRH6zEKd+edKkwDXFUDnyEA3LiJ7GyCdIVS7KIEmsRi9jUINz3Qd1oe6gFDMpXU50
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2fccc8-ba94-4ff1-5e3e-08d783cd4579
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 15:16:35.1701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oiy8uuAfWfrb7CUpEJwsKzyZ9x1JYDfp4chQq8lSs7kfdNe6LVbqandUx9cY0z334QKdQSBkzNDeVDt7/vCtatHaKC1NdM6mNYgMCJ+yOuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PR01MB1753
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Do you think you can take this patch?

Thanks,
Fab

> From: linux-renesas-soc-owner@vger.kernel.org <linux-renesas-soc-owner@vg=
er.kernel.org> On Behalf Of Rob Herring
> Sent: 14 October 2019 19:11
> Subject: Re: [PATCH net-next v2 2/3] dt-bindings: can: rcar_canfd: docume=
nt r8a774b1 support
>=20
> On Thu, 10 Oct 2019 15:25:59 +0100, Fabrizio Castro wrote:
> > Document the support for rcar_canfd on R8A774B1 SoC devices.
> >
> > Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> > v1->v2:
> > * Added the R8A774B1 to the clock paragraph according to Geert's commen=
t
> >
> >  Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
>=20
> Acked-by: Rob Herring <robh@kernel.org>
