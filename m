Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5516E0F88
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjDMOEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjDMOEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:04:00 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021024.outbound.protection.outlook.com [52.101.57.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972749ED0;
        Thu, 13 Apr 2023 07:03:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DB7RarY5UCF2hc1HYSgmk/pxR9Gk01OjRb9KlLT3N8d969DO00588oaTlIQ9qttRfe8TPCcpzmqNQ9miZ2bM91I9RTNqgJVml5lboSyIymJjsQr7igujTbxdPtibjghyXZUj1TSkdgGZCy/x1EzZPLHwjgwMKYnI4DPFsKl/mIWP+2k6S8/PXgeFkwE0b6FgNe5PRreqOgmc7j2bqBxNMKuo59Asgi2d5Vdj0sDBTdgh3m5T2yVhkV549Qappprlu0BCuX4Yeo69EjKcWGmF8vkvnoqQv+jqa+yGmhByKJz+povxwX6wkxzpLHaa1K5Nl9ltO5lEqtNYdLa9mFRFog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZwDBmnNFlJPJUjkO1oNfzx1Ibz/ZDI+bjC2ZJxQotw=;
 b=ZPOYIJEXbe7TSLymhs1HoqMmT4mF0YYttRqLFlISXJ/UTccLrz8BwR1A9CpVU8Pb1+x7wnrpArcjvMOPzs+l0hAIu+tINcQrFvipB0Pvl6P/QAY2+PS0tLQ7up4bbA4v9NXraTC97JDmYP/cH+1NhkFCEUo79jYEssEgZPmVmDeFxuptTwukC7iY6wgYo2LWl4F0waR/0fljCZMGQ4LfIJN0l6OGz+yORKTazHnJO/0aqQxot+1F90mhuOaUMwAb13WumtOMZOPp4DSmNezjI2bk9qOCWOjbwhZbtth1I82+pGP4R+bEOLOR84Pf0lxGHskSOBCv/ra/FGXDG337/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZwDBmnNFlJPJUjkO1oNfzx1Ibz/ZDI+bjC2ZJxQotw=;
 b=SZ5a5p7NnJVesdur1hUM8AtTilRiyxMKl5Tdfg+HwAH2hiwIFUUBrNQ45v9slJ9u9eUrIiZPyWnYgGw6eqxdp9qXfN9WTBrTitA+Vj2Q22Uin8QYPvczoaa4OVQe3NH39g32rrlUDDkUQymlsA0xMoUVZgae5m2di8ztnByZRUA=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by MW4PR21MB1892.namprd21.prod.outlook.com (2603:10b6:303:78::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.6; Thu, 13 Apr
 2023 14:03:50 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787%7]) with mapi id 15.20.6319.004; Thu, 13 Apr 2023
 14:03:50 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer allocation
 code to prepare for various MTU
Thread-Topic: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer
 allocation code to prepare for various MTU
Thread-Index: AQHZbYQujzvOlLV/4Ey68gIm6XL6d68pNewAgAANP5A=
Date:   Thu, 13 Apr 2023 14:03:50 +0000
Message-ID: <PH7PR21MB3116194E8F7D56EB434B56A6CA989@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
 <1681334163-31084-3-git-send-email-haiyangz@microsoft.com>
 <20230413130428.GO17993@unreal>
