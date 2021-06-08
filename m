Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E56939F054
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFHICy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhFHICu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:02:50 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07EEC061574;
        Tue,  8 Jun 2021 01:00:56 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id h24so31149546ejy.2;
        Tue, 08 Jun 2021 01:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Au4T37pZxwQ7mFzfSfWn4Yc9q6vCOt0deECCIjdAjrE=;
        b=PLqsWcPCGCfIcEiWaTQRGOIse4KNIlcBVWW/O1SIYB5od8ltM+pGjiLegCeuJqY5T1
         QdYl8d26lcRGRNdEiWWlixZKuBVMh6Go7kKu35eIdqlTwVCdGVsR2pVbUjgoNUeQ9SA2
         1r4pquRHjnLCOuuT84hdZSjBH4M4ydpi2uz1ZXiyRf1nXq5RQVlcJF4vmJHwpgzgrTrB
         SyToomiVrcEEQ4T+QDF5Hs4F357RWTJy0KDpVNv4PkwyMwcU5/hWRk+pKpR/Az5XSZaG
         juzE+4IE0y82gmqfhUExLUwnbctAnhgmhOejza3+1khjiOVKBMWKv21qGdXTiPUnA74W
         uYEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Au4T37pZxwQ7mFzfSfWn4Yc9q6vCOt0deECCIjdAjrE=;
        b=RkxVMRMpFz/3f4T8T3aV5+rhE3Xs/y7PW/pdNu5dMvCt632kWoFNyHHk99YRqP41Vh
         qLqJmbD8FQud22gdqLePQjM7q4iZy9UzrPcomZkWV4bhDXzIKrwj/KOAmICtvk39rH/I
         byLmqKLfHeUtSJbLs17pZP1IBF3EwSdvw4YYJiu71t3HxdEZwkQ5aoyHT5kw9xSN1rNN
         wpBoeUi0p9nW8fynGGf1NtNQB/eQr0m3npmm1mBZ+gSJHJDZU7Lo/3dJZhySXo6QhOkj
         GIOc8iXD9AP7G8c0EVO+8MZ+nb0xxdKSPIEiJ8jdbMgFJipDxBdRuI2umbJPAg8W8TWk
         PinA==
X-Gm-Message-State: AOAM532QgI1A5AwddH1jp6Bu7nJ7VTVJcMIioEfobVTsBgAy4XgUayB5
        LXX6LfCpORcvL3RdYEqYDive4yeq/B0=
X-Google-Smtp-Source: ABdhPJxVx1X9K1isEc7HPCpDBQ0kGz8wzJP0ZX0o1CYXKwXWzfU876EV7znqJLYKfhJxFbOzDDoCjA==
X-Received: by 2002:a17:906:a1d9:: with SMTP id bx25mr21604744ejb.363.1623139255151;
        Tue, 08 Jun 2021 01:00:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:3800:944:853f:7699:6a08? (p200300ea8f2938000944853f76996a08.dip0.t-ipconnect.de. [2003:ea:8f29:3800:944:853f:7699:6a08])
        by smtp.googlemail.com with ESMTPSA id v7sm8600517edx.38.2021.06.08.01.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 01:00:54 -0700 (PDT)
To:     Koba Ko <koba.ko@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210608032207.2923574-1-koba.ko@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] [v2] r8169: Use PHY_POLL when RTL8106E enable ASPM
Message-ID: <84eb168e-58ff-0350-74e2-c55249eb258c@gmail.com>
Date:   Tue, 8 Jun 2021 10:00:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608032207.2923574-1-koba.ko@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.06.2021 05:22, Koba Ko wrote:
> For RTL8106E, it's a Fast-ethernet chip.
> If ASPM is enabled, the link chang interrupt wouldn't be triggered
> immediately and must wait a very long time to get link change interrupt.
> Even the link change interrupt isn't triggered, the phy link is already
> established.
> 
> Use PHY_POLL to watch the status of phy link and disable
> the link change interrupt when ASPM is enabled on RTL8106E.
> 
> v2: Instead use PHY_POLL and identify 8106E by RTL_GIGA_MAC_VER_39.
> 

Still the issue description doesn't convince me that it's a hw bug
with the respective chip version. What has been stated so far:

1. (and most important) Issue doesn't occur in mainline because ASPM
   is disabled in mainline for r8169. Issue occurs only with a
   downstream kernel with ASPM enabled for r8169.

2. Issue occurs only with ASPM L1.1 not disabled, even though this chip
   version doesn't support L1 sub-states. Just L0s/L1 don't trigger
   the issue.
   The NIC doesn't announce L1.1 support, therefore PCI core won't
   enable L1 sub-states on the PCIe link between NIC and upstream
   PCI bridge.

3. Issue occurs only with a GBit-capable link partner. 100MBit link
   partners are fine. Not clear whether issue occurs with a specific
   Gbit link partner only or with GBit-capable link partners in general.

4. Only link-up interrupt is affected. Not link-down and not interrupts
   triggered by other interrupt sources.

5. Realtek couldn't confirm that there's such a hw bug on RTL8106e.

One thing that hasn't been asked yet:
Does issue occur always if you re-plug the cable? Or only on boot?
I'm asking because in the dmesg log you attached to the bugzilla issue
the following looks totally ok.

[   61.651643] r8169 0000:01:00.0 enp1s0: Link is Down
[   63.720015] r8169 0000:01:00.0 enp1s0: Link is Up - 100Mbps/Full - flow control rx/tx
[   66.685499] r8169 0000:01:00.0 enp1s0: Link is Down

> Signed-off-by: Koba Ko <koba.ko@canonical.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 2c89cde7da1e..a59cbaef2839 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -4914,6 +4914,19 @@ static const struct dev_pm_ops rtl8169_pm_ops = {
>  
>  #endif /* CONFIG_PM */
>  
> +static int rtl_phy_poll_quirk(struct rtl8169_private *tp)
> +{
> +	struct pci_dev *pdev = tp->pci_dev;
> +
> +	if (!pcie_aspm_enabled(pdev))

That's the wrong call. According to what you said earlier you want to
check for L1 sub-states, not for ASPM in general.

> +		return 0;
> +
> +	if (tp->mac_version == RTL_GIGA_MAC_VER_39)
> +		return 1;
> +
> +	return 0;
> +}
> +
>  static void rtl_wol_shutdown_quirk(struct rtl8169_private *tp)
>  {
>  	/* WoL fails with 8168b when the receiver is disabled. */
> @@ -4991,7 +5004,10 @@ static const struct net_device_ops rtl_netdev_ops = {
>  
>  static void rtl_set_irq_mask(struct rtl8169_private *tp)
>  {
> -	tp->irq_mask = RxOK | RxErr | TxOK | TxErr | LinkChg;
> +	tp->irq_mask = RxOK | RxErr | TxOK | TxErr;
> +
> +	if (!rtl_phy_poll_quirk(tp))
> +		tp->irq_mask |= LinkChg;
>  
>  	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
>  		tp->irq_mask |= SYSErr | RxOverflow | RxFIFOOver;
> @@ -5085,7 +5101,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  	new_bus->name = "r8169";
>  	new_bus->priv = tp;
>  	new_bus->parent = &pdev->dev;
> -	new_bus->irq[0] = PHY_MAC_INTERRUPT;
> +	new_bus->irq[0] =
> +		(rtl_phy_poll_quirk(tp) ? PHY_POLL : PHY_MAC_INTERRUPT);
>  	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x", pci_dev_id(pdev));
>  
>  	new_bus->read = r8169_mdio_read_reg;
> 

