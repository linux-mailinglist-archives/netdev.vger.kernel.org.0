Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCEE2918E1
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 20:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgJRSdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 14:33:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbgJRSdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 14:33:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67EA32087C;
        Sun, 18 Oct 2020 18:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603045986;
        bh=rUX21xiwxZSHn20h5/TwJJSIV3k9SLMqll3wpqVp1l4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DiXdr0kpKgpzLxn0BKqa54JD7D8VMuTcfwJKgz0n6DFN+DVW8mAgYmjUS7H5qfWFX
         M23ykewRNHfBeulGLOKNhmmxovHK9Br+CLgBXi5Ue51qmdYhyvUe/Ob4/teeKmFLXk
         iP1ZYivhiGOfQW+HhFGolvFDGl7attVdFR7UNtpc=
Date:   Sun, 18 Oct 2020 11:33:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Message-ID: <20201018113305.091946ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201018112653.21735d08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
        <20201017213611.2557565-2-vladimir.oltean@nxp.com>
        <20201018094951.0016f208@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201018173649.GF456889@lunn.ch>
        <20201018112653.21735d08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Oct 2020 11:26:53 -0700 Jakub Kicinski wrote:
> Hm, looks like the intent is to enforce power of two alignment 
> to prevent the structure from spanning cache lines. Doesn't make 
> any difference for 1 counter, but I guess we can keep the style 
> for consistency.

I take that back, looks like seqcount_t is 4B, so it will make
a difference, don't mind me :)
