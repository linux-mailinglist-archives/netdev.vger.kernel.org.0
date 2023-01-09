Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA98662921
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 15:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbjAIOyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 09:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234750AbjAIOyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 09:54:52 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BFFE50
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 06:54:51 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id o75so8764907yba.2
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 06:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YIgOk2vZYUEppuqaUX7d/zLpPOAJZJ2Q2hrbqGB8Xww=;
        b=iAttVXlqOJBUULuAIBDupT8wsqo+pj8RZgiE+4viHriW0AennRfmWsZ43ZooCRNpou
         31Sy35//2Zb7i7wliONLBc53yLMAJId9WUGpfFQD/2wEv47+FNyJhfABkEG2TQ4vKMc+
         ISoQNxvxAtCFNy0W+OrJ+0deXe48HbNKVpnYCdJ7ExtyPTbur0G1Jbzp5C92kh8OqYtm
         ksKqa8uhCiXljYR//eDX0Y5UeM8Iu3wUiVK4Jz/+tZfk++nv4cK4gFuQE0dX7Fh+g3mD
         uZvmJ4rHHHZogCyUiraugNLsPyvY16xJYz6NCBMiEdo4vZ+tZfKUTQ8ViP+mBeg668wB
         fg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YIgOk2vZYUEppuqaUX7d/zLpPOAJZJ2Q2hrbqGB8Xww=;
        b=w5VU4c+2GVh5XFv4dfdgXQcs7Tj29D5qMbbI8oCw3+fjSXoJCW0+l8RUF+86fKeLE3
         +F+U3aMjOJQlQ4azA29shi62fmeiMWgxiykMCeRogsnDbSsRyyGlSFuq9eOHjBm4CCmb
         XBE3J7nrd1oemH7Ri/k/QZiXJDi3pmCzEKOt3GAj1jwISynMk9HRrZpMTjNCnbiqiosA
         M1niRJSHETQa899E/qCdWphz164X7BmAB1t8L0gfqJH4+WyX11qxEHF8SD6+Kfbpv1R1
         LWdf5ZWV04zMW7ibYHYE60FcAakwPu2eT0uQgeGajRjqkQ1GvmQCC+6Z11eBovJ640mA
         rFPQ==
X-Gm-Message-State: AFqh2krMsyD3IJ6wr1ZAR9sKo1pYaK7myE/a6SxoPmK9IEc1ZZz01An7
        6CBCxHu6OO78zrXlmOZkQ4YpMrJT5TD8m7QsnXxk7Q==
X-Google-Smtp-Source: AMrXdXs1tg6BtCNjD4l/XSKxtuExUHllGzNESTqihwz7aJH4NbrzysLwBZYZ4UQ392n611o1b+kvnMIRIDw+GqPcMus=
X-Received: by 2002:a25:8f89:0:b0:7b3:bb8:9daf with SMTP id
 u9-20020a258f89000000b007b30bb89dafmr1083040ybl.427.1673276089915; Mon, 09
 Jan 2023 06:54:49 -0800 (PST)
MIME-Version: 1.0
References: <20230108025545.338-1-cuiyunhui@bytedance.com> <CANn89i+W__5-jDUdM=_97jzQy9Wq+n9KBEuOGjUi=Fxe_ntqbg@mail.gmail.com>
 <CAEEQ3wnoKqN+uTmMmUDJ9pp+YVaLmKnv42RApzPbNOGg6CRmnA@mail.gmail.com>
In-Reply-To: <CAEEQ3wnoKqN+uTmMmUDJ9pp+YVaLmKnv42RApzPbNOGg6CRmnA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Jan 2023 15:54:38 +0100
Message-ID: <CANn89iKY5gOC97NobXkhYv6d9ik=ks5ZEwVe=6H-VTwux=BwGQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v4] sock: add tracepoint for send recv length
To:     =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com,
        xiyou.wangcong@gmail.com, duanxiongchun@bytedance.com,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 9, 2023 at 2:13 PM =E8=BF=90=E8=BE=89=E5=B4=94 <cuiyunhui@byted=
ance.com> wrote:
>
> On Mon, Jan 9, 2023 at 5:56 PM Eric Dumazet <edumazet@google.com> wrote:
>
> >
> > Note: At least for CONFIG_RETPOLINE=3Dy and gcc 12.2, compiler adds man=
y
> > additional instructions (and additional memory reads),
> > even when the trace point is not enabled.
> >
> > Contrary to some belief, adding a tracepoint is not always 'free'.
> > tail calls for example are replaced with normal calls.
> >
>
>
> >         .popsection
> >
> > # 0 "" 2
> > #NO_APP
> > .L106:
> > # net/socket.c:1008: }
> >         movl    %ebx, %eax      # <retval>,
> >         popq    %rbx    #
> >         popq    %rbp    #
> >         popq    %r12    #
> >         ret
> > .L111:
> > # ./include/trace/events/sock.h:308: DEFINE_EVENT(sock_msg_length,
> > sock_recv_length,
> >
>
> Hi Eric,  Thanks for your reply,  In fact, it is because the
> definition of the tracepoint function is inline,
> Not just these two tracepoints=EF=BC=8Cright?
>
> #define __DECLARE_TRACE(name, proto, args, cond, data_proto)            \
>       ...
>       static inline void trace_##name(proto)
>
> Regarding the above issue, I plan to optimize it like this:
>
> static noinline void call_trace_sock_send_length(struct sock *sk, __u16 f=
amily,
>                                             __u16 protocol, int ret, int =
flags)
> {
>         trace_sock_send_length(sk, family, protocol, ret, 0);
> }
>
> static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *=
msg)
> {
>         int ret =3D INDIRECT_CALL_INET(sock->ops->sendmsg, inet6_sendmsg,
>                                      inet_sendmsg, sock, msg,
>                                      msg_data_left(msg));
>         BUG_ON(ret =3D=3D -EIOCBQUEUED);
>
>         if (trace_sock_send_length_enabled()) {

A barrier() is needed here, with the current state of affairs.

IMO, ftrace/x86 experts should take care of this generic issue ?



>                 call_trace_sock_send_length(sock->sk, sock->sk->sk_family=
,
>                                             sock->sk->sk_protocol, ret, 0=
);
>         }
>         return ret;
> }
>
> What do you think?
>
> Thanks,
> Yunhui
