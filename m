Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB3832011A
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 23:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhBSWBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 17:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhBSWB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 17:01:29 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C50DC061786
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 14:00:33 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id t15so10470298wrx.13
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 14:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=RBNlqRoSiJ1xlHuBA7FYF5J/Cpp57bs5HnF5tAm96Ik=;
        b=Aat0kMzB8javRMjqRvCXy9p//j6SlxwNxuQsGPSW1Zy+hfcEuPCRTBLKyOa0C8+mNJ
         4U+UeE197azmFZmGUxaO1oVTRjBgE3WEVkNMEXOwX7BOGvb5jw8msY/cVNc0CR5O5phy
         3a+HJgQQisdbDN49z4YRarQ6dxf7HNKv6u18E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=RBNlqRoSiJ1xlHuBA7FYF5J/Cpp57bs5HnF5tAm96Ik=;
        b=ivob6KpgshPJ2AyJkXlKNQRtngf/93FL4+OmYPEM5/Y/peFs2xQvBdzFdK9J3/SmOt
         0c4WDDa2QyWOopmjp84qAyhLiteAGYoaJi/sEKiQm+2vq0uYnx3yg9uKTIV4xfEhhZHP
         UVwEGtQsCMRwbn4vSpY3pUOLL0jqufsodVBEJsnmhw4rvLHUs6A7H6QGvxgr+AQEEMig
         mCm8Z6JxhFV3wUkyQKEaf1xNhvgL2ZXQcX+9Lp8LLdfdwkXtnpYAg2QkasWJC4jjqMnG
         Q9L0lzqWxNSD36OzbSngUKqN5W0fj7Lvo0wx8lYjqYf9FoNMRAtGuiS7ya4+3Li3IeFG
         DszA==
X-Gm-Message-State: AOAM531cBO9+R5AQ/mhRMtxuubkXzehoBzRGrHIJy6LLFdVTqWVvpxMl
        GBghmR2zCw/PZ6Zmh8DhoKsA7Q==
X-Google-Smtp-Source: ABdhPJxtg0peN7p7p19gQOeg+3PQbduWC3a4KiH4obAhZ+Dk3XO48RXRxkxYEZoLhyivVgYht3OORg==
X-Received: by 2002:adf:e80d:: with SMTP id o13mr11415701wrm.113.1613772031998;
        Fri, 19 Feb 2021 14:00:31 -0800 (PST)
Received: from cloudflare.com (83.24.165.208.ipv4.supernova.orange.pl. [83.24.165.208])
        by smtp.gmail.com with ESMTPSA id s14sm16326161wmj.23.2021.02.19.14.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 14:00:31 -0800 (PST)
References: <20210216064250.38331-1-xiyou.wangcong@gmail.com>
 <20210216064250.38331-2-xiyou.wangcong@gmail.com>
 <87im6n52zx.fsf@cloudflare.com>
 <CAM_iQpVou5Ea5APSzpcQU9oyb0n39Wmo1zTqJfMjWSt-NvGO5A@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [Patch bpf-next v4 1/5] bpf: clean up sockmap related Kconfigs
In-reply-to: <CAM_iQpVou5Ea5APSzpcQU9oyb0n39Wmo1zTqJfMjWSt-NvGO5A@mail.gmail.com>
Date:   Fri, 19 Feb 2021 23:00:30 +0100
Message-ID: <87h7m74t1d.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 07:46 PM CET, Cong Wang wrote:
> On Fri, Feb 19, 2021 at 10:25 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> On Tue, Feb 16, 2021 at 07:42 AM CET, Cong Wang wrote:
>> > From: Cong Wang <cong.wang@bytedance.com>
>> >
>> > As suggested by John, clean up sockmap related Kconfigs:
>> >
>> > Reduce the scope of CONFIG_BPF_STREAM_PARSER down to TCP stream
>> > parser, to reflect its name.
>> >
>> > Make the rest sockmap code simply depend on CONFIG_BPF_SYSCALL.
>> > And leave CONFIG_NET_SOCK_MSG untouched, as it is used by
>> > non-sockmap cases.
>> >
>> > Cc: Daniel Borkmann <daniel@iogearbox.net>
>> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
>> > Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
>> > Acked-by: John Fastabend <john.fastabend@gmail.com>
>> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>> > ---
>>
>> Sorry for the delay. There's a lot happening here. Took me a while to
>> dig through it.
>>
>> I have a couple of nit-picks, which easily can be addressed as
>> follow-ups, and one comment.
>
> No problem, it is not merged, so V5 is definitely not a problem.
>
>>
>> sock_map_prog_update and sk_psock_done_strp are only used in
>> net/core/sock_map.c and can be static.
>
> 1. This seems to be unrelated to this patch? But I am still happy to
> address it.

