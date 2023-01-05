Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A955765E744
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbjAEJE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjAEJD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:03:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D804F50E46;
        Thu,  5 Jan 2023 01:03:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 768816192C;
        Thu,  5 Jan 2023 09:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F648C433D2;
        Thu,  5 Jan 2023 09:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672909430;
        bh=mK8m5r6Yvu6vRkxtRcJykJn1adYg546xLjheQQ7qKWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ax/EmA1tmXTzmAFv/uwq6015BLN/tRQtXQDFWvGuiUkbIM2KUZSuJFD8deZg/Kb+B
         NwMdH+yxbakL6QaFtZNP1RZosTLR6+kAvkD8gwTTW0/+EBGoznxI/FTi0Lcw/IvHR6
         n04jglw6BSCoYE4i7BN+7tRpUMitXL0BFwvLjVbthZAVUm8m27Kfnb0XyZCQxBXl0m
         41QCJgLujYwjtrqQCKWJvKRJEAB+5WESpi56/rujWqwt5wH2bn8GT8fCPTj651XbiD
         IWtRfvSR55pPBMzsTuHsHWUJuXpvLcLLlQfZsS/MONd2PoXGMrtxcegLD+SGzY9TNC
         H3SX4RlonSmPw==
Date:   Thu, 5 Jan 2023 11:03:46 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <Y7aSco7bDOHQhQv7@unreal>
References: <cover.1672840325.git.piergiorgio.beruto@gmail.com>
 <5d9b49cb21c97bf187502d4f6000f1084a7e4df7.1672840326.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d9b49cb21c97bf187502d4f6000f1084a7e4df7.1672840326.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 03:06:30PM +0100, Piergiorgio Beruto wrote:
> This patch adds the required connection between netlink ethtool and
> phylib to resolve PLCA get/set config and get status messages.
> 
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> ---
>  drivers/net/phy/phy.c        | 172 +++++++++++++++++++++++++++++++++++
>  drivers/net/phy/phy_device.c |   3 +
>  include/linux/phy.h          |   7 ++
>  3 files changed, 182 insertions(+)

<...>

> +	curr_plca_cfg = kmalloc(sizeof(*curr_plca_cfg), GFP_KERNEL);
> +	if (unlikely(!curr_plca_cfg)) {

Please don't put likely/unlikely on kamlloc and/or in in control path
flow.

Thanks
