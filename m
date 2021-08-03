Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324473DEBA4
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhHCLTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:19:14 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:57594 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235467AbhHCLTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 07:19:13 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 173BIjbx114050;
        Tue, 3 Aug 2021 06:18:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1627989525;
        bh=xOfUPHHqXVwjF79ATT4GN2kZvtYkfFv5v8eXZAY31GQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=fjNZeXY/VWBa/4VsSDhJfHzAdOXle125mDkxgMdz5rl9GAblcSpGkxEFR1PDgqlnU
         /M01c9+hiwiBTirfoZGVEOGuhz935RrM86Q5aDryphlVTyZB9kSlhteyd1eqhy8YrM
         sPbddqZjUFJTDXGwPIfd8NVlKgNQmhO5IxnZojsg=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 173BIjKe067253
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Aug 2021 06:18:45 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 3 Aug
 2021 06:18:45 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Tue, 3 Aug 2021 06:18:44 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 173BIebq100518;
        Tue, 3 Aug 2021 06:18:40 -0500
Subject: Re: [PATCH net-next] net: build all switchdev drivers as modules when
 the bridge is a module
To:     Arnd Bergmann <arnd@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20210726142536.1223744-1-vladimir.oltean@nxp.com>
 <CAK8P3a2HGm7MyUc3N1Vjdb2inS6D3E3HDq4bNTOBaHZQCP9kwA@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <eab61b8f-fc54-ea63-ad31-73fb13026b1f@ti.com>
Date:   Tue, 3 Aug 2021 14:18:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2HGm7MyUc3N1Vjdb2inS6D3E3HDq4bNTOBaHZQCP9kwA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

On 02/08/2021 17:47, Arnd Bergmann wrote:
> On Mon, Jul 26, 2021 at 4:28 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>>
>> Currently, all drivers depend on the bool CONFIG_NET_SWITCHDEV, but only
>> the drivers that call some sort of function exported by the bridge, like
>> br_vlan_enabled() or whatever, have an extra dependency on CONFIG_BRIDGE.
>>
>> Since the blamed commit, all switchdev drivers have a functional
>> dependency upon switchdev_bridge_port_{,un}offload(), which is a pair of
>> functions exported by the bridge module and not by the bridge-independent
>> part of CONFIG_NET_SWITCHDEV.
>>
>> Problems appear when we have:
>>
>> CONFIG_BRIDGE=m
>> CONFIG_NET_SWITCHDEV=y
>> CONFIG_TI_CPSW_SWITCHDEV=y
>>
>> because cpsw, am65_cpsw and sparx5 will then be built-in but they will
>> call a symbol exported by a loadable module. This is not possible and
>> will result in the following build error:
>>
>> drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_netdevice_event':
>> drivers/net/ethernet/ti/cpsw_new.c:1520: undefined reference to
>>                                          `switchdev_bridge_port_offload'
>> drivers/net/ethernet/ti/cpsw_new.c:1537: undefined reference to
>>                                          `switchdev_bridge_port_unoffload'
>>
>> As mentioned, the other switchdev drivers don't suffer from this because
>> switchdev_bridge_port_offload() is not the first symbol exported by the
>> bridge that they are calling, so they already needed to deal with this
>> in the same way.
>>
>> Fixes: 2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform which bridge ports are offloaded")
>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> I'm still seeing build failures after this patch was applied. I have a fixup
> patch that seems to work, but I'm still not sure if that version is complete.

In my opinion, the problem is a bit bigger here than just fixing the build :(

In case, of ^cpsw the switchdev mode is kinda optional and in many cases
(especially for testing purposes, NFS) the multi-mac mode is still preferable mode.

There were no such tight dependency between switchdev drivers and bridge core before and switchdev serviced as
independent, notification based layer between them, so ^cpsw still can be "Y" and bridge can be "M".
Now for mostly every kernel build configuration the CONFIG_BRIDGE will need to be set as "Y", or we will have
to update drivers to support build with BRIDGE=n and maintain separate builds for networking vs non-networking testing.
But is this enough? Wouldn't it cause 'chain reaction' required to add more and more "Y" options (like CONFIG_VLAN_8021Q)?

PS. Just to be sure we on the same page - ARM builds will be forced (with this patch) to have CONFIG_TI_CPSW_SWITCHDEV=m
and so all our automation testing will just fail with omap2plus_defconfig.
-- 
Best regards,
grygorii
