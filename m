Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B50A1F0CF4
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 18:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgFGQ1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 12:27:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38750 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbgFGQ1m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 12:27:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uwaql4O17QvEqQO+cQA0wrTlh19QNuCc70lVhi13b/4=; b=hhWz1HIkD9X7dwPKMJdPEoaL38
        AQC+ZbyVr2abmGhQIIV/IiO4i3M85XS5zNq+kqkXDfzdH5SFdumYzzJ7szBR8Ot5WfQd3YjUivRbO
        c5W0Q1MuPYl3AEI8eH8kYo+WVGreCHclgh6x0gd0BpKXggSdb7xPdF4nHKF1b3HwC2i4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jhy8q-004Lbn-JB; Sun, 07 Jun 2020 18:27:24 +0200
Date:   Sun, 7 Jun 2020 18:27:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Amit Cohen <amitc@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        corbet@lwn.net, jiri@mellanox.com, idosch@mellanox.com,
        shuah@kernel.org, mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, f.fainelli@gmail.com,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH net-next 04/10] ethtool: Add link extended state
Message-ID: <20200607162724.GF1022955@lunn.ch>
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-5-amitc@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607145945.30559-5-amitc@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 07, 2020 at 05:59:39PM +0300, Amit Cohen wrote:
> Currently, drivers can only tell whether the link is up/down using
> LINKSTATE_GET, but no additional information is given.
> 
> Add attributes to LINKSTATE_GET command in order to allow drivers
> to expose the user more information in addition to link state to ease
> the debug process, for example, reason for link down state.
> 
> Extended state consists of two attributes - ext_state and ext_substate.
> The idea is to avoid 'vendor specific' states in order to prevent
> drivers to use specific ext_state that can be in the future common
> ext_state.
> 
> The substates allows drivers to add more information to the common
> ext_state. For example, vendor can expose 'Autoneg failure' as
> ext_state and add 'No partner detected during force mode' as
> ext_substate.
> 
> If a driver cannot pinpoint the extended state with the substate
> accuracy, it is free to expose only the extended state and omit the
> substate attribute.

Maybe it is hiding somewhere, but shoudn't there be a check to see if
the interface is administratively up? I don't think the information
returned here makes much sense if the interface is configured down.

	 Andrew
