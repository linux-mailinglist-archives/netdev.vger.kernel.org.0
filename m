Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9193DEE1D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbhHCMrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:47:02 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:48684 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236022AbhHCMrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 08:47:02 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 173CkXUs015641;
        Tue, 3 Aug 2021 07:46:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1627994793;
        bh=dwa6kQPQNIzIVu4zRjFxk1oyIAq25vQUEDqTws0ieMc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=OIEUdb7fh3uigJDoABx6EiicoM98wNlzl8F2L90jD6nZWyF4JFhEdPCeBoGty/uKm
         h56WdANzPtrXzZIjsN+Z4BWRJfpXGHuVHS+0nYDCnMVHOzkX4fXdmdgEBWCGjmbnjO
         4UEKWwwW1rJMbFtnOWe4DDKjS8tgfzA3pwaa9jCc=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 173CkXbM058113
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Aug 2021 07:46:33 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 3 Aug
 2021 07:46:32 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Tue, 3 Aug 2021 07:46:32 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 173CkScx019449;
        Tue, 3 Aug 2021 07:46:28 -0500
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
        Vignesh Raghavendra <vigneshr@ti.com>
References: <20210726142536.1223744-1-vladimir.oltean@nxp.com>
 <CAK8P3a2HGm7MyUc3N1Vjdb2inS6D3E3HDq4bNTOBaHZQCP9kwA@mail.gmail.com>
 <eab61b8f-fc54-ea63-ad31-73fb13026b1f@ti.com>
 <20210803115819.sdtdqhmfk5k4olip@skbuf>
 <CAK8P3a3xtC7p_iEcqLpL+uhCBGm31vrrCG5xFCxraCRZiyEWQA@mail.gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <81e7f845-c0be-110e-d1ae-5b5574bf7267@ti.com>
Date:   Tue, 3 Aug 2021 15:46:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3xtC7p_iEcqLpL+uhCBGm31vrrCG5xFCxraCRZiyEWQA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/08/2021 15:33, Arnd Bergmann wrote:
> On Tue, Aug 3, 2021 at 1:58 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>>
>> On Tue, Aug 03, 2021 at 02:18:38PM +0300, Grygorii Strashko wrote:
>>> In my opinion, the problem is a bit bigger here than just fixing the build :(
>>>
>>> In case, of ^cpsw the switchdev mode is kinda optional and in many cases
>>> (especially for testing purposes, NFS) the multi-mac mode is still preferable mode.
>>>
>>> There were no such tight dependency between switchdev drivers and bridge core before and switchdev serviced as
>>> independent, notification based layer between them, so ^cpsw still can be "Y" and bridge can be "M".
>>> Now for mostly every kernel build configuration the CONFIG_BRIDGE will need to be set as "Y", or we will have
>>> to update drivers to support build with BRIDGE=n and maintain separate builds for networking vs non-networking testing.
>>> But is this enough? Wouldn't it cause 'chain reaction' required to add more and more "Y" options (like CONFIG_VLAN_8021Q)?
>>>
>>> PS. Just to be sure we on the same page - ARM builds will be forced (with this patch) to have CONFIG_TI_CPSW_SWITCHDEV=m
>>> and so all our automation testing will just fail with omap2plus_defconfig.
>>
>> I didn't realize it is such a big use case to have the bridge built as
>> module and cpsw as built-in.
> 
> I don't think anybody realistically cares about doing, I was only interested in
> correctly expressing what the dependency is.
> 
>> I will send a patch that converts the
>> switchdev_bridge_port_{,un}offload functions to simply emit a blocking
>> switchdev notifier which the bridge processes (a la SWITCHDEV_FDB_ADD_TO_BRIDGE),
>> therefore making switchdev and the bridge loosely coupled in order to
>> keep your setup the way it was before.
> 
> That does sounds like it can avoid future build regressions, and simplify the
> Kconfig dependencies, so that would probably be a good solution.

Yes. it sounds good, thank you.
Just a thought - might be good to follow switchdev_attr approach (extendable), but in the opposite direction as, I feel,
more notification dev->bridge might be added in the future.

-- 
Best regards,
grygorii
