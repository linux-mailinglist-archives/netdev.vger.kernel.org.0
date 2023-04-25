Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283F16EE3D8
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 16:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjDYOYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 10:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbjDYOYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 10:24:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F998146C0;
        Tue, 25 Apr 2023 07:24:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D420962137;
        Tue, 25 Apr 2023 14:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE62C433D2;
        Tue, 25 Apr 2023 14:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682432646;
        bh=yliYoqpOgm0dIutKl8oAPe72ftrxSi7X6V4lwrOfkLA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cYe0gfy7XAzZ49rDBexhAmSFOO5duqhrkvX08mLuEdSLlIZuvrEUA0wnABu7Go3Ei
         pZOaYTqCP4I9mms9GBI+RAhoaNcVT25ExCJwHZF2pSOVsvSsm5BXiupNAfXCUWZaIG
         N706B/E1DNAwz8eaTZ5/3E8+GGvV6tdTaaabFLCaP4cxnyqlxubcJobnU/2X16Vb5O
         aE0OULprxkOs3j7ej1xl8ug2/CULqKkDjJvAIQoxw4gP25z2IyIbhpc9ATFUga+6YK
         qHbnt1NDX7BkackKR5Fy0X2BHtMBT7ypthSvAK75DxIDkaub6mmZGhJqItZGZzumR6
         UbWnWqwnl3CtQ==
Date:   Tue, 25 Apr 2023 07:24:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Qingfang Deng <dqfext@gmail.com>,
        SkyLake Huang <SkyLake.Huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH v2] net: phy: add driver for MediaTek SoC built-in GE
 PHYs
Message-ID: <20230425072404.28b798e1@kernel.org>
In-Reply-To: <ZEePDK2oW5xkiEIv@makrotopia.org>
References: <ZEPU6oahOGwknkSc@makrotopia.org>
        <20230424183755.3fac65b0@kernel.org>
        <ZEePDK2oW5xkiEIv@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 09:27:56 +0100 Daniel Golle wrote:
> > Daniel, is it high prio for you to get it into 6.4 or 6.5 is okay?  
> 
> No rush, as this is mostly relevant for OpenWrt the thing which matters
> most to me is having it in the next LTS kernel, so 6.5 should still be
> fine I suppose.
> 
> > 
> > I'm trying to get a read on whether we should merge it because it's 
> > kind of on the goal line for this merge window. 
> > 
> > If nobody feels strongly we can do this the traditional way - I'll 
> > just complain about RCT, hence kicking it back out into the field :)  
> 
> I understand Andrew's concerns and will resubmit for the next merge
> window in 2 weeks, and without the LED part for now until PHY LED
> infrastructure is more ready (ie. able to offload 'netdev' trigger
> to hardware)

Perfect, thanks!
