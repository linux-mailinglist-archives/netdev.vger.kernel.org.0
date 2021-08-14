Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AC73EC25B
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 13:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbhHNLe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 07:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237914AbhHNLe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 07:34:27 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46033C061764;
        Sat, 14 Aug 2021 04:33:59 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r6so16846546wrt.4;
        Sat, 14 Aug 2021 04:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w8xOczPcraLtNNjpWWMaj9QohyqoYcXHRp5Aa+PE+vE=;
        b=acQxm5P3wMGW0YsPyO/TjEH7K4xxio6mKwGpOHeVIDYKiU81ouDg4UV4aA0PU0l6aU
         9+2IIzxj/PCITTAF3M+fu//kxgZvPCHLNcBpxT3zwOSUqL4Z5SiyKhPpvFQZz47pwavT
         Fbwve9Fq98S6n4U4lmtFA+Fgr54g9Gc5DB5Ma0eExk5SyZruK+GY4bQFHrohxPv6xPj9
         DQaqVSmqPUw/EpOW99WZWyGrTdrL5G2SP1xgAT6Eg1Ir2bYsj0fIm3Ee0gFcPrYnC7w1
         COyh9iHniFeTTu7O529BjUcxCTxYtB6iQYRoN7nifyr479+lpO85ofCrDOy2OWhQ7tXt
         EdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w8xOczPcraLtNNjpWWMaj9QohyqoYcXHRp5Aa+PE+vE=;
        b=TYWDtrY8bm5O0LE0uXGt3Quh7WHKxBkx7fVJIeMXOJdMt/OrxqB439GtdfZaK/BgEu
         7056aP3RWlgg6P7JPVfVawssJj7fB1HPhox7RK32DzoY4KVYKiQQGr8tCOtXFi02Vd9Q
         I6D43ylIcJMBRvkQEPGvQ8oqiMRFwVmnF/xABBYWDIv9nTrKohzjV4s5/R9yxWSSQ44/
         YeYNBJrtBiJly3XzcNvFKdHxzyu2DPanAE7FVc3MUSOFYH4bh+DGioXPVRaTDAIJJGCp
         xgDefM4zWvSPOOrXUxv8zq+DJq2AD7zSY6xMXIW4rsLu05hojTqPyIdZY8atpBrRiyBW
         +fgQ==
X-Gm-Message-State: AOAM5322ngJBfNoUnuKRzOiP/LLFdjmlNJ2HIHLqe6JbZXglVaZOAc1q
        cDxBlEOnihKFzBrlZPn1Abe1wY84vuSJDw==
X-Google-Smtp-Source: ABdhPJwuBkxsPloe+1yJMxVf8000jKjjA51XLqGLh3dvKRHMCUtlj0wNMVcaKEtx65Bat6AAfK/lLA==
X-Received: by 2002:adf:f245:: with SMTP id b5mr7735308wrp.78.1628940837437;
        Sat, 14 Aug 2021 04:33:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:b5a1:ec6b:3c18:2e5b? (p200300ea8f10c200b5a1ec6b3c182e5b.dip0.t-ipconnect.de. [2003:ea:8f10:c200:b5a1:ec6b:3c18:2e5b])
        by smtp.googlemail.com with ESMTPSA id m15sm1195525wrw.74.2021.08.14.04.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 04:33:56 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] r8169: Enable ASPM for selected NICs
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     nic_swsd <nic_swsd@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20210812155341.817031-1-kai.heng.feng@canonical.com>
 <20210812155341.817031-2-kai.heng.feng@canonical.com>
 <3633f984-8dd6-f81b-85f9-6083420b4516@gmail.com>
 <CAAd53p6KGTVWp5PgZux5t2mdTXK29XdyB5Ke5YbR_-UacR03Sg@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0c62c140-94d7-96ff-a837-0f9f9086d120@gmail.com>
