Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5480B2AE5F9
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732420AbgKKBpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:45:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731610AbgKKBpD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 20:45:03 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A125721D91;
        Wed, 11 Nov 2020 01:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605059103;
        bh=ic/a7OlP7uVxoz0DZlnF8Ku42k4DL7dFKQ5vFbygi4c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ItIBu3KedxgUi3HQVDq2fRjNtZkawaNHGlgAf53SwhyxoEE6HXOa/RxwyrzzKHdhH
         1wQkku5shQJFlvc9MjbI7FCR1xXCY2Kix90s+TciKjQG2r0xNYpur8w3SWRKK3wniU
         lQSstQx3kXgyPKqB0R5Nk4twvJO8masbKNKDBMW8=
Date:   Tue, 10 Nov 2020 17:45:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Mao Wenan <wenan.mao@linux.alibaba.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net v5] net: Update window_clamp if SOCK_RCVBUF is set
Message-ID: <20201110174501.703879e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iL6UW9mG6hW7f3Yv+32Pe_i9F-5cQhfo2uV68wdcgSuZA@mail.gmail.com>
References: <CANn89i+ABLMJTEKat=9=qujNwe0BFavphzqYc1CQGtrdkwUnXg@mail.gmail.com>
        <1604967391-123737-1-git-send-email-wenan.mao@linux.alibaba.com>
        <CANn89iL6UW9mG6hW7f3Yv+32Pe_i9F-5cQhfo2uV68wdcgSuZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 08:32:52 +0100 Eric Dumazet wrote:
> On Tue, Nov 10, 2020 at 1:16 AM Mao Wenan <wenan.mao@linux.alibaba.com> wrote:
> > When net.ipv4.tcp_syncookies=1 and syn flood is happened,
> > cookie_v4_check or cookie_v6_check tries to redo what
> > tcp_v4_send_synack or tcp_v6_send_synack did,
> > rsk_window_clamp will be changed if SOCK_RCVBUF is set,
> > which will make rcv_wscale is different, the client
> > still operates with initial window scale and can overshot
> > granted window, the client use the initial scale but local
> > server use new scale to advertise window value, and session
> > work abnormally.
> >
> > Fixes: e88c64f0a425 ("tcp: allow effective reduction of TCP's rcv-buffer via setsockopt")
> > Signed-off-by: Mao Wenan <wenan.mao@linux.alibaba.com>  
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks!
