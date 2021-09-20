Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A91412BCE
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348782AbhIUChz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245218AbhIUCKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:10:01 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EC8C08ED82
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:25:27 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso609052pjb.3
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rPYoxxs4koUmmbiJoheqASC9c6PCRXPemhelXLmI9g0=;
        b=fk/CYkfvSBt3AVUIdmJHhxWV8dWlAwtCRK/lP0+ZEigqAwl9AHsiWTYJ6oroEtA8L/
         2XMkvo4sAi60gK8XhdaIlc252N8pRxlhnXKWbErO5ds1gfw7EWma1ET3zFJaDOklsSCh
         6E1d5RSDPoPmNG4wv6PnRMuVWhwqatAsp+yulU/CBsds5qDQeBMAmOzj6GRQPeiyC41l
         my44Njsh2D7OPa6Tt/+2VUnX/d+o3lEjEoUcGvrQ+8rWrrBSH4awcNRrbJ/QzoYEu0ey
         0mq0PsJyaqQoE2VuL+j2Y7TXa3ciU4YvcA8qvq9wzr2cvqaiFSetK7BzH2CVsnqdewb9
         PwKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rPYoxxs4koUmmbiJoheqASC9c6PCRXPemhelXLmI9g0=;
        b=tOODhJ48lujNaHjcgNshWRgCixkAqFkKRhKaD2OI8enskV1Xlj+yMzsVA1CYogQX8j
         Fy/ges1Mrg9L7xzgRq6d4JkhP5z/123xZeJnjHBzu3E4MGlFD9W9zNWWJzx3+ucZWVVs
         4USX6pkDLjirbktSvEr1bUHCWRHwtOwhL6PYp8vDt/x/XnC0Orhn2kdBihYEvI64xkDn
         3W4v3ojCFu6w3r69aKC44Al2goTCY26OhVqi32KG1lDcodKb6iEW29p37tbWZX/pwxjp
         wM9Sv05fDm7zFpQ3xK7/rkl6LIAiVen4q+FboVUJ5i9lwqT8a87aRHlh318RYuC+efey
         1x9A==
X-Gm-Message-State: AOAM531BQQZkj7JkP55EUebKGAEaWmvD2JbUGtztPHkPu9ovJVOK8LQQ
        p4c6a2qiMcmBgFJI3aGCpwk=
X-Google-Smtp-Source: ABdhPJwnDVrxkj7dtZKo0L36hRl8dH/zcWD0AnQ2D/bnXDPMIHirFdfKMS0wMadoIvUpDg1IsI3f+g==
X-Received: by 2002:a17:902:bb16:b0:13c:a5e1:f0b5 with SMTP id im22-20020a170902bb1600b0013ca5e1f0b5mr20790563plb.35.1632162326894;
        Mon, 20 Sep 2021 11:25:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q3sm69192pfg.49.2021.09.20.11.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 11:25:26 -0700 (PDT)
Subject: Re: Race between "Generic PHY" and "bcm53xx" drivers after
 -EPROBE_DEFER
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
 <4648f65c-4d38-dbe9-a902-783e6dfb9cbd@gmail.com>
 <20210920170348.o7u66gpwnh7bczu2@skbuf>
 <11994990-11f2-8701-f0a4-25cb35393595@gmail.com>
 <20210920174022.uc42krhj2on3afud@skbuf>
 <25e4d46a-5aaf-1d69-162c-2746559b4487@gmail.com>
 <20210920180240.tyi6v3e647rx7dkm@skbuf>
 <e010a9da-417d-e4b2-0f2f-b35f92b0812f@gmail.com>
 <20210920181727.al66xrvjmgqwyuz2@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d2c7a300-656f-ffec-fb14-2b4e99f28081@gmail.com>
Date:   Mon, 20 Sep 2021 11:25:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920181727.al66xrvjmgqwyuz2@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/21 11:17 AM, Vladimir Oltean wrote:
[snip]
>> All I am saying is that there is not really any need to come up with a
>> Device Tree-based solution since you can inspect the mdio_device and
>> find out whether it is an Ethernet PHY or a MDIO device proper, and that
>> ought to cover all cases that I can think of.
> 
> Okay, but where's the problem? I guess we're on the same page, and
> you're saying that we should not be calling bcma_mdio_mii_register, and
> assigning the result to bgmac->mii_bus, because that makes us call
> bcma_phy_connect instead of bgmac_phy_connect_direct. But based on what
> condition? Simply if bgmac->phyaddr == BGMAC_PHY_NOREGS?

Yes simply that condition, I really believe it ought to be enough for
the space these devices are in use.
-- 
Florian
