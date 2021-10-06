Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A15E424182
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238373AbhJFPo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:44:28 -0400
Received: from mail-bn8nam12on2070.outbound.protection.outlook.com ([40.107.237.70]:11617
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230014AbhJFPo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 11:44:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXE+7+fPdEeH0ft82BBrFjA10tyjlZOkq5mElfPUz2JMM/nwvdiSa/ATGpblHQ92SCkNk47EHsQ9RWn3xS+reGnviOKRJ9CQU51Ur+8ZPyzIoPgkH48Jbu1HEkJcnH3kghQihq8qL0EFkWx/3Ie0mIoujrdRAXLJ1lqoQqpl6EouTpNjv+jU31iNUKFG/nI/1kAZ74jbL3vh9DmjbPG7dclI9KU9jk487lbCGNA8eSMHZ0zPsd9ScMLg3iEd0LI/zZ/l5Xku8MVHTFjXLBywel/qATBCSs+D44Cf6LUi+pFJlVzGGCz254093oFcyefb3Gb+t7bbYLd+t+qfWBvuGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3O08tXLTo27ngpNbnQ38lXh/lzNsfRLmjjCRXbj2K5I=;
 b=MhI4O7/dPU0aH8VmajLg1smU6mnrt2U66Fsz+Lz4zJ//Q5ZMwmDmye2uPUTR9tl2eG/7lxTK7CR1Ll+1bWcoHmUeCihxj17ei6uzrORSAm4Pb3KRLOyTDUl4aiLNXFX3CHapx21oT4Ijx2Kacpa1MPB16B1NdThzV9GdrDoLj0WR3tOV8PZSUHlOApgsVbCtj3y/R+JWmAGhnOyZaXPnlD4vJitjydGa+MKD8aaI2q42YJOgKxUu8u0AnDozEGQCgkIs+7IfqM74x3sqEHpqp1+UjRvjJUO05zS1KFj9Euis20sEDd5Jmu2YEC2Nc98XeCoPyIl8EmX/wT8OX0Xw3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3O08tXLTo27ngpNbnQ38lXh/lzNsfRLmjjCRXbj2K5I=;
 b=M9z8rRJtXBWwrQ+3nkgz66OGBmAyPLKLuU8GsfFw9fZVsRwcRJxA3ZY1zsXUYrMiwj43Wc6hxs1uksjJk2uqSqJzeR6VpwHtOnJvxZWtFJ9K+jlVDfDrE7kqEssMIPZ8spes7Ig2A2NuLcNkbNANP/ygTUciXRjDDBr0naXosSI=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 6 Oct
 2021 15:42:33 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.023; Wed, 6 Oct 2021
 15:42:33 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v7 08/24] wfx: add bus_sdio.c
