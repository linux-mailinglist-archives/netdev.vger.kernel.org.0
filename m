Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6449A6343F1
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbiKVSsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiKVSsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:48:24 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD4087A65
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:48:17 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-3a3961f8659so61518867b3.2
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Suef9qGZyeDmFmQNW1pPUf7Q/ChJX92BCODoUZMGLX8=;
        b=bpwN8N30HWXpzkqtkYdHqlpJnE/hAc39tI0RG2EBizFiHAyyzDd8REAjY3JuQBRCTH
         JNdWLd1KhEyT8nHF4Jt3nBNvKdBi/mpsKcpziexcwK2urw9bCT+qaP+ZK98xkkaJSkHN
         ZT70ZxNJaM9bNGGCmCghOxMNJLrljLTYASXsJPfcnRG2sbK9sXy1t0FIC8pf72nFCtW2
         YtuDj8eubWOiQQuu6qHx65jW0eU/K6aVXXVZnLvSf72QUEKnYmJX8SfLC7eZYiVZpCEU
         oIqFgfw3um/rjinQVBwSxysye+mOg+SC/OAC1yx0mhxOeVxVZqyOYd8J4be+TmowG6uc
         DHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Suef9qGZyeDmFmQNW1pPUf7Q/ChJX92BCODoUZMGLX8=;
        b=aNK22y8OpDmChZZUrmADw+a3170rgUTegDTcB/hIWZq/dlUanAvVJeur1BCmqwQnLd
         C1Svo7pQW8shYXPTWeM1UwUOCaxc/757xTtLMpQafDhyg9BZ5KeYzPTjEddZLXfZTPZx
         x4tZbHMwgsTBzSb2Vb+O8RB5Ej9QtDH9o4GpL6C/LBJEbG+mjbMnbiBxsGEfo0RBQ9m5
         tPjyo0xBzHSFMSGAc6BtRk+D68C7LJ0jvAyfzIigC6VrAxmy0Ix4rxnY18c9V1+7HVEr
         8fM2R+0MO7PbrhSIfGu5521rEQTYRk1LNJbub+lFoIDkT/9oFoVYH9F+jZs8ADAFv69O
         mrPQ==
X-Gm-Message-State: ANoB5pktyrj+WouTKPVJPsQcdmiSw/eRdg4TbTJ7sXKWd7331WKyzTHp
        wH1q7R0LyKjNdGBC9XfLaePlCxZVcjAUk3/6cVN+Ig==
X-Google-Smtp-Source: AA0mqf7988lpR33vi1F2g1fgKd/46A3PWLVSvRNIGU0sT5FGaq/tu3ij3PEWJqXryerpC9ywVGCNN8/7/vL9DZBIIgM=
X-Received: by 2002:a05:690c:a92:b0:36c:aaa6:e571 with SMTP id
 ci18-20020a05690c0a9200b0036caaa6e571mr23269568ywb.467.1669142896591; Tue, 22
 Nov 2022 10:48:16 -0800 (PST)
MIME-Version: 1.0
References: <20221122184158.170798-1-saeed@kernel.org>
In-Reply-To: <20221122184158.170798-1-saeed@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 22 Nov 2022 10:48:05 -0800
Message-ID: <CANn89i+6wuATYqe2eN2+P4rA6_EwfZwzWhpZb+ZnxWHp+yG5sQ@mail.gmail.com>
Subject: Re: [PATCH net-next V2] tcp: Fix build break when CONFIG_IPV6=n
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, Nov 22, 2022 at 10:42 AM Saeed Mahameed <saeed@kernel.org> wrote:
>
> From: Saeed Mahameed <saeedm@nvidia.com>
>
> The cited commit caused the following build break when CONFIG_IPV6 was
> disabled
>
> net/ipv4/tcp_input.c: In function =E2=80=98tcp_syn_flood_action=E2=80=99:
> include/net/sock.h:387:37: error: =E2=80=98const struct sock_common=E2=80=
=99 has no member named =E2=80=98skc_v6_rcv_saddr=E2=80=99; did you mean =
=E2=80=98skc_rcv_saddr=E2=80=99?
>
> Fix by using inet6_rcv_saddr() macro which handles this situation
> nicely.
>
> Fixes: d9282e48c608 ("tcp: Add listening address to SYN flood message")
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> CC: Matthieu Baerts <matthieu.baerts@tessares.net>
> CC: Jamie Bainbridge <jamie.bainbridge@gmail.com>


Thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
