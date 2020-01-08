Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBDD134FF5
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgAHXTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:19:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45976 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgAHXTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 18:19:23 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so5244157wrj.12
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 15:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=YiIMBH8tUbzHj7giy/GuF5wME+zFSGoUZHPXrPEn/yM=;
        b=c97r27l8y5DlrJisO05/Gq8y9tOri3T5FgAMB8SjH4XStFLFPaMc8XBTtp3aWBIWgS
         rcQrjNp6E06yh7CpHrCHubvPiK6VB1FJoAQLjPu0fh966e2jSj1FjTOIThW2S1nawwai
         kr5cG24YZWBozowfO4ba6YauTvKSdYwYca7xXTxkkMzOOPnrIKzPDMhs41zVJGQuA876
         Co4gb+3k10S5uU5M2nAHcy3/qHzgtl6no1cU7BL3M1yYeuCkktIIFy+pmRAVgb/a0aja
         3Gng7Hm8ayzc5/yIgAzc36FnnWzDb86klpdLAEYeAR2hQ70BgJFQFegEnq6Sz0gpOgyg
         8t5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YiIMBH8tUbzHj7giy/GuF5wME+zFSGoUZHPXrPEn/yM=;
        b=jcGoDxf/IjMJwV/YyZwLzq4hQewoluvN+iiJz4X6sRO9nSnvz4rKzeW/0LfZBbbAeG
         ItMuyQHJGewPkZsXwoUl0QhNV4YF3u9GiStPcKepD3SOFnmZp/14jj3IM5RzWb8GdfP9
         +m2J0XvvsbIeiG263NT++VZojqi+4M/8sxHr05QddLMRdSfnVl4uf7KdCim9Sg7wlzQi
         c//uLuH6dKKSlyTBiXyQibOVvOZ6nlUaM2L7bS4emhJ1AR9jbSiVs11XxAhVgqkP+fAf
         kuVwHhKKUrmG9hLnFiFyeuAnNcN9+U2Wez/qAY7kDkMetEdFKLmxeiU3UyWVSBxI6x+m
         G+jw==
X-Gm-Message-State: APjAAAUM1gtES1Bj/CHzRRFDZsp3Zl6ytfogSmEiK3pOM9W96sR/tt7G
        zuR5ynGfx+vsAGIrh4A7W4rQU+GCwT8W6Q==
X-Google-Smtp-Source: APXvYqz8rw+XvLiotsVRtdDJ2Nm4e5+K1KaWP2M6iYiYOOs9xTswHtubpWBB2nhtXWycePCN7XqUOg==
X-Received: by 2002:adf:fd87:: with SMTP id d7mr7275198wrr.226.1578525560682;
        Wed, 08 Jan 2020 15:19:20 -0800 (PST)
Received: from xps13.intranet.net (82-64-122-65.subs.proxad.net. [82.64.122.65])
        by smtp.googlemail.com with ESMTPSA id c17sm5864166wrr.87.2020.01.08.15.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 15:19:19 -0800 (PST)
Subject: Re: [PATCH net] net: usb: lan78xx: fix possible skb leak
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
References: <20200107185701.137063-1-edumazet@google.com>
 <393ec56d-5d37-ac75-13af-25ade6aabac8@gmail.com>
 <CANn89iKD6DSnz-QdBMYgm=1N2V7UZpCD3TiB+yTO_tGu7XKReg@mail.gmail.com>
From:   RENARD Pierre-Francois <pfrenard@gmail.com>
Message-ID: <870db5aa-d1b3-1466-c5f5-c6d84e250411@gmail.com>
Date:   Thu, 9 Jan 2020 00:19:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CANn89iKD6DSnz-QdBMYgm=1N2V7UZpCD3TiB+yTO_tGu7XKReg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OK

Before scp command ( and after a fresh reboot)
---------------------------------
skbuff_ext_cache     378    378    192   21    1 : tunables 0    0    0 
: slabdata     18     18      0
skbuff_fclone_cache    112    112    512   16    2 : tunables 0    0    
0 : slabdata      7      7      0
skbuff_head_cache   1936   2160    256   16    1 : tunables 0    0    0 
: slabdata    135    135      0
---------------------------------
---------------------------------

After the hang of scp (hanged at 203 MB)
---------------------------------
skbuff_ext_cache     693    693    192   21    1 : tunables 0    0    0 
: slabdata     33     33      0
skbuff_fclone_cache    128    128    512   16    2 : tunables 0    0    
0 : slabdata      8      8      0
skbuff_head_cache   2032   2176    256   16    1 : tunables 0    0    0 
: slabdata    136    136      0
---------------------------------
TcpExtTCPSpuriousRtxHostQueues 120                0.0
---------------------------------

