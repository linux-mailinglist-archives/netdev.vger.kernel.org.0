Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B9F4870C3
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 03:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345571AbiAGCun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 21:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344814AbiAGCum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 21:50:42 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0A1C061245;
        Thu,  6 Jan 2022 18:50:42 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id A6A7E4388F;
        Fri,  7 Jan 2022 02:50:22 +0000 (UTC)
Message-ID: <e2ac1706-6471-0188-00d8-1c68735d24f7@marcan.st>
Date:   Fri, 7 Jan 2022 11:50:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 06/35] brcmfmac: firmware: Support passing in multiple
 board_types
Content-Language: en-US
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
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
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-7-marcan@marcan.st>
 <CAHp75VcXgVTZhPiPmbpAJr21xUopRXU6yi=wvyzs6ByR8C+rzw@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <CAHp75VcXgVTZhPiPmbpAJr21xUopRXU6yi=wvyzs6ByR8C+rzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/04 20:28, Andy Shevchenko wrote:
> On Tue, Jan 4, 2022 at 9:28 AM Hector Martin <marcan@marcan.st> wrote:
>>
>> In order to make use of the multiple alt_path functionality, change
>> board_type to an array. Bus drivers can pass in a NULL-terminated list
>> of board type strings to try for the firmware fetch.
> 
>> +               /* strip extension at the end */
>> +               strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
>> +               alt_path[suffix - path] = 0;
>>
>> -       alt_paths[0] = kstrdup(alt_path, GFP_KERNEL);
>> +               strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);
>> +               strlcat(alt_path, board_types[i], BRCMF_FW_NAME_LEN);
>> +               strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
>> +
>> +               alt_paths[i] = kstrdup(alt_path, GFP_KERNEL);
>> +               brcmf_dbg(TRACE, "FW alt path: %s\n", alt_paths[i]);
> 
> Consider replacing these string manipulations with kasprintf().
> 

Done, thanks!

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
