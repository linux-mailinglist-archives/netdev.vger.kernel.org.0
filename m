Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051871E95BB
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgEaEyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgEaEyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:54:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF50CC05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:54:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26DA3128FE206;
        Sat, 30 May 2020 21:54:17 -0700 (PDT)
Date:   Sat, 30 May 2020 21:54:15 -0700 (PDT)
Message-Id: <20200530.215415.180552611360986513.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next] mptcp: fix NULL ptr dereference in MP_JOIN
 error path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1fc1fd4512e4709d1fbeb7f008f38b273ee1d798.1590767183.git.pabeni@redhat.com>
References: <1fc1fd4512e4709d1fbeb7f008f38b273ee1d798.1590767183.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 21:54:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 29 May 2020 17:49:18 +0200

> When token lookup on MP_JOIN 3rd ack fails, the server
> socket closes with a reset the incoming child. Such socket
> has the 'is_mptcp' flag set, but no msk socket associated
> - due to the failed lookup.
> 
> While crafting the reset packet mptcp_established_options_mp()
> will try to dereference the child's master socket, causing
> a NULL ptr dereference.
> 
> This change addresses the issue with explicit fallback to
> TCP in such error path.
> 
> Fixes: 729cd6436f35 ("mptcp: cope better with MP_JOIN failure")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thank you.
