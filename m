Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE004D5367
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 02:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbfJMAU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 20:20:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37602 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfJMAU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 20:20:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B73E71518AA41;
        Sat, 12 Oct 2019 17:20:55 -0700 (PDT)
Date:   Sat, 12 Oct 2019 17:20:55 -0700 (PDT)
Message-Id: <20191012.172055.1647651676286562151.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH 2/2] net: dsa: microchip: Add shared regmap mutex
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191010182508.22833-2-marex@denx.de>
References: <20191010182508.22833-1-marex@denx.de>
        <20191010182508.22833-2-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 12 Oct 2019 17:20:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Thu, 10 Oct 2019 20:25:08 +0200

> The KSZ driver uses one regmap per register width (8/16/32), each with
> it's own lock, but accessing the same set of registers. In theory, it
> is possible to create a race condition between these regmaps, although
> the underlying bus (SPI or I2C) locking should assure nothing bad will
> really happen and the accesses would be correct.
> 
> To make the driver do the right thing, add one single shared mutex for
> all the regmaps used by the driver instead. This assures that even if
> some future hardware is on a bus which does not serialize the accesses
> the same way SPI or I2C does, nothing bad will happen.
> 
> Note that the status_mutex was unused and only initied, hence it was
> renamed and repurposed as the regmap mutex.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Applied.
