Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C731B52B0
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgDWCqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgDWCqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:46:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042D6C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 19:46:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 309C7127AFC06;
        Wed, 22 Apr 2020 19:46:48 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:46:47 -0700 (PDT)
Message-Id: <20200422.194647.2015117902662502050.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        kuba@kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: fix data_fin handing in RX path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <97c9e399060f81ed71ebfd446d9cf89bbb534142.1587572315.git.pabeni@redhat.com>
References: <97c9e399060f81ed71ebfd446d9cf89bbb534142.1587572315.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:46:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 22 Apr 2020 18:24:56 +0200

> The data fin flag is set only via a DSS option, but
> mptcp_incoming_options() copies it unconditionally from the
> provided RX options.
> 
> Since we do not clear all the mptcp sock RX options in a
> socket free/alloc cycle, we can end-up with a stray data_fin
> value while parsing e.g. MPC packets.
> 
> That would lead to mapping data corruption and will trigger
> a few WARN_ON() in the RX path.
> 
> Instead of adding a costly memset(), fetch the data_fin flag
> only for DSS packets - when we always explicitly initialize
> such bit at option parsing time.
> 
> Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied and queued up for v5.6 -stable, thanks.
