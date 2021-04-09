Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E0D35A57E
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbhDISOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:14:50 -0400
Received: from polaris.svanheule.net ([84.16.241.116]:54962 "EHLO
        polaris.svanheule.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234578AbhDISOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 14:14:39 -0400
Received: from [IPv6:2a02:a03f:eaff:9f01:16d1:68eb:7ab8:2bc3] (unknown [IPv6:2a02:a03f:eaff:9f01:16d1:68eb:7ab8:2bc3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: sander@svanheule.net)
        by polaris.svanheule.net (Postfix) with ESMTPSA id 264EC1ED3FB;
        Fri,  9 Apr 2021 20:14:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svanheule.net;
        s=mail1707; t=1617992065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hcu30fXGAr7gHk4i20arIo7AuPzPhaCCgZCP5EeYFOM=;
        b=qlwXqOJE7j27k1eDu/ednXmVtCfbxkVH5gj//lV753KNLarSmxIy5UtJBzgfGml/ac2p5X
        VOIHp+DcXg9k0glbiuGPPgfOE0CTcjfrgG4iLHmbM+pnoDQnsWRoxcP8rTafcNQgi83o6i
        G6TfYfrhXRvXPPCct1yIp7Crh11FbCNpGZemLQzstSMpaLsnvy5q+Xn+24JklRZn9uxkj0
        YL4CgTNMeitYpdchRTyHI6zlfA1sZ4AIyQja/7JAZn5qvMbNOMWavX5D/e6KSgVe9f1UKH
        PNeH5cNpQ6Yg7oxtAP7Q9dhKnjvZ59Qa/rxnXLRtV5mz3MOEWKRipa5k7Ro/Dw==
Message-ID: <8af840c5565343334954979948cadf7576b23916.camel@svanheule.net>
Subject: Re: [RFC PATCH 1/2] regmap: add miim bus support
From:   Sander Vanheule <sander@svanheule.net>
To:     Mark Brown <broonie@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>, bert@biot.com
Date:   Fri, 09 Apr 2021 20:14:22 +0200
In-Reply-To: <20210409160750.GD4436@sirena.org.uk>
References: <cover.1617914861.git.sander@svanheule.net>
         <489e8a2d22dc8a5aaa3600289669c3bf0a15ba19.1617914861.git.sander@svanheule.net>
         <20210409160750.GD4436@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

On Fri, 2021-04-09 at 17:07 +0100, Mark Brown wrote:
> On Thu, Apr 08, 2021 at 10:52:34PM +0200, Sander Vanheule wrote:
> > Basic support for MIIM bus access. Support only includes clause-22
> > register access, with 5-bit addresses, and 16-bit wide registers.
> 
> What is "MIIM"?  A quick search isn't showing up useful hits for that.
> Why not just call this MDIO like the rest of the kernel is doing, it
> seems like using something else is at best going to make it harder to
> discover this code?  If MIIM is some subset or something it's not
> obvious how we're limited to that.

MIIM stands for "MII management", i.e. the management bus for devices
with some form of MII interface. MDIO is also frequently used to refer
to the data pin of the bus (there's also MDC: the clock pin), so I
wanted to make the distinction.

The kernel has the mii_bus struct to describe the bus master, but like
you noted the bus is generaly refered to as an MDIO interface. I'm fine
with naming it MDIO to make it easier to spot.

Best,
Sander

