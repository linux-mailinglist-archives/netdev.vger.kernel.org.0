Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D91642502D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 11:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240732AbhJGJhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 05:37:12 -0400
Received: from mail-bn8nam12on2040.outbound.protection.outlook.com ([40.107.237.40]:9697
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240541AbhJGJhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 05:37:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnnbSECF3KRSQTazjk3aSmDnNvdGKriG75onF8ygDloW2SkzEuIE7hZ56q6l2dr6cs88L7avsx0wiXePxO3SjDPMWHpf00nTdBavZPt+LODS9gidpVdIeVWPMu71BW/EfubHLeHBKm6WfT0AyOD5RinoAeczyP7FUU+/iAkrrhqV7PDSRevwed2BXhX9/4FVvdY9OZs4lbncDNAy66gAqp0sCgfdPlvsJ+rZjaAbED3qP4PAHC8pNJOjQblLHsLjEqxKMkkZBEaf5+Wr3n67yqwZz1JEWVFbXe6mk47KPQ5zW07+s6Qu2l7zx0jAJ/TRW/9hr7uv1EJJJKsDrO+UoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ARRECq5Ubls6yVVzUFu3l+hey7x8xQdAGH+iQ7LDGM=;
 b=gIKqwd+oCXUlzPye7X6f/m4+l9agdAEdZeQxAeuIfkyXxdAxLrqUECb+KlOWCntWwYHg0M+QqINAdaEzIWyrpgfKfNICeIxfwst93CYvdbDUXJHrJyW60MH0n1GLbjQ5ZxvjdO3t4r3eHoSuC+U+/lcR/wTS3VX4RbY+UH24Ph+SGlUK5SA4WZ3beBV5pacHb6uTuBVWigabnSELw9zAYX/Iqsj5GsEwy9oOb9coH+pu4C9JDDGX8QAC5HoxNsjMo64Ws0PluZ2Mfp3qFbw9AzvWeKD2UptRu3C0Xof/VRYjkUAKBaAUtTgCmw3pr6KJJVUPyP+5IMrzgiCNr36mTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ARRECq5Ubls6yVVzUFu3l+hey7x8xQdAGH+iQ7LDGM=;
 b=JU7JvuM1d9fkuzWWXSDzbq3mMwX9tTFtof8eyO/azoI7M7rRsXQwcGEmqLxylrB7lcUWBRHTWPZAGDZ2qm9xJ4N4W8QEn2P+lufjmtHXDHojEDlRrxG3dZHdqNOIco/TGrMGWUK2uQNPiufQbFct/BpkdVqzFfPKB+EIDqE2Kp8=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5627.namprd11.prod.outlook.com (2603:10b6:510:e4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 7 Oct
 2021 09:35:15 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4587.019; Thu, 7 Oct 2021
 09:35:15 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 10/24] wfx: add fwio.c/fwio.h
Date:   Thu, 07 Oct 2021 11:35:06 +0200
Message-ID: <6406115.Wd3412XU5f@pc-42>
Organization: Silicon Labs
In-Reply-To: <87tuhtcl4a.fsf@codeaurora.org>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <2174509.SLDT7moDbM@pc-42> <87tuhtcl4a.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR0P264CA0199.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::19) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PR0P264CA0199.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Thu, 7 Oct 2021 09:35:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34fa7738-bc12-45ec-cb62-08d98975c46d
X-MS-TrafficTypeDiagnostic: PH0PR11MB5627:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5627AE6E443B5D4A54FE90F593B19@PH0PR11MB5627.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jabjXYVeP4X+/EQJCL49f1kGhWSkiRHOgCAiB+bYWscywjjoGaOr8Ax8NMRSAbzDzt8wYNKWlSU81LPrEqJfvoMD0ULzM9KRR1c+Xhv4naFISyaP7w4kVhScqLcBP1dKIOgXFiKQ+vw2fmu99Yl50WS9zd9JwECkdU8bSkLTACrFHRwUwmzkKO2FKLaDwhAHywnvAX6FJSxlU+UB/FVOe38DZFc00d/y+ERnGPEITIM4NyvX1tyTSLQt8cOXATDbuzGJYUZXN0OdpNAk4aiFqdIrwVYgEHBnj/NYM5ONbErX8ZusDaDH/OixvCEG/Gk493VMbOqQJZFP8uPe/TFOCXNjBmGVDm4a3FvJDJIlDix9NCahMG4bIIp6uCCgPE2U+KtSjMrmqC7M5Pil2iKPlMcLana01veKt6XtjlRKQGcbQ7hgidpooebTVkTX7eyS1gSy7Ukif85zBZV+1SXTBLNr8glZmlHhyRboslzSnItYhyo/KZQnscXrzc0zUb9eVNWkJPyB4eeDSybBSDP+HhcTNMjRdZ4gDirOvXSSnSj6jWB8p+QgE5YQS32i+AiyB0EcNRomQXGUTfKl+kHpwFiLfZH7mHml+ShEOLICv/LKUFm9tdTWjbRy0/Wz4id6yigEYApwRG/X6T31zihdKi5Tgyju9XauLoq/a7U3vEkGnAxA7SjXkZhBNp4rlWWNNAOfViGsKq4lJeEPSRJUBHuEFjMA/cWo1AtlXD3fYVH+x45Ta4KOTR63keYh0kzcJpTVuwJYVYqhSz99yLNmTF+bPczEs0L8yMY0d+TzKIg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(66574015)(8676002)(66476007)(2906002)(66946007)(508600001)(5660300002)(6486002)(66556008)(83380400001)(7416002)(86362001)(6512007)(9686003)(33716001)(36916002)(966005)(6506007)(6916009)(26005)(38350700002)(8936002)(316002)(54906003)(38100700002)(956004)(186003)(4326008)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ChyTadVOQOVj7DhWOTJetE2r6z5pyyH9GhwcGLzLFyuQ8XV8mLUluhd6Kk?=
 =?iso-8859-1?Q?ZYNyKl9/bEqKPpGg3vJ5WN0vHX6iQrNgY1GIayvebfFSBT1s94W0QEDfkW?=
 =?iso-8859-1?Q?oHY1NV0kvR36WsriFJk+9xYWNtTKP1sD4KrO2z1ePAw0QSavXRwbXV3Yud?=
 =?iso-8859-1?Q?cQuUmVA8LSLbQ687tUzwuD906cwcbWe6tKQszyMoiFYbMH8dphcdAxyG+i?=
 =?iso-8859-1?Q?9cS5WIwxtfL0pUUImUacIV5J61c2aA0Va4e0jYkf/Wi41DT1vuMLQ2PDR/?=
 =?iso-8859-1?Q?m8mPrYjucxrT4vHEQNSjdfai6mk3SWR92RXuIeVxCxLkCwdwI7dLdobOhf?=
 =?iso-8859-1?Q?4Ow3SALzSBIl60otxtb55HQGFkUhfgp28vhgWG2PIdactLucejc910szrK?=
 =?iso-8859-1?Q?CTmgpXSDeqFMZGx2TdwTjD9F+HTc3E99Vn+m9CtyxDN12C4a9SZR5josp1?=
 =?iso-8859-1?Q?BGmHJf3X1IHwLPTSxNYysxiKaRCpXi2uShBl0jJg45wga7qhVTyrDR6Hkt?=
 =?iso-8859-1?Q?ykZBpHSZwhgLrd+oktxFtookzVeMiYPvcQgSZAHuEDVAwKa7XoVOFvJmWK?=
 =?iso-8859-1?Q?txHvpxgl0p9QVeN/eur4sT6XGDiEqz8N/YM0AQaxdH4VrLkVQEXubKJofL?=
 =?iso-8859-1?Q?3ATh6PVl0ineVgcpbbuHl8YzwaVoEoZd3fpbZPsINHfXWuoKQPN8bWetLw?=
 =?iso-8859-1?Q?twntmNb7OkYnnKcXYZOFnYP1USNhg/1Qp0Z7Ugx9M508TbOsmxEcOuUPEL?=
 =?iso-8859-1?Q?S5FnNfQyvZUvPhyx37+ukf1FDGoMCnnvTXhT0qbJO8GKmNackmA7X/EkQK?=
 =?iso-8859-1?Q?Z7nCxRObXJEHjlHo/MP1H2roDOYaCuX1FGpgSHpjVB0AJWavWrbakxu/H8?=
 =?iso-8859-1?Q?zvUR7c14xUgkGwosGDDzEl6WDj6UY3PupcSbIXjBKegoQKj5RrunvtcQfD?=
 =?iso-8859-1?Q?GI18AQR2c6XPcxGU/bsq0QDvwgqLgLKaOJXhBnHtgtGRM3md7ilhF90QCn?=
 =?iso-8859-1?Q?x36WzAqWrYv3esUYIneHYrQBP/GbGg/NsL/UWoh2C2sVi3G60EUg66Vh3C?=
 =?iso-8859-1?Q?W4nhmjAEo3UNeovmhP/jiqIvml62XzPbpVxeqO2/KiEG+GH4KC2NoYlUVC?=
 =?iso-8859-1?Q?+fFVNCoVVfGwWeLW94JxoLXUe+11kQBCbTr6DSEBJNBXYI/TzQLWQ3NURd?=
 =?iso-8859-1?Q?BkR8IUG2cioaxLrH67pt0zFZs+85uARG3AcQArGQbSk/dokSHqwWZewXIT?=
 =?iso-8859-1?Q?shMqNeLicfZiLwX9zqJLaDKg1pHQc/AsaM2v9HY0VtW74Y1zZ2U0DMy9Ki?=
 =?iso-8859-1?Q?GUHcSpX1XSg1ReFwxWpGClwRGKzFbDizftv8Q/2JhVi9EzARfDDbUuC5vn?=
 =?iso-8859-1?Q?kXXx5wCFzk?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34fa7738-bc12-45ec-cb62-08d98975c46d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 09:35:15.0857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/Cuo0JcfCmbzAaRXBbXAKUolqM9ecZz8slrfWr8OnKZWaiSg23IF45fZejYZNel2WxkgM1rwYrx+ZvxBM3qqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5627
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 7 October 2021 10:08:53 CEST Kalle Valo wrote:
> J=E9r=F4me Pouiller <jerome.pouiller@silabs.com> writes:
> > On Friday 1 October 2021 13:58:38 CEST Kalle Valo wrote:
> >> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> >>
> >> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >> >
> >> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >>
> >> [...]
> >>
> >> > +static int get_firmware(struct wfx_dev *wdev, u32 keyset_chip,
> >> > +                     const struct firmware **fw, int *file_offset)
> >> > +{
> >> > +     int keyset_file;
> >> > +     char filename[256];
> >> > +     const char *data;
> >> > +     int ret;
> >> > +
> >> > +     snprintf(filename, sizeof(filename), "%s_%02X.sec",
> >> > +              wdev->pdata.file_fw, keyset_chip);
> >> > +     ret =3D firmware_request_nowarn(fw, filename, wdev->dev);
> >> > +     if (ret) {
> >> > +             dev_info(wdev->dev, "can't load %s, falling back to %s=
.sec\n",
> >> > +                      filename, wdev->pdata.file_fw);
> >> > +             snprintf(filename, sizeof(filename), "%s.sec",
> >> > +                      wdev->pdata.file_fw);
> >> > +             ret =3D request_firmware(fw, filename, wdev->dev);
> >> > +             if (ret) {
> >> > +                     dev_err(wdev->dev, "can't load %s\n", filename=
);
> >> > +                     *fw =3D NULL;
> >> > +                     return ret;
> >> > +             }
> >> > +     }
> >>
> >> How is this firmware file loading supposed to work? If I'm reading the
> >> code right, the driver tries to load file "wfm_wf200_??.sec" but in
> >> linux-firmware the file is silabs/wfm_wf200_C0.sec:
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmwar=
e.git/tree/silabs
> >>
> >> That can't work automatically, unless I'm missing something of course.
> >
> > The firmware are signed. "C0" is the key used to sign this firmware. Th=
is
> > key must match with the key burned into the chip. Fortunately, the driv=
er
> > is able to read the key accepted by the chip and automatically choose t=
he
> > right firmware.
> >
> > We could imagine to add a attribute in the DT to choose the firmware to
> > load. However, it would be a pity to have to specify it manually wherea=
s
> > the driver is able to detect it automatically.
> >
> > Currently, the only possible key is C0. However, it exists some interna=
l
> > parts with other keys. In addition, it is theoretically possible to ask
> > to Silabs to burn parts with a specific key in order to improve securit=
y
> > of a product.
> >
> > Obviously, for now, this feature mainly exists for the Silabs firmware
> > developers who have to work with other keys.
>=20
> My point above was about the directory "silabs". If I read the code
> correctly, wfx driver tries to load "foo.bin" but in the linux-firmware
> file is "silabs/foo.bin". So the should also include directory name in
> the request and use "silabs/foo.bin".

Oh! Absolutely. I had never noticed my firmware was not in silabs/ on my
test setup.

[...]
--=20
J=E9r=F4me Pouiller


