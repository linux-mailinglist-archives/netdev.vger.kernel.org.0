Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439F16BC1B2
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbjCOXqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbjCOXqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:46:34 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF68C19C44
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:46:05 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id r1so27544ybu.5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678923964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GURfLkH9fjCPvPTlLdPo8C1lhWFs6sSXbaIseFlcfEY=;
        b=qYti+SVdyPx4ELzRApWRlZA67qEntlxMl2eLVnQxxc6lJKsVMbqpgqgjgIh+GqpAwg
         VDdoRjT4eNiqswwY5R7n7H9n77rgsMHCAM7O12xxRJASOJ4ZPAM72xm1UCGKHmSmtH7o
         8THY2LLp4UWwGEEeJp8kXUq/TE15r4KsjSlaYUgZ3hu+Wbpncel3liJjoNG3eANR8Mga
         3md26A0rgMXlipRZOUoIbk3DcoO2yJYKoQ4N4klWYaxRslpKB+Q2uKV8Y67cLnM/P96E
         7HGDcEzPw3LOz3T6JLZHE4gZai1oz6sQdKC6fwsarcPM8ea+LMqzUPkvpeYKfRhDRJ5D
         olrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678923964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GURfLkH9fjCPvPTlLdPo8C1lhWFs6sSXbaIseFlcfEY=;
        b=MQbGxRXL2EeG0Q8KzlX0IlIDyOhNsrKa0FxFTwXCEfXZypkSuT/wzcyWZzzOipRT5i
         WJenFGmFZ6nCLxzap2TFDaDetc+8A9OpleELM0fYERfwGi0qzTtVZBCGNkjktZJ8TtZz
         nrbRczii+7sMy18QUTYfR9GPEXPfqhFhfe2mv5TMNM/DL0dpOo3trgcCr2Mf85N7BC58
         bkEIfjDMzAHVo7K67Hu1qOWq+tX7fU7W4WPwJVGExGZ+CPlrzXiFEmQOprZMVkX8pjxC
         kludpH5pzwyWN/QdacrXP/I0pYCb73pSqn+dawcYRJkufbLnfzRnjUvIjxKgIgqlM+VY
         aGKw==
X-Gm-Message-State: AO0yUKXj8ZYsvTBWmm+95mcLx3wEMSIHZh3Mi500dL0tXXOfsLUcV5sO
        G4X4+VzwA3mHBF/POVTjFyMV0Ut+s8Xo5ZjbEdy2cA==
X-Google-Smtp-Source: AK7set/BQnt8HWVOer2oQ2mpfgBIJj1ZGFXyK8ebg7Klvv7FujqIUAqpAlULU4onVMAuAIOiZM7X78jxDr28aILn/rs=
X-Received: by 2002:a05:6902:4f:b0:b38:461f:daeb with SMTP id
 m15-20020a056902004f00b00b38461fdaebmr7829457ybh.6.1678923963427; Wed, 15 Mar
 2023 16:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com> <20230315154245.3405750-2-edumazet@google.com>
 <20230315142841.3a2ac99a@kernel.org> <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
 <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com> <CAHk-=wjgW-aFo3qLyssg+76-XkYbeMaH58FwW5Bd3-baqfXqrQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjgW-aFo3qLyssg+76-XkYbeMaH58FwW5Bd3-baqfXqrQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Mar 2023 16:45:52 -0700
Message-ID: <CANn89i+DLp2tDG7DT1bdYvL1o0UBsBzGBA3t4J2P+yn_QLJX2Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/8] inet: preserve const qualifier in inet_sk()
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

On Wed, Mar 15, 2023 at 4:40=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Mar 15, 2023 at 4:21=E2=80=AFPM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But I really don't see why you don't just use
> > "container_of()", which is actually type-safe, and would allow "struct
> > inet_sock" to contain the "struct sock" somewhere else than in the
> > first field.
>
> I guess that doesn't work, because of how sk_alloc() and friends are set =
up.
>
> But I do think the networking code should strive to avoid those
> "randomly cast one socket type to another".

Note that my v1 proposed this thing:

#define inet_sk(sk) \
+       _Generic(sk,                                           \
+                const struct sock * : ((const struct inet_sock *)(sk)), \
+                struct sock * : ((struct inet_sock *)(sk)) \
+       )


Jakub feedback was to instead use a common helper, and CCed you on the
discussion.
I do not see yet how to do this 'without cast'

Let me know if you are ok with the v1 approach.

>
> For example, when you have a TCP socket, instead of casting from
> "struct sock *" to "struct tcp_sock *" in tcp_sk(), and getting it all
> wrong wrt const, I think you should do the same thing:
>
>   #define tcp_sock(ptr) container_of(ptr, struct tcp_sock,
> inet_conn.icsk_inet.sk)
>
> to really *show* that you know that "yes, struct tcp_sock contains a
> 'sk' embedded three structures down!".
>
> And no, I did not actually *test* that at all. But it should get
> 'const' right (because container_of() gets const right these days),
> _and_ it actually verifies that the type you claim has another type
> embedded in it actually does so.
>
>                   Linus
