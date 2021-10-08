Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437FE427434
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 01:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243753AbhJHXfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 19:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231927AbhJHXfh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 19:35:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84DF860F93;
        Fri,  8 Oct 2021 23:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633736021;
        bh=w5oQwy4X68XmDzVHh1jDz3jQvfmR5n7r/q1/aeiNG/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HLR2elylFO/sA7DSmYWyC6U3povK6RFdoGqXLEuabXkKUPRrHZ4p44NUNep3TYkLC
         JT0iqEs1HDje9ph88jm8DtmrH8RlP99jr6JbwmRu9aqRXXYDQdTc6Cb9q4VXQXtkKH
         PEfHZGnmHoYUGr0+9Rbum8aV0dKPSJdfYhCiH4BUUHOiDn81F0g/poE8jQcTNtAqiS
         zC//kGsGvSmSCWnsExzXjuuJ3Mw/cO+o7ng72WpsrjITDTI6a0aAE/TyHM8quioMv8
         7GLj4VglfgQ3b39Boh466m7J4L6Q0yGk4Bpisy4+iDPGJrdv8v1aSU1r8Wsu7yM3jz
         EKOhOa6ISG/zg==
Date:   Fri, 8 Oct 2021 16:33:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net 1/4] mqprio: Correct stats in
 mqprio_dump_class_stats().
Message-ID: <20211008163340.5c8ebc2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211007175000.2334713-2-bigeasy@linutronix.de>
References: <20211007175000.2334713-1-bigeasy@linutronix.de>
        <20211007175000.2334713-2-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Oct 2021 19:49:57 +0200 Sebastian Andrzej Siewior wrote:
> It looks like with the introduction of subqueus the statics broke.
> Before the change `bstats' and `qstats' on stack was fed and later this
> was copied over to struct gnet_dump.
> 
> After the change the `bstats' and `qstats' are only set to 0 and no
> longer updated and that is then fed to gnet_dump. Additionally
> qdisc->cpu_bstats and qdisc->cpu_qstats is destroeyd for global
> stats. For per-CPU stats both __gnet_stats_copy_basic() and
> __gnet_stats_copy_queue() add the values but for global stats the value
> set and so the previous value is lost and only the last value from the
> loop ends up in sch->[bq]stats.
> 
> Use the on-stack [bq]stats variables again and add the stats manually in
> the global case.
> 
> Fixes: ce679e8df7ed2 ("net: sched: add support for TCQ_F_NOLOCK subqueues to sch_mqprio")
> Cc: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Applied after significant massaging of the commit message.

Please repost the cleanup in a week (once net gets merged 
into net-next).

Thanks!
