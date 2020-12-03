Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED552CE056
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgLCVKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:10:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37274 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLCVKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 16:10:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkvrB-00A6kM-5K; Thu, 03 Dec 2020 22:09:41 +0100
Date:   Thu, 3 Dec 2020 22:09:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201203210941.GJ2333853@lunn.ch>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201203162428.ffdj7gdyudndphmn@skbuf>
 <87a6uu7gsr.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6uu7gsr.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> One could argue that if Linus had received an error instead, adapted his
> teamd config and tried again, he would be a happier user and we might
> not have to compete with his OS.
> 
> I am not sure which way is the correct one, but I do not think that it
> necessarily _always_ correct to silently fallback to a non-offloaded
> mode.

This is an argument Mellanox makes, where falling back to software
would be a bad idea given the huge bandwidth of their hardware
accelerator, and the slow bandwidth of their CPU.

If the switch has no hardware support for LAG at all, then falling
back to software is reasonable. It is less clear when there is some
support in the switch. If we do reject it, we should try to make use
of extack to give the user a useful error messages: Not supported, try
configuration XYZ. But i guess that needs some plumbing, getting
extack available in the place we make the decision.

	Andrew
