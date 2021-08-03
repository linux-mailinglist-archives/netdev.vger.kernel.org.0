Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EFD3DE637
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 07:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbhHCFhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 01:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231386AbhHCFhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 01:37:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21B9A60F48;
        Tue,  3 Aug 2021 05:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627969019;
        bh=8wr/7dE+jSZj26tooPGUxgremTinWJ9CqompU9Ny1r8=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=ThUNxGjvxhkUYpVm+CdfK0Qo7NIZKusVv+LWhWZre4g554VEIBq0rvNwxKc6I5klw
         mQFBfuRn/ITMNx0MQgZCWbJEs73GBqGdes+VzVptG3dNISn6DdseWX34SzTD57kSOU
         bMqDkT7HA/I+ObUjoj/KiHhkFO+2q7rH2NI+hqwU=
Date:   Tue, 3 Aug 2021 07:36:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Skripkin <paskripkin@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: pegasus: fix uninit-value in get_interrupt_interval
Message-ID: <YQjV+amsR+8PLVfZ@kroah.com>
References: <20210730214411.1973-1-paskripkin@gmail.com>
 <YQaVS5UwG6RFsL4t@carbon>
 <20210801223513.06bede26@gmail.com>
 <YQhQe4bdoEAef8bj@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQhQe4bdoEAef8bj@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 11:07:23PM +0300, Petko Manolov wrote:
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index 9a907182569c..eafbe8107907 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -26,6 +26,8 @@
>   *		...
>   *		v0.9.3	simplified [get|set]_register(s), async update registers
>   *			logic revisited, receive skb_pool removed.
> + *		v1.0.1	add error checking for set_register(s)(), see if calling
> + *			get_registers() has failed and print a message accordingly.
>   */
>  
>  #include <linux/sched.h>
> @@ -45,7 +47,7 @@
>  /*
>   * Version Information
>   */
> -#define DRIVER_VERSION "v0.9.3 (2013/04/25)"
> +#define DRIVER_VERSION "v1.0.1 (2021/08/01)"

Nit, the log above, and the driver version here, mean nothing when it
comes to code in the kernel tree, both should be dropped as we have full
kernel changelog through git, and the version is bound to the kernel
release the driver came in.

thanks,

greg k-h
