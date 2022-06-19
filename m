Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69195508E5
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 08:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiFSGYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 02:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiFSGYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 02:24:10 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07olkn2044.outbound.protection.outlook.com [40.92.15.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F83BE25;
        Sat, 18 Jun 2022 23:24:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNm0UCzbvoLyzGOgejMfwQyLFemNsxNVIzd7lme6lDCIW2MSZic+M2fWejlf0vgLN7ghRxmjL4D0uxv0gLn8MKMIgpc1UmCZI4U6uCoXuOvJUtPxdw42D0Gf4Z6ixByufNDVg80+6Ypu/N9mj6VWlxWhfNVVRqgSWxkeMJ4kI/VL00LvJAzd7RnbfJb8OHFt1TVvR8o8ih3uqyC8MOb5aiuBg3+qIpN+zXb5/z58Kprv2wtu7jH0pfpm3xvA79vGfrwE6fiGNvKNLIHC9Qs/PMnODGy+xUZiHQVI716TLnea51HsY7axBebRkebSdhmI7zoUC6RF1jrkx5o+eN8s4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D5gggBZYFNSf9gu66MSdBgBznJD3MDk7O0RxMh4e06I=;
 b=RviafhYColY5b16po+1G/htX35qhcvFjmgMhpEw+A6Ca7Y6NtGcHH5y0SECFf7F2/xuS4UgN2TbGONhOVL5KxhvqbsHj9x4aIC3NBA+Y+o8LynN9GeQcB9eGSQSTI/PPmGtd3ph6eNN6myW6mLZdBC80LX5J0Md4qO/jerB/t5j5AUGfEKHCnlJQ51d3h809SvUVJBSUNSt/AfY5P2LlQ+amGmbly0/E46WE0kEA8VSso4O0qvMhCrbnm5PW857EQlv6Sb82mYdb7D8SnJcfrDz89UYsqjLQxHJkNOR/BZuDMfjjtc1kQBZs7vsb5I6Or9GvzcflzYt48Uflb4l51w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5gggBZYFNSf9gu66MSdBgBznJD3MDk7O0RxMh4e06I=;
 b=SKlskVhDlLlVdmtVpw8izvoA462+3j/IbJjc7UlmoDIUcG3Z1hYSF/oGPbFg80M2bQgTm5gmwJN2ZhYyihDdOQ/Yr+gqzz4zaVOjkznQ7D8s+eUuy1Jfo96MYP0qnLx8kCmCvFy3+DjR6Q/kPIqEhuTPCehSwLYE5AZoAe4G7TMIl3lYIe++LoGinIo638avNboPKF1XUfqBZO3tYYWvkPi1KMmQbaqfV5xMgVCPuB4DTKHxrSBVKriByTEd4mCyHVYbQJ0BsDfz3bQGdFfQf6kh2L89T62cbg+vLFgcizvKK+Vr9CBL4Q3WW2dcs6AK2gc1NEbxzr2BNeSHQ+VCkQ==
Received: from BY3PR18MB4579.namprd18.prod.outlook.com (2603:10b6:a03:3c2::23)
 by BN6PR1801MB1988.namprd18.prod.outlook.com (2603:10b6:405:68::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Sun, 19 Jun
 2022 06:24:06 +0000
Received: from BY3PR18MB4579.namprd18.prod.outlook.com
 ([fe80::a152:9965:ced5:192d]) by BY3PR18MB4579.namprd18.prod.outlook.com
 ([fe80::a152:9965:ced5:192d%2]) with mapi id 15.20.5353.020; Sun, 19 Jun 2022
 06:24:06 +0000
From:   <wentao_liang_g@163.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "jdmason@kudzu.us" <jdmason@kudzu.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/ethernet/neterion/vxge: Fix a use-after-free
 bug in vxge-main.c
Thread-Topic: [PATCH] drivers/net/ethernet/neterion/vxge: Fix a use-after-free
 bug in vxge-main.c
Thread-Index: AQHYg5fan0WA3s/kGEu4h2ZIbP7riw==
Sender: Liang Wentao <Wentao_Liang_o@outlook.com>
Date:   Sun, 19 Jun 2022 06:24:06 +0000
Message-ID: <BY3PR18MB4579167AD36EC86A9152EBB5D8B19@BY3PR18MB4579.namprd18.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-messagesentrepresentingtype: 2
x-tmn:  [JwGdfw4vfqHx2mwU4PsfMbD5OyK/TtYc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bd9aa54-b525-4f5f-cf41-08da51bc5044
x-ms-traffictypediagnostic: BN6PR1801MB1988:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oM4XsSc2yT8QisNQxa8EMXwIm1BcIkSCuMn7Pn9DVm0PHi4BakQST5TghYGKN1NQosM6rDTLvBujlBZStDw6VmefnO8HWxpVWc8squN+vU7/dd02fw9me7VEJOjA/Zh7iGZfIB2P5lYQmpY1vbedkeuvWUHOIj2YAv+KzRs+dARgaRQlB2xWqD1aQFjDXWtn/3AA1uSQsuum7cGcyoxF/YH+bRRUAD6/I8FrAloZ9aR5oUJtF/GNRZuXXKeMItdzEPu67F0z0LfoAMRSg9Wy4/RtB+x40SovPTpXC35/is/F/KnMnQvzUr5rI6LZvEAZvCkbXrhH1Mn1rYDr4jTMKFH8tWh2QNempvdGIZPxABB+AoN2mJ5PrElW2mC3LQfd6irS3SRy4Xz3GZv/RPiEYbwCV+yL4fPa2DrjK0THkNgpFLitfyIX7yEH5dEFa2yJy2d0rZyioFDvG5IpZUZ0Bp/0RdIrVVplA0XjZMP/Mpcwsb4Iq0SoaFkqEvsznxtg/5FkTxSQ04NOsHy/cBSvZ6MQq1IWIpT3rfTco5i3SFyp+VJOxoBDHwCSV6Z8xfWGL4j9er1IF4MqOeCAYTAk/g==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?VsxkGM0fWYNsFgLXg7U6Lfs7GXmvmTKHlBAsASgbr2dMQuA6m8Qvv/rIEI?=
 =?iso-8859-1?Q?WJDnesIKql33s+5TAl6XP8uCgBc+MB5nKwf6NLqt015PQzl/+FBxJK1Udc?=
 =?iso-8859-1?Q?7kTrkqmsmqbc8SxnDuZGyKL9B6AqJLnrIKrofcb3LjtsHmVlcM/Ny+OBG+?=
 =?iso-8859-1?Q?5U1P8ohdAM6SCfPq47YmXwXOqlcOTuXZGcWptRhvQuNdkthyMS8O1QnBsC?=
 =?iso-8859-1?Q?6O4JJhqx7LsD8BcWMZoAkhxKcIvtBRL5oMrpQgfqT3on9PmXjhxubafs5Y?=
 =?iso-8859-1?Q?uiEugII1wP54NJMBQ/MVkf1NKoKJkvIO78Cx/o6cWceJJE/NOVVUhNVzID?=
 =?iso-8859-1?Q?ro/+GZfh0zEgdN0E3vT4Rqvw38kOhcLjCj+PZG+J4u5wn2+mAsYN6iHNNW?=
 =?iso-8859-1?Q?uXexd8Q0t3LRhNa8FuOipf4OKiNB/tGg8IumSpp22DmdihWW5PfZ0/DMzO?=
 =?iso-8859-1?Q?3L7fIUNX49KzqNf9/4W7WY1jxdtnWLmmXKrgnf6BOuIySh2b2jv1NSkHGE?=
 =?iso-8859-1?Q?L65ng50AnnjuJh9maLjy/plSOTDFnr9Y26xwEXc55+CETtD4TXzgAB/0mt?=
 =?iso-8859-1?Q?DkzadoMHqzwzLbROizUCV07K44PCJbFzxy3Zq2oYbGF0rqz0BQHutEYSHh?=
 =?iso-8859-1?Q?i+ejF2bTgN6eM9cL62987ND8yWnzRgYCfjbUrnpXJSKyLwTQMjpcejmr45?=
 =?iso-8859-1?Q?U7pQ8Jxq0BWcTND+N4qqPlxRL0e9F+4Gy5wiBT+snxcKhnjHS0yqw0kzsI?=
 =?iso-8859-1?Q?RLYL69/nEM/VM4LRmYMxDL+93J92wQ8UCABB4K8TknDs44sitXObnOgH05?=
 =?iso-8859-1?Q?1jiOsg6RM5xQxhVenRQo7iGHIvt7jr2E52SxhXhApRAM91CwLPv9fKgqz1?=
 =?iso-8859-1?Q?fNy/oXuG/KiVO5ghtY3wd/Shl4AAZpOLZnnjSReScaQHx0TBJtRURCtbNC?=
 =?iso-8859-1?Q?pm8/K1ScQOJMLdmAv/BDC8jejv150ucmsqw2bP8Am6HdzXVtDN86xhRcsM?=
 =?iso-8859-1?Q?Yyo2xTUDLsvQVQDwVZysp0jRtQtkAqz9dWjo12byZPnRdnO5I6qK9jX9tD?=
 =?iso-8859-1?Q?Z774rCtqhbMRB6AU9CCKo4mJVmAp7A1wQ1Xn1ANJUPSLW0ZNy3ke1Oc2I5?=
 =?iso-8859-1?Q?7z2oC4GzeKAzLNLgqk/UKpkvcTib58zmgMv1Dugw2u79MaKoWCOmocLOUZ?=
 =?iso-8859-1?Q?padsxgfGoP71HN7lKEzCi4sd52YkTKPpJzER+IRzGwdo/Y2qGbLslBCERd?=
 =?iso-8859-1?Q?NkXygppfofzu9GiroY7SQ1qU1rfkDAEX6MbByUmYT7fo8YhmPxIVeduntU?=
 =?iso-8859-1?Q?fk4StDHpl4iSD52wLES0UbtfBSiM2gXPCumaPRuaaENVtUADlR2gX1BJlz?=
 =?iso-8859-1?Q?/NJrcvfprtIjYYO3p/qQ7OqJk5gPbhItNIEzGl3AlZF5tc1jo1vuQxjNkf?=
 =?iso-8859-1?Q?p3ZAyogW6gh8uTw+hwG0nFSfkLhl8eyp56Db92vJvRE2gUe7b9q7TlltZz?=
 =?iso-8859-1?Q?Y=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4579.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd9aa54-b525-4f5f-cf41-08da51bc5044
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2022 06:24:06.8578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1801MB1988
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=0A=
=0A=
I have replied your mail and answered your questions about my =0A=
patch a few days ago as follow. Do you have any more question? =0A=
I have already renewed the patch with the correct subject and tag.=0A=
=0A=
I am looking forward to the patch being accepted and merged.=0A=
=A0=0A=
Thanks=0A=
=A0=0A=
Wentao=0A=
=A0=0A=
=A0=0A=
>No errors happening during a test is not a sufficient proof of=0A=
>correctness. You need to analyze the driver and figure out what bar0 =0A=
>is used for.=0A=
=A0=0A=
Bar0 is a Base=A0Address=A0Register=A0(BAR)=A0in=A0PCIe devices. It points=
=0A=
 to the memory space of the device. When the device is removed, =0A=
we need to iounmap it. We check the related code and do not find =0A=
bar0 is reference in the remaining part of vxge_remove(). We believe =0A=
move the iounmap to the front of vxge_device_unregister is properly.=0A=
=A0=0A=
=A0=0A=
>Alternatively just save the address of bar0 to a local variable, let=0A=
>the netdev unregister happen, and then call *unmap() on the local=0A=
>variable. That won't move the unmap and avoid the UAF.=0A=
=A0=0A=
This is not a right way to patch the bug. The UAF is not triggered=0A=
 by accessing the address itself but accessing the memory pointed =0A=
by bar0. Even if the address is saved, the memory is still freed. =0A=
Accessing the memory in iounmap will result in UAF as well. The =0A=
experiment also proved it.=0A=
=A0=0A=
>But please LMK how you use these cards first.=0A=
=A0=0A=
In order to trigger the vulnerability, a vxge device is required. =0A=
We use QEMU to emulate the device.=0A=
=A0=0A=
Besides, I want to point out that the UAF bug does is in the remove =0A=
routine of the device. There is not any operation to a removed device. =0A=
If the device can be removed safely in the patched kernel, we do not =0A=
have to warry about anything else.=
