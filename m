Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD98482E72
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 07:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiACGSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 01:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiACGSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 01:18:53 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0C6C061761;
        Sun,  2 Jan 2022 22:18:52 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 9474A42528;
        Mon,  3 Jan 2022 06:18:42 +0000 (UTC)
Message-ID: <3cc2b6a4-51fc-90dd-0540-fbd95f73011d@marcan.st>
Date:   Mon, 3 Jan 2022 15:18:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 03/34] brcmfmac: firmware: Support having multiple alt
 paths
Content-Language: en-US
To:     Dmitry Osipenko <digetx@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-4-marcan@marcan.st>
 <ecb54095-9af9-cf65-53e0-2f42029c1511@gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <ecb54095-9af9-cf65-53e0-2f42029c1511@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/02 15:55, Dmitry Osipenko wrote:
> 26.12.2021 18:35, Hector Martin пишет:
>>  struct brcmf_fw {
>>  	struct device *dev;
>>  	struct brcmf_fw_request *req;
>> +	const char **alt_paths;
> 
>> +	int alt_index;
> ...
>> +static void brcm_free_alt_fw_paths(const char **alt_paths)
>> +{
>> +	int i;
> ...
>>  static int brcmf_fw_request_firmware(const struct firmware **fw,
>>  				     struct brcmf_fw *fwctx)
>>  {
>>  	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
>> -	int ret;
>> +	int ret, i;
> 
> unsigned int
> 

Thanks, changed for v2!

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
