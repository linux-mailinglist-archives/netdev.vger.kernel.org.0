Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B6F2CF18E
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbgLDQGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:06:33 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:53342 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgLDQGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:06:32 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4G5CN8112042;
        Fri, 4 Dec 2020 16:05:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=CRX1tP16qfHm063q0BwyiJW0vFhRxuLVcLDuPnepxIg=;
 b=vA8k+PM3ti0G331WaZNnP3waAlbxuyQzZVJruhhoqy7gD0BRO+5v2YbQtTimrYXYiNra
 zs5dcxeuuz4poY4Yg4RkHF4fuf3gz0yJJB5RCW5JpdrDVwGkUlqVetyXvuEzvVIWCdEj
 upJk2eGoLwXu4DTffzMAenbByoXgMaogpOP61PkjSBFkuB9EW+a2idJ1jHorZp2piqyH
 1f8Gp+qLTZVc1HyRu1BeoRUbopQGs5QBimWq/H24Ji9nMKZBlxbCiRzGeaBRn5PWs6A9
 ImarIVMfKEivvyD27wrtQYnWTkDcZN9mPYpXjrl6kGgCBbhsv1PyrFH5l8ZIfSeoJ0Jv Cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2bbxmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 16:05:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4G5WYb085385;
        Fri, 4 Dec 2020 16:05:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3540g3utxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 16:05:34 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B4G5Pf6031359;
        Fri, 4 Dec 2020 16:05:25 GMT
Received: from anon-dhcp-152.1015granger.net (/68.61.232.219)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 08:05:25 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: Why the auxiliary cipher in gss_krb5_crypto.c?
From:   Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20201204154626.GA26255@fieldses.org>
Date:   Fri, 4 Dec 2020 11:05:24 -0500
Cc:     David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-afs@lists.infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <76331A46-235E-4A35-BA07-F4811FA29EB5@oracle.com>
References: <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com>
 <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
 <118876.1607093975@warthog.procyon.org.uk>
 <20201204154626.GA26255@fieldses.org>
To:     Bruce Fields <bfields@fieldses.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040092
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040092
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 4, 2020, at 10:46 AM, Bruce Fields <bfields@fieldses.org> =
wrote:
>=20
> On Fri, Dec 04, 2020 at 02:59:35PM +0000, David Howells wrote:
>> Hi Chuck, Bruce,
>>=20
>> Why is gss_krb5_crypto.c using an auxiliary cipher?  For reference, =
the
>> gss_krb5_aes_encrypt() code looks like the attached.
>>=20
>>> =46rom what I can tell, in AES mode, the difference between the main =
cipher and
>> the auxiliary cipher is that the latter is "cbc(aes)" whereas the =
former is
>> "cts(cbc(aes))" - but they have the same key.
>>=20
>> Reading up on CTS, I'm guessing the reason it's like this is that CTS =
is the
>> same as the non-CTS, except for the last two blocks, but the non-CTS =
one is
>> more efficient.
>=20
> CTS is cipher-text stealing, isn't it?  I think it was Kevin Coffman
> that did that, and I don't remember the history.  I thought it was
> required by some spec or peer implementation (maybe Windows?) but I
> really don't remember.  It may predate git.  I'll dig around and see
> what I can find.

I can't add more here, this design comes from well before I started
working on this body of code (though, I worked near Kevin when he
implemented it).


--
Chuck Lever



