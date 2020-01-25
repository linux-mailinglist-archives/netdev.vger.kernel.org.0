Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DE61493F5
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 09:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgAYIFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 03:05:17 -0500
Received: from mail-eopbgr60093.outbound.protection.outlook.com ([40.107.6.93]:13824
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726303AbgAYIFR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 03:05:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqB5lVwx+mofrnhxdOY8ujlIwSPcdKc+p2GN2KGX0zrJjNYSdCVzeGdTdIHh9P9TEKNva3YXM9BjLYKcWW6RYCBDogdpJOkOvlZWmiQW4oqX+ttRqMQMeyxZbs9ehoT/zCQSbhM54MYwWZStbAvVA7n7QKPK3wkEGrhUo6zhignpe83JHHvKp6e16+opoKf5S4jmG7M0DVy9ns+h2vehJS9oBMF9eU0qdoH1WeqSBmk3UKo50QI4SaI26luOIkU/3zAi9RMjGbsuQlSPB5axgXvCdDyA1wFbdeQd0fuaDhNjx7nJwh2rdrTDfEzaKYfZkdIgVtSF3+fpXXKdXdXa1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Wb1dEh/NeD7XtcOgs8yi9HWC/4w4AXhrwpiyPVXtu0=;
 b=RGy+qi48igZEcisWEIEUkrmrSzI/RKo4Zm7+kUCtE1rHEv9LC5IjGOlbzNHo9iMjfdpxEGYDDw9t8vhF4FYxqrwv7DR+KRre1auQd9fhMm3JrnuTrYtlWWttsZgxCSIlyyZQnhjmQZdssDx88Bm5V3J95TFvKWF/+P+UcjSdqy5mc0motmeMwizUQiWyHBc7r8hOmxDSL8oRHBjH/eot3W2kC4tOWWPzOT1uqtTAt1hykquPVuiPrtLm2ZKBxvQAS05rDUFUVUn6oKwISzkj0KAjMzfYRAZxlxFJn/b+kQIEBukeo/b3Eyn+1dR1n8F4cwqlb5gTdkvtvDUD+lCBSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Wb1dEh/NeD7XtcOgs8yi9HWC/4w4AXhrwpiyPVXtu0=;
 b=idA3eEM1qOdX04BXbBddkDTAUHj4SoCglPcEowAJ2i2oTpKxBwVGoCzF7GLn4zX9O4XE34pdUzPenmVG7XKxKEZUjt9bC+CtwaNKeqwwxUGEulTV7RF9G7Gxg1GlsiFtWcCdJEduGv/x4cbRzIgBdLCVxheF1YYGrEnowJ57m/4=
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19) by
 AM0PR05MB5684.eurprd05.prod.outlook.com (20.178.115.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 08:05:13 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7%6]) with mapi id 15.20.2665.017; Sat, 25 Jan 2020
 08:05:13 +0000
Received: from SvensMacBookAir.sven.lan (78.43.2.70) by FR2P281CA0001.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 08:05:12 +0000
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH v4] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Topic: [PATCH v4] mvneta driver disallow XDP program on hardware buffer
 management
Thread-Index: AQHV0oebTsKeFqWhwESpvZKN+FWHo6f6HDeAgADrDIA=
Date:   Sat, 25 Jan 2020 08:05:13 +0000
Message-ID: <20200125080509.x5onhuib3xoxuubo@SvensMacBookAir.sven.lan>
References: <20200124072628.75245-1-sven.auhagen@voleatech.de>
 <c5bc8e1c-dc0f-6c59-a36e-1b8c5e2d43e9@gmail.com>
In-Reply-To: <c5bc8e1c-dc0f-6c59-a36e-1b8c5e2d43e9@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FR2P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::11) To AM0PR05MB5156.eurprd05.prod.outlook.com
 (2603:10a6:208:f7::19)
