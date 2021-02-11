Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40D831952E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhBKVdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhBKVcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:32:54 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB2EC061574
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=k4LMDiF9zToEeTsBFXqCIXz8+q7GhOCjPaIYMIica7c=; b=WJETOcofr9gB661Vlqovx3BEnG
        A0zAVxwBLdoWvgrMiNOWRbGn5htst9IvQE/I9/ChiBRL+PkbaBIRdPo7VGYgWtQPVd73Z7Y1Y5R6C
        l3SwFrZiEwOOt9llEAvL3eFJw6Y6Q7zWL7YCTkIOa7CxQnbhMvMWntoA1j+p7lf9e97phUaxACDUA
        pY0VVAkGVt5xKOKKc/m46FLh1fddANYLiqCYvecV5BWXed/OgbDqj516rBhMCgLFlnkv2GJCtmxXT
        3D9pKFNCk+JZgarTl3BYa0oykbEL9KVNL5ONcHSp26CT17D0yqJYPWSc/je4EqUwd+HkyQkpbqECg
        u2tbZwcg==;
Received: from [2601:1c0:6280:3f0::cf3b]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lAJZJ-0000z0-Sb; Thu, 11 Feb 2021 21:32:10 +0000
Subject: Re: [PATCH v4 net-next 00/21] nvme-tcp receive offloads
To:     Boris Pismenny <borisp@mellanox.com>, dsahern@gmail.com,
        kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
References: <20210211211044.32701-1-borisp@mellanox.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <76c93e83-be63-f7ed-a096-1408e9525331@infradead.org>
Date:   Thu, 11 Feb 2021 13:32:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210211211044.32701-1-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 1:10 PM, Boris Pismenny wrote:
> Changes since v3:
> =========================================
> * Use DDP_TCP ifdefs in iov_iter and skb iterators to minimize impact
> when compiled out (Christoph)
> * Simplify netdev references and reduce the use of
> get_netdev_for_sock (Sagi)
> * Avoid "static" in it's own line, move it one line down (Christoph)
> * Pass (queue, skb, *offset) and retrieve the pdu_seq in
> nvme_tcp_resync_response (Sagi)
> * Add missing assignment of offloading_netdev to null in offload_limits
> error case (Sagi)
> * Set req->offloaded = false once -- the lifetime rules are:
> set to false on cmd_setup / set to true when ddp setup succeeds (Sagi)
> * Replace pr_info_ratelimited with dev_info_ratelimited (Sagi)
> * Add nvme_tcp_complete_request and invoke it from two similar call
> sites (Sagi)
> * Introduce nvme_tcp_req_map_sg earlier in the series (Sagi)
> * Add nvme_tcp_consume_skb and put into it a hunk from
> nvme_tcp_recv_data to handle copy with and without offload

Hi,
Did vger.kernel.org eat patch 21/21?

and does that patch contain the Documentation updates?

thanks.
-- 
~Randy

