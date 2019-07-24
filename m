Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 152EE741B3
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfGXWts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:49:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53198 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfGXWts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:49:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30BD71543CF81;
        Wed, 24 Jul 2019 15:49:47 -0700 (PDT)
Date:   Wed, 24 Jul 2019 15:49:46 -0700 (PDT)
Message-Id: <20190724.154946.685191807969201132.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+622bdabb128acc33427d@syzkaller.appspotmail.com,
        syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com,
        syzbot+9399c158fcc09b21d0d2@syzkaller.appspotmail.com,
        syzbot+a34e5f3d0300163f0c87@syzkaller.appspotmail.com,
        ralf@linux-mips.org
Subject: Re: [Patch net] netrom: hold sock when setting skb->destructor
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723034122.23166-1-xiyou.wangcong@gmail.com>
References: <20190723034122.23166-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 15:49:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Mon, 22 Jul 2019 20:41:22 -0700

> sock_efree() releases the sock refcnt, if we don't hold this refcnt
> when setting skb->destructor to it, the refcnt would not be balanced.
> This leads to several bug reports from syzbot.
> 
> I have checked other users of sock_efree(), all of them hold the
> sock refcnt.
> 
> Fixes: c8c8218ec5af ("netrom: fix a memory leak in nr_rx_frame()")
> Reported-and-tested-by: <syzbot+622bdabb128acc33427d@syzkaller.appspotmail.com>
> Reported-and-tested-by: <syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com>
> Reported-and-tested-by: <syzbot+9399c158fcc09b21d0d2@syzkaller.appspotmail.com>
> Reported-and-tested-by: <syzbot+a34e5f3d0300163f0c87@syzkaller.appspotmail.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable.
