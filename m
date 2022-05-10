Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8ECB521E1F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345361AbiEJPYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243371AbiEJPXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:23:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A4169B4C;
        Tue, 10 May 2022 08:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BrcjASk2DUAbQD/eqUjTD3NlvEuIpKwMRXYxlN/O2qM=; b=qxibPyP2TKp3T8QBcCXx62qvwZ
        6k5wkRVMp5dfQiNbYk2Ek27D4KQypIdofH0g+CQG+RrbVqSRG9lxkFk2EuBKFTX8FbvLI1h3F38oA
        4Jm2mguxTeKGpQ8TS+hS6t8Z5KfLSMVCaevz98lw7xs9x4OJNX0wV1tFPPYaIA7Ttc3s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1noRT5-002A5B-Jd; Tue, 10 May 2022 17:08:07 +0200
Date:   Tue, 10 May 2022 17:08:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] net: phy: mscc: Add error check when __phy_read()
 failed
Message-ID: <Ynp/124xVt+lUa6f@lunn.ch>
References: <20220510142247.16071-1-wanjiabing@vivo.com>
 <165219411356.3924.11722336879963021691@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165219411356.3924.11722336879963021691@kwain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Does this fix an actual issue or was this found by code inspection? If
> that is not fixing a real issue I don't think it should go to stable
> trees.

You are probably right about stable vs net-next. With the old code, a
bad read will result in random return values and bad things are likely
to happen. With this change, 0 will be returned, and hopefully less
bad things will happen.

But i doubt this impacts real users. MDIO tends to either work or not
work at all. And not working is pretty noticeable, and nobody has
reported issues.

So, lets drop the fixes tag, and submit to net-next.

	 Andrew
