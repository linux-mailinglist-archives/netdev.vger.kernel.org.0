Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D673A056D
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhFHVBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:01:51 -0400
Received: from mail-ej1-f54.google.com ([209.85.218.54]:40469 "EHLO
        mail-ej1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhFHVBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 17:01:51 -0400
Received: by mail-ej1-f54.google.com with SMTP id my49so18155578ejc.7;
        Tue, 08 Jun 2021 13:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=30xnlef1ElHYHsbW4hyY7qER+x2vQ7X1mjznnJz++Yk=;
        b=Ggsn5TdOgIHYna/yQm7O1jfZ3wc6tjW6tmznRjLfvPivgWANv5iG890vhiFhW3PTb0
         I5JQqt6AYKY/YeIyXiOzjcdKN7UYCClO02NitlpL8La8SquT/H6Pi2zDVcFRBRo7sw6f
         2i6Z6Dodfq4QWBRevaGS/ykl6+cNiXuZoOJHaeDirbjcL+QBFcmUHr18CGVf568Qq2by
         yRJWJAaFB94YrU2jrCEK+E/HUrTDRvd0JKEb0DDrmyQFK2/7JLGDDUlk9Iga08ZDTknB
         llRaCNud5ojld4rvVvhiBvQUO29XmggqPGdbcx2NuGYZcbRth64w4509VzjHe8TRlsfT
         s81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=30xnlef1ElHYHsbW4hyY7qER+x2vQ7X1mjznnJz++Yk=;
        b=aAmm+ueLMQUCE5MjM/lYP74XB42WS8SS6FuqfO7Rf38bsnAbJ5GYvpKfEDQrs8P7jI
         sxKg1Fdu0aQR9gF9Wt5rrs42t12f/RiBrWUV1u4Fi+buK4GqZx7Yz/IX5Sz9odxPQB3u
         oHnhRW13o3Hb6clbbs6/mxDrjOiLet5UroHF7yGtaBQwtOM1yUC+Mtp2EemGShpFlbFz
         9ioAlRW9/WCDYzqsbvk0LlflIcN8XywR0Hl/JcE9S8awQDaJzWJ5aBURG3YbJ7dSVXF3
         1RXzp3+yfK+BUgOel0EfunBVOTfloEhQqwddcfWNUDyhgGtUNv3EbQFZki2CU7aU2Q4j
         pZhg==
X-Gm-Message-State: AOAM530l9U8lSPRecCaUkDEo2Fdht+lmXjxQdoDfTa5ZNSdIxqrmJTzO
        nz1C4JgGqo8OLJ5x8JGE605J33BPXis=
X-Google-Smtp-Source: ABdhPJy4h/oncno/1eXgbfF74nyajmJnGB8JEsY36TAUwLttKvMZz15F4SuDitIqXZtEFy9gYyWUeA==
X-Received: by 2002:a17:907:2141:: with SMTP id rk1mr5831396ejb.200.1623185936553;
        Tue, 08 Jun 2021 13:58:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:3800:8cb5:6cf8:6fac:256f? (p200300ea8f2938008cb56cf86fac256f.dip0.t-ipconnect.de. [2003:ea:8f29:3800:8cb5:6cf8:6fac:256f])
        by smtp.googlemail.com with ESMTPSA id m15sm291524eji.39.2021.06.08.13.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 13:58:55 -0700 (PDT)
To:     Koba Ko <koba.ko@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210608032207.2923574-1-koba.ko@canonical.com>
 <84eb168e-58ff-0350-74e2-c55249eb258c@gmail.com>
 <CAJB-X+XFYa1cZgtJEL1KCNWviL3Y4X6EbN--rE8CD_9oD9EFyA@mail.gmail.com>
 <7a36c032-38fa-6aa6-fa0f-c3664850d8ea@gmail.com>
 <CAJB-X+V78kUM97AZQp9ZQbp=tzWwD9FQWEcFS6VnVRZnSHkb7g@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] [v2] r8169: Use PHY_POLL when RTL8106E enable ASPM
