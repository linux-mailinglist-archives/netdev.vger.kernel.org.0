Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9A9D631AE2
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 09:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiKUIA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 03:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiKUIAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 03:00:24 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC001E713;
        Mon, 21 Nov 2022 00:00:22 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AKMYxxO017079;
        Mon, 21 Nov 2022 00:00:10 -0800
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kxwcuw48w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 00:00:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpk30RUSXCaov/JGj9trv1m7l8APFP5kSrvE7NUcIx2pzANXzg5pyvxt6boW5N/u4mtfWMlopnGnyl9RpThFk0p0hi7HY5226oln4wf6ZCJNesKzArertv/Vvqyzqc6PNpHv/yqtDRwfzHscklJDgJQNW4Q3KTjELtzXx5OaQ+FGu5/pOW7FtLWGc8rtCuSj0Km6c5SsPfKZLAhhRhnDZ4/P4XW8o0D3W02TSb+SQraoBUad+/MkXErRZHzS+370EwL2PX32jCQIjFSdXvjS/hjPvFJmFE0lpFa3bSgHv4w49qs9tb7sUbBXSNK0eshTMnpRMTZLjK35KPXrQt28Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SX9beojMH/SKgAgck8WsvyB4c/45D4bguKqHx0X3uR4=;
 b=aM+WF9cqJN6EMRPpZmaDjImTdHkLaq4sdB4LWWcwUbYFYbRoopd1wBxRl6c3xTc8hxPy3SgODcUP+XRBq/cp07ZbsWxrGOAYkkpxJUhkt93uCQm3kn/BNQ2fJ+obOcCTzfo5mMbPctPheNwW9o/c6F09zcHc5S0tjS+TD3ltHGgT+MgIQ40Sa7vsd857PxZkY74dCkdYKgmPPIIy0xVazgDwfFwd/GcywH0PbwkQ60vT3Tmrc4jsVaRSCx3INDZa7xUJ0EjGaGtA93Yr5ENtBwX58w0iATa1FiM0At+x7hQOfy7lk3hPC8mCZaviCRNswUHUZN80UWSIMs3ikhB3aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SX9beojMH/SKgAgck8WsvyB4c/45D4bguKqHx0X3uR4=;
 b=qYnBtzmaU5a3QKS9j8TSU8kF8NqWq0STPVeNcfJXPzeTBh0hI4kIO2O2RQOx5z9SYrlRq3dIL3mG9eWL2FH3zEabJ6+HSRn61C2MqNvflU9tUDC6kQjO4h4LoljanLBCVccCvIOBKCRpHktz//eBOzYJTIXFijOUtBDjfokq7II=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by PH0PR18MB4844.namprd18.prod.outlook.com (2603:10b6:510:113::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Mon, 21 Nov
 2022 08:00:07 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7acb:2734:b129:b652]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7acb:2734:b129:b652%5]) with mapi id 15.20.5813.017; Mon, 21 Nov 2022
 08:00:07 +0000
From:   Geethasowjanya Akula <gakula@marvell.com>
To:     Dan Carpenter <error27@gmail.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
CC:     Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vamsi Krishna Attunuru <vattunuru@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [EXT] [PATCH net] octeontx2-af: cn10k: mcs: Fix copy and paste
 bug in mcs_bbe_intr_handler()
Thread-Topic: [EXT] [PATCH net] octeontx2-af: cn10k: mcs: Fix copy and paste
 bug in mcs_bbe_intr_handler()
