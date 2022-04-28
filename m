Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1783512984
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 04:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241438AbiD1Ce6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 22:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241428AbiD1Ce5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 22:34:57 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9C58AE56;
        Wed, 27 Apr 2022 19:31:44 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id a1so3952539edt.3;
        Wed, 27 Apr 2022 19:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rsECo+2OlRIIUX6px+ZZedqf8Qza4lbnki5ll/KBNjU=;
        b=NLed8agnFcwlUPM9IZ/j7FQ4+Mzu64jql5QkMCdls5tCo+wgQ/hDxjoJbNKvpjMlzh
         lpd25fx8qXqOi72uCZANGtZWU84pO5AKT2HHa5ZOPLkwf9gS5RS9gqjVv2sNhyMl2DxA
         MMhwnMyZi19AiSh14c+t+AzGKJu+nPqGjfDOFdJLNIJbmgc/0J9FoX5tgbhCkmtmj8aK
         4/SuilzIQcXvF6nqX1Bbr6wcf9wKhYHMPN71C/wtWl87PvP8t56CldPtruhYgZPhJ6cW
         7qFyn2RC5ZCxhhrTO3d6EkiDfdUH1qDGtpKlDKTys2pSIWOoovAYiJYKltW8NsPvmFvU
         flSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rsECo+2OlRIIUX6px+ZZedqf8Qza4lbnki5ll/KBNjU=;
        b=TR5oVyRN/6pFEz/5XxPcSfs70uc8cReqybeTNaSpZuTRqLD85s35lBnG5R6b/rDs56
         Y8DyYhk9KyfbDseTkJ8kRw1uEJIvN85qP0H05nWj8FTGaQwOEMxLmxajzoLQWJ1j6Y9S
         ZEXsfaFtWFiD0XS2bhl8htW/lsVaqCaNBxdxGnX6+ZK8d55gp0jwd2vgVtHcOZCvOEH5
         eUtA0ApVpfqebzSkLjMaxtzAbZ95w7CMOikizyyOKl0b0PRZHonayItgxmXUWwh1QB/g
         h7daczHAL+J3xQ00MP3lJGH5bXcFZNq+fmA6RTOT+23QsNyL3oS1lsIWvCQ97S66wtjQ
         3RMA==
X-Gm-Message-State: AOAM530yT/QNx9EFyMB+6Ur1YvhIID07yWVY3bDabtRPL07Wztk7uKBt
        h+ykICp1IUBhCWaiGsnUtrcshwtsPqhkz/QnyuQ=
X-Google-Smtp-Source: ABdhPJwzd+wNN/Ghq9mRwrycbsK5MTBwpY7MI6hugkMW/Mi/0p4fFeNLt7O2W6LKcCYeXCzFuM5NuyJxu3SzbPpTO1I=
X-Received: by 2002:a05:6402:358c:b0:426:19c0:2ee7 with SMTP id
 y12-20020a056402358c00b0042619c02ee7mr5371296edc.137.1651113102771; Wed, 27
 Apr 2022 19:31:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220426080709.6504-1-imagedong@tencent.com> <20220426080709.6504-2-imagedong@tencent.com>
 <CANn89iJa3FZHXfUWHw-OwOu8X_Cc0-YzxkgE_M=8DrBN1jWnAQ@mail.gmail.com>
In-Reply-To: <CANn89iJa3FZHXfUWHw-OwOu8X_Cc0-YzxkgE_M=8DrBN1jWnAQ@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 28 Apr 2022 10:31:31 +0800
Message-ID: <CADxym3ZrdVWUy=vrNWMHUK83243VE_LT3WOn0ThuqnwLDNQtKw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: add skb drop reasons to inet connect request
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Biao Jiang <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>,
        Menglong Dong <imagedong@tencent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Mengen Sun <mengensun@tencent.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
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

On Tue, Apr 26, 2022 at 9:32 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Apr 26, 2022 at 1:07 AM <menglong8.dong@gmail.com> wrote:
> >
[......]
> > +                       if (!err)
> > +                               consume_skb(skb);
>
> Please, do not add more mess like that, where skb is either freed by
> the callee or the caller.
>

