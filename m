Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08CF50A8A1
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 21:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391677AbiDUTDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 15:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391668AbiDUTDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 15:03:18 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B2B120B6
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 12:00:27 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2eba37104a2so62858037b3.0
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 12:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dibQVW220A9lBnFZzOic5SqKAXKDfElBa15cRmQcjsQ=;
        b=C0UW5MejA3mGyToMWdDymFaTiJDqhMd80fTVdIClNg/nh2CZxIt0sLSoK6yr795GFM
         dpEi4KLzP5HszqafegW29T+hYxyMXa5QnUuLRTp8f8XUbevNmmS+jqbSVVBocFdvO/3r
         7FuP3XRXQk7eFRQUrSnhWvPEQLm7GhLxufxvnQ6TaR/OD+sc+mn+KTPBpyAQQaPdNHGb
         kuREimQfj5SgXoubQMJHOcY6NCIUTMiGDqJeaFEAN9ZP742AEoD8PUAjygtGONlDgA6s
         LXNCaQdsW2xonGw8CVxGhyobNLXVIAq6t2sDRMkFc+HACXkd1nAiPj2N4lYEwBnQwWZq
         LOHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dibQVW220A9lBnFZzOic5SqKAXKDfElBa15cRmQcjsQ=;
        b=BwWU3Ffb9Syl5cBZW4kalZ3rJOkwxtsBJvrPm9JfjOLRFrrrKZqAPCmwPb0KqkImg1
         CNG+ZUozKAXLUeWpWCTWgDSin1erIAFc6QjEMc+/BqhIUGjAUfje0T8ioCMTfVqfa7YK
         cbQnqCODMrMDXpt7Flne3akO17ghZjwSqvZE400Z+03tbrBj9lz3K1QnLQLWALr866Od
         Cj8fPvY9/abb34uYok28snD9iGauHANqYZpG617bQP+PoIebZm0vYeJYFA2rXMilt9aN
         gLMn69hb/i7WQjbKejE7apKNMeb30JNuqOU9uWPvz78nozChCW+sJgiI7JqeR+ehU5h0
         M89Q==
X-Gm-Message-State: AOAM5333kudqTt4z+UTYGWQOdzFqA9kLMhC/O5YlwmdyfWUO2BGyZj7/
        GK3a6dGSXIHm9BpCgJkiXiOOfL0ktSu2ZeLfLrI=
X-Google-Smtp-Source: ABdhPJwgSKbF/k+g3sFmPTSEJCMb/syVBmq4kg5N5xcr5eajhnQ2EDzyyXFeoUEklBN+3C/p5cOGF+Z8gHtTQ0L52AI=
X-Received: by 2002:a0d:e806:0:b0:2ef:338c:9644 with SMTP id
 r6-20020a0de806000000b002ef338c9644mr1232675ywe.59.1650567627055; Thu, 21 Apr
 2022 12:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
 <20220410161042.183540-2-xiyou.wangcong@gmail.com> <6255da425c4ad_57e1208f9@john.notmuch>
In-Reply-To: <6255da425c4ad_57e1208f9@john.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 21 Apr 2022 12:00:14 -0700
Message-ID: <CAM_iQpWQwsJ1eWv9X9O5DqJUhH3Cx-gz+CfHXQsyjeqF04bJPQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v1 1/4] tcp: introduce tcp_read_skb()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 1:00 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > This patch inroduces tcp_read_skb() based on tcp_read_sock(),
> > a preparation for the next patch which actually introduces
> > a new sock ops.
> >
> > TCP is special here, because it has tcp_read_sock() which is
> > mainly used by splice(). tcp_read_sock() supports partial read
> > and arbitrary offset, neither of them is needed for sockmap.
> >
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
>
> Thanks for doing this Cong comment/question inline.
>
> [...]
>
> > +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> > +              sk_read_actor_t recv_actor)
> > +{
> > +     struct sk_buff *skb;
> > +     struct tcp_sock *tp = tcp_sk(sk);
> > +     u32 seq = tp->copied_seq;
> > +     u32 offset;
> > +     int copied = 0;
> > +
> > +     if (sk->sk_state == TCP_LISTEN)
> > +             return -ENOTCONN;
> > +     while ((skb = tcp_recv_skb(sk, seq, &offset, true)) != NULL) {
>
> I'm trying to see why we might have an offset here if we always
> consume the entire skb. There is a comment in tcp_recv_skb around
> GRO packets, but not clear how this applies here if it does at all
> to me yet. Will read a bit more I guess.
>
> If the offset can be >0 than we also need to fix the recv_actor to
> account for the extra offset in the skb. As is the bpf prog might
> see duplicate data. This is a problem on the stream parser now.
>
> Then another fallout is if offset is zero than we could just do
> a skb_dequeue here and skip the tcp_recv_skb bool flag addition
> and upate.

I think it is mainly for splice(), and of course strparser, but none of
them is touched by my patchset.

>
> I'll continue reading after a few other things I need to get
> sorted this afternoon, but maybe you have the answer on hand.
>

Please let me know if you have any other comments.

Thanks.
