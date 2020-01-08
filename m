Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B79134DDC
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgAHUrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:47:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47676 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgAHUrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:47:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B18D81584C8C5;
        Wed,  8 Jan 2020 12:47:36 -0800 (PST)
Date:   Wed, 08 Jan 2020 12:47:36 -0800 (PST)
Message-Id: <20200108.124736.2090428155895325489.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com
Subject: Re: [PATCH net 0/2] When ungrafting from PRIO, replace child with
 FIFO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1578333529.git.petrm@mellanox.com>
References: <cover.1578333529.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 12:47:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Mon, 6 Jan 2020 18:01:53 +0000

> When a child Qdisc is removed from one of the PRIO Qdisc's bands, it is
> replaced unconditionally by a NOOP qdisc. As a result, any traffic hitting
> that band gets dropped. That is incorrect--no Qdisc was explicitly added
> when PRIO was created, and after removal, none should have to be added
> either.
> 
> In patch #2, this problem is fixed for PRIO by first attempting to create a
> default Qdisc and only falling back to noop when that fails. This pattern
> of attempting to create an invisible FIFO, using NOOP only as a fallback,
> is also seen in some other Qdiscs.
> 
> The only driver currently offloading PRIO (and thus presumably the only one
> impacted by this) is mlxsw. Therefore patch #1 extends mlxsw to handle the
> replacement by an invisible FIFO gracefully.

Series applied, and queued up for -stable, thanks!
