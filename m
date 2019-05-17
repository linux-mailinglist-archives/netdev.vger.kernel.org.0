Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA9D21A15
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 16:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbfEQOxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 10:53:09 -0400
Received: from web1.siteocity.com ([67.227.147.204]:37842 "EHLO
        web1.siteocity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728968AbfEQOxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 10:53:09 -0400
X-Greylist: delayed 2485 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 May 2019 10:53:07 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=felipegasper.com; s=default; h=To:References:Message-Id:
        Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Subject:Mime-Version:
        Content-Type:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=N6m8ItcPeAXtI74gTibpdhO9VtglXynz6qvN46c+wdE=; b=PbLc3yPgpUwo/2Tew4KztUm6S
        rZJmFRHIoU+mXUVUC8Ov5FFBXfUWtDM54nHWwDtTIUJJn+HMajz888QdKsY4VrA1A5L39+Jrqxu0z
        +FpipWyEUSj93ct8veIK7NeHbcP4Ww63H5533KcvSfbWJrR6r8KOO30yFmEiWm5M39Xo2zAgVt+39
        8nZvmhDNgnrjPSQZ0aAR7nR8gx//oaRW2VxsnxYpZfWugiWZUXArBmBruHKZPToS1mq2ImRG567RX
        kYLoeZIBOeGnKZDrFlxd/qeuugysXejb5juPhbBGavctKePoxlRzLrGpFikzohTtPpvU2tsEnsGM9
        0pL2zc1pA==;
Received: from [149.248.87.38] (port=51684 helo=[192.168.86.41])
        by web1.siteocity.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <felipe@felipegasper.com>)
        id 1hRdaG-0000dd-AM; Fri, 17 May 2019 09:11:41 -0500
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
From:   Felipe Gasper <felipe@felipegasper.com>
In-Reply-To: <CALCETrUaTamZ1ZGbWpu+4kDAEFRqyESoa_4tgwpAmMh3NVQ4pQ@mail.gmail.com>
Date:   Fri, 17 May 2019 10:11:38 -0400
Cc:     "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AF68C2F5-1E59-44D4-BC63-9C988C278174@felipegasper.com>
References: <20190517032505.19921-1-felipe@felipegasper.com>
 <CALCETrUaTamZ1ZGbWpu+4kDAEFRqyESoa_4tgwpAmMh3NVQ4pQ@mail.gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
X-Mailer: Apple Mail (2.3445.104.11)
X-OutGoing-Spam-Status: No, score=-1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - web1.siteocity.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipegasper.com
X-Get-Message-Sender-Via: web1.siteocity.com: authenticated_id: fgasper/from_h
X-Authenticated-Sender: web1.siteocity.com: felipe@felipegasper.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-From-Rewrite: unmodified, already matched
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On May 17, 2019, at 12:59 AM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
>> On May 16, 2019, at 8:25 PM, Felipe <felipe@felipegasper.com> wrote:
>>=20
>> Author: Felipe Gasper <felipe@felipegasper.com>
>> Date:   Thu May 16 12:16:53 2019 -0500
>>=20
>>   Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
>>=20
>>   This adds the ability for Netlink to report a socket=E2=80=99s UID =
along with the
>>   other UNIX socket diagnostic information that is already available. =
This will
>>   allow diagnostic tools greater insight into which users control =
which socket.
>>=20
>>   Signed-off-by: Felipe Gasper <felipe@felipegasper.com>
>>=20
>> diff --git a/include/uapi/linux/unix_diag.h =
b/include/uapi/linux/unix_diag.h
>> index 5c502fd..a198857 100644
>> --- a/include/uapi/linux/unix_diag.h
>> +++ b/include/uapi/linux/unix_diag.h
>> @@ -20,6 +20,7 @@ struct unix_diag_req {
>> #define UDIAG_SHOW_ICONS    0x00000008    /* show pending connections =
*/
>> #define UDIAG_SHOW_RQLEN    0x00000010    /* show skb receive queue =
len */
>> #define UDIAG_SHOW_MEMINFO    0x00000020    /* show memory info of a =
socket */
>> +#define UDIAG_SHOW_UID        0x00000040    /* show socket's UID */
>>=20
>> struct unix_diag_msg {
>>   __u8    udiag_family;
>> @@ -40,6 +41,7 @@ enum {
>>   UNIX_DIAG_RQLEN,
>>   UNIX_DIAG_MEMINFO,
>>   UNIX_DIAG_SHUTDOWN,
>> +    UNIX_DIAG_UID,
>>=20
>>   __UNIX_DIAG_MAX,
>> };
>> diff --git a/net/unix/diag.c b/net/unix/diag.c
>> index 3183d9b..011f56c 100644
>> --- a/net/unix/diag.c
>> +++ b/net/unix/diag.c
>> @@ -110,6 +110,11 @@ static int sk_diag_show_rqlen(struct sock *sk, =
struct sk_buff *nlskb)
>>   return nla_put(nlskb, UNIX_DIAG_RQLEN, sizeof(rql), &rql);
>> }
>>=20
>> +static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb)
>> +{
>> +    return nla_put(nlskb, UNIX_DIAG_UID, sizeof(kuid_t), =
&(sk->sk_uid));
>=20
> That type is called *k* uid_t because it=E2=80=99s internal to the =
kernel. You
> probably want from_kuid_munged(), which will fix it up for an
> appropriate userns.  Presumably you want sk=E2=80=99s netns=E2=80=99s =
userns.

Thank you for pointing this out.

Would it suffice to get the userns as: =E2=80=9Csk_user_ns(sk)=E2=80=9D?

Or would it be better to pass struct netlink_callback *cb from =
unix_diag_dump() to sk_diag_dump() to sk_diag_fill(), then to the new =
function to add the UID?

cheers,
-Felipe Gasper=
