Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D45399E42
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFCKCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhFCKB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:01:59 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B313C06174A;
        Thu,  3 Jun 2021 03:00:02 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id r13so3027442wmq.1;
        Thu, 03 Jun 2021 03:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=f2Vs35cSxU4APK/RpGOuwhQEmGHwriWYDxNfbFo+9lU=;
        b=DpytrSPvMgfIZo2/gaQJ0mJu0YdHS+BmcXCl+n8xJrfsRC4a9aIL3xXNq/ejrFEO2e
         QMRrgrEtpzqZWYkRSATdk9B3cwx7NO5Q1uM+MRTfzJ94gggjabNz+3Pe7YC51pYFweTu
         ZKoxiZcNqbkZidryO72g3erjMA/3yFdw/qQETqxwyF92sD/8Hyp6+jZQklnZGtUHLJLD
         dbPLmVKnRcsJ8U6p1VnFZdhQL8+dwGtPwnSsGUvjJ2/f1jQ+H4BnFcYmpihEolvcc8am
         Ze6gomiehj1ocZObRaQQ03V6v0CQ1yoznfAgBswfCvVyZyKk2IEtUgRrdFAxlFtXEYpx
         DhMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f2Vs35cSxU4APK/RpGOuwhQEmGHwriWYDxNfbFo+9lU=;
        b=dsbbenC38ZsZPAxViivfZQ+eTtkGdEgN3x0FGegQZWx9lmAGSenugib0SEn8V01e01
         j64bxnoupMe7XKy/EZaea2WvvDun7G/FvlkkUz0Q6cUfYpl2DFPZXV9aP+3TV7bUolBv
         R6plQoD9jIcijceifKn6VXx7rLvs6RSc11ko5l4j0tSiJ1+Xh9EJnd6m8A2+0P81Ue6C
         qt2Oa00ZjImCKNAhE+pZdgLXFw4VYt7R3UP5qHEZTkGpj3a7vmMHz5DgsB7VQiae3zti
         4FsdTzYm28ds7R0ukoy2x8WJcsHiR9iDXpC0lyctfxyQ/zzQJI6oUU1IjVukwlymT2Kr
         QqbQ==
X-Gm-Message-State: AOAM531zJw5oJdIbiTZ9qrl4jf21cuSPAkyddhoYcFoS/c+s73uxupux
        OEDleiFUYGuJ2w9xW0SciBYW3MCVBGM=
X-Google-Smtp-Source: ABdhPJzw9nfhf6QnG1hTZIggkR+ydQLImWlI8oOCh+DpFDnOtR6Y4wgCfMbJ7GmNvXKoKIbC3+Plpw==
X-Received: by 2002:a1c:5982:: with SMTP id n124mr35736662wmb.33.1622714400344;
        Thu, 03 Jun 2021 03:00:00 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:c00:1417:ca4:f5bb:e1fd? (p200300ea8f2f0c0014170ca4f5bbe1fd.dip0.t-ipconnect.de. [2003:ea:8f2f:c00:1417:ca4:f5bb:e1fd])
        by smtp.googlemail.com with ESMTPSA id n6sm2204845wmq.34.2021.06.03.02.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 02:59:59 -0700 (PDT)
To:     Koba Ko <koba.ko@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210603025414.226526-1-koba.ko@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] r8169: introduce polling method for link change
Message-ID: <3d2e7a11-92ad-db06-177b-c6602ef1acd4@gmail.com>
Date:   Thu, 3 Jun 2021 11:59:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210603025414.226526-1-koba.ko@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.06.2021 04:54, Koba Ko wrote:
> For RTL8106E, it's a Fast-ethernet chip.
> If ASPM is enabled, the link chang interrupt wouldn't be triggered
> immediately and must wait a very long time to get link change interrupt.
> Even the link change interrupt isn't triggered, the phy link is already
> established.
> 
At first please provide a full dmesg log and output of lspci -vv.
Do you have the firmware for the NIC loaded? Please provide "ethtool -i <if>"
output.

Does the issue affect link-down and/or link-up detection?
Do you have runtime pm enabled? Then, after 10s of link-down NIC goes to
D3hot and link-up detection triggers a PME.

