Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6CA6075DA
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 13:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiJULOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 07:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiJULNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 07:13:52 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21182610B5;
        Fri, 21 Oct 2022 04:12:59 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id u21so4467042edi.9;
        Fri, 21 Oct 2022 04:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tU6iZx3wt0D9XWTGgnG7mXuFS6LSlg2gKvINXgiZtf0=;
        b=d466sidD/mC8C29VfNT1DRdOl33SBay3hEcx5CU81ewI81Eq8n7Zh/RsH2Vxvdjuy9
         1BNLgcsrFzhQaoj1ofCuwccJCz7wMQMI7fLRKRg5fVio0jh3UETVKO0bmQqAWWS6Aav/
         PG5/n7XJBI8VHvDVKOB3WMh2SSZuDzto+pP8znSNrzww1F36i5zuBwLDYIhKv/M2a51u
         wivVWYuNCt1Nw4cRx/wjsHq3hcs7/C8nE1cS+xzZHJyxHCaBZ5Mc7BWce14veevutG2F
         gCal4Kov+bQwl6FqKGJFDNAlnHhih93xW9uVqs2gqr0TG83IvJDYF0FBWqtvTT4Cpcje
         wRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tU6iZx3wt0D9XWTGgnG7mXuFS6LSlg2gKvINXgiZtf0=;
        b=RX7nCT2JK9HgAnenZcH0cCMsUiQVziqMsg8ARWGZmhQ+S66uSn/7e41lir96zE3S4r
         8PBR/SBreuBl8ObRXMRYlEMQHtMrta12z+KmzDFoS7FNhb8L0oWLexmiPoiH9f9ge0Tg
         Nw+BNzYLWvzfo2/E7KM0J8BAFEMrQ3ImS6pmgSSGq40hyeDXVF3ooHuNWbbk4hpISJ/D
         2nQvD+sp1sE4974t5Qx+wiJQtFat7j7nXbCKIEtHjgBsvn/PhxpNtOzJUe+W+kYJArnG
         INqGl1QM3jU5ORzer5NQ4DEyRbZBAOHg9s9irmTJO95kjbTIc7WdO/O8cKPf7ZRRpRHu
         vW7Q==
X-Gm-Message-State: ACrzQf2ruDV1N77TJdZcQra4ru/27G17RlNx4mklt7kGdl7WWmCeYv+2
        56l+IArLhG2WR681DyjPM0hJrj8hg20=
X-Google-Smtp-Source: AMsMyM5xWjsuZ7nAsCpsY4WorjnmuVs/sPrtquLskjOaBWCGWIXKM/yQ0gYnu9oVx2mywVQBaJixow==
X-Received: by 2002:a17:907:97cc:b0:797:c389:de5f with SMTP id js12-20020a17090797cc00b00797c389de5fmr6353054ejc.627.1666350759675;
        Fri, 21 Oct 2022 04:12:39 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b40:ea00:dda4:ab12:591c:b0be? (dynamic-2a01-0c22-7b40-ea00-dda4-ab12-591c-b0be.c22.pool.telefonica.de. [2a01:c22:7b40:ea00:dda4:ab12:591c:b0be])
        by smtp.googlemail.com with ESMTPSA id f20-20020a17090631d400b0073de0506745sm11427451ejf.197.2022.10.21.04.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 04:12:39 -0700 (PDT)
Message-ID: <125eddc1-8791-e8c4-39ac-fb5b864d91ba@gmail.com>
Date:   Fri, 21 Oct 2022 13:12:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: phy: Avoid WARN_ON for PHY_NOLINK during
 resuming
Content-Language: en-US
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221021074154.25906-1-hayashi.kunihiko@socionext.com>
 <4d2d6349-6910-3e73-e6c5-db9041bcfdb8@gmail.com>
 <86262217-a620-dc5b-cf5a-3a23ea869834@socionext.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <86262217-a620-dc5b-cf5a-3a23ea869834@socionext.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.10.2022 11:35, Kunihiko Hayashi wrote:
> Hi Heiner,
> 
> Thank you for your comment.
> 
> On 2022/10/21 17:38, Heiner Kallweit wrote:
>> On 21.10.2022 09:41, Kunihiko Hayashi wrote:
>>> When resuming from sleep, if there is a time lag from link-down to link-up
>>> due to auto-negotiation, the phy status has been still PHY_NOLINK, so
>>> WARN_ON dump occurs in mdio_bus_phy_resume(). For example, UniPhier AVE
>>> ethernet takes about a few seconds to link up after resuming.
>>>
>> That autoneg takes some time is normal. If this would actually the root
>> cause then basically every driver should be affected. But it's not.
> 
> Although the auto-neg should happen normally, I'm not sure about other
> platforms.
> 
>>> To avoid this issue, should remove PHY_NOLINK the WARN_ON conditions.
>>>
>>> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
>>> ---
>>>   drivers/net/phy/phy_device.c | 8 ++++----
>>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>>> index 57849ac0384e..c647d027bb5d 100644
>>> --- a/drivers/net/phy/phy_device.c
>>> +++ b/drivers/net/phy/phy_device.c
>>> @@ -318,12 +318,12 @@ static __maybe_unused int mdio_bus_phy_resume(struct
>>> device *dev)
>>>       phydev->suspended_by_mdio_bus = 0;
>>>
>>>       /* If we managed to get here with the PHY state machine in a state
>>> -     * neither PHY_HALTED, PHY_READY nor PHY_UP, this is an indication
>>> -     * that something went wrong and we should most likely be using
>>> -     * MAC managed PM, but we are not.
>>> +     * neither PHY_HALTED, PHY_READY, PHY_UP nor PHY_NOLINK, this is an
>>> +     * indication that something went wrong and we should most likely
>>> +     * be using MAC managed PM, but we are not.
>>>        */
>>
>> Did you read the comment you're changing? ave_resume() calls phy_resume(),
>> so you should follow the advice in the comment.
> 
> I understand something is wrong with "PHY_NOLINK" here, and need to investigate
> the root cause of the phy state issue.
> 
Best look at how phydev->mac_managed_pm is used in phylib and by MAC drivers.

> Thank you,
> 
> ---
> Best Regards
> Kunihiko Hayashi

