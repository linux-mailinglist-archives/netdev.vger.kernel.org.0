Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D9A3DDB0E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbhHBO3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:29:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24046 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233985AbhHBO3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 10:29:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 172EEpSM014248;
        Mon, 2 Aug 2021 07:29:31 -0700
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a62652mjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Aug 2021 07:29:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mn6GWmTojoMuVXU2IVVuglIkNfodbqfo7/2YQVSZCCrGjK9fCWKhh3czlQYGaq7Ij0RCEfX/cb84CqkXxMOEMyaX70OCAkZWzWBdwTJaFmTcSzTqg8Vt4Shr401WfEID40BzYkFhxglaLCmQX3mIpqUvAPMtmOe0QlBP+MgLeDJLEX+YQ5bZfLwZujaY3dkOakqajIIqpK91uS+Q10X7vTMuR52fcXAK21t3Zb/VMKc6XqT18AOXQlY8CxlK7l0wScaSEAtAp6oMuVCOKTx8gjaAqRs6GlL3lVoDhms7chJ5HUqlH8zAlHJi5Q9rRF7q8m/QXJT4VLnBuR9iaxYELg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfrCdvSUqJjQfxX/HuRzUq8L2pDt+t2GaIByIu/qAwk=;
 b=EeMofercIk02dAaq4ppE66b6ZGn/vNjpha32T9DGHFB0YkVDcT76zGV75KytXG77DUO4C0N0N6zUWmFbQpmEn1tGb1aa2okWv5VHh1pVzgU6CTChtV12LuZdLSByHnEFatEvzNmkM7R8yrI8vEJVdLLcaSHXgAr75jrVUd1QToGwXl+2/QtjGPYovIiwoO8DTO7mLSFr5t6sKnUOl2a6YP2xDkx9xJZ5HA8SmDwY8QGfwrGFoBLkG8VhHjEdUkWiYHrkGeFAaXO/lw648GkPAZlQ1NezvBc1UDHD3uAsUM7sUvv4j9BG/ToLCTlknmZIjy3XZf2rcGrFOOfRAbsYWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfrCdvSUqJjQfxX/HuRzUq8L2pDt+t2GaIByIu/qAwk=;
 b=V1zZWIAfjA5906sO9M1X9KAcKdIa+a2RnGPdcohArsru7HpXKAtDtSy9irGfgN7z3O/u1gwUyDo5sVvJRa5jUhPHtPL3VXhXSmbmjAK/NPLovhyS5gwJ06v8DwWnBk2XnsvXx2EwzipKX31eaUdVzhPqAHNAEBSlQzhmuhTQ/RM=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BYAPR18MB2550.namprd18.prod.outlook.com (2603:10b6:a03:138::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Mon, 2 Aug
 2021 14:29:29 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::6513:d2ca:d44a:537c]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::6513:d2ca:d44a:537c%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 14:29:29 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Kees Cook <keescook@chromium.org>
