Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78FEA5A689
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 23:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfF1Vqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 17:46:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52428 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfF1Vqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 17:46:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1304813CB3330;
        Fri, 28 Jun 2019 14:46:48 -0700 (PDT)
Date:   Fri, 28 Jun 2019 14:46:47 -0700 (PDT)
Message-Id: <20190628.144647.570493656550419800.davem@davemloft.net>
To:     vedang.patel@intel.com
Cc:     netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        intel-wired-lan@lists.osuosl.org, vinicius.gomes@intel.com,
        l@dorileo.org, jakub.kicinski@netronome.com, m-karicheri2@ti.com,
        sergei.shtylyov@cogentembedded.com, eric.dumazet@gmail.com,
        aaron.f.brown@intel.com
Subject: Re: [PATCH net-next v6 0/8] net/sched: Add txtime-assist support
 for taprio.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561500439-30276-1-git-send-email-vedang.patel@intel.com>
References: <1561500439-30276-1-git-send-email-vedang.patel@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 14:46:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vedang Patel <vedang.patel@intel.com>
Date: Tue, 25 Jun 2019 15:07:11 -0700

> Currently, we are seeing packets being transmitted outside their
> timeslices. We can confirm that the packets are being dequeued at the right
> time. So, the delay is induced after the packet is dequeued, because
> taprio, without any offloading, has no control of when a packet is actually
> transmitted.
> 
> In order to solve this, we are making use of the txtime feature provided by
> ETF qdisc. Hardware offloading needs to be supported by the ETF qdisc in
> order to take advantage of this feature. The taprio qdisc will assign
> txtime (in skb->tstamp) for all the packets which do not have the txtime
> allocated via the SO_TXTIME socket option. For the packets which already
> have SO_TXTIME set, taprio will validate whether the packet will be
> transmitted in the correct interval.
> 
> In order to support this, the following parameters have been added:
> - flags (taprio): This is added in order to support different offloading
>   modes which will be added in the future.
> - txtime-delay (taprio): This indicates the minimum time it will take for
>   the packet to hit the wire after it reaches taprio_enqueue(). This is
>   useful in determining whether we can transmit the packet in the remaining
>   time if the gate corresponding to the packet is currently open.
> - skip_skb_check (ETF): ETF currently drops any packet which does not have
>   the SO_TXTIME socket option set. This check can be skipped by specifying
>   this option.
 ...

Series applied, thanks.
