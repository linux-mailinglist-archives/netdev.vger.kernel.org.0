Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640923DFB39
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 07:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbhHDFrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 01:47:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235012AbhHDFrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 01:47:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DBC260F35;
        Wed,  4 Aug 2021 05:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628056060;
        bh=1gdAXIFEnMmmgxkAapvaJqxB+Vq0F+z7XRSiH/DqABE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tz7FyKHQV1AMtEtC+epww0ohe2WtFEph3g6Spy1b5mz6khm47prW89VVSyRhfzjLx
         zLL8g7wB+u3lOBUwnFnlTvcwO5Rce31LNm7Y2FCf9m2ayBQ3OimThsKKAYjcd1UfGg
         ZbBF3shZ4a9z9/PD9t9KWy4ZX9tKc4Jh6lOawyhIY632toTDhbXharRkPINL7yN5K2
         W1Q1/fhbHhhWSUStVToCEn0GdJkSINuFzgKPs7aw/UxAYXYHbw3VHmM4HYTZ+YeW8f
         PQH8iwS1TCEc0ecbqa44NCMYCnN716BvnwG/qLR1ZvbSMx/sziwECBwy3c/6EACTb+
         fBmSksFmmzZ4Q==
Date:   Wed, 4 Aug 2021 08:47:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, kuba@kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, mptcp@lists.linux.dev,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-s390@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: Modify sock_set_keepalive() for more
 scenarios
Message-ID: <YQop+GhJcKICdwZ0@unreal>
References: <20210804032856.4005-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804032856.4005-1-yajun.deng@linux.dev>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 11:28:56AM +0800, Yajun Deng wrote:
> Add 2nd parameter in sock_set_keepalive(), let the caller decide
> whether to set. This can be applied to more scenarios.
> 
> v2:
>  - add the change in fs/dlm.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  fs/dlm/lowcomms.c     |  2 +-
>  include/net/sock.h    |  2 +-
>  net/core/filter.c     |  4 +---
>  net/core/sock.c       | 10 ++++------
>  net/mptcp/sockopt.c   |  4 +---
>  net/rds/tcp_listen.c  |  2 +-
>  net/smc/af_smc.c      |  2 +-
>  net/sunrpc/xprtsock.c |  2 +-
>  8 files changed, 11 insertions(+), 17 deletions(-)

1. Don't add changelogs in the commit messages and put them under --- marker.
2. Add an explanation to the commit message WHY this change is necessary
and HOW will it be used.
3. Drop all your double NOT in front of values (!!val) and rely on C
that casts int to bool naturally.

Thanks
