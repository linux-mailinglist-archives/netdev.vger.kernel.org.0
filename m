Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8729F6C4238
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 06:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjCVFjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 01:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjCVFjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 01:39:12 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505E81DB89;
        Tue, 21 Mar 2023 22:39:08 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c18so18291705ple.11;
        Tue, 21 Mar 2023 22:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679463548;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGDQCU4nQYKKNY62Vvqu7+hRTgYni7jWemf009ocRk8=;
        b=fE8mUKwUT47eXSyD0em1R4+b7rTwoUuOq/LxxTWYHn+smXNfBgTPVnJKEFDf8WQeOZ
         4qTOLnlb4YwJjeM5v/FoDvv+SfhnKXFPR8dMAqk2WdpWI3hN/YnGPcPVI9d0ElRTEGSU
         9pCduaJnOG4+j3dDTO3rbo1DakqVOuozJf6QROzJlWFh5gLbd1fyGCazhQ+yroibgjtO
         ekZK3t8qSFcIAlNx6yoSiiccRWZwQ4m3F9D6DyWSP8YdTANk2ZIiWB7mVmDGfGTwlotr
         KorHrhKhLoq2xO8lG0PxzelOGyqrwj15iohviM+GM8iU0Tso6JBK7LBAlHswyntAlwMY
         Qn1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679463548;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nGDQCU4nQYKKNY62Vvqu7+hRTgYni7jWemf009ocRk8=;
        b=K7+jDxqnJ6tLxlJ4lITey3qBViQFIOI+5kHNl6L5yYRjlzAJAKYj0FEmODAd/JpRPw
         QknK3t/A90aLFkwepDvbkQLqYd3ACjj4ILDtAJc+jki24+/pCbMu6k8M4ogJyiffCSQ5
         yV3d6YB1VivaZ0y5wNroG3IFPdbwkpkHeOay+3lYa9w6e+G6vjoTLRJhhAjulH5eULKv
         TBlAjCjZV/FtpoKg2kuwEGWXUx90F8DOdaJ2H/ZzErHSEx98Xfj/q2ORYGSbbZdkyaZ8
         rIaXrDipGOEz9eSSplTIBCaXDWlG1blH7+IEpRFZnJD8WHadXatuX3VFxc5zrHU5UYka
         yi5A==
X-Gm-Message-State: AO0yUKV+EFSJPZWetvE7+jq0QTakdz0tKH5UOj9gQqCTazkrDyQ1/QiS
        EQVhqE5xBcmTwzqj4T8+oXc=
X-Google-Smtp-Source: AK7set+f1BWjWmocAKPzaL3zJno5gvOfTZXvtjc3kPnYjKvvST+BBkP5d4Vfr3fsxZGfMA+Oe7LnAw==
X-Received: by 2002:a17:902:ecc9:b0:19e:5965:8694 with SMTP id a9-20020a170902ecc900b0019e59658694mr1944592plh.60.1679463547593;
        Tue, 21 Mar 2023 22:39:07 -0700 (PDT)
Received: from localhost ([98.97.36.54])
        by smtp.gmail.com with ESMTPSA id c1-20020a170902724100b001a198adb190sm9682996pll.88.2023.03.21.22.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 22:39:07 -0700 (PDT)
Date:   Tue, 21 Mar 2023 22:39:05 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        cong.wang@bytedance.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Message-ID: <641a9479e96ed_875ab208f8@john.notmuch>
In-Reply-To: <CANn89i+gbRZYzjSFR2N_xpBaFaB+0ShOgQo1EXBk-R7k1_t_8Q@mail.gmail.com>
References: <20230321215212.525630-1-john.fastabend@gmail.com>
 <20230321215212.525630-8-john.fastabend@gmail.com>
 <CANn89i+gbRZYzjSFR2N_xpBaFaB+0ShOgQo1EXBk-R7k1_t_8Q@mail.gmail.com>
Subject: Re: [PATCH bpf 07/11] bpf: sockmap incorrectly handling copied_seq
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet wrote:
> On Tue, Mar 21, 2023 at 2:52=E2=80=AFPM John Fastabend <john.fastabend@=
gmail.com> wrote:
> >
> > The read_skb() logic is incrementing the tcp->copied_seq which is use=
d for
> > among other things calculating how many outstanding bytes can be read=
 by
