Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 036F918C67A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCTE3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:29:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46824 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgCTE3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:29:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6CFA615909F2F;
        Thu, 19 Mar 2020 21:29:51 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:29:50 -0700 (PDT)
Message-Id: <20200319.212950.742799321773945249.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix throughput drop during Tx backpressure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584639490-27208-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1584639490-27208-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 21:29:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Thu, 19 Mar 2020 23:08:09 +0530

> commit 7c3bebc3d868 ("cxgb4: request the TX CIDX updates to status page")
> reverted back to getting Tx CIDX updates via DMA, instead of interrupts,
> introduced by commit d429005fdf2c ("cxgb4/cxgb4vf: Add support for SGE
> doorbell queue timer")
> 
> However, it missed reverting back several code changes where Tx CIDX
> updates are not explicitly requested during backpressure when using
> interrupt mode. These missed changes cause slow recovery during
> backpressure because the corresponding interrupt no longer comes and
> hence results in Tx throughput drop.
> 
> So, revert back these missed code changes, as well, which will allow
> explicitly requesting Tx CIDX updates when backpressure happens.
> This enables the corresponding interrupt with Tx CIDX update message
> to get generated and hence speed up recovery and restore back
> throughput.
> 
> Fixes: 7c3bebc3d868 ("cxgb4: request the TX CIDX updates to status page")
> Fixes: d429005fdf2c ("cxgb4/cxgb4vf: Add support for SGE doorbell queue timer")
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied and queued up for -stable.
