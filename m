Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FB748A952
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 09:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348881AbiAKI1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 03:27:37 -0500
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:11584
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231130AbiAKI1g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 03:27:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mU+5CRa92dSDF+y49jltQGj6susdZqsCdtiGUp0o8MAQ5lT/A7rC4QD+BUiCVTRfnqFumonXrd/y/pfMd2p+ugjFc/uySp9C11APNvEOBAO7Bce+rJO73mJOlD/gC2Ewaro8W4AoSfN5quQ57vvNoDFPgr6Isg2iZSn6mTXscBHGmRm2vAY2w58hPvnX/CVUsd6Z1U64VX+kHyUjmSIjPNsb90kD5bneNTwCslBkYrJeshFwsYcTYyJPSmGdZ9I47h8EVqA3Uiz8GxOjE112abPDKBfLZ4/VFZP8Gtjrtfjx9AAtTI65Y26EAoV0tm+HUYY4e7y9kw0qBST8UyyhWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bVVu5olzJnEIlXa9KSqJMhB7blaRWCDbBQsCZ41WP8=;
 b=g71I82CL+INVuMfShlL9rH+MLBtmhMgHyUBSYPu9eyHBLPDkN6h16Ix6JKdfSXyQHnoOt0FyFHNT8dyTiAnsQmjexPg2MPWD79okEBb3z4cPLV2iOlIuVO9qbeA4+zl9buovtqGtFwuSTzMD4DGOmfddxi8R7+LcX8dR4q/WTNOEhW7/Srm9rGP3DH07dB/0LrD9cVLRX7pSImWpl6UGn+MLNdm5OZRaeEPw7PC6kOa286pj3TLAG21NxLDa/LfFKW16LaV9AQpMQuB81lPo2xh9LgXFieb5Scp8F5kI58Cthr9lxIySpGe+iv5VcuT7xyA2IwAyX7XRIXnB44jlYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bVVu5olzJnEIlXa9KSqJMhB7blaRWCDbBQsCZ41WP8=;
 b=fjNd0p9B3+MLfK1/NiLMcsg7ohBDFlKLC/P7wtWoknXPfWo8pKirDj4ZLSuo1e4CgddTjhTOiHmY0ABvH5SjpAfKjusAbqyx+SvAR4WqO/yRtDVt0YCdZqqgC4xQxzSNk6MuV1v39naHd75TH91QsO9nxzI5stNxx1YcbBuf5UA=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM0PR04MB6228.eurprd04.prod.outlook.com (2603:10a6:208:142::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 08:27:33 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::e507:6815:70b7:f379]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::e507:6815:70b7:f379%8]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 08:27:33 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH CFT net-next] net: enetc: use .mac_select_pcs() interface
Thread-Topic: [PATCH CFT net-next] net: enetc: use .mac_select_pcs() interface
Thread-Index: AQHX8npJLeRvaAz/zUWeXla1iOJ756xXs4wAgAT3T3CAAPdC4A==
Date:   Tue, 11 Jan 2022 08:27:33 +0000
Message-ID: <AM9PR04MB8397721F40A82475A1CA42FF96519@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <E1mxq4r-00GWrp-Ay@rmk-PC.armlinux.org.uk>
 <YdhDAHxFaUhiQFbd@shell.armlinux.org.uk>
 <AM9PR04MB83977DD63CD3DB191E79DC7D96509@AM9PR04MB8397.eurprd04.prod.outlook.com>
