Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E412FBCA7
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 17:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732922AbhASQiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 11:38:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64158 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729544AbhASQhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 11:37:15 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10JGXg8r016392;
        Tue, 19 Jan 2021 08:35:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=xUVRaTLXROqr7Kjt4FLsANbvwrpwjEi0ov0GEaI325k=;
 b=jSyUmbArnSYxKMjFUFhEDDVHAgSWbcBql/zevcz/r9LrvFTsAq3thTt8e1RdVS7RXjT7
 +qrpEWuHJXVKw1Wn1RHQQY63s/TdR0D1xQQLoNCowcpDdTTKPRdP9XUNHN8oLQO5ondw
 93k2VwqiZUU3LimK24ZB+VrbCdQis5NiGVU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 364h2cj1f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 19 Jan 2021 08:35:51 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 19 Jan 2021 08:35:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hesW0XXou8s7l/NDdQeAS0yL4FMuGZstX04ljCk3vYVoXgETb+6I92GTAkiRmDCjIByOQW2oMQLvNnMXGA7vnNLJn4V4DFENDiwab3Smg4XRVIsYlxj5hinEkQ7mRccKI2hYmA3EjPlMOttefJRqyUuYA2xpwq214u1j9veLb17EPxIyBYzhCo+Zu8UXqaW937yEiYNGeyPQB2E1FoW6kqdSRxPc+5RVMzg8SS5rDs1qT2+cpRO7bhl9mwZeD7uu4F2UKr6AVjKzIhgJ29CsQgY79rsVB/e73U63pb7e55yqrhLzRxo56FS5OYTWGYc9DbYt/FINKr9r5VpM83z3Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUVRaTLXROqr7Kjt4FLsANbvwrpwjEi0ov0GEaI325k=;
 b=fzBA4QVGryipr6bBE0psHz6/LAzPyf5LjpGz09GLnUUGN24anblPTx0ut84uXlThq6RKALMK3YtXzaOPbNFnX4nPPftlucgMrCT9ervdaN6Gd1fDVw1+IOxQVWBA+KAGShLOe5lRuB7yDK5Qu7l5ujFdkuqICl8DYyVXfHtvvUVycV7Fyb7KFQiPod8dig71NmNhr0KmuQ/I+9BX/Rpg7ONHntuj4UyxSdoNQsuclmuMbqurIp8ikhtbUWeWyBfjfH9oekgwmd4mi5t5ljchBq91xYM6geJt67gbp3sMP877Nw1gTQuEpJ2jZmLZSHT06YxSvVsBiP4cTgfOlSRWjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUVRaTLXROqr7Kjt4FLsANbvwrpwjEi0ov0GEaI325k=;
 b=SYDMoeezlMW446oYpKxdj3RnQD5ZR7MC5k4lRY4b4AwXjHBSitInJJOa4bRiBz9udkWpWAkpMclwhcnYtXgFGECmhEJqYrN7UFzHw8yjLEMiZxiC8BkYNsmfwt9rKpNdmxQx3hzFAl/YQpw+FUbBDvKvjue4RB/9Pa9gZ3S7a/E=
