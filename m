Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7481AF50A
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgDRVDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbgDRVDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 17:03:01 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C274C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:03:01 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x4so6579933wmj.1
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t9gMB0FsI0zdEdpceBasiz3g0Fu0MM1WQILXBe315Kk=;
        b=ByAm7hZHNrzfg8ll5nLNUkhcsSjPpMR5tM3ZEB4haZgTXqtXRH2FWN/h5Sho78VwWN
         OwvOYpRvp0I4bk5hTMo8OoIzhnq8KLLO4xcwFTg9y8v1nhkfKLLC2z6qAihc8OfZGtme
         55P3iW892Wk0lR/hkuLhoMA8HTtlzy62LbLI/RJyPbK3rn60/+VFyPOIEbGGatT71Zd9
         diDr/dLa4zyoDps0JToOwfThZzN6opkYykPHw6968U7yE8wcKiQIiw7Tulc3av00ax2Z
         ID8QrD9HL92A/ljCpSThyDUKadHOesTNJCJSOgarlvWI0bA1VOGyN/T7Cq3YltyGm+e2
         uEdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t9gMB0FsI0zdEdpceBasiz3g0Fu0MM1WQILXBe315Kk=;
        b=QaEMMOctH2/7N0nejY8csby1nX1SaU+Ub//2ZMHZ93kxXA+ZroATJ1qgKX5RvlCj9W
         esBC8Em6g2H+fx7VEiTqRda1cDQr3m2WDTazzO2Nfim8UBroQlhsJ7omrwnXiMi4WCMR
         XvXKsBQRj1pJb/HWnfKw7HiJ1LGDD9LIwsArXyd3Wvj93P6HErwZWd/hknXWKD3oACR+
         FzA225XeNLiQi782RrtgyC35pcdOpLPGk2PPd3rmJ+ymJOl4YsYbEbWdBLuwnX1sSOAR
         1k1SbJ0PnpGkXnWjdUORgjG5Nwb8YsV/6w3pP1+MvpZh/JWaEFxTO0ljqCTjJy6yo6+z
         QS5g==
X-Gm-Message-State: AGi0PuZ17LL/ZYm+RWinS5IZr5jsy8kzTyeUli852kNyFu1pVsM6BKdY
        BPm6XZbD4hFI/L6ssyhEWwH+4UhB
X-Google-Smtp-Source: APiQypJ4w0hWF8CoHHogyOHGgu3M/kb0Rt+BTSfYx2JfiCdbmVXifyBBri5ZmZJcyNt3XQa3Llpq5w==
X-Received: by 2002:a05:600c:441a:: with SMTP id u26mr10292938wmn.154.1587243779839;
        Sat, 18 Apr 2020 14:02:59 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u3sm27568524wrt.93.2020.04.18.14.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:02:58 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: phy: realtek: add delay to resume path
 of certain internal PHY's
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c4e18f15-7c37-13a2-4e26-1203da318f67@gmail.com>
 <77a1f6da-0089-71bc-38bf-3180aaaeca36@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d0380453-c73a-2c6f-8c96-041a52cd191c@gmail.com>
Date:   Sat, 18 Apr 2020 14:02:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <77a1f6da-0089-71bc-38bf-3180aaaeca36@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/18/2020 1:08 PM, Heiner Kallweit wrote:
> Internal PHY's from RTL8168h up may not be instantly ready after calling
> genphy_resume(). So far r8169 network driver adds the needed delay, but
> better handle this in the PHY driver. The network driver may miss other
> places where the PHY is resumed.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
