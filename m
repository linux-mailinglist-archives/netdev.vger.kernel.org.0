Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C37DFF5B2
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfKPVEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:04:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53808 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfKPVEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:04:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 426D2151A15FD;
        Sat, 16 Nov 2019 13:04:23 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:04:22 -0800 (PST)
Message-Id: <20191116.130422.2084572901433723641.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net] net/smc: fix fastopen for non-blocking connect()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191115113930.38684-1-kgraul@linux.ibm.com>
References: <20191115113930.38684-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:04:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Fri, 15 Nov 2019 12:39:30 +0100

> From: Ursula Braun <ubraun@linux.ibm.com>
> 
> FASTOPEN does not work with SMC-sockets. Since SMC allows fallback to
> TCP native during connection start, the FASTOPEN setsockopts trigger
> this fallback, if the SMC-socket is still in state SMC_INIT.
> But if a FASTOPEN setsockopt is called after a non-blocking connect(),
> this is broken, and fallback does not make sense.
> This change complements
> commit cd2063604ea6 ("net/smc: avoid fallback in case of non-blocking connect")
> and fixes the syzbot reported problem "WARNING in smc_unhash_sk".
> 
> Reported-by: syzbot+8488cc4cf1c9e09b8b86@syzkaller.appspotmail.com
> Fixes: e1bbdd570474 ("net/smc: reduce sock_put() for fallback sockets")
> Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>

Applied and queued up for -stable, thanks.
