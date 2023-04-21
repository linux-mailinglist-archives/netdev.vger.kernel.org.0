Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E882A6EA231
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 05:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbjDUDL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 23:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233328AbjDUDLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 23:11:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118166EB2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 20:11:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C59B61543
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 03:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCB1C433EF;
        Fri, 21 Apr 2023 03:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682046691;
        bh=eXqgtKpbsbah7q4JTaCtbcluZjMJjKDdIt+qjArJC4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OYibX4LQUQ01p5ih3JYiRcLxpWy2xQjQQFAzOLg+fTL1T02A0xyRjD68J8D4cVX+t
         CQp8G61Ft7VjMJdA+4HYc1aRO3z/a4kd28EFlxD9bFAyVM5N6e2tAnPFttmqzZ/8fp
         lIr7CODJppLDOAeSVCGt3uEee9YXxTyK6MZbn6eyxzm+QHewGvzJb3m3oK69UVLAh/
         BFPCQcxIDItlhIZTUM5upaQ7P+6EX/suR4ltvZetWh/OsZUvb26/48K33Hox6HuFue
         YBv4XAiLkWipv/qL/wJE6eAuEGQa4pc/IcwxwjZ73zuOoU/zVnXHMliZt3GpSELMVF
         /O2FZQ9zdR2Ew==
Date:   Thu, 20 Apr 2023 20:11:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 net-next] net: phy: add basic driver for NXP CBTX PHY
Message-ID: <20230420201129.4fdc6c83@kernel.org>
In-Reply-To: <20230418190141.1040562-1-vladimir.oltean@nxp.com>
References: <20230418190141.1040562-1-vladimir.oltean@nxp.com>
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

On Tue, 18 Apr 2023 22:01:41 +0300 Vladimir Oltean wrote:
> The CBTX PHY is a Fast Ethernet PHY integrated into the SJA1110 A/B/C
> automotive Ethernet switches.
> 
> It was hoped it would work with the Generic PHY driver, but alas, it
> doesn't. The most important reason why is that the PHY is powered down
> by default, and it needs a vendor register to power it on.
> 
> It has a linear memory map that is accessed over SPI by the SJA1110
> switch driver, which exposes a fake MDIO controller. It has the
> following (and only the following) standard clause 22 registers:

Looking for Acks from PHY maintainers..
-- 
pw-bot: ur
