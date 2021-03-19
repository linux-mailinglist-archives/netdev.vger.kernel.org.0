Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A36342057
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 15:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhCSO63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 10:58:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60824 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhCSO61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 10:58:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12JEtFK7152459;
        Fri, 19 Mar 2021 14:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=nNVI2SlibpAqRuIbVH/8Rvr0V9uwZeoi4aLmgOlLGJc=;
 b=C70HwVz0YHf/Bz9rWAPJLzLCx9ef4xhBw+ZO3BmOEVbh1VJhXr01GecY+DXTCE/CQsHM
 iCD1/H470zLGS3o4Ki3WJAt1nQ43YNsbl8R942CXonfWRxleVI4dSzXRFlJRC68oLJ9G
 y1Hi+Dh1eUkaKamndhGgMxSjARLbC2sWFYVu1CyZpQndsBpvBCvynhb5HfnTNhpPd7qS
 oD2ZGvbNsjBPjQImICs7GW0/HTsQFz1oD5Wgt0avuPA05TczIpc2SQgfaEOmL6HZn+GS
 tu+VM47Ox6KIVYD6tMcFA5OK0h09BvJzjUDZm3gEkYJIDof69ODyTD8bpt8N/AV/rAW6 EQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 378nbmkakr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 14:58:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12JEu6IP014110;
        Fri, 19 Mar 2021 14:58:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 37cf2vjd9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 14:58:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xlph2ZI7fwXqoRzFU122BDp5g6u0/VD5MCkCJ89EiHI6jqzEqttpvbGkJy86kp184tNt61O4Qhn47NyV8k4pXglLQcB5PooHEDzUOKbDBZ9pZs7Wm1nuz0orBB/5MMaxroUoz301oxg7xZchBOVPDWY0HliFyE+AZHYVIg9O4Urah7EirEIbUE0IF67x902yRyQNtvCD1mc7SIKxdFQOpl8ngKSpmlBUe8qSuet3CW2nXd5i9QL4dLVixJTMg5QCnbjYfwKKcQCR3EPCxHVjuYlYHEENoDE2SRA2QENw1lGrbnVgQgUQD1MD2E0rQHke2ISO/Z1ekhffozAAG8Yl4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNVI2SlibpAqRuIbVH/8Rvr0V9uwZeoi4aLmgOlLGJc=;
 b=LGiLmqvkyXDaqqOCn++h0lDnbWTjKMrZc8bakCdCPxj6AH3E4MdG/VQcpQWoO9avtd4a5BPV1VgRHOeYJfm0tOFCII8v6gdnFndCib93oK8u/V9WzLq0n9zj0A2ElUvberU+Rw2laLaBh891CVdgjCQxKVy5JNUTDfZShe5d1G7IeiDU0I/4Wyvt+9L3Uz4n4FYajo4u3HRESXkLVVnwqV6sLIv/niM5deCpJ+lxleHSvyBhq8qevEAWCCUfjFJIMU9XaTN1kOkPwDwRJQiHBmbQbPKPFjmblSLpTFnk5my0hOg48/xMFKbsue3g8W+3aHllkI0sHOtCbGyIChP4zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNVI2SlibpAqRuIbVH/8Rvr0V9uwZeoi4aLmgOlLGJc=;
 b=B1csSbBX4k8M5zAQaeZrQIEE78zGQ7ocEn5adrNQgU9W4KVxKoYLtp/92mlbLSQeWGYV56IhS1mt97uK1Z5yo8K8flSd2+1nZweTGwNDRzg80hNmmBY577MgWeTk+46M7FretiJjNo6S/1/55pkO2mtiru8Cx9CGK8kZf91Kuek=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB2439.namprd10.prod.outlook.com (2603:10b6:a02:ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 14:58:15 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.3955.024; Fri, 19 Mar 2021
 14:58:15 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Chris Down <chris@chrisdown.name>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bruce Fields <bfields@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] SUNRPC: Output oversized frag reclen as ASCII if
 printable
