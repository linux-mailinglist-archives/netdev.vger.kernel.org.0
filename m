Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6200E22CB8D
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 18:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgGXQ5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 12:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgGXQ5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 12:57:35 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA72DC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 09:57:35 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x8so4779209plm.10
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 09:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WeY5BPHL/E7lEbn1yCY49qTN31+LXQiDTN+4S0/viW0=;
        b=CP7YZ3wUtjG4JC1jfyeSlwqvDGIajd9a1ff80gFpxjHa/YUiLX2af1iPWP2fOwH9XS
         GhumY4CB5Mz6oyT1dgkccoEK8FLNe8awBtrKJ/ZlgivTWzNbeegi8S9QU5LbcpPa0r3n
         vKaM1GFeb1aSo13i5LaUxuZ+5u+GY+VaGrlztqm/xi58kzl9+aX3A91AXPJWbAK8goXh
         s6STmrkEeQOQu/nPukbKv+1n+KGfGSyLTzppIyS+//QUPr0F28VMvWrIsFsLQRXEzBqx
         xtckN6rWPsUWNeJTGHWAWFy8jw8LuL8AiK07ixYQh1nH+3+l1a4Y0BVI69vHBwexh4wx
         rEJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WeY5BPHL/E7lEbn1yCY49qTN31+LXQiDTN+4S0/viW0=;
        b=jUtFCtFy/y2u/G6xXgNWsKOKRoksVGM5zn9QN3DkADXCZJC3+gKA8+fy+Ag3w247y+
         o3475p15eymG38Lc97FbtS80Crv7+o1FhlzyoYVkBZEdEo0Qu9Um88T8x8jIyQh6iC/m
         pecupAi/k8xGPWowRkKL4ZOmgyt78jHKwRWtaQPSfIxohWPF0mC1eVV540SbAPG2sgZd
         cP3v2sVLHlWaw34PySt+kRrV/s0sbjOy4dUrmzCiZOsqyU3Geldn7mASYS2PDINF3bU9
         XC5/ZipJULoTzvfPzC+tM9j/17/eeKtWns2IfHCWcfiNRU9DauT5Cd+IeiCGMX/8mFqd
         2W5w==
X-Gm-Message-State: AOAM5305rMzHN9DaSfF7U2nlSmXngGBV33o8oPtJAXWRbNLZy73/Ejg3
        tvgpy1KguBGi1o8DUMIx3y4=
X-Google-Smtp-Source: ABdhPJwy4QN7xq3Gb/yNI5zTpcdRe0gdOXVT6wsBCTVzi5ODhXDq9HtYsK+KOedB9EN2Ufw7T4nDFQ==
X-Received: by 2002:a17:90a:ce0c:: with SMTP id f12mr6566899pju.19.1595609855490;
        Fri, 24 Jul 2020 09:57:35 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u66sm6804502pfb.191.2020.07.24.09.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 09:57:34 -0700 (PDT)
Subject: Re: [Patch net v2] qrtr: orphan socket in qrtr_release()
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20200724164551.24109-1-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4b799848-8e77-ec4a-1a79-aa08c0f856c7@gmail.com>
Date:   Fri, 24 Jul 2020 09:57:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200724164551.24109-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/24/20 9:45 AM, Cong Wang wrote:
> We have to detach sock from socket in qrtr_release(),
> otherwise skb->sk may still reference to this socket
> when the skb is released in tun->queue, particularly
> sk->sk_wq still points to &sock->wq, which leads to
> a UAF.
> 
> Reported-and-tested-by: syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com
> Fixes: 28fb4e59a47d ("net: qrtr: Expose tunneling endpoint to user space")
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/qrtr/qrtr.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
> index 24a8c3c6da0d..300a104b9a0f 100644
> --- a/net/qrtr/qrtr.c
> +++ b/net/qrtr/qrtr.c
> @@ -1180,6 +1180,7 @@ static int qrtr_release(struct socket *sock)
>  		sk->sk_state_change(sk);
>  
>  	sock_set_flag(sk, SOCK_DEAD);
> +	sock_orphan(sk);
>  	sock->sk = NULL;
>  
>  	if (!sock_flag(sk, SOCK_ZAPPED))
> 

Reviewed-by: Eric Dumazet <edumazet@google.com>
