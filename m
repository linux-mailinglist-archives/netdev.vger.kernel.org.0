Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553D3BC92F
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 15:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436669AbfIXNwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 09:52:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51772 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbfIXNwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 09:52:19 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A00AA152543A1;
        Tue, 24 Sep 2019 06:52:18 -0700 (PDT)
Date:   Tue, 24 Sep 2019 15:52:17 +0200 (CEST)
Message-Id: <20190924.155217.1833825682160899189.davem@davemloft.net>
To:     zaharov@selectel.ru
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] bonding/802.3ad: fix slave initialization states race
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190918130545.GA11133@yandex.ru>
References: <20190918130545.GA11133@yandex.ru>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Sep 2019 06:52:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksei Zakharov <zaharov@selectel.ru>
Date: Wed, 18 Sep 2019 16:05:45 +0300

> Once a while, one of 802.3ad slaves fails to initialize and hangs in
> BOND_LINK_FAIL state. Commit 334031219a84 ("bonding/802.3ad: fix slave
> link initialization transition states") checks slave->last_link_up. But
> link can still hang in weird state.
> After physical link comes up it sends first two LACPDU messages and
> doesn't work properly after that. It doesn't send or receive LACPDU.
> Once it happens, the only message in dmesg is:
> bond1: link status up again after 0 ms for interface eth2
> 
> This behavior can be reproduced (not every time):
> 1. Set slave link down
> 2. Wait for 1-3 seconds
> 3. Set slave link up
> 
> The fix is to check slave->link before setting it to BOND_LINK_FAIL or
> BOND_LINK_DOWN state. If got invalid Speed/Dupex values and link is in
> BOND_LINK_UP state, mark it as BOND_LINK_FAIL; otherwise mark it as
> BOND_LINK_DOWN.
> 
> Fixes: 334031219a84 ("bonding/802.3ad: fix slave link initialization
> transition states")

Please do not split Fixes: tags onto mutliple lines.

> Signed-off-by: Aleksei Zakharov <zakharov.a.g@yandex.ru>

Please work out the final way to fix this with Jay and repost.

Thank you.
