Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000052AD938
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 15:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgKJOtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 09:49:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36420 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730853AbgKJOtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 09:49:18 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAEhrGx010557;
        Tue, 10 Nov 2020 14:49:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=sPIiV/3UM3YEUvlOqqEtPvsNDIxlFjXBi9StsBoT0rY=;
 b=0D0dj0nedsR0zUpUewt5Z7CXxLG5DKnojprHoKJBMVt0UsdVskfo56rOIyLLSibKYi+o
 oxyznuj4/uHlo2XtlmolcQEYadRPD80FkCHAjoZ9zQDpISxP0imp1XG1azPMBCvv87nH
 dKCkPH6bcKswDe7Cbj2tlhTOgwnrZMbni5uSNnM7x68rPQdbWkgmUWey4BmQnFfKeVfD
 vXpszoPGeWWtC4G45KcobVATRNegNrxGz+MXmp+SDXTFP6zsubT18j+DxfkBiQxfze5q
 ORaAXC1ylJwapuOfyVPq45WuF3iyEOuONPWe8ELtdWkx3FP2cbnvLHgUWohsJcZQiKcN KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34nh3av3gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 14:49:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAEk8gM164386;
        Tue, 10 Nov 2020 14:49:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34p5gx09p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 14:49:14 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AAEn83A002606;
        Tue, 10 Nov 2020 14:49:13 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 06:49:07 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH RFC] SUNRPC: Use zero-copy to perform socket send
 operations
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <47630f20-c596-6cdc-2eed-7e0ad1137292@gmail.com>
Date:   Tue, 10 Nov 2020 09:49:06 -0500
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <269B7F38-0F08-456B-B584-1FF550BA48AA@oracle.com>
References: <160493771006.15633.8524084764848931537.stgit@klimt.1015granger.net>
 <9ce015245c916b2c90de72440a22f801142f2c6e.camel@hammerspace.com>
 <0313136F-6801-434F-8304-72B9EADD389E@oracle.com>
 <f03dae6d36c0f008796ae01bbb6de3673e783571.camel@hammerspace.com>
 <5056C7C7-7B26-4667-9691-D2F634C02FB1@oracle.com>
 <3194609c525610dc502d69f11c09cff1c9b21f2d.camel@hammerspace.com>
 <A3D0FF41-D88F-4116-AD47-AF9C94B1D984@oracle.com>
 <47630f20-c596-6cdc-2eed-7e0ad1137292@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 9, 2020, at 3:10 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
