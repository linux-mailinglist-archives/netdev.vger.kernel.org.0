Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F721F5E90
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 01:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgFJXGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 19:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgFJXGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 19:06:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C3CC03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 16:06:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97758120ED480;
        Wed, 10 Jun 2020 16:06:07 -0700 (PDT)
Date:   Wed, 10 Jun 2020 16:06:04 -0700 (PDT)
Message-Id: <20200610.160604.1148281043237238325.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net] mptcp: fix races between shutdown and recvmsg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <766c50ce4e7e0415adaf0c63e3f92e75abb8470c.1591778786.git.pabeni@redhat.com>
References: <766c50ce4e7e0415adaf0c63e3f92e75abb8470c.1591778786.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jun 2020 16:06:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed, 10 Jun 2020 10:47:41 +0200

> The msk sk_shutdown flag is set by a workqueue, possibly
> introducing some delay in user-space notification. If the last
> subflow carries some data with the fin packet, the user space
> can wake-up before RCV_SHUTDOWN is set. If it executes unblocking
> recvmsg(), it may return with an error instead of eof.
> 
> Address the issue explicitly checking for eof in recvmsg(), when
> no data is found.
> 
> Fixes: 59832e246515 ("mptcp: subflow: check parent mptcp socket on subflow state change")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks Paolo.
