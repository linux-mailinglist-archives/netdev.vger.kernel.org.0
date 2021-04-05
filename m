Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3363544FD
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 18:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238412AbhDEQOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 12:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242504AbhDEQOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 12:14:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74E536138D;
        Mon,  5 Apr 2021 16:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617639256;
        bh=R3lfmNNYOFQ9z+6tp5Fqp8Kg7x5zx5E0lY4nIbRVVkM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v1kc2izNMdJlraXF5YFMf+DfwB188ybQCESOos2KIy070stvD5pu92TWHd5dCiB55
         Nn+crPq3biMnZ7WEFBwCjnc3uc3J4DddeLEWmDBZne+7z61I29/1+Je6eXLPzY464y
         SwtmWhuLJCCLJI7LhMats+66y096t1uhuMAf9vp0=
Date:   Mon, 5 Apr 2021 18:14:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jianmin Wang <jianmin@iscas.ac.cn>
Cc:     stable@vger.kernel.org, omosnace@redhat.com, davem@davemloft.net,
        dzickus@redhat.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        smueller@chronox.de, steffen.klassert@secunet.com
Subject: Re: [PATCH] backports: crypto user - make NETLINK_CRYPTO work inside
 netns
Message-ID: <YGs3Voq0codXCHbA@kroah.com>
References: <20190709111124.31127-1-omosnace@redhat.com>
 <20210405135515.50873-1-jianmin@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405135515.50873-1-jianmin@iscas.ac.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 01:55:15PM +0000, Jianmin Wang wrote:
> There is same problem found in linux 4.19.y as upstream commit. The 
> changes of crypto_user_* and cryptouser.h files from upstream patch are merged into 
> crypto/crypto_user.c for backporting.
> 
> Upstream commit:
>     commit 91b05a7e7d8033a90a64f5fc0e3808db423e420a
>     Author: Ondrej Mosnacek <omosnace@redhat.com>
>     Date:   Tue,  9 Jul 2019 13:11:24 +0200
> 
>     Currently, NETLINK_CRYPTO works only in the init network namespace. It
>     doesn't make much sense to cut it out of the other network namespaces,
>     so do the minor plumbing work necessary to make it work in any network
>     namespace. Code inspired by net/core/sock_diag.c.
> 
>     Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
>     Signed-off-by: default avatarHerbert Xu <herbert@gondor.apana.org.au>
> 
> Signed-off-by: Jianmin Wang <jianmin@iscas.ac.cn>
> ---
>  crypto/crypto_user.c        | 37 +++++++++++++++++++++++++------------
>  include/net/net_namespace.h |  3 +++
>  2 files changed, 28 insertions(+), 12 deletions(-)

How does this change fit with the stable kernel rules?  It looks to be a
new feature, if you need this, why not just use a newer kernel version?
What is preventing you from doing that?

thanks,

greg k-h
