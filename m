Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7571E4F2CF
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 02:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFVAgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 20:36:23 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41308 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfFVAgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 20:36:23 -0400
Received: by mail-qt1-f194.google.com with SMTP id d17so8732279qtj.8
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 17:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G9/ATlAOi7wqajXWBhDa0PjiOzOi0RX5Iz70nHz/Tos=;
        b=HtB9bkzn+fjKBy7UdkrTPIfpMoEP+j8/WlLJw9JouPvIlDJSH72D4yt0N6A37950TP
         pRGVEAPVRx8FRO0MMrqLuIvWRjabMYsMGvccuKkxaI+H5mNz01iCaLeKxC9VYjDUCknD
         Ggocwjx9mSdnDnHO+NFnDUqkXDQsiHlssQAYiE7uyaf1Y+qxaH5uJI94fjLd/oLl/ioT
         eLL3kWCgMkeBgDZSPPNOEThSGEApwBt4NvZ86wvFtZIemH+8A7mhtPHXfjJzOR4b/nQy
         /NDXAKiiRkK/yWFUcNihuJP+Bb7hUNfVJace673bSH1q2fiVia8VaSyC2LVVmKEAxqk2
         wnkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G9/ATlAOi7wqajXWBhDa0PjiOzOi0RX5Iz70nHz/Tos=;
        b=HUrnxAJhAyLRDVgOCCakofqbDTYVdoZW1JId5Wmi60qKMmyCibfiM33+frjKXeSTIn
         PbW5YydfjcViK/s9nK0l6Suf2oRnLCMi1eKoI8uUspHKboNqDiw+1baTULcWN7krq1ed
         TqjxnVv0x9/JXX/vnFnsZiR+5zCLNZgIFGlkNAZDlDBcp7Qp5zUJNm8T5CIrzVuSU0xO
         6hBd0MoZqIWKi8J/+QAIQcwOoZ5ojgm+S333Dj6PxwSdaLcNHta8xjEbZxfRokrwAD9g
         RrcEsS86ujBEmW67t5vDyAERzNTReBxeLOw4v4Sx/GSqtSOQrsS3mZTsdF0Fa0p9Z5f7
         LEnw==
X-Gm-Message-State: APjAAAV77+WzBh0Moy8nMU84F5+s6H2cFvRv0C+hR3XkFItwx2jgaa5V
        dw8gCslDsMr+YvGfvDhDpPM=
X-Google-Smtp-Source: APXvYqwGPJcMAcMfBrSyyJQjG+4S8jY7z2rYZljP2i5OMxsiml0LhsBitJRrtvf/DUpL380c8F789w==
X-Received: by 2002:ac8:2ca5:: with SMTP id 34mr122788017qtw.246.1561163782749;
        Fri, 21 Jun 2019 17:36:22 -0700 (PDT)
Received: from ?IPv6:2607:fb90:ed9:1901:68e8:19b9:cff3:84b8? ([2607:fb90:ed9:1901:68e8:19b9:cff3:84b8])
        by smtp.gmail.com with ESMTPSA id 47sm3117873qtw.90.2019.06.21.17.36.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:36:21 -0700 (PDT)
Subject: Re: Removing skb_orphan() from ip_rcv_core()
To:     Joe Stringer <joe@wand.net.nz>, Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <71d6c88b-9a4a-cb5b-9e49-41972b78427d@gmail.com>
Date:   Fri, 21 Jun 2019 20:36:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/21/19 10:58 AM, Joe Stringer wrote:
> Hi folks, picking this up again..
> 
> As discussed during LSFMM, I've been looking at adding something like
> an `skb_sk_assign()` helper to BPF so that logic similar to TPROXY can
> be implemented with integration into other BPF logic, however
> currently any attempts to do so are blocked by the skb_orphan() call
> in ip_rcv_core() (which will effectively ignore any socket assign
> decision made by the TC BPF program).
> 
> Recently I was attempting to remove the skb_orphan() call, and I've
> been trying different things but there seems to be some context I'm
> missing. Here's the core of the patch:
> 
> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index ed97724c5e33..16aea980318a 100644
> --- a/net/ipv4/ip_input.c
> +++ b/net/ipv4/ip_input.c
> @@ -500,8 +500,6 @@ static struct sk_buff *ip_rcv_core(struct sk_buff
> *skb, struct net *net)
>        memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
>        IPCB(skb)->iif = skb->skb_iif;
> 
> -       /* Must drop socket now because of tproxy. */
> -       skb_orphan(skb);
> 
>        return skb;
> 
> The statement that the socket must be dropped because of tproxy
> doesn't make sense to me, because the PRE_ROUTING hook is hit after
> this, which will call into the tproxy logic and eventually
> nf_tproxy_assign_sock() which already does the skb_orphan() itself.
> 
> However, if I drop these lines then I end up causing sockets to
> release references too many times. Seems like if we don't orphan the
> skb here, then later logic assumes that we have one more reference
> than we actually have, and decrements the count when it shouldn't
> (perhaps the skb_steal_sock() call in __inet_lookup_skb() which seems
> to assume we always have a reference to the socket?)
> 
> Splat:
> 
> refcount_t hit zero at sk_stop_timer+0x2c/0x30 in cilium-agent[16359],
> uid/euid: 0/0
> WARNING: CPU: 0 PID: 16359 at kernel/panic.c:686 refcount_error_report+0x9c/0xa1
> ...
> ? inet_put_port+0xa6/0xd0
> inet_csk_clear_xmit_timers+0x2e/0x50
> tcp_done+0x8b/0xf0
> tcp_reset+0x49/0xc0
> tcp_validate_incoming+0x2f7/0x410
> tcp_rcv_state_process+0x250/0xdb6
> ? tcp_v4_connect+0x46f/0x4e0
> tcp_v4_do_rcv+0xbd/0x1f0
> __release_sock+0x84/0xd0
> release_sock+0x30/0xa0
> inet_stream_connect+0x47/0x60
> 
> (Full version: https://gist.github.com/joestringer/d5313e4bf4231e2c46405bd7a3053936
> )
> 
> This seems potentially related to some of the socket referencing
> discussion in the peer thread "[RFC bpf-next 0/7] Programming socket
> lookup with BPF".
> 
> During LSFMM, it seemed like no-one knew quite why the skb_orphan() is
> necessary in that path in the current version of the code, and that we
> may be able to remove it. Florian, I know you weren't in the room for
> that discussion, so raising it again now with a stack trace, Do you
> have some sense what's going on here and whether there's a path
> towards removing it from this path or allowing the skb->sk to be
> retained during ip_rcv() in some conditions?
> 

I guess you might missed part of the LSFMM discussion :

We need to make sure skb_orphan() is called from any virtual
driver ndo_start_xmit() that re-injects packet back to the stack.

loopback driver has it, but probably some driver lacks it.
