Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BA74636E6
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242291AbhK3Oma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242282AbhK3Om3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:42:29 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17ADAC06174A;
        Tue, 30 Nov 2021 06:39:09 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id l25so87454181eda.11;
        Tue, 30 Nov 2021 06:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=M6DtkT7yqdJnxtyLICuawnpZM7p79Wj4fCV0rOvuorc=;
        b=kWQKHzgCw0nBmZ3KPMcZlngLgy0R3fADL9T6FpN+8T6f0/8Q340Bfe6WTP8fxqMC6B
         xilA11oYDQ8S8ZRy+cQ9XoC/TRc7a1/pvGKh2ktPlJQ2u8WgaT9APjwT7BNnmwQOwLbn
         fZmuQ4+gOxaun276AtofMqTN84jvrtBr1fIBOkxT8KcU6Zhw2SI3NL8o7wSxeS9gYukJ
         WVUGuD2E1fzYGZYrtaLMhk1b2mH+ej3sRDRqMkGnUfXcFiK/MLYFs6i7JvbQXcJ42oef
         15LDy8T8X1g51OZW/RgDpW0upS3LxWgtcJ3X8bK7+QAbw28vLj3N8gozCfvCsk14nWxG
         hlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=M6DtkT7yqdJnxtyLICuawnpZM7p79Wj4fCV0rOvuorc=;
        b=g5B3vMP4bclXs/vOOSPNtqSb+axnQY3VdTWhs6FxcHVZJYLjWe1TcKh/aoWZH9yQLx
         +lvimaFekO9sMHnAG+2q9nHh+zGcGLycKUZ6D18XMn6CCOVAjf221NbP5Q2gWeayc4ps
         Gciy5niVM626LDy5ALG4vLJKpSXRAZGhmB6cS6PD+YAD5ZbFuR0YqpkClAmnfD1sJnGx
         wgu7oVA0r8f25FQymIYD3YUBYW4552y3FVfAXKL+9qkE5f2rD0crbKkza8J49iUg/W3m
         GmNgQzH1TUoyh3ifqQSTLilTr06D6QJ8qE8Hj+I/7a/YEAmHhi9WxJi7BHarGDGvQOma
         mKUA==
X-Gm-Message-State: AOAM532eF6FTkZnJSQPIQsgLHbCLy+pN3Lj7nDLOP7n1ExDtikS9QHfd
        CGeDiHhQxKN9205rdodiLrirLPOARJaqL/jTFCk=
X-Google-Smtp-Source: ABdhPJweaAObaI0URjNLnhUOKtwKK07rAqckNLWdRLVytqGybnD74/eNpXw48zCymxAK4tp2IHkO4NsDn6iMaBNby20=
X-Received: by 2002:a05:6402:2692:: with SMTP id w18mr83091835edd.220.1638283148308;
 Tue, 30 Nov 2021 06:39:08 -0800 (PST)
MIME-Version: 1.0
References: <20211128060102.6504-1-imagedong@tencent.com> <20211129075707.47ab0ffe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211129075707.47ab0ffe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 30 Nov 2021 22:36:59 +0800
Message-ID: <CADxym3YJwgs1-hYZURUf+K56zTtQmWHbwAvEG27s_w8FwQrkQQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: snmp: add statistics for tcp small queue check
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Eric Dumazet <edumazet@google.com>,
        Menglong Dong <imagedong@tencent.com>,
        Yuchung Cheng <ycheng@google.com>, kuniyu@amazon.co.jp,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 11:57 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 28 Nov 2021 14:01:02 +0800 menglong8.dong@gmail.com wrote:
> > Once tcp small queue check failed in tcp_small_queue_check(), the
> > throughput of tcp will be limited, and it's hard to distinguish
> > whether it is out of tcp congestion control.
> >
> > Add statistics of LINUX_MIB_TCPSMALLQUEUEFAILURE for this scene.
>
> Isn't this going to trigger all the time and alarm users because of the
> "Failure" in the TCPSmallQueueFailure name?  Isn't it perfectly fine
> for TCP to bake full TSQ amount of data and have it paced out onto the
> wire? What's your link speed?

Well, it's a little complex. In my case, there is a guest in kvm, and virti=
o_net
is used with napi_tx enabled.

With napi_tx enabled, skb won't be orphaned after it is passed to virtio_ne=
t,
until it is released. The point is that the sending interrupt of
virtio_net will be
turned off and the skb can't be released until the next net_rx interrupt co=
mes.
So, wmem_alloc can't decrease on time, and the bandwidth is limited. When
this happens, the bandwidth can decrease from 500M to 10M.

In fact, this issue of uapi_tx is fixed in this commit:
https://lore.kernel.org/lkml/20210719144949.935298466@linuxfoundation.org/

I added this statistics to monitor the sending failure (may be called
sending delay)
caused by qdisc and net_device. When something happen, maybe users can
raise =E2=80=98/proc/sys/net/ipv4/tcp_pacing_ss_ratio=E2=80=99 to get bette=
r bandwidth.

Thanks!
Menglong Dong
