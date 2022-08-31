Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7705A5A7455
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 05:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiHaDQl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Aug 2022 23:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbiHaDQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 23:16:27 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 987E644567;
        Tue, 30 Aug 2022 20:16:15 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 27V3EQhB4014031, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 27V3EQhB4014031
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 31 Aug 2022 11:14:26 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 31 Aug 2022 11:14:43 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 31 Aug 2022 11:14:43 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97]) by
 RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97%5]) with mapi id
 15.01.2375.007; Wed, 31 Aug 2022 11:14:43 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Sven van Ashbrook <svenva@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>
CC:     Alex Levin <levinale@google.com>,
        Chithra Annegowda <chithraa@google.com>,
        Frank Gorgenyi <frankgor@google.com>,
        Aaron Ma <aaron.ma@canonical.com>,
        David Ober <dober6023@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v1] r8152: allow userland to disable multicast
Thread-Topic: [PATCH net-next v1] r8152: allow userland to disable multicast
Thread-Index: AQHYvC1hOy5hN6sTzkWIgD4dfS/00a3IUksA
Date:   Wed, 31 Aug 2022 03:14:42 +0000
Message-ID: <b94fb55a06cc4ea5aeb32e919e9607a1@realtek.com>
References: <20220830045923.net-next.v1.1.I4fee0ac057083d4f848caf0fa3a9fd466fc374a0@changeid>
In-Reply-To: <20220830045923.net-next.v1.1.I4fee0ac057083d4f848caf0fa3a9fd466fc374a0@changeid>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/8/30_=3F=3F_11:23:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sven van Ashbrook <svenva@chromium.org>
> Sent: Tuesday, August 30, 2022 1:00 PM
[...]
> The rtl8152 driver does not disable multicasting when userspace asks
> it to. For example:
>  $ ifconfig eth0 -multicast -allmulti
>  $ tcpdump -p -i eth0  # will still capture multicast frames
> 
> Fix by clearing the device multicast filter table when multicast and
> allmulti are both unset.
> 
> Tested as follows:
> - Set multicast on eth0 network interface
> - verify that multicast packets are coming in:
>   $ tcpdump -p -i eth0
> - Clear multicast and allmulti on eth0 network interface
> - verify that no more multicast packets are coming in:
>   $ tcpdump -p -i eth0
> 
> Signed-off-by: Sven van Ashbrook <svenva@chromium.org>

Acked-by: Hayes Wang <hayeswang@realtek.com>

Best Regards,
Hayes

