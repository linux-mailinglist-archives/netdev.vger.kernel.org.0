Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EBA2FC93B
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbhATDkP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 Jan 2021 22:40:15 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:57853 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728756AbhATDjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:39:52 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 10K3cXZv9031456, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs03.realtek.com.tw[172.21.6.96])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 10K3cXZv9031456
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 20 Jan 2021 11:38:33 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 20 Jan 2021 11:38:32 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833]) by
 RTEXMBS04.realtek.com.tw ([fe80::ecca:80ca:53:e833%12]) with mapi id
 15.01.2106.006; Wed, 20 Jan 2021 11:38:32 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Grant Grundler <grundler@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oliver@neukum.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        nic_swsd <nic_swsd@realtek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: usb: cdc_ncm: don't spew notifications
Thread-Topic: [PATCH net] net: usb: cdc_ncm: don't spew notifications
Thread-Index: AQHW7smNYWwyfviJ4EOtGXflgw3CLaov3Wqg
Date:   Wed, 20 Jan 2021 03:38:32 +0000
Message-ID: <0a5e1dad04494f16869b44b8457f0980@realtek.com>
References: <20210120011208.3768105-1-grundler@chromium.org>
In-Reply-To: <20210120011208.3768105-1-grundler@chromium.org>
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

Grant Grundler <grundler@chromium.org>
> Sent: Wednesday, January 20, 2021 9:12 AM
> Subject: [PATCH net] net: usb: cdc_ncm: don't spew notifications
> 
> RTL8156 sends notifications about every 32ms.
> Only display/log notifications when something changes.
> 
> This issue has been reported by others:
> 	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1832472
> 	https://lkml.org/lkml/2020/8/27/1083
> 
> ...
> [785962.779840] usb 1-1: new high-speed USB device number 5 using xhci_hcd
> [785962.929944] usb 1-1: New USB device found, idVendor=0bda,
> idProduct=8156, bcdDevice=30.00
> [785962.929949] usb 1-1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=6
> [785962.929952] usb 1-1: Product: USB 10/100/1G/2.5G LAN
> [785962.929954] usb 1-1: Manufacturer: Realtek
> [785962.929956] usb 1-1: SerialNumber: 000000001
> [785962.991755] usbcore: registered new interface driver cdc_ether
> [785963.017068] cdc_ncm 1-1:2.0: MAC-Address: 00:24:27:88:08:15
> [785963.017072] cdc_ncm 1-1:2.0: setting rx_max = 16384
> [785963.017169] cdc_ncm 1-1:2.0: setting tx_max = 16384
> [785963.017682] cdc_ncm 1-1:2.0 usb0: register 'cdc_ncm' at
> usb-0000:00:14.0-1, CDC NCM, 00:24:27:88:08:15
> [785963.019211] usbcore: registered new interface driver cdc_ncm
> [785963.023856] usbcore: registered new interface driver cdc_wdm
> [785963.025461] usbcore: registered new interface driver cdc_mbim
> [785963.038824] cdc_ncm 1-1:2.0 enx002427880815: renamed from usb0
> [785963.089586] cdc_ncm 1-1:2.0 enx002427880815: network connection:
> disconnected
> [785963.121673] cdc_ncm 1-1:2.0 enx002427880815: network connection:
> disconnected
> [785963.153682] cdc_ncm 1-1:2.0 enx002427880815: network connection:
> disconnected
> ...
> 
> This is about 2KB per second and will overwrite all contents of a 1MB
> dmesg buffer in under 10 minutes rendering them useless for debugging
> many kernel problems.
> 
> This is also an extra 180 MB/day in /var/logs (or 1GB per week) rendering
> the majority of those logs useless too.
> 
> When the link is up (expected state), spew amount is >2x higher:
> ...
> [786139.600992] cdc_ncm 2-1:2.0 enx002427880815: network connection:
> connected
> [786139.632997] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink
> 2500 mbit/s uplink
> [786139.665097] cdc_ncm 2-1:2.0 enx002427880815: network connection:
> connected
> [786139.697100] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink
> 2500 mbit/s uplink
> [786139.729094] cdc_ncm 2-1:2.0 enx002427880815: network connection:
> connected
> [786139.761108] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink
> 2500 mbit/s uplink
> ...
> 
> Chrome OS cannot support RTL8156 until this is fixed.
> 
> Signed-off-by: Grant Grundler <grundler@chromium.org>

Reviewed-by: Hayes Wang <hayeswang@realtek.com>

Best Regards,
Hayes

