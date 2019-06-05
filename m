Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A77035CAE
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 14:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfFEMYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 08:24:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58126 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727172AbfFEMYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 08:24:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4oWPZj0Wa51huFxiPKzXFmh7QlniWG9vWBBiN/IhkKk=; b=E7cHf83+Stia4Q6LSVDkVKJHTI
        pn0AjAJBWnkNrNeqGrEf1PJRTlP/t22WP8Z/mKAM/qMXUhtLXzmRfPgN2hbgMXZX4NXeGrBbiEy2T
        ZvvXa0/B8F4SwTb39XU4H3JpqsKrMSBOJaqtGLSFscn28L1b4F6zubMRlu/8aokQs9SM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYUxY-00046t-S7; Wed, 05 Jun 2019 14:24:04 +0200
Date:   Wed, 5 Jun 2019 14:24:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA with MV88E6321 and imx28
Message-ID: <20190605122404.GH16951@lunn.ch>
References: <8812014c-1105-5fb6-bc20-bad0f86d33ea@eks-engel.de>
 <20190604135000.GD16951@lunn.ch>
 <854a0d9c-17a2-c502-458d-4d02a2cd90bb@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <854a0d9c-17a2-c502-458d-4d02a2cd90bb@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I got the devicetree from somebody that is why German is in it. But
> first I wanted to get it running before I tidy it up.  The switch is
> strapped to single mode (so I can read SMI addresses 0x10-0x16 and
> 0x1b-0x1e directly).

Hi Benjamin

You have miss-understood what reg means.

There are three addressing modes used by the various switches,
although most only support two.

In multi-chip mode, it occupies one address, and there are two
registers used to multiplex access to the underlying registers.  In
this setup, you use reg=<X> to indicate the switch is using address X.

In single mode, it occupies all addresses on the MDIO bus, but many
are reserved. In this mode you use reg=<0>.

A few chips support dual mode, where you can have two switches on one
MDIO bus, one using 0x0-0xf, and the second using 0x10-0x1f. Here you
use reg=<0> or reg=<16>.

Try setting reg=<0> if you have it in single mode.

    Andrew
