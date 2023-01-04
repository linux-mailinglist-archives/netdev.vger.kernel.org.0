Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A4665DF06
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 22:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240436AbjADV20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 16:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbjADV2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 16:28:06 -0500
X-Greylist: delayed 4499 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 04 Jan 2023 13:21:44 PST
Received: from mail.schwarz.eu (eight.schwarz.eu [IPv6:2a01:4f8:c17:2a56::8:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C066F4103F;
        Wed,  4 Jan 2023 13:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=oss.schwarz.eu; s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2stL7la/beV9vnoj3SG39DjOHPT+hbqJVKK5Y2G6Ges=; b=q6HFpblNkfVMedDg16XKDDIBW0
        vLDQp3IgtN1rA311usT6MI8j1e3EQix1PMCHgh6ze+ttuzvnhtJoXRv2n2UiriYZQq9bZVo/iwOu5
        5t7t5JasM0r8ZsvLz3lEKA8GjpjQUTNKLcSE61hh1NSxbs3bepmeww1CVqusrta1tLWDbHf+yeVef
        u7uVxpxASbOBdYOIbG5E/PdK+Xg+wlhz8VtIaDQOohLVd4E6V9O9POFQxf8NHahvQU5d+iRL4IjVh
        ig6xq6yVwXUOUs0MENbywUGdgGljUQ7pMfjfuM4d5XRdsrZzXg2qb8yymsRzDZi6ywAxqJ5S8vOdP
        txCYWyzg==;
Message-ID: <37a19225-7f34-e1f1-666f-5d08e6c1ec15@oss.schwarz.eu>
Date:   Wed, 4 Jan 2023 21:06:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC PATCH v1 19/19] rtw88: Add support for the SDIO based
 RTL8821CS chipset
To:     Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        Chris Morgan <macroalpha82@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-20-martin.blumenstingl@googlemail.com>
 <63b4b3e1.050a0220.791fb.767c@mx.google.com>
 <0acf173d-a425-dcca-ad2f-f0f0f13a9f5e@gmail.com>
Content-Language: en-US
From:   Felix Schwarz <felix.schwarz@oss.schwarz.eu>
In-Reply-To: <0acf173d-a425-dcca-ad2f-f0f0f13a9f5e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received: by mail.schwarz.eu with esmtpsa (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.96)
        (envelope-from <felix.schwarz@oss.schwarz.eu>)
        id 1pDA25-0007qQ-2z; Wed, 04 Jan 2023 22:21:42 +0100
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 04.01.23 um 20:59 schrieb Bitterblue Smith:
> The USB-based RTL8811CU also doesn't work, with suspiciously similar
> errors:
> 
> Dec 25 21:43:37 home kernel: rtw_8821cu 1-2:1.0: Firmware version 24.11.0, H2C version 12
> Dec 25 21:43:37 home kernel: rtw_8821cu 1-2:1.0 wlp0s20f0u2: renamed from wlan0
> Dec 25 21:43:40 home kernel: rtw_8821cu 1-2:1.0: read register 0x5 failed with -110
> Dec 25 21:43:41 home kernel: rtw_8821cu 1-2:1.0: read register 0x20 failed with -110
> Dec 25 21:44:11 home kernel: rtw_8821cu 1-2:1.0: write register 0x20 failed with -110
> Dec 25 21:44:12 home kernel: rtw_8821cu 1-2:1.0: read register 0x7c failed with -110
> Dec 25 21:44:43 home kernel: rtw_8821cu 1-2:1.0: write register 0x7c failed with -110
> Dec 25 21:44:44 home kernel: rtw_8821cu 1-2:1.0: read register 0x1080 failed with -110
> Dec 25 21:45:16 home kernel: rtw_8821cu 1-2:1.0: write register 0x1080 failed with -110

Same for me: I saw very similar read/write failures with my "Realtek 
Semiconductor Corp. 802.11ac NIC" (ID 0bda:c811) after applying Ping-Ke's patch 
for rfe 38 (see my message to linux-wireless on Dec 29).

Felix

