Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3373EC25E
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 13:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238318AbhHNLej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 07:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238215AbhHNLeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 07:34:31 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51459C061764;
        Sat, 14 Aug 2021 04:34:03 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id a201-20020a1c7fd2000000b002e6d33447f9so896785wmd.0;
        Sat, 14 Aug 2021 04:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UnugELH/aSAAmccmiXeZUH+MlucQ/YM062lGeSReouU=;
        b=EVqinU5002f45n90CmclIUxxxqMN4LHQ61a79RaczW8ec0efWutOZF34abohQBg/Of
         Q8dAy3DwEGaxzXb9dhK9ZqHWfWYfE3m6ByW2MlrcebGoI2nnfuCkP1UmBySBV0DC7JL8
         h97WsyQZFJOKwK1IXz4pJmnOsxIee4Acqh1Qw7p9aEHPbKfTtKYYBQCgVJYYeRp1n3Ph
         z/rGz4uBer6rvQ5/OhT17hQk/FON8NMlea2lFMkc2ozEoGx3YLnJkkmZfzva/J7GseRe
         Lmzc51hoo9WAzFrJBhX8WnXulBzueUBYckbmsAKNuJAS2tocKtdvJDbjmgtZLxlNRy/v
         pb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UnugELH/aSAAmccmiXeZUH+MlucQ/YM062lGeSReouU=;
        b=fwFwYnMuaeJOZImqHNF5IWOPvwW1pNRTY7BiMhy/EYjaIyUOrQb1OQDHVq6FToO09v
         szdWIkfI1IXgSIH23ids2AC+EiZO/6EiYuHKAvpdqehCBwvsW4R4AENbZ0PuCOAPAUj7
         IuRrd0bW/7iA0zh9urifvBSkZnogeGY5r8BRO8J+StnUBMVwQZwmCjGu8Im7ycslxiOK
         79PBjZxynrUaeugHOpN4WITBvIUsPSntGNLWVtZ1pJAWY6Lti9wd8LHi6dVDXSjrnwya
         7ZF0Qr5/cZ8c9rg9nEAiMxFzffREwpGUovGE6df3T3xlOHpglG0h2/SQWTg/OmBshf6i
         lytQ==
X-Gm-Message-State: AOAM531IO5QQZJeK9UhFDBHmtrQUAXlAO6SyawsSt+W7o/PHWuScpKUB
        FeZ3eCO+GdI+kcMCROAVxTRnycj6eUMW0g==
X-Google-Smtp-Source: ABdhPJzd/80wGlgh7LxnOLHGSgrXwr8IbqpV46XLgDYHE1ZtJP8UxCS52b87hTvN+nRJnq3Ba8r4NQ==
X-Received: by 2002:a1c:7203:: with SMTP id n3mr7070117wmc.45.1628940841677;
        Sat, 14 Aug 2021 04:34:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:b5a1:ec6b:3c18:2e5b? (p200300ea8f10c200b5a1ec6b3c182e5b.dip0.t-ipconnect.de. [2003:ea:8f10:c200:b5a1:ec6b:3c18:2e5b])
        by smtp.googlemail.com with ESMTPSA id b15sm4413830wrq.5.2021.08.14.04.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 04:34:00 -0700 (PDT)
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     nic_swsd <nic_swsd@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20210812155341.817031-1-kai.heng.feng@canonical.com>
 <631a47b7-f068-7770-65f4-bdfedc4b7d6c@gmail.com>
 <CAAd53p7qVcnwLL-73J4J_QvEfca2Y=Mjr=G-7LaBPMX2FzRCFw@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 1/2] r8169: Implement dynamic ASPM mechanism
Message-ID: <0c08f92a-2e06-8917-3726-4b67bd875dbc@gmail.com>
Date:   Sat, 14 Aug 2021 13:31:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAAd53p7qVcnwLL-73J4J_QvEfca2Y=Mjr=G-7LaBPMX2FzRCFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.08.2021 11:54, Kai-Heng Feng wrote:
> On Fri, Aug 13, 2021 at 2:49 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 12.08.2021 17:53, Kai-Heng Feng wrote:
>>> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
>>> Same issue can be observed with older vendor drivers.
>>>
>>> The issue is however solved by the latest vendor driver. There's a new
>>> mechanism, which disables r8169's internal ASPM when the NIC traffic has
>>> more than 10 packets, and vice versa.
>>>
>>> Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
>>
>> As we have Realtek in this mail thread:
> 
> Is it still in active use? I always think it's just a dummy address...
At least mails to this address are not bounced, and this address still is
in MAINTAINERS. But right, I've never any reaction on mails to this
address. So it may make sense to remove it from MAINTAINERS.
Not sure what the process would be to do this.

> 
>> Typically hw issues affect 1-3 chip versions only. The ASPM problems seem
>> to have been existing for at least 15 years now, in every chip version.
>> It seems that even the new RTL8125 chip generation still has broken ASPM.
> 
> Is there a bug report for that?
> 
No. This was referring to your statement that also r8125 vendor driver
includes this "dynamic ASPM" workaround. They wouldn't have done this
if RTL8125 had proper ASPM support, or?

