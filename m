Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E7B27B7A3
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgI1XOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgI1XNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:43 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72143C05BD43;
        Mon, 28 Sep 2020 16:04:43 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z25so2895293iol.10;
        Mon, 28 Sep 2020 16:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1KseT/svdKVvJYTJTQpp56Ar8bPIQrMokOTCZMQ15rc=;
        b=d1oxmyG/ypY91Fb3AbMotpeF8MEzxfA/5DNjoQRwhoeh04debN3CSOa6qe/h7WetAp
         WapYVV6eD8jP/F7S+y6HYqkKTjIsXfIIxkeyc/HzPSbfDvUqst8aDK9arRJ0A5+o/qdN
         +6qkNjXAa2nZLHrmoXAH8B23Zq/J1sP66Qg+3+BXVQ8Y4p03kaPi75WET9CbUl679xNC
         +fHoM1lL7U1gsR2QOZqDDs9v6pPFoZmxRwLNQ/YOX12qPhLXh1hg7nHk0ZFKOTXEzq3p
         9PM/Ale+256/qTh3y/0AfMKl0Ddskr5pSGfrcT8bVRAaEoIVraqGQFNMhebeG5hzimvk
         mjHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1KseT/svdKVvJYTJTQpp56Ar8bPIQrMokOTCZMQ15rc=;
        b=Oopp5Hhd58Lssd7BMnIHaQuqNUVWfATfD+bPFzlFJLxE0TQPDEbOpg4hkLUCPMx+MU
         GkVLUDOJ9WUo+ZGK5S8b2RyzevJ72GHJL2OAAesdiSUtaB7GW872MxQL76dGS7LcRScn
         5ApJWwXbsXDkzQAUpIObhys5zMKOvWedBdlUch7oQgCAOW8AsreP4fS1vfSNHuVh4eGM
         CMQsGiApNyDFdPfoNEp5fhXT7ICQ8Y67Ngh7wq978f7X8Wb0r81EmhLDXperBY6uiVR0
         QiBGsp1OwJ8+1t6pMhBr8jWXt7c47ejpzIEWhstpVDIqEL4Ha6rsR9wwm3/ceZLyp/F7
         DDgA==
X-Gm-Message-State: AOAM5305gnEgvkgJjowxSKxLakeH9zUjPWJph4S3K3LWMAqVRfaI5cKL
        YTvfnglRKH/lVxllY+vBCiGuRh0Ehi5woGv8Cpo=
X-Google-Smtp-Source: ABdhPJy8fKGk4i2gt+Z971pAw5a/T0PJzv1K80XuRjSiR9lSjSp1Cx0n8Ja8XgZ7afOYIc3DouJfdcqfHrCmVR1/+14=
X-Received: by 2002:a02:c004:: with SMTP id y4mr730552jai.121.1601334282736;
 Mon, 28 Sep 2020 16:04:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200927194846.045411263@linutronix.de> <20200927194920.824108021@linutronix.de>
In-Reply-To: <20200927194920.824108021@linutronix.de>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 28 Sep 2020 16:04:31 -0700
Message-ID: <CAKgT0Uc0bB8nr0Kh-UHS=dEW3nu=DrYeio1w6snkzFSB=tQgXw@mail.gmail.com>
Subject: Re: [patch 10/35] net: intel: Remove in_interrupt() warnings
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 27, 2020 at 1:00 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>
> in_interrupt() is ill defined and does not provide what the name
> suggests. The usage especially in driver code is deprecated and a tree wide
> effort to clean up and consolidate the (ab)usage of in_interrupt() and
> related checks is happening.
>
> In this case the checks cover only parts of the contexts in which these
> functions cannot be called. They fail to detect preemption or interrupt
> disabled invocations.
>
> As the functions which are invoked from the various places contain already
> a broad variety of checks (always enabled or debug option dependent) cover
> all invalid conditions already, there is no point in having inconsistent
> warnings in those drivers.
>
> Just remove them.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org

