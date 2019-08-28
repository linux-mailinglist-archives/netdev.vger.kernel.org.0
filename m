Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B242A0CAB
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfH1Vqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:46:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37384 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfH1Vqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:46:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC658153A41BC;
        Wed, 28 Aug 2019 14:46:40 -0700 (PDT)
Date:   Wed, 28 Aug 2019 14:46:40 -0700 (PDT)
Message-Id: <20190828.144640.1256529135313631776.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     xiyou.wangcong@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        netdev@vger.kernel.org, pabeni@redhat.com, sbrivio@redhat.com,
        shuali@redhat.com
Subject: Re: [PATCH net v2] net/sched: pfifo_fast: fix wrong dereference
 when qdisc is reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <783231162b9d32faaf5df34ad8ad437b0031bd31.1566901438.git.dcaratti@redhat.com>
References: <783231162b9d32faaf5df34ad8ad437b0031bd31.1566901438.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 14:46:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Tue, 27 Aug 2019 12:29:09 +0200

> Now that 'TCQ_F_CPUSTATS' bit can be cleared, depending on the value of
> 'TCQ_F_NOLOCK' bit in the parent qdisc, we need to be sure that per-cpu
> counters are present when 'reset()' is called for pfifo_fast qdiscs.
> Otherwise, the following script:
 ...
> can generate the following splat:
 ...
> Fix this by testing the value of 'TCQ_F_CPUSTATS' bit in 'qdisc->flags',
> before dereferencing 'qdisc->cpu_qstats'.
> 
> Changes since v1:
>  - coding style improvements, thanks to Stefano Brivio
> 
> Fixes: 8a53e616de29 ("net: sched: when clearing NOLOCK, clear TCQ_F_CPUSTATS, too")
> CC: Paolo Abeni <pabeni@redhat.com>
> Reported-by: Li Shuang <shuali@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied and queued up for v5.2 -stable.
