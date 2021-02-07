Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB60331267F
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 18:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBGRu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 12:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBGRuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 12:50:25 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569A4C061756
        for <netdev@vger.kernel.org>; Sun,  7 Feb 2021 09:49:45 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id d7so9787827otq.6
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 09:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kjF32x+g63Mhbkv+V5xB1MnzYdIbawp2tYWaemr5LkM=;
        b=WFEp5x4q+0sXS7gFfs14ExT0SFo9H1X65E1OoNACPF6Kqi87HxY0D/1zCG1jpe6qQ8
         1TRHrOoHhHSv1PKHUyiPDv5vytQZLskL9DlnTU+pXtHAGOrMKttXcqgt/KZ9WoE39Z/L
         ikVLzxoXsac/Secxzr+VCNOK870kiQfO0/+lImSX0H2G15deUA7aZODS2RLo9FHXElBg
         mvDUZ/Y/GuItRPDeP6FvMY25+oaiPAKVIicWf5qhI2O0XYBYIVPBHD7NuKGRqMrKu8UX
         ti4vT3bVtXIlpu/hQAnix06hl7n4ptAmU5tV24y2JGVEy8FQQACIsN47+oiusGIaIi+M
         hWPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kjF32x+g63Mhbkv+V5xB1MnzYdIbawp2tYWaemr5LkM=;
        b=iTRy939jCktt3iPa5LDuNfddc6Ed3u7oe2we5AFWyZCanrmyn6nOmSWfDnNTne2sJO
         5Xxdh2vcmyc28WhoT/JWRQDcoslkuI8MpcJ5PRghBvWrOSknhWbYOGKqNpjR3Tt+RAt+
         eVqF44Ts3ncznT6FMJd3yiMlg59SVObUTop7fQBn8xmfR7xGXLD1YIFc9kOnVaFdr08I
         Qs6LmoPFygezeP9Js1S/9/0Aa9/sEr+LZn9g9J7+/ZWUwL3zcsnA0NH2TKgY+5sWvChA
         rTEO4M/hYICITr/oohylu+RuHfbqNnre6hN1sLpDqvwqzAR3wOz7knJYz03ZPkcB3jpt
         BJXQ==
X-Gm-Message-State: AOAM5316EoKgGYS3uyQmwP+JB0N330Cb0m35MedQtyIOck+O+UbVynOC
        WejZGF+/pcEx8d0O2CzZ+yQ=
X-Google-Smtp-Source: ABdhPJzTbZEL8JoVD7ZzlPbgc5H2uDRTplsnwWHKeojePM8OoLFZ4hp0FMWp6Lcx3WTDl4QBvsQrRQ==
X-Received: by 2002:a9d:6290:: with SMTP id x16mr10294196otk.109.1612720184586;
        Sun, 07 Feb 2021 09:49:44 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id t3sm165792otb.36.2021.02.07.09.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Feb 2021 09:49:43 -0800 (PST)
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
To:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c81f79ee-e8d0-2f83-6926-c370e9540730@gmail.com>
Date:   Sun, 7 Feb 2021 10:49:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/6/21 1:36 PM, Arjun Roy wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> Explicitly define reserved field and require it to be 0-valued.
> 
> Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Suggested-by: David Ahern <dsahern@gmail.com>
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/uapi/linux/tcp.h | 2 +-
>  net/ipv4/tcp.c           | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> index 42fc5a640df4..8fc09e8638b3 100644
> --- a/include/uapi/linux/tcp.h
> +++ b/include/uapi/linux/tcp.h
> @@ -357,6 +357,6 @@ struct tcp_zerocopy_receive {
>  	__u64 msg_control; /* ancillary data */
>  	__u64 msg_controllen;
>  	__u32 msg_flags;
> -	/* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
> +	__u32 reserved; /* set to 0 for now */
>  };
>  #endif /* _UAPI_LINUX_TCP_H */
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e1a17c6b473c..c8469c579ed8 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4159,6 +4159,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
>  		}
>  		if (copy_from_user(&zc, optval, len))
>  			return -EFAULT;
> +		if (zc.reserved)
> +			return -EINVAL;
>  		lock_sock(sk);
>  		err = tcp_zerocopy_receive(sk, &zc, &tss);
>  		release_sock(sk);
> 


The 'switch (len)' statement needs to be updated now that 'len' is not
going to end on the 'msg_flags' boundary? But then, how did that work
before if there was 4 byte padding?

Maybe I am missing something here. You currently have:

	switch (len) {
	case offsetofend(struct tcp_zerocopy_receive, msg_flags):

which should == 60, yet the struct size is 64 with 4-bytes of padding. A
user doing

	int optlen = sizeof(struct tcp_zerocopy_receive);

	getsockopt(...., &optlen)

would pass in a value of 64, right?
