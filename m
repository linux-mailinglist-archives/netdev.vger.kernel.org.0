Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221CB134DC6
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgAHUlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:41:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47592 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbgAHUli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:41:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 44FF01584BD28;
        Wed,  8 Jan 2020 12:41:38 -0800 (PST)
Date:   Wed, 08 Jan 2020 12:41:37 -0800 (PST)
Message-Id: <20200108.124137.101510987796630147.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, fw@strlen.de,
        syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com
Subject: Re: [PATCH net] pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200106141039.204089-1-edumazet@google.com>
References: <20200106141039.204089-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 12:41:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon,  6 Jan 2020 06:10:39 -0800

> As diagnosed by Florian :
> 
> If TCA_FQ_QUANTUM is set to 0x80000000, fq_deueue()
> can loop forever in :
> 
> if (f->credit <= 0) {
>   f->credit += q->quantum;
>   goto begin;
> }
> 
> ... because f->credit is either 0 or -2147483648.
> 
> Let's limit TCA_FQ_QUANTUM to no more than 1 << 20 :
> This max value should limit risks of breaking user setups
> while fixing this bug.
> 
> Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Diagnosed-by: Florian Westphal <fw@strlen.de>
> Reported-by: syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com

Applied and queued up for -stable, thanks.
