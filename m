Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D908D11A2EA
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 04:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfLKDRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 22:17:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbfLKDRx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 22:17:53 -0500
Received: from paulmck-ThinkPad-P72.home (199-192-87-166.static.wiline.com [199.192.87.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C8DE20836;
        Wed, 11 Dec 2019 03:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576034272;
        bh=+YcxndZMyPJlutMO+HDeqVbIBmhcahLQYT/Qc077ev0=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=NPftQfmwQr+msZd7MLaHlkkmDDM9r3b1WcrArFX6G6DOWsqrNNZEFCykv5GR+SXS7
         Y0m8TIlBCSKbPRm9OCly8PYNNvRZzNK2aBhry6DU68nHtDL8JS1mPkZj2yJ+POz9lv
         3covE9eb0GMP7EeVETkjzcTFA+jc12RKE/0yHndc=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 8FDD4352276C; Tue, 10 Dec 2019 19:17:51 -0800 (PST)
Date:   Tue, 10 Dec 2019 19:17:51 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Tuong Lien Tong <tuong.t.lien@dektech.com.au>
Cc:     'Ying Xue' <ying.xue@windriver.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        tipc-discussion@lists.sourceforge.net, kernel-team@fb.com,
        torvalds@linux-foundation.org, davem@davemloft.net
Subject: Re: [tipc-discussion] [PATCH net/tipc] Replace rcu_swap_protected()
 with rcu_replace_pointer()
Message-ID: <20191211031751.GZ2889@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20191210033146.GA32522@paulmck-ThinkPad-P72>
 <0e565b68-ece1-5ae6-bb5d-710163fb8893@windriver.com>
 <20191210223825.GS2889@paulmck-ThinkPad-P72>
 <54112a30-de24-f6b2-b02e-05bc7d567c57@windriver.com>
 <707801d5afc6$cac68190$605384b0$@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <707801d5afc6$cac68190$605384b0$@dektech.com.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 09:00:39AM +0700, Tuong Lien Tong wrote:
> Hi Ying, Paul,
> 
> Please see my comments inline. Thanks!

Good catch!

> BR/Tuong
> 
> -----Original Message-----
> From: Ying Xue <ying.xue@windriver.com> 
> Sent: Wednesday, December 11, 2019 8:32 AM
> To: paulmck@kernel.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; mingo@kernel.org;
> tipc-discussion@lists.sourceforge.net; kernel-team@fb.com;
> torvalds@linux-foundation.org; davem@davemloft.net
> Subject: Re: [tipc-discussion] [PATCH net/tipc] Replace rcu_swap_protected()
> with rcu_replace_pointer()
> 
> On 12/11/19 6:38 AM, Paul E. McKenney wrote:
> > commit 4ee8e2c68b076867b7a5af82a38010fffcab611c
> > Author: Paul E. McKenney <paulmck@kernel.org>
> > Date:   Mon Dec 9 19:13:45 2019 -0800
> > 
> >     net/tipc: Replace rcu_swap_protected() with rcu_replace_pointer()
> >     
> >     This commit replaces the use of rcu_swap_protected() with the more
> >     intuitively appealing rcu_replace_pointer() as a step towards removing
> >     rcu_swap_protected().
> >     
> >     Link:
> https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4g
> g6Hw@mail.gmail.com/
> >     Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> >     Reported-by: kbuild test robot <lkp@intel.com>
> >     Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> >     Cc: Jon Maloy <jon.maloy@ericsson.com>
> >     Cc: Ying Xue <ying.xue@windriver.com>
> >     Cc: "David S. Miller" <davem@davemloft.net>
> >     Cc: <netdev@vger.kernel.org>
> >     Cc: <tipc-discussion@lists.sourceforge.net>
> 
> Acked-by: Ying Xue <ying.xue@windriver.com>

As in the following?  If so, I will be very happy to apply your Acked-by.

							Thanx, Paul

------------------------------------------------------------------------

commit 4c0855120704e7a578dc6862ae57babf6dc9bc77
Author: Paul E. McKenney <paulmck@kernel.org>
Date:   Mon Dec 9 19:13:45 2019 -0800

    net/tipc: Replace rcu_swap_protected() with rcu_replace_pointer()
    
    This commit replaces the use of rcu_swap_protected() with the more
    intuitively appealing rcu_replace_pointer() as a step towards removing
    rcu_swap_protected().
    
    Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
    Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
    Reported-by: kbuild test robot <lkp@intel.com>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
    [ paulmck: Updated based on Ying Xue and Tuong Lien Tong feedback. ]
    Cc: Jon Maloy <jon.maloy@ericsson.com>
    Cc: Ying Xue <ying.xue@windriver.com>
    Cc: "David S. Miller" <davem@davemloft.net>
    Cc: <netdev@vger.kernel.org>
    Cc: <tipc-discussion@lists.sourceforge.net>

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 990a872..39a13b4 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -258,7 +258,7 @@ static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
 	rcu_dereference_protected((rcu_ptr), lockdep_is_held(lock))
 
 #define tipc_aead_rcu_swap(rcu_ptr, ptr, lock)				\
-	rcu_swap_protected((rcu_ptr), (ptr), lockdep_is_held(lock))
+	rcu_replace_pointer((rcu_ptr), (ptr), lockdep_is_held(lock))
 
 #define tipc_aead_rcu_replace(rcu_ptr, ptr, lock)			\
 do {									\
@@ -1189,7 +1189,7 @@ static bool tipc_crypto_key_try_align(struct tipc_crypto *rx, u8 new_pending)
 
 	/* Move passive key if any */
 	if (key.passive) {
-		tipc_aead_rcu_swap(rx->aead[key.passive], tmp2, &rx->lock);
+		tmp2 = tipc_aead_rcu_swap(rx->aead[key.passive], tmp2, &rx->lock);
 		x = (key.passive - key.pending + new_pending) % KEY_MAX;
 		new_passive = (x <= 0) ? x + KEY_MAX : x;
 	}
