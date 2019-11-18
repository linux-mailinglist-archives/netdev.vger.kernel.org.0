Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B565F100F76
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 00:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfKRXif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 18:38:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45242 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726795AbfKRXie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 18:38:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+gyPTj0ulkxKiKx/TxVg16730+9x+rAbmIcyaqpG7Co=; b=Vw0IoUwRIz5RAc1ICtQf5cpkGw
        aT+FA+w2Q6NP/EhzU9ZJNrWKHffKeSJMbyanQRl/W2yFxk8ChyHcw2R73s5jiFtHFJsISBi6tnnMT
        SvVurnXdx5bhxPrEsB2bq+6XHOTlQQTZu9JcWs6lcu9dyG5rGf0jMuQ6ZQujlriQk3pQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iWqbI-0005pu-4V; Tue, 19 Nov 2019 00:38:32 +0100
Date:   Tue, 19 Nov 2019 00:38:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH net 1/1] mdio_bus: fix mdio_register_device when
 RESET_CONTROLLER is disabled
Message-ID: <20191118233832.GD15395@lunn.ch>
References: <20191118181505.32298-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191118181505.32298-1-marek.behun@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 07:15:05PM +0100, Marek Behún wrote:
> When CONFIG_RESET_CONTROLLER is disabled, the
> devm_reset_control_get_exclusive function returns -ENOTSUPP. This is not
> handled in subsequent check and then the mdio device fails to probe.
> 
> When CONFIG_RESET_CONTROLLER is enabled, its code checks in OF for reset
> device, and since it is not present, returns -ENOENT. -ENOENT is handled.
> Add -ENOTSUPP also.
> 
> This happened to me when upgrading kernel on Turris Omnia. You either
> have to enable CONFIG_RESET_CONTROLLER or use this patch.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> Fixes: 71dd6c0dff51b ("net: phy: add support for reset-controller")

This seems reasonable.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
