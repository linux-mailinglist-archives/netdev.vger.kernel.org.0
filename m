Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E806D37FD
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjDBM4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjDBM4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:56:37 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57BEBB96
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:56:36 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id w4so25530040plg.9
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 05:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680440196; x=1683032196;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/nD136MF2Z9EUiMEq4UyKVbTDjfKADzymaPvF3vrDLc=;
        b=ZonF/L2jWhILs1wMgvNupDVDRN5gNikdiIYgYN4DHHdoQ+JHPQ3btc1qRg01UMTV18
         4EXOpW7EJbSS+CEJmHJnJ9ty4Gr4cLzsr3VWZkeK3YC2+Xx+GCGD6gC3zKfo36zabDPs
         CFdhKFsJyDhr01AzDCQQu8akRt/4vkE2IkvfsRM784uqwlJqqLmSZMg03+M35UwoxmVc
         dXMHEpFX9C+NiyVqGWRGNR9xQ8OTSar1eVYzwKUabDNDrrfaNhjDs7JCtSKR0z2sCH7+
         U0VoViTQEFixX5XxyH6g3RCaIVa+77T5BY3onIgSgMZSjcqXzaLKauJpPdRIBtfvqto7
         gmdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680440196; x=1683032196;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/nD136MF2Z9EUiMEq4UyKVbTDjfKADzymaPvF3vrDLc=;
        b=M6xPGfHkgHzAILXq6TgMfXC9aNevnPgwBng2EBkncjBTU4lF+QMY3TpJ+4rr2KGhsr
         aF50/40GiI2MP1IDLuz36IdtkWMWY11xFhJqi8Xm1wR4oYmndK6mt+hyJCCRkxnC/hts
         DnJx5USBd6zkFPDCsVA8o4nHM6QQHQTHUfbbt5d697IyLT28v3Ay353kh7tWmB0W/JMk
         0I8P09YzXDpETlswXo2zGQVnNxIrLKEtLTgevNJSnrTfstdHfnM+kUHlK2fHWEZCPhyZ
         7INJHKj0oT0CFoCdFpFJSH23KAoRvDOLLaaRvrEUDesjQdpxar4vkaXzFde6CHGaZ6DZ
         N6kw==
X-Gm-Message-State: AAQBX9eB/7jTLkpoJ38XAtIwMMHNi0ImG9Khv2y/GrFYh9PpS+uqXUaK
        kpFRf8uTBdnFkDqxy4o7Yqo=
X-Google-Smtp-Source: AKy350bGK/l+uw7m3W+WH434UOqHqyT88WCdGzGPfbrwW/zkhzh6pBOinAkNuDyeH7yC0Paw4gJ+Hg==
X-Received: by 2002:a17:90b:4a07:b0:237:1f17:6842 with SMTP id kk7-20020a17090b4a0700b002371f176842mr37180494pjb.10.1680440195926;
        Sun, 02 Apr 2023 05:56:35 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h14-20020a170902f7ce00b001a217a7a11csm4738445plw.131.2023.04.02.05.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 05:56:35 -0700 (PDT)
Message-ID: <cab59e73-5006-4558-d4db-a393d9e8d02c@gmail.com>
Date:   Sun, 2 Apr 2023 05:56:33 -0700
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
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230402125328.wf5tkov3hhdvqjkm@skbuf>
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



On 4/2/2023 5:53 AM, Vladimir Oltean wrote:
> On Sun, Apr 02, 2023 at 05:52:29AM -0700, Florian Fainelli wrote:
>> PS: there could be some interesting use cases with SIO(S|G)MII(REG|PHY) to
>> be explored, but not for now.
> 
> You mean with DSA intercepting them on the master? Details?

Humm, maybe this is an -ENOTENOUGHCOFFEE situation, if we have a 
fixed-link, we would not do anything of value. If we have a PHY-less 
configuration same thing. So it would only be a sort of configuration 
where the switch side has a PHY and the MAC connects to it that would be 
of any value.
-- 
Florian
