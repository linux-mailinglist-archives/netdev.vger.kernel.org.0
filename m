Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AED4158FF
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 09:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbhIWH22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 03:28:28 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:36252
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237853AbhIWH21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 03:28:27 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E4A0A402CF
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 07:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632382014;
        bh=BpYqFmvbKqI+/NfJqDUHrHumN6faQ7YSYJO5rWC5vl8=;
        h=To:Cc:References:From:Subject:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=JLA85T/Sili9wPVSXEyh+eOx3qUFsAAlNJJY/lzJ5BwlnIkvSOMde5oQ4aJmUaQM5
         qcVdUvF7aFDfEoSNibiI7O5opdVAxLvE8jhXTNs4Zt7pchCzZlrmqBGj2OOUkwBvAL
         lcZLOdLOgV8sKDz07FofbLTXbr3CvUTVNVjh1cr8HRc7ogsTmR3ZJjgnYUFvwMefi9
         Xx8QVw4l1j9CRI1puVB0vsdWe7c79pJImGOSE4vB1eYRExzikJb0EAJ47CKiQI2y3W
         YB8BaljPYa3YMKh0KJC7It5JrKAe1Yhaam7Il6lVfQ7MXYw1uT3wrdyxdrNFU+uXJJ
         2/SaCdDZ20x+w==
Received: by mail-ed1-f70.google.com with SMTP id m30-20020a50999e000000b003cdd7680c8cso5880504edb.11
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 00:26:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BpYqFmvbKqI+/NfJqDUHrHumN6faQ7YSYJO5rWC5vl8=;
        b=kML3jdY9L2WFvkQAWkUKRU0fkgysIcdHIwJg2MafjfePj9IxJg7pD1ZxuEEQh19GON
         B4X1j2iwJydsdzFxZLqqHElnCeX5TmKxglHezH2G86d+cc4jNUpVQaW8BtOnpMzJUHCf
         DMZuAkbnv6n2SvBK3pEb+H6LVhhoZ9auJR4Hc9Ej+qYfhtmisdJyoXIGnydQOC6stgHh
         zK5ZjySvljRzG+tiZJ/4/g98HVFeJuXgDZh9WiduKkVl6Ji9ciVbf6abQOqBv560H6/5
         SOfemnLMWWPneAJbcBzaTFLo/ghCSrc6kXqHf31YB4UD21WN7oZbtYBb8yO1vKeNPQC7
         OAfg==
X-Gm-Message-State: AOAM533pqDolCe4A4VLBUiL9P5Uq86by3wj0iiW0BtPNLXI+hOAnVmHz
        hQACllDZTjzx+ND1rnnlAlOIJQEU0f9Evoq/13sWVlX/8Y0OvZGm55psdjl5tYF9B9x4U3BlUQg
        hBNiWVLBfoR+6UICSONzDyPtqvj88uA5WSw==
X-Received: by 2002:aa7:d7d5:: with SMTP id e21mr3906250eds.27.1632382013933;
        Thu, 23 Sep 2021 00:26:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxDwRjKrSA++cC1IQS3ul4nadXAHfLTPlUI4SQF66GujOefM3Z3K42W8P/6Lzto9Vc1VvnMg==
X-Received: by 2002:aa7:d7d5:: with SMTP id e21mr3906217eds.27.1632382013674;
        Thu, 23 Sep 2021 00:26:53 -0700 (PDT)
Received: from [192.168.0.134] (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id mm23sm2482065ejb.78.2021.09.23.00.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 00:26:52 -0700 (PDT)
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20210923065051.GA25122@kili>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: Re: [PATCH net] nfc: avoid potential race condition
Message-ID: <3760c70c-299c-89bf-5a4a-22e8d564ef92@canonical.com>
Date:   Thu, 23 Sep 2021 09:26:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210923065051.GA25122@kili>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/09/2021 08:50, Dan Carpenter wrote:
> This from static analysis inspired by CVE-2021-26708 where there was a
> race condition because it didn't lock_sock(sk) before saving
> "vsk->transport".  Here it is saving "llcp_sock->local" but the concept
> is the same that it needs to take the lock first.

I think the difference between this llcp_sock code and above transport,
is lack of writer to llcp_sock->local with whom you could race.

Commits c0cfa2d8a788fcf4 and 6a2c0962105ae8ce causing the
multi-transport race show nicely assigns to vsk->transport when module
is unloaded.

Here however there is no writer to llcp_sock->local, except bind and
connect and their error paths. The readers which you modify here, have
to happen after bind/connect. You cannot have getsockopt() or release()
before bind/connect, can you? Unless you mean here the bind error path,
where someone calls getsockopt() in the middle of bind()? Is it even
possible?

The code except this looks reasonable and since writer protects
llcp_sock->local(), the reader I guess should do it as well... just
wondering whether this is a real issue.


Best regards,
Krzysztof

> 
> Fixes: 00e856db49bb ("NFC: llcp: Fall back to local values when getting socket options")
> Fixes: d646960f7986 ("NFC: Initial LLCP support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/nfc/llcp_sock.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
> index 6cfd30fc0798..74f4209c7144 100644
> --- a/net/nfc/llcp_sock.c
> +++ b/net/nfc/llcp_sock.c
> @@ -314,14 +314,16 @@ static int nfc_llcp_getsockopt(struct socket *sock, int level, int optname,
>  	if (get_user(len, optlen))
>  		return -EFAULT;
>  
> -	local = llcp_sock->local;
> -	if (!local)
> -		return -ENODEV;
> -
>  	len = min_t(u32, len, sizeof(u32));
>  
>  	lock_sock(sk);
>  
> +	local = llcp_sock->local;
> +	if (!local) {
> +		release_sock(sk);
> +		return -ENODEV;
> +	}
> +
>  	switch (optname) {
>  	case NFC_LLCP_RW:
>  		rw = llcp_sock->rw > LLCP_MAX_RW ? local->rw : llcp_sock->rw;
> @@ -598,14 +600,15 @@ static int llcp_sock_release(struct socket *sock)
>  
>  	pr_debug("%p\n", sk);
>  
> +	lock_sock(sk);
> +
>  	local = llcp_sock->local;
>  	if (local == NULL) {
> +		release_sock(sk);
>  		err = -ENODEV;
>  		goto out;
>  	}
>  
> -	lock_sock(sk);
> -
>  	/* Send a DISC */
>  	if (sk->sk_state == LLCP_CONNECTED)
>  		nfc_llcp_send_disconnect(llcp_sock);
> 

