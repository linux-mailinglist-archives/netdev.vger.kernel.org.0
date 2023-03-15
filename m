Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242C66BC0C8
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbjCOXWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjCOXWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:22:17 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE06A6178
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:21:38 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x3so782121edb.10
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678922497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=viCtZ5VrT2siElZEzhIlbcycyn8GoP+HciTR67CK2cA=;
        b=aQ+OMxqTGfUWYUhMYJzlOygwfBiAv8jaglD0OI+DZSN2CtajlUfn7l6Yj2zTkXcynQ
         l6g1vjz2RBHSPZWJKGxnWoB9FKU+xSIChm1fdn5U3RmRdP+y/Js5I8ovkHwTuc7aC6SH
         g6Fc4+dt1Xo1C++/kTyc9iJl4HdejNFa8DOMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678922497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=viCtZ5VrT2siElZEzhIlbcycyn8GoP+HciTR67CK2cA=;
        b=GoWpvUo7AZkyVdt296xT6A/31vtUYnelCVbFpb3o/UwL8/LCP2bR3WoEu3riYbWYO6
         27qEF14yKvvGI++sKGNZcgpvbAnFE0qQkO0bYJUNJc2tS0H7s5eLCOi0Tb42sf5H2PnF
         ZVd+hhNVfR+FnEil/x0nO5SKRDol36GRDZNTBc8pONloCaTadM/pig6m5bpZjm3fk6XK
         Tzfev/kUFg3VHHIIh2LGnAMekMmVdFowol2YjmQLEaT7TyAb1GJiWpoCg60vX1jHluTX
         QjmzqNwIqSVYmfQ/Oe3c6MV4eOOLwaQnHjzhdkgOvqGiK2CCnnzirMxq395pKRzcOp16
         Tv9g==
X-Gm-Message-State: AO0yUKXlJydlwIokb/+ajSrVgIXcBKAAQ+yl7RksY3Ldy6434mmkL/6h
        M+w12WTyh8XSypAOzTpCLslmq8iOdoM+UYSUli8HQA==
X-Google-Smtp-Source: AK7set+z/g6+MGWJvHYkei51WmfQV6B83n4F4onLHgHVRocKBVgUMrGiF7RD2Jttw3nTD6+SmIRkvA==
X-Received: by 2002:a17:906:9f0a:b0:92b:d4f6:7f4c with SMTP id fy10-20020a1709069f0a00b0092bd4f67f4cmr9366668ejc.2.1678922496798;
        Wed, 15 Mar 2023 16:21:36 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id op1-20020a170906bce100b009222a7192b4sm3066913ejb.30.2023.03.15.16.21.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 16:21:35 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id cn21so1061465edb.0
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:21:35 -0700 (PDT)
X-Received: by 2002:a17:907:804:b0:8e5:411d:4d09 with SMTP id
 wv4-20020a170907080400b008e5411d4d09mr4284616ejb.15.1678922494976; Wed, 15
 Mar 2023 16:21:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com> <20230315154245.3405750-2-edumazet@google.com>
 <20230315142841.3a2ac99a@kernel.org> <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
In-Reply-To: <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Mar 2023 16:21:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com>
Message-ID: <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com>
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

On Wed, Mar 15, 2023 at 3:38=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> Maybe something like this?

Please no.

> +#define promote_to_type(ptr, oldtype, newtype)                 \
> +       _Generic(ptr,                                           \
> +                const oldtype *: ((const newtype *)(ptr)),     \
> +                oldtype *: ((newtype *)(ptr))                  \
> +       )

That's just a very ugly way to just do a cast. It's wrong.

> +#define inet_sk(sk) promote_to_type(sk, struct sock, struct inet_sock)

This is horrid.

Why isn't this just doing

   #define inet_sk(ptr) container_of(ptr, struct inet_sock, sk)

which is different from a plain cast in that it actually checks that
"yes, struct inet_sock has a member called 'sk' that has the right
type, so now we can convert from that sk to the containing structure".

That's very different from just randomly casting a pointer to another
pointer, like the current inet_sk() does, and like that disgusting
promote_to_type() macro does.

We really strive for proper type safety in the kernel. And that very
much means *not* doing random casts.

At least that "inet_sk(sk)" version using generics didn't take random
pointer types. But I really don't see why you don't just use
"container_of()", which is actually type-safe, and would allow "struct
inet_sock" to contain the "struct sock" somewhere else than in the
first field.

Hmm? Am I missing something that is happening in linux-next?

                Linus
