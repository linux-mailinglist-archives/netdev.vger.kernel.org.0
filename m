Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BD33EC260
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 13:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbhHNLem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 07:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238262AbhHNLef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 07:34:35 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF56C061764;
        Sat, 14 Aug 2021 04:34:06 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id k5-20020a05600c1c85b02902e699a4d20cso8537327wms.2;
        Sat, 14 Aug 2021 04:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r/+o8EzEKCOW7nmnLsdeqyhYWSXC8YmoHZ2G+9IGu9Q=;
        b=qbSMtj52feIug+cp5+g8XVBUY8g+tycsDAxwURe9rqzHq3XGzYy0HCC+C1P2NdrkuS
         9tfq2ZIUkIyBKHtt+weKNzfcGaEe8F3BvwTZ6zgtyUZFAdS2RB8Tn9fsADY5suX5cQ1d
         IMN8M49IK34kZMQLAmQ8u/r/g0/21Bea4PDC+7KvUTPzr9CpdTtqwF+mrmQgP5u5HWXK
         3elhVPTrG5RA8Fb4TBhPBRecX8x5WuZC16c4bGhP4ccbhuZ1TCUNwn9vKMGSsrzvGbOM
         7N0zUwHBNqGswigMyikshD7AeE7y4orzFH5VwJXABA2ireuyyLJw/pKNQj+Tr7kdZ9hJ
         ZZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r/+o8EzEKCOW7nmnLsdeqyhYWSXC8YmoHZ2G+9IGu9Q=;
        b=YBqo9fNC+P7CYU3zlHgwEmPwG0K3AaVRzNcXXgpPROBo38LjHEmuPl9/Y14EJ0xPj2
         2W09mygU/l2aRw4XdNKNWnIFACO/zjP8aiG3coznab17+JAWr4XzWmIwd74LN/cJyB7K
         Z6PzZJlxlUXwKv/vbjWXQj9eVxe0Tum/4Rg88g8tiKFVabXZRbHyR7j/FzuwG8O/hlOz
         LN39AfLMeV7lFPovKCc19U2LvsSF6mVU0greXF2Oxq6/MDVfbTDVaWJPGXW0+ljP+/yZ
         9cteaK2Q9B32oYS82MzRKaTnI4DR3uaivJ6bRZSrs+/RDANVl56OSN3DWo5kYqq340xs
         ocbQ==
X-Gm-Message-State: AOAM533nvPEeUgkw9TTWsfuq7mPIA6av6r5AqQpqb88PX1K4TPIWWUul
        cz6lBXO0S3Zn1AU/Y6GSXd2YrkhrbZyLaQ==
X-Google-Smtp-Source: ABdhPJy1hG9QXBoU2PP9slBB0D9jUNo5+XmljFU9pQYzKUhDYQrWKPPcsVC0k7uY8Mb2Hy+wVJvV2w==
X-Received: by 2002:a1c:4d17:: with SMTP id o23mr6827578wmh.92.1628940845170;
        Sat, 14 Aug 2021 04:34:05 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:b5a1:ec6b:3c18:2e5b? (p200300ea8f10c200b5a1ec6b3c182e5b.dip0.t-ipconnect.de. [2003:ea:8f10:c200:b5a1:ec6b:3c18:2e5b])
        by smtp.googlemail.com with ESMTPSA id u5sm4327167wrr.94.2021.08.14.04.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 04:34:04 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] r8169: Implement dynamic ASPM mechanism
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     nic_swsd <nic_swsd@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20210812155341.817031-1-kai.heng.feng@canonical.com>
 <875e7304-20a1-0bca-ee07-41b16f07152a@gmail.com>
 <CAAd53p41RWp6weA2uXmZvKiVajehYkuC6cmHDeLxtJU_gsxCFA@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a655633a-408e-49a1-fc1f-960eaa16ef88@gmail.com>
Date:   Sat, 14 Aug 2021 13:33:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAAd53p41RWp6weA2uXmZvKiVajehYkuC6cmHDeLxtJU_gsxCFA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.08.2021 11:46, Kai-Heng Feng wrote:
> j
> 
> On Fri, Aug 13, 2021 at 3:39 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
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
>>> use dynamic ASPM under Windows. So implement the same mechanism here to
>>> resolve the issue.
>>>
>> Realtek using something in their Windows drivers isn't really a proof of
>> quality.
> 
> I agree. So it'll be great if Realtek can work with us here.
> 
>> Still my concerns haven't been addressed. If ASPM is enabled and
>> there's a congestion in the chip it may take up to a second until ASPM
>> gets disabled. In this second traffic very likely is heavily affected.
>> Who takes care in case of problem reports?
> 
> I think we'll know that once the patch is merged in downstream kernel.
> 
>>
>> This is a massive change for basically all chip versions. And experience
>> shows that in case of problem reports Realtek never cares, even though
>> they are listed as maintainers. All I see is that they copy more and more
>> code from r8169 into their own drivers. This seems to indicate that they
>> consider quality of their own drivers as not sufficient.
> 
> I wonder why they don't want to put their efforts to r8169...
> Obviously they are doing a great job for rtw88 and r8152.
> 
>>
>> Still my proposal: Apply this downstream, and if there are no complaints
>> after a few months it may be considered for mainline.
> 
> Yes that's my plan. But I'd still like it to be reviewed before
> putting it to the downstream kernel.
> 
>>
>> Last but not least the formal issues:
>> - no cover letter
> 
> Will write it up once it's tested dowstream.
> 
>> - no net/net-next annotation
> 
> Does it mean put "net/net-next" in the subject line?
> 

https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#how-do-i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in

> 
>>
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
>>
>> We are in soft irq context here, therefore you shouldn't sleep.
> 
> I thought napi_poll is not using softirq, apparent I was wrong. Will
> correct it too.
> 
I saw an automated mail from a test bot to you complaining about this.

>>
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
>>
>> In the first version you used msecs_to_jiffies(ASPM_TIMER_INTERVAL).
>> Now you use 1000 jiffies what is a major difference.
> 
> msecs_to_jiffies() was omitted. Will correct it.
> 
> Kai-Heng
> 
>>
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

