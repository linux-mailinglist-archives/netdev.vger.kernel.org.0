Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE0623446B
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 13:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732638AbgGaLOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 07:14:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44088 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732104AbgGaLOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 07:14:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06VB758g138077;
        Fri, 31 Jul 2020 11:14:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=RuuosTbYTCr8I08cs/W2a+vgUYd33wv3e8KZbejxVWM=;
 b=K/8KlAFLEUGW81gpFqx4MCbbAEs0r2yk0oc7hMGtcPskWye9ivK9Et+Kl3sVCVoOCwKH
 VzZBhpCak2oMkK2xOBlDfct7jALEHbBdaPCvnyon9+gLGKn4IoxIsq9UoRMAfYFE+xk2
 25JuLV52B4QK1U2LaqU7ae8pC8eOUcEbLYSXtkSEzd3H9e8w4MToeTeDfZPxNp6yxRIv
 uWjuhjL2bnkfnouFdh0rei/OhY1TxqvSd/n6PdnX8Qmuj1yQEDAucDC8sHCl/GwTZfeJ
 U3njJRO1BpNZ1Rma8Dh7ZAR9Wt/T/8/fAZsOAQOm6nqCDl0HnIa0M+aDo6GjChcI5/dm ZA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32hu1jrhve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jul 2020 11:14:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06VB8rN8135178;
        Fri, 31 Jul 2020 11:14:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 32hu5yrj6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jul 2020 11:14:20 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06VBEJNF163083;
        Fri, 31 Jul 2020 11:14:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32hu5yrj69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 11:14:19 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06VBEEbe008514;
        Fri, 31 Jul 2020 11:14:14 GMT
Received: from dhcp-10-175-172-80.vpn.oracle.com (/10.175.172.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 31 Jul 2020 04:14:14 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
From:   =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
In-Reply-To: <20200731095943.GI5493@kadam>
Date:   Fri, 31 Jul 2020 13:14:09 +0200
Cc:     Leon Romanovsky <leon@kernel.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <81B40AF5-EBCA-4628-8CF6-687C12134552@oracle.com>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal> <20200731095943.GI5493@kadam>
To:     Dan Carpenter <dan.carpenter@oracle.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1011
 malwarescore=0 spamscore=0 suspectscore=3 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007310084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 31 Jul 2020, at 11:59, Dan Carpenter <dan.carpenter@oracle.com> =
wrote:
>=20
> On Fri, Jul 31, 2020 at 07:53:01AM +0300, Leon Romanovsky wrote:
>> On Thu, Jul 30, 2020 at 03:20:26PM -0400, Peilin Ye wrote:
>>> rds_notify_queue_get() is potentially copying uninitialized kernel =
stack
>>> memory to userspace since the compiler may leave a 4-byte hole at =
the end
>>> of `cmsg`.
>>>=20
>>> In 2016 we tried to fix this issue by doing `=3D { 0 };` on `cmsg`, =
which
>>> unfortunately does not always initialize that 4-byte hole. Fix it by =
using
>>> memset() instead.
>>=20
>> Of course, this is the difference between "{ 0 }" and "{}" =
initializations.
>>=20
>=20
> No, there is no difference.  Even struct assignments like:
>=20
> 	foo =3D *bar;
>=20
> can leave struct holes uninitialized.  Depending on the compiler the
> assignment can be implemented as a memset() or as a series of struct
> member assignments.

What about:

struct rds_rdma_notify {
	__u64                      user_token;
	__s32                      status;
} __attribute__((packed));


Thxs, H=C3=A5kon


> regards,
> dan carpenter
>=20

