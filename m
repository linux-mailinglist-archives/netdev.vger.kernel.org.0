Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53093B50D6
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 04:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhF0C6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 22:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhF0C6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 22:58:23 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB1DC061574
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 19:55:58 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id v7so12111890pgl.2
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 19:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c5EWtGUx9ZRp325Wj5021/NoEepkMsKhBX29uNd61x8=;
        b=UA7+0W13nkrhM917nhX0BGNaMA969/83JbXEYHZFtGY7IEi3XqlV6Z93QeBgwmgePF
         Pw/nO7NlvGOMjxzcVqs3qXbqAFtTJF0Gsjrt8P9F9SkPMnIYJYZVMN7Gn+tVj16Xtp/b
         gErkU6aSRnvs9N8CKBprOAxOw0P/fyVcKRCwJfbu/yK6ZCd6CIHc376ZEw6R3uFa0kgA
         fFKxbs8FrVZjXiXmmJUSPs2j+xNjLxp6LP0iV1avTKRJZWyheN8tRwJCYJlb9OEgKzv8
         hjulXmZ3Ebt3D7JmqHp7EJZmcrBF11Zipe65OPh8qH0PifZpjhWLu628DaU/S9r84ere
         NsOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c5EWtGUx9ZRp325Wj5021/NoEepkMsKhBX29uNd61x8=;
        b=d3ijkJAXTo0LfD1KvVRC38J78Qvy57I8NIRYIQx+nonjZzoMezpxGz6tND8CNAz78I
         Ngwdp+GLt1UtAZwbv0zIfKLJ55BQQLtMCNWY6mehlktDW6Yx8PfHNgb89zXQh9agsD2s
         5MLYuBONaxq37tsT6fCcSOevx17tK0euUN9yRqrW1r/r2pG8IdyV/s3EBTYyseEMN74Q
         ZmxRpLysuUX5mDn25zPE1yFXPZ2CfWBryB5bZx3qNTVDG47UwuDgwuDopAgxC1dPBOHM
         kYriMWdsPeoKFmpULWRjAvXVijTv7eALgvxY1UWjYmEB25lytItEbNT9LjYKook2xp7S
         eJCA==
X-Gm-Message-State: AOAM5336yFLOFRho0p8Xv5bkQaTioie4JmyQ14S7QPB/aUpm97wzrVuT
        jTVlCS5NRUZeIE38EOBeA/I=
X-Google-Smtp-Source: ABdhPJzVL6nzO3JprwEwW4P/lW7vRCy74i7OohTNJaxyqdKbs105lRkrtfm6okxHcYXwWaOP8aeQ7A==
X-Received: by 2002:a63:5302:: with SMTP id h2mr7431316pgb.262.1624762558541;
        Sat, 26 Jun 2021 19:55:58 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id 1sm10296838pfo.92.2021.06.26.19.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Jun 2021 19:55:58 -0700 (PDT)
Subject: Re: [PATCH net-next 2/7] net: ocelot: delete call to br_fdb_replay
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210625185321.626325-1-olteanv@gmail.com>
 <20210625185321.626325-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7f61fb80-8118-e8cd-31cc-88dde60fbaf4@gmail.com>
Date:   Sat, 26 Jun 2021 19:55:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625185321.626325-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/2021 11:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Not using this driver, I did not realize it doesn't react to
> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE notifications, but it implements just
> the bridge bypass operations (.ndo_fdb_{add,del}). So the call to
> br_fdb_replay just produces notifications that are ignored, delete it
> for now.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
