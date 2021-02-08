Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8180313F97
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236515AbhBHTvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:51:32 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55258 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbhBHTtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 14:49:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118JjLr8138385;
        Mon, 8 Feb 2021 19:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FRiwwLgKewS/evQL1QXgtx/6LD0pv2VnaStUhTaJsMU=;
 b=jWkwKmaB2bvFNnns11p2Lt7ydwSThSQt08h8vfAfMibpn0Rnwm1BXADyrlVROcDURdH9
 inV8a76pxPrKx7ROTAADWfBzB9rf4OZgGW1IZJx165UD6XL9U5g8hIXXJEyJLRsq0Evs
 j8BJ7UN2qS3HpCW0c7VfZl9C/pNBTMOCn/UHJRx43oXiIH/SHLUebJCOZlFs8Re4ZPiI
 3K2hejbT71pJ+XICOdpaIjMV74FFhiY5oWEh3yoCAzj3paq9ZTYZKjeHEA9yi1gpcK45
 9IDXCMvNwaUPa6pU2o/xmlxETCtD1yOOW6QnxLr2nc2CSo9n+D0QIUvpgJR2cYokub0/ QQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36hgmad9r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 19:48:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118JZqMn056250;
        Mon, 8 Feb 2021 19:48:42 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 36j4pms0p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 19:48:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLQGsz1p5qo2lfm/GHsbbP9grU6JxCalqBghUQoTiC/FbKx4i+G05K8MAuWRI7V5RoXn/2DZ8we6cfAaXbqmHxthO2cSiLNED4sUEnYIDOLeO9AeDEeZyFGLUo6j+yy2wtTKqFJMzvOJ8zBEXWcsY8CPrS96SJ5qM69NMA+dYQLXarLhrwKxGuIb3vdpV7WlVqFDDt8SrGo68VJVHn/MsiYoxMuHKAcMTmF6BrRmzmKI7tWGIA4vycClJfcMcD3OZGSH70AlXXY05bVF1Vg4yE/YEVPR735cINyFd9wxh1RqpTb2j857SmQQ0RgN8fQD8BVbXySV2qouCwa6tkWUqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRiwwLgKewS/evQL1QXgtx/6LD0pv2VnaStUhTaJsMU=;
 b=TVmx3l4AkAevi+TUKRC7/XcSlQrTg5PQCBdssksdKuZFdDWVrvn/kUBmd/ju+01wpZGpUI3tUuVHYa5EYibyzrHsfjyJ6cqen3ef/+5oIQbDFox+1627/ie42fwaDD3eRSpQJb3dB56NUjTlCdstTdHG4ND8MOdsg/Gwzp1WUr3ye/FcIaSdkQAwj7vTdbfKlz3nJv3x9XFu9/qIS92j5wiNpc6lRnQqigN7bC4iOBYfz7DUbHKIpP4IFrI5oUqrH31k7hMEUArNHMCX1XYa4kLMZeGxfwOICIjO9UZzQgOq75Q/EaRU6ar1sNAfQUVXLO1F2hU155xNg252AxmE7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRiwwLgKewS/evQL1QXgtx/6LD0pv2VnaStUhTaJsMU=;
 b=kM1kjO7Wqps5Y5l7+jLnrxGY1pG/wSeTqhkIcuQ7eLD47K/hd1Tw9H5Uw/afwNwFg4qT/dLr+WAFzPYIMaWmygG6VjB4ZdAjzI6s6Vk/sow9crXYLEmuim7MIhuWI+2kWdeMEgypj2bG5vL0QWGK+1KbsFTLpEO8Szf6vTX5wSU=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by SJ0PR10MB4478.namprd10.prod.outlook.com (2603:10b6:a03:2d4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.27; Mon, 8 Feb
 2021 19:48:39 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::6da8:6d28:b83:702b]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::6da8:6d28:b83:702b%4]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 19:48:39 +0000
From:   Chuck Lever <chuck.lever@oracle.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "daire@dneg.com" <daire@dneg.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.10 03/45] SUNRPC: Handle TCP socket sends with
 kernel_sendpage() again
Thread-Topic: [PATCH AUTOSEL 5.10 03/45] SUNRPC: Handle TCP socket sends with
 kernel_sendpage() again
Thread-Index: AQHW7ss9RlJPDpfZPEapNWcB2Zz3OqpOxR4AgAAEFQA=
Date:   Mon, 8 Feb 2021 19:48:39 +0000
Message-ID: <5CD4BF8B-402C-4735-BF04-52B8D62F5EED@oracle.com>
References: <20210120012602.769683-1-sashal@kernel.org>
 <20210120012602.769683-3-sashal@kernel.org>
 <2c8a1cfc781b1687ace222a8d4699934f635c1e9.camel@hammerspace.com>
In-Reply-To: <2c8a1cfc781b1687ace222a8d4699934f635c1e9.camel@hammerspace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: hammerspace.com; dkim=none (message not signed)
 header.d=none;hammerspace.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a82366d8-148a-4c72-d073-08d8cc6a87f8
