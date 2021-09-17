Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D2B410046
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 22:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbhIQUUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 16:20:37 -0400
Received: from mail-eopbgr1400101.outbound.protection.outlook.com ([40.107.140.101]:6162
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231656AbhIQUUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 16:20:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2pw75sFkwtjrRBDuZ2HSb+62sYvG8mwoY1r9PKZo5gknezDIql1wgySB7ihdrpJiEo3lPPsekdUrp11ATXapCt4TfZp32o4r4M0zJbrlI+NA5mvKcw/2SC0Qj62ITquBFdJu86Xfei8T3xQF4O9DJgGQL3PLOREEdFmapmHNs282Kdz9t6xWlNTIebmFjt8VTsauQRAxin0ZJmvD65t4HOd8thiPHYhjgYbLkn2tvvaAouFTAR9sKytXHidNRryrtBWv52WHrHyKoI0X3UqOQIqdwYT422ct/9pgJ8IwAh4NJKTxQNG/sHYELY5QiGsTP8cF9m3n/+ERFbL+D2eGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oHxiRO9bpM0rm79jgAL0KvFr+IBLs1i1ItTeBzElhTg=;
 b=fHC2hLEHeqafGf/VNaOiOB2j18RB1/zy1PWlxHoMcP66X37U6UwHZG5xjZWS7fY5DC31izs5t93ZIsSGnPEEuE0UEBLoXSknZ5fE276CRdAvNiAMhTp83x93lV+OFELRW/yZngWdTpoc/2D0LCVrMUXzY24RUpblXpOXUKVYp8arAJQ78nwdgpyOF3c8dT/ipwEiVYJ7GafJhnDhYM8xAxNAGDkeUTOFNemdLdS7JmNV7lGYLfNZAXRxVvXfydS9wH/PX8pOL58LZ11PRKPD+viKNId9vcY/dK/cOMStJp6LwRS5t/f7Ec0zmVYUByzIzc6vBATBUpB3LtQFxk0Faw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHxiRO9bpM0rm79jgAL0KvFr+IBLs1i1ItTeBzElhTg=;
 b=WZXNxVPmxnX9mvpqiGTbxXX0BTfloDsi7Nf1HB400tHpVU3yFzE9rpvSZ7tS7qpMMfo/F52eY9fBp8Lq4OBQbYxCyKwioUhfmP2A1DFS9jnob/zx+33RugsXQNJtWelzLn/T1Q9Z3UXDHIBcwUYr3fzlakx2EyW5Cp7D7C4GCRc=
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OSAPR01MB4642.jpnprd01.prod.outlook.com (2603:1096:604:60::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 20:19:08 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::84ad:ad49:6f8:1312]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::84ad:ad49:6f8:1312%6]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 20:19:08 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v2 2/2] ptp: idt82p33: implement double dco time
 correction
Thread-Topic: [PATCH net v2 2/2] ptp: idt82p33: implement double dco time
 correction
Thread-Index: AQHXq9Hw5KOUR0ss3UKvyfLSiPV3fKuoo+GAgAAE1HA=
Date:   Fri, 17 Sep 2021 20:19:08 +0000
Message-ID: <OS3PR01MB65936ADCEF63D966B44C5FEFBADD9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <1631889589-26941-1-git-send-email-min.li.xe@renesas.com>
        <1631889589-26941-2-git-send-email-min.li.xe@renesas.com>
 <20210917125401.6e22ae13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210917125401.6e22ae13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ddf71bf-de82-42df-0cd6-08d97a18676c
