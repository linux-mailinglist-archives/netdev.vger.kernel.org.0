Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0C4400645
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 22:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350144AbhICUCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 16:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbhICUB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 16:01:59 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2609DC061575;
        Fri,  3 Sep 2021 13:00:59 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id g138so44390wmg.4;
        Fri, 03 Sep 2021 13:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N+/ijPrgySaj3wZhh50lF15QRZ6BcLbAW4B1pzs4L10=;
        b=mF34oOB7kHuJItaHqpPVh7S/7YHJd9xsnNJkGR1z32qOI2BSPBwEICdpsp02y9Dd7u
         Vs0Vg7EEC7SGmBvi32rs2f+jjlaQfoSGo+Y/a9mpVruuiK+SGKOd8i8Z4Wzz92+ymYDJ
         Fjpnvhn/ygckCaYGzyOmQURnwSbu9Naax0Nh4z5FCrNgEMXq+nbRRSr2KdAhM/s4eJ6X
         JpRvoBbEZPsPdMUJ6myvgWqLmZWnPSYHmMx1ggDOM77PCuOhE9TUNqM4TbJmfWiYvWLG
         KHwyFOClQ/dBy67zNNvL1I1AKqx9+swMdMqEmBnAsIMcxT8eQJm5cHeMlwYrYzEVvv63
         Lzlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N+/ijPrgySaj3wZhh50lF15QRZ6BcLbAW4B1pzs4L10=;
        b=qc5ux1ZXhcEf/9l3yioxjzXJVVwZOFNt01jRJh6mfr/PsjDaIzgggIGKR8Owkzwaa0
         FxAykFnMbTJuotHIBY4lyJA54uLDy9qdBiVPPKkJoRjLqVXjJFk5Oeil+lqPF2/WO55C
         BHrAnJ3ODNE1zcu0yF/ZhivdGh0XS5DMvOUQUyGt+fc5mF17zgKHxbPrb1d2bI50JL7r
         Yez5HgaB1I/fFeCC92XuDLlt2Oz5LQBdhi6lTBXfKOvGodXj0httYAaiUNbIheN509jM
         6errb6ZakZuHxoBrg0if8WFqpkSFXMJ3Xk6WV5G018cegyCdmLOl8A73wo6fuBPs9CvE
         voXw==
X-Gm-Message-State: AOAM530y/nGwNPMCxnX2bum6mNkEkfTAXnQz98SEDzOq53kApxNo9zbq
        Mz1E+wX7sA3Usp7ru/XJcu0=
X-Google-Smtp-Source: ABdhPJwmXXC/wG3rOBNJk2+624jMqJOMYDAG2js8xC3SrubWDrP4mwTX6VlQErmpDitutk7AGn/BBg==
X-Received: by 2002:a05:600c:2210:: with SMTP id z16mr447530wml.70.1630699257765;
        Fri, 03 Sep 2021 13:00:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:e013:89de:4503:1d89? (p200300ea8f084500e01389de45031d89.dip0.t-ipconnect.de. [2003:ea:8f08:4500:e013:89de:4503:1d89])
        by smtp.googlemail.com with ESMTPSA id c14sm325119wme.6.2021.09.03.13.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:00:57 -0700 (PDT)
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC] [PATCH net-next v4] [PATCH 2/2] r8169: Implement dynamic
 ASPM mechanism
Message-ID: <71aea1f6-749b-e379-70f4-653ac46e7f25@gmail.com>
Date:   Fri, 3 Sep 2021 22:00:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAAd53p634-nxEYYDbc69JEVev=cFkqtdCJv5UjAFCDUqdNAk_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.09.2021 17:56, Kai-Heng Feng wrote:
> On Tue, Aug 31, 2021 at 2:09 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>>
>> On Sat, Aug 28, 2021 at 01:14:52AM +0800, Kai-Heng Feng wrote:
>>> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
>>> Same issue can be observed with older vendor drivers.
>>>
>>> The issue is however solved by the latest vendor driver. There's a new
>>> mechanism, which disables r8169's internal ASPM when the NIC traffic has
>>> more than 10 packets, and vice versa. The possible reason for this is
>>> likely because the buffer on the chip is too small for its ASPM exit
>>> latency.
>>
>> This sounds like good speculation, but of course, it would be better
>> to have the supporting data.
>>
>> You say above that this problem affects r8169 on "some platforms."  I
>> infer that ASPM works fine on other platforms.  It would be extremely
>> interesting to have some data on both classes, e.g., "lspci -vv"
>> output for the entire system.
> 
> lspci data collected from working and non-working system can be found here:
> https://bugzilla.kernel.org/show_bug.cgi?id=214307
> 
>>
>> If r8169 ASPM works well on some systems, we *should* be able to make
>> it work well on *all* systems, because the device can't tell what
>> system it's in.  All the device can see are the latencies for entry
>> and exit for link states.
> 
> That's definitely better if we can make r8169 ASPM work for all platforms.
> 
>>
>> IIUC this patch makes the driver wake up every 1000ms.  If the NIC has
>> sent or received more than 10 packets in the last 1000ms, it disables
>> ASPM; otherwise it enables ASPM.
> 
> Yes, that's correct.
> 
>>
>> I asked these same questions earlier, but nothing changed, so I won't
>> raise them again if you don't think they're pertinent.  Some patch
>> splitting comments below.
> 
> Sorry about that. The lspci data is attached.
> 

Thanks for the additional details. I see that both systems have the L1
sub-states active. Do you also face the issue if L1 is enabled but
L1.2 and L1.2 are not? Setting the ASPM policy from powersupersave
to powersave should be sufficient to disable them.
I have a test system Asus PRIME H310I-PLUS, BIOS 2603 10/21/2019 with
the same RTL8168h chip version. With L1 active and sub-states inactive
everything is fine. With the sub-states activated I get few missed RX
errors when running iperf3.

One difference between your good and bad logs is the following.
(My test system shows the same LTR value like your bad system.)

Bad:
	Capabilities: [170 v1] Latency Tolerance Reporting
		Max snoop latency: 3145728ns
		Max no snoop latency: 3145728ns

Good:
	Capabilities: [170 v1] Latency Tolerance Reporting
		Max snoop latency: 1048576ns
		Max no snoop latency: 1048576ns

I have to admit that I'm not familiar with LTR and don't know whether
this difference could contribute to the differing behavior.
