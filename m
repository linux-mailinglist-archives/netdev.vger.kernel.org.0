Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0872D3F512E
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 21:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhHWTW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 15:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhHWTWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 15:22:55 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB1EC061760
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 12:22:12 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id v123so1525754pfb.11
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 12:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CK+AX2WqAyeiIDRVaoGcFyrLXxvEHB+VKpRPyD7xTQY=;
        b=dTdZl2E8g0hhfWmxWHZL4YwO/Hy7JNt3uPGL+6Mx78/nODBoKlzUddt+UX7B/I8XXb
         Q+hhIBbyQXKDA8RJ0AA9hb4Fmem9Amyk5NpU/wvvspUdDDGar3LLwgoLHUEv8y85A8H0
         sgykJpMm5gCdQlU+DQSMnZcSeCdUzZBpt48u/qK7s253Ql5ZqwITkY+y1Stj+9HFu33d
         ayzfqMnrBRx6BYtHcVwNqtGlolHxvFSLMh/drafXIkbOO26JtqRVA+WbzPKlxjwgG2S1
         IR7Lt7LgHzuRh6wLj7ebeJwgGGx6baVHNI94x9DF92u6xKphYosu0zh4N9R8c9KMFwUQ
         OjHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CK+AX2WqAyeiIDRVaoGcFyrLXxvEHB+VKpRPyD7xTQY=;
        b=NmEaqg3bpMclPIzu/Ta3yljrxsqstbUGtoWJ763VHEnQcAfonkhqd/El31olYEro8V
         lYsCSxsE2tPGCcqL8oh2eoSM1/5EHdYMbyuOVzkJbp5WO76nlAqhyJGU4Xe1gsaE1wcn
         S/yd+ZTX1AAfLMs/0pwe6hxuVHJK4kOq2JZx981lU2PsFksM9XY+35C7+3PGBPWFQDBx
         Ajhux2P+K1pPvVbp0NjDS1judyu10UVHx8yaZhMFu85UDZCQJAFgEoCh2t5/lhe1MIo9
         0YKX596q+Uvj8SOMCZR1afDfUzpKpIeli0yx3Ch76EZzO4IxvD0OK2rpu4acjQBmJ8pC
         OFIw==
X-Gm-Message-State: AOAM530PGpXcnT9IY/6Zm4G8Zr6XP41ASuxzEFG10kAAKf+aVgXrkqST
        jzKPTqyQNlMr/8/LZrQn73M=
X-Google-Smtp-Source: ABdhPJxCrQjPPihRCyKbLsD5o6ElCD/i4zG585U8m8uUqfUEbr2OuJ/1FqRjJ1J/yxW8OcAajNGVVA==
X-Received: by 2002:a63:70b:: with SMTP id 11mr33440494pgh.75.1629746531576;
        Mon, 23 Aug 2021 12:22:11 -0700 (PDT)
Received: from [192.168.1.22] (amarseille-551-1-7-65.w92-145.abo.wanadoo.fr. [92.145.152.65])
        by smtp.gmail.com with UTF8SMTPSA id ca7sm45305pjb.11.2021.08.23.12.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 12:22:10 -0700 (PDT)
Message-ID: <35e2b227-073b-9527-b0e3-088a47622ffd@gmail.com>
Date:   Mon, 23 Aug 2021 21:22:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH net-next 3/3] net: dsa: let drivers state that they need
 VLAN filtering while standalone
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20210823180242.2842161-1-vladimir.oltean@nxp.com>
 <20210823180242.2842161-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210823180242.2842161-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/23/2021 8:02 PM, Vladimir Oltean wrote:
> As explained in commit e358bef7c392 ("net: dsa: Give drivers the chance
> to veto certain upper devices"), the hellcreek driver uses some tricks
> to comply with the network stack expectations: it enforces port
> separation in standalone mode using VLANs. For untagged traffic,
> bridging between ports is prevented by using different PVIDs, and for
> VLAN-tagged traffic, it never accepts 8021q uppers with the same VID on
> two ports, so packets with one VLAN cannot leak from one port to another.
> 
> That is almost fine*, and has worked because hellcreek relied on an
> implicit behavior of the DSA core that was changed by the previous
> patch: the standalone ports declare the 'rx-vlan-filter' feature as 'on
> [fixed]'. Since most of the DSA drivers are actually VLAN-unaware in
> standalone mode, that feature was actually incorrectly reflecting the
> hardware/driver state, so there was a desire to fix it. This leaves the
> hellcreek driver in a situation where it has to explicitly request this
> behavior from the DSA framework.
> 
> We configure the ports as follows:
> 
> - Standalone: 'rx-vlan-filter' is on. An 8021q upper on top of a
>    standalone hellcreek port will go through dsa_slave_vlan_rx_add_vid
>    and will add a VLAN to the hardware tables, giving the driver the
>    opportunity to refuse it through .port_prechangeupper.
> 
> - Bridged with vlan_filtering=0: 'rx-vlan-filter' is off. An 8021q upper
>    on top of a bridged hellcreek port will not go through
>    dsa_slave_vlan_rx_add_vid, because there will not be any attempt to
>    offload this VLAN. The driver already disables VLAN awareness, so that
>    upper should receive the traffic it needs.
> 
> - Bridged with vlan_filtering=1: 'rx-vlan-filter' is on. An 8021q upper
>    on top of a bridged hellcreek port will call dsa_slave_vlan_rx_add_vid,
>    and can again be vetoed through .port_prechangeupper.
> 
> *It is not actually completely fine, because if I follow through
> correctly, we can have the following situation:
> 
> ip link add br0 type bridge vlan_filtering 0
> ip link set lan0 master br0 # lan0 now becomes VLAN-unaware
> ip link set lan0 nomaster # lan0 fails to become VLAN-aware again, therefore breaking isolation
> 
> This patch fixes that corner case by extending the DSA core logic, based
> on this requested attribute, to change the VLAN awareness state of the
> switch (port) when it leaves the bridge.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
