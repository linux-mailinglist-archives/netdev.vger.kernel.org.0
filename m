Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7367C6A6367
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 00:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjB1XAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 18:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjB1XAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 18:00:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FAB37F0D
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 15:00:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B438B80EDC
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 22:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839B7C4339C;
        Tue, 28 Feb 2023 22:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677625152;
        bh=Z+Kj/6sEWrDtYSq3KyYeIZmPiExr3QUhN+wR5M4BIDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q5M9q4UqiPvLUHp1+8fLO1CtG9Z9xqHUjzxgE9j4p0PSYL+tpsdJ12bOIEcEtzzqD
         jtrqLmmppFt5AG1wKLzQf65T4TRNwfaBHNfdb6wWZS4OEtgJSSTEzxCRqplIDAmakH
         bqw9bUuigyduytqTmj5PN3Pt0Ov9z9MANeaAjtpYj8NE8O7EniWvsl2qxuxZJcVqVI
         7AwXz7+oWFwCW1tk280DhO5p6D2n264o377C0GgAjI4EpaqluTdVTYTl3a6Dao3c47
         qPn5GgFybHPOo50DeSfWp/tJCl+4kEuFoRHHn1yZBNSYI+4vzfLY5EPtvh1qxzmXfO
         eRSoAMkKalOfw==
Date:   Tue, 28 Feb 2023 14:59:11 -0800
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
Message-ID: <20230228145911.2df60a9f@kernel.org>
In-Reply-To: <Y/6Cxf6EAAg22GOL@shell.armlinux.org.uk>
References: <20230227154037.7c775d4c@kmaincent-XPS-13-7390>
        <Y/zKJUHUhEgXjKFG@shell.armlinux.org.uk>
        <Y/0Idkhy27TObawi@hoboy.vegasvil.org>
        <Y/0N4ZcUl8pG7awc@shell.armlinux.org.uk>
        <Y/0QSphmMGXP5gYy@hoboy.vegasvil.org>
        <Y/3ubSj5+2C5xbZu@shell.armlinux.org.uk>
        <20230228141630.64d5ef63@kmaincent-XPS-13-7390>
        <Y/4ayPsZuYh+13eI@hoboy.vegasvil.org>
        <Y/4rXpPBbCbLqJLY@shell.armlinux.org.uk>
        <20230228142648.408f26c4@kernel.org>
        <Y/6Cxf6EAAg22GOL@shell.armlinux.org.uk>
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

On Tue, 28 Feb 2023 22:40:05 +0000 Russell King (Oracle) wrote:
> IMHO, it's better if the kernel automatically selects a sensible
> default _and_ gives the user the ability to override it e.g. via
> ethtool.

Oh, I see, makes sense.
