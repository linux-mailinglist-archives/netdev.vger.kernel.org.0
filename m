Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA5E115816
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 21:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfLFUCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 15:02:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60128 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfLFUCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 15:02:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B234151211EA;
        Fri,  6 Dec 2019 12:02:21 -0800 (PST)
Date:   Fri, 06 Dec 2019 12:02:21 -0800 (PST)
Message-Id: <20191206.120221.133623350556751803.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] tipc: fix ordering of tipc module init and exit
 routine
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191206052548.14693-1-ap420073@gmail.com>
References: <20191206052548.14693-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 12:02:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Fri,  6 Dec 2019 05:25:48 +0000

> In order to set/get/dump, the tipc uses the generic netlink
> infrastructure. So, when tipc module is inserted, init function
> calls genl_register_family().
> After genl_register_family(), set/get/dump commands are immediately
> allowed and these callbacks internally use the net_generic.
> net_generic is allocated by register_pernet_device() but this
> is called after genl_register_family() in the __init function.
> So, these callbacks would use un-initialized net_generic.
> 
> Test commands:
 ...
> Splat looks like:
 ...
> Fixes: 7e4369057806 ("tipc: fix a slab object leak")
> Fixes: a62fbccecd62 ("tipc: make subscriber server support net namespace")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable.
