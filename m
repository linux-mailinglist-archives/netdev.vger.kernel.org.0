Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B96E27563D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 12:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgIWKXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 06:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbgIWKXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 06:23:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70D10238D7;
        Wed, 23 Sep 2020 10:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600856591;
        bh=vbe7KhLEZRy4OEuhFJNKIUNqjK+4f7n+EAp2CYmrpyI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K1hQRymbnkZkbCaJfs7jUvv1JxrUwU4Z6Nl9qJwa5StOAbwQv4gM3cVnqrE6VuDr1
         6ymn5CiB7/D1c0bpifdyydecHdfJWw6nTtOlgZMLUX4FNTzjUheVGgGtb/s+VFJtAz
         DacfhjfPQxE1VqvdcGhcmTkd30hsdFOknC4gcMoI=
Date:   Wed, 23 Sep 2020 12:23:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Himadri Pandya <himadrispandya@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, oneukum@suse.com,
        pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        yuehaibing@huawei.com, petkan@nucleusys.com, ogiannou@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH 0/4] net: usb: avoid using usb_control_msg() directly
Message-ID: <20200923102330.GB3154647@kroah.com>
References: <20200923090519.361-1-himadrispandya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923090519.361-1-himadrispandya@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 02:35:15PM +0530, Himadri Pandya wrote:
> A recent bug-fix shaded light on possible incorrect use of
> usb_control_msg() without proper error check. This resulted in
> introducing new usb core api wrapper functions usb_control_msg_send()
> and usb_control_msg_recv() by Greg KH. This patch series continue the
> clean-up using the new functions.
> 
> Himadri Pandya (4):
>   net: usbnet: use usb_control_msg_recv() and usb_control_msg_send()
>   net: sierra_net: use usb_control_msg_recv()
>   net: usb: rtl8150: use usb_control_msg_recv() and
>     usb_control_msg_send()
>   net: rndis_host: use usb_control_msg_recv() and usb_control_msg_send()
> 
>  drivers/net/usb/rndis_host.c | 44 +++++++++++++---------------------
>  drivers/net/usb/rtl8150.c    | 32 +++++--------------------
>  drivers/net/usb/sierra_net.c | 17 ++++++-------
>  drivers/net/usb/usbnet.c     | 46 ++++--------------------------------
>  4 files changed, 34 insertions(+), 105 deletions(-)
> 

Note, all of these depend on a set of patches in my usb tree, so they
should probably wait to be sent to the networking developers until after
5.10-rc1 is out.

thanks,

greg k-h
