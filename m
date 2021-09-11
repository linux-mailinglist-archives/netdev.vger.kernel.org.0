Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C033C407860
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 15:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbhIKNhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 09:37:23 -0400
Received: from mail-oln040093003006.outbound.protection.outlook.com ([40.93.3.6]:35320
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235887AbhIKNhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 09:37:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrPla8g/HRqLHX9cD7wudZVHL8yFMqd1LjYwH+QQEun5a68i3zabGGfDAlnl6uqBjla+yGekOrHJXTApoEnSc0NC6DlFcPUH5NnjWEMYVOaSxQHw4TR1RTmZOsdIUH6RYobxaDLIVFzlstPZLtpM2zXkBZPAwnYo99kvGTOjblePNfQ38K34b6HsJpd1PVLTQK5WVfB4HRwO4iAj9MvUcfF8z7Vn7UdJvo5OKitre3QxUz5BzwEWCHtLJ0PWmZnON4CZtTDMKIAXstvVH+YV+8MhQqr+egrkSFS8M1ehEDw+C7K2IsqnkS5L8jBb0ghXtdiHhGFTmssyu6CuV5oQ5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=i+v8Yg+25mxUZwJ7xWN6N01ifH7cvgA8tc03RplZQqE=;
 b=BqnEyF0qjkt1tdfUQ5xQGHpX+bWVL+3J00EOWqYclezfnyeLDxAQRQXHqd7nC3xQ50MzZIVMan7oXluCoh4HTJo0QtnR8EyAhgkwWVj7Ci/AShyzF8zvhRIDgjnpMf1oMWiWf9ol163MChaTHRHjprTwIBXk8QOKPxd99ubLYhmCQRbHgJoE24nAPYeOC40ruKEuIR2JjF/YxUm+KFDuKl669/Zn7+QoTY+nawURcYKDGlLXT0c0Z/Kbz/8/r2U4H81/IcMgyLhuhYi41pHYaKfUF0qXBZzC1SD6++5U8dTBsz/m/Ab8866Fka2B8Lx9vHJGUW9aP0F3z9bPpJVglw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+v8Yg+25mxUZwJ7xWN6N01ifH7cvgA8tc03RplZQqE=;
 b=W+8KaDkEGlMt9vxk4LmdAHDHXSYcu29eKgGIQb39YDYTRdbi5htmi0wM/cxdM5sowN8cGtc0mnPmC7ceT7K309hYli5UNBbL5NpGiOTWz0nZi6zdtn5kRs9FmPsapKdeYqOOOnKL4AubKXd2OF4nnRd8bAdqlinIXdUSfZKjc1I=
Received: from MN2PR21MB1295.namprd21.prod.outlook.com (2603:10b6:208:3e::25)
 by MN2PR21MB1439.namprd21.prod.outlook.com (2603:10b6:208:20a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.1; Sat, 11 Sep
 2021 13:36:06 +0000
Received: from MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::d804:7493:8e3d:68d3]) by MN2PR21MB1295.namprd21.prod.outlook.com
 ([fe80::d804:7493:8e3d:68d3%9]) with mapi id 15.20.4478.015; Sat, 11 Sep 2021
 13:36:06 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Len Baker <len.baker@gmx.com>, KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?iso-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        Kees Cook <keescook@chromium.org>
