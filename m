Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8F4634435
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 20:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiKVTCR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Nov 2022 14:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbiKVTCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 14:02:06 -0500
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CA68CF24
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 11:02:04 -0800 (PST)
Received: by mail-qv1-f42.google.com with SMTP id j6so10696456qvn.12
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 11:02:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2f/71KnGt891JaO49Do9Xj7uGJgKZaxYrdCCIWaszRU=;
        b=XXuAkXcY3IHVrilFAee9kjHTADy/d3oBCJmLIv2SJih21a/+J5A58S+z0lDPthZuvm
         Zgfy7li9ZnXEmsU0059MXZZRuJ9usNQ9HdJnHy89qgn8Y1Rm59PnbWkHxUzoBK0yssRI
         2YztmhNzarAOMmz5W9QpsxQtg4eXSPGXOCvjVAcUAsj3n3OtLO9x9WL3wpLzZywK5qVq
         iWQU7fjD/OYXyp1ddB8bj9uhDnLJv9ry9eUqmAAl/3LbShd+2Tl+6nQxxn5aEEPwW9Dg
         PsTSzTd31C9GjPUyrDSHxWZtCl4bsJHguiWSIZquexb6DlxegVx67dry1EXxGjLtAEN2
         qDnA==
X-Gm-Message-State: ANoB5pm/MVHR010G5Cdh5Yk96j/hCd8hgUTBhcEOD0Tlc1vJmkcDdWcU
        AtDgyTAy7gw7z37WWtjsv4s4UvXeSDShWA==
X-Google-Smtp-Source: AA0mqf4hPj62Rp90HcRX4J0oZAurhtrbkf8twlPYir6mkSR9d5h4KwDlxH0BicI3sooVzZ05t9VkIg==
X-Received: by 2002:a0c:d7c7:0:b0:4c6:5acc:1e0b with SMTP id g7-20020a0cd7c7000000b004c65acc1e0bmr5340695qvj.24.1669143723301;
        Tue, 22 Nov 2022 11:02:03 -0800 (PST)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id x22-20020a05620a259600b006fb9bfc6103sm10902947qko.123.2022.11.22.11.02.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 11:02:02 -0800 (PST)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-3704852322fso153462597b3.8
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 11:02:01 -0800 (PST)
X-Received: by 2002:a0d:dc87:0:b0:370:61f5:b19e with SMTP id
 f129-20020a0ddc87000000b0037061f5b19emr22386316ywe.316.1669143721201; Tue, 22
 Nov 2022 11:02:01 -0800 (PST)
MIME-Version: 1.0
References: <20221122093131.161499-1-saeed@kernel.org> <CAMuHMdVQAkPhtEdq=-kwQE8v2sgyCx_bD-f2yk95Fc7t4Fz56w@mail.gmail.com>
 <CANn89i+1JanTp=HacjfLkKR_nnC4vA4VJz2tMzAqEb+cFn_3tw@mail.gmail.com> <Y30VLZGDYHAk+lSL@x130.lan>
In-Reply-To: <Y30VLZGDYHAk+lSL@x130.lan>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 22 Nov 2022 20:01:49 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXJr33KNq2C6+qPMF0WNkQAkn=hN5TeQLczQvDcQZE+eA@mail.gmail.com>
Message-ID: <CAMuHMdXJr33KNq2C6+qPMF0WNkQAkn=hN5TeQLczQvDcQZE+eA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: Fix build break when CONFIG_IPV6=n
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,

On Tue, Nov 22, 2022 at 7:30 PM Saeed Mahameed <saeed@kernel.org> wrote:
> On 22 Nov 08:42, Eric Dumazet wrote:
> >On Tue, Nov 22, 2022 at 1:37 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >> On Tue, Nov 22, 2022 at 10:31 AM Saeed Mahameed <saeed@kernel.org> wrote:
> >> > From: Saeed Mahameed <saeedm@nvidia.com>
> >> >
> >> > The cited commit caused the following build break when CONFIG_IPV6 was
> >> > disabled
> >> >
> >> > net/ipv4/tcp_input.c: In function ‘tcp_syn_flood_action’:
> >> > include/net/sock.h:387:37: error: ‘const struct sock_common’ has no member named ‘skc_v6_rcv_saddr’; did you mean ‘skc_rcv_saddr’?
> >> >
> >> > Fix by using inet6_rcv_saddr() macro which handles this situation
> >> > nicely.
> >> >
> >> > Fixes: d9282e48c608 ("tcp: Add listening address to SYN flood message")
> >> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> >>
> >> Thanks for your patch!
> >>
> >> > --- a/net/ipv4/tcp_input.c
> >> > +++ b/net/ipv4/tcp_input.c
> >> > @@ -6843,9 +6843,9 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
> >> >
> >> >         if (!READ_ONCE(queue->synflood_warned) && syncookies != 2 &&
> >> >             xchg(&queue->synflood_warned, 1) == 0) {
> >> > -               if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
> >> > +               if (sk->sk_family == AF_INET6) {
> >>
> >> I think the IS_ENABLED() should stay, to make sure the IPV6-only
> >> code is optimized away when IPv6-support is disabled.
> >
> >Agreed.
>
> sending V2.
>
> but for the record, I don't think such a user exist. Simply if you care
> about such micro optimization, then you are serious enough not to disable
> IPv6.

Sure we do. It's not a micro-optimization, as it gets rid of a printed string.
Several defconfig disable CONFIG_IPV6. People who disable IPv6
because of limited memory welcome the removal of such unused code.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
