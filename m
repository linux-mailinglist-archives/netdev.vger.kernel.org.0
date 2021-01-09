Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2FD2EFD5C
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 04:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbhAIDRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 22:17:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbhAIDRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 22:17:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CB302399C;
        Sat,  9 Jan 2021 03:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610162203;
        bh=JktQALoNf5wtWzp6JI8N86X3dix51etwspzXbC0GKo8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nQHTBY2LqvE0TG97D1+CWWOvIj2l7iALMCsfdCZab3u8COei0P91mycrhEKWhQBWl
         uIosfIiUzoRgy3AqiLnY+ZjvrV9eo92n9dy4K7P+05Xbzw9rDEyZBuOE7WS9TlEtpM
         1r+b29WpyhUNbtbriTBahC6uNCUvBJTKx9dYQm5OZaOCLAg1VxpI9+YO6vnSxDyQxN
         3oPy4vlNSutZaHWfm8SxV5e6RGopATy7UGXGUikB0VvXMmrOJ392le1ARvfRlH3yeo
         qEj45Fa95+XV4vmf55C/U/ygjEmN0tyhq1eRPOybkvgH3VFK4mNUnrQaPggl0112eE
         fcQiO564CmHQw==
Date:   Fri, 8 Jan 2021 19:16:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Baptiste Lepers <baptiste.lepers@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] udp: Prevent reuseport_select_sock from reading
 uninitialized socks
Message-ID: <20210108191642.1963d3aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+FuTScp=7nrd5vmAwoAdL-moX37Kx38a-QjqoWh-k1xxyJwMg@mail.gmail.com>
References: <20210107051110.12247-1-baptiste.lepers@gmail.com>
        <CA+FuTScp=7nrd5vmAwoAdL-moX37Kx38a-QjqoWh-k1xxyJwMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 00:27:07 -0500 Willem de Bruijn wrote:
> On Thu, Jan 7, 2021 at 12:11 AM Baptiste Lepers
> <baptiste.lepers@gmail.com> wrote:
> >
> > reuse->socks[] is modified concurrently by reuseport_add_sock. To
> > prevent reading values that have not been fully initialized, only read
> > the array up until the last known safe index instead of incorrectly
> > re-reading the last index of the array.
> >
> > Fixes: acdcecc61285f ("udp: correct reuseport selection with connected
> > sockets")
> > Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>  
> 
> Acked-by: Willem de Bruijn <willemb@google.com>
> 
> Thanks. This also matches local variable socks as used to calculate i
> and j with reciprocal_scale immediately above.
> 
> Please mark fixes [PATCH net] in the future.

And please don't wrap the fixes tags.

Applied, thanks!
