Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8973409DF
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhCRQQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbhCRQQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:16:20 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6FBC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:16:19 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso3374799pjb.3
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 09:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0+L0Rr9w+tfqNr5HgZvkMEu/KInlrWzOyCihbkTeCWs=;
        b=BMiEexQr+J+cNy02n4I2OPNeoDf+9D7NLGdcqyn87DGHSOTy2lmaV0YNQWu4KrIOhj
         BytADmrG9PCe3e2SfKq2j0X8iLd4AGQ8R8cAluU3U/blO3yu+HZifBcitwtB2y/y8Ail
         cx8MCkP0tgJSvn84/S2gsa37d7UbDMDZ6yCcTNmd2JLvUdhKM7WPikFbAKKLYWAK2buM
         SyerjhUU3NbBh8YTWeLtveTxrRtQPdnb6O6RqJE2N2e7hNA7wqLbZuHsB7diVTojcfAe
         SOAq+CmQ0V5Bvpp+PJsLLQJAuaEnYV0lJQ72CaPy+a8RFacLSAOPsBaWTcSAL8XMXOgI
         dRtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0+L0Rr9w+tfqNr5HgZvkMEu/KInlrWzOyCihbkTeCWs=;
        b=MZjog6RVbCdtrZSvBBaDnv9bSkQ9rxs3RIUfgEtq19hDpoUjMClQhRWo2/4kOqg7SD
         P/NBePXZogxLizBXAJeIBI1XUqAbL4V9lEPMWP6M2jkFgIH3VK/bwrc0DgKHvr4eFEdc
         vj2qRGitPJGqxy58YVu9h8QfXBnfARMAeh1ajet3CaW4vHpQFKtSk9xmN50tdfapODGM
         nXS5481gHXwESY7FDq8ovFc9MhlcnxGgu5b4x9A6qjZQTiynK0FiCK11gZde/MsmLoAk
         7WpFDrgJTaHDsCOtFR9GyT+jaGfjRP24OWvuKjOAdyttrSB3NitTHXStOYswqJYgfJ2R
         ExUg==
X-Gm-Message-State: AOAM531tJgS4AQTMkGOZcrTkaivW3ACj2slRCl5M2xenxFg9SWFNYabB
        I6wTreCOPaY2StXb9W4ThAE=
X-Google-Smtp-Source: ABdhPJwVmUFYGdec95nvQZE7txGLRjPouexRpa8HQnY2r2bZ3BoiBtLQi6zlv5l9NpKM/AzbiJjD7A==
X-Received: by 2002:a17:902:b289:b029:e4:bc38:a7 with SMTP id u9-20020a170902b289b02900e4bc3800a7mr10446306plr.50.1616084179427;
        Thu, 18 Mar 2021 09:16:19 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h16sm2749501pfc.194.2021.03.18.09.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:16:18 -0700 (PDT)
Subject: Re: [PATCH 1/2] net: dsa: bcm_sf2: add function finding RGMII
 register
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210317143706.30809-1-zajec5@gmail.com>
 <20210317143706.30809-2-zajec5@gmail.com>
 <49f01c3d-7149-299e-d191-7ffdfb975039@gmail.com>
 <ebd5018c-35af-60b7-d44b-e583ec18f2e7@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e42f1076-7f4a-574a-bce9-726b1b402a9f@gmail.com>
Date:   Thu, 18 Mar 2021 09:16:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <ebd5018c-35af-60b7-d44b-e583ec18f2e7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 12:30 AM, Rafał Miłecki wrote:
> On 17.03.2021 22:20, Florian Fainelli wrote:
>> On 3/17/2021 7:37 AM, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> Simple macro like REG_RGMII_CNTRL_P() is insufficient as:
>>> 1. It doesn't validate port argument
>>> 2. It doesn't support chipsets with non-lineral RGMII regs layout
>>>
>>> Missing port validation could result in getting register offset from out
>>> of array. Random memory -> random offset -> random reads/writes. It
>>> affected e.g. BCM4908 for REG_RGMII_CNTRL_P(7).
>>
>> That is entirely fair, however as a bug fix this is not necessarily the
>> simplest way to approach this.
> 
> I'm not sure if I understand. Should I fix it in some totally different
> way? Or should I just follow your inline suggestions?

What I meant is that for a bug fix you could just mangled the offset of
the register such that REG_RGMII_CNTRL_P(7) would resole to the right
offset. That would be lying a little bit, but for a bug fix, that would
work. Not that it matters since the changes are still fresh in net/net-next.
-- 
Florian
