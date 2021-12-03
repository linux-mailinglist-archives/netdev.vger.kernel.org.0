Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253A54672FA
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 08:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379066AbhLCIA4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Dec 2021 03:00:56 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:35191 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350800AbhLCIAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 03:00:52 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1B37v91y9000601, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1B37v91y9000601
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 3 Dec 2021 15:57:09 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 3 Dec 2021 15:57:09 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 3 Dec 2021 15:57:09 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::f915:ec6f:35f1:6b04]) by
 RTEXMBS04.realtek.com.tw ([fe80::f915:ec6f:35f1:6b04%5]) with mapi id
 15.01.2308.015; Fri, 3 Dec 2021 15:57:09 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [RFC PATCH 0/4] r8169: support dash
Thread-Topic: [RFC PATCH 0/4] r8169: support dash
Thread-Index: AQHX5QnDLn6ABzzmpEe3dMh4ox9UtKwaRZuAgAKrunD//4AsAIAD8ppQ
Date:   Fri, 3 Dec 2021 07:57:08 +0000
Message-ID: <d3a1e1c469844aa697d6d315c9549eda@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
        <20211129095947.547a765f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <918d75ea873a453ab2ba588a35d66ab6@realtek.com>
 <20211130190926.7c1d735d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211130190926.7c1d735d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/12/3_=3F=3F_06:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 1, 2021 11:09 AM
[...]
> I'm not sure how relevant it will be to you but this is the
> documentation we have:
> 
> https://www.kernel.org/doc/html/latest/networking/devlink/index.html
> https://www.kernel.org/doc/html/latest/networking/devlink/devlink-params.ht
> ml
> 
> You'll need to add a generic parameter (define + a short description)
> like 325e0d0aa683 ("devlink: Add 'enable_iwarp' generic device param")
> 
> In terms of driver changes I think the most relevant example to you
> will be:
> 
> drivers/net/ethernet/ti/cpsw_new.c
> 
> You need to call devlink_alloc(), devlink_register and
> devlink_params_register() (and the inverse functions).

I have studied the devlink briefly.

However, I find some problems. First, our
settings are dependent on the design of
both the hardware and firmware. That is,
I don't think the others need to do the
settings as the same as us. The devlink
seems to let everyone could use the same
command to do the same setting. However,
most of our settings are useless for the
other devices.

Second, according to the design of our
CMAC, the application has to read and
write data with variable length from/to
the firmware. Each custom has his own
requests. Therefore, our customs would
get different firmware with different
behavior. Only the application and the
firmware know how to communicate with
each other. The driver only passes the
data between them. Like the Ethernet
driver, it doesn't need to know the
contend of the packet. I could implement
the CMAC through sysfs, but I don't
know how to do by devlink.

In brief, CMAC is our major method to
configure the firmware and get response
from the firmware. Except for certain information,
the other settings are not standard and useless
for the other vendors.

Is the devlink the only method I could use?
Actually, we use IOCTL now. We wish to
convert it to sysfs for upstream driver.

Best Regards,
Hayes