x-originating-ip: [78.43.2.70]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sven.auhagen@voleatech.de; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8869fc60-f8ff-4dc5-2460-08d7a16d4e0f
x-ms-traffictypediagnostic: AM0PR05MB5684:|AM0PR05MB5684:
x-microsoft-antispam-prvs: <AM0PR05MB568499421165FE6455CF26BBEF090@AM0PR05MB5684.eurprd05.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(39830400003)(346002)(366004)(376002)(189003)(199004)(316002)(1076003)(54906003)(86362001)(107886003)(6862004)(4326008)(2906002)(9686003)(55016002)(508600001)(8936002)(186003)(956004)(81156014)(26005)(8676002)(81166006)(44832011)(16526019)(7696005)(66556008)(64756008)(66476007)(6506007)(53546011)(52116002)(66946007)(71200400001)(66446008)(5660300002)(309714004);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR05MB5684;H:AM0PR05MB5156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: voleatech.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LLqjdd7Q0RdezZC1cFDc6Vg2fhCPyyhRaiIfRmvZ9dWdA+vyBdWURHWVYrBxKKOlD4BPWnTif4BRbJR6L4gpIsIOJWOFb8e9brlQCXV3324mSuei6DfpjyZPAcUZCy9pcR/fI7V29MiaJkNJUMSXZexe9BhUFeq0gZQoH+kXCZVII2wXC4/ehyOLqz9JIKkPYrJvI/08qAzUlTo8XVimgHPdeXXZfFxqEq9cT4/Ugd2BwWqwO9Z/0PPl3pXPqhWd5o5Q84Ao2s5zh4hUCKjEf/fYXzFOeOgHyg5eJjAELXgt85yLJlO0W61N+bY5lqFb76W6kUoiE7KVSL1kE2Xgd7Rd2gg3MpmrJmBD7RV+aTWzfSzny5q6kda1WNYtIrEE6hrNGnoR7jXJ0TyVQZ/nkueLOnz8bl8Q1rXbkMUyoTGv0j3BDgArzq7bq1wSfE8trl93bz4tZtVqdVaBruOzPkZKyzI78o3HCTYfb+kdT6EwhLyEiAW+LHbuuVazUXV+
x-ms-exchange-antispam-messagedata: kvf8y7Lv1r05dE3n133vhfrLOxikxStw+VQTcwZvnQvCfb35MWKhk6MN+cflEsUKCBlUD72FkFB7qHuYB+Pjgnb7Z0uMZnPNDOO0BCAXapKtPtO0Z+Wcn1NNUcnj08vQJraWM3kQBKwPnzW49Gv7qw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31F80ADB724F674291DC51FCBF082A8B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 8869fc60-f8ff-4dc5-2460-08d7a16d4e0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 08:05:13.2365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sZmMfr5hgMHgF/Ugs+Rsgja8epsemOjsGpUIQb2ao5dw2o7+MZshHCoBmHN6Qp662FtoR1Oj52cXEJ6WwopU7yE0nq2QsXSJkaMEvxSpBTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5684
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 10:03:53AM -0800, Florian Fainelli wrote:
> On 1/23/20 11:26 PM, Sven Auhagen wrote:
> > Recently XDP Support was added to the mvneta driver
> > for software buffer management only.
> > It is still possible to attach an XDP program if
> > hardware buffer management is used.
> > It is not doing anything at that point.
> >=20
> > The patch disallows attaching XDP programs to mvneta
> > if hardware buffer management is used.
> >=20
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index 71a872d46bc4..96593b9fbd9b 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -4225,6 +4225,12 @@ static int mvneta_xdp_setup(struct net_device *d=
ev, struct bpf_prog *prog,
> >  		return -EOPNOTSUPP;
> >  	}
> > =20
> > +		if (pp->bm_priv) {
> > +			NL_SET_ERR_MSG_MOD(extack,
> > +					   "Hardware Buffer Management not supported on XDP");
> > +			return -EOPNOTSUPP;
> > +		}
>=20
> Your indentation is still a bit off here, looks like you have one too
> many tabs. This is what we would expect:

Ah sorry I missed it.
I will resubmit with the corrected tab size.

Best
Sven

>=20
> 	if (pp->bm_priv) {
> 	}
>=20
> > +
> >  	need_update =3D !!pp->xdp_prog !=3D !!prog;
> >  	if (running && need_update)
> >  		mvneta_stop(dev);
> >=20
>=20
>=20
> --=20
> Florian
