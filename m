Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB5827A156
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 16:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgI0N75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 09:59:57 -0400
Received: from mail-eopbgr150072.outbound.protection.outlook.com ([40.107.15.72]:24974
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726149AbgI0N75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 09:59:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7Iprm9nK95uQUj4a2aeKwexlwmRgC+1RDU+1N0clClVYpsDl39IiaDgTsSKInsUFsJnBTNDagHDGAM0I1FEyN+xfMAJzNxRnvdNRxHjBXYfsGDGxVVBcd3+GGfj7TeQFWNruR911NBTT/ZiLB0K4wr+UepV5zUGCkgIPuhAF1aCrM0ywolt8/bCUBl3QT5dIH466XGcWM4u5lEQQ3qXGClIs2MbdZAt0UkuUEd+aPue7Rl0rLrngJhTYyfEluXwIWWFdmtr/3uoxBzxwJbOl/G+ufLgk1koBv7DB+3CUSQTS7JLrn6VBVvpyULjXB2FlHqgz+2m0jHGDCPQ23P0+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZKmkhIGfFbxeaElptsT0ocPjvNxiJOFWiM+MaKH818=;
 b=RSTfe0q22D/GDacloy5vKQ21EzDIqP3+nxtxA3rlNuDRX9ZYgVAos37hIstRmyCp3p6F/EntkXAkQkJ9xHVODbah5YshJnlemrDbKpH6mdEKvygzIXJe1iSQ7kQdFwSwmDCrAtIakJ5yHE9lwhxXCCet+q63dvva8vk3GQlzeWuwvDu7npodbS5O9YFnCV547TTLFladeWRqPQKpadO6Xr5EMOWZ2WsCpnsGaG81x6oeYa39ypLEM2ljJdG93OlNBZsBmGnLxa4OzjELZtnTD9vssewPdcZXheB5SHTUmjzdYFwuYh5SCtllZA2//jJrdKDyAGc2IX5mVb1TSPESDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZKmkhIGfFbxeaElptsT0ocPjvNxiJOFWiM+MaKH818=;
 b=KSmWzqWiZz2+8rR3vb3pl3nkFOn6KPL1pMcwCn0xh+IkPGTueciUpwY+EyVfC09GQCHsU/0mz7TILyMSUrzfGRZkoCn691n/YxM3sh24nPJYhKcXxR7k8Ogs3VrPB9Ve95e8MCq+5aK8OCv3GuKKAyAHXMGxG20+A/GENVp/x8g=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB2989.eurprd04.prod.outlook.com
 (2603:10a6:802:8::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Sun, 27 Sep
 2020 13:59:52 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3412.025; Sun, 27 Sep 2020
 13:59:52 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Alex Dewar <alex.dewar90@gmail.com>
CC:     Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dpaa2-mac: Fix potential null pointer dereference
Thread-Topic: [PATCH] dpaa2-mac: Fix potential null pointer dereference
Thread-Index: AQHWlNKE0U3a08JmbE+ZNmBTPcXWFKl8g0kA
Date:   Sun, 27 Sep 2020 13:59:52 +0000
Message-ID: <20200927135950.cy536vnvrae6h2ne@skbuf>
References: <20200927133119.586083-1-alex.dewar90@gmail.com>
In-Reply-To: <20200927133119.586083-1-alex.dewar90@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8ed9a907-722a-4bab-2c8f-08d862ed9b82
x-ms-traffictypediagnostic: VI1PR04MB2989:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB2989DC8CE3757187CF8F48BAE0340@VI1PR04MB2989.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V6uDaa57O9nMG4eoq1FTQuBRfm8nfVYd+Bg+nsyPDPV3+bAh+pC7yf94sr4gMaDV8LRLCXEv2JKtWzvezf6gM1cs0g/bJFVs95laJykMQwORf93mM0l5fayPFttJRfogS0vrHTNuufOpZ2mm4cdheTn57lf9Piai75yTkVJex+G28DTJcJDhZsXF5TSfCB5IRu5H89g2+sMI63LASNXjAo5MVP/1552Sp75ufDUzCr08dP2AHBJ9FGIvTNH9i5yD3pmZL3+Up4HvzkwjVJHcLvwRy8AhJcToTWQElTor6ElQiShnyrZfAmDPU8B7DWInTXJYNpbpsuqe7/4Rf0JSN8XKzuKC0hQXGtUdxcb1RRcbH48+m9QuUTyzcEOvh92X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(2906002)(44832011)(6916009)(186003)(316002)(54906003)(83380400001)(9686003)(6512007)(478600001)(26005)(86362001)(6486002)(4326008)(33716001)(5660300002)(1076003)(66446008)(6506007)(66556008)(64756008)(66476007)(8936002)(8676002)(71200400001)(66946007)(91956017)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: aYkRLTNbaCjAcOby638T1cvWPhgjT3+YSxq+BmcMOQTVaMd1sbl/NR3atJ/LwzvcdBe/cSnN2I0bkYsaMj4gMb6XmxTjc6hNz9DvtbIV0UBVxpEmYFqzUEaHK9TC1Ei7j/bUZsCJkr4odN0OzYGgA5yaP4y3+DMoellAnbMv/CA186hZOPJ25gGqlPwepC2WkCT6O+oOZSkOhCa8XDmTbYI5C1QtgjthfRfpbUtnjep8cwbSNgvuXpyKJzuyKqUQdD3ebYliYb0fj7LtLsNU50Vs8lEGBIohuHVSYVR1t2YB54syM6aPoIy0vQ1qTVTkVptSpqZXsVkhW1+9juNknzZd3sODLYMDhtdcouZKyLTB38IZmRvY0SaCotMFPZ3Q00mtaDuSCf1UmFu6r8s1HpPYUjmoU45Qa8P5d+fhDZLQ3AcDEAvX5osQrtL9qvplA7NQTFeXXB40rEZ6nd8KQ5L8wBLqgIM+4OVKcUdgAPwx31CsB6x3snOI10bI1yevXn4Wtmkxg72LgmHVwjnsydqjyAGMIVaXm4G/0nZOTMg/NWQ7m9tj/RsMQ85Eg1ulIKwXgEcinmbTlyo+s3klq2kddWAbm6rfFkTAWghS7GoET5qS0aqTuoG7Hyfvdji6puLJgk94lRB+yW8Ov7nDlA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B1A59593078E0448930793083EAC1B4D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed9a907-722a-4bab-2c8f-08d862ed9b82
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2020 13:59:52.7476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zF6lmdQoTjbIY6AenNmarKfL1pcoN7CeF0Xd/b0Gg9M//AlgF/4AhPHHo9nkhplv313x8QbOrnaXszGaIcy1vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB2989
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 27, 2020 at 02:31:20PM +0100, Alex Dewar wrote:
> In dpaa2_pcs_destroy, variable pcs is dereference before it is
> null-checked. Fix this.
>=20
> Addresses-Coverity: CID 1497159: Null pointer dereferences (REVERSE_INULL=
)
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-mac.c
> index 6ff64dd1cf27..09bf4fec1172 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -291,11 +291,10 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
>  static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
>  {
>  	struct lynx_pcs *pcs =3D mac->pcs;
> -	struct device *dev =3D &pcs->mdio->dev;
> =20
>  	if (pcs) {
>  		lynx_pcs_destroy(pcs);
> -		put_device(dev);
> +		put_device(&pcs->mdio->dev);
>  		mac->pcs =3D NULL;
>  	}
>  }

This would introduce another problem because you would access an already
freed pcs. Maybe just move the declaration and initialization of dev
inside the if statement.

Thanks, Ioana=
