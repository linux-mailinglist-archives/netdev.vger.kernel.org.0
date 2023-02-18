Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EAD69B749
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 02:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBRBEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 20:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjBRBEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 20:04:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A97457E9
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 17:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OYMF+IjE855gEtm25bEWX9N6Axm6HyORo51Hcsq9l+Y=; b=edX+eHSh9F1JczhEhrl7YaEH/g
        hAzg8NWW1WpDd1yiy2I1s+N2p5VB/PVg0QoK4ukYStGLe3CUNuzWyU5rJ1KRy2yM2fw7p3n7NyOoa
        uFG+nVRc8lKklDtoRbHRYI8N2A0KWBuj2T6n5RLaMf5rdAvytbPeFeu/yd8RdXm7laWo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pTBeV-005M5v-1s; Sat, 18 Feb 2023 02:04:35 +0100
Date:   Sat, 18 Feb 2023 02:04:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Richard Weinberger' <richard@nod.at>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "wei.fang@nxp.com" <wei.fang@nxp.com>,
        "shenwei.wang@nxp.com" <shenwei.wang@nxp.com>,
        "xiaoning.wang@nxp.com" <xiaoning.wang@nxp.com>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>
Subject: Re: high latency with imx8mm compared to imx6q
Message-ID: <Y/AkI7DUYKbToEpj@lunn.ch>
References: <1422776754.146013.1676652774408.JavaMail.zimbra@nod.at>
 <b4fc00958e0249208b5aceecfa527161@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4fc00958e0249208b5aceecfa527161@AcuMS.aculab.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 08:49:23PM +0000, David Laight wrote:
> From: Richard Weinberger
> > Sent: 17 February 2023 16:53
> ...
> > I'm investigating into latency issues on an imx8mm system after
> > migrating from imx6q.
> > A regression test showed massive latency increases when single/small packets
> > are exchanged.
> > 
> > A simple test using ping exhibits the problem.
> > Pinging the very same host from the imx8mm has a way higher RTT than from the imx6.
> > 
> > Ping, 100 packets each, from imx6q:
> > rtt min/avg/max/mdev = 0.689/0.851/1.027/0.088 ms
> > 
> > Ping, 100 packets each, from imx8mm:
> > rtt min/avg/max/mdev = 1.073/2.064/2.189/0.330 ms
> > 
> > You can see that the average RTT has more than doubled.
> ...
> 
> Is it just interrupt latency caused by interrupt coalescing
> to avoid excessive interrupts?

Just adding to this, it appears imx6q does not have support for
changing the interrupt coalescing. imx8m does appear to support it. So
try playing with ethtool -c/-C.

    Andrew
