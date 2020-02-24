Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1DB816A1BD
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 10:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgBXJR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 04:17:56 -0500
Received: from mail-dm6nam11on2063.outbound.protection.outlook.com ([40.107.223.63]:6103
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727168AbgBXJRz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 04:17:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npZnFCs63m88AEhgyI4D0uZUymm84RbhJSG26A9Rrdugag/CCd0gbBDKKQfqvn1XgtkzMLPthmFuUYUQ07SMLu/QnerS6TDW8KPdy49dS7USDf9Ldw5EhVLAfIto3EnBHefe2yWF9B0pBHHfE0/zA4zSPPH3Smqj5r8fr6gOl+uoS2rWsjHDVSBPO7Ms9flWiqVA0lHYADBOEOS9Fr0pnzecQ0kwFkQpYKFXLSxc4/A4ZPmeVa2bMgfDeuQRBQx5+7rCrr0o1goU/m229UJj3ypQC3lACtFC1yqYD8Qt+YPmNZWzP+QcXSwU731T2SXjvFDX3lvobKpL7zBVTLI++A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2iaH+Vpc6pWopY2Wx/vFvzXcFnBYjy5WSegRObBkU=;
 b=GqoKf9d+odX2t7pz2VnTA8EJpKOeYg1MBAT20f+W4J97LQJRzrHbYVGHu5GKSHr7z9Q+k0PzeqGKSqRyOp8h6gbeSrITWSrfxwb/DDWcCDlFvJWvVrmbdSzYnhUr7meJCQJ1EQxQhF6Uuh07zb1iJkCYBtqSxCUeQ+zDF435qF6v3hfkXTXwR/87SY6AhmMTxbqxw0rRvQl46w9xmw6auqHUfBF91xq/U1C0BfmOQlSi17Ud/27IOBHzU/+fvwxyN+MIAaG2ws/oKbNJVT2pQiXoHTaofBZE3KSBcZYsYaLsaxhWPA7n8lyYB6jAdWl3NvnlWuXOhurrg01QiqJDSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk2iaH+Vpc6pWopY2Wx/vFvzXcFnBYjy5WSegRObBkU=;
 b=fdqd95SO+jo2qFcQ06aTjhczLTyUVwxYrkgNGWWcjTI966zMWvUvhqjZU4g1oVEVCXAc9t4pYQJ61/Npfmafgnwl32NTfXQ5T9mCP8rsg4D0+QYRsbzN+1A0H/ytoHtXct7bq5uQKo6Yb08dN6QShcM/7RW9b1eZ63Iu181nLvY=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB3726.namprd11.prod.outlook.com (2603:10b6:208:ef::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17; Mon, 24 Feb
 2020 09:17:48 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2750.021; Mon, 24 Feb 2020
 09:17:48 +0000
From:   =?iso-8859-1?Q?J=E9r=F4me_Pouiller?= <Jerome.Pouiller@silabs.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
CC:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Piotr Sroka <piotrs@cadence.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Olivier Moysan <olivier.moysan@st.com>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] docs: dt: fix several broken doc references
Thread-Topic: [PATCH] docs: dt: fix several broken doc references
Thread-Index: AQHV6ietodQMow/ON0qYMI30cMvXMagqEj+A
Date:   Mon, 24 Feb 2020 09:17:48 +0000
Message-ID: <2091904.E9UJrs0rOF@pc-42>
References: <0e530494349b37eb2eab4a8eccf56626e0b18e6d.1582448388.git.mchehab+huawei@kernel.org>
In-Reply-To: <0e530494349b37eb2eab4a8eccf56626e0b18e6d.1582448388.git.mchehab+huawei@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c216210-b0e0-4f03-71de-08d7b90a6a8e
x-ms-traffictypediagnostic: MN2PR11MB3726:
x-microsoft-antispam-prvs: <MN2PR11MB3726D310E3AE89F7BD62ABB893EC0@MN2PR11MB3726.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(346002)(136003)(376002)(39850400004)(366004)(396003)(199004)(189003)(478600001)(91956017)(66446008)(76116006)(64756008)(66556008)(66476007)(66946007)(33716001)(71200400001)(86362001)(6512007)(9686003)(2906002)(5660300002)(6486002)(316002)(8936002)(54906003)(26005)(4326008)(6506007)(8676002)(81166006)(81156014)(7416002)(186003)(39026012);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3726;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tW26OkY59CNnY0uV4PGmD9XS4pbuQLM1pt4GQwiWWWTjwahJZptDgOqh6gEcUJRRUKnEesFW63AQ+nHlmwLL6ujNeNhsjhmmjCWQ46yFZw5E02yBSEb4fT317AxYu1Q2Q8KOsFadzCMUE3s3CEUNeZ+OMns8tRv8Xa0CHukBXBgrVCsIILH2aUoAl7wQl67J9LZHTDCB3/JuS7kmOZwaSe66pPrFgevejKjIYTBuZaPvIdPS6DzQlrbH4G425hyAK84yu5bQCGNqm/GU+rS5pSFBlspjnZoso63etQGlyjlP2smClxd8ON0HazuSFgvv9fc3G5Oi+TuwdT7/eUITINwhL4ZCuWO7NGRABq2lFRe7Fj9JF/GL+jO1uWuyeIpTKrYwlABrrT/F0DJcq06TykDW52G3Qoo8SmztbqH2+4rG8pB4LiFwShz1kpQa2HWacV6RACvegASwLAKxzGKaAR5OX2/Yxn7CpqrNwkp2PwU7j8D+dM2ltDToonuQJFVa
x-ms-exchange-antispam-messagedata: AF0yrNqSJydrbDobr5+HTtfQccuCrmtFMqub6qCDUO+6bGqompj9fTm7j/3EHIz96Am9d2n3Y6oufwUu5SqccPbmSIQoDEGkPrk6ZECdmPwKgIRVBZEiuC4Wfk0BZ8jWv76rno3xBiwaCXdz7aAvOA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <A4AF2F212668DE49B684D505CA997FC5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c216210-b0e0-4f03-71de-08d7b90a6a8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2020 09:17:48.1208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2xQe5PXq5tYfLbiYko/qpVR7veZp92Wqc1rmW2c0HugRWr2C1F3wLQZdz5vAfsMHRGVfsqAf8K3AZnp+my/ATQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3726
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday 23 February 2020 09:59:53 CET Mauro Carvalho Chehab wrote:
> There are several DT doc references that require manual fixes.
> I found 3 cases fixed on this patch:
>=20
>         - directory named "binding/" instead of "bindings/";
>         - .txt to .yaml renames;
>         - file renames (still on txt format);
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  .../devicetree/bindings/mtd/cadence-nand-controller.txt       | 2 +-
>  .../devicetree/bindings/net/brcm,bcm7445-switch-v4.0.txt      | 2 +-
>  Documentation/devicetree/bindings/sound/st,stm32-sai.txt      | 2 +-
>  Documentation/devicetree/bindings/sound/st,stm32-spdifrx.txt  | 2 +-
>  Documentation/devicetree/bindings/spi/st,stm32-spi.yaml       | 2 +-
>  MAINTAINERS                                                   | 4 ++--
>  .../devicetree/bindings/net/wireless/siliabs,wfx.txt          | 2 +-
>  7 files changed, 8 insertions(+), 8 deletions(-)
[...]
> diff --git a/drivers/staging/wfx/Documentation/devicetree/bindings/net/wi=
reless/siliabs,wfx.txt b/drivers/staging/wfx/Documentation/devicetree/bindi=
ngs/net/wireless/siliabs,wfx.txt
> index ffec79c14786..17db67559f5e 100644
> --- a/drivers/staging/wfx/Documentation/devicetree/bindings/net/wireless/=
siliabs,wfx.txt
> +++ b/drivers/staging/wfx/Documentation/devicetree/bindings/net/wireless/=
siliabs,wfx.txt
> @@ -94,5 +94,5 @@ Some properties are recognized either by SPI and SDIO v=
ersions:
>     Must contains 64 hexadecimal digits. Not supported in current version=
.
>=20
>  WFx driver also supports `mac-address` and `local-mac-address` as descri=
bed in
> -Documentation/devicetree/binding/net/ethernet.txt
> +Documentation/devicetree/bindings/net/ethernet.txt

For siliabs,wfx.txt:

Reviewed-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>

--=20
J=E9r=F4me Pouiller

