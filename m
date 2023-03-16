Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D40A6BC260
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 01:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjCPAXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 20:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjCPAXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 20:23:40 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC56C76161
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 17:23:39 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-5416b0ab0ecso327877b3.6
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 17:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678926219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GBBdkxZAXRCi7TG8F08OVVEoAmrcMUusc/B0YVetYOs=;
        b=Z/UXxuRicb6SbI++I77ObBvfb4Xq8N5eh78ZITv/DxHwxkyLLqwIiLSRm321BtAU0c
         BoY3lU0ejWLOGqA/lrwZ5owhTaJ8ZwNVOAf5+BK8jO3UDYVMZuzzruZCkXM9Z7XwSgGv
         ZW3gijy+AzytGAeEUy9YXPWIoDlSK+lILpY+bYr9YMRrUgt8EH2mpYZ49XOAgIOT8YBf
         Y8jzz+NX6WFbS9A+afLgml5urKYxM35YdJ2Mzr6SY35fSiwRNuP8gx+QXTThHDYiwd1J
         CUfdvGriDgnoObUVPxujzyyTcpUMbB5f1uh+e9TnrrjZuZ4cg9T87ihRcyNl0U5YNzcT
         lc5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678926219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GBBdkxZAXRCi7TG8F08OVVEoAmrcMUusc/B0YVetYOs=;
        b=NmSgT3p6vl1hYuV2P2Vs1eCu0FyynaxN4TBpE9V5tgbIg1rKFDygueS02RE9tmaswT
         oGxT2SQ7/63baxbtPy5vXnFH89Z/p2i38iEvhQZL9UxopHezdxHVS3W/ju6rAVGoaw6n
         hA/kmtKk1KLAXicHfcF35EOykZi8r2F/9QAkIaDVPdfqNzUTGWIRtfk6DHBWKXlziT9b
         cHFnpZ0MQFZC4nX681JzDf1ysZ95JD6cr7RAqGR7AghrUaml3IJrIzcdgiAhUY0fc0zw
         Cu0IMVBNk7IWn544eOMjmFxhhkUGwTkGWEsR8pMPf0NL8E/avzgrUjo/WTOca6xf1mAa
         HY4A==
X-Gm-Message-State: AO0yUKUXbascKZCv/NQxKu5styGgeplNRsoQRR7DwUe4e91YdYmQPWw8
        5uHgtEeQVpKTCZUdOd59hxO7O+7vjy/Y6j14KCH8jg==
X-Google-Smtp-Source: AK7set9h2LELWGEgT1pyTaNqOLlbwZfDCBsbw+igJGEtXuscsdRBZeL6JKIYmyIBeJdNCu9fu885MfPwRPsPb6rJqqw=
X-Received: by 2002:a81:b184:0:b0:53c:6fda:835f with SMTP id
 p126-20020a81b184000000b0053c6fda835fmr1054065ywh.0.1678926218853; Wed, 15
 Mar 2023 17:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com> <20230315154245.3405750-2-edumazet@google.com>
 <20230315142841.3a2ac99a@kernel.org> <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
 <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com>
 <CAHk-=wjgW-aFo3qLyssg+76-XkYbeMaH58FwW5Bd3-baqfXqrQ@mail.gmail.com>
 <CANn89i+DLp2tDG7DT1bdYvL1o0UBsBzGBA3t4J2P+yn_QLJX2Q@mail.gmail.com>
 <CAHk-=wiOf12nrYEF2vJMcucKjWPN-Ns_SW9fA7LwST_2Dzp7rw@mail.gmail.com>
 <CANn89iKiVQXC1briKcmKd2Fs77f+rBW_WuqCD9z_WViAWipzhg@mail.gmail.com>
 <CAHk-=wj+6FLCdOMR+NH=JsL2VccNJGhg1_3OKw+YOaP0+PxmZg@mail.gmail.com> <CANn89iKzNh0hvJNbKvo5tokg-Kf-btNYpMik8KQ53vLAWgrY9Q@mail.gmail.com>
In-Reply-To: <CANn89iKzNh0hvJNbKvo5tokg-Kf-btNYpMik8KQ53vLAWgrY9Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Mar 2023 17:23:27 -0700
Message-ID: <CANn89i+uJwvGy6HRN4Ym8Q=jSDx=wDEU-5neo=b3C+xJf=pW-g@mail.gmail.com>
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

On Wed, Mar 15, 2023 at 5:11=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Wed, Mar 15, 2023 at 5:02=E2=80=AFPM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Wed, Mar 15, 2023 at 4:56=E2=80=AFPM Eric Dumazet <edumazet@google.c=
om> wrote:
> > >
> > > container_of_const() does not detect this bug at compile time, does i=
t ?
> > >
> > > struct sk_buff *skb =3D ...;
> > >
> > > struct inet_sk *inet =3D inet_sk(skb);
> >
> > You didn't actually test it, did you?
>
> I thought I did, sorry. I will spend more time on it.

Oh I might have been fooled, because of course we can not use sk for
the macro parameter name.

-ENOTENOUGHSLEEP

Basically something like this should work just fine

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 6eb8235be67f8b8265cd86782aed2b489e8850ee..caa20a9055310f5ef108f9b1bb4=
3214a3d598b9e
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
+#define inet_sk(ptr) container_of_const(ptr, struct inet_sock, sk)

 static inline void __inet_sk_copy_descendant(struct sock *sk_to,
                                             const struct sock *sk_from,
