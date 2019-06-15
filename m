Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307C546DAF
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfFOCIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:08:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57110 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFOCIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:08:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81F1112EB0323;
        Fri, 14 Jun 2019 19:08:09 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:08:08 -0700 (PDT)
Message-Id: <20190614.190808.2204923376726716417.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     stephen@networkplumber.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netem@lists.linux-foundation.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, edumazet@google.com, posk@google.com
Subject: Re: [PATCH net] net: netem: fix use after free and double free
 with packet corruption
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612185121.4175-1-jakub.kicinski@netronome.com>
References: <20190612185121.4175-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:08:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 12 Jun 2019 11:51:21 -0700

> Brendan reports that the use of netem's packet corruption capability
> leads to strange crashes.  This seems to be caused by
> commit d66280b12bd7 ("net: netem: use a list in addition to rbtree")
> which uses skb->next pointer to construct a fast-path queue of
> in-order skbs.
> 
> Packet corruption code has to invoke skb_gso_segment() in case
> of skbs in need of GSO.  skb_gso_segment() returns a list of
> skbs.  If next pointers of the skbs on that list do not get cleared
> fast path list goes into the weeds and tries to access the next
> segment skb multiple times.
> 
> Reported-by: Brendan Galloway <brendan.galloway@netronome.com>
> Fixes: d66280b12bd7 ("net: netem: use a list in addition to rbtree")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Please rework the commit message a bit to make things cleared, your
ascii diagrams would be great. :)

