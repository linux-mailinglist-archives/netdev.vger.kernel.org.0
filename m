Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650FAE5F89
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 22:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfJZUbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 16:31:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39529 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbfJZUbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 16:31:42 -0400
Received: by mail-wm1-f65.google.com with SMTP id r141so5311857wme.4
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M70ZtvqM+XZL/Ore8lv/oCy/1b7f2g106NXi7HBmwPU=;
        b=ECGpdCDInZcs9Kd7kDKrYPlo4vzSrno6xpT4gWel//6CiCBfCrkOPx0qnPuvaTZSYu
         ZzQaDv4olRbqdAs/ixmvKE+VhDwjVPPveVfWtT0rw1XUUyya7XvmthXDScrYTDklAsks
         Qgr2a61iV2lyvCfxJNNxf/AQ1Mvij13dB6GvCSCkVfNzHwwgQMU7Ga2nPSbHG0SmCUwZ
         fPNWKdWYNvLbzCcSHVj7x9qHiw2l7W0qBS+LAMaSJqe4bDZlVmGm9dtbiGUeBU4gurpf
         Ibpb82pCbh3D9ayhfetM2IZ6FwWxdUCLiMISmQxCgC6PO9obuces41It9LFH0H6AzVaE
         NHwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M70ZtvqM+XZL/Ore8lv/oCy/1b7f2g106NXi7HBmwPU=;
        b=Jz7r1+wCTg/YPfLP+HgPwyiezC5EutyoAYIzY3vNDENTWA0KsmcIX211mx3fOaH3Uh
         SSUHcPGl7HrFt4F7uVe6s5hCec0+V4Kwu+TvwJNvwJvQDSLTHrhyREJZrrcwo+KXZ3wB
         nEAkDcGNRi3KtcBo1foZGo1lzuVQEy1+uaXDsDU1zgz33X8t6/P6ENoxQZsUsyCic1Si
         706L3cuYV+KoNXSjN3+7KC/LhIco0GDOqYc21yZ5c7213StOcPb2uUb6uRC6fqNPbiSy
         JK0b46Dz7UwdZyIiSUq3XpW958xHKenkKpCMVp+BElvPwdFwmfCvLBRuahwy7XDH+Odg
         goVg==
X-Gm-Message-State: APjAAAVfg4/OiTT3YwKV6VUiaYkHEEYrCRn5AeLOm4KMdKQ8yaMy97yB
        VGBTDMCQ15xVe/u0ip/LC7o=
X-Google-Smtp-Source: APXvYqy5U456TsG+fZckr9oUiA2or/S57QhwZHpk85a8JWmf4wXnybviMFZP0VbMe5XYEvcgvJkDnA==
X-Received: by 2002:a1c:9646:: with SMTP id y67mr2795427wmd.79.1572121899116;
        Sat, 26 Oct 2019 13:31:39 -0700 (PDT)
Received: from [10.230.7.147] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id u7sm6780586wre.59.2019.10.26.13.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Oct 2019 13:31:38 -0700 (PDT)
Subject: Re: [PATCH net 1/2] net: mscc: ocelot: fix vlan_filtering when
 enslaving to bridge before link is up
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, vivien.didelot@gmail.com,
        andrew@lunn.ch
References: <20191026180427.14039-1-olteanv@gmail.com>
 <20191026180427.14039-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b3eb1250-8a0d-5e54-82c0-4ab6ef9e9088@gmail.com>
Date:   Sat, 26 Oct 2019 13:31:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191026180427.14039-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/2019 11:04 AM, Vladimir Oltean wrote:
> Background information: the driver operates the hardware in a mode where
> a single VLAN can be transmitted as untagged on a particular egress
> port. That is the "native VLAN on trunk port" use case. Its value is
> held in port->vid.
> 
> Consider the following command sequence (no network manager, all
> interfaces are down, debugging prints added by me):
> 
> $ ip link add dev br0 type bridge vlan_filtering 1
> $ ip link set dev swp0 master br0
> 
> Kernel code path during last command:
> 
> br_add_slave -> ocelot_netdevice_port_event (NETDEV_CHANGEUPPER):
> [   21.401901] ocelot_vlan_port_apply: port 0 vlan aware 0 pvid 0 vid 0
> 
> br_add_slave -> nbp_vlan_init -> switchdev_port_attr_set -> ocelot_port_attr_set (SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING):
> [   21.413335] ocelot_vlan_port_apply: port 0 vlan aware 1 pvid 0 vid 0
> 
> br_add_slave -> nbp_vlan_init -> nbp_vlan_add -> br_switchdev_port_vlan_add -> switchdev_port_obj_add -> ocelot_port_obj_add -> ocelot_vlan_vid_add
> [   21.667421] ocelot_vlan_port_apply: port 0 vlan aware 1 pvid 1 vid 1
> 
> So far so good. The bridge has replaced the driver's default pvid used
> in standalone mode (0) with its own default_pvid (1). The port's vid
> (native VLAN) has also changed from 0 to 1.
> 
> $ ip link set dev swp0 up
> 
> [   31.722956] 8021q: adding VLAN 0 to HW filter on device swp0
> do_setlink -> dev_change_flags -> vlan_vid_add -> ocelot_vlan_rx_add_vid -> ocelot_vlan_vid_add:
> [   31.728700] ocelot_vlan_port_apply: port 0 vlan aware 1 pvid 1 vid 0
> 
> The 8021q module uses the .ndo_vlan_rx_add_vid API on .ndo_open to make
> ports be able to transmit and receive 802.1p-tagged traffic by default.
> This API is supposed to offload a VLAN sub-interface, which for a switch
> port means to add a VLAN that is not a pvid, and tagged on egress.
> 
> But the driver implementation of .ndo_vlan_rx_add_vid is wrong: it adds
> back vid 0 as "egress untagged". Now back to the initial paragraph:
> there is a single untagged VID that the driver keeps track of, and that
> has just changed from 1 (the pvid) to 0. So this breaks the bridge
> core's expectation, because it has changed vid 1 from untagged to
> tagged, when what the user sees is.
> 
> $ bridge vlan
> port    vlan ids
> swp0     1 PVID Egress Untagged
> 
> br0      1 PVID Egress Untagged
> 
> But curiously, instead of manifesting itself as "untagged and
> pvid-tagged traffic gets sent as tagged on egress", the bug:
> 
> - is hidden when vlan_filtering=0
> - manifests as dropped traffic when vlan_filtering=1, due to this setting:
> 
> 	if (port->vlan_aware && !port->vid)
> 		/* If port is vlan-aware and tagged, drop untagged and priority
> 		 * tagged frames.
> 		 */
> 		val |= ANA_PORT_DROP_CFG_DROP_UNTAGGED_ENA |
> 		       ANA_PORT_DROP_CFG_DROP_PRIO_S_TAGGED_ENA |
> 		       ANA_PORT_DROP_CFG_DROP_PRIO_C_TAGGED_ENA;
> 
> which would have made sense if it weren't for this bug. The setting's
> intention was "this is a trunk port with no native VLAN, so don't accept
> untagged traffic". So the driver was never expecting to set VLAN 0 as
> the value of the native VLAN, 0 was just encoding for "invalid".
> 
> So the fix is to not send 802.1p traffic as untagged, because that would
> change the port's native vlan to 0, unbeknownst to the bridge, and
> trigger unexpected code paths in the driver.
> 
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Fixes: 7142529f1688 ("net: mscc: ocelot: add VLAN filtering")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Nice explanation, thanks!
-- 
Florian
