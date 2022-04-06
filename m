Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B2F4F6055
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbiDFNtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbiDFNss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:48:48 -0400
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 281DE6D1B40;
        Wed,  6 Apr 2022 04:11:40 -0700 (PDT)
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1nc3ZY-00031I-00; Wed, 06 Apr 2022 13:11:36 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 48979C4E6A; Wed,  6 Apr 2022 13:11:01 +0200 (CEST)
Date:   Wed, 6 Apr 2022 13:11:01 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Andrew Stanley-Jones <asj@cban.com>,
        Rob Braun <bbraun@vix.com>, Michael Graff <explorer@vix.com>,
        Matt Thomas <matt@3am-software.com>,
        Arnd Bergmann <arnd@kernel.org>, linux-mips@vger.kernel.org,
        linus.walleij@linaro.org
Subject: Re: [PATCH net-next] net: wan: remove the lanmedia (lmc) driver
Message-ID: <20220406111101.GA19718@alpha.franken.de>
References: <20220406041548.643503-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220406041548.643503-1-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 09:15:48PM -0700, Jakub Kicinski wrote:
> The driver for LAN Media WAN interfaces spews build warnings on
> microblaze. The virt_to_bus() calls discard the volatile keyword.
> The right thing to do would be to migrate this driver to a modern
> DMA API but it seems unlikely anyone is actually using it.
> There had been no fixes or functional changes here since
> the git era begun.
> 
> Let's remove this driver, there isn't much changing in the APIs,
> if users come forward we can apologize and revert.
> 
> Link: https://lore.kernel.org/all/20220321144013.440d7fc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: Krzysztof Hałasa <khalasa@piap.pl>
> CC: Andrew Stanley-Jones <asj@cban.com>
> CC: Rob Braun <bbraun@vix.com>
> CC: Michael Graff <explorer@vix.com>,
> CC: Matt Thomas <matt@3am-software.com>
> CC: Arnd Bergmann <arnd@kernel.org>
> CC: tsbogend@alpha.franken.de # MIPS
> CC: linux-mips@vger.kernel.org
> CC: linus.walleij@linaro.org
> ---
>  arch/mips/configs/gpr_defconfig  |    1 -
>  arch/mips/configs/mtx1_defconfig |    1 -
>  drivers/net/wan/Kconfig          |   28 -
>  drivers/net/wan/Makefile         |    2 -
>  drivers/net/wan/lmc/Makefile     |   18 -
>  drivers/net/wan/lmc/lmc.h        |   33 -
>  drivers/net/wan/lmc/lmc_debug.c  |   65 -
>  drivers/net/wan/lmc/lmc_debug.h  |   52 -
>  drivers/net/wan/lmc/lmc_ioctl.h  |  255 ----
>  drivers/net/wan/lmc/lmc_main.c   | 2009 ------------------------------
>  drivers/net/wan/lmc/lmc_media.c  | 1206 ------------------
>  drivers/net/wan/lmc/lmc_proto.c  |  106 --
>  drivers/net/wan/lmc/lmc_proto.h  |   18 -
>  drivers/net/wan/lmc/lmc_var.h    |  468 -------
>  14 files changed, 4262 deletions(-)
>  delete mode 100644 drivers/net/wan/lmc/Makefile
>  delete mode 100644 drivers/net/wan/lmc/lmc.h
>  delete mode 100644 drivers/net/wan/lmc/lmc_debug.c
>  delete mode 100644 drivers/net/wan/lmc/lmc_debug.h
>  delete mode 100644 drivers/net/wan/lmc/lmc_ioctl.h
>  delete mode 100644 drivers/net/wan/lmc/lmc_main.c
>  delete mode 100644 drivers/net/wan/lmc/lmc_media.c
>  delete mode 100644 drivers/net/wan/lmc/lmc_proto.c
>  delete mode 100644 drivers/net/wan/lmc/lmc_proto.h
>  delete mode 100644 drivers/net/wan/lmc/lmc_var.h

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
