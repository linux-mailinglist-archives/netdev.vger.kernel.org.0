Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEC21B13CB
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgDTSAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgDTSAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:00:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93587C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:00:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 270441274A68E;
        Mon, 20 Apr 2020 11:00:39 -0700 (PDT)
Date:   Mon, 20 Apr 2020 11:00:38 -0700 (PDT)
Message-Id: <20200420.110038.1108481207729207065.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: enable internal pull-down
 for RX_DV/CRS_DV/RX_CTL and RX_ER
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200417195052.22537-1-olteanv@gmail.com>
References: <20200417195052.22537-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 11:00:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 17 Apr 2020 22:50:52 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Some boards do not have the RX_ER MII signal connected. Normally in such
> situation, those pins would be grounded, but then again, some boards
> left it electrically floating.
> 
> When sending traffic to those switch ports, one can see that the
> N_SOFERR statistics counter is incrementing once per each packet. The
> user manual states for this counter that it may count the number of
> frames "that have the MII error input being asserted prior to or
> up to the SOF delimiter byte". So the switch MAC is sampling an
> electrically floating signal, and preventing proper traffic reception
> because of that.
> 
> As a workaround, enable the internal weak pull-downs on the input pads
> for the MII control signals. This way, a floating signal would be
> internally tied to ground.
> 
> The logic levels of signals which _are_ externally driven should not be
> bothered by this 40-50 KOhm internal resistor. So it is not an issue to
> enable the internal pull-down unconditionally, irrespective of PHY
> interface type (MII, RMII, RGMII, SGMII) and of board layout.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks.
