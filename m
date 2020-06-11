Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B1E1F6E2D
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 21:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgFKTsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 15:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgFKTsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 15:48:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD607C08C5C1
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 12:48:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 532501286690A;
        Thu, 11 Jun 2020 12:48:35 -0700 (PDT)
Date:   Thu, 11 Jun 2020 12:48:34 -0700 (PDT)
Message-Id: <20200611.124834.181904714491590620.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net] tipc: fix NULL pointer dereference in tipc_disc_rcv()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200611100808.24244-1-tuong.t.lien@dektech.com.au>
References: <20200611100808.24244-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jun 2020 12:48:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Thu, 11 Jun 2020 17:08:08 +0700

> When a bearer is enabled, we create a 'tipc_discoverer' object to store
> the bearer related data along with a timer and a preformatted discovery
> message buffer for later probing... However, this is only carried after
> the bearer was set 'up', that left a race condition resulting in kernel
> panic.
> 
> It occurs when a discovery message from a peer node is received and
> processed in bottom half (since the bearer is 'up' already) just before
> the discoverer object is created but is now accessed in order to update
> the preformatted buffer (with a new trial address, ...) so leads to the
> NULL pointer dereference.
> 
> We solve the problem by simply moving the bearer 'up' setting to later,
> so make sure everything is ready prior to any message receiving.
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied, thanks.
