Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F51249144
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHRW70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgHRW70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:59:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AF2C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:59:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BAC8A127E56E7;
        Tue, 18 Aug 2020 15:42:39 -0700 (PDT)
Date:   Tue, 18 Aug 2020 15:59:25 -0700 (PDT)
Message-Id: <20200818.155925.247746694282898053.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jmaloy@redhat.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net, dsahern@gmail.com,
        hideaki.yoshifuji@miraclelinux.com
Subject: Re: [PATCH net] ipv6: some fixes for ipv6_dev_find()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1e29a394c9ccb72126dbc3e9769a59c0234f8649.1597645849.git.lucien.xin@gmail.com>
References: <1e29a394c9ccb72126dbc3e9769a59c0234f8649.1597645849.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 15:42:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 17 Aug 2020 14:30:49 +0800

> This patch is to do 3 things for ipv6_dev_find():
> 
>   As David A. noticed,
> 
>   - rt6_lookup() is not really needed. Different from __ip_dev_find(),
>     ipv6_dev_find() doesn't have a compatibility problem, so remove it.
> 
>   As Hideaki suggested,
> 
>   - "valid" (non-tentative) check for the address is also needed.
>     ipv6_chk_addr() calls ipv6_chk_addr_and_flags(), which will
>     traverse the address hash list, but it's heavy to be called
>     inside ipv6_dev_find(). This patch is to reuse the code of
>     ipv6_chk_addr_and_flags() for ipv6_dev_find().
> 
>   - dev parameter is passed into ipv6_dev_find(), as link-local
>     addresses from user space has sin6_scope_id set and the dev
>     lookup needs it.
> 
> Fixes: 81f6cb31222d ("ipv6: add ipv6_dev_find()")
> Suggested-by: YOSHIFUJI Hideaki <hideaki.yoshifuji@miraclelinux.com>
> Reported-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thank you.
