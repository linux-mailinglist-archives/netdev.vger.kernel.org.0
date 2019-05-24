Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC9E29FF3
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732067AbfEXUfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:35:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42874 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfEXUfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:35:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BC01F14E2D90D;
        Fri, 24 May 2019 13:35:11 -0700 (PDT)
Date:   Fri, 24 May 2019 13:35:11 -0700 (PDT)
Message-Id: <20190524.133511.953468514937709206.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, willemb@google.com
Subject: Re: [PATCH net-next v2] selftests/net: SO_TXTIME with ETF and FQ
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190523174846.84394-1-willemdebruijn.kernel@gmail.com>
References: <20190523174846.84394-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 May 2019 13:35:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Thu, 23 May 2019 13:48:46 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> The SO_TXTIME API enables packet tranmission with delayed delivery.
> This is currently supported by the ETF and FQ packet schedulers.
> 
> Evaluate the interface with both schedulers. Install the scheduler
> and send a variety of packets streams: without delay, with one
> delayed packet, with multiple ordered delays and with reordering.
> Verify that packets are released by the scheduler in expected order.
> 
> The ETF qdisc requires a timestamp in the future on every packet. It
> needs a delay on the qdisc else the packet is dropped on dequeue for
> having a delivery time in the past. The test value is experimentally
> derived. ETF requires clock_id CLOCK_TAI. It checks this base and
> drops for non-conformance.
> 
> The FQ qdisc expects clock_id CLOCK_MONOTONIC, the base used by TCP
> as of commit fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC").
> Within a flow there is an expecation of ordered delivery, as shown by
> delivery times of test 4. The FQ qdisc does not require all packets to
> have timestamps and does not drop for non-conformance.
> 
> The large (msec) delays are chosen to avoid flakiness.
 ...
> Changes v1->v2: update commit message output
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Willem.
