Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB172743EA
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 16:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIVOQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 10:16:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36856 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgIVOQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 10:16:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MEEpho159552;
        Tue, 22 Sep 2020 14:16:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=6EaZpMApi/rzCh2z/QU+2Ap9ZSw0blrADAxeli20pKU=;
 b=zzmAK5jzIpqHO984CGEmz/uhhlK/0qUYzmsegScukUFVymq12JvcuaQC2EEsJPuLkHto
 ACAOM2Hk9ZGFfQ3xDoeuComEgyFfr8dabz+hv6+AIeAPGN2gX7//DnfdPW3EjBaWLa/E
 xvRgLowkIttGL0h75bj0lvpAy3WG9NSEiOjAxF+ZvCehUCUpIkt0eo0+at56rCmmgGwk
 RLtPeAbWr9RcqxfXcY7ox3WWpWOLDTyjBiFv1dvmCL6AKnMs2j21DMKbOWw/dLM9W0zu
 r3ugYQ+gFKzwtwA7G0Y45HLK350IDaf+utrJ0dN7TQ3WKmwFJx+cWVKIpoAZWgbxpSL/ iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33ndnud28e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 14:16:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MEBMBx055549;
        Tue, 22 Sep 2020 14:14:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33nuwydjdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 14:14:10 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08MEE4fu007720;
        Tue, 22 Sep 2020 14:14:04 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 07:14:04 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] SUNRPC: Fix svc_flush_dcache()
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <07c27f89-187b-69a3-fd40-f9beef29da40@windriver.com>
Date:   Tue, 22 Sep 2020 10:14:03 -0400
Cc:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EFDE7D43-5E0D-4484-9B8C-CBED30EA4E04@oracle.com>
References: <160063136387.1537.11599713172507546412.stgit@klimt.1015granger.net>
 <07c27f89-187b-69a3-fd40-f9beef29da40@windriver.com>
To:     He Zhe <zhe.he@windriver.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 22, 2020, at 3:13 AM, He Zhe <zhe.he@windriver.com> wrote:
>=20
>=20
>=20
> On 9/21/20 3:51 AM, Chuck Lever wrote:
>> On platforms that implement flush_dcache_page(), a large NFS WRITE
>> triggers the WARN_ONCE in bvec_iter_advance():
>>=20
>> Sep 20 14:01:05 klimt.1015granger.net kernel: Attempted to advance =
past end of bvec iter
>> Sep 20 14:01:05 klimt.1015granger.net kernel: WARNING: CPU: 0 PID: =
1032 at include/linux/bvec.h:101 bvec_iter_advance.isra.0+0xa7/0x158 =
[sunrpc]
>>=20
>> Sep 20 14:01:05 klimt.1015granger.net kernel: Call Trace:
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  =
svc_tcp_recvfrom+0x60c/0x12c7 [sunrpc]
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? =
bvec_iter_advance.isra.0+0x158/0x158 [sunrpc]
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? =
del_timer_sync+0x4b/0x55
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? test_bit+0x1d/0x27 =
[sunrpc]
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  svc_recv+0x1193/0x15e4 =
[sunrpc]
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? =
try_to_freeze.isra.0+0x6f/0x6f [sunrpc]
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? =
refcount_sub_and_test.constprop.0+0x13/0x40 [sunrpc]
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? =
svc_xprt_put+0x1e/0x29f [sunrpc]
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? svc_send+0x39f/0x3c1 =
[sunrpc]
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  nfsd+0x282/0x345 =
[nfsd]
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? =
__kthread_parkme+0x74/0xba
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  kthread+0x2ad/0x2bc
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? =
nfsd_destroy+0x124/0x124 [nfsd]
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? test_bit+0x1d/0x27
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? =
kthread_mod_delayed_work+0x115/0x115
>> Sep 20 14:01:05 klimt.1015granger.net kernel:  =
ret_from_fork+0x22/0x30
>>=20
>> Reported-by: He Zhe <zhe.he@windriver.com>
>> Fixes: ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()")
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> ---
>> net/sunrpc/svcsock.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> Hi Zhe-
>>=20
>> If you confirm this fixes your issue and there are no other
>> objections or regressions, I can submit this for v5.9-rc.
>=20
> I don't quite get why we add "seek" to "size". It seems this action =
does not
> reflect the actual scenario and forcedly neutralizes the WARN_ONCE =
check in
> bvec_iter_advance, so that it may "advance past end of bvec iter" and =
thus
> introduces overflow.

> Why don't we avoid this problem at the very begginning like my v1? =
That is, call
> svc_flush_bvec only when we have received more than we want to seek.
>=20
>         len =3D sock_recvmsg(svsk->sk_sock, &msg, MSG_DONTWAIT);
> -       if (len > 0)
> +       if (len > 0 && (size_t)len > (seek & PAGE_MASK))
>                 svc_flush_bvec(bvec, len, seek);

Because this doesn't fix the underlying bug that triggered the
WARN_ONCE.

svc_tcp_recvfrom() attempts to assemble a possibly large RPC Call
from a sequence of sock_recvmsg's.

@seek is the running number of bytes that has been received so
far for the RPC Call we are assembling. @size is the number of
bytes that was just received in the most recent sock_recvmsg.

We want svc_flush_bvec to flush just the area of @bvec that
hasn't been flushed yet.

Thus: the current size of the partial Call message in @bvec is
@seek + @size. The starting location of the flush is
@seek & PAGE_MASK. This aligns the flush so it starts on a page
boundary.

This:

 230         struct bvec_iter bi =3D {
 231                 .bi_size        =3D size + seek,
 232         };

 235         bvec_iter_advance(bvec, &bi, seek & PAGE_MASK);

advances the bvec_iter to the part of @bvec that hasn't been
flushed yet.

This loop:

 236         for_each_bvec(bv, bvec, bi, bi)
 237                 flush_dcache_page(bv.bv_page);

flushes each page starting at that point to the end of the bytes
that have been received so far

In other words, ca07eda33e01 was wrong because it always flushed
the first section of @bvec, never the later parts of it.


> Regards,
> Zhe
>=20
>>=20
>>=20
>> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
>> index d5805fa1d066..c2752e2b9ce3 100644
>> --- a/net/sunrpc/svcsock.c
>> +++ b/net/sunrpc/svcsock.c
>> @@ -228,7 +228,7 @@ static int svc_one_sock_name(struct svc_sock =
*svsk, char *buf, int remaining)
>> static void svc_flush_bvec(const struct bio_vec *bvec, size_t size, =
size_t seek)
>> {
>> 	struct bvec_iter bi =3D {
>> -		.bi_size	=3D size,
>> +		.bi_size	=3D size + seek,
>> 	};
>> 	struct bio_vec bv;

--
Chuck Lever



