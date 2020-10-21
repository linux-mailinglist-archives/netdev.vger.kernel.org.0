Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCEC29463E
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 03:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411035AbgJUBUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 21:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405040AbgJUBUN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 21:20:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A795922253;
        Wed, 21 Oct 2020 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603243213;
        bh=fz1w7NFMCYtkUS5K2lXAhqvcDP0rC/WBFTJUM8Cgnn8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vR78tVBktZeXIDLhYieC8Ou9d8ydr61lvalyoQg+4l0KspF/UihP60+V2gmutkLFU
         NfOd0UklFj1VYRV3gwP7CEHBiBLQwumwOD2Fr0vWuZ3HtTCNLFZrE1ErvgNrQoFXjR
         uUfVKgvwfjFrSO3YdiJDJmgUlj7nwDq0owK7BLLs=
Date:   Tue, 20 Oct 2020 18:20:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        netdev@vger.kernel.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: chelsio: inline_crypto: fix Kconfig and build
 errors
Message-ID: <20201020182010.39f11e21@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019181059.22634-1-rdunlap@infradead.org>
References: <20201019181059.22634-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 11:10:59 -0700 Randy Dunlap wrote:
> Fix build errors when TLS=m, TLS_TOE=y, and CRYPTO_DEV_CHELSIO_TLS=y.
> 
> Having (tristate) CRYPTO_DEV_CHELSIO_TLS depend on (bool) TLS_TOE
> is not strong enough to prevent the bad combination of TLS=m and
> CRYPTO_DEV_CHELSIO_TLS=y, so add a dependency on TLS to prevent the
> problematic kconfig combination.
> 
> Fixes these build errors:
> 
> hppa-linux-ld: drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.o: in function `chtls_free_uld':
>  drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c:165: undefined reference to `tls_toe_unregister_device'
> hppa-linux-ld: drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.o: in function `chtls_register_dev':
> drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c:204: undefined reference to `tls_toe_register_device'
> 
> Fixes: 44fd1c1fd821 ("chelsio/chtls: separate chelsio tls driver from crypto driver")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks Randy!

But I swapped the Fixes tag for:

Fixes: 53b4414a7003 ("net/tls: allow compiling TLS TOE out")
