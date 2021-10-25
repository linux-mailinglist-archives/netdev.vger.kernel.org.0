Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDC4439EA9
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbhJYSpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232401AbhJYSpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 14:45:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D06E660EBD;
        Mon, 25 Oct 2021 18:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635187382;
        bh=gE6uHg+CNrCPttWP8SdyDtd6v7lrV6svF2oKjF+jHo8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S6/JBHAHhqopwImSyelRp+Lf8IqMi6PcEBuZ06uQcejJSjtfFnNgmTPL0Keu218md
         ZIIDYqo8H5WtgGxMjDABu9mog+POKgz+GnKMQ11XXZ3CpY7Iteoa1XTvbBpOVaFza1
         EQjpJfVnSZwuIHuQBPPyHYBeDdA7CqwOFRwPuq+3iYyHwWXAeVAIKJaKLhQQfY+n++
         7m/ULST8RTc/EfL3xVPRmhersfkf62LTRUxR5MF4T+HnMoCMzOTHEtduKcK++PNfrE
         Bd93uI8a/v7OUHNYiqHPJQujPDE5MfahkuyrJX5jz3bSeMgvBA9DymBsI1qezdfIpc
         K+AUR13oRVzew==
Date:   Mon, 25 Oct 2021 11:43:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: ethtool: ring configuration for CAN devices
Message-ID: <20211025114300.15b8814c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YXaqEk97/WcCxcFE@lunn.ch>
References: <20211024213759.hwhlb4e3repkvo6y@pengutronix.de>
        <YXaimhlXkpBKRQin@lunn.ch>
        <20211025124331.d7r7qbadkzfk7i4f@pengutronix.de>
        <YXaqEk97/WcCxcFE@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 14:58:58 +0200 Andrew Lunn wrote:
> > > struct ethtool_kringparam {
> > > 	__u32	cmd;
> > > 	__u32   mode;
> > > 	__u32	rx_max_pending;
> > > 	__u32	rx_mini_max_pending;
> > > 	__u32	rx_jumbo_max_pending;
> > > 	__u32	tx_max_pending;
> > > 	__u32	rx_pending;
> > > 	__u32	rx_mini_pending;
> > > 	__u32	rx_jumbo_pending;
> > > 	__u32	tx_pending;
> > > };

Ah, yes, if we do full field-by-field translation the result is not as
bad as embedding the "base" structure, at the cost of additional
boilerplate code in the core. But frankly potato, potatoe.

> > > and use this structure between the ethtool core and the drivers. This
> > > has already been done at least once to allow extending the
> > > API. Semantic patches are good for making the needed changes to all
> > > the drivers.  
> > 
> > What about the proposed "two new parameters ringparam_ext and extack for
> > .get_ringparam and .set_ringparam to extend more ring params through
> > netlink." by Hao Chen/Guangbin Huang in:
> > 
> > https://lore.kernel.org/all/20211014113943.16231-5-huangguangbin2@huawei.com/
> >
> > I personally like the conversion of the in in-kernel API to struct
> > ethtool_kringparam better than adding ringparam_ext.  
> 
> Ah, i missed that development.

I think it's the fifth version and people are starting to have feedback.
Something is not working :(

> I don't like it.
> 
> You should probably jump into that discussion and explain your
> requirements. Make sure it is heading in a direction you can extend
> for your needs.
