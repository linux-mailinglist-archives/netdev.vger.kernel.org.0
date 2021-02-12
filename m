Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B138319D9B
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 12:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhBLLwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 06:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhBLLwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 06:52:03 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D53C061574;
        Fri, 12 Feb 2021 03:51:23 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id g6so7470506wrs.11;
        Fri, 12 Feb 2021 03:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8ZC2/R1SNZSuxcXy4LeK0Q8NhZvjFjYkR/mcbYkpiXI=;
        b=OteHdG/wlJUm02p1JyvM9mjLo5zlNWrvsspNLc/+tYdWqPm0V5qnTS3C71d/5Ojw0/
         ePqTeD+m3ezLwD/9Epu/bUpfCgkW9dWMgS5R13Z3zpdVXfHeQzg2IfhEOFcDJXq+2dph
         j7ynsBoSDBen6+iV+vGmLj9EWE946ul0UaBEkoVOR7jCLlGQNsjYfKJDoUgU4f4+2Qz8
         vyiXofPnoTvNn2jLpYhQc+mpUMajkI7KGVZNtXlHz74r60MsQd45xdUt6KVIt9Ruy+HU
         IsTDODGp/m3qlXAYryqON6/tG5TGfExjJ9Il/qiQFiLaI8UVq/c+7z9EjZ7cWHG32f+J
         /X6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8ZC2/R1SNZSuxcXy4LeK0Q8NhZvjFjYkR/mcbYkpiXI=;
        b=UoX8mUZ/6McG/7dM3IQrF4BLcruo8FE5aIHVXk4OV6CAKpUmwiPlWjlIRl8SklaY5D
         G2T8XnhXtnC6RunAjpxnMMxceDxUqWz9L3atBSQr9HyIlFrxhh0YfXnwA6x5ZDGpDAt9
         bW5buJv2HKA6qaPOiVYeWJxrjqBl4w37AR4KBmcqZwqb8L9Eq7pWRy57QAITaVkdHlj+
         m5QC3tEqnzKQG0PCrOM/FGyFJtKoRX32kDmj7mbdgH/938FdvzIOAdtzO0KqdHU40Rgt
         ehCl/9T8pGLviks95+gqgF4eREfeWnbDpPIT9TWf67YHVdRsvD8K4bCDZNCODzz+JX4g
         Aa0w==
X-Gm-Message-State: AOAM530JcqosIZ3rtCsToA5E0raJvXgr3ivV+GpIyQBygqf+omt0lfP3
        lWe2AI1lEk2gUVBS6FXQh7A=
X-Google-Smtp-Source: ABdhPJz22zetUFufDzdMB8IhcVovakzQUIiH3eon2UfCaV344pKM8aFHuwc4FUcd+AykuS6ZOCTzxg==
X-Received: by 2002:a5d:438c:: with SMTP id i12mr2901812wrq.179.1613130681989;
        Fri, 12 Feb 2021 03:51:21 -0800 (PST)
Received: from [192.168.1.101] ([37.165.143.52])
        by smtp.gmail.com with ESMTPSA id i10sm11542581wrp.0.2021.02.12.03.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 03:51:21 -0800 (PST)
Subject: Re: [PATCH] net/qrtr: restrict user-controlled length in
 qrtr_tun_write_iter()
To:     Sabyrzhan Tasbolatov <snovitoll@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com
References: <20210202092059.1361381-1-snovitoll@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3b27dac1-45b9-15ad-c25e-2f5f3050907e@gmail.com>
Date:   Fri, 12 Feb 2021 12:51:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210202092059.1361381-1-snovitoll@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/2/21 10:20 AM, Sabyrzhan Tasbolatov wrote:
> syzbot found WARNING in qrtr_tun_write_iter [1] when write_iter length
> exceeds KMALLOC_MAX_SIZE causing order >= MAX_ORDER condition.
> 
> Additionally, there is no check for 0 length write.
> 
> [1]
> WARNING: mm/page_alloc.c:5011
> [..]
> Call Trace:
>  alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
>  alloc_pages include/linux/gfp.h:547 [inline]
>  kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
>  kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
>  kmalloc include/linux/slab.h:557 [inline]
>  kzalloc include/linux/slab.h:682 [inline]
>  qrtr_tun_write_iter+0x8a/0x180 net/qrtr/tun.c:83
>  call_write_iter include/linux/fs.h:1901 [inline]
> 
> Reported-by: syzbot+c2a7e5c5211605a90865@syzkaller.appspotmail.com
> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> ---
>  net/qrtr/tun.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
> index 15ce9b642b25..b238c40a9984 100644
> --- a/net/qrtr/tun.c
> +++ b/net/qrtr/tun.c
> @@ -80,6 +80,12 @@ static ssize_t qrtr_tun_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	ssize_t ret;
>  	void *kbuf;
>  
> +	if (!len)
> +		return -EINVAL;
> +
> +	if (len > KMALLOC_MAX_SIZE)
> +		return -ENOMEM;



Probably not enough.

qrtr_endpoint_post() will later attempt a netdev_alloc_skb() which will need
some extra space (for struct skb_shared_info) 

Do we really expect to accept huge lengths here ?


> +
>  	kbuf = kzalloc(len, GFP_KERNEL);
>  	if (!kbuf)
>  		return -ENOMEM;
> 
