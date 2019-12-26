Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93EF812AFC9
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfLZXgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:36:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44658 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfLZXgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:36:00 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E467153A868B;
        Thu, 26 Dec 2019 15:35:59 -0800 (PST)
Date:   Thu, 26 Dec 2019 15:35:58 -0800 (PST)
Message-Id: <20191226.153558.876242092356247020.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com,
        ncardwell@google.com
Subject: Re: [PATCH net] net_sched: sch_fq: properly set
 sk->sk_pacing_status
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191223191324.49554-1-edumazet@google.com>
References: <20191223191324.49554-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 15:35:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 23 Dec 2019 11:13:24 -0800

> If fq_classify() recycles a struct fq_flow because
> a socket structure has been reallocated, we do not
> set sk->sk_pacing_status immediately, but later if the
> flow becomes detached.
> 
> This means that any flow requiring pacing (BBR, or SO_MAX_PACING_RATE)
> might fallback to TCP internal pacing, which requires a per-socket
> high resolution timer, and therefore more cpu cycles.
> 
> Fixes: 218af599fa63 ("tcp: internal implementation for pacing")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks Eric.
