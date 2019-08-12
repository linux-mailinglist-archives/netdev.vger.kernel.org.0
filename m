Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9797B89651
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfHLEhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:37:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38722 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfHLEhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:37:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E40C014017D83;
        Sun, 11 Aug 2019 21:37:40 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:37:40 -0700 (PDT)
Message-Id: <20190811.213740.2137488837577705437.davem@davemloft.net>
To:     wens@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net: dsa: Check existence of .port_mdb_add
 callback before calling it
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190811141825.11566-1-wens@kernel.org>
References: <20190811141825.11566-1-wens@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:37:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen-Yu Tsai <wens@kernel.org>
Date: Sun, 11 Aug 2019 22:18:25 +0800

> From: Chen-Yu Tsai <wens@csie.org>
> 
> The dsa framework has optional .port_mdb_{prepare,add,del} callback fields
> for drivers to handle multicast database entries. When adding an entry, the
> framework goes through a prepare phase, then a commit phase. Drivers not
> providing these callbacks should be detected in the prepare phase.
> 
> DSA core may still bypass the bridge layer and call the dsa_port_mdb_add
> function directly with no prepare phase or no switchdev trans object,
> and the framework ends up calling an undefined .port_mdb_add callback.
> This results in a NULL pointer dereference, as shown in the log below.
> 
> The other functions seem to be properly guarded. Do the same for
> .port_mdb_add in dsa_switch_mdb_add_bitmap() as well.
 ...
> Fixes: e6db98db8a95 ("net: dsa: add switch mdb bitmap functions")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Applied and queued up for -stable, thanks.
