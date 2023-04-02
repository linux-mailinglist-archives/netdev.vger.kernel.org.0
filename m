Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958416D380A
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 15:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjDBNDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 09:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjDBNDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 09:03:13 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862562CAC7
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 06:03:05 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id jl13so19391742qvb.10
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 06:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680440584; x=1683032584;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DSE2lwOaiV3xghP+7SFkQocBpY1IzL4zDudTuw4TYE0=;
        b=d6YQe+lXLPSltMluKn4bsndo2crjjVFsjpTJN7rT4tf16k6/WjDLGNRWMHC8MfNrFr
         ZIcspdEtEzp796qyiZjTg0RWKRbs+t2lkrVsn9hOqi7JW+U/b4VDTNhKxK/AzegNds1O
         bDCps73muZfEVwB33ftJ6TljBS88OV74i13ocmzu/Ua1FX5LcRBocPlUTaA2pgyCRnGo
         Ee44KYFrJvQ/LckShE1RxOCYxoxBh8ZfXiwY5NZ8tG0kyUL+4y8k+SsXrpkw51FHv7/B
         Xn6gj6gjCiPZ52NSlGw/OmGFfgYhy6zTPNTGtqiaGsvM3dqRO24hlW0RKc0RXMAmiJA3
         LoaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680440584; x=1683032584;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DSE2lwOaiV3xghP+7SFkQocBpY1IzL4zDudTuw4TYE0=;
        b=0YpRfrQY4u7cwbsIG3wybj5VE7O0/OnnnDRn8eG4j3gTLkFsowubZPBgdoAvtm4ndx
         1WT8jT+m6v/TSBwaIrYyKk1MAVFa2dcRCwjB/9SgZRKQ12DteIcaX+iWyvqHLUmtbiMK
         LssXAsELFGj6JnYXfgkjc7UVC6wECZPpcMbnU8iHe2laZ2PQRhEGuFDRDDnS6iNfk1Md
         8g94nRE4UulE9/cTiDmWoglEwLyIFjy5vGudHwTAm4bdbMbXlYDsogfFKk9DLajL+VF6
         Yrs2sYxiemXCvSCpw2mMfBPu3mSWq8Zbz05Lt0sn+0ynqQvbwM2CUgKDAjcJdToTBBRL
         l/Vg==
X-Gm-Message-State: AAQBX9dCou/B+sp4XFMpq6bsatmLQwTl9kvAS5q0XlfRTVUj4vRcKwol
        pBa+YCeb6Rorno6LL4L6y2Y=
X-Google-Smtp-Source: AKy350btMpWo/Q967C8LhAiCpKkTvew0ayb+m/CnFbKXEBx3UiC28UCjeGT7OOokSSCgLdJStYMGNw==
X-Received: by 2002:a05:6214:5081:b0:56f:154:2517 with SMTP id kk1-20020a056214508100b0056f01542517mr44776672qvb.10.1680440584018;
        Sun, 02 Apr 2023 06:03:04 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id ny4-20020a056214398400b005e37909a7fcsm774584qvb.13.2023.04.02.06.03.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 06:03:03 -0700 (PDT)
Message-ID: <2e3cbe68-d6c3-a6aa-dcee-d991c8fbd1c6@gmail.com>
Date:   Sun, 2 Apr 2023 06:03:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 3/7] net: promote SIOCSHWTSTAMP and SIOCGHWTSTAMP
 ioctls to dedicated handlers
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?UTF-8?Q?K=c3=b6ry_Maincent?= <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
 <20230402123755.2592507-4-vladimir.oltean@nxp.com>
 <915c64ca-bbea-bfe9-3898-cd65791c3e5d@gmail.com>
 <20230402125328.wf5tkov3hhdvqjkm@skbuf>
 <cab59e73-5006-4558-d4db-a393d9e8d02c@gmail.com>
 <20230402130159.xwacksnmymmthxtm@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230402130159.xwacksnmymmthxtm@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/2/2023 6:01 AM, Vladimir Oltean wrote:
> On Sun, Apr 02, 2023 at 05:56:33AM -0700, Florian Fainelli wrote:
>>
>>
>> On 4/2/2023 5:53 AM, Vladimir Oltean wrote:
>>> On Sun, Apr 02, 2023 at 05:52:29AM -0700, Florian Fainelli wrote:
>>>> PS: there could be some interesting use cases with SIO(S|G)MII(REG|PHY) to
>>>> be explored, but not for now.
>>>
>>> You mean with DSA intercepting them on the master? Details?
>>
>> Humm, maybe this is an -ENOTENOUGHCOFFEE situation, if we have a fixed-link,
>> we would not do anything of value. If we have a PHY-less configuration same
>> thing. So it would only be a sort of configuration where the switch side has
>> a PHY and the MAC connects to it that would be of any value.
> 
> But the last case could be handled directly through a phy_mii_ioctl()
> issued by the DSA master's own ndo_eth_ioctl() handler, no need for DSA
> to intervene, right?

Yes of course, no need for the indirection dance, thanks!
-- 
Florian
