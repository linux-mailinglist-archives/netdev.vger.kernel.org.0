Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64446EECF1
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 06:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbjDZE3R convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Apr 2023 00:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239023AbjDZE3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 00:29:16 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5C11FFC;
        Tue, 25 Apr 2023 21:29:13 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 33Q4SfBwA028953, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 33Q4SfBwA028953
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 26 Apr 2023 12:28:41 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 26 Apr 2023 12:28:43 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 26 Apr 2023 12:28:43 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d]) by
 RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d%5]) with mapi id
 15.01.2375.007; Wed, 26 Apr 2023 12:28:43 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Zhang Shurong <zhang_shurong@foxmail.com>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] wifi: rtw88: fix incorrect error codes in rtw_debugfs_copy_from_user
Thread-Topic: [PATCH v2 1/2] wifi: rtw88: fix incorrect error codes in
 rtw_debugfs_copy_from_user
Thread-Index: AQHZd5JwMo0jajhBZEqbv0oa4rkPjK88/+ug
Date:   Wed, 26 Apr 2023 04:28:43 +0000
Message-ID: <9c3ddb61020749d4811053e25c949b05@realtek.com>
References: <cover.1682438257.git.zhang_shurong@foxmail.com>
 <tencent_8BA35E4B9CDF40D4AE6D8D831D7ACC28A00A@qq.com>
In-Reply-To: <tencent_8BA35E4B9CDF40D4AE6D8D831D7ACC28A00A@qq.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Zhang Shurong <zhang_shurong@foxmail.com>
> Sent: Wednesday, April 26, 2023 12:24 AM
> To: tony0620emma@gmail.com
> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Zhang Shurong
> <zhang_shurong@foxmail.com>
> Subject: [PATCH v2 1/2] wifi: rtw88: fix incorrect error codes in rtw_debugfs_copy_from_user
> 
> If there is a failure during copy_from_user, rtw_debugfs_copy_from_user
> should return negative error code instead of a positive value count.
> 
> Fix this bug by returning correct error code. Moreover, the check
> of buffer against null is removed since it will be handled by
> copy_from_user.
> 
> Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw88/debug.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
> index fa3d73b333ba..3da477e1ebd3 100644
> --- a/drivers/net/wireless/realtek/rtw88/debug.c
> +++ b/drivers/net/wireless/realtek/rtw88/debug.c
> @@ -183,8 +183,8 @@ static int rtw_debugfs_copy_from_user(char tmp[], int size,
> 
>         tmp_len = (count > size - 1 ? size - 1 : count);
> 
> -       if (!buffer || copy_from_user(tmp, buffer, tmp_len))
> -               return count;
> +       if (copy_from_user(tmp, buffer, tmp_len))
> +               return -EFAULT;
> 
>         tmp[tmp_len] = '\0';
> 
> --
> 2.40.0

