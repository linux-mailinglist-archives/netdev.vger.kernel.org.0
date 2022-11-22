Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EB763344E
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiKVECx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbiKVECq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:02:46 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E274662DF
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:02:45 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-39451671bdfso107582787b3.10
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AX6APvJikAYtW4PVkwMRIJdH8dGEjjV5+qfFv2x71ow=;
        b=Ofsz+qnTkD48dKaxtS0KPTOcIZO6tQPTI+ehJlwX1nndOY8gNJf2WrgMocLsdJXBko
         Q2SLT0pVCMMrgqE/9hBAK6ckul/cyyuXebMnKCQj4imRPQchnVVEMz+XqvDrXp5mucNh
         ePbO5luzQh1o3aph25NpJoNUuZniKz6e4uRj4kmgZRgcpDMGKLnJUtP6IqogkLPUGG6i
         z31kMDEyjtOa3bIfr+lW28nxzIcESkVBCb5QOUp7Eypi+zjQz9vcWcqM5FZZq0GFD/sL
         deQgei5SJUI1V4udogSfIVDwkQdqf0kQDCu3mplLree57gk1T6j0glKPndd0oFNlCK4e
         a6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AX6APvJikAYtW4PVkwMRIJdH8dGEjjV5+qfFv2x71ow=;
        b=PTZ5Bzz1vwV81PktHrz14S2bnOXo0L7YMq5GW1DcujRsSI3syAl5BfpNtyEjmQVJRt
         iUG29ZGuXQ+wvin3ZwI+bkJvunb154XrycAZtkkLpesDhqWsN7yY2gUQaseTEI8Rv7z/
         qx5fTEqQSGJjn2LW5ViROjCXqfK7RX/HHaNfY1vv2UwyTq/fgFhpSm+uDFQraC+OeRbt
         slj/UaPT5qtJxSFiUOyxeU4U8prCn7JRxSHh7xoVFlAflQ1M7bU6ZZCrqHr8b320aS2g
         79gOS+DaARdA5M0C3HHw/hsVriemXqr9/FQZ9dt2xdmpv+c3O2NY3gPAaKiBLGU4EhOE
         4Tdw==
X-Gm-Message-State: ANoB5pngQfbY8iFoOyjSrUFu+hs7z727IEqt4g/xBrDL4LydYWzZC7sc
        /SA7fMRi+Lc2odGJGT4zYmy0rnZJGQU6MfGCkv2WcQ==
X-Google-Smtp-Source: AA0mqf702DrsBfXyfsI8+kznXmvyc+4PVlBvjKIOkaGco+Xu2kG0JJ1HPtB0QtSV/yGqFmnKiqrzeM31S2QXkM9y3Zs=
X-Received: by 2002:a0d:dbcf:0:b0:39f:21ad:8475 with SMTP id
 d198-20020a0ddbcf000000b0039f21ad8475mr2311911ywe.489.1669089764608; Mon, 21
 Nov 2022 20:02:44 -0800 (PST)
MIME-Version: 1.0
References: <20221115211905.1685426-1-dima@arista.com> <20221115211905.1685426-4-dima@arista.com>
 <20221118191809.0174f4da@kernel.org> <31efe48a-4c68-f17c-64ee-88d45f56c438@arista.com>
 <20221121124135.4015cc66@kernel.org> <5c899a02-cec1-07c9-1c1a-8747773ece0c@arista.com>
 <20221121195326.2632f138@kernel.org>
In-Reply-To: <20221121195326.2632f138@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Nov 2022 20:02:33 -0800
Message-ID: <CANn89i+T8f5fNyPdq_vQEqQZGdS2rx3+8Sbt_-d+8A6zPyM6vA@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 7:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 21 Nov 2022 20:56:18 +0000 Dmitry Safonov wrote:
> > > Dunno from memory, too much happens in these files :S
> > >
> > > Could you cherry-pick [1] onto net-next and see if
> > >
> > >   git am --no-3way patches/*
> > >
> > > goes thru cleanly? If so no objections for the patches to go via tip,
> > > we're close enough to the merge window.
> >
> > That did go cleanly for me on today's net-next/main.
>
> Great, feel free to slap my:
>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
>
> on v5. (But we'll still want a proper review from Eric.)

I'll try my best.
