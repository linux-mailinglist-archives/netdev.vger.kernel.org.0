Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E03E6EFC
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 10:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731890AbfJ1JWA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Oct 2019 05:22:00 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:54491 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728941AbfJ1JV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 05:21:59 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9S9LbRM014005, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9S9LbRM014005
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 28 Oct 2019 17:21:41 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Mon, 28 Oct
 2019 17:21:29 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "oliver@neukum.org" <oliver@neukum.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH 2/2] r8152: Add macpassthru support for ThinkPad Thunderbolt 3 Dock Gen 2
Thread-Topic: [PATCH 2/2] r8152: Add macpassthru support for ThinkPad
 Thunderbolt 3 Dock Gen 2
Thread-Index: AQHViyNIwWDKAImfZESSShiKae+s26dvaNpQ//+TW4CAAMxToA==
Date:   Mon, 28 Oct 2019 09:21:28 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18EF17F@RTITMBSVM03.realtek.com.tw>
References: <20191025105919.689-1-kai.heng.feng@canonical.com>
 <20191025105919.689-2-kai.heng.feng@canonical.com>
 <0835B3720019904CB8F7AA43166CEEB2F18EEE4D@RTITMBSVM03.realtek.com.tw>
 <3980F066-6783-45A6-9B34-1D838C2C1A2C@canonical.com>
In-Reply-To: <3980F066-6783-45A6-9B34-1D838C2C1A2C@canonical.com>
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
> Sent: Monday, October 28, 2019 12:58 PM
[...]
> >> @@ -6754,6 +6779,8 @@ static const struct usb_device_id rtl8152_table[]
> = {
> >> 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f, 0)},
> >> 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062, 0)},
> >> 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069, 0)},
> >> +	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082,
> >> +			R8152_QUIRK_LENOVO_MACPASSTHRU)},
> >
> > This limits the usage of driver_info. For example, I couldn't
> > use it to store a pointer address anymore.
> 
> But will the driver ever use .driver_info for pointers?
> There are many driver use it for quirks and quirks only.

I prefer to keep .driver_info empty, even though it is not
used currently.

The R8152_QUIRK_LENOVO_MACPASSTHRU is only used to set the
flag of LENOVO_MACPASSTHRU in probe(), and it is used only once.
Besides, it could be replaced by checking the vendor ID and
product ID. Therefore, I don't think it is necessary to use
driver_info , unless there are more devices needing it.

Best Regards,
Hayes


