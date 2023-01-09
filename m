Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8792366257B
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 13:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbjAIMZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 07:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbjAIMZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 07:25:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F351AA3F
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 04:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673267100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=047AVottjqaPKMmy/qTEXod9E2E5rMO4NCUZPc/fm8o=;
        b=KuIAtz0VdGBjtAIU1LDsvLuftAEtXrok95AVoLAC0zNOkIoklegCHNozeS0dUOV9Gdba1u
        os2XNXli/KzmoqzSCxU0ry2lIjLfp8dXEXOs7MR9rM0PZJOjl42Us55ItjGZ3eX6u6c3Ya
        37t9RkympBhOofxP0KI2Nc8Fy+tS8qI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-646-AStMbaU7MqWq047b25SY_Q-1; Mon, 09 Jan 2023 07:24:57 -0500
X-MC-Unique: AStMbaU7MqWq047b25SY_Q-1
Received: by mail-ed1-f71.google.com with SMTP id z8-20020a056402274800b0048a31c1746aso5095550edd.0
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 04:24:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=047AVottjqaPKMmy/qTEXod9E2E5rMO4NCUZPc/fm8o=;
        b=iIxGLzxcdFzHeA9T/Jeg+ljerhhwhbnJ7AAAJROJydniZ5A9tCRgAHcHtKUTdWwdw6
         tIDaa65kA/dUJLRnoGOd46CyacfUYEYXbcYCaCUiM35KBTiQjA3YYXoilPGw8JmOobw7
         63W/RvHVR6wAonnZFLd6sEvkalIJ+dnvh3uXLpH9wkAbzkF6REOpf4pvcLmGnMCRYKmg
         DewYlOebrQwFuNVNgyyYylUH8M7oijBMosbA9sd40EtrBU8/iLzMaseoO62h8xCW+8Wq
         HpRUBHHSrDfS4HTOIPARiKoZzkOnPMaWghVC8LtGZUa2hn9fugdsi+S35vAepBIVg9DO
         8gSg==
X-Gm-Message-State: AFqh2kp0EfBT64VqnqGOpx9OkD3XsAbm9Jdj/RmV6VIP2n3vT+oDZ+oT
        dmdrXUGVFUGH1L+/QLmJ9dTL8fZC3ixHUhDdqcKGRzAjkEtbTSM4o5hToLK3/UCesy6291H7bIG
        ks68cZ3XSkz9Tybaj
X-Received: by 2002:a17:907:2a06:b0:84d:12db:fd23 with SMTP id fd6-20020a1709072a0600b0084d12dbfd23mr10020528ejc.71.1673267096426;
        Mon, 09 Jan 2023 04:24:56 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu2WwxNmXUhy5g/cCORo7Fu+dWeppJy3ZSSkrKlE8Kjf/wdU5t5cFMxgfwdwDEJAjrrmRAa+Q==
X-Received: by 2002:a17:907:2a06:b0:84d:12db:fd23 with SMTP id fd6-20020a1709072a0600b0084d12dbfd23mr10020518ejc.71.1673267096235;
        Mon, 09 Jan 2023 04:24:56 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id c8-20020aa7df08000000b0046c4553010fsm3656686edy.1.2023.01.09.04.24.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 04:24:55 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <fa1c57de-52f6-719f-7298-c606c119d1ab@redhat.com>
Date:   Mon, 9 Jan 2023 13:24:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 2/2] net: kfree_skb_list use kmem_cache_free_bulk
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
References: <167293333469.249536.14941306539034136264.stgit@firesoul>
 <167293336786.249536.14237439594457105125.stgit@firesoul>
 <20230106143310.699197bd@kernel.org>
In-Reply-To: <20230106143310.699197bd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/01/2023 23.33, Jakub Kicinski wrote:
> Hi!
> 
> Would it not be better to try to actually defer them (queue to
> the deferred free list and try to ship back to the NAPI cache of
> the allocating core)? 
> Is the spin lock on the defer list problematic
> for fowarding cases (which I'm assuming your target)?

We might be talking past each-other.  As the NAPI cache for me
is the per CPU napi_alloc_cache (this_cpu_ptr(&napi_alloc_cache);)

This napi_alloc_cache doesn't use a spin_lock, but depend on being
protected by NAPI context.  The code in this patch closely resembles how
the napi_alloc_cache works.  See code: napi_consume_skb() and
__kfree_skb_defer().


> Also the lack of perf numbers is a bit of a red flag.
>

I have run performance tests, but as I tried to explain in the
cover letter, for the qdisc use-case this code path is only activated
when we have overflow at enqueue.  Thus, this doesn't translate directly
into a performance numbers, as TX-qdisc is 100% full caused by hardware
device being backed up, and this patch makes us use less time on freeing
memory.

I have been using pktgen script ./pktgen_bench_xmit_mode_queue_xmit.sh
which can inject packets at the qdisc layer (invoking __dev_queue_xmit).
And then used perf-record to see overhead of SLUB (__slab_free is top#4)
is reduced.


> On Thu, 05 Jan 2023 16:42:47 +0100 Jesper Dangaard Brouer wrote:
>> +static void kfree_skb_defer_local(struct sk_buff *skb,
>> +				  struct skb_free_array *sa,
>> +				  enum skb_drop_reason reason)
> 
> If we wanna keep the implementation as is - I think we should rename
> the thing to say "bulk" rather than "defer" to avoid confusion with
> the TCP's "defer to allocating core" scheme..

I named it "defer" because the NAPI cache uses "defer" specifically func
name __kfree_skb_defer() why I choose kfree_skb_defer_local(), as this
patch uses similar scheme.

I'm not sure what is meant by 'TCP's "defer to allocating core" scheme'.
Looking at code I guess you are referring to skb_attempt_defer_free()
and skb_defer_free_flush().

It would be too high cost calling skb_attempt_defer_free() for every SKB
because of the expensive spin_lock_irqsave() (+ restore).  I see the
skb_defer_free_flush() can be improved to use spin_lock_irq() (avoiding
mangling CPU flags).  And skb_defer_free_flush() (which gets called from
RX-NAPI/net_rx_action) end up calling napi_consume_skb() that endup
calling kmem_cache_free_bulk() (which I also do, just more directly).

> 
> kfree_skb_list_bulk() ?

Hmm, IMHO not really worth changing the function name.  The
kfree_skb_list() is called in more places, (than qdisc enqueue-overflow
case), which automatically benefits if we keep the function name
kfree_skb_list().

--Jesper

