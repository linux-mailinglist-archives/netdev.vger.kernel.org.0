Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30372AC9D2
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 01:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730839AbgKJAke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 19:40:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729454AbgKJAkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 19:40:33 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E738206D8;
        Tue, 10 Nov 2020 00:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604968833;
        bh=jmTx3DJMRcveLNZUk4PbliJncItS0hILMz0WGG7pkgU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wwkDIoq95V5OTOZI+OdPhmoxGHJEDSdKrhS3IBTLLMqljPqEZwiEkYrABm9Dsn4qj
         hEKwFxKKQ+/MZS2tyDi+6aOi6HSya7Gjl8OYsOPi4ciz/CQp5iwN/CNxFuQ55nS/5w
         iTinCHbuJx40zjeSgYGQhRGr2AgR3zKlnA5MBQhk=
Date:   Mon, 9 Nov 2020 16:40:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, davem@davemloft.net,
        ycheng@google.com, ncardwell@google.com, priyarjha@google.com,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, willemb@google.com,
        pabeni@redhat.com, Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH v2 net-next] net: udp: introduce UDP_MIB_MEMERRORS for
 udp_mem
Message-ID: <20201109164031.5f4fc0ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604627354-43207-1-git-send-email-dong.menglong@zte.com.cn>
References: <1604627354-43207-1-git-send-email-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Nov 2020 20:49:14 -0500 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> When udp_memory_allocated is at the limit, __udp_enqueue_schedule_skb
> will return a -ENOBUFS, and skb will be dropped in __udp_queue_rcv_skb
> without any counters being done. It's hard to find out what happened
> once this happen.
> 
> So we introduce a UDP_MIB_MEMERRORS to do this job. Well, this change
> looks friendly to the existing users, such as netstat:
> 
> $ netstat -u -s
> Udp:
>     0 packets received
>     639 packets to unknown port received.
>     158689 packet receive errors
>     180022 packets sent
>     RcvbufErrors: 20930
>     MemErrors: 137759
> UdpLite:
> IpExt:
>     InOctets: 257426235
>     OutOctets: 257460598
>     InNoECTPkts: 181177
> 
> v2:
> - Fix some alignment problems
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

Applied, thanks!
