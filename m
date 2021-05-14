Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6DF380C4B
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbhENOxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:53:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40444 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232925AbhENOxo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 10:53:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AmV+EvcDeYdDnQmn67vbG6wCy+Lo347GLmfcoYF4nYU=; b=pgAhzW7y6e8e6S6CTD+RLxhtpw
        CIbMBW9p+nLCtjEejKjaI78U+3rS4xdSD+r6syqVKDDi5oul/aTaiVlDDHAk21Q+qcBBtRzBbitBD
        P33FQlRqgtMUki3Iqy1ps306xLiCE8BIMZsDHKA1FrrSh/78ephvIVnMkktqYUNAGEQk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhZAw-004CPx-UN; Fri, 14 May 2021 16:52:26 +0200
Date:   Fri, 14 May 2021 16:52:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH v3] net: phy: add driver for Motorcomm yt8511 phy
Message-ID: <YJ6OqpRTo+rlfb51@lunn.ch>
References: <20210514115826.3025223-1-pgwipeout@gmail.com>
 <YJ56G23e930pg4Iv@lunn.ch>
 <CAMdYzYrSB0G7jfG9fo85X0DxVG_r-qaWUyVAa5paAW0ugLvoxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMdYzYrSB0G7jfG9fo85X0DxVG_r-qaWUyVAa5paAW0ugLvoxw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I also wonder about bits 15:12 of PHY EXT ODH: Delay and driver
> > strength CFG register.
> 
> The default value *works*, and from an emi perspective we want the
> lowest strength single that is reliable.

I was not meaning signal strength, but Txc_delay_sel_fe,

  selecte tx_clk_rgmii delay in chip which is used to latch txd_rgmii
  in 100BT/10BTe mode. 150ps step. Default value 15 means about 2ns
  clock delay compared to txd_rgmii in typical cornor.

[Typos courtesy of the datasheet, not me!]

This sounds like more RGMII delays. It seems like PHY EXT 0CH is about
1G mode, and PHY EXT 0DH is about 10/100 mode. I think you probably
need to set this bits as well. Have you tested against a link peer at
10 Half? 100 Full?

   Andrew
