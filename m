Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B29912F6CC
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 11:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgACKjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 05:39:20 -0500
Received: from mail-dm6nam12on2062.outbound.protection.outlook.com ([40.107.243.62]:64225
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727350AbgACKjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 05:39:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vo+1S9Lh99AJH9eP2Z0/vQ3DbkKpZ9NRuli0hJReuxpOMJmDCuf0PtNwDKbyEFJe142bYn5yOzRYKKU97WHYXgbX9G+hfhhepqMM6UcGvyjF5dmJuATS9ai4Yh6doGBc5xuu2+Fsg0inxnyaeP0Nl2yF5DMH5AoCLoySzcaOG8nEf9bhxiYLb/gWBvKrL6ShT2CPpYt8lYp4SD1GAP1+yvQFtJ3ioTx1aY5hjUegaBWxiBHWtdSL5Co88l6+cFM4FzM/sY5x9lqJWEmflrDBoXG5HSjL7i6dWc9s2WzgVDBquN/0/+f5c/sl7IGNmUbfuRJstBMdIzWnjFSIGj0Elg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qEWolf3bLpqauwpvas6kP0B4J1efodT+hvqLk1m58k=;
 b=h6jm7ujKqXI5sBR4e64BXDmmvaHeX1jeBDzTv45MBdc7LKS/lTmAu8TLDPiNTDPQEtXLY13hfDGEvA7T/jbiHaAkFZInkiOVXRuHt+Lm8pVbPdWXrD7SBFCahhEa0NmgnjRKAuJWY5E0zohHZ2s3cwVDyTfg91mlkuxkjiScDnxmMKow+6P9QG1w+QvOTKB34PFtJ/yo3cxG+2AYw6SjMv32+rkWFC1CoNSu9p7wmkWHPc8/4cXhTu9Kbr9U5RaeTrXpZC7NWCRS9KsEKmnvhFP4yMO6KRj5Ympu0zyjAF1wdigPZoEIvafSAvByqyKv81rh/aiYkvo0IONU7dNLNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qEWolf3bLpqauwpvas6kP0B4J1efodT+hvqLk1m58k=;
 b=XpPwYDWgIAfQ6jUcP2vGRqWNQRjxxcqLSCdsVdModZcK/igmm3Prn8Tgzb2qyHnGfd4xDPsUcIWLwNwmEOHDCeHa3aF2odFZCfhnSqoFQlnQsyv6U/+oYgSYyxmK7hggLdHYH8IDy7SuG22+km3Q4X4+sq0aOCDW0UZBvTCrZiM=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3838.namprd11.prod.outlook.com (20.178.252.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Fri, 3 Jan 2020 10:39:16 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2602.012; Fri, 3 Jan 2020
 10:39:16 +0000
From:   =?iso-8859-1?Q?J=E9r=F4me_Pouiller?= <Jerome.Pouiller@silabs.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 13/55] staging: wfx: avoid double warning when no more tx
 policy are available
Thread-Topic: [PATCH 13/55] staging: wfx: avoid double warning when no more tx
 policy are available
Thread-Index: AQHVtDLD8xTkZNX3aEu0AqQlv1La16fYxecAgAAVyYA=
Date:   Fri, 3 Jan 2020 10:39:16 +0000
Message-ID: <2726644.RsKqsKUrSp@pc-42>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
 <20191216170302.29543-14-Jerome.Pouiller@silabs.com>
 <20200103092116.GB3911@kadam>
In-Reply-To: <20200103092116.GB3911@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8b3bc84-07fe-400c-78ba-08d790392e87
x-ms-traffictypediagnostic: MN2PR11MB3838:
x-microsoft-antispam-prvs: <MN2PR11MB38387CC6E175EC692841599493230@MN2PR11MB3838.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 0271483E06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(396003)(346002)(136003)(376002)(39850400004)(199004)(189003)(33716001)(66476007)(6916009)(66446008)(186003)(64756008)(8676002)(478600001)(66556008)(8936002)(54906003)(81166006)(6486002)(71200400001)(6506007)(9686003)(2906002)(6512007)(91956017)(66946007)(76116006)(4326008)(26005)(66574012)(86362001)(81156014)(316002)(5660300002)(29513003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3838;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fr4s130kFyupY7ALfR84zkYNNTizUsgY0FH09OFvBic6NCX1Q568927//HVoFc+uzaGk8ZITabKRTlGe90XWHwGW+YgZiZG/GaMRkBSTd8qfaBAk9jSnbst5wfwgYT9tPxvssiEvf4OWVfVwFqp5zAGgxY+fijtpRl25P6nN5TtvZajMsjQoToZ23SkfZnL0y3Kgx8fv9KdfpRYGKIwmmicf0vcxyp7ZVfvPzOVWAq743Cdka4BnlIPDMMFfBDgPwwvO2cKBVb3Jg9ywjuvh7/dPgH1qcp31XAbUABn1X2QHWHJ+GJCy7qE5gcajiW3eFpdczDq4xngtyVuCHAujxH8Qv7KhrBLdND4Nwl2+UcBZYRcfRnfGwROVOZl2NdUtvMXTyUPH+Dc6EQKmIx/YI9bxiEt2RaCmOfoqRSNaumQeOPQR6S5ATltkk+zDW8VjvbX8NNgvie1PJsi07oTiAf0F6mANVJ2DJGwndKegzAlbXfFUCwY6mKEL72BYIC0t
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <229EAFC715B6E54EBEBFD888D1EA8753@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8b3bc84-07fe-400c-78ba-08d790392e87
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2020 10:39:16.2621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C4j0qcksboSv+FL2P22lSB0qoFoKUjMS+w5/yDXtZXCzlGyUnUjm8/1LJqwO+mzpminoIWFbUnMBEkIPOmvFhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3838
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 3 January 2020 10:21:16 CET Dan Carpenter wrote:
> On Mon, Dec 16, 2019 at 05:03:40PM +0000, J=E9r=F4me Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Currently, number of available tx retry policies is checked two times.
> > Only one is sufficient.
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/staging/wfx/data_tx.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/wfx/data_tx.c b/drivers/staging/wfx/data_t=
x.c
> > index 32e269becd75..c9dea627661f 100644
> > --- a/drivers/staging/wfx/data_tx.c
> > +++ b/drivers/staging/wfx/data_tx.c
> > @@ -169,7 +169,8 @@ static int wfx_tx_policy_get(struct wfx_vif *wvif,
> >       wfx_tx_policy_build(wvif, &wanted, rates);
> >
> >       spin_lock_bh(&cache->lock);
> > -     if (WARN_ON(list_empty(&cache->free))) {
> > +     if (list_empty(&cache->free)) {
> > +             WARN(1, "unable to get a valid Tx policy");
> >               spin_unlock_bh(&cache->lock);
> >               return WFX_INVALID_RATE_ID;
>=20
> This warning is more clear than the original which is good, but that's
> not what the commit message says.  How does this fix a double warning?

Err... Indeed, it don't. From wfx_tx_get_rate_id():

       rate_id =3D wfx_tx_policy_get(wvif, ...);
       if (rate_id =3D=3D WFX_INVALID_RATE_ID)
               dev_warn(wvif->wdev->dev, "unable to get a valid Tx policy")=
;

I will fix that in my next PR.

--=20
J=E9r=F4me Pouiller

