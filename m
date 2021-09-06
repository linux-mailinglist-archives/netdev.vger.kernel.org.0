Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C051E401E14
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 18:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243787AbhIFQNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 12:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbhIFQM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 12:12:57 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DD4C061575;
        Mon,  6 Sep 2021 09:11:51 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q26so9611359wrc.7;
        Mon, 06 Sep 2021 09:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yMe7hARaRlNs8BzL6jRs3KtWxHz+7C0gkS3B6LA37KM=;
        b=pQSlIbQ/ik4FojTvAQP/cmkRlDM5QyKZjm0ENXJ3ocm7Cw5pxeSurQIWHkmn6kyedN
         uRVYIyMkUcAAEZzjVan3nFoFazmnvoNSj43TRM/WbBzyw8i59wlNB/fiFB3FRBjrnIVn
         PRs0Esn8lN1JIfLU/vH4Wqk2gZj1io1bBVORQZGrIwcnFcWlUR1ZZq7Um0dHxzUtQTxJ
         +sNwu/3YXhNsKVTZg6qkkZmNSZXkIemxdzbijreO77pMSWK4TbM0GnDqJ7+7VhJH/MRg
         p9M4KCgJlN9RbcSpr2mHGwcfPBulmh08CUx6K+tvsFUiDjvomf9/qlQRn4fiyw3IRYhJ
         sS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yMe7hARaRlNs8BzL6jRs3KtWxHz+7C0gkS3B6LA37KM=;
        b=pYl3aFrhOQkIKpCf78X8Hcjt8OQIA+SoHxeVmVA5p4Vl8ziMBiIe+YpU4EgnVMRHMY
         KmrQhLO0dXmDN6cyZWqzhmnwh//QtAakZWroqB9xrNTaxfMDtKNs39Pf7m/NvFGG/Abm
         1alpuN+IMxgh9SmTXyC4x8qd5nUeyCFmz8T+xhX0uBzH/sT0k6jmku1Fqf7tQ4yP0QdB
         GAaNJZrXuzs8p2Ys3jFC52E8volxfbAw9GTgEQbrIsH4N5s/IfetHfTDMoznh482JeRk
         BvS51Uzl3iXPKyVWpbo0uG+/29aW34MW6EdFIgasNjicEYQ7tg1/wkcNicaumnHg5GO1
         V74Q==
X-Gm-Message-State: AOAM531/5JTycx3aUCD8dEwZoi7NXx5E9YTf738g8VrGCdGeFmGFqd5x
        cZ2cOgvjBalWk2HlbNFo4g0=
X-Google-Smtp-Source: ABdhPJxhjJZHTnai6GVdBkiSIrx+YBCUDUL0kjxHqFjwErUDVQ4O5s/VpGUyMOldisoIOwWeNLSGYw==
X-Received: by 2002:adf:e4ca:: with SMTP id v10mr4967409wrm.126.1630944709174;
        Mon, 06 Sep 2021 09:11:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:2cc2:5e4b:8e61:1e2c? (p200300ea8f0845002cc25e4b8e611e2c.dip0.t-ipconnect.de. [2003:ea:8f08:4500:2cc2:5e4b:8e61:1e2c])
        by smtp.googlemail.com with ESMTPSA id s1sm8364950wrs.53.2021.09.06.09.11.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 09:11:48 -0700 (PDT)
Subject: Re: [RFC] [PATCH net-next v4] [PATCH 2/2] r8169: Implement dynamic
 ASPM mechanism
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     nic_swsd <nic_swsd@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>
References: <20210827171452.217123-3-kai.heng.feng@canonical.com>
 <20210830180940.GA4209@bjorn-Precision-5520>
 <CAAd53p634-nxEYYDbc69JEVev=cFkqtdCJv5UjAFCDUqdNAk_A@mail.gmail.com>
 <71aea1f6-749b-e379-70f4-653ac46e7f25@gmail.com>
 <CAAd53p7XQWJJrVUgGZe0MC1jO+f3+edAmkEVhP40Lwwtq2bU2A@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c39bd0ad-c80a-dbed-3f30-95c2b31434cc@gmail.com>
