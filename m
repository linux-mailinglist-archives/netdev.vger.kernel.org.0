Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4F718FA6D
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 17:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgCWQxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 12:53:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52232 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgCWQxr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 12:53:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=++z2CRK0gXpZoL10K6qxW/9324/513wsRgfOJfb5xyo=; b=CmqyHGZ/ocZ6tJuNr5AI//JEhB
        tpk9hhMmujhhNmONDJFm2imneT+JyEMaNuy5902fOqOqLtYQTuyhx+ybRFreph2ouCPvBbO0rBpEV
        yT9V58bLmF41RRGg2sdFD8qTUicExv29PtuhVUka1G0UqqiSp0gmfR6IiKTXYE+VDaHU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGQKf-0001QZ-6N; Mon, 23 Mar 2020 17:53:45 +0100
Date:   Mon, 23 Mar 2020 17:53:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Bauer <mail@david-bauer.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: at803x: select correct page on initialization
Message-ID: <20200323165345.GE32387@lunn.ch>
References: <20200323162730.88236-1-mail@david-bauer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323162730.88236-1-mail@david-bauer.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 05:27:30PM +0100, David Bauer wrote:
> The Atheros AR8031 and AR8033 expose different registers for SGMII/Fiber
> as well as the copper side of the PHY depending on the BT_BX_REG_SEL bit
> in the chip configure register.
> 
> The driver assumes the copper side is selected on probe, but this might
> not be the case depending which page was last selected by the
> bootloader.
> 
> Select the copper page when initializing the configuration to circumvent
> this.

Hi David

You might want to look at phy_read_paged(), phy_write_paged(), etc,
depending on your needs. There can be locking issues, which these
functions address.

	  Andrew
