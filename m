Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CB7411FC0
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 19:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349114AbhITRpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 13:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352853AbhITRmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 13:42:20 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FB2C0363F0;
        Mon, 20 Sep 2021 09:54:14 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id l6so6704934plh.9;
        Mon, 20 Sep 2021 09:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BVUQwCPVABzZfjfA1MSF2RPyACpP6SrhyHePd1BxqFg=;
        b=g9WffIev9n4JE+zerOPcdBgNXleWbDeoTCeVmLdadn3pey8Bwg8/boq87gclfAlkLB
         3J80pTkp6GGPTLA9xMks6McvHizR8cvufA1imk++YXgynql9GBMF9CQsqsM7EoHpBP3K
         2CtFG9AcI5WenoNglbB+5VvWa1mRDU/id8PJIs88bI+9Bd/NJcyVfjh4qD1oXCWKVlcZ
         eOsTjx8ITIBo2YPoQoXjh2jBXXz1XgGG+bkc5Fsd+hxU5qZ07b1poV+/c+Kzk+tjWNR8
         jemoApnW7UHvlHZqCCf0QDUhzCumHbJGinZdxAYUiobmKsmqmkDmJfgovN465XqwHzuG
         6Bww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BVUQwCPVABzZfjfA1MSF2RPyACpP6SrhyHePd1BxqFg=;
        b=QHgL6bXEmaSqLYv4D++2oJet2EvDY52YBgqA5sOCjWLaYBEnE4ZduLhC0HVx8z/Pbc
         VfiwYhcDT3FK3DtoiyERCAyd6moooD4TnO8IDFZWBPnKadURmt4M0EjOzlkrrAsgUjtz
         IrVCyKwhlHbCDkld0PvwpozGancrKiLq2Qno5jBmQSbYdhw7s4MQrTPy0/KvvXiCkqVG
         t5LQ6ZFIyPuDqpblTdU9fei4ISTx4IEqTMXmI9Xb4bx4Fc3bi/yfNClvBoSBrcC0bWqB
         Knv3C3TRf6FTPhqlLeVSpWPeUdK2RMOxAeBLWT7VvEbii+94IeUYaCAfVTO2v3BQQD2f
         3u5g==
X-Gm-Message-State: AOAM532jxRyyms7qkP18oGIgi7c8NUUUfB3KvreLuKOZB6BhsrMf1YUJ
        xaU8a7nURY9DlgxS9o9ROXSiSQb6v7ebtV/eImQ=
X-Google-Smtp-Source: ABdhPJxLx8xoYZEjROx0BTL0qNPlPGU3HiAjqyY/ohecPOSt6GBiEqNYGVLDCEmO6TyeIq3WPvuhiAqtjFVZ00U0z+U=
X-Received: by 2002:a17:903:32cd:b0:13d:9b0e:7897 with SMTP id
 i13-20020a17090332cd00b0013d9b0e7897mr12692999plr.30.1632156853516; Mon, 20
 Sep 2021 09:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210914143515.106394-1-yan2228598786@gmail.com>
In-Reply-To: <20210914143515.106394-1-yan2228598786@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 20 Sep 2021 09:54:02 -0700
Message-ID: <CAM_iQpWLPvSmZD4CTmzSoor04xfdkvZuDhF=_CCaumT7XiaN7g@mail.gmail.com>
Subject: Re: [PATCH] tcp: tcp_drop adds `SNMP` and `reason` parameter for tracing
To:     Zhongya Yan <yan2228598786@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Yonghong Song <yhs@fb.com>, 2228598786@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 7:38 AM Zhongya Yan <yan2228598786@gmail.com> wrote=
:
>
> When we wanted to trace the use of the `tcp_drop(struct sock *sk, struct =
sk_buff *skb)` function, we didn't know why `tcp` was deleting `skb'. To so=
lve this problem, I updated the function `tcp_drop(struct sock *sk, struct =
sk_buff *skb, int field, const char *reason)`.
> This way you can understand the reason for the deletion based on the prom=
pt message.
> `field`: represents the SNMP-related value
> `reason`: represents the reason why `tcp` deleted the current `skb`, and =
contains some hints.
> Of course, if you want to know more about the reason for updating the cur=
rent function, you can check: https://www.brendangregg.com/blog/2018-05-31/=
linux-tcpdrop.html

I think you fail to explain why only TCP needs it? This should
be useful for all kinds of drops, not just TCP, therefore you should
consider extending net/core/drop_monitor.c instead of just tcp_drop().

Also, kernel does not have to explain it in strings, those SNMP
counters are already available for user-space, so kernel could
just use SNMP enums and let user-space interpret them. In many
cases, you are just adding strings for those SNMP enums.

Thanks.
