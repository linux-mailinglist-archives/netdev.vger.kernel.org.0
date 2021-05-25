Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D39839029B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhEYNgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 09:36:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56228 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233314AbhEYNgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 09:36:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QVfCIaJRZFdqpoQnaoHLSToEK5uzlriQqJf3wkiuazc=; b=5R9PKruX3AeXuSgBIK5hbOv6m+
        y83vfrQcHBqM9gxRwfUDfCXViccGgbQaYYxnThE+jTEmg0PlZq+RSHuEI2x1i+IwQon8hHTiQHXWm
        ZFhV7NXIVHludp9V4D2izp33zklOGKmv09hgudoXqb31Pm64byQOP+2ULCxi4kU57xfQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llXCc-006B0y-8r; Tue, 25 May 2021 15:34:34 +0200
Date:   Tue, 25 May 2021 15:34:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 0/2] Introduce MDIO probe order C45 over C22
Message-ID: <YKz86iMwoP3VT4uh@lunn.ch>
References: <20210525055803.22116-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525055803.22116-1-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 01:58:03PM +0800, Wong Vee Khee wrote:
> Synopsys MAC controller is capable of pairing with external PHY devices
> that accessible via Clause-22 and Clause-45.
> 
> There is a problem when it is paired with Marvell 88E2110 which returns
> PHY ID of 0 using get_phy_c22_id(). We can add this check in that
> function, but this will break swphy, as swphy_reg_reg() return 0. [1]

Is it possible to identify it is a Marvell PHY? Do any of the other
C22 registers return anything unique? I'm wondering if adding
.match_phy_device to genphy would work to identify it is a Marvell PHY
and not bind to it. Or we can turn it around, make the
.match_phy_device specifically look for the fixed-link device by
putting a magic number in one of the vendor registers.

    Andrew
