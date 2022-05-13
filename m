Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A963525A24
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 05:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376762AbiEMDcB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 May 2022 23:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376767AbiEMDb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 23:31:59 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBA062235
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 20:31:56 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24D3VZptC000965, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24D3VZptC000965
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 May 2022 11:31:35 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 13 May 2022 11:31:35 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 12 May 2022 20:31:34 -0700
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Fri, 13 May 2022 11:31:34 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Kyle Pelton <kyle.d.pelton@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "aaron.ma@canonical.com" <aaron.ma@canonical.com>
CC:     nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH] net: usb: r8152: Set default WOL options
Thread-Topic: [PATCH] net: usb: r8152: Set default WOL options
Thread-Index: AQHYZkpPKiGJG2BZTkmqDZgLiX5Z+q0cHwyg
Date:   Fri, 13 May 2022 03:31:33 +0000
Message-ID: <f7cf50af1f524b96abc11e7317e73837@realtek.com>
References: <20220512215013.230647-1-kyle.d.pelton@linux.intel.com>
In-Reply-To: <20220512215013.230647-1-kyle.d.pelton@linux.intel.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/5/12_=3F=3F_10:59:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kyle Pelton <kyle.d.pelton@linux.intel.com>
> Sent: Friday, May 13, 2022 5:50 AM
[...]
>  #define WAKE_ANY (WAKE_PHY | WAKE_MAGIC | WAKE_UCAST |
> WAKE_BCAST | WAKE_MCAST)
> +#define WAKE_DEFAULT (WAKE_PHY << 5)

I think the (WAKE_PHY << 5) is equal to WAKE_MAGIC.

>  static u32 __rtl_get_wol(struct r8152 *tp)
>  {
> @@ -9717,10 +9718,12 @@ static int rtl8152_probe(struct usb_interface *intf,
> 
>  	intf->needs_remote_wakeup = 1;
> 
> -	if (!rtl_can_wakeup(tp))
> +	if (!rtl_can_wakeup(tp)) {
>  		__rtl_set_wol(tp, 0);
> -	else
> +	} else {
> +		__rtl_set_wol(tp, WAKE_DEFAULT);
>  		tp->saved_wolopts = __rtl_get_wol(tp);

I think it is better to set tp->saved_wolopts = WAKE_MAGIC. Besides,
add rtl_runtime_suspend_enable(tp, false) in r8152b_init() as same
as r8153_init(), r8153b_init(), and so on. You don't need
__rtl_set_wol() here.

> +	}
> 
>  	tp->rtl_ops.init(tp);
>  #if IS_BUILTIN(CONFIG_USB_RTL8152)


Best Regards,
Hayes

