Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84D850D4D4
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 21:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238831AbiDXTaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 15:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbiDXTaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 15:30:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B950063BDD;
        Sun, 24 Apr 2022 12:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7UroR8cAk0U12qPAV3NETzrxsB+mhh/WgYHXhvV0K1A=; b=AiBlkAMTTAwBXjlgFs684hKIuv
        +XSB8CvcFDntfNe+k8tbirvzR1X1otSngrByisNnqvqYM1y4O4rSsShVCx7SOg4mxBdjuD16j+f9D
        E1o3W87v+EI7dDzLHAmj03RS1wwgrGeNfRswhAzCHJObnG9stn0tFLRtJhpKLpfzc+9s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nihso-00HIdF-G3; Sun, 24 Apr 2022 21:26:58 +0200
Date:   Sun, 24 Apr 2022 21:26:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Behun <kabel@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: Fix port_hidden_wait to account
 for port_base_addr
Message-ID: <YmWkgkILCrBP5hRG@lunn.ch>
References: <20220424153143.323338-1-nathan@nathanrossi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424153143.323338-1-nathan@nathanrossi.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 03:31:43PM +0000, Nathan Rossi wrote:
> The other port_hidden functions rely on the port_read/port_write
> functions to access the hidden control port. These functions apply the
> offset for port_base_addr where applicable. Update port_hidden_wait to
> use the port_wait_bit so that port_base_addr offsets are accounted for
> when waiting for the busy bit to change.
> 
> Without the offset the port_hidden_wait function would timeout on
> devices that have a non-zero port_base_addr (e.g. MV88E6141), however
> devices that have a zero port_base_addr would operate correctly (e.g.
> MV88E6390).
> 
> Fixes: ea89098ef9a5 ("net: dsa: mv88x6xxx: mv88e6390 errata")

That is further back than needed. And due to the code moving around
and getting renamed, you are added extra burden on those doing the
back port for no actual gain.

Please verify what i suggested, 609070133aff1 is better and then
repost.

	Thanks
		Andrew
