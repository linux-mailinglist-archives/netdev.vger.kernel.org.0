Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179414C3261
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiBXQ6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiBXQ63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:58:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA347433B1;
        Thu, 24 Feb 2022 08:57:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FFAB619E2;
        Thu, 24 Feb 2022 16:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89985C340FF;
        Thu, 24 Feb 2022 16:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645721875;
        bh=VsHRTV7aICRI+ROp0zh53/L5aAom3s0dMx0t31Au44Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KlYyN74PS4i7EISHuML/k0Zk+ppdJ3eAsKx8rwkPNlscoqLFOgYtFAS3uiBVifmPu
         1B07YVArtVJ+TjDxrqesKE68KHah4PIXSQTQF0V1DBSC4y7mJyujoLxW5DFzz2BhxU
         wFDQozxSCgnTi4da+vcOUxd4h+ufRHSX4QM+2NYaAK5smNPVeCDxnwuEA8HjqEGzde
         OaHXTZdDnoYSdN6EP9SYh+MQg2NNdVJ/LQTVFzNNVRqlLWm+IhtP6uADttsc1bDw9h
         zARSISmgmsFwtm8mgR2KYvIhIx9yWZlp+9ge7qR6zrgHX5gJVomAhe2XCA2X2s58YR
         cwh5pu8aLmI2g==
Date:   Thu, 24 Feb 2022 08:57:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mauri Sandberg <maukka@ext.kapsi.fi>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] net: mv643xx_eth: process retval from
 of_get_mac_address
Message-ID: <20220224085754.703860a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220223142337.41757-1-maukka@ext.kapsi.fi>
References: <20220221062441.2685-1-maukka@ext.kapsi.fi>
        <20220223142337.41757-1-maukka@ext.kapsi.fi>
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

On Wed, 23 Feb 2022 16:23:37 +0200 Mauri Sandberg wrote:
> Obtaining a MAC address may be deferred in cases when the MAC is stored
> in an NVMEM block, for example, and it may not be ready upon the first
> retrieval attempt and return EPROBE_DEFER.
> 
> It is also possible that a port that does not rely on NVMEM has been
> already created when getting the defer request. Thus, also the resources
> allocated previously must be freed when doing a roll-back.
> 
> Signed-off-by: Mauri Sandberg <maukka@ext.kapsi.fi>
> Cc: Andrew Lunn <andrew@lunn.ch>

While we wait for Andrew's ack, is this the correct fixes tag?

Fixes: 76723bca2802 ("net: mv643xx_eth: add DT parsing support")
