Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D24A11578B
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 20:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfLFTH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 14:07:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60634 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfLFTH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 14:07:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6J4hMS064017;
        Fri, 6 Dec 2019 19:07:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=th4gv8eCyl+j2Jp0rdEE5iFuXARoemj0G5R0hJm6e38=;
 b=N0U13GJ9FQy17lsZPLVm2nvHvp8yUBsjERLkH5PC+dw9ew5YWOFu3rOBZ8G1sTAO+hoD
 TPKflJq3l+FUNeiUlyZDnNH3EqO8VBujJmef5QWMR3PGqe/87vUSBZQkb8U2NabywORf
 BOYfTvskRoc4w8ta7OtMrQ3xav/TyIIOmHld3stxkewUZhkmHjipo/SpQvK1fHU6zIxx
 T6gZ1Xr50133mbv5n9H0KIVPgXN1aBVVyo1nRrW1iT4d7wMKO4Y/vsLk4wfxq48G+Nu4
 Oat+Q/1MN3WGvgO8fUCAKsp5prTHqlaQ/RH4c1FCO8ODRXtgQxihDqvxqKz5rFjXiR7P kA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wkgcqwuvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 19:07:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6J4cPZ148398;
        Fri, 6 Dec 2019 19:07:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wqerax8es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 19:07:23 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB6J7Lki025957;
        Fri, 6 Dec 2019 19:07:21 GMT
Received: from dhcp-10-175-176-166.vpn.oracle.com (/10.175.176.166)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Dec 2019 11:07:21 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH net] net: netlink: Fix uninit-value in netlink_recvmsg()
From:   =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
In-Reply-To: <c24c48d2-fc5e-6aca-27b8-7ea98ecd3ecc@gmail.com>
Date:   Fri, 6 Dec 2019 20:07:19 +0100
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <449D3522-802F-47D8-9D8E-C7DF2CBD6C5F@oracle.com>
References: <20191206134923.2771651-1-haakon.bugge@oracle.com>
 <c24c48d2-fc5e-6aca-27b8-7ea98ecd3ecc@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3601.0.10)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912060153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912060153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 6 Dec 2019, at 19:47, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>=20
>=20
>=20
> On 12/6/19 5:49 AM, H=C3=A5kon Bugge wrote:
>> If skb_recv_datagram() returns NULL, netlink_recvmsg() will return an
>> arbitrarily value.
>>=20
>> Signed-off-by: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>> ---
>> net/netlink/af_netlink.c | 1 +
>> 1 file changed, 1 insertion(+)
>>=20
>> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
>> index 90b2ab9dd449..bb7276f9c9f8 100644
>> --- a/net/netlink/af_netlink.c
>> +++ b/net/netlink/af_netlink.c
>> @@ -1936,6 +1936,7 @@ static int netlink_recvmsg(struct socket *sock, =
struct msghdr *msg, size_t len,
>> 		return -EOPNOTSUPP;
>>=20
>> 	copied =3D 0;
>> +	err =3D 0;
>>=20
>> 	skb =3D skb_recv_datagram(sk, flags, noblock, &err);
>> 	if (skb =3D=3D NULL)
>>=20
>=20
> Please provide a Fixes: tag
>=20
> By doing the research, you probably would find there is no bug.
>=20
> err is set in skb_recv_datagram() when there is no packet to read.

yes, you are right, by bad.


H=C3=A5kon


