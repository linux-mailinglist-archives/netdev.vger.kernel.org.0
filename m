Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4731CA000
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgEHBQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726495AbgEHBQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 21:16:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B021C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 18:16:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D58AB119376EF;
        Thu,  7 May 2020 18:16:52 -0700 (PDT)
Date:   Thu, 07 May 2020 18:16:51 -0700 (PDT)
Message-Id: <20200507.181651.1434873497888506640.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        kuba@kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: set correct vfs info for subflows
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a2fde8fb93863b0ffdeea94b5f44ba64b7601c5d.1588865446.git.pabeni@redhat.com>
References: <a2fde8fb93863b0ffdeea94b5f44ba64b7601c5d.1588865446.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 18:16:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu,  7 May 2020 18:53:24 +0200

> When a subflow is created via mptcp_subflow_create_socket(),
> a new 'struct socket' is allocated, with a new i_ino value.
> 
> When inspecting TCP sockets via the procfs and or the diag
> interface, the above ones are not related to the process owning
> the MPTCP master socket, even if they are a logical part of it
> ('ss -p' shows an empty process field)
> 
> Additionally, subflows created by the path manager get
> the uid/gid from the running workqueue.
> 
> Subflows are part of the owning MPTCP master socket, let's
> adjust the vfs info to reflect this.
> 
> After this patch, 'ss' correctly displays subflows as belonging
> to the msk socket creator.
> 
> Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied and queued up for -stable, thanks.
