Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2C215DB01
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387401AbgBNPcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:32:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53474 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729294AbgBNPcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:32:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED91015C4F145;
        Fri, 14 Feb 2020 07:32:20 -0800 (PST)
Date:   Fri, 14 Feb 2020 07:32:20 -0800 (PST)
Message-Id: <20200214.073220.1785477089100385948.davem@davemloft.net>
To:     w.dauchy@criteo.com
Cc:     netdev@vger.kernel.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH v5 net] net, ip6_tunnel: enhance tunnel locate with
 link check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200213171922.510172-1-w.dauchy@criteo.com>
References: <cf5ef569-1742-a22f-ec7d-f987287e12fb@6wind.com>
        <20200213171922.510172-1-w.dauchy@criteo.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Feb 2020 07:32:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Dauchy <w.dauchy@criteo.com>
Date: Thu, 13 Feb 2020 18:19:22 +0100

> With ipip, it is possible to create an extra interface explicitly
> attached to a given physical interface:
> 
>   # ip link show tunl0
>   4: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ipip 0.0.0.0 brd 0.0.0.0
>   # ip link add tunl1 type ipip dev eth0
>   # ip link show tunl1
>   6: tunl1@eth0: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ipip 0.0.0.0 brd 0.0.0.0
> 
> But it is not possible with ip6tnl:
> 
>   # ip link show ip6tnl0
>   5: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>       link/tunnel6 :: brd ::
>   # ip link add ip6tnl1 type ip6tnl dev eth0
>   RTNETLINK answers: File exists
> 
> This patch aims to make it possible by adding link comparaison in both
> tunnel locate and lookup functions; we also modify mtu calculation when
> attached to an interface with a lower mtu.
> 
> This permits to make use of x-netns communication by moving the newly
> created tunnel in a given netns.
> 
> Signed-off-by: William Dauchy <w.dauchy@criteo.com>

Applied, thank you.
