Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541E41F5E9E
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 01:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgFJXKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 19:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgFJXKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 19:10:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADE0C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 16:10:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F30711F5F667;
        Wed, 10 Jun 2020 16:10:11 -0700 (PDT)
Date:   Wed, 10 Jun 2020 16:10:10 -0700 (PDT)
Message-Id: <20200610.161010.1999273694493899789.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: don't leak msk in token container
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f52cfae0ddacd91b37a804f19a6ffa2f79efe56f.1591778889.git.pabeni@redhat.com>
References: <f52cfae0ddacd91b37a804f19a6ffa2f79efe56f.1591778889.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jun 2020 16:10:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 10 Jun 2020 10:49:00 +0200

> If a listening MPTCP socket has unaccepted sockets at close
> time, the related msks are freed via mptcp_sock_destruct(),
> which in turn does not invoke the proto->destroy() method
> nor the mptcp_token_destroy() function.
> 
> Due to the above, the child msk socket is not removed from
> the token container, leading to later UaF.
> 
> Address the issue explicitly removing the token even in the
> above error path.
> 
> Fixes: 79c0949e9a09 ("mptcp: Add key generation and token tree")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Also applied and queued up for v5.6 -stable, thanks.
