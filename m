Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A006DF1EC
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 12:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjDLK2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 06:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjDLK2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 06:28:13 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C22910EF
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 03:28:12 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id xi5so27534198ejb.13
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 03:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1681295291;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=rj9fvcibMW48MaloVAPMPFjLFvW3M+fUPLz4gOoA3Ik=;
        b=ee+lQfruVja98WkllDE+Uw4cGzCpW/8AsOBtsPDfeNh8ekKqBXplLBtZW4Kwb4PW2m
         DdzXPx28rDHyEroyeDSSHv0Ndxr7/Dt4D7Hzrh1opeIODm73hc/0ANboiAjmIqHo4nKE
         ugrF9GvBXASJD1AlBbgifMkzLwu7lOuxPtqH8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681295291;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rj9fvcibMW48MaloVAPMPFjLFvW3M+fUPLz4gOoA3Ik=;
        b=Loa3whYjqqXAMNPfjum6Dzhol9zWSluqd4DBfJPow8T2rwTcj+OIDlb49mu7FpiqyX
         i2CTitYztDbNjDEOA4NgbqcVahQaUNGb8mgEncCyT6dPS0PC2Jp/dBliFQ9qW1VguD0Y
         6N/8h67n9yPo6eCKIDBq7na7tT+USh95MZkeUOTx8lZA3sAHF09Ggvb+Ebmp8Snk1Mjx
         0xScMYE1LDIhgJvJ4KrhIcsJ2Iyv8NkivdWPMRIAOSGXOKhWW4Nt4QGswdpspuOqGJy0
         3j+qNgXUMglthnwBlLDx85SZSh6Ye2LF/iYaDpcrjm/6LKO8rvScPwSNV2zS2imbjElH
         hifA==
X-Gm-Message-State: AAQBX9fFAoCW6jfT8wEm0Y2wN2BPNmJGeEt8WbLR/YowqUjZCWtLktS7
        60yaRXpQJ0ttuyhgkzTPn37h9A==
X-Google-Smtp-Source: AKy350b/KwvBgywfJF1XiTTRvbAnBijFvZlR3HJKqcKy/p11ynNkG51ywF0PTInFnPbePV18GFZerg==
X-Received: by 2002:a17:906:4c48:b0:94a:86dc:3a13 with SMTP id d8-20020a1709064c4800b0094a86dc3a13mr10499450ejw.75.1681295290916;
        Wed, 12 Apr 2023 03:28:10 -0700 (PDT)
Received: from cloudflare.com (79.191.181.173.ipv4.supernova.orange.pl. [79.191.181.173])
        by smtp.gmail.com with ESMTPSA id s7-20020a170906a18700b00929fc8d264dsm7197146ejy.17.2023.04.12.03.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 03:28:10 -0700 (PDT)
References: <20230407171654.107311-1-john.fastabend@gmail.com>
 <20230407171654.107311-6-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v6 05/12] bpf: sockmap, TCP data stall on recv
 before accept
Date:   Wed, 12 Apr 2023 12:26:04 +0200
In-reply-to: <20230407171654.107311-6-john.fastabend@gmail.com>
Message-ID: <87h6tlgzt3.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 10:16 AM -07, John Fastabend wrote:
> A common mechanism to put a TCP socket into the sockmap is to hook the
> BPF_SOCK_OPS_{ACTIVE_PASSIVE}_ESTABLISHED_CB event with a BPF program
> that can map the socket info to the correct BPF verdict parser. When
> the user adds the socket to the map the psock is created and the new
> ops are assigned to ensure the verdict program will 'see' the sk_buffs
> as they arrive.
>
> Part of this process hooks the sk_data_ready op with a BPF specific
> handler to wake up the BPF verdict program when data is ready to read.
> The logic is simple enough (posted here for easy reading)
>
>  static void sk_psock_verdict_data_ready(struct sock *sk)
>  {
> 	struct socket *sock = sk->sk_socket;
>
> 	if (unlikely(!sock || !sock->ops || !sock->ops->read_skb))
> 		return;
> 	sock->ops->read_skb(sk, sk_psock_verdict_recv);
>  }
>
> The oversight here is sk->sk_socket is not assigned until the application
> accepts() the new socket. However, its entirely ok for the peer application
> to do a connect() followed immediately by sends. The socket on the receiver
> is sitting on the backlog queue of the listening socket until its accepted
> and the data is queued up. If the peer never accepts the socket or is slow
> it will eventually hit data limits and rate limit the session. But,
> important for BPF sockmap hooks when this data is received TCP stack does
> the sk_data_ready() call but the read_skb() for this data is never called
> because sk_socket is missing. The data sits on the sk_receive_queue.
>
> Then once the socket is accepted if we never receive more data from the
> peer there will be no further sk_data_ready calls and all the data
> is still on the sk_receive_queue(). Then user calls recvmsg after accept()
> and for TCP sockets in sockmap we use the tcp_bpf_recvmsg_parser() handler.
> The handler checks for data in the sk_msg ingress queue expecting that
> the BPF program has already run from the sk_data_ready hook and enqueued
> the data as needed. So we are stuck.
>
> To fix do an unlikely check in recvmsg handler for data on the
> sk_receive_queue and if it exists wake up data_ready. We have the sock
> locked in both read_skb and recvmsg so should avoid having multiple
> runners.
>
> Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/ipv4/tcp_bpf.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 804bd0c247d0..ae6c7130551c 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -212,6 +212,26 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
>  		return tcp_recvmsg(sk, msg, len, flags, addr_len);
>  
>  	lock_sock(sk);
> +
> +	/* We may have received data on the sk_receive_queue pre-accept and
> +	 * then we can not use read_skb in this context because we haven't
> +	 * assigned a sk_socket yet so have no link to the ops. The work-around
> +	 * is to check the sk_receive_queue and in these cases read skbs off
> +	 * queue again. The read_skb hook is not running at this point because
> +	 * of lock_sock so we avoid having multiple runners in read_skb.
> +	 */
> +	if (unlikely(!skb_queue_empty(&sk->sk_receive_queue))) {
> +		tcp_data_ready(sk);
> +		/* This handles the ENOMEM errors if we both receive data
> +		 * pre accept and are already under memory pressure. At least
> +		 * let user no to retry.

Nit: s/no/know/

> +		 */
> +		if (unlikely(!skb_queue_empty(&sk->sk_receive_queue))) {
> +			copied = -EAGAIN;
> +			goto out;
> +		}
> +	}
> +
>  msg_bytes_ready:
>  	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
>  	/* The typical case for EFAULT is the socket was gracefully

Similar to patch 04/12, we will need this corner case fix in
tcp_bpf_recvmsg as well.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