Message-ID: <4508fbcb-f8ec-3805-4aa3-eeea4975de31@gmail.com>
Date:   Tue, 8 Jun 2021 22:58:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAJB-X+V78kUM97AZQp9ZQbp=tzWwD9FQWEcFS6VnVRZnSHkb7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.06.2021 16:17, Koba Ko wrote:
> On Tue, Jun 8, 2021 at 9:45 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 08.06.2021 12:43, Koba Ko wrote:
>>> On Tue, Jun 8, 2021 at 4:00 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>
>>>> On 08.06.2021 05:22, Koba Ko wrote:
>>>>> For RTL8106E, it's a Fast-ethernet chip.
>>>>> If ASPM is enabled, the link chang interrupt wouldn't be triggered
>>>>> immediately and must wait a very long time to get link change interrupt.
>>>>> Even the link change interrupt isn't triggered, the phy link is already
>>>>> established.
>>>>>
>>>>> Use PHY_POLL to watch the status of phy link and disable
>>>>> the link change interrupt when ASPM is enabled on RTL8106E.
>>>>>
>>>>> v2: Instead use PHY_POLL and identify 8106E by RTL_GIGA_MAC_VER_39.
>>>>>
>>>>
>>>> Still the issue description doesn't convince me that it's a hw bug
>>>> with the respective chip version. What has been stated so far:
>>>>
>>>> 1. (and most important) Issue doesn't occur in mainline because ASPM
>>>>    is disabled in mainline for r8169. Issue occurs only with a
>>>>    downstream kernel with ASPM enabled for r8169.
>>>
>>> mainline kernel and enable L1, the issue is also observed.
>>>
>> Yes, but enabling L1 via sysfs is at own risk.
> 
> but we could have a workaround if hw have an aspm issue.
> 
>>
>>>> 2. Issue occurs only with ASPM L1.1 not disabled, even though this chip
>>>>    version doesn't support L1 sub-states. Just L0s/L1 don't trigger
>>>>    the issue.
>>>>    The NIC doesn't announce L1.1 support, therefore PCI core won't
>>>>    enable L1 sub-states on the PCIe link between NIC and upstream
>>>>    PCI bridge.
>>>
>>> More precisely, when L1 is enabled, the issue would be triggered.
>>> For RTL8106E,
>>> 1. Only disable L0s, pcie_aspm_enabled return 1, issue is triggered.
>>> 2. Only disable L1_1, pcie_aspm_enabled return 1, issue is triggered.
>>>
>>> 3. Only disable L1, pcie_aspm_enabled return 0, issue is not triggered.
>>>
>>>>
>>>> 3. Issue occurs only with a GBit-capable link partner. 100MBit link
>>>>    partners are fine. Not clear whether issue occurs with a specific
>>>>    Gbit link partner only or with GBit-capable link partners in general.
>>>>
>>>> 4. Only link-up interrupt is affected. Not link-down and not interrupts
>>>>    triggered by other interrupt sources.
>>>>
>>>> 5. Realtek couldn't confirm that there's such a hw bug on RTL8106e.
>>>>
>>>> One thing that hasn't been asked yet:
>>>> Does issue occur always if you re-plug the cable? Or only on boot?
>>>> I'm asking because in the dmesg log you attached to the bugzilla issue
>>>> the following looks totally ok.
>>>>
>>>> [   61.651643] r8169 0000:01:00.0 enp1s0: Link is Down
>>>> [   63.720015] r8169 0000:01:00.0 enp1s0: Link is Up - 100Mbps/Full - flow control rx/tx
>>>> [   66.685499] r8169 0000:01:00.0 enp1s0: Link is Down
>>>
>>> Once the link is up,
>>> 1. If cable is unplug&plug immediately,  you wouldn't see the issue.
>>> 2. Unplug cable and wait a long time (~1Mins), then plug the cable,
>>> the issue appears again.
>>>
>> This sounds runtime-pm-related. After 10s the NIC runtime-suspends,
>> and once the cable is re-plugged a PME is triggered that lets the
>> PCI core return the PCIe link from D3hot to D0.
>> If you re-plug the cable after such a longer time, do you see the
>> PCIe PME immediately in /proc/interrupts?
> 
> I don't know which irq number is for RTL8106e PME, but check all PME
> in /proc/interrupt,
> 
> There's no interrupt increase on all PME entries and rtl8106e irq entry(irq 32).
> 
>>
>> And if you set /sys/class/net/<if>/power/control to "on", does the
>> issue still occur?
> 
> Yes, after echo "on" to /sys/class/net/<if>/power/control and
> replugging the cable, the issue is still caught.
>>
>>>>
>>>>> Signed-off-by: Koba Ko <koba.ko@canonical.com>
>>>>> ---
>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 21 +++++++++++++++++++--
>>>>>  1 file changed, 19 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>>> index 2c89cde7da1e..a59cbaef2839 100644
>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>>> @@ -4914,6 +4914,19 @@ static const struct dev_pm_ops rtl8169_pm_ops = {
>>>>>
>>>>>  #endif /* CONFIG_PM */
>>>>>
>>>>> +static int rtl_phy_poll_quirk(struct rtl8169_private *tp)
>>>>> +{
>>>>> +     struct pci_dev *pdev = tp->pci_dev;
>>>>> +
>>>>> +     if (!pcie_aspm_enabled(pdev))
>>>>
>>>> That's the wrong call. According to what you said earlier you want to
>>>> check for L1 sub-states, not for ASPM in general.
>>>
>>> As per described above, that's why use pcie_aspm_enabled here.
>>>
>>>>
>>>>> +             return 0;
>>>>> +
>>>>> +     if (tp->mac_version == RTL_GIGA_MAC_VER_39)
>>>>> +             return 1;
>>>>> +
>>>>> +     return 0;
>>>>> +}
>>>>> +
>>>>>  static void rtl_wol_shutdown_quirk(struct rtl8169_private *tp)
>>>>>  {
>>>>>       /* WoL fails with 8168b when the receiver is disabled. */
>>>>> @@ -4991,7 +5004,10 @@ static const struct net_device_ops rtl_netdev_ops = {
>>>>>
>>>>>  static void rtl_set_irq_mask(struct rtl8169_private *tp)
>>>>>  {
>>>>> -     tp->irq_mask = RxOK | RxErr | TxOK | TxErr | LinkChg;
>>>>> +     tp->irq_mask = RxOK | RxErr | TxOK | TxErr;
>>>>> +
>>>>> +     if (!rtl_phy_poll_quirk(tp))
>>>>> +             tp->irq_mask |= LinkChg;
>>>>>
>>>>>       if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
>>>>>               tp->irq_mask |= SYSErr | RxOverflow | RxFIFOOver;
>>>>> @@ -5085,7 +5101,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>>>>       new_bus->name = "r8169";
>>>>>       new_bus->priv = tp;
>>>>>       new_bus->parent = &pdev->dev;
>>>>> -     new_bus->irq[0] = PHY_MAC_INTERRUPT;
>>>>> +     new_bus->irq[0] =
>>>>> +             (rtl_phy_poll_quirk(tp) ? PHY_POLL : PHY_MAC_INTERRUPT);
>>>>>       snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x", pci_dev_id(pdev));
>>>>>
>>>>>       new_bus->read = r8169_mdio_read_reg;
>>>>>
>>>>
>>

The r8101 vendor driver applies a special setting for RTL8106e if ASPM is enabled.
Not sure whether it's related but it's worth a try. Could you please check whether
the following makes a difference?

diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 50f0f621b..60014b9c4 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -1153,6 +1153,7 @@ static void rtl8106e_hw_phy_config(struct rtl8169_private *tp,
 	r8169_apply_firmware(tp);
 
 	rtl_writephy_batch(phydev, phy_reg_init);
+	phy_write(phydev, 0x18, 0x8310);
 }
 
 static void rtl8125_legacy_force_mode(struct phy_device *phydev)
-- 
2.32.0


