Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD921130EE
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 18:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfLDRj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 12:39:27 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36084 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDRj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 12:39:27 -0500
Received: by mail-pj1-f68.google.com with SMTP id n96so108956pjc.3;
        Wed, 04 Dec 2019 09:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LiJocrhksCvpO+19ZdExpChYK8w6nQgoAmY+U1ToVCw=;
        b=DFVeuZX8iTexCHx8t3r9+DFmLx/hWSshdMstwuBvqeXm/taPQxGkeLpYDDdOktV7KC
         y6oi9Y38zDn3633Eya9Ka5B6eJZSkvOO/saG/83igdkdtK/Xpf4QyZowDVvxVYdFQQ90
         /vBCnSAbNsyWNm8sVmkVRIyfl+3n3caPM/xCmkuibaIORcQY8Hrfwvd4HjWa1n7yOQUw
         Bt5yhDjKtOFzuthd9dVDDxbAmYbj16C/BrI8xzpXOBkI15DizyUT+rSOsE93HxZW+KNQ
         ImGZhsnVhOd6cys76qCNeHLTRKEVdFaqD688dS4wskjOocqD9JrzmKQTAgfG5PgOHmVI
         J+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LiJocrhksCvpO+19ZdExpChYK8w6nQgoAmY+U1ToVCw=;
        b=ISVsFWAVHjsACFml5DM6kViYQJ0tXEIV/IPOisRbwpUnc6gorkY0jF30c2JSEoZ/rC
         NbCeUHw8/wVl0iitzh1lfMSEFYStVzn0Wrn1RevkD//XVwh84UW4uzVWmCCFdLELJVHF
         PQohA0gIrYEKGNIxVcZRte9uiMvYXIdEjVKLZycfRCWWeogVAr5hssGZLMsoUPtciEmF
         iq57tqadijDoT66ivoFpUFFsByCcOR4/fh4uBWqWux1pPoIKhyOuDWe8whnUJIP0RBs4
         3qfhUj+jQP4iE3IihGiUT+3sIsqppHBzE+LWZTNF2oRlMfZsRULpVhOUZLE6mTrb+T3y
         Uf4A==
X-Gm-Message-State: APjAAAWAEI58tk62hBdVbV3QikgdjVqPONYvWFTV/8HeptP2EI+Yob/q
        ndMKaDjeqVjG+Z/B6zK47W3a+ZEr
X-Google-Smtp-Source: APXvYqwe3IcNYdntM1drGvi5vv9cb2mBcY251MgrD5fiAgLt2Jx1ESE7j+6W8y9jVGNETF4QVvvsuQ==
X-Received: by 2002:a17:90a:bf81:: with SMTP id d1mr4465454pjs.125.1575481166109;
        Wed, 04 Dec 2019 09:39:26 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id j20sm8350166pff.182.2019.12.04.09.39.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 09:39:25 -0800 (PST)
Subject: Re: [PATCH] net/decnet: fix -EFAULT error that is not getting
 returned
To:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191204151144.1434209-1-colin.king@canonical.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b75479fd-055e-3758-fc59-3385185a705b@gmail.com>
Date:   Wed, 4 Dec 2019 09:39:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191204151144.1434209-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/19 7:11 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently an -EFAULT error on a memcpy_to_msg is not being returned
> because it is being overwritten when variable rv is being re-assigned
> to the number of bytes copied after breaking out of a loop. Fix this
> by instead assigning the error to variable copied so that this error
> code propegated to rv and hence is returned at the end of the function.
> 
> [ This bug was was introduced before the current git history ]
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/decnet/af_decnet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
> index e19a92a62e14..e23d9f219597 100644
> --- a/net/decnet/af_decnet.c
> +++ b/net/decnet/af_decnet.c
> @@ -1759,7 +1759,7 @@ static int dn_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>  			chunk = size - copied;
>  
>  		if (memcpy_to_msg(msg, skb->data, chunk)) {
> -			rv = -EFAULT;
> +			copied = -EFAULT;

This does not look right.

We probably want :
		if (!copied)
			copied = -EFAULT;

>  			break;
>  		}
>  		copied += chunk;
> 
