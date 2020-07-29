Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658E52316B7
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730585AbgG2AYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgG2AYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:24:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2805BC061794;
        Tue, 28 Jul 2020 17:24:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0C1E0128D35D5;
        Tue, 28 Jul 2020 17:08:03 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:24:47 -0700 (PDT)
Message-Id: <20200728.172447.1925120854282970312.davem@davemloft.net>
To:     xiyuyang19@fudan.edu.cn
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tanxin.ctf@gmail.com
Subject: Re: [PATCH] ipv6: Fix nexthop refcnt leak when creating ipv6 route
 info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595664139-40703-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1595664139-40703-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 17:08:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Date: Sat, 25 Jul 2020 16:02:18 +0800

> ip6_route_info_create() invokes nexthop_get(), which increases the
> refcount of the "nh".
> 
> When ip6_route_info_create() returns, local variable "nh" becomes
> invalid, so the refcount should be decreased to keep refcount balanced.
> 
> The reference counting issue happens in one exception handling path of
> ip6_route_info_create(). When nexthops can not be used with source
> routing, the function forgets to decrease the refcnt increased by
> nexthop_get(), causing a refcnt leak.
> 
> Fix this issue by pulling up the error source routing handling when
> nexthops can not be used with source routing.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

Applied and queued up for -stable, thanks.
