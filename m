Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3723B22EB
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 00:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhFWWJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 18:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhFWWJm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 18:09:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DEDA613C9;
        Wed, 23 Jun 2021 22:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624486044;
        bh=GojLl4J/gGJOgHBEC7jj/+47pX2BhDyB5EjDiZ/4vls=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uEqERaF8ian3I1NH/wYYunmI/naFzAzXz5UTyazvqGZqkwgmJhGcnld60w+v4xxGb
         li637FUKwAsgUncpPXlQWxDRYuIb41MYeeUfhn4Q5rl2a/6aSQ776EJR1+R9Zoy3Wv
         kOyn6giu5rySkTw0HIriwnXnmTD1mBDx/R862Ys4eMsRNf9UkT8iElZwWYDkb8mgQT
         qq6fS15or6esf/OzYAgHm1tihIYHAz5v+WJroEZPfj5nBgTkgJVMbL2JrDVtw+6T7N
         TgUn+SNPGDNivUlQmQenVJDhgOynikAkfQaAhfwf3OPMMm71gmCixoWCAiERHsuEvm
         Zi9PVzCqWUNdA==
Date:   Wed, 23 Jun 2021 15:07:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>
Subject: Re: [PATCH net] ipv6: fix out-of-bound access in ip6_parse_tlv()
Message-ID: <20210623150723.489b7f6d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210623194353.2021745-1-eric.dumazet@gmail.com>
References: <20210623194353.2021745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Jun 2021 12:43:53 -0700 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> First problem is that optlen is fetched without checking
> there is more than one byte to parse.
> 
> Fix this by taking care of IPV6_TLV_PAD1 before
> fetching optlen (under appropriate sanity checks against len)
> 
> Second problem is that IPV6_TLV_PADN checks of zero
> padding are performed before the check of remaining length.
> 
> Fixes: c1412fce7ecc ("net/ipv6/exthdrs.c: Strict PadN option checking")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Tom Herbert <tom@herbertland.com>
> ---
> 
> Only compiled, I would appreciate a solid review of this patch before merging it, thanks !

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

for what that's worth
