Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F803F5A8B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfKHWGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:06:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39266 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfKHWGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:06:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C783153AF3AF;
        Fri,  8 Nov 2019 14:06:45 -0800 (PST)
Date:   Fri, 08 Nov 2019 14:06:45 -0800 (PST)
Message-Id: <20191108.140645.867365524804910483.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, willemb@google.com
Subject: Re: [PATCH net-next] packet: fix data-race in fanout_flow_is_huge()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108130746.172131-1-edumazet@google.com>
References: <20191108130746.172131-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 14:06:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  8 Nov 2019 05:07:46 -0800

> KCSAN reported the following data-race [1]
> 
> Adding a couple of READ_ONCE()/WRITE_ONCE() should silence it.
> 
> Since the report hinted about multiple cpus using the history
> concurrently, I added a test avoiding writing on it if the
> victim slot already contains the desired value.
> 
> [1]
> 
> BUG: KCSAN: data-race in fanout_demux_rollover / fanout_demux_rollover
 ...
> Fixes: 3b3a5b0aab5b ("packet: rollover huge flows before small flows")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
