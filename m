Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341337242F
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 04:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfGXCDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 22:03:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58356 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbfGXCDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 22:03:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O1wZCE029592;
        Wed, 24 Jul 2019 02:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=aPJ/gz+1htaF0JhpGjhp8e3/McToimuUgnVMZqHte9s=;
 b=Je6bXjfvhms99P77tbjOa/GUP3fCbw+7/Jpcme25tvf+ziqD7j//GF+yZWuPOW+bPSou
 T507xOemfOsA12Rz1jBR01Z4mwJFdAIh8VUMFDueI5M8ZzS6d8EZBA0pub8og66qm4s6
 j7labDK7Ph+mSL7gnwObln3ayUujWHZgha8wIxg/dEZ7YOSzINjWbXLhKGKymEEjc7vW
 kXtNeFjZIsRwrsAWlRPN+C5IONGL/0FAwmfqmRYdX/BJs2gVLG4dgxFJw5A1XQPiiEDU
 OOEWKi26aD60jxZRcWIR6D1owq6Etx/g4CzqgJQjJM3xKwAQK6A8tLVPdaP3OL3WJ7/s lA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tx61bt601-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 02:02:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O1vO96057801;
        Wed, 24 Jul 2019 02:02:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tx60xk9hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 02:02:23 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6O22LdJ003994;
        Wed, 24 Jul 2019 02:02:21 GMT
Received: from [31.133.156.81] (/31.133.156.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jul 2019 19:02:21 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] rpcrdma_decode_msg: check xdr_inline_decode result
From:   Chuck Lever <chuck.lever@oracle.com>
X-Mailer: iPad Mail (16F203)
In-Reply-To: <20190724015115.3493-1-navid.emamdoost@gmail.com>
Date:   Tue, 23 Jul 2019 22:02:09 -0400
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "David S. Miller" <davem@davemloft.net>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <AE745E5F-63A8-4377-98E8-512828179FC0@oracle.com>
References: <20190724015115.3493-1-navid.emamdoost@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907240020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907240020
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 23, 2019, at 9:51 PM, Navid Emamdoost <navid.emamdoost@gmail.com> w=
rote:
>=20
> xdr_inline_decode may return NULL, so the check is necessary. The base
> pointer will be dereferenced later in rpcrdma_inline_fixup.

NACK. When xdr_inline_decode is passed a zero =E2=80=9Clength=E2=80=9D argum=
ent, it can never return NULL.


> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
> net/sunrpc/xprtrdma/rpc_rdma.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma=
.c
> index 4345e6912392..d0479efe0e72 100644
> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
> @@ -1160,6 +1160,9 @@ rpcrdma_decode_msg(struct rpcrdma_xprt *r_xprt, stru=
ct rpcrdma_rep *rep,
>=20
>    /* Build the RPC reply's Payload stream in rqst->rq_rcv_buf */
>    base =3D (char *)xdr_inline_decode(xdr, 0);
> +    if (!base)
> +        return -EIO;
> +
>    rpclen =3D xdr_stream_remaining(xdr);
>    r_xprt->rx_stats.fixup_copy_count +=3D
>        rpcrdma_inline_fixup(rqst, base, rpclen, writelist & 3);
> --=20
> 2.17.1
>=20

