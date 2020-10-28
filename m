Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3206629E114
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgJ2BxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 21:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728699AbgJ1V5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:57:40 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33A3C0613CF;
        Wed, 28 Oct 2020 14:57:40 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id r17so262295vkf.6;
        Wed, 28 Oct 2020 14:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D6r8L1EL8IRRyXeugahLoJIBCwA8PIgOemZAnAuCVb8=;
        b=uuzuF6Xe35sYv6i6Zbvct8ucdXbm37frPNTUGoTTKAgTeLAJ8eyLqo7SjFoqygYrzG
         cV0rzpN4+6JHzoypRBulKccyUtdZhl2iwBxhnoNcSvKr20+NF5KeBpDNZ0ShE5ffHLQB
         msHfTrWuj2ENc3HGxEOIliyZAxSRbZaeVNV24OLriqJsdH4Mw28Bn9XodLIEyQG/l1CP
         8A8SbPIXuVlVxafxS5VtnG47s+3z6nJpLbrjPI0ThbHMMgsbmAK+w6mzpQCq6PQNxBev
         bTAgOr/Fo8YjsqA+XwgS62lEhUxAnRTfylYjwXbfdaceA7zTZ4fjTPFMKFYIQzhxNp2E
         xbBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D6r8L1EL8IRRyXeugahLoJIBCwA8PIgOemZAnAuCVb8=;
        b=Aa7ha+GR51Z4NfCiZTKCTKv9DgME5rUoJnEhx43sHEolyJeNMWxhRVrdDDTniBwN8V
         jbiztT5pX8B2+Bgl2CdnoPGstZax60JQJtrXA3X6hUznuiqDQNLaMLKXMBhH1GQYynPB
         GNGJZwsDYzrETC37V4qnkC4xY6ktDTnWF+3Y7F4J1EKqBbb1VngtGZussHyQ/m/Eeu5M
         QNMWvu/yqo7cjpwc5IRG5lUs+iMe9SXazPTrOnbomPiZqsI+tJYB2gNtQcz4IR3Uf5SV
         kmKGBvbLa8ruFqZL4UaWLPUztxPuO4XSPa5DKzd6OGO5LGJFg1SmRj79zEoxeV1sLhHk
         wzSg==
X-Gm-Message-State: AOAM5319hySo63QtEpMsS/xDD8plz1dF15178fJCp/z76xDOfnaWmUck
        PeRbRKRc68QInht0BfSiQlLYi/xqR4k=
X-Google-Smtp-Source: ABdhPJwDV2kqLmbKTjRBCrDa7ZGX0BGuyW5l30jZm9a5wCeV1d4ghcjFN2UFRXaVLXqL16FFQxdjTA==
X-Received: by 2002:a62:ab0e:0:b029:164:1790:a11b with SMTP id p14-20020a62ab0e0000b02901641790a11bmr1135778pff.73.1603919138691;
        Wed, 28 Oct 2020 14:05:38 -0700 (PDT)
Received: from [10.230.0.148] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id 5sm491991pfn.83.2020.10.28.14.05.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 14:05:38 -0700 (PDT)
Subject: Re: [PATCH] RFC: net: phy: of phys probe/reset issue
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Roger Quadros <rogerq@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>
References: <20201023174750.21356-1-grygorii.strashko@ti.com>
 <450d262e-242c-77f1-9f06-e25943cc595c@gmail.com>
 <20201023201046.GB752111@lunn.ch>
 <87f264f7-da24-61db-2339-59a88d88e533@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ade12434-adf2-6ea7-24ce-ce45ad2e1b5e@gmail.com>
Date:   Wed, 28 Oct 2020 14:05:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87f264f7-da24-61db-2339-59a88d88e533@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/2020 12:32 PM, Grygorii Strashko wrote:
> hi Andrew,
> 
> On 23/10/2020 23:10, Andrew Lunn wrote:
>>> Yes there is: have your Ethernet PHY compatible string be of the form
>>> "ethernetAAAA.BBBB" and then there is no need for such hacking.
>>> of_get_phy_id() will parse that compatible and that will trigger
>>> of_mdiobus_register_phy() to take the phy_device_create() path.
>>
>> Yep. That does seem like the cleanest way to do this. Let the PHY
>> driver deal with the resources it needs.
> 
> Thanks you for your comments.
> 
> huh. I gave it try and some thinking. it works as W/A, but what does it
> mean in the long term?

I believe this was made clearer before: this is the only forward that
works across all subsystems, independently of the PHY and MDIO layers.

> 
> Neither Linux documentation, neither DT bindings suggest such solution
> in any way
> (and there is *Zero* users of ""ethernet-phy-id%4x.%4x" in the current
> LKML).
> And the main reason for this RFC is really bad customer experience while
> migrating to the new kernels, as
> mdio reset does not support multi-phys and phy resets are not working.

It is documented in the binding, but the binding is a document about a
contract, not about how Linux implements things, so I suppose you are
right that we are missing additional documentation to describe how it is
useful:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/net/ethernet-phy.yaml#n30

> 
> Following your comments, my understanding for the long term (to avoid
> user's confusions) is:
> "for OF case the usage of 'ethernet-phy-id%4x.%4x' compatibly is became
> mandatory for PHYs
> to avoid PHY resets dependencies from board design and bootloader".
> 
> Which in turn means - update all reference boards by adding
> ""ethernet-phy-id%4x.%4x" and add
> new DT board files for boards which are differ by only PHY version.

Well, you can have the boot loader absorb some of those board specific
details, after all, the entire point of moving ARM towards Device Tree
was to do just that. The appended DTB was offered as an interim solution.
-- 
Florian
