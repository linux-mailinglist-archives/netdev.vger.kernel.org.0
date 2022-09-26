Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7FC5EB1C7
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiIZUEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiIZUEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:04:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9550AB2F;
        Mon, 26 Sep 2022 13:04:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30C23611C6;
        Mon, 26 Sep 2022 20:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454F3C433D6;
        Mon, 26 Sep 2022 20:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664222670;
        bh=ZTzwsJUd481iZiJATN/XGwnMEhE4ZZBY5vOqHx0c/gA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GO6hv2RpXWRjJwseIdNHe5lUdyEQDnHasF9mC041/AjRvkgYxAfQH8+hhrvs8a5zk
         0Rilkf4cd39i/Mp4SKjyeohwgjYHjKH0lCxy8hVTl4uMrIlYYmtlom/LGNLomGdd+g
         BxZzLAuon1xnEHGy51KCVWqGjdwAq9G48XetqqWdooWY+8izUYdYz0UbO8+V382oTJ
         wrSJgV/6QqGtd1UyVHHQ3+ddfvyIIcHIpO2zwuHW0A3AqnlZhN/pjCTNybKL6+pKlo
         609O8OAOrcTPWcBu7y8rEqdIcP1NT0BR1XFlih8qJVjxEyoqQ/RP7qQ7eh2ULeE/lf
         9OmB1S7H+lFxw==
Date:   Mon, 26 Sep 2022 13:04:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <richardcochran@gmail.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net V2] net: lan743x: Fixes: 60942c397af6 ("Add support
 for PTP-IO Event Input External  Timestamp (extts)")
Message-ID: <20220926130429.3ffd78b1@kernel.org>
In-Reply-To: <20220923094134.10477-1-Raju.Lakkaraju@microchip.com>
References: <20220923094134.10477-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Sep 2022 15:11:34 +0530 Raju Lakkaraju wrote:
> Subject: [PATCH net V2] net: lan743x: Fixes: 60942c397af6 ("Add support for PTP-IO Event Input External  Timestamp (extts)")
> 
> Remove PTP_PF_EXTTS support for non-PCI11x1x devices since they do not
> support the PTP-IO Input event triggered timestamping mechanisms
> added
> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

The fixes tag should go before your sign-off. So something like:

Subject: eth: lan743x: reject extts for non-pci11x1x devices

Remove PTP_PF_EXTTS support for non-PCI11x1x devices since they do not
support the PTP-IO Input event triggered timestamping mechanisms
added [...]

Fixes: 60942c397af6 ("Add support for PTP-IO Event Input External  Timestamp (extts)")
Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>


I'd be good to add to the commit message what the user-visible problem
will be. Crash or just silently accepting a config which won't work?
