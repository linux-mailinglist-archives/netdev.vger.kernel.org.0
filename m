Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC6E1048C7
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 04:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfKUDAF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 Nov 2019 22:00:05 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:53553 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKUDAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 22:00:05 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID xAL301fA010231, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id xAL301fA010231
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 21 Nov 2019 11:00:01 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Thu, 21 Nov 2019 11:00:01 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 21 Nov 2019 11:00:00 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::f0a5:1a8b:cf45:7112]) by
 RTEXMB04.realtek.com.tw ([fe80::f0a5:1a8b:cf45:7112%4]) with mapi id
 15.01.1779.005; Thu, 21 Nov 2019 11:00:00 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Prashant Malani <pmalani@chromium.org>
CC:     "grundler@chromium.org" <grundler@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net] r8152: Re-order napi_disable in rtl8152_close
Thread-Topic: [PATCH net] r8152: Re-order napi_disable in rtl8152_close
Thread-Index: AQHVn9p0kCKKsPhQEkqnVEj6cHKxFKeU6+kA
Date:   Thu, 21 Nov 2019 03:00:00 +0000
Message-ID: <2b96129da21d412f8780325e6be95c9d@realtek.com>
References: <20191120194020.8796-1-pmalani@chromium.org>
In-Reply-To: <20191120194020.8796-1-pmalani@chromium.org>
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

Prashant Malani [mailto:pmalani@chromium.org]
> Sent: Thursday, November 21, 2019 3:40 AM
[...]
> @@ -4283,10 +4283,10 @@ static int rtl8152_close(struct net_device
> *netdev)
>  	unregister_pm_notifier(&tp->pm_notifier);
>  #endif
>  	tasklet_disable(&tp->tx_tl);

Should tasklet_disable() be moved, too?

> -	napi_disable(&tp->napi);
>  	clear_bit(WORK_ENABLE, &tp->flags);
>  	usb_kill_urb(tp->intr_urb);
>  	cancel_delayed_work_sync(&tp->schedule);
> +	napi_disable(&tp->napi);
>  	netif_stop_queue(netdev);

Best Regards,
Hayes


