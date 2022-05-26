Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B217534D5B
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 12:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346630AbiEZKet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 06:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241953AbiEZKer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 06:34:47 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA6CCC16C
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 03:34:46 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220526103442euoutp010a3336131b0683ba2087587c48fe969e~yoTnJ_qSq3174331743euoutp01I
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 10:34:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220526103442euoutp010a3336131b0683ba2087587c48fe969e~yoTnJ_qSq3174331743euoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653561282;
        bh=oOj0KQk1xU/k17SS2yM6mKwI+S1ERvO9x6+c0kti3UI=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=G/AyPSRGev/fG2gkBPykEV9Tyso2qqZCVPJ7ZgWzBDeiGUcGKXSnAJsmL/mtDE5OT
         ZZsssWMXVxVpxG9mSfP8Z/jqe0NtjS43HMYQUwkWd7Ljw4/XlsmDyzwkp7UIENjOFn
         dU1OnWOeu2casiUMXKgjMNj3jsd5o5cHNiDba7Nw=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220526103442eucas1p1392a6aa42b3924a2a66843784f3c3274~yoTmq92fX2658826588eucas1p1J;
        Thu, 26 May 2022 10:34:42 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 28.A0.09887.2C75F826; Thu, 26
        May 2022 11:34:42 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220526103441eucas1p14f347b72295c50297061706cac9d54b9~yoTl_do-X0512705127eucas1p1a;
        Thu, 26 May 2022 10:34:41 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220526103441eusmtrp141c0c30578b34d66bb9922e7dfe6b578~yoTl9cy5d1620816208eusmtrp1L;
        Thu, 26 May 2022 10:34:41 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-f0-628f57c22dff
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 11.6E.09404.1C75F826; Thu, 26
        May 2022 11:34:41 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220526103440eusmtip198df46b735ffbadad23d4dd5fd5b1c66~yoTk3KvK30401304013eusmtip1F;
        Thu, 26 May 2022 10:34:40 +0000 (GMT)
