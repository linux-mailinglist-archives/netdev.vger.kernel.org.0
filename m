Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36543EF30
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 05:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbfD3D3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 23:29:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35414 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730008AbfD3D3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 23:29:41 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 096F1133FCD58;
        Mon, 29 Apr 2019 20:29:40 -0700 (PDT)
Date:   Mon, 29 Apr 2019 23:29:39 -0400 (EDT)
Message-Id: <20190429.232939.432144633150614878.davem@davemloft.net>
To:     ssuryaextr@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net,v3] vrf: Use orig netdev to count Ip6InNoRoutes and
 a fresh route lookup when sending dest unreach
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190427131433.4082-1-ssuryaextr@gmail.com>
References: <20190427131433.4082-1-ssuryaextr@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Apr 2019 20:29:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>
Date: Sat, 27 Apr 2019 09:14:33 -0400

> When there is no route to an IPv6 dest addr, skb_dst(skb) points
> to loopback dev in the case of that the IP6CB(skb)->iif is
> enslaved to a vrf. This causes Ip6InNoRoutes to be incremented on the
> loopback dev. This also causes the lookup to fail on icmpv6_send() and
> the dest unreachable to not sent and Ip6OutNoRoutes gets incremented on
> the loopback dev.
 ...
> Fix this by counting on the original netdev and reset the skb dst to
> force a fresh lookup.
> 
> v2: Fix typo of destination address in the repro steps.
> v3: Simplify the loopback check (per David Ahern) and use reverse
>     Christmas tree format (per David Miller).
> 
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> Reviewed-by: David Ahern <dsahern@gmail.com>
> Tested-by: David Ahern <dsahern@gmail.com>

Applied, thanks.
