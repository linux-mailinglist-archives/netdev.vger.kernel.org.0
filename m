Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3FE6EBFD8
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 15:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjDWN4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 09:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjDWN4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 09:56:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B9E198A;
        Sun, 23 Apr 2023 06:56:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95D4860DDB;
        Sun, 23 Apr 2023 13:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCD4C433EF;
        Sun, 23 Apr 2023 13:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682258197;
        bh=+JOYX8seu0t3f3lzP0Ox3sJafXdwgpF87v6VqrbMEnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o5nhFcF2mZookwOS14HR8l8yM08N5XA9nQ56SiQgT1YpdTZ3UiBuNtnISGhFhI9Q2
         MjV/DirZcRBNXKlF2sENhMgmyxmirfii90wKrbzjxM/E3DvcuQ7uX0E4uHL1uB86FY
         bb8KRI6s7aa/en1lChDczcNZWcGNClLPGpn74IYU=
Date:   Sun, 23 Apr 2023 15:56:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     stable@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        kuniyu@amazon.com, netdev@vger.kernel.org
Subject: Re: [PATCH 6.1 0/3] inet6: Backport complete patchset for
 inet6_destroy_sock() call modificatioin
Message-ID: <2023042318-chosen-epileptic-3b58@gregkh>
References: <cover.1681954729.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1681954729.git.william.xuanziyang@huawei.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 12:39:46PM +0800, Ziyang Xuan wrote:
> 6.1 LTS has backported commit ca43ccf41224 ("dccp/tcp: Avoid negative
> sk_forward_alloc by ipv6_pinfo.pktoptions.") and commit 62ec33b44e0f ("net:
> Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues()."),
> but these are incomplete. There are some patches that have not been
> backported including key pre-patch commit b5fc29233d28 ("inet6: Remove
> inet6_destroy_sock() in sk->sk_prot->destroy().").
> 
> Backport complete patchset for inet6_destroy_sock() call modificatioin.
> 
> Kuniyuki Iwashima (3):
>   inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().
>   dccp: Call inet6_destroy_sock() via sk->sk_destruct().
>   sctp: Call inet6_destroy_sock() via sk->sk_destruct().
> 
>  net/dccp/dccp.h      |  1 +
>  net/dccp/ipv6.c      | 15 ++++++++-------
>  net/dccp/proto.c     |  8 +++++++-
>  net/ipv6/af_inet6.c  |  1 +
>  net/ipv6/ping.c      |  6 ------
>  net/ipv6/raw.c       |  2 --
>  net/ipv6/tcp_ipv6.c  |  8 +-------
>  net/ipv6/udp.c       |  2 --
>  net/l2tp/l2tp_ip6.c  |  2 --
>  net/mptcp/protocol.c |  7 -------
>  net/sctp/socket.c    | 29 +++++++++++++++++++++--------
>  11 files changed, 39 insertions(+), 42 deletions(-)
> 
> -- 
> 2.25.1
> 

All now queued up, thanks.

greg k-h