Message-ID: <8d26c979-62ba-3263-2a13-3e872c535707@samsung.com>
Date:   Thu, 26 May 2022 12:34:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH net] net: phy: Don't trigger state machine while in
 suspend
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-samsung-soc@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <688f559346ea747d3b47a4d16ef8277e093f9ebe.1653556322.git.lukas@wunner.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xbVRzHd+693D6ykkuBcQKExZqxzShsPpKzYVDMxJtlZrgsWyRELXDH
        YIWS3pWhJoZ0A+EKDNiw2PAoMl51vDqejUxWsURrViqy0a74ADoYghXoYDicWu6m/Pf5/c73
        e36/78kR4lIdGSpMzzrLqLLkChkpJnot67bnzCcvJu+7USpA1QUOAbJNmnF01+EkUbXtAoHc
        likBelD7NYlsWg2OPvdU+SGbrVOARntL/dDMF00YqrJdx5C5chCgYa+BQHOzYegXO0cgi34H
        4qZbSaTPdxNo1boA0PnleQw9LLeTr+6gx27Zcbp/8gqgu1sdGD2gmxTQfyy9Q+uNatpddklA
        Gw1FJD3s+BXQA/0rGO160Ahoz/Vxknb8Po/Tf58fI+iO7nGCXjFGJEgTxS+nMor0HEYVHfue
        +PSXbV4yeyE6t8e0AfLAtUgOiISQehE2D/bgHBALpVQLgCUeA8EXXgDLZi3Ap5JSKwDeqXjp
        iaPINCvgRc0AOuvbSb5YAnC13IJxQCiUULFwuCHDZyCoXbBz4D7mYwkVAL/9bIbwcTCVDOt6
        8/18HEi9BWsaajcZp0Kgc6YO890ZRF3B4EVuHPgKnGoh4JhRv6kiqf2QW+RIH4uoE7BmrULA
        u3fCvsXqzUCQqhfD1ct2nN/7ECxZbwE8B8L5kW4Bz+HQeqmY8G0NKSX8q+oFvp0Lb/129bE1
        Brpu/kn6JDi1F3aYovl2HHRMVOC80x9OLAbwG/jDil7t47YEFhZIeXUk1I20/zfzxugPeBmQ
        6ba8im5Let2WLLr/5+oBYQAhjJrNTGPY57OYc1GsPJNVZ6VFpSgzjeDf72t9NOLtB83zS1Fm
        gAmBGUAhLguSjLpLkqWSVPn7HzAq5bsqtYJhzSBMSMhCJCnpnXIplSY/y5xhmGxG9eQUE4pC
        87BGDVlfPmSYDCemni1Otte9Vl1emBgTe3Th55VA9dGcvIxRZ9rlOGkB8dGFgPXi9AG59JTB
        xSkb2wun4hVPdyVkN7wRvPemf/zQwzrRyOqPXYpU4Orb3n48MubRkbaeyuWQe9/sTImwdrVq
        az/ZN37HLQqTc+FJmrui198Mu509rdlzWP5dR9O1/KimT50fa9tC5yLqo7dzrGat6CfvsC73
        w42knIP3KNOJ26XTG7Kr6o6EpOUJz/d+2w6FBrL3h2xtu1TWrqmJweaDNSy+rEx8+9hX4qAD
        C+LD2leO716rCF6Pq8T7BjPOnZrbE29W53kOnDlpCi4BT7lU3dvQEQ3EZQR7Wr7/GVzFyv8B
        U+MB2S0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA01SfUwbZRzOe3e9azcbzwLjDRohjS6OxevHoHtB7BgxcozInDEu2ZTZbhdg
        Ky32Y9mIf+DYdKuCfDgGTVfqWowUCNgVBsSR2JUqw1jqUrRIDTo6WN2GsE2ZLiClMeG/J/k9
        X/nl4eOiXl4av0Jr5PRalUZMbiLGV76NvPjN/k/V0pXpJGT9MEyhQMSLo1vhKRJZA6cJFPX/
        TqFl2zUSBS6cwtGlhVYeCgT6KDQxUM9Ds11fYKg1MIIh7/mrAPkeuAg0P/c0mgmaCeS3b0Hm
        m50ksp+JEuiv8TsA1S7FMPRvY5DM38LemAzi7GDECVhPZxhjhywRiv1zsZS1u01stKGZYt2u
        cyTrC/8G2KHB+xg7vdwB2IWREMmG78VwdrX2BsH2ekIEe9/97OuiA0yeXmcychnlOoPxZfFB
        GZIzshzEyLNyGNmOne/kyrPFEmXeEU5TcZzTS5TvMuVf9zwgq+5ITvQPPwY14PJWMxDwIZ0F
        zw3PUWawiS+iOwBsvRYkEodn4FhLDS+Bk+DjSTOZIC0A6HCH1hR8vpBWQp/jaJxD0M/DvqGH
        WBwL6afgWNvsuk8KrYa2q10gjpPoffCiw7buidOpcGq2fZ2fTDsx6OzJj/vjdDcB+85fJxJh
        nQB+9sFtKs4iaRk03423EPAF9Fvw4t9NVMJJAc39ZpDA6fDKXSveAESWDUUsGwItGySWDRI7
        IFwgmTMZKssqDXLGoKo0mLRlzGFdpRusLWfA/8gzCDpji4wXYHzgBZCPi5OFE9E6tUh4RHWy
        mtPrDulNGs7gBdlr32jE01IO69ampzUekimk2bIsRY40O0exQ5wqLKo6qxLRZSojd4zjqjj9
        /zqML0irwRS9Htf8dR/mouTKyE2LZQDrqOg25u0ZByU/tvjekNIvjc3t9bV9359rXzzZ/UJG
        MblruiLGKzCmNf+QgjmerF94pXh/aEYwzHz5q0KtTPpDXV1TsnLrq7OuYz7J3PTMgfckjqkT
        z5VuHw/qzjTVCydNeMYnU5aPYyOouc4yubr7UUFhbbv/zX9Gi63aoqXv/K++5lRe8Oz5WdY+
        XzD69ufbDxYWHrVHid3M3verj6dWt8maNPs++il6b3Mg1zbYCksat6rrnOkTS/7Qldu7rKfL
        dmoMRHqRrbgrc1TqzzwFnhggt1nzNut7KHPe5UvRXzIfTiz7V0u7Gvqi21rye8WEoVwly8T1
        BtV/RJ1m6sIDAAA=
X-CMS-MailID: 20220526103441eucas1p14f347b72295c50297061706cac9d54b9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220526092819eucas1p2f05c11c571f47b0330e42d00b5d32b50
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220526092819eucas1p2f05c11c571f47b0330e42d00b5d32b50
References: <CGME20220526092819eucas1p2f05c11c571f47b0330e42d00b5d32b50@eucas1p2.samsung.com>
        <688f559346ea747d3b47a4d16ef8277e093f9ebe.1653556322.git.lukas@wunner.de>
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukas,

On 26.05.2022 11:28, Lukas Wunner wrote:
> Upon system sleep, mdio_bus_phy_suspend() stops the phy_state_machine(),
> but subsequent interrupts may retrigger it:
>
> They may have been left enabled to facilitate wakeup and are not
> quiesced until the ->suspend_noirq() phase.  Unwanted interrupts may
> hence occur between mdio_bus_phy_suspend() and dpm_suspend_noirq(),
> as well as between dpm_resume_noirq() and mdio_bus_phy_resume().
>
> Amend phy_interrupt() to avoid triggering the state machine if the PHY
> is suspended.  Signal wakeup instead if the attached net_device or its
> parent has been configured as a wakeup source.  (Those conditions are
> identical to mdio_bus_phy_may_suspend().)  Postpone handling of the
> interrupt until the PHY has resumed.
>
> Before stopping the phy_state_machine() in mdio_bus_phy_suspend(),
> wait for a concurrent phy_interrupt() to run to completion.  That is
> necessary because phy_interrupt() may have checked the PHY's suspend
> status before the system sleep transition commenced and it may thus
> retrigger the state machine after it was stopped.
>
> Likewise, after re-enabling interrupt handling in mdio_bus_phy_resume(),
> wait for a concurrent phy_interrupt() to complete to ensure that
> interrupts which it postponed are properly rerun.
>
> Fixes: 1ce8b37241ed ("usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling")

