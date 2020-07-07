Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C111421788D
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 22:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgGGUEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 16:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgGGUEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 16:04:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E856C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 13:04:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B821E120F93E2;
        Tue,  7 Jul 2020 13:04:54 -0700 (PDT)
Date:   Tue, 07 Jul 2020 13:04:54 -0700 (PDT)
Message-Id: <20200707.130454.2028653793161446123.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, thomas.gambier@nexedi.com
Subject: Re: [PATCH net] ipv6: Fix use of anycast address with loopback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200707133924.24919-1-dsahern@kernel.org>
References: <20200707133924.24919-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 13:04:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Tue,  7 Jul 2020 07:39:24 -0600

> Thomas reported a regression with IPv6 and anycast using the following
> reproducer:
> 
>     echo 1 >  /proc/sys/net/ipv6/conf/all/forwarding
>     ip -6 a add fc12::1/16 dev lo
>     sleep 2
>     echo "pinging lo"
>     ping6 -c 2 fc12::
> 
> The conversion of addrconf_f6i_alloc to use ip6_route_info_create missed
> the use of fib6_is_reject which checks addresses added to the loopback
> interface and sets the REJECT flag as needed. Update fib6_is_reject for
> loopback checks to handle RTF_ANYCAST addresses.
> 
> Fixes: c7a1ce397ada ("ipv6: Change addrconf_f6i_alloc to use ip6_route_info_create")
> Reported-by: thomas.gambier@nexedi.com
> Signed-off-by: David Ahern <dsahern@kernel.org>

Applied, and queued up for -stable, thanks David.
