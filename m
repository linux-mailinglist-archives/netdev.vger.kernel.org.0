Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F6D31844C
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 05:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhBKEVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 23:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhBKEVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 23:21:06 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E75C061574;
        Wed, 10 Feb 2021 20:20:26 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d13so2645050plg.0;
        Wed, 10 Feb 2021 20:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ofWIvbul8lUQjDjEqyhG2qv/DpTdeTq9suCAukT4VnE=;
        b=cJkf+VIciLaXv1lixjdR8iXxDvJD4ZVrqUo9pLZZOczna0nt6lXw+gvOZNbOiFr9Ax
         xXLtvTJtKB5ICTmJeynxBdn39We/Qj+tzybWJLI+YpQpya8NbF7CEqhU7uDvPD9/+aOb
         X0MP9xdLMPmQZ1cdXlY2M8wEiztJgbsc+o3R1enU36K44psdbuPcp0FECGfnmjGLvkEl
         pbmJ/ca9FeGs5zLyGfHWDyiQ2R41jRN6favzNvY7kfjbXs7nx57QxGt5Mgrp1a/IBocm
         NkcfcU38GSec03drey6h7xPphlkEwIMZIn88AfGtDhxqRP3qliCqabex9N/PNUJs9bvl
         9l8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ofWIvbul8lUQjDjEqyhG2qv/DpTdeTq9suCAukT4VnE=;
        b=LK7MAF56gcTYHmG9U9VDdUJMKYlNzcxhecNFu5Nau7DdctBPY0+fJWs8+UUKeT+rb2
         8626HbSRRtv3N9iCCI91t9DNYNEFoj4dTMc/wE5f3G+6BYGMk0dY9OxmNgjliCNbPiib
         gjFNWdgj/3PMkDtK5FrkRP9KAq//6H+zuU2M3n0V2th2yPMnmHONuXcDTWjKjM4m/FEP
         9JNyRjQbiv7WvcWR2sBvJ7VeZ9f/z2vlsfn7WIdk1dAdXRLNMd/uK9Jgdp7lEc44W+7l
         emDhvJbUj7CI5kkzez92/chx7Evwb+B59R4O/PjFtpN4b+tOX+AG0YpCWYi8LbFHOEJc
         QdGg==
X-Gm-Message-State: AOAM530w/szf/FU96G24tdTjbNd2+rKXZ/VAuih91bxSO+MF4eDgWZpI
        MWd/WyU1RAPyBWcB7+w7pzySRQ3rfWM=
X-Google-Smtp-Source: ABdhPJxywamPXOiUFuBiMJGeS5MBf6KcEI2wQhgt6ksWCRY9UWhZ7BoITqmymMwz37b/iZ4sU43/7g==
X-Received: by 2002:a17:902:7847:b029:df:d889:252c with SMTP id e7-20020a1709027847b02900dfd889252cmr5985974pln.76.1613017225380;
        Wed, 10 Feb 2021 20:20:25 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 68sm3644935pfe.33.2021.02.10.20.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 20:20:24 -0800 (PST)
Subject: Re: [PATCH v3 net-next 10/11] net: mscc: ocelot: offload bridge port
 flags to device
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
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
References: <20210210091445.741269-1-olteanv@gmail.com>
 <20210210091445.741269-11-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a5a4e1e8-8370-954f-ab4e-20a52f54d468@gmail.com>
Date:   Wed, 10 Feb 2021 20:20:21 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210091445.741269-11-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2021 1:14 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> We should not be unconditionally enabling address learning, since doing
> that is actively detrimential when a port is standalone and not offloading
> a bridge. Namely, if a port in the switch is standalone and others are
> offloading the bridge, then we could enter a situation where we learn an
> address towards the standalone port, but the bridged ports could not
> forward the packet there, because the CPU is the only path between the
> standalone and the bridged ports. The solution of course is to not
> enable address learning unless the bridge asks for it.
> 
> We need to set up the initial port flags for no learning and flooding
> everything, then the bridge takes over. The flood configuration was
> already configured ok in ocelot_init, we just need to disable learning
> in ocelot_init_port.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
