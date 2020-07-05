Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643C2214969
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 02:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgGEA5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 20:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgGEA5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 20:57:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52CDC061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 17:57:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1ED68157A9D98;
        Sat,  4 Jul 2020 17:57:25 -0700 (PDT)
Date:   Sat, 04 Jul 2020 17:57:24 -0700 (PDT)
Message-Id: <20200704.175724.1724928333689332249.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next 0/3] mptcp: add REUSEADDR/REUSEPORT/V6ONLY
 setsockopt support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200704233017.20831-1-fw@strlen.de>
References: <20200704233017.20831-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 04 Jul 2020 17:57:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Sun,  5 Jul 2020 01:30:14 +0200

> restarting an mptcp-patched sshd yields following error:
> 
>   sshd: error: Bind to port 22 on 0.0.0.0 failed: Address already in use.
>   sshd: error: setsockopt IPV6_V6ONLY: Operation not supported
>   sshd: error: Bind to port 22 on :: failed: Address already in use.
>   sshd: fatal: Cannot bind any address.
> 
> This series adds support for the needed setsockopts:
> 
> First patch skips the generic SOL_SOCKET handler for MPTCP:
> in mptcp case, the setsockopt needs to alter the tcp socket, not the mptcp
> parent socket.
> 
> Second patch adds minimal SOL_SOCKET support: REUSEPORT and REUSEADDR.
> Rest is still handled by the generic SOL_SOCKET code.
> 
> Last patch adds IPV6ONLY support.  This makes ipv6 work for openssh:
> It creates two listening sockets, before this patch, binding the ipv6
> socket will fail because the port is already bound by the ipv4 one.

Series applied, thanks Florian.
