Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A97210A4C
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 17:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEAPza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 11:55:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35084 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfEAPz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 11:55:29 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 77A101473ED34;
        Wed,  1 May 2019 08:55:28 -0700 (PDT)
Date:   Wed, 01 May 2019 11:55:27 -0400 (EDT)
Message-Id: <20190501.115527.2091350297046816201.davem@davemloft.net>
To:     ycheng@google.com
Cc:     edumazet@google.com, netdev@vger.kernel.org, ncardwell@google.com,
        soheil@google.com
Subject: Re: [PATCH net-next 0/8] undo congestion window on spurious SYN or
 SYNACK timeout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190429224620.151064-1-ycheng@google.com>
References: <20190429224620.151064-1-ycheng@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 08:55:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>
Date: Mon, 29 Apr 2019 15:46:12 -0700

> Linux TCP currently uses the initial congestion window of 1 packet
> if multiple SYN or SYNACK timeouts per RFC6298. However such
> timeouts are often spurious on wireless or cellular networks that
> experience high delay variances (e.g. ramping up dormant radios or
> local link retransmission). Another case is when the underlying
> path is longer than the default SYN timeout (e.g. 1 second). In
> these cases starting the transfer with a minimal congestion window
> is detrimental to the performance for short flows.
> 
> One naive approach is to simply ignore SYN or SYNACK timeouts and
> always use a larger or default initial window. This approach however
> risks pouring gas to the fire when the network is already highly
> congested. This is particularly true in data center where application
> could start thousands to millions of connections over a single or
> multiple hosts resulting in high SYN drops (e.g. incast).
> 
> This patch-set detects spurious SYN and SYNACK timeouts upon
> completing the handshake via the widely-supported TCP timestamp
> options. Upon such events the sender reverts to the default
> initial window to start the data transfer so it gets best of both
> worlds. This patch-set supports this feature for both active and
> passive as well as Fast Open or regular connections.

Series applied, thanks.
