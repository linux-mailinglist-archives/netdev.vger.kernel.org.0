Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF0DFE691
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKOUrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:47:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40936 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfKOUrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:47:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 326B614E14FF3;
        Fri, 15 Nov 2019 12:47:06 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:47:05 -0800 (PST)
Message-Id: <20191115.124705.218221190080573287.davem@davemloft.net>
To:     ppenkov.kernel@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, ppenkov@google.com,
        syzkaller@googlegroups.com
Subject: Re: [net-next] tun: fix data-race in gro_normal_list()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114175209.205382-1-ppenkov.kernel@gmail.com>
References: <20191114175209.205382-1-ppenkov.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 12:47:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov.kernel@gmail.com>
Date: Thu, 14 Nov 2019 09:52:09 -0800

> From: Petar Penkov <ppenkov@google.com>
> 
> There is a race in the TUN driver between napi_busy_loop and
> napi_gro_frags. This commit resolves the race by adding the NAPI struct
> via netif_tx_napi_add, instead of netif_napi_add, which disables polling
> for the NAPI struct.
> 
> KCSAN reported:
> BUG: KCSAN: data-race in gro_normal_list.part.0 / napi_busy_loop
 ...
> Fixes: 943170998b20 ("tun: enable NAPI for TUN/TAP driver")
> Signed-off-by: Petar Penkov <ppenkov@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied.
