Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EF8593757
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 21:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244481AbiHOS5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 14:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245245AbiHOS5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 14:57:05 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99384491DE;
        Mon, 15 Aug 2022 11:32:13 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id l5so6098414qtv.4;
        Mon, 15 Aug 2022 11:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=zeuqYuZLuy/3ZLhntIAE4E09r8HDO38szgJxTkvg/RU=;
        b=C4oEhIJoRpZtomzx+CSNKrTrFygnL9Jua5oOlm6YuwVej1Bk65Lg04iS18JJFwr5px
         XaAqJ6EkSLXHWIathPtKyPq0CNTJ+Xh9eu4OwSUB1C8ehuzATPpp3Lqn2KbUkd2g/Glq
         gRWKbu6zBeMvyBP2IyBhvUA0qrGku/DuPnivKxoCXSqdxjrX9Z40FiW75B6sf6DEGiM3
         m6uckto0g2GIAl051w0doGmrH2YnGJClJVNQ0jmhT5sdH18/gOFY7nKy7qnRztZyR8PF
         Zi36F1vxnW85/Io48+W0Nw43K7tBmaNie9EOY5LDIMtBuHdUkoine4pWkE2IpUfQZ4/W
         1RxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=zeuqYuZLuy/3ZLhntIAE4E09r8HDO38szgJxTkvg/RU=;
        b=DQikSV43nXOx5lX0wYB496yvCTXnm6MZespQxiuMlsMkTKR9w0Bkjihid5CTUrvZU7
         B2y0KYvhzyJLJNCHerX+jf9DOFjw7CUh2BKKh8WJhpubpcRsXuEcnF+Z7QiHt2xNDHk/
         HqMzGGPqOYvDIQ8qPNhDfbTijjIvJeCtCe78Xd3t4sqtAKZJoLam4jsuf++DWLDhqgjz
         lG8bDv/N39aA1pPUMnUch9YvAw7th2OhtKbPp6Ku/EsQymti6aB66QUAX/3w37h+9hpm
         2laZ99BwI7yYTTta9E0i6u1tpuoY0swaf3xKUGImwFBB5lfKD6+YfgBG2b73mwlZIN5O
         7z6w==
X-Gm-Message-State: ACgBeo2t7lIiigQ9f2LZuaCMpV/JXth+jjy3feYKOpOzndzse9GuP2Up
        NjpgMI8iZHXMJvyMr7DvUkk=
X-Google-Smtp-Source: AA6agR418oYLZOakW7pifUfVRjgptv2oz4dLh0hDZyJpBJvFN1sHk25mtYI+ulGYG8WzLc/ssQt+IQ==
X-Received: by 2002:ac8:5f86:0:b0:344:65d7:ea44 with SMTP id j6-20020ac85f86000000b0034465d7ea44mr3533926qta.42.1660588332636;
        Mon, 15 Aug 2022 11:32:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 21-20020ac85655000000b0034355a352d1sm8713192qtt.92.2022.08.15.11.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 11:32:12 -0700 (PDT)
Message-ID: <fef9c594-80f4-f155-b40e-3762590e3c8c@gmail.com>
Date:   Mon, 15 Aug 2022 11:32:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: phy: broadcom: Implement suspend/resume for
 AC131 and BCM5241
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20220815174356.2681127-1-f.fainelli@gmail.com>
 <YvqJyg3eUusc8jkC@shell.armlinux.org.uk>
 <d75b23fb-74e5-3986-26d0-9ae83158c7ce@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <d75b23fb-74e5-3986-26d0-9ae83158c7ce@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/22 11:09, Florian Fainelli wrote:
> On 8/15/22 11:00, Russell King (Oracle) wrote:
>> On Mon, Aug 15, 2022 at 10:43:56AM -0700, Florian Fainelli wrote:
>>> +    /* We cannot use a read/modify/write here otherwise the PHY 
>>> continues
>>> +     * to drive LEDs which defeats the purpose of low power mode.
>>> +     */
>> ...
>>> +    /* Set standby mode */
>>> +    reg = phy_read(phydev, MII_BRCM_FET_SHDW_AUXMODE4);
>>> +    if (reg < 0) {
>>> +        err = reg;
>>> +        goto done;
>>> +    }
>>> +
>>> +    reg |= MII_BRCM_FET_SHDW_AM4_STANDBY;
>>> +
>>> +    err = phy_write(phydev, MII_BRCM_FET_SHDW_AUXMODE4, reg);
>>
>> Does the read-modify-write problem extend to this register? Why would
>> the PHY behave differently whether you used phy_modify() here or not?
>> On the mdio bus, it should be exactly the same - the only difference
>> is that we're guaranteed to hold the lock over the sequence whereas
>> this drops and re-acquires the lock.
> 
> What read-modify-write problem are you referring to, that is, are you 
> talking about my statement about setting BMCR.PDOWN only or something else?

Sorry, hit send too quickly, I see what problem you are referring to. v2 
coming up shortly utilizing phy_modify() and simplifying the return path 
(no need for done label, etc.)

Thanks
-- 
Florian
