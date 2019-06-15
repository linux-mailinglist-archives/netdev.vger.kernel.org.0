Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67954721C
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfFOUle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:41:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39440 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfFOUld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:41:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FF5114EB9033;
        Sat, 15 Jun 2019 13:41:33 -0700 (PDT)
Date:   Sat, 15 Jun 2019 13:41:32 -0700 (PDT)
Message-Id: <20190615.134132.2175095878545554970.davem@davemloft.net>
To:     linus.walleij@linaro.org
Cc:     andrew@lunn.ch, vivien.didelot@savoirfairelinux.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: dsa: rtl8366: Fix up VLAN filtering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190613222520.19182-1-linus.walleij@linaro.org>
References: <20190613222520.19182-1-linus.walleij@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 15 Jun 2019 13:41:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 14 Jun 2019 00:25:20 +0200

> We get this regression when using RTL8366RB as part of a bridge
> with OpenWrt:
> 
> WARNING: CPU: 0 PID: 1347 at net/switchdev/switchdev.c:291
> 	 switchdev_port_attr_set_now+0x80/0xa4
> lan0: Commit of attribute (id=7) failed.
> (...)
> realtek-smi switch lan0: failed to initialize vlan filtering on this port
> 
> This is because it is trying to disable VLAN filtering
> on VLAN0, as we have forgot to add 1 to the port number
> to get the right VLAN in rtl8366_vlan_filtering(): when
> we initialize the VLAN we associate VLAN1 with port 0,
> VLAN2 with port 1 etc, so we need to add 1 to the port
> offset.
> 
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Applied and queued up for -stable.

Please never CC: stable for networking fixes, I handle the stable submissions
myself as per the networking FAQ.

Thank you.
