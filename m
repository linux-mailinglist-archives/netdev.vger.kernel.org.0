Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479834DC16F
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiCQIib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiCQIhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:37:51 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90001B9FC6;
        Thu, 17 Mar 2022 01:36:35 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id w25so5602413edi.11;
        Thu, 17 Mar 2022 01:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FbLPQTlBes5VIsjaLjqAOziQGJwMzsnqC4xSI4e7GHI=;
        b=VGFVOsKf/LtJbjkJ/rfraQs+UBUBS0WTKx1BGxeVhBzAL46jg5CAzEbVLa+uFt4hHF
         lTpZyH6gkvP8Wgnw9QzVZl5j2HwAFf9dNZldAIL+Dtjgth/VqVhhWnVKDM0kjWnMEmeu
         A5Hq8GQM5otHPQ61Gl3D/JXOMlNzlkMO9OWWqOhjHD96pyuulpq8MzfTDnrHck8ajYl+
         O12na5afH+wwiwKSsTloMF+WS3AI7/sgDU4FA8osM6hifN0DT0W2UZefqIpEYJsSVyPF
         QfMBmEF/++xgS1ODBuTm3l6LApw3PoUs6yHFRP2AcVPJqzkf5kXHy3FoJMWPRIjpfmFq
         kUaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FbLPQTlBes5VIsjaLjqAOziQGJwMzsnqC4xSI4e7GHI=;
        b=FuzIUJCMi92tww9JmA7WqswTzUqBVuLJj2PIWLni2Fw1Ro4sMBpIJ7jGts0+MVgUMv
         ZIGEObd1RjVL5WbDpXn4Z7Dwb/HIn6fwqNJR3EFfb6AS9FvLoGPvlNjzZb23JWLa5BxC
         DFAwJt6R1daOa7ZUmo7UZEgIUTeSInMvJIqrdqbnY75m86P3C9GxcDE0BeQWOVEuIJFz
         f4yZ4J47kVE14joIZj0vorH0Y8UkGMVy0BmHcGa26zhIxfAEvXO6gqUb+nXPXzjDKN5G
         FwADC5MSmK5j2xrbhT7KGM1oKRchWwdWdjXCJuIYTKMtUa2o5RXP72v/Khi6lwxGIQLB
         XMuQ==
X-Gm-Message-State: AOAM531EtrqSs/Yk83dxguJYmlf+O3H4DEMJHhAhm25zOeDIjDaHzpD4
        aR6Q+BtJfSmZng5PbcqSPMbewEfy42p025hQJcI=
X-Google-Smtp-Source: ABdhPJxd5GeG5Xkw/rnSqaRmnp6ZdCV2SHWGJyjh+XHGZ/d9LuEnMBYTl2Iy+k9Z0jnuf3Vo1Sd/LjtDklyMhKQLFbA=
X-Received: by 2002:a05:6402:11d2:b0:418:ea25:976b with SMTP id
 j18-20020a05640211d200b00418ea25976bmr3126534edw.310.1647506194252; Thu, 17
 Mar 2022 01:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220316063148.700769-1-imagedong@tencent.com>
 <20220316063148.700769-3-imagedong@tencent.com> <f6c1dbe5-ba6f-6e68-aa3b-4fe018d5092f@kernel.org>
 <CADxym3Z_o6P+jSu5sUZDQf4bGUj4f4tGEYi7a9z+wRjYu0o1xw@mail.gmail.com> <87764612d480432134b5253f17e3d6fff816e147.camel@redhat.com>
In-Reply-To: <87764612d480432134b5253f17e3d6fff816e147.camel@redhat.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 17 Mar 2022 16:36:22 +0800
Message-ID: <CADxym3YLqMWW-hMv6CzQyEfJqd+RFPoCacmtTyy-3HBHX_5KUg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] net: icmp: introduce __ping_queue_rcv_skb()
 to report drop reasons
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 4:33 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Thu, 2022-03-17 at 13:25 +0800, Menglong Dong wrote:
> > On Thu, Mar 17, 2022 at 11:56 AM David Ahern <dsahern@kernel.org> wrote:
> > >
> > > On 3/16/22 12:31 AM, menglong8.dong@gmail.com wrote:
> > > > diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> > > > index 3ee947557b88..9a1ea6c263f8 100644
> > > > --- a/net/ipv4/ping.c
> > > > +++ b/net/ipv4/ping.c
> > > > @@ -934,16 +934,24 @@ int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(ping_recvmsg);
> > > >
> > > > -int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > > > +static enum skb_drop_reason __ping_queue_rcv_skb(struct sock *sk,
> > > > +                                              struct sk_buff *skb)
> > > >  {
> > > > +     enum skb_drop_reason reason;
> > > > +
> > > >       pr_debug("ping_queue_rcv_skb(sk=%p,sk->num=%d,skb=%p)\n",
> > > >                inet_sk(sk), inet_sk(sk)->inet_num, skb);
> > > > -     if (sock_queue_rcv_skb(sk, skb) < 0) {
> > > > -             kfree_skb(skb);
> > > > +     if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
> > > > +             kfree_skb_reason(skb, reason);
> > > >               pr_debug("ping_queue_rcv_skb -> failed\n");
> > > > -             return -1;
> > > > +             return reason;
> > > >       }
> > > > -     return 0;
> > > > +     return SKB_NOT_DROPPED_YET;
> > > > +}
> > > > +
> > > > +int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> > > > +{
> > > > +     return __ping_queue_rcv_skb(sk, skb) ?: -1;
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(ping_queue_rcv_skb);
> > > >
> > >
> > > This is a generic proto callback and you are now changing its return
> > > code in a way that seems to conflict with existing semantics
> >
> > The return value of ping_queue_rcv_skb() seems not changed.
> > In the previous code, -1 is returned on failure and 0 for success.
> > This logic isn't changed, giving __ping_queue_rcv_skb() != 0 means
> > failure and -1 is returned. Isn't it?
>
> With this patch, on failure __ping_queue_rcv_skb() returns 'reason' (>
> 0) and ping_queue_rcv_skb() returns the same value.
>
> On success __ping_queue_rcv_skb() returns SKB_NOT_DROPPED_YET (==0) and
> ping_queue_rcv_skb() return -1.
>
> You need to preserve the old ping_queue_rcv_skb() return values, under
> the same circumstances.

Oops...my mistake....:)

Thanks for your explanation!

Menglong Dong

>
> Thanks,
>
> Paolo
>
