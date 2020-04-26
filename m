Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872EF1B8BB2
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgDZDkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgDZDkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:40:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F94C061A0C
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 20:40:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D1BB159FD9E1;
        Sat, 25 Apr 2020 20:40:15 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:40:14 -0700 (PDT)
Message-Id: <20200425.204014.4915249663374846.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        dcaratti@redhat.com, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: fix race in msk status update
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4d5e3c09ca38a0a3ec951fa4f5bfc65d5cd40129.1587725562.git.pabeni@redhat.com>
References: <4d5e3c09ca38a0a3ec951fa4f5bfc65d5cd40129.1587725562.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:40:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 24 Apr 2020 13:15:21 +0200

> Currently subflow_finish_connect() changes unconditionally
> any msk socket status other than TCP_ESTABLISHED.
> 
> If an unblocking connect() races with close(), we can end-up
> triggering:
> 
> IPv4: Attempt to release TCP socket in state 1 00000000e32b8b7e
> 
> when the msk socket is disposed.
> 
> Be sure to enter the established status only from SYN_SENT.
> 
> Fixes: c3c123d16c0e ("net: mptcp: don't hang in mptcp_sendmsg() after TCP fallback")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks.
