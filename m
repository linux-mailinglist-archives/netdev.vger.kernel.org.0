Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD3277BD2
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 22:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388380AbfG0UaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 16:30:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39862 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388192AbfG0UaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 16:30:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 63060153409C7;
        Sat, 27 Jul 2019 13:29:59 -0700 (PDT)
Date:   Sat, 27 Jul 2019 13:29:59 -0700 (PDT)
Message-Id: <20190727.132959.360971552451713269.davem@davemloft.net>
To:     baijiaju1990@gmail.com
Cc:     isdn@linux-pingi.de, pakki001@umn.edu, tranmanphong@gmail.com,
        gregkh@linuxfoundation.org, rfontana@redhat.com,
        gustavo@embeddedor.com, tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: mISDN: hfcsusb: Fix possible null-pointer
 dereferences in start_isoc_chain()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190726082736.8195-1-baijiaju1990@gmail.com>
References: <20190726082736.8195-1-baijiaju1990@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 13:29:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>
Date: Fri, 26 Jul 2019 16:27:36 +0800

> In start_isoc_chain(), usb_alloc_urb() on line 1392 may fail 
> and return NULL. At this time, fifo->iso[i].urb is assigned to NULL.
> 
> Then, fifo->iso[i].urb is used at some places, such as:
> LINE 1405:    fill_isoc_urb(fifo->iso[i].urb, ...)
>                   urb->number_of_packets = num_packets;
>                   urb->transfer_flags = URB_ISO_ASAP;
>                   urb->actual_length = 0;
>                   urb->interval = interval;
> LINE 1416:    fifo->iso[i].urb->...
> LINE 1419:    fifo->iso[i].urb->...
> 
> Thus, possible null-pointer dereferences may occur.
> 
> To fix these bugs, "continue" is added to avoid using fifo->iso[i].urb
> when it is NULL.
> 
> These bugs are found by a static analysis tool STCheck written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Applied.
