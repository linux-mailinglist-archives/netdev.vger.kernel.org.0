Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078C0234540
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 14:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733111AbgGaMF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 08:05:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49014 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733108AbgGaMFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 08:05:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06VC2wKA036678;
        Fri, 31 Jul 2020 12:05:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=wQSjVYBw/TnpmeaVef5NuD3Sb07fZXefhlktIO+86VE=;
 b=iZX7AyqlTaeG0sax9PxX4B4ZcMa2vT0UZ7l/Y+qmA1wZlGMKLak5Bs9GINU76b0lfvYm
 ey6lmKPyGj3kt6rI2z71n217FQ72/y7ayy7rFtbD7yEjPFW5ph4B+/DwvW4S1WNvK0EJ
 87xTp9jGelyP01Vqr2pJIJww6jcOHz8AU/g/VLB4NRxrrmkHCyMmGvBqXiOJun+04Q6z
 JyQNhQ3VhAIoSRf1E2CbKlUGYo0+/ayHFWK8VIFxcPoqV+v1WMPN8fdwF+K/p3KbpHT1
 k7K+7KOHh8FFAn6Jzq+mfTB8y5hdo9Qzvx/v+HfwZKpsv5Zt8R13N8ZzegxlMOu051qn WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32hu1jrqca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jul 2020 12:05:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06VC2bSk150843;
        Fri, 31 Jul 2020 12:03:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 32hu63wuxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jul 2020 12:03:13 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06VC3Cr1152622;
        Fri, 31 Jul 2020 12:03:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32hu63wuv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 12:03:12 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06VC3Anq029674;
        Fri, 31 Jul 2020 12:03:10 GMT
Received: from dhcp-10-175-172-80.vpn.oracle.com (/10.175.172.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 31 Jul 2020 05:03:10 -0700
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
From:   =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
In-Reply-To: <20200731115909.GA1649637@kroah.com>
Date:   Fri, 31 Jul 2020 14:03:06 +0200
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leon@kernel.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <866B1B5B-0156-4EED-9599-51BEF5661DA9@oracle.com>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal> <20200731095943.GI5493@kadam>
 <81B40AF5-EBCA-4628-8CF6-687C12134552@oracle.com>
 <20200731115909.GA1649637@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9698 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 spamscore=0 suspectscore=3 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007310090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 31 Jul 2020, at 13:59, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> On Fri, Jul 31, 2020 at 01:14:09PM +0200, H=C3=A5kon Bugge wrote:
>>=20
>>=20
>>> On 31 Jul 2020, at 11:59, Dan Carpenter <dan.carpenter@oracle.com> =
wrote:
>>>=20
>>> On Fri, Jul 31, 2020 at 07:53:01AM +0300, Leon Romanovsky wrote:
>>>> On Thu, Jul 30, 2020 at 03:20:26PM -0400, Peilin Ye wrote:
>>>>> rds_notify_queue_get() is potentially copying uninitialized kernel =
stack
>>>>> memory to userspace since the compiler may leave a 4-byte hole at =
the end
>>>>> of `cmsg`.
>>>>>=20
>>>>> In 2016 we tried to fix this issue by doing `=3D { 0 };` on =
`cmsg`, which
>>>>> unfortunately does not always initialize that 4-byte hole. Fix it =
by using
>>>>> memset() instead.
>>>>=20
>>>> Of course, this is the difference between "{ 0 }" and "{}" =
initializations.
>>>>=20
>>>=20
>>> No, there is no difference.  Even struct assignments like:
>>>=20
>>> 	foo =3D *bar;
>>>=20
>>> can leave struct holes uninitialized.  Depending on the compiler the
>>> assignment can be implemented as a memset() or as a series of struct
>>> member assignments.
>>=20
>> What about:
>>=20
>> struct rds_rdma_notify {
>> 	__u64                      user_token;
>> 	__s32                      status;
>> } __attribute__((packed));
>=20
> Why is this still a discussion at all?
>=20
> Try it and see, run pahole and see if there are holes in this =
structure
> (odds are no), you don't need us to say what is happening here...

An older posting had this:

$ pahole -C "rds_rdma_notify" net/rds/recv.o
struct rds_rdma_notify {
	__u64                      user_token;           /*     0     8 =
*/
	__s32                      status;               /*     8     4 =
*/

	/* size: 16, cachelines: 1, members: 2 */
	/* padding: 4 */
	/* last cacheline: 16 bytes */
};


Thxs, H=C3=A5kon

