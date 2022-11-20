Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE6C631207
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 01:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiKTARa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 19:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbiKTAR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 19:17:29 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE0713DCA
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 16:17:26 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id m7-20020a9d6447000000b0066da0504b5eso5339128otl.13
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 16:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XUPs0hYXxpkXDpCeoleV/+p5PmIn6PPnxUwAFD/HPjo=;
        b=KNu2ekV9QV5hqtJvgJWHR8HbP3fiaToN04J0PmyWskLj7FdAME7LVWHUV22OZtohpO
         Vzs5tFbWqS2i4S7/oof2frAFV2sONy8n9q80YAPZ0I2HEJq1u9M2txPaoJHJrLETJx6S
         MuCUjz3+frMGKRzLpgrS0NyEqgTMMMtqU9shfDhd8allaFsZISlfqlFYVyGHpM/zLa0g
         4xCJDxewnA9KLf5MPTH2ZAgbUGVkIiED54CBz+uH+FcCR3vdhgC2hrYcEdpm3D7ZCSdL
         F2kOCdD1f8r6THZJuEHIQOC+aXATJMmLE3flcoZ5qm2rQzRR8edt5KMF9lpCG6IzgwVf
         X/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XUPs0hYXxpkXDpCeoleV/+p5PmIn6PPnxUwAFD/HPjo=;
        b=Bmi+isvF88wK1OU4PGjN+M2pq4q+lgwqsvpN5T5j/MTg0/VAAdDce0hRPOjd+v8FQj
         EuHmN8rfBVv6CS9frrWcQsvGvk9/fnTYF07uqOqQrPKPggGcZlOH80pZD7YP9n/HpWB5
         RJB7MrXFay4tXzWSEU8JATfQymtrslwB2sYsX9G4MuTMfx2XRNfbabq0tOVw4MSmXyCe
         0BfBHbt7zivh8KdzkQxmhKzWHoLlqOPSCmNzB63V50fIH5/h4kAPWwgZpv/pF2sxhmX+
         dHwP3mTSWiqxIMUbp/Hcm9CEBp7xwb+PWuyzw6gGIaHWvgbQPE3E3Nl7q/q4BpGyFO7M
         6bjA==
X-Gm-Message-State: ANoB5pnjJowhqbjZcmhixlSYhH2O2pmOD9ocOmC6Xv4zMZCg/DFM2O2F
        hUZpmFpWYmXp3NwY8FMQ/Bu2TnlUdnuRbBpGvng=
X-Google-Smtp-Source: AA0mqf5AiTx+l4fWJglfkE4TdwCr/Uhk52JqS6E9vgcj+hsQoUFJ5eGgrPrkkSRvdsM0Gxvn+xzVYfSGgkEJ9xsKsBE=
X-Received: by 2002:a9d:6b88:0:b0:66c:5797:5c11 with SMTP id
 b8-20020a9d6b88000000b0066c57975c11mr6817554otq.305.1668903446108; Sat, 19
 Nov 2022 16:17:26 -0800 (PST)
MIME-Version: 1.0
References: <Y3lYkqBhw1eK6dth@euler>
In-Reply-To: <Y3lYkqBhw1eK6dth@euler>
From:   Jamie Bainbridge <jamie.bainbridge@gmail.com>
Date:   Sun, 20 Nov 2022 11:17:15 +1100
Message-ID: <CAAvyFNg3=Dm00oMGwQnQPPeu0c8mEqM3ZvdK2xA5nFtpkitZRQ@mail.gmail.com>
Subject: Re: Kernel build failure from d9282e48c6088
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, Geert sent a patch:

https://lore.kernel.org/netdev/d1ecf500f07e063d4e8e34f4045ddca55416c686.166=
8507036.git.geert+renesas@glider.be/

Jamie

On Sun, 20 Nov 2022 at 09:28, Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> Just a heads up, commit d9282e48c6088 ("tcp: Add listening address to
> SYN flood message") breaks if CONFIG_IPV6 isn't enabled.
>
> A simple change from an if() to a macro and I'm on my merry way. Not
> sure if you want anything more than that.
>
> In file included from ./include/asm-generic/bug.h:22,
>                  from ./arch/arm/include/asm/bug.h:60,
>                  from ./include/linux/bug.h:5,
>                  from ./include/linux/mmdebug.h:5,
>                  from ./include/linux/mm.h:6,
>                  from net/ipv4/tcp_input.c:67:
> net/ipv4/tcp_input.c: In function =E2=80=98tcp_syn_flood_action=E2=80=99:
> ./include/net/sock.h:387:37: error: =E2=80=98const struct sock_common=E2=
=80=99 has no member named =E2=80=98skc_v6_rcv_saddr=E2=80=99; did you mean=
 =E2=80=98skc_rcv_saddr=E2=80=99?
>   387 | #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
>       |                                     ^~~~~~~~~~~~~~~~
> ./include/linux/printk.h:429:19: note: in definition of macro =E2=80=98pr=
intk_index_wrap=E2=80=99
>   429 |   _p_func(_fmt, ##__VA_ARGS__);    \
>       |                   ^~~~~~~~~~~
> ./include/linux/printk.h:530:2: note: in expansion of macro =E2=80=98prin=
tk=E2=80=99
>   530 |  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>       |  ^~~~~~
> ./include/linux/net.h:272:3: note: in expansion of macro =E2=80=98pr_info=
=E2=80=99
>   272 |   function(__VA_ARGS__);    \
>       |   ^~~~~~~~
> ./include/linux/net.h:288:2: note: in expansion of macro =E2=80=98net_rat=
elimited_function=E2=80=99
>   288 |  net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~
> ./include/linux/net.h:288:43: note: in expansion of macro =E2=80=98sk_v6_=
rcv_saddr=E2=80=99
>   288 |  net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
>       |                                           ^~~~~~~~~~~
> net/ipv4/tcp_input.c:6847:4: note: in expansion of macro =E2=80=98net_inf=
o_ratelimited=E2=80=99
>  6847 |    net_info_ratelimited("%s: Possible SYN flooding on port [%pI6c=
]:%u. %s.\n",
>       |    ^~~~~~~~~~~~~~~~~~~~
>   CC      net/ipv4/icmp.o
> make[3]: *** [scripts/Makefile.build:250: net/ipv4/tcp_input.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [scripts/Makefile.build:500: net/ipv4] Error 2
> make[1]: *** [scripts/Makefile.build:500: net] Error 2
> make: *** [Makefile:1992: .] Error 2
>
