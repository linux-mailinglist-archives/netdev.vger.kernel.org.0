Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFFF6160838
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgBQCf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:35:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47816 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgBQCf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:35:26 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 259EA153808F4;
        Sun, 16 Feb 2020 18:35:25 -0800 (PST)
Date:   Sun, 16 Feb 2020 18:35:25 -0800 (PST)
Message-Id: <20200216.183525.67035879142775466.davem@davemloft.net>
To:     bpoirier@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        nicolas.dichtel@6wind.com, dsahern@gmail.com
Subject: Re: [PATCH net 1/2] ipv6: Fix route replacement with dev-only route
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
References: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 18:35:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Poirier <bpoirier@cumulusnetworks.com>
Date: Wed, 12 Feb 2020 10:41:06 +0900

> After commit 27596472473a ("ipv6: fix ECMP route replacement") it is no
> longer possible to replace an ECMP-able route by a non ECMP-able route.
> For example,
> 	ip route add 2001:db8::1/128 via fe80::1 dev dummy0
> 	ip route replace 2001:db8::1/128 dev dummy0
> does not work as expected.
> 
> Tweak the replacement logic so that point 3 in the log of the above commit
> becomes:
> 3. If the new route is not ECMP-able, and no matching non-ECMP-able route
> exists, replace matching ECMP-able route (if any) or add the new route.
> 
> We can now summarize the entire replace semantics to:
> When doing a replace, prefer replacing a matching route of the same
> "ECMP-able-ness" as the replace argument. If there is no such candidate,
> fallback to the first route found.
> 
> Fixes: 27596472473a ("ipv6: fix ECMP route replacement")
> Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>

Applied and queued up for -stable.
