Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08241B7E6A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 20:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgDXS4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 14:56:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33504 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728990AbgDXS4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 14:56:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f/ICdXX2tvt9HuwmkaXgLln2pWbCatON189erHV+D2w=; b=ULE80aEE/yZarCd/IiRPOo/cXz
        U+OCiL091aQQEn02pOCk+yq0IjVvJRMlySkWgN3IA0hxokJ0v6D+qZyLAwLaG3SHskytFroj5M4Vd
        QqDZFnoxY0ElN1+VwB+yC1/69/Gb5GbgQ5YUirHPRK4y1McjE2VO0cEeMZZJoIJeS7CM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jS3Ug-004bVa-GC; Fri, 24 Apr 2020 20:56:10 +0200
Date:   Fri, 24 Apr 2020 20:56:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tanjeff Moos <tanjeff@cccmz.de>
Cc:     Networking <netdev@vger.kernel.org>
Subject: Re: How to operate 10Gbit SFP+ module if driver doesn't support SFP+?
Message-ID: <20200424185610.GE1088354@lunn.ch>
References: <25058311-191c-055a-5966-aeb14440db2b@cccmz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25058311-191c-055a-5966-aeb14440db2b@cccmz.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 06:41:18PM +0200, Tanjeff Moos wrote:
> Hello netdev list,
> 
> I hope that I'm at the right mailinglist for my question. If not, let me
> know.
> 
> 
> Abstract
> --------
> 
> I'm trying to get a 10GBASE-SR SFP+ module running on a self-made board.
> The MAC driver doesn't support phylink (i.e. no I²C accesses to the SFP+
> registers), therefore I want to use PHY-less mode. On the other hand,
> the "fixed-link" mode supports only up to 1 Gbit. The "in-band-status"
> mode is said to not work with my setup. Thus I'm running out of options.
> I ask you if there are further options to get things running.
> 
> 
> About the hardware
> ------------------
> 
> My company built an access point containing an NXP QorIQ T1023 Soc. This
> SoC includes a MAC which is connected to an SFP+ cage. We use XFI for
> the connection between MAC and SFP+. In addition, the SFP+ module is
> connected to the SoC via I²C to access its registers.
> 
> 
> About the software
> ------------------
> 
> I am running OpenWRT with a Linux 4.14.137 kernel. There are patches on
> that kernel (mostly from the OpenWRT project, some by us).
 
Hi Tanjeff

Most kernel hackers don't care about such old kernels.

> Details about the problem
> -------------------------
> 
> For the MAC, I use the DPAA driver.

Is this dpaa2? If so, a modern kernel supports PHYLINK. That solves
most of your problems. The kernel SFP code should work so long as you
have access the i2c via a standard linux I2C bus.

     Andrew
