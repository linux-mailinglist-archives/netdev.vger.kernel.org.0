Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BBA3D953A
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhG1SYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:24:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50460 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhG1SYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 14:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LvOjBUqVjrLqN4kS0GCldCtmhitVnGI4xDgdqBcDq5o=; b=i4aWQy5iAL3uVvCxgcCOJea1/h
        KSL/F5ipDtdbj3ru2mVgQJxxiK3RfJnkZg3M2ITPmZM8XIHQXv+CULxWHUy3xDJom4aamD+Rpuspk
        WTACF6PiOL56w7ZCbWMYuD85m+HcHFrpX5TVUfgFvj3XqrM6d/eSxktRh4vPLSevxHIw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8oDm-00FDbS-4R; Wed, 28 Jul 2021 20:23:58 +0200
Date:   Wed, 28 Jul 2021 20:23:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dario Alcocer <dalcocer@helixd.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
Message-ID: <YQGgvj2e7dqrHDCc@lunn.ch>
References: <YPrHJe+zJGJ7oezW@lunn.ch>
 <0188e53d-1535-658a-4134-a5f05f214bef@helixd.com>
 <YPsJnLCKVzEUV5cb@lunn.ch>
 <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
 <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com>
 <YPxPF2TFSDX8QNEv@lunn.ch>
 <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
 <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 11:07:37AM -0700, Dario Alcocer wrote:
> It appears the port link-state issue is caused by the mv88e6xxx switch
> driver. The function mv88e6xxx_mac_config identifies the PHY as internal and
> skips the call to mv88e6xxx_port_setup_mac.
> 
> It does not make sense to me why internal PHY configuration should be
> skipped.

The switch should do the configuration itself for internal PHYs. At
least that works for other switches. What value does CMODE have for
the port? 0xf?

    Andrew
