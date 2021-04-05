Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA24835410A
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 12:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240877AbhDEKBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 06:01:34 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31412 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232063AbhDEKBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 06:01:33 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 135A0OH6023867;
        Mon, 5 Apr 2021 03:01:24 -0700
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by mx0b-0016f401.pphosted.com with ESMTP id 37q2ms2wew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Apr 2021 03:01:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMlt9Z8UZUFNG1s9ZXGW+kum2LFZpw+IQYQgfH9/ZsaB1TeIK9OJMdsVKGVG0Rpq+p1Hfay2BBtLlFnmZ18EYamEvDR0wsq3YQzXW8RpjNvw2A665EtamvSLmO3xXVinZCeaDdIsTCMEHefbAPYawsvYkBdImXUTY2Rf4DWWgn+L8VlXMWY6r7M6U8mvJNcwh2IJvsqxRkkrP+Nkg5XMEBZpVCzCTKbf4X2uesFrxWGkK/8tAGua/oyx6iejhTKAL8uTwONARc1WEN+m+dF1W914fl3fZY2/r5Xt46J0S8e15SuqcNMXqskHilWpQWjZuXIlHrS3PXvFEo80QkJ5CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOfRDOyGQ0YBgi8XWmpD3rQHeh6BEk0wexnx4L1Rtas=;
 b=YzdJMnwTvHLw7Nv8Yn2FrWDEMd1wIyfZRPMClPfhRkBxo8M6ccweYx2fdKhfLHK3glJLh5EVUi+fyJw9mlbjIM9By++abYGwThyAuy56m+m6bxTLKBtYSiUDbG8SdbgyvSjGd2IG6yVSb5Rh45nxmGu9ieVtQ5yzulzW9eRbQIi9q9i4e1JvbmL/LdzYxaOUc3AMFD58t+8bPdVOfHxWBIAF7PKciEbBxK4o3NI0UFsxeWTspoiJho8EV+USYBj9R07BQG9oZPaR2lVIGURUMN0Va3v9SEVHqzunB1aN48qIjncLlYPYLpMB3ETZ+TykMdsqJ14L7FM/l6xKiTVDNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOfRDOyGQ0YBgi8XWmpD3rQHeh6BEk0wexnx4L1Rtas=;
 b=CCnzlIycAw0A933w7WgztnWocfzA78XBI+BYvJO0y7xYYqKcdrcceuKk4EuT8QjavYrheJpGJitANSMM4RlUmN0U0Xk+dV8fjCaerdpdMZGqmTvkEw2hUlrp7p4zxp89myPLKKon4xj2BUUGl2nHBxhFyARjw77qasrig5r8PSY=
