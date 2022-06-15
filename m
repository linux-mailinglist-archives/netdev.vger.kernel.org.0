Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D70054D04B
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 19:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242330AbiFORq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 13:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiFORqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 13:46:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39F153E3A
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 10:46:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E4A561B83
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 17:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61526C34115;
        Wed, 15 Jun 2022 17:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655315213;
        bh=ooKADeM00koUfd1W4RU/WAsSy7gZaiXcy6jOy2REyPI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qR+os5uzs7/Vktrc+xuLhJsX1GGqgWeaj93IrZQr5C4LXr8mn+ZXrxq81/KNl5bZV
         Ao9Pdnt/Fm3SUSnBTwmgtkdtwT+nYq4pnap6nmvIWOM/xJBlObRPA+SjRjOZS7dnyV
         L2/Ae8zfEHK/km7rb5DaeUUt+BVf/p+uBMLBRbsxDRvrvhccZFk5nbHjxA+VZPwGFf
         xQioru/+gMll/BmxM9V8Vy+qkxb5NVscHe7NzPZIVIamaEtrtGJS573tOlRaiojM65
         TqEdsmx2vJGCQtmP2AFy/W6SZmyNhzj2fcB1TQ2qThIkETEVUiB5APRf/ynRlXGmsE
         zXACksx7RPB4w==
Date:   Wed, 15 Jun 2022 10:46:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 02/15] net: phylink: add phylink_pcs_inband()
Message-ID: <20220615104652.591f5e98@kernel.org>
In-Reply-To: <YqmVdj4X5101PC1u@shell.armlinux.org.uk>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
        <E1o0jgF-000JYC-49@rmk-PC.armlinux.org.uk>
        <20220614224652.09d4c287@kernel.org>
        <YqmVdj4X5101PC1u@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jun 2022 09:16:54 +0100 Russell King (Oracle) wrote:
> > Patch 1 does not need to be backported so I presume it can lose the
> > fixes tag?  
> 
> As the commit talks about fixing something, in my experience the commit
> will get automatically selected for backporting to stable trees whether
> or not it has a fixes tag on it. The only way to stop that happening is
> not through avoiding a fixes tag, but to keep on top of the stable tree
> emails to stop patches being backported that don't need to be.
> 
> If you still want me to remove it, I will, but I predict it will still
> be backported.

Fair, but the argument is not very... "clean", if you will. I read the
argument as "the unwelcome thing is likely to happen anyway, so doesn't
matter". But Fixes serves no purpose here, since we don't expect the
backport. So we are defaulting to adding something useless on the basis
of it not making things worse?

I'm only saying that to make sure I understand your perspective.
Obviously not something I'd hold your patches over, fine either way.