>=20
>=20
>=20
> On 11/9/20 8:31 PM, Chuck Lever wrote:
>>=20
>>=20
>>> On Nov 9, 2020, at 1:16 PM, Trond Myklebust =
<trondmy@hammerspace.com> wrote:
>>>=20
>>> On Mon, 2020-11-09 at 12:36 -0500, Chuck Lever wrote:
>>>>=20
>>>>=20
>>>>> On Nov 9, 2020, at 12:32 PM, Trond Myklebust <
>>>>> trondmy@hammerspace.com> wrote:
>>>>>=20
>>>>> On Mon, 2020-11-09 at 12:12 -0500, Chuck Lever wrote:
>>>>>>=20
>>>>>>=20
>>>>>>> On Nov 9, 2020, at 12:08 PM, Trond Myklebust
>>>>>>> <trondmy@hammerspace.com> wrote:
>>>>>>>=20
>>>>>>> On Mon, 2020-11-09 at 11:03 -0500, Chuck Lever wrote:
>>>>>>>> Daire Byrne reports a ~50% aggregrate throughput regression
>>>>>>>> on
>>>>>>>> his
>>>>>>>> Linux NFS server after commit da1661b93bf4 ("SUNRPC: Teach
>>>>>>>> server
>>>>>>>> to
>>>>>>>> use xprt_sock_sendmsg for socket sends"), which replaced
>>>>>>>> kernel_send_page() calls in NFSD's socket send path with
>>>>>>>> calls to
>>>>>>>> sock_sendmsg() using iov_iter.
>>>>>>>>=20
>>>>>>>> Investigation showed that tcp_sendmsg() was not using zero-
>>>>>>>> copy
>>>>>>>> to
>>>>>>>> send the xdr_buf's bvec pages, but instead was relying on
>>>>>>>> memcpy.
>>>>>>>>=20
>>>>>>>> Set up the socket and each msghdr that bears bvec pages to
>>>>>>>> use
>>>>>>>> the
>>>>>>>> zero-copy mechanism in tcp_sendmsg.
>>>>>>>>=20
>>>>>>>> Reported-by: Daire Byrne <daire@dneg.com>
>>>>>>>> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D209439
>>>>>>>> Fixes: da1661b93bf4 ("SUNRPC: Teach server to use
>>>>>>>> xprt_sock_sendmsg
>>>>>>>> for socket sends")
>>>>>>>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>>>>>>>> ---
>>>>>>>> net/sunrpc/socklib.c  |    5 ++++-
>>>>>>>> net/sunrpc/svcsock.c  |    1 +
>>>>>>>> net/sunrpc/xprtsock.c |    1 +
>>>>>>>> 3 files changed, 6 insertions(+), 1 deletion(-)
>>>>>>>>=20
>>>>>>>> This patch does not fully resolve the issue. Daire reports
>>>>>>>> high
>>>>>>>> softIRQ activity after the patch is applied, and this
>>>>>>>> activity
>>>>>>>> seems to prevent full restoration of previous performance.
>>>>>>>>=20
>>>>>>>>=20
>>>>>>>> diff --git a/net/sunrpc/socklib.c b/net/sunrpc/socklib.c
>>>>>>>> index d52313af82bc..af47596a7bdd 100644
>>>>>>>> --- a/net/sunrpc/socklib.c
>>>>>>>> +++ b/net/sunrpc/socklib.c
>>>>>>>> @@ -226,9 +226,12 @@ static int xprt_send_pagedata(struct
>>>>>>>> socket
>>>>>>>> *sock, struct msghdr *msg,
>>>>>>>>        if (err < 0)
>>>>>>>>                return err;
>>>>>>>>=20
>>>>>>>> +       msg->msg_flags |=3D MSG_ZEROCOPY;
>>>>>>>>        iov_iter_bvec(&msg->msg_iter, WRITE, xdr->bvec,
>>>>>>>> xdr_buf_pagecount(xdr),
>>>>>>>>                      xdr->page_len + xdr->page_base);
>>>>>>>> -       return xprt_sendmsg(sock, msg, base + xdr-
>>>>>>>>> page_base);
>>>>>>>> +       err =3D xprt_sendmsg(sock, msg, base + xdr->page_base);
>>>>>>>> +       msg->msg_flags &=3D ~MSG_ZEROCOPY;
>>>>>>>> +       return err;
>>>>>>>> }
>>>>>>>>=20
>>>>>>>> /* Common case:
>>>>>>>> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
>>>>>>>> index c2752e2b9ce3..c814b4953b15 100644
>>>>>>>> --- a/net/sunrpc/svcsock.c
>>>>>>>> +++ b/net/sunrpc/svcsock.c
>>>>>>>> @@ -1176,6 +1176,7 @@ static void svc_tcp_init(struct
>>>>>>>> svc_sock
>>>>>>>> *svsk,
>>>>>>>> struct svc_serv *serv)
>>>>>>>>                svsk->sk_datalen =3D 0;
>>>>>>>>                memset(&svsk->sk_pages[0], 0, sizeof(svsk-
>>>>>>>>> sk_pages));
>>>>>>>>=20
>>>>>>>> +               sock_set_flag(sk, SOCK_ZEROCOPY);
>>>>>>>>                tcp_sk(sk)->nonagle |=3D TCP_NAGLE_OFF;
>>>>>>>>=20
>>>>>>>>                set_bit(XPT_DATA, &svsk->sk_xprt.xpt_flags);
>>>>>>>> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
>>>>>>>> index 7090bbee0ec5..343c6396b297 100644
>>>>>>>> --- a/net/sunrpc/xprtsock.c
>>>>>>>> +++ b/net/sunrpc/xprtsock.c
>>>>>>>> @@ -2175,6 +2175,7 @@ static int
>>>>>>>> xs_tcp_finish_connecting(struct
>>>>>>>> rpc_xprt *xprt, struct socket *sock)
>>>>>>>>=20
>>>>>>>>                /* socket options */
>>>>>>>>                sock_reset_flag(sk, SOCK_LINGER);
>>>>>>>> +               sock_set_flag(sk, SOCK_ZEROCOPY);
>>>>>>>>                tcp_sk(sk)->nonagle |=3D TCP_NAGLE_OFF;
>>>>>>>>=20
>>>>>>>>                xprt_clear_connected(xprt);
>>>>>>>>=20
>>>>>>>>=20
>>>>>>> I'm thinking we are not really allowed to do that here. The
>>>>>>> pages
>>>>>>> we
>>>>>>> pass in to the RPC layer are not guaranteed to contain stable
>>>>>>> data
>>>>>>> since they include unlocked page cache pages as well as
>>>>>>> O_DIRECT
>>>>>>> pages.
>>>>>>=20
>>>>>> I assume you mean the client side only. Those issues aren't a
>>>>>> factor
>>>>>> on the server. Not setting SOCK_ZEROCOPY here should be enough to
>>>>>> prevent the use of zero-copy on the client.
>>>>>>=20
>>>>>> However, the client loses the benefits of sending a page at a
>>>>>> time.
>>>>>> Is there a desire to remedy that somehow?
>>>>>=20
>>>>> What about splice reads on the server side?
>>>>=20
>>>> On the server, this path formerly used kernel_sendpages(), which I
>>>> assumed is similar to the sendmsg zero-copy mechanism. How does
>>>> kernel_sendpages() mitigate against page instability?
>>>=20
>>> It copies the data. =F0=9F=99=82
>>=20
>> tcp_sendmsg_locked() invokes skb_copy_to_page_nocache(), which is
>> where Daire's performance-robbing memcpy occurs.
>>=20
>> do_tcp_sendpages() has no such call site. Therefore the legacy
>> sendpage-based path has at least one fewer data copy operations.
>>=20
>> What is the appropriate way to make tcp_sendmsg() treat a =
bvec-bearing
>> msghdr like an array of struct page pointers passed to =
kernel_sendpage() ?
>>=20
>=20
>=20
> MSG_ZEROCOPY is only accepted if sock_flag(sk, SOCK_ZEROCOPY) is true,
> ie if SO_ZEROCOPY socket option has been set earlier.

Eric, are you suggesting that ZEROCOPY is the mechanism that socket
consumers should be using with sock_sendmsg to get the same behavior
as kernel_sendpage() ?

If no, what is the preferred approach?

If yes, can you comment on the added soft IRQ workload when NFSD
sets these flags?


--
Chuck Lever



