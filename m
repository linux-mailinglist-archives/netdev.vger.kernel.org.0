Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64EAF18DED
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfEIQWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:22:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36462 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfEIQWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:22:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 524EB14CF8672;
        Thu,  9 May 2019 09:22:43 -0700 (PDT)
Date:   Thu, 09 May 2019 09:22:42 -0700 (PDT)
Message-Id: <20190509.092242.151546265607007899.davem@davemloft.net>
To:     jasowang@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuehaibing@huawei.com, xiyou.wangcong@gmail.com,
        weiyongjun1@huawei.com, eric.dumazet@gmail.com
Subject: Re: [PATCH net V3 2/2] tuntap: synchronize through tfiles array
 instead of tun->numqueues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557372018-18544-2-git-send-email-jasowang@redhat.com>
References: <1557372018-18544-1-git-send-email-jasowang@redhat.com>
        <1557372018-18544-2-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:22:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed,  8 May 2019 23:20:18 -0400

> When a queue(tfile) is detached through __tun_detach(), we move the
> last enabled tfile to the position where detached one sit but don't
> NULL out last position. We expect to synchronize the datapath through
> tun->numqueues. Unfortunately, this won't work since we're lacking
> sufficient mechanism to order or synchronize the access to
> tun->numqueues.
> 
> To fix this, NULL out the last position during detaching and check
> RCU protected tfile against NULL instead of checking tun->numqueues in
> datapath.
> 
> Cc: YueHaibing <yuehaibing@huawei.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: weiyongjun (A) <weiyongjun1@huawei.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Fixes: c8d68e6be1c3b ("tuntap: multiqueue support")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes from V2:
> - resample during detach in tun_xdp_xmit()
> Changes from V1:
> - keep the check in tun_xdp_xmit()

Applied and queued up for -stable.
