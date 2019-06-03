Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A54E6325EE
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 03:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfFCBLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 21:11:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50588 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFCBLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 21:11:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 41B0E1340D538;
        Sun,  2 Jun 2019 18:11:30 -0700 (PDT)
Date:   Sun, 02 Jun 2019 18:11:29 -0700 (PDT)
Message-Id: <20190602.181129.1486064709617479611.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, willemb@google.com,
        syzkaller@googlegroups.com, dvyukov@google.com
Subject: Re: [PATCH net] packet: unconditionally free po->rollover
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531163723.191617-1-willemdebruijn.kernel@gmail.com>
References: <20190531163723.191617-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 02 Jun 2019 18:11:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Fri, 31 May 2019 12:37:23 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> Rollover used to use a complex RCU mechanism for assignment, which had
> a race condition. The below patch fixed the bug and greatly simplified
> the logic.
> 
> The feature depends on fanout, but the state is private to the socket.
> Fanout_release returns f only when the last member leaves and the
> fanout struct is to be freed.
> 
> Destroy rollover unconditionally, regardless of fanout state.
> 
> Fixes: 57f015f5eccf2 ("packet: fix crash in fanout_demux_rollover()")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Diagnosed-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable.
