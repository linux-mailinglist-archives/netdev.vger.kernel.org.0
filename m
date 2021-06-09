Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986AC3A194B
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhFIPZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:25:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46418 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhFIPZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 11:25:22 -0400
Received: from mail-oo1-f69.google.com ([209.85.161.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <koba.ko@canonical.com>)
        id 1lr03C-000050-4X
        for netdev@vger.kernel.org; Wed, 09 Jun 2021 15:23:26 +0000
Received: by mail-oo1-f69.google.com with SMTP id 3-20020a4a03030000b029024950bdb69dso10641596ooi.3
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 08:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XMlElETiyD59LovlsrAZ3jNQTFrmc+dshdaSLqPwfGM=;
        b=igkE0sBUxr7FFHga2G+ZXWWNxBMqi0oKT15yQpH6r8IGZsMbKBo+GHCEDf4Or5EkT9
         i2rROHP8N+CjZNwyTCymQWicUUMAJZmq0hKT4iegAqGalzcfoPQV35cM+l7dk/X1ZfJy
         z5TX1g2sK8LER8ryuP+O+BaBP9jG1U7QRPJmWfHuFRX/Nuc35mzW4yJFgJAIitAJ3W/k
         nfRMoaqVZZN8+zSkhXZfVhy6yugoveuynkRf6qzxizO6on3S+CXPzSrJ+1PnReiaztik
         xK5ofp08cfMl4Z5OYqIfGNjqDZWNHjn4aI0Bf9W5SdJXchbYSRq81/6H3GAmYIIbBjKr
         buaw==
X-Gm-Message-State: AOAM531vFkSe/RLI5rSeBH9bdhVbPKm7c9RYm+MJzzmH5XX8X6KYRQV5
        tNzJOkT2zllQO9eRnlM8zFqQjHhb22hXdS3Wu5VXEkuzQdLxOBlhb5MAFtSPYIMDO+USzG/vfuM
        rqa0GML98cG5C32aPMKmbm+OBuoux0Z2/laJ20F540VWOc3PNJg==
X-Received: by 2002:a9d:6acb:: with SMTP id m11mr19471680otq.246.1623252204982;
        Wed, 09 Jun 2021 08:23:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztx9BUEA50c55qrcETwdnXouA3yAkN2V2+uqffZGrjpxMbECgPbqWT1hJPMRdHto2utw5hxDqdUCwu5W5Dt/w=
X-Received: by 2002:a9d:6acb:: with SMTP id m11mr19471653otq.246.1623252204609;
 Wed, 09 Jun 2021 08:23:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210608032207.2923574-1-koba.ko@canonical.com>
 <84eb168e-58ff-0350-74e2-c55249eb258c@gmail.com> <CAJB-X+XFYa1cZgtJEL1KCNWviL3Y4X6EbN--rE8CD_9oD9EFyA@mail.gmail.com>
 <7a36c032-38fa-6aa6-fa0f-c3664850d8ea@gmail.com> <CAJB-X+V78kUM97AZQp9ZQbp=tzWwD9FQWEcFS6VnVRZnSHkb7g@mail.gmail.com>
 <4508fbcb-f8ec-3805-4aa3-eeea4975de31@gmail.com> <CAJB-X+WgTE4pENU24=AraQ7mzeL23j34nmNQ1Qyk_f9f5JpbEg@mail.gmail.com>
 <51990dff-79f8-ec25-873d-e5d6be2f923c@gmail.com>
In-Reply-To: <51990dff-79f8-ec25-873d-e5d6be2f923c@gmail.com>
From:   Koba Ko <koba.ko@canonical.com>
Date:   Wed, 9 Jun 2021 23:23:13 +0800
Message-ID: <CAJB-X+XA3CekCQUrB1QxJoM_vFb51tfMJNARz215SjB7g0wb0w@mail.gmail.com>
Subject: Re: [PATCH] [v2] r8169: Use PHY_POLL when RTL8106E enable ASPM
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 10:29 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 09.06.2021 03:47, Koba Ko wrote:
> > On Wed, Jun 9, 2021 at 4:58 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> On 08.06.2021 16:17, Koba Ko wrote:
> >>> On Tue, Jun 8, 2021 at 9:45 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>>>
> >>>> On 08.06.2021 12:43, Koba Ko wrote:
> >>>>> On Tue, Jun 8, 2021 at 4:00 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>>>>>
> >>>>>> On 08.06.2021 05:22, Koba Ko wrote:
> >>>>>>> For RTL8106E, it's a Fast-ethernet chip.
> >>>>>>> If ASPM is enabled, the link chang interrupt wouldn't be triggered
> >>>>>>> immediately and must wait a very long time to get link change interrupt.
> >>>>>>> Even the link change interrupt isn't triggered, the phy link is already
> >>>>>>> established.
> >>>>>>>
> >>>>>>> Use PHY_POLL to watch the status of phy link and disable
> >>>>>>> the link change interrupt when ASPM is enabled on RTL8106E.
> >>>>>>>
> >>>>>>> v2: Instead use PHY_POLL and identify 8106E by RTL_GIGA_MAC_VER_39.
> >>>>>>>
> >>>>>>
> >>>>>> Still the issue description doesn't convince me that it's a hw bug
> >>>>>> with the respective chip version. What has been stated so far:
> >>>>>>
> >>>>>> 1. (and most important) Issue doesn't occur in mainline because ASPM
> >>>>>>    is disabled in mainline for r8169. Issue occurs only with a
> >>>>>>    downstream kernel with ASPM enabled for r8169.
> >>>>>
> >>>>> mainline kernel and enable L1, the issue is also observed.
> >>>>>
> >>>> Yes, but enabling L1 via sysfs is at own risk.
> >>>
> >>> but we could have a workaround if hw have an aspm issue.
> >>>
> >>>>
> >>>>>> 2. Issue occurs only with ASPM L1.1 not disabled, even though this chip
> >>>>>>    version doesn't support L1 sub-states. Just L0s/L1 don't trigger
> >>>>>>    the issue.
> >>>>>>    The NIC doesn't announce L1.1 support, therefore PCI core won't
> >>>>>>    enable L1 sub-states on the PCIe link between NIC and upstream
> >>>>>>    PCI bridge.
> >>>>>
> >>>>> More precisely, when L1 is enabled, the issue would be triggered.
> >>>>> For RTL8106E,
> >>>>> 1. Only disable L0s, pcie_aspm_enabled return 1, issue is triggered.
> >>>>> 2. Only disable L1_1, pcie_aspm_enabled return 1, issue is triggered.
> >>>>>
> >>>>> 3. Only disable L1, pcie_aspm_enabled return 0, issue is not triggered.
> >>>>>
> >>>>>>
> >>>>>> 3. Issue occurs only with a GBit-capable link partner. 100MBit link
> >>>>>>    partners are fine. Not clear whether issue occurs with a specific
> >>>>>>    Gbit link partner only or with GBit-capable link partners in general.
> >>>>>>
> >>>>>> 4. Only link-up interrupt is affected. Not link-down and not interrupts
> >>>>>>    triggered by other interrupt sources.
> >>>>>>
> >>>>>> 5. Realtek couldn't confirm that there's such a hw bug on RTL8106e.
> >>>>>>
> >>>>>> One thing that hasn't been asked yet:
> >>>>>> Does issue occur always if you re-plug the cable? Or only on boot?
> >>>>>> I'm asking because in the dmesg log you attached to the bugzilla issue
> >>>>>> the following looks totally ok.
> >>>>>>
> >>>>>> [   61.651643] r8169 0000:01:00.0 enp1s0: Link is Down
> >>>>>> [   63.720015] r8169 0000:01:00.0 enp1s0: Link is Up - 100Mbps/Full - flow control rx/tx
> >>>>>> [   66.685499] r8169 0000:01:00.0 enp1s0: Link is Down
> >>>>>
> >>>>> Once the link is up,
> >>>>> 1. If cable is unplug&plug immediately,  you wouldn't see the issue.
> >>>>> 2. Unplug cable and wait a long time (~1Mins), then plug the cable,
> >>>>> the issue appears again.
> >>>>>
> >>>> This sounds runtime-pm-related. After 10s the NIC runtime-suspends,
> >>>> and once the cable is re-plugged a PME is triggered that lets the
> >>>> PCI core return the PCIe link from D3hot to D0.
> >>>> If you re-plug the cable after such a longer time, do you see the
> >>>> PCIe PME immediately in /proc/interrupts?
> >>>
> >>> I don't know which irq number is for RTL8106e PME, but check all PME
> >>> in /proc/interrupt,
> >>>
> >>> There's no interrupt increase on all PME entries and rtl8106e irq entry(irq 32).
> >>>
> >>>>
> >>>> And if you set /sys/class/net/<if>/power/control to "on", does the
> >>>> issue still occur?
> >>>
> >>> Yes, after echo "on" to /sys/class/net/<if>/power/control and
> >>> replugging the cable, the issue is still caught.
> >>>>
> >>>>>>
> >>>>>>> Signed-off-by: Koba Ko <koba.ko@canonical.com>
> >>>>>>> ---
> >>>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 21 +++++++++++++++++++--
> >>>>>>>  1 file changed, 19 insertions(+), 2 deletions(-)
> >>>>>>>
> >>>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> >>>>>>> index 2c89cde7da1e..a59cbaef2839 100644
> >>>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
> >>>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> >>>>>>> @@ -4914,6 +4914,19 @@ static const struct dev_pm_ops rtl8169_pm_ops = {
> >>>>>>>
> >>>>>>>  #endif /* CONFIG_PM */
> >>>>>>>
> >>>>>>> +static int rtl_phy_poll_quirk(struct rtl8169_private *tp)
> >>>>>>> +{
> >>>>>>> +     struct pci_dev *pdev = tp->pci_dev;
> >>>>>>> +
> >>>>>>> +     if (!pcie_aspm_enabled(pdev))
> >>>>>>
> >>>>>> That's the wrong call. According to what you said earlier you want to
> >>>>>> check for L1 sub-states, not for ASPM in general.
> >>>>>
> >>>>> As per described above, that's why use pcie_aspm_enabled here.
> >>>>>
> >>>>>>
> >>>>>>> +             return 0;
> >>>>>>> +
> >>>>>>> +     if (tp->mac_version == RTL_GIGA_MAC_VER_39)
> >>>>>>> +             return 1;
> >>>>>>> +
> >>>>>>> +     return 0;
> >>>>>>> +}
> >>>>>>> +
> >>>>>>>  static void rtl_wol_shutdown_quirk(struct rtl8169_private *tp)
> >>>>>>>  {
> >>>>>>>       /* WoL fails with 8168b when the receiver is disabled. */
> >>>>>>> @@ -4991,7 +5004,10 @@ static const struct net_device_ops rtl_netdev_ops = {
> >>>>>>>
> >>>>>>>  static void rtl_set_irq_mask(struct rtl8169_private *tp)
> >>>>>>>  {
> >>>>>>> -     tp->irq_mask = RxOK | RxErr | TxOK | TxErr | LinkChg;
> >>>>>>> +     tp->irq_mask = RxOK | RxErr | TxOK | TxErr;
> >>>>>>> +
> >>>>>>> +     if (!rtl_phy_poll_quirk(tp))
> >>>>>>> +             tp->irq_mask |= LinkChg;
> >>>>>>>
> >>>>>>>       if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
> >>>>>>>               tp->irq_mask |= SYSErr | RxOverflow | RxFIFOOver;
> >>>>>>> @@ -5085,7 +5101,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
> >>>>>>>       new_bus->name = "r8169";
> >>>>>>>       new_bus->priv = tp;
> >>>>>>>       new_bus->parent = &pdev->dev;
> >>>>>>> -     new_bus->irq[0] = PHY_MAC_INTERRUPT;
> >>>>>>> +     new_bus->irq[0] =
> >>>>>>> +             (rtl_phy_poll_quirk(tp) ? PHY_POLL : PHY_MAC_INTERRUPT);
> >>>>>>>       snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x", pci_dev_id(pdev));
> >>>>>>>
> >>>>>>>       new_bus->read = r8169_mdio_read_reg;
> >>>>>>>
> >>>>>>
> >>>>
> >>
> >> The r8101 vendor driver applies a special setting for RTL8106e if ASPM is enabled.
> >> Not sure whether it's related but it's worth a try. Could you please check whether
> >> the following makes a difference?
> >
> > After applying this patch, it can't help relieve the issue.
> > The 8101 vendor driver also use polling method to watch the link change event.
> > Tried to disable polling method and enable LinkChg Irq, but it also
> > can't get LinkChg interrupt.
> >
> OK, thanks for testing.
> As it is now, rtl_phy_poll_quirk() would always return false because ASPM
> is disabled on driver load. Changing ASPM settings can be done later via sysfs
> if supported by device and upstream bridge. In addition:

it seems a callback is needed to inform the driver when changing the
aspm policy,
is it correct?

> - If you want to return a bool, declare the return value as bool.
> - You shouldn't have to disable the LinkChg interrupt. The interrupt just triggers
>   a phylib state machine run what may result in a faster link-up signal even
>   when using polling.

ok.

>
> By the way: All Realtek vendor drivers (r8101, r8168, r8125) don't use the LinkChg
> interrupt. However I don't think this is because of known hw issues, more likely
> it's because they don't use phylib and thought polling is the easier approach.
> At least for r8169 I haven't heard yet of any complain regarding the LinkChg
> interrupt.
>
> >>
> >> diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
> >> index 50f0f621b..60014b9c4 100644
> >> --- a/drivers/net/ethernet/realtek/r8169_phy_config.c
> >> +++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
> >> @@ -1153,6 +1153,7 @@ static void rtl8106e_hw_phy_config(struct rtl8169_private *tp,
> >>         r8169_apply_firmware(tp);
> >>
> >>         rtl_writephy_batch(phydev, phy_reg_init);
> >> +       phy_write(phydev, 0x18, 0x8310);
> >>  }
> >>
> >>  static void rtl8125_legacy_force_mode(struct phy_device *phydev)
> >> --
> >> 2.32.0
> >>
> >>
>
