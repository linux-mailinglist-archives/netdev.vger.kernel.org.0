Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432871D32AA
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgENOWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:22:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60342 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgENOWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 10:22:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iw7xPk5mHjedIW+MdeZHEhO6QWaPHxp9nZEO29+rOl0=; b=tLcLf7syCfJU0V+88jYPQ65lQ9
        bxfnLVhL3a9oL89tZzFlHcc06sc4cByFjoPlq+0a5WYgzGcxGh7CPmcdx/h49YPPUX/N2QNumJksn
        EhoeiOUsKp11e8u9aUl98cJpm6oyAOLYAAEgRQNsWRBr69NflByorECzFbCWx2TMyrWs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZEl5-002IDV-Fa; Thu, 14 May 2020 16:22:47 +0200
Date:   Thu, 14 May 2020 16:22:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 18/19] net: ks8851: Implement Parallel bus operations
Message-ID: <20200514142247.GR499265@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-19-marex@denx.de>
 <20200514015753.GL527401@lunn.ch>
 <5dbab44d-de45-f8e2-b4e4-4be15408657e@denx.de>
 <20200514131527.GN527401@lunn.ch>
 <16f60604-f3e9-1391-ff47-37c40ab9c6f7@denx.de>
 <20200514140722.GQ499265@lunn.ch>
 <b810e344-8a6c-a3dc-cfd3-1eba116bfcd7@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b810e344-8a6c-a3dc-cfd3-1eba116bfcd7@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 04:14:13PM +0200, Marek Vasut wrote:
> On 5/14/20 4:07 PM, Andrew Lunn wrote:
> >> All right
> >>
> >> btw is jiffies-based timeout OK? Like this:
> > 
> > If you can, make use of include/linux/iopoll.h
> 
> I can't, because I need those weird custom accessors, see
> ks8851_wrreg16_par(), unless I'm missing something there?

static int ks8851_rdreg16_par_txqcr(struct foo ks) {
       return ks8851_rdreg16_par(ks, KS_TXQCR)
}

int txqcr;

err = readx_poll_timeout(ks8851_rdreg16_par_txqcr, txqcr,
                         txqcr & TXQCR_METFE, 10, 10, ks)

	 Andrew
