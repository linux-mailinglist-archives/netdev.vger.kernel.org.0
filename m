Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F534A8BA2
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353338AbiBCS2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244245AbiBCS16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 13:27:58 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22D7C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 10:27:58 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id z14-20020a17090ab10e00b001b6175d4040so10876733pjq.0
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 10:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dMre6qfknBQoDeRCVuVAl69FIr2T1cX5CJWbL6B482M=;
        b=Hrliu4F6oW43NaLUXm3hD3DJkvTqEnGA32y9YXtt4aBMYowQTHJeKydYVJfBwp/KdX
         DpAuMmMB/3a7AKlIXH0t/IWpmob0F6FdvZC14P83wCxsI98I2MqnNR4D6towsFtE3C3v
         I9Y2YfbTqxqLftZpQjt3Zj9aPrDdcp2w+KoDtRzLCdAfjnxDZXQWWbdX/tT0o3QNuXsl
         pROfpRkBsP09L4lMnoGPkQpRZ+jiYDfaa3dQlMhe8qNBi2IC6JO/p2eLKPv2awUjeL3j
         Nx8cJuY/KERQhZLztd4IpLAkGj9DZCjH6XJVRAWR1MpXMlFVT25F+T9mSgsEBybX10aX
         4rDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dMre6qfknBQoDeRCVuVAl69FIr2T1cX5CJWbL6B482M=;
        b=HdxUibZPTWtP17/yx/+DM5GZFeRZGRryTiHECzVcG/GzGn8ziToPQr20cb1Uw3bIPc
         V0399ajpUuKjVJ5W9mDGgJEqmRB5E7ma0rxNVxQRYsceeWZVBqrv7APfcpFVMbjW5aCJ
         EqHU136gK+NnRtVCQi2IHPh9xdEy5rz9UZY3aqBnkaKy5sSEPqY4phHUIWeac5sl1dUE
         kIZRRPh85NOIhSKajv/N8tcenLm9ZVNsYH754/wTarf1K2vDRPeoTX/5Yt7oSam9sKVG
         ZbfHm8a494FqWJNX65IPtpTDQCZF/+3CSCh+KKAqgp+yK6zeJ8eP6UW5e9vsi/HEY2JI
         tnqA==
X-Gm-Message-State: AOAM532iUiQXRfUmWvYfJXEx/fy+63t1kxlD8WTUSRWoJgpYFi2qE2rr
        WVopwPylh2opx8ZAAILm3upE4wMTHwo=
X-Google-Smtp-Source: ABdhPJwCLhOriy3HQ67FtL4daPvvHr9ZkwvaJleJUBkb+BfkQb2ziT4juHF1oph6YITWYN3URl4wAA==
X-Received: by 2002:a17:902:6b4b:: with SMTP id g11mr36516225plt.109.1643912878447;
        Thu, 03 Feb 2022 10:27:58 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q11sm29765242pfk.149.2022.02.03.10.27.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 10:27:57 -0800 (PST)
Message-ID: <360d1489-dbfb-d8e8-205c-4aab6ae55a30@gmail.com>
Date:   Thu, 3 Feb 2022 10:27:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RFC net-next 0/5] net: dsa: b53: convert to
 phylink_generic_validate() and mark as non-legacy
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/2022 6:48 AM, Russell King (Oracle) wrote:
> Hi,
> 
> This series converts b53 to use phylink_generic_validate() and also
> marks this driver as non-legacy.
> 
> Patch 1 cleans up an if() condition to be more readable before we
> proceed with the conversion.
> 
> Patch 2 populates the supported_interfaces and mac_capabilities members
> of phylink_config.
> 
> Patch 3 drops the use of phylink_helper_basex_speed() which is now not
> necessary.
> 
> Patch 4 switches the driver to use phylink_generic_validate()
> 
> Patch 5 marks the driver as non-legacy.

I won't be able to test these patches on the platform that does use the 
SRAB code until the beginning of next week since I don't actually have 
access to the hardware right now, but I will respond once tested.
--
Florian
