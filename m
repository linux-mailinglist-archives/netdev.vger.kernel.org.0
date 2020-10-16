Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02282904D4
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 14:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407318AbgJPMQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 08:16:52 -0400
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:39961
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404860AbgJPMQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 08:16:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ii7Ry/ANrG0cAiMolsZXE5BQj9jgPDY7PqjJeeRXiRMVdiMC1uVDF/cKHbMHb3PtdDFY9eToqYNPaxLWjGwVJWfHye0cvGTD52Au5+8lH1ziUJS2TRs097KJZ9qqM1IUXBwL85FDIc8kWpqyXnh7dqTJBuA+Pk01C+dbB4iZ6RCKyG0Q1cwShLYW48sAFTyTHq6YSYAo15mYS+EiJY3hdQkmKFv65ztnT2l9+/xvCOiO49YuP/4WyNyXJq+VJ1UQNib/HoqVqo3UB5pTNSHuUbq5fmyURyBr5EiFEyFWjSweTRgPivCgs9C5VtCHmJbQ1tEwxOlQ/ylRxvdBiO/huA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjLzVHhASSbFURlfnPTPPZoHp5YzonUfkjcaMt+meE4=;
 b=AjzLo1YXVaFIHu2D3pkHMZxeVzileteH4727ySwjrRNEwLKOPE54l1N3WOijBgj8854OtPS+2FiM3OlT227LBeALuSboQHO2knTE7vUw0wixhMVB1L5pdSWLFbip3ubj0Q2gCi96AZGUGzuAe/LkO95ZayXn6A7UdBRHWxrzA/Wb/5lN88NOaRMhH8k30kKuWnMrlpBQ9xfgHTTYL5SOKei9imzPmi46ceoMudRcdyQCEReK5O5eSi+GQTbXZyS5JUR1T/d6ZaAdAQb0xvJtICB1tgfRzw1iauip3qwo7iXI33zMw7nbu+8Dj4Y8hGkTxVvAvW3/p2ot6oPryAAzYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjLzVHhASSbFURlfnPTPPZoHp5YzonUfkjcaMt+meE4=;
 b=hrjGP0ouKjaVee872Q/ZqVj/EIhqLSHEJeg0jiq0qomg3MexTOArvL+Z6HQOVdw+u1hEa6CzyJrsDhOVXuImShp6P9VLqTE6Ff3MmYlugN22SZm0r0XnD+BkDpdSe+RmOqQZOiZ15U8oJkVP4cWgEqsgnmUwAWLuvx60zeNDHo0=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2654.namprd11.prod.outlook.com (2603:10b6:805:54::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Fri, 16 Oct
 2020 12:16:48 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.031; Fri, 16 Oct 2020
 12:16:48 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 07/23] wfx: add bus_sdio.c
