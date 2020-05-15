Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D731D4F3C
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 15:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgEON05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 09:26:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34018 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgEON0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 09:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2lkBHPmlDRseinSfpjV+W/RFt5TcCXmxGmuOEC27plc=; b=XDpFiU172k5RrAaLBNhmTQlUrc
        jR2OibS4ZxAABJMhFVQlN9XNegRrmH9VQwX4fxx4PIMi8BnrqEwj9NpagBYhS27I/Jyw/drf1nECQ
        osgRt5q2QnDdGsfK64NrmFvt+ObES17pyWEhNWTDyuFsq8ISQzqmB8xp8pzdhSOhgFts=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZaMP-002Nfr-PO; Fri, 15 May 2020 15:26:45 +0200
Date:   Fri, 15 May 2020 15:26:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xulin Sun <xulin.sun@windriver.com>
Cc:     alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xulinsun@gmail.com
Subject: Re: [PATCH] net: mscc: ocelot: replace readx_poll_timeout with
 readx_poll_timeout_atomic
Message-ID: <20200515132645.GR527401@lunn.ch>
References: <20200515031813.30283-1-xulin.sun@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515031813.30283-1-xulin.sun@windriver.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 11:18:13AM +0800, Xulin Sun wrote:
> This fixes call trace like below to use atomic safe API:
> 
> BUG: sleeping function called from invalid context at drivers/net/ethernet/mscc/ocelot.c:59
> in_atomic(): 1, irqs_disabled(): 0, pid: 3778, name: ifconfig
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<ffff2b163c83b78c>] dev_set_rx_mode+0x24/0x40
> Hardware name: LS1028A RDB Board (DT)
> Call trace:
> dump_backtrace+0x0/0x140
> show_stack+0x24/0x30
> dump_stack+0xc4/0x10c
> ___might_sleep+0x194/0x230
> __might_sleep+0x58/0x90
> ocelot_mact_forget+0x74/0xf8
> ocelot_mc_unsync+0x2c/0x38
> __hw_addr_sync_dev+0x6c/0x130
> ocelot_set_rx_mode+0x8c/0xa0
> __dev_set_rx_mode+0x58/0xa0
> dev_set_rx_mode+0x2c/0x40
> __dev_open+0x120/0x190
> __dev_change_flags+0x168/0x1c0
> dev_change_flags+0x3c/0x78
> devinet_ioctl+0x6c4/0x7c8
> inet_ioctl+0x2b8/0x2f8
> sock_do_ioctl+0x54/0x260
> sock_ioctl+0x21c/0x4d0
> do_vfs_ioctl+0x6d4/0x968
> ksys_ioctl+0x84/0xb8
> __arm64_sys_ioctl+0x28/0x38
> el0_svc_common.constprop.0+0x78/0x190
> el0_svc_handler+0x70/0x90
> el0_svc+0x8/0xc
> 
> Signed-off-by: Xulin Sun <xulin.sun@windriver.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