>> Why was this never fixed? ASPM not considered to be relevant? HW design
>> too broken?
> 
> IIUC, ASPM is extremely relevant to pass EU/US power consumption
> regulation. So I really don't know why the situation under Linux is so
> dire.
> 
It's not something related to Linux, ASPM support in the Realtek chips
is simply broken. This needs to be fixed in HW.
The behavior we see may indicate that certain buffers in the chips are
too small to buffer traffic for full period of ASPM exit latency.

> Kai-Heng
> 
>>
>>> use dynamic ASPM under Windows. So implement the same mechanism here to
>>> resolve the issue.
>>>
>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>> ---
>>> v2:
>>>  - Use delayed_work instead of timer_list to avoid interrupt context
>>>  - Use mutex to serialize packet counter read/write
>>>  - Wording change
>>>
>>>  drivers/net/ethernet/realtek/r8169_main.c | 45 +++++++++++++++++++++++
>>>  1 file changed, 45 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>> index c7af5bc3b8af..7ab2e841dc69 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -624,6 +624,11 @@ struct rtl8169_private {
>>>
>>>       unsigned supports_gmii:1;
>>>       unsigned aspm_manageable:1;
>>> +     unsigned aspm_enabled:1;
>>> +     struct delayed_work aspm_toggle;
>>> +     struct mutex aspm_mutex;
>>> +     u32 aspm_packet_count;
>>> +
>>>       dma_addr_t counters_phys_addr;
>>>       struct rtl8169_counters *counters;
>>>       struct rtl8169_tc_offsets tc_offset;
>>> @@ -2671,6 +2676,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>>>               RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
>>>       }
>>>
>>> +     tp->aspm_enabled = enable;
>>> +
>>>       udelay(10);
>>>  }
>>>
>>> @@ -4408,6 +4415,9 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
>>>
>>>       dirty_tx = tp->dirty_tx;
>>>
>>> +     mutex_lock(&tp->aspm_mutex);
>>> +     tp->aspm_packet_count += tp->cur_tx - dirty_tx;
>>> +     mutex_unlock(&tp->aspm_mutex);
>>>       while (READ_ONCE(tp->cur_tx) != dirty_tx) {
>>>               unsigned int entry = dirty_tx % NUM_TX_DESC;
>>>               u32 status;
>>> @@ -4552,6 +4562,10 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, int budget
>>>               rtl8169_mark_to_asic(desc);
>>>       }
>>>
>>> +     mutex_lock(&tp->aspm_mutex);
>>> +     tp->aspm_packet_count += count;
>>> +     mutex_unlock(&tp->aspm_mutex);
>>> +
>>>       return count;
>>>  }
>>>
>>> @@ -4659,8 +4673,33 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
>>>       return 0;
>>>  }
>>>
>>> +#define ASPM_PACKET_THRESHOLD 10
>>> +#define ASPM_TOGGLE_INTERVAL 1000
>>> +
>>> +static void rtl8169_aspm_toggle(struct work_struct *work)
>>> +{
>>> +     struct rtl8169_private *tp = container_of(work, struct rtl8169_private,
>>> +                                               aspm_toggle.work);
>>> +     bool enable;
>>> +
>>> +     mutex_lock(&tp->aspm_mutex);
>>> +     enable = tp->aspm_packet_count <= ASPM_PACKET_THRESHOLD;
>>> +     tp->aspm_packet_count = 0;
>>> +     mutex_unlock(&tp->aspm_mutex);
>>> +
>>> +     if (tp->aspm_enabled != enable) {
>>> +             rtl_unlock_config_regs(tp);
>>> +             rtl_hw_aspm_clkreq_enable(tp, enable);
>>> +             rtl_lock_config_regs(tp);
>>> +     }
>>> +
>>> +     schedule_delayed_work(&tp->aspm_toggle, ASPM_TOGGLE_INTERVAL);
>>> +}
>>> +
>>>  static void rtl8169_down(struct rtl8169_private *tp)
>>>  {
>>> +     cancel_delayed_work_sync(&tp->aspm_toggle);
>>> +
>>>       /* Clear all task flags */
>>>       bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
>>>
>>> @@ -4687,6 +4726,8 @@ static void rtl8169_up(struct rtl8169_private *tp)
>>>       rtl_reset_work(tp);
>>>
>>>       phy_start(tp->phydev);
>>> +
>>> +     schedule_delayed_work(&tp->aspm_toggle, ASPM_TOGGLE_INTERVAL);
>>>  }
>>>
>>>  static int rtl8169_close(struct net_device *dev)
>>> @@ -5347,6 +5388,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>
>>>       INIT_WORK(&tp->wk.work, rtl_task);
>>>
>>> +     INIT_DELAYED_WORK(&tp->aspm_toggle, rtl8169_aspm_toggle);
>>> +
>>> +     mutex_init(&tp->aspm_mutex);
>>> +
>>>       rtl_init_mac_address(tp);
>>>
>>>       dev->ethtool_ops = &rtl8169_ethtool_ops;
>>>
>>

