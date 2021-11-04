Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59D9444D08
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 02:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhKDBlu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 3 Nov 2021 21:41:50 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:52367 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbhKDBlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 21:41:50 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1A41cj9H3009888, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1A41cj9H3009888
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 4 Nov 2021 09:38:45 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 4 Nov 2021 09:38:44 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 4 Nov 2021 09:38:44 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::dc53:1026:298b:c584]) by
 RTEXMBS04.realtek.com.tw ([fe80::dc53:1026:298b:c584%5]) with mapi id
 15.01.2308.015; Thu, 4 Nov 2021 09:38:44 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] rtw89: Fix potential dereference of the null pointer sta
Thread-Topic: [PATCH][next] rtw89: Fix potential dereference of the null
 pointer sta
Thread-Index: AQHXwduziBNegQ3KtE6tzEeaYjpkJqvX/pCwgBfOyICAAT/CgIAAIjOAgAGF8cA=
Date:   Thu, 4 Nov 2021 01:38:44 +0000
Message-ID: <25510e071f6c46788bb3348251f9975b@realtek.com>
References: <20211015154530.34356-1-colin.king@canonical.com>
 <9cc681c217a449519aee524b35e6b6bc@realtek.com> <20211102131437.GF2794@kadam>
 <c3de973999ea40cf967ffefe0ee56ed4@realtek.com> <20211103102128.GL2794@kadam>
In-Reply-To: <20211103102128.GL2794@kadam>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/11/3_=3F=3F_11:29:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 11/04/2021 01:15:49
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 167084 [Nov 03 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 465 465 eb31509370142567679dd183ac984a0cb2ee3296
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 11/04/2021 01:18:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Sent: Wednesday, November 3, 2021 6:21 PM
> To: Pkshih <pkshih@realtek.com>
> Cc: Colin King <colin.king@canonical.com>; Kalle Valo <kvalo@codeaurora.org>; David S . Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; linux-wireless@vger.kernel.org;
> netdev@vger.kernel.org; kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH][next] rtw89: Fix potential dereference of the null pointer sta
> 
> On Wed, Nov 03, 2021 at 12:36:17AM +0000, Pkshih wrote:
> 
> > > > > diff --git a/drivers/net/wireless/realtek/rtw89/core.c
> > > > > b/drivers/net/wireless/realtek/rtw89/core.c
> > > > > index 06fb6e5b1b37..26f52a25f545 100644
> > > > > --- a/drivers/net/wireless/realtek/rtw89/core.c
> > > > > +++ b/drivers/net/wireless/realtek/rtw89/core.c
> > > > > @@ -1534,9 +1534,14 @@ static bool rtw89_core_txq_agg_wait(struct rtw89_dev *rtwdev,
> > > > >  {
> > > > >  	struct rtw89_txq *rtwtxq = (struct rtw89_txq *)txq->drv_priv;
> > > > >  	struct ieee80211_sta *sta = txq->sta;
> > > > > -	struct rtw89_sta *rtwsta = (struct rtw89_sta *)sta->drv_priv;
> > > >
> > > > 'sta->drv_priv' is only a pointer, we don't really dereference the
> > > > data right here, so I think this is safe. More, compiler can optimize
> > > > this instruction that reorder it to the place just right before using.
> > > > So, it seems like a false alarm.
> > >
> > > The warning is about "sta" not "sta->priv".  It's not a false positive.
> > >
> > > I have heard discussions about compilers trying to work around these
> > > bugs by re-ordering the code.  Is that an option in GCC?  It's not
> > > something we should rely on, but I'm just curious if it exists in
> > > released versions.
> > >
> >
> > I say GCC does "reorder" the code, because the object codes of following
> > two codes are identical with default or -Os ccflags.
> 
> Huh...  That's cool.  GCC doesn't re-order it for me, but I'm on GCC 8
> so maybe it will work when I get to a more modern version.
> 

My GCC is 9.3.0. 
But, I don't try other versions.

--
Ping-Ke

