Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98AF72101F0
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 04:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgGACWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 22:22:49 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35268 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgGACWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 22:22:48 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jqSOX-0005Pn-Rq; Wed, 01 Jul 2020 12:22:42 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 01 Jul 2020 12:22:41 +1000
Date:   Wed, 1 Jul 2020 12:22:41 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
Message-ID: <20200701022241.GA7167@gondor.apana.org.au>
References: <CANn89iLPqtJG0iESCHF+RcOjo95ukan1oSzjkPjoSJgKpO2wSQ@mail.gmail.com>
 <20200701020211.GA6875@gondor.apana.org.au>
 <CANn89iKP-evuLxeLo6p_98T+FuJ-J5YaMTRG230nqj3R=43tVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKP-evuLxeLo6p_98T+FuJ-J5YaMTRG230nqj3R=43tVA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 07:17:46PM -0700, Eric Dumazet wrote:
>
> The main issue of the prior code was the double read of key->keylen in
> tcp_md5_hash_key(), not that few bytes could change under us.
>
> I used smp_rmb() to ease backports, since old kernels had no
> READ_ONCE()/WRITE_ONCE(), but ACCESS_ONCE() instead.

If it's the double-read that you're protecting against, you should
just use barrier() and the comment should say so too.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