Date:   Sat, 14 Aug 2021 13:23:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAAd53p6KGTVWp5PgZux5t2mdTXK29XdyB5Ke5YbR_-UacR03Sg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.08.2021 12:11, Kai-Heng Feng wrote:
> On Fri, Aug 13, 2021 at 3:39 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 12.08.2021 17:53, Kai-Heng Feng wrote:
>>> The latest vendor driver enables ASPM for more recent r8168 NICs, do the
>>> same here to match the behavior.
>>>
>>> In addition, pci_disable_link_state() is only used for RTL8168D/8111D in
>>> vendor driver, also match that.
>>>
>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>> ---
>>> v2:
>>>  - No change
>>>
>>>  drivers/net/ethernet/realtek/r8169_main.c | 34 +++++++++++++++++------
>>>  1 file changed, 26 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>> index 7ab2e841dc69..caa29e72a21a 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -623,7 +623,7 @@ struct rtl8169_private {
>>>       } wk;
>>>
>>>       unsigned supports_gmii:1;
>>> -     unsigned aspm_manageable:1;
>>> +     unsigned aspm_supported:1;
>>>       unsigned aspm_enabled:1;
>>>       struct delayed_work aspm_toggle;
>>>       struct mutex aspm_mutex;
>>> @@ -2667,8 +2667,11 @@ static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)
>>>
>>>  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>>>  {
>>> +     if (!tp->aspm_supported)
>>> +             return;
>>> +
>>>       /* Don't enable ASPM in the chip if OS can't control ASPM */
>>> -     if (enable && tp->aspm_manageable) {
>>> +     if (enable) {
>>>               RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
>>>               RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
>>>       } else {
>>> @@ -5284,6 +5287,21 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
>>>       rtl_rar_set(tp, mac_addr);
>>>  }
>>>
>>> +static int rtl_hw_aspm_supported(struct rtl8169_private *tp)
>>> +{
>>> +     switch (tp->mac_version) {
>>> +     case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_36:
>>> +     case RTL_GIGA_MAC_VER_38:
>>> +     case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_42:
>>> +     case RTL_GIGA_MAC_VER_44 ... RTL_GIGA_MAC_VER_46:
>>> +     case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_63:
>>
>> This shouldn't be needed because ASPM support is announced the
>> standard PCI way. Max a blacklist should be needed if there are
>> chip versions that announce ASPM support whilst in reality they
>> do not support it (or support is completely broken).
> 
> So can we also remove aspm_manageable since blacklist will be used?
> 
That's independent. What I mean is replace the whitelist with auto-
detected ASPM support and blacklist just the ones that are where
ASPM is completely unusable.
Retrieving the info about ASPM support may need a smll PCI core
extension. We need something similar to pcie_aspm_enabled(),
just exposing link->aspm_support. link->aspm_enabled may change
at runtime (sysfs link attributes).

> Kai-Heng
> 
>>
>>> +             return 1;
>>> +
>>> +     default:
>>> +             return 0;
>>> +     }
>>> +}
>>> +
>>>  static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>  {
>>>       struct rtl8169_private *tp;
>>> @@ -5315,12 +5333,12 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>       if (rc)
>>>               return rc;
>>>
>>> -     /* Disable ASPM completely as that cause random device stop working
>>> -      * problems as well as full system hangs for some PCIe devices users.
>>> -      */
>>> -     rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
>>> -                                       PCIE_LINK_STATE_L1);
>>> -     tp->aspm_manageable = !rc;
>>> +     if (tp->mac_version == RTL_GIGA_MAC_VER_25)
>>> +             pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
>>> +                                    PCIE_LINK_STATE_L1 |
>>> +                                    PCIE_LINK_STATE_CLKPM);
>>> +
>>> +     tp->aspm_supported = rtl_hw_aspm_supported(tp);
>>>
>>>       /* enable device (incl. PCI PM wakeup and hotplug setup) */
>>>       rc = pcim_enable_device(pdev);
>>>
>>

