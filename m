Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD31351CB
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfFDVYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:24:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52596 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDVYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:24:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A9201500FF35;
        Tue,  4 Jun 2019 14:24:37 -0700 (PDT)
Date:   Tue, 04 Jun 2019 14:24:36 -0700 (PDT)
Message-Id: <20190604.142436.1951250822599766015.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org,
        syzbot+bad6e32808a3a97b1515@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] net: ipv4: fix rcu lockdep splat due to wrong
 annotation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190603204144.28320-1-fw@strlen.de>
References: <000000000000bec591058a6fd889@google.com>
        <20190603204144.28320-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 14:24:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Mon,  3 Jun 2019 22:41:44 +0200

> syzbot triggered following splat when strict netlink
> validation is enabled:
> 
> net/ipv4/devinet.c:1766 suspicious rcu_dereference_check() usage!
> 
> This occurs because we hold RTNL mutex, but no rcu read lock.
> The second call site holds both, so just switch to the _rtnl variant.
> 
> Reported-by: syzbot+bad6e32808a3a97b1515@syzkaller.appspotmail.com
> Fixes: 2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied.
