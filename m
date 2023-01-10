Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA5666433E
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 15:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbjAJO3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 09:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbjAJO3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 09:29:12 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB903AF
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:29:10 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-4d0f843c417so42075057b3.7
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W1/IlsowDKP/3r1B2CaPcaivSmsHP1df4SER37W7GxA=;
        b=Bob2ZHY8L4ZwCKgbTC5fpYz8Xz5LLL+2HPtRqwuFzrXYJLnhZFmrYFLo7yD9MUCGkw
         6nwNNSFtoJCrQMjqnNTjYmIpRsRR8PNpDo3beNEkMXoc27EV11zB3Wyb3pzdsvOd1X8U
         WNIxn24jyMicVHvEk+2uj3pM2Ls3bwPFghucaJE1bxRZem0ZJTXgxdYJ7sLfjo8CguJC
         mf4YBI7cfhb2J+gWFzbECLqPZH/zZU4DEWu/TF1BpgI7wV5eXQZLLjXaetMoqGKLGAre
         jvyTfbnOWXinhutqiFjZzaMk6e0Tvdh2Uc+9Z/s+eJJpQRmTtxHXFOk1BOW4KssJEP0x
         zr4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W1/IlsowDKP/3r1B2CaPcaivSmsHP1df4SER37W7GxA=;
        b=PxLTomjRn/8BmgmiO3m0Q6PfW5Vz4/oMmYyFvmstc+nT0/98kTSsq2iVPvVdQfNsCJ
         QSOgo4eltiLZVD92xXAr1RacB8S7hW33mYNDHIuxyY3DhTsIys5Lh2ym542n9fGTwZfb
         CbIF3jrSXAHSvM2fhHCekVbnEcN0dyztD8MzQLO+iVytbiFdlty3s5HkeqsDO83UCH5S
         uypcLzt+5jxSKP76H8mxPApbpcEFhY/smq3erSkiePBjlaxp8Z2ap5nSS9FJh6srFXVh
         7c4mwD32m5xSpmvjDMHZOyVSXVV2Hwm7t2ULUyPwR5H4I0PpA6zpokQq+Oa3c9vK0Uns
         xnBA==
X-Gm-Message-State: AFqh2kpsMlH0QQ89RflgQYJ4wWGSB1RwT2Q24+5hTOOGAT8BOYSmbz7/
        P93S7RSKp887aSC/rwjJrllTG5wTOuCcm2Kchgl3yQ==
X-Google-Smtp-Source: AMrXdXuF5Xfu645Jler6GWlBrNdBTjTPBrbiqUqqkfvFFbwW9e5kim/9wfpx+1Z9A8cbbVleBCt8UAnEU2OqY/aqGfA=
X-Received: by 2002:a0d:d6c2:0:b0:46b:c07c:c1d5 with SMTP id
 y185-20020a0dd6c2000000b0046bc07cc1d5mr1332906ywd.55.1673360949790; Tue, 10
 Jan 2023 06:29:09 -0800 (PST)
MIME-Version: 1.0
References: <20221221-sockopt-port-range-v2-0-1d5f114bf627@cloudflare.com> <20221221-sockopt-port-range-v2-1-1d5f114bf627@cloudflare.com>
In-Reply-To: <20221221-sockopt-port-range-v2-1-1d5f114bf627@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 10 Jan 2023 15:28:58 +0100
Message-ID: <CANn89iJmmENm6DTP4qjkN23j_KT7ZS_hweR5qks4VETsUzA_eQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] inet: Add IP_LOCAL_PORT_RANGE socket option
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        kernel-team@cloudflare.com, Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 2:37 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Users who want to share a single public IP address for outgoing connections
> between several hosts traditionally reach for SNAT. However, SNAT requires
> state keeping on the node(s) performing the NAT.
>

> v1 -> v2:
>  * Fix the corner case when the per-socket range doesn't overlap with the
>    per-netns range. Fallback correctly to the per-netns range. (Kuniyuki)
>
> Reviewed-by: Marek Majkowski <marek@cloudflare.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/net/inet_sock.h         |  4 ++++
>  include/net/ip.h                |  3 ++-
>  include/uapi/linux/in.h         |  1 +
>  net/ipv4/inet_connection_sock.c | 25 +++++++++++++++++++++++--
>  net/ipv4/inet_hashtables.c      |  2 +-
>  net/ipv4/ip_sockglue.c          | 18 ++++++++++++++++++
>  net/ipv4/udp.c                  |  2 +-
>  7 files changed, 50 insertions(+), 5 deletions(-)


Being an INET option, I think net/sctp/socket.c should also be changed.

Not clear if selinux_socket_bind() needs any change, I would CC
SELINUX maintainers for advice.
