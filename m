Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0216FE6BA7
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 04:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbfJ1D6v convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 27 Oct 2019 23:58:51 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:58336 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbfJ1D6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 23:58:51 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9S3wUbQ013774, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw [172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTP id x9S3wUbQ013774;
        Mon, 28 Oct 2019 11:58:30 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Mon, 28 Oct
 2019 11:58:29 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "oliver@neukum.org" <oliver@neukum.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH 2/2] r8152: Add macpassthru support for ThinkPad Thunderbolt 3 Dock Gen 2
Thread-Topic: [PATCH 2/2] r8152: Add macpassthru support for ThinkPad
 Thunderbolt 3 Dock Gen 2
Thread-Index: AQHViyNIwWDKAImfZESSShiKae+s26dvaNpQ
Date:   Mon, 28 Oct 2019 03:58:28 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18EEE4D@RTITMBSVM03.realtek.com.tw>
References: <20191025105919.689-1-kai.heng.feng@canonical.com>
 <20191025105919.689-2-kai.heng.feng@canonical.com>
In-Reply-To: <20191025105919.689-2-kai.heng.feng@canonical.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng [mailto:kai.heng.feng@canonical.com]
> Sent: Friday, October 25, 2019 6:59 PM
[...]
> @@ -6626,6 +6648,9 @@ static int rtl8152_probe(struct usb_interface *intf,
>  		netdev->hw_features &= ~NETIF_F_RXCSUM;
>  	}
> 
> +	if (id->driver_info & R8152_QUIRK_LENOVO_MACPASSTHRU)

Do you really need this?
It seems the information of idVendor and idProduct is enough. 

> +		set_bit(LENOVO_MACPASSTHRU, &tp->flags);
> +
>  	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial
> &&
>  	    (!strcmp(udev->serial, "000001000000") ||
>  	     !strcmp(udev->serial, "000002000000"))) {
> @@ -6754,6 +6779,8 @@ static const struct usb_device_id rtl8152_table[] = {
>  	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f, 0)},
>  	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062, 0)},
>  	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069, 0)},
> +	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082,
> +			R8152_QUIRK_LENOVO_MACPASSTHRU)},

This limits the usage of driver_info. For example, I couldn't
use it to store a pointer address anymore.

>  	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205, 0)},
>  	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c, 0)},
>  	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214, 0)},
> --
> 2.17.1

