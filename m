Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97346BC235
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 01:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbjCPALW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 20:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbjCPALU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 20:11:20 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD7B3402D
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 17:11:18 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-540cb2fb5b9so67907b3.3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 17:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678925478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pPNXvaFfhWp6FgS6V4f9mToYRtJfkshxmIl+tVXgNd0=;
        b=BzLo9XBPFmm2fG6pYb/Fk27p9JqEJUXkyXA/h23gowJSl7U+HJtl5l9zkp/F8HoEDx
         m3asS3+P+Bc0H7ZtIxL0sBgP01/xF8E/oLcfyFbV4FUMkfJE6I/OGKQnTtXRVL9kDy4J
         Y5pWWC2eQOZE7/AfNYpYW60MBQfMwVDaPLbSOGYRSwboX5xYeX/b73EeDffW1ctz3l+U
         qZZxJSh+kkkinJKjPYCtWo4nc4RCjPgD0T+FUt580TjKQjw2tUgt+bql1eVC8hqErD1j
         xOk0wh9gXvfthS/JSbRsaBTuz9vVTmdpB6Wzobt2LrOOKmcvIY1STrYs7UFh7Th+/Bgi
         DVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678925478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pPNXvaFfhWp6FgS6V4f9mToYRtJfkshxmIl+tVXgNd0=;
        b=LagmiXdvox7ei2kRdHmNNqY9h4MwEfVTvDu3wVfpSHwCCSRFfRpQnxOkzz76JlQh30
         lKfOtJ+k/iJGXeOW4drkwCS+UgHmY7z+vz1YbGW/9cXbOd0Ci3wfskIauWVUmqg1pekW
         ksuS6c2PxfF2e7QOkhH6tVLQ6JmS9ty6Ly6+72qiSh038vRvEgkby/Nt/ywO2ypVpFL0
         wT1jWmcoLtCZdswPivwAw+3WnckHs/yiwwIWla+4tAxjNIyWORcI/J1TdIPr/+HAAKor
         o+nhWHPh47KCSUznpmxoCRd/SYIbcC3yXa2ifaoRPxs3oUYTI2Of9llL9gLy5NggRdUP
         TS4w==
X-Gm-Message-State: AO0yUKW0Uge4ziukXahmOTTy6ymUjRP4FVAy62TWLVSA42YRavpU4/H4
        3p4BFgAi9VusUPUAk7CGeOpAnDCaT//D66ld9NOc/VUXm6OWlfHK/No=
X-Google-Smtp-Source: AK7set8rwbKg/IvZMGwrB5z1ibGGS4XKhAdRoo/jBoEzmPWMeuTXje/WO5Mn03dVuNxIGJ3sbAAQa/iZZD5C3uaohGM=
X-Received: by 2002:a81:4413:0:b0:52e:e8b1:d51e with SMTP id
 r19-20020a814413000000b0052ee8b1d51emr1131253ywa.1.1678925477626; Wed, 15 Mar
 2023 17:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com> <20230315154245.3405750-2-edumazet@google.com>
 <20230315142841.3a2ac99a@kernel.org> <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
 <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com>
 <CAHk-=wjgW-aFo3qLyssg+76-XkYbeMaH58FwW5Bd3-baqfXqrQ@mail.gmail.com>
 <CANn89i+DLp2tDG7DT1bdYvL1o0UBsBzGBA3t4J2P+yn_QLJX2Q@mail.gmail.com>
 <CAHk-=wiOf12nrYEF2vJMcucKjWPN-Ns_SW9fA7LwST_2Dzp7rw@mail.gmail.com>
 <CANn89iKiVQXC1briKcmKd2Fs77f+rBW_WuqCD9z_WViAWipzhg@mail.gmail.com> <CAHk-=wj+6FLCdOMR+NH=JsL2VccNJGhg1_3OKw+YOaP0+PxmZg@mail.gmail.com>
In-Reply-To: <CAHk-=wj+6FLCdOMR+NH=JsL2VccNJGhg1_3OKw+YOaP0+PxmZg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Mar 2023 17:11:06 -0700
Message-ID: <CANn89iKzNh0hvJNbKvo5tokg-Kf-btNYpMik8KQ53vLAWgrY9Q@mail.gmail.com>
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

On Wed, Mar 15, 2023 at 5:02=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Mar 15, 2023 at 4:56=E2=80=AFPM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > container_of_const() does not detect this bug at compile time, does it =
?
> >
> > struct sk_buff *skb =3D ...;
> >
> > struct inet_sk *inet =3D inet_sk(skb);
>
> You didn't actually test it, did you?

I thought I did, sorry. I will spend more time on it.

>
> I get about 40 lines of error messages about how broken that is, starting=
 with
>
>    ./include/linux/build_bug.h:78:41: error: static assertion failed:
> "pointer type mismatch in container_of()"
>
> exactly because yes, 'container_of()' is very pissy indeed about bogus
> conversions.
>
> You can only convert a named member into a containing structure, and
> 'inet_sk' does not contain a member named 'sk' that is of type 'struct
> skb_buff'.
>
>             Linus
