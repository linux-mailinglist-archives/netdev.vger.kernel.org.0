Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524C43B94A1
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 18:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhGAQ0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 12:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhGAQ0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 12:26:09 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6EDC061762;
        Thu,  1 Jul 2021 09:23:38 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id g5so4636108iox.11;
        Thu, 01 Jul 2021 09:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=0JeKB22sEFVH2OHfyjjswISFP46Q0b13zeqLEZJolsg=;
        b=vX3FwSZdCH3V7dWrRtZD/fvYvleRoOQ9fx5LgJs6FJUYkCUJInZr7dOdAYicTWdiMb
         WmvZ3JbgjgZs8gaPECULDds3rnZ0j/pVLYXB4CfYgEW+OVauq1Z83GDuRryDcNWW1RcF
         fl3wlTYY0A9nMkBAlmR4FjCygX0k0DHJXc7rs3rrBQWldfLu+ACuDJ4xgSOsER1USWiD
         FJU1zqlS3CQ3DBPqIpd1uVZvrgk8poDewaUzhQOqAK0B8srPVhbrLf/qep6JXj0Cnlob
         FgpjVoNVAjbCNxPRQBEOI4xtgjNICrPZRHm09h6KKCb8SYG92Uv/lICh6q+GcVY5WifJ
         Le2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=0JeKB22sEFVH2OHfyjjswISFP46Q0b13zeqLEZJolsg=;
        b=h6+3AtqF+C9xYlL6n4w38DI2i/J45nxwlr5dHCLp3gnNkFFw4BZusJILKNKdSwuXiH
         D1ZosSdLq0DstV9ijz6KWOk6QFQOfLsYBNnoamSjyWFmx6bXelMgGDIkqjDeGKDEhUWF
         eD+r8OG4ib1EtaYn79FWZJOdXBOzTcI2+fPE6nct60zeZF7rdPR3k98dImPFiygkZT7O
         DkE8k4NPa8wcv1cULtL9yAaLZpD392KUYmaUiLIIeyMdb6GKv/SCTBGYc5CZtRxXHlsh
         JIdYdwpHcNS1OQA6NIvYAawbiSZbBw05TJ2fQlWTXQdX5XMYocC3MVtaCk449HJbdF6Y
         C43A==
X-Gm-Message-State: AOAM531a/jXQkRzCh/Vng+wpJTHbj7eF7dYfAVMCQecaz47QjvXlw30v
        /qDGyOsk1cEJV75iAPqW7Sw=
X-Google-Smtp-Source: ABdhPJzUEe8WwvD5QeuHmNBIf2Z1Hmc46D/yRs2EvF1g+hW6cOOsxu4beCgyGRRlxaKuKnFz7MilZQ==
X-Received: by 2002:a6b:6205:: with SMTP id f5mr213241iog.60.1625156618173;
        Thu, 01 Jul 2021 09:23:38 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id e14sm240290ilq.32.2021.07.01.09.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 09:23:37 -0700 (PDT)
Date:   Thu, 01 Jul 2021 09:23:29 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <60ddec01c651b_3fe24208dc@john-XPS-13-9370.notmuch>
In-Reply-To: <20210701061656.34150-1-xiyou.wangcong@gmail.com>
References: <20210701061656.34150-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf v2] skmsg: check sk_rcvbuf limit before queuing to
 ingress_skb
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
> Jiang observed OOM frequently when testing our AF_UNIX/UDP
> proxy. This is due to the fact that we do not actually limit
> the socket memory before queueing skb to ingress_skb. We
> charge the skb memory later when handling the psock backlog,
> but it is not limited either.

Right, its not limiting but charging it should push back on
the stack so it stops feeding skbs to us. Maybe this doesn't
happen in UDP side?

> 
> This patch adds checks for sk->sk_rcvbuf right before queuing
> to ingress_skb and drops packets if this limit exceeds. This
> is very similar to UDP receive path. Ideally we should set the
> skb owner before this check too, but it is hard to make TCP
> happy about sk_forward_alloc.

But it breaks TCP side see below.

> 
> Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/core/skmsg.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 9b6160a191f8..a5185c781332 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -854,7 +854,8 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
>  		return -EIO;
>  	}
>  	spin_lock_bh(&psock_other->ingress_lock);
> -	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
> +	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED) ||
> +	    atomic_read(&sk_other->sk_rmem_alloc) > READ_ONCE(sk_other->sk_rcvbuf)) {
>  		spin_unlock_bh(&psock_other->ingress_lock);
>  		skb_bpf_redirect_clear(skb);
>  		sock_drop(from->sk, skb);
> @@ -930,7 +931,8 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
>  		}
>  		if (err < 0) {
>  			spin_lock_bh(&psock->ingress_lock);
> -			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
> +			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED) &&
> +			    atomic_read(&sk_other->sk_rmem_alloc) <= READ_ONCE(sk_other->sk_rcvbuf)) {
>  				skb_queue_tail(&psock->ingress_skb, skb);

We can't just drop the packet in the memory overrun case here. This will
break TCP because the data will be gone and no one will retransmit.

Thats why in the current scheme on redirect we can push back when we
move it to the other queues ingress message queue or redirect into
the other socket via send.

At one point I considered charging the data sitting in the ingress_skb?
Would that solve the problem here? I think it would cause the enqueue
at the UDP to start dropping packets from __udp_enqueue_schedule_skb()?

>  				schedule_work(&psock->work);
>  				err = 0;
> -- 
> 2.27.0
> 
