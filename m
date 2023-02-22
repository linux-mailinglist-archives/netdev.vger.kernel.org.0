Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8503A69FF37
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 00:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjBVXGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 18:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbjBVXF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 18:05:56 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F1810DC;
        Wed, 22 Feb 2023 15:05:41 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so2266610pja.5;
        Wed, 22 Feb 2023 15:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g83jne5NK1f0qNOF01NVxxsHPtsUTkk2wA9mvIvUV5k=;
        b=gUcb+7htnezEcBl2QOEozOewRHhPrnj0VnkJZegj3sqdvAuGX6Agtx50WNf/3PHnQn
         n3czPCVcfxc0qAHe/oZXiOeOoLXV4ZAsNtfXtj3kIur15QH+7eU7CbTC7FjH9EQnD3vX
         1QsIJAiYe65gBgK1zkoYYMEwnS+J2JS1mEEq8xbB7B4TAUFCKvAL0O7dBqmcqLgenjiG
         49+3cCZwL+I8AmZ/LaeafksGXz4vXpnx7w63qkS0EzPjUwP0nf/K3d4N5eIpirqXuhQl
         TphsFrmP2Y6pyrtUA89xR42ENjUP/zErWkHisKJoqZGU+hR5GiWJY53cebUSSD8DfLau
         ZrYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g83jne5NK1f0qNOF01NVxxsHPtsUTkk2wA9mvIvUV5k=;
        b=wwLxHwxysnxI13Ou0PLql+T8r7EJkP/UwYs/1mcye7qc2DTy7qV7uy0IOzS9tzBw+G
         hXYaUnW/xmAn2OiOyfpnfC35V6J+DwfUtAOv30R9h2Z+AzoOIoj8vE6d/0OsP+BAVCLo
         8VE7/6I4IBT+3QcQkyb0b0Gbc2/LxTdpkAAZ8M/uitsXwGKejYT+KPizT+C7abqcr1et
         UyYVkr8EJW0dwd7eJaxrKLTYORESZQnnxwZXJuIbtnbRrMnDLaQyiOmQx2JpNrjnv+Ze
         28Y6+kxqqfRWpbt4qZ1zTCqTDMUug0jGZ2CFznByKiZjiA8msmB3ZhnlUm1ulXV5B9L1
         yDnw==
X-Gm-Message-State: AO0yUKUIwYDI2tD3gdyiU+Gy4blBzmsrVIzAdrzp8GBKpMv/RrZvycK/
        QsuSWwL4D2qC3vn1vrkogdJhp3p0Nx0RhA==
X-Google-Smtp-Source: AK7set+WyKQF/NraLe9XINTZqVkrBoP/Ar9J4a1eOuUJfhVfT6cMEC0dqjLSTrUWCKb1lE+XmKstPg==
X-Received: by 2002:a17:902:d4c8:b0:199:30a6:376c with SMTP id o8-20020a170902d4c800b0019930a6376cmr10900398plg.68.1677107140771;
        Wed, 22 Feb 2023 15:05:40 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2-20020a170902654200b0019a74841c9bsm3160622pln.192.2023.02.22.15.05.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 15:05:40 -0800 (PST)
Message-ID: <d865c56e-5ad3-71df-d6a9-03f09859347e@gmail.com>
Date:   Wed, 22 Feb 2023 15:05:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: dsa: microchip: Fix gigabit set and get function for
 KSZ87xx
Content-Language: en-US
To:     Marek Vasut <marex@denx.de>, Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>, stable@vger.kernel.org
References: <20230222031738.189025-1-marex@denx.de>
 <20230222210853.pilycwhhwmf7csku@skbuf>
 <ed05fc85-72a8-e694-b829-731f6d720347@denx.de>
 <20230222223141.ozeis33beq5wpkfy@skbuf>
 <9a5c5fa0-c75e-3e60-279c-d6a5f908a298@denx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <9a5c5fa0-c75e-3e60-279c-d6a5f908a298@denx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/23 14:58, Marek Vasut wrote:
> On 2/22/23 23:31, Vladimir Oltean wrote:
>> On Wed, Feb 22, 2023 at 11:05:10PM +0100, Marek Vasut wrote:
>>> On 2/22/23 22:08, Vladimir Oltean wrote:
>>>> Please summarize in the commit title what is the user-visible impact of
>>>> the problem that is being fixed. Short and to the point.
>>>
>>> Can you suggest a Subject which is acceptable ?
>>
>> Nope. The thing is, I don't know what you're seeing, only you do. I can
>> only review and comment if it's plausible or not. I'm sure you can come
>> up with something.
>>
>>>>> Currently, the driver uses PORT read function on register 
>>>>> P_XMII_CTRL_1
>>>>> to access the P_GMII_1GBIT_M, i.e. Is_1Gbps, bit.
>>>>
>>>> Provably false. The driver does do that, but not for KSZ87xx.
>>>
>>> The driver uses port read function with register value 0x56 instead 
>>> of 0x06
>>> , which means the remapping happens twice, which provably breaks the 
>>> driver
>>> since commit Fixes below .
>>
>> The sentence is false in the context of ksz87xx, which is what is the
>> implied context of this patch (see commit title written by yourself).
>> The P_GMII_1GBIT_M field is not accessed, and that is a bug in itself.
>> Also, the (lack of) access to the P_GMII_1GBIT_M field is not what
>> causes the breakage that you see, but to other fields from that register.
>>
>>>> There is no call site other than ksz_set_xmii(). Please delete false
>>>> information from the commit message.
>>>
>>> $ git grep P_XMII_CTRL_1 drivers/net/dsa/microchip/
>>> drivers/net/dsa/microchip/ksz_common.c: [P_XMII_CTRL_1] = 0x06,
>>> drivers/net/dsa/microchip/ksz_common.c: [P_XMII_CTRL_1] = 0x0301,
>>> drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, 
>>> regs[P_XMII_CTRL_1], &data8);
>>> drivers/net/dsa/microchip/ksz_common.c: ksz_pwrite8(dev, port, 
>>> regs[P_XMII_CTRL_1], data8);
>>> drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, 
>>> regs[P_XMII_CTRL_1], &data8);
>>> drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, 
>>> regs[P_XMII_CTRL_1], &data8);
>>> drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, 
>>> regs[P_XMII_CTRL_1], &data8);
>>> drivers/net/dsa/microchip/ksz_common.c: ksz_pwrite8(dev, port, 
>>> regs[P_XMII_CTRL_1], data8);
>>> drivers/net/dsa/microchip/ksz_common.h: P_XMII_CTRL_1,
>>>
>>> I count 6.
>>
>> So your response to 2 reviewers wasting their time to do a detailed
>> analysis of the code paths that apply to the KSZ87xx model in particular,
>> to tell you precisely why your commit message is incorrect is "git grep"?
>>
>>> OK, to make this simple, can you write a commit message which you 
>>> consider
>>> acceptable, to close this discussion ?
>>
>> Nope. The thing is, I'm sure you can, too. Maybe you need to take a
>> break and think about this some more.
> 
> Sorry, not like this and not with this feedback tone.
> 
> If Arun wants to send V2 to fix the actual bug, fine by me.

Seems like we are getting a masterclass in how not communicate, be 
perceived to be rude from contributors, and also lacking the persistence 
to be expected from a contributor, just what we need. Very encouraging.
-- 
Florian

