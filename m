Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCF0293224
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 01:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389146AbgJSXzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 19:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389142AbgJSXzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 19:55:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 454012098B;
        Mon, 19 Oct 2020 23:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603151716;
        bh=MX3ChZ10By8l3k5Q+ttNQypMnym58fUo6pv/mtddLfM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q5viWLwhSLRgDJLUKQyy86gIVByjRPh5E691y45vf3hpZ3w8fCFLA56dUvB6DIfII
         +Ggjtv+OgDxoqCNWwIjnOYVDfWeiEbIfGSmIP93aUXDtV7DiAqJZss1se6aM1h9Us4
         WJzGAk1iOgOHIpLlUaMc0ptqDqWIpic5Y1Q6xKNc=
Date:   Mon, 19 Oct 2020 16:55:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net] net: dsa: reference count the host mdb addresses
Message-ID: <20201019165514.1fe7d8f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015212711.724678-1-vladimir.oltean@nxp.com>
References: <20201015212711.724678-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Oct 2020 00:27:11 +0300 Vladimir Oltean wrote:
> Currently any DSA switch that implements the multicast ops (properly,
> that is) gets these errors after just sitting for a while, with at least
> 2 ports bridged:
> 
> [  286.013814] mscc_felix 0000:00:00.5 swp3: failed (err=-2) to del object (id=3)
> 
> The reason has to do with this piece of code:
> 
> 	netdev_for_each_lower_dev(dev, lower_dev, iter)
> 		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);

We need a review on this one, anyone?
