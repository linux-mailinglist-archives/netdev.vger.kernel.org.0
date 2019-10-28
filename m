Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 459F4E6F40
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 10:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388004AbfJ1Jl7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 28 Oct 2019 05:41:59 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:56054 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732063AbfJ1Jl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 05:41:59 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9S9fgjr018616, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9S9fgjr018616
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Oct 2019 17:41:42 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Mon, 28 Oct
 2019 17:41:42 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "oliver@neukum.org" <oliver@neukum.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] r8152: Pass driver_info to REALTEK_USB_DEVICE() macro
Thread-Topic: [PATCH 1/2] r8152: Pass driver_info to REALTEK_USB_DEVICE()
 macro
Thread-Index: AQHViyNHZmeG3ry3I0mcK8buPIS36KdvzL/w
Date:   Mon, 28 Oct 2019 09:41:40 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18EF1C4@RTITMBSVM03.realtek.com.tw>
References: <20191025105919.689-1-kai.heng.feng@canonical.com>
In-Reply-To: <20191025105919.689-1-kai.heng.feng@canonical.com>
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
> -#define REALTEK_USB_DEVICE(vend, prod)	\
> +#define REALTEK_USB_DEVICE(vend, prod, info)	\
>  	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
>  		       USB_DEVICE_ID_MATCH_INT_CLASS, \
>  	.idVendor = (vend), \
>  	.idProduct = (prod), \
> -	.bInterfaceClass = USB_CLASS_VENDOR_SPEC \
> +	.bInterfaceClass = USB_CLASS_VENDOR_SPEC, \
> +	.driver_info = (info) \
>  }, \
>  { \
>  	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO | \
> @@ -6739,25 +6740,26 @@ static void rtl8152_disconnect(struct
> usb_interface *intf)
>  	.idProduct = (prod), \
>  	.bInterfaceClass = USB_CLASS_COMM, \
>  	.bInterfaceSubClass = USB_CDC_SUBCLASS_ETHERNET, \
> -	.bInterfaceProtocol = USB_CDC_PROTO_NONE
> +	.bInterfaceProtocol = USB_CDC_PROTO_NONE, \
> +	.driver_info = (info) \

This part is for ECM mode. Add driver_info here is useless,
because it is never be used. The driver always changes
the ECM mode to vendor mode.

Best Regards,
Hayes


