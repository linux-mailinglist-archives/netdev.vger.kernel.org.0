Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71311E6ECA
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437174AbgE1WYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:24:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55564 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437163AbgE1WYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 18:24:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ftQ5JaNqXNixqQRjexgi8e7gJsQfV0dE9Xitfbw95M4=; b=1uDPjblHgipQgbWe4yeLqpUTuH
        LSAOvfi8+zPsJUQnJk6woz7lQIMK+YF8GFAaIgc9Z0BaljYJ626Y9afAJ+OX/XAq2QdgmSWR1/3An
        0HUxqk4Gz+k8o3j48DrqG344sVdcJZ1xp5ozlTSpMQ3H8+ubc9p6hQfCKxnG6BJElTLU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeQxD-003aRx-Th; Fri, 29 May 2020 00:24:47 +0200
Date:   Fri, 29 May 2020 00:24:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     netdev@vger.kernel.org
Subject: Re: Usage of mdelay() inside Interrupt
Message-ID: <20200528222447.GB853774@lunn.ch>
References: <20200528211518.GA15665@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528211518.GA15665@localhost>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 11:15:18PM +0200, Armin Wolf wrote:
> Hi,
> 
> while browsing the sourcefile of lib8390.c in
> drivers/net/ethernet/8390/, i noticed that inside
> of ei_rx_overrun(), which is called from inside
> a Interrupt handler, mdelay() is being used.
> So i wonder if the usage of mdelay() inside the
> Interrupt handler may cause problems since waiting
> ~10ms in Interrupt context seems a bit odd.

Hi Armin

It is legal. But it is not ideal. But reading the comments around it
suggests the hardware is very particular about how you recover from an
overrun, and maybe this is the most robust solution?

Overruns should not happen too often. If the statistics counter
stats.rx_over_errors indicates it is happening a lot then maybe more
investigation is needed, because it is going to be bad for
performance.

	Andrew
