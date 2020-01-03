Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF3B12FEC0
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 23:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgACW24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 17:28:56 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60966 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728687AbgACW24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 17:28:56 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003MJ8sq162026;
        Fri, 3 Jan 2020 22:28:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=2KowZgiBz0ZizJIhiwrlohESrwlc53Jd59BqPulPrjw=;
 b=na18AY3TbO0w22qgzrmLoSM0eHFUyvxb5fJySs/7p6ra4k/JjEuTBcwCj3WdhhgM86Qo
 Fk6ZdpoooyHYZQOnoiTFEZmcxa1yAWTdLv/zc1Z3hea+e04bTpMG+JOF9NqRj1JzPp1u
 sQ9saW083yzGzOVW7t9j/k4Q+O65VgKVwMMfxEVvxpprYFJ0+cGlcyRYxkX7YPS2l1t6
 5VrWAt/nVkiW8Xpju2VuKcE4HeTyi5LT5wnFjm1mPJnbpYm+v6lLHRHu63deEtc+XSne
 nQOKgBIz4XSg4uUltJp/7BU52OsfbZaS9qnqzfeT/hr80U2hp9ONdOlVONEiBywExf7G GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftxjqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 22:28:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 003MJ4Z5040304;
        Fri, 3 Jan 2020 22:28:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2x9jm850xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 22:28:45 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 003MSe32006140;
        Fri, 3 Jan 2020 22:28:41 GMT
Received: from [192.168.14.112] (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 14:28:40 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2] net: mlx5: Use iowriteXbe() to ring doorbell and
 remove reduntant wmb()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20200103191749.GE9706@ziepe.ca>
Date:   Sat, 4 Jan 2020 00:28:36 +0200
Cc:     saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, eli@mellanox.com, tariqt@mellanox.com,
        danielm@mellanox.com,
        =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <11EBB1F4-6D5A-4047-99A1-D339B7C8A697@oracle.com>
References: <20200103175207.72655-1-liran.alon@oracle.com>
 <20200103191749.GE9706@ziepe.ca>
To:     Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030203
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9489 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030203
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 3 Jan 2020, at 21:17, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Fri, Jan 03, 2020 at 07:52:07PM +0200, Liran Alon wrote:
>> diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
>> index 40748fc1b11b..4631ad35da53 100644
>> +++ b/include/linux/mlx5/cq.h
>> @@ -162,13 +162,8 @@ static inline void mlx5_cq_arm(struct =
mlx5_core_cq *cq, u32 cmd,
>>=20
>> 	*cq->arm_db =3D cpu_to_be32(sn << 28 | cmd | ci);
>>=20
>> -	/* Make sure that the doorbell record in host memory is
>> -	 * written before ringing the doorbell via PCI MMIO.
>> -	 */
>> -	wmb();
>> -
>> -	doorbell[0] =3D cpu_to_be32(sn << 28 | cmd | ci);
>> -	doorbell[1] =3D cpu_to_be32(cq->cqn);
>> +	doorbell[0] =3D sn << 28 | cmd | ci;
>> +	doorbell[1] =3D cq->cqn;
>=20
> This does actually have to change to a u64 otherwise it is not the
> same.
>=20
> On x86 LE, it was
> db[0] =3D swab(a)
> db[1] =3D swab(b)
> __raw_writel(db)
>=20
> Now it is
> db[0] =3D a
> db[1] =3D b
> __raw_writel(swab(db))
>=20
> Putting the swab around the u64 swaps the order of a/b in the TLP.
>=20
> It might be tempting to swap db[0]/db[1] but IIRC this messed it up on
> BE.

Oops. You are right...

>=20
> The sanest, simplest solution is to use a u64 natively, as the example
> I gave did.

I agree.

>=20
> There is also the issue of casting a u32 to a u64 and possibly
> triggering a unaligned kernel access, presumably this doesn't happen
> today only by some lucky chance..
>=20
>> 	mlx5_write64(doorbell, uar_page + MLX5_CQ_DOORBELL);
>> }
>> diff --git a/include/linux/mlx5/doorbell.h =
b/include/linux/mlx5/doorbell.h
>> index 5c267707e1df..9c1d35777323 100644
>> +++ b/include/linux/mlx5/doorbell.h
>> @@ -43,17 +43,15 @@
>>  * Note that the write is not atomic on 32-bit systems! In contrast =
to 64-bit
>>  * ones, it requires proper locking. mlx5_write64 doesn't do any =
locking, so use
>>  * it at your own discretion, protected by some kind of lock on 32 =
bits.
>> - *
>> - * TODO: use write{q,l}_relaxed()
>>  */
>>=20
>> -static inline void mlx5_write64(__be32 val[2], void __iomem *dest)
>> +static inline void mlx5_write64(u32 val[2], void __iomem *dest)
>> {
>=20
> So this should accept a straight u64, the goofy arrays have to go away

I agree.

>=20
>> #if BITS_PER_LONG =3D=3D 64
>> -	__raw_writeq(*(u64 *)val, dest);
>> +	iowrite64be(*(u64 *)val, dest);
>> #else
>> -	__raw_writel((__force u32) val[0], dest);
>> -	__raw_writel((__force u32) val[1], dest + 4);
>> +	iowrite32be(val[0], dest);
>> +	iowrite32be(val[1], dest + 4);
>=20
> With a u64 input this fallback is written as
>=20
>  iowrite32be(val >> 32, dest)
>  iowrite32be((u32)val, dest + 4)
>=20
> Which matches the definition for how write64 must construct a TLP.
>=20
> And arguably the first one should be _relaxed (but nobody cares about
> this code path)

I agree with everything. Will fix on v3.

Thanks!
-Liran

>=20
> Jason