> > the application. This results in application errors, if the applicati=
on
> > does an ioctl(FIONREAD) we return zero because this is calculated fro=
m
> > the copied_seq value.
> >
> > To fix this we move tcp->copied_seq accounting into the recv handler =
so
> > that we update these when the recvmsg() hook is called and data is in=

> > fact copied into user buffers. This gives an accurate FIONREAD value
> > as expected and improves ACK handling. Before we were calling the
> > tcp_rcv_space_adjust() which would update 'number of bytes copied to
> > user in last RTT' which is wrong for programs returning SK_PASS. The
> > bytes are only copied to the user when recvmsg is handled.
> >
> > Doing the fix for recvmsg is straightforward, but fixing redirect and=

> > SK_DROP pkts is a bit tricker. Build a tcp_psock_eat() helper and the=
n
> > call this from skmsg handlers. This fixes another issue where a broke=
n
> > socket with a BPF program doing a resubmit could hang the receiver. T=
his
> > happened because although read_skb() consumed the skb through sock_dr=
op()
> > it did not update the copied_seq. Now if a single reccv socket is
> > redirecting to many sockets (for example for lb) the receiver sk will=
 be
> > hung even though we might expect it to continue. The hang comes from
> > not updating the copied_seq numbers and memory pressure resulting fro=
m
> > that.
> >
> > We have a slight layer problem of calling tcp_eat_skb even if its not=

> > a TCP socket. To fix we could refactor and create per type receiver
> > handlers. I decided this is more work than we want in the fix and we
> > already have some small tweaks depending on caller that use the
> > helper skb_bpf_strparser(). So we extend that a bit and always set
> > the strparser bit when it is in use and then we can gate the
> > seq_copied updates on this.
> >
> > Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  include/net/tcp.h  |  3 +++
> >  net/core/skmsg.c   |  7 +++++--
> >  net/ipv4/tcp.c     | 10 +---------
> >  net/ipv4/tcp_bpf.c | 28 +++++++++++++++++++++++++++-
> >  4 files changed, 36 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index db9f828e9d1e..674044b8bdaf 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -1467,6 +1467,8 @@ static inline void tcp_adjust_rcv_ssthresh(stru=
ct sock *sk)
> >  }
> >
> >  void tcp_cleanup_rbuf(struct sock *sk, int copied);
> > +void __tcp_cleanup_rbuf(struct sock *sk, int copied);
> > +
> >
> >  /* We provision sk_rcvbuf around 200% of sk_rcvlowat.
> >   * If 87.5 % (7/8) of the space has been consumed, we want to overri=
de
> > @@ -2321,6 +2323,7 @@ struct sk_psock;
> >  struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *ps=
ock);
> >  int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bo=
ol restore);
> >  void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
> > +void tcp_eat_skb(struct sock *sk, struct sk_buff *skb);
> >  #endif /* CONFIG_BPF_SYSCALL */
> >
> >  int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c

[...]

> >  EXPORT_SYMBOL(tcp_read_skb);
> > diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> > index b1ba58be0c5a..c0e5680dccc0 100644
> > --- a/net/ipv4/tcp_bpf.c
> > +++ b/net/ipv4/tcp_bpf.c
> > @@ -11,6 +11,24 @@
> >  #include <net/inet_common.h>
> >  #include <net/tls.h>
> >
> > +void tcp_eat_skb(struct sock *sk, struct sk_buff *skb)
> > +{
> > +       struct tcp_sock *tcp;
> > +       int copied;
> > +
> > +       if (!skb || !skb->len || !sk_is_tcp(sk))
> > +               return;
> > +
> > +       if (skb_bpf_strparser(skb))
> > +               return;
> > +
> > +       tcp =3D tcp_sk(sk);
> > +       copied =3D tcp->copied_seq + skb->len;
> > +       WRITE_ONCE(tcp->copied_seq, skb->len);
>
> It seems your tests are unable to catch this bug :/

Its because the tests are returning SK_PASS and this logic
is never called. I'll add a test that checks FIONREAD and
does SK_DROP.

Thanks.=