Date:   Wed, 06 Oct 2021 17:42:23 +0200
Message-ID: <4117481.h6P39bWmWk@pc-42>
Organization: Silicon Labs
In-Reply-To: <CAPDyKFr62Kykg3=9WiXAV8UToqjw8gj4t6bbM7pGQ+iGGQRLmg@mail.gmail.com>
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com> <149139701.nbvtKH4F0p@pc-42> <CAPDyKFr62Kykg3=9WiXAV8UToqjw8gj4t6bbM7pGQ+iGGQRLmg@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PAZP264CA0029.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:122::16) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PAZP264CA0029.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:122::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Wed, 6 Oct 2021 15:42:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cf1c139-9e0f-45ca-d685-08d988dfe9c7
X-MS-TrafficTypeDiagnostic: PH0PR11MB5626:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5626AD0F8527CBD43D871E7593B09@PH0PR11MB5626.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EElQZ+rQh4Vn81qBoNlKdgFXZjsFui4jpeb/CPulidLlFLkSpiAdw+SE/2bfP0gCSWjtbynP2ibThU2R7eNmJrKCJXRgdJGO57zGgwFsiwNG7rjJfSKRmEB2usmM66B0MnXq9uvzCZ1agqOJmIKdNs2F8ShvOrGl4tH01wmcKrO3J7KnY8AAh1dgffA8h7nW3AqqAbeGuF04d45xtW01W8YW82TTP4UWb5kTSD7VJhkEIuJAcGgqFhSEydpegpL3V0R2XXOepSn915LlAZO39WqWaL88jCefghMUYusNDbzlwQltQBzjOKk74LW7Skk988ipblwP5whHX7cjJO0BMtesQW4mrurAZCN7HAUtVbbIGjnKLcMY1maq+fEWZge/RdrTaw8m6v/R+dcF3jthE2sn3m1fiaLpu//4mLUEc+s92C6XhCxqBqXzyjPXBK8xQep2ckkcYBOY+Wt/1l1fmY7KOWpIdkrXBPwAUXS2Ls4mUduitc+TIwk7FaD4k5tdMP/K8YlOyZme4r9PgKAggsABz4uL8uSFMeWgZzL+zOBpCBCgVJYlVQoLUm1ErIYOhmy/A9piQI5kd/MZTU96x9mILIr3BnIkRPdCPFL4GEVwC++hdgF8G3/p6JWARdZt1hdhhjf88P1Aeq+kTf17+GfUCyHTjQyKlfqVFI/64sProMcX2uWsHltvxnHDX6wXK1nnXs+36ToKNbGSxQgykPhTYicI5wmoNiJQRSRGm9XARPqx29x9kA9ZPfvydfjak/EGV5freZrGfZPLKXCQEQPICdCvN8pcXjLAfKIixPGT/gNqqCQS83wqRAiKtVop
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(6916009)(966005)(186003)(6666004)(2906002)(508600001)(86362001)(83380400001)(7416002)(66556008)(8936002)(66476007)(6506007)(33716001)(26005)(38100700002)(38350700002)(9686003)(6486002)(8676002)(54906003)(316002)(4326008)(66946007)(52116002)(36916002)(6512007)(5660300002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?al/cJ5AOd/FNXRx+OtVkoZbkNBidD9w4eytM7u1Elp2ROFsGo+vYjSr6w2?=
 =?iso-8859-1?Q?tfBH/SJZq3a4dp41qFtX9tGo79KElWRBQS6l9Z51CXRLxhoGD6Q0+rJ288?=
 =?iso-8859-1?Q?5uBPaWiOk7IIoV9H1OWn1hpL+IZakLi0gTItbsfZbjvYYdgtn9QlOoy1n3?=
 =?iso-8859-1?Q?UWnSRdOnsdNz7hYO6U0zeHfe6vzzx+ztu4ibwtLa/mTcmzxdGaCeSeInw1?=
 =?iso-8859-1?Q?knWvNUcHliBfs4V8A8fVuPuT2wx8NWikfjdlL4fJB3V2CV0RPqDwS/v2NO?=
 =?iso-8859-1?Q?q7vEjfYJZWE4A4iWk+Gfb06XZ8gJLaIDtvXSuTPb+aaD9In1vJZzFdbHYU?=
 =?iso-8859-1?Q?+I2WC6Eg1SJkH8EBg3ZFA/QxKHl05oxUuXUf5G+uU3jKIV7hYMkDD+zeDh?=
 =?iso-8859-1?Q?0bR79bz/pvJNAq7bAHhXaSpCRloPGB8Y8nnFd84dYjRwvyyjZpIOdXOLOM?=
 =?iso-8859-1?Q?o7ni2TaUHN3lcugmV78xQvITtXPXl6Jx5YxOj0Na3FzyokNOmL+5HotM+Q?=
 =?iso-8859-1?Q?u7UkPy25rGUfjMfDdL0RwD30r16BUquiGzWIO+eiK1hrN8NRWMUi3ues7U?=
 =?iso-8859-1?Q?Mj7fZq7mNOdd4eFAL2swOhMnuVKw+uJIJ8T/9Iy43zHX3dctdKTRNa+a38?=
 =?iso-8859-1?Q?7TfsuR23WOaDp4T9LB4i267jD3WBY8HQFnbOuPuL1+evFa2ZR4mJ3HyQ4w?=
 =?iso-8859-1?Q?0WzBzaeaJP4aW3WSjhSBrniH65u90LNXgC8pU2vyS4tZ19BT9uw66tPx+J?=
 =?iso-8859-1?Q?8AHyf1VOG6XqP27hNN1Kd9QBz2hjli5fGcUAKuC/KrVAvQ581g7vsicEGc?=
 =?iso-8859-1?Q?qIUBy/yClyxGP02CdVj0PhtMVbRPR5FhxGb8OkCvCAusrgQHJR2VECv0hy?=
 =?iso-8859-1?Q?6II9Pd6J59Sloctz1RKyKPvuVZl7E+YwJg0OO5DOj4lI6zuVT3/8QILlZW?=
 =?iso-8859-1?Q?XMktzRZEBGuaF30xLy37tn6F7/Aq2/C3I/xQItQKysk3ganqnShQUCIE6b?=
 =?iso-8859-1?Q?f7OxA2zelwI+e9Mgcjen1Kqzjbd7wtiRxl6/uiNzss5MUKVtiAjOylMiAx?=
 =?iso-8859-1?Q?OehdwNJcTHRUs1Ost88DiazodkheiVRDb8Pep4qnF0eq92fXhLkl146pBA?=
 =?iso-8859-1?Q?qsngEsWcO0KF15ks+XkosAgQqdhenwMk/idKFyNcq74LxjxABUnkdH7tFj?=
 =?iso-8859-1?Q?Lx0EFw4wfe67OEVawcTerV2shLv28juXeld+IU6XiIaDfiAUj+4AfcFgx0?=
 =?iso-8859-1?Q?nCZCZnFIHrPDisPMTW6pNarFpZ6yjWVZjIl8jaUXfP7amZbKvohncz1yFh?=
 =?iso-8859-1?Q?WLR2rOmvBuP3vyD8ZVI05/SdgyB08oe7tnXVXNvMYMypt2484Y3dLKb0dv?=
 =?iso-8859-1?Q?aURPWaTyuV?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf1c139-9e0f-45ca-d685-08d988dfe9c7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 15:42:33.3447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qflpWpE7DdUezm5mnOM0rhhFnObuj9Vny3WO+o+uZKauk6F5BMgqbf1zsvTOeD3TcvgmwdN31X/kDyNOy4aejQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5626
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 6 October 2021 17:02:07 CEST Ulf Hansson wrote:
> On Tue, 5 Oct 2021 at 10:14, J=E9r=F4me Pouiller <jerome.pouiller@silabs.=
com> wrote:
> > On Friday 1 October 2021 17:23:16 CEST Ulf Hansson wrote:
> > > On Thu, 30 Sept 2021 at 19:06, Pali Roh=E1r <pali@kernel.org> wrote:
> > > > On Thursday 30 September 2021 18:51:09 J=E9r=F4me Pouiller wrote:
> > > > > On Thursday 30 September 2021 12:07:55 CEST Ulf Hansson wrote:
> > > > > > On Mon, 20 Sept 2021 at 18:12, Jerome Pouiller
> > > > > > <Jerome.Pouiller@silabs.com> wrote:
> > > > > > >
> > > > > > > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > > > > > >
> > > > > > > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.co=
m>
> > > > > > > ---
> > > > > > >  drivers/net/wireless/silabs/wfx/bus_sdio.c | 261 +++++++++++=
++++++++++
> > > > > > >  1 file changed, 261 insertions(+)
> > > > > > >  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio.=
c
> > > > > > >
> > > > > > > diff --git a/drivers/net/wireless/silabs/wfx/bus_sdio.c b/dri=
vers/net/wireless/silabs/wfx/bus_sdio.c
> > > > > >
> > > > > > [...]
> > > > > >
> > > > > > > +
> > > > > > > +static int wfx_sdio_probe(struct sdio_func *func,
> > > > > > > +                         const struct sdio_device_id *id)
> > > > > > > +{
> > > > > > > +       struct device_node *np =3D func->dev.of_node;
> > > > > > > +       struct wfx_sdio_priv *bus;
> > > > > > > +       int ret;
> > > > > > > +
> > > > > > > +       if (func->num !=3D 1) {
> > > > > > > +               dev_err(&func->dev, "SDIO function number is =
%d while it should always be 1 (unsupported chip?)\n",
> > > > > > > +                       func->num);
> > > > > > > +               return -ENODEV;
> > > > > > > +       }
> > > > > > > +
> > > > > > > +       bus =3D devm_kzalloc(&func->dev, sizeof(*bus), GFP_KE=
RNEL);
> > > > > > > +       if (!bus)
> > > > > > > +               return -ENOMEM;
> > > > > > > +
> > > > > > > +       if (!np || !of_match_node(wfx_sdio_of_match, np)) {
> > > > > > > +               dev_warn(&func->dev, "no compatible device fo=
und in DT\n");
> > > > > > > +               return -ENODEV;
> > > > > > > +       }
> > > > > > > +
> > > > > > > +       bus->func =3D func;
> > > > > > > +       bus->of_irq =3D irq_of_parse_and_map(np, 0);
> > > > > > > +       sdio_set_drvdata(func, bus);
> > > > > > > +       func->card->quirks |=3D MMC_QUIRK_LENIENT_FN0 |
> > > > > > > +                             MMC_QUIRK_BLKSZ_FOR_BYTE_MODE |
> > > > > > > +                             MMC_QUIRK_BROKEN_BYTE_MODE_512;
> > > > > >
> > > > > > I would rather see that you add an SDIO_FIXUP for the SDIO card=
, to
> > > > > > the sdio_fixup_methods[], in drivers/mmc/core/quirks.h, instead=
 of
> > > > > > this.
> > > > >
> > > > > In the current patch, these quirks are applied only if the device=
 appears
> > > > > in the device tree (see the condition above). If I implement them=
 in
> > > > > drivers/mmc/core/quirks.h they will be applied as soon as the dev=
ice is
> > > > > detected. Is it what we want?
> > > > >
> > > > > Note: we already have had a discussion about the strange VID/PID =
declared
> > > > > by this device:
> > > > >   https://www.spinics.net/lists/netdev/msg692577.html
> > > >
> > > > Yes, vendor id 0x0000 is invalid per SDIO spec. So based on this ve=
ndor
> > > > id, it is not possible to write any quirk in mmc/sdio generic code.
> > > >
> > > > Ulf, but maybe it could be possible to write quirk based on OF
> > > > compatible string?
> > >
> > > Yes, that would be better in my opinion.
> > >
> > > We already have DT bindings to describe embedded SDIO cards (a subnod=
e
> > > to the mmc controller node), so we should be able to extend that I
> > > think.
> >
> > So, this feature does not yet exist? Do you consider it is a blocker fo=
r
> > the current patch?
>=20
> Yes, sorry. I think we should avoid unnecessary hacks in SDIO func
> drivers, especially those that deserve to be fixed in the mmc core.
>=20
> Moreover, we already support the similar thing for eMMC cards, plus
> that most parts are already done for SDIO too.
>=20
> >
> > To be honest, I don't really want to take over this change in mmc/core.
>=20
> I understand. Allow me a couple of days, then I can post a patch to
> help you out.

Great! Thank you. I apologize for the extra work due to this invalid
vendor id.

--=20
J=E9r=F4me Pouiller


