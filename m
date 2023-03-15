Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D996BC1CC
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbjCOXy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbjCOXy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:54:27 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D94E7281
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:54:26 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r11so1093679edd.5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678924464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NtbWKY019b1AN5H09VZnU3NC5Gez9MfKRMNu+pjtwVE=;
        b=AaATJeWTALEtIuLW/evhMlDREiB4CfF4E6CzlbdXGAJM5imLbknJdnDjEVfY0xLp/T
         pFdBUicSL45ekyDmxzwcpz6vRo5fNfkP7/kF5vs+hH+lh8ZXFNAmacyXkaEosjdGo1xV
         HhRggLgOjoQfAk1qXYo5DD+NjnmDgBODb6w/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NtbWKY019b1AN5H09VZnU3NC5Gez9MfKRMNu+pjtwVE=;
        b=Ez11i+y4wxpl7vvun09cQaeuACPGFJ9dEVPlCPGPzI5lwUO5stYufMqdpgzxH2dGWX
         M/177QMc/wxHbZcNdmzktR7S/qL3zpf3hV8C+Vp3FKtRdvxXsRF0KcBwem9NEObE5KiI
         jQVwCBJ0jN7UDJQIf/CATmw3Yh0gS5gO/yoed17z3XmDfy3FI0Seh1G7E5wT9UrCDUYh
         ToXLxpHVnwqB67J0OKzu4Cq1/O9bYgyhoY8Ot4AevweNk3YID3uyjnQwGnn60tGOHFya
         SMblG28134xoXj8V46Ril6zVxfXxEbCXJbTWFS3wiNRp5H4j2LcU5tgy+6oA0thVHPSc
         ZbPA==
X-Gm-Message-State: AO0yUKXcvN7L9PQes7U8qpQ2fJzAkxkoHBylNe8wsnfDod8mLSe8pxtq
        lBLficqZj0S7Hnk5fH2wLGNazPn6tBYUqB+sENAArA==
X-Google-Smtp-Source: AK7set/TQv6/TwwG0kAR3tnoTi/5QopdLwcGSXeMoxu7On0ArG8VtyDhU6dYJJvE3pYDXvPE2KpzNg==
X-Received: by 2002:a17:906:3a46:b0:930:6d59:d1f8 with SMTP id a6-20020a1709063a4600b009306d59d1f8mr124788ejf.10.1678924464347;
        Wed, 15 Mar 2023 16:54:24 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id ay13-20020a170906d28d00b0092fb818127dsm688335ejb.94.2023.03.15.16.54.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 16:54:23 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id o12so1017634edb.9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:54:23 -0700 (PDT)
X-Received: by 2002:a17:906:7d98:b0:92b:f118:ef31 with SMTP id
 v24-20020a1709067d9800b0092bf118ef31mr4143869ejo.15.1678924462672; Wed, 15
 Mar 2023 16:54:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com> <20230315154245.3405750-2-edumazet@google.com>
 <20230315142841.3a2ac99a@kernel.org> <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
 <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com>
 <CAHk-=wjgW-aFo3qLyssg+76-XkYbeMaH58FwW5Bd3-baqfXqrQ@mail.gmail.com> <CANn89i+DLp2tDG7DT1bdYvL1o0UBsBzGBA3t4J2P+yn_QLJX2Q@mail.gmail.com>
In-Reply-To: <CANn89i+DLp2tDG7DT1bdYvL1o0UBsBzGBA3t4J2P+yn_QLJX2Q@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Mar 2023 16:54:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiOf12nrYEF2vJMcucKjWPN-Ns_SW9fA7LwST_2Dzp7rw@mail.gmail.com>
Message-ID: <CAHk-=wiOf12nrYEF2vJMcucKjWPN-Ns_SW9fA7LwST_2Dzp7rw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/8] inet: preserve const qualifier in inet_sk()
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 4:46=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> Note that my v1 proposed this thing:
>
> #define inet_sk(sk) \
> +       _Generic(sk,                                           \
> +                const struct sock * : ((const struct inet_sock *)(sk)), =
\
> +                struct sock * : ((struct inet_sock *)(sk)) \
> +       )

Right. That was better.

But:

> Jakub feedback was to instead use a common helper, and CCed you on the
> discussion.
> I do not see yet how to do this 'without cast'

That's _exactly_ what container_of_const() does.

I actually would want to make "container_of()" itself do that
correctly, but we clearly have too many broken cases as-is, so
'container_of_const' it is.

             Linus
