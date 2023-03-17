Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E186BEEA5
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjCQQl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjCQQlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:41:21 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9211460AA9;
        Fri, 17 Mar 2023 09:41:16 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id qh28so3812627qvb.7;
        Fri, 17 Mar 2023 09:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679071275;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RKtQIRPTwx0sjr8pGOmT1wJdjg4XTo56N2gmOoM0cQE=;
        b=mpFH2R3iwl/5weOznwPmrfYIB3IMeeGaWAe3u1D8LZnVlZfs158KVgjivJf9x/dYEV
         Z7qLgzttajKSLyFKy4OGQh0sLSqbTVxi22JMCwQHoNt1PtKF7Ksto/JzCBlIfrAcM6fM
         MJyNMdrHwU0Z/E85tc127AmF6/5V49bx1F0rBPG+b+gvHObnsz/zBlgCPl/ZJnoiei3S
         gVeBMukfQsFZnwUtCy7QDrY+nvw6vAMLLGgCZF6lHEaPAAvXERRS10GN+a9LNFH8bbIk
         MhiiCJYJ5XcIVZWkJY/D+IW1/YfnhQ/0D4z5WC939YgUcwFH42foRjPWVfE41HWp3d9n
         6gVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679071275;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RKtQIRPTwx0sjr8pGOmT1wJdjg4XTo56N2gmOoM0cQE=;
        b=xnlYfW25UUNL97na+qZMkn0UOPf46eujrm3sDMCfA8TlPFTfI45oSaIfgtFK1TwjpC
         hOUfdbhYDwD+DHmKLDVOxNNyyNXYQQx9v3dELRNITBdv3N/5cMi5WLuhGenLCtAen32s
         9KApf33eZDvWLXPYi/cyfKsiNiFujcBMurzhKyKWnqJMkVaVoNDlaxjw+U4JS7MGNjSV
         W4LneRZ8V44Gkkx5IhvWts6+oQRiJkPAkZGdHxmzlM0P6k6tp9WPynic/mEixcuJyuTI
         57Xdx04TCHgMSSDdpxGOkY/N+kc2jDLqNnLQqzaP6bB55ge+LTU7Jng4Gz9oQKvTK0IG
         hM8Q==
X-Gm-Message-State: AO0yUKViP4eqVd9onpY/vgpVaWI+MKi68ns/j3/69w3slo9e5Iicw3jm
        07odv/gDEqxa3P49VjsJRQk=
X-Google-Smtp-Source: AK7set8qhSkoqA6JPQF41q0sUDm8QYqqO6beBxjyOlXzmdhBQTAnWXCadxY8XoFDjWtZjgmB5du0Fw==
X-Received: by 2002:ad4:5cc7:0:b0:5a3:6ff8:9d2e with SMTP id iu7-20020ad45cc7000000b005a36ff89d2emr42878931qvb.37.1679071275642;
        Fri, 17 Mar 2023 09:41:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e24-20020ac845d8000000b003c033b23a9asm1776567qto.12.2023.03.17.09.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 09:41:14 -0700 (PDT)
Message-ID: <4d669474-59b6-b0e9-09cb-8278734fa3a2@gmail.com>
Date:   Fri, 17 Mar 2023 09:41:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 2/3] net: dsa: b53: mmap: register MDIO Mux bus controller
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, jonas.gorski@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230317113427.302162-1-noltari@gmail.com>
 <20230317113427.302162-3-noltari@gmail.com>
 <20230317115115.s32r52rz3svuj4ed@skbuf>
 <CAKR-sGe3xHkN-1+aLn0ixnskctPK4GTzfXu8O_dkFhHyY1nTeg@mail.gmail.com>
 <20230317130434.7cbzk5gxx5guarcz@skbuf>
 <CAKR-sGeFZLnuqH=4Gok1URJEvrQKxbk203Q8zdMd9830G_XD7A@mail.gmail.com>
 <20230317142919.hhjd64juws35j47o@skbuf>
 <CAKR-sGc7u346XqoihOuDse3q=d8HG6er3H6R1NCm_pQeNW7edA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAKR-sGc7u346XqoihOuDse3q=d8HG6er3H6R1NCm_pQeNW7edA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/23 09:23, Álvaro Fernández Rojas wrote:
