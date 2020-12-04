Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D4B2CF61D
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 22:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgLDV0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 16:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgLDV0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 16:26:42 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D237C061A4F;
        Fri,  4 Dec 2020 13:26:02 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id i9so7254435ioo.2;
        Fri, 04 Dec 2020 13:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dcobOCg4elJ1lBIJnbdqI7sJMeQVb3HqQ2OWJay91KA=;
        b=KrtuBt5MXQtj9zWIsKhfga5hBQGSBID2664sPjRwL0rOihm6EPbkABs+Av6MkIjVjn
         TBPHWrpwNtWgF9I8br+bubAJv3JAmgoMVp3LsbwaXchyw6SNLlL3yeVIl1bWu2+JbzHq
         9AZFKzvEsjkgCvBLOA9LA3e0RKcLhXFg/29w/NoPzWFfX3UKTJMdbepL1xKlcnRyypBo
         643+hIgkR8PNRbifZcMEQGO/A7JByE0BjJTAlItgEowUH3wUCYMoE2IwO1cT+wb4Ipyr
         E7hDtUUF3ceyao47yCQXPYB6MtXLcAWnpfQbCPr2e7sAiNDKzj4jy5ME1NFEvREvV70U
         JXKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dcobOCg4elJ1lBIJnbdqI7sJMeQVb3HqQ2OWJay91KA=;
        b=OZdDGB/ZnrsS9D+m9HEYtisFUbpqE6457Vi1Ldg3eDwPyoJBkNAOINJJVYOheEh+bZ
         pJboFGYqXI53CR+GFoY9wBMo9xvZlvXIssdi4GVIie36hol+sYN7mZLSPGf4U9fL59Kp
         VSmDD+fOLeMQrZ1DKohKo+GcarBKtoKjUohkzJxWqfHnb5vxyEif3cmjUPyDPvYWlO6s
         Vo+c8tXD4w+v4LDESVfzZndCxkr1OlKdoEmHkBAV4dBxu02B0B+IdqvLbcbxMVXu+h3n
         CSrTHBKVj4SIpd+AniOTXQ6/b93dv7cCK9OSiFmTNJVuWDLHMBst0/V5Kta2uRnIQU5V
         Bxog==
X-Gm-Message-State: AOAM531ywDffW1y/7urqI9kkd8YTW31oCPLGGUGAyQCrm9X8Logcu0R0
        ljHOYdMYoVIj9WF8ZYs0A4fofRn6oS/V7FiR8FA=
X-Google-Smtp-Source: ABdhPJx86Powa4ZnC6gzQpBuytC8EmVW3lKN6t9bFbw4cSl/I0aTSHWtuY+5ZF97rQ6aFHJHwlv9tMGf0x4ij9I4aRQ=
X-Received: by 2002:a02:4:: with SMTP id 4mr8851115jaa.121.1607117161437; Fri,
 04 Dec 2020 13:26:01 -0800 (PST)
MIME-Version: 1.0
References: <20201204200920.133780-1-mario.limonciello@dell.com> <20201204200920.133780-3-mario.limonciello@dell.com>
In-Reply-To: <20201204200920.133780-3-mario.limonciello@dell.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 4 Dec 2020 13:25:50 -0800
Message-ID: <CAKgT0Ucz5zDp3fEJFpt1x1e+OcLCxOZVyo5KK5sM_LktbLQH3Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] e1000e: Move all S0ix related code into its own
 source file
To:     Mario Limonciello <mario.limonciello@dell.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>,
        David Arcari <darcari@redhat.com>,
        Yijun Shen <Yijun.Shen@dell.com>, Perry.Yuan@dell.com,
        anthony.wong@canonical.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 12:09 PM Mario Limonciello
<mario.limonciello@dell.com> wrote:
>
> Introduce a flag to indicate the device should be using the S0ix
> flows and use this flag to run those functions.
>
> Splitting the code to it's own file will make future heuristics
> more self contained.
>
> Tested-by: Yijun Shen <yijun.shen@dell.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>

One minor issue pointed out below.

