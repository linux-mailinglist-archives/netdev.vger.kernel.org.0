Return-Path: <netdev+bounces-1652-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F5F6FE9E3
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:45:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 630CF1C20EBC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229221643B;
	Thu, 11 May 2023 02:45:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149F0EC9
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:45:42 +0000 (UTC)
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93194C0D;
	Wed, 10 May 2023 19:45:40 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-39431e2b2cdso817583b6e.3;
        Wed, 10 May 2023 19:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683773140; x=1686365140;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=1rVAcfYHatzHlN2VVCLFgi47fHp8lJNnw2nLmoxn86I=;
        b=btCVg2FXZlWmBbNgrtAiiOaCW+GQ+ly8JVo8OWzhw51Ji8yfZ5A+OjtmRj2bgGKREL
         qD9u39dV8zuBgdft7D4N3Y99oI0QUvFQy4BEOBLKXNVMvNv+4FwA43mDMtbOfz5RVOCB
         oz8gf5iynbpeASKciZZ3KBfjrX2UhDtzYf9QljoTQqI6NyuNx1k/kYjX4Guk1OFOGAP+
         RhEEdRkW5CXnYuWnDhOwM+ZlGpQ4eezJ7UT5zUNEH+btgAeNcoAULn0qtwynCnuNxkzc
         kdxea4cfzzo8+4MUqjTfAzbHMwhWZnLY1fEifxM3P/FQ7INwL7VvsF3fz3VEdacahwT6
         FKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683773140; x=1686365140;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1rVAcfYHatzHlN2VVCLFgi47fHp8lJNnw2nLmoxn86I=;
        b=LK6MyzWMolJQSsnFgCnt4I6TYqxdoQHp2vdwjTJGq40YtsYN1k7iJ56cvv2JPGn80z
         jWZMkGFDfxgNUhUwGTwzLPCs70RsZt3ip6UUSWk720D/slUTCkX4/gPCk2RsuyzjWpzm
         1h0FW/f7+WNeCcW6L+dxcJb8Vlk2wnLrU5WAmM1U5B+YE5c4BvD2J7q5tG2f+abNUr9t
         GgpGJnaqEkRgT0n4vFjrsmt97DII/zUOmA3rtenYRjmBxG+mPjNWCNPp5PJED3troF8T
         5gq/6j901P9k2cwm14kKrKUPnDsU9KPT/YLjdSNuxWU1ioAcWETp8j5BblhzFwWJRlHG
         o42Q==
X-Gm-Message-State: AC+VfDzA8yr+3EsW3MLQD5Rzsf2kxlQwPG9Tyuk5XX7tAOMGAQ01EyH9
	VOPFN1WJbbyBHlSKDRqsd6sbz3Z9WGY=
X-Google-Smtp-Source: ACHHUZ6gdqhSA/R49jhIHEru5eSRBNgmsMatF8hKx8Ebx0ROrMHnHBiJDZlx6G74ePlyuh61Cbt3Aw==
X-Received: by 2002:aca:d19:0:b0:38b:eb6b:315f with SMTP id 25-20020aca0d19000000b0038beb6b315fmr3848087oin.41.1683773139978;
        Wed, 10 May 2023 19:45:39 -0700 (PDT)
Received: from [10.62.118.118] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id w14-20020a4ac18e000000b00541854ce607sm6789223oop.28.2023.05.10.19.45.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 19:45:39 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <c21206d6-eb4b-2e7d-eb2e-cab9f3b06c62@lwfinger.net>
Date: Wed, 10 May 2023 21:45:37 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH] wifi: rtl8xxxu: fix authentication timeout due to
 incorrect RCR value
Content-Language: en-US
To: Yun Lu <luyun_611@163.com>, Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Jes.Sorensen@gmail.com, kvalo@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20230427020512.1221062-1-luyun_611@163.com>
 <866570c9-38d8-1006-4721-77e2945170b9@lwfinger.net>
 <76a784b2.2cb3.187c60f0f68.Coremail.luyun_611@163.com>
 <d3743b66-23b1-011c-9dcd-c408b1963fca@lwfinger.net>
 <62d9fe90.63b.187cb1481f8.Coremail.luyun_611@163.com>
 <794ab671-43a3-7548-13f0-4b289f07425f@gmail.com>
 <75c2fe43.3e15.187e5b4182f.Coremail.luyun_611@163.com>
 <4856a7f8.1909.18808a46ab6.Coremail.luyun_611@163.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <4856a7f8.1909.18808a46ab6.Coremail.luyun_611@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/10/23 21:29, Yun Lu wrote:
