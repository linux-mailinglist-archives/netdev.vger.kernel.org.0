Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23CF28DC82
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfHNR6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:58:18 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46351 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbfHNR6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:58:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id w3so16257759pgt.13;
        Wed, 14 Aug 2019 10:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MpjkKQG57NWCogNh6HA4vWFkmzsK8Kfyi0DRma3/+J0=;
        b=Vit3WwwbyY1gvyZrE3M7s+gCpFczxu1keMfk4x9zOOcG22+a3nZHMXfDdYNIlR8F94
         7RtBj4EYZETbDD3DTilFs5qtwW7EZv74YfX853Hxun5myTZnBLPKcbuSMBsYIRXl/g5F
         K88eKV8SBM3a9S59DgwuNlUG+0HKb/1ULI3IvCmxvTewpHZy8fZNG3rfAkBi1F/5BmC8
         qhP86GwUbYVkq3AfAOCdGycTDZRsEHt5reS2eEAYVlq9x3UTqm76N9a7hXGDnGv/t2vR
         IW9Q3kt5e499XQz9mS0STJsY2emJ1hVqU2ueUBa+9M3mRdHIBAzqyIp5kt28z+mVKR8R
         QvhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MpjkKQG57NWCogNh6HA4vWFkmzsK8Kfyi0DRma3/+J0=;
        b=bdlZ8+O+kSaGbjmRcA+5IDKDhAacfkAHK15+kn9UJtrWdJBo5WdcXcTv1Q5vKvfUF/
         WHmcj7dLxA+RhJ7RCnBPqYWfr1t4IIjusZ+0unz/H3wCSjzCF5i0X8tcY/Gggi+2+Xwq
         +px8UP2ho2xXg1ayyNFyoqUOSZx79YrOsy1US8PSXe3zXPPdY5Y3W6H4liLWdx8MnppD
         pE28LbKsO0OAXs5bl5LS43pdYpJqXsPjwRY9QskSXFnyH9McsSEadF6iUOE6wGOS7Mw4
         qaMiNEt6n3PTI/Rd2u9lkjpB2GK7POoSWNX2Z0sbA95ggSGfbcd6nC2iHUAw48dKJj8D
         dEgg==
X-Gm-Message-State: APjAAAUaHaooJiElRc6oTpNXPHTKENg3LhETGoQRbsZ6xCohnsZn+1cJ
        NaWV4/3ZajTs1UOCWC92AvY=
X-Google-Smtp-Source: APXvYqxzm2vUyPLeI4Vkfj1AqqAKclypzJih427wh8mJFQqBI0P5FfXK2Ix5RYE6RVQeNB1kNsKdrw==
X-Received: by 2002:a17:90a:db0d:: with SMTP id g13mr886282pjv.51.1565805496969;
        Wed, 14 Aug 2019 10:58:16 -0700 (PDT)
Received: from [10.69.78.41] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c199sm604284pfb.28.2019.08.14.10.58.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 10:58:16 -0700 (PDT)
Subject: Re: [PATCH v4 12/14] net: phy: adin: implement downshift
 configuration via phy-tunable
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        hkallweit1@gmail.com, andrew@lunn.ch
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-13-alexandru.ardelean@analog.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <081d5898-40c5-54d8-f543-942a3518f36e@gmail.com>
Date:   Wed, 14 Aug 2019 10:58:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812112350.15242-13-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2019 4:23 AM, Alexandru Ardelean wrote:
> Down-speed auto-negotiation may not always be enabled, in which case the
> PHY won't down-shift to 100 or 10 during auto-negotiation.
> 
> This change enables downshift and configures the number of retries to
> default 4 (which is also in the datasheet
> 
> The downshift control mechanism can also be controlled via the phy-tunable
> interface (ETHTOOL_PHY_DOWNSHIFT control).
> 
> The change has been adapted from the Aquantia PHY driver.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
