Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE92669173
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240620AbjAMIpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240657AbjAMIpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:45:44 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DCA271B6
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 00:45:42 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by laurent.telenet-ops.be with bizsmtp
        id 88lL2900C4C55Sk018lL8t; Fri, 13 Jan 2023 09:45:40 +0100
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pGFgd-003qP4-W0;
        Fri, 13 Jan 2023 09:45:19 +0100
Date:   Fri, 13 Jan 2023 09:45:19 +0100 (CET)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Christoph Hellwig <hch@lst.de>
cc:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 13/22] pinctrl: remove renesas sh controllers
In-Reply-To: <20230113062339.1909087-14-hch@lst.de>
Message-ID: <c480ecd6-166c-18b4-2230-418836ce3fb2@linux-m68k.org>
References: <20230113062339.1909087-1-hch@lst.de> <20230113062339.1909087-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 	Hi Christoph,

On Fri, 13 Jan 2023, Christoph Hellwig wrote:
> Now that arch/sh is removed these drivers are dead code.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for your patch!

> --- a/drivers/pinctrl/renesas/Kconfig
> +++ b/drivers/pinctrl/renesas/Kconfig
> @@ -255,57 +243,10 @@ config PINCTRL_RZV2M
> 	  This selects GPIO and pinctrl driver for Renesas RZ/V2M
> 	  platforms.
>
> -config PINCTRL_PFC_SH7203
> -	bool "pin control support for SH7203" if COMPILE_TEST
> -	select PINCTRL_SH_FUNC_GPIO

(If this is to be continued) the PINCTRL_SH_FUNC_GPIO symbol itself, and
all its users, can be removed, too.

> --- a/drivers/pinctrl/renesas/core.c
> +++ b/drivers/pinctrl/renesas/core.c
> @@ -753,562 +753,6 @@ static int sh_pfc_suspend_init(struct sh_pfc *pfc) { return 0; }
> #define DEV_PM_OPS	NULL
> #endif /* CONFIG_PM_SLEEP && CONFIG_ARM_PSCI_FW */
>
> -#ifdef DEBUG
> -#define SH_PFC_MAX_REGS		300
> -#define SH_PFC_MAX_ENUMS	5000
> -

This whole hunk should stay (except for the part protected by #ifdef
CONFIG_PINCTRL_SH_FUNC_GPIO), as it is used for validating pin control
tables on ARM SoCs, too.

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
