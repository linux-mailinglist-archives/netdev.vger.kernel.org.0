Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAAA5330AFF
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 11:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhCHKUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 05:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhCHKUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 05:20:05 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F998C06174A;
        Mon,  8 Mar 2021 02:20:05 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id d15so10831514wrv.5;
        Mon, 08 Mar 2021 02:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5FyddfYk6kKr/3zvxDS0VxAq0/NkeI1fTb/fX0lhdjQ=;
        b=VNu2vtDmLmzQJwF4ZyTj8wObBxKSsE82/oOXMgl6E3jKOhli0nYm0p9ir6Pdmv+8+0
         kNOXWuutxJh9KiHrdwuEVwytOHAOmG1gX89A8XkQcaGvAVRUgDsEY+xSMcQbIrKahyNv
         VmhHfiWrWglKX5OXr0HnRIDHBbEC1Z30DWvn5kcF1QNc7Hd4a4xsIZwpxWxe/p22lu5R
         Ed/DgbFFI4Bt9cehYSktW9xmeHPIGXCRAfQowteFDKa/4SpnvMXz/XnQtHutpVAJpj73
         GcHgfoDFjE25pHn6MRZq7F47x8NrAImuJthqjOflUVnYOXYzr6s9yLcSKY2Ft3qOZi+W
         HZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5FyddfYk6kKr/3zvxDS0VxAq0/NkeI1fTb/fX0lhdjQ=;
        b=nsF54KPjaXZgP2Bhm4YC91Pbt8VKibsYpu2n4JPgiJVKY/P0q7r1cYxHUdBpO8cuHX
         3C9WlwZR1+ApO+nIVbuxKBNHHBxW3ONKZXx54/fGV7AsDMBrv+Qj6lFF/fBiWqFj2Cjx
         Z9j7iqjiOKF180CVgCc741WelfT4KfSdWc4Q+Thih1tXnpaYy6dBXJwPw2TGkxquSwal
         x5e42FvkgDiStkW6NMVcP9I/IwKhOO3k0T2YFtSJs9fFXBR90uEeVQeN790mSTMohASR
         WV8xx7bIfxNYbCPr3ydFZXS8U++JdfwlsmNUCu5B0tmBBgIIOD7mXxu+QoOtZYAL5w31
         p7gw==
X-Gm-Message-State: AOAM532WuLJZaSvgTfGWkG0Wi4lF+RLwF8LXambMAuzBkM9VyGsxIEBQ
        hiByrTKJUHFgi47G3XUHiJkaaC6p+DoBSA==
X-Google-Smtp-Source: ABdhPJzCwrBCqqyIGM7tUOvJJ3q8im0e+1PCOS7GVSQC0rnBjVBVUcOR0NiLmcaAa5nAlh2dufPzqg==
X-Received: by 2002:adf:aa08:: with SMTP id p8mr21664879wrd.232.1615198803547;
        Mon, 08 Mar 2021 02:20:03 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:bb00:95fd:bec9:ac6f:f944? (p200300ea8f1fbb0095fdbec9ac6ff944.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:95fd:bec9:ac6f:f944])
        by smtp.googlemail.com with ESMTPSA id v2sm11306241wru.85.2021.03.08.02.20.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 02:20:03 -0800 (PST)
Subject: Re: [PATCH] net: ieee802154: fix error return code of dgram_sendmsg()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org, stefan@datenfreihafen.org
References: <20210308093106.9748-1-baijiaju1990@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d373b42c-0057-48b3-4667-bfa53a99f040@gmail.com>
Date:   Mon, 8 Mar 2021 11:19:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210308093106.9748-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.03.2021 10:31, Jia-Ju Bai wrote:
> When sock_alloc_send_skb() returns NULL to skb, no error return code of
> dgram_sendmsg() is assigned.
> To fix this bug, err is assigned with -ENOMEM in this case.
> 

Please stop sending such nonsense. Basically all such patches you
sent so far are false positives. You have to start thinking,
don't blindly trust your robot.
In the case here the err variable is populated by sock_alloc_send_skb().

> Fixes: 78f821b64826 ("ieee802154: socket: put handling into one file")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  net/ieee802154/socket.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
> index a45a0401adc5..a750b37c7e73 100644
> --- a/net/ieee802154/socket.c
> +++ b/net/ieee802154/socket.c
> @@ -642,8 +642,10 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  	skb = sock_alloc_send_skb(sk, hlen + tlen + size,
>  				  msg->msg_flags & MSG_DONTWAIT,
>  				  &err);
> -	if (!skb)
> +	if (!skb) {
> +		err = -ENOMEM;
>  		goto out_dev;
> +	}
>  
>  	skb_reserve(skb, hlen);
>  
> 

