Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A727D324D4
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 22:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfFBUyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 16:54:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFBUyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 16:54:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D35961411E114;
        Sun,  2 Jun 2019 13:54:17 -0700 (PDT)
Date:   Sun, 02 Jun 2019 13:54:17 -0700 (PDT)
Message-Id: <20190602.135417.1658688470668746683.davem@davemloft.net>
To:     nikita.yoush@cogentembedded.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com, marek.behun@nic.cz,
        rmk+kernel@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cphealy@gmail.com
Subject: Re: [PATCH] net: dsa: mv88e6xxx: avoid error message on remove
 from VLAN 0
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
References: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Jun 2019 13:54:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Date: Fri, 31 May 2019 10:35:14 +0300

> When non-bridged, non-vlan'ed mv88e6xxx port is moving down, error
> message is logged:
> 
> failed to kill vid 0081/0 for device eth_cu_1000_4
> 
> This is caused by call from __vlan_vid_del() with vin set to zero, over
> call chain this results into _mv88e6xxx_port_vlan_del() called with
> vid=0, and mv88e6xxx_vtu_get() called from there returns -EINVAL.
> 
> On symmetric path moving port up, call goes through
> mv88e6xxx_port_vlan_prepare() that calls mv88e6xxx_port_check_hw_vlan()
> that returns -EOPNOTSUPP for zero vid.
> 
> This patch changes mv88e6xxx_vtu_get() to also return -EOPNOTSUPP for
> zero vid, then this error code is explicitly cleared in
> dsa_slave_vlan_rx_kill_vid() and error message is no longer logged.
> 
> Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

Applied.
