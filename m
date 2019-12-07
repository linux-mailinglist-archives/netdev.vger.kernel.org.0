Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3AAE115E64
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 21:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfLGUGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 15:06:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42904 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfLGUGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 15:06:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2CACF15422F8E;
        Sat,  7 Dec 2019 12:06:29 -0800 (PST)
Date:   Sat, 07 Dec 2019 12:06:28 -0800 (PST)
Message-Id: <20191207.120628.389185869668594760.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, xiyou.wangcong@gmail.com,
        marcelo.leitner@gmail.com, jhs@mojatatu.com, jiri@resnulli.us
Subject: Re: [PATCH net v2] net_sched: validate TCA_KIND attribute in
 tc_chain_tmplt_add()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191207193445.135760-1-edumazet@google.com>
References: <20191207193445.135760-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 12:06:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat,  7 Dec 2019 11:34:45 -0800

> Use the new tcf_proto_check_kind() helper to make sure user
> provided value is well formed.
 ...
> Fixes: 6f96c3c6904c ("net_sched: fix backward compatibility for TCA_KIND")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable.

Oh how I love such long chains of stable backport requirements... ("gdc" is
"git describe --contains")

[davem@localhost net]$ gdc 6f96c3c6904c
v5.4-rc4~6^2~79
[davem@localhost net]$ git show 6f96c3c6904c | grep Fixes
    Fixes: 62794fc4fbf5 ("net_sched: add max len check for TCA_KIND")
[davem@localhost net]$ gdc 62794fc4fbf5
v5.4-rc1~14^2~68
[davem@localhost net]$ git show 62794fc4fbf5 | grep Fixes
    Fixes: 8b4c3cdd9dd8 ("net: sched: Add policy validation for tc attributes")
[davem@localhost net]$ gdc 8b4c3cdd9dd8
v4.19-rc7~7^2~2
[davem@localhost net]$ git show 8b4c3cdd9dd8 | grep Fixes
    The 2 Fixes tags below cover the latest additions. The other attributes
    Fixes: 5bc1701881e39 ("net: sched: introduce multichain support for filters")
    Fixes: d47a6b0e7c492 ("net: sched: introduce ingress/egress block index attributes for qdisc")
[davem@localhost net]$ gdc 5bc1701881e39
v4.13-rc1~157^2~434^2~2
[davem@localhost net]$ gdc d47a6b0e7c492
v4.16-rc1~123^2~139^2~5

I mean seriously, that is such a lovely chain of fixups for fixups... :-)

