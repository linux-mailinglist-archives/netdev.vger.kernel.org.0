Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0AF101111
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 03:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfKSCA3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 18 Nov 2019 21:00:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52756 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfKSCA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 21:00:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0350D14047BBE;
        Mon, 18 Nov 2019 18:00:27 -0800 (PST)
Date:   Mon, 18 Nov 2019 18:00:27 -0800 (PST)
Message-Id: <20191118.180027.1114053540301054943.davem@davemloft.net>
To:     marek.behun@nic.cz
Cc:     netdev@vger.kernel.org, dmitry.torokhov@gmail.com, andrew@lunn.ch,
        andriy.shevchenko@linux.intel.com
Subject: Re: [PATCH net 1/1] mdio_bus: fix mdio_register_device when
 RESET_CONTROLLER is disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191118181505.32298-1-marek.behun@nic.cz>
References: <20191118181505.32298-1-marek.behun@nic.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 18:00:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>
Date: Mon, 18 Nov 2019 19:15:05 +0100

> When CONFIG_RESET_CONTROLLER is disabled, the
> devm_reset_control_get_exclusive function returns -ENOTSUPP. This is not
> handled in subsequent check and then the mdio device fails to probe.
> 
> When CONFIG_RESET_CONTROLLER is enabled, its code checks in OF for reset
> device, and since it is not present, returns -ENOENT. -ENOENT is handled.
> Add -ENOTSUPP also.
> 
> This happened to me when upgrading kernel on Turris Omnia. You either
> have to enable CONFIG_RESET_CONTROLLER or use this patch.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> Fixes: 71dd6c0dff51b ("net: phy: add support for reset-controller")

Applied and queued up for -stable.
