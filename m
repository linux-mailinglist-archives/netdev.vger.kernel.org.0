Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A987C2940C6
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 18:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394860AbgJTQqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 12:46:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33438 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394856AbgJTQqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 12:46:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KGijJJ011295;
        Tue, 20 Oct 2020 16:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=0xbHYWfx1qsUJtKvtGxxhzbbAgoheE44Yomg5cvr3Ag=;
 b=Zci+qb4yadT5XHBTFYvxPzWJ9dHRjjMJ471c1KkIAJJWc7+d+C0/7PrXrBNaHdwIjXTR
 n12EudbVQuSKIB7c4OZA0fa3vFFKh02UFLY+60FuqPCXlFVEEW8Poap9FQXuJSYiPhXJ
 nDdgIl+o+qv1PumeLIV03fz4+VhbFJ25dp8s1bb6/jzr/0x9nAHiAU81sMNZsgXqXrd5
 ngG9916doQiO8qRfsFJorZ+6g3cHrnE6gy4RFuS2EcfqW+RK8rWoVQTP63HAiH1zZJyp
 AFTsfxbVaB+zCpQQ6Vb9S+uusNwfLMMcA62xE6lOCVlgLazdV+mchKKEserc3tXMHrQQ 3A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 349jrpmb75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 20 Oct 2020 16:46:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KGeuDs170853;
        Tue, 20 Oct 2020 16:46:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 348ahwggky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Oct 2020 16:46:00 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09KGjwGZ025270;
        Tue, 20 Oct 2020 16:45:58 GMT
Received: from smirzamo-mac.lan (/136.52.113.136)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Oct 2020 09:45:58 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH linux-5.9 1/1] net: netfilter: fix KASAN:
 slab-out-of-bounds Read in nft_flow_rule_create
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
In-Reply-To: <20201020115047.GA15628@salvia>
Date:   Tue, 20 Oct 2020 09:45:57 -0700
Cc:     linux-kernel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <28C74722-8F35-4397-B567-FA5BCF525891@oracle.com>
References: <20201019172532.3906-1-saeed.mirzamohammadi@oracle.com>
 <20201020115047.GA15628@salvia>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010200112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010200112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks! Yes, that looks good to me.

Saeed

> On Oct 20, 2020, at 4:50 AM, Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
>=20
> On Mon, Oct 19, 2020 at 10:25:32AM -0700, =
saeed.mirzamohammadi@oracle.com wrote:
>> From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
>>=20
>> This patch fixes the issue due to:
>>=20
>> BUG: KASAN: slab-out-of-bounds in nft_flow_rule_create+0x622/0x6a2
>> net/netfilter/nf_tables_offload.c:40
>> Read of size 8 at addr ffff888103910b58 by task syz-executor227/16244
>>=20
>> The error happens when expr->ops is accessed early on before =
performing the boundary check and after nft_expr_next() moves the expr =
to go out-of-bounds.
>>=20
>> This patch checks the boundary condition before expr->ops that fixes =
the slab-out-of-bounds Read issue.
>=20
> Thanks. I made a slight variant of your patch.
>=20
> I'm attaching it, it is also fixing the problem but it introduced
> nft_expr_more() and use it everywhere.
>=20
> Let me know if this looks fine to you.
> <0001-netfilter-fix-KASAN-slab-out-of-bounds-Read-in-nft_f.patch>