x-ms-traffictypediagnostic: OSAPR01MB4642:
x-microsoft-antispam-prvs: <OSAPR01MB464202123F50620806986FA1BADD9@OSAPR01MB4642.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: du77eJPZpZJFrPAkJVDJ/ws/SJ3hezYBTHCrleDlTscRzZK/NETjLDexIfI6Fijp9TY6HpzL+X29+lX8lbyDX9rtYTxiUeJAbdT6Iv0okgqRQM1c7NPMUpjoydGU/YkNWKesS1aCWlN7BanL5Lqo8+Kc30wyLMfi8dCnOv2jz4zl2CGoQYOkiPDbg4KfqYxLwYzsbycpAFl1MiCcP1DJuYVZmhe/sfgXp9c+pEi1wft/fS/AR4IG2fu4AzW8Oq2ypPOPhEJCnZ+OwKx1PlgqyUZ02YzZYVxNwoO1MmA8huCs/ABWJ5ERPng8Ta8Q8jEXBbesrWDBwrthZHkvkiDmwLQkXDrHHjeWj2FVImFf1jicpf+cplAqq+3plyrEhoPdOSDmWF64HchyX2WP+DcAtvJxHM9qiyGSeu1uHsi6FG67UtQSiCsXjSRtkEHM0NCswiE48OkuHtVlRLipPbZfxir01rqk+1RonlX6nXlPsMnCVi4vqHSGdoVCN/+IdRTHFeqIkkYaUDV6CI6CbBcf13wghKpDxfxW5RZuy1uyn/OQtXka9YiFS9ZXGIOhjeSHcsBc2GlbSfIwJ78q29SjW9FAVjd9MO2JJ4cl39ar+0yAVq4jZ6MU4+wuqIlbCxJU32KQPxcfz17sNuNi/hF1oX0EFUxP3tVv/F52ypQU5HneP1tKUguNAXgXS2a4EMq4ufaEPLyk4N+8dK7dIgDGiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(186003)(64756008)(66556008)(66946007)(66476007)(66446008)(8936002)(76116006)(122000001)(38100700002)(4326008)(8676002)(5660300002)(26005)(6916009)(71200400001)(9686003)(38070700005)(52536014)(316002)(54906003)(55016002)(6506007)(2906002)(7696005)(86362001)(33656002)(83380400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CcN1e3XAHn5NzvTGjQaqbDZ9sWe9nS/i6MpgfpUWbC3+gpk8dR0NMGZMpItp?=
 =?us-ascii?Q?lOyQJjBTjOG0hJfrboDha0JsSRgvED0eP0KpDK/a1QOm05uspfLR3dyU1BaB?=
 =?us-ascii?Q?kdX8OpAzCWzW/YFusp4v5L6ykU5XbA06j/GLT/cWyY4N3m8fOefb3Z63RoXl?=
 =?us-ascii?Q?UAo5Qs8WnCaFe3ZtmAGjAnJap1L0tTD58gvTjbNYtNziDz8Akz5gLGRSn/73?=
 =?us-ascii?Q?5Il3EqyTZKRpDf0+IS7nommJT6GjnaViGXlwMJ3YMab0l6zwslsyCkPkiPCc?=
 =?us-ascii?Q?fzWV/bMhZB0MpJauyTn+4CCAQ/Dx9v5iN0di6C2dCHFOWpTtEMXqYy6g8BX3?=
 =?us-ascii?Q?vQ8S5vmlbzK9dUaGvjy4b43WI48vDGCYVjFzFYDOSoVgykY9EfnlbsZNKLnP?=
 =?us-ascii?Q?5GKYksEl70k+9eRtM4/QMg0G53Vrq7eMMoBhLeMv1reNLkyIhnqcqoM9XMG/?=
 =?us-ascii?Q?i7RYiSbzM/OCy/1RBbnRJmO8N9eS4drSxEYX0A7MzLLT0Eg15fY98QVw4J48?=
 =?us-ascii?Q?i7D76tSUk96WASwqvteWRlppF7XLjOm/2pAZs3+vsrus58Fx7QGraPHrefkU?=
 =?us-ascii?Q?vbJtKa5lA3+BXJMbyScc4myDWIS2DHSEMo1nIHcMrDkxGtUJYEbCewwsNEvq?=
 =?us-ascii?Q?BOBE9MshFwgJrvZTLTrodlLpfbudbWlevv8F3uj6JevlPtKseV4qgvkgJGIS?=
 =?us-ascii?Q?DOK7VHb4n9H+Bko60sZZu47H5lNVTVKej/19o5TB8J3f3PxeW0m0qH9MZdQ+?=
 =?us-ascii?Q?QjKm05Q9edmFeZ2cv3/5TZERBRn1mddaqjce2T0H0joNFMpbpA4xWUW5lwq0?=
 =?us-ascii?Q?f6SF3B3wWc2SCxNXYE2/vjn6iEEXjbisUufNBq29m28OphBXufoGyl7q/6f/?=
 =?us-ascii?Q?R8QxnZkCD5bCtoHSx125Z1ZS1+ZV0V/0vQZQeA4SEGVh68sJFjjiJ6ttKUza?=
 =?us-ascii?Q?3w8GTVTWD0Iv8PqHso16Z9XOvl4NOW7gYx3nXZes7hNJYeJjr+dHaDIixBG7?=
 =?us-ascii?Q?fgeRRPUzu3fsbjI7UpxT+iOzhYWXkX4/DDORCS7dWLmHDmjJRMVFm1/daQ9R?=
 =?us-ascii?Q?HX5v2yyj5XOzgMF4E1enOk81m5Po+kip89SKz4qNwDBNCIG/skRPkEtrulki?=
 =?us-ascii?Q?jEQjZ+94cONrR890Wod8FDlNWHsiKj9oPWKdKN766PaZfF+gJ/FNqiifhK0j?=
 =?us-ascii?Q?hXbkv06UUHYI4MZczKEPpBJhqLS0bPPlXl8u6KNbFgid7bQty+L78TzSv73u?=
 =?us-ascii?Q?f72IjO9+IGzvMIlVX+hK+GwOWdFhQjKoh41IVBtpHoHTBKNnZCu2NMsA2q5/?=
 =?us-ascii?Q?iPHDDlNB8lD6l4UKKTKagzPt?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ddf71bf-de82-42df-0cd6-08d97a18676c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2021 20:19:08.1130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x0+IH+YK3W2juEflrOK6hCOnFxUVwNwaYyICo3NIkg4k2Vhb4cXgR0Vp4e5oWR0/En53AFau/bSSUCAPzVLfZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4642
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> > @@ -29,6 +29,14 @@ module_param(phase_snap_threshold, uint, 0);
> > MODULE_PARM_DESC(phase_snap_threshold,
> >  "threshold (1000ns by default) below which adjtime would ignore");
> >
> > +static bool delayed_accurate_adjtime =3D false;
> > +module_param(delayed_accurate_adjtime, bool, false);
> > +MODULE_PARM_DESC(delayed_accurate_adjtime,
> > +"set to true to use more accurate adjtime that is delayed to next
> > +1PPS signal");
>=20
> Module parameters are discouraged. If you have multiple devices on the
> system module parameters don't allow setting different options depending
> on device. Unless Richard or someone else suggests a better API for this
> please use something like devlink params instead (and remember to
> document them).
>=20
> > +static char *firmware;
> > +module_param(firmware, charp, 0);
>=20

Hi Jacob

Yes, this was suggested by Richard back then

On Fri, Jun 25, 2021 at 02:24:24PM +0000, Min Li wrote:
> How would you suggest to implement the change that make the new driver be=
havior optional?

I would say, module parameter or debugfs knob.

Thanks,
Richard

> What's the point of this? Just rename the file in the filesystem.

We use this parameter to specify firmware so that module can be autoloaded
/etc/modprobe.d/modname.conf
