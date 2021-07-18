Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37D83CC877
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 12:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhGRKuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 06:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231836AbhGRKuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 06:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 158B56100A;
        Sun, 18 Jul 2021 10:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626605231;
        bh=UK4GyKvDfMGN0HjWigqnE/GTzdduZA9HuEDZ3yQX1/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NBjoiK9W6M7W7DapoBXfo5EzDnNXce7pTNlTSKlFFED87herxsfuw7A43gkE0H1ck
         Ghegt54o5zMuxWF38OedFLvLn5UPfulIG5F7ol3g8zZHSXB0ACIbOy6+85PJkunZPT
         hrnTNxICCLufm3YmEoAA8RbK3lOh4aurCJgk6YxnrLHWotJCJUc1PLsIxGKwrqeU1Z
         7dTtuZMc2VF9jewWKwe64colsObZlGDqIhmAoiHuDDypi2VpaR7QqwTcpBHufFHwy0
         3yUlHUltzUK4W6gD3NMZN2yebVG8Ao3vdSlbkZbUj7IkHnzchsiN3F1a40DBaF/Uze
         oBs8X0sBe/YqQ==
Date:   Sun, 18 Jul 2021 13:47:08 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     "tanxin.ctf@gmail.com" <tanxin.ctf@gmail.com>,
        "xiyuyang19@fudan.edu.cn" <xiyuyang19@fudan.edu.cn>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kolga@netapp.com" <kolga@netapp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "yuanxzhang@fudan.edu.cn" <yuanxzhang@fudan.edu.cn>
Subject: Re: [PATCH] SUNRPC: Convert from atomic_t to refcount_t on
 rpc_clnt->cl_count
Message-ID: <YPQGrMEuZ2q4JhgW@unreal>
References: <1626517112-42831-1-git-send-email-xiyuyang19@fudan.edu.cn>
 <1f12b3569565fa8590b45cc2fbe7c176ca7c5184.camel@hammerspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f12b3569565fa8590b45cc2fbe7c176ca7c5184.camel@hammerspace.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 02:43:26PM +0000, Trond Myklebust wrote:
> On Sat, 2021-07-17 at 18:18 +0800, Xiyu Yang wrote:
> > refcount_t type and corresponding API can protect refcounters from
> > accidental underflow and overflow and further use-after-free
> > situations.
> > 
> 
> Have you tested this patch? As far as I remember, the reason why we
> never converted is that refcount_inc() gets upset and WARNs when you
> bump a zero refcount, like we do very much on purpose in
> rpc_free_auth(). Is that no longer the case?

It is still the case, they sent gazillion conversion patches with same
mistake.

Thanks

> 
> 
> -- 
> Trond Myklebust
> Linux NFS client maintainer, Hammerspace
> trond.myklebust@hammerspace.com
> 
> 
