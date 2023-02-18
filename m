Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29D969BBC2
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 21:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBRURq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 15:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBRURp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 15:17:45 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066BF144B4
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 12:17:45 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id a20so1611861pls.2
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 12:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S0LIqxJpIJ/NqEdu7NOq/baKiibfBZFy4nFa4XSSff8=;
        b=ODZhio4igIAsXmEkA34y7KE4ves5+2UgT9XvijzLDuJwUQyaB5ct7SSXl3dzOWYE+t
         UM7onDKE2PvDBFD4mpjO3mHU9B5g6ipUu0afBzOYDbsVhCoxowq4G6qH8mwHQNq/kfGb
         3sjYonu6NZkw+gHgFQEs2tqVxPgftK/pqOAlQ+34kRL4BdbCRrxIxf9b8nRqSGk1t+IV
         kq3C0sp5uuiWadWpaBlY15ylvdbOfLe5wAowHtygz6fPfK7UsAekA+W8Ss7s53U7pT2F
         4cyxNcx1Vlkn9GUkHiZDXls5rAuEz0Yyd9E4kKHdOx8XKN+9xanadWEmqrbBpVd2q6cp
         Sctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S0LIqxJpIJ/NqEdu7NOq/baKiibfBZFy4nFa4XSSff8=;
        b=CUcjn8H1wv4aWe31frb4T5Pa5si8STy+SzuUiMfXlT5dwM6aAmQ5s4IMxQyc3Qi152
         1anPEj+6W2TfGkR0p6HWZN5ObhklkIZ+py2GZGaEWrjw1zmtz0Yen95rXxbeHjqIDqYa
         NI2wFu6zqAEXoRDZqH7CAo6YwlldECTjDJbVRyh9Mts6W0wRjAx+dHXiKghjzkdf7Jn9
         xlRkc2nrZLg+2zDchSMSB9iXHoirUpG1Q3rixlhtpPdLfVdO9hxkZa2eVfyUDmz1NtS4
         F6TGeNgpw9sQG+QNf4LPMmwwf6fv3lIWItlO9yr8AjIN4TbxSQ5V1oiPXBknE3G5Twc+
         SeMA==
X-Gm-Message-State: AO0yUKUsPfOFfB1pyTlcvLvh3STU1nTZp/HeQrM81TWhoaMBqlbur5Ua
        Y3RKBw5DZqZPeQUg33AxOqo=
X-Google-Smtp-Source: AK7set/vSyHs1F1Jb5czzgUninpXTRyb0TFEX79sIGxaVDN1GLv8VW0fral0U3dcMsc/luQV71NjaQ==
X-Received: by 2002:a05:6a21:78a0:b0:c7:73de:5aa7 with SMTP id bf32-20020a056a2178a000b000c773de5aa7mr8537083pzc.43.1676751464392;
        Sat, 18 Feb 2023 12:17:44 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:196e:1505:10e5:1fe6? ([2600:8802:b00:4a48:196e:1505:10e5:1fe6])
        by smtp.gmail.com with ESMTPSA id k133-20020a633d8b000000b004fb8732a2f9sm4564378pga.88.2023.02.18.12.17.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Feb 2023 12:17:43 -0800 (PST)
Message-ID: <02eaa2ca-d788-c98f-e23f-8ab71a161104@gmail.com>
Date:   Sat, 18 Feb 2023 12:17:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Choose a default DSA CPU port
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com
References: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/18/2023 9:07 AM, Arınç ÜNAL wrote:
> Hey there folks,
> 
> The problem is this. Frank and I have got a Bananapi BPI-R2 with MT7623 
> SoC. The port5 of MT7530 switch is wired to gmac1 of the SoC. Port6 is 
> wired to gmac0. Since DSA sets the first CPU port it finds on the 
> devicetree, port5 becomes the CPU port for all DSA slaves.
> 
> But we'd prefer port6 since it uses trgmii while port5 uses rgmii. There 
> are also some performance issues with the port5 - gmac1 link.
> 
> Now we could change it manually on userspace if the DSA subdriver 
> supported changing the DSA master.
> 
> I'd like to find a solution which would work for the cases of; the 
> driver not supporting changing the DSA master, or saving the effort of 
> manually changing it on userspace.

Changing the assignment is a policy, and policies reside in user-space, 
most of the time. What is inconvenient with doing this in user-space? 
Assuming you are going to do this in an OpenWrt context, this seems 
fairly easy to have /etc/config/network result into the right set of 
calls to configure the switch, would not it?

> 
> The solution that came to my mind:
> 
> Introduce a DT property to designate a CPU port as the default CPU port.
> If this property exists on a CPU port, that port becomes the CPU port 
> for all DSA slaves.
> If it doesn't exist, fallback to the first-found-cpu-port method.
> 
> Frank doesn't like this idea:
> 
>  > maybe define the default cpu in driver which gets picked up by core 
> (define port6 as default if available).
>  > Imho additional dts-propperty is wrong approch...it should be handled 
> by driver. But cpu-port-selection is currently done in dsa-core which 
> makes it a bit difficult.
> 
> What are your thoughts?

I agree with Frank for the reasons that this is akin to encoding a 
policy in the Device Tree which is not what Device Tree is for. There is 
already Richard working on adding support for changing the DSA master:

https://lore.kernel.org/all/20230211184101.651462-1-richard@routerhints.com/
-- 
Florian
