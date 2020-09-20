Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C0F2711C3
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 04:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgITCd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 22:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITCd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 22:33:26 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86276C061755
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:33:26 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id u3so5117710pjr.3
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qTuBn85+qBBUfKvfIllVPplsI7LO3SvmNLQaN2iyiJ8=;
        b=g6YchNk8ct/FVlpPTS+lfAQuVwXrx9SsoBPYxNnL9NIXg9t65dW+stF4mywRrvGZqf
         CMFp+H42pUYnV9GsobH8NcgacAwVtzfSDPWDAk6lYfR68iMsSsJdnBoyng0uem1mjDKH
         bc0We3YboOqkovJDJNsN4ahRg25m77Aem316jpgFSyQs2V4TiGlyE8ewdxY3x7eSgq6H
         rHSX+K0EdOPnUa3fcZM+BOzX/7dhPUk/r3xSivHh2Pq9iazpz3sA9YTdAa0ZV1RCoLmu
         6XLrx86tPwj8yViSkAgKIKKslgqC1tZ5jRfToeCnDv7asTK2JZO4OBLSqRxMjDWTRXUS
         T35A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qTuBn85+qBBUfKvfIllVPplsI7LO3SvmNLQaN2iyiJ8=;
        b=nGthwawq9dpdDJMKTKSQccUbzYPL6D/ImbMn+wOBITBJ1/jl02gMFjST9ecKTOWiHe
         nTHMQoKRUwP6LXt3Vq92SomsqQtk5ZT2C+Vo0ug5iZ+fkXao7Ctl9pmuaYJvNqKVi4tV
         VphCaXJds7X1C20SATtBU7o16IhmClKK7KZQBhRdlMWxoyRjTdX0PB0n6JcSteqm7C5b
         Eb19VnIaOH94+IzkjjbpgPFRIeAE6DiS5GYm1Rt1cfK4qiKJoau9RqJkA+av6qOdwI7Y
         bFjxhOqKs7eQ33zOieCd5xeMiaN/+Vyd2s2ezSa8CqbZ9V8OEHzh4r2SvGkspcAFjcJG
         hR9Q==
X-Gm-Message-State: AOAM531EEzAQTruwhwZyqGO7Ltv22Wt764vFbScxXfEZdrlPMX3GJ431
        UtDhMPLrWqzH8OvVpIpZ/NGaDXGSHh8yjw==
X-Google-Smtp-Source: ABdhPJwAu6y3U4Voziewj+rYYqwbrYSa3PgnG963QfNLqEmBwcFjPSvRY+xtsYkk9UmpOevLQrhTLQ==
X-Received: by 2002:a17:90b:883:: with SMTP id bj3mr18174744pjb.184.1600569205066;
        Sat, 19 Sep 2020 19:33:25 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id p11sm7921603pfq.130.2020.09.19.19.33.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 19:33:24 -0700 (PDT)
Subject: Re: [RFC PATCH 1/9] net: dsa: deny enslaving 802.1Q upper to
 VLAN-aware bridge from PRECHANGEUPPER
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, idosch@idosch.org,
        jiri@resnulli.us, kurt.kanzenbach@linutronix.de, kuba@kernel.org
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
 <20200920014727.2754928-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dbe191ee-aef5-2e32-c4a6-d18b3d73ebe3@gmail.com>
Date:   Sat, 19 Sep 2020 19:33:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920014727.2754928-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/2020 6:47 PM, Vladimir Oltean wrote:
> There doesn't seem to be any strong technical reason for doing it this
> way, but we'll be adding more checks for invalid upper device
> configurations, and it will be easier to have them all grouped under
> PRECHANGEUPPER.
> 
> Tested that it still works:
> ip link set br0 type bridge vlan_filtering 1
> ip link add link swp2 name swp2.100 type vlan id 100
> ip link set swp2.100 master br0
> [   20.321312] br0: port 5(swp2.100) entered blocking state
> [   20.326711] br0: port 5(swp2.100) entered disabled state
> Error: dsa_core: Cannot enslave VLAN device into VLAN aware bridge.
> [   20.346549] br0: port 5(swp2.100) entered blocking state
> [   20.351957] br0: port 5(swp2.100) entered disabled state
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
