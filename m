Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7972B0909
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgKLPz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:55:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbgKLPz4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:55:56 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D46B320A8B;
        Thu, 12 Nov 2020 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605196556;
        bh=YwfO8X82PYFOArvFWdCfvsIrKdHLyCpq+wJrG3IMUYs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KcrRC7Y6J2/KgZpmVKTAcgxLHITDyOyAaxrR6iVIfg5NeDhwtM1RlKNbT9eU4yu/7
         o4PIRjza0DUYlVa7zc4tGFpHuj5kJCHh2Um1dlSsOdD9Eyc3SoowtFDx9MWmRbfTKZ
         nE5mrbQEYiW4Lu8ydHvSkuFcfZIXC6Fo2tba36ts=
Date:   Thu, 12 Nov 2020 07:55:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geliang Tang <geliangtang@gmail.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [MPTCP][PATCH v2 net-next] mptcp: fix static checker warnings
 in mptcp_pm_add_timer
Message-ID: <20201112075554.00739ede@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <078a2ef5bdc4e3b2c25ef852461692001f426495.1604976945.git.geliangtang@gmail.com>
References: <078a2ef5bdc4e3b2c25ef852461692001f426495.1604976945.git.geliangtang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 11:01:43 +0800 Geliang Tang wrote:
> Fix the following Smatch complaint:
> 
>      net/mptcp/pm_netlink.c:213 mptcp_pm_add_timer()
>      warn: variable dereferenced before check 'msk' (see line 208)
> 
>  net/mptcp/pm_netlink.c
>     207          struct mptcp_sock *msk = entry->sock;
>     208          struct sock *sk = (struct sock *)msk;
>     209          struct net *net = sock_net(sk);
>                                            ^^
>  "msk" dereferenced here.
> 
>     210
>     211          pr_debug("msk=%p", msk);
>     212
>     213          if (!msk)
>                     ^^^^
>  Too late.
> 
>     214                  return;
>     215
> 
> Fixes: 93f323b9cccc ("mptcp: add a new sysctl add_addr_timeout")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Applied, thanks!