> ---
>  drivers/net/ethernet/intel/e1000e/Makefile |   2 +-
>  drivers/net/ethernet/intel/e1000e/e1000.h  |   4 +
>  drivers/net/ethernet/intel/e1000e/netdev.c | 272 +-------------------
>  drivers/net/ethernet/intel/e1000e/s0ix.c   | 280 +++++++++++++++++++++
>  4 files changed, 290 insertions(+), 268 deletions(-)
>  create mode 100644 drivers/net/ethernet/intel/e1000e/s0ix.c
>
> diff --git a/drivers/net/ethernet/intel/e1000e/Makefile b/drivers/net/ethernet/intel/e1000e/Makefile
> index 44e58b6e7660..f2332c01f86c 100644
> --- a/drivers/net/ethernet/intel/e1000e/Makefile
> +++ b/drivers/net/ethernet/intel/e1000e/Makefile
> @@ -9,5 +9,5 @@ obj-$(CONFIG_E1000E) += e1000e.o
>
>  e1000e-objs := 82571.o ich8lan.o 80003es2lan.o \
>                mac.o manage.o nvm.o phy.o \
> -              param.o ethtool.o netdev.o ptp.o
> +              param.o ethtool.o netdev.o s0ix.o ptp.o
>
> diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
> index ba7a0f8f6937..b13f956285ae 100644
> --- a/drivers/net/ethernet/intel/e1000e/e1000.h
> +++ b/drivers/net/ethernet/intel/e1000e/e1000.h
> @@ -436,6 +436,7 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca);
>  #define FLAG2_DFLT_CRC_STRIPPING          BIT(12)
>  #define FLAG2_CHECK_RX_HWTSTAMP           BIT(13)
>  #define FLAG2_CHECK_SYSTIM_OVERFLOW       BIT(14)
> +#define FLAG2_ENABLE_S0IX_FLOWS           BIT(15)
>
>  #define E1000_RX_DESC_PS(R, i)     \
>         (&(((union e1000_rx_desc_packet_split *)((R).desc))[i]))
> @@ -462,6 +463,9 @@ enum latency_range {
>  extern char e1000e_driver_name[];
>
>  void e1000e_check_options(struct e1000_adapter *adapter);
> +void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter);
> +void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter);
> +void e1000e_maybe_enable_s0ix(struct e1000_adapter *adapter);
>  void e1000e_set_ethtool_ops(struct net_device *netdev);
>
>  int e1000e_open(struct net_device *netdev);
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 128ab6898070..cd9839e86615 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c

<snip>

>  static int e1000e_pm_freeze(struct device *dev)
>  {
>         struct net_device *netdev = dev_get_drvdata(dev);
> @@ -6962,7 +6701,6 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
>         struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
>         struct e1000_adapter *adapter = netdev_priv(netdev);
>         struct pci_dev *pdev = to_pci_dev(dev);
> -       struct e1000_hw *hw = &adapter->hw;
>         int rc;
>
>         e1000e_flush_lpic(pdev);
> @@ -6974,8 +6712,7 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
>                 e1000e_pm_thaw(dev);
>
>         /* Introduce S0ix implementation */
> -       if (hw->mac.type >= e1000_pch_cnp &&
> -           !e1000e_check_me(hw->adapter->pdev->device))
> +       if (adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS)
>                 e1000e_s0ix_entry_flow(adapter);

So the placement of this code raises some issues. It isn't a problem
with your patch but a bug in the driver that needs to be addressed. I
am assuming you only need to perform this flow if you successfully
froze the part. However this is doing it in all cases, which is why
the e1000e_pm_thaw is being called before you call this code. This is
something that should probably be an "else if" rather than a seperate
if statement.

>
>         return rc;
> @@ -6986,12 +6723,10 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
>         struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
>         struct e1000_adapter *adapter = netdev_priv(netdev);
>         struct pci_dev *pdev = to_pci_dev(dev);
> -       struct e1000_hw *hw = &adapter->hw;
>         int rc;
>
>         /* Introduce S0ix implementation */
> -       if (hw->mac.type >= e1000_pch_cnp &&
> -           !e1000e_check_me(hw->adapter->pdev->device))
> +       if (adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS)
>                 e1000e_s0ix_exit_flow(adapter);
>
>         rc = __e1000_resume(pdev);
> @@ -7655,6 +7390,9 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>         if (!(adapter->flags & FLAG_HAS_AMT))
>                 e1000e_get_hw_control(adapter);
>
> +       /* use heuristics to decide whether to enable s0ix flows */
> +       e1000e_maybe_enable_s0ix(adapter);
> +
>         strlcpy(netdev->name, "eth%d", sizeof(netdev->name));
>         err = register_netdev(netdev);
>         if (err)
