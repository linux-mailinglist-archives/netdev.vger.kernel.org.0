Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2728C2D7F44
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 20:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392911AbgLKTRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 14:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392760AbgLKTQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 14:16:54 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F14C0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 11:16:14 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id e2so7782540pgi.5
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 11:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=61g/lABOk/rS9JU0PU8gGCkwAXD/M2pW7fIINB24oD8=;
        b=borDRSlOR+HwlxE+esc4vbp6YrOtHKLoj8SWOYgKEgIj8bb5lTkszlqdTHqIhzoi+c
         0roq/fL5yq4n5qAPA8spJkVNfqwOKqv2pkZe+3edpdWQ5FfXAAuh7kG/hFkYvjYyKVk8
         KYjRUDRUmPf0OjzB/spfDGop9EBNK7AVMpxdGah2YLszaMmiz/EkEHgdF1CMInhAt2Vf
         VevE7FlleCwW0siXhkFn/THayhZZrk2XJX7coOAyYS73cchzTSrWxFvvicLbl99Om7Yp
         Fop6CVV0La9YMMT09vBKjwmrMZj5johJIuFOqz81eLAkAhmE9Px+ydP6J4cpo5gJRBPW
         K5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=61g/lABOk/rS9JU0PU8gGCkwAXD/M2pW7fIINB24oD8=;
        b=A0uCiec/+0QcJqgT4+lZkLllHw6THET5SUO9wOwDDIXkvvPHFFHhXwK5azpF6NTpzF
         CnrOKHWNIkHHp3mUda30HqoP61d59aS7OAvMkjU/zjyoZDPdpwz3ut6nUydoFbC2WfOf
         wTej57nFhyfPTU380UaxGjf3mlEsz+P2uaII96en2u7SoN3fOx4CzByuw19Q00g0dK+M
         mQoy1gLOmkktkinNoc5syBTWluXMeuCHEE6zaGWgihqFLPbQbci6u97evNVrUZ2lJA/h
         9tIiuQJ9r63xHmQyOjxNE19Ptgwzm9VTSj6UjRJzZtuqtSEOVNpMQGJmXRrYwvG/ehLD
         WFDA==
X-Gm-Message-State: AOAM530bgXEodzphGA3H5Vw8NFv2aTD7KXdc4qF+moz6WCOK3W9zbABe
        U+6ybsMiCWrumONfnDgJTlQ7eeFyOaFa2Y9z6/c=
X-Google-Smtp-Source: ABdhPJyMJaQ/BGNCyy7wbfzBRBmu2uLUhTAMSxCZIIymtA4aob6y7Byqjcj0J6XytjFsiKdqUaodJGBlYrphdUkxmkA=
X-Received: by 2002:a63:5114:: with SMTP id f20mr10757438pgb.5.1607714174282;
 Fri, 11 Dec 2020 11:16:14 -0800 (PST)
MIME-Version: 1.0
References: <20201211152649.12123-1-maximmi@mellanox.com> <20201211152649.12123-3-maximmi@mellanox.com>
In-Reply-To: <20201211152649.12123-3-maximmi@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 11 Dec 2020 11:16:03 -0800
Message-ID: <CAM_iQpUS_71R7wujqhUnF41dtVtNj=5kXcdAHea1euhESbeJrg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/4] sch_htb: Hierarchical QoS hardware offload
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 7:26 AM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> HTB doesn't scale well because of contention on a single lock, and it
> also consumes CPU. This patch adds support for offloading HTB to
> hardware that supports hierarchical rate limiting.
>
> This solution addresses two main problems of scaling HTB:
>
> 1. Contention by flow classification. Currently the filters are attached
> to the HTB instance as follows:

I do not think this is the reason, tcf_classify() has been called with RCU
only on the ingress side for a rather long time. What contentions are you
talking about here?

>
>     # tc filter add dev eth0 parent 1:0 protocol ip flower dst_port 80
>     classid 1:10
>
> It's possible to move classification to clsact egress hook, which is
> thread-safe and lock-free:
>
>     # tc filter add dev eth0 egress protocol ip flower dst_port 80
>     action skbedit priority 1:10
>
> This way classification still happens in software, but the lock
> contention is eliminated, and it happens before selecting the TX queue,
> allowing the driver to translate the class to the corresponding hardware
> queue.

Sure, you can use clsact with HTB, or any combinations you like, but you
can't assume your HTB only works with clsact, can you?


>
> Note that this is already compatible with non-offloaded HTB and doesn't
> require changes to the kernel nor iproute2.
>
> 2. Contention by handling packets. HTB is not multi-queue, it attaches
> to a whole net device, and handling of all packets takes the same lock.
> When HTB is offloaded, its algorithm is done in hardware. HTB registers
> itself as a multi-queue qdisc, similarly to mq: HTB is attached to the
> netdev, and each queue has its own qdisc. The control flow is still done
> by HTB: it calls the driver via ndo_setup_tc to replicate the hierarchy
> of classes in the NIC. Leaf classes are presented by hardware queues.
> The data path works as follows: a packet is classified by clsact, the
> driver selects a hardware queue according to its class, and the packet
> is enqueued into this queue's qdisc.

I do _not_ read your code, from what you describe here, it sounds like
you just want a per-queue rate limit, instead of a global one. So why
bothering HTB whose goal is a global rate limit?

And doesn't TBF already work with mq? I mean you can attach it as
a leaf to each mq so that the tree lock will not be shared either, but you'd
lose the benefits of a global rate limit too. EDT does basically the same,
but it never claims to completely replace HTB. ;)

Thanks.
