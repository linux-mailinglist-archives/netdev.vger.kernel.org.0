Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93443444983
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 21:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhKCU2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 16:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhKCU2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 16:28:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45887C061208;
        Wed,  3 Nov 2021 13:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=k3I/nJavgx6XiiROVgxCaTtXsXUugWiGTr0ZFK/7s6k=; b=OyrJd/sPOFafUSCoJeCGPd0mgc
        oCUb/DEEwSd+WUrC1HSo/PvXCke7ooNDhZSuoOstA+2eRs1+w7itOz7XXe774dOKg+/dRiOCvud7l
        ZMvCLMtz4xPKPAy77jtMWS2wGAW1RFlVCFz5oNddBW8E+bVgi8QN9PvBFK7/bGX0VkMzug5AxVFFZ
        xScE/DjpFFdyC6iVb3ifwKw/dvaXbx88e0BLxLEndnE3sIpAV2JCh5Tter03PfDJ/Ouhn+uTYD4HE
        d1pNI35RarMTOKrPeoeMvT2kIrRAn9DjPj3E565QkxiSQC4GWA6A80vtxfvuie/A0Rx2GwBKN1LUq
        TiLfnd+Q==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miMpp-006UsQ-6I; Wed, 03 Nov 2021 20:26:13 +0000
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
To:     =?UTF-8?B?V2VsbHMgTHUg5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>,
        Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <d0217eed-a8b7-8eb9-7d50-4bf69cd38e03@infradead.org>
 <159ab76ac7114da983332aadc6056c08@sphcmbx02.sunplus.com.tw>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <07456b90-a83c-b1b9-20d4-b70a746148a5@infradead.org>
Date:   Wed, 3 Nov 2021 13:26:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <159ab76ac7114da983332aadc6056c08@sphcmbx02.sunplus.com.tw>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/21 11:08 AM, Wells Lu 呂芳騰 wrote:
>>
>> Hi--
>>
>> On 11/3/21 4:02 AM, Wells Lu wrote:
>>> diff --git a/drivers/net/ethernet/sunplus/Kconfig
>>> b/drivers/net/ethernet/sunplus/Kconfig
>>> new file mode 100644
>>> index 0000000..a9e3a4c
>>> --- /dev/null
>>> +++ b/drivers/net/ethernet/sunplus/Kconfig
>>> @@ -0,0 +1,20 @@
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +#
>>> +# Sunplus Ethernet device configuration #
>>> +
>>> +config NET_VENDOR_SUNPLUS
>>> +	tristate "Sunplus Dual 10M/100M Ethernet (with L2 switch) devices"
>>> +	depends on ETHERNET && SOC_SP7021
>>> +	select PHYLIB
>>> +	select PINCTRL_SPPCTL
>>> +	select COMMON_CLK_SP7021
>>> +	select RESET_SUNPLUS
>>> +	select NVMEM_SUNPLUS_OCOTP
>>> +	help
>>> +	  If you have Sunplus dual 10M/100M Ethernet (with L2 switch)
>>> +	  devices, say Y.
>>> +	  The network device supports dual 10M/100M Ethernet interfaces,
>>> +	  or one 10/100M Ethernet interface with two LAN ports.
>>> +	  To compile this driver as a module, choose M here.  The module
>>> +	  will be called sp_l2sw.
>>
>> Please use NET_VENDOR_SUNPLUS in the same way that other
>> NET_VENDOR_wyxz kconfig symbols are used. It should just enable or
>> disable any specific device drivers under it.
>>
>>
>> --
>> ~Randy
> 
> I looked up Kconfig file of other vendors, but not sure what I should do.
> Do I need to modify Kconfig file in the form as shown below?

Hi,

Yes, this is the correct general idea, but also consider
Andrew's comments.

Thanks.

> # SPDX-License-Identifier: GPL-2.0
> #
> # Sunplus device configuration
> #
> 
> config NET_VENDOR_SUNPLUS
> 	bool "Sunplus devices"
> 	default y
> 	depends on ARCH_SUNPLUS
> 	---help---
> 	  If you have a network (Ethernet) card belonging to this
> 	  class, say Y here.
> 
> 	  Note that the answer to this question doesn't directly
> 	  affect the kernel: saying N will just cause the configurator
> 	  to skip all the questions about Sunplus cards. If you say Y,
> 	  you will be asked for your specific card in the following
> 	  questions.
> 
> if NET_VENDOR_SUNPLUS
> 
> config SP7021_EMAC
> 	tristate "Sunplus Dual 10M/100M Ethernet (with L2 switch) devices"
> 	depends on ETHERNET && SOC_SP7021
> 	select PHYLIB
> 	select PINCTRL_SPPCTL
> 	select COMMON_CLK_SP7021
> 	select RESET_SUNPLUS
> 	select NVMEM_SUNPLUS_OCOTP
> 	help
> 	  If you have Sunplus dual 10M/100M Ethernet (with L2 switch)
> 	  devices, say Y.
> 	  The network device supports dual 10M/100M Ethernet interfaces,
> 	  or one 10/100M Ethernet interface with two LAN ports.
> 	  To compile this driver as a module, choose M here.  The module
> 	  will be called sp_l2sw.
> 
> endif # NET_VENDOR_SUNPLUS
> 
> Best regards,
> Wells
> 


-- 
~Randy