Date:   Fri, 16 Oct 2020 14:16:43 +0200
Message-ID: <2769264.q6GNP55evR@pc-42>
Organization: Silicon Labs
In-Reply-To: <CAPDyKFpP6xBru79Xh2oe=J8HWO3uk1VpcMzEiG6X7WX-AOvgkA@mail.gmail.com>
References: <20201012104648.985256-1-Jerome.Pouiller@silabs.com> <20201012104648.985256-8-Jerome.Pouiller@silabs.com> <CAPDyKFpP6xBru79Xh2oe=J8HWO3uk1VpcMzEiG6X7WX-AOvgkA@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SN4PR0501CA0008.namprd05.prod.outlook.com
 (2603:10b6:803:40::21) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by SN4PR0501CA0008.namprd05.prod.outlook.com (2603:10b6:803:40::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.7 via Frontend Transport; Fri, 16 Oct 2020 12:16:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51d3f556-4ee2-4f69-f375-08d871cd5ae7
X-MS-TrafficTypeDiagnostic: SN6PR11MB2654:
X-Microsoft-Antispam-PRVS: <SN6PR11MB2654D7BB096FE2524E067E0893030@SN6PR11MB2654.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xPYooIvud6uGGXOvIwioHc+ET2KL4+cgbmMdX0L5+5jtWbauBdUodTAWquDMWJT/exELRzBTDXaBkyoAuP1OEJDXX3aU+gq5qd+hXQMPwpunXa8hbwn/CN5ZqiFxh/waXIjbRL4F5AAMq8UzHXc1pE5/K4X12Nx0cTdjtapVTXwfpapFHBxBeawQSBU2Bl3+Oo8v4AxdFXtwVE668conCDpSG/wvVLMtlMQZze9G2HVLM7bG+YRjemu53JoMwDu6WiXkdZXSs0eDavbx+Ot6XaRtxPyzhYnpTU8KcsXLU0MFJ68MyuBvN+rOQNEUfJjiGVWBFzumg27qm3bEn9H7b37ibfWQOabmCOHO0/6aNMYdlqc5+0SQ9JA4GxSFzQLL9T7ytDIlnqBa0DWrkT7pcsyPfVdJw2Vx0ybFnfUhqALA/7x5hqCuDs+kOQt7VgmqinA8CxQCdluekspZ3/ssxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39850400004)(136003)(346002)(376002)(66574015)(7416002)(66556008)(2906002)(66946007)(66476007)(33716001)(86362001)(6506007)(52116002)(966005)(83380400001)(5660300002)(956004)(6666004)(316002)(54906003)(6512007)(16526019)(6916009)(4326008)(8936002)(6486002)(36916002)(478600001)(9686003)(8676002)(186003)(26005)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: E4VSLrls2NaUo+OUmr/uF+neqKYQk7rQP7A9udPwhXBXM9lI78pRIKhUebgFygN9faby8QP991AlxtKan0dYov1S/nb7+O5xJUbiwdQHt935Ms09c17NehtzfxxuCBhXM+fGaxplCtDiUaNy4oTnUCjQwMdg3Y4iVPtvRitHvGtIRnqXs5s9iJOwGb40fli2UZ0Dgu3zSb2vVQTFPA96OYJYlFi8GB7VfOmEGDmpRayklCfkiZgiVc6O9Fs0OReCKCUpTd98OjzgMFn6hTqtENa23OL1pXlk6UsO7+mFRj9J2zi8SLRPBZD/p2OLhqXj1Zis3mYlArZ9OP5Zhm56tvhy31PiI6aOJTi5BuHXQKblg7sS14Wo8d4uHxWC2iSqVDqvr2rHJjYlRsqmuHHZppUEgRE92Ev1rH9EHFRKDHPX+qPKi+G98ejPJP0GqNuSMrY4S/ZpLvmeuoIanC3rnWi3j6NhEIal1saUnVAp8H9/lwmLDKMmkwEFdaQqS6M6fgVjVgXhT1QpdDVj1jAkaySGv2BoQOfQshmA9xalIASyDB2Ie8iL46dRA9MW/hx1gQkDlUfZXCMUBgY7tqZKtRD8qxZKNVg3H3DMFyHFoOfFhZ8riF3v41kLjqzByHf5jCGf4OGPyLBzXxN0eo6dNg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51d3f556-4ee2-4f69-f375-08d871cd5ae7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 12:16:48.6266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9XakUjjPyQc2fqU6VtXlE0qIZkuBT5mZBmBFx+QFvv33hDwFtumC55cMTa3mc9jUYIzBjAniHvuskDm2zpo1hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2654
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ulf,

On Friday 16 October 2020 13:30:30 CEST Ulf Hansson wrote:
> On Mon, 12 Oct 2020 at 12:47, Jerome Pouiller
> <Jerome.Pouiller@silabs.com> wrote:
> >
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
>=20
> Please fill out this commit message to explain a bit more about the
> patch and the HW it enables support for.

This patch belongs to a series[1] that will squashed before to be
committed (Kalle Valo prefer to process like that for this review). So,
I didn't bother to write real commit messages. For the v2, I will take
care to add linux-mmc in copy of the whole series.

[1] https://lore.kernel.org/lkml/20201012104648.985256-1-Jerome.Pouiller@si=
labs.com/


> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/net/wireless/silabs/wfx/bus_sdio.c | 269 +++++++++++++++++++++
> >  1 file changed, 269 insertions(+)
> >  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio.c
> >
> > diff --git a/drivers/net/wireless/silabs/wfx/bus_sdio.c b/drivers/net/w=
ireless/silabs/wfx/bus_sdio.c
> > new file mode 100644
> > index 000000000000..e06d7e1ebe9c
[...]
> > +struct sdio_driver wfx_sdio_driver =3D {
> > +       .name =3D "wfx-sdio",
> > +       .id_table =3D wfx_sdio_ids,
> > +       .probe =3D wfx_sdio_probe,
> > +       .remove =3D wfx_sdio_remove,
> > +       .drv =3D {
> > +               .owner =3D THIS_MODULE,
> > +               .of_match_table =3D wfx_sdio_of_match,
> > +       }
> > +};
>=20
> I couldn't find where you call sdio_register|unregister_driver(), but
> maybe that's done from another patch in series?

Indeed, it is here[2].

[2] https://lore.kernel.org/lkml/20201012104648.985256-5-Jerome.Pouiller@si=
labs.com/


--=20
J=E9r=F4me Pouiller


