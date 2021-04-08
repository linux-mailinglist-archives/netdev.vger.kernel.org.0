Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2D7358CE4
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhDHSsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbhDHSsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:48:51 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0601C061760;
        Thu,  8 Apr 2021 11:48:39 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id z22-20020a17090a0156b029014d4056663fso1930098pje.0;
        Thu, 08 Apr 2021 11:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QkZRHIeVAtMclnbf69iEmwFuxNIgUD1wl1hPkUbv0+4=;
        b=JeL4/htdYtHE3hOWpnmiUh0UNlkkuVLE1e4Nu/UNDrd5gzGAqHyXZsdqEpS1R3ICyb
         Y7ZgnktRRTqzIqywZMaaAY9wV+OPW+D6HYf9u96znmAheJZMQgEAJiQsfqYjWkNSiSbj
         YfDh97J7OenVx+II2koVQ5kMRJM70stbUjbfriwxYmgLcKcD/S7Dz1MfsmB+whZKN8k5
         Cm9kwKOvNyen/5XyB7FUUfEbNmU5njNXuGFGcm6tlcoYys6J28kCp7DUA3J+gHj5QAV8
         QJc5KhkDPEdWx+667JE3251j7Kwv+6xMGPOU8Y0Gbsyqt4fSAAcAULjj0iWcZ9asxxXd
         RP8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QkZRHIeVAtMclnbf69iEmwFuxNIgUD1wl1hPkUbv0+4=;
        b=TDx+Z60MznK8Nd2WJVWO8ABISBCvt7YFFpHn4FIOm4UpJcaduzHpbvULztMNN9jOcQ
         /Xf7Md5wHYnC3PhKNsZjcgvJNS/oaB9kzNdySG8f1DE4RYNCqr1UUZQQLwVQZak77f7z
         nxV9uxGgzdIMQCRHblag9r+DhvS2mO2bs61DKmXGxWcTZeouCznAPfyAk4ntAkA5/3W9
         jCaWJtAn61nqCKcwO/s34DN30fFkmehgzfqrAUBif72Q7gXQiN+gv8DDjQ5CeD0KKkGx
         oShLDzCrNm13i47WPIzl3Si8mBNUUYHyBjnfsgZEbm2F+aGun99afXCdVfYjKvubgSSk
         RyoQ==
X-Gm-Message-State: AOAM533qU10QQDKyQ3sqD58ihSsIKTkgV7t1WFd1dEVeil6ZDjHcE5c8
        B6K5MzpOwPfH+Go248T/bj3gmixaE9I=
X-Google-Smtp-Source: ABdhPJz6nMDs7woEDIGKCe65uJ5cWjQgSxzD8EB0fAZgtitxpsgQckjPSrXph54VDnfYBJOXfqHPuA==
X-Received: by 2002:a17:90b:1b0c:: with SMTP id nu12mr9996958pjb.129.1617907718784;
        Thu, 08 Apr 2021 11:48:38 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l1sm122385pgt.29.2021.04.08.11.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 11:48:38 -0700 (PDT)
Subject: Re: [PATCH net v2 1/2] net: dsa: lantiq_gswip: Don't use PHY auto
 polling
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210408183828.1907807-1-martin.blumenstingl@googlemail.com>
 <20210408183828.1907807-2-martin.blumenstingl@googlemail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8be6a8c9-67d3-b1ed-7d1e-e594ba73ae13@gmail.com>
Date:   Thu, 8 Apr 2021 11:48:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210408183828.1907807-2-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/8/2021 11:38 AM, Martin Blumenstingl wrote:
> PHY auto polling on the GSWIP hardware can be used so link changes
> (speed, link up/down, etc.) can be detected automatically. Internally
> GSWIP reads the PHY's registers for this functionality. Based on this
> automatic detection GSWIP can also automatically re-configure it's port
> settings. Unfortunately this auto polling (and configuration) mechanism
> seems to cause various issues observed by different people on different
> devices:
> - FritzBox 7360v2: the two Gbit/s ports (connected to the two internal
>   PHY11G instances) are working fine but the two Fast Ethernet ports
>   (using an AR8030 RMII PHY) are completely dead (neither RX nor TX are
>   received). It turns out that the AR8030 PHY sets the BMSR_ESTATEN bit
>   as well as the ESTATUS_1000_TFULL and ESTATUS_1000_XFULL bits. This
>   makes the PHY auto polling state machine (rightfully?) think that the
>   established link speed (when the other side is Gbit/s capable) is
>   1Gbit/s.
> - None of the Ethernet ports on the Zyxel P-2812HNU-F1 (two are
>   connected to the internal PHY11G GPHYs while the other three are
>   external RGMII PHYs) are working. Neither RX nor TX traffic was
>   observed. It is not clear which part of the PHY auto polling state-
>   machine caused this.
> - FritzBox 7412 (only one LAN port which is connected to one of the
>   internal GPHYs running in PHY22F / Fast Ethernet mode) was seeing
>   random disconnects (link down events could be seen). Sometimes all
>   traffic would stop after such disconnect. It is not clear which part
>   of the PHY auto polling state-machine cauased this.
> - TP-Link TD-W9980 (two ports are connected to the internal GPHYs
>   running in PHY11G / Gbit/s mode, the other two are external RGMII
>   PHYs) was affected by similar issues as the FritzBox 7412 just without
>   the "link down" events
> 
> Switch to software based configuration instead of PHY auto polling (and
> letting the GSWIP hardware configure the ports automatically) for the
> following link parameters:
> - link up/down
> - link speed
> - full/half duplex
> - flow control (RX / TX pause)
> 
> After a big round of manual testing by various people (who helped test
> this on OpenWrt) it turns out that this fixes all reported issues.
> 
> Additionally it can be considered more future proof because any
> "quirk" which is implemented for a PHY on the driver side can now be
> used with the GSWIP hardware as well because Linux is in control of the
> link parameters.
> 
> As a nice side-effect this also solves a problem where fixed-links were
> not supported previously because we were relying on the PHY auto polling
> mechanism, which cannot work for fixed-links as there's no PHY from
> where it can read the registers. Configuring the link settings on the
> GSWIP ports means that we now use the settings from device-tree also for
> ports with fixed-links.
> 
> Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Fixes: 3e6fdeb28f4c33 ("net: dsa: lantiq_gswip: Let GSWIP automatically set the xMII clock")
> Cc: stable@vger.kernel.org
> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
