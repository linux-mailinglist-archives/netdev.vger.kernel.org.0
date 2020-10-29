Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3088129F16C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 17:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgJ2Q21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 12:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgJ2Q21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 12:28:27 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A6AC0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 09:28:26 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id e15so2775175pfh.6
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 09:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rSveV6E6Fy8lD3Rn/Hz2z+bWeBndb8KH7LcmC9FCieo=;
        b=anmYdddfQEL2a3pUPl4hl56gC0CuxKhQHLZWCn2xLIQDOKz/ivxorV2BgIadL/6PsA
         Ic5YyK1y/SHEp0GgM2bK5JHTkf0m6oy4hybNZPwGCvjEZmSPi8X8Wg2VugxGC6EVqflv
         uN6oK6GQzxm0e4kDNxBAb6daqNYYh0KV47KJ5PP49KcW1kkriLwHyxebtNnVvbbMDdsm
         jpSFyUT7ZevSqNB+W9agq8u3NWxTjoiB8hyJbawCdMOTDo2+7iF7/Aj1wAyrzT6ia9Zo
         mFDzV0zbWmXxxrwebV9Uz+TgW1SML0DLsKhvOvva4OvHqDQaXDY5MKfyzvJ7pahSK7f9
         dHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rSveV6E6Fy8lD3Rn/Hz2z+bWeBndb8KH7LcmC9FCieo=;
        b=uczV5Tw5jVoemU5h0c+jT5BeIGIZolDUmqaAxHQHEC2cfV4KHywQUsGblF59UVmLus
         BaGXKOjPR2T418J3teRgjegBd5fNr+/spu7c4TCjamLrcl8A3DH6+yE0dqr3WW4LzTYj
         805CIeiWWVSoP/R4sU+ML+xjOCb/6Q4tAB31FB1wWJGpMWy6GOlpdIa7Fuihzs5VPG85
         8Ib5PmpcrIuOxyNqYnls9EkoFktEZeYrtatds6wKMzZTS4iuvSB0H4to7Gs3Xd/eUK3n
         hkww4DsHYxbhvmbCDkzFfBSZGLsLkWi5Ogg/jiPsYyOUG9bHS+8m7H9zj8eTErcP6bCR
         yh2A==
X-Gm-Message-State: AOAM530wLkheQD/APgJN/XIUY2c7R5+13udwS27hhjGBztzWONQYDhPG
        /Ei4UNfWzhPkwjs30v8gviE=
X-Google-Smtp-Source: ABdhPJzMhQ+uxG9ZMmATGJvx6QHJ+JlX8+8Yg14aChRCa4laL9QXPH4fI4ZF8+0CFbMxHI+izRmnqw==
X-Received: by 2002:a62:17c2:0:b029:163:d44c:491c with SMTP id 185-20020a6217c20000b0290163d44c491cmr4738960pfx.81.1603988906250;
        Thu, 29 Oct 2020 09:28:26 -0700 (PDT)
Received: from [10.230.28.251] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b3sm3278863pfd.66.2020.10.29.09.28.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 09:28:25 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: fix vlan setup
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <E1kYAU3-00071C-1G@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <368dd624-ae0d-d593-156e-a201b11366de@gmail.com>
Date:   Thu, 29 Oct 2020 09:28:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <E1kYAU3-00071C-1G@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/29/2020 9:09 AM, Russell King wrote:
> DSA assumes that a bridge which has vlan filtering disabled is not
> vlan aware, and ignores all vlan configuration. However, the kernel
> software bridge code allows configuration in this state.
> 
> This causes the kernel's idea of the bridge vlan state and the
> hardware state to disagree, so "bridge vlan show" indicates a correct
> configuration but the hardware lacks all configuration. Even worse,
> enabling vlan filtering on a DSA bridge immediately blocks all traffic
> which, given the output of "bridge vlan show", is very confusing.
> 
> Allow the VLAN configuration to be updated on Marvell DSA bridges,
> otherwise we end up cutting all traffic when enabling vlan filtering.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