The patch looks good to me.

Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

> ---
>  drivers/net/ethernet/intel/e1000/e1000_main.c     |    1 -
>  drivers/net/ethernet/intel/fm10k/fm10k_pci.c      |    2 --
>  drivers/net/ethernet/intel/i40e/i40e_main.c       |    4 ----
>  drivers/net/ethernet/intel/ice/ice_main.c         |    1 -
>  drivers/net/ethernet/intel/igb/igb_main.c         |    1 -
>  drivers/net/ethernet/intel/igc/igc_main.c         |    1 -
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |    1 -
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |    2 --
>  8 files changed, 13 deletions(-)
>
> --- a/drivers/net/ethernet/intel/e1000/e1000_main.c
> +++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
> @@ -534,7 +534,6 @@ void e1000_down(struct e1000_adapter *ad
>
>  void e1000_reinit_locked(struct e1000_adapter *adapter)
>  {
> -       WARN_ON(in_interrupt());
>         while (test_and_set_bit(__E1000_RESETTING, &adapter->flags))
>                 msleep(1);
>
> --- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
> +++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
> @@ -221,8 +221,6 @@ static bool fm10k_prepare_for_reset(stru
>  {
>         struct net_device *netdev = interface->netdev;
>
> -       WARN_ON(in_interrupt());
> -
>         /* put off any impending NetWatchDogTimeout */
>         netif_trans_update(netdev);
>
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -6689,7 +6689,6 @@ static void i40e_vsi_reinit_locked(struc
>  {
>         struct i40e_pf *pf = vsi->back;
>
> -       WARN_ON(in_interrupt());
>         while (test_and_set_bit(__I40E_CONFIG_BUSY, pf->state))
>                 usleep_range(1000, 2000);
>         i40e_down(vsi);
> @@ -8462,9 +8461,6 @@ void i40e_do_reset(struct i40e_pf *pf, u
>  {
>         u32 val;
>
> -       WARN_ON(in_interrupt());
> -
> -
>         /* do the biggest reset indicated */
>         if (reset_flags & BIT_ULL(__I40E_GLOBAL_RESET_REQUESTED)) {
>
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -486,7 +486,6 @@ static void ice_do_reset(struct ice_pf *
>         struct ice_hw *hw = &pf->hw;
>
>         dev_dbg(dev, "reset_type 0x%x requested\n", reset_type);
> -       WARN_ON(in_interrupt());
>
>         ice_prepare_for_reset(pf);
>
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -2220,7 +2220,6 @@ void igb_down(struct igb_adapter *adapte
>
>  void igb_reinit_locked(struct igb_adapter *adapter)
>  {
> -       WARN_ON(in_interrupt());
>         while (test_and_set_bit(__IGB_RESETTING, &adapter->state))
>                 usleep_range(1000, 2000);
>         igb_down(adapter);
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -3831,7 +3831,6 @@ void igc_down(struct igc_adapter *adapte
>
>  void igc_reinit_locked(struct igc_adapter *adapter)
>  {
> -       WARN_ON(in_interrupt());
>         while (test_and_set_bit(__IGC_RESETTING, &adapter->state))
>                 usleep_range(1000, 2000);
>         igc_down(adapter);
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -5677,7 +5677,6 @@ static void ixgbe_up_complete(struct ixg
>
>  void ixgbe_reinit_locked(struct ixgbe_adapter *adapter)
>  {
> -       WARN_ON(in_interrupt());
>         /* put off any impending NetWatchDogTimeout */
>         netif_trans_update(adapter->netdev);
>
> --- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> +++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
> @@ -2526,8 +2526,6 @@ void ixgbevf_down(struct ixgbevf_adapter
>
>  void ixgbevf_reinit_locked(struct ixgbevf_adapter *adapter)
>  {
> -       WARN_ON(in_interrupt());
> -
>         while (test_and_set_bit(__IXGBEVF_RESETTING, &adapter->state))
>                 msleep(1);
>
>
