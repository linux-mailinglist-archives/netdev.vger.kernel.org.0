Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7CD39DAC4
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 13:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhFGLLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 07:11:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43283 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhFGLLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 07:11:22 -0400
Received: from mail-oi1-f197.google.com ([209.85.167.197])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <koba.ko@canonical.com>)
        id 1lqD8M-0000oe-5x
        for netdev@vger.kernel.org; Mon, 07 Jun 2021 11:09:30 +0000
Received: by mail-oi1-f197.google.com with SMTP id y137-20020aca4b8f0000b02901f1fb748c74so4317436oia.21
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 04:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OotacsWGRzNlZ2Cws9I9zM1ereepJORuwNT0N0h9kX0=;
        b=WEd+jdyGIXTwzPvequROA7XyzhPpiLty9A9v2523DmejuCDE6SvoxbBmMksSR/HlOG
         Lkxv453WR/k46f3FpSm1rPwRkeLaUA9NqsSuHep3DZO2383lYrgoVqfYMnWHv5bOCLD+
         QhEOe6Upv52yevinkTyQCggXHyos53sOkpa5PlHlRAfWQGYpBhVGQlDlz5O0NgcmwcEN
         jdCbzJo3oLEhjduexB8PfiR3SjpM4xqxPKopSU7bL1TLuEcBB/7Fw49qBAUtl+yWdedn
         tlesnbG53DD1tSt5bYjec7QD/cjEn2+JGe0NIyVdtS/nUWsFX/OQEQ1xNWfWdGmfvOLd
         Eiug==
X-Gm-Message-State: AOAM530g5PTHnssT3TcCmACs9Ilxp6WlHg6Q2a8ENJTo5KtAmM3kEe/c
        qTB6dSePkoQW5uwkzgKgp0QQuyYeMisrY6Lfe5jtthno7Z0tPH0SubsQmoVabifYaZfehsmHpdp
        CTAMo/XbivM0wxJxdZpAFzovIXC6Ae7jOIXeRrzX/q4WVolv3xw==
X-Received: by 2002:a9d:1ec6:: with SMTP id n64mr13553879otn.3.1623064168956;
        Mon, 07 Jun 2021 04:09:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFHPvCRLeZH9LIgZibmOJx/fa07SUSnKmjox/erNt8pM37kZOnhG5DW8J5GGDg2K6l/ept9jjXUF8FARq75Pg=
X-Received: by 2002:a9d:1ec6:: with SMTP id n64mr13553856otn.3.1623064168482;
 Mon, 07 Jun 2021 04:09:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210603025414.226526-1-koba.ko@canonical.com>
 <3d2e7a11-92ad-db06-177b-c6602ef1acd4@gmail.com> <CAJB-X+V4vpLoNt2C_i=3mS4UtFnDdro5+hgaFXHWxcvobO=pzg@mail.gmail.com>
 <f969a075-25a1-84ba-daad-b4ed0e7f75f5@gmail.com> <CAJB-X+U5VEeSNS4sF0DBxc-p0nxA6QLVVrORHsscZuY37rGJ7w@mail.gmail.com>
 <bfc68450-422d-1968-1316-64f7eaa7cbe9@gmail.com> <CAJB-X+UDRK5-fKEGc+PS+_02HePmb34Pw_+tMyNr_iGGeE+jbQ@mail.gmail.com>
 <fffdc562-a3d3-07b4-cc4a-130eaca45126@gmail.com>
