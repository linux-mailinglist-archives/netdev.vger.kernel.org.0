Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24A822006F
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 00:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgGNWG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 18:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbgGNWG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 18:06:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B47C061755;
        Tue, 14 Jul 2020 15:06:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E311315E52DAD;
        Tue, 14 Jul 2020 15:06:26 -0700 (PDT)
Date:   Tue, 14 Jul 2020 15:06:26 -0700 (PDT)
Message-Id: <20200714.150626.477183558154470216.davem@davemloft.net>
To:     paolo.pisati@canonical.com
Cc:     kuba@kernel.org, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: fib_nexthop_multiprefix: fix cleanup()
 netns deletion
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714154055.68167-1-paolo.pisati@canonical.com>
References: <20200714154055.68167-1-paolo.pisati@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 15:06:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Pisati <paolo.pisati@canonical.com>
Date: Tue, 14 Jul 2020 17:40:55 +0200

> During setup():
> ...
>         for ns in h0 r1 h1 h2 h3
>         do
>                 create_ns ${ns}
>         done
> ...
> 
> while in cleanup():
> ...
>         for n in h1 r1 h2 h3 h4
>         do
>                 ip netns del ${n} 2>/dev/null
>         done
> ...
> 
> and after removing the stderr redirection in cleanup():
> 
> $ sudo ./fib_nexthop_multiprefix.sh
> ...
> TEST: IPv4: host 0 to host 3, mtu 1400                              [ OK ]
> TEST: IPv6: host 0 to host 3, mtu 1400                              [ OK ]
> Cannot remove namespace file "/run/netns/h4": No such file or directory
> $ echo $?
> 1
> 
> and a non-zero return code, make kselftests fail (even if the test
> itself is fine):
> 
> ...
> not ok 34 selftests: net: fib_nexthop_multiprefix.sh # exit=1
> ...
> 
> Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>

Applied, thank you.
