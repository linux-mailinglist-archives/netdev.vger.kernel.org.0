Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD405344D04
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhCVRPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:15:22 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:27591
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230334AbhCVROq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 13:14:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIEbxZvXpolTN4bBFMLNK8gzO7yk31UTK2s3smkBOmsQvL2nS+T88qv5UZCQ+I36/a2sJ3Ed3K+jzX6lsD6Z2Ln6gjTkF4lM8Ml+CHTtIqVFuub+R2yygehmQRh6SrXX5vpARNx7naoVucEwl6wAgg+EAnUztOMFQHh8W9OpQZHmidQ0njpELSEgT5uvmq1vUW5L9Cx7w5ekRBgeBVLlcuRz8Qre/dJ5OpIN0KsAnRmoGMCsuxKZ0vx7PsZIkrgzyyaReWlk56Ob+YzrSKVv8K7EnKWkB9UBXSurJcKPOZXAZb/+atXwHiiMpvlVWsAigaxPNTjp8jqfCA9Lz9tIMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hst/YM/qPFiQ20GaPXW7z81quuvY+QfkKCzDv7OkUzs=;
 b=JJWNyTiMcWX48PNfsoU6PQrRxGY3nEtqd9+agznmJtE0u7F6Qw/rQpZw2MLjyW69CpICaXfqWgW9ayWW+SvsiUae0uGICzwDmo3wg77infaGCyhI/Tm5QbJTkPJWBR1vqhiVfaCWR0QgM7Gai2UakSWgwMqFqYrLBTzamd5uMVWnI7PQpql8x9Ny3hRB6eeR0/3HroAxKHFlarnxhQDzibPjY8EiZxSMikr6Fzo1XrEfmF3/64juQrlvMx35e5+xl6eC4UDzpo10EE/jO9FoTMQ2XgpEuUydhk5em9jCMgmdMffnkf1wdfh5A4Nt4ybNBlm9Ap4ACOWbaf2P/CwHVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hst/YM/qPFiQ20GaPXW7z81quuvY+QfkKCzDv7OkUzs=;
 b=fDKpMPrTf9Q1SSRaGKtfp49/ZxuZTRQcm4MWP9HABSJ7ChE3lNaXIDUwooBQQtCs+Y3jInzr7X2JbIPmJlnj9il9u8zofqtsxWOhLVlWEoAhV2/gVKjIFuuHko0WsPuu7H/RGsNFXVC6INmc4da8DhaEJsA0zSq32Az8TmOVFsc=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5114.namprd11.prod.outlook.com (2603:10b6:806:114::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 17:14:43 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::41bc:5ce:dfa0:9701%7]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 17:14:43 +0000
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
        Rob Herring <robh+dt@kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH v5 08/24] wfx: add bus_sdio.c
