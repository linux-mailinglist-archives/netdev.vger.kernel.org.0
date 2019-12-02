Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E6D10EEEF
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 19:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfLBSKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 13:10:33 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:37553 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbfLBSKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 13:10:33 -0500
Received: by mail-ot1-f68.google.com with SMTP id k14so330375otn.4
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 10:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=3T3a+kwSOtasigIO0jGcMyTt9hkxgH3VEfkRkQo8HuI=;
        b=UHH5PVDDVS/shIwtYgzKbfKKTtE76aMr0RjHV+3VmzGMstnmcVwXZc7PlEkB5eXFhE
         2rn+FXoHaM53lAcOVejvD4ZBryo7aXWBcxIplVHWDvMZQ4NSbHhnpSDaNegtjE1MUhAS
         IlIBygkoB+6l7ki2cH4zC3NkjfoezebQn+zOfJUdo/fZs9iIZk1OkCsfT7zC0HJq8hPT
         xssmdidgZh8STvG3F8EeXMpCD7jk9YjqbphVvB7Zy+4SjOtJREHODe/r78kfUUWjTOvB
         OHfikh+oh2phtx+HV8UoE8OnkJkQNWKmR5Yy4McjeZqasfQf0KDxMvdvJk0+4EXYsG+D
         +XRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3T3a+kwSOtasigIO0jGcMyTt9hkxgH3VEfkRkQo8HuI=;
        b=mxyuzSbnfHSa+ciMQx59jwQ+2fyxv88XRQxCiSIjlMbUtdQHZA6o9Bw+O4X9QPero5
         sMwFgOo8/hKCRqgm5jDfYSn89pMa5XIkayMS56dvLvzViTyixdvGuw/ABvKyW+Mt/CT7
         GF3OQryKgKj0Cn144+HIClxsgK6Bor+tlTi5Ye+MpoLfgNxTxeV0l8PnpPLu7+Ns0Jxc
         Vm4Ng0lrbSoADScMxnOjInBo6K2xolNoq+dcpwowYBrijlY72VXmdsaaxP1nQ1+ruoZc
         mBPOh0J13wLBWRLFGqvWsSgkHA2t1ZQ43nFQHTtfCRJKG+0R94dhVkM0XFMk6k8N0lrq
         i5sg==
X-Gm-Message-State: APjAAAW2n47NP8IGX4iwdYfAme0khUVhXvDcJB7JXTt4qC/Wv8WTh7el
        yRkyPwKFYP6fg+Q2PlqkwkcZDnat
X-Google-Smtp-Source: APXvYqyceclujpyrVYra3K8X9X6uakgjqFU+ivXmHplgTaSAYYsqeZdHb+Iac2E5LBVLNt6bwxLlvQ==
X-Received: by 2002:a9d:70d2:: with SMTP id w18mr307007otj.48.1575310232748;
        Mon, 02 Dec 2019 10:10:32 -0800 (PST)
Received: from [192.168.1.104] ([74.197.19.145])
        by smtp.gmail.com with ESMTPSA id b20sm63018oib.1.2019.12.02.10.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 10:10:32 -0800 (PST)
Subject: Re: Followup: Kernel memory leak on 4.11+ & 5.3.x with IPsec
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org
References: <CAMnf+Pg4BLVKAGsr9iuF1uH-GMOiyb8OW0nKQSEKmjJvXj+t1g@mail.gmail.com>
 <20191101075335.GG14361@gauss3.secunet.de>
 <f5d26eeb-02b5-20f4-14f5-e56721c97eb8@gmail.com>
 <20191111062832.GP13225@gauss3.secunet.de>
From:   JD <jdtxs00@gmail.com>
Message-ID: <a1a60471-7395-2bb0-5c6d-290b9af4b7dc@gmail.com>
Date:   Mon, 2 Dec 2019 12:10:32 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191111062832.GP13225@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I noticed the patch hasn't been in the last two stable releases for 4.14 
and 4.19.  I checked the 4.14.157 and 4.19.87 release but the 
xfrm_state.c file doesn't have the patch.

Any update on or eta when this patch will backported to those two?  
Also, I suppose 5.3.14 will need it as well.

Thank you.

On 11/11/2019 12:28 AM, Steffen Klassert wrote:
> On Mon, Nov 04, 2019 at 12:25:37PM -0600, JD wrote:
>> Hello Steffen,
>>
>> I left the stress test running over the weekend and everything still looks
>> great. Your patch definitely resolves the leak.
> I've just applied the patch below to the IPsec tree.
>
> Thanks again for reporting and testing!
>
> Subject: [PATCH] xfrm: Fix memleak on xfrm state destroy
>
> We leak the page that we use to create skb page fragments
> when destroying the xfrm_state. Fix this by dropping a
> page reference if a page was assigned to the xfrm_state.
>
> Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
> Reported-by: JD <jdtxs00@gmail.com>
> Reported-by: Paul Wouters <paul@nohats.ca>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>   net/xfrm/xfrm_state.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index c6f3c4a1bd99..f3423562d933 100644
> --- a/net/xfrm/xfrm_state.c
> +++ b/net/xfrm/xfrm_state.c
> @@ -495,6 +495,8 @@ static void ___xfrm_state_destroy(struct xfrm_state *x)
>   		x->type->destructor(x);
>   		xfrm_put_type(x->type);
>   	}
> +	if (x->xfrag.page)
> +		put_page(x->xfrag.page);
>   	xfrm_dev_state_free(x);
>   	security_xfrm_state_free(x);
>   	xfrm_state_free(x);


