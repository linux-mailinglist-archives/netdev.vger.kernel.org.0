Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A184219614
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 04:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgGICN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 22:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgGICN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 22:13:58 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED55C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:13:58 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id cv18so2747042pjb.1
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 19:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vLYNK3Az17O1iTYhpPu4P8kQCbruyaUYCoCCV1Y1vfA=;
        b=HsjeMImMuIInLLTVkCQRcvKOmOMDlDfCT5gQyCdzMqsCX8Yu2maADTH5fGrr43bQju
         qpTxJRsb3sfaQdQtMc7DQDpdrGwxSjXFRhWN4lqAgsJaJD/pmYr0sYvp/mpYz5im3lib
         FmaUn368avXjG+TT1dyc7TzcVCUdcQ9avf0x/XvyFKtblbyKh0JAvkflm5+SMgr2VgWK
         ZmaTWFirrnjic+c8ZEm99MrSzaf21xHzdTzQTYRPwUVtHUzrvWpvjeaPve/1j0yT3pTx
         Yd2ONHKl0tmYafwEVbu4c4CT843hjah8GZ/A5azMmY4XTiEaJAQhRqxNaiw3JGe44J/u
         p5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vLYNK3Az17O1iTYhpPu4P8kQCbruyaUYCoCCV1Y1vfA=;
        b=VlKiLI98o8ZiIRwJuLUebOe/Azm1J0lDcayWtqA7Oh7nBPOgOOVFLQgbXKEhRybvP7
         NCpLanxZgPdy9RNHtphI3KiJ/M4bqiLX7SgfQmyAOSWG7/UYBSGVrkqsAhiKji/OG2cL
         wLOzv9AlsvmIZUCQTXktlBd7PrS9nXM5zZ15PdsA8UUFP4QxpNBCKYDl2YdX+0WFLZw1
         uqzEZ4HwDpPbUbAljZxb+Abd2iY4jWLwnZiqyou97xx2n7hw/c7eP9B8QYOVlgGsYyGy
         AxBy+ftfLiUHFM8MKevKDQ7CAi+N7XGwVmI2W/TOR3x/73fM/+Z1a+3Qfjm+KjQ+NiVC
         zD5g==
X-Gm-Message-State: AOAM530MCplzIFsgzUTtL6weVviNTJPyAqqpRoTuUgFI3YSXIUOBxcON
        63i+gUQTewDdSGPcc98E6Mo=
X-Google-Smtp-Source: ABdhPJzaOlkJS194w/G6zLI3r4PANOrEhCvTxjqu4b8FXMH04geBJCeg2QtY62mo+eWhH6VnC/TeQw==
X-Received: by 2002:a17:902:ee14:: with SMTP id z20mr11646452plb.265.1594260837979;
        Wed, 08 Jul 2020 19:13:57 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id b82sm896358pfb.215.2020.07.08.19.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 19:13:57 -0700 (PDT)
Subject: Re: [net-next PATCH 1/3 v1] net: dsa: rtl8366: Fix VLAN semantics
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20200708204456.1365855-1-linus.walleij@linaro.org>
 <20200708204456.1365855-2-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <15074ccd-97de-7417-4d11-3d1bcaf4c70d@gmail.com>
Date:   Wed, 8 Jul 2020 19:13:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200708204456.1365855-2-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/2020 1:44 PM, Linus Walleij wrote:
> The RTL8366 would not handle adding new members (ports) to
> a VLAN: the code assumed that ->port_vlan_add() was only
> called once for a single port. When intializing the
> switch with .configure_vlan_while_not_filtering set to
> true, the function is called numerous times for adding
> all ports to VLAN1, which was something the code could
> not handle.
> 
> Alter rtl8366_set_vlan() to just |= new members and
> untagged flags to 4k and MC VLAN table entries alike.
> This makes it possible to just add new ports to a
> VLAN.
> 
> Put in some helpful debug code that can be used to find
> any further bugs here.
> 
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
