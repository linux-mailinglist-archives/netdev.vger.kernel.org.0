Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088812DCA27
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgLQAtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgLQAtT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 19:49:19 -0500
Date:   Wed, 16 Dec 2020 16:48:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608166119;
        bh=NLNYrstPfE0QbPFqmX/aq0W0aFwreKPMHKoYADup7O4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=TW6bxj7FeH+GBQc7l6QMpag7hNqnreKCz6JXMDRyWX6Iv82o0LSK1Yrp1qI031hPs
         bY0+t5W81WOc8RuIYMHIZTxU4vYSLMA1g+Ke+7qlOoizQWY2mGKCHVrDYNDPrMtjqB
         iYHu/B3jvqLDVIuIyRXwuAhm1dW1vrWgw3y9IRvzj6OubwNSeCzODL0ajDhJQiczxM
         ag0hHUm4iVZ+oppbwZNPTcDzINtgj9dJq4g81jb0JNXp3fFY4Pvd2NuxOMvcgbfllF
         6uY0jwWGRvyz/lHS8VvWE3jEGwGaLQz5TN00KnRDXI1wcsy+9p5w25+nvheE2s1Vn6
         iyP0aDd8nqMaw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gao Yan <gao.yanB@h3c.com>
Cc:     <paulus@samba.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: remove disc_data_lock in ppp line discipline
Message-ID: <20201216164838.55f939a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215150054.570-1-gao.yanB@h3c.com>
References: <20201215150054.570-1-gao.yanB@h3c.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 23:00:54 +0800 Gao Yan wrote:
> tty layer provide tty->ldisc_sem lock to protect tty->disc_data;
> For examlpe, when cpu A is running ppp_synctty_ioctl that
> hold the tty->ldisc_sem, so if cpu B calls ppp_synctty_close,
> it will wait until cpu A release tty->ldisc_sem. So I think it is
> unnecessary to have the disc_data_lock;
> 
> cpu A                           cpu B
> tty_ioctl                       tty_reopen
>  ->hold tty->ldisc_sem            ->hold tty->ldisc_sem(write), failed
>  ->ld->ops->ioctl                 ->wait...
>  ->release tty->ldisc_sem         ->wait...OK,hold tty->ldisc_sem
>                                     ->tty_ldisc_reinit
>                                       ->tty_ldisc_close
>                                         ->ld->ops->close  
> 
> Signed-off-by: Gao Yan <gao.yanB@h3c.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.11 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.11-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
