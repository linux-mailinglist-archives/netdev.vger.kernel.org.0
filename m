Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5812381B96
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 00:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhEOW7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 18:59:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30041 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229568AbhEOW7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 18:59:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621119478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9+7OU1jiXcuN+JE+ZENa1/WzM8XgPqJzZW5eKBUcv7I=;
        b=CRskjGbRZW7s0NNWw6Exv6owoIbH3/pQ16rvPE2NDNp5P1doAAGVL8y13kgDkzXJvSpJcW
        hypIvnWnI7aWpOLMOm1yOaYgAWE/EeUDSfmKU4vurA7AX1YQ8Qu0J/cqh9Asd2dQlgMTQr
        G07RQnmMTOwpkEmn74WCq5L+lTUI8pE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-phDzVN7YM-6MqJ3ldxjHJw-1; Sat, 15 May 2021 18:57:57 -0400
X-MC-Unique: phDzVN7YM-6MqJ3ldxjHJw-1
Received: by mail-qt1-f199.google.com with SMTP id e28-20020ac84b5c0000b02901cd9b2b2170so2293998qts.13
        for <netdev@vger.kernel.org>; Sat, 15 May 2021 15:57:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=9+7OU1jiXcuN+JE+ZENa1/WzM8XgPqJzZW5eKBUcv7I=;
        b=Zn9ileSh/ufVGbL/4S/GgAu6eL7GVTiu/wA6RPM/8yBYHqR+QjGLG4o1IyfSMqsvKN
         AFRJJfPl3Lkcd8KlRUT7c2JSB6HAzHtwJ560y4OrtXA7QQ+mi/QzBySuynqz0D9sdJD1
         dI5J5qkcqbpskYouWx9KLkeEpV9dC6EUgZD1df0Bp6bkLdTo/5ujHTgmBIFhrf/vdbWD
         pwSXwcCySgPqZhZmwsOvJNnVb+d+AXytE7W7WaDJvERzC2Gvkk5DLafmCKG1Jw1zKZ7l
         rGaUOlVc1geGhVNL9AxzVS06yEiXk2I7bLhIU5i6eMMpA+Ysi1Du+es83rhgREeMA9bW
         rUSg==
X-Gm-Message-State: AOAM533d1veWyv8/Ufl5Ya/3PornNG25sRCumr1O9oc8VdOkRIp6pZ/x
        RxAJMe2KFUBE2c66fpoIUddV5z/8h1vSVtknOh2sfEEoV5XxGoJTqwMf5FHPPdiRXpN58vwlLko
        nrTD/bJZ4Sm4ZLqCb
X-Received: by 2002:a05:6214:1433:: with SMTP id o19mr1671466qvx.59.1621119476370;
        Sat, 15 May 2021 15:57:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKwOrtaeteO9NmLX1KUl053C7yobMvcddlNcbBg6LmnS9TOilpr6UZNHO1lvzeOYNU1Ne6Cw==
X-Received: by 2002:a05:6214:1433:: with SMTP id o19mr1671460qvx.59.1621119476204;
        Sat, 15 May 2021 15:57:56 -0700 (PDT)
Received: from [192.168.0.106] ([24.225.235.43])
        by smtp.gmail.com with ESMTPSA id b23sm7891095qtq.0.2021.05.15.15.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 May 2021 15:57:55 -0700 (PDT)
Subject: Re: [PATCH net] tipc: skb_linearize the head skb when reassembling
 msgs
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Ying Xue <ying.xue@windriver.com>
References: <c7d752b5522360de0a6886202c59fe49524a9fda.1620417423.git.lucien.xin@gmail.com>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <6b5deaab-d91a-8008-961e-805274f8989f@redhat.com>
Date:   Sat, 15 May 2021 18:57:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <c7d752b5522360de0a6886202c59fe49524a9fda.1620417423.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/21 3:57 PM, Xin Long wrote:
> It's not a good idea to append the frag skb to a skb's frag_list if
> the frag_list already has skbs from elsewhere, such as this skb was
> created by pskb_copy() where the frag_list was cloned (all the skbs
> in it were skb_get'ed) and shared by multiple skbs.
>
> However, the new appended frag skb should have been only seen by the
> current skb. Otherwise, it will cause use after free crashes as this
> appended frag skb are seen by multiple skbs but it only got skb_get
> called once.
>
> The same thing happens with a skb updated by pskb_may_pull() with a
> skb_cloned skb. Li Shuang has reported quite a few crashes caused
> by this when doing testing over macvlan devices:
>
>    [] kernel BUG at net/core/skbuff.c:1970!
>    [] Call Trace:
>    []  skb_clone+0x4d/0xb0
>    []  macvlan_broadcast+0xd8/0x160 [macvlan]
>    []  macvlan_process_broadcast+0x148/0x150 [macvlan]
>    []  process_one_work+0x1a7/0x360
>    []  worker_thread+0x30/0x390
>
>    [] kernel BUG at mm/usercopy.c:102!
>    [] Call Trace:
>    []  __check_heap_object+0xd3/0x100
>    []  __check_object_size+0xff/0x16b
>    []  simple_copy_to_iter+0x1c/0x30
>    []  __skb_datagram_iter+0x7d/0x310
>    []  __skb_datagram_iter+0x2a5/0x310
>    []  skb_copy_datagram_iter+0x3b/0x90
>    []  tipc_recvmsg+0x14a/0x3a0 [tipc]
>    []  ____sys_recvmsg+0x91/0x150
>    []  ___sys_recvmsg+0x7b/0xc0
>
>    [] kernel BUG at mm/slub.c:305!
>    [] Call Trace:
>    []  <IRQ>
>    []  kmem_cache_free+0x3ff/0x400
>    []  __netif_receive_skb_core+0x12c/0xc40
>    []  ? kmem_cache_alloc+0x12e/0x270
>    []  netif_receive_skb_internal+0x3d/0xb0
>    []  ? get_rx_page_info+0x8e/0xa0 [be2net]
>    []  be_poll+0x6ef/0xd00 [be2net]
>    []  ? irq_exit+0x4f/0x100
>    []  net_rx_action+0x149/0x3b0
>
>    ...
>
> This patch is to fix it by linearizing the head skb if it has frag_list
> set in tipc_buf_append(). Note that we choose to do this before calling
> skb_unshare(), as __skb_linearize() will avoid skb_copy(). Also, we can
> not just drop the frag_list either as the early time.
>
> Fixes: 45c8b7b175ce ("tipc: allow non-linear first fragment buffer")
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>   net/tipc/msg.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/net/tipc/msg.c b/net/tipc/msg.c
> index 3f0a253..ce6ab54 100644
> --- a/net/tipc/msg.c
> +++ b/net/tipc/msg.c
> @@ -149,18 +149,13 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
>   		if (unlikely(head))
>   			goto err;
>   		*buf = NULL;
> +		if (skb_has_frag_list(frag) && __skb_linearize(frag))
> +			goto err;
>   		frag = skb_unshare(frag, GFP_ATOMIC);
>   		if (unlikely(!frag))
>   			goto err;
>   		head = *headbuf = frag;
>   		TIPC_SKB_CB(head)->tail = NULL;
> -		if (skb_is_nonlinear(head)) {
> -			skb_walk_frags(head, tail) {
> -				TIPC_SKB_CB(head)->tail = tail;
> -			}
> -		} else {
> -			skb_frag_list_init(head);
> -		}
>   		return 0;
>   	}
>   
Acked-by: Jon Maloy <jmaloy@redhat.com>

