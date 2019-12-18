Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A2B124B52
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 16:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfLRPPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 10:15:17 -0500
Received: from mail-eopbgr1400111.outbound.protection.outlook.com ([40.107.140.111]:2975
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726980AbfLRPPQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 10:15:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C5yFUmV7c4AllxY+9Uw/tkKSVsaiQSqJoCOfo9Z4jZZX6iSiQ+AMDM/50epvr/QrMQUdezwduzQopP6JlqffeEOnDxvAFgM0gu4iaGiUc0ruRC3ld+JKSIkAYhW6JrGra2r5JCo0quiu+4Fxq8pgA2YUvPepf1VwJB3wwROa00ZtLTrDrSl6qtpuB5ZHediIj/lzHF4Szk5CvQyNJiS+A5k4umJ1/B429sMVTb7akOEchF7FKC5ta1RP/oebbMlN/WPrPaD5yqTubl3T/rqmOzuWRm3HJJ//6wYN5YgCz2yhD/YmiHxSi+AAIghS9m1g3W4bdL+dscR7rxzZqTYLJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ao4I1Vy0WMgwCvmDeFUNmYHozM75FTFX35O1C9a4eF0=;
 b=OC15qC+VPUmuBJ3MOUq/tkjMIQMvLmmiJ31EDxUG7Kk9mU3xdJI7pXsoFaVxwAEyDPbJVa4FYAVM4atoP0DHXfOF0bAOkBNwR6HPpDdfXHHPA3d8LdDkZLx4urZQKNw8v3TuuYG3yXRS7HuBiLuUpGNVf1r0L+525dHjXkXaBlTB0/YI6XKk5uNTo8bSkQ320HzDaZqEaeeEl7cU6FPaffqqEb1KWSbt8Fyde96T5HjF5697nWxs1QePU4FhgYFi0Ykp8sTCpB8/606qAwodJvnf1Rjd+9Xv7lXKtpjqsFFfcd4ccrLsW0E0H9R4USp+J5xj0PpLf3xVjXDwi+0Xog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ao4I1Vy0WMgwCvmDeFUNmYHozM75FTFX35O1C9a4eF0=;
 b=C1cU8TCKwQEVSK7T89yFz3zHnJPHD+Zti+rX5TChCjX+rYc4fc8LQ+jvjZUZ4KkVO9g5mXVxzJPF8sbWSMdISG0LXtUQt89nlNxZ50f/a2kbYBGt+uQbv1m7lHxT7ysYvxSENon8fjR08xK4ieD4LzLE2N5laFfVRq3CKWoTJmY=
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com (52.133.163.13) by
 TY1PR01MB1753.jpnprd01.prod.outlook.com (52.133.160.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 15:15:12 +0000
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::5166:5e51:90f5:3ee1]) by TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::5166:5e51:90f5:3ee1%7]) with mapi id 15.20.2559.012; Wed, 18 Dec 2019
 15:15:12 +0000
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh@kernel.org>,
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
Subject: RE: [PATCH net-next v2 1/3] dt-bindings: can: rcar_can: Add r8a774b1
 support
Thread-Topic: [PATCH net-next v2 1/3] dt-bindings: can: rcar_can: Add r8a774b1
 support
Thread-Index: AQHVf3asq0vI/T9FDU6adsa1qbGfO6dadlUAgGX2QUA=
Date:   Wed, 18 Dec 2019 15:15:12 +0000
Message-ID: <TY1PR01MB17708F6646BD736C52A22BFCC0530@TY1PR01MB1770.jpnprd01.prod.outlook.com>
References: <1570717560-7431-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1570717560-7431-2-git-send-email-fabrizio.castro@bp.renesas.com>
 <20191014181016.GA1927@bogus>
In-Reply-To: <20191014181016.GA1927@bogus>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fabrizio.castro@bp.renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bdad0aa8-d633-4aa4-bd1f-08d783cd1439
x-ms-traffictypediagnostic: TY1PR01MB1753:|TY1PR01MB1753:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TY1PR01MB17533B2E222C9CBA4423966DC0530@TY1PR01MB1753.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:494;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(199004)(189003)(86362001)(81156014)(44832011)(186003)(71200400001)(76116006)(81166006)(66946007)(8676002)(66446008)(64756008)(66556008)(66476007)(9686003)(8936002)(55016002)(2906002)(4326008)(33656002)(53546011)(7416002)(7696005)(6506007)(4744005)(54906003)(316002)(26005)(52536014)(478600001)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:TY1PR01MB1753;H:TY1PR01MB1770.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E56h1cKzAOorJEsiyfVGlHadFza/qcvU9/MrDlKKAVPYgm5RpT1cWsxiBBivzQZJXNZ4hdCF5y6qLZuzGUYPIba9tQtyOek0Fy6rJKbF2qnN3tZMuu40DmQgk6OTGdknEErEDZTy+ub0Lm+5AU1SDmQueSejUVhw3ek/UD2PYTIHsBDNm1HSHfXn51lWPdmcwyvx/voGbAUhSXFb5XYUszmBLC513Scw2jD/IvX8+zt+EDORhSeetYiC2N1m7Tz8Ts5dawNNdZo1ypoonPMkZGWQyV7YgeVem9XzdLgTMHyA/QG2fVckA7Xb4nzA9udoDEih6kA16SHgB0SajuVGL3UvhrqZpNUZZj/246rhwX0FBRXz9s1iPJFi0OCuQbsY7y786EXHSO2aKXDznKtHdfYDnoyQhi79in0xosNA2o5phgEZOiPTF14c4E6vWtka
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdad0aa8-d633-4aa4-bd1f-08d783cd1439
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 15:15:12.5348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KS0aSXdaIr7OTn8EPMZlknI/hhfkKqIBmdbfz6rzlgeBYi0t8LtmhRI6RPDcdUGa8Ftb7lM9vM374G+TfU8e3ry3Zz3bMpxzSHNhu4gaIdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PR01MB1753
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Do you think you can take this patch?

Thanks,
Fab

> From: Rob Herring <robh@kernel.org>
> Sent: 14 October 2019 19:10
> Subject: Re: [PATCH net-next v2 1/3] dt-bindings: can: rcar_can: Add r8a7=
74b1 support
>=20
> On Thu, 10 Oct 2019 15:25:58 +0100, Fabrizio Castro wrote:
> > Document RZ/G2N (r8a774b1) SoC specific bindings.
> >
> > Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> > v1->v2:
> > * No change
> >
> >  Documentation/devicetree/bindings/net/can/rcar_can.txt | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
>=20
> Acked-by: Rob Herring <robh@kernel.org>
