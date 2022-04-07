Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAD14F7566
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 07:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbiDGFhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 01:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiDGFh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 01:37:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85439C680B
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 22:35:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B8A3B826B3
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 05:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67965C385A0;
        Thu,  7 Apr 2022 05:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649309725;
        bh=AKYbqIS2jTBBxIuPIwFMz5dE2qsbkQiqSM8em42+cE4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bVGtHOG/gZoK+uLlDvl3Atbdn2IyAGK/oDMgl/QWxC6HxIqkyiZyGutwV5vALy+c9
         E3TWQGu0FlUjbuslgH1n+gCnEqmupuMnDQFiLp/VlnCw/svixf1o+PTOVMoA+uO3CW
         79mSbxYME9JGV+OFkwAsEjK2Nh2OeG+Et5o9sx+c8eguZV52X7GTERx8ZtAfV3w7c1
         XDJ68jCC+O2iODZG89Uqfp6AO834Dgm1ujYJsBozLp9G+bY92MnqH5vrQkzUvVwZzQ
         hUJLdn4ujw3HRCiy31WWwWaz4HlBXRreL+4rTZYLZ5E5b0NQP0eBuHVjtzQYEGryq1
         /bz5VBMe81WpQ==
Date:   Wed, 6 Apr 2022 22:35:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH net] net: mdio: don't defer probe forever if PHY IRQ
 provider is missing
Message-ID: <20220406223524.42fe2a8a@kernel.org>
In-Reply-To: <Yk51TIeGfFmfusQL@kroah.com>
References: <20220406202323.3390405-1-vladimir.oltean@nxp.com>
        <20220406153443.51ad52f8@kernel.org>
        <20220406231956.nwe6kb6vgli2chln@skbuf>
        <20220406172550.6408c990@kernel.org>
        <Yk51TIeGfFmfusQL@kroah.com>
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

On Thu, 7 Apr 2022 07:23:24 +0200 Greg Kroah-Hartman wrote:
> separate patch that I can NAK as I do not understand why this is needed
> at all :)

Just in case you meant lack of context rather than the patch itself,
here's the original posting from lore:

https://lore.kernel.org/all/20220406202323.3390405-1-vladimir.oltean@nxp.com/

tl;dr we can fallback to polling if we can't get the IRQ, afaiu.
