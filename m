Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 786EBD62E0
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 14:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731029AbfJNMqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 08:46:06 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42019 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730733AbfJNMqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 08:46:06 -0400
Received: by mail-pg1-f196.google.com with SMTP id f14so4951324pgi.9;
        Mon, 14 Oct 2019 05:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PJizmR8nNVLQP4oKIsqXFCLsPLDAyIx80sr6Y5F0cg8=;
        b=RTLgL8MzCC1QFCGRsPfgjcqJhhlex207NBFvHed47ujMLweqqOv7j/7fUHPPDVBlgs
         yOzN/gpj0sSiwjegsSB2pruxV/GLaUb7k2g/qnwOOM3Hu3WZIDJkY6w9SeU2cn5g4ZZo
         VK35hUTD2j6knmXFa/42vprGhCpugakk8fRdLq8M/0ozg7Qip2HwRqFB3Ppd/HM5RIea
         yERDeKlDqf+mECPoEOrHJi98+lQpeArKLVXZzkBrQRlNnLONpXCvyh8DRiFDNnBpW3Ng
         kkf9PD8cy/QG3MfOOZoIfYBUgrEC0o+pOP7LLbHnmhCdOJA/hNsleo/uxvDv22NetAs2
         C1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PJizmR8nNVLQP4oKIsqXFCLsPLDAyIx80sr6Y5F0cg8=;
        b=iBg7kdAbikbtbtoatDKBr+iV8bDXjILUiPwlHvsnuEvhneEnGIlQ57tf646PT9LV2g
         O12e7fqsaHzN94LBUJZPgz9ZSdizVWxfmm7JNzVJ9DByvQ0JToctpR0X9nwhB0r98DjP
         hol+/8zmZ+4G28e6oAxolS/0yD8Z2AsIWuYftyDSo9lrAeuiR+ONQgrMe31RjL3FPJId
         YRRQmuyBdGs9ZAORdqfNkGGJOc+5U7VCc6wXE+yH+VmnmIGXnDnXS/LvKziGhZ9HHebe
         TgPtovYV8MYQzjuzfvQXkqefVmiXsYHNba7H4quwYXNGZKegHsRf7PGJdulLQK6ZfpEl
         amDA==
X-Gm-Message-State: APjAAAXOa8NFzsXzXt8qAT4xY5uG7dhXq6tpnrsFFWUsz1/PWWCHtp7z
        mJ+OM39oxSizbrvSD3sT96KSDP8R
X-Google-Smtp-Source: APXvYqx9F3kcOHEBh6NJCYB1/bQEY5V/jmACOWYkDR0dai6rklXEwbvDdUzUTwLlDwSZz+fJexZwvg==
X-Received: by 2002:a17:90a:8d13:: with SMTP id c19mr35979764pjo.63.1571057165086;
        Mon, 14 Oct 2019 05:46:05 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id 192sm20582422pfb.110.2019.10.14.05.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2019 05:46:04 -0700 (PDT)
Subject: Re: [PATCH net] net: sched: act_mirred: drop skb's dst_entry in
 ingress redirection
To:     Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
 <2d816fb6-befb-aaeb-328b-539507022a22@gmail.com>
 <31b4e85e-bdf8-6462-dc79-06ff8d98b6cf@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4d23d69d-f716-afb4-8db6-c21b5ccd7c44@gmail.com>
Date:   Mon, 14 Oct 2019 05:46:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <31b4e85e-bdf8-6462-dc79-06ff8d98b6cf@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/14/19 12:07 AM, Zhiyuan Hou wrote:
> 
> On 2019/10/12 6:59 下午, Eric Dumazet wrote:
>>
>> On 10/12/19 12:16 AM, Zhiyuan Hou wrote:
>>> In act_mirred's ingress redirection, if the skb's dst_entry is valid
>>> when call function netif_receive_skb, the fllowing l3 stack process
>>> (ip_rcv_finish_core) will check dst_entry and skip the routing
>>> decision. Using the old dst_entry is unexpected and may discard the
>>> skb in some case. For example dst->dst_input points to dst_discard.
>>>
>>> This patch drops the skb's dst_entry before calling netif_receive_skb
>>> so that the skb can be made routing decision like a normal ingress
>>> skb.
>>>
>>> Signed-off-by: Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
>>> ---
>>>   net/sched/act_mirred.c | 5 ++++-
>>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
>>> index 9ce073a05414..6108a64c0cd5 100644
>>> --- a/net/sched/act_mirred.c
>>> +++ b/net/sched/act_mirred.c
>>> @@ -18,6 +18,7 @@
>>>   #include <linux/gfp.h>
>>>   #include <linux/if_arp.h>
>>>   #include <net/net_namespace.h>
>>> +#include <net/dst.h>
>>>   #include <net/netlink.h>
>>>   #include <net/pkt_sched.h>
>>>   #include <net/pkt_cls.h>
>>> @@ -298,8 +299,10 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
>>>         if (!want_ingress)
>>>           err = dev_queue_xmit(skb2);
>>> -    else
>>> +    else {
>>> +        skb_dst_drop(skb2);
>>>           err = netif_receive_skb(skb2);
>>> +    }
>>>         if (err) {
>>>   out:
>>>
>> Why is dst_discard used ?
> When send a skb from local to external, the dst->dst_input will be
> assigned dst_discard after routing decision. So if we redirect these
> skbs to ingress stack, it will be dropped.
> 
> For ipvlan l2 mode or macvlan, clsact egress filters on master deivce
> may also meet these skbs even if they came from slave device. Ingress
> redirection on these skbs may drop them on l3 stack.

Can you please add a test, so that we can see what you are trying to do exactly ?




>> This could actually drop packets, for loopback.
>>
>> A Fixes: tag would tremendously help, I wonder if you are not working around
>> the other issue Wei was tracking yesterday ( https://www.spinics.net/lists/netdev/msg604397.html )
> No, this is a different issue ^_^.

Please add a Fixes: tag then.

Thanks.
