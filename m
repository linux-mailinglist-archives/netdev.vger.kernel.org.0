Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2997C1CBDF5
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgEIFwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgEIFwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 01:52:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3C2821582;
        Sat,  9 May 2020 05:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589003535;
        bh=azb8IZTfZ9uwHqosxAmOOn3r7g+Q3Nto+qIHqy30Mw8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2jqzQtCzK92JUIKUEy346eZATjCw9y9sDyThE87uKCqffUNgoJSaWS7Xbb2cAPv3U
         67P0ps4rHhmG5AkB7/nI0DzBP3WorRvno4vC4t1u0UI6d1WzOrvUab9XF0b2Qu4cid
         xtqnGBxRAQxMvrDfh/SBzvkyY5jqmvTBsfbBJI08=
Date:   Fri, 8 May 2020 22:52:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipa: Remove ipa_endpoint_stop{,_rx_dma}
 again
Message-ID: <20200508225213.5e109221@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508194132.3412384-1-natechancellor@gmail.com>
References: <20200508194132.3412384-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 May 2020 12:41:33 -0700 Nathan Chancellor wrote:
> When building arm64 allyesconfig:
> 
> drivers/net/ipa/ipa_endpoint.c: In function 'ipa_endpoint_stop_rx_dma':
> drivers/net/ipa/ipa_endpoint.c:1274:13: error: 'IPA_ENDPOINT_STOP_RX_SIZE' undeclared (first use in this function)
> drivers/net/ipa/ipa_endpoint.c:1274:13: note: each undeclared identifier is reported only once for each function it appears in
> drivers/net/ipa/ipa_endpoint.c:1289:2: error: implicit declaration of function 'ipa_cmd_dma_task_32b_addr_add' [-Werror=implicit-function-declaration]
> drivers/net/ipa/ipa_endpoint.c:1291:45: error: 'ENDPOINT_STOP_DMA_TIMEOUT' undeclared (first use in this function)
> drivers/net/ipa/ipa_endpoint.c: In function 'ipa_endpoint_stop':
> drivers/net/ipa/ipa_endpoint.c:1309:16: error: 'IPA_ENDPOINT_STOP_RX_RETRIES' undeclared (first use in this function)
> 
> These functions were removed in a series, merged in as
> commit 33395f4a5c1b ("Merge branch 'net-ipa-kill-endpoint-stop-workaround'").
> 
> Remove them again so that the build works properly.
> 
> Fixes: 3793faad7b5b ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied, thank you!

I think I already said this, but would be great if IPA built on x86
with COMPILE_TEST..