Date:   Mon, 6 Sep 2021 17:34:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAAd53p7XQWJJrVUgGZe0MC1jO+f3+edAmkEVhP40Lwwtq2bU2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.09.2021 17:10, Kai-Heng Feng wrote:
> On Sat, Sep 4, 2021 at 4:00 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 03.09.2021 17:56, Kai-Heng Feng wrote:
>>> On Tue, Aug 31, 2021 at 2:09 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>>>>
>>>> On Sat, Aug 28, 2021 at 01:14:52AM +0800, Kai-Heng Feng wrote:
>>>>> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
>>>>> Same issue can be observed with older vendor drivers.
>>>>>
>>>>> The issue is however solved by the latest vendor driver. There's a new
>>>>> mechanism, which disables r8169's internal ASPM when the NIC traffic has
>>>>> more than 10 packets, and vice versa. The possible reason for this is
>>>>> likely because the buffer on the chip is too small for its ASPM exit
>>>>> latency.
>>>>
>>>> This sounds like good speculation, but of course, it would be better
>>>> to have the supporting data.
>>>>
>>>> You say above that this problem affects r8169 on "some platforms."  I
>>>> infer that ASPM works fine on other platforms.  It would be extremely
>>>> interesting to have some data on both classes, e.g., "lspci -vv"
>>>> output for the entire system.
>>>
>>> lspci data collected from working and non-working system can be found here:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=214307
>>>
>>>>
>>>> If r8169 ASPM works well on some systems, we *should* be able to make
>>>> it work well on *all* systems, because the device can't tell what
>>>> system it's in.  All the device can see are the latencies for entry
>>>> and exit for link states.
>>>
>>> That's definitely better if we can make r8169 ASPM work for all platforms.
>>>
>>>>
>>>> IIUC this patch makes the driver wake up every 1000ms.  If the NIC has
>>>> sent or received more than 10 packets in the last 1000ms, it disables
>>>> ASPM; otherwise it enables ASPM.
>>>
>>> Yes, that's correct.
>>>
>>>>
>>>> I asked these same questions earlier, but nothing changed, so I won't
>>>> raise them again if you don't think they're pertinent.  Some patch
>>>> splitting comments below.
>>>
>>> Sorry about that. The lspci data is attached.
>>>
>>
>> Thanks for the additional details. I see that both systems have the L1
>> sub-states active. Do you also face the issue if L1 is enabled but
>> L1.2 and L1.2 are not? Setting the ASPM policy from powersupersave
>> to powersave should be sufficient to disable them.
>> I have a test system Asus PRIME H310I-PLUS, BIOS 2603 10/21/2019 with
>> the same RTL8168h chip version. With L1 active and sub-states inactive
>> everything is fine. With the sub-states activated I get few missed RX
>> errors when running iperf3.
> 
> Once L1.1 and L1.2 are disabled the TX speed can reach 710Mbps and RX
> can reach 941 Mbps. So yes it seems to be the same issue.

I reach 940-950Mbps in both directions, but this seems to be unrelated
to what we discuss here.

> With dynamic ASPM, TX can reach 750 Mbps while ASPM L1.1 and L1.2 are enabled.
> 
>> One difference between your good and bad logs is the following.
>> (My test system shows the same LTR value like your bad system.)
>>
>> Bad:
>>         Capabilities: [170 v1] Latency Tolerance Reporting
>>                 Max snoop latency: 3145728ns
>>                 Max no snoop latency: 3145728ns
>>
>> Good:
>>         Capabilities: [170 v1] Latency Tolerance Reporting
>>                 Max snoop latency: 1048576ns
>>                 Max no snoop latency: 1048576ns
>>
>> I have to admit that I'm not familiar with LTR and don't know whether
>> this difference could contribute to the differing behavior.
> 
> I am also unsure what role LTR plays here, so I tried to change the
> LTR value to 1048576ns and yield the same result, the TX and RX remain
> very slow.
> 
> Kai-Heng
> 

