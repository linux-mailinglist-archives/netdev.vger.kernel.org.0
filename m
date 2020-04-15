Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9591A8FAB
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 02:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392382AbgDOAVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 20:21:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38030 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392373AbgDOAUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 20:20:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DNxVMcdN0fHM74o28syLvCDPwdnk5xedQN9SxOkrhQg=; b=giUEjOUqVrhcuuacotB0KOLaQ3
        JVSSqKF7qu2ppRBKZ16oj169KL94HBhvKcJxkic6P6s7IWIdwmVljFcI0/iXFjvCXGHw5x6bgJI88
        9R3K35EZhBY1FDR0Inpa8lT8WktA/lVKbJE/MUrJ4jbuIKu2J1KBzsovnV1VQ4kZgH5k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOVnJ-002m9m-On; Wed, 15 Apr 2020 02:20:45 +0200
Date:   Wed, 15 Apr 2020 02:20:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com, Chris.Healy@zii.aero,
        cphealy@gmail.com
Subject: Re: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Message-ID: <20200415002045.GF611399@lunn.ch>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <20200414.163830.2151404177947586721.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414.163830.2151404177947586721.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 04:38:30PM -0700, David Miller wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Tue, 14 Apr 2020 02:45:51 +0200
> 
> > Measurements of the MDIO bus have shown that driving the MDIO bus
> > using interrupts is slow. Back to back MDIO transactions take about
> > 90uS, with 25uS spent performing the transaction, and the remainder of
> > the time the bus is idle.
> > 
> > Replacing the completion interrupt with polled IO results in back to
> > back transactions of 40uS. The polling loop waiting for the hardware
> > to complete the transaction takes around 27uS. Which suggests
> > interrupt handling has an overhead of 50uS, and polled IO nearly
> > halves this overhead, and doubles the MDIO performance.
> > 
> > Suggested-by: Chris Heally <cphealy@gmail.com>
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Where are we with this?
> 
> Andrew, do you intend to submit a version that via iopoll.h does
> cpu relax and usleeps?

Hi David

I do want to test such a version, yes.

  Andrew
