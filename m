Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECF121029D
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 05:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgGADuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 23:50:22 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35316 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgGADuW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 23:50:22 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jqTlG-0006Ov-BC; Wed, 01 Jul 2020 13:50:15 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 01 Jul 2020 13:50:14 +1000
Date:   Wed, 1 Jul 2020 13:50:14 +1000
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
Message-ID: <20200701035014.GA7384@gondor.apana.org.au>
References: <CANn89iLPqtJG0iESCHF+RcOjo95ukan1oSzjkPjoSJgKpO2wSQ@mail.gmail.com>
 <20200701020211.GA6875@gondor.apana.org.au>
 <CANn89iKP-evuLxeLo6p_98T+FuJ-J5YaMTRG230nqj3R=43tVA@mail.gmail.com>
 <20200701022241.GA7167@gondor.apana.org.au>
 <CANn89iLKZQAtpejcLHmOu3dsrGf5eyFfHc8JqoMNYisRPWQ8kQ@mail.gmail.com>
 <20200701025843.GA7254@gondor.apana.org.au>
 <CANn89iKnf6=RFd-XRjPv=qaU8P-LGCBcw6JU5Ywwb16gU2iQqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKnf6=RFd-XRjPv=qaU8P-LGCBcw6JU5Ywwb16gU2iQqQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 08:36:51PM -0700, Eric Dumazet wrote:
>
> If I knew so many people were excited about TCP / MD5, I would have
> posted all my patches on lkml ;)
> 
> Without the smp_wmb() we would still need something to prevent KMSAN
> from detecting that we read uninitialized bytes,
> if key->keylen is increased.  (initial content of key->key[] is garbage)
> 
> Something like this :

LGTM.  Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
