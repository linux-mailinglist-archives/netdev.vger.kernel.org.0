Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C54D687511
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjBBFZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBBFZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:25:29 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBE179C8A;
        Wed,  1 Feb 2023 21:25:26 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 4F980420CF;
        Thu,  2 Feb 2023 05:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1675315524; bh=quxyhSe0FeVvGcqkw4T8hy/z9545s1zKRXcY3IGMuzs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=QDPtVfdb9reZ5mrUq0DE15jyyOvLL35VbpgEt5mECvGKwzJ/enzdD8bxz73FKYnkS
         UQLt2dpXu9ERK8E3LOq7hLSU2a4QTWv7h56/4xp/6doFhQKSO9F00cx7Cn9vt2A70q
         OkVOjSrhFfBeNwwSuYglPGnjdb0xJNbYeV/zMMYVXVF/Sg/4aTgLk+gRO1qWfEE34w
         2LpHQEMNNMVehm94aGAKx30/2EEyjIwdkceGXaujE2reU3jEoZMCH2EEMeWmZr+1X/
         2vsOw907IPxybcPn4cMIixNZrPN5ou/YVZ99fdHOCF+jeGfeX3TbRYZfVRlHdSoFAI
         w/U8SWrWQd/Vg==
Message-ID: <4fb4af22-d115-de62-3bda-c1ae02e097ee@marcan.st>
Date:   Thu, 2 Feb 2023 14:25:15 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 1/5] brcmfmac: Drop all the RAW device IDs
Content-Language: en-US
To:     Jonas Gorski <jonas.gorski@gmail.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Prutskov <alep@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Soontak Lee <soontak.lee@cypress.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Aditya Garg <gargaditya08@live.com>, asahi@lists.linux.dev,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Hauke Mehrtens <hauke@hauke-m.de>
References: <20230131112840.14017-1-marcan@marcan.st>
 <20230131112840.14017-2-marcan@marcan.st>
 <CAOiHx=mYxFx0kr5s=4X_qywZBpPqCbrNjLnTXfigPOnqZSxjag@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <CAOiHx=mYxFx0kr5s=4X_qywZBpPqCbrNjLnTXfigPOnqZSxjag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/01/2023 23.17, Jonas Gorski wrote:
> On Tue, 31 Jan 2023 at 12:36, Hector Martin <marcan@marcan.st> wrote:
>>
>> These device IDs are only supposed to be visible internally, in devices
>> without a proper OTP. They should never be seen in devices in the wild,
>> so drop them to avoid confusion.
> 
> I think these can still show up in embedded platforms where the
> OTP/SPROM is provided on-flash.
> 
> E.g. https://forum.archive.openwrt.org/viewtopic.php?id=55367&p=4
> shows this bootlog on an BCM4709A0 router with two BCM43602 wifis:
> 
> [    3.237132] pci 0000:01:00.0: [14e4:aa52] type 00 class 0x028000
> [    3.237174] pci 0000:01:00.0: reg 0x10: [mem 0x00000000-0x00007fff 64bit]
> [    3.237199] pci 0000:01:00.0: reg 0x18: [mem 0x00000000-0x003fffff 64bit]
> [    3.237302] pci 0000:01:00.0: supports D1 D2
> ...
> [    3.782384] pci 0001:03:00.0: [14e4:aa52] type 00 class 0x028000
> [    3.782440] pci 0001:03:00.0: reg 0x10: [mem 0x00000000-0x00007fff 64bit]
> [    3.782474] pci 0001:03:00.0: reg 0x18: [mem 0x00000000-0x003fffff 64bit]
> [    3.782649] pci 0001:03:00.0: supports D1 D2
> 
> 0xaa52 == 43602 (BRCM_PCIE_43602_RAW_DEVICE_ID)
> 
> Rafał can probably provide more info there.
> 
> Regards
> Jonas
> 

Arend, any comments on these platforms?

- Hector
