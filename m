Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9685A968D
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 00:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbfIDWdZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Sep 2019 18:33:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38804 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfIDWdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 18:33:24 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 304AA1528601E;
        Wed,  4 Sep 2019 15:33:23 -0700 (PDT)
Date:   Wed, 04 Sep 2019 15:33:21 -0700 (PDT)
Message-Id: <20190904.153321.186858821162730720.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org, dsahern@gmail.com,
        lorenzo@google.com
Subject: Re: [PATCH v2] net-ipv6: fix excessive RTF_ADDRCONF flag on
 ::1/128 local route (and others)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190902162336.240405-1-zenczykowski@gmail.com>
References: <565e386f-e72a-73db-1f34-fedb5190658a@gmail.com>
        <20190902162336.240405-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Sep 2019 15:33:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Mon,  2 Sep 2019 09:23:36 -0700

> From: Maciej ¯enczykowski <maze@google.com>
> 
> There is a subtle change in behaviour introduced by:
>   commit c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
>   'ipv6: Change addrconf_f6i_alloc to use ip6_route_info_create'
> 
> Before that patch /proc/net/ipv6_route includes:
> 00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001 lo
> 
> Afterwards /proc/net/ipv6_route includes:
> 00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80240001 lo
> 
> ie. the above commit causes the ::1/128 local (automatic) route to be flagged with RTF_ADDRCONF (0x040000).
> 
> AFAICT, this is incorrect since these routes are *not* coming from RA's.
> 
> As such, this patch restores the old behaviour.
> 
> Fixes: c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43

Please format your Fixes: tag properly next time, I fixed it up for you.

> Cc: David Ahern <dsahern@gmail.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>

Applied and queued up for -stable.
