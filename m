Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1444517ED8B
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgCJBCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:02:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34364 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbgCJBCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:02:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87AC215A016F3;
        Mon,  9 Mar 2020 18:02:52 -0700 (PDT)
Date:   Mon, 09 Mar 2020 18:02:52 -0700 (PDT)
Message-Id: <20200309.180252.1828445690226985016.davem@davemloft.net>
To:     maheshb@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, mahesh@bandewar.net
Subject: Re: [PATCH net] macvlan: add cond_resched() during multicast
 processing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309225707.65351-1-maheshb@google.com>
References: <20200309225707.65351-1-maheshb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 18:02:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>
Date: Mon,  9 Mar 2020 15:57:07 -0700

> The Rx bound multicast packets are deferred to a workqueue and
> macvlan can also suffer from the same attack that was discovered
> by Syzbot for IPvlan. This solution is not as effective as in
> IPvlan. IPvlan defers all (Tx and Rx) multicast packet processing
> to a workqueue while macvlan does this way only for the Rx. This
> fix should address the Rx codition to certain extent.
> 
> Tx is still suseptible. Tx multicast processing happens when
> .ndo_start_xmit is called, hence we cannot add cond_resched().
> However, it's not that severe since the user which is generating
>  / flooding will be affected the most.
> 
> Fixes: 412ca1550cbe ("macvlan: Move broadcasts into a work queue")
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>

Applied and queued up for -stable.
