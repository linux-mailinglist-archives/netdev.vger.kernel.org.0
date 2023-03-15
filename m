Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CEC6BC1E8
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbjCOX5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjCOX53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:57:29 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8451467825
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:56:53 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id z83so55062ybb.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678924591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BStx308mNgzvtGlo4nE5Culg5u4Iu2iNn7XkcRTDccg=;
        b=JNgtMk6Vv4HMFiutNVHgUhNridXYkpJGXtXIel6itcc6/chxXuoLKaOJ2s4Q+cUR/c
         KXB4DOs/5VSLAtmtPZja+EzYexHVDXnneEAQk5qDaRnRp+jN/c0L4UdI6Ofm0mdiCNK8
         YdzRSMgzijXfpAriSWffwo9hg/TDExz+zIzyx/DR+Cg9j6QEt9PLgZC0Cs7OEDmcBtyF
         i8GUOWKBJQ+f4ogPlKGLw/++j85+JX2L43rnMF9sSbVqKrMYLkaXPY+bHfAM8PHAYdDj
         e4PSjwbVTgTVgbzLt/tYAtqSvtSfuCU12Heqv2S+W66F6119r4X/crRUCEa6Lo4DmVvj
         TBgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BStx308mNgzvtGlo4nE5Culg5u4Iu2iNn7XkcRTDccg=;
        b=DJoN0eW4V9pTrZ6GQwl/Wb3vevtKVvsr57KUoHMCYEWGhaKxDPYJ8lDjUCaaRkizav
         PfDyVHfEjevBbFTzDT3lZ6m7lQlrkl1FcgRhjX7sygolvsW2tm7IrSscM6VTKcgNueP6
         CCRQXcK5n2dmlmyrI3v8CYkGjRDSQPsnCgYogf6ZuRR06PcG5CCBwb/TX9ragr2Oq/7p
         O4jS7p45qQJYzAV7VPVeQiyzIWnXxE3Dx0Dsybt4ARSH2ARr0KMx7s/WKmRkjezi5Ocy
         14FGzlb6mIxlzEQNfyxAvoXdVYlQXsLX7kBj7d86fdqocZI4hWOcLDSW5gZyJ6jIGh5U
         V2RA==
X-Gm-Message-State: AO0yUKUhWrv1ERccxuLxO3TXQyVwI0t2pxL+KBtKhKa9eMK6mWIp36bg
        /kQZctIbmWe7C4ow+sRQj2AIRlGHHRyni9UywWcnXA==
X-Google-Smtp-Source: AK7set+pFer1ZiB1yV196egnOEE07enj1lMRsY3uJzgLYdO6CM4ufja/ldd4QaEoRVOSwhdqfKTyLtTdYqxwBk3uVQU=
X-Received: by 2002:a05:6902:1205:b0:b3e:c715:c313 with SMTP id
 s5-20020a056902120500b00b3ec715c313mr3104032ybu.6.1678924590987; Wed, 15 Mar
 2023 16:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com> <20230315154245.3405750-2-edumazet@google.com>
 <20230315142841.3a2ac99a@kernel.org> <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
 <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com>
 <CAHk-=wjgW-aFo3qLyssg+76-XkYbeMaH58FwW5Bd3-baqfXqrQ@mail.gmail.com>
 <CANn89i+DLp2tDG7DT1bdYvL1o0UBsBzGBA3t4J2P+yn_QLJX2Q@mail.gmail.com> <CAHk-=wiOf12nrYEF2vJMcucKjWPN-Ns_SW9fA7LwST_2Dzp7rw@mail.gmail.com>
In-Reply-To: <CAHk-=wiOf12nrYEF2vJMcucKjWPN-Ns_SW9fA7LwST_2Dzp7rw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Mar 2023 16:56:19 -0700
Message-ID: <CANn89iKiVQXC1briKcmKd2Fs77f+rBW_WuqCD9z_WViAWipzhg@mail.gmail.com>
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

On Wed, Mar 15, 2023 at 4:54=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Mar 15, 2023 at 4:46=E2=80=AFPM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > Note that my v1 proposed this thing:
> >
> > #define inet_sk(sk) \
> > +       _Generic(sk,                                           \
> > +                const struct sock * : ((const struct inet_sock *)(sk))=
, \
> > +                struct sock * : ((struct inet_sock *)(sk)) \
> > +       )
>
> Right. That was better.
>
> But:
>
> > Jakub feedback was to instead use a common helper, and CCed you on the
> > discussion.
> > I do not see yet how to do this 'without cast'
>
> That's _exactly_ what container_of_const() does.
>
> I actually would want to make "container_of()" itself do that
> correctly, but we clearly have too many broken cases as-is, so
> 'container_of_const' it is.

container_of_const() does not detect this bug at compile time, does it ?

struct sk_buff *skb =3D ...;

struct inet_sk *inet =3D inet_sk(skb);
