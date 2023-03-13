Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9825C6B6D7A
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 03:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjCMC3X convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 12 Mar 2023 22:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjCMC3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 22:29:23 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33199279A9;
        Sun, 12 Mar 2023 19:29:18 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32D2SlRdA020761, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32D2SlRdA020761
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 13 Mar 2023 10:28:47 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 13 Mar 2023 10:28:02 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 13 Mar 2023 10:28:01 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 13 Mar 2023 10:28:01 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        "Nitin Gupta" <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH v2 RFC 1/9] wifi: rtw88: Clear RTW_FLAG_POWERON early in rtw_mac_power_switch()
Thread-Topic: [PATCH v2 RFC 1/9] wifi: rtw88: Clear RTW_FLAG_POWERON early in
 rtw_mac_power_switch()
Thread-Index: AQHZU48RHUVrRx5DKki3zO3RS/BQyK73/dpQ
Date:   Mon, 13 Mar 2023 02:28:01 +0000
Message-ID: <14619a051589472292f8270c2c291204@realtek.com>
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
 <20230310202922.2459680-2-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230310202922.2459680-2-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Saturday, March 11, 2023 4:29 AM
> To: linux-wireless@vger.kernel.org
> Cc: Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; Ulf Hansson
> <ulf.hansson@linaro.org>; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> linux-mmc@vger.kernel.org; Chris Morgan <macroalpha82@gmail.com>; Nitin Gupta <nitin.gupta981@gmail.com>;
> Neo Jou <neojou@gmail.com>; Ping-Ke Shih <pkshih@realtek.com>; Jernej Skrabec <jernej.skrabec@gmail.com>;
> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Subject: [PATCH v2 RFC 1/9] wifi: rtw88: Clear RTW_FLAG_POWERON early in rtw_mac_power_switch()
> 
> The SDIO HCI implementation needs to know when the MAC is powered on.
> This is needed because 32-bit register access has to be split into 4x
> 8-bit register access when the MAC is not fully powered on or while
> powering off. When the MAC is powered on 32-bit register access can be
> used to reduce the number of transfers but splitting into 4x 8-bit
> register access still works in that case.
> 
> During the power on sequence is how RTW_FLAG_POWERON is only set when
> the power on sequence has completed successfully. During power off
> however RTW_FLAG_POWERON is set. This means that the upcoming SDIO HCI
> implementation does not know that it has to use 4x 8-bit register
> accessors. Clear the RTW_FLAG_POWERON flag early when powering off the
> MAC so the whole power off sequence is processed with RTW_FLAG_POWERON
> unset. This will make it possible to use the RTW_FLAG_POWERON flag in
> the upcoming SDIO HCI implementation.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> Changes since v1:
> - This replaces a previous patch called "rtw88: hci: Add an optional
>   power_switch() callback to rtw_hci_ops" which added a new callback
>   to the HCI ops.
> 
> 
>  drivers/net/wireless/realtek/rtw88/mac.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
> index f3a566cf979b..cfdfc8a2c836 100644
> --- a/drivers/net/wireless/realtek/rtw88/mac.c
> +++ b/drivers/net/wireless/realtek/rtw88/mac.c
> @@ -273,6 +273,9 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
>         if (pwr_on == cur_pwr)
>                 return -EALREADY;
> 
> +       if (!pwr_on)
> +               clear_bit(RTW_FLAG_POWERON, rtwdev->flags);
> +
>         pwr_seq = pwr_on ? chip->pwr_on_seq : chip->pwr_off_seq;
>         ret = rtw_pwr_seq_parser(rtwdev, pwr_seq);
>         if (ret)

This patch changes the behavior if rtw_pwr_seq_parser() returns error while
doing power-off, but I dig and think further about this case hardware stays in
abnormal state. I think it would be fine to see this state as POWER_OFF.
Do you agree this as well?


> @@ -280,8 +283,6 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
> 
>         if (pwr_on)
>                 set_bit(RTW_FLAG_POWERON, rtwdev->flags);
> -       else
> -               clear_bit(RTW_FLAG_POWERON, rtwdev->flags);
> 
>         return 0;
>  }
> --
> 2.39.2

