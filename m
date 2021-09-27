Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07635419DD3
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 20:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbhI0SJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 14:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235400AbhI0SJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 14:09:04 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D94C061575;
        Mon, 27 Sep 2021 11:07:26 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id r75so23969710iod.7;
        Mon, 27 Sep 2021 11:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=h6SHm8gHcr6SSJmnr+K29w9BZfctVHXwgDqyHTdU1G0=;
        b=CFHf1tidvD3sGi1w6kzkFBoO9B0jlebXM3+DNpvz1+znBNTzc+/Vhgx4+7xB46o1ZO
         oxlw0x2XC92tqI1mGCMEz+K+4Koy9niuwoT3nsyZgtXlaOaDAT9/q/jPYlaEd1r2acfl
         cSmi6zgjM0y9RJt16uhUvbPUkjgwbsiGvQaK2iOfmoxcsNv5Zg3x8wokxMaS6sSNDJGs
         Dng2SQb0EW+2UgPDnwtwl2pGPMJXYiPi9pCet2iQV8z9ARL9ck6i/yozUTZczMjEx1v8
         9k8VfqT65MGu84cdxqaOyrHBVgjYkOji5y/IyYzad1bopfDdo3zu4NiOjyK8CR07NYBR
         PK6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=h6SHm8gHcr6SSJmnr+K29w9BZfctVHXwgDqyHTdU1G0=;
        b=q0Z8qRlWHqfQA/iuu9xsOASIAx8GUctcDgiOetuEm3UI9fDx7g9pS5zde1EKf8LE/1
         x2OjqHISP41ZoBJQpbWUZ3nivTx1AP1kzPMAkHMnsGAifM0q+AGe0EL/iN9rycu13rLC
         jJXag7jd7XmKoBQbPlBZqlxKr/XrFqTA7gQwF+4xMOJ33iVuVFstdQ/raN77X4TQnGYW
         Ifc5zRMiWBRbq//p+lzfljuvbcTDkdoRmVFd+tlG3bUQHXeN+27BpZubdTiwExTs+5BV
         eFVaTjUvOZpTF/9zt8dcT6D1FqI96vDLLtlb2QxvQLpvOYi/67GxhPVgn1bmyuOTD7TX
         e61g==
X-Gm-Message-State: AOAM531VdDsK5ePEllQsH6FcUGF6Jl0fSz1ll4U18Vg5YmbR3hkaK6hB
        I/rCMvy10biLieF9GHlOxyAk9TLcdd4=
X-Google-Smtp-Source: ABdhPJy6BiYKjlhT0ifHCcTQgeLQLKNukU1uhBIN07Nw5kdNhrwyv6SebyBmgbJw7Yx/SDc1ZYKxNQ==
X-Received: by 2002:a02:6666:: with SMTP id l38mr1058327jaf.146.1632766046288;
        Mon, 27 Sep 2021 11:07:26 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id s18sm9331856iov.53.2021.09.27.11.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 11:07:25 -0700 (PDT)
Date:   Mon, 27 Sep 2021 11:07:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Yucong Sun <sunyucong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6152085486e84_397f208e8@john-XPS-13-9370.notmuch>
In-Reply-To: <20210924220507.24543-3-xiyou.wangcong@gmail.com>
References: <20210924220507.24543-1-xiyou.wangcong@gmail.com>
 <20210924220507.24543-3-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf 2/3] net: poll psock queues too for sockmap sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Yucong noticed we can't poll() sockets in sockmap even
> when they are the destination sockets of redirections.
> This is because we never poll any psock queues in ->poll().
> We can not overwrite ->poll() as it is in struct proto_ops,
> not in struct proto.
> 
> So introduce sk_msg_poll() to poll psock ingress_msg queue
> and let sockets which support sockmap invoke it directly.
> 
> Reported-by: Yucong Sun <sunyucong@gmail.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/linux/skmsg.h |  6 ++++++
>  net/core/skmsg.c      | 15 +++++++++++++++
>  net/ipv4/tcp.c        |  2 ++
>  net/ipv4/udp.c        |  2 ++
>  net/unix/af_unix.c    |  5 +++++
>  5 files changed, 30 insertions(+)
> 

[...]
  						  struct sk_buff *skb)
>  {
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e8b48df73c85..2eb1a87ba056 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -280,6 +280,7 @@
>  #include <linux/uaccess.h>
>  #include <asm/ioctls.h>
>  #include <net/busy_poll.h>
> +#include <linux/skmsg.h>
>  
>  /* Track pending CMSGs. */
>  enum {
> @@ -563,6 +564,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
>  
>  		if (tcp_stream_is_readable(sk, target))
>  			mask |= EPOLLIN | EPOLLRDNORM;
> +		mask |= sk_msg_poll(sk);
>  
>  		if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
>  			if (__sk_stream_is_writeable(sk, 1)) {


For TCP we implement the stream_memory_read() hook which we implement in
tcp_bpf.c with tcp_bpf_stream_read. This just checks psock->ingress_msg
list which should cover any redirect from skmsg into the ingress side
of another socket.

And the tcp_poll logic is using tcp_stream_is_readable() which is 
checking for sk->sk_prot->stream_memory_read() and then calling it.

The straight receive path, e.g. not redirected from a sender should
be covered by the normal tcp_epollin_ready() checks because this
would be after TCP does the normal updates to rcv_nxt, copied_seq,
etc.

So above is not in the TCP case by my reading. Did I miss a
case? We also have done tests with Envoy which I thought were polling
so I'll check on that as well.

Thanks,
John
