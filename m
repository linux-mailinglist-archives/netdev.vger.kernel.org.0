Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4770D2A2514
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 08:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgKBHUW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Nov 2020 02:20:22 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:54151 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbgKBHUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 02:20:22 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0A27KG1t8032712, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0A27KG1t8032712
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 2 Nov 2020 15:20:16 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.33) by
 RTEXMB04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Mon, 2 Nov 2020 15:20:16 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 2 Nov 2020 15:20:15 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Mon, 2 Nov 2020 15:20:15 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next v2] net/usb/r8153_ecm: support ECM mode for RTL8153
Thread-Topic: [PATCH net-next v2] net/usb/r8153_ecm: support ECM mode for
 RTL8153
Thread-Index: AQHWrmwDnKDexsPDxUiMgOTBbfR/C6mx0pMAgAJFC4A=
Date:   Mon, 2 Nov 2020 07:20:15 +0000
Message-ID: <dc7fd1d4d1c544e8898224c7d9b54bda@realtek.com>
References: <1394712342-15778-387-Taiwan-albertk@realtek.com>
        <1394712342-15778-388-Taiwan-albertk@realtek.com>
 <20201031160838.39586608@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031160838.39586608@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.146]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org>
[...]
> Can you describe the use case in more detail?
> 
> AFAICT r8152 defines a match for the exact same device.
> Does it not mean that which driver is used will be somewhat random
> if both are built?

I export rtl_get_version() from r8152. It would return none zero
value if r8152 could support this device. Both r8152 and r8153_ecm
would check the return value of rtl_get_version() in porbe().
Therefore, if rtl_get_version() return none zero value, the r8152
is used for the device with vendor mode. Otherwise, the r8153_ecm
is used for the device with ECM mode.

> > +/* Define these values to match your device */
> > +#define VENDOR_ID_REALTEK		0x0bda
> > +#define VENDOR_ID_MICROSOFT		0x045e
> > +#define VENDOR_ID_SAMSUNG		0x04e8
> > +#define VENDOR_ID_LENOVO		0x17ef
> > +#define VENDOR_ID_LINKSYS		0x13b1
> > +#define VENDOR_ID_NVIDIA		0x0955
> > +#define VENDOR_ID_TPLINK		0x2357
> 
> $ git grep 0x2357 | grep -i tplink
> drivers/net/usb/cdc_ether.c:#define TPLINK_VENDOR_ID	0x2357
> drivers/net/usb/r8152.c:#define VENDOR_ID_TPLINK		0x2357
> drivers/usb/serial/option.c:#define TPLINK_VENDOR_ID			0x2357
> 
> $ git grep 0x17ef | grep -i lenovo
> drivers/hid/hid-ids.h:#define USB_VENDOR_ID_LENOVO		0x17ef
> drivers/hid/wacom.h:#define USB_VENDOR_ID_LENOVO	0x17ef
> drivers/net/usb/cdc_ether.c:#define LENOVO_VENDOR_ID	0x17ef
> drivers/net/usb/r8152.c:#define VENDOR_ID_LENOVO		0x17ef
> 
> Time to consolidate those vendor id defines perhaps?

It seems that there is no such header file which I could include
or add the new vendor IDs.

Best Regards,
Hayes



