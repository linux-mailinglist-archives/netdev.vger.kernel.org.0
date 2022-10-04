Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9695F3C8C
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 07:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJDFxB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Oct 2022 01:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJDFxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 01:53:00 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75A971658B
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 22:52:55 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2945qAbS5032216, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2945qAbS5032216
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 4 Oct 2022 13:52:10 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 4 Oct 2022 13:52:37 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 4 Oct 2022 13:52:36 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2]) by
 RTEXMBS04.realtek.com.tw ([fe80::402d:f52e:eaf0:28a2%5]) with mapi id
 15.01.2375.007; Tue, 4 Oct 2022 13:52:36 +0800
From:   Hau <hau@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "grundler@chromium.org" <grundler@chromium.org>
Subject: RE: [PATCH net-next] r8169: fix rtl8125b dmar pte write access not set error
Thread-Topic: [PATCH net-next] r8169: fix rtl8125b dmar pte write access not
 set error
Thread-Index: AQHY1vPf7s+Qc5TA+Uy+C5kxA/yuuq381hYAgADmvuA=
Date:   Tue, 4 Oct 2022 05:52:36 +0000
Message-ID: <cbd0418859b74e2581598395fcf773f6@realtek.com>
References: <20221003064620.28194-1-hau@realtek.com>
 <20221003170546.1b9ca44f@kernel.org>
In-Reply-To: <20221003170546.1b9ca44f@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/10/4_=3F=3F_03:52:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, 3 Oct 2022 14:46:20 +0800 Chunhao Lin wrote:
> > When close device, rx will be enabled if wol is enabeld. When open
> > device it will cause rx to dma to wrong address after pci_set_master().
> >
> > In this patch, driver will disable tx/rx when close device. If wol is
> > eanbled only enable rx filter and disable rxdv_gate to let hardware
> > can receive packet to fifo but not to dma it.
> 
> Sounds like a fix, could you resend with a Fixes tag and [PATCH net]
> designation? net-next is for new features and refactoring, net for fixes.

I will resend this patch to [PATCH net]. Thanks.

>  ------Please consider the environment before printing this e-mail.
