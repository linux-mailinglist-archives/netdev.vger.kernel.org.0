Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878DF47BDC2
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 10:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhLUJxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 04:53:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36906 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230302AbhLUJxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 04:53:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/zhb72PIpmMP/0f9ZICy5PiOV32parsA7zs1T2++Su8=; b=vV/PvZ5J+yf/eBz9TxQN5C6547
        jTVoOQe42AfClJxVu6AsIj1JIsdrzKYbHYpeEOHhNX+m9SaaxUMEys4rRXqMORKeJpcCFsD5wqV5y
        CxZUlwigKsVwN/SaCr6DbNaOuo29WeXVkLLXT6k1YIzy2/VFQZraAc5aSm+xoyc7LSLI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzbpw-00H7Hz-Ez; Tue, 21 Dec 2021 10:53:36 +0100
Date:   Tue, 21 Dec 2021 10:53:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>
Cc:     linux-kernel@vger.kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Message-ID: <YcGkILZxGLEUVVgU@lunn.ch>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221065047.290182-2-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +The following diagram shows a typical packet processing pipeline with the Intel DLB.
> +
> +                              WC1              WC4
> + +-----+   +----+   +---+  /      \  +---+  /      \  +---+   +----+   +-----+
> + |NIC  |   |Rx  |   |DLB| /        \ |DLB| /        \ |DLB|   |Tx  |   |NIC  |
> + |Ports|---|Core|---|   |-----WC2----|   |-----WC5----|   |---|Core|---|Ports|
> + +-----+   -----+   +---+ \        / +---+ \        / +---+   +----+   ------+
> +                           \      /         \      /
> +                              WC3              WC6

This is the only mention of NIC here. Does the application interface
to the network stack in the usual way to receive packets from the
TCP/IP stack up into user space and then copy it back down into the
MMIO block for it to enter the DLB for the first time? And at the end
of the path, does the application copy it from the MMIO into a
standard socket for TCP/IP processing to be send out the NIC?

Do you even needs NICs here? Could the data be coming of a video
camera and you are distributing image processing over a number of
cores?

	 Andrew