> El vie, 17 mar 2023 a las 15:29, Vladimir Oltean (<olteanv@gmail.com>) escribió:
>>
>> On Fri, Mar 17, 2023 at 03:17:12PM +0100, Álvaro Fernández Rojas wrote:
>>>> The proposed solution is too radical for a problem that was not properly
>>>> characterized yet, so this patch set has my temporary NACK.
>>>
>>> Forgive me, but why do you consider this solution too radical?
>>
>> Because it involves changing device tree bindings (stable ABI) in an
>> incompatible way.
>>
>>>>
>>>>> But maybe Florian or Jonas can give some more details about the issue...
>>>>
>>>> I think you also have the tools necessary to investigate this further.
>>>> We need to know what resource belonging to the switch is it that the
>>>> MDIO mux needs. Where is the earliest place you can add the call to
>>>> b53_mmap_mdiomux_init() such that your board works reliably? Note that
>>>> b53_switch_register() indirectly calls b53_setup(). By placing this
>>>> function where you have, the entirety of b53_setup() has finished
>>>> execution, and we don't know exactly what is it from there that is
>>>> needed.
>>>
>>> In the following link you will find different bootlogs related to
>>> different scenarios all of them with the same result: any attempt of
>>> calling b53_mmap_mdiomux_init() earlier than b53_switch_register()
>>> will either result in a kernel panic or a device hang:
>>> https://gist.github.com/Noltari/b0bd6d5211160ac7bf349d998d21e7f7
>>>
>>> 1. before b53_switch_register():
>>>
>>> 2. before dsa_register_switch():
>>>
>>> 3. before b53_switch_init():
>>
>> Did you read what I said?
> 
> Yes, but I didn't get your point, sorry for that.
> 
>>
>> | Note that b53_switch_register() indirectly calls b53_setup(). By placing
>> | this function where you have, the entirety of b53_setup() has finished
>> | execution, and we don't know exactly what is it from there that is
>> | needed.
>>
>> Can you place the b53_mmap_mdiomux_init() in various places within
>> b53_setup() to restrict the search further?
> 
> I tried and these are the results:
> https://gist.github.com/Noltari/d5bdba66b8f2e392c9e4c2759661d862
> 
> All of them hang when dsa_tree_setup() is called for DSA tree 1
> (external switch) without having completely setup DSA tree 0 (internal
> switch):
> [ 1.471345] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
> [ 1.481099] bcm6368-enetsw 1000d800.ethernet: IRQ tx not found
> [ 1.506752] bcm6368-enetsw 1000d800.ethernet: mtd mac 4c:60:de:86:52:12
> [ 1.594365] bcm7038-wdt 1000005c.watchdog: Registered BCM7038 Watchdog
> [ 1.612008] NET: Registered PF_INET6 protocol family
> [ 1.645617] Segment Routing with IPv6
> [ 1.649547] In-situ OAM (IOAM) with IPv6
> [ 1.653948] NET: Registered PF_PACKET protocol family
> [ 1.659984] 8021q: 802.1Q VLAN Support v1.8
> [ 1.699193] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
> [ 2.124257] bcm53xx 0.1:1e: found switch: BCM53125, rev 4
> *** Device hang ***
> 
> I don't know if there's a way to defer the probe of DSA tree 1 (the
> external switch) until DSA tree 0 (the internal switch) is completely
> setup, because that would probably be the only alternative way of
> fixing this.

Could you find out which part is hanging? It looks like there is a busy 
waiting operation that we never complete?

DSA should be perfectly capable of dealing with disjoint trees being 
cascaded to one another, as this is entirely within how the framework is 
designed.

What I suspect might be happening is a "double programming" effect, 
similar or identical to what was described in this commit:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b8c6cd1d316f3b01ae578d8e29179f6396c0eaa2

using the MDIO mux would properly isolate the pseudo PHYs of the switch 
such that a given MDIO write does not end up programming *both* the 
internal and external switches. It could also be a completely different 
problem.
-- 
Florian

