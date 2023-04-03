Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7136D4BEB
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjDCPaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbjDCPaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6D110E7
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0DFE618A6
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 15:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7444C433D2;
        Mon,  3 Apr 2023 15:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680535821;
        bh=ZUxtvaHU3i38SW6pWm0GHvlm5mFyE1lJEITAIIEOAmA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jkx7YWIEvPmmuSGfZ1hGp0/W3H4PnjkxPjpbNUwsvmuuPMFY9NjtUb0zMniyLI4rG
         JpB/nYKT+B/6VzAbhOpY0HThXtht2HYNQyZWdBu4sVQxE3jpW9OiRSih0o65bPvg1e
         WwulPNEbAgStgeBAXDyNcPbsXf8Eow2rV0ilbISKH2lvb94Qt6459ZeannIU0fTcpa
         8sAfxf3nftf7yd8+fowb24oriCEdYQeZOya3bRhIP208ne75TCwzKXUl3o1QejXRH0
         445j4OHTqcqO9JjzJugagp5auyuNYcDXS/GE1ysHQany/+R6PcayB8tcuxy73Lm+dc
         /lRJoAbhZNtDA==
Date:   Mon, 3 Apr 2023 08:30:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH net-next 7/7] net: create a netdev notifier for DSA to
 reject PTP on DSA master
Message-ID: <20230403083019.120b72fd@kernel.org>
In-Reply-To: <20230402123755.2592507-8-vladimir.oltean@nxp.com>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
        <20230402123755.2592507-8-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  2 Apr 2023 15:37:55 +0300 Vladimir Oltean wrote:
> The established way for unrelated modules to react on a net device event
> is via netdevice notifiers. So we create a new notifier which gets
> called whenever there is an attempt to change hardware timestamping
> settings on a device.

Two core parts of the kernel are not "unrelated modules".
Notifiers make the code harder to maintain and reason about.

But what do I know, clearly the code is amazing since it 
has been applied in <22h on a weekend :|
