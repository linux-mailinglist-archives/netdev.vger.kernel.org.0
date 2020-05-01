Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA161C206B
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgEAWM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAWM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:12:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83C8C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 15:12:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D9F314F0D691;
        Fri,  1 May 2020 15:12:28 -0700 (PDT)
Date:   Fri, 01 May 2020 15:12:27 -0700 (PDT)
Message-Id: <20200501.151227.588336197049608607.davem@davemloft.net>
To:     cambda@linux.alibaba.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        dust.li@linux.alibaba.com, tonylu@linux.alibaba.com
Subject: Re: [PATCH net-next v3] net: Replace the limit of TCP_LINGER2 with
 TCP_FIN_TIMEOUT_MAX
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424080616.85447-1-cambda@linux.alibaba.com>
References: <20200423073529.92152-1-cambda@linux.alibaba.com>
        <20200424080616.85447-1-cambda@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:12:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cambda Zhu <cambda@linux.alibaba.com>
Date: Fri, 24 Apr 2020 16:06:16 +0800

> This patch changes the behavior of TCP_LINGER2 about its limit. The
> sysctl_tcp_fin_timeout used to be the limit of TCP_LINGER2 but now it's
> only the default value. A new macro named TCP_FIN_TIMEOUT_MAX is added
> as the limit of TCP_LINGER2, which is 2 minutes.
> 
> Since TCP_LINGER2 used sysctl_tcp_fin_timeout as the default value
> and the limit in the past, the system administrator cannot set the
> default value for most of sockets and let some sockets have a greater
> timeout. It might be a mistake that let the sysctl to be the limit of
> the TCP_LINGER2. Maybe we can add a new sysctl to set the max of
> TCP_LINGER2, but FIN-WAIT-2 timeout is usually no need to be too long
> and 2 minutes are legal considering TCP specs.
> 
> Changes in v3:
> - Remove the new socket option and change the TCP_LINGER2 behavior so
>   that the timeout can be set to value between sysctl_tcp_fin_timeout
>   and 2 minutes.
> 
> Changes in v2:
> - Add int overflow check for the new socket option.
> 
> Changes in v1:
> - Add a new socket option to set timeout greater than
>   sysctl_tcp_fin_timeout.
> 
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>

Applied, thank you.
