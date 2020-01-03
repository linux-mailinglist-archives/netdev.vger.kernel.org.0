Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 915A812FA2E
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 17:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgACQTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 11:19:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59068 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727701AbgACQTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 11:19:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003GJFbf066206;
        Fri, 3 Jan 2020 16:19:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=VD4M2tY2hMhwhvNvOyRClDpTc6pactNE8/7wFqqkiHo=;
 b=FukHT+DnKJ9lIPpJIrvBpHqditFvdQyecllo6yBRKBzFNpTSqXSADByulZ6QCNybkq76
 jSKUTWG/HHv1cZBCOvQGD/EZglpB41SaB3o7NybcCjJuTZzbAHHUPGcXI7LxYBqTV7jU
 ljI1YgpzBAD8UhIalDeHTtQ4Lt/ZA8VfOuyv9bEFAqm6CNAFF3+sXb1UY1OgGJFiACsN
 DGNyXnhHvOyYjOLIUaSWXWCjNkejLOr7DMlT/mGo5ulix9UJATHGLzBNQ06I5/qUlTXv
 wyWR1GlVDsS8kUEjCOenGVKYbH7BjRMmW1f1yy78/0fb2Gr6DoIPV0xqrnnkC+xD7ZgE Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0pw1yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 16:19:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003GIK2I076758;
        Fri, 3 Jan 2020 16:19:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2x9jm7mp9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 16:19:22 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 003GJLtP013287;
        Fri, 3 Jan 2020 16:19:21 GMT
Received: from [192.168.14.112] (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 08:19:20 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] net: Google gve: Remove dma_wmb() before ringing doorbell
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <b9172cbc-de9d-5926-0021-7a276b9f304f@gmail.com>
Date:   Fri, 3 Jan 2020 18:19:16 +0200
Cc:     csully@google.com, davem@davemloft.net, netdev@vger.kernel.org,
        sagis@google.com, jonolson@google.com, yangchun@google.com,
        lrizzo@google.com, adisuresh@google.com,
        Si-Wei Liu <si-wei.liu@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4D6D05B1-52FF-49E8-A6E5-115ADDEFF6AA@oracle.com>
References: <20200103130108.70593-1-liran.alon@oracle.com>
 <b9172cbc-de9d-5926-0021-7a276b9f304f@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 3 Jan 2020, at 15:36, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>=20
>=20
>=20
> On 1/3/20 5:01 AM, Liran Alon wrote:
>> Current code use dma_wmb() to ensure Tx descriptors are visible
>> to device before writing to doorbell.
>>=20
>> However, these dma_wmb() are wrong and unnecessary. Therefore,
>> they should be removed.
>>=20
>> iowrite32be() called from gve_tx_put_doorbell() internally executes
>> dma_wmb()/wmb() on relevant architectures. E.g. On ARM, iowrite32be()
>> calls __iowmb() which translates to wmb() and only then executes
>> __raw_writel(). However on x86, iowrite32be() will call writel()
>> which just writes to memory because writes to UC memory is guaranteed
>> to be globally visible only after previous writes to WB memory are
>> globally visible.
>=20
> This part about x86 is confusing.

I disagree but I don=E2=80=99t mind removing it from commit message if =
you think so.
I think it emphasise that writel()/iowrite32be() does the right thing =
for the given architecture.

>=20
> writel() has the needed barrier (compared to writel_relaxed() which =
has no such barrier)

Right.

>=20
> The UC vs WB memory sounds irrelevant.

It is relevant. For example, writel()/iowrite32be() wasn=E2=80=99t =
sufficient in case Tx descriptors was in WC memory instead of WB memory.
(As for example done in AWS ENA LLQ or Mellanox mlx4 BlueFlame =
technologies).

i.e. writel() guarantees that all previous writes to UC/WB memory are =
globally visible before the write done by writel().
In our case, the Tx descriptors are in WB memory.

>=20
>>=20
>> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>> ---
>> drivers/net/ethernet/google/gve/gve_tx.c | 6 ------
>> 1 file changed, 6 deletions(-)
>>=20
>> diff --git a/drivers/net/ethernet/google/gve/gve_tx.c =
b/drivers/net/ethernet/google/gve/gve_tx.c
>> index f4889431f9b7..d0244feb0301 100644
>> --- a/drivers/net/ethernet/google/gve/gve_tx.c
>> +++ b/drivers/net/ethernet/google/gve/gve_tx.c
>> @@ -487,10 +487,6 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct =
net_device *dev)
>> 		 * may have added descriptors without ringing the =
doorbell.
>> 		 */
>>=20
>> -		/* Ensure tx descs from a prior gve_tx are visible =
before
>> -		 * ringing doorbell.
>> -		 */
>> -		dma_wmb();
>> 		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
>> 		return NETDEV_TX_BUSY;
>> 	}
>> @@ -505,8 +501,6 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct =
net_device *dev)
>> 	if (!netif_xmit_stopped(tx->netdev_txq) && netdev_xmit_more())
>> 		return NETDEV_TX_OK;
>>=20
>> -	/* Ensure tx descs are visible before ringing doorbell */
>> -	dma_wmb();
>> 	gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
>> 	return NETDEV_TX_OK;
>> }
>>=20
>=20
> This seems strange to care about TX but not RX ?
>=20
> gve_rx_write_doorbell() also uses iowrite32be()
>=20

You are right.
I missed that I should also remove dma_wmb() in gve_clean_rx_done() =
before calling gve_rx_write_doorbell().
Will fix it in v2.

Thanks,
-Liran