Date:   Mon, 22 Mar 2021 18:14:36 +0100
Message-ID: <4503971.bAhddQ8uqO@pc-42>
Organization: Silicon Labs
In-Reply-To: <CAPDyKFqJf=vUqpQg3suDCadKrFTkQWFTY_qp=+yDK=_Lu9gJGg@mail.gmail.com>
References: <20210315132501.441681-1-Jerome.Pouiller@silabs.com> <20210315132501.441681-9-Jerome.Pouiller@silabs.com> <CAPDyKFqJf=vUqpQg3suDCadKrFTkQWFTY_qp=+yDK=_Lu9gJGg@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-ClientProxiedBy: BL0PR0102CA0031.prod.exchangelabs.com
 (2603:10b6:207:18::44) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by BL0PR0102CA0031.prod.exchangelabs.com (2603:10b6:207:18::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 17:14:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 287acc7b-f23d-410c-5ec1-08d8ed55fc4f
X-MS-TrafficTypeDiagnostic: SA2PR11MB5114:
X-Microsoft-Antispam-PRVS: <SA2PR11MB51146055839C718D9A2C7BFA93659@SA2PR11MB5114.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/wZfVm4O9B6wpMOwPoTmA9umYTAL+XQLoXOIULZ/DvPzjbdvvyv5Y/gHzE0gs1dAiiDlx6GgUxBztZLBF3DgbfckgHgsdkcAsDnEafAlqlhJjc+Ld1RsvZ7OMsauWSurFD5+0Kb0xH6CvN67soofzqO6PIMNyDffsGQt6tRjpHRXqK+79D2cakNL9uDWxzaRg9IG3A7UBhi4bFUSQgg+W/HtUNv4vogudoLbTeUW5s+1GgRV+i7jViQQEePqF0ltMV/D6pOUyUqU5hPL95eA+j+wmbsoKZsD3jBm6R32HRxlRm5dpCCFUmNmG37NRLEFQeYK/TAHGajcxXD9v9xfKWZ//UAVSfYTVlWJAb18g8L7eV5mL/BK9UdKiLJy1FSW1/3FJW8EctLRxwMOUd5VGIdNLBi7jAKuioCFkH4wSqFSLJLkP2ESnMYOcPs5pWQRcpnFwC2cZ/eoUrTrA9iNQ/EwWZ9kch3QSmlMWOkvIIExoR9GrYMK9/MayHHTy8u8cUdACyUTUI3N1Ioz98NDbMohYLmD6RL0w5XOjcYJ8GAXg5WVBgBjA/ZFToEhJhktE+QhqxshHzQoGH65GYk/5SJYuIE0BhiJszNrhCszglqOHQG8Jby0SqeYwEanK6C3NrmTXKw/mKotjPZZrVmKEN1GxZoPLSqYX8f7JVSkQhV0j872vY7uCK+oJveIkIB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(39850400004)(396003)(346002)(6916009)(36916002)(6512007)(7416002)(478600001)(9686003)(6666004)(6486002)(5660300002)(52116002)(8676002)(4326008)(38100700001)(6506007)(2906002)(186003)(316002)(54906003)(66574015)(83380400001)(33716001)(8936002)(16526019)(66476007)(86362001)(66946007)(66556008)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?dus6qcuOBIE7CvCbfOyGS2QkrLKrI1LdJSW7ohdg5WKQrOowPgFtTOJrOV?=
 =?iso-8859-1?Q?XY+x4zh02lyBQh9/6UlIstoc28bgFw9wRbAYyFIj+5DkEggI7X4z73bGji?=
 =?iso-8859-1?Q?NP5bFx2aPyCTfvCnb9kxPRiZB6j1eKbxio8RNXGfckbQsrkUtxLpk0YQq0?=
 =?iso-8859-1?Q?W0XKn7u0TQt0NbM/Nvb8fNQRPUE9BsMy79clHCqfjko0nDMA6y29El5R/K?=
 =?iso-8859-1?Q?GNnf5aetZs835fhODUkT5aFf4EgYnZFhfnxnqQbq8oxqURy7tSpu41hPoE?=
 =?iso-8859-1?Q?e220k3DHSqiZp/IuWpNaIi4dQwKVn1OEJxtuLYWrZe7QHsb/6L/Go9OwIL?=
 =?iso-8859-1?Q?SzgOuF6SGIZhMvRHBRtUWeQu9EWO4JronMW55wd/JiijGARrkX6O1w5Mp+?=
 =?iso-8859-1?Q?Hy4gui1/SBWiUG9OFDKFD13QjQ4iwQAOHUIgujw7SKEn9VKv6u1ghAWsGK?=
 =?iso-8859-1?Q?zppUo+l8EeXncTQF7uQ+mKVW5Z5T/HT0q5lu9uC5GeJXgf2ucChDloZ86B?=
 =?iso-8859-1?Q?qKCnLL3IAP6xqhmBRwykKlSZoIxQfjR71a4XiUC6YShE9ZRMDz/QFuXDqQ?=
 =?iso-8859-1?Q?VhsQ3epZR4BFjLOdINta2SjCylsGYKCie0jwqrQGCZbKV8GoXraXagc8BZ?=
 =?iso-8859-1?Q?PytZ/NzyyOzQBT4ous9D9v1ME5mCpylTTy8OdL6aSyyda4gPDczaSg6k/p?=
 =?iso-8859-1?Q?ocHDDzK/FwP600p4fcTNUmhrqgisxCRbvZ+xeM4lR30Q9tQ9oZ/JzVP8xP?=
 =?iso-8859-1?Q?tNkOVsY+KCM+d8gMFEEdT751gBxz716XzDrak2iCsNtemcTswjDuIN1N/6?=
 =?iso-8859-1?Q?/MFKjN9i51NxFnXj7RcMrFgdAOXekq9/etF62Fjo4I6Si2L055DEXTc4bO?=
 =?iso-8859-1?Q?QubtgYFJtaIiLZyyzP8d8zgiax5Bg85OwbExS8YGHPm7mtPbMo150w+nBM?=
 =?iso-8859-1?Q?NgQb63DszfBtiUUCop9e7+QoxWYQTrD46wvKs/v/6wJkhQcUlh+yWGEMh7?=
 =?iso-8859-1?Q?a/VTwllA22PaYM/n0dclUT4JuHkMMCB9/807uwqa6tIiAANly4f8xXqS7D?=
 =?iso-8859-1?Q?CbjDUAy4LhztPS12OGI0gi+6uqZyFZfOsAzINGO8JaRRlTQoQ3HWkRqbuc?=
 =?iso-8859-1?Q?3VKucQRdNr5rAdVjnbKkUjDPJ5qYdyH3j6A8ctMsaq6BSC7JqCIVpHiU0d?=
 =?iso-8859-1?Q?yw5lXig1sQ6jUHCmu7IbVsEvjoNAoXjR4NZbtBH6B4FD6Dicm1MX+rMieo?=
 =?iso-8859-1?Q?aakaemhvsS8Uxz4lwdrzaR4ixor7b4qPTS+DlmA0leL6I2vJcg71Bo+qdF?=
 =?iso-8859-1?Q?eMPA8RGorwNyd68AQLdnsnEp4ag4yqHt5JmFcis786N3RO83Hc897exVRK?=
 =?iso-8859-1?Q?ykD9eRZvBqM61tTvb7hMAbTz+s9cwdyjOkRQiCcTrQrNrDF2OK2fEHSkfc?=
 =?iso-8859-1?Q?SJoPiRwMTOdu9n3V?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 287acc7b-f23d-410c-5ec1-08d8ed55fc4f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 17:14:43.6226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aKJvcqDCXBx6CPKPkqJLId1CXCPk/V4iboYBx+KE8Volyoc6x4aaxfRYI6Mw9Rl9nh/ZXEPZSUO8e3d7fSMllg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ulf,

On Monday 22 March 2021 13:20:35 CET Ulf Hansson wrote:
> On Mon, 15 Mar 2021 at 14:25, Jerome Pouiller
> <Jerome.Pouiller@silabs.com> wrote:
> >
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/net/wireless/silabs/wfx/bus_sdio.c | 259 +++++++++++++++++++++
> >  1 file changed, 259 insertions(+)
> >  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio.c
>=20
> [...]
>=20
> > +static const struct sdio_device_id wfx_sdio_ids[] =3D {
> > +       { SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF20=
0) },
> > +       { },
> > +};
> > +MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
> > +
> > +struct sdio_driver wfx_sdio_driver =3D {
> > +       .name =3D "wfx-sdio",
> > +       .id_table =3D wfx_sdio_ids,
> > +       .probe =3D wfx_sdio_probe,
> > +       .remove =3D wfx_sdio_remove,
> > +       .drv =3D {
> > +               .owner =3D THIS_MODULE,
> > +               .of_match_table =3D wfx_sdio_of_match,
>=20
> It's not mandatory to support power management, like system
> suspend/resume. However, as this looks like this is a driver for an
> embedded SDIO device, you probably want this.
>=20
> If that is the case, please assign the dev_pm_ops here and implement
> the ->suspend|resume() callbacks.

I have no platform to test suspend/resume, so I have only a
theoretical understanding of this subject.

I understanding is that with the current implementation, the
device will be powered off on suspend and then totally reset
(including reloading of the firmware) on resume. I am wrong?

This behavior sounds correct to me. You would expect something
more?=20


--=20
J=E9r=F4me Pouiller


