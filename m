Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE24115764
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 19:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfLFSr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 13:47:58 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39492 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfLFSr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 13:47:58 -0500
Received: by mail-pj1-f68.google.com with SMTP id v93so3101405pjb.6
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 10:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c4JvAfJlkT3WqL5tIHTwhG9SXvORZr0g25AJ4d/DZL8=;
        b=IH2oqwpzBvDPa5+MapOrEr6XUqYbEwJBkJwX01Vac3sjJPIUjsxQxAEZ9pvsT5iTEq
         dmvp6gZZRo6xEAgEhwG6EaQDS3HWm6KS/H3+vdVeVcHTM6kWe9SO0C0Cl1jfIbkpSZaT
         7jGuN9y2yJQbaD9YqwGqgZFZCFTqOpx8buOiAfIwFTOsf3jxtNlBRh5Yi3in0Lq+3eW2
         YWw+WBS/25V3dyb7k0Lx8cWhWmhTFLjnfIXRmyVWFN1wdoSZTvW7ys7Y80NeoUqvg5nd
         uLL5qyb0uHFEbEvNy7cku6iiwToKZH/Zm/jHUc1HPMfbRi7Y5ToZxWVrvgWf0+EYV0VY
         Ackg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c4JvAfJlkT3WqL5tIHTwhG9SXvORZr0g25AJ4d/DZL8=;
        b=Ry13msHbd+aWTnJg6THttTl39bcySjsnBiM/YGeQ6IgKzZ6vaIsu7SwE1joTDcLvbw
         o1kjCE/nhMFQhUfOkwZPwM9epfMEWc25Mqg+oP9L8Q51juleRtiDQG3QN5uDW9uCQtGf
         wla9SLiyoiTWgzB4b69JyIEcdMDzXx0gT4jczTzJESRcr/HXex3hOWiz4pURNixpVNYe
         DffsCfbGkDAcopt1mI97RYgTHu+leDE5iuGNyjkQiwp4LLJn3FweeWLHTbus4LYEPFIe
         kYHTnhTsvvR6yJnW1ZYWEQtWKrUWPIjNo2EJAc7vwOceYbMM8k6xqwzjnsLDSr4JrqC7
         1NDQ==
X-Gm-Message-State: APjAAAWsxsE7v0fBHmimssQS8TX1x7BN4PEds5ED8/E0uWE6TFJsApwR
        Cd9na5KY9OyYwJ+VwT+XIm+EPWy8
X-Google-Smtp-Source: APXvYqzCR+LP9F9hQoJwEuC7RvWP5v4KqUIhbPAsV1TTrLm/FsAoKiYdxJCnFVWkZiej8DbSdxANhA==
X-Received: by 2002:a17:902:6b0c:: with SMTP id o12mr16239658plk.284.1575658077357;
        Fri, 06 Dec 2019 10:47:57 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id 129sm17513122pfw.71.2019.12.06.10.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 10:47:56 -0800 (PST)
Subject: Re: [PATCH net] net: netlink: Fix uninit-value in netlink_recvmsg()
To:     =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20191206134923.2771651-1-haakon.bugge@oracle.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c24c48d2-fc5e-6aca-27b8-7ea98ecd3ecc@gmail.com>
Date:   Fri, 6 Dec 2019 10:47:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191206134923.2771651-1-haakon.bugge@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/6/19 5:49 AM, Håkon Bugge wrote:
> If skb_recv_datagram() returns NULL, netlink_recvmsg() will return an
> arbitrarily value.
> 
> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
> ---
>  net/netlink/af_netlink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 90b2ab9dd449..bb7276f9c9f8 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -1936,6 +1936,7 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>  		return -EOPNOTSUPP;
>  
>  	copied = 0;
> +	err = 0;
>  
>  	skb = skb_recv_datagram(sk, flags, noblock, &err);
>  	if (skb == NULL)
> 

Please provide a Fixes: tag

By doing the research, you probably would find there is no bug.

err is set in skb_recv_datagram() when there is no packet to read.

