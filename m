Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3EC399F55
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 21:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391273AbfHVTEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 15:04:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47270 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731910AbfHVTEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 15:04:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6F070153410A7;
        Thu, 22 Aug 2019 12:04:22 -0700 (PDT)
Date:   Thu, 22 Aug 2019 12:04:21 -0700 (PDT)
Message-Id: <20190822.120421.71092037400077946.davem@davemloft.net>
To:     jan.dakinevich@virtuozzo.com
Cc:     linux-kernel@vger.kernel.org, den@virtuozzo.com,
        khorenko@virtuozzo.com, pabeni@redhat.com, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, hare@suse.com, kgraul@linux.ibm.com,
        kyeongdon.kim@lge.com, tglx@linutronix.de, netdev@vger.kernel.org
Subject: Re: [PATCH] af_unix: utilize skb's fragment list for sending large
 datagrams
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566470311-4089-1-git-send-email-jan.dakinevich@virtuozzo.com>
References: <1566470311-4089-1-git-send-email-jan.dakinevich@virtuozzo.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 12:04:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Date: Thu, 22 Aug 2019 10:38:39 +0000

> However, paged part can not exceed MAX_SKB_FRAGS * PAGE_SIZE, and large
> datagram causes increasing skb's data buffer. Thus, if any user-space
> program sets send buffer (by calling setsockopt(SO_SNDBUF, ...)) to
> maximum allowed size (wmem_max) it becomes able to cause any amount
> of uncontrolled high-order kernel allocations.

So?  You want huge SKBs you get the high order allocations, seems
rather reasonable to me.

SKBs using fragment lists are the most difficult and cpu intensive
geometry for an SKB to have and we should avoid using it where
feasible.

I don't want to apply this, sorry.
