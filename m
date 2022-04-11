Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01874FC5E0
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 22:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349591AbiDKUhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 16:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240336AbiDKUhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 16:37:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F3711C20;
        Mon, 11 Apr 2022 13:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3725B8170E;
        Mon, 11 Apr 2022 20:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC22C385A3;
        Mon, 11 Apr 2022 20:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649709299;
        bh=zvNqK4P+5QQN8s0u8A7+ok31XpbPjuJiekP3FbT2bwA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VpX9/3JoameD25kAtsu0SBt//6rBhNVByIB8aV6zeJ7H9pKhhTZDKQaXY/0dhklOS
         lo645n/IyG05A1kSnp0sDb/5Ijholkjug1gCSeT0CS/sjChqwYTE//kmjcsI9+uEDO
         Qc2v9x2GwnxzRdyBaP1k45dKsOSquHw3rW2q9HApVsrki/l84fadBTjVuQjxbIJDvF
         fp8o/bDvzWEfXfb6+2uTP4pULFBq+y92eADHoKqah9FEFdNxtfLal57EtRMjHJmEbA
         uri4m7mt4ACtPFqne5BqNAgBGbZGot3EyCJX/jVqyd8BPliazOlaNAw3CijqxOrm5b
         ZHa2fax4xsSow==
Date:   Mon, 11 Apr 2022 13:34:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, pabeni@redhat.com, krzk+dt@kernel.org,
        roopa@nvidia.com, andrew@lunn.ch, edumazet@google.com,
        wells.lu@sunplus.com
Subject: Re: [PATCH net-next v7 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <20220411133457.1c783e4c@kernel.org>
In-Reply-To: <1649697088-7812-3-git-send-email-wellslutw@gmail.com>
References: <1649697088-7812-1-git-send-email-wellslutw@gmail.com>
        <1649697088-7812-3-git-send-email-wellslutw@gmail.com>
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

On Tue, 12 Apr 2022 01:11:28 +0800 Wells Lu wrote:
> +config NET_VENDOR_SUNPLUS
> +	bool "Sunplus devices"
> +	default y
> +	depends on ARCH_SUNPLUS || COMPILE_TEST
> +	help
> +	  If you have a network (Ethernet) card belonging to this
> +	  class, say Y here.
> +
> +	  Note that the answer to this question doesn't directly
> +	  affect the kernel: saying N will just cause the configurator
> +	  to skip all the questions about Sunplus cards. If you say Y,
> +	  you will be asked for your specific card in the following
> +	  questions.
> +
> +if NET_VENDOR_SUNPLUS
> +
> +config SP7021_EMAC
> +	tristate "Sunplus Dual 10M/100M Ethernet devices"
> +	depends on SOC_SP7021 || COMPILE_TEST
> +	select PHYLIB
> +	select PINCTRL_SPPCTL
> +	select COMMON_CLK_SP7021
> +	select RESET_SUNPLUS
> +	select NVMEM_SUNPLUS_OCOTP
> +	help
> +	  If you have Sunplus dual 10M/100M Ethernet devices, say Y.
> +	  The network device creates two net-device interfaces.
> +	  To compile this driver as a module, choose M here. The
> +	  module will be called sp7021_emac.

x86 allmodconfig is not happy about it:

WARNING: unmet direct dependencies detected for PINCTRL_SPPCTL
  Depends on [n]: PINCTRL [=y] && SOC_SP7021 && OF [=y] && HAS_IOMEM [=y]
  Selected by [m]:
  - SP7021_EMAC [=m] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_SUNPLUS [=y] && (SOC_SP7021 || COMPILE_TEST [=y])

Please wait at least 24h before reposting.