Thread-Topic: [PATCH] SUNRPC: Output oversized frag reclen as ASCII if
 printable
Thread-Index: AQHXHM/NVCtugqioaUyypXdJqaYWcqqLZvMA
Date:   Fri, 19 Mar 2021 14:58:14 +0000
Message-ID: <3844BF67-8820-4D6C-95BA-8BA0B0956BD0@oracle.com>
References: <YFS7L4FIQBDtIY9d@chrisdown.name>
In-Reply-To: <YFS7L4FIQBDtIY9d@chrisdown.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: chrisdown.name; dkim=none (message not signed)
 header.d=none;chrisdown.name; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61a9c25c-7655-43cd-70fb-08d8eae76c78
x-ms-traffictypediagnostic: BYAPR10MB2439:
x-microsoft-antispam-prvs: <BYAPR10MB2439814B5331A1CCD64B70F393689@BYAPR10MB2439.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:517;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DtvH41obOuGrC20zYHd5fndltkU0qfG6Rq+ZybKb2gcjSV90iKoQpYQggVDIJbVV4PaFLJhgtPVG5AtBM38hezRsOrxS6Ia0NZJhOaAVQtoSTdJNc+pbjSkZHeMXLNOuyGKWHKrKR1yHleDIStvVIbI5jbSXdye6H/bfXJ7vPJN86Bsfu/k3Ms0XhM9KsIFOHMkI9nZGH3aUzvgUlCkA9H5LCDGQ2Dyp52ZSa0wf+eUt2qpIQXuhYricZO/DuhZzeXbAtUVeaoKiwvyl+wQ/8rfTKNfu0LLMuMt8FFeubAwZiG3cBz0Z/SmUcpWTz8GsZ8DKN8iPYanIoje97Wbkgk529AYo15jnq30RI64awthf5mva7Mcgg+4j/9slgBlkYazHxexhzxe9+o4a8uVE0hlESZFNp+QXflpW/HXAR+UPwUfEMmAYNURWl7tiTtlnZLIoZy6BhmItAeND0oshbrLJYsBTlMbkQZhQGR4L5kGftGwj2PZKIxPGxACgZvNw7cTftL1nKRzXV9e29tOxewVqYJuXkRSSrB/FQDdbx8wvvIRApN7ij7AVZeXMqB02aMK4211sip8OHLaKxTtKTSOgwD0CeShRPzT9o0XSvwhIggbWa5NjBazYonrZAXiRXH1mIK1z0vSHrRqyPTbWK68oqV9JOUUHergvPp6E+eHm9Q3QJrlopMqOi3VLtQGA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(2616005)(36756003)(26005)(4326008)(478600001)(2906002)(6486002)(6916009)(86362001)(66476007)(5660300002)(6512007)(66556008)(54906003)(6506007)(8936002)(53546011)(76116006)(91956017)(66446008)(66946007)(64756008)(83380400001)(8676002)(33656002)(316002)(38100700001)(186003)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?AzwcINYNYnC9/atabXGfmf2hKa+y1F13s3ffw64klZSJ5uB2HGOBzq+W9kPr?=
 =?us-ascii?Q?PE4oVAnk1seeq03WXuA9ScigDgGEutMwmxhkPfWOVZ9sJzyMwUn2uGsoQPoL?=
 =?us-ascii?Q?ad2u35Wk2O1+rUHgccdB26a92tsndsx/bj2G12akubCYBlub4246QNLA0m7w?=
 =?us-ascii?Q?VvDel6iiyJcK1hjA2cLaE6UTYbBfJNNCSLXpgIgVFoXS5KcVW6ntoUCMEbDd?=
 =?us-ascii?Q?kFBQEcX4HKTBOoem/wseB4UTr5OpSOM3v7mUMjmhaRPr6Hqt7Np59Z4Fo2D1?=
 =?us-ascii?Q?J1ZInKFwQEGIr0ctHyWt8ydGyuqagCR0giads4SOhfbnBvtKlrrYEpHXjZS0?=
 =?us-ascii?Q?zDJHFDxMaTBHk2jaADyG92eOAMuUA5iW5xU+WrTuNz+x22gzG+mjAlEZ3Q5X?=
 =?us-ascii?Q?pTcS3aVtiGL5I7qMV1ZZRzCuLWZ4Rt+3Xzfo1fKBpicyGqU7dKCu2KkDWfS9?=
 =?us-ascii?Q?FwBuJ7e9efYnwe1uVFZInUwUNEVbrEcweUstcyOSwSUJE446f13mixVFExm+?=
 =?us-ascii?Q?qNUulgCD18PEVP/lqWiUIC9ueR2euGXBfVzcgTuG/lfzAEIrWe/B3IpiItHw?=
 =?us-ascii?Q?rFbFvZ/F/j/CqcKbqPzq9zc3dTRM7bV3sFXxBD8lRtuJ0YD0QTl0MZepwO3v?=
 =?us-ascii?Q?IsT5W7NBzYjMaGxSxg6pkXvv60coeIckryrnephZOkSc3iJvVshGIbfMh8aM?=
 =?us-ascii?Q?wXWq8eMOALObZH8QDTYkA2e88sInK/bPvivxtzMcl4kZuS0LtheFapipWPUx?=
 =?us-ascii?Q?vJ96O13ZaquMwQfD7kFdy12fn4lkCsyaZ0bHG5iSnrJ/usvQtkYP9OYZmRqX?=
 =?us-ascii?Q?00onZ9p/1LWCOkZqpeOo+rDjevEo8M++sVr7k7z8Kj5zkYU3pY98nmJgxM33?=
 =?us-ascii?Q?qbxLfan/fihBzql2CcpqVF2XRBZpzdohpd3CQJmHwZkH3UECJaSm10qcjuPN?=
 =?us-ascii?Q?XZFkwU2gYZUHg1o6NKhccBw24+Zz+5eInHj21i4EA2HMUKQVlyFEcJ2V49JO?=
 =?us-ascii?Q?XKgFfo//8azsgrgtHbJnsZfVZ7yFPWse6IZH3eoXYyTFS4xiLL+p9amibAlg?=
 =?us-ascii?Q?QFO20OR7QUrDbwlCnRSI0hx1cVlgJIz5G9TKojC7WLJuTYYzEHoFOZc3y9rd?=
 =?us-ascii?Q?ZYKESjwgqqhI09sb3yVlcM2/4FE7NvkQmQXDFwAo/qcFVbe4CClI1H7QajYn?=
 =?us-ascii?Q?zYCbyfmrrPex7GTmbKm1ss+3gzubPUeF9zGgRYbTe7YsifuBpqU9X0pkXJhi?=
 =?us-ascii?Q?YC8Fu8uN1h5rDyHBxHtEQ9YLTHa3mc9N+sDpQYJy9e6ivR6N6Y5HcDuCRbzN?=
 =?us-ascii?Q?ugrNnNDXRj2tlMOKV27CL2oA?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <96D966773025584A9C79AA4F046D2A71@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a9c25c-7655-43cd-70fb-08d8eae76c78
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2021 14:58:14.9599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0uiVPlz6iXR8hcajzqudS7Qob1XVEDDJf42OI4ixxzBmue+u6Zlov4AdscynxNI1UyHhP5PF+gJv+h/KGhuxMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2439
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9928 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190107
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9928 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris-

