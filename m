Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087526711E6
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjARD0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjARD0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:26:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760254FCFD;
        Tue, 17 Jan 2023 19:26:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04DEE61601;
        Wed, 18 Jan 2023 03:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9896CC433D2;
        Wed, 18 Jan 2023 03:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674012366;
        bh=2PjPN3LtRvrndMQORaS0fpW+/QZolRQR3rsF4H3EiN8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NaWie1TaQKSc3V5S8P/fdVLJlre+Oh4kUX0WxnRvRoTBBJl951Cp0UogKidPXNoG3
         EatUia4U3W95xHdcY173+0tCR+hsP9tNTu7c7wzJ0FctumV+GqRiTvKPTWwUX5FuTy
         UcoSQyabrgSGSixX/x2ur7c/OgjH/1Xuk3Z4KPZCZ5bUNnrvotMHT22PtTx+K91cFs
         4Kd7JGeKc/QE0eSw6MQb9GmIV4uBhkl8ep0aC6hVXdNOpQNoJDUcShg5U6S7YdB8r+
         jwAh0SGCSItrot17rx0VZ23HpeF/kAkOUrrSkaTDtdN2V428YEflPrk60Fn8LSU6QT
         7PyavQ+spyLog==
Date:   Tue, 17 Jan 2023 19:26:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: Re: [PATCH net-next 1/1] drivers/phylib: fix coverity issue
Message-ID: <20230117192604.77a16822@kernel.org>
In-Reply-To: <5061b6d09d0cd69c832c9c0f2f1a6848d3a5ab1c.1673991998.git.piergiorgio.beruto@gmail.com>
References: <5061b6d09d0cd69c832c9c0f2f1a6848d3a5ab1c.1673991998.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Jan 2023 22:47:53 +0100 Piergiorgio Beruto wrote:
> Subject: [PATCH net-next 1/1] drivers/phylib: fix coverity issue

The title of the patch should refer to the bug rather than which tool
found it.

here, for eaxmple:

  net: phy: fix use of uninit variable when setting PLCA config

> Coverity reported the following:
> 
> *** CID 1530573:    (UNINIT)
> drivers/net/phy/phy-c45.c:1036 in genphy_c45_plca_set_cfg()
> 1030     				return ret;
> 1031
> 1032     			val = ret;
> 1033     		}
> 1034
> 1035     		if (plca_cfg->node_cnt >= 0)
[snip]
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
> Addresses-Coverity-ID: 1530573 ("UNINIT")
> Fixes: 493323416fed ("drivers/net/phy: add helpers to get/set PLCA configuration")

nit: the tags are in somewhat unnatural order. Since you'll need to
respin for the subject change, this would be better:

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Fixes: 493323416fed ("drivers/net/phy: add helpers to get/set PLCA configuration")
Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>

(Yes, the custom coverity tag can go meet its friends in the bin)
