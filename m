Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3CA51FFFB
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237263AbiEIOiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbiEIOiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:38:16 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399A72AED94;
        Mon,  9 May 2022 07:34:18 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id F19E830B2954;
        Mon,  9 May 2022 16:34:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=3bXf2
        2+Nw/0Od99Sjn+qvkBNLItca+JSrqVBQ0ekeoA=; b=KyrBaUw2BhbHetjD/tBfn
        0xPskG+rZ8S8NS0pcLJFWAYaGyIz2CN1p6HRoO3JaO2gHZzQgVpsA7N7rZKmQ0Rk
        2oZd17AHRJfaDSy4f79STC98g8z+JHMZZaCrM3lpjoJrPUOAjgQ7E6T1LnyowgNL
        17M1o3VhGGQsUovwMhuPqjjaxgTTGG2Y4S+8M5QK6lC/56ePGEbvNBVLUWXpF+d2
        1LgWaSN+MyUaWNUHr1zXYk6yBIXQmwRIMiEAWIBBY51QAl4as7SiioTFcrrDUfXd
        844Bm2MO65B/GVzZk51Fb3bFpp9U7gyh0k9XbWOrU8hWWguj2O8KYTKvzXzK2NvT
        g==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 7BE2930B2948;
        Mon,  9 May 2022 16:34:15 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 249EYF9M032507;
        Mon, 9 May 2022 16:34:15 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 249EYEIP032506;
        Mon, 9 May 2022 16:34:14 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH] can: ctucanfd: Let users select instead of depend on CAN_CTUCANFD
Date:   Mon, 9 May 2022 16:34:05 +0200
User-Agent: KMail/1.9.10
Cc:     Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <887b7440446b6244a20a503cc6e8dc9258846706.1652104941.git.geert+renesas@glider.be>
In-Reply-To: <887b7440446b6244a20a503cc6e8dc9258846706.1652104941.git.geert+renesas@glider.be>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202205091634.05147.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Geert,

On Monday 09 of May 2022 16:02:59 Geert Uytterhoeven wrote:
> The CTU CAN-FD IP core is only useful when used with one of the
> corresponding PCI/PCIe or platform (FPGA, SoC) drivers, which depend on
> PCI resp. OF.
>
> Hence make the users select the core driver code, instead of letting
> then depend on it.  Keep the core code config option visible when
> compile-testing, to maintain compile-coverage.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>

Thanks for suggestion, I have no strong opinion/experience there
but I agree that proposed behavior seems more friendly to users. 

>  drivers/net/can/ctucanfd/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/can/ctucanfd/Kconfig
> b/drivers/net/can/ctucanfd/Kconfig index 48963efc7f19955f..3c383612eb1764e2
> 100644
> --- a/drivers/net/can/ctucanfd/Kconfig
> +++ b/drivers/net/can/ctucanfd/Kconfig
> @@ -1,5 +1,5 @@
>  config CAN_CTUCANFD
> -	tristate "CTU CAN-FD IP core"
> +	tristate "CTU CAN-FD IP core" if COMPILE_TEST
>  	help
>  	  This driver adds support for the CTU CAN FD open-source IP core.
>  	  More documentation and core sources at project page
> @@ -13,8 +13,8 @@ config CAN_CTUCANFD
>
>  config CAN_CTUCANFD_PCI
>  	tristate "CTU CAN-FD IP core PCI/PCIe driver"
> -	depends on CAN_CTUCANFD
>  	depends on PCI
> +	select CAN_CTUCANFD
>  	help
>  	  This driver adds PCI/PCIe support for CTU CAN-FD IP core.
>  	  The project providing FPGA design for Intel EP4CGX15 based DB4CGX15
> @@ -23,8 +23,8 @@ config CAN_CTUCANFD_PCI
>
>  config CAN_CTUCANFD_PLATFORM
>  	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
> -	depends on CAN_CTUCANFD
>  	depends on OF || COMPILE_TEST
> +	select CAN_CTUCANFD
>  	help
>  	  The core has been tested together with OpenCores SJA1000
>  	  modified to be CAN FD frames tolerant on MicroZed Zynq based

