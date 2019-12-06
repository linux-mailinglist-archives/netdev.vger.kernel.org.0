Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 712A1115766
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 19:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfLFSsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 13:48:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60040 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfLFSsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 13:48:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6IiOoW059004;
        Fri, 6 Dec 2019 18:48:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=5lp8ZlBxNkmXaXoLWYbKdrOMUAA0UVIB/7+lHi76x7w=;
 b=WAhgkgCIsjBbWAll5DXTCDqjoQlenazn1q8E18R+XnaI1VKMJwIUqSdzKI26RLXWmp5a
 bTDvbEC9h/hiMgAPR5Fwfx6Aklr1+T6T92lRuAIQ7peKd+6uURCurNHR8oYfU8jPQynn
 0jaZqWl9eXTq1MREeFv+A4ngWkNizqtgrmqTozD8jodBzmyoCMqdrqyxOX3PufpVll1C
 2M9l9BAPSLqsFarPZTiqE42NElgZhG4r3s4zSa5D4EMFS9RwrkN/lvGTeEoBnyHLzSvg
 PyLpuZcamWq14rLL+1DqWcF0+ufZyevRCkwzDFqRu5NyxOfY3eAsWhpc+MuJnQInqFar CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wkfuuwyf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 18:48:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6IiAG6133140;
        Fri, 6 Dec 2019 18:46:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wqm0t1dav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 18:46:01 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB6Ik0KA003539;
        Fri, 6 Dec 2019 18:46:01 GMT
Received: from dhcp-10-175-176-166.vpn.oracle.com (/10.175.176.166)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Dec 2019 10:46:00 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH net] net: netlink: Fix uninit-value in netlink_recvmsg()
From:   =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
In-Reply-To: <13b4ccb1-2dec-fc4d-b9da-0957240f7fd7@cogentembedded.com>
Date:   Fri, 6 Dec 2019 19:45:58 +0100
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6255CC20-05DA-41C1-A46D-FE7F6C4A64BD@oracle.com>
References: <20191206134923.2771651-1-haakon.bugge@oracle.com>
 <13b4ccb1-2dec-fc4d-b9da-0957240f7fd7@cogentembedded.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
X-Mailer: Apple Mail (2.3601.0.10)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912060152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912060152
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 6 Dec 2019, at 19:20, Sergei Shtylyov =
<sergei.shtylyov@cogentembedded.com> wrote:
>=20
> Hello!
>=20
> On 12/06/2019 04:49 PM, H=C3=A5kon Bugge wrote:
>=20
>> If skb_recv_datagram() returns NULL, netlink_recvmsg() will return an
>> arbitrarily value.
>=20
>   Arbitrary?

is an adjective. Since I described the verb *return*, I assumed the =
adverb, arbitrarily, is correct, But english is not my native language.

Thxs, H=C3=A5kon

>=20
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
>=20
> MBR, Sergei

