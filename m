Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED7B823F2
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 19:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbfHER1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 13:27:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59536 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfHER1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 13:27:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7492715407F00;
        Mon,  5 Aug 2019 10:27:00 -0700 (PDT)
Date:   Mon, 05 Aug 2019 10:26:56 -0700 (PDT)
Message-Id: <20190805.102656.1576923178764860652.davem@davemloft.net>
To:     johan@kernel.org
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        cuissard@marvell.com, andreyknvl@google.com, dvyukov@google.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+cf35b76f35e068a1107f@syzkaller.appspotmail.com
Subject: Re: [PATCH] NFC: nfcmrvl: fix gpio-handling regression
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190805100055.10398-1-johan@kernel.org>
References: <20190805100055.10398-1-johan@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 10:27:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hovold <johan@kernel.org>
Date: Mon,  5 Aug 2019 12:00:55 +0200

> Fix two reset-gpio sanity checks which were never converted to use
> gpio_is_valid(), and make sure to use -EINVAL to indicate a missing
> reset line also for the UART-driver module parameter and for the USB
> driver.
> 
> This specifically prevents the UART and USB drivers from incidentally
> trying to request and use gpio 0, and also avoids triggering a WARN() in
> gpio_to_desc() during probe when no valid reset line has been specified.
> 
> Fixes: e33a3f84f88f ("NFC: nfcmrvl: allow gpio 0 for reset signalling")
> Cc: stable <stable@vger.kernel.org>	# 4.13
> Reported-by: syzbot+cf35b76f35e068a1107f@syzkaller.appspotmail.com
> Tested-by: syzbot+cf35b76f35e068a1107f@syzkaller.appspotmail.com
> Signed-off-by: Johan Hovold <johan@kernel.org>

Applied and queued up for -stable.
