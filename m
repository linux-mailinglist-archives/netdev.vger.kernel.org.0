Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55959DB7A9
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437261AbfJQTjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:39:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41172 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730180AbfJQTjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:39:08 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDCDE140518C2;
        Thu, 17 Oct 2019 12:39:07 -0700 (PDT)
Date:   Thu, 17 Oct 2019 15:39:06 -0400 (EDT)
Message-Id: <20191017.153906.71740567018905735.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH net V3 2/2] net: dsa: microchip: Add shared regmap mutex
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191016133324.10451-2-marex@denx.de>
References: <20191016133324.10451-1-marex@denx.de>
        <20191016133324.10451-2-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 12:39:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Wed, 16 Oct 2019 15:33:24 +0200

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
 ...
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied.
