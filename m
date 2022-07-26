Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65195817D1
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 18:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239262AbiGZQsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 12:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbiGZQsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 12:48:10 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7F02559A
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 09:48:08 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id j63so5192639ybb.13
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 09:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5DhOEfQjc0UBW5Ej14FMIk1Cij3TutYe/mI7JM8ogpM=;
        b=ftLESBLN89GyCffQOu1wrxd0Fze9Pbxcs+DezVxvbdCZlynm77q2c2YB0/ReshfxGj
         Kkgi9xzOs51Mr5A0G7GrAAGDHmZbq6cVmviAgC3sR2EMvHmcu01cv+t4++FjF5lrPJnS
         Y05qtSPeCWfw5GeNwXfIygMBkWbkFucKya9g5ClmoPtlej4noxXUufXEVyacsUrgalYu
         KT9wmVT8DYZeofbeu59etnZap70VV788DnoosDB9k9VwOUuBu6D9NBeopgbDrOje6hd2
         Kz+1gJEj+kB04YPmOOqfIdv/heQauAbsqSGHaNKg69PQxEI2hmlE8WOhC3DNt03sEmuH
         b81w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5DhOEfQjc0UBW5Ej14FMIk1Cij3TutYe/mI7JM8ogpM=;
        b=XQzivNUkiAN6BQPVGyPT8a2+igrwgzo4WMNE8Lr7611xuzVaVWaN3DUInH3CT+mDBE
         g92OZnM1GVPsBrir2u/bKekp59tWe1CzYrwgkkKaDOX5qf8t4vpPh27hs8WcmG9fFXz+
         FlfiRKxAoCuQXsmt4hTBBG10OdTYRog6ISCxWPcV/17wlbBq39G3Ksezmzu3iaCk/R8F
         HLEc7YdFt8WSmyl6q+TFyu6Sbv7HwFW3mZBJT3ptOF2b4TDvWq5NZ81DjqUOadV5DRbx
         D7XA87bSBiEb0gDp8mdC2IU9L3hOqJGnb1fqQXoi58S8ig14xAsKl0o/Kix1GJPXzOle
         PkVw==
X-Gm-Message-State: AJIora/jva/B0UV6gftfXLjLdzHxU1t2M59QlT5PLq3fTxLP1zBeJE3x
        1FIiOlhkptjHLjR50kQMxGzED5L11hFS/7YOt8NvKg==
X-Google-Smtp-Source: AGRyM1sadbtaZL7ZosgbL4EQPa0Uq27qPa8L5O1y4dFyUFbl7Ax9oWS8afUfCpZu0mlEaFiea3K4ufL6WWFkOosSPas=
X-Received: by 2002:a05:6902:114b:b0:66f:d0:57c7 with SMTP id
 p11-20020a056902114b00b0066f00d057c7mr14354165ybu.55.1658854087092; Tue, 26
 Jul 2022 09:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220709222029.297471-1-xiyou.wangcong@gmail.com>
 <CANn89iJSQh-5DAhEL4Fh5ZDrtY47y0Mo9YJbG-rnj17pdXqoXA@mail.gmail.com>
 <YtQ/Np8DZBJVFO3l@pop-os.localdomain> <CANn89iLLANJLHG+_uUu5Z+V64BMCsYHRgCHVHENhZiMOrVUtMw@mail.gmail.com>
 <Yt2IgGuqVi9BHc/g@pop-os.localdomain> <CANn89iLHg-D3q8jPFq_87mLFPh5L7arbaF2aNeY42s4VUv_D-Q@mail.gmail.com>
 <YuAS69C22HEi87qD@pop-os.localdomain>
In-Reply-To: <YuAS69C22HEi87qD@pop-os.localdomain>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 26 Jul 2022 18:47:55 +0200
Message-ID: <CANn89iKy9bb2DFpTVosSV2-bpsoLgYPpz3Ep+Qf=EvAqYAWXxw@mail.gmail.com>
Subject: Re: [Patch bpf-next] tcp: fix sock skb accounting in tcp_read_skb()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Jul 26, 2022 at 6:14 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:

> If TCP really wants to queue a FIN with skb->len==0, then we have to
> adjust the return value for recv_actor(), because we currently use 0 as
> an error too (meaning no data is consumed):
>
>         if (sk_psock_verdict_apply(psock, skb, ret) < 0)
>                 len = 0;  // here!
> out:
>         rcu_read_unlock();
>         return len;
>
>
> BTW, what is wrong if we simply drop it before queueing to
> sk_receive_queue in TCP? Is it there just for collapse?

Because an incoming segment can have payload and FIN.

The consumer will need to consume the payload before FIN is considered/consumed,
with the complication of MSG_PEEK ...

Right after tcp_read_skb() removes the skb from sk_receive_queue,
we need to update TCP state, regardless of recv_actor().

Maybe like that:

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ba2bdc81137490bd1748cde95789f8d2bff3ab0f..6e2c11cd921872e406baffc475c9870e147578a1
100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1759,20 +1759,15 @@ int tcp_read_skb(struct sock *sk,
skb_read_actor_t recv_actor)
                int used;

                __skb_unlink(skb, &sk->sk_receive_queue);
+               seq = TCP_SKB_CB(skb)->end_seq;
                used = recv_actor(sk, skb);
                if (used <= 0) {
                        if (!copied)
                                copied = used;
                        break;
                }
-               seq += used;
                copied += used;

-               if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
-                       consume_skb(skb);
-                       ++seq;
-                       break;
-               }
                consume_skb(skb);
                break;
        }
