Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB3B3121F25
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfLQAAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:00:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57482 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfLQAAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 19:00:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA7D3155695AB;
        Mon, 16 Dec 2019 16:00:42 -0800 (PST)
Date:   Mon, 16 Dec 2019 16:00:42 -0800 (PST)
Message-Id: <20191216.160042.1123553178502537234.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: check that Realtek PHY driver module
 is loaded
From:   David Miller <davem@davemloft.net>
In-Reply-To: <be869014-21a1-a2e3-5a9b-93ddb01200f5@gmail.com>
References: <be869014-21a1-a2e3-5a9b-93ddb01200f5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 16:00:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 13 Dec 2019 16:53:37 +0100

> Some users complained about problems with r8169 and it turned out that
> the generic PHY driver was used instead instead of the dedicated one.
> In all cases reason was that r8169.ko was in initramfs, but realtek.ko
> not. Manually adding realtek.ko to initramfs fixed the issues.
> Root cause seems to be that tools like dracut and genkernel don't
> consider softdeps. Add a check for loaded Realtek PHY driver module
> and provide the user with a hint if it's not loaded.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied but this really is a failure of the dependency system and tooling.

I don't know if tools like dracut is where this has to happen or
something closer to the kernel module dep system itself, but what's
happening right now obviously does not work.
