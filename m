Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80B3D64060
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfGJFHo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 10 Jul 2019 01:07:44 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:37513 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfGJFHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 01:07:44 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x6A57QYq030900, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x6A57QYq030900
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 10 Jul 2019 13:07:27 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0439.000; Wed, 10 Jul 2019 13:07:26 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Huang <tehuang@realtek.com>
Subject: RE: [PATCH 09/12] rtw88: Fix misuse of GENMASK macro
Thread-Topic: [PATCH 09/12] rtw88: Fix misuse of GENMASK macro
Thread-Index: AQHVNt0EKBOEadT3XU2T7xXrxoiWeabDTLwA
Date:   Wed, 10 Jul 2019 05:07:26 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D18644DC@RTITMBSVM04.realtek.com.tw>
References: <cover.1562734889.git.joe@perches.com>
 <0de52d891d7925b02f4f0fe2c750d076e55434d9.1562734889.git.joe@perches.com>
In-Reply-To: <0de52d891d7925b02f4f0fe2c750d076e55434d9.1562734889.git.joe@perches.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH 09/12] rtw88: Fix misuse of GENMASK macro
> 
> Arguments are supposed to be ordered high then low.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8822b.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
> b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
> index 1172f6c0605b..d61d534396c7 100644
> --- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
> @@ -997,7 +997,7 @@ static void rtw8822b_do_iqk(struct rtw_dev *rtwdev)
>  	rtw_write_rf(rtwdev, RF_PATH_A, RF_DTXLOK, RFREG_MASK, 0x0);
> 
>  	reload = !!rtw_read32_mask(rtwdev, REG_IQKFAILMSK, BIT(16));
> -	iqk_fail_mask = rtw_read32_mask(rtwdev, REG_IQKFAILMSK,
> GENMASK(0, 7));
> +	iqk_fail_mask = rtw_read32_mask(rtwdev, REG_IQKFAILMSK,
> GENMASK(7, 0));
>  	rtw_dbg(rtwdev, RTW_DBG_PHY,
>  		"iqk counter=%d reload=%d do_iqk_cnt=%d
> n_iqk_fail(mask)=0x%02x\n",
>  		counter, reload, ++do_iqk_cnt, iqk_fail_mask);
> --

That's correct. Thanks.

Acked-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

Yan-Hsuan
