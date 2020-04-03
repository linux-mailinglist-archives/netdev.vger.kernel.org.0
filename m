Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D226619CDF5
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 02:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390399AbgDCAzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 20:55:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53608 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390138AbgDCAzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 20:55:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 598D1127401B7;
        Thu,  2 Apr 2020 17:55:03 -0700 (PDT)
Date:   Thu, 02 Apr 2020 17:55:02 -0700 (PDT)
Message-Id: <20200402.175502.2304965794103611918.davem@davemloft.net>
To:     code@timstallard.me.uk
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net: icmp6: add icmp_errors_use_inbound_ifaddr
 sysctl for IPv6
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200331231706.14551-1-code@timstallard.me.uk>
References: <20200331231706.14551-1-code@timstallard.me.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 17:55:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tim Stallard <code@timstallard.me.uk>
Date: Wed,  1 Apr 2020 00:17:06 +0100

> In practice, this causes issues with IPv6 path MTU discovery in networks
> where unroutable linknets are used, and packets from these linknets are
> discarded by upstream providers' BCP38 filters, dropping all Packet
> Too Big errors. Traceroutes are also broken in this scenario.

But now traceroute6 is going to output confusing output by default
again in the scenerios described in the Fixes: commit.

Why don't we see if, explicitly, a source address was configured on
the route rather than us using a default saddr?  And in that case go
back to the old behavior.