Yeah, this is a little chaotic.....I just can't find a way out :/
keeping thinking

>
> > +                       return err < 0;
>
> Where err is set to a negative value ?

-1 is returned in dccp_v4_conn_request()

>
>
> >                 }
> >                 SKB_DR_SET(reason, TCP_FLAGS);
> >                 goto discard;
> > @@ -6878,6 +6877,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
> >         bool want_cookie = false;
> >         struct dst_entry *dst;
> >         struct flowi fl;
> > +       SKB_DR(reason);
> >
> >         /* TW buckets are converted to open requests without
> >          * limitations, they conserve resources and peer is
> > @@ -6886,12 +6886,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
> >         if ((net->ipv4.sysctl_tcp_syncookies == 2 ||
> >              inet_csk_reqsk_queue_is_full(sk)) && !isn) {
> >                 want_cookie = tcp_syn_flood_action(sk, rsk_ops->slab_name);
> > -               if (!want_cookie)
> > +               if (!want_cookie) {
> > +                       SKB_DR_SET(reason, TCP_REQQFULLDROP);
> >                         goto drop;
> > +               }
> >         }
> >
> >         if (sk_acceptq_is_full(sk)) {
> >                 NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
> > +               SKB_DR_SET(reason, LISTENOVERFLOWS);
> >                 goto drop;
> >         }
> >
> > @@ -6947,6 +6950,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
> >                          */
> >                         pr_drop_req(req, ntohs(tcp_hdr(skb)->source),
> >                                     rsk_ops->family);
> > +                       SKB_DR_SET(reason, TCP_REQQFULLDROP);
> >                         goto drop_and_release;
> >                 }
> >
> > @@ -7006,7 +7010,8 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
> >  drop_and_free:
> >         __reqsk_free(req);
> >  drop:
> > +       kfree_skb_reason(skb, reason);
>
> Ugh no, prefer "return reason" and leave to the caller the freeing part.
>
> Your changes are too invasive and will hurt future backports.
>

Okey, I'll try some way else.

>
> >         tcp_listendrop(sk);
> > -       return 0;
> > +       return 1;
> >  }
> >  EXPORT_SYMBOL(tcp_conn_request);
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index 157265aecbed..b8daf49f54a5 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> > @@ -1470,7 +1470,8 @@ int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb)
> >
> >  drop:
> >         tcp_listendrop(sk);
> > -       return 0;
>
> This return 0 meant : do not send reset.
>
>
> > +       kfree_skb_reason(skb, SKB_DROP_REASON_IP_INADDRERRORS);
>
> double kfree_skb() ?
>
> > +       return 1;
>
> -> send RESET
>

No, this return 1 means not send RESET and this skb is already freed in
icsk_af_ops->conn_request(), since I made a change to the caller of
conn_request() in tcp_rcv_state_process() and dccp_rcv_state_process():

    err = icsk->icsk_af_ops->conn_request(sk, skb);
    local_bh_enable();
    rcu_read_unlock();
    if (!err)
        consume_skb(skb);
    return err < 0;

if err==1, the skb will not be freed again, as 0 is returned by
tcp_rcv_state_process()

> >  }
> >  EXPORT_SYMBOL(tcp_v4_conn_request);
> >
> > --
> > 2.36.0
> >
>
> I have a hard time understanding this patch.
>
> Where is the related IPv6 change ?
>
> I really wonder if you actually have tested this.

Yeah, I missed the IPv6....but it still works, the changes are
compatible with current IPv6 code.

In fact, I have tested it, and everything is ok, no double free
happens:

  drop at: tcp_conn_request+0xf1/0xcb0 (0xffffffff81d43271)
  origin: software
  input port ifindex: 1
  timestamp: Thu Apr 28 10:19:42 2022 917631574 nsec
  protocol: 0x800
  length: 74
  original length: 74
  drop reason: LISTENOVERFLOWS

  drop at: tcp_conn_request+0xf1/0xcb0 (0xffffffff81d43271)
  origin: software
  input port ifindex: 1
  timestamp: Thu Apr 28 10:19:43 2022 930983132 nsec
  protocol: 0x800
  length: 74
  original length: 74
  drop reason: LISTENOVERFLOWS
