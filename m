Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7CA1F8F0F
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 09:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgFOHJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 03:09:54 -0400
Received: from verein.lst.de ([213.95.11.211]:59902 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728224AbgFOHJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 03:09:53 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5693568AFE; Mon, 15 Jun 2020 09:09:50 +0200 (CEST)
Date:   Mon, 15 Jun 2020 09:09:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Sagi Grimberg <sagi@lightbitslabs.com>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [v3 PATCH] iov_iter: Move unnecessary inclusion of
 crypto/hash.h
Message-ID: <20200615070950.GA21837@lst.de>
References: <20200611074332.GA12274@gondor.apana.org.au> <20200611114911.GA17594@gondor.apana.org.au> <20200612065737.GA17176@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612065737.GA17176@gondor.apana.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 04:57:37PM +1000, Herbert Xu wrote:
> The header file linux/uio.h includes crypto/hash.h which pulls in
> most of the Crypto API.  Since linux/uio.h is used throughout the
> kernel this means that every tiny bit of change to the Crypto API
> causes the entire kernel to get rebuilt.
> 
> This patch fixes this by moving it into lib/iov_iter.c instead
> where it is actually used.
> 
> This patch also fixes the ifdef to use CRYPTO_HASH instead of just
> CRYPTO which does not guarantee the existence of ahash.
> 
> Unfortunately a number of drivers were relying on linux/uio.h to
> provide access to linux/slab.h.  This patch adds inclusions of
> linux/slab.h as detected by build failures.
> 
> Also skbuff.h was relying on this to provide a declaration for
> ahash_request.  This patch adds a forward declaration instead.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
