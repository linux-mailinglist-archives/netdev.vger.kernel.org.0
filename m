Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983A96C5641
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjCVUEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjCVUDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:03:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8888B6C684
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:59:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69E716229E
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 19:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D87C433D2;
        Wed, 22 Mar 2023 19:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515175;
        bh=qG2Bt2fu1Uv89/Vc6v4212ADWXVOq2w/KsrFb4eMutc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=owBRMXTzkF57BeQgktsGeAdMPHORrFUk8nCrkujTGCaAtFJ8i522+q/S2etcbOaqB
         10mvrcbMD2jP28stBjR7t9URc5OYfKGuS1MaYWiC68j8hahPU4zdsC4LesYbolgtqB
         BLbDP214ffKQGDrQ2MevbsL7FMwkn8SYPHAAG+G/nEhzAoOb8AZbE2gHlu+XLUBD7f
         2GIrkR3Gwo2z73VeQenRHoou/oN6YVXuYVKo9s5rdfYl7cbYbOXQ5/iCkD6CJskA/H
         T6xdCEXiMzKc3Sjj82qGbWMm1V3Dw/zhfTa5G0dCmO7Tw8Aca5xgUgQG8xlLhK5oT4
         FPa6mEG/aVZSw==
Date:   Wed, 22 Mar 2023 12:59:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hau <hau@realtek.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: Re: [PATCH net] r8169: fix rtl8168h rx crc error
Message-ID: <20230322125934.102876c1@kernel.org>
In-Reply-To: <3892d440f0194b30aa32ccd93f661dd2@realtek.com>
References: <20230322064550.2378-1-hau@realtek.com>
        <20230322082104.y6pz7ewu3ojd3esh@soft-dev3-1>
        <3892d440f0194b30aa32ccd93f661dd2@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 12:13:12 +0000 Hau wrote:
> > Don't forget to add the fixes tag.
> > Another comment that I usually get is to replace hardcoded values with
> > defines, but on the other side I can see that this file already has plently of
> > hardcoded values.
>  
> It is not a fix for a specific commit. PHY 10m pll off is an power
> saving feature which is enabled by H/W default. This issue can be
> fixed by disable PHY 10m pll off.

How far back can the issue be reproduced? Is it only possible with
certain device types? Then the Fixes tag should point at the commit
which added support for the devices. Was it always present since 2.6
kernels? Put the first commit in the git history as Fixes.
