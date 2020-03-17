Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDE0188A7E
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 17:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgCQQiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 12:38:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41236 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbgCQQiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 12:38:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f4Vg4ujTNe+gB3luatRKaUCrueq5sdKPTPzwO5uX0Ac=; b=cLWGWRQEzK4gZf2xg0kU6pfdG0
        PgrTMjqiLV54yP+JeNsiTg4qA9ACjRTK02+AOTvSSOzeXaTD8MW29346JbzoGa54Ny/lNggOesQT3
        Y+ldrIVpooCkI4Ul4rGkCb0xqRDKjgdeleH0iy11nYEsTeXmrbjx0Cqhus7//TMA67wg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jEFEA-0007gs-ML; Tue, 17 Mar 2020 17:38:02 +0100
Date:   Tue, 17 Mar 2020 17:38:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Message-ID: <20200317163802.GZ24270@lunn.ch>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 02:52:51PM +0000, Russell King wrote:
> *NOT FOR MERGING*
> 
> Add a separate set of PCS operations, which MAC drivers can use to
> couple phylink with their associated MAC PCS layer.  The PCS
> operations include:
> 
> - pcs_get_state() - reads the link up/down, resolved speed, duplex
>    and pause from the PCS.
> - pcs_config() - configures the PCS for the specified mode, PHY
>    interface type, and setting the advertisement.
> - pcs_an_restart() - restarts 802.3 in-band negotiation with the
>    link partner
> - pcs_link_up() - informs the PCS that link has come up, and the
>    parameters of the link. Link parameters are used to program the
>    PCS for fixed speed and non-inband modes.

Hi Russell

This API makes sense. But it seems quite common to have multiple
PCS's. Rather than have MAC drivers implement their own mux, i wonder
if there should be core support? Or at least a library to help the
implementation?

	Andrew