> On Mar 19, 2021, at 10:54 AM, Chris Down <chris@chrisdown.name> wrote:
>=20
> The reclen is taken directly from the first four bytes of the message
> with the highest bit stripped, which makes it ripe for protocol mixups.
> For example, if someone tries to send a HTTP GET request to us, we'll
> interpret it as a 1195725856-sized fragment (ie. (u32)'GET '), and print
> a ratelimited KERN_NOTICE with that number verbatim.
>=20
> This can be confusing for downstream users, who don't know what messages
> like "fragment too large: 1195725856" actually mean, or that they
> indicate some misconfigured infrastructure elsewhere.

One wonders whether that error message is actually useful at all.
We could, for example, turn this into a tracepoint, or just get
rid of it.


> To allow users to more easily understand and debug these cases, add the
> number interpreted as ASCII if all characters are printable:
>=20
>    RPC: fragment too large: 1195725856 (ASCII "GET ")
>=20
> If demand grows elsewhere, a new printk format that takes a number and
> outputs it in various formats is also a possible solution. For now, it
> seems reasonable to put this here since this particular code path is the
> one that has repeatedly come up in production.
>=20
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Chuck Lever <chuck.lever@oracle.com>
> Cc: J. Bruce Fields <bfields@redhat.com>
> Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
> net/sunrpc/svcsock.c | 39 +++++++++++++++++++++++++++++++++++++--
> 1 file changed, 37 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 2e2f007dfc9f..046b1d104340 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -46,6 +46,7 @@
> #include <linux/uaccess.h>
> #include <linux/highmem.h>
> #include <asm/ioctls.h>
> +#include <linux/ctype.h>
>=20
> #include <linux/sunrpc/types.h>
> #include <linux/sunrpc/clnt.h>
> @@ -863,6 +864,34 @@ static void svc_tcp_clear_pages(struct svc_sock *svs=
k)
> 	svsk->sk_datalen =3D 0;
> }
>=20
> +/* The reclen is taken directly from the first four bytes of the message=
 with
> + * the highest bit stripped, which makes it ripe for protocol mixups. Fo=
r
> + * example, if someone tries to send a HTTP GET request to us, we'll int=
erpret
> + * it as a 1195725856-sized fragment (ie. (u32)'GET '), and print a rate=
limited
> + * KERN_NOTICE with that number verbatim.
> + *
> + * To allow users to more easily understand and debug these cases, this
> + * function decodes the purported length as ASCII, and returns it if all
> + * characters were printable. Otherwise, we return NULL.
> + *
> + * WARNING: Since we reuse the u32 directly, the return value is not nul=
l
> + * terminated, and must be printed using %.*s with
> + * sizeof(svc_sock_reclen(svsk)).
> + */
> +static char *svc_sock_reclen_ascii(struct svc_sock *svsk)
> +{
> +	u32 len_be =3D cpu_to_be32(svc_sock_reclen(svsk));
> +	char *len_be_ascii =3D (char *)&len_be;
> +	size_t i;
> +
> +	for (i =3D 0; i < sizeof(len_be); i++) {
> +		if (!isprint(len_be_ascii[i]))
> +			return NULL;
> +	}
> +
> +	return len_be_ascii;
> +}
> +
> /*
>  * Receive fragment record header into sk_marker.
>  */
> @@ -870,6 +899,7 @@ static ssize_t svc_tcp_read_marker(struct svc_sock *s=
vsk,
> 				   struct svc_rqst *rqstp)
> {
> 	ssize_t want, len;
> +	char *reclen_ascii;
>=20
> 	/* If we haven't gotten the record length yet,
> 	 * get the next four bytes.
> @@ -898,9 +928,14 @@ static ssize_t svc_tcp_read_marker(struct svc_sock *=
svsk,
> 	return svc_sock_reclen(svsk);
>=20
> err_too_large:
> -	net_notice_ratelimited("svc: %s %s RPC fragment too large: %d\n",
> +	reclen_ascii =3D svc_sock_reclen_ascii(svsk);
> +	net_notice_ratelimited("svc: %s %s RPC fragment too large: %d%s%.*s%s\n=
",
> 			       __func__, svsk->sk_xprt.xpt_server->sv_name,
> -			       svc_sock_reclen(svsk));
> +			       svc_sock_reclen(svsk),
> +			       reclen_ascii ? " (ASCII \"" : "",
> +			       (int)sizeof(u32),
> +			       reclen_ascii ?: "",
> +			       reclen_ascii ? "\")" : "");
> 	set_bit(XPT_CLOSE, &svsk->sk_xprt.xpt_flags);
> err_short:
> 	return -EAGAIN;
> --=20
> 2.30.2
>=20

--
Chuck Lever



