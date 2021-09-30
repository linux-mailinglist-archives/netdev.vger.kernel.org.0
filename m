Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8327A41E376
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 23:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhI3Vpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 17:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhI3Vpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 17:45:55 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F4BC06176A;
        Thu, 30 Sep 2021 14:44:12 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id p1so7212442ilg.10;
        Thu, 30 Sep 2021 14:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=YPye3DWH3JNbK+JXOK9ZOft+nwdQshkXdSxUB8qf+pg=;
        b=VQyNrnS0LmFO36RfBdIkQsFyE3RZvAcUw+ecDw3mnzwMt5DTQZeguR8CSJPSOnreKS
         BbxQxSM6jj9iVfDbTQD2IaRob2UrZMkjxfPP6SSdOU7JbmFXYoslbm3IWlsyk/SA/NcD
         5kiP5HYjG0BEC6mJ0CyO1JcPpy720v9EDhSYrpHVKhFfODSKG8igROBJ0XSFgik2kKA6
         JZ9PeSl/xkjmv26YcpcqhxVSCi7734y4I+roX2u1iZwVvSsLGAeFsiO9LFmJbAobXBYK
         plFrRcb3aVROFgVwJ8RSl4ZRCmdUA9h/Y8lEd1iUuJl+WntVahF+XqibRv3MJYoEKmis
         TrRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=YPye3DWH3JNbK+JXOK9ZOft+nwdQshkXdSxUB8qf+pg=;
        b=4k6fpU+5usRMRpWa1rDdHCZqVRwEG2hB3Sm+U4amdrpWS8WHdik+jzmqxR/P5uFwSm
         ve3u6sL0ms2cXlPY9B3208CNNIyj9n/UfUNt7dYQz4bt237CfVrX5IdiRECGu+gMVkYC
         9s1O9Gwi3nGLDUuERNOHbVxCfTNOz4nEU3bYO3IA94DmVhNBnR+WGzhaHvG5BteEfbef
         ulvazIG/Fmg06o1HW3v2GKmMG27pGBMjd0osF01xe6AGZMwvhL8leO419ECgiZTnxbwC
         3NIToUwd+faOsVdH140EV7Y2ddvr+DGFK2rfJDuFzszsZoZr6akFsYyngrTCTziHnSro
         St7A==
X-Gm-Message-State: AOAM5303D+hUv6NzeRZ8Df4oK6E28PeYDT/eXaVgJX1w0CjV6bXuPmkJ
        3o13aX2NaFT4kzOY7s1Zi06gvjWsj6E=
X-Google-Smtp-Source: ABdhPJyspA/4Pll4BZ7Rciezr9XiS/W/a2CTI4M/+VnaWb6pLTyVMI44lyUy8zgo7T7GEDmb2gFJtw==
X-Received: by 2002:a05:6e02:1887:: with SMTP id o7mr5798820ilu.12.1633038251442;
        Thu, 30 Sep 2021 14:44:11 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id j17sm2446930ile.20.2021.09.30.14.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 14:44:10 -0700 (PDT)
Date:   Thu, 30 Sep 2021 14:44:00 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Yucong Sun <sunyucong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <61562fa0b3f74_6c4e4208c1@john-XPS-13-9370.notmuch>
In-Reply-To: <20210928002212.14498-4-xiyou.wangcong@gmail.com>
References: <20210928002212.14498-1-xiyou.wangcong@gmail.com>
 <20210928002212.14498-4-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf v2 3/4] net: implement ->sock_is_readable for UDP and
 AF_UNIX
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
> Yucong noticed we can't poll() sockets in sockmap even when
> they are the destination sockets of redirections. This is
> because we never poll any psock queues in ->poll(), except
> for TCP. Now we can overwrite >sock_is_readable() and
> implement and invoke it for UDP and AF_UNIX sockets.

nit: instead of 'because we never poll any psock queue...' how about
'because we do not poll the psock queues in ->poll(), except
for TCP.'
> 
> Reported-by: Yucong Sun <sunyucong@gmail.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

[...]
  
>  static inline void sk_msg_check_to_free(struct sk_msg *msg, u32 i, u32 bytes)
>  {
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 2d6249b28928..93ae48581ad2 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -474,6 +474,20 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
>  }
>  EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
>  
> +bool sk_msg_is_readable(struct sock *sk)
> +{
> +	struct sk_psock *psock;
> +	bool empty = true;
> +
> +	psock = sk_psock_get_checked(sk);

We shouldn't need the checked version here right? We only get here because
we hooked the sk with the callbacks from *_bpf_rebuild_rpotos. Then we
can just use sk_psock() and save a few extra insns/branch.

> +	if (IS_ERR_OR_NULL(psock))
> +		return false;
> +	empty = sk_psock_queue_empty(psock);
> +	sk_psock_put(sk, psock);
> +	return !empty;
> +}
> +EXPORT_SYMBOL_GPL(sk_msg_is_readable);

[...]
