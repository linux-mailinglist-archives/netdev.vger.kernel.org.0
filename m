Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A3A1AB600
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 04:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388952AbgDPCmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 22:42:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40008 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732153AbgDPCml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 22:42:41 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jOuTp-0002BK-4G; Thu, 16 Apr 2020 12:42:18 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Apr 2020 12:42:16 +1000
Date:   Thu, 16 Apr 2020 12:42:16 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     syzbot <syzbot+fc0674cde00b66844470@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: crypto: api - Fix use-after-free and race in crypto_spawn_alg
Message-ID: <20200416024216.GA18571@gondor.apana.org.au>
References: <0000000000002656a605a2a34356@google.com>
 <20200410060942.GA4048@gondor.apana.org.au>
 <20200416021703.GD816@sol.localdomain>
 <20200416022502.GA18386@gondor.apana.org.au>
 <20200416023001.GE816@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416023001.GE816@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 07:30:01PM -0700, Eric Biggers wrote:
> 
> I'm not sure what you mean here.  crypto_alg_get() is:
> 
> static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
> {
>         refcount_inc(&alg->cra_refcnt);
>         return alg;
> }
> 
> So given:
> 
> 	target = crypto_alg_get(alg);
> 
> Both alg and target have to be non-NULL.

Yes I know that we know that it can't be NULL, but gcc 8.3 doesn't.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
