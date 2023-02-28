Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCE96A6263
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjB1W0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 17:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjB1W0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:26:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D8826847
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 14:26:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 875B2611FC
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 22:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8895DC433D2;
        Tue, 28 Feb 2023 22:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677623210;
        bh=fWOxEO95PB3uURNOW5y7FilZFqbCmjHjy2UTvqZyaNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UQQljJOjOZHSGxEDt382Fjy6/G3kI7N+LQW6kac6C0XyTOm6acUar6/TNnsopvRq1
         FH8b9fMQeY3YD546oGd5Dwx/uCUebQ9IKVuGWxzInV317QcbXeiW3x6NUja25hzMkH
         ZWuXWtV56C7PwuPHMLFkxwnOeb6TwEQ8xktbMMTOAO/+zfu8UxcQp9eSLwBgsfElny
         BzGKgHfCanmTwYiyzVz7lSEC/Abjk06kRQ2icoR8TDyVox2k4yV1d3A7QPkbmiP72G
         NQ4jSLGyfUbmbzLvu2AEPthRxYMd4h+XJfUpiMjl5P837Zt4/qNRIhMdsgjAUYaJ5/
         avf/seh3qbdsA==
Date:   Tue, 28 Feb 2023 14:26:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
        andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <20230228142648.408f26c4@kernel.org>
In-Reply-To: <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
References: <20200730124730.GY1605@shell.armlinux.org.uk>
        <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
        <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
        <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
        <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
        <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
        <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
        <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
        <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
        <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
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

On Tue, 28 Feb 2023 16:27:10 +0000 Russell King (Oracle) wrote:
> > 5. other?  
> 
> Another possible solution to this would be to introduce a rating for
> each PTP clock in a similar way that we do for the kernel's
> clocksources, and the one with the highest rating becomes the default. 

Why not ethtool? Sorry if I'm missing something obvious..
