Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A7031AEAA
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhBNBX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhBNBX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:23:26 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFF9C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:22:46 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id l3so4120442oii.2
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ILLZcRaHWSJt8NDFCsH3KqV4mCrT8uqJnagcJWDZvJM=;
        b=jY41SkOPMZVualOU8WKsq4imGAYyj7Se1v1Nqlvl4EC7dY1KV6hCJuMAT6V5sBIIfY
         UmVu9cdAf0B6kNx1cJ/S8ZMb2ov68kNhvieLrcpQV9eNTOjhdTVPd8kVjh+1qx7ruIcZ
         Fxhxpk+CYyE+yz2RWJVswbYhYPqMRhP9Iysoywsmc4MFTkbzR0VaYx7ZBxRDYIry0I6A
         bqdVMxWY09l93xeuKYTuqai1VxOgIc74jp409cGQeasZsTUBYKOVIsJz4c72nlZ5y/id
         RRJlQd6R8LvoiXh4zRGDWDQfZzVU7o6TFUH999voj/UM+sITkgx83/0iVGFswNvC5QnS
         Js8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ILLZcRaHWSJt8NDFCsH3KqV4mCrT8uqJnagcJWDZvJM=;
        b=aNfW0/l+gsn6m6e+mpkmZmgi4bri9ZxPR7qzN0/2Vwpuova4xRdL9B7y35kzTSIC38
         jrEuhuZTgmSsVXk9qB/4GkMWc3ozuTJgEMErO0J6ZlJx7bMu9JN3zGO+d/GF37tQz39G
         bXuqEiNQQ9R9RnX6sDQ8K7Ab4aN4uDxMfl5YoK6p9uzThY8PY6a1p/jVgKwQ65AQuuJY
         LYx+GmhrzEp+KtGNkFUj4TMHXhqTEkLDZRWj0CD2APoDPvODeMNHTnGQSPH3eJwJYCuk
         1OEq6hqsy1RaqxqW4AmIrcHqbyrsIbSt6HC4pV4fvRK4QIhxwqpCf+ik2JgYOilZ3g5K
         f0mA==
X-Gm-Message-State: AOAM533Tt9Ikve6zM8E8QT7zwZ70jLATMHWHnsBgHNLlqWaFCmdaDQUW
        uDTQxW3c2uK1MR+kXqJpXrU=
X-Google-Smtp-Source: ABdhPJwEVHzYdp3IO6Ju6fOCDG1m3c2mcdXyg4VhqUOLQhbwoMr0KfQJgLa8jNRpbrHOPlvlqUcaUg==
X-Received: by 2002:aca:3d85:: with SMTP id k127mr4308626oia.157.1613265765357;
        Sat, 13 Feb 2021 17:22:45 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id h24sm2593759otl.50.2021.02.13.17.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 17:22:44 -0800 (PST)
Subject: Re: [PATCH v2 net-next 05/12] net: mscc: ocelot: refactor
 ocelot_port_inject_frame out of ocelot_port_xmit
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
References: <20210213223801.1334216-1-olteanv@gmail.com>
 <20210213223801.1334216-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <45bcc398-0dae-bf1b-50b8-b7af7b8e414b@gmail.com>
Date:   Sat, 13 Feb 2021 17:22:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213223801.1334216-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 14:37, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The felix DSA driver will inject some frames through register MMIO, same
> as ocelot switchdev currently does. So we need to be able to reuse the
> common code.
> 
> Also create some shim definitions, since the DSA tagger can be compiled
> without support for the switch driver.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
