Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F054213CF3C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 22:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgAOVhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 16:37:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60388 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729578AbgAOVhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 16:37:15 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 156D315A0E3E8;
        Wed, 15 Jan 2020 13:37:11 -0800 (PST)
Date:   Wed, 15 Jan 2020 13:35:42 -0800 (PST)
Message-Id: <20200115.133542.149188857628032129.davem@davemloft.net>
To:     yangpc@wangsu.com
Cc:     edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: fix marked lost packets not being retransmitted
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1578993820-2114-1-git-send-email-yangpc@wangsu.com>
References: <1578993820-2114-1-git-send-email-yangpc@wangsu.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Jan 2020 13:37:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pengcheng Yang <yangpc@wangsu.com>
Date: Tue, 14 Jan 2020 17:23:40 +0800

> When the packet pointed to by retransmit_skb_hint is unlinked by ACK,
> retransmit_skb_hint will be set to NULL in tcp_clean_rtx_queue().
> If packet loss is detected at this time, retransmit_skb_hint will be set
> to point to the current packet loss in tcp_verify_retransmit_hint(),
> then the packets that were previously marked lost but not retransmitted
> due to the restriction of cwnd will be skipped and cannot be
> retransmitted.
> 
> To fix this, when retransmit_skb_hint is NULL, retransmit_skb_hint can
> be reset only after all marked lost packets are retransmitted
> (retrans_out >= lost_out), otherwise we need to traverse from
> tcp_rtx_queue_head in tcp_xmit_retransmit_queue().
> 
> Packetdrill to demonstrate:
 ...
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>

Applied, thank you.