After CTRL-C of scp
---------------------------------
skbuff_ext_cache     693    693    192   21    1 : tunables 0    0    0 
: slabdata     33     33      0
skbuff_fclone_cache    128    128    512   16    2 : tunables 0    0    
0 : slabdata      8      8      0
skbuff_head_cache   2112   2336    256   16    1 : tunables 0    0    0 
: slabdata    146    146      0
---------------------------------
TcpExtTCPSpuriousRtxHostQueues  124                0.0
---------------------------------



After the hang of a second attempt (hanged at 1214 MB)
---------------------------------
skbuff_ext_cache     735    735    192   21    1 : tunables 0    0    0 
: slabdata     35     35      0
skbuff_fclone_cache    160    160    512   16    2 : tunables 0    0    
0 : slabdata     10     10      0
skbuff_head_cache   2096   2240    256   16    1 : tunables 0    0    0 
: slabdata    140    140      0
---------------------------------
TcpExtTCPSpuriousRtxHostQueues  248                0.0
---------------------------------


After a third attempt (hanged at 55 MB)
---------------------------------
skbuff_ext_cache     735    735    192   21    1 : tunables 0    0    0 
: slabdata     35     35      0
skbuff_fclone_cache    176    176    512   16    2 : tunables 0    0    
0 : slabdata     11     11      0
skbuff_head_cache   2000   2144    256   16    1 : tunables 0    0    0 
: slabdata    134    134      0
---------------------------------
TcpExtTCPSpuriousRtxHostQueues  365                0.0
---------------------------------








On 1/8/20 9:25 PM, Eric Dumazet wrote:
> On Wed, Jan 8, 2020 at 11:13 AM RENARD Pierre-Francois
> <pfrenard@gmail.com> wrote:
>> I tried with last rawhide kernel 5.5.0-0.rc5.git0.1.local.fc32.aarch64
>> I compiled it this night. (I check it includes the patch for lan78xx.c )
>>
>> Both tests (scp and nfs ) are failing the same way as before.
>>
>> Fox
>>
> Please report the output of " grep skb /proc/slabinfo"
>
> before and after your test.
>
> The symptoms (of retransmit being not attempted by TCP) match the fact
> that skb(s) is(are) not freed by a driver (or some layer)
>
> When TCP detects this (function skb_still_in_host_queue()), one SNMP
> counter is incremented
>
> nstat -a | grep TCPSpuriousRtxHostQueues
>
> Thanks.
>
>>
>> On 1/7/20 7:57 PM, Eric Dumazet wrote:
>>> If skb_linearize() fails, we need to free the skb.
>>>
>>> TSO makes skb bigger, and this bug might be the reason
>>> Raspberry Pi 3B+ users had to disable TSO.
>>>
>>> Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>> Reported-by: RENARD Pierre-Francois <pfrenard@gmail.com>
>>> Cc: Stefan Wahren <stefan.wahren@i2se.com>
>>> Cc: Woojung Huh <woojung.huh@microchip.com>
>>> Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
>>> ---
>>>    drivers/net/usb/lan78xx.c | 9 +++------
>>>    1 file changed, 3 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
>>> index f940dc6485e56a7e8f905082ce920f5dd83232b0..fb4781080d6dec2af22f41c5e064350ea74130b3 100644
>>> --- a/drivers/net/usb/lan78xx.c
>>> +++ b/drivers/net/usb/lan78xx.c
>>> @@ -2724,11 +2724,6 @@ static int lan78xx_stop(struct net_device *net)
>>>        return 0;
>>>    }
>>>
>>> -static int lan78xx_linearize(struct sk_buff *skb)
>>> -{
>>> -     return skb_linearize(skb);
>>> -}
>>> -
>>>    static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
>>>                                       struct sk_buff *skb, gfp_t flags)
>>>    {
>>> @@ -2740,8 +2735,10 @@ static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
>>>                return NULL;
>>>        }
>>>
>>> -     if (lan78xx_linearize(skb) < 0)
>>> +     if (skb_linearize(skb)) {
>>> +             dev_kfree_skb_any(skb);
>>>                return NULL;
>>> +     }
>>>
>>>        tx_cmd_a = (u32)(skb->len & TX_CMD_A_LEN_MASK_) | TX_CMD_A_FCS_;
>>>
>>

