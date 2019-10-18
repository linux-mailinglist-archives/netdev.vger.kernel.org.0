Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33067DCC2A
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 19:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634409AbfJRRDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 13:03:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55000 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2634405AbfJRRDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 13:03:34 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30F5614A8CACB;
        Fri, 18 Oct 2019 10:03:33 -0700 (PDT)
Date:   Fri, 18 Oct 2019 13:03:32 -0400 (EDT)
Message-Id: <20191018.130332.850928941409040390.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Thomas.Bartschies@cvk.de
Subject: Re: [PATCH net] net: ensure correct skb->tstamp in various
 fragmenters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191017010056.58021-1-edumazet@google.com>
References: <20191017010056.58021-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 18 Oct 2019 10:03:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 16 Oct 2019 18:00:56 -0700

> Thomas found that some forwarded packets would be stuck
> in FQ packet scheduler because their skb->tstamp contained
> timestamps far in the future.
> 
> We thought we addressed this point in commit 8203e2d844d3
> ("net: clear skb->tstamp in forwarding paths") but there
> is still an issue when/if a packet needs to be fragmented.
> 
> In order to meet EDT requirements, we have to make sure all
> fragments get the original skb->tstamp.
> 
> Note that this original skb->tstamp should be zero in
> forwarding path, but might have a non zero value in
> output path if user decided so.
> 
> Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Thomas Bartschies <Thomas.Bartschies@cvk.de>

Applied and queued up for -stable, thanks Eric.
