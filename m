Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EEE665285
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 04:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjAKDxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 22:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjAKDxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 22:53:38 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F9BFD29
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:53:36 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id bk16so13791875wrb.11
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VQOEXukn20hgpPjJ+OLqtGzuCJHE3pnunV9JohjE5Tc=;
        b=XkN9DGFQRtzmQXS8sE2gm0e69v1OxxFkqEZ2dZbFKJxPhuYhDSk3Rzj4nxJqgDP/x4
         mFvqA32CcyapU+ZKOhga2o7c/v3i+vdOT2rY6ev2S2U96Fx9EqqxF29ijBvVgFt3rnjf
         LsJIakdCBeJoaAT2Gi9NmI3t1AeB7PgAeQMiX0GTSYYdMVhFEoPxyMsSx96i1uVW/Xgs
         thaM0wIFAvYZ0/aueVXBOnKrDtY5q91WQ0IowrBit1xnGTpjtbFhwRgjiF+Pu47W6uBL
         eQ/bne9H7fNYjqZByJizcovVpvPWC+QZydxhOxzOsMxsZdS80DrW755B3H5VBu4vJ1Tt
         M+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQOEXukn20hgpPjJ+OLqtGzuCJHE3pnunV9JohjE5Tc=;
        b=QxU6YmjMwf85tg6mKE+ii8jIkUf0nKuNvcVbgukz4KAN21YPVX11QYPwZ7dlBzJXSL
         yKWWqPDPJwx2ri/z57BIokUvA77IIbTsUKGHQmUQgWXTRKqK7VbSsnU1fZTXXwcQ+zFj
         WwB+rGr8Zr04VRNuApKIfWO4yPZMtc3MRdpV3rgoyaF7H7jSZAraNppqaGfOq/881Crq
         pim4Z5yrzl+4dDjHBJWDdZqEhFhlpdxBlrTF1V4j/TkrVFJa4k4YR6LFoDOQpixUmNYA
         hEk4/E39Mq+igA+qE17CbNRJ4jMc+Qkl1f3b2jwR3gZWhG05nNYTRXvpGSGegDOtB0Z1
         ACuw==
X-Gm-Message-State: AFqh2kp2gOuo5aK4h2x9s6ZbLPqKWHzqTqLdhDJMjwlPnpLgmkl8QKAs
        Jam93nxu6Gj2PqjhTxhvhHpW6mioFx3RkWTwTdakMA==
X-Google-Smtp-Source: AMrXdXtnOF6DYyWFuiXwm86I3OwtS9EwrrNE5SzwEC3i4dBVo641rdM1fvMb8XqwDiyWnTX/4nS9yOzzL5Ri7E1tpdc=
X-Received: by 2002:a5d:6207:0:b0:242:2748:be7a with SMTP id
 y7-20020a5d6207000000b002422748be7amr4436775wru.116.1673409215323; Tue, 10
 Jan 2023 19:53:35 -0800 (PST)
MIME-Version: 1.0
References: <20230110091356.1524-1-cuiyunhui@bytedance.com>
 <CANn89i+Wh2krOy4YFWvBsEx-s_JgQ0HixHAVJwGw18dVPeyiqw@mail.gmail.com> <20230110104419.67294691@gandalf.local.home>
In-Reply-To: <20230110104419.67294691@gandalf.local.home>
From:   =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>
Date:   Wed, 11 Jan 2023 11:53:24 +0800
Message-ID: <CAEEQ3w=aU3siD-ubhPB3+Wv10ARfUeR=cUHmvdEp2q+y105vAw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v5] sock: add tracepoint for send recv length
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Eric Dumazet <edumazet@google.com>, mhiramat@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        kuniyu@amazon.com, xiyou.wangcong@gmail.com,
        duanxiongchun@bytedance.com, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dust.li@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 11:44 PM Steven Rostedt <rostedt@goodmis.org> wrote=
:
>
>
>         TP_printk("sk address =3D %p, family =3D %s protocol =3D %s, leng=
th =3D %d, error =3D %d, flags =3D 0x%x",
>                   __entry->sk, show_family_name(__entry->family),
>                   show_inet_protocol_name(__entry->protocol),
>                   __entry->ret > 0 ? ret : 0, __entry->ret < 0 ? ret : 0,
>                   __entry->flags)
> );
>
> DEFINE_EVENT(sock_msg_length, sock_send_length,
>         TP_PROTO(struct sock *sk, int ret, int flags),
>
>         TP_ARGS(sk, ret, flags)
> );
>
> DEFINE_EVENT_PRINT(sock_msg_length, sock_recv_length,
>         TP_PROTO(struct sock *sk, int ret, int flags),
>
>         TP_ARGS(sk, ret, flags)
>
>         TP_printk("sk address =3D %p, family =3D %s protocol =3D %s, leng=
th =3D %d, error =3D %d, flags =3D 0x%x",
>                   __entry->sk, show_family_name(__entry->family),
>                   show_inet_protocol_name(__entry->protocol),
>                   !(__entry->flags & MSG_PEEK) ? __entry->ret : __entry->=
ret > 0 ? ret : 0,
>                   __entry->ret < 0 ? ret : 0,
>                   __entry->flags)
> );
> #endif /* _TRACE_SOCK_H */
>
> As DEFINE_EVENT_PRINT() uses the class template, but overrides the
> TP_printk() portion (still saving memory).
>

Hi Steve, Based on your suggestion, can we use the following code
instead of using DEFINE_EVENT_PRINT =EF=BC=9F

DECLARE_EVENT_CLASS(sock_msg_length,

        TP_PROTO(struct sock *sk, int ret, int flags),

        TP_ARGS(sk, ret, flags),

        TP_STRUCT__entry(
                __field(void *, sk)
                __field(__u16, family)
                __field(__u16, protocol)
                __field(int, ret)
                __field(int, flags)
        ),

        TP_fast_assign(
                __entry->sk =3D sk;
                __entry->family =3D sk->sk_family;
                __entry->protocol =3D sk->sk_protocol;
                __entry->ret =3D ret;
                __entry->flags =3D flags;
        ),

        TP_printk("sk address =3D %p, family =3D %s protocol =3D %s, length
=3D %d, error =3D %d, flags =3D 0x%x",
                  __entry->sk, show_family_name(__entry->family),
                  show_inet_protocol_name(__entry->protocol),
                  !(__entry->flags & MSG_PEEK) ?
                  (__entry->ret > 0 ? __entry->ret : 0) : 0,
                  __entry->ret < 0 ? __entry->ret : 0,
                  __entry->flags)
);

DEFINE_EVENT(sock_msg_length, sock_send_length,
        TP_PROTO(struct sock *sk, int ret, int flags),

        TP_ARGS(sk, ret, flags)
);

DEFINE_EVENT(sock_msg_length, sock_recv_length,
        TP_PROTO(struct sock *sk, int ret, int flags),

        TP_ARGS(sk, ret, flags)
);


> And then both calls can just do:
>
>         trace_sock_send_length(sk, ret, 0);
>
>         trace_sock_recv_length(sock->sk, ret, flags);
>
> And I bet that will also solve all the gcc being smart waste.
>
> -- Steve
>

Btw,  we still need noinline helpers, right?
Otherwise the following code would be inlined into sock_recvmsg:
mov    0x18(%r13),%rsi
mov    %gs:0x7e832d87(%rip),%eax        # 0x2e68c <pcpu_hot+12>
mov    %eax,%eax
bt     %rax,0xdca591(%rip)        # 0xffffffff825c5ea0 <__cpu_online_mask>


Thanks,
Yunhui
