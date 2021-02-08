Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D745D314042
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbhBHUUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:20:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48778 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236601AbhBHUSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:18:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118K5RZO120669;
        Mon, 8 Feb 2021 20:18:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ScAYDauduLz+JKM0Lz8Io5WswnJf4NlRf+0OEba4dt4=;
 b=zJ9r64rovYpRfJYLR+cBblcSMiUFAPqd+HnjpJXyXUjeFmqKg/L5nl3fKQSLiTs1Xzcu
 NBlavU3lV+wSXo6zyHCcXYEZEMbyQDitQnq0h7KFXN85vXMUOks8TlM9giJ8wKd+99A6
 zhEscVjLDUik/8nL5PyaAnznnc3qUQt79+RSgQUFsOVCiJ420XRvyc9OKySnZ313S4nw
 etpjt/BFbtxjefsWtKRUIynLPf+fAyhMFOGVIjsQbvvdmd+AYGzX2qADLl9+XLTU8lHu
 l2Ritt+q/y8RMVuTT5lqlj83Ab3hrtLc8M7sEfMk0trl4mX0Bc3GNKN2cB7y5rG6Ha9l Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36hjhqn9da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 20:18:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118K5LuJ020730;
        Mon, 8 Feb 2021 20:18:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3020.oracle.com with ESMTP id 36j510a00u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 20:18:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ck1RWMvL8KzkCRVhFF2O3ZucE7vB7CSX/PMUiF3n4Vi0FkUIKnJmLXVoUXHWBzZDJSGhuHguLUrsTl9oOgTdOysNbbdJX6F89oRjIIUetidIaHtc8Rcc+U75T1P9PjxAaf0LdnJMow3VVXo9Qt6/N69fTKPtmqa0fA8w/mK1syyh+ezW21gzoASp5UddiYYhfJatPbibu9qyocbtsr71ZkhZGBQ0PoT1IlDQ3jGfXCXWfTe1JsipQERdFf3gu6kkb5fSeNQ+pbc9pjffN00pDdGAOGxh8czjEOtnm6S++zsZFHoIdHieSOcBw2/A35c8ohQ5VJKJpvQQhn3qf0t5pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScAYDauduLz+JKM0Lz8Io5WswnJf4NlRf+0OEba4dt4=;
 b=awlWEZKwZXmkh7bC1u9do4KfrlpaD3gtYGxK0fEBwzmfSEujszPQbOFH7wYrZRQt8EFaSBCXoEbaOuVzY3P15CvRIu5CeXQFXzKSeQMLeS9oiWW1L4GHbdj2xcNhNIDPjcdQRMi2OGTCi0+JhqyjdknTRrKOmHeIlN7S7bbb1+DCkd0hEBpEzn/3MiAOpzYLXu53WIHxz0FEaGkLEeULXohQI90BQA7V2qgkMtqiF8qW9L7QJIi4vzfyV+4PccJ28G0KtSTYcuEfhHXHJl0p2ui+6b3QxZlEXwfCdxEV9vLOGAK+y25qx6FFdCroyGkyaChWTqJjVdYmLYgiZ8rU8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScAYDauduLz+JKM0Lz8Io5WswnJf4NlRf+0OEba4dt4=;
 b=e2W8YMxb1J+2sXuUGBCkxkqWBIQFptm/IIXwO/2nSRwkFQfJX/0aOTjllfT68gyDCCmr20qJAaFGAZZqy1gL4yyD952N5cTn/Qn2U8c/FJ/vgWcFty3nG1c8Vm1uj/xqQvkvCkcaN+sPQlxy7eoAw2rTDnsrbUq3LA5od8O9sHI=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BY5PR10MB4036.namprd10.prod.outlook.com (2603:10b6:a03:1b0::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Mon, 8 Feb
 2021 20:17:58 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::6da8:6d28:b83:702b]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::6da8:6d28:b83:702b%4]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 20:17:58 +0000
From:   Chuck Lever <chuck.lever@oracle.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daire@dneg.com" <daire@dneg.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.10 03/45] SUNRPC: Handle TCP socket sends with
 kernel_sendpage() again
Thread-Topic: [PATCH AUTOSEL 5.10 03/45] SUNRPC: Handle TCP socket sends with
 kernel_sendpage() again
