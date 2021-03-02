Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305BE32B3C3
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1576079AbhCCEF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581882AbhCBT23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 14:28:29 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4261CC061788;
        Tue,  2 Mar 2021 11:27:47 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DqnD32Fqfz1rvxr;
        Tue,  2 Mar 2021 20:25:52 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DqnD01Pyvz1qwjl;
        Tue,  2 Mar 2021 20:25:52 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id cgdcMnRzD3HI; Tue,  2 Mar 2021 20:25:50 +0100 (CET)
X-Auth-Info: PuXIev8z3GrAlFtwE2wNXw8ehidMZTw3YtY26thEaug=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  2 Mar 2021 20:25:50 +0100 (CET)
Subject: Re: [PATCH AUTOSEL 5.10 050/217] rsi: Fix TX EAPOL packet handling
 against iwlwifi AP
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20201223021626.2790791-1-sashal@kernel.org>
 <20201223021626.2790791-50-sashal@kernel.org>
From:   Marek Vasut <marex@denx.de>
Message-ID: <68699f8a-2fcd-3b3d-f809-afa54790e9f9@denx.de>
Date:   Tue, 2 Mar 2021 20:25:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20201223021626.2790791-50-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/23/20 3:13 AM, Sasha Levin wrote:

Hello Sasha,

> From: Marek Vasut <marex@denx.de>
> 
> [ Upstream commit 65277100caa2f2c62b6f3c4648b90d6f0435f3bc ]
> 
> In case RSI9116 SDIO WiFi operates in STA mode against Intel 9260 in AP mode,
> the association fails. The former is using wpa_supplicant during association,
> the later is set up using hostapd:

[...]

Was this patch possibly missed from 5.10.y ?

Also, while at it, I think it might make sense to pick the following two 
patches as well, they dramatically reduce interrupt rate of the RSI WiFi 
device, so it stops overloading lower-end devices:
287431463e786 ("rsi: Move card interrupt handling to RX thread")
abd131a19f6b8 ("rsi: Clean up loop in the interrupt handler")
