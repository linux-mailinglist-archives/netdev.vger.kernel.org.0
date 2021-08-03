Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B055F3DF19B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236897AbhHCPfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236838AbhHCPfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:35:09 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE58C061757;
        Tue,  3 Aug 2021 08:34:58 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id u3so40410003lff.9;
        Tue, 03 Aug 2021 08:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M/noFf4vKzG4qevBTC43NePoxOXVUarwcbqZDfiwD7s=;
        b=TZ0+dcre3ngLoCoXAT2kG3mxmeUynsWA1fBu3vhRDABc772OmQCDEVdCjaQoh6B4h9
         OyzR2pEHoiWjuDTW3jsGmRfZssDQce8eYKr7lnZevXYbWCw21SWQuIERYGRCR0DVmajf
         TeVcnKD2dRBz5u3F/y2aQb7MT8pA3PI/ubrRZ71kS8nmupQ2KzMyMQmtl5yfxLTkgLiV
         T/VNpRExMRuvU76U3E68L1K5zNopNDBVkwiuybyj7fQ+eLWLncfP/EVJ1qz/nFInQE3U
         ml+AQH5t7gMAxi7y1GTq+Ksj5UmzaQ0cqflqUqSLNuiyvnjaqtLWWnhXfo6/2NyRS8Jp
         k/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M/noFf4vKzG4qevBTC43NePoxOXVUarwcbqZDfiwD7s=;
        b=WppYFv+/ghRYCPzetJ/cG2eTfi/RwcCewGPcyuOS1VvjKuDt9ngLahuRf2n73oZObZ
         iSwH9uapM/4wS8PeKDVc2//zrLopsRJbSX8pYRUmDRJGLEb924vVNnSAdu09VPJpfbMR
         fAIbPD6+DeIAWTNYScfij44044sLGQvECVSYCMyVef3LgoE1p11qYoO3H53EetKeoj7v
         fJbdwU1cHMzNPLWIzb5w1UGfjkEi14AjGq2STHjHGy/HnDjuPks92+fivBUEbG/xPjvt
         EbImU4vtdJTbbE2T3oCRNKeZrBTagS4btPecldXLXNPtX28KHHmudV0ZplArbdgv7qUG
         wW1A==
X-Gm-Message-State: AOAM531OTFc5ZqhGOgwCUVZ6tyM2BplAYLUW9L68P70nRX2CSlrbnqxM
        cOA4tZXfncGlVXZKtFSIWejQ1MqPF+c=
X-Google-Smtp-Source: ABdhPJxc1tCGkWbQRcL4Rn7SuUEssYbKcoJ9d+qPT+jZQO1bpCK9giLr9dt5zXbdhgnNhm/0O3O4pA==
X-Received: by 2002:a05:6512:3b94:: with SMTP id g20mr17135908lfv.0.1628004896476;
        Tue, 03 Aug 2021 08:34:56 -0700 (PDT)
Received: from [192.168.2.145] (46-138-51-120.dynamic.spd-mgts.ru. [46.138.51.120])
        by smtp.googlemail.com with ESMTPSA id o11sm1100246ljg.29.2021.08.03.08.34.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 08:34:56 -0700 (PDT)
Subject: Re: [BUG] brcmfmac locks up on resume from suspend
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <b853d145-0edf-db0a-ff42-065011f7a149@gmail.com>
 <0a29dbcc-7ab6-bc5d-3d42-4e1a33c2f6ec@gmail.com>
Message-ID: <8acf609c-7871-3809-6e9f-6df45a72d972@gmail.com>
Date:   Tue, 3 Aug 2021 18:34:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0a29dbcc-7ab6-bc5d-3d42-4e1a33c2f6ec@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

22.06.2021 20:04, Dmitry Osipenko пишет:
> 18.06.2021 23:36, Dmitry Osipenko пишет:
>> Hi,
>>
>> I'm getting a hang on resume from suspend using today's next-20210618.
>> It's tested on Tegra20 Acer A500 that has older BCM4329, but seems the
>> problem is generic.
>>
>> There is this line in pstore log:
>>
>>   ieee80211 phy0: brcmf_netdev_start_xmit: xmit rejected state=0
>>
>> Steps to reproduce:
>>
>> 1. Boot system
>> 2. Connect WiFi
>> 3. Run "rtcwake -s10 -mmem"
>>
>> What's interesting is that turning WiFi off/on before suspending makes
>> resume to work and there are no suspicious messages in KMSG, all further
>> resumes work too.
>>
>> This change fixes the hang:
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> index db5f8535fdb5..06d16f7776c7 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> @@ -301,7 +301,6 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct
>> sk_buff *skb,
>>  	/* Can the device send data? */
>>  	if (drvr->bus_if->state != BRCMF_BUS_UP) {
>>  		bphy_err(drvr, "xmit rejected state=%d\n", drvr->bus_if->state);
>> -		netif_stop_queue(ndev);
>>  		dev_kfree_skb(skb);
>>  		ret = -ENODEV;
>>  		goto done;
>> 8<---
>>
>> Comments? Suggestions? Thanks in advance.
>>
> 
> Update:
> 
> After some more testing I found that the removal of netif_stop_queue() doesn't really help, apparently it was a coincidence.
> 
> I enabled CONFIG_BRCMDBG and added dump_stack() to the error condition of brcmf_netdev_start_xmit() and this is what it shows:
> 
> PM: suspend entry (s2idle)
> Filesystems sync: 0.000 seconds
> Freezing user space processes ... (elapsed 0.004 seconds) done.
> OOM killer disabled.
> Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
...
The hanging problem has been resolved by bumping Tegra SoC core voltage,
so it wasn't related to BCM.

The "xmit rejected" error is still there, but it's not fatal AFAICS.
