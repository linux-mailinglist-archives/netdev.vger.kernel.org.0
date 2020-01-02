Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6A012EED7
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 23:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731002AbgABWgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 17:36:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730994AbgABWgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 17:36:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qlCueuEE71C15ND6txghr1ehOii+ZevQsrxgwVHUqsg=; b=HqLyerdC1lRmfibjog9UoAvp+H
        Mx6t56bJC/Cmm82qiR08dhg8uGTk+6lpuKDO0TC7NLeeRHwskq09ri6qpdVSKPFk4AtPUqOWS5Bm+
        9eHhPEk5tcICeNTsAZHwxYhINic649dRpZSZmB95xCSfVslhrm9ee4DRxJuXQo4J6FS8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1in957-0004aI-O4; Thu, 02 Jan 2020 23:36:41 +0100
Date:   Thu, 2 Jan 2020 23:36:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     baruch@tkos.co.il, vivien.didelot@gmail.com, marek.behun@nic.cz,
        netdev@vger.kernel.org, d.odintsov@traviangames.com
Subject: Re: [PATCH] net: dsa: mv88e6xxx: force cmode write on 6141/6341
Message-ID: <20200102223641.GI1397@lunn.ch>
References: <dd029665fdacef34a17f4fb8c5db4584211eacf6.1576748902.git.baruch@tkos.co.il>
 <20200102.124556.1780903980066866154.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102.124556.1780903980066866154.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 02, 2020 at 12:45:56PM -0800, David Miller wrote:
> From: Baruch Siach <baruch@tkos.co.il>
> Date: Thu, 19 Dec 2019 11:48:22 +0200
> 
> > mv88e6xxx_port_set_cmode() relies on cmode stored in struct
> > mv88e6xxx_port to skip cmode update when the requested value matches the
> > cached value. It turns out that mv88e6xxx_port_hidden_write() might
> > change the port cmode setting as a side effect, so we can't rely on the
> > cached value to determine that cmode update in not necessary.
> > 
> > Force cmode update in mv88e6341_port_set_cmode(), to make
> > serdes configuration work again. Other mv88e6xxx_port_set_cmode()
> > callers keep the current behaviour.
> > 
> > This fixes serdes configuration of the 6141 switch on SolidRun Clearfog
> > GT-8K.
> > 
> > Fixes: 7a3007d22e8 ("net: dsa: mv88e6xxx: fully support SERDES on Topaz family")
> > Reported-by: Denis Odintsov <d.odintsov@traviangames.com>
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> 
> This thread has stalled on December 20th with Baruch asking if we can put this
> in for now as a temporary fix that solves the given problem whilst a better
> long term analysis and change is being worked on.

Hi David

It seems like a reasonable fix for the moment.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