CC:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: Re: [PATCH 42/64] net: qede: Use memset_after() for counters
Thread-Topic: [PATCH 42/64] net: qede: Use memset_after() for counters
Thread-Index: AdeGtkLsSvL2o+KDTzKodUmtpqlAUA==
Date:   Mon, 2 Aug 2021 14:29:28 +0000
Message-ID: <SJ0PR18MB3882DC88DB04C9DE68678CEDCCEF9@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4671518c-feb1-4064-8873-08d955c1efd4
x-ms-traffictypediagnostic: BYAPR18MB2550:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB25500E156F81C2FEE992AC5FCCEF9@BYAPR18MB2550.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4nKMtFfm6q75L022wx5/+fODlplahXWLRHW1OAyZ860p70iUbShyJ2thZvaSMBEufN8s/OWfKH+RKSoExCqJemQB4jPD+GLDMu9npwQIWGlbZFUfG7Of1CptJgx0Sin25jTfbFQaL20za672esZKSoH1KJKim3rvzo2kg7UHYqn6NaJ3UOuTfEfvUAgV/1UH2YhvC6UWIpoftVPCXFWmhcqrBluu7yQfo9p2/Wsed50faUNYWvOPb7qjro3hrYosgGFOSXZT6MLerLWAxvbUyNDtTBxLjjvg8dAmZjDojWXVrnHvwP+NZbmQnykyhhbYknq9l5GEMdtZFrzS/p3cDCr555PlG1ZL++NQHnWz7pKF3GiypwCVl4BbPARfW1C7gN/8dS/Rk+pKkVHstthZJxalew9MVxxFSZAqrH1Lbtk9Rd5ebd08Z9QrZ1760jK04UQLjNtYW88L5TbW6KHnqA3e/Qh5V4EU/BjNgNuft9a+yF4LUtrGz85V5j65psGOMLAkOb5LNWQvckP97QN+8NdILhRPo91VwKVlSO+ZmH/C1YqNwqYtAHn8APFXk99Y68xQW2up8C+5iTMyyKJk6zwirNE8mSa5Pc2W04PcrhArFCKW+WqdtKyG/xv7HQc0tIWnquXFaGD0zoFqrNU7b7ppqKWgKNsikzv/UkqSL0Yh8MCnVsh5ISGu6k6fHub442pf4vGzcw2Wmdmj2Cbg5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(186003)(83380400001)(86362001)(6916009)(38070700005)(26005)(7696005)(52536014)(7416002)(6506007)(107886003)(316002)(122000001)(38100700002)(8676002)(478600001)(8936002)(2906002)(71200400001)(64756008)(54906003)(55016002)(33656002)(76116006)(5660300002)(66476007)(66446008)(66556008)(9686003)(4326008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r36pt96gPfq2TWMhN6i6otGo9BCYDdrX9XhTdJ14F9NS9hNULE9dbz/8YvGM?=
 =?us-ascii?Q?CfkP8eb7K6I22nAVfkrYUSQnUanOfd0ynfbWSn7tscEEM36YOzF20ov9csij?=
 =?us-ascii?Q?jS/9msypDCduALT1mINwKviq4w4ESLIN0Jho2+rtdHA4J7wRWC7tvYHcLvUd?=
 =?us-ascii?Q?iKfGD0tYfs8nvZIJYesWdb2Ds4xnkYVLLaIHzaLEBJ7UaPnPl0rh5nE5rzi3?=
 =?us-ascii?Q?9AkMImGiw2m9WJyMNeS7EC7uhb0hHYcmCCIMVsokRFYOJFASUhVMYtsXOV56?=
 =?us-ascii?Q?MSq7yRjlH9zvSXwdkehG7pQOQ+MIBxqJlZrxD4HqTOfUMVs4G8kurQYykUQ1?=
 =?us-ascii?Q?rjVIE2dhc44GhX4XEoHsP08Tg2woJ0B2YgHkGP92NbQKn/+rCBzBAwNWP89D?=
 =?us-ascii?Q?vXrDklHctzsbF71MFQiLKGCMpWUlWHZX3rZZdDzJCMWJsBWWcUWm+4M1NXix?=
 =?us-ascii?Q?OAsCUGKp/0JtbYtDKoAFUm4KmR+jfdzKlzn7ujOv5k6DiOoeAFl3lDzYyy7i?=
 =?us-ascii?Q?4XM3f0CdlibPaYjnSSjk8oxLpdlVl0h4iU2qM4rjHyuSDIsWeCMKO213kGAm?=
 =?us-ascii?Q?FbIZRo+4iaqqVOGhz4HGVQsWVohjG9MuagXtCxbFuW1/9ixwNgCVz2i9GLok?=
 =?us-ascii?Q?ivKulGa7F6OhKzCbikzuI1vGROYzOmB84JsYDx9/mSVQG6iE6qeFSxEtsuYg?=
 =?us-ascii?Q?UHgj5bDXetEdpvR8InJmwzLr1b18bKETlbP7queg9t92uqRLNryzC6q9wrLc?=
 =?us-ascii?Q?3xAivZ6WiftIva94sin1LJZ7paPjGKDVKAgcZDFZdPVndaTe6e7GV7+AiX2r?=
 =?us-ascii?Q?KppxfVVX3Sc8J570A2Cc4YEAu3Slvw3V1JSNbcqxUZcxjxZ5mKXVxDw48VOW?=
 =?us-ascii?Q?Kcg1lLRLRgDJ2hzEo/iF/ZEqJ0nk1IReSOuOrdG/aetVu6VL9rOxAaCeu+BT?=
 =?us-ascii?Q?iCXA8DI/PHrdr1vNlZgpo7XhLBe/jhZeibydKQOex0/4IdpMZAmI8F8aUBYi?=
 =?us-ascii?Q?jz4pHanP5XJGbehc5x6gE9B88F4s7n8I/UsvKqcBbpxbkUyh3dXKgkvpu7Ax?=
 =?us-ascii?Q?s2BhhpC8/v0rPAn8Vr6PDmByofl3I2i6thbRpeicmL7n22LWWlDs6Lto/TZV?=
 =?us-ascii?Q?w688OiRi90CQlPXQCUsa+5C6NnT7GFFIf0N0M8Fjks3h147O/gwVsXeMWCQO?=
 =?us-ascii?Q?2XyArz6SoOia0ubB5JF1FovWD9OE8oUJxewNgeus9mws8DgKxcHK3l51/aUU?=
 =?us-ascii?Q?v3Ax+1GTD5H/WuxDse/+B2FFfHh8yaoWaW5bGSZJHGndnqWctef6/P+E1iis?=
 =?us-ascii?Q?ia4fDZKrCCoLttkdtJMvvTUa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4671518c-feb1-4064-8873-08d955c1efd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 14:29:28.8058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ivd18q5DnoheZEfOxS0dSHg0KLsScH+1yRYI2vpqQlJG9hz5rOnxqrwQhh01VneSHF1PPzRHa4nGDZUIPrICyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2550
X-Proofpoint-ORIG-GUID: ox9cV0OtkKJSABP7NaYpoBN3ml4Voeoj
X-Proofpoint-GUID: ox9cV0OtkKJSABP7NaYpoBN3ml4Voeoj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-02_05:2021-08-02,2021-08-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, Jul 31, 2021 at 07:07:00PM -0300, Kees Cook wrote:
> On Tue, Jul 27, 2021 at 01:58:33PM -0700, Kees Cook wrote:
> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > field bounds checking for memset(), avoid intentionally writing across
> > neighboring fields.
> >
> > Use memset_after() so memset() doesn't get confused about writing
> > beyond the destination member that is intended to be the starting point
> > of zeroing through the end of the struct.
> >
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > The old code seems to be doing the wrong thing: starting from not the
> > first member, but sized for the whole struct. Which is correct?
>=20
> Quick ping on this question.
>=20
> The old code seems to be doing the wrong thing: it starts from the second
> member and writes beyond int_info, clobbering qede_lock:

Thanks for highlighting the problem, but actually, the memset is redundant.
We will remove it so the change will not be needed.

>=20
> struct qede_dev {
>         ...
>         struct qed_int_info             int_info;
>=20
>         /* Smaller private variant of the RTNL lock */
>         struct mutex                    qede_lock;
>         ...
>=20
>=20
> struct qed_int_info {
>         struct msix_entry       *msix;
>         u8                      msix_cnt;
>=20
>         /* This should be updated by the protocol driver */
>         u8                      used_cnt;
> };
>=20
> Should this also clear the "msix" member, or should this not write
> beyond int_info? This patch does the latter.

It should clear only the msix_cnt, no need to clear the entire=20
qed_int_info structure.

>=20
> -Kees
>=20
> > ---
> >  drivers/net/ethernet/qlogic/qede/qede_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c
> b/drivers/net/ethernet/qlogic/qede/qede_main.c
> > index 01ac1e93d27a..309dfe8c94fb 100644
> > --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> > +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> > @@ -2419,7 +2419,7 @@ static int qede_load(struct qede_dev *edev, enum
> qede_load_mode mode,
> >  	goto out;
> >  err4:
> >  	qede_sync_free_irqs(edev);
> > -	memset(&edev->int_info.msix_cnt, 0, sizeof(struct qed_int_info));
> > +	memset_after(&edev->int_info, 0, msix);

We will replace the redundant memset with:
edev->int_info.msix_cnt =3D 0;=20

> >  err3:
> >  	qede_napi_disable_remove(edev);
> >  err2:
> > --
> > 2.30.2
> >
>=20
> --
> Kees Cook
