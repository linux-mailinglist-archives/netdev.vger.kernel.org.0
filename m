Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E561D429B
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 03:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgEOBB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 21:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726170AbgEOBB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 21:01:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E6CC061A0C;
        Thu, 14 May 2020 18:01:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D33141288F375;
        Thu, 14 May 2020 18:01:25 -0700 (PDT)
Date:   Thu, 14 May 2020 18:01:25 -0700 (PDT)
Message-Id: <20200514.180125.970958854699328151.davem@davemloft.net>
To:     frextrite@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        kaber@trash.net, sfr@canb.auug.org.au, cai@lca.pw,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        joel@joelfernandes.org, madhuparnabhowmik10@gmail.com,
        paulmck@kernel.org
Subject: Re: [PATCH net v2 1/2] ipmr: Fix RCU list debugging warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514180102.26425-1-frextrite@gmail.com>
References: <20200514180102.26425-1-frextrite@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 18:01:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amol Grover <frextrite@gmail.com>
Date: Thu, 14 May 2020 23:31:02 +0530

> ipmr_for_each_table() macro uses list_for_each_entry_rcu()
> for traversing outside of an RCU read side critical section
> but under the protection of rtnl_mutex. Hence, add the
> corresponding lockdep expression to silence the following
> false-positive warning at boot:
> 
> [    4.319347] =============================
> [    4.319349] WARNING: suspicious RCU usage
> [    4.319351] 5.5.4-stable #17 Tainted: G            E
> [    4.319352] -----------------------------
> [    4.319354] net/ipv4/ipmr.c:1757 RCU-list traversed in non-reader section!!
> 
> Fixes: f0ad0860d01e ("ipv4: ipmr: support multiple tables")
> Signed-off-by: Amol Grover <frextrite@gmail.com>

Applied.
