Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30214135367
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 07:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgAIG5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 01:57:51 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36088 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgAIG5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 01:57:51 -0500
Received: by mail-pj1-f68.google.com with SMTP id n59so739967pjb.1;
        Wed, 08 Jan 2020 22:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EGLJrFDAJvVSUXGf5r+UXyr/WyWVdcP4T3MVsD1N2yk=;
        b=a/wYjSdU/ZAJunO54jevddz2zOeAE2ZSkJj1rzB0bmvBB5XPHQTD5LRvAhvwaSq1R3
         mtDYZ254YQzTnxjAKPoIxfoQ8WkSZ4Y9fimArhdi8yGnC5+cH6d+uMHFoN0B9C7P26AH
         fOa3nFIJODTEGQACQoLdveV9zypq+tvRTpiAO1aTTiMy8Iv7IODi2n6iPAZ8V3UlCUiq
         LJtRg3TmvWN5pPqaTEBZEZFB72cjhDkEIOjRmXk3WRUdUppIdwPx4QPnuCXDaEhtCI/y
         1Cop8u/0FlkkYvRJOqPRgZOc4XgSqa4BSAlsqmdzLqWgPqT01TYL5LS97Fx92bjJ+aF3
         hwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EGLJrFDAJvVSUXGf5r+UXyr/WyWVdcP4T3MVsD1N2yk=;
        b=uUKsEVTI5sKKQvdIm225lNLvVUMeN7UGUs4ohfgiUDD2upFb7VTrqqdLYnWvb56+z0
         DqEUMoLce0ZZC6VqeIQCquqT9HA5XJQ6DlCnOn3bja834bBAgGz9RMhja8NylNNXKrwz
         1fORCZ9wlJh6bkGboMgR4d/fV8iFnLa05cZ5+js5Nv3PuoaW1ijEnNVjAUIqNt47AbOy
         NcpFISzSQmafibD1WSns6JlFliv9rNYn937pA0h08F6Lg1BBONOmb1lY38XlPf0TWM89
         1qyZ7WS3yD6eA1+RJNwjn67+FHNihV6WNGiVLmIO6JRxLpmFHojzTJhLm+uWBG8fyY7G
         21Cg==
X-Gm-Message-State: APjAAAVBe2XjEgaxG0pZK6DNBku+7UnwQDf/r1ICPNL+DxcYlRhe23+R
        7PvklZWZmdWqWQkgxKnm/GI=
X-Google-Smtp-Source: APXvYqwSXgW13/epl0QKnF2rous6/+hlKJq6RuTl0vO7FN4hgE34XzQ1CCtV4UUsIOSSoyZvw7gJCw==
X-Received: by 2002:a17:90a:d985:: with SMTP id d5mr3633354pjv.73.1578553070403;
        Wed, 08 Jan 2020 22:57:50 -0800 (PST)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id j7sm6635630pgn.0.2020.01.08.22.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 22:57:50 -0800 (PST)
Subject: Re: [bpf PATCH 2/2] bpf: xdp, remove no longer required
 rcu_read_{un}lock()
To:     John Fastabend <john.fastabend@gmail.com>, bjorn.topel@gmail.com,
        bpf@vger.kernel.org, toke@redhat.com
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
References: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
 <157851930654.21459.7236323146782270917.stgit@john-Precision-5820-Tower>
 <a4bb8f06-f960-cdda-f73a-8b87744445af@gmail.com>
 <5e16c99ecc70b_279f2af4a0e725c49a@john-XPS-13-9370.notmuch>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <b74865dd-c8ff-4a93-a4b6-0dfd021eca66@gmail.com>
Date:   Thu, 9 Jan 2020 15:57:45 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <5e16c99ecc70b_279f2af4a0e725c49a@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/01/09 15:35, John Fastabend wrote:
> Toshiaki Makita wrote:
>> On 2020/01/09 6:35, John Fastabend wrote:
>>> Now that we depend on rcu_call() and synchronize_rcu() to also wait
>>> for preempt_disabled region to complete the rcu read critical section
>>> in __dev_map_flush() is no longer relevant.
>>>
>>> These originally ensured the map reference was safe while a map was
>>> also being free'd. But flush by new rules can only be called from
>>> preempt-disabled NAPI context. The synchronize_rcu from the map free
>>> path and the rcu_call from the delete path will ensure the reference
>>> here is safe. So lets remove the rcu_read_lock and rcu_read_unlock
>>> pair to avoid any confusion around how this is being protected.
>>>
>>> If the rcu_read_lock was required it would mean errors in the above
>>> logic and the original patch would also be wrong.
>>>
>>> Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
>>> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
>>> ---
>>>    kernel/bpf/devmap.c |    2 --
>>>    1 file changed, 2 deletions(-)
>>>
>>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>>> index f0bf525..0129d4a 100644
>>> --- a/kernel/bpf/devmap.c
>>> +++ b/kernel/bpf/devmap.c
>>> @@ -378,10 +378,8 @@ void __dev_map_flush(void)
>>>    	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
>>>    	struct xdp_bulk_queue *bq, *tmp;
>>>    
>>> -	rcu_read_lock();
>>>    	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
>>>    		bq_xmit_all(bq, XDP_XMIT_FLUSH);
>>> -	rcu_read_unlock();
>>
>> I introduced this lock because some drivers have assumption that
>> .ndo_xdp_xmit() is called under RCU. (commit 86723c864063)
>>
>> Maybe devmap deletion logic does not need this anymore, but is it
>> OK to drivers?
> 
> Ah OK thanks for catching this. So its a strange requirement from
> virto_net to need read_lock like this. Quickly scanned the drivers
> and seems its the only one.
> 
> I think the best path forward is to fix virtio_net so it doesn't
> need rcu_read_lock() here then the locking is much cleaner IMO.

Actually veth is calling rcu_dereference in .ndo_xdp_xmit() so it needs
the same treatment. In the reference I sent in another mail, Jesper
said mlx5 also has some RCU dependency.

> I'll send a v2 and either move the xdp enabled check (the piece
> using the rcu_read_lock) into a bitmask flag or push the
> rcu_read_lock() into virtio_net so its clear that this is a detail
> of virtio_net and not a general thing. FWIW I don't think the
> rcu_read_lock is actually needed in the virtio_net case anymore
> either but pretty sure the rcu_dereference will cause an rcu
> splat. Maybe there is another annotation we can use. I'll dig
> into it tomorrow. Thanks

I'm thinking we can just move the rcu_lock to wrap around only ndo_xdp_xmit.
But as you suggest if we can identify all drivers which depends on RCU and move the
rcu_lock into the drivers (or remove the dependency) it's better.

Toshiaki Makita
