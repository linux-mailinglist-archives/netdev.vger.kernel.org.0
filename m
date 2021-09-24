Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B529417C49
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 22:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346171AbhIXUVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 16:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344583AbhIXUVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 16:21:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90F5160238;
        Fri, 24 Sep 2021 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632514806;
        bh=phrZa7dj+fsfjzbC7PK0r7mEdN1esyyuCvZdh/HvE+Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o6SrOM391jDnsjEr+ttm0JE8hIuMKjAtcVbc8r+f8/cUKQWKGejqThOnyFrQAi970
         GTYZHFTeeXUEflV9zmsMS0U+pjIWMPa2PCsSAcUY+EI28l57s7pGxtCjud/qlEURxJ
         4mXH5VnWr857hXiljSOI4wgTKT+7ZRcesJTNwUOaPf+F8x0n9E3t26E2KzBcpQrkg+
         LSVh7g5SDQ5/IgKeQK4StxpC69OyFCxZ2WUcbptJWisBUZ4IDnbs9rix4pr1mUDbaB
         cFTfaeDXH8SPhUFJEI3QUknZluF/ibp2crt2/e48nE0uaC2/m51KxGa0bm32HAE3u8
         lzZodMKApVVFw==
Date:   Fri, 24 Sep 2021 13:20:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luke Hsiao <luke.w.hsiao@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Luke Hsiao <lukehsiao@google.com>
Subject: Re: [PATCH net-next] tcp: tracking packets with CE marks in BW rate
 sample
Message-ID: <20210924132005.264e4e2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210923211706.2553282-1-luke.w.hsiao@gmail.com>
References: <20210923211706.2553282-1-luke.w.hsiao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Sep 2021 21:17:07 +0000 Luke Hsiao wrote:
> From: Yuchung Cheng <ycheng@google.com>
> 
> In order to track CE marks per rate sample (one round trip), TCP needs a
> per-skb header field to record the tp->delivered_ce count when the skb
> was sent. To make space, we replace the "last_in_flight" field which is
> used exclusively for NV congestion control. The stat needed by NV can be
> alternatively approximated by existing stats tcp_sock delivered and
> mss_cache.
> 
> This patch counts the number of packets delivered which have CE marks in
> the rate sample, using similar approach of delivery accounting.

Is this expected to be used from BPF CC? I don't see a user..
