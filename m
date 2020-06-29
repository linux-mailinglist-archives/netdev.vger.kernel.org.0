Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF5220E37A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390200AbgF2VOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:14:21 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:43155 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729877AbgF2S5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:57:41 -0400
Received: from marcel-macpro.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 012ABCECD6;
        Mon, 29 Jun 2020 17:51:57 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Bluetooth: fix kernel null pointer dereference error on
 suspend
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200629142600.GA3102@cosmos>
Date:   Mon, 29 Jun 2020 17:42:02 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C9C778D8-E453-4400-9475-E5127F5FA575@holtmann.org>
References: <20200629142600.GA3102@cosmos>
To:     Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vamshi,

> BUG Call Trace:
>  queue_work_on+0x39/0x40
>  hci_adv_monitors_clear+0x71/0x90 [bluetooth]
>  hci_unregister_dev+0x18a/0x2f0 [bluetooth]
>  btusb_disconnect+0x68/0x150 [btusb]
>  usb_unbind_interface+0x7f/0x260
>  device_release_driver_internal+0xec/0x1b0
>  device_release_driver+0x12/0x20
>  bus_remove_device+0xe1/0x150
>  device_del+0x17d/0x3e0
>  usb_disable_device+0x9f/0x250
>  usb_disconnect+0xc6/0x270
>  hub_event+0x6da/0x18d0
>  process_one_work+0x20c/0x400
>  worker_thread+0x34/0x400
> 
> RIP: 0010:__queue_work+0x92/0x3f0
> 
> NULL deference occurs in hci_update_background_scan() while it tries
> to queue_work on already destroyed workqueues.
> 
> Change hci_unregister_dev() to invoke destroy_workqueues after the
> call to hci_adv_monitors_clear().
> 
> Signed-off-by: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
> ---
> net/bluetooth/hci_core.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

