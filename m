Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A3141E3D1
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 00:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245343AbhI3W1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 18:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhI3W1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 18:27:17 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11ABEC06176A;
        Thu, 30 Sep 2021 15:25:34 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id d18so9465890iof.13;
        Thu, 30 Sep 2021 15:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wNlZAUvu5LSkmnCojiJMGrKpmMsNUg/akAoK4Rv1QCI=;
        b=mG4RZroJ8/DpWbnHhMXSr4qasjPOLCXIykHKKuLOCqyw89Q/DlxO4XTbkIbBHcznuR
         BbT2eHS3F9ZAVafBggfpIJ1cIL+dtf4a+FgHWpFRiIUsGrI2OSDgR914yMYutxBQP4mC
         BqT7j0s5a4gmoWUtSQzoDLOCmgmK20lBOcYwOtC5x+lqbpbtjtD6tF/kPs8HwttEIhtP
         +euVedBdkK6cydH27ALR2OUM9qRXAuCSV17Ueft2pYUh5tzSois1z22vMIxenrVh1frA
         SGrdYrKRZs4QDN8z1AmR8tZ+bOMZjph/YSgMKOjPSmdPYMua1sG2/BE48sYHreDclakY
         DFsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wNlZAUvu5LSkmnCojiJMGrKpmMsNUg/akAoK4Rv1QCI=;
        b=PlPjFaSabrr6U3vQTQZeIpeueE1a25CmUsNYNYdearSWShkqSjRJHOIawmwq3xuLha
         SmrbxDHRJEJhBl054TkHRwgM09sV1n6xfDSA+yWelZ0ahT4lNdWJmyrPjtXgsI4MPhxr
         T+P2o3FXbZ+XtGtgPICrqKDNwzODeRtNZgz2YxWgVe3PZjprJC1Qnj1pTDBjJK1qx5eG
         IOkEjwHqKca74o6Onejmcarsa5Px2Cq5TRVp8c6+11WwBwXdi0IXoksDysDs+Skd7189
         J7GYz98vfF4WvrnAeE5qW8bLblNgCxFLBjRTh7+ZYBH8pD0j+qEDRbx5FWPryst1lnrH
         mScw==
X-Gm-Message-State: AOAM5302pdGsqiTTnB7miyrJws3oXznoyotq589MzOI+R7NPPVJUi9Nd
        1zLa5CPYK8vTpYycxGv8xuk=
X-Google-Smtp-Source: ABdhPJw/6IW/ODkg9gM02PR4GLORs6otPNe20g74HukioVf8njEpt613iQvj1ZbN2WuIbWHxrP+wIg==
X-Received: by 2002:a5d:8557:: with SMTP id b23mr5545283ios.192.1633040733384;
        Thu, 30 Sep 2021 15:25:33 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id o2sm2112927ioo.46.2021.09.30.15.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 15:25:32 -0700 (PDT)
Date:   Thu, 30 Sep 2021 15:25:23 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     liujian56@huawei.com
Message-ID: <61563953e731f_6c4e420814@john-XPS-13-9370.notmuch>
In-Reply-To: <20210929084529.96583-1-liujian56@huawei.com>
References: <20210929084529.96583-1-liujian56@huawei.com>
Subject: RE: [PATCH] tcp_bpf: Fix one concurrency problem in the
 tcp_bpf_send_verdict function
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liu Jian wrote:
> In the following cases:
> We need to redirect the first msg to sock1 and the second msg to sock2.
> The sock lock needs to be released at __SK_REDIRECT and to get another
> sock lock, this will cause the probability that psock->eval is not set to
> __SK_NONE when the second msg comes.
> 
> If psock does not set apple bytes, fix this by do the cleanup before
> releasing the sock lock. And keep the original logic in other cases.

It took me sometime to figure out the above description. Please include
a bit more details here this needs to be backported so we want to be
very clear what the error  is and how to trigger it.

In this case we should list the flow to show how the interleaving of
msgs breaks.

"
With two Msgs, msgA and msgB and a user doing nonblocking sendmsg calls
(or multiple cores) on a single socket 'sk' we could get the following
flow.

 msgA, sk                               msgB, sk
 -----------                            ---------------
 tcp_bpf_sendmsg()
 lock(sk)
 psock = sk->psock
                                        tcp_bpf_sendmsg()
                                        lock(sk) ... blocking
 tcp_bpf_send_verdict
 if (psock->eval == NONE)
   psock->eval = sk_psock_msg_verdict
 ..
 < handle SK_REDIRECT case >
   release_sock(sk)                     < lock dropped so grab here >
   ret = tcp_bpf_sendmsg_redir
                                        psock = sk->psock
                                        tcp_bpf_send_verdict
 lock_sock(sk) ... blocking on B
                                        if (psock->eval == NONE) <- boom.
                                         psock->eval will have msgA state

The problem here is we dropped the lock on msgA and grabbed it with msgB.
Now we have old state in psock and importantly psock->eval has not
been cleared. So msgB will run whatever action was done on A and the
verdict program may never see it.
"

Showing the flow makes it painfully obvious why dropping that lock
with old state is broken.


> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>

We need a fixes tag as well so we can backport this.

> ---
>  net/ipv4/tcp_bpf.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index d3e9386b493e..02442e43ac4d 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -232,6 +232,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>  	bool cork = false, enospc = sk_msg_full(msg);
>  	struct sock *sk_redir;
>  	u32 tosend, delta = 0;
> +	u32 eval = __SK_NONE;
>  	int ret;
>  
>  more_data:
> @@ -274,6 +275,12 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>  		break;
>  	case __SK_REDIRECT:
>  		sk_redir = psock->sk_redir;
> +		if (!psock->apply_bytes) {
> +			/* Clean up before releasing the sock lock. */
> +			eval = psock->eval;
> +			psock->eval = __SK_NONE;
> +			psock->sk_redir = NULL;
> +		}

We need to move above chunk below sk_msg_apply_bytes() so we account for
the bytes and if we zero apply bytes with this send we clear the psock
state. Otherwise we could have the same issue with stale state on the
boundary where apply bytes is met.

>  		sk_msg_apply_bytes(psock, tosend);

<-- put above chunk here.

>  		if (psock->cork) {
>  			cork = true;

Interestingly, I caught the race with cork state, but missed it with
the eval case. Likely because our program redirected to a single sk.

> @@ -281,7 +288,12 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>  		}
>  		sk_msg_return(sk, msg, tosend);
>  		release_sock(sk);
> +
>  		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
> +
> +		if (eval == __SK_REDIRECT)

Is the 'if' needed? we are in this case because eval is SK_REDIRECT.

> +			sock_put(sk_redir);
> +
>  		lock_sock(sk);
>  		if (unlikely(ret < 0)) {
>  			int free = sk_msg_free_nocharge(sk, msg);
> -- 
> 2.17.1
> 