> Introduce a polling method to watch the status of phy link and disable
> the link change interrupt.
> Also add a quirk for those realtek devices have the same issue.
> 
Which are the affected chip versions? Did you check with Realtek?
Your patch switches to polling for all Fast Ethernet versions,
and that's not what we want.

My suspicion would be that something is system-dependent. Else I think
we would have seen such a report before.

> Signed-off-by: Koba Ko <koba.ko@canonical.com>
> ---
>  drivers/net/ethernet/realtek/r8169.h      |   2 +
>  drivers/net/ethernet/realtek/r8169_main.c | 112 ++++++++++++++++++----
>  2 files changed, 98 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
> index 2728df46ec41..a8c71adb1b57 100644
> --- a/drivers/net/ethernet/realtek/r8169.h
> +++ b/drivers/net/ethernet/realtek/r8169.h
> @@ -11,6 +11,8 @@
>  #include <linux/types.h>
>  #include <linux/phy.h>
>  
> +#define RTL8169_LINK_TIMEOUT (1 * HZ)
> +
>  enum mac_version {
>  	/* support for ancient RTL_GIGA_MAC_VER_01 has been removed */
>  	RTL_GIGA_MAC_VER_02,
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 2c89cde7da1e..70aacc83d641 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -178,6 +178,11 @@ static const struct pci_device_id rtl8169_pci_tbl[] = {
>  
>  MODULE_DEVICE_TABLE(pci, rtl8169_pci_tbl);
>  
> +static const struct pci_device_id rtl8169_linkChg_polling_enabled[] = {
> +	{ PCI_VDEVICE(REALTEK, 0x8136), RTL_CFG_NO_GBIT },
> +	{ 0 }
> +};
> +

This doesn't seem to be used.

>  enum rtl_registers {
>  	MAC0		= 0,	/* Ethernet hardware address. */
>  	MAC4		= 4,
> @@ -618,6 +623,7 @@ struct rtl8169_private {
>  	u16 cp_cmd;
>  	u32 irq_mask;
>  	struct clk *clk;
> +	struct timer_list link_timer;
>  
>  	struct {
>  		DECLARE_BITMAP(flags, RTL_FLAG_MAX);
> @@ -1179,6 +1185,16 @@ static void rtl8168ep_stop_cmac(struct rtl8169_private *tp)
>  	RTL_W8(tp, IBCR0, RTL_R8(tp, IBCR0) & ~0x01);
>  }
>  
> +static int rtl_link_chng_polling_quirk(struct rtl8169_private *tp)
> +{
> +	struct pci_dev *pdev = tp->pci_dev;
> +
> +	if (pdev->vendor == 0x10ec && pdev->device == 0x8136 && !tp->supports_gmii)
> +		return 1;
> +
> +	return 0;
> +}
> +
>  static void rtl8168dp_driver_start(struct rtl8169_private *tp)
>  {
>  	r8168dp_oob_notify(tp, OOB_CMD_DRIVER_START);
> @@ -4608,6 +4624,75 @@ static void rtl_task(struct work_struct *work)
>  	rtnl_unlock();
>  }
>  
> +static void r8169_phylink_handler(struct net_device *ndev)
> +{
> +	struct rtl8169_private *tp = netdev_priv(ndev);
> +
> +	if (netif_carrier_ok(ndev)) {
> +		rtl_link_chg_patch(tp);
> +		pm_request_resume(&tp->pci_dev->dev);
> +	} else {
> +		pm_runtime_idle(&tp->pci_dev->dev);
> +	}
> +
> +	if (net_ratelimit())
> +		phy_print_status(tp->phydev);
> +}
> +
> +static unsigned int
> +rtl8169_xmii_link_ok(struct net_device *dev)
> +{
> +	struct rtl8169_private *tp = netdev_priv(dev);
> +	unsigned int retval;
> +
> +	retval = (RTL_R8(tp, PHYstatus) & LinkStatus) ? 1 : 0;
> +
> +	return retval;
> +}
> +
> +static void
> +rtl8169_check_link_status(struct net_device *dev)
> +{
> +	struct rtl8169_private *tp = netdev_priv(dev);
> +	int link_status_on;
> +
> +	link_status_on = rtl8169_xmii_link_ok(dev);
> +
> +	if (netif_carrier_ok(dev) == link_status_on)
> +		return;
> +
> +	phy_mac_interrupt(tp->phydev);
> +
> +	r8169_phylink_handler (dev);
> +}
> +
> +static void rtl8169_link_timer(struct timer_list *t)
> +{
> +	struct rtl8169_private *tp = from_timer(tp, t, link_timer);
> +	struct net_device *dev = tp->dev;
> +	struct timer_list *timer = t;
> +	unsigned long flags;

flags isn't used and triggers a compiler warning. Did you even
compile-test your patch?

> +
> +	rtl8169_check_link_status(dev);
> +
> +	if (timer_pending(&tp->link_timer))
> +		return;
> +
> +	mod_timer(timer, jiffies + RTL8169_LINK_TIMEOUT);
> +}
> +
> +static inline void rtl8169_delete_link_timer(struct net_device *dev, struct timer_list *timer)
> +{
> +	del_timer_sync(timer);
> +}
> +
> +static inline void rtl8169_request_link_timer(struct net_device *dev)
> +{
> +	struct rtl8169_private *tp = netdev_priv(dev);
> +
> +	timer_setup(&tp->link_timer, rtl8169_link_timer, TIMER_INIT_FLAGS);
> +}
> +
>  static int rtl8169_poll(struct napi_struct *napi, int budget)
>  {
>  	struct rtl8169_private *tp = container_of(napi, struct rtl8169_private, napi);
> @@ -4624,21 +4709,6 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
>  	return work_done;
>  }
>  
> -static void r8169_phylink_handler(struct net_device *ndev)
> -{
> -	struct rtl8169_private *tp = netdev_priv(ndev);
> -
> -	if (netif_carrier_ok(ndev)) {
> -		rtl_link_chg_patch(tp);
> -		pm_request_resume(&tp->pci_dev->dev);
> -	} else {
> -		pm_runtime_idle(&tp->pci_dev->dev);
> -	}
> -
> -	if (net_ratelimit())
> -		phy_print_status(tp->phydev);
> -}
> -
>  static int r8169_phy_connect(struct rtl8169_private *tp)
>  {
>  	struct phy_device *phydev = tp->phydev;
> @@ -4769,6 +4839,10 @@ static int rtl_open(struct net_device *dev)
>  		goto err_free_irq;
>  
>  	rtl8169_up(tp);
> +
> +	if (rtl_link_chng_polling_quirk(tp))
> +		mod_timer(&tp->link_timer, jiffies + RTL8169_LINK_TIMEOUT);
> +
>  	rtl8169_init_counter_offsets(tp);
>  	netif_start_queue(dev);
>  out:
> @@ -4991,7 +5065,10 @@ static const struct net_device_ops rtl_netdev_ops = {
>  
>  static void rtl_set_irq_mask(struct rtl8169_private *tp)
>  {
> -	tp->irq_mask = RxOK | RxErr | TxOK | TxErr | LinkChg;
> +	tp->irq_mask = RxOK | RxErr | TxOK | TxErr;
> +
> +	if (!rtl_link_chng_polling_quirk(tp))
> +		tp->irq_mask |= LinkChg;
>  
>  	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
>  		tp->irq_mask |= SYSErr | RxOverflow | RxFIFOOver;
> @@ -5436,6 +5513,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (pci_dev_run_wake(pdev))
>  		pm_runtime_put_sync(&pdev->dev);
>  
> +	if (rtl_link_chng_polling_quirk(tp))
> +		rtl8169_request_link_timer(dev);
> +
>  	return 0;
>  }
>  
> 

All this isn't needed. If you want to switch to link status polling,
why don't you simply let phylib do it? PHY_MAC_INTERRUPT -> PHY_POLL

Your timer-based code most likely would have problems if runtime pm
is enabled. Then you try to read the link status whilst NIC is in
D3hot.
