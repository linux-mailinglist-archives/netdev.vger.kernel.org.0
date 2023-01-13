Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCF4C669E25
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjAMQaP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 13 Jan 2023 11:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjAMQ3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:29:06 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ACE9482F5C
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 08:23:57 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 30DGMlJyA017610, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 30DGMlJyA017610
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Sat, 14 Jan 2023 00:22:47 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Sat, 14 Jan 2023 00:23:46 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Sat, 14 Jan 2023 00:23:45 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Sat, 14 Jan 2023 00:23:45 +0800
From:   Hau <hau@realtek.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net] r8169: fix rtl8168h wol fail
Thread-Topic: [PATCH net] r8169: fix rtl8168h wol fail
Thread-Index: AQHZITAeQEw7+pbiWEKyObvpj0H4U66PsbSAgAAedICAARt84IAASKWAgAayTHD//86LgIABruOg//+8sACAACFVAIADUFuA
Date:   Fri, 13 Jan 2023 16:23:45 +0000
Message-ID: <d34e9d2f3a0d4ae8988d39b865de987b@realtek.com>
References: <20230105180408.2998-1-hau@realtek.com>
 <714782c5-b955-4511-23c0-9688224bba84@gmail.com> <Y7dAbxSPeaMnW/ly@lunn.ch>
 <9ee2f626bab3481697b71c58091e7def@realtek.com>
 <4014d243-8f8a-f273-fba8-2ae5a3844ea5@gmail.com>
 <6ff876a66e154bb4b357b31465c86741@realtek.com>
 <d28834dc-0426-5813-a24d-181839f23c38@gmail.com>
 <add32dc486bb4fc9abc283b2bb39efc3@realtek.com>
 <e201750b-f3be-b62d-4dc6-2a00f4834256@gmail.com> <Y78ssmMck/eZTpYz@lunn.ch>
In-Reply-To: <Y78ssmMck/eZTpYz@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.228.56]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/1/13_=3F=3F_02:39:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >>> In this application(rtl8168h + rtl8211fs) it also supports 100Mbps
> > >>> fiber
> > >> module.
> > >>
> > >> Does RTL8211FS advertise 100Mbps and 1Gbps on the UTP/MDI side in
> > >> case of a 100Mbps fiber module?
> > > Yes.
> > >
> > I think in this case internal PHY and RTL8211FS would negotiate 1Gbps,
> > not matching the speed of the 100Mbps fiber module.
> > How does this work?

My mistake. With 100Mbps fiber module RTL8211FS will only advertise 100Mbps
on the UTP/MDI side. With 1Gbps fiber module it will advertise both 100Mbps and
1Gbps. So issue will only happen with 1Gbps fiber module.

> Fibre line side has no autoneg. Both ends need to be using the same speed,
> or the SERDES does not synchronise and does not establish link.
> 
> You can ask the SFP module what baud rate it supports, and then use
> anything up to that baud rate. I've got systems where the SFP is fast enough
> to support a 2.5Gbps link, so the MAC indicates both 2.5G and 1G, defaults to
> 2.5G, and fails to connect to a 1G link peer. You need to use ethtool to force
> it to the lower speed before the link works.
> 
> But from what i understand, you cannot use a 1000Base-X SFP, set the MAC
> to 100Mbps, and expect it to connect to a 100Base-FX SFP. So for me, the
> RTL8211FS should not be advertise 100Mbps and 1Gbps, it needs to talk to
> the SFP figure out exactly what it is, and only advertise the one mode which
> is supported.

It is the RTL8211FS firmware bug. This patch is for workaround this issue.

 ------Please consider the environment before printing this e-mail.
