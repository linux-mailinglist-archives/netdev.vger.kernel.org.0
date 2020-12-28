Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF572E6B84
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbgL1XMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 18:12:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46316 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730763AbgL1XLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 18:11:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 556C94CE686D4;
        Mon, 28 Dec 2020 15:11:03 -0800 (PST)
Date:   Mon, 28 Dec 2020 15:11:02 -0800 (PST)
Message-Id: <20201228.151102.1580596487777420764.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, khc@pm.waw.pl
Subject: Re: [PATCH net v2] net: hdlc_ppp: Fix issues when mod_timer is
 called while timer is running
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201228025339.3210-1-xie.he.0141@gmail.com>
References: <20201228025339.3210-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 28 Dec 2020 15:11:03 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Sun, 27 Dec 2020 18:53:39 -0800

> ppp_cp_event is called directly or indirectly by ppp_rx with "ppp->lock"
> held. It may call mod_timer to add a new timer. However, at the same time
> ppp_timer may be already running and waiting for "ppp->lock". In this
> case, there's no need for ppp_timer to continue running and it can just
> exit.
> 
> If we let ppp_timer continue running, it may call add_timer. This causes
> kernel panic because add_timer can't be called with a timer pending.
> This patch fixes this problem.
> 
> Fixes: e022c2f07ae5 ("WAN: new synchronous PPP implementation for generic HDLC.")
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied and queued up for -stable, thanks!
