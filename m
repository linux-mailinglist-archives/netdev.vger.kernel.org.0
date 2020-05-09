Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C13B1CBDB0
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgEIFUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgEIFUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 01:20:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5A3920736;
        Sat,  9 May 2020 05:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589001621;
        bh=taWkGCnD8WwQuVwgjCX/fukm0lUXUhQsCvd9FCgEwbA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XfLGc1tLkUNjRq4GnxIEjTDtgi38IZHXz+rtq1q7cKwwOw2GuggL8yHGHhxVvejEg
         5mU+3JaWadA8F5KZEuugLuM4l8MgcKXeR2ouWmg2FJVUOraGivdmuQiAwtKAwXLmMV
         Ox/ydrPfwcXphKLSx0GcBb03DMGoQtP8WXp6GGac=
Date:   Fri, 8 May 2020 22:20:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] net/dst: use a smaller percpu_counter batch
 for dst entries accounting
Message-ID: <20200508222019.0f6319b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508015810.46023-1-edumazet@google.com>
References: <20200508015810.46023-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 May 2020 18:58:10 -0700 Eric Dumazet wrote:
> percpu_counter_add() uses a default batch size which is quite big
> on platforms with 256 cpus. (2*256 -> 512)
> 
> This means dst_entries_get_fast() can be off by +/- 2*(nr_cpus^2)
> (131072 on servers with 256 cpus)
> 
> Reduce the batch size to something more reasonable, and
> add logic to ip6_dst_gc() to call dst_entries_get_slow()
> before calling the _very_ expensive fib6_run_gc() function.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thank you!
