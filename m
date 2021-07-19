Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60D33CCC68
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 04:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbhGSCzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 22:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbhGSCzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 22:55:40 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5666CC061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:52:40 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id h9so19144793oih.4
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WxKnE9VVIhW03+cH+9p6iQL7PxKsWgSsEqoZEEkW4H4=;
        b=FyBb6p+QwCom/Q45S/ycAcWLSxcczSHOGV3NQ1SizOB/wz6L44mjjsBfgTe1NIDILv
         Qs1wH0vYjb1g3PRufdBmip9lE9noEHSg95/B5nxgb4jdkH5N4+mudsjGP+SAXvQF6de1
         1RyBWkB5a+Mi/n3xN3Ag+v3xFMtVXyTFyQVgw29UfZNdv44uRtXA3aTRzBRwOnJ/Bb2j
         nd/hyOrKvVfb0iK997TxuLglVS1/Nf1PXLFrZZvvtkrDW9qSwNUxM6IECsipDleqsaOl
         ZLh7k9Nlov1kvpO2yyf1tOeicqrNkF9FD4cdlH/Cz49w/UXmjnwuZGzsnfbYkZxwh5SW
         CD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WxKnE9VVIhW03+cH+9p6iQL7PxKsWgSsEqoZEEkW4H4=;
        b=bkmSFfSqb9KWU8Il/f6GUBGjGIV3c0XBZNwovpZ/Lu/ivenN5xd4i6IfD6wMmS7F8l
         H/BokGkHI/yKVreonFMNDk0Mucmo+uHL2b5gYdm/Ay58cV170TdlTybk6MfvsoQG30uK
         vOP4Uh+PjBgtN9nr19N5NQIXfsz8nECG87r1dxgq5pUNksu+vRw/+R3jHgPliE8bFSYz
         zy6oJ9FAkr32Qg4iR3r3HkgT6pT0PqBZAzgnzAVgWTbGk6TNty2RI3f85zj5BorAPSna
         Kpg5yx+y9iJFogXW7Y6DOofGBzjvXl9Rr6GdY2SdoBDRO0X5vg/ih05bc+wU4qOPQ9rz
         +vHA==
X-Gm-Message-State: AOAM532QBpOv+3LcbJGzNkMnqvEMnNerQMgIfW/L6WLRjnCPdWCHqGLG
        FJ4ztsZaXfbl0Bs2GkAP+ZE=
X-Google-Smtp-Source: ABdhPJx7n4EoVKcq+Sr9OjRUaJ8kvnBup9qs52qthhp3/k9g8n/JUv6MZQj1ukIFMDFqW+Pa7De7gA==
X-Received: by 2002:a05:6808:1494:: with SMTP id e20mr4291116oiw.111.1626663159708;
        Sun, 18 Jul 2021 19:52:39 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:49e1:751f:b992:b4f3? ([2600:1700:dfe0:49f0:49e1:751f:b992:b4f3])
        by smtp.gmail.com with ESMTPSA id o101sm3383766ota.61.2021.07.18.19.52.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 19:52:39 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 14/15] net: dsa: mv88e6xxx: map virtual
 bridges with forwarding offload in the PVT
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-15-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5915e957-8a22-54d4-fb56-aa080f21fce9@gmail.com>
Date:   Sun, 18 Jul 2021 19:52:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210718214434.3938850-15-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/2021 2:44 PM, Vladimir Oltean wrote:
> The mv88e6xxx switches have the ability to receive FORWARD (data plane)
> frames from the CPU port and route them according to the FDB. We can use
> this to offload the forwarding process of packets sent by the software
> bridge.
> 
> Because DSA supports bridge domain isolation between user ports, just
> sending FORWARD frames is not enough, as they might leak the intended
> broadcast domain of the bridge on behalf of which the packets are sent.
> 
> It should be noted that FORWARD frames are also (and typically) used to
> forward data plane packets on DSA links in cross-chip topologies. The
> FORWARD frame header contains the source port and switch ID, and
> switches receiving this frame header forward the packet according to
> their cross-chip port-based VLAN table (PVT).
> 
> To address the bridging domain isolation in the context of offloading
> the forwarding on TX, the idea is that we can reuse the parts of the PVT
> that don't have any physical switch mapped to them, one entry for each
> software bridge. The switches will therefore think that behind their
> upstream port lie many switches, all in fact backed up by software
> bridges through tag_dsa.c, which constructs FORWARD packets with the
> right switch ID corresponding to each bridge.
> 
> The mapping we use is absolutely trivial: DSA gives us a unique bridge
> number, and we add the number of the physical switches in the DSA switch
> tree to that, to obtain a unique virtual bridge device number to use in
> the PVT.
> 
> Co-developed-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
