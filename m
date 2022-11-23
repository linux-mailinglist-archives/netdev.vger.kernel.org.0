Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBA8634E2F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 04:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbiKWDDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 22:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbiKWDDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 22:03:12 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEE515A18;
        Tue, 22 Nov 2022 19:02:55 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so705355pjb.0;
        Tue, 22 Nov 2022 19:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=24WunCmiRAIHsa1eYZgoUGPlmQj4xZgQ++rzPlnyZi8=;
        b=ZHocrwD2he/2VTFZlzVfaSknBzrZPFc2mHTDITo519gpQz9xqsxzOWic2Vn1GqLCI+
         nIY0cZQXI0ZsmOzU9mRZPxDEo1/7hnCGGEOKY0SjK1qi5U9SnzZ1sTRpbTWeYf7FKSoA
         xw0u7lKlmyrkJPcI5BeX8sLn3524waMlIGMjfvUSEVzVccWCiziN18U1U/gGCGIVrpOz
         qyLr+0ZQLkjF/BhpbtG4zTa+RBhqDo+CacAQfFmXUsccRFu41IrMNbPpWIuO4UjpZOk3
         UJ4em53WsCbCrnJBLjx37+Bi9c9snE9jlzI2uXSRhhv0IcarU3V8yO4o1pFhmnIG7DUp
         hXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=24WunCmiRAIHsa1eYZgoUGPlmQj4xZgQ++rzPlnyZi8=;
        b=f+K8Q+1WRzp4RNqQx85BeV25h50ZWs5bmy+dt8lDZyHY12YdelW+osWJrmA5GvdarB
         z5jGpXccrWA8it1FGdm4tvv4uEbaKnkzsHk6D5DKj7o6+y4ZzsQ/tmYwexnFo4lNQFEM
         mtGTcNBXP5XVxqNEhc0WyFfdZmGbYVxRel52YZgxhNsgHyzEBPplvN0IpflIKSxno9wL
         JNj1iqGe5DjITPmibGt8cub+WhHnsh1nGRDJt1l2rEyBUqgs8/NALLVYBhsddoWCFj4p
         qJHejQ9HSMfR9b1HQBtawBJMt3iCS80KNXDk9v+orH8PNWC4goWlxcb1fpk6UKQjfCAj
         DYBg==
X-Gm-Message-State: ANoB5pkpTjVwc1bl+c17DMgTF3E7xl/uMS1tzQ4rZoW/sg/qIdOdkqZr
        h1ot2/hWF/u747GsaF7mPyBSrKH0hhM=
X-Google-Smtp-Source: AA0mqf6IwWzndjnrlPkiujh6dKKIE25cfDKE07nO/G975cK3nMhBwg30irzupX23q+g3xiDy4io4yQ==
X-Received: by 2002:a17:903:1206:b0:188:cd12:c2e1 with SMTP id l6-20020a170903120600b00188cd12c2e1mr9401069plh.171.1669172575142;
        Tue, 22 Nov 2022 19:02:55 -0800 (PST)
Received: from localhost ([129.95.226.125])
        by smtp.gmail.com with ESMTPSA id d12-20020a170902654c00b00168dadc7354sm8215682pln.78.2022.11.22.19.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 19:02:54 -0800 (PST)
Date:   Tue, 22 Nov 2022 19:02:51 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Pengcheng Yang <yangpc@wangsu.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Message-ID: <637d8d5bd4e27_2b649208eb@john.notmuch>
In-Reply-To: <1669082309-2546-3-git-send-email-yangpc@wangsu.com>
References: <1669082309-2546-1-git-send-email-yangpc@wangsu.com>
 <1669082309-2546-3-git-send-email-yangpc@wangsu.com>
Subject: RE: [PATCH RESEND bpf 2/4] bpf, sockmap: Fix missing BPF_F_INGRESS
 flag when using apply_bytes
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pengcheng Yang wrote:
> When redirecting, we use sk_msg_to_ingress() to get the BPF_F_INGRESS
> flag from the msg->flags. If apply_bytes is used and it is larger than
> the current data being processed, sk_psock_msg_verdict() will not be
> called when sendmsg() is called again. At this time, the msg->flags is 0,
> and we lost the BPF_F_INGRESS flag.
> 
> So we need to save the BPF_F_INGRESS flag in sk_psock and assign it to
> msg->flags before redirection.
> 
> Fixes: 8934ce2fd081 ("bpf: sockmap redirect ingress support")
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---
>  include/linux/skmsg.h | 1 +
>  net/core/skmsg.c      | 1 +
>  net/ipv4/tcp_bpf.c    | 1 +
>  net/tls/tls_sw.c      | 1 +
>  4 files changed, 4 insertions(+)
> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 48f4b64..e1d463f 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -82,6 +82,7 @@ struct sk_psock {
>  	u32				apply_bytes;
>  	u32				cork_bytes;
>  	u32				eval;
> +	u32				flags;
>  	struct sk_msg			*cork;
>  	struct sk_psock_progs		progs;
>  #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 188f855..ab2f8f3 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -888,6 +888,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
>  		if (psock->sk_redir)
>  			sock_put(psock->sk_redir);
>  		psock->sk_redir = msg->sk_redir;
> +		psock->flags = msg->flags;
>  		if (!psock->sk_redir) {
>  			ret = __SK_DROP;
>  			goto out;
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index ef5de4f..1390d72 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -323,6 +323,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>  		break;
>  	case __SK_REDIRECT:
>  		sk_redir = psock->sk_redir;
> +		msg->flags = psock->flags;
>  		sk_msg_apply_bytes(psock, tosend);
>  		if (!psock->apply_bytes) {
>  			/* Clean up before releasing the sock lock. */
                 ^^^^^^^^^^^^^^^
In this block reposted here with the rest of the block


		if (!psock->apply_bytes) {
			/* Clean up before releasing the sock lock. */
			eval = psock->eval;
			psock->eval = __SK_NONE;
			psock->sk_redir = NULL;
		}

Now that we have a psock->flags we should clera that as
well right?
