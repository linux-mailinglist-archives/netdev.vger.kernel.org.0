Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11BCBF93F0
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 16:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfKLPTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 10:19:04 -0500
Received: from mail-eopbgr50071.outbound.protection.outlook.com ([40.107.5.71]:17376
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727429AbfKLPTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 10:19:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XC8/4lN8rR/o65BRobQwTdnio+PRaKm2dChIUQ8Iwhe+3pGuMYtnG1e75tci6DuwWKEpf5W+Biz9wX0z1+bhfntqNhCi1G5CjbMmBmhkyKBA/BBVMnJvwZoTK2FnmSJWbIz68e+ar+WKa15wb07cLGExi4WV7yW1nYdSF8fKlQrcuYQwi75StIiSspxZDDSlBWfH0+NvhSJge4/sluhHH+GSm8d1el9a2ZYGyM1Uwhk0F7kfjg7VwT2t71iHp80eI+jswj7uc87YxUv1QgGFLmVH++NjyhASmuTSEKYGB9X1+Eo2NaPf91fBZoW+s3ywoX5rXMNk8JYRrwg2a2Q3cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ly2nIYwKaSfYx1JM7yPSvaDBiVUbOkFaSu1QGyDmzAk=;
 b=bRFm5oxP95nEPZdc9hfvOOlopGFc/J/ejDBOqjcHzIkazw70TRSt/+nZxIX9osN8l4fnVuDOWZ2W130iZIgrNkQI3m0+SJ7Z6uzEsxXlURid2vbz7FvWyZyzjh5P53kEJmkQ/V1qvbpwa2q83kjzFqGqgIbyBZ33VPz1yRoFRlSHjT5eIImpPXZV6OKXJc1YBVeb1NMGOIATP0w3jwvDiM0GFycwXJK9AGWXBCz/YApNE/Q20hwtzrtCE6zkFcK9vVdZ0j4ZYCIoLaiKpF6Gz2igso85yyCXtxCCQxtOaLcY2huHuFIGUsBf5Dec32sOZMBShKcQoqqkqdAawlSxOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ly2nIYwKaSfYx1JM7yPSvaDBiVUbOkFaSu1QGyDmzAk=;
 b=qY/+NmoheDxkqLpDYmLtSnYW+xjsKnVIkbtlCWV0TeJAkuiDxJ4SYNyTILf0JYOSoMLx1L0uQmVyZvBK6I3PZ2fnT6cqep2rKWXI+RQVgrofwQaSd9MS7AAYgdVs+IQGiKchFQnkU9bf/8XVClFgldtH6JQoFYO7XnpK7mBq+o4=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3710.eurprd04.prod.outlook.com (52.134.18.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Tue, 12 Nov 2019 15:18:59 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2430.027; Tue, 12 Nov
 2019 15:18:59 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Simon Horman <simon.horman@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v2] dpaa2-eth: free already allocated channels on
 probe defer
Thread-Topic: [PATCH net v2] dpaa2-eth: free already allocated channels on
 probe defer
Thread-Index: AQHVmWT7anYidbeJtEqirE6b4qILkqeHoCeAgAADdYA=
Date:   Tue, 12 Nov 2019 15:18:59 +0000
Message-ID: <VI1PR0402MB280082F2CFC49BAB2E4CAB23E0770@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1573568693-18642-1-git-send-email-ioana.ciornei@nxp.com>
 <20191112145714.ohlnx6pmpkqxs5qs@netronome.com>
In-Reply-To: <20191112145714.ohlnx6pmpkqxs5qs@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 07778351-d5b2-4cf6-6656-08d76783a45c
x-ms-traffictypediagnostic: VI1PR0402MB3710:
x-microsoft-antispam-prvs: <VI1PR0402MB3710C1ACB4AD71814CD7F3FDE0770@VI1PR0402MB3710.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(199004)(189003)(6246003)(66556008)(76116006)(99286004)(66446008)(4326008)(55016002)(64756008)(66946007)(66476007)(6916009)(54906003)(9686003)(6506007)(316002)(26005)(186003)(256004)(52536014)(102836004)(5660300002)(66066001)(6436002)(71200400001)(71190400001)(478600001)(6116002)(3846002)(14454004)(2906002)(25786009)(74316002)(7736002)(76176011)(305945005)(7696005)(229853002)(33656002)(8936002)(476003)(446003)(11346002)(486006)(44832011)(8676002)(81156014)(81166006)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3710;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FhhEUAoV9WO+MXtu8ggLvKMrdKgPGCRFB/l3/qKNgqKxyyQJxYbEQrhoV7MvQIS3YkTOnuqi7Pg8zJvbcTX9cPd2E2fdF28CRo9rlhKEgIrsQP3kEuScoVI20vpJj8mJgFvbZVA4I0H5K94BIqmaRD/a8t/ExiRYwycEbUcB5RuAD4BCv4h0XEE4/4ElKx+dSuvSGqdN639D0hB7iY9SEF9FjuOxdH+zJAeWNMWli1An8BEafoPo1sYRud15SXUfOvooDGZbmnC2CWUoClagw6NKAh0Mq8v29VAq2LNrTi6hvrkbpyb1/00wQ+1qYzyrb4/CtqwTyh99p74ZrIy2DH50iuXL0puUWLh0qHGVJ5g1d2T0m5rOYeXtsfpsf+gzxAB9FYGTqgVITTQGDGjKCUwTBkb0hlyxrUSMFuywrjSq1Il0bQm1fjgUdI0kgQ2m
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07778351-d5b2-4cf6-6656-08d76783a45c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 15:18:59.1210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 71pn2E5AumSPLkucT5/ggdMrI4UFPTA3ohECGCFcgDilehMMgOtt+PkaZg2D7u5mQmQ9PpJGiOQL38gfrdpaCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3710
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, Nov 12, 2019 at 04:24:53PM +0200, Ioana Ciornei wrote:
> > The setup_dpio() function tries to allocate a number of channels equal
> > to the number of CPUs online. When there are not enough DPCON objects
> > already probed, the function will return EPROBE_DEFER. When this
> > happens, the already allocated channels are not freed. This results in
> > the incapacity of properly probing the next time around.
> > Fix this by freeing the channels on the error path.
> >
> > Fixes: d7f5a9d89a55 ("dpaa2-eth: defer probe on object allocate")
>=20
> Its not clear to me that this clean-up problem was added by the defer cha=
nge.
> But rather, looking at the git logs, it seems likely to have been present=
 since the
> driver was added by:
>=20
> 6e2387e8f19e ("staging: fsl-dpaa2/eth: Add Freescale DPAA2 Ethernet drive=
r")
>=20

The problem is not present in the initial driver.
The logic before the d7f5a9d89a55 ("dpaa2-eth: defer probe on object alloca=
te") patch
was that if there are not enough channels available it will go ahead with l=
ess than the optimal
value.=20

> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> > Changes in v2:
> >  - add the proper Fixes tag
> >
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > index 19379bae0144..22e9519f65bb 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > @@ -2232,6 +2232,14 @@ static int setup_dpio(struct dpaa2_eth_priv
> > *priv)
> >  err_service_reg:
> >  	free_channel(priv, channel);
> >  err_alloc_ch:
> > +	for (i =3D 0; i < priv->num_channels; i++) {
> > +		channel =3D priv->channel[i];
> > +		nctx =3D &channel->nctx;
> > +		dpaa2_io_service_deregister(channel->dpio, nctx, dev);
> > +		free_channel(priv, channel);
> > +	}
> > +	priv->num_channels =3D 0;
> > +
> >  	if (err =3D=3D -EPROBE_DEFER)
> >  		return err;
>=20
> This function goes on to return 0 unless cpumask_empty(&priv->dpio_cpumas=
k)
> is zero. Given this is an errorr path and the clean-up above, is that cor=
rect?

You're right, cleaning up the channels should be done just on the EPROBE_DE=
FER path,
in the if statement, and not for the entire code path.=20
I'll rework this.

Thanks for pointing this out.

Ioana

>=20
> >
> > --
> > 1.9.1
> >
