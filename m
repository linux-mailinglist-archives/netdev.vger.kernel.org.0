Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF10E1B8F32
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 13:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgDZLBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 07:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726119AbgDZLBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 07:01:34 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7A5C061A0C
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 04:01:32 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id y24so17019176wma.4
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 04:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=RrhmdO0DLNjfBMDoqT4uy73PlihIJnZjBGcOAEACVLQ=;
        b=SOJ0e9h/vfQZL3fIsHaTnpWUyWcPJ8BtfMjph1KCE0tRbZP2i7AlCnU653nkIXiOPP
         aa5Dx1YA180Z/TBpL3G0M3ywHrcwihnMg6zk5p6RMuMq+8uQaz9BGSOfEI5kbP5NYQw4
         MOxZmXM9onjxNbW9ZgymV65EkkoAwY3XJh0t8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=RrhmdO0DLNjfBMDoqT4uy73PlihIJnZjBGcOAEACVLQ=;
        b=POzw4+gFU2ylJmsfD3UTauxBAjoHlVFesYKpSnW0AKakqzKXmmzXxXBHkzSQ3OjRxZ
         umqBCyBWco9rBCxKDRcvntG9/YsI9eylsMjwUGGj7WC/NYRoKRhUVH933gPmMqN5GMZg
         MFM58kBrp3UZCsQTs8JTBci90fcLq5plgC4UPb2IPWaaxLk5hxDtj6H+fnUQyC1r0y6x
         YinewGpcMzEwOPehuCIpjmnGMD9Lun2tKh9pAZZHY24LmnrkZdvq1VRd82Kw3o71ADBn
         wYKiAwpmlp1cWGIDhbm77hxyGen5cTxUnF4XYbv+b/F50Y9OfAHo3tI38M4Lbidpnbmw
         X7Ww==
X-Gm-Message-State: AGi0PuZM0FsTFaHfSD2707RmegUnRj1g8S60mbw95K2Oz5AuzYKfWeRo
        3HIBJG/a2UMb49/vKABNFk+5bg==
X-Google-Smtp-Source: APiQypKNGHSJziLKlpT3nTU2sPDDe98lUcVdHC0Mf29p4r46R6e+U+gqONTPjIa3F/qs3ED7pv8Upw==
X-Received: by 2002:a7b:c3d4:: with SMTP id t20mr21410207wmj.170.1587898891012;
        Sun, 26 Apr 2020 04:01:31 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id v7sm10002236wmg.3.2020.04.26.04.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 04:01:30 -0700 (PDT)
References: <1587872115-42805-1-git-send-email-xiyuyang19@fudan.edu.cn>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Lingpeng Chen <forrest0579@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH v2] bpf: Fix sk_psock refcnt leak when receiving message
In-reply-to: <1587872115-42805-1-git-send-email-xiyuyang19@fudan.edu.cn>
Date:   Sun, 26 Apr 2020 13:01:29 +0200
Message-ID: <87k122v7cm.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 05:35 AM CEST, Xiyu Yang wrote:
> tcp_bpf_recvmsg() invokes sk_psock_get(), which returns a reference of
> the specified sk_psock object to "psock" with increased refcnt.
>
> When tcp_bpf_recvmsg() returns, local variable "psock" becomes invalid,
> so the refcount should be decreased to keep refcount balanced.
>
> The reference counting issue happens in several exception handling paths
> of tcp_bpf_recvmsg(). When those error scenarios occur such as "flags"
> includes MSG_ERRQUEUE, the function forgets to decrease the refcnt
> increased by sk_psock_get(), causing a refcnt leak.
>
> Fix this issue by calling sk_psock_put() or pulling up the error queue
> read handling when those error scenarios occur.
>
> Fixes: e7a5f1f1cd000 ("bpf/sockmap: Read psock ingress_msg before sk_receive_queue")
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
> Changes in v2:
> - Add Fixes tag
> - Pull up the error queue read handling
> ---
>  net/ipv4/tcp_bpf.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 5a05327f97c1..ff96466ea6da 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -262,14 +262,17 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  	struct sk_psock *psock;
>  	int copied, ret;
>  
> +	if (unlikely(flags & MSG_ERRQUEUE))
> +		return inet_recv_error(sk, msg, len, addr_len);
> +
>  	psock = sk_psock_get(sk);
>  	if (unlikely(!psock))
>  		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
> -	if (unlikely(flags & MSG_ERRQUEUE))
> -		return inet_recv_error(sk, msg, len, addr_len);
>  	if (!skb_queue_empty(&sk->sk_receive_queue) &&
> -	    sk_psock_queue_empty(psock))
> +	    sk_psock_queue_empty(psock)) {
> +		sk_psock_put(sk, psock);
>  		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
> +	}
>  	lock_sock(sk);
>  msg_bytes_ready:
>  	copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
