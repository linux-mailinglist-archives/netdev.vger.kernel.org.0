Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA631B863E
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 13:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgDYLmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 07:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgDYLmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 07:42:31 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6924DC09B04C
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 04:42:30 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id o10so10211765qtr.6
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 04:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version:content-transfer-encoding;
        bh=hdIpK7ct63Z7jJE9Mjn72p6e0+1mT0sE49L6U7OVovk=;
        b=rjR3ZDoEA1kMo0d7AI6FUigWYhXfwA/OOqMy5TRbBqa6IOibl6n2Ti+p4lW5q1ItqG
         0k1YfDviLW8gxVE27X5Cha36KqTKPCDXK5YYpKiBp0sLWzjbn9Bu+3dVG9H+V36Lw61f
         puwFoMVKKUv3pMvC01cxe3eYffVFqvcK8DmPvijZYSd2wefAkUC681LBzVE4POyvmFsF
         IDJvZ3jpLY8zFLEY3qxysDBsfnx6qP1kWceF++4h/CpeztSKE7JP/TPemqDLX1j7V03s
         MUK4FNSLinAHYN5d6LmzD6JDgTZcQCDcxpqL9sWvP68inaaZrGJ0/6eFoQR9p5xSi5P8
         1aTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version
         :content-transfer-encoding;
        bh=hdIpK7ct63Z7jJE9Mjn72p6e0+1mT0sE49L6U7OVovk=;
        b=t6qUojI++SlYXAx1/325zEVfoKGtO4glnIIX7KwS88d8/S/6D41harfP2t+JFdrnAx
         7ogvWKej/qmSPg7GjjgWScYWTGhU1n/60YKJrs4+ovzg+Qe92ru3pG0Pzdcgp5ol0rvw
         4D3gGgjOySQvTM32dLrlPh2Jt+6s9JooANVI02AJ19igIQxjqnvk+sD7FxJTFnC4/eEP
         rHo8MpuJKh1v4TylNC7vCKukEP8rxWm7+xsNfmLFE5ar7NrZvaddXvCckU83LUhhqD8W
         ijGv3q6WSITFVqiJoJwB+6XiBmwani1c8ogkvKTLZblx1mPyZrtBsc8d/W57nHfUe5ED
         yVmQ==
X-Gm-Message-State: AGi0Pua2mIgDjA4SCQkSxaG4n/37s7QPgo3RROoZ0NBrqCb9gzvBdIEC
        7mHB/cWCukRlHxWR7SH5DZyL
X-Google-Smtp-Source: APiQypLVrBD4XSPStNPmAY5ImhaRZtIADJ00vA6YTflmpLtPbulGc66vuPVFk8OlyA5rqRB2Xyc2DQ==
X-Received: by 2002:ac8:6753:: with SMTP id n19mr14205963qtp.353.1587814949479;
        Sat, 25 Apr 2020 04:42:29 -0700 (PDT)
Received: from [192.168.7.212] (pool-71-245-238-133.bstnma.fios.verizon.net. [71.245.238.133])
        by smtp.gmail.com with ESMTPSA id g47sm6161863qte.54.2020.04.25.04.42.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 Apr 2020 04:42:28 -0700 (PDT)
From:   Paul Moore <paul@paul-moore.com>
To:     Dmitry Vyukov <dvyukov@google.com>,
        David Miller <davem@davemloft.net>, <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
CC:     Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, <selinux@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>
Date:   Sat, 25 Apr 2020 07:42:26 -0400
Message-ID: <171b1244748.27df.85c95baa4474aabc7814e68940a78392@paul-moore.com>
In-Reply-To: <CACT4Y+b8HiV6KFuAPysZD=5hmyO4QisgxCKi4DHU3CfMPSP=yg@mail.gmail.com>
References: <CACT4Y+YTi4JCFRqOB9rgA22S+6xxTo87X41hj6Tdfro8K3ef7g@mail.gmail.com>
 <CAHC9VhQs6eJpX4oMrhBiDap-HhEsBBgmYWEou=ZH60YiA__T7w@mail.gmail.com>
 <CACT4Y+b8HiV6KFuAPysZD=5hmyO4QisgxCKi4DHU3CfMPSP=yg@mail.gmail.com>
User-Agent: AquaMail/1.24.0-1572 (build: 102400003)
Subject: Re: selinux_netlink_send changes program behavior
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On April 25, 2020 1:15:05 AM Dmitry Vyukov <dvyukov@google.com> wrote:

> On Fri, Apr 24, 2020 at 11:51 PM Paul Moore <paul@paul-moore.com> wrote:
>>
>> On Fri, Apr 24, 2020 at 4:27 AM Dmitry Vyukov <dvyukov@google.com> wrote=
:
>>> Hi SELinux maintainers,
>>>
>>> We've hit a case where a developer wasn't able to reproduce a kernel
>>> bug, it turned out to be a difference in behavior between SELinux and
>>> non-SELinux kernels.
>>> Condensed version: a program does sendmmsg on netlink socket with 2
>>> mmsghdr's, first is completely empty/zeros, second contains some
>>> actual payload. Without SELinux the first mmsghdr is treated as no-op
>>> and the kernel processes the second one (triggers bug). However the
>>> SELinux hook does:
>>>
>>> static int selinux_netlink_send(struct sock *sk, struct sk_buff *skb)
>>> {
>>> if (skb->len < NLMSG_HDRLEN) {
>>>  err =3D -EINVAL;
>>>  goto out;
>>> }
>>>
>>> and fails processing on the first empty mmsghdr (does not happen
>>> without SELinux).
>>>
>>> Is this difference in behavior intentional/acceptable/should be fixed?
>>
>> From a practical perspective, SELinux is always going to need to do a
>> length check as it needs to peek into the netlink message header for
>> the message type so it can map that to the associated SELinux
>> permissions.  So in that sense, the behavior is intentional and
>> desired; however from a bug-for-bug compatibility perspective ... not
>> so much.
>>
>> Ultimately, my it's-Friday-and-it's-been-a-long-week-ending-in-a-long-da=
y
>> thought is that this was a buggy operation to begin with and the bug
>> was just caught in different parts of the kernel, depending on how it
>> was configured.  It may not be ideal, but I can think of worse things
>> (and arguably SELinux is doing the Right Thing).
>
> +netlink maintainers for intended semantics of empty netlink messages
>
> If it's a bug, or intended behavior depends on the intended
> behavior... which I assume is not documented anywhere officially.

Your original email gave the impression that there was a big in the non-SEL=
inux case; if that is not the case my response changes.

> However, most of the netlink families use netlink_rcv_skb, which does:
>
> int netlink_rcv_skb(struct sk_buff *skb, int (*cb)(struct sk_buff *,
>                           struct nlmsghdr *,
>                           struct netlink_ext_ack *))
> {
>    ...
>    while (skb->len >=3D nlmsg_total_size(0)) {
>    ...
>       skb_pull(skb, msglen);
>    }
>    return 0;
> }
>
> 1. How intentional is this while loop logic vs sloppy error checking?
> 2. netlink_rcv_skb seems to be able to handle 2+ messages in the same
> skb, while selinux_netlink_send only checks the first one... so can I
> skip SELinux checks by putting a malicious message after a permitted
> one?..



