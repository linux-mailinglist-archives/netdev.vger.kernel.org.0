Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59684F450B
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381832AbiDEUEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573173AbiDESHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 14:07:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA441F623;
        Tue,  5 Apr 2022 11:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=eK1W6c3cykjE0LliXQwdPpUl4xUEcuaJtmGpAa5ka20=; b=DroHWKqca4Vq4W7PTsU+k7+YsQ
        +ZiV7XCDx/UOgPCSCA/Ay36KKPaIMOYZZ8GAlXpb8MzCWbQJADXlw26mZaUMWjK16b+PGHCu6OaLr
        eKp+zBAZikv9jQCkqK4pZeHIPZTe+JjQDxH1SlB/Wxy4nBz+4ihiONMQulZmxiP3SyLRj6QbLBBHw
        AEdn36e/hEY5DtsEzGeDqE4HAvDSxRI648dXsVbOfih/gyQnaesDl4t9ttLkT53HDVWHDAs7yD0Jv
        Dl9TvfKQRib/BrEqja3eRnL6whXR/NN5sSHrnpXf3++dEWxEJ73jYMypwMazlVSe4lL/zm0rcubkM
        OJy6QZwQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nbnXz-006wEx-Ex; Tue, 05 Apr 2022 18:04:55 +0000
Message-ID: <ac023638-5ce4-1c0b-29e5-e30fc3038e72@infradead.org>
Date:   Tue, 5 Apr 2022 11:04:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] net: micrel: Fix KS8851 Kconfig
Content-Language: en-US
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        Divya.Koppera@microchip.com, kernel test robot <lkp@intel.com>
References: <20220405065936.4105272-1-horatiu.vultur@microchip.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220405065936.4105272-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/4/22 23:59, Horatiu Vultur wrote:
> KS8851 selects MICREL_PHY, which depends on PTP_1588_CLOCK_OPTIONAL, so
> make KS8851 also depend on PTP_1588_CLOCK_OPTIONAL.
> 
> Fixes kconfig warning and build errors:
> 
> WARNING: unmet direct dependencies detected for MICREL_PHY
>   Depends on [m]: NETDEVICES [=y] && PHYLIB [=y] && PTP_1588_CLOCK_OPTIONAL [=m]
>     Selected by [y]:
>       - KS8851 [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_MICREL [=y] && SPI [=y]
> 
> ld.lld: error: undefined symbol: ptp_clock_register referenced by micrel.c
> net/phy/micrel.o:(lan8814_probe) in archive drivers/built-in.a
> ld.lld: error: undefined symbol: ptp_clock_index referenced by micrel.c
> net/phy/micrel.o:(lan8814_ts_info) in archive drivers/built-in.a
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/net/ethernet/micrel/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/micrel/Kconfig b/drivers/net/ethernet/micrel/Kconfig
> index 1b632cdd7630..830363bafcce 100644
> --- a/drivers/net/ethernet/micrel/Kconfig
> +++ b/drivers/net/ethernet/micrel/Kconfig
> @@ -28,6 +28,7 @@ config KS8842
>  config KS8851
>  	tristate "Micrel KS8851 SPI"
>  	depends on SPI
> +	depends on PTP_1588_CLOCK_OPTIONAL
>  	select MII
>  	select CRC32
>  	select EEPROM_93CX6

-- 
~Randy
