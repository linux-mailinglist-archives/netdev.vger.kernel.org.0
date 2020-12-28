Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36D22E6C1B
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbgL1Wzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729551AbgL1Vnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 16:43:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA3A4207CF;
        Mon, 28 Dec 2020 21:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609191791;
        bh=D6maiTwKwe+KyMWhVVQ91QXjBm22zHdiYU9GMU9+f/w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KxkN0QJ+PhVetLohjDEEwdyVabCkCpw6DjC+6jPji4sLv3k63y9X0O9qB48N+Wn09
         Id8pBiSyWPP8DEO0GJgEVeKbiBhB7oBa4bolrxouN8eJHJSXacakAyWkvkOjgF9NNi
         2pKrTnK+FtcF6L/pUstyKNLsj/S869HVFW897RzyVqmMyyDjchwGal9tHMUUj+NbWE
         gtxYvIYuWOFrlXIUhPhyM59QrIIa65nQaOjsN9P9CGQwRcAWOcSSyCHZ83llqUxPxu
         9Oq2jQo3+aNbQqBh+yvXXuLfa/+Acjev2pW8SXbe6uhlHm2aMeRO8LjjNNhNq8P3um
         Jqz53hpX0IJcQ==
Date:   Mon, 28 Dec 2020 13:43:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangyunjian <wangyunjian@huawei.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <willemdebruijn.kernel@gmail.com>
Cc:     <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <jerry.lilijun@huawei.com>, <chenchanghu@huawei.com>,
        <xudingke@huawei.com>, <brian.huangbin@huawei.com>
Subject: Re: [PATCH net v2] tun: fix return value when the number of iovs
 exceeds MAX_SKB_FRAGS
Message-ID: <20201228134309.1126941c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1608864736-24332-1-git-send-email-wangyunjian@huawei.com>
References: <1608864736-24332-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Dec 2020 10:52:16 +0800 wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Currently the tun_napi_alloc_frags() function returns -ENOMEM when the
> number of iovs exceeds MAX_SKB_FRAGS + 1. However this is inappropriate,
> we should use -EMSGSIZE instead of -ENOMEM.
> 
> The following distinctions are matters:
> 1. the caller need to drop the bad packet when -EMSGSIZE is returned,
>    which means meeting a persistent failure.
> 2. the caller can try again when -ENOMEM is returned, which means
>    meeting a transient failure.
> 
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> Acked-by: Willem de Bruijn <willemb@google.com>

Applied, thanks everyone!
