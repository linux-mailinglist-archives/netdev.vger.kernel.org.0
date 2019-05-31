Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F27F31074
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfEaOqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:46:18 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49272 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfEaOqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 10:46:17 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hWinC-00076S-Un; Fri, 31 May 2019 22:46:02 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hWimz-0007Ah-Cd; Fri, 31 May 2019 22:45:49 +0800
Date:   Fri, 31 May 2019 22:45:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH] inet: frags: Remove unnecessary
 smp_store_release/READ_ONCE
Message-ID: <20190531144549.uiyht5hcy7lfgoge@gondor.apana.org.au>
References: <20190524160340.169521-12-edumazet@google.com>
 <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
 <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
 <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au>
 <CACT4Y+Y39u9VL+C27PVpfVZbNP_U8yFG35yLy6_KaxK2+Z9Gyw@mail.gmail.com>
 <20190529054759.qrw7h73g62mnbica@gondor.apana.org.au>
 <CACT4Y+ZuHhAwNZ31+W2Hth90qA9mDk7YmZFq49DmjXCUa_gF1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+ZuHhAwNZ31+W2Hth90qA9mDk7YmZFq49DmjXCUa_gF1g@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 10:24:08AM +0200, Dmitry Vyukov wrote:
>
> OK, let's call it barrier. But we need more than a barrier here then.

READ_ONCE/WRITE_ONCE is not some magical dust that you sprinkle
around in your code to make it work without locks.  You need to
understand exactly why you need them and why the code would be
buggy if you don't use them.

In this case the code doesn't need them because an implicit
barrier() (which is *stronger* than READ_ONCE/WRITE_ONCE) already
exists in both places.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
