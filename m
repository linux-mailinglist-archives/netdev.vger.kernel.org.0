Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1546ECF83
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjDXNrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjDXNrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:47:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF13B7A9C
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 06:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xIkKyz7lqnw+mbfjlUXEdXbIofSt8iMUpVnA6Q4lstQ=; b=UWnenMvyoYRvyClHtyiNxaCRzR
        JCju/N2hsmhVMHlQr0zQp9arj3t96aq2b/EzyjL4hxIbgmfkSOf4PrXEVLS1q8mLbMKtqfMTpmPrv
        YsyBWrms+kqspqonUJvhwYyKgUqZBR7dx94YGV/pwawYfbDXWXW5htYwMG8E/W/HGM48=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pqwXC-00B63h-Ls; Mon, 24 Apr 2023 15:47:14 +0200
Date:   Mon, 24 Apr 2023 15:47:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: phy: Fix reading LED reg property
Message-ID: <c01a4c59-6668-4ae7-b7cf-54d5a5a7e897@lunn.ch>
References: <20230424134003.297827-1-alexander.stein@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424134003.297827-1-alexander.stein@ew.tq-group.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 03:40:02PM +0200, Alexander Stein wrote:
> 'reg' is always encoded in 32 bits, thus it has to be read using the
> function with the corresponding bit width.

Hi Alexander

Is this an endian thing? Does it return the wrong value on big endian
systems?

I deliberately used of_property_read_u8() because it will perform a
range check, and if the value is bigger or smaller than 0-256 it will
return an error. Your change does not include such range checks, which
i don't like.

  Andrew
