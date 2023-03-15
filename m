Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B32D6BBFE5
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjCOWiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjCOWiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:38:04 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12334222FC
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:38:03 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-5416698e889so275452407b3.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678919882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72rR3gEp3ZKHDWXssYZcD2o+6XTIqIkvSJNmdYuaAYU=;
        b=rnyYrT8EIoDiUW32yilvNQqHygy6dfbFiMPJx7DhItiHyMBzKXJe8PZa9MKiRfAKP4
         iUjEL+2TG3pIQHQDWvcw+vu2pyCqfVP29F4B31A/poMrI9Tu25PoPwXh9r10YypRmHxj
         Ju9YHCusId8tP4MUEu4SN+v+iL5hbHsGxsdfVvR+RviAi1yXJAQv4WGJ04V2Vr/XJcqL
         E6iww7m+R7NL2YrBd4LD9cgK8WJNvrGYRtqXeQLX60fwxXM34RiOhLFAsSEXw2N0Ji6V
         xr72kvZy0m5L9dSYN/0Cb92S89O7G6N327Ud5CQ0lsDMHhn6sy6Da79eWVmzmuErfb+I
         cntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678919882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72rR3gEp3ZKHDWXssYZcD2o+6XTIqIkvSJNmdYuaAYU=;
        b=Ly/pIOPAMypEFr9UL7VuR4mT9nFGVgVLfCYUA8KpAwhvQcDRcyXf9cj/Z2j5VBQyso
         Y4oE2gOWmEp70rZ+qfxkqOoD20a+02SG7CsBvNXrTZR1w+Fwn+y2gOnBoTOH8uzSGPFH
         Ed+NE1vMlJWU6/UYqlLVoEoT7EeVx8lDxq19m2L67SRunEi0XI9YnyKIUjSPHoZrAFLa
         K2YDeaFPqU9p20HDo/yO4R3pZaqD1Vh8WnDEkl63VX4HRludv+QXK3FZ6C22oXFELj+r
         NUDL3NnBBwWl6xf0jWYjhNyrCHmuApKM60CXH15gcSN6kuzk43b67mRLFWdZmv0NjonJ
         j3rw==
X-Gm-Message-State: AO0yUKXZxSO9/FVsAyRwy67ESSAD5UyM57K8TBUbCnsJLF8eJEOvQTjK
        0MYBwDiSJOPoX2isUgCBFbWCUuUUFEdgsXfnQDd7DrkFvY6XYWV6WbIlbw==
X-Google-Smtp-Source: AK7set8+euI5FwCIJnNjwPmshbW+QE85TpHN5ts7nasfB6OaYukdTjWcO+kaHKQMHJan6JsbZmbEbziw+NQYfF2W+Uw=
X-Received: by 2002:a81:a748:0:b0:533:9c5b:7278 with SMTP id
 e69-20020a81a748000000b005339c5b7278mr959648ywh.0.1678919881967; Wed, 15 Mar
 2023 15:38:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com> <20230315154245.3405750-2-edumazet@google.com>
 <20230315142841.3a2ac99a@kernel.org>
In-Reply-To: <20230315142841.3a2ac99a@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Mar 2023 15:37:50 -0700
Message-ID: <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/8] inet: preserve const qualifier in inet_sk()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
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

On Wed, Mar 15, 2023 at 2:28=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Wed, 15 Mar 2023 15:42:38 +0000 Eric Dumazet wrote:
> > -static inline struct inet_sock *inet_sk(const struct sock *sk)
> > -{
> > -     return (struct inet_sock *)sk;
> > -}
> > +#define inet_sk(sk) \
> > +       _Generic(sk,                                                   =
       \
> > +                const struct sock * : ((const struct inet_sock *)(sk))=
,      \
> > +                struct sock * : ((struct inet_sock *)(sk))           \
> > +       )
>
> Could we possibly use container_of_const() or define a new common
> macro for this downcast? I'm worried it will spread and it's a bit
> verbose.

I did see container_of_const() but the default: case was not appealing to m=
e.

Maybe something like this?

diff --git a/include/linux/container_of.h b/include/linux/container_of.h
index 713890c867bea78804defe1a015e3c362f40f85d..9a24d8db1f4c46166c07589bb08=
4eda9b9ede8ba
100644
--- a/include/linux/container_of.h
+++ b/include/linux/container_of.h
@@ -35,4 +35,10 @@
                default: ((type *)container_of(ptr, type, member))      \
        )

+#define promote_to_type(ptr, oldtype, newtype)                 \
+       _Generic(ptr,                                           \
+                const oldtype *: ((const newtype *)(ptr)),     \
+                oldtype *: ((newtype *)(ptr))                  \
+       )
+
 #endif /* _LINUX_CONTAINER_OF_H */
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 6eb8235be67f8b8265cd86782aed2b489e8850ee..96f41b3c1a3e4b6ad1c6d2058ca=
46686be282c03
100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -305,11 +305,7 @@ static inline struct sock *skb_to_full_sk(const
struct sk_buff *skb)
        return sk_to_full_sk(skb->sk);
 }

-#define inet_sk(sk) \
-       _Generic(sk,                                                    \
-                const struct sock * : ((const struct inet_sock
*)(sk)),        \
-                struct sock * : ((struct inet_sock *)(sk))             \
-       )
+#define inet_sk(sk) promote_to_type(sk, struct sock, struct inet_sock)

 static inline void __inet_sk_copy_descendant(struct sock *sk_to,
                                             const struct sock *sk_from,
