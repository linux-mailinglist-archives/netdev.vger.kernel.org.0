Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E53C56E57
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFZQIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:08:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37154 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZQIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:08:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB9CF14A8CC72;
        Wed, 26 Jun 2019 09:08:41 -0700 (PDT)
Date:   Wed, 26 Jun 2019 09:08:41 -0700 (PDT)
Message-Id: <20190626.090841.1832076350011087887.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, sbrivio@redhat.com,
        dsahern@gmail.com, syzkaller@googlegroups.com
Subject: Re: [PATCH net] ipv4: fix suspicious RCU usage in
 fib_dump_info_fnhe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190626100450.217106-1-edumazet@google.com>
References: <20190626100450.217106-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 09:08:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 26 Jun 2019 03:04:50 -0700

> sysbot reported that we lack appropriate rcu_read_lock()
> protection in fib_dump_info_fnhe()
> 
> net/ipv4/route.c:2875 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
 ...
> Fixes: ee28906fd7a1 ("ipv4: Dump route exceptions if requested")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Cc: David Ahern <dsahern@gmail.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied, we can adjust the 'err' initialization or whatever as a followup.
