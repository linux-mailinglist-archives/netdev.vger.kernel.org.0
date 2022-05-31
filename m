Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827E7539181
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 15:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344589AbiEaNLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 09:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344587AbiEaNLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 09:11:44 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AA0CC0;
        Tue, 31 May 2022 06:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=4ua9nPt2PukSR9gYpe/o1H008WDaOZXfT2gVd5Mb3XI=; b=TpklImPqrcJUJNVWAXID4BD4M/
        Bb4KxbZW6ta5g27nNp0hodORImPxOm/myB6VilyUGpRTW4Gkr+0SwcaaQm1Zf5w9IVudq2TMg6qan
        +AN6AHvEcyByBSibzp+5g1iLbu+iQKM7YtSffWb/yRrbTZ8+hQkZM7CuzlUg78ntGIvNkUSg64FNL
        JKv9loboyiERmAX4lfygofzokYJxTSXbULIZhtXaj7N7B7oAA/piU85ID9KrQ5WfJF80zVQtx9LJ5
        zZRs5pJv+lmKbdXJN+YKzjmSBO5oZjc+Bf+WMKo7fCOTku0kDUIKRDdHOdwRaF+OJof64E3tp5fBs
        AePfsbsQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nw1en-003SGS-A3; Tue, 31 May 2022 13:11:34 +0000
Message-ID: <529649b4-a597-9304-0df6-1b1e577df38c@infradead.org>
Date:   Tue, 31 May 2022 06:11:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 2/2] net: ti: icssg-prueth: Add ICSSG ethernet driver
Content-Language: en-US
To:     Puranjay Mohan <p-mohan@ti.com>, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, nm@ti.com, ssantosh@kernel.org,
        s-anna@ti.com, linux-arm-kernel@lists.infradead.org,
        rogerq@kernel.org, grygorii.strashko@ti.com, vigneshr@ti.com,
        kishon@ti.com, robh+dt@kernel.org, afd@ti.com, andrew@lunn.ch
References: <20220531095108.21757-1-p-mohan@ti.com>
 <20220531095108.21757-3-p-mohan@ti.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220531095108.21757-3-p-mohan@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 5/31/22 02:51, Puranjay Mohan wrote:
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index fb30bc5d56cb..500d0591ad2a 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -182,4 +182,19 @@ config CPMAC
>  	help
>  	  TI AR7 CPMAC Ethernet support
>  
> +config TI_ICSSG_PRUETH
> +	tristate "TI Gigabit PRU Ethernet driver"
> +	select PHYLIB
> +
> +	depends on PRU_REMOTEPROC
> +	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
> +	help
> +	  Support dual Gigabit Ethernet ports over the ICSSG PRU Subsystem

	End the sentence above with a period ('.').

> +	  This subsystem is available starting with the AM65 platform.
> +
> +	  This driver requires firmware binaries which will run on the PRUs
> +	  to support the ethernet operation. Currently, it supports Ethernet

	Be consistent:   ethernet                       or          Ethernet

> +	  with 1G and 100M link speed.

-- 
~Randy
