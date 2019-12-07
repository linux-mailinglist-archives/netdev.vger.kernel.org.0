Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE21115B0A
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 06:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfLGFGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 00:06:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36208 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfLGFGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 00:06:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 481601538660A;
        Fri,  6 Dec 2019 21:06:15 -0800 (PST)
Date:   Fri, 06 Dec 2019 21:06:14 -0800 (PST)
Message-Id: <20191206.210614.21944081416332733.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        edumazet@google.com, arnd@arndb.de, john.stultz@linaro.org,
        tglx@linutronix.de
Subject: Re: [PATCH net v4 0/3] tcp: fix handling of stale syncookies
 timestamps
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1575631229.git.gnault@redhat.com>
References: <cover.1575631229.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 21:06:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Fri, 6 Dec 2019 12:38:26 +0100

> The synflood timestamps (->ts_recent_stamp and ->synq_overflow_ts) are
> only refreshed when the syncookie protection triggers. Therefore, their
> value can become very far apart from jiffies if no synflood happens for
> a long time.
> 
> If jiffies grows too much and wraps while the synflood timestamp isn't
> refreshed, then time_after32() might consider the later to be in the
> future. This can trick tcp_synq_no_recent_overflow() into returning
> erroneous values and rejecting valid ACKs.
> 
> Patch 1 handles the case of ACKs using legitimate syncookies.
> Patch 2 handles the case of stray ACKs.
> Patch 3 annotates lockless timestamp operations with READ_ONCE() and
> WRITE_ONCE().
 ...

Series applied, thanks.