Completely unrelated. Just a nit-pick. Feel free to ignore.

> 2. sk_psock_done_strp() is in skmsg.c, hence why it is non-static.
> And I believe it fits in skmsg.c better than in sock_map.c, because
> it operates on psock rather than sock_map itself.

I wrote that sk_psock_done_strp is used only in net/core/sock_map.c,
while I should have written that it's used only in net/core/skmsg.c.

Sorry, a mistake when copying from my notes. Also, feel free to ignore.

> So, I can make sock_map_prog_update() static in a separate patch
> and carry it in V5.

Completely up to you. I don't insist.

>>
>> [...]
>>
>> > diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
>> > index bc7d2a586e18..b2c4865eb39b 100644
>> > --- a/net/ipv4/tcp_bpf.c
>> > +++ b/net/ipv4/tcp_bpf.c
>> > @@ -229,7 +229,6 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
>> >  }
>> >  EXPORT_SYMBOL_GPL(tcp_bpf_sendmsg_redir);
>> >
>> > -#ifdef CONFIG_BPF_STREAM_PARSER
>> >  static bool tcp_bpf_stream_read(const struct sock *sk)
>> >  {
>> >       struct sk_psock *psock;
>> > @@ -561,8 +560,10 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
>> >                                  struct proto *base)
>> >  {
>> >       prot[TCP_BPF_BASE]                      = *base;
>> > +#if defined(CONFIG_BPF_SYSCALL)
>> >       prot[TCP_BPF_BASE].unhash               = sock_map_unhash;
>> >       prot[TCP_BPF_BASE].close                = sock_map_close;
>> > +#endif
>> >       prot[TCP_BPF_BASE].recvmsg              = tcp_bpf_recvmsg;
>> >       prot[TCP_BPF_BASE].stream_memory_read   = tcp_bpf_stream_read;
>> >
>> > @@ -629,4 +630,3 @@ void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
>> >       if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
>> >               newsk->sk_prot = sk->sk_prot_creator;
>> >  }
>> > -#endif /* CONFIG_BPF_STREAM_PARSER */
>>
>> net/core/sock_map.o now is built only when CONFIG_BPF_SYSCALL is set.
>> While tcp_bpf_get_proto is only called from net/core/sock_map.o.
>>
>> Seems there is no sense in compiling tcp_bpf_get_proto, and everything
>> it depends on which was enclosed by CONFIG_BPF_STREAM_PARSER check, when
>> CONFIG_BPF_SYSCALL is unset.
>
> I can try but I am definitely not sure whether kTLS is happy about
> it, clearly kTLS at least uses __tcp_bpf_recvmsg() and
> tcp_bpf_sendmsg_redir().

I think kTLS will be fine because that's the situation today.

__tcp_bpf_recvmsg and tcp_bpf_sendmsg_redir need to be left out,
naturally, is it is now.

(Although I think they could event be stubbed out. But that would be
unrelated to this change.)

After all how would we end up on code path in kTLS that utilizes sockmap
API, if sockmap can't be created when CONFIG_BPF_SYSCALL is unset.

>
>>
>> > diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
>> > index 7a94791efc1a..e635ccc175ca 100644
>> > --- a/net/ipv4/udp_bpf.c
>> > +++ b/net/ipv4/udp_bpf.c
>> > @@ -18,8 +18,10 @@ static struct proto udp_bpf_prots[UDP_BPF_NUM_PROTS];
>> >  static void udp_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
>> >  {
>> >       *prot        = *base;
>> > +#if defined(CONFIG_BPF_SYSCALL)
>> >       prot->unhash = sock_map_unhash;
>> >       prot->close  = sock_map_close;
>> > +#endif
>> >  }
>> >
>> >  static void udp_bpf_check_v6_needs_rebuild(struct proto *ops)
>>
>> Same situation here but for udp_bpf_get_proto.
>
> UDP is different, as kTLS certainly doesn't and won't use it. I think
> udp_bpf.c can be just put under CONFIG_BPF_SYSCALL.
>
> Thanks.
