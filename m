Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DA02697D3
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgINVjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgINVjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:39:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35A2C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:39:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B6C412829758;
        Mon, 14 Sep 2020 14:22:30 -0700 (PDT)
Date:   Mon, 14 Sep 2020 14:39:16 -0700 (PDT)
Message-Id: <20200914.143916.822989187215700034.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mtosatti@redhat.com, edumazet@google.com
Subject: Re: [PATCH net-next v2] net: try to avoid unneeded backlog flush
From:   David Miller <davem@davemloft.net>
In-Reply-To: <07fa2be86a3b54d0cf0b771ca3c8b2ebbbca314f.1599758369.git.pabeni@redhat.com>
References: <07fa2be86a3b54d0cf0b771ca3c8b2ebbbca314f.1599758369.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 14:22:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 10 Sep 2020 23:33:18 +0200

> flush_all_backlogs() may cause deadlock on systems
> running processes with FIFO scheduling policy.
> 
> The above is critical in -RT scenarios, where user-space
> specifically ensure no network activity is scheduled on
> the CPU running the mentioned FIFO process, but still get
> stuck.
> 
> This commit tries to address the problem checking the
> backlog status on the remote CPUs before scheduling the
> flush operation. If the backlog is empty, we can skip it.
> 
> v1 -> v2:
>  - explicitly clear flushed cpu mask - Eric
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thank you.