In-Reply-To: <fffdc562-a3d3-07b4-cc4a-130eaca45126@gmail.com>
From:   Koba Ko <koba.ko@canonical.com>
Date:   Mon, 7 Jun 2021 19:09:17 +0800
Message-ID: <CAJB-X+XhOHb0m676-Cj3a41H55DCUrLvTWhxac6uS_U2p5XAMA@mail.gmail.com>
Subject: Re: [PATCH] r8169: introduce polling method for link change
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 6:43 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 07.06.2021 06:34, Koba Ko wrote:
> > On Fri, Jun 4, 2021 at 7:59 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> On 04.06.2021 11:08, Koba Ko wrote:
> >>> On Fri, Jun 4, 2021 at 4:23 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>>>
> >>>> On 04.06.2021 09:22, Koba Ko wrote:
> >>>>> On Thu, Jun 3, 2021 at 6:00 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>>>>>
> >>>>>> On 03.06.2021 04:54, Koba Ko wrote:
> >>>>>>> For RTL8106E, it's a Fast-ethernet chip.
> >>>>>>> If ASPM is enabled, the link chang interrupt wouldn't be triggered
> >>>>>>> immediately and must wait a very long time to get link change interrupt.
> >>>>>>> Even the link change interrupt isn't triggered, the phy link is already
> >>>>>>> established.
> >>>>>>>
> >>>>>> At first please provide a full dmesg log and output of lspci -vv.
> >>>>>> Do you have the firmware for the NIC loaded? Please provide "ethtool -i <if>"
> >>>>>> output.
> >>>>>
> >>>>> please get the logs from here,
> >>>>> https://bugzilla.kernel.org/show_bug.cgi?id=213165
> >>>>>
> >>>>>> Does the issue affect link-down and/or link-up detection?
> >>>>>> Do you have runtime pm enabled? Then, after 10s of link-down NIC goes to
> >>>>>> D3hot and link-up detection triggers a PME.
> >>>>>
> >>>>> Issue affect link-up.
> >>>>> yes, pm runtime is enabled, but rtl8106e always stays D0 even if the
> >>>>> cable isn't present.
> >>>>>
> >>>> Then runtime pm doesn't seem to be set to "auto". Else 10s after link loss
> >>>> the chip runtime-suspends and is set to D3hot.
> >>>
> >>> I will check this.
> >>>
> >>>>
> >>>>>>
> >>>>>>> Introduce a polling method to watch the status of phy link and disable
> >>>>>>> the link change interrupt.
> >>>>>>> Also add a quirk for those realtek devices have the same issue.
> >>>>>>>
> >>>>>> Which are the affected chip versions? Did you check with Realtek?
> >>>>>> Your patch switches to polling for all Fast Ethernet versions,
> >>>>>> and that's not what we want.
> >>>>>
> >>>>> I don't know the exact version, only the chip name 806e(pci device id 0x8165).
> >>>>> ok, Im asking Realtek to help how to identify the chip issue is observed.
> >>>>>
> >>>> At least your Bugzilla report refers to VER_39. PCI device id 0x8136 is shared
> >>>> by all fast ethernet chip versions.
> >>>> Do you know other affected chip versions apart from VER_39 ?
> >>>>
> >>>> In the Bugzilla report you also write the issue occurs with GBit-capable
> >>>> link partners. This sounds more like an aneg problem.
> >>>> The issue doesn't occur with fast ethernet link partners?
> >>>
> >>> Issue wouldn't be observed when the link-partner has only FE capability.
> >>>
> >> Weird. I still have no clue how FE vs. GE support at link partner and
> >> ASPM could be related. I could understand that the PHY might have a
> >> problem with a GE link partner and aneg takes more time than usual.
> >> But this would be completely unrelated to a potential issue with
> >> ASPM on the PCIe link.
> >>
> >> And it's also not clear how L1_1 can cause an issue if the NIC doesn't
> >> support L1 sub-states. Maybe the root cause isn't with the NIC but
> >> with some other component in the PCIe path (e.g. bridge).
> >>
> >
> > I prefer that there's a interrupt issue when aspm is enabled on RTL8106e,
> >
> >>>>
> >>>> Your bug report also includes a patch that disables L1_1 only.
> >>>> Not sure how this is related because the chip version we speak about
> >>>> here doesn't support L1 sub-states.
> >>>
> >>> I have tried to enable L0s, L1 and don't disable L1 substate,
> >>> but still get the issue that interrupt can't be fired immediately but
> >>> the Link status is up.
> >>>
> >>>>
> >>>>>>
> >>>>>> My suspicion would be that something is system-dependent. Else I think
> >>>>>> we would have seen such a report before.
> >>>>> On the mainline, the aspm is disable, so you may not observe this.
> >>>>> If you enable ASPM and must wait CHIP go to power-saving mode, then
> >>>>> you can observe the issue.
> >>>>>>
> >>>>
> >>>> So what you're saying is that mainline is fine and your problem is with
> >>>> a downstream kernel with re-enabled ASPM? So there's nothing broken in
> >>>> mainline? In mainline you have the option to re-enable ASPM states
> >>>> individually via sysfs (link subdir at pci device).
> >>>
> >>> If enable L1_1 on the mainline, the issue could be observed too.
> >>>
> >> It has a reason that ASPM is disabled per default in mainline. Different
> >> chip versions have different types of issues with ASPM enabled.
> >> However several chip versions work fine with ASPM (also LI sub-states),
> >> therefore users can re-enable ASPM states at own risk.
> >
> > After consulting with REALTEK, I can identify RTL8106e by PCI_VENDOR
> > REALTEK, DEVICE 0x8136, Revision 0x7.
>
> This wasn't the question. The identification is available already.
> This chip version is RTL_GIGA_MAC_VER_39.
>
> > I would like to make PHY_POLL as default for RTL8106E on V2.
> > because there's no side effects besides the cpu usage rate would be a
> > little higher,
> > How do you think?
> >
> Did you check the actual question with Realtek? Did they confirm a hw
> issue with this chip version? If yes, some more details would be helpful.
>

