Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AEA271568
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 17:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgITPi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 11:38:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44640 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgITPi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 11:38:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08KFUwUh176600;
        Sun, 20 Sep 2020 15:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=K+0SzXgpoWzXCGxoZDrD7xWy3jeNjxytHxViKP+/Y8M=;
 b=sZCkOODJjtJ5rTv/JewSzfUbHXCedk47yd3pBMTqy/5i+IBLcTP0y3XvRbMZSdcz4bGh
 HzJ0Xq+g28zku330+tWu30ASPNqBw89XCZ3p9zXE6z4DxbQ0AX1bXYdEUiEiL8V+vzBh
 nzNe9XW5MpOItYRGDFBdJ8fN8rlYvo/4gkGSm8sPwkSg8HzmO9uNyizy3ImgrEB3zPzn
 e53GnaQwFXxQ8wC4K9sV2U0uEwc9TWnbBZQT+n4n/EgJYLiCxjVSwL/cXXg5rE4+rEmT
 feIOwCVO+PpAcON1v70KLatOpNamuSFpVojPSPGY0fk81j2CEMFs5v1ItNvHljLxasTJ aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33n9dqtm3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 20 Sep 2020 15:38:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08KFZjYB043005;
        Sun, 20 Sep 2020 15:38:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33nuvx8p09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Sep 2020 15:38:07 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08KFbvKD020432;
        Sun, 20 Sep 2020 15:37:58 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 20 Sep 2020 08:37:57 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH 08/14] xprtrdma: drop double zeroing
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <1600601186-7420-9-git-send-email-Julia.Lawall@inria.fr>
Date:   Sun, 20 Sep 2020 11:37:56 -0400
Cc:     Bruce Fields <bfields@fieldses.org>,
        kernel-janitors@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CC88D365-0362-4CD8-9B72-0EE8B51BF481@oracle.com>
References: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
 <1600601186-7420-9-git-send-email-Julia.Lawall@inria.fr>
To:     Julia Lawall <Julia.Lawall@inria.fr>,
        Anna Schumaker <anna.schumaker@netapp.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9750 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009200136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9750 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0 impostorscore=0
 clxscore=1011 lowpriorityscore=0 suspectscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009200135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, Julia!

> On Sep 20, 2020, at 7:26 AM, Julia Lawall <Julia.Lawall@inria.fr> =
wrote:
>=20
> sg_init_table zeroes its first argument, so the allocation of that =
argument
> doesn't have to.
>=20
> the semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @@
> expression x,n,flags;
> @@
>=20
> x =3D=20
> - kcalloc
> + kmalloc_array
>  (n,sizeof(*x),flags)
> ...
> sg_init_table(x,n)
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Acked-by: Chuck Lever <chuck.lever@oracle.com>

This one goes to Anna.


> ---
> net/sunrpc/xprtrdma/frwr_ops.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff -u -p a/net/sunrpc/xprtrdma/frwr_ops.c =
b/net/sunrpc/xprtrdma/frwr_ops.c
> --- a/net/sunrpc/xprtrdma/frwr_ops.c
> +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> @@ -124,7 +124,7 @@ int frwr_mr_init(struct rpcrdma_xprt *r_
> 	if (IS_ERR(frmr))
> 		goto out_mr_err;
>=20
> -	sg =3D kcalloc(depth, sizeof(*sg), GFP_NOFS);
> +	sg =3D kmalloc_array(depth, sizeof(*sg), GFP_NOFS);
> 	if (!sg)
> 		goto out_list_err;
>=20
>=20

--
Chuck Lever



