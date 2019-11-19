Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1D9102AEF
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfKSRpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:45:06 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43064 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKSRpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 12:45:05 -0500
Received: by mail-pf1-f196.google.com with SMTP id 3so12518742pfb.10
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 09:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/dqi8wu2isGmv0NfJJEP5mmcuGLHpsjWyrJnti2+ag4=;
        b=WsdkEUH/lmj9b09s8hUdN64fw7jHpmXskRtpDoprxPqRt9unMHmyFeHyFz3t8EbCeq
         EiHY/51hAW7DhEOa566iva2VkeU1AKOnYm6xB62u1WUcZZlA82hYh4kb7QVLd8JFiAwH
         bZ1YI3vRr3Q1Y85Qd9qTHcg7/i+j8ytN1K9E3JVTuRXsNSNFeBq95JNN2/OkrWRn0m7R
         iXOC0n0gqQxrjzUwumBjdF26cF/iqzi2yzN8JwH1B00LJkTH9ixy5Hq2gZyRUNulkG0U
         WMMnl4HQqLNJTKszYQLcp7libFyWrbSFToiF4OOWYlAgIqdKjvbXwZoU6vrp2/18+S8P
         QUYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/dqi8wu2isGmv0NfJJEP5mmcuGLHpsjWyrJnti2+ag4=;
        b=k6BdCcBNLA9+68Tfn46i/JXcphUnGhpOWMOv4RQF94OemcdStGT1/ez1exAcQwMD/i
         kbkFNrjsYyPrDWS+Wke8/H2gibiKF0HSF1WZQA42xZ9POGwhs+2Rwbm6ztpgFnA4a2mD
         LHDkoxSyMyLtNB794XVKyAnhMwSlNijfIbcbuSXj76oHunG2ky9D+UNpErow0WJhCpUz
         /7DgfMdrRYjyYX4XC3XyWwCylqDpvLHXHpIPVipU+OEuY9Dw1va0kRzwlGzzCCLB8OnZ
         wU6n0LTZCqrH3EW3/O9XP22SL8MlS6mUuoE9Fq0mB64YTHUg/rJWBHtC2/w0I3tpFcLD
         TYUA==
X-Gm-Message-State: APjAAAUR+zamplt3LelA2sNh4tRJiH1FnaQgJ1veKTYO9AXhCFFOynMg
        iL0PvSxkUnZGU1D//4CFJc4=
X-Google-Smtp-Source: APXvYqzudq7Xu+pmh5qqPT8HYMZcoPvT7j1g/AfuojKdJcDFMAUKFLZIVw7/7o/Hkmmy8WM/Ukfgpg==
X-Received: by 2002:a62:86cc:: with SMTP id x195mr7251081pfd.199.1574185503698;
        Tue, 19 Nov 2019 09:45:03 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:3071:8113:4ecc:7f4c])
        by smtp.googlemail.com with ESMTPSA id v24sm25741457pfn.53.2019.11.19.09.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 09:45:02 -0800 (PST)
Subject: Re: [PATCH net-next v3 2/2] ipv4: use dst hint for ipv4 list receive
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
References: <cover.1574165644.git.pabeni@redhat.com>
 <f242674de1892d14ed602047c3817cc7212a618d.1574165644.git.pabeni@redhat.com>
 <34b44ddc-046b-a829-62af-7c32d6a0cbbe@gmail.com>
 <f8035cdd76f22d0eef3f3921779cebf0e2033934.camel@redhat.com>
 <6c619ef604e8236f2fc7e08fd2f977137633fbc6.camel@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <08b1245c-4856-4f61-abae-760a70d198d2@gmail.com>
Date:   Tue, 19 Nov 2019 10:45:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6c619ef604e8236f2fc7e08fd2f977137633fbc6.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/19 10:33 AM, Paolo Abeni wrote:
> On Tue, 2019-11-19 at 17:20 +0100, Paolo Abeni wrote:
>> On Tue, 2019-11-19 at 09:00 -0700, David Ahern wrote:
>>> On 11/19/19 7:38 AM, Paolo Abeni wrote:
>>>> @@ -535,11 +550,20 @@ static void ip_sublist_rcv_finish(struct list_head *head)
>>>>  	}
>>>>  }
>>>>  
>>>> +static struct sk_buff *ip_extract_route_hint(struct net *net,
>>>> +					     struct sk_buff *skb, int rt_type)
>>>> +{
>>>> +	if (fib4_has_custom_rules(net) || rt_type != RTN_LOCAL)
>>>
>>> Why the local only limitation for v4 but not v6? Really, why limit this
>>> to LOCAL at all? 
>>
>> The goal here was to simplify as much as possible the ipv4
>> ip_route_use_hint() helper, as its complexity raised some eyebrown.
>>
>> Yes, hints can be used also for forwarding. I'm unsure how much will
>> help, given the daddr contraint. If there is agreement I can re-add it.
> 
> Sorry, I forgot to ask: would you be ok enabling the route hint for
> !RTN_BROADCAST, as in the previous iteration? Covering RTN_BROADCAST
> will add quite a bit of complexity to ip_route_use_hint(), likely with
> no relevant use-case.
> 

It is a trade-off of too many checks which just add overhead to the
packets that can not benefit from re-use. I was trying to understand why
local delivery was given preference.
