Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9222A4EB7FB
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241732AbiC3BxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiC3BxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:53:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED843EAB9
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 18:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA5BBB818FD
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 01:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E26FC340ED;
        Wed, 30 Mar 2022 01:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648605078;
        bh=uPVPTPqQ+zjGcNlvIVQgAcOHL8ZFkPOnSUmQa1IAbc8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=euEDuvVmQ+NysAcpunoPlA4u5Lj99bpDC2rHg8SeBEttV29jpVA7yNy0GcIDBFYrZ
         WPUewfyVqc521SS1ubdvvYF6d292X/cncpMCzQKYS4fygPZ4suk093Du92+EXUd0Nm
         uez0iwNY0sP15O5QAMd2wpTFQ63vRB7IgChDUukBooxWVFnX1A3hY+nbXrinzNZ3UM
         +s+uzxUsbX7MJYzaiMBmDJ4WuNKEUffMtmRuZBKsMq8nXxou8CKV/T04cuZxBGg0MX
         XPuL+jSu0nguYK6hrTyO+Rfo/4ZsgTQY9Sr5yBRTfF2LSOysU5JD1ZqhVRkCoDf60a
         BvsXfn2ECcK0w==
Date:   Tue, 29 Mar 2022 18:51:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, patches@lists.linux.dev,
        kernel test robot <lkp@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, bjarni.jonasson@microchip.com,
        p.zabel@pengutronix.de
Subject: Re: [PATCH] net: sparx5: uses, depends on BRIDGE or !BRIDGE
Message-ID: <20220329185116.24c44f2f@kernel.org>
In-Reply-To: <20220330012025.29560-1-rdunlap@infradead.org>
References: <20220330012025.29560-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Mar 2022 18:20:25 -0700 Randy Dunlap wrote:
> Fix build errors when BRIDGE=m and SPARX5_SWITCH=y:
> 
> riscv64-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.o: in function `.L305':
> sparx5_switchdev.c:(.text+0xdb0): undefined reference to `br_vlan_enabled'
> riscv64-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.o: in function `.L283':
> sparx5_switchdev.c:(.text+0xee0): undefined reference to `br_vlan_enabled'
> 
> Fixes: 3cfa11bac9bb ("net: sparx5: add the basic sparx5 driver")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Cc: Lars Povlsen <lars.povlsen@microchip.com>
> Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
> Cc: UNGLinuxDriver@microchip.com
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>

Gotta CC all the authors of the change under Fixes, please.
Adding them now.

> --- linux-next-20220329.orig/drivers/net/ethernet/microchip/sparx5/Kconfig
> +++ linux-next-20220329/drivers/net/ethernet/microchip/sparx5/Kconfig
> @@ -5,6 +5,7 @@ config SPARX5_SWITCH
>  	depends on OF
>  	depends on ARCH_SPARX5 || COMPILE_TEST
>  	depends on PTP_1588_CLOCK_OPTIONAL
> +	depends on BRIDGE || BRIDGE=n
>  	select PHYLINK
>  	select PHY_SPARX5_SERDES
>  	select RESET_CONTROLLER