Thread-Index: AQHY+1+OoZypSCU1OUas3wDZOgcb+65JBTKq
Date:   Mon, 21 Nov 2022 08:00:07 +0000
Message-ID: <DM6PR18MB2602D92B07F140B616729203CD0A9@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <Y3efyh1HjbToppbN@kili>
In-Reply-To: <Y3efyh1HjbToppbN@kili>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR18MB2602:EE_|PH0PR18MB4844:EE_
x-ms-office365-filtering-correlation-id: 83f5aa3d-e25c-4e3b-fa98-08dacb9667e7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ySmW6nzQuaTnlARouXQL+G1y1Q93alrXi+V+tpen2gv+cyZljmW0DakUUX7+mNCI/C7CjJJtV5fVaJmsliA36rnuZU60Hd3j3TnRzM7EcEaBP/dWMtiRJkEs2SEuSfW3DCVzvtixH4AbqDIvF/NnSZhXa6F8GDVdpC+GzkgD1NlSztbHxSl+bIWoBu+nEOpeIbJhPC8BxWMf/LREw7cPN6fEmckUfOb4kQMxVglNtDDXtDrRVnruiQ6/3/RORmmL0ZoPWdMxCZS6nwzFNxgCkhyJeCWulduJVGdYgWacTIY2MVYw/2532gseI+k5PY29CBxClcIfgOto4/qvzNgkV8w9yspPB6QJZac0lcCGVF+jacbVmMo9yphnh5NnUm8bNUKT4NtI90MKkqR3J/IHhmYvOJvvkFra+TipjIu8qEkaoyLsSUBiP7nz0W0/rV1GgVIsXGhirOMszY+d4buSfLlmK5KYwNo0O67fMwhszxIkUNzpeiQuxwlLJS7KiKSIAgjGpcxEVmrZKPUszVa3/e4G6e8D6F6fbH6LjocGp/HFCJTiU1Qom5TjSxfIzVC+VuCbKqK/e8stN5cjDJRoqZuagWVLxQa21XhsWbDGFyljr0zvgrygEn+86oQj1/wRBndzYtPl/rEnovdzlcQv2uoPZy2pY2UzwgTnyVFDuvPhrzajn3vDfd5/eTvLOyvmUH17wedY6/AB3640oPz4nw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39850400004)(366004)(136003)(376002)(346002)(451199015)(86362001)(33656002)(55016003)(5660300002)(8936002)(71200400001)(52536014)(41300700001)(2906002)(186003)(9686003)(316002)(110136005)(6636002)(53546011)(7696005)(6506007)(54906003)(4326008)(66476007)(66446008)(64756008)(8676002)(66946007)(66556008)(76116006)(26005)(91956017)(478600001)(38100700002)(122000001)(38070700005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EkWE94gI1ohXEEWc9UMTyL7lGxkwtIGPTf3zh7Gu2Yw9BrlJIwdIOJ8KIWie?=
 =?us-ascii?Q?4FJRdO+++jxnlAvUTnETyv5SJ6qc7/FFwsqy0go5exBB/hW3bTe4wixIOjpV?=
 =?us-ascii?Q?yHYwvBr78juJckSXfY1JTeDVvnMj78rI7C3Q+/AQRUzVUq+xD+A6r7Dsw0a/?=
 =?us-ascii?Q?VXqLNgnfJWHJDybQ/ni8gzQZ4o/ZCAEBEeetULEQ5rEQ+2BQkjKcGMcbrD7N?=
 =?us-ascii?Q?N9avBj5+M0locqZtn0LYcm9JWbpp9wqEJ6Q2QatwvvSfoNs7jQV/SYpcRRPT?=
 =?us-ascii?Q?f9EKJdCScIOorMT9VSpO6Z2eo+8+YuCj/2J91Q2XRlh1wC0Sf0DMJ88h1zsj?=
 =?us-ascii?Q?KPIRHnwYLFnvHsO3KaganE5hbE9fHkUTV7cPbWHr7yIs0ngV3LtA8FT7LSTG?=
 =?us-ascii?Q?Uo0lIumGlX228MeYZ4gORBOkLQ0c31NiV6SWKhgEhabyYqw5btf4WmoOQQPW?=
 =?us-ascii?Q?Nd2Nl4Pqj6C3Qhvar68s326Mg5I6IXem2yCdDQIM+tHlNUPXfTIj+79kxCIa?=
 =?us-ascii?Q?96ZrqC/KqxpkC1+kQ4mFxmyJH5AGn0LoCEJKbdO3n799Vc1rmmgJAZSNK3QV?=
 =?us-ascii?Q?scanq0+uEKvs+O0Jtxr0KBurMfNn+tuLDcAmVySPDhLc4NzhGEjvIL8RoYaT?=
 =?us-ascii?Q?JAMKJRZsuJqGGpKLxJF8mCBSbin/b5hiEveEPvZEa/4qHZo9iseLLLfF6mNX?=
 =?us-ascii?Q?NhgAgE4/QuXMWKlyDC4hxCXwp+pJXaMrJDCxb2w3t6bA2iWGumZ7APi7mdT7?=
 =?us-ascii?Q?aY3/0hAdLXCkCl6q2RPvejd8rOWRSPlHHrQzoDJFmENW13Qy/bofaxAdPUEG?=
 =?us-ascii?Q?gRolpKS3C6VjbDyFo2l1ayRoDzCo6U/oPt5ux/cfjRmIuxQ5ziL+mOeIrWAD?=
 =?us-ascii?Q?NqijUEaPRs28Sv1IQTVMRtI3g5qJinKQeAbzW+DsPqVQi7Hby7+xi6AUU/yO?=
 =?us-ascii?Q?32XnngxNlKkyDKK/lW5KB0c09NjgQEjq8dYmIJoqagyZtOiOVDF3UcH90A4N?=
 =?us-ascii?Q?6aBsbfnoipvwTwFwHkMC84yTH2hDDlyeybItDVQWCdZfyMZfdtNVnl5vIiOB?=
 =?us-ascii?Q?91loLTdKQmXLbUnJI0mEN1cNjWRgSpsjmdOvjbMCKDBLNz496RL0A5TXItJL?=
 =?us-ascii?Q?KuA8TyJ3wRqhFWxmLBGk6yjHgfzYnVUVxF3464jqGu+geKK5RV8uYytZtAzW?=
 =?us-ascii?Q?Lfnou1k1slKKwtOf2mPEo4kCj0SygOyoBv8ZvZmjetCnOSSUx8/SCaFJPqtp?=
 =?us-ascii?Q?xVdx5SD6JN7Ub9eSpOGevhE81s1t9qUY+xmsogelMaShqb3L8RwkSHUQg/61?=
 =?us-ascii?Q?u8lIVjvXY2VIO7jQNHj5K1JKdx9U6aothc2Ab8QDfzCxcSGfwmneupW2KhMh?=
 =?us-ascii?Q?Por9I7hQhGiVHCjBslwhCVXa5lFDgB+hd/o5Ap6ZZ6rzUvYU0zH93feuNhLd?=
 =?us-ascii?Q?PwvQ3U6efhALt8lsSm65QDkC6oCn4DS4VHH2r7CV10Y6VVgz9r6nqZVNSwv2?=
 =?us-ascii?Q?JnopogrFzkxeev32txOfSngNT9gy4upo0qr6jtWievm3fLvaxxxp1JPJV8zF?=
 =?us-ascii?Q?4Tk76saddY3QNybtu3Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f5aa3d-e25c-4e3b-fa98-08dacb9667e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 08:00:07.4510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Em1CzbYeKjYzEhaK02gM7WXss5KkTvKYNPu3H5W84/JaTu1+N5nmQTVT9i5dHZwhDcI3TwuWKJ8OTpOAt6aOVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4844
X-Proofpoint-ORIG-GUID: -VsF3WYTs_XZH7PIHkHm86XE7ECIMTHH
X-Proofpoint-GUID: -VsF3WYTs_XZH7PIHkHm86XE7ECIMTHH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_05,2022-11-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ACK.
Thanks for the patch.

Geetha.

________________________________________
From: Dan Carpenter <error27@gmail.com>
Sent: Friday, November 18, 2022 8:37 PM
To: Sunil Kovvuri Goutham; Geethasowjanya Akula
Cc: Linu Cherian; Jerin Jacob Kollanukkaran; Hariprasad Kelam; Subbaraya Su=
ndeep Bhatta; David S. Miller; Eric Dumazet; Jakub Kicinski; Paolo Abeni; V=
amsi Krishna Attunuru; netdev@vger.kernel.org; kernel-janitors@vger.kernel.=
org
Subject: [EXT] [PATCH net] octeontx2-af: cn10k: mcs: Fix copy and paste bug=
 in mcs_bbe_intr_handler()

External Email

----------------------------------------------------------------------
This code accidentally uses the RX macro twice instead of the RX and TX.

Fixes: 6c635f78c474 ("octeontx2-af: cn10k: mcs: Handle MCS block interrupts=
")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Applies to net.

 drivers/net/ethernet/marvell/octeontx2/af/mcs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/=
ethernet/marvell/octeontx2/af/mcs.c
index 4a343f853b28..c0bedf402da9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -951,7 +951,7 @@ static void mcs_bbe_intr_handler(struct mcs *mcs, u64 i=
ntr, enum mcs_direction d
                else
                        event.intr_mask =3D (dir =3D=3D MCS_RX) ?
                                          MCS_BBE_RX_PLFIFO_OVERFLOW_INT :
-                                         MCS_BBE_RX_PLFIFO_OVERFLOW_INT;
+                                         MCS_BBE_TX_PLFIFO_OVERFLOW_INT;

                /* Notify the lmac_id info which ran into BBE fatal error *=
/
                event.lmac_id =3D i & 0x3ULL;
--
2.35.1

