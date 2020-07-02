Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0246212B90
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 19:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgGBRuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 13:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgGBRuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 13:50:24 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94BD020737;
        Thu,  2 Jul 2020 17:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593712224;
        bh=gONodLYvSEBI/VzAFQ+qoexk3Hoaqs926kGYVFbfaAs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VRg2kfoDvSMpz8T8I1Y4Kz/0JTymw6S1ArHLqCNfOB+D8jka05iOV6NSdXFQmRgeD
         6Pn4a5wS13qlHgdpyoeS1QMCFlIP1blXzcTlWQpSEyI+hfee+SUdCvDsX40qmTVIEq
         d9ltZHdjUiRYKjCQmiKUdhbvtC9GHJcqvQZtsUk4=
Date:   Thu, 2 Jul 2020 10:50:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-wireless@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Denis Kenzior <denkenz@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-nfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/7] crypto: remove ARC4 support from the skcipher API
Message-ID: <20200702175022.GA2753@sol.localdomain>
References: <20200702101947.682-1-ardb@kernel.org>
 <20200702101947.682-5-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702101947.682-5-ardb@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+linux-wireless, Marcel Holtmann, and Denis Kenzior]

On Thu, Jul 02, 2020 at 12:19:44PM +0200, Ard Biesheuvel wrote:
> Remove the generic ecb(arc4) skcipher, which is slightly cumbersome from
> a maintenance perspective, since it does not quite behave like other
> skciphers do in terms of key vs IV lifetime. Since we are leaving the
> library interface in place, which is used by the various WEP and TKIP
> implementations we have in the tree, we can safely drop this code now
> it no longer has any users.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Last year there was a discussion where it was mentioned that iwd uses
"ecb(arc4)" via AF_ALG.  So can we really remove it yet?
See https://lkml.kernel.org/r/97BB95F6-4A4C-4984-9EAB-6069E19B4A4F@holtmann.org
Note that the code isn't in "iwd" itself but rather in "libell" which iwd
depends on: https://git.kernel.org/pub/scm/libs/ell/ell.git/

Apparently it also uses md4 and ecb(des) too.

Marcel and Denis, what's your deprecation plan for these obsolete and insecure
algorithms?

- Eric
