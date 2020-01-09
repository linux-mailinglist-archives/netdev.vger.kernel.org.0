Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7579A1352F6
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 07:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgAIGBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 01:01:16 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40843 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgAIGBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 01:01:16 -0500
Received: by mail-pg1-f196.google.com with SMTP id k25so2671123pgt.7;
        Wed, 08 Jan 2020 22:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YJI+8nBaX+YClMtWDKO/JvFrqW7bGFHCvyKaisEeMn4=;
        b=uBg7Kw8RPem8bWQ/DYpUSbNGkay8DVaYObkJffe51E1kLTYg35jmsLvMbEQXdf/crA
         co/xDQ4iVgKAdH7Pp5tL38Cb/H+p+cZA2DD8ZKKfJceCLmKQ7zUDpjNZ76fagMiRHJB8
         qn+Ba7LrDzYBERICP8FU/wwFVjwHM92JSEadv/L8E62iRhtmczb0OjrxfD28yNQd0q/y
         uY1J3cdqsdibPqZE1VCtCt+0rBKEwccX1P+klG0Swz2PoPYPp5Uq7boiAa6wHwIuYeL3
         a+d4O2viEk02ptziZBPdmT1uLN81ffB/S7refXVEF0IwjSzrn1RjOhmhCBvUX8k3odZo
         TjkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YJI+8nBaX+YClMtWDKO/JvFrqW7bGFHCvyKaisEeMn4=;
        b=DNbvKDP5LV+BqhlvTSKZqn09VXHYGRU0kq+FqD2ZYJoiaoq6SAFQytFTQocZsT0iCL
         vNkr95bm84vtSPzzUUmC3XyM+DJOP73FbNMkz56WvyMLxjKX6Kh3QI4pZOfZkR/bYCsL
         chCsjMmxsq6sK12Pa5E4h+7WOxOycHkXKqBVeoxwOf3gL4uFfPowpXVwBikvT9HPJPo/
         sbCn2xaiob3rDUotFUPjQZaCsYVF+Spd8E64cJNIuRWS/KqD7A8RI7JgL4Pth4COF4KC
         PHJLJmAaPN4XL/xHCUkNcyoE6FJwlpmV18QhULwPGkBI9CQta/B+B/CnWIT2GNAI5ESf
         dwpw==
X-Gm-Message-State: APjAAAWzdzdFfBcJK9QMepEpb+UHIAzqb7O0m8D+N/Yh3tckstUenV6F
        Dy6kkmuTYtr5EoRZGo8xU20=
X-Google-Smtp-Source: APXvYqyJerfI+ICq2cwl9GhOGJy/axJr/Cb4bSjaJXBizTWJfYQRt5HeuzByImnF+q+hy5naYIeDXQ==
X-Received: by 2002:a62:8f0d:: with SMTP id n13mr9809271pfd.38.1578549674714;
        Wed, 08 Jan 2020 22:01:14 -0800 (PST)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id v143sm6135132pfc.71.2020.01.08.22.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 22:01:14 -0800 (PST)
Subject: Re: [bpf PATCH 2/2] bpf: xdp, remove no longer required
 rcu_read_{un}lock()
To:     John Fastabend <john.fastabend@gmail.com>, bjorn.topel@gmail.com,
        bpf@vger.kernel.org, toke@redhat.com
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
References: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
 <157851930654.21459.7236323146782270917.stgit@john-Precision-5820-Tower>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <a4bb8f06-f960-cdda-f73a-8b87744445af@gmail.com>
Date:   Thu, 9 Jan 2020 15:01:09 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <157851930654.21459.7236323146782270917.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/01/09 6:35, John Fastabend wrote:
> Now that we depend on rcu_call() and synchronize_rcu() to also wait
> for preempt_disabled region to complete the rcu read critical section
> in __dev_map_flush() is no longer relevant.
> 
> These originally ensured the map reference was safe while a map was
> also being free'd. But flush by new rules can only be called from
> preempt-disabled NAPI context. The synchronize_rcu from the map free
> path and the rcu_call from the delete path will ensure the reference
> here is safe. So lets remove the rcu_read_lock and rcu_read_unlock
> pair to avoid any confusion around how this is being protected.
> 
> If the rcu_read_lock was required it would mean errors in the above
> logic and the original patch would also be wrong.
> 
> Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   kernel/bpf/devmap.c |    2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index f0bf525..0129d4a 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -378,10 +378,8 @@ void __dev_map_flush(void)
>   	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
>   	struct xdp_bulk_queue *bq, *tmp;
>   
> -	rcu_read_lock();
>   	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
>   		bq_xmit_all(bq, XDP_XMIT_FLUSH);
> -	rcu_read_unlock();

I introduced this lock because some drivers have assumption that
.ndo_xdp_xmit() is called under RCU. (commit 86723c864063)

Maybe devmap deletion logic does not need this anymore, but is it
OK to drivers?

Toshiaki Makita
