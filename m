Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316AF44DB50
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 18:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhKKR5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 12:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhKKR5f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 12:57:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E1E861264;
        Thu, 11 Nov 2021 17:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636653285;
        bh=DUU8GP2n+HStKvETIJ/7AuTDQcxlcwedSQGVJMPuwuM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vNGc4spFYdim/6SVFMomtb8XVqxKbLzvPWSdfap6lywNHKv08GL3KCgadqN5zxMfx
         i3XQIZjbRCFDuUJBgkssQX4n3vESehvsP787DAiqfwGZBc2NMR6FOWkhJgcaEELjUF
         Thbrwk9YPNyYZiyyGigrulna2sB8zoLhfb7A1+LaAMlxMgdSyR1pcdJvcyaekWe/dW
         cL93i2Ptx1M4i+1sSgZ6PH61u5+7bnsyNsOpwFw+Ao7M6Bt3+gpoFy9WzJPLoUdrqt
         ekJY10+kehT2UictyH+2GqZ+e71K4UoaALvnlShyBFDhFiOsKB/JmpC5uuVxYXLjUG
         bn9IA0dZmuUUg==
Date:   Thu, 11 Nov 2021 09:54:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Marco Elver <elver@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] skbuff: suppress clang object-size-mismatch error
Message-ID: <20211111095444.461b900e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <931f1038-d7ab-f236-8052-c5e5b9753b18@linaro.org>
References: <20211111003519.1050494-1-tadeusz.struk@linaro.org>
        <CANpmjNNcVFmnBV-1Daauqk5ww8YRUVRtVs_SXVAPWG5CrFBVPg@mail.gmail.com>
        <c410f4a0-cc06-8ef8-3765-d99e29012acb@linaro.org>
        <CANpmjNNuWfauPoUxQ6BETrZ8JMjWgrAAhAEqEXW=5BNsfWfyDA@mail.gmail.com>
        <931f1038-d7ab-f236-8052-c5e5b9753b18@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 08:01:26 -0800 Tadeusz Struk wrote:
> > That general advice might not be compatible with what the kernel
> > wants, especially since UBSAN_OBJECT_SIZE is normally disabled and I
> > think known to cause these issues in the kernel.
> > 
> > I'll defer to maintainers to decide what would be the preferred way of
> > handling this.  
> 
> Sure, I would also like to know if there is a better way of fixing this.
> Thanks for your feedback.

I remember Dave was working thru the tree at some point to clean up all
skb->next/skb->prev accesses so that we can switch over to using normal
list helpers.

I'm not sure if that stalled due to lack of time or some fundamental
problems.

Seems like finishing that would let us clean up such misuses?
