Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3EC126F57
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfLSVFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:05:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33988 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfLSVFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 16:05:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Z6+shlsb16iUzFq024VXsfdXlB/cz3r0//85zW14nco=; b=m985PNnQnCn9RSp0lupqjPipHJ
        IgdmeW3WJ/fi4wfhy5Qe0+dtY/nwes2DbglqjfUxZdxbhizzHCxJpS7czEVRMnM46KSoCHxCIcKup
        HuatsQD/yMJyUi1PBLuIjUF0cIrU1/jrC1HYvUD4v2KlpBo863DKY2B8ubvBEpzG2IHw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ii2yl-0005yp-77; Thu, 19 Dec 2019 22:05:03 +0100
Date:   Thu, 19 Dec 2019 22:05:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     rmk+kernel@armlinux.org.uk, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: make phy_error() report which PHY has
 failed
Message-ID: <20191219210503.GR17475@lunn.ch>
References: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
 <20191219.125010.1105219757379875134.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219.125010.1105219757379875134.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think I agree with Heiner that it is valuable to know whether the
> error occurred from the interrupt handler or the state machine (and
> if the state machine, where that got called from).
> 
> So I totally disagree with removing the backtrace, sorry.

Russell does have a point about the backtrace not giving an indication
of which phy experienced the error. So adding the phydev_err() call,
which will prefix the print with an identifier for the PHY, is a good
idea. So we should add that, and keep the WARN().

      Andrew
