Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDBD533260
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 22:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241235AbiEXUXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 16:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241065AbiEXUXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 16:23:03 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51565D5E0
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 13:23:01 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2ec42eae76bso194060947b3.10
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 13:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jkbsj8ZwrUi7OObfgCh/4Ar2JNwqZvHZHWjqqEl/+jU=;
        b=DcF4IOeyC1v9Z+v2nErxKz1G/LVvOm7gwchisLgHi3xQICx+mu9q8u8QSxLDgwtJL7
         OASbpLKso3Ab2vBCILTtKzTqwplcynpS/nLv+j0EXAJg+k273y2lNWN6MgWpwZ332kia
         F6krBjU4uSNwOq/li1dfZwgb3BT/NJtcAV6p818t1T1R3QLXyQ+vECn3AUXir0V0tr98
         nINilkpN2pFDLxd8/0NwlHmAzpA/xM2X532i3r7+gAyzrDoXYSALN0p0Yq8IBDWZFNWz
         YSKW79yB9lklVhZ27eh3a8dhXhyCyJ9vS5G6xa56h5Qht+nUE1h/9n3qQ2RJ4z0Po9MI
         RnZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jkbsj8ZwrUi7OObfgCh/4Ar2JNwqZvHZHWjqqEl/+jU=;
        b=kTnRr6qPENoiyPsNULbzkrmU2RIEkKV1SUy2G/p4ewvtH5ZscU9fBd6z/IpM/Fib5n
         LiYvAw+u3xvtCc+CiNU5SXGPttTz0WIdhnxWNF4ePUc/kZ1llnopV0SiHRRuNeN/ox+1
         rtLb8ZXpFoI1nLS2jwWgHcjgLtwXXWhnx8pBhnZIqPUMfu68gv6k27NRWuogw5wyU00z
         zBpy35/PaxKD1SjkE1dYukAR9ZpMBmwfRAIuCQlhQOmTAtobTEjmsDO/S/Fzuv6OM7E3
         a3M9kYMeZFRRpTZVyEEAoyxmJ6AQdiGFqTQGKyEZOjskJN7Nlz1qZssHZHeySdGx8zDl
         db+Q==
X-Gm-Message-State: AOAM530pe7ZaTcjS4ORZ55YPM37E7hFseXxm9NpEIeUW9MGtA9UC9Uoy
        dslLygMdtRfgghxVMUquMf+/bgaNTC7MnKdsr7sVkA==
X-Google-Smtp-Source: ABdhPJxI0LRDxxcWqCGKYs6WhpYtvmy2F8jbSAxNaFVcE1AEGhn5zSjLp5nioTc3NHXvpgAlkAFCwNktgzjS4b6u/ak=
X-Received: by 2002:a81:b401:0:b0:300:2e86:e7e5 with SMTP id
 h1-20020a81b401000000b003002e86e7e5mr4238965ywi.467.1653423780877; Tue, 24
 May 2022 13:23:00 -0700 (PDT)
MIME-Version: 1.0
References: <4740526.31r3eYUQgx@natalenko.name> <4bd84c983e77486fbc94dfa2a167afaa@AcuMS.aculab.com>
 <CADVnQykt1Lz0m1gfEckHhDLy66xhJvO0F2Z1-yQ=Mgi7gBY5RQ@mail.gmail.com>
In-Reply-To: <CADVnQykt1Lz0m1gfEckHhDLy66xhJvO0F2Z1-yQ=Mgi7gBY5RQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 24 May 2022 13:22:49 -0700
Message-ID: <CANn89iKsJ53GKJyKGLLvn_NhY_oe5TzHLGRtRttZpHaUOVmiBw@mail.gmail.com>
Subject: Re: [RFC] tcp_bbr2: use correct 64-bit division
To:     Neal Cardwell <ncardwell@google.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Yuchung Cheng <ycheng@google.com>,
        Yousuk Seung <ysseung@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Adithya Abraham Philip <abrahamphilip@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konstantin Demin <rockdrilla@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 1:06 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Tue, May 24, 2022 at 4:01 AM David Laight <David.Laight@aculab.com> wrote:
> >
> > From: Oleksandr Natalenko
> > > Sent: 22 May 2022 23:30
> > > To: Neal Cardwell <ncardwell@google.com>
> > >
> > > Hello Neal.
> > >
> > > It was reported to me [1] by Konstantin (in Cc) that BBRv2 code suffers from integer division issue on
> > > 32 bit systems.
> >
> > Do any of these divisions ever actually have 64bit operands?
> > Even on x86-64 64bit divide is significantly slower than 32bit divide.
> >
> > It is quite clear that x * 8 / 1000 is the same as x / (1000 / 8).
> > So promoting to 64bit cannot be needed.
> >
> >         David
>
> The sk->sk_pacing_rate can definitely be bigger than 32 bits if the
> network path can support more than 34 Gbit/sec  (a pacing rate of 2^32
> bytes per sec is roughly 34 Gibt/sec). This definitely happens.
>
> So  this one seems reasonable to me (and is only in debug code, so the
> performance is probably fine):
> -                (u64)sk->sk_pacing_rate * 8 / 1000,
> +                div_u64((u64)sk->sk_pacing_rate * 8, 1000),
>
> For the other two I agree we should rework them to avoid the 64-bit
> divide, since we don't need it.
>
> There is similar logic in mainline Linux in tcp_tso_autosize(), which
> is currently using "unsigned long" for bytes.
>

Not sure I follow.

sk_pacing_rate is also 'unsigned long'

So tcp_tso_autosize() is correct on 32bit and 64bit arches.
There is no forced 64bit operation there.


> Eric, what do you advise?
>
> thanks,
> neal