yes, but Realtek said there's no issue on ASPM and AN.
They also didn't answer why disabling an unsupported L1_1 would cause
this issue.

>
> The dmesg log attached to your linked bugzilla issue lists a number of
> ACPI errors. Overall I'm still not convinced that root cause of your
> issue is a NIC hw bug.
>

I also upgraded the BIOS to the last and still can get the issue.

> >>> Thanks
> >>>>
> >>>>>>> Signed-off-by: Koba Ko <koba.ko@canonical.com>
> >>>>>>> ---
> >>>>>>>  drivers/net/ethernet/realtek/r8169.h      |   2 +
> >>>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 112 ++++++++++++++++++----
> >>>>>>>  2 files changed, 98 insertions(+), 16 deletions(-)
> >>>>>>>
> >>>>>>> diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
> >>>>>>> index 2728df46ec41..a8c71adb1b57 100644
> >>>>>>> --- a/drivers/net/ethernet/realtek/r8169.h
> >>>>>>> +++ b/drivers/net/ethernet/realtek/r8169.h
> >>>>>>> @@ -11,6 +11,8 @@
> >>>>>>>  #include <linux/types.h>
> >>>>>>>  #include <linux/phy.h>
> >>>>>>>
> >>>>>>> +#define RTL8169_LINK_TIMEOUT (1 * HZ)
> >>>>>>> +
> >>>>>>>  enum mac_version {
> >>>>>>>       /* support for ancient RTL_GIGA_MAC_VER_01 has been removed */
> >>>>>>>       RTL_GIGA_MAC_VER_02,
> >>>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> >>>>>>> index 2c89cde7da1e..70aacc83d641 100644
> >>>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
> >>>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> >>>>>>> @@ -178,6 +178,11 @@ static const struct pci_device_id rtl8169_pci_tbl[] = {
> >>>>>>>
> >>>>>>>  MODULE_DEVICE_TABLE(pci, rtl8169_pci_tbl);
> >>>>>>>
> >>>>>>> +static const struct pci_device_id rtl8169_linkChg_polling_enabled[] = {
> >>>>>>> +     { PCI_VDEVICE(REALTEK, 0x8136), RTL_CFG_NO_GBIT },
> >>>>>>> +     { 0 }
> >>>>>>> +};
> >>>>>>> +
> >>>>>>
> >>>>>> This doesn't seem to be used.
> >>>>>>
> >>>>>>>  enum rtl_registers {
> >>>>>>>       MAC0            = 0,    /* Ethernet hardware address. */
> >>>>>>>       MAC4            = 4,
> >>>>>>> @@ -618,6 +623,7 @@ struct rtl8169_private {
> >>>>>>>       u16 cp_cmd;
> >>>>>>>       u32 irq_mask;
> >>>>>>>       struct clk *clk;
> >>>>>>> +     struct timer_list link_timer;
> >>>>>>>
> >>>>>>>       struct {
> >>>>>>>               DECLARE_BITMAP(flags, RTL_FLAG_MAX);
> >>>>>>> @@ -1179,6 +1185,16 @@ static void rtl8168ep_stop_cmac(struct rtl8169_private *tp)
> >>>>>>>       RTL_W8(tp, IBCR0, RTL_R8(tp, IBCR0) & ~0x01);
> >>>>>>>  }
> >>>>>>>
> >>>>>>> +static int rtl_link_chng_polling_quirk(struct rtl8169_private *tp)
> >>>>>>> +{
> >>>>>>> +     struct pci_dev *pdev = tp->pci_dev;
> >>>>>>> +
> >>>>>>> +     if (pdev->vendor == 0x10ec && pdev->device == 0x8136 && !tp->supports_gmii)
> >>>>>>> +             return 1;
> >>>>>>> +
> >>>>>>> +     return 0;
> >>>>>>> +}
> >>>>>>> +
> >>>>>>>  static void rtl8168dp_driver_start(struct rtl8169_private *tp)
> >>>>>>>  {
> >>>>>>>       r8168dp_oob_notify(tp, OOB_CMD_DRIVER_START);
> >>>>>>> @@ -4608,6 +4624,75 @@ static void rtl_task(struct work_struct *work)
> >>>>>>>       rtnl_unlock();
> >>>>>>>  }
> >>>>>>>
> >>>>>>> +static void r8169_phylink_handler(struct net_device *ndev)
> >>>>>>> +{
> >>>>>>> +     struct rtl8169_private *tp = netdev_priv(ndev);
> >>>>>>> +
> >>>>>>> +     if (netif_carrier_ok(ndev)) {
> >>>>>>> +             rtl_link_chg_patch(tp);
> >>>>>>> +             pm_request_resume(&tp->pci_dev->dev);
> >>>>>>> +     } else {
> >>>>>>> +             pm_runtime_idle(&tp->pci_dev->dev);
> >>>>>>> +     }
> >>>>>>> +
> >>>>>>> +     if (net_ratelimit())
> >>>>>>> +             phy_print_status(tp->phydev);
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +static unsigned int
> >>>>>>> +rtl8169_xmii_link_ok(struct net_device *dev)
> >>>>>>> +{
> >>>>>>> +     struct rtl8169_private *tp = netdev_priv(dev);
> >>>>>>> +     unsigned int retval;
> >>>>>>> +
> >>>>>>> +     retval = (RTL_R8(tp, PHYstatus) & LinkStatus) ? 1 : 0;
> >>>>>>> +
> >>>>>>> +     return retval;
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +static void
> >>>>>>> +rtl8169_check_link_status(struct net_device *dev)
> >>>>>>> +{
> >>>>>>> +     struct rtl8169_private *tp = netdev_priv(dev);
> >>>>>>> +     int link_status_on;
> >>>>>>> +
> >>>>>>> +     link_status_on = rtl8169_xmii_link_ok(dev);
> >>>>>>> +
> >>>>>>> +     if (netif_carrier_ok(dev) == link_status_on)
> >>>>>>> +             return;
> >>>>>>> +
> >>>>>>> +     phy_mac_interrupt(tp->phydev);
> >>>>>>> +
> >>>>>>> +     r8169_phylink_handler (dev);
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +static void rtl8169_link_timer(struct timer_list *t)
> >>>>>>> +{
> >>>>>>> +     struct rtl8169_private *tp = from_timer(tp, t, link_timer);
> >>>>>>> +     struct net_device *dev = tp->dev;
> >>>>>>> +     struct timer_list *timer = t;
> >>>>>>> +     unsigned long flags;
> >>>>>>
> >>>>>> flags isn't used and triggers a compiler warning. Did you even
> >>>>>> compile-test your patch?
> >>>>>>
> >>>>>>> +
> >>>>>>> +     rtl8169_check_link_status(dev);
> >>>>>>> +
> >>>>>>> +     if (timer_pending(&tp->link_timer))
> >>>>>>> +             return;
> >>>>>>> +
> >>>>>>> +     mod_timer(timer, jiffies + RTL8169_LINK_TIMEOUT);
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +static inline void rtl8169_delete_link_timer(struct net_device *dev, struct timer_list *timer)
> >>>>>>> +{
> >>>>>>> +     del_timer_sync(timer);
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +static inline void rtl8169_request_link_timer(struct net_device *dev)
> >>>>>>> +{
> >>>>>>> +     struct rtl8169_private *tp = netdev_priv(dev);
> >>>>>>> +
> >>>>>>> +     timer_setup(&tp->link_timer, rtl8169_link_timer, TIMER_INIT_FLAGS);
> >>>>>>> +}
> >>>>>>> +
> >>>>>>>  static int rtl8169_poll(struct napi_struct *napi, int budget)
> >>>>>>>  {
> >>>>>>>       struct rtl8169_private *tp = container_of(napi, struct rtl8169_private, napi);
> >>>>>>> @@ -4624,21 +4709,6 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
> >>>>>>>       return work_done;
> >>>>>>>  }
> >>>>>>>
> >>>>>>> -static void r8169_phylink_handler(struct net_device *ndev)
> >>>>>>> -{
> >>>>>>> -     struct rtl8169_private *tp = netdev_priv(ndev);
> >>>>>>> -
> >>>>>>> -     if (netif_carrier_ok(ndev)) {
> >>>>>>> -             rtl_link_chg_patch(tp);
> >>>>>>> -             pm_request_resume(&tp->pci_dev->dev);
> >>>>>>> -     } else {
> >>>>>>> -             pm_runtime_idle(&tp->pci_dev->dev);
> >>>>>>> -     }
> >>>>>>> -
> >>>>>>> -     if (net_ratelimit())
> >>>>>>> -             phy_print_status(tp->phydev);
> >>>>>>> -}
> >>>>>>> -
> >>>>>>>  static int r8169_phy_connect(struct rtl8169_private *tp)
> >>>>>>>  {
> >>>>>>>       struct phy_device *phydev = tp->phydev;
> >>>>>>> @@ -4769,6 +4839,10 @@ static int rtl_open(struct net_device *dev)
> >>>>>>>               goto err_free_irq;
> >>>>>>>
> >>>>>>>       rtl8169_up(tp);
> >>>>>>> +
> >>>>>>> +     if (rtl_link_chng_polling_quirk(tp))
> >>>>>>> +             mod_timer(&tp->link_timer, jiffies + RTL8169_LINK_TIMEOUT);
> >>>>>>> +
> >>>>>>>       rtl8169_init_counter_offsets(tp);
> >>>>>>>       netif_start_queue(dev);
> >>>>>>>  out:
> >>>>>>> @@ -4991,7 +5065,10 @@ static const struct net_device_ops rtl_netdev_ops = {
> >>>>>>>
> >>>>>>>  static void rtl_set_irq_mask(struct rtl8169_private *tp)
> >>>>>>>  {
> >>>>>>> -     tp->irq_mask = RxOK | RxErr | TxOK | TxErr | LinkChg;
> >>>>>>> +     tp->irq_mask = RxOK | RxErr | TxOK | TxErr;
> >>>>>>> +
> >>>>>>> +     if (!rtl_link_chng_polling_quirk(tp))
> >>>>>>> +             tp->irq_mask |= LinkChg;
> >>>>>>>
> >>>>>>>       if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
> >>>>>>>               tp->irq_mask |= SYSErr | RxOverflow | RxFIFOOver;
> >>>>>>> @@ -5436,6 +5513,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >>>>>>>       if (pci_dev_run_wake(pdev))
> >>>>>>>               pm_runtime_put_sync(&pdev->dev);
> >>>>>>>
> >>>>>>> +     if (rtl_link_chng_polling_quirk(tp))
> >>>>>>> +             rtl8169_request_link_timer(dev);
> >>>>>>> +
> >>>>>>>       return 0;
> >>>>>>>  }
> >>>>>>>
> >>>>>>>
> >>>>>>
> >>>>>> All this isn't needed. If you want to switch to link status polling,
> >>>>>> why don't you simply let phylib do it? PHY_MAC_INTERRUPT -> PHY_POLL
> >>>>>
> >>>>> Thanks for suggestions, I tried to use PHY_POLL, it could do the same
> >>>>> thing that I did.
> >>>>>
> >>>>>> Your timer-based code most likely would have problems if runtime pm
> >>>>>> is enabled. Then you try to read the link status whilst NIC is in
> >>>>>> D3hot.
> >>>>
> >>
>
