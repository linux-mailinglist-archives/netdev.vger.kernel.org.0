Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5111E94C2
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 02:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgEaAi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 20:38:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58852 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729361AbgEaAi0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 20:38:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=e9QIUdzd+iWIilrtCZ9ZBugPzhUA+6l2fFpJzvxDvH4=; b=0e2QjDN/lALeQ1lOnuUTCbBUoO
        Fm2v65fWeJYFKPm24HxbHM8aOlsBwoPR5BePSxCfG+Xz24zmwEqxGNefTHarKVLjGlR5U8d+rniUp
        SgTEC5FopK8ZuJwHC2Ws906OdpBLRo+a5DWKRkt7qdcqv/PYBSj8thstE3dQCLMaNz1Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jfBzZ-003lZ0-St; Sun, 31 May 2020 02:38:21 +0200
Date:   Sun, 31 May 2020 02:38:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: sja1105: suppress
 -Wmissing-prototypes in sja1105_static_config.c
Message-ID: <20200531003821.GA897737@lunn.ch>
References: <20200530102953.692780-1-olteanv@gmail.com>
 <20200530102953.692780-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530102953.692780-2-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 30, 2020 at 01:29:52PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Newer compilers complain with W=1 builds that there are non-static
> functions defined in sja1105_static_config.c that don't have a
> prototype, because their prototype is defined in sja1105.h which this
> translation unit does not include.
> 
> I don't entirely understand what is the point of these warnings, since
> in principle there's nothing wrong with that.

Hi Vladimir

The issue here is that the header might have a typo and have a
different signature than the function itself. The caller than passes
the parameters in the wrong way. Best case it segfault/Opps, but it
can introduce subtle bugs which are hard to find.

    Andrew
