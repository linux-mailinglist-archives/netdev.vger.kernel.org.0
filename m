Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 444A286865
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 20:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732786AbfHHSDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 14:03:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49066 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbfHHSDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 14:03:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B057C154FFFF0;
        Thu,  8 Aug 2019 11:03:30 -0700 (PDT)
Date:   Thu, 08 Aug 2019 11:03:30 -0700 (PDT)
Message-Id: <20190808.110330.1163430543960132818.davem@davemloft.net>
To:     oneukum@suse.com
Cc:     netdev@vger.kernel.org, wg@grandegger.com, mkl@pengutronix.de,
        linux-can@vger.kernel.org
Subject: Re: [PATCH] pcan_usb_fd: zero out the common command buffer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190808092825.23470-1-oneukum@suse.com>
References: <20190808092825.23470-1-oneukum@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 11:03:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>
Date: Thu,  8 Aug 2019 11:28:25 +0200

> Lest we leak kernel memory to a device we better zero out buffers.
> 
> Reported-by: syzbot+513e4d0985298538bf9b@syzkaller.appspotmail.com
> Signed-off-by: Oliver Neukum <oneukum@suse.com>

Please CC: the CAN subsystem maintainers, as this is clearly listed in the
MAINTAINERS file.

Thank you.

> ---
>  drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
> index 34761c3a6286..47cc1ff5b88e 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
> @@ -841,7 +841,7 @@ static int pcan_usb_fd_init(struct peak_usb_device *dev)
>  			goto err_out;
>  
>  		/* allocate command buffer once for all for the interface */
> -		pdev->cmd_buffer_addr = kmalloc(PCAN_UFD_CMD_BUFFER_SIZE,
> +		pdev->cmd_buffer_addr = kzalloc(PCAN_UFD_CMD_BUFFER_SIZE,
>  						GFP_KERNEL);
>  		if (!pdev->cmd_buffer_addr)
>  			goto err_out_1;
> -- 
> 2.16.4
> 