In-Reply-To: <20230413130428.GO17993@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=49f3f8e9-b761-4155-8907-f27b273ddc27;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-04-13T13:51:52Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|MW4PR21MB1892:EE_
x-ms-office365-filtering-correlation-id: 08ea56ba-0f9d-4efd-3a9d-08db3c27e891
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s3sV0/I9T87zL4pQOAmnYKPlemcuhbdj3Gi6UhotkPskhybjUa5LcrTzrl1R8uiS7+lZkrN3NbaaZO36SezW7S5T1xfFx7rCiGFw3/H4K/AshVKUjH54r66gqDAaZ/Cyn6wAKNJkrrxUSyAWrXOCYsvAs9S9DqdsbHsHipN4aOnN0Sfsu3JkETCjA9QtWjypaL+uJ9XmWPDOUB400kGSE0I7pTb+jEE90kSLWWUxdDc4y//SFQm1efiwu52vAute+0xTX6koD4IXa9/tg/nx2X7kdau5fpv/W13Is9hQOI8stAQXQLziefealimFevlUk4naiJFaaHeaUL4YjbXMCTYQiQ91Ea9lj7RKajXGhv+nLGd4PYzsSWt+xvYBIO8Tu+GGKs+76a4SNfkn3l3EICgu87wdc698TL4f42/xT8szvgWIjwf7GaPjl6IBMqIsqQ7JE8oiUxhR3fs46k0kbHI/UoxRPT6r3sJTbmixvXUvKoWLKRLbdWJ+IHej9ddwBzyjBl8piWu3oDb4wnSKhaJeoUCRIeEzlywPQ4HzKjCA6UE5ziKkH3FqPYQ+DtNoDpEopoAeYwQNL5fm82Z7QFV8FJ5jDtgAvDmrqsadmRsFMLu8HpInLMfhMm0o0NHJIY3ZoRGa7gMD5vySaInwT6tAyB7MnXcj45vT3mQuyB8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199021)(53546011)(26005)(9686003)(6506007)(186003)(10290500003)(478600001)(33656002)(316002)(786003)(54906003)(71200400001)(7696005)(5660300002)(7416002)(8936002)(52536014)(38070700005)(2906002)(8990500004)(82960400001)(4326008)(6916009)(8676002)(82950400001)(122000001)(86362001)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(38100700002)(41300700001)(55016003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dCpy/MLLF6s4ZYfNr0H3yQkqNsbaphsBL7p3ipGZXQwFdIXAFiwO/LvzPJc5?=
 =?us-ascii?Q?j50r2PWInEKd0mQEr8zW1/XpiZGDMCFIi+fa+uKJtmm9S9iTnEHfz67iVv1J?=
 =?us-ascii?Q?QtZrBT04ONpsjVQajCQganme9xvKSZeaTiGTzuoUiCkjVv0cjZTv0h08fVcB?=
 =?us-ascii?Q?IJUdAibfix3rfUrXNr/+U5KiX8KkrSbDkgZ4QTzX4TCUfZbb3cw/Rgybiko+?=
 =?us-ascii?Q?KT7I1enpa7qbJSp2V4XaF/6dU6bkfkKR9Qeb1Of96xoQAWgXqxtW2LWkbOYZ?=
 =?us-ascii?Q?YONcKX7S/aaJrYPwxv7xZmshu7I/Fa5SNkGCADJurIQKE9IkMg/rrH9pi1Z3?=
 =?us-ascii?Q?rYznlsZ0C6i73e0Aj/uyWBzvj7tiy7iXaOYtS4Yd5eUl3R1yJ7qA2oS0Oahp?=
 =?us-ascii?Q?Ftae0+koOq4MdRNZeLUPVB6ZNnbVuLbEwjfixoGxUYCxenB56cFVxmk4gkRK?=
 =?us-ascii?Q?BKT4BKjBuNfIi/+D45JNOVhHVaCm3inDtcMHTvb86q9Cm/jLYDmfksXJ1eAF?=
 =?us-ascii?Q?SSBEH0lXu40W/bE4RgynfvAc8YQMsLLq0bAVoVUZVEEIsYmR58z4+sIPveCa?=
 =?us-ascii?Q?1uNOwR1hhSOzcckhtMnNStJ4i3QEldRrrd+Ob+43i2y6q+UwzvOiZVIdd7l+?=
 =?us-ascii?Q?LZwpJ2SrLYBJDoAAVpuBSbAlgNO8gYfOG9eMDEkaZUul+2Xs2Qdex9Bi1tEt?=
 =?us-ascii?Q?ZciOjbMLapEEz8sO9wGoSulqFuOfAzESWCzwJ5PFi1ZWDNdj9npERD0piYoU?=
 =?us-ascii?Q?ukRQzAbxpDtrhk1RSSQke6FZ/+VQOr8QggP0HM+1obgJ+axZes9KaQ1gb6V5?=
 =?us-ascii?Q?h3s1R8zkuXt5SVXxXuYXT16WqSXwwIspFGEIc6J0idRgQMMvOncTCt7WGd9S?=
 =?us-ascii?Q?QCfhoimDLs/8RKEdGllnBMLfxR+KKjP2l29ng7L31PIuhR4gS3AchNEa/YLu?=
 =?us-ascii?Q?E7nXIWLKSqD2PY2Yr5FoztEttWb8b5k/a7tekWymPvK7rauxYP5l036t886E?=
 =?us-ascii?Q?PhBlqSXfAEkyu6081Mk+xGrgd0fYjCH+BCvZqiAhIAybq+jyBEFNEGa9ZtmC?=
 =?us-ascii?Q?VNbLI+HBJjidblbncLmF3YJ2UuR8zkZYtW92s0V3NlbwqJpqfcUwXV6O2n8j?=
 =?us-ascii?Q?X4OxDeWG+alDWI3W1uNKHvqKPPbA/JV/+BWxMg6wRHSTeke74xqhZ6Aw/Ncb?=
 =?us-ascii?Q?/TeyjTSpuJuq81ifdh5F4R2g8XNJfAhgVO0vqEyVdcn3HatwuZo5j118WsS5?=
 =?us-ascii?Q?95gOwy2v72Zrf1ynty92rVqRdZ89V8bBqth+RFcQKLyEO7c/NU5yWjt7GI74?=
 =?us-ascii?Q?JvWEJs7JwAE5ISI00mUlPbIA2FnN6bMuJyhYu2rhDFoE7/OiSwRpbsQ1yqn1?=
 =?us-ascii?Q?uw3pGjkjKqAGJPwo67mcQN7Pm+CW9ZsQ0m3ukn4WIS8J8Duna09lNxvy7eSt?=
 =?us-ascii?Q?zO6sstUTojkMJZM0XqBjtzkRkkrvX//zzMd1AdMNdoHKEL4N7FrjO2lnUmoN?=
 =?us-ascii?Q?CLF9e7B8VSvfyBrxNa2Ubo369LqWuT2M9OYGK1x1im4An+qsnGkyzhVM8QkV?=
 =?us-ascii?Q?EQt5b/VQYyJriy4ObB4keqHSJlv55oqekiXVGRqJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ea56ba-0f9d-4efd-3a9d-08db3c27e891
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2023 14:03:50.5936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PeEqJpyF0EdYvoRW7/LiT3wgr02VxT44CaYzDVfm7BsG1MtbU3pUyIK4SWy1jjLOOye3U+Z74gTwJQNJ/iEgpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1892
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, April 13, 2023 9:04 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; Long Li <longli@microsoft.com>;
> ssengar@linux.microsoft.com; linux-rdma@vger.kernel.org;
> daniel@iogearbox.net; john.fastabend@gmail.com; bpf@vger.kernel.org;
> ast@kernel.org; Ajay Sharma <sharmaajay@microsoft.com>;
> hawk@kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer alloc=
ation
> code to prepare for various MTU
>=20
> On Wed, Apr 12, 2023 at 02:16:01PM -0700, Haiyang Zhang wrote:
> > Move out common buffer allocation code from mana_process_rx_cqe() and
> > mana_alloc_rx_wqe() to helper functions.
> > Refactor related variables so they can be changed in one place, and buf=
fer
> > sizes are in sync.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > ---
> > V3:
> > Refectored to multiple patches for readability. Suggested by Jacob Kell=
er.
> >
> > V2:
> > Refectored to multiple patches for readability. Suggested by Yunsheng L=
in.
> >
> > ---
> >  drivers/net/ethernet/microsoft/mana/mana_en.c | 154 ++++++++++-------
> -
> >  include/net/mana/mana.h                       |   6 +-
> >  2 files changed, 91 insertions(+), 69 deletions(-)
>=20
> <...>
>=20
> > +static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
> > +			     dma_addr_t *da, bool is_napi)
> > +{
> > +	struct page *page;
> > +	void *va;
> > +
> > +	/* Reuse XDP dropped page if available */
> > +	if (rxq->xdp_save_va) {
> > +		va =3D rxq->xdp_save_va;
> > +		rxq->xdp_save_va =3D NULL;
> > +	} else {
> > +		page =3D dev_alloc_page();
>=20
> Documentation/networking/page_pool.rst
>    10 Basic use involves replacing alloc_pages() calls with the
>    11 page_pool_alloc_pages() call.  Drivers should use
> page_pool_dev_alloc_pages()
>    12 replacing dev_alloc_pages().
>=20
> General question, is this sentence applicable to all new code or only
> for XDP related paths?

Quote from the context before that sentence --

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Page Pool API
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
The page_pool allocator is optimized for the XDP mode that uses one frame
per-page, but it can fallback on the regular page allocator APIs.
Basic use involves replacing alloc_pages() calls with the
page_pool_alloc_pages() call.  Drivers should use page_pool_dev_alloc_pages=
()
replacing dev_alloc_pages().

--unquote

So the page pool is optimized for the XDP, and that sentence is applicable =
to drivers
that have set up page pool for XDP optimization.
static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool=
)  //need a pool been set up

Back to our mana driver, we don't have page pool setup yet. (will consider =
in the future)
So we cannot call page_pool_dev_alloc_pages(pool) in this place yet.

Thanks,
- Haiyang

