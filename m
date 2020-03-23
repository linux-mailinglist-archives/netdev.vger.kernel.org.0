Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99CA519000D
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCWVLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:11:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52702 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbgCWVLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 17:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WdELsRkhdf+MWM/L6Tfg7lZU2frqvB9d+bcVcBAEQDc=; b=ZV5++g4T2UiRDBjbcke4EQAX5b
        JH1S6YkT/IAYqGpH6Coeg75JmaFqhmMhThU8iyU0dAp2mQ8iAlEg8HtCE1yCWVHCDB6wE4efBxQjD
        fzg9RovjecA6GcjqvtJwwmq8UiiTTcqtfnYRvVGudZeErKUHxOfyhU08risOiB0sf2do=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGUMQ-0003KK-Sv; Mon, 23 Mar 2020 22:11:50 +0100
Date:   Mon, 23 Mar 2020 22:11:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Bauer <mail@david-bauer.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: at803x: select correct page on initialization
Message-ID: <20200323211150.GA12621@lunn.ch>
References: <20200323162730.88236-1-mail@david-bauer.net>
 <20200323165345.GE32387@lunn.ch>
 <f5f5c674-8563-bd92-c065-0bfbcc364ef5@david-bauer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5f5c674-8563-bd92-c065-0bfbcc364ef5@david-bauer.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 10:08:49PM +0100, David Bauer wrote:
> Hello Andrew,
> 
> On 3/23/20 5:53 PM, Andrew Lunn wrote:
> > You might want to look at phy_read_paged(), phy_write_paged(), etc,
> > depending on your needs. There can be locking issues, which these
> > functions address.
> 
> Thanks for the hint, i was not aware of these methods. I see how they can handle
> e.g. the page-switching logic in phy_read_paged.
> 
> However i still need to select the copper page on config initialization manually,
> as genphy_update_link is not page aware or am i missing something here?

Hi David

Yes, for that initial setup, you need to directly write to the
register. But at803x_aneg_done() should use these helpers.

	  Andrew
