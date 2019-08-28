Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C099F8EB
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 05:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfH1Dw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 23:52:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54434 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfH1Dw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 23:52:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6AA2F153BA913;
        Tue, 27 Aug 2019 20:52:55 -0700 (PDT)
Date:   Tue, 27 Aug 2019 20:52:54 -0700 (PDT)
Message-Id: <20190827.205254.561639753689757462.davem@davemloft.net>
To:     loyou85@gmail.com
Cc:     edumazet@google.com, dsterba@suse.com, dbanerje@akamai.com,
        fw@strlen.de, davej@codemonkey.org.uk, tglx@linutronix.de,
        matwey@sai.msu.ru, sakari.ailus@linux.intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiaojunzhao141@gmail.com
Subject: Re: [PATCH v3] net: fix skb use after free in netpoll
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566801964-14691-1-git-send-email-loyou85@gmail.com>
References: <20190825.232003.1145950065287854577.davem@davemloft.net>
        <1566801964-14691-1-git-send-email-loyou85@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 20:52:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Sun <loyou85@gmail.com>
Date: Mon, 26 Aug 2019 14:46:04 +0800

> After commit baeababb5b85d5c4e6c917efe2a1504179438d3b
> ("tun: return NET_XMIT_DROP for dropped packets"),
> when tun_net_xmit drop packets, it will free skb and return NET_XMIT_DROP,
> netpoll_send_skb_on_dev will run into following use after free cases:
> 1. retry netpoll_start_xmit with freed skb;
> 2. queue freed skb in npinfo->txq.
> queue_process will also run into use after free case.
> 
> hit netpoll_send_skb_on_dev first case with following kernel log:
 ...
> Signed-off-by: Feng Sun <loyou85@gmail.com>
> Signed-off-by: Xiaojun Zhao <xiaojunzhao141@gmail.com>

Applied and queued up for -stable.
