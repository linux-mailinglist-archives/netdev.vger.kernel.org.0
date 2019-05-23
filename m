Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B1028D90
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 01:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388493AbfEWXDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 19:03:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37956 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387725AbfEWXDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 19:03:16 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4NN1FVt059399;
        Thu, 23 May 2019 23:02:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=61U1g4Qwd+YXNHX5FwhqRFWvGU28Frzm1PU4OuNdzOA=;
 b=oB87+ku4KgSUdUPd4v61zpy+5bs2hMSwlRIWhIviu7YuuLj+QkXfdMN6RgecNnsgbcUK
 b+kwRhKyDblJf0RMk0lkhMjju64jy+4U8Y7y41C3FCD1D5GhJjKHeVCG5eyAePMxkSfD
 lJm3/IfLdf7bA4KN15jOIGrx7pcjEpBUezcUY/Iatighda2YU0Um4LK1DPuoo4B4gYd0
 9MoJ08yDruASgKnOMQHIAEd7qPdRyqQku0e0AoCxIHyA5cM7p3f9bGFCaCj+aqM+rEZu
 9ja6s5+oYCoiTLzfSYADK2bBYcyqniZ9A/7KI8NlvEmvwLghG470oUp/maD3MCAPo5Aw rQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2smsk5ngmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 23:02:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4NN18uj056885;
        Thu, 23 May 2019 23:02:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2smshfhc0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 23:02:46 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4NN2foL000641;
        Thu, 23 May 2019 23:02:41 GMT
Received: from anon-dhcp-171.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 May 2019 23:02:41 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net-next] xprtrdma: Use struct_size() in kzalloc()
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <70ca0dea-6f1f-922c-7c5d-e79c6cf6ecb5@embeddedor.com>
Date:   Thu, 23 May 2019 19:02:39 -0400
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Bruce Fields <bfields@fieldses.org>,
        Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CDDB9617-08B2-43B6-AB03-3BAA7CC27839@oracle.com>
References: <20190131004622.GA30261@embeddedor>
 <07CB966E-A946-4956-8480-C0FC13E13E4E@oracle.com>
 <ad9eccc7-afd2-3419-b886-6210eeabd5b5@embeddedor.com>
 <70ca0dea-6f1f-922c-7c5d-e79c6cf6ecb5@embeddedor.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Anna Schumaker <anna.schumaker@netapp.com>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9266 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905230148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9266 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905230148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gustavo-

Anna is supposed to take patches for xprtrdma/ .


> On May 23, 2019, at 6:36 PM, Gustavo A. R. Silva =
<gustavo@embeddedor.com> wrote:
>=20
> Hi Dave,
>=20
> I wonder if you can take this patch.
>=20
> Thanks
> --
> Gustavo
>=20
> On 3/28/19 3:41 PM, Gustavo A. R. Silva wrote:
>> Hi all,
>>=20
>> Friendly ping:
>>=20
>> Who can take this?
>>=20
>> Thanks
>> --
>> Gustavo
>>=20
>> On 1/31/19 8:11 AM, Chuck Lever wrote:
>>>=20
>>>=20
>>>> On Jan 30, 2019, at 7:46 PM, Gustavo A. R. Silva =
<gustavo@embeddedor.com> wrote:
>>>>=20
>>>> One of the more common cases of allocation size calculations is =
finding
>>>> the size of a structure that has a zero-sized array at the end, =
along
>>>> with memory for some number of elements for that array. For =
example:
>>>>=20
>>>> struct foo {
>>>>   int stuff;
>>>>   struct boo entry[];
>>>> };
>>>>=20
>>>> instance =3D kzalloc(sizeof(struct foo) + count * sizeof(struct =
boo), GFP_KERNEL);
>>>>=20
>>>> Instead of leaving these open-coded and prone to type mistakes, we =
can
>>>> now use the new struct_size() helper:
>>>>=20
>>>> instance =3D kzalloc(struct_size(instance, entry, count), =
GFP_KERNEL);
>>>>=20
>>>> This code was detected with the help of Coccinelle.
>>>>=20
>>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>>=20
>>> Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
>>>=20
>>>=20
>>>> ---
>>>> net/sunrpc/xprtrdma/verbs.c | 3 +--
>>>> 1 file changed, 1 insertion(+), 2 deletions(-)
>>>>=20
>>>> diff --git a/net/sunrpc/xprtrdma/verbs.c =
b/net/sunrpc/xprtrdma/verbs.c
>>>> index 4994e75945b8..9e8cf7456840 100644
>>>> --- a/net/sunrpc/xprtrdma/verbs.c
>>>> +++ b/net/sunrpc/xprtrdma/verbs.c
>>>> @@ -811,8 +811,7 @@ static struct rpcrdma_sendctx =
*rpcrdma_sendctx_create(struct rpcrdma_ia *ia)
>>>> {
>>>> 	struct rpcrdma_sendctx *sc;
>>>>=20
>>>> -	sc =3D kzalloc(sizeof(*sc) +
>>>> -		     ia->ri_max_send_sges * sizeof(struct ib_sge),
>>>> +	sc =3D kzalloc(struct_size(sc, sc_sges, ia->ri_max_send_sges),
>>>> 		     GFP_KERNEL);
>>>> 	if (!sc)
>>>> 		return NULL;
>>>> --=20
>>>> 2.20.1
>>>>=20
>>>=20
>>> --
>>> Chuck Lever
>>>=20
>>>=20
>>>=20

--
Chuck Lever



