Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E6F6BC1A4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbjCOXmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbjCOXmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:42:03 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BB8A9DEB
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:40:49 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id r11so999320edd.5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678923596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qBe0nXyFE4A9zoLpe4TvtrUjCHhFDmIAbNHtYjZAiuc=;
        b=He+HQcvVkBzpCVY/loOgo7zcGLxSNM6QrWvZ3zJg6zJrNDnH4PAO3riMTQxRRU8iZ5
         xk4MDJyLURZO9VxIG0crEYL9A9HkdYNVfdj2a7uqU7fy7NuwA38H7rHIWjNlBLQE98/T
         Jvhr3b3Py529zb1Kl5fnVJYPjeMflG+TZy8RI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678923596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qBe0nXyFE4A9zoLpe4TvtrUjCHhFDmIAbNHtYjZAiuc=;
        b=yDKb9UyH7vdwBAyLgfVzBDhfD7lZGlnCa2waCKBv25SyM5gRjmsMjEVzB5EJzt6MNh
         mp0vWWX68caSuigMTWKQn5NF8L3GJbMNgFScLudE1yhzzxSZMVxr5N6Xlv6YEuYo2khR
         WQy6VjLtXHl9WwzB5HqdKUaHi3mzZQUngKeTZ2LwNhUG7cTVIAQr+Gwue+J/MI56m++T
         cSOi3tt6J+h5umE3ah0V49TqGAtFb/5TOv095yBt+Vyn7SHiOZ0Sy1KjJweFE+4x9ejJ
         d6/e47mehnU1jdco+v8+V7hashHSxzA3A1JJWwNXTLiFYm5tzVNYEi9g6wxC06gT2Dsc
         8VzQ==
X-Gm-Message-State: AO0yUKUszg2Wsm6IJUOwu8IcTe7eiqtQsu1lX3S7QRaiq14X8bw+FELS
        EEZqK+VHFqNytTcT53eFOQ2A9OPnNGpkvSihj5PUDQ==
X-Google-Smtp-Source: AK7set8dcT6h7aRQY6YsOx4q9eKh/fM+RhH0ZbbSe6fGpuosR8tywn9IM55BWZgjZGbvdiORI1zkSA==
X-Received: by 2002:a17:907:2da7:b0:8e6:bcb6:469e with SMTP id gt39-20020a1709072da700b008e6bcb6469emr8959943ejc.0.1678923596340;
        Wed, 15 Mar 2023 16:39:56 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id r8-20020a170906c28800b00928e0ea53e5sm3092417ejz.84.2023.03.15.16.39.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 16:39:55 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id cn21so1185452edb.0
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:39:55 -0700 (PDT)
X-Received: by 2002:a50:9315:0:b0:4fb:2593:844 with SMTP id
 m21-20020a509315000000b004fb25930844mr2471393eda.2.1678923595112; Wed, 15 Mar
 2023 16:39:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com> <20230315154245.3405750-2-edumazet@google.com>
 <20230315142841.3a2ac99a@kernel.org> <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
 <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com>
In-Reply-To: <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Mar 2023 16:39:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjgW-aFo3qLyssg+76-XkYbeMaH58FwW5Bd3-baqfXqrQ@mail.gmail.com>
Message-ID: <CAHk-=wjgW-aFo3qLyssg+76-XkYbeMaH58FwW5Bd3-baqfXqrQ@mail.gmail.com>
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

On Wed, Mar 15, 2023 at 4:21=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But I really don't see why you don't just use
> "container_of()", which is actually type-safe, and would allow "struct
> inet_sock" to contain the "struct sock" somewhere else than in the
> first field.

I guess that doesn't work, because of how sk_alloc() and friends are set up=
.

But I do think the networking code should strive to avoid those
"randomly cast one socket type to another".

For example, when you have a TCP socket, instead of casting from
"struct sock *" to "struct tcp_sock *" in tcp_sk(), and getting it all
wrong wrt const, I think you should do the same thing:

  #define tcp_sock(ptr) container_of(ptr, struct tcp_sock,
inet_conn.icsk_inet.sk)

to really *show* that you know that "yes, struct tcp_sock contains a
'sk' embedded three structures down!".

And no, I did not actually *test* that at all. But it should get
'const' right (because container_of() gets const right these days),
_and_ it actually verifies that the type you claim has another type
embedded in it actually does so.

                  Linus
