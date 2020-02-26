Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE33716F610
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 04:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgBZDYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 22:24:34 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:37438 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbgBZDYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 22:24:33 -0500
Received: by mail-qv1-f65.google.com with SMTP id ci20so696148qvb.4
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 19:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=byJArUR1gRNyEzbbc+BbbcZgYoH1YkGLygZl2IVeHm8=;
        b=kOcwaFt2MGK69s2W0an/yK+ihpAOf67sX7WHOU2t4goCDrMLhXpWwTehOw/IvdQIRR
         sLQI+wRoBrzo1rsTYP2cX0iwzlB395nshepGRq6ObQMHNtQdHwe1qXQ68RulgOhZ/LlB
         0RzxDIiw8Gup+TXzOdmEeFP5BJGieClcfCgIP16w8AjWsX2+yf9dWMEkWLQwQuw1p7g+
         DBF4TXRft/tI5Rk6yPDHE/0MQzH4b9w/3FqwUcB61cSkRN6ISoi+cRxq+ds5eZk9AyDO
         SKV5Qv21d18HfBLvGnczdXnxBuVTzlrqa3an6msu/nObAep/2agNKf0PhdSF2S+pdEVM
         wmCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=byJArUR1gRNyEzbbc+BbbcZgYoH1YkGLygZl2IVeHm8=;
        b=ng63oiYipel8hwEZwWLouT5TczgvUVAEZ8oBzTGhlEKuCP54QOWEWkcoLtJuzFWDT+
         pKGPB4fK8IqltKo/l3LIHY2lMt5Hh4gqdunWkG6w9WEZsBhKrGCH+OYIwKm7AJsZBqaJ
         bNlU7opjO5MgEaw37xEAPIaK4f7kxqLP29HakVwR9pXbscjfJCfATCz844KILOYDjmXe
         voGq60OH7KYmhS9AfQYHsOH3GxZMnn1rD9lfPeb4DqXlcRn2uHCkL7S4GcAlmlqOLV+/
         MUppQQ5qtwGOYx/DuUMMTSM0/KuagIh16/cl6kJCA8BSvrLTPNnxQCMrI9BLjNDvifad
         emLw==
X-Gm-Message-State: APjAAAURP0DISx2PEqH12AIc6qRNh8x6tukLJDMPVmGPTgO3cH0jdts2
        vjuK0/0+v7c3ZgiiODjX4ahqex5B
X-Google-Smtp-Source: APXvYqxe4lGTyturJqn3nNzuJM+DNC0J4NMnWd7eBkToZ0EQ0Wew9rXWE7XMSxMEekk23erJlLUpqA==
X-Received: by 2002:ad4:518d:: with SMTP id b13mr2598867qvp.141.1582687472238;
        Tue, 25 Feb 2020 19:24:32 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:e4f3:14fb:fa99:757f? ([2601:282:803:7700:e4f3:14fb:fa99:757f])
        by smtp.googlemail.com with ESMTPSA id x28sm376553qkx.104.2020.02.25.19.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 19:24:31 -0800 (PST)
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
To:     Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com>
Date:   Tue, 25 Feb 2020 20:24:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/20 8:00 PM, Jason Wang wrote:
> 
> On 2020/2/26 上午8:57, David Ahern wrote:
>> From: David Ahern <dahern@digitalocean.com>
>>
>> virtio_net currently requires extra queues to install an XDP program,
>> with the rule being twice as many queues as vcpus. From a host
>> perspective this means the VM needs to have 2*vcpus vhost threads
>> for each guest NIC for which XDP is to be allowed. For example, a
>> 16 vcpu VM with 2 tap devices needs 64 vhost threads.
>>
>> The extra queues are only needed in case an XDP program wants to
>> return XDP_TX. XDP_PASS, XDP_DROP and XDP_REDIRECT do not need
>> additional queues. Relax the queue requirement and allow XDP
>> functionality based on resources. If an XDP program is loaded and
>> there are insufficient queues, then return a warning to the user
>> and if a program returns XDP_TX just drop the packet. This allows
>> the use of the rest of the XDP functionality to work without
>> putting an unreasonable burden on the host.
>>
>> Cc: Jason Wang <jasowang@redhat.com>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: David Ahern <dahern@digitalocean.com>
>> ---
>>   drivers/net/virtio_net.c | 14 ++++++++++----
>>   1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 2fe7a3188282..2f4c5b2e674d 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -190,6 +190,8 @@ struct virtnet_info {
>>       /* # of XDP queue pairs currently used by the driver */
>>       u16 xdp_queue_pairs;
>>   +    bool can_do_xdp_tx;
>> +
>>       /* I like... big packets and I cannot lie! */
>>       bool big_packets;
>>   @@ -697,6 +699,8 @@ static struct sk_buff *receive_small(struct
>> net_device *dev,
>>               len = xdp.data_end - xdp.data;
>>               break;
>>           case XDP_TX:
>> +            if (!vi->can_do_xdp_tx)
>> +                goto err_xdp;
> 
> 
> I wonder if using spinlock to synchronize XDP_TX is better than dropping
> here?

I recall you suggesting that. Sure, it makes for a friendlier user
experience, but if a spinlock makes this slower then it goes against the
core idea of XDP.


> 
> Thanks
> 
> 
>>               stats->xdp_tx++;
>>               xdpf = convert_to_xdp_frame(&xdp);
>>               if (unlikely(!xdpf))
>> @@ -870,6 +874,8 @@ static struct sk_buff *receive_mergeable(struct
>> net_device *dev,
>>               }
>>               break;
>>           case XDP_TX:
>> +            if (!vi->can_do_xdp_tx)
>> +                goto err_xdp;
>>               stats->xdp_tx++;
>>               xdpf = convert_to_xdp_frame(&xdp);
>>               if (unlikely(!xdpf))
>> @@ -2435,10 +2441,10 @@ static int virtnet_xdp_set(struct net_device
>> *dev, struct bpf_prog *prog,
>>         /* XDP requires extra queues for XDP_TX */
>>       if (curr_qp + xdp_qp > vi->max_queue_pairs) {
>> -        NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
>> -        netdev_warn(dev, "request %i queues but max is %i\n",
>> -                curr_qp + xdp_qp, vi->max_queue_pairs);
>> -        return -ENOMEM;
>> +        NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available;
>> XDP_TX will not be allowed");
>> +        vi->can_do_xdp_tx = false;
>> +    } else {
>> +        vi->can_do_xdp_tx = true;
>>       }
>>         old_prog = rtnl_dereference(vi->rq[0].xdp_prog);
> 

