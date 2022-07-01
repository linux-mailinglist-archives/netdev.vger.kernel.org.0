Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176ED563170
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 12:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbiGAKdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 06:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbiGAKdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 06:33:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6D3220F76
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 03:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656671612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D9vvNVdwZntnKvurfg1+X4py3l/2siLv6GCS2CIvmXo=;
        b=TQz3bmWD6aI9KEnE6wpLH/cDoPqr3UVQ6an3XvZ8zuLK2aHga2C31M6JwQwOiBqAYcYIn5
        YA1slcV+UeZSyUkCAs76frd2wFKU8N4BrW4GILS2yRoYhc8Z+0pXgUW+nqN5UdQZ7fV5iP
        nkJntPThOLGFRqqy89+1HErn7RPBIgA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-rSKgSrWBMqeCp4nt4tnG_g-1; Fri, 01 Jul 2022 06:33:31 -0400
X-MC-Unique: rSKgSrWBMqeCp4nt4tnG_g-1
Received: by mail-lf1-f71.google.com with SMTP id f29-20020a19dc5d000000b004811c8d1918so954502lfj.2
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 03:33:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=D9vvNVdwZntnKvurfg1+X4py3l/2siLv6GCS2CIvmXo=;
        b=5RL+W57YWsoK4rn9fHsDkxVB9Euub9BIzbwxgH4Btr60934BwT0vl3tIBT6Xt5RYMo
         2H1lmgFhNqxkiHSgwHmrKOPP99TueS7tFkcfQi7/Odsj3oWkoiKPGxtNLGb3PYrtSe1f
         nZw2UhI8tjc7U4QJBzNsaeFsY7QGFlUBbQ2KnmchsS7PjX9stTIE/71SA9xHvQGsEgMW
         zGWhAy9v+tAm3WlveVfB86l1+3/ZQNs/w8pCdEdr1h0qxxSrQibI5uME/MBMtgbDG+w2
         dVjW7XGTi1mhj6i7t6807oigcsR/+GUVSCnx9LVQQizvzBKiG9qIHNPSw0EjRm+TrSxJ
         Y8PA==
X-Gm-Message-State: AJIora/dEUH4UZlyhTS4sV4r+AYvVhZvVYw6Bx1LKDojTm/EE8MIUVE6
        c6kGa6baWPlfUcnQdEWGRYNWLA/rWYLWJyK+7wAMDnthoqZwxyNV73EjJB/qg4kbhq7cx7CeUCe
        u6mHrBZ2gl39EgfHg
X-Received: by 2002:a2e:9355:0:b0:25a:9192:6c47 with SMTP id m21-20020a2e9355000000b0025a91926c47mr7979803ljh.190.1656671608835;
        Fri, 01 Jul 2022 03:33:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vcmteMDZtWRYHA9EU8MCQzoetmEZRfrs252gukrELHV8ZduHrcVh8HsCwabQsh6ZdIkBUQsQ==
X-Received: by 2002:a2e:9355:0:b0:25a:9192:6c47 with SMTP id m21-20020a2e9355000000b0025a91926c47mr7979782ljh.190.1656671608572;
        Fri, 01 Jul 2022 03:33:28 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id h4-20020a05651c124400b0025a968f4ffesm3120080ljh.19.2022.07.01.03.33.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 03:33:27 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <224bc3b2-b63f-d1c8-5f4d-41b367f7b329@redhat.com>
Date:   Fri, 1 Jul 2022 12:33:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Cc:     brouer@redhat.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, song@kernel.org,
        martin.lau@linux.dev, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>, haoluo@google.com,
        jolsa@kernel.org, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Freysteinn Alfredsson <Freysteinn.Alfredsson@kau.se>,
        Toke Hoiland Jorgensen <toke@redhat.com>
Subject: Re: [PATCH bpf] xdp: Fix spurious packet loss in generic XDP TX path
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
References: <20220701094256.1970076-1-johan.almbladh@anyfinetworks.com>
 <CANn89i+FZ7t6F6tA8iFMjAzGmKkK=A+kdFpsm6ioygg5DnwT8g@mail.gmail.com>
In-Reply-To: <CANn89i+FZ7t6F6tA8iFMjAzGmKkK=A+kdFpsm6ioygg5DnwT8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 01/07/2022 11.57, Eric Dumazet wrote:
> On Fri, Jul 1, 2022 at 11:43 AM Johan Almbladh
> <johan.almbladh@anyfinetworks.com> wrote:
>>
>> The byte queue limits (BQL) mechanism is intended to move queuing from
>> the driver to the network stack in order to reduce latency caused by
>> excessive queuing in hardware. However, when transmitting or redirecting
>> a packet with XDP, the qdisc layer is bypassed and there are no
>> additional queues. Since netif_xmit_stopped() also takes BQL limits into
>> account, but without having any alternative queuing, packets are
>> silently dropped.
>>
>> This patch modifies the drop condition to only consider cases when the
>> driver itself cannot accept any more packets. This is analogous to the
>> condition in __dev_direct_xmit(). Dropped packets are also counted on
>> the device.
> 
> This means XDP packets are able to starve other packets going through a qdisc,
> DDOS attacks will be more effective.
> 
> in-driver-XDP use dedicated TX queues, so they do not have this
> starvation issue.

Good point. This happen in XDP-generic path, because XDP share the TX
queue with normal network stack.

> 
> This should be mentioned somewhere I guess.

I want to mention that (even for in-driver-XDP) not having a queuing 
mechanism for XDP redirect is a general problem (and huge foot gun). 
E.g. doing XDP-redirect between interfaces with different link rates 
quickly result in issues.
We have Toke + PhD student (Frey Cc) working[1] on "XDQ" to address this 
generically.  I urge them to look at the code for the push-back 
mechanism that netif_xmit_frozen_or_drv_stopped() and BQL provides and 
somehow integrated XDQ with this...

--Jesper

  [1] https://youtu.be/tthG9LP5GFk

>>
>> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
>> ---
>>   net/core/dev.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index 8e6f22961206..41b5d7ac5ec5 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -4875,10 +4875,12 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
>>          txq = netdev_core_pick_tx(dev, skb, NULL);
>>          cpu = smp_processor_id();
>>          HARD_TX_LOCK(dev, txq, cpu);
>> -       if (!netif_xmit_stopped(txq)) {
>> +       if (!netif_xmit_frozen_or_drv_stopped(txq)) {
>>                  rc = netdev_start_xmit(skb, dev, txq, 0);
>>                  if (dev_xmit_complete(rc))
>>                          free_skb = false;
>> +       } else {
>> +               dev_core_stats_tx_dropped_inc(dev);
>>          }
>>          HARD_TX_UNLOCK(dev, txq);
>>          if (free_skb) {
>> --
>> 2.30.2
>>
> 

