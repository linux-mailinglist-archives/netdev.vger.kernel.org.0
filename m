Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3677A558BF9
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 01:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiFWXxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 19:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiFWXxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 19:53:22 -0400
Received: from smtp7.emailarray.com (smtp7.emailarray.com [65.39.216.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6E517E1B
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 16:53:12 -0700 (PDT)
Received: (qmail 61846 invoked by uid 89); 23 Jun 2022 23:53:10 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 23 Jun 2022 23:53:10 -0000
Date:   Thu, 23 Jun 2022 16:53:08 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net] ptp: ocp: add EEPROM_AT24 dependency
Message-ID: <20220623235308.qrfmd5tfknhf7ggs@bsd-mbp.dhcp.thefacebook.com>
References: <20220623233141.31251-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623233141.31251-1-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 02:31:41AM +0300, Vadim Fedorenko wrote:
> Various information which is provided via devlink is stored in
> EEPROM and is not accessible unless at24 eeprom is supported.
> 
> Fixes: 773bda964921 ("ptp: ocp: Expose various resources on the timecard.")
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>  drivers/ptp/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
> index 458218f88c5e..c86be47e69ed 100644
> --- a/drivers/ptp/Kconfig
> +++ b/drivers/ptp/Kconfig
> @@ -171,7 +171,7 @@ config PTP_1588_CLOCK_OCP
>  	tristate "OpenCompute TimeCard as PTP clock"
>  	depends on PTP_1588_CLOCK
>  	depends on HAS_IOMEM && PCI
> -	depends on I2C && MTD
> +	depends on I2C && EEPROM_AT24 && MTD
>  	depends on SERIAL_8250
>  	depends on !S390
>  	depends on COMMON_CLK

The intent was to list the minimum dependencies for the PTP clock to
operate and for the module to compile.

While EEPROM_AT24 is needed to read the chip, it can operate without it.

Full access to all features needs addtional configuration options, for
example, MTD_SPI_NOR, SPI_XILINX, I2C_XILINX.  These are not required
for the basic ptp clock operation.  

I think listing these configuration options would be more appropriate
in the Documentation entry.
-- 
Jonathan
