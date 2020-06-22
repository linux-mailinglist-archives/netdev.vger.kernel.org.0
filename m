Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185102042D0
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 23:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730686AbgFVVok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 17:44:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727015AbgFVVok (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 17:44:40 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C58A22075A;
        Mon, 22 Jun 2020 21:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592862279;
        bh=/aLLjvO2Ei7tSkktHMp36wTpSxd9jKlcG+dbuAYiODw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sko3tfyKyexkmAphNm7aLC5lw5ejCsvu/y7x88Xvnmo6Bp8BXv6ZbOKzGjQGvMkYt
         s+nZta1H0FcRTgk2n+8elnBz7Tq72ZCL+Nr1fhkmbt0rG6gMAOKkgUStuNE9kolPKQ
         3av0CjWqVdgrbHbBj4bNzNgVEqdvTvGbfT5cO3u8=
Date:   Mon, 22 Jun 2020 14:44:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@marvell.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Yuval Mintz <yuval.mintz@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Ram Amrani" <ram.amrani@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 9/9] net: qed: fix "maybe uninitialized" warning
Message-ID: <20200622144437.770e09e0@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200622111413.7006-10-alobakin@marvell.com>
References: <20200622111413.7006-1-alobakin@marvell.com>
        <20200622111413.7006-10-alobakin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Jun 2020 14:14:13 +0300 Alexander Lobakin wrote:
> Variable 'abs_ppfid' in qed_dev.c:qed_llh_add_mac_filter() always gets
> printed, but is initialized only under 'ref_cnt == 1' condition. This
> results in:
> 
> In file included from ./include/linux/kernel.h:15:0,
>                  from ./include/asm-generic/bug.h:19,
>                  from ./arch/x86/include/asm/bug.h:86,
>                  from ./include/linux/bug.h:5,
>                  from ./include/linux/io.h:11,
>                  from drivers/net/ethernet/qlogic/qed/qed_dev.c:35:
> drivers/net/ethernet/qlogic/qed/qed_dev.c: In function 'qed_llh_add_mac_filter':
> ./include/linux/printk.h:358:2: warning: 'abs_ppfid' may be used uninitialized
> in this function [-Wmaybe-uninitialized]
>   printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
>   ^~~~~~
> drivers/net/ethernet/qlogic/qed/qed_dev.c:983:17: note: 'abs_ppfid' was declared
> here
>   u8 filter_idx, abs_ppfid;
>                  ^~~~~~~~~
> 
> ...under W=1+.
> 
> Fix this by initializing it with zero.
> 
> Fixes: 79284adeb99e ("qed: Add llh ppfid interface and 100g support for
> offload protocols")
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

Please don't wrap Fixes tags:

Fixes tag: Fixes: 79284adeb99e ("qed: Add llh ppfid interface and 100g support for
Has these problem(s):
	- Subject has leading but no trailing parentheses
	- Subject has leading but no trailing quotes