In-Reply-To: <AM9PR04MB83977DD63CD3DB191E79DC7D96509@AM9PR04MB8397.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c509d5fe-dd8a-4e8b-cb55-08d9d4dc3786
x-ms-traffictypediagnostic: AM0PR04MB6228:EE_
x-microsoft-antispam-prvs: <AM0PR04MB6228AA56A9014A6EEAEE7B8096519@AM0PR04MB6228.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lslzMuXzJTQ4e8Y3AJTM/TKqkQNP7GEX4XBcSmuJkdsgD7/+O3OGPBjFrMLch/1EnStFRbjLpayYAR0G2eUYMCjRSTwVh4LsZxvqjfkr4u7jG3yEAnJCkF3DM4S1PH1/wxczE7shtttBzSIPH0OEzcrmDFY/kRnxh90LcOabcoYr1o4mGTLd0cbyPJ7qXbdvE0+3QKTPWNNS2K/52K5C90AOQr4dBIgorgZ7sxUS8X1el/dK3RxdoGX0ZxzsMzWueNSGBQQeLntJjPwdaNXPXJ5rGMl9Ui1K+rW6TSUhs8wcp8TTqEBVDssKG3tAsK/JLXi3Ug1TVLfOwnaYPBfxKNqKelc3xy4YLUx8F0VKin9cQU8fPFdD84if9LNjV6HuISi4K8tKcNfOfixA+6+JUL0qHBOeJp6k0MVjNG0tzocmbZ/MElCRExLHBJDrzw8yUOa75P90p/u9HF9lqL68ZcafGKvvPQiXw4ks+yRju1HTFR6ZyHs7WwAzeF849c86JpMO++fe/469zghg4okmx3pCWPD6zKrxdB3L8zcq6KUzxfKb9JT4LdMg4cKPEhV1ne1tcwEpc8F5M7ypVe/tBwCxzSR+HT4SZHt19dVh9zYW8vqT9ypvwpFIxOwxi9Nclo9EQVJEkg+EMBmvLwGwwsrvrzcmse5ih8zH2dUyUPuWsSvq0CJ3PVxMcD3xpQyg8khPfNnQVyrrGVr49sN7vBFw87I5Y8rHaydWPH7Vdwg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(76116006)(6506007)(316002)(122000001)(9686003)(66946007)(83380400001)(33656002)(26005)(38070700005)(8676002)(66556008)(66446008)(53546011)(4326008)(508600001)(55016003)(71200400001)(52536014)(64756008)(44832011)(7696005)(8936002)(38100700002)(186003)(110136005)(2906002)(5660300002)(66476007)(142923001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xp2buodXMmiNeAhW7GOmaNVniOd94qBkci35MM5C2zA+ayG8UjAjvgHymMs8?=
 =?us-ascii?Q?UCK3WvQ/IUukECVvE1LqPKR8LWIC4TCBCSvwiTfHSlt8tBMw3ceWVuJVpBYo?=
 =?us-ascii?Q?4YPr17yY4NEn3lCaAo09qrj+j5e5Pkm+nxxnB75hjmaBPNbqOEJXswlvQrxl?=
 =?us-ascii?Q?qbepO8EqFRr++o6S01cbgZHeokCDhbEu5d1rzSqbEuuxs7bYqf4ZLLBpM11I?=
 =?us-ascii?Q?zENd1FgSCvZbbn7ZbyN0JQD5ccEFOgSWIeyVqkp2GBWS1teZs36Z11EuQEdR?=
 =?us-ascii?Q?eueJwd1Q4Z9oHKe6l+izDf9BoE2/1MvwnEc2MpmhCx3pUWLEzd3NQgXCtd60?=
 =?us-ascii?Q?tcaF8RuxwsHPViarS3pL7g0yjFB572sfOiI1HDDMH2ve+VVBKijOdB+fl6s1?=
 =?us-ascii?Q?h4AEIsvXaS23xk/+0GmlKZNHp0zipEOhvLJHq3Nvv8nftpgI0szTBv4Hgi5Y?=
 =?us-ascii?Q?UBg/byQ+uUnFbALnY/QLZb6SLtbiNMx6ijNyhYWrJQdxYsEGlG8Xr2FlvNWi?=
 =?us-ascii?Q?Gvi3tZQBTKPs38o4BvfSHIBCgML+izYfCgWAgjnCdrlKtzWeW+PuyVy9DBXU?=
 =?us-ascii?Q?U2l1wMbWXKpJPuuoNtGL8WhLREsbMzybUswLy7lKVHwv5WDbqLJLITyYvNv5?=
 =?us-ascii?Q?yG0aI86s+gHZR+sKaVbzULb+kFlW1gtU/M7eyMUbTyc9eHI/eXloIHcgS2z+?=
 =?us-ascii?Q?72+espncaKynp/JN3uGNUquWK9cldFEIrGDEHhPO1Sw0bM5RQO4hfQ3VMjjr?=
 =?us-ascii?Q?EfIWB7ndzaxWliXKVZ3Gaz/hXbeIBOAs/ICqhKYwMqj9l6awvXkcLn2AdvuI?=
 =?us-ascii?Q?3v+atY5Ra/7LULUSVwpS9FFJdBGAicu1fSIj5z5B6WGqIANQ8jgp9dt8jMlM?=
 =?us-ascii?Q?SWDpFaoVIv8SbPbVXXLOvHhGAsXWd5w2BpiE0+CeYkvknAVWB/xBbaThzpV7?=
 =?us-ascii?Q?K3dBRBBZzc9kzZFgWR1jMaW6jJgrmuo2A2j2S6/OQ3hQIFdkHUsjOkKo3VHn?=
 =?us-ascii?Q?dvSEBoC+NCUfBedcL4VQvcs0z17MIyUV6NP/XBDgI0FHxSScnabV9G5up2CI?=
 =?us-ascii?Q?ZySo7TqT5MXCfgXGW6dLyaqEAZAsZi/zX08K5qAec3dle3NhI61D9OoQ1RVb?=
 =?us-ascii?Q?gIspsCP1cnwzCwAmgBsc+EFIdifOSRTg4fK0RBec9vv6yWnENdd1ewaSDpGe?=
 =?us-ascii?Q?nfW6A8tTDbpRd4bpD8IwKaUMOEHI0zdElPGp3+vkUwRnxCguLEXEhhpa9+jF?=
 =?us-ascii?Q?ob0U9+Cc4SzLJNyrDI90VhpZ6h+yRKI9KN/8uf0a8MrKhKdkpLNjDql42p1Q?=
 =?us-ascii?Q?gGb9APDcrejSHXxWnJPFdRUNPnIIfYFpH7E5fsjGkycCy4mz+KGPsEXGB5wl?=
 =?us-ascii?Q?cQP1LMG22kA7okJir8Olt/RlBSQt26FDuBO1An/dpxzs/5JCMn7s6NejRb08?=
 =?us-ascii?Q?QSvG1frKrkiLRNFEFLNxe8+R99BrMOu1Z+bWySMUTLQdHJUZ5UJOV9m+eXPZ?=
 =?us-ascii?Q?RpsSXoIJc4CnaLUeuQ0EL/NkFjIGSUwvWfB5fwigQSRiBJl9WOIAJPvubRMZ?=
 =?us-ascii?Q?P6NR1ojaXveQOlve1lm869Iv/CSd2fmDKmyn7CnOJJUOw4jOgsBMPU01+E3/?=
 =?us-ascii?Q?4w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c509d5fe-dd8a-4e8b-cb55-08d9d4dc3786
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 08:27:33.8641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NBti9MhHmE/AYSOT6nU4luxFHVORBoWE3czZ2gdt/ukqOLPVrNuE1uym95asvmoxxP46ZOFvRMN6mmWbj3oiiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6228
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Claudiu Manoil
> Sent: Monday, January 10, 2022 7:38 PM
> To: Russell King <linux@armlinux.org.uk>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Subject: RE: [PATCH CFT net-next] net: enetc: use .mac_select_pcs()
> interface
>=20
> > -----Original Message-----
> > From: Russell King <linux@armlinux.org.uk>
> > Sent: Friday, January 7, 2022 3:41 PM
> > To: David S. Miller <davem@davemloft.net>; Jakub Kicinski
> > <kuba@kernel.org>
> > Cc: Claudiu Manoil <claudiu.manoil@nxp.com>; netdev@vger.kernel.org
> > Subject: Re: [PATCH CFT net-next] net: enetc: use .mac_select_pcs()
> > interface
> >
> > On Thu, Dec 16, 2021 at 12:41:41PM +0000, Russell King (Oracle) wrote:
> > > Convert the PCS selection to use mac_select_pcs, which allows the PCS
> > > to perform any validation it needs.
> > >
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> >
> > Hi,
> >
> > Can anyone test this please? Claudiu?
> >
> > Russell.
> >
>=20
> Hi Russell,
>=20
> drivers/net/ethernet/freescale/enetc/enetc_pf.c: In function
> 'enetc_pl_mac_select_pcs':
> drivers/net/ethernet/freescale/enetc/enetc_pf.c:942:27: error: 'struct
> phylink_pcs' has no member named 'pcs'
>   942 |  return pf->pcs ? &pf->pcs->pcs : NULL;
>=20
> I suppose you meant:
> -       return pf->pcs ? &pf->pcs->pcs : NULL;
> +       return pf->pcs;
>=20
> With this correction I could bring up the SGMII link on my ls1028rdb.
> The patch needs also rebase.
>=20

Actually it's just a matter of rebasing the patch on latest net-next,  sinc=
e
commit e7026f15564f "net: phy: lynx: refactor Lynx PCS module to use generi=
c phylink_pcs"
replaced 'struct lynx_pcs' with 'struct phylink_pcs'.
