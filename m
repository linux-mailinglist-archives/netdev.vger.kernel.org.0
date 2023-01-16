Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE62666CE89
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbjAPSOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbjAPSNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:13:50 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADB22A984
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 10:00:00 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id j16-20020a05600c1c1000b003d9ef8c274bso18418269wms.0
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 10:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RenzUn74Q9jLsvzuylQRKXoJxyRhnObBO6txqo8PJQw=;
        b=nTHmktnWjCB53s98IML0269XXc7OlCoHYxqlDRaED8SHsneKzvyb1nJXLEfcFmJ4Gu
         eTOUmV8Yl4YdmJwrR6gApDhAuE4scrxS6LXVo6UmhNxLw0mVjzGa2ulRHwmev0coMyJu
         6mtoduX0Q8RcofD/ufYJmOxc4rPH8mi7aZcYMfDGJWWDOvqoopd+TxMhAosxNNt7gIyP
         jIkykpkic01VIxDXxPxJV49P3MCUmZNVEYGkk5lkzB3bA2OTaFs1uBGpJqGnMT0wXkyU
         y46uTpYoeOfcMCXUdGYJx9kk0pAysJvA/Vj5semrVThum3o5pzX2asPowScYBTfC2GZ3
         yXCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RenzUn74Q9jLsvzuylQRKXoJxyRhnObBO6txqo8PJQw=;
        b=ikianJDv4a+rXOKghZhNzV2g7MMDX4kpb7wz6HNg/SYb65kd11Ji83/kJptU7GR0e8
         xED+HOZytQCWIOngwFXSWjeF1RZph5sLIoFmuLlXDk19rv4WpMtYwQcD14kkV8MDxsk7
         vzOofxremRct7pHRQp7cLls8uzhBD/gc6c9oe/JijkW6O6BgrfItAP6QjYlpYasm45SG
         fa9hOteCePTCrILIKvywFaeh0XvNPk9ne87ZkBYtUHu3vGmFBJ4fXcioYbNc5FFBfhsy
         7TS745VoaIByOtSMkJAuEdkOEYx6xlxM5aMJbGTjBCO4t8WR4DzE7RLdPwx4ePP2gQTf
         lgBg==
X-Gm-Message-State: AFqh2kogEcLzgo0k1MAswgHsSSavL/lJ49lBRcVBssoUhZ5KuQ22nMBg
        6ZloyetrG+AihZ32PMI7VrMTYa3MfqA=
X-Google-Smtp-Source: AMrXdXsfZWWnnm2l1eBt+2T80hjWxdmiyd50u4OUTAvUlk8TX1/lPnTum4YrdO4t3WysOourbXWXkA==
X-Received: by 2002:a05:600c:1e19:b0:3da:2ba4:b97 with SMTP id ay25-20020a05600c1e1900b003da2ba40b97mr7788002wmb.19.1673891999346;
        Mon, 16 Jan 2023 09:59:59 -0800 (PST)
Received: from ?IPV6:2a01:c23:c4bc:ff00:1041:a2b8:3c58:ba6d? (dynamic-2a01-0c23-c4bc-ff00-1041-a2b8-3c58-ba6d.c23.pool.telefonica.de. [2a01:c23:c4bc:ff00:1041:a2b8:3c58:ba6d])
        by smtp.googlemail.com with ESMTPSA id l36-20020a05600c1d2400b003d9fb59c16fsm23681776wms.11.2023.01.16.09.59.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 09:59:58 -0800 (PST)
Message-ID: <67a2e465-7a7b-6928-eefd-773c65a9b08d@gmail.com>
Date:   Mon, 16 Jan 2023 18:59:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net] r8169: fix rtl8168h wol fail
Content-Language: en-US
To:     Hau <hau@realtek.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
References: <714782c5-b955-4511-23c0-9688224bba84@gmail.com>
 <Y7dAbxSPeaMnW/ly@lunn.ch> <9ee2f626bab3481697b71c58091e7def@realtek.com>
 <4014d243-8f8a-f273-fba8-2ae5a3844ea5@gmail.com>
 <6ff876a66e154bb4b357b31465c86741@realtek.com>
 <d28834dc-0426-5813-a24d-181839f23c38@gmail.com>
 <add32dc486bb4fc9abc283b2bb39efc3@realtek.com>
 <e201750b-f3be-b62d-4dc6-2a00f4834256@gmail.com> <Y78ssmMck/eZTpYz@lunn.ch>
 <d34e9d2f3a0d4ae8988d39b865de987b@realtek.com> <Y8GIgXKCtaYzpFdW@lunn.ch>
 <939fae88-ab42-132a-81d8-bbedfc20344e@gmail.com>
 <5084ca55d66f4e449253e54081e86986@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <5084ca55d66f4e449253e54081e86986@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.01.2023 18:04, Hau wrote:
>> On 13.01.2023 17:36, Andrew Lunn wrote:
>>> On Fri, Jan 13, 2023 at 04:23:45PM +0000, Hau wrote:
>>>>>>>>> In this application(rtl8168h + rtl8211fs) it also supports
>>>>>>>>> 100Mbps fiber
>>>>>>>> module.
>>>>>>>>
>>>>>>>> Does RTL8211FS advertise 100Mbps and 1Gbps on the UTP/MDI side
>> in
>>>>>>>> case of a 100Mbps fiber module?
>>>>>>> Yes.
>>>>>>>
>>>>>> I think in this case internal PHY and RTL8211FS would negotiate
>>>>>> 1Gbps, not matching the speed of the 100Mbps fiber module.
>>>>>> How does this work?
>>>>
>>>> My mistake. With 100Mbps fiber module RTL8211FS will only advertise
>>>> 100Mbps on the UTP/MDI side. With 1Gbps fiber module it will
>>>> advertise both 100Mbps and 1Gbps. So issue will only happen with 1Gbps
>> fiber module.
>>>>
>>>>> Fibre line side has no autoneg. Both ends need to be using the same
>>>>> speed, or the SERDES does not synchronise and does not establish link.
>>>>>
>>>>> You can ask the SFP module what baud rate it supports, and then use
>>>>> anything up to that baud rate. I've got systems where the SFP is
>>>>> fast enough to support a 2.5Gbps link, so the MAC indicates both
>>>>> 2.5G and 1G, defaults to 2.5G, and fails to connect to a 1G link
>>>>> peer. You need to use ethtool to force it to the lower speed before the
>> link works.
>>>>>
>>>>> But from what i understand, you cannot use a 1000Base-X SFP, set the
>>>>> MAC to 100Mbps, and expect it to connect to a 100Base-FX SFP. So for
>>>>> me, the RTL8211FS should not be advertise 100Mbps and 1Gbps, it
>>>>> needs to talk to the SFP figure out exactly what it is, and only
>>>>> advertise the one mode which is supported.
>>>>
>>>> It is the RTL8211FS firmware bug. This patch is for workaround this issue.
>>>
>>> So if it is advertising both 100Mbps and 1Gbps, we know the SFP is
>>> actually 1G, and we can remove the 100Mbps advertisement? That should
>>> then solve all the problems?
>>>
>> Right, that's what I proposed too, removing 1Gbps advertisement of the
>> RTL8168H-internal PHY via userspace tool, e.g. ethtool. For me this is the
>> cleanest solution. Adding a workaround for a firmware bug of a specific
>> external PHY to the r8169 MAC driver would be somewhat hacky.
>>
> Thanks for your suggestions. But because it needs user to execute userspace tool.
> This workaround may not be accepted by our customer
> 

In this case you can provide your customer with a downstream kernel including
your patch.

