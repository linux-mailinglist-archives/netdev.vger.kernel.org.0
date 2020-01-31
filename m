Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B1F14F251
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgAaSlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:41:51 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40228 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgAaSlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 13:41:51 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so9856604wmi.5
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 10:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5gmwKqAKc5kWsvxeD4EGDMD92bC5n6bIWCn6V1AM57Q=;
        b=QLNMX1SL1B0wIJPcq1V+nHEJTkeo/O/GjbIOI07GeptbjLniIUYgGIHZJtxSLMJoym
         38aq5Ow0vT8WTjknPWWTIgoK+6mO4KwiBgDsMimoHYicdYksWZtiRMgzfQDgFjNXZNI1
         lpOBIcxuKbboFR2KTUw+G9/zqhxwTG/BggV7kYrZDBt9kZTQKIWb6PCqxqQ4vnXrS9+5
         D5rjEYs4HPYO/cH4Fy4s9xTbbDGhMxS7u9IiyzmzqphNh3NFlYL36gfOT+LThfYA4dr+
         n7ib9UmPOfZ2+WxGWOjDV3baK3rwG7WqR68Jx+KpWgTWVE9bOhfCkkAEgyC0Dnw5whDy
         cXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5gmwKqAKc5kWsvxeD4EGDMD92bC5n6bIWCn6V1AM57Q=;
        b=pn5/HiCFbTpJOpn95TBNd0YNv3N2j4aJkItLIBetKH78szovKOsFZTr1TjIueSLziU
         dP0Mdf74S4MrB0LAIjSFHgt0fzsh7I2j4yxGf9ima/nwEKudIX5D1QsIm4hNThD56DxV
         jkGCrLEQc788iFPeF93ctINmkg1lYEpn383AxbQC0ZQhq+7FMoEsG4Ua5vBT7NFIZmOq
         +SSqoQN4tNEG3ptyZNJAI4ohWi78y9KGV97PoeIh5uTjZNFEfXuWin93wI8FPoX6/Jd7
         IzNmQYGtluPavkfQRWwNXVgJd1qenU+gPaE4zq79z4idxHSVTJwd9aY9R7YUCdNfzBJp
         WTWg==
X-Gm-Message-State: APjAAAXwFsxnY5hadJBrhiSw84ajdmbn87GVoSyj7D/QKLe0dMEY0mKt
        hGSDXRDAG2dvXKq07RAP2N88vu35I/N/WJDdoJefvA==
X-Google-Smtp-Source: APXvYqzFoHwcaYLzfWkYaneTs2Zo7iUsuHzERbU41SfIMHCtj+bKtImwcdoULSMez/paPiCscHk1QDBBak4Gn+JYvM4=
X-Received: by 2002:a1c:4d08:: with SMTP id o8mr13758443wmh.86.1580496108817;
 Fri, 31 Jan 2020 10:41:48 -0800 (PST)
MIME-Version: 1.0
References: <20200131182247.126058-1-edumazet@google.com> <CADVnQy==XFxLXmJtmx3tnsscpUGr_sRNGFaRwg+64o7Dkwq2zg@mail.gmail.com>
In-Reply-To: <CADVnQy==XFxLXmJtmx3tnsscpUGr_sRNGFaRwg+64o7Dkwq2zg@mail.gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Fri, 31 Jan 2020 13:41:03 -0500
Message-ID: <CACSApvaPH9oD7gM8KHnT1Pn=uD3g-6jDwyt0X5-MKooVcaySYA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: clear tp->delivered in tcp_disconnect()
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 1:32 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Fri, Jan 31, 2020 at 1:22 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > tp->delivered needs to be cleared in tcp_disconnect().
> >
> > tcp_disconnect() is rarely used, but it is worth fixing it.
> >
> > Fixes: ddf1af6fa00e ("tcp: new delivery accounting")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Yuchung Cheng <ycheng@google.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
> > ---
> >  net/ipv4/tcp.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index dd57f1e3618160c1e51d6ff54afa984292614e5c..a8ffdfb61f422228d4af1de600b756c9d3894ef5 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -2622,6 +2622,7 @@ int tcp_disconnect(struct sock *sk, int flags)
> >         tp->snd_cwnd = TCP_INIT_CWND;
> >         tp->snd_cwnd_cnt = 0;
> >         tp->window_clamp = 0;
> > +       tp->delivered = 0;
> >         tp->delivered_ce = 0;
> >         tcp_set_ca_state(sk, TCP_CA_Open);
> >         tp->is_sack_reneg = 0;
> > --
>
> Thanks, Eric!
>
> Acked-by: Neal Cardwell <ncardwell@google.com>
>
> neal

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Nice catch! Thanks!