Received: from DM6PR15MB2793.namprd15.prod.outlook.com (2603:10b6:5:1aa::15)
 by DM6PR15MB3036.namprd15.prod.outlook.com (2603:10b6:5:141::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Tue, 19 Jan
 2021 16:35:49 +0000
Received: from DM6PR15MB2793.namprd15.prod.outlook.com
 ([fe80::91c7:861f:744f:2401]) by DM6PR15MB2793.namprd15.prod.outlook.com
 ([fe80::91c7:861f:744f:2401%7]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 16:35:49 +0000
From:   Alexander Duyck <alexanderduyck@fb.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>
Subject: RE: [PATCH net-next] net: fix GSO for SG-enabled devices.
Thread-Topic: [PATCH net-next] net: fix GSO for SG-enabled devices.
Thread-Index: AQHW7l8KfVCqsvzg6Emy7mjA6jC5c6ovHdUg
Date:   Tue, 19 Jan 2021 16:35:49 +0000
Message-ID: <DM6PR15MB2793AC8087CB99E590C03B99BDA30@DM6PR15MB2793.namprd15.prod.outlook.com>
References: <61306401471dcfc6219d5c001580769c2c67377a.1611059420.git.pabeni@redhat.com>
In-Reply-To: <61306401471dcfc6219d5c001580769c2c67377a.1611059420.git.pabeni@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [50.39.189.65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3707f09-2bbc-4ae5-a557-08d8bc984764
x-ms-traffictypediagnostic: DM6PR15MB3036:
x-microsoft-antispam-prvs: <DM6PR15MB303619CBB258150864F467B5BDA39@DM6PR15MB3036.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y2fduGGdqgvSSpd8e7qDjI2RGsjIOKyUlFAIIsprJ23qBsvungJldYcleh86fbzJqvtYZSJITDa8Jc0WXsQvUeBh3thEVxL9qWPPacuIBc2n8n0DkhxQAHD27n/bWOUyUbBW0HgwqxRB8+ly11AYHCdhy3DxPH39w43Y53jvGP4zSPGbMV6z2ihC4cLHOYTE2zlimDIg4yYfZks6LRjRH6gYBtD3SSigpzTR7QMxfTzesidGp+Vps/GkwKabrUspBY5MqidiJ/ru0qJH4q/mHzNBHJ1MMs7f/JSbq9Jzky9YwwYekCTztIvJ9Vau68m7mEIT51zqHBF5Q7a7OYekTZAB7G0jz08a4YyxXxhs0l97u9JcRLDSDlZq8hZde4DlF1bim4oIUeSjgW9Gsn+3YQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2793.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(376002)(136003)(346002)(2906002)(7696005)(316002)(110136005)(5660300002)(478600001)(54906003)(8676002)(71200400001)(4326008)(52536014)(186003)(76116006)(66556008)(55016002)(9686003)(64756008)(66446008)(26005)(86362001)(6506007)(8936002)(53546011)(66476007)(33656002)(83380400001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pSrObmqUihBDD7Xf6aEWRsV1x2qR+XyGay9Oc1eAWh2jMK5gyXM3LwNbRzT5?=
 =?us-ascii?Q?zdZvFIzEMyCf3wUwE8UCHqWC64conMWeUQYZMQwJm4LVJmcvE1Cz2mMGloe/?=
 =?us-ascii?Q?NyWGa2B32u5bcxe0pdbXdMnVLFLtyuSdGrdFNFFw/wJiZruKDsiiIZmGSsdv?=
 =?us-ascii?Q?7AULYdU10ipMMwP0V2G4zgpwCbTSMIH7umNJxuoUgL5Q7W4hi8AiPOP1iifQ?=
 =?us-ascii?Q?E9JtpTsIdfsGlN6Ux0ggZQYim51ZGBhMMMMEqRaeN7qhA9yp806pOZC44696?=
 =?us-ascii?Q?RydxZUKVArM1GkN9ACp8L6G+TQmmmyn0cqt4ak+PE0tT4G6PypJbP8Q3nMC9?=
 =?us-ascii?Q?uE/i3ipEMLflF+0KzlmOtrcHU1DsZnalQwtZmLUZEZi9sLNQXxt6jHoFLNEO?=
 =?us-ascii?Q?eQEsGVNE7VLrHnEvgpCmqk7sLfVkhIbMq+PtGp1WfLtjWevmobU2HOcwvpq4?=
 =?us-ascii?Q?Gcfjlt5lKYAYs1szjvC8vDJlSgdcQeb9/TJIVrUgQXuan1MQRXN4x2Ii6mVA?=
 =?us-ascii?Q?Gq6vlekLlIF9nhfaWwqHhF16T4ZdXL8BZsSpmDc5Z+P3/+mBy9vOuQcaQoJ9?=
 =?us-ascii?Q?7JrpBQjmIjuT7AePxpGP9Sdf5AtrX020X+ppWwz/mb+uYZpE9JVORShJjuu6?=
 =?us-ascii?Q?KKJ6x8+IDZKVokwJy+ad7MFR/ZYuFAQ8hH0k56UBeYpa3PD2NajSp3Qg9H0M?=
 =?us-ascii?Q?SEisw7azUwNZkhiooJvTIwJOsOJYw12rtFJ9enmKdPauSmiXFg938h0K4waE?=
 =?us-ascii?Q?RgHrciGG9pv5rfgEjJFRGeizZZxqHlXUBL8iS/9FFL8HuukV/jgA1ZRQKVAR?=
 =?us-ascii?Q?agbaheJTLuy1ezGOuulXvQ82zFGvbhGrVD3TajHoC3HWZw54QHywqsm4I239?=
 =?us-ascii?Q?CMSHxmbu2SP1rWI7FMNenIFzhCtbASPf1o8EfvRZF61mUgbS9NKkLs85X0Ji?=
 =?us-ascii?Q?tbnZ+G66X+iUvAi3JOfrKgJOpv9hYCvcc4ah/Pqut6k=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2793.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3707f09-2bbc-4ae5-a557-08d8bc984764
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 16:35:49.1224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6RT1smZ944VjnJ6sUjcKbs/AVyE1gPvQeXnv2f4ovrirKvbSzd2XooF4BXiBLR4cP7D1ZGZSlZAGGHfbjLPPKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3036
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_05:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 clxscore=1011 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Paolo Abeni <pabeni@redhat.com>
> Sent: Tuesday, January 19, 2021 4:31 AM
> To: netdev@vger.kernel.org
> Cc: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Alexander Duyck <alexanderduyck@fb.com>; Xin Long
> <lucien.xin@gmail.com>
> Subject: [PATCH net-next] net: fix GSO for SG-enabled devices.
>=20
> The commit dbd50f238dec ("net: move the hsize check to the else block in
> skb_segment") introduced a data corruption for devices supporting scatter=
-
> gather.
>=20
> The problem boils down to signed/unsigned comparison given unexpected
> results: if signed 'hsize' is negative, it will be considered greater tha=
n a
> positive 'len', which is unsigned.
>=20
> This commit addresses the issue explicitly casting 'len' to a signed inte=
ger, so
> that the comparison gives the correct result.
>=20
> Bisected-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Fixes: dbd50f238dec ("net: move the hsize check to the else block in
> skb_segment")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> note: a possible more readable alternative would be moving the
> 	if (hsize < 0)
>=20
> before 'if (hsize > len)', but that was explicitly discouraged in a previ=
ous
> iteration of the blamed commit to save a comparison, so I opted to preser=
ve
> that optimization.

I would say it is probably better to just moving the "hsize < 0" check. Wha=
t I had suggested was a minor optimization and it hadn't occurred to me tha=
t this is a signed vs unsigned comparison.

> ---
>  net/core/skbuff.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c index
> e835193cabcc3..27f69c0bd8393 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3938,7 +3938,7 @@ struct sk_buff *skb_segment(struct sk_buff
> *head_skb,
>  			skb_release_head_state(nskb);
>  			__skb_push(nskb, doffset);
>  		} else {
> -			if (hsize > len || !sg)
> +			if (hsize > (int)len || !sg)
>  				hsize =3D len;
>  			else if (hsize < 0)
>  				hsize =3D 0;

