Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E42647EC66
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 08:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351694AbhLXHDn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Dec 2021 02:03:43 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:60278 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241350AbhLXHDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 02:03:43 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BO73VcH4019093, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BO73VcH4019093
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 Dec 2021 15:03:31 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 24 Dec 2021 15:03:30 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 23:03:30 -0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Fri, 24 Dec 2021 15:03:30 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Yu-Tung Chang <mtwget@gmail.com>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtw88: add quirk to disable pci caps on HP Slim Desktop S01-pF1000i
Thread-Topic: [PATCH] rtw88: add quirk to disable pci caps on HP Slim Desktop
 S01-pF1000i
Thread-Index: AQHX+JJYMbVqgr50Tke2k9WySEI3LqxBNfwA
Date:   Fri, 24 Dec 2021 07:03:30 +0000
Message-ID: <2e678fa4d9d14a3d892e829bfc7524e6@realtek.com>
References: <20211224064846.1171-1-mtwget@gmail.com>
In-Reply-To: <20211224064846.1171-1-mtwget@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/12/24_=3F=3F_04:02:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Yu-Tung Chang <mtwget@gmail.com>
> Sent: Friday, December 24, 2021 2:49 PM
> To: tony0620emma@gmail.com
> Cc: kvalo@kernel.org; davem@davemloft.net; kuba@kernel.org; linux-wireless@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Yu-Tung Chang <mtwget@gmail.com>
> Subject: [PATCH] rtw88: add quirk to disable pci caps on HP Slim Desktop S01-pF1000i
> 
> 8821CE causes random freezes on HP Slim Desktop S01-pF1000i. Add a quirk
> to disable pci ASPM capability.
> 
> Signed-off-by: Yu-Tung Chang <mtwget@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index a7a6ebfaa203..f8999d7dee61 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -1738,6 +1738,15 @@ static const struct dmi_system_id rtw88_pci_quirks[] = {
>  		},
>  		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
>  	},
> +	{
> +		.callback = disable_pci_caps,
> +		.ident = "HP HP Slim Desktop S01-pF1xxx",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "HP Slim Desktop S01-pF1xxx"),
> +		},
> +		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
> +	},
>  	{}
>  };
> 

A patch [1] is merged to fix freezes of 8821ce.

[1] https://lore.kernel.org/all/20211215114635.333767-1-kai.heng.feng@canonical.com/

--
Ping-Ke

