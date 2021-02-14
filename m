Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9B831AEA0
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhBNBPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBNBPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:15:00 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE36C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:14:20 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id h17so179907oih.5
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VOJ1lmbN+vH57l1SG4QYmGF99ErbFQ96e3JnwrSs1qI=;
        b=q9CAjfPw2+kG7MrkRTnPnVgQ1Q0x5GTMODz1VrufnON+4l4zYAUidhBXVegG2uN+su
         guu4y1JAhVfkRT3csdXVzsMWut9JmLRkr2hrdZqg71XpdvoTnToq2TK9yZdxiCHlGwnY
         OG5dcF7HV1lBAdyq7vbZtrJo2Cp5AGi+jPJaeSvD4V2NRagjV/6n35i6kXU/TUACxrXX
         Dli0NS9GZPrJd4LUn23RMMd3ltU06SrL4HCNnKXRxU+xyyI+Ix+GtqrRY9u09ueIMvNT
         EJEKxh0kUszCxnSlrNaJqm9LkEfy69qTkN3I/KAxJCZa068gozi1llSECOxq2eg41aOZ
         9TAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VOJ1lmbN+vH57l1SG4QYmGF99ErbFQ96e3JnwrSs1qI=;
        b=L9/D72rSa1gb5rVshI12PI/ZoJcxajLRL2lD9naO40hL1KcBRJsH6dKxYtRRLAgrdb
         YpmFSZUU3IpDg1W9NnrePQ8EgCvBPL0UTRB2kJAdTZyJVJ/axrgBBuvAW1a9thiAqaAz
         Zrtz0PSkvMxwgNEVqPenfrp1HU1DSoLJTDAzadlzu76UI4t29E/G4etJ4yBWuEE4WZy4
         GbUXEYRmzrDwJBXZ9Q1osNufkMqUDqTUxCuIiSKulGzm+tVL8uaZaDpOaDuO/Z2oYS5I
         1u8IafnrBndiceCrAH2/W8FetuCoga6Gn+h1ntnQLWGnufc4KuZ4E/NQYt8JjjXUmvWG
         3j6g==
X-Gm-Message-State: AOAM531hjJ9AdmqIOwvCzS/eON45ayecZ5Gtvsb3Utig/N6q+K3X7mgp
        us+bbgYPDvGkmS5UEygDX60=
X-Google-Smtp-Source: ABdhPJz9pA/SRO7UYCUbqVKOsQ+8PzOmMUC7gcuZjiKyyme4NgLugoC4nfjhfDiTkAU9e5r1hbSvVQ==
X-Received: by 2002:aca:6256:: with SMTP id w83mr4341861oib.170.1613265259635;
        Sat, 13 Feb 2021 17:14:19 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id 3sm2853062oid.27.2021.02.13.17.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 17:14:18 -0800 (PST)
Subject: Re: [PATCH net-next 3/5] net: bridge: propagate extack through
 switchdev_port_attr_set
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
References: <20210213204319.1226170-1-olteanv@gmail.com>
 <20210213204319.1226170-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5361d33d-6acb-8da3-e472-c51ead66e771@gmail.com>
Date:   Sat, 13 Feb 2021 17:14:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213204319.1226170-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 12:43, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The benefit is the ability to propagate errors from switchdev drivers
> for the SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING and
> SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL attributes.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
