Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB71472371
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 10:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhLMJEg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Dec 2021 04:04:36 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:49224 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbhLMJEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 04:04:34 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BD94NppC030276, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BD94NppC030276
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Dec 2021 17:04:23 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 17:04:23 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 17:04:23 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Mon, 13 Dec 2021 17:04:23 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Jian-Hong Pan <jhp@endlessos.org>,
        Bernie Huang <phhuang@realtek.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessos.org" <linux@endlessos.org>
Subject: RE: [PATCH] rtw88: pci: turn off PCI ASPM during NAPI polling
Thread-Topic: [PATCH] rtw88: pci: turn off PCI ASPM during NAPI polling
Thread-Index: AQHX7/kQjSc2DLccoUatj4jk7MRPeqwwIE+Q
Date:   Mon, 13 Dec 2021 09:04:22 +0000
Message-ID: <963fc5bc39314dc49faa719b03a79ad4@realtek.com>
References: <20211213080908.80723-1-jhp@endlessos.org>
In-Reply-To: <20211213080908.80723-1-jhp@endlessos.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/12/13_=3F=3F_07:23:00?=
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
> From: Jian-Hong Pan <jhp@endlessos.org>
> Sent: Monday, December 13, 2021 4:09 PM
> To: Pkshih <pkshih@realtek.com>; Bernie Huang <phhuang@realtek.com>; Kai-Heng Feng
> <kai.heng.feng@canonical.com>; Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo
> <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux@endlessos.org; Jian-Hong Pan <jhp@endlessos.org>
> Subject: [PATCH] rtw88: pci: turn off PCI ASPM during NAPI polling
> 
> The system on the machines equipped with RTL8821CE freezes randomly
> until the PCI ASPM is disabled during NAPI poll function.
> 
> Link: https://www.spinics.net/lists/linux-wireless/msg218387.html
> Fixes: 9e2fd29864c5 ("rtw88: add napi support")
> Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index a7a6ebfaa203..a6fdddecd37d 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -1658,6 +1658,7 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
>  					      priv);
>  	int work_done = 0;
> 
> +	rtw_pci_link_ps(rtwdev, false);
>  	while (work_done < budget) {
>  		u32 work_done_once;
> 
> @@ -1681,6 +1682,7 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
>  		if (rtw_pci_get_hw_rx_ring_nr(rtwdev, rtwpci))
>  			napi_schedule(napi);
>  	}
> +	rtw_pci_link_ps(rtwdev, true);
> 
>  	return work_done;
>  }

I think we need to add ref_cnt and only do this thing on specific chip and platform [1].

[1] https://lore.kernel.org/linux-wireless/e78b81f3a73c45b59f4c4d9f5b414508@realtek.com/T/#m95b22af523ea801fdb84225b87a84ca4f04bb33d

--
Ping-Ke

