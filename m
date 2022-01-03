Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D25F482E53
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 06:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiACFwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 00:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiACFwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 00:52:06 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395F2C061761;
        Sun,  2 Jan 2022 21:52:06 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id B400342528;
        Mon,  3 Jan 2022 05:51:55 +0000 (UTC)
Message-ID: <46c09b62-d50f-fd2e-3eb4-ed4b643eef4a@marcan.st>
Date:   Mon, 3 Jan 2022 14:51:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 07/34] brcmfmac: pcie: Read Apple OTP information
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-8-marcan@marcan.st>
 <CACRpkdbyFr-ZQuKOtx4+RRRBddmPGGUTY0j2VvT_7KxRBEQzNQ@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <CACRpkdbyFr-ZQuKOtx4+RRRBddmPGGUTY0j2VvT_7KxRBEQzNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/02 14:38, Linus Walleij wrote:
> On Sun, Dec 26, 2021 at 4:37 PM Hector Martin <marcan@marcan.st> wrote:
> 
>> On Apple platforms, the One Time Programmable ROM in the Broadcom chips
>> contains information about the specific board design (module, vendor,
>> version) that is required to select the correct NVRAM file. Parse this
>> OTP ROM and extract the required strings.
>>
>> Note that the user OTP offset/size is per-chip. This patch does not add
>> any chips yet.
>>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
> 
> Overall looks fine!
> 
>> +       const char *chip_params;
>> +       const char *module_params;
> 
> This variable name "module_params" is a bit confusing since loadable
> kernel modules have params...
> 
> Can we think of another name and just put a comment that this
> refers to the WiFi module building block?
> 
> Sometimes people talk about SoM:s (system-on-modules), so
> maybe som_params or brcm_som_params?
> 
> Yours,
> Linus Walleij
> 

How about board_params, since we're already calling those things boards
elsewhere in the driver? That could refer to the board of a standalone
module, or an integrated board, which should cover all cases.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
