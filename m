Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFEC6557A8E
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 14:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiFWMnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 08:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiFWMnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 08:43:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628E51183F;
        Thu, 23 Jun 2022 05:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fw13PT4f/o51mico3RM7ZZY+ckMOJ2/9wKDSKcOEvGc=; b=bg7OGbc5Idq+okMLUPctd/gpY1
        MLQYHMUg+xVkIIgrdyBnPGu7zL1JAdDtTX5JbdYtmheZXj8OC+NKfR/FZg1nfyTbC39qO95/wQm1h
        UU0TfGEPidi40zVTlkl7n+TsJiqNqa6/3ZgSiw/dSgCa9KQRMmY7Z3ZpChYVWj0xS4pI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o4MAg-007y6n-2b; Thu, 23 Jun 2022 14:42:54 +0200
Date:   Thu, 23 Jun 2022 14:42:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com
Subject: Re: [PATCH 1/2] net: dp83822: disable false carrier interrupt
Message-ID: <YrRfzph6jyg2pUyO@lunn.ch>
References: <YqzAKguRaxr74oXh@lunn.ch>
 <20220623085125.1426049-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623085125.1426049-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 10:51:25AM +0200, Enguerrand de Ribaucourt wrote:
> When unplugging an Ethernet cable, false carrier events were produced by
> the PHY at a very high rate. Once the false carrier counter full, an
> interrupt was triggered every few clock cycles until the cable was
> replugged. This resulted in approximately 10k/s interrupts.
> 
> Since the false carrier counter (FCSCR) is never used, we can safely
> disable this interrupt.
> 
> In addition to improving performance, this also solved MDIO read
> timeouts I was randomly encountering with an i.MX8 fec MAC because of
> the interrupt flood. The interrupt count and MDIO timeout fix were
> tested on a v5.4.110 kernel.

Since this is version 2, you should add v2 into the subject line. See
the submitting patches document in the kernel documentation.

Also, with patch sets, please include a patch 0/X which describes the
big picture.

This is also a bug fix, you are stopping an interrupt storm. So please
include a Fixes: tag indicating where the issue was introduced.

The code itself looks good, it is just getting the processes right.

	Andrew
