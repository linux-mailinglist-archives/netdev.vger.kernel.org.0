Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B303CCC66
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 04:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbhGSCyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 22:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbhGSCyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 22:54:10 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D24DC061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:51:10 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id a132so8299707oib.6
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v2eXKPHVpTGWQBn4atDle/vMS0emj77aI3df3rtNZnA=;
        b=fb9/VEayTTjcPHY/YFefn3hXmbwkIW7AbJUab6yCFZL1ELWRkBfvzk1rHQAWNiMMRH
         rDMV2vEkTSEjRy14RE75QHsO0PV6f6S0S/FMeJeK/qxXk7uExR85nRLGqUYVNY2W8frk
         RdAiFtPjHlFWxfloLKHKf2RjXweu5vZoJ+yJ15XpIFw1nt5WqwVMjHVoDVz4HB5gqe2J
         O5ygDDW0AdSbVqwSxRyESQRVuYRn173FLlZdL1D9y7eQ3xwoMTMmtpOPd/BOzBgilkMz
         RUc4q0Y0Og4xC1z2e8dxRnIAubc80858XFsNHN9aYTn0PuJhrVdnTL/HUS1ZHsaFBr3e
         +HSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v2eXKPHVpTGWQBn4atDle/vMS0emj77aI3df3rtNZnA=;
        b=ffE9qylZtWJCGkJ6zFwMaTdbrCyMTkWxdDNvwjbhP8434uYI1d1Ox8g85BZQ5pIV0Y
         KluU8rogUuZiG2GrexfhbgqvP5Jb43MvCVnx3/B+j2E28+ODVrexKiJYOu1KzXb0ADzn
         hEn34zhwc96iCn/mrzb4Q2gy5EcSSSWlsibhdsjWKpRsxTlOKHsju9Nb92vdd9LvCyrn
         35vg500IVoWS13CqZV2LC6U7qmk1PThQNwHL7g/NopT82rEm7lJsP1ePQq9n+hIC9Q+K
         Sbqd3IzfXd9kUWznFSg98fmlV0ZQBPeDKgCLLMOBOW7B+kvesPDnN5owrQymzgYasvE1
         24Xg==
X-Gm-Message-State: AOAM532LN+X+IaBSBPnThNxo/Cm0xog86pQWW9fbZZgwKE7nESExJgYY
        WCHZb57sU4xHspl6gOd3KG8=
X-Google-Smtp-Source: ABdhPJzbVGILTYmD50dPpViVa5gdKnY8iO74vYhfJT6Xq8hJuKne+ZniqLCFuI5CkL1eIikVp7ZW3w==
X-Received: by 2002:aca:f58e:: with SMTP id t136mr20382103oih.33.1626663069822;
        Sun, 18 Jul 2021 19:51:09 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:49e1:751f:b992:b4f3? ([2600:1700:dfe0:49f0:49e1:751f:b992:b4f3])
        by smtp.gmail.com with ESMTPSA id i16sm3379124otp.7.2021.07.18.19.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 19:51:09 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 13/15] net: dsa: add support for bridge TX
 forwarding offload
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
 <20210718214434.3938850-14-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f6918f62-0482-f89a-61c6-c4d8071192a8@gmail.com>
Date:   Sun, 18 Jul 2021 19:51:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210718214434.3938850-14-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/2021 2:44 PM, Vladimir Oltean wrote:
> For a DSA switch, to offload the forwarding process of a bridge device
> means to send the packets coming from the software bridge as data plane
> packets. This is contrary to everything that DSA has done so far,
> because the current taggers only know to send control packets (ones that
> target a specific destination port), whereas data plane packets are
> supposed to be forwarded according to the FDB lookup, much like packets
> ingressing on any regular ingress port. If the FDB lookup process
> returns multiple destination ports (flooding, multicast), then
> replication is also handled by the switch hardware - the bridge only
> sends a single packet and avoids the skb_clone().
> 
> DSA plays a substantial role in backing the forwarding offload, and
> leaves relatively few things up to the switch driver. In particular, DSA
> keeps for each bridge port a zero-based index (the number of the
> bridge). Multiple ports enslaved to the same bridge have a pointer to
> the same accel_priv structure.
> 
> The tagger can check if the packet that is being transmitted on has
> skb->offload_fwd_mark = true or not. If it does, it can be sure that the
> packet belongs to the data plane of a bridge, further information about
> which can be obtained based on dp->bridge_dev and dp->bridge_num.
> It can then compose a DSA tag for injecting a data plane packet into
> that bridge number.
> 
> For the switch driver side, we offer two new dsa_switch_ops methods,
> called .port_bridge_fwd_offload_{add,del}, which are modeled after
> .port_bridge_{join,leave}.
> These methods are provided in case the driver needs to configure the
> hardware to treat packets coming from that bridge software interface as
> data plane packets. The switchdev <-> bridge interaction happens during
> the netdev_master_upper_dev_link() call, so to switch drivers, the
> effect is that the .port_bridge_fwd_offload_add() method is called
> immediately after .port_bridge_join().
> 
> If the bridge number exceeds the number of bridges for which the switch
> driver can offload the TX data plane (and this includes the case where
> the driver can offload none), DSA falls back to simply returning
> tx_fwd_offload = false in the switchdev_bridge_port_offload() call.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
