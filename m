Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04166647D2A
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 06:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLIFN6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 9 Dec 2022 00:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIFN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 00:13:57 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27D5B87417;
        Thu,  8 Dec 2022 21:13:52 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2B95B1n44016358, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2B95B1n44016358
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 9 Dec 2022 13:11:01 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Fri, 9 Dec 2022 13:11:48 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 9 Dec 2022 13:11:48 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Fri, 9 Dec 2022 13:11:48 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Li Zetao <lizetao1@huawei.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtlwifi: rtl8821ae: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()
Thread-Topic: [PATCH] rtlwifi: rtl8821ae: Fix global-out-of-bounds bug in
 _rtl8812ae_phy_set_txpower_limit()
Thread-Index: AQHZCkbbXqqj5E4pa0em0g/eG4ORkq5lAS7w
Date:   Fri, 9 Dec 2022 05:11:48 +0000
Message-ID: <e985ead3ea7841b8b3a94201dfb18776@realtek.com>
References: <20221207152319.3135500-1-lizetao1@huawei.com>
In-Reply-To: <20221207152319.3135500-1-lizetao1@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/9_=3F=3F_02:22:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Li Zetao <lizetao1@huawei.com>
> Sent: Wednesday, December 7, 2022 11:23 PM
> To: Ping-Ke Shih <pkshih@realtek.com>; kvalo@kernel.org; davem@davemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com
> Cc: lizetao1@huawei.com; Larry.Finger@lwfinger.net; linville@tuxdriver.com;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] rtlwifi: rtl8821ae: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()
> 
> There is a global-out-of-bounds reported by KASAN:
> 
>   BUG: KASAN: global-out-of-bounds in
>   _rtl8812ae_eq_n_byte.part.0+0x3d/0x84 [rtl8821ae]
>   Read of size 1 at addr ffffffffa0773c43 by task NetworkManager/411
> 
>   CPU: 6 PID: 411 Comm: NetworkManager Tainted: G      D
>   6.1.0-rc8+ #144 e15588508517267d37
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
>   Call Trace:
>    <TASK>
>    ...
>    kasan_report+0xbb/0x1c0
>    _rtl8812ae_eq_n_byte.part.0+0x3d/0x84 [rtl8821ae]
>    rtl8821ae_phy_bb_config.cold+0x346/0x641 [rtl8821ae]
>    rtl8821ae_hw_init+0x1f5e/0x79b0 [rtl8821ae]
>    ...
>    </TASK>
> 
> The root cause of the problem is that the comparison order of
> "prate_section" in _rtl8812ae_phy_set_txpower_limit() is wrong. The
> _rtl8812ae_eq_n_byte() is used to compare the first n bytes of the two
> strings, so this requires the length of the two strings be greater
> than or equal to n. In the  _rtl8812ae_phy_set_txpower_limit(), it was
> originally intended to meet this requirement by carefully designing
> the comparison order. For example, "pregulation" and "pbandwidth" are
> compared in order of length from small to large, first is 3 and last
> is 4. However, the comparison order of "prate_section" dose not obey
> such order requirement, therefore when "prate_section" is "HT", it will
> lead to access out of bounds in _rtl8812ae_eq_n_byte().
> 
> Fix it by adding a length check in _rtl8812ae_eq_n_byte(). Although it
> can be fixed by adjusting the comparison order of "prate_section", this
> may cause the value of "rate_section" to not be from 0 to 5. In
> addition, commit "21e4b0726dc6" not only moved driver from staging to
> regular tree, but also added setting txpower limit function during the
> driver config phase, so the problem was introduced by this commit.
> 
> Fixes: 21e4b0726dc6 ("rtlwifi: rtl8821ae: Move driver from staging to regular tree")
> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
> b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
> index a29321e2fa72..720114a9ddb2 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
> @@ -1600,7 +1600,7 @@ static bool _rtl8812ae_get_integer_from_string(const char *str, u8 *pint)
> 
>  static bool _rtl8812ae_eq_n_byte(const char *str1, const char *str2, u32 num)
>  {

This can causes problem because it compares characters from tail to head, and
we can't simply replace this by strncmp() that does similar work. But, I also
don't like strlen() to loop 'str1' constantly.

How about having a simple loop to compare characters forward:

for (i = 0; i < num; i++)
    if (str1[i] != str2[i])
         return false;

return true;

> -	if (num == 0)
> +	if (num == 0 || strlen(str1) < num)
>  		return false;
>  	while (num > 0) {
>  		num--;
> --
> 2.31.1
> 
> 
> ------Please consider the environment before printing this e-mail.