> Larry  and  Bitterblue:
> 
> Thank you for your reply,  are there any further questions or suggestions on this issue?
> Could this patch be merged? There seems to be no other side effects.
> 
> 
> 
> 在 2023-05-04 15:39:57，"Yun Lu" <luyun_611@163.com> 写道：
>>
>> 在 2023-04-30 18:36:50，"Bitterblue Smith" <rtl8821cerfe2@gmail.com> 写道：
>>> On 29/04/2023 06:35, Yun Lu wrote:
>>>> At 2023-04-29 01:06:03, "Larry Finger" <Larry.Finger@lwfinger.net> wrote:
>>>>> On 4/27/23 23:11, wo wrote:
>>>>>> [  149.595642] [pid:7,cpu6,kworker/u16:0,0]BEFORE: REG_RCR differs from regrcr:
>>>>>> 0x1830613 insted of 0x7000604e
>>>>>> [  160.676422] [pid:237,cpu6,kworker/u16:5,3]BEFORE: REG_RCR differs from
>>>>>> regrcr: 0x70006009 insted of 0x700060ce
>>>>>> [  327.234588] [pid:7,cpu7,kworker/u16:0,5]BEFORE: REG_RCR differs from
>>>>> regrcr: 0x1830d33 insted of 0x7000604e
>>>>>
>>>>>
>>>>> My patch was messed up, but it got the information that I wanted, which is shown
>>>>> in the quoted lines above. One of these differs only in the low-order byte,
>>>>> while the other 2 are completely different. Strange!
>>>>>
>>>>> It is possible that there is a firmware error. My system, which does not show
>>>>> the problem, reports the following:
>>>>>
>>>>> [54130.741148] usb 3-6: RTL8192CU rev A (TSMC) romver 0, 2T2R, TX queues 2,
>>>>> WiFi=1, BT=0, GPS=0, HI PA=0
>>>>> [54130.741153] usb 3-6: RTL8192CU MAC: xx:xx:xx:xx:xx:xx
>>>>> [54130.741155] usb 3-6: rtl8xxxu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
>>>>> [54130.742301] usb 3-6: Firmware revision 88.2 (signature 0x88c1)
>>>>>
>>>>> Which firmware does your unit use?
>>>>
>>>> The firmware verion we used is 80.0 (signature 0x88c1)
>>>>   [  903.873107] [pid:14,cpu0,kworker/0:1,2]usb 1-1.2: RTL8192CU rev A (TSMC) 2T2R, TX queues 2, WiFi=1, BT=0, GPS=0, HI PA=0
>>>> [  903.873138] [pid:14,cpu0,kworker/0:1,3]usb 1-1.2: RTL8192CU MAC: 08:be:xx:xx:xx:xx
>>>> [  903.873138] [pid:14,cpu0,kworker/0:1,4]usb 1-1.2: rtl8xxxu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
>>>> [  903.873474] [pid:14,cpu0,kworker/0:1,5]usb 1-1.2: Firmware revision 80.0 (signature 0x88c1)
>>>>
>>>>>
>>>>> Attached is a new test patch. When it logs a CORRUPTED value, I would like to
>>>>> know what task is attached to the pid listed in the message. Note that the two
>>>>> instances where the entire word was wrong came from pid:7.
>>>>>
>>>>> Could improper locking could produce these results?
>>>>>
>>>>> Larry
>>>>
>>>> Apply your new patch, then turn on/off the wireless network switch on the network control panel serverl loops.
>>>> The log shows:
>>>> [   85.384429] [pid:221,cpu6,kworker/u16:6,5]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x70006009 insted of 0x700060ce
>>>> [  121.681976] [pid:216,cpu6,kworker/u16:3,0]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x70006009 insted of 0x700060ce
>>>> [  144.416992] [pid:217,cpu6,kworker/u16:4,1]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x70006009 insted of 0x700060ce
>>>>
>>>> And if we up/down the interface serverl loops as follows:
>>>> ifconfig wlx08bexxxxxx down
>>>> sleep 1
>>>> ifconfig wlx08bexxxxxx up
>>>> sleep 10
>>>> The log shows:
>>>> [  282.112335] [2023:04:29 10:30:34][pid:95,cpu6,kworker/u16:1,3]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x1832e13 insted of 0x7000604e
>>>> [  293.311462] [2023:04:29 10:30:45][pid:217,cpu7,kworker/u16:4,9]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x1830e72 insted of 0x7000604e
>>>> [  304.435089] [2023:04:29 10:30:56][pid:217,cpu6,kworker/u16:4,9]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x1830ed3 insted of 0x7000604e
>>>> [  315.532257] [2023:04:29 10:31:07][pid:95,cpu7,kworker/u16:1,8]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x7000604e insted of 0x7000604e
>>>> [  324.114379] [2023:04:29 10:31:16][pid:221,cpu6,kworker/u16:6,7]REG_RCR corrupted in rtl8xxxu_configure_filter: 0x1832e14 insted of 0x7000604e
>>>>
>>>> We also update the  firmware verion to 88.2, and the test results are the same as above.
>>>>
>>>> Thank you for helping debug this issue, which seems to be related to specific devices.
>>>>
>>>> Yun Lu
>>>>
>>>>
>>>>
>>>>
>>> There was this bug report about phantom MAC addresses with
>>> the RTL8188CUS:
>>> https://lore.kernel.org/linux-wireless/a31d9500-73a3-f890-bebd-d0a4014f87da@reto-schneider.ch/
>>>
>>> See the pcap file. I wonder if it's related?
>>
>> The bug in the link is a high retransmission rate during message transmission, but the problem we encountered is that
>> the nic cannot receive authentication frames, resulting in authentication timeout and inability to connect to WiFi. It seems
>> that these two issues are not related.
>>
>> We also enabled monitor mode and found that the AP has replied to the authentication message, but the nic cannot receive
>> this reply message due to the incorrect RCR register value. Once the RCR register is modified to the correct value,
>> the authentication message can be received normally and the connection to WIFI can be normal.

Yun Lu,

I have no objection to adding this patch. Although it looked a little ad-hoc at 
first, it seems to fix a hardware or firmware error for your device. It 
certainly does no harm other than taking up a bit of memory in the loaded driver.

Resubmit the patch with a new version number, and I will Ack it.

Larry


Larry



