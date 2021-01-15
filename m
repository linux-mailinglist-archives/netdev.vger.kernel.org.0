Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825382F812F
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbhAOQu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbhAOQu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:50:28 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C02C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:49:47 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id x20so134688pjh.3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4GV12z3SC0201k37ANB10q+RfQzIsZosjSLlDFeUKeo=;
        b=OC0K77c4ikrHAarsM6b9BDJUzkGGRYIR1MEy3a6vvBjZ/n6tn3XD355PLwQ1776E5H
         CuMsHHhShQ9gz9wFGgXyqdMR+290sZaoV2nyTpqccI5OEamUqpilLo/3t4rXbrmazDXA
         kAdEr+3R4Js1YJwMizKeZllM9fTuBXo3xvM5jJnFEwTI+QTQE1inOYhRBwUnPS4cHctU
         IKX7ZXZebDeN3jpMX05FUj2/zcaqK6kxHQ7DKUnjkyw4hDsTYvnjHZGMM2JF8Fa0SQ3V
         7NJE3Qj7PBameOclFQdkPdz80t4PjUwc1sXuOyb8WKO5HUJQ59ZJgLAOroC7kymMT7ef
         9GwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4GV12z3SC0201k37ANB10q+RfQzIsZosjSLlDFeUKeo=;
        b=Ado/kbHTMnNSrBqtbk97MwtSHy4NUl3+VFl6TbMlOWtytPn7bmYkEskmAKA8YOP7FB
         3cOhkP8mQ13ssE0Q3cotEbiUswXq+MSzhcYTqG5eHb/hZvo8xt3qrG8skHg0uj7KKhw3
         5VUK4NV4outMIzorxf1cfIJ1jDEE8nsCNQNWrSEtSO5aoJxRoOFYgzfyWqy9943tkSQ1
         DF5fsFlbs5sfKjQvwqpFUNaoMSg7XLMr/Mj4TNuTRYopIO+2iSrihLsredd1M6b8Fktm
         n6u1FtS3+i/KTGUg2ZJI8EOlS/3ms3Y3ir/FxIuv6l3oCZsA7gFAW3Si3ZjvtJhfmdho
         HI5w==
X-Gm-Message-State: AOAM532iHdTV4RSF0mcPuJThvSJ+CjWzfTBigIhEj7b91+e2MRVJ1Um/
        OBX8Ol6ImKNox56Yht4Qbmg=
X-Google-Smtp-Source: ABdhPJxnhAkJlFekRUEeLjrqIyRrEKkVpj9x0ofQvH6qmXBfr/VxqxXjgDvzsN2ADZ6Szdxw2aRd1w==
X-Received: by 2002:a17:90a:4096:: with SMTP id l22mr11274964pjg.114.1610729387187;
        Fri, 15 Jan 2021 08:49:47 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d8sm3856515pjm.30.2021.01.15.08.49.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 08:49:46 -0800 (PST)
Subject: Re: [PATCH net-next] net: dsa: set configure_vlan_while_not_filtering
 to true by default
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>
References: <20210114173426.2731780-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fc42fb41-eb97-5ace-91ae-7e4c2d75743f@gmail.com>
Date:   Fri, 15 Jan 2021 08:49:43 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210114173426.2731780-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/14/2021 9:34 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As explained in commit 54a0ed0df496 ("net: dsa: provide an option for
> drivers to always receive bridge VLANs"), DSA has historically been
> skipping VLAN switchdev operations when the bridge wasn't in
> vlan_filtering mode, but the reason why it was doing that has never been
> clear. So the configure_vlan_while_not_filtering option is there merely
> to preserve functionality for existing drivers. It isn't some behavior
> that drivers should opt into. Ideally, when all drivers leave this flag
> set, we can delete the dsa_port_skip_vlan_configuration() function.
> 
> New drivers always seem to omit setting this flag, for some reason. So
> let's reverse the logic: the DSA core sets it by default to true before
> the .setup() callback, and legacy drivers can turn it off. This way, new
> drivers get the new behavior by default, unless they explicitly set the
> flag to false, which is more obvious during review.
> 
> Remove the assignment from drivers which were setting it to true, and
> add the assignment to false for the drivers that didn't previously have
> it. This way, it should be easier to see how many we have left.
> 
> The following drivers: lan9303, mv88e6060 were skipped from setting this
> flag to false, because they didn't have any VLAN offload ops in the
> first place.
> 
> The Broadcom Starfighter 2 driver calls the common b53_switch_alloc and
> therefore also inherits the configure_vlan_while_not_filtering=true
> behavior.
> 
> Also, print a message through netlink extack every time a VLAN has been
> skipped. This is mildly annoying on purpose, so that (a) it is at least
> clear that VLANs are being skipped - the legacy behavior in itself is
> confusing, and the extack should be much more difficult to miss, unlike
> kernel logs - and (b) people have one more incentive to convert to the
> new behavior.
> 
> No behavior change except for the added prints is intended at this time.
> 
> $ ip link add br0 type bridge vlan_filtering 0
> $ ip link set sw0p2 master br0
> [   60.315148] br0: port 1(sw0p2) entered blocking state
> [   60.320350] br0: port 1(sw0p2) entered disabled state
> [   60.327839] device sw0p2 entered promiscuous mode
> [   60.334905] br0: port 1(sw0p2) entered blocking state
> [   60.340142] br0: port 1(sw0p2) entered forwarding state
> Warning: dsa_core: skipping configuration of VLAN. # This was the pvid
> $ bridge vlan add dev sw0p2 vid 100
> Warning: dsa_core: skipping configuration of VLAN.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
