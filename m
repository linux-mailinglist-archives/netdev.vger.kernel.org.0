Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02452AC5C
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 23:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfEZV0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 17:26:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46728 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfEZV0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 17:26:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 17ADD14577853;
        Sun, 26 May 2019 14:26:14 -0700 (PDT)
Date:   Sun, 26 May 2019 14:26:11 -0700 (PDT)
Message-Id: <20190526.142611.2046234950632418862.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 00/11] inet: frags: avoid possible races at
 netns dismantle
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190524160340.169521-1-edumazet@google.com>
References: <20190524160340.169521-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 14:26:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 24 May 2019 09:03:29 -0700

> This patch series fixes a race happening on netns dismantle with
> frag queues. While rhashtable_free_and_destroy() is running,
> concurrent timers might run inet_frag_kill() and attempt
> rhashtable_remove_fast() calls. This is not allowed by
> rhashtable logic.
> 
> Since I do not want to add expensive synchronize_rcu() calls
> in the netns dismantle path, I had to no longer inline
> netns_frags structures, but dynamically allocate them.
> 
> The ten first patches make this preparation, so that
> the last patch clearly shows the fix.
> 
> As this patch series is not exactly trivial, I chose to
> target 5.3. We will backport it once soaked a bit.

Ok, applied to net-next.

Everything except the last patch looks trivially correct to me.