Received: from DM6PR18MB3388.namprd18.prod.outlook.com (2603:10b6:5:1cc::13)
 by DM5PR1801MB1980.namprd18.prod.outlook.com (2603:10b6:4:62::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Mon, 5 Apr
 2021 10:01:19 +0000
Received: from DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::954d:da2:7c1a:37b5]) by DM6PR18MB3388.namprd18.prod.outlook.com
 ([fe80::954d:da2:7c1a:37b5%3]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 10:01:19 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [EXT] [PATCH 1/2] qede: Remove a erroneous ++ in
 'qede_rx_build_jumbo()'
Thread-Topic: [EXT] [PATCH 1/2] qede: Remove a erroneous ++ in
 'qede_rx_build_jumbo()'
Thread-Index: AQHXKVAKAi4n35jF+U6sz2JOr2jbJ6qlshHA
Date:   Mon, 5 Apr 2021 10:01:19 +0000
Message-ID: <DM6PR18MB3388733FA76041D09B546CA8AB779@DM6PR18MB3388.namprd18.prod.outlook.com>
References: <1c27abb938a430e58bd644729597015b3414d4aa.1617540100.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <1c27abb938a430e58bd644729597015b3414d4aa.1617540100.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2409:4042:278b:70f6:c9fb:d831:d2e5:ee85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0cee7313-5bc4-4b34-f08b-08d8f819c2b4
x-ms-traffictypediagnostic: DM5PR1801MB1980:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1801MB1980C32139468836C921D4B8AB779@DM5PR1801MB1980.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KpQIKxYUyzdF7879O3X/t8uQuGXXdOtpjoJ4uk3FZFqEGEgVfImv6xjkDW5yXWOmZ46NVzJTHPXgRkuyk8Pv+ROeExHiHHgEztk0IhmowDaq/b4domashZDTpTTG2wCQVrG+K3/mL13yiZF+DtRoPe0Xq2ul1/s0wZzy57zZ92XE9oeXxWFDaAKzi0SP9nBgbSKV2XrIsJWLXIj3Czw4QLrxYpg1Pn6OcdxbQY293RllPM3PpfS6uvqQMKngJwZQcnd1T+YxQ6I0RjRMxJAm3DPAiTWpuihqTX1RkMKvOiyfPFy+rFXqC5HskOQcWk7ctPezZNw2evCQnYOvrhyg4W2+WeQUGxwfd7CLRhGJG0uIU3Hx3NQMkM8KzzJTv62B7W2X4fYCYo1Ac/aAiNlbcpXpIDCnZzIzB90xneHKKXT6+G7LKdBCqNj4oXMz3Y7VHzEHv5XAwAw3anbYpdiPVi9hUVAtTXgXylkaUjp2cUCQlS4zxUz/onODqbo4ak+bYC/I9fEoFPWsWsDzhbTIXHA+EhC3xRwG7JH7M2xKhT9o0zN8ppuWrtCwWtByU4z/Xkpeaw/vj3ef3UW9+FwVvZg6SAJf6f2yzzmRYf+mBDMHHhhv92Vvxm4vGq1dMglqb6V3K+kKKqlpPlFlSIp1pftwK/Umykorl40Oduf7ugE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3388.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(39850400004)(396003)(478600001)(316002)(86362001)(7696005)(38100700001)(71200400001)(2906002)(54906003)(52536014)(83380400001)(33656002)(110136005)(66446008)(64756008)(66476007)(6506007)(53546011)(66556008)(76116006)(4326008)(55016002)(9686003)(66946007)(186003)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WNUuxp38y3vk9OcBnrrmP2IdsPtjw10u5qPYqZIBIOscJaCZGOYAkqGucPVR?=
 =?us-ascii?Q?VsYH/utBQtb/T+VYAA/OYutLCIQLhvrjQH9zA2j8S9IT8f/NgLs+MCTeQX3e?=
 =?us-ascii?Q?nUrOfpB/6sJ2QyGTRz1LOtALvNv7NooJ0onW+A0vM/mJfsQLgCfsWh3Wn3y5?=
 =?us-ascii?Q?KrZye3gA2VB2RS4nqnEQLcO+vjXffMNiLOVDamI7EVvYdfKIyrFAoDODEAQg?=
 =?us-ascii?Q?ZkvmX+p90UyYzFvCw6lVgLjpZj01Eq/A5plR81muhpEyz1ogQvsUEvfWHIDc?=
 =?us-ascii?Q?vvBb34B+I12RXW5rzVFeOAOSqSUj+HWIBL1c4p6oOkOlyem019kcc+1AxZ3k?=
 =?us-ascii?Q?BN5txyuo/CCWqK7EdHb931C7RwWzkdKUJkVU4yUTOcbwaVrEV37cBOaGktRG?=
 =?us-ascii?Q?DKj0OpmotbPCc5YDRlKFwHwzoqb4mLIwtm8r/AuQSjXhnz6SMhtiivVDTLXs?=
 =?us-ascii?Q?0eraweI26NoiHgyeIlcC6acxB7top3pLr/kDkSRxK9YGzq09mZV7o24PmBRu?=
 =?us-ascii?Q?qPzi0MqOaBJVhhyV8KF7H9e+RwN5MhZssx+BgbuWLF7ynikVLeho3e4oVSf3?=
 =?us-ascii?Q?AGprCTj5xNuFTJAsGbU3cWsx7Bq7i7gDOLpbo4KozsMbz0X3qmZiE35SizBJ?=
 =?us-ascii?Q?pHNwqGCgUEypR7iqeNfC+BcZWn97zybH8uikrzTmHwfYLRfgYF/FdOAnSYzk?=
 =?us-ascii?Q?iscMYrgBs6HaBIyTWU1HBp1u1gNf61y6XBSUFtSvvsydlelQ30XDhPORgewC?=
 =?us-ascii?Q?ByvdzzbTr57t5oncKcFOf/Ny2q/Y81rdbEJK+g+R4gzZT6T6wvMPn5OY51MB?=
 =?us-ascii?Q?ThE4tiMV1yLpYnCdBQDJIjYdXymmhKRDOianlwXllgQDykj2hId9KN4nyezZ?=
 =?us-ascii?Q?VmpGLICt5n+OJG55rP4mGEpMtN4gwfV99YPXw1a0KjGbl0+OiTn63woNL/8C?=
 =?us-ascii?Q?Lmj9JsPOvAaaP9L77ul/t/0cT+sEaPEcad8cYrLJKEvC7BjS7GXES1lVFGla?=
 =?us-ascii?Q?3lUo6HgUYabZZ3gKA8xsaaIoi0yokm3t17CN9egGVCWKmML1sdy9nSvwU6s6?=
 =?us-ascii?Q?Cato3UfJM26TNINkOakgkFZpzmoNjyEC1xbbcc4LcUtxu/Q3cD7rb2ql7SDC?=
 =?us-ascii?Q?Bqjcwift/vpLcFv/s9NENiqM4tMTfUa5hWcs3h+XyjTGz4CZKM4ABJxy5CTG?=
 =?us-ascii?Q?dsSbgtEFQicwYE4jx5kBNvUkrj9JSUbV9PjJWcWjhC1dDkCkt9AySD5UoMkt?=
 =?us-ascii?Q?5q/uw3m37A+PvVyMdh/OwkcjDgzANtmDBm5hR8bYWQ7zRLbt+lFdcCUwB6Lz?=
 =?us-ascii?Q?cg/gtyHKaLX6Mb3uJinGxADjBhu5EclDvF8VUreFqspPyuHwI8OO4obncnh3?=
 =?us-ascii?Q?53u9Und4t0ctE6R9o1IhFc4vdK2z?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3388.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cee7313-5bc4-4b34-f08b-08d8f819c2b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2021 10:01:19.5425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lpxvlUjtYO209nAa7ODDjqFR+qOr2zI3ubmFsKv24Zb1av/QK4CulXbLMSFutoN8urWn4f4RPz+Fm1mxJPGgXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1801MB1980
X-Proofpoint-GUID: rHgBb-hML_VPYI165opwgEGil760ImkE
X-Proofpoint-ORIG-GUID: rHgBb-hML_VPYI165opwgEGil760ImkE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-05_07:2021-04-01,2021-04-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Sent: Sunday, April 4, 2021 6:13 PM
> To: Ariel Elior <aelior@marvell.com>; GR-everest-linux-l2 <GR-everest-lin=
ux-
> l2@marvell.com>; davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-
> janitors@vger.kernel.org; Christophe JAILLET <christophe.jaillet@wanadoo.=
fr>
> Subject: [EXT] [PATCH 1/2] qede: Remove a erroneous ++ in
> 'qede_rx_build_jumbo()'
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> This ++ is confusing. It looks duplicated with the one already performed =
in
> 'skb_fill_page_desc()'.
>=20
> In fact, it is harmless. 'nr_frags' is written twice with the same value.
> Once, because of the nr_frags++, and once because of the 'nr_frags =3D i =
+ 1'
> in 'skb_fill_page_desc()'.
>=20
> So axe this post-increment to avoid confusion.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/qlogic/qede/qede_fp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c
> b/drivers/net/ethernet/qlogic/qede/qede_fp.c
> index 102d0e0808d5..ee3e45e38cb7 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
> @@ -1209,7 +1209,7 @@ static int qede_rx_build_jumbo(struct qede_dev
> *edev,
>  		dma_unmap_page(rxq->dev, bd->mapping,
>  			       PAGE_SIZE, DMA_FROM_DEVICE);
>=20
> -		skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags++,
> +		skb_fill_page_desc(skb, skb_shinfo(skb)->nr_frags,
>  				   bd->data, rxq->rx_headroom, cur_size);
>=20
>  		skb->truesize +=3D PAGE_SIZE;
> --
> 2.27.0

Acked-by: Manish Chopra <manishc@marvell.com>