x-ms-traffictypediagnostic: SJ0PR10MB4478:
x-microsoft-antispam-prvs: <SJ0PR10MB4478FBF4C7C44A15DB90E4F2938F9@SJ0PR10MB4478.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /AZ0xZItEHoH7WE8GKoONdavvxotYF1PhaWZbr+QsdEzpNYqbsBsfPhbtO/+Wnyr4J4udmM4WLNq51OQdL36C9NNNpH/JVKgG0FYM1Fg/ZlCE54zuXTJFqvas5v8RNIcmGX5FzyNkQkDLHQ7HFUEE97EufbRYx54ZlF51KSZtMV6tvL2WCsd/MW5iXuZhnjJ7HUie7x2Jux8sTdM6Y+x1JhSEG1VH3kcz5sXbkjXXK8eMEag6drEAghEc3PmzALjOuhefk5IYNLKGvkJSoS38v+C4IHQuvI4Pgx1skE6EcwSItYaixOqAYSzkIUCi83oXwOhlszSryr7SPHLU0z4/u4VcgDXWs7lACgRgjK6OHhuJjdkwRtMs8S8+ayMQ/01XwDssZdFnfPlqMWrVSNLeWMKh9T31w4lj8Sc4QY4ZtqmL865pbWsecijb+nwSpGNJclMqe3gIFm+IggMxzwOPNsVjY7DOYCq75tyroQnehr2hi9bvOLyo6oUwdt0qJ+YhYM0a9yMYhcpYDXHgZSidGJtYp/bgz8UE+POqaDrm4ynmkmPOlB1JaiKc3IHDc6wR77F8vXxTjB1uS0yRJh7FNbH/y8rvDhHQzpqbTerry7FVsxA4FLOuI6VkgIMLLX3kK1MAbFJhqHMxu1zMLZ1xsUYpD1djTLpgyRxzIOWte0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(136003)(376002)(44832011)(478600001)(2616005)(966005)(83380400001)(26005)(4326008)(33656002)(36756003)(91956017)(71200400001)(6486002)(2906002)(6512007)(53546011)(6506007)(6916009)(186003)(66476007)(8936002)(64756008)(86362001)(76116006)(66556008)(66946007)(66446008)(54906003)(5660300002)(8676002)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WJbylZr0WDyd0grH5yq+fiIsByGJzNmdAytEinpDXxX0dUQLR/RyvRd+MCkG?=
 =?us-ascii?Q?r9Z7xHRAqfZxo+UNsWEm3Fl1YfojJzWTtTvWu0TFo415KPZ03ulFq6GtFcOu?=
 =?us-ascii?Q?owm57IWFzdJoch9TO4EL42IhOTHNef5r1Ft6KfhGSjV+RftlKKdxIKbz9NLY?=
 =?us-ascii?Q?bQCEd2zlzCP905bTCfW1kDCx7zlwToeWO9l9oCjxX8esuU7WKW8uF9qFyxVt?=
 =?us-ascii?Q?/Ot58FI1RORoqtla9elkcitXquz+zQ/JDrGoi9nxFJ5hkNCmFU5h7YjsQufu?=
 =?us-ascii?Q?K4DEJGWuGxZo40IcnsDtZVJW5qQu1RkFW8ILyOMcQRHwKwoeM7l7Ewso3KNE?=
 =?us-ascii?Q?GcnDzbIS+Fyia3xevZpuumNFDs+Lh3s/IQOoy+hKdmTjRyL+P1gtqXBOEzWq?=
 =?us-ascii?Q?CZvEmQ+yZTCwYFv1YIenWJLezU3qJPae/cGy6UyCI13mQa37hr3676q0YRsE?=
 =?us-ascii?Q?B5ZS07cybLZTzn+q5t3xjLFe+jyFh8KcDhN4EQXUP7TK0yMu+iSiA58Z0Pul?=
 =?us-ascii?Q?KUUCwGNrqvAKERGRA8zVMRsfWUJWZ2gNv2Vx6QUBh24uw3zSfR4CmDUnOnHE?=
 =?us-ascii?Q?Y2nh5CrDXTnc4qSyTKGpfuEEEmqH8cb3/2nNpQXRXO5MqIiakuDgtjjU3IMG?=
 =?us-ascii?Q?BC1487/vtzvaGGPHbhzBzI+Ark4MeyfXV2OCCrX0gXgXhNOfdlhEhdzg6jhA?=
 =?us-ascii?Q?FfeM9ODlEFE3GF0w9EvgSvWTHS4SgMzEO1Fytp6MMcsdD0fRChiVRzYl9AV+?=
 =?us-ascii?Q?AfY7jlOw0I+GFMeK6Mk6FDYBJQMDtz0GpqzMFjoq3P9U5sFEqIcUmVLmT2RO?=
 =?us-ascii?Q?+ObcfHlmjiu5q52dlyYcm6DVC3Py6XCIxn2lkEZblWFFumwqRMcP4Z2AejEB?=
 =?us-ascii?Q?YSvJVr2xMoP+h2Vc/fJ+8xpfL23F2jZCmccKC2X53dCGTGFGq50f9v0kOqfa?=
 =?us-ascii?Q?j4ck/fbTXNtsZIu/ioyUcuzm+blQJv2Pn8yQAYf+d3xvQrABqDqaL5BtHc7i?=
 =?us-ascii?Q?p175/vIjq8kCkYjbbfRILUrjvrbreBEfkFcFiUBpG9n6DMJh89F8SFOuarJj?=
 =?us-ascii?Q?/7w4UVOMng6GG7wHOM1/Y/1m+lVJE5XlaM53xz73WXDWkGOmXeb5b1A6cZu3?=
 =?us-ascii?Q?IjzLln3b0II6tJJ0poem5FqMP6PzCf7I/bji9zvxq1GqjDQ4GDeXH9ywt3As?=
 =?us-ascii?Q?AMT5blEwJ08fvFAZOZdIOMH95GlW5oGefp0wa59qQvVcHzVlhA7dSACz7WJg?=
 =?us-ascii?Q?2M/agP03hIHWnt05Pu75WCbizzLSh8hF+wPmLz17WrPGVlR090kB2wrePBI0?=
 =?us-ascii?Q?1dBiASlRVQHxiEaY6E/V8vHi57Spd6PT8Y/ybkU4ERi5EA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FD25100107D9EA46BE1F8E55552DA598@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a82366d8-148a-4c72-d073-08d8cc6a87f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2021 19:48:39.1291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GXg5DsMj5G1Bmqs/Hpsma107f9lOxqkqUW6NJatBHyQH1H+flEcupUq7fskqduA0FJkeYDyCczzhlokf477O8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4478
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080117
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1031 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102080117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 8, 2021, at 2:34 PM, Trond Myklebust <trondmy@hammerspace.com> wro=
te:
>=20
> On Tue, 2021-01-19 at 20:25 -0500, Sasha Levin wrote:
>> From: Chuck Lever <chuck.lever@oracle.com>
>>=20
>> [ Upstream commit 4a85a6a3320b4a622315d2e0ea91a1d2b013bce4 ]
>>=20
>> Daire Byrne reports a ~50% aggregrate throughput regression on his
>> Linux NFS server after commit da1661b93bf4 ("SUNRPC: Teach server to
>> use xprt_sock_sendmsg for socket sends"), which replaced
>> kernel_send_page() calls in NFSD's socket send path with calls to
>> sock_sendmsg() using iov_iter.
>>=20
>> Investigation showed that tcp_sendmsg() was not using zero-copy to
>> send the xdr_buf's bvec pages, but instead was relying on memcpy.
>> This means copying every byte of a large NFS READ payload.
>>=20
>> It looks like TLS sockets do indeed support a ->sendpage method,
>> so it's really not necessary to use xprt_sock_sendmsg() to support
>> TLS fully on the server. A mechanical reversion of da1661b93bf4 is
>> not possible at this point, but we can re-implement the server's
>> TCP socket sendmsg path using kernel_sendpage().
>>=20
>> Reported-by: Daire Byrne <daire@dneg.com>
>> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D209439
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  net/sunrpc/svcsock.c | 86
>> +++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 85 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
>> index c2752e2b9ce34..4404c491eb388 100644
>> --- a/net/sunrpc/svcsock.c
>> +++ b/net/sunrpc/svcsock.c
>> @@ -1062,6 +1062,90 @@ static int svc_tcp_recvfrom(struct svc_rqst
>> *rqstp)
>>         return 0;       /* record not complete */
>>  }
>> =20
>> +static int svc_tcp_send_kvec(struct socket *sock, const struct kvec
>> *vec,
>> +                             int flags)
>> +{
>> +       return kernel_sendpage(sock, virt_to_page(vec->iov_base),
>> +                              offset_in_page(vec->iov_base),
>> +                              vec->iov_len, flags);

Thanks for your review!

> I'm having trouble with this line. This looks like it is trying to push
> a slab page into kernel_sendpage().

The head and tail kvec's in rq_res are not kmalloc'd, they are
backed by pages in rqstp->rq_pages[].


> What guarantees that the nfsd
> thread won't call kfree() before the socket layer is done transmitting
> the page?

If I understand correctly what Neil told us last week, the page
reference count on those pages is set up so that one of
svc_xprt_release() or the network layer does the final put_page(),
in a safe fashion.

Before da1661b93bf4 ("SUNRPC: Teach server to use xprt_sock_sendmsg
for socket sends"), the original svc_send_common() code did this:

-       /* send head */
-       if (slen =3D=3D xdr->head[0].iov_len)
-               flags =3D 0;
-       len =3D kernel_sendpage(sock, headpage, headoffset,
-                                 xdr->head[0].iov_len, flags);
-       if (len !=3D xdr->head[0].iov_len)
-               goto out;
-       slen -=3D xdr->head[0].iov_len;
-       if (slen =3D=3D 0)
-               goto out;


--
Chuck Lever



