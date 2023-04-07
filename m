Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428AB6DA8E5
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 08:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238089AbjDGG0A convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 Apr 2023 02:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjDGGZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 02:25:57 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018405B88;
        Thu,  6 Apr 2023 23:25:56 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3376OZFy8005152, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3376OZFy8005152
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Fri, 7 Apr 2023 14:24:35 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Fri, 7 Apr 2023 14:24:20 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 7 Apr 2023 14:24:20 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Fri, 7 Apr 2023 14:24:20 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Douglas Anderson <dianders@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     =?iso-8859-1?Q?Andr=E9_Apitzsch?= <git@apitzsch.eu>,
        =?iso-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        David Ober <dober6023@gmail.com>,
        Jean-Francois Le Fillatre <jflf_kernel@gmx.com>,
        "Sven van Ashbrook" <svenva@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] r8152: Add __GFP_NOWARN to big allocations
Thread-Topic: [PATCH] r8152: Add __GFP_NOWARN to big allocations
Thread-Index: AQHZaOX5MJJBdKWQZ0S+wy/WHuNvFK8fXNhg
Date:   Fri, 7 Apr 2023 06:24:20 +0000
Message-ID: <1922af354f7548f0878821b3f0692640@realtek.com>
References: <20230406171411.1.I84dbef45786af440fd269b71e9436a96a8e7a152@changeid>
In-Reply-To: <20230406171411.1.I84dbef45786af440fd269b71e9436a96a8e7a152@changeid>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.228.6]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Douglas Anderson <dianders@chromium.org>
[...]
> When memory is a little tight on my system, it's pretty easy to see
> warnings that look like this.
> 
>   ksoftirqd/0: page allocation failure: order:3,
> mode:0x40a20(GFP_ATOMIC|__GFP_COMP),
> nodemask=(null),cpuset=/,mems_allowed=0
>   ...
>   Call trace:
>    dump_backtrace+0x0/0x1e8
>    show_stack+0x20/0x2c
>    dump_stack_lvl+0x60/0x78
>    dump_stack+0x18/0x38
>    warn_alloc+0x104/0x174
>    __alloc_pages+0x588/0x67c
>    alloc_rx_agg+0xa0/0x190 [r8152 ...]
>    r8152_poll+0x270/0x760 [r8152 ...]
>    __napi_poll+0x44/0x1ec
>    net_rx_action+0x100/0x300
>    __do_softirq+0xec/0x38c
>    run_ksoftirqd+0x38/0xec
>    smpboot_thread_fn+0xb8/0x248
>    kthread+0x134/0x154
>    ret_from_fork+0x10/0x20
> 
> On a fragmented system it's normal that order 3 allocations will
> sometimes fail, especially atomic ones. The driver handles these
> failures fine and the WARN just creates spam in the logs for this
> case. The __GFP_NOWARN flag is exactly for this situation, so add it
> to the allocation.
> 
> NOTE: my testing is on a 5.15 system, but there should be no reason
> that this would be fundamentally different on a mainline kernel.
> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>

Acked-by: Hayes Wang <hayeswang@realtek.com>

Best Regards,
Hayes