Thread-Index: AQHW7ss9RlJPDpfZPEapNWcB2Zz3OqpOxR4AgAAEFQCAAAasgIAAAYSA
Date:   Mon, 8 Feb 2021 20:17:58 +0000
Message-ID: <E1E68CB0-3A46-4040-97F7-89E03FC11C9E@oracle.com>
References: <20210120012602.769683-1-sashal@kernel.org>
 <20210120012602.769683-3-sashal@kernel.org>
 <2c8a1cfc781b1687ace222a8d4699934f635c1e9.camel@hammerspace.com>
 <5CD4BF8B-402C-4735-BF04-52B8D62F5EED@oracle.com>
 <6a137e45966fc297671d6f7218b9603d856c4604.camel@hammerspace.com>
In-Reply-To: <6a137e45966fc297671d6f7218b9603d856c4604.camel@hammerspace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: hammerspace.com; dkim=none (message not signed)
 header.d=none;hammerspace.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2be4b114-30a7-4950-e315-08d8cc6ea062
x-ms-traffictypediagnostic: BY5PR10MB4036:
x-microsoft-antispam-prvs: <BY5PR10MB4036C3D934FBEF68BF51980C938F9@BY5PR10MB4036.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3ag4wgLIshfUktr9+PMSZ2Y7x2yPzmz5wWKx7KXVhmuj9ZF2jM4dFhHFoK3FiuEIn5Ge/lfuGWSLzaKVsbti6wUivg8zeXg1zkr2aIpJZIH++0fdtPIPt+a8TlSz2JKoptL2d/y0G7Fs6FF1ptwo4sCtehCnFN92h7impOb17XALknI5hwaFcvmY6aJaW05s3kj/mOrS0JkmPcLb1PlyIiYR0eMi85qp2AgLDnrNR4wdVjdSTlSgI6n5Xg5rIXDT4QImTZtYBxf+irbG0pnoBeXQif2uVlv4fCSYvRw0a+/gc7KNKt5rczA56xDA7KHeuqebDvLTLcqkeo/4m3R/YjFVxR1GfV1WjsWDEMznboUsFtJH5rQ2AggvFXAH5pP0jz+UAtKWlH3PSXtGPGJhD5gvEofucOimYP/2CqqeUAnRPzWB6LqRcdCWXnZIqgLi+ihq67/rUJJxnLBgc4L3vxc0MAJbY+YN9Bhv78WZzzotrAQpmzcGAgw6uf+w0k/dAGeLceJz2K8K/S21XNR2hvIiXfs85nG7Z6j5zrnx3Bd2vCV8stM6WIRJxuhDS/TRLSia+nIHXgfpHq5hu3skNqnuIeWLrFA9PrAt6/nR781sHL9bNsIx5x6aAo0VRtFLmmid1+s44iFctUxVEoUZqQeH20cJoH4qrhlF/gN0u2k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(376002)(39860400002)(346002)(54906003)(36756003)(6506007)(4326008)(91956017)(64756008)(66476007)(86362001)(71200400001)(66446008)(53546011)(478600001)(66946007)(66556008)(83380400001)(186003)(8936002)(76116006)(6916009)(5660300002)(33656002)(6486002)(2616005)(2906002)(44832011)(8676002)(26005)(966005)(6512007)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?BodNk7H9NrJneLaMTFD20HLxdo+OIzWDnoQ4/ud0yjS4YfSJjH41LBagBFG2?=
 =?us-ascii?Q?NPX4dvQ7DzVfbtsYqvxiEWNd8MV63epwg39ckUtx1Yx/0UxULeoSWvWoEAqr?=
 =?us-ascii?Q?n1C4TBW5htkfnXObyvMdOU5jlD6XbwoaeHjWW3YGXfCKAPMVpd0X03FcqxR6?=
 =?us-ascii?Q?ha7aaPrYWDi8Isr426A8iws+2LMFnf7Lus/SwzIaPV9w8IWgQ3KgwSBOgxVC?=
 =?us-ascii?Q?VfbxyDGvFd05oCrI+NbyK/w3eDF2g+UXp2AfBzadzVlt3CAa/vOO+k6hqIeZ?=
 =?us-ascii?Q?uDwPUGaoe8F1BvgwVdNmULZEYUbopWZKEN7s+eX1kZhfwpl0xS1nRSqd5KMZ?=
 =?us-ascii?Q?6xdqguHirLvsT3umet8DM0cmRon85+un8342ApZMGaIPtHhXCdy53uc2BtB5?=
 =?us-ascii?Q?1XpBdycP0pBR+KakfSMDfQ3gPwkrfTHOVzU+gqthZyuav4JA83bcnLLdGcVG?=
 =?us-ascii?Q?r2zk0XezGmMNOw42MydisMwGQLW1nD6Edh7EU5fPa6E3xsKw91VvJtLrBNoY?=
 =?us-ascii?Q?msgH79IPUmRt158RB6/RSIj4Q0NjccMNPn8b6Vlig2f+H8NFQS75Zq5+4/Hd?=
 =?us-ascii?Q?HGHhRExZ8PeL6q1AVNXJC4KHEnAQ+0OzRJ96Nb7LxHxWFoppkpT4bC8HC1b/?=
 =?us-ascii?Q?nBVlh2lxJaUS3HG6gGuHUhuq1atAUx5+uHDBrTLhiKvTb7ttdWak5QyjXSNE?=
 =?us-ascii?Q?kYrZxwcciEoB183kfWg4sEXOhJ/oG4HncSpWYw4Vypab+uWBcn+BeZ6PoRJC?=
 =?us-ascii?Q?VuTEehE3B85ZEVnmmoTiD8RdbrBt4L7R14MVfueHAP6on/PI2BZXeB+DkW/x?=
 =?us-ascii?Q?Gjlb707ef8EVCcFEdzjVoEI0DzknYeEutAFmOyixlVRcvU0hISlr7gxKb3da?=
 =?us-ascii?Q?u2ClEWRAs7keqV84MY10ewe2pV+qFiUF45OWwgmKscSadh0cu+1ll/+v7pDC?=
 =?us-ascii?Q?r/2dHWVEsXc4RE3CyEfz2e6K1i8QQY8v0yNmqQLgawCdGbXnfd49NhGDu28H?=
 =?us-ascii?Q?WJe7gZS1y2aVZbhSf8uo8o6AIlwsXYOvYe/QyMFIIkWfxy7TaTr9FOihLYBQ?=
 =?us-ascii?Q?Gtanp5AQ8882G/xDMqsdKT/2JKigwICk8xwY3Yt9a6hZ6VgcBFQeE6hkz7PF?=
 =?us-ascii?Q?zqTx38/39shRlsiU9DWMl6ciUTwSyzNOboVvJMBtiqb1rJXY1Kyu6Eed3068?=
 =?us-ascii?Q?/rn9/9waF4lVHI1lToytplD6VxxChhB3VaDzwjdoLm+qtpmFeme7bkAjttPO?=
 =?us-ascii?Q?yKYG8otUPXjFIBumJwizyeH9cImkMfN9zYMDdob86fFRm7lSyUTGnBehgt9h?=
 =?us-ascii?Q?JOKQ/hQkEdwRSgADr1H/7YAbD2oyjCeG6e6IR1dO/6Y8Kg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2DADD44929ADB8468DA669762B6B3DDE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be4b114-30a7-4950-e315-08d8cc6ea062
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2021 20:17:58.1353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2wlaun58JpBg9S4L6D3bAGKoJ62l/f4CdPUuT6ZRRwCAJKTyp/EENHTQSZYgmRFZEL/NGKn0spFTrWu3HEr0MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4036
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102080119
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1031 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102080119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 8, 2021, at 3:12 PM, Trond Myklebust <trondmy@hammerspace.com> wro=
te:
>=20
> On Mon, 2021-02-08 at 19:48 +0000, Chuck Lever wrote:
>>=20
>>=20
>>> On Feb 8, 2021, at 2:34 PM, Trond Myklebust <
>>> trondmy@hammerspace.com> wrote:
>>>=20
>>> On Tue, 2021-01-19 at 20:25 -0500, Sasha Levin wrote:
>>>> From: Chuck Lever <chuck.lever@oracle.com>
>>>>=20
>>>> [ Upstream commit 4a85a6a3320b4a622315d2e0ea91a1d2b013bce4 ]
>>>>=20
>>>> Daire Byrne reports a ~50% aggregrate throughput regression on
>>>> his
>>>> Linux NFS server after commit da1661b93bf4 ("SUNRPC: Teach server
>>>> to
>>>> use xprt_sock_sendmsg for socket sends"), which replaced
>>>> kernel_send_page() calls in NFSD's socket send path with calls to
>>>> sock_sendmsg() using iov_iter.
>>>>=20
>>>> Investigation showed that tcp_sendmsg() was not using zero-copy
>>>> to
>>>> send the xdr_buf's bvec pages, but instead was relying on memcpy.
>>>> This means copying every byte of a large NFS READ payload.
>>>>=20
>>>> It looks like TLS sockets do indeed support a ->sendpage method,
>>>> so it's really not necessary to use xprt_sock_sendmsg() to
>>>> support
>>>> TLS fully on the server. A mechanical reversion of da1661b93bf4
>>>> is
>>>> not possible at this point, but we can re-implement the server's
>>>> TCP socket sendmsg path using kernel_sendpage().
>>>>=20
>>>> Reported-by: Daire Byrne <daire@dneg.com>
>>>> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D209439
>>>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>> ---
>>>>  net/sunrpc/svcsock.c | 86
>>>> +++++++++++++++++++++++++++++++++++++++++++-
>>>>  1 file changed, 85 insertions(+), 1 deletion(-)
>>>>=20
>>>> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
>>>> index c2752e2b9ce34..4404c491eb388 100644
>>>> --- a/net/sunrpc/svcsock.c
>>>> +++ b/net/sunrpc/svcsock.c
>>>> @@ -1062,6 +1062,90 @@ static int svc_tcp_recvfrom(struct
>>>> svc_rqst
>>>> *rqstp)
>>>>         return 0;       /* record not complete */
>>>>  }
>>>> =20
>>>> +static int svc_tcp_send_kvec(struct socket *sock, const struct
>>>> kvec
>>>> *vec,
>>>> +                             int flags)
>>>> +{
>>>> +       return kernel_sendpage(sock, virt_to_page(vec->iov_base),
>>>> +                              offset_in_page(vec->iov_base),
>>>> +                              vec->iov_len, flags);
>>=20
>> Thanks for your review!
>>=20
>>> I'm having trouble with this line. This looks like it is trying to
>>> push
>>> a slab page into kernel_sendpage().
>>=20
>> The head and tail kvec's in rq_res are not kmalloc'd, they are
>> backed by pages in rqstp->rq_pages[].
>>=20
>>=20
>>> What guarantees that the nfsd
>>> thread won't call kfree() before the socket layer is done
>>> transmitting
>>> the page?
>>=20
>> If I understand correctly what Neil told us last week, the page
>> reference count on those pages is set up so that one of
>> svc_xprt_release() or the network layer does the final put_page(),
>> in a safe fashion.
>>=20
>> Before da1661b93bf4 ("SUNRPC: Teach server to use xprt_sock_sendmsg
>> for socket sends"), the original svc_send_common() code did this:
>>=20
>> -       /* send head */
>> -       if (slen =3D=3D xdr->head[0].iov_len)
>> -               flags =3D 0;
>> -       len =3D kernel_sendpage(sock, headpage, headoffset,
>> -                                 xdr->head[0].iov_len, flags);
>> -       if (len !=3D xdr->head[0].iov_len)
>> -               goto out;
>> -       slen -=3D xdr->head[0].iov_len;
>> -       if (slen =3D=3D 0)
>> -               goto out;
>>=20
>>=20
>>=20
>=20
> OK, so then only the argument kvec can be allocated on the slab (thanks
> to  svc_deferred_recv)? Is that correct?

The RPC/RDMA Receive buffer is kmalloc'd, that would be used for
rq_arg.head/tail. But for TCP, I believe the head kvec is always
pulled out of rq_pages[].

svc_process() sets up rq_res.head this way:

1508         resv->iov_base =3D page_address(rqstp->rq_respages[0]);
1509         resv->iov_len =3D 0;

I would need to audit the code to confirm that rq_res.tail is never
kmalloc'd.


--
Chuck Lever



