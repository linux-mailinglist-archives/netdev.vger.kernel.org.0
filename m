Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 991E290927
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 22:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbfHPUFa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Aug 2019 16:05:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39020 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfHPUFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 16:05:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 67DD213E99DE2;
        Fri, 16 Aug 2019 13:05:29 -0700 (PDT)
Date:   Fri, 16 Aug 2019 13:05:29 -0700 (PDT)
Message-Id: <20190816.130529.1610341946658634132.davem@davemloft.net>
To:     marek.behun@nic.cz
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: check for mode change
 in port_setup_mac
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190814144024.27975-1-marek.behun@nic.cz>
References: <20190814144024.27975-1-marek.behun@nic.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 16 Aug 2019 13:05:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>
Date: Wed, 14 Aug 2019 16:40:24 +0200

> The mv88e6xxx_port_setup_mac checks if the requested MAC settings are
> different from the current ones, and if not, does nothing (since chaning
> them requires putting the link down).
> 
> In this check it only looks if the triplet [link, speed, duplex] is
> being changed.
> 
> This patch adds support to also check if the mode parameter (of type
> phy_interface_t) is requested to be changed. The current mode is
> computed by the ->port_link_state() method, and if it is different from
> PHY_INTERFACE_MODE_NA, we check for equality with the requested mode.
> 
> In the implementations of the mv88e6250_port_link_state() method we set
> the current mode to PHY_INTERFACE_MODE_NA - so the code does not check
> for mode change on 6250.
> 
> In the mv88e6352_port_link_state() method, we use the cached cmode of
> the port to determine the mode as phy_interface_t (and if it is not
> enough, eg. for RGMII, we also look at the port control register for
> RX/TX timings).
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Applied.
