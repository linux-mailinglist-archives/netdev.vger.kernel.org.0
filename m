Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DBF1B5257
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgDWCTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgDWCTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:19:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EF8C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 19:19:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DADD7127A39DA;
        Wed, 22 Apr 2020 19:19:20 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:19:18 -0700 (PDT)
Message-Id: <20200422.191918.1966469083528111465.davem@davemloft.net>
To:     cambda@linux.alibaba.com
Cc:     netdev@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com, edumazet@google.com
Subject: Re: [PATCH net-next] net: Add TCP_FORCE_LINGER2 to TCP setsockopt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200421121737.3269-1-cambda@linux.alibaba.com>
References: <20200421121737.3269-1-cambda@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:19:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cambda Zhu <cambda@linux.alibaba.com>
Date: Tue, 21 Apr 2020 20:17:37 +0800

> This patch adds a new TCP socket option named TCP_FORCE_LINGER2. The
> option has same behavior as TCP_LINGER2, except the tp->linger2 value
> can be greater than sysctl_tcp_fin_timeout if the user_ns is capable
> with CAP_NET_ADMIN.
> 
> As a server, different sockets may need different FIN-WAIT timeout and
> in most cases the system default value will be used. The timeout can
> be adjusted by setting TCP_LINGER2 but cannot be greater than the
> system default value. If one socket needs a timeout greater than the
> default, we have to adjust the sysctl which affects all sockets using
> the system default value. And if we want to adjust it for just one
> socket and keep the original value for others, all the other sockets
> have to set TCP_LINGER2. But with TCP_FORCE_LINGER2, the net admin can
> set greater tp->linger2 than the default for one socket and keep
> the sysctl_tcp_fin_timeout unchanged.
> 
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>

Eric, please review.
