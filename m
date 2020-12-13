Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63832D8B30
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 04:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392163AbgLMDnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 22:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgLMDnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 22:43:55 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D83C0613CF;
        Sat, 12 Dec 2020 19:43:14 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id q25so15090073oij.10;
        Sat, 12 Dec 2020 19:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aLMv7bv//grEdHcZE3Ga0rjuWlHjH5Gf0eUa19zRJrQ=;
        b=sA271PWlMNitfIcgRi1Rvcy+v+0cABEo3Du/WflzKU/dTtae3WDiwSk0qaSwmCPEvb
         qbLHCzQtRY4zP+A34qnL+yyxD6dwK0mT/7EHOOvyCrsvGu2GzMageMe68FA+r7qfkGG3
         FZqX24Gh5FRbda9BOPJpSUExXPURHVEY2PZwy+RUn7na7BgKA+RcKf10S6+FtqnI2inX
         +079tFPY5xaemXlaY89MVgkBaJ1A5ma2afSgCOwH61a2E6CKe1FbYc96GeGWWeIvdofM
         4T8dpVJqXwd6snwzb9L2ScFaljBRicUt6yQRFAPWUIzAlLZ/5gjvr1tH09TyALZAn2yp
         Zrcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aLMv7bv//grEdHcZE3Ga0rjuWlHjH5Gf0eUa19zRJrQ=;
        b=KAPtw/xBUDm36yO67Yu5Bwri3a/VeRMu3JuC0TWEUVRTDKFJxqiDSQcYJWteflbNOy
         l1FIz8U5MCefUrf7fGk6UO1w6yHMdvHk3xkzFNiNSPmcOGg/5ztWfLKAsEL6aeDw/LTN
         K6m2oRgx+Ba5m7KXdEH5vwxraHTZohJk5XMuv1r0jnQsrGKnKjG262mpQrlfHFWr8Gng
         QB46CdI8kZvZPIoxU+mkPPANOeI5zNam6q4xET21X2VX1bcJrQQ00cGZlWdPXyx427PH
         0RmQ683ngfy16xgWca/4oX5/COOxNMpY3FMG03BRw/SL8qK7+9Inw/rYJlTSujVMz/0k
         oaJw==
X-Gm-Message-State: AOAM5339N4OtsiULRPT3imyff4hdsiIq5NINmGGScW42RpPm8TB+bXjh
        x1SrEvFwQwNRVfuMkruoeyw=
X-Google-Smtp-Source: ABdhPJzRk7A3ZZeJR9uQqVQYmJbfWlQv2jn+usTzLnZEDAMsEvcuvH4F5/5UWeqTrxm6J8HqOOndHA==
X-Received: by 2002:aca:2418:: with SMTP id n24mr13792346oic.62.1607830994270;
        Sat, 12 Dec 2020 19:43:14 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:5c21:b591:3efd:575e? ([2600:1700:dfe0:49f0:5c21:b591:3efd:575e])
        by smtp.gmail.com with ESMTPSA id s26sm3160664otd.8.2020.12.12.19.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 19:43:13 -0800 (PST)
Subject: Re: [PATCH v2 net-next 2/6] net: dsa: don't use
 switchdev_notifier_fdb_info in dsa_switchdev_event_work
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
References: <20201213024018.772586-1-vladimir.oltean@nxp.com>
 <20201213024018.772586-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6ee91a90-9c27-9001-66af-9bf16081f3b5@gmail.com>
Date:   Sat, 12 Dec 2020 19:43:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201213024018.772586-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2020 6:40 PM, Vladimir Oltean wrote:
> Currently DSA doesn't add FDB entries on the CPU port, because it only
> does so through switchdev, which is associated with a net_device, and
> there are none of those for the CPU port.
> 
> But actually FDB addresses on the CPU port have some use cases of their
> own, if the switchdev operations are initiated from within the DSA
> layer. There is just one problem with the existing code: it passes a
> structure in dsa_switchdev_event_work which was retrieved directly from
> switchdev, so it contains a net_device. We need to generalize the
> contents to something that covers the CPU port as well: the "ds, port"
> tuple is fine for that.
> 
> Note that the new procedure for notifying the successful FDB offload is
> inspired from the rocker model.
> 
> Also, nothing was being done if added_by_user was false. Let's check for
> that a lot earlier, and don't actually bother to schedule the worker
> for nothing.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