CC:     Colin Ian King <colin.king@canonical.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Subject: RE: [PATCH] net: mana: Prefer struct_size over open coded arithmetic
Thread-Topic: [PATCH] net: mana: Prefer struct_size over open coded arithmetic
Thread-Index: AQHXpvfowjZ9iOsS30Sr6BnAMo+4xque1aCQ
Date:   Sat, 11 Sep 2021 13:36:05 +0000
Message-ID: <MN2PR21MB12950F1132B8F4DB41BF3778CAD79@MN2PR21MB1295.namprd21.prod.outlook.com>
References: <20210911102818.3804-1-len.baker@gmx.com>
In-Reply-To: <20210911102818.3804-1-len.baker@gmx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e1d06467-b897-4945-9c07-df9c2bf11082;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-09-11T13:34:44Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 042b59e5-dfd0-47ee-1e72-08d975291b56
x-ms-traffictypediagnostic: MN2PR21MB1439:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB1439E4CE3DF95DDE478AA9A4CAD79@MN2PR21MB1439.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VyznBoP4LgAub1szDQCBj6k1naXbbXHhlhT1CNQGjABNZ1y9m1HxSki3vBQONZZwY8y2eTHblzVEz1dZpK9JNxUCL844MtmrYgcK/+uSywRKdfmtCKtyMVYiVR+5Rb98tus5ciBQtcwPncq/ihuYIJrsLCA/2SwinSR6+obO9iCaWg/YO+N5qT/Ffv/AyY/bVHSyIJmQ0IiTyrmnxHNmY/IFmr4rB7ZSUTSE9D2gNqX0IfUMipTx8PsD8ixq6nTlymjR+T9/h+pR+qh9LXFqEOzTLtORB6SvP6m/ywyZRHMAYZ9dcs3Vr+pDjHb9j6Yi6mU4jH2kLctoFS0ternyBeD1iC+FQK8BNvVfh4mqpqquHs/Q7trFm9LPMpoqORoGNbGP9fTt4vNqie9OheztZADIkdCzxWAVnn1hlvEHlj8fGjV9KuXPTWmgil6/NYhmFwzlK3xK4i8ZKN+z4UskUSzZdAz0l4nvurQrOzijfLfCAgF/K4q043BQ/PfpQNN+4uKm+iaCJhjPUkNPgF1uEn3SKBreSzde94zMr+TAmDksh76KyVkvXOfOHpgjL2QUSnYPVJN91CHeQRgr/8r+ypJLz72mqWKr1z2BasFFj+QhNzPfoF4Sru+ClRr+FEwUSpnDuk/7nHhj4lJ9QVeFhJsUXkPOysvCzhPwWWVL9otg+g1PceR8evP7oU+j2V/za6mauJCR/t/MJQVRiAfDYJ3IBOp9crUfAShHF+sYKAdTWtqi5EoJhAMclR3SIuUpH8S/Tnb0yvIP1XRS5bQNSAwJZn/eRPNqC7JTLXgth9UgekbQHvQZWeL/tRZ8UZaVa6b9ryfn01lzEkwYBdwJkQbtuW+WJgeoORP/wWflSww8bnfxGczu9UcDw7AwZ/AJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1295.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(38100700002)(186003)(82950400001)(7696005)(9686003)(5660300002)(83380400001)(71200400001)(966005)(8676002)(8936002)(26005)(110136005)(10290500003)(316002)(8990500004)(6506007)(53546011)(66946007)(2906002)(508600001)(66574015)(55016002)(66476007)(921005)(82960400001)(33656002)(7416002)(38070700005)(66446008)(52536014)(76116006)(54906003)(66556008)(86362001)(4326008)(64756008)(518174003)(10090945008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?8orrZEM2xEu0a4ggglOh7IMIdxulja0ruIAnAyvo2i8v4irv0EvVh+MHba?=
 =?iso-8859-1?Q?9Nk1wSoNHU/33lOjmVzdheLO7qTsHJSYc3MjsnvgWWSfJ/8ZWEtdKlyPJQ?=
 =?iso-8859-1?Q?UheAQpJsMIbmkNT6VihxMnmfvfyDRBP72bTHmxBTVDRIPuw870Tt3/n8Jx?=
 =?iso-8859-1?Q?bWAUAulbKwkqof+/npA8SO5eO1JEe70h2TADM2Gp3sN5XsPGEXkCT5PKD9?=
 =?iso-8859-1?Q?wybYNpD+haDS4hmnz43ZQmx+u3nMeD1YbInEGRC5b2gbdEi/rKi6NJHJAu?=
 =?iso-8859-1?Q?0a88ZfnyPIpmn9YZr1lgIYR9rbzw/HkPHlV0m/q0Ax7B+ixFvSLKuXAXPt?=
 =?iso-8859-1?Q?icIKVFILaM/5QC9RZ75PxDvG7TECkyMTFY+/0g27rgLJqdwM3ouo78bYpV?=
 =?iso-8859-1?Q?Qpx72W+2Yvc309Bmu1kibCDDZm/bFT5MZk3ni5Je2RIWDTshS3W9ZU6ns+?=
 =?iso-8859-1?Q?OEwuKX1lAbNVQ/+Y8I26jhPxcMkhkw/OHK1a7iUy6dSzNcZG2uGWgvGfLR?=
 =?iso-8859-1?Q?DMYneKJp2p+TheRQWr9G5B+VF+KNOBRf4dbH8/O262FxgoFmZ38yNJcEiw?=
 =?iso-8859-1?Q?dbwqxWymPXoIrG8tN4641t2fY0Keu8WNtgzGMG4mqIJ+W4Uydq+mnWQitR?=
 =?iso-8859-1?Q?iy9nN8ywPh8Xywjt8YGHF5piMG/Hn+7JKqZzSgMcZMbdrsfqG+Yq/eRBhd?=
 =?iso-8859-1?Q?CuMSCeamdWXqt88RzI1Evns8DXZh7St4KnWrNsIeqh6V6u0gKlv2VxEnPV?=
 =?iso-8859-1?Q?PQ2kiTDjzbXEScYl2w85D2U3noNch950nQpQOcoOy5qk0rSTtAUZtWeoXF?=
 =?iso-8859-1?Q?mQ89uEgHWWPlBtBHHwTvjy88pjWpT+whlsn9MY+yfoJQt1HZv+lUwweXw8?=
 =?iso-8859-1?Q?ueRh+xLWwZwXmTHrNToJfNCvkdh/1zOivvculYLhwT1eCS9ucn6bFyADJ2?=
 =?iso-8859-1?Q?tOQtFWawJXqXJ1vAKZy4JbE+iEkr0Crp8fH6IHE2kA1pPGQm3H/BQp3G1V?=
 =?iso-8859-1?Q?4zJkYkBcVoQzX1XJ7WLg5FEObJEakBGtzNmYLeVKziUVWzJUnpI5rPWvvY?=
 =?iso-8859-1?Q?jZg8NgSGP50IltCAy7PmQujKcdlLSDOiDv4IzCIrBB5TbRA654I8PodSnQ?=
 =?iso-8859-1?Q?dmUECQmAKlVCCyiLSJULRTwZ1J3H5VC5Mmfom/5dQROr9yfHyoVjB9KH7r?=
 =?iso-8859-1?Q?6pVjEFHdHsV60FUdLugou1xZk142sr43Q56gSswDv8mavMWsuSkGt/9wvQ?=
 =?iso-8859-1?Q?vD4Rswv1sVCOPg2A+rbm6/VNX+7OqFKskd1gGO2/LuLcGXJtv4v8ZtLXrT?=
 =?iso-8859-1?Q?h3nf+O31oP1zAJsRsV/MbNb2SudiPZAgTUlUpvrsOVbACjoamN52G7XCeA?=
 =?iso-8859-1?Q?CmbuIEO00I?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1295.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 042b59e5-dfd0-47ee-1e72-08d975291b56
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2021 13:36:06.0994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZTbjW+Bv5tAKS/WycySBMsYrTsBkp34wRQCf8UOWSksiujLVIrXZNwQPryDbKGfs2BmeMoaN5iVurqpxT1IrrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1439
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Len Baker <len.baker@gmx.com>
> Sent: Saturday, September 11, 2021 6:28 AM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> Wei Liu <wei.liu@kernel.org>; Dexuan Cui <decui@microsoft.com>; David S.
> Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Sumit
> Semwal <sumit.semwal@linaro.org>; Christian K=F6nig
> <christian.koenig@amd.com>; Kees Cook <keescook@chromium.org>
> Cc: Len Baker <len.baker@gmx.com>; Colin Ian King
> <colin.king@canonical.com>; linux-hardening@vger.kernel.org; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-media@vger.kernel.org; dri-
> devel@lists.freedesktop.org; linaro-mm-sig@lists.linaro.org
> Subject: [PATCH] net: mana: Prefer struct_size over open coded
> arithmetic
>=20
> [Some people who received this message don't often get email from
> len.baker@gmx.com. Learn why this is important at
> http://aka.ms/LearnAboutSenderIdentification.]
>=20
> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or similar)
> function arguments due to the risk of them overflowing. This could lead
> to values wrapping around and a smaller allocation being made than the
> caller was expecting. Using those allocations could lead to linear
> overflows of heap memory and other misbehaviors.
>=20
> So, use the struct_size() helper to do the arithmetic instead of the
> argument "size + count * size" in the kzalloc() function.
>=20
> [1]
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.k=
e
> rnel.org%2Fdoc%2Fhtml%2Fv5.14%2Fprocess%2Fdeprecated.html%23open-coded-
> arithmetic-in-allocator-
> arguments&amp;data=3D04%7C01%7Chaiyangz%40microsoft.com%7C1bf83c1204a34da=
e
> a6d308d9750eef16%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C6376695297
> 12931146%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJ
> BTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=3DPbYpBtyYfVfwwlxWSQx%2FiARc=
9
> mhb0J7bfD46%2F9q5oTw%3D&amp;reserved=3D0
>=20
> Signed-off-by: Len Baker <len.baker@gmx.com>
> ---
>  drivers/net/ethernet/microsoft/mana/hw_channel.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> index 1a923fd99990..0efdc6c3c32a 100644
> --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> @@ -398,9 +398,7 @@ static int mana_hwc_alloc_dma_buf(struct
> hw_channel_context *hwc, u16 q_depth,
>         int err;
>         u16 i;
>=20
> -       dma_buf =3D kzalloc(sizeof(*dma_buf) +
> -                         q_depth * sizeof(struct hwc_work_request),
> -                         GFP_KERNEL);
> +       dma_buf =3D kzalloc(struct_size(dma_buf, reqs, q_depth),
> GFP_KERNEL);

Thanks!

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

