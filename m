Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB695765DA
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 14:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfGZMdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 08:33:00 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46436 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfGZMdA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 08:33:00 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hqzP8-0003pj-1X; Fri, 26 Jul 2019 22:32:58 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hqzP2-00029d-1a; Fri, 26 Jul 2019 22:32:52 +1000
Date:   Fri, 26 Jul 2019 22:32:51 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, smueller@chronox.de,
        steffen.klassert@secunet.com, dzickus@redhat.com
Subject: Re: [PATCH] crypto: user - make NETLINK_CRYPTO work inside netns
Message-ID: <20190726123251.GA8274@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709111124.31127-1-omosnace@redhat.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ondrej Mosnacek <omosnace@redhat.com> wrote:
> Currently, NETLINK_CRYPTO works only in the init network namespace. It
> doesn't make much sense to cut it out of the other network namespaces,
> so do the minor plumbing work necessary to make it work in any network
> namespace. Code inspired by net/core/sock_diag.c.
> 
> Tested using kcapi-dgst from libkcapi [1]:
> Before:
>    # unshare -n kcapi-dgst -c sha256 </dev/null | wc -c
>    libkcapi - Error: Netlink error: sendmsg failed
>    libkcapi - Error: Netlink error: sendmsg failed
>    libkcapi - Error: NETLINK_CRYPTO: cannot obtain cipher information for hmac(sha512) (is required crypto_user.c patch missing? see documentation)
>    0
> 
> After:
>    # unshare -n kcapi-dgst -c sha256 </dev/null | wc -c
>    32
> 
> [1] https://github.com/smuellerDD/libkcapi
> 
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
> crypto/crypto_user_base.c            | 37 +++++++++++++++++++---------
> crypto/crypto_user_stat.c            |  4 ++-
> include/crypto/internal/cryptouser.h |  2 --
> include/net/net_namespace.h          |  3 +++
> 4 files changed, 31 insertions(+), 15 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
