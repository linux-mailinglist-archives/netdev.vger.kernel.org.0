Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335D031A44D
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhBLSLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhBLSLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 13:11:21 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994A7C061756;
        Fri, 12 Feb 2021 10:10:41 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id m6so14824pfk.1;
        Fri, 12 Feb 2021 10:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bytmtoINOEdkBtL4V2XAs15+q8GmAS7yZKBoJvhkgLk=;
        b=akE2ozj4n+Syf78UgJqCInvzuDDz+8VmFwiwu0NVDiPEtd9yuZancJkUYDsXQzYUbp
         ObndXxrSoodxkK60wJ6CouUlchzBZ3QP8k4bGVwfdMaQGNShPX5gMyLHokdta2A9EPEP
         DEApGNbbS247uAc79ayPDzMVwo1pC/QOSoxC2xFMT3tSTWuPrGkZqDtrKvfi0c+4YG1v
         kKxdMB4aFm280e4uW/KM2G4eO3f0iQkqyTYgX5pdNZKGS+IqNofZo2HkZD+KsnCZs9kZ
         RaHYXbRaeC1CMggg6p0Lw0mzj7wAvEO/tfwHENqV3oJSpWqbcOcPesH9LsuuO+2V3Sd2
         SRuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bytmtoINOEdkBtL4V2XAs15+q8GmAS7yZKBoJvhkgLk=;
        b=hLkyK2Nkt+F7PwhobC49LUXUnQnWeIvlS+PS4shq/+pIJdjTRDyo3/Gvb44W9PDvUc
         x1Oc9dpLDyRQLt+mH4qEKQvXSfsq+niHHfuO5Qq5/hvqeVrUPIdTiIC3ayiIiQbECyr/
         bhwgD4bvLBpxvkGBx0QgMyYO7uQzudVCpethFYjYVchOIHtDVsOhU+GrLp0Rea0Ik/hw
         bxyC37Ya33+Juom7vbwmmQ6UydaOOU80/vVOXKoS+qIV6L0sGQPHsKO6FCYtYmnwpKAC
         /L979FRUeX6Pgsl2X08iMHg+Qzu6JdoTtlELwDbS6p7FxQG1aNyqwLHS0+6lUddBuM01
         Wx+w==
X-Gm-Message-State: AOAM533UWkoffOWTVKdrER8EAI+zKPFcVUlQMN0+JWG/BaQV2QQrVI7D
        YXlVyz5hSFNJKBnpEiO8F7XeK9h7Ydg=
X-Google-Smtp-Source: ABdhPJz/Ti9d44Rv75w/tdspUxsn1D7i/I0j1GsylUmhWNr5eKXVF+yfHYMhqeLr+UkmhJ5ihnkcTQ==
X-Received: by 2002:a63:4e09:: with SMTP id c9mr4365562pgb.107.1613153440776;
        Fri, 12 Feb 2021 10:10:40 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e15sm11325899pgr.81.2021.02.12.10.10.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 10:10:40 -0800 (PST)
Subject: Re: [PATCH v5 net-next 05/10] net: switchdev: pass flags and mask to
 both {PRE_,}BRIDGE_FLAGS attributes
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
References: <20210212151600.3357121-1-olteanv@gmail.com>
 <20210212151600.3357121-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9a1efd0d-9930-cbc7-5450-ffb47a0034e4@gmail.com>
Date:   Fri, 12 Feb 2021 10:10:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210212151600.3357121-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/12/2021 7:15 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This switchdev attribute offers a counterproductive API for a driver
> writer, because although br_switchdev_set_port_flag gets passed a
> "flags" and a "mask", those are passed piecemeal to the driver, so while
> the PRE_BRIDGE_FLAGS listener knows what changed because it has the
> "mask", the BRIDGE_FLAGS listener doesn't, because it only has the final
> value. But certain drivers can offload only certain combinations of
> settings, like for example they cannot change unicast flooding
> independently of multicast flooding - they must be both on or both off.
> The way the information is passed to switchdev makes drivers not
> expressive enough, and unable to reject this request ahead of time, in
> the PRE_BRIDGE_FLAGS notifier, so they are forced to reject it during
> the deferred BRIDGE_FLAGS attribute, where the rejection is currently
> ignored.
> 
> This patch also changes drivers to make use of the "mask" field for edge
> detection when possible.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
