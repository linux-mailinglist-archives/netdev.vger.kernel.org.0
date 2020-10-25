Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B224298506
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 00:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1420579AbgJYXcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 19:32:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42952 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1420565AbgJYXcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 19:32:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09PNSHQE044031;
        Sun, 25 Oct 2020 23:32:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=W+E4vs32mttsE6FHSgjydHJbUAZvV25zza8/TXMNrEg=;
 b=YUlezSwucoZwfhOz48q5oSLUtM0nNOmfWeZ8e+RHv3g2bLh/CNF+mSjesjiKzXOXoth3
 9fStL+3YfmDc8A1+GGJCCc9xhuxuhQMgQyTqybV5Ydqzq3yGOYdjrAp+0O7HYn/Cs3o4
 9k+0s5BDJPj4OUS4/NsCXVnGo12GFz5btg0I1O3UtNvD5omomjkNEr1/o6gNkN/woGLE
 hlUaIVRXUwhVyEI3UHtt46R4dEwTgVbzHTcPk+8jppqJjbJvmYT0h8IX7q9Dq5MQHMoN
 E+11Z+rF8iRlxRzrfe8z9Ic1gQEmNffRexBPqAYB+GMvIPQsPr7ySXoQpFtihsX8fZW8 Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7kjgr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 25 Oct 2020 23:32:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09PNJsuT104653;
        Sun, 25 Oct 2020 23:32:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx5vgvsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Oct 2020 23:32:00 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09PNVwom027328;
        Sun, 25 Oct 2020 23:31:58 GMT
Received: from dhcp-10-159-151-51.vpn.oracle.com (/10.159.151.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 25 Oct 2020 16:31:58 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH linux-5.9 1/1] net: netfilter: fix KASAN:
 slab-out-of-bounds Read in nft_flow_rule_create
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
In-Reply-To: <3BE1A64B-7104-4220-BAD1-870338A33B15@oracle.com>
Date:   Sun, 25 Oct 2020 16:31:57 -0700
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <566D38F7-7C99-40F4-A948-03F2F0439BBB@oracle.com>
References: <20201019172532.3906-1-saeed.mirzamohammadi@oracle.com>
 <20201020115047.GA15628@salvia>
 <28C74722-8F35-4397-B567-FA5BCF525891@oracle.com>
 <3BE1A64B-7104-4220-BAD1-870338A33B15@oracle.com>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        stable@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=3 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010250177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=3
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010250177
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding stable.


> On Oct 21, 2020, at 1:08 PM, Saeed Mirzamohammadi =
<saeed.mirzamohammadi@oracle.com> wrote:
>=20
> Attached the syzkaller C repro.
>=20
> Tested-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> <repro.c>
>> On Oct 20, 2020, at 9:45 AM, Saeed Mirzamohammadi =
<saeed.mirzamohammadi@oracle.com> wrote:
>>=20
>> Thanks! Yes, that looks good to me.
>>=20
>> Saeed
>>=20
>>> On Oct 20, 2020, at 4:50 AM, Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
>>>=20
>>> On Mon, Oct 19, 2020 at 10:25:32AM -0700, =
saeed.mirzamohammadi@oracle.com wrote:
>>>> From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
>>>>=20
>>>> This patch fixes the issue due to:
>>>>=20
>>>> BUG: KASAN: slab-out-of-bounds in nft_flow_rule_create+0x622/0x6a2
>>>> net/netfilter/nf_tables_offload.c:40
>>>> Read of size 8 at addr ffff888103910b58 by task =
syz-executor227/16244
>>>>=20
>>>> The error happens when expr->ops is accessed early on before =
performing the boundary check and after nft_expr_next() moves the expr =
to go out-of-bounds.
>>>>=20
>>>> This patch checks the boundary condition before expr->ops that =
fixes the slab-out-of-bounds Read issue.
>>>=20
>>> Thanks. I made a slight variant of your patch.
>>>=20
>>> I'm attaching it, it is also fixing the problem but it introduced
>>> nft_expr_more() and use it everywhere.
>>>=20
>>> Let me know if this looks fine to you.
>>> <0001-netfilter-fix-KASAN-slab-out-of-bounds-Read-in-nft_f.patch>
>>=20
>=20