I'm not sure if this is a right commit here. It revealed the issue, but 
it is not directly related to the net/phy code.

> Link: https://lore.kernel.org/netdev/a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com/
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/net/phy/phy.c        | 23 +++++++++++++++++++++++
>   drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
>   include/linux/phy.h          |  6 ++++++
>   3 files changed, 52 insertions(+)
>
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index ef62f357b76d..8d3ee3a6495b 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -31,6 +31,7 @@
>   #include <linux/io.h>
>   #include <linux/uaccess.h>
>   #include <linux/atomic.h>
> +#include <linux/suspend.h>
>   #include <net/netlink.h>
>   #include <net/genetlink.h>
>   #include <net/sock.h>
> @@ -976,6 +977,28 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
>   	struct phy_driver *drv = phydev->drv;
>   	irqreturn_t ret;
>   
> +	/* Wakeup interrupts may occur during a system sleep transition.
> +	 * Postpone handling until the PHY has resumed.
> +	 */
> +	if (IS_ENABLED(CONFIG_PM_SLEEP) && phydev->irq_suspended) {
> +		struct net_device *netdev = phydev->attached_dev;
> +
> +		if (netdev) {
> +			struct device *parent = netdev->dev.parent;
> +
> +			if (netdev->wol_enabled)
> +				pm_system_wakeup();
> +			else if (device_may_wakeup(&netdev->dev))
> +				pm_wakeup_dev_event(&netdev->dev, 0, true);
> +			else if (parent && device_may_wakeup(parent))
> +				pm_wakeup_dev_event(parent, 0, true);
> +		}
> +
> +		phydev->irq_rerun = 1;
> +		disable_irq_nosync(irq);
> +		return IRQ_HANDLED;
> +	}
> +
>   	mutex_lock(&phydev->lock);
>   	ret = drv->handle_interrupt(phydev);
>   	mutex_unlock(&phydev->lock);
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 431a8719c635..46acddd865a7 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -278,6 +278,15 @@ static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
>   	if (phydev->mac_managed_pm)
>   		return 0;
>   
> +	/* Wakeup interrupts may occur during the system sleep transition when
> +	 * the PHY is inaccessible. Set flag to postpone handling until the PHY
> +	 * has resumed. Wait for concurrent interrupt handler to complete.
> +	 */
> +	if (phy_interrupt_is_valid(phydev)) {
> +		phydev->irq_suspended = 1;
> +		synchronize_irq(phydev->irq);
> +	}
> +
>   	/* We must stop the state machine manually, otherwise it stops out of
>   	 * control, possibly with the phydev->lock held. Upon resume, netdev
>   	 * may call phy routines that try to grab the same lock, and that may
> @@ -315,6 +324,20 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
>   	if (ret < 0)
>   		return ret;
>   no_resume:
> +	if (phy_interrupt_is_valid(phydev)) {
> +		phydev->irq_suspended = 0;
> +		synchronize_irq(phydev->irq);
> +
> +		/* Rerun interrupts which were postponed by phy_interrupt()
> +		 * because they occurred during the system sleep transition.
> +		 */
> +		if (phydev->irq_rerun) {
> +			phydev->irq_rerun = 0;
> +			enable_irq(phydev->irq);
> +			irq_wake_thread(phydev->irq, phydev);
> +		}
> +	}
> +
>   	if (phydev->attached_dev && phydev->adjust_link)
>   		phy_start_machine(phydev);
>   
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 508f1149665b..b09f7d36cff2 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -572,6 +572,10 @@ struct macsec_ops;
>    * @mdix_ctrl: User setting of crossover
>    * @pma_extable: Cached value of PMA/PMD Extended Abilities Register
>    * @interrupts: Flag interrupts have been enabled
> + * @irq_suspended: Flag indicating PHY is suspended and therefore interrupt
> + *                 handling shall be postponed until PHY has resumed
> + * @irq_rerun: Flag indicating interrupts occurred while PHY was suspended,
> + *             requiring a rerun of the interrupt handler after resume
>    * @interface: enum phy_interface_t value
>    * @skb: Netlink message for cable diagnostics
>    * @nest: Netlink nest used for cable diagnostics
> @@ -626,6 +630,8 @@ struct phy_device {
>   
>   	/* Interrupts are enabled */
>   	unsigned interrupts:1;
> +	unsigned irq_suspended:1;
> +	unsigned irq_rerun:1;
>   
>   	enum phy_state state;
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

