Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77ED036FD6
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfFFJ3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:29:13 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46636 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbfFFJ3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 05:29:13 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYohm-0001wm-23; Thu, 06 Jun 2019 17:29:06 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYohb-000735-8z; Thu, 06 Jun 2019 17:28:55 +0800
Date:   Thu, 6 Jun 2019 17:28:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Boqun Feng <boqun.feng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Luc Maranget <luc.maranget@inria.fr>,
        Jade Alglave <j.alglave@ucl.ac.uk>
Subject: Re: rcu_read_lock lost its compiler barrier
Message-ID: <20190606092855.dfeuvyk5lbvm4zbf@gondor.apana.org.au>
References: <20190603200301.GM28207@linux.ibm.com>
 <Pine.LNX.4.44L0.1906041026570.1731-100000@iolanthe.rowland.org>
 <20190606045109.zjfxxbkzq4wb64bj@gondor.apana.org.au>
 <20190606060511.GA28207@linux.ibm.com>
 <20190606061438.nyzaeppdbqjt3jbp@gondor.apana.org.au>
 <20190606090619.GC28207@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606090619.GC28207@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 02:06:19AM -0700, Paul E. McKenney wrote:
>
> Or is your point instead that given the initial value of "a" being
> zero and the value stored to "a" being one, there is no way that
> any possible load and store tearing (your slicing and dicing) could
> possibly mess up the test of the value loaded from "a"?

Exactly.  If you can dream up of a scenario where the compiler can
get this wrong I'm all ears.

> > But I do concede that in the general RCU case you must have the
> > READ_ONCE/WRITE_ONCE calls for rcu_dereference/rcu_assign_pointer.
> 
> OK, good that we are in agreement on this part, at least!  ;-)

Well only because we're allowing crazy compilers that can turn
a simple word-aligned word assignment (a = b) into two stores.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
