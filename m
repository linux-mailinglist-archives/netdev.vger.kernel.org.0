Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B73029D6FA
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731914AbgJ1WT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731765AbgJ1WRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C1742075E;
        Wed, 28 Oct 2020 00:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603845747;
        bh=ceOVLv+DLKtAkAr/A90oUkAov3JpX2pYzKeRxT/m8ko=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eTPpMYvG2llfrQYxCmb/givA+OlquuQWJp0/I8MOYuR5QgyH29Yk7EDoc9WibUkt8
         +bqV5Ppeu/oiCewNoJi+kf1hk3THnnly14/SBegOfx00qmwf4391slgvhCRuDb/9IZ
         kSD9/w3cyaIJl+GFCk8qUdgbMIGqvQ3TiLbeLJ28=
Date:   Tue, 27 Oct 2020 17:42:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Chas Williams <3chas3@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next 01/11] atm: horizon: shut up clang null pointer
 arithmetic warning
Message-ID: <20201027174226.4bd50144@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201026213040.3889546-1-arnd@kernel.org>
References: <20201026213040.3889546-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 22:29:48 +0100 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Building a "W=1" kernel with clang produces a warning about
> suspicous pointer arithmetic:
> 
> drivers/atm/horizon.c:1844:52: warning: performing pointer arithmetic
> on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>   for (mem = (HDW *) memmap; mem < (HDW *) (memmap + 1); ++mem)
> 
> The way that the addresses are handled is very obscure, and
> rewriting it to be more conventional seems fairly pointless, given
> that this driver probably has no users.
> Shut up this warning by adding a cast to uintptr_t.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Hi!

I'm not sure what your plan is for re-spinning but when you do could
you please split the wireless changes out? Also we never got patch 3
IDK if that's a coincidence or if it wasn't for networking...
