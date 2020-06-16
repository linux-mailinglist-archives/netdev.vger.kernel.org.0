Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD42F1FC023
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 22:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbgFPUjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 16:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbgFPUjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 16:39:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33D5C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 13:39:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C5FD128D494B;
        Tue, 16 Jun 2020 13:39:06 -0700 (PDT)
Date:   Tue, 16 Jun 2020 13:39:03 -0700 (PDT)
Message-Id: <20200616.133903.1424216259218078379.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        ncardwell@google.com, ycheng@google.com,
        venkat.x.venkatsubra@oracle.com
Subject: Re: [PATCH net] tcp: grow window for OOO packets only for SACK
 flows
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616033707.145423-1-edumazet@google.com>
References: <20200616033707.145423-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jun 2020 13:39:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 15 Jun 2020 20:37:07 -0700

> Back in 2013, we made a change that broke fast retransmit
> for non SACK flows.
> 
> Indeed, for these flows, a sender needs to receive three duplicate
> ACK before starting fast retransmit. Sending ACK with different
> receive window do not count.
> 
> Even if enabling SACK is strongly recommended these days,
> there still are some cases where it has to be disabled.
> 
> Not increasing the window seems better than having to
> rely on RTO.
> 
> After the fix, following packetdrill test gives :
 ...
> Fixes: 4e4f1fc22681 ("tcp: properly increase rcv_ssthresh for ofo packets")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>

Applied and queued up for -stable, thanks Eric.
