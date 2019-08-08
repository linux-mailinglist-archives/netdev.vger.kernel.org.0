Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E938686F
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 20:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390145AbfHHSFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 14:05:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49194 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfHHSFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 14:05:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D56CA154FFFF0;
        Thu,  8 Aug 2019 11:05:13 -0700 (PDT)
Date:   Thu, 08 Aug 2019 11:05:13 -0700 (PDT)
Message-Id: <20190808.110513.1831373344437334072.davem@davemloft.net>
To:     oneukum@suse.com
Cc:     netdev@vger.kernel.org, dsd@gentoo.org, kune@deine-taler.de,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: [PATCH] zd1211rw: remove false assertion from zd_mac_clear()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190808093203.23752-1-oneukum@suse.com>
References: <20190808093203.23752-1-oneukum@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 11:05:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>
Date: Thu,  8 Aug 2019 11:32:03 +0200

> The function is called before the lock which is asserted was ever used.
> Just remove it.
> 
> Reported-by: syzbot+74c65761783d66a9c97c@syzkaller.appspotmail.com
> Signed-off-by: Oliver Neukum <oneukum@suse.com>

Please CC: the appropriate driver maitainers and mailing list as this
is clearly specified in the MAINTAINERS file.

Thank you.

> ---
>  drivers/net/wireless/zydas/zd1211rw/zd_mac.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
> index da7e63fca9f5..a9999d10ae81 100644
> --- a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
> @@ -223,7 +223,6 @@ void zd_mac_clear(struct zd_mac *mac)
>  {
>  	flush_workqueue(zd_workqueue);
>  	zd_chip_clear(&mac->chip);
> -	lockdep_assert_held(&mac->lock);
>  	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));
>  }
>  
> -- 
> 2.16.4
> 
