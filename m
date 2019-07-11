Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3006266146
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 23:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfGKViC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 17:38:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47268 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfGKViC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 17:38:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C13DF14DAF644;
        Thu, 11 Jul 2019 14:38:01 -0700 (PDT)
Date:   Thu, 11 Jul 2019 14:38:01 -0700 (PDT)
Message-Id: <20190711.143801.134278119555664614.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org,
        syzbot+097ef84cdc95843fbaa8@syzkaller.appspotmail.com,
        arvid.brodin@alten.se
Subject: Re: [Patch net] hsr: switch ->dellink() to ->ndo_uninit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190710062454.16386-1-xiyou.wangcong@gmail.com>
References: <20190710062454.16386-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jul 2019 14:38:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue,  9 Jul 2019 23:24:54 -0700

> Switching from ->priv_destructor to dellink() has an unexpected
> consequence: existing RCU readers, that is, hsr_port_get_hsr()
> callers, may still be able to read the port list.
> 
> Instead of checking the return value of each hsr_port_get_hsr(),
> we can just move it to ->ndo_uninit() which is called after
> device unregister and synchronize_net(), and we still have RTNL
> lock there.
> 
> Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")
> Fixes: edf070a0fb45 ("hsr: fix a NULL pointer deref in hsr_dev_xmit()")
> Reported-by: syzbot+097ef84cdc95843fbaa8@syzkaller.appspotmail.com
> Cc: Arvid Brodin <arvid.brodin@alten.se>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied and queued up for -stable, thanks.
