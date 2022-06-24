Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C19355A04D
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 20:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiFXRzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 13:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiFXRzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 13:55:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D48A7655;
        Fri, 24 Jun 2022 10:55:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37F47B82B67;
        Fri, 24 Jun 2022 17:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F67C34114;
        Fri, 24 Jun 2022 17:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656093331;
        bh=ifbQWrSacxUg2H6ShAtyaoldstP4yu0ExIla1qMp8+A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z254G4QIEyIBoNKv9dQBEtArmGVblyDCBp5RdgIhZobV2Wt3Cr8rqu4pQvTxdlNbE
         hjneVy6tAq2P/KG8/lhQ9gZMwlTo/VhEOuet8QKbz6W2nGZleD6rT6NxeVikB85JfM
         CS5/I/uXa6GQdbz0kj5hixsb1PUERksTr2MAMYcpM5ZCy9GMhns0TEzB4IuZ3x0kSE
         dXt2GeLJJXpVZSznB51j5tLvAsaP155Sjns73v+uKSJLRDkHdrVqevMtpFRfKgwZAv
         6XwLEZZBD2XeXf1RaL0ou7XM/Cz86MAGQwRoL+G2032SId2PoARzI3X51OSyOGi71h
         Qc7MPlwVIwyDA==
Date:   Fri, 24 Jun 2022 10:55:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/3] Create common DPLL/clock configuration API
Message-ID: <20220624105522.1961b4d3@kernel.org>
In-Reply-To: <3d2970c7-f785-edf7-2936-807cf21ec65e@gmail.com>
References: <20220623005717.31040-1-vfedorenko@novek.ru>
        <3d2970c7-f785-edf7-2936-807cf21ec65e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jun 2022 10:20:44 -0700 Florian Fainelli wrote:
> On 6/22/22 17:57, Vadim Fedorenko wrote:
> > Implement common API for clock/DPLL configuration and status reporting.
> > The API utilises netlink interface as transport for commands and event
> > notifications. This API aim to extend current pin configuration and
> > make it flexible and easy to cover special configurations.  
> 
> Any reasons why you are not copying the Linux common clock framework 
> maintainers and not seeking to get your code included under drivers/clk/ 
> where it would seem like a more natural place for it?
> 
> Is netlink really a necessary configuration interface for those devices?

Sorry, likely my fault. Vadim asked me who to CC and I suggested to just
hit linux-arm-kernel assuming it's the best place for chance encounters
with embedded folks. An assumption based on no real data or experience.

Regarding the clock framework I think I brought that suggestion up in
the mega thread when Maciej M proposed the SyncE support and putting
all the PLL info directly in rtnetlink. There wasn't much support,
and perhaps that's fair, clock generation vs runtime DPLL config for
time source purposes are different use cases.

With that longish excuse out of the way, CCing linux-clk now, here's
the lore link to the thread:

https://lore.kernel.org/r/20220623005717.31040-2-vfedorenko@novek.ru/

