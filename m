Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E35352DF2D
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 23:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245167AbiESVWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 17:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245148AbiESVWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 17:22:48 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610E910276E
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 14:22:45 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220519212240euoutp02a5258810f04cc7eeb1cd58b93b098883~wnoWmFCNR2022920229euoutp02C
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 21:22:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220519212240euoutp02a5258810f04cc7eeb1cd58b93b098883~wnoWmFCNR2022920229euoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652995360;
        bh=ziqlar9sQ+tJZ5eulBTf606ZaUaq1zZX8QQBNE91++Q=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=orVNttlWM/Nl+tWHgCYuEcN9UXwZ0149yg3DhFM8vNSFa9E8Z3J8CQI9mRAV1VTJI
         u4mgSPPCHl9cjAsoCdttaWYOBODkiSyteKmkPTvLpG7LlBH0EcUss9kGmzNc5MctpR
         Bxdj9uR8Yn4xP+7fYEGLhrJPL5YdjR+1RbQ9Se0s=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220519212238eucas1p1c06265e17a33da55aa9b99ac00633941~wnoVN5iaf0443204432eucas1p1l;
        Thu, 19 May 2022 21:22:38 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id FB.83.09887.E15B6826; Thu, 19
        May 2022 22:22:38 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220519212237eucas1p28d609f0dec68094e98eed9fe74963746~wnoT_DeOL0727507275eucas1p2p;
        Thu, 19 May 2022 21:22:37 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220519212237eusmtrp24c532a6c9b0a085e2786be2d17a9b623~wnoT7ND2I2524725247eusmtrp2B;
        Thu, 19 May 2022 21:22:37 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-b6-6286b51e8619
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 90.00.09404.D15B6826; Thu, 19
        May 2022 22:22:37 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220519212235eusmtip27608a5c1d715882ac3e9bbee50afcb5e~wnoSwfSRx2614426144eusmtip2S;
        Thu, 19 May 2022 21:22:35 +0000 (GMT)
Message-ID: <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
Date:   Thu, 19 May 2022 23:22:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY
 interrupts to PHY driver to avoid polling
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20220519190841.GA30869@wunner.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxTG9957e1vqCteK9J0iS5ppIlGQbY43m6tTmLtZsoTxB8F9OFu5
        gSoU0lrAJVOsyEpHDGNTS9dBh6NKXaaptRYdH9aGRlyowGCWj6IIgwFFOspG55BZLm789zvn
        OU+ec968PFxYS67jyRWHGaVCmism+YS9LeTZGne1TLbtni8WGcu8XOQZdOLoN28fiYyeUgKN
        tg1z0XzNLRJ5zmpwVPdIz0Eez2Uuums/xUEjF80Y0nuaMVRnPokj5+kmgFxBC4HGx9aj+506
        ArWZYpDuYQOJTCdHCfTnnSmATvwxgaHHX3aSb4no7t5OnHYMfg9oW4MXoxsNg1x6JrCPNlnV
        9GjlV1zaaiknaZf3AaAbHbMYPTBfD+hHzT0k7Z2ewOnFE90EfcnWQ9Cz1rg04Qf8HVlMrryQ
        USZK9vNzhv/q5xbMbSw2j+uxEvBdnA5E8CD1KmzUV3B0gM8TUhcALA0tArYIAqjvNxFsMQvg
        k6t+7jNLn3t8WTgPYO9jBxEWhFQAwJD2SJgFlATarjixMBPURtgdKOGy/dXwdvXI0vxaSgan
        pnrwMK+hFHDSa+GEGadEsG+kdskbTYmh5utpLByGU0MkDFxpXxJIKgnq/DoyzBFUIrSHqnHW
        /CK85jfiYQOk6vmwTWMH7NqpcHLs/jKvgRNu2/I5sXCxMZzGe8r5cEH/Ctsuhr2TP+AsvwEH
        Ov4mwyM4tRleup7ItnfBQKsPZ52R8J5/NbtBJKyyn11uC6C2TMhOb4IG94//Zd6824VXArFh
        xaMYVhxvWHGL4f9cEyAsQMSoVXnZjOplBVOUoJLmqdSK7IQD+XlW8PQP33niDjrA+YlAghNg
        POAEkIeLowUgr1QmFGRJj3zKKPM/UapzGZUTrOcRYpHggPyyVEhlSw8zhximgFE+UzFexLoS
        TKLHKy/0mu0aS/K7XXTS3n0lt67bWz50tQ/vjqvaHSoMZsrf2/Xx5vy6qoGmpkJH+ax8u2qD
        sGjsizSTenwLldHcVBFPZhoyfK/nvJM07RW8HZ184/fIqIVzNVm/7Jlp0VZkVAVFi66i1Gux
        33Zs17b2nN4Zn2mY6U+osVL7TZuiDx5KtB4zdTlSaXdK2Zmfh47Xy1yaqC0v0JpTzatqU4pv
        2DrWmnwbGj6T5vrKX2unb//T91B+NGdvWrJjZ7b22AOJ1ngmzi8Lpofw+Zs1BaVyQejzgzHE
        XHr60eM7oszxq7ZVc859835M65ut6o+eu1iomGt53ihJsb3kHVrY+tOvPDGhypEmxeNKlfRf
        Pe31QDIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t/xe7qyW9uSDLa+5rCY03aT3eL83UPM
        Fs9u3mKzmHO+hcXi6bFH7BY/5h1mszg/vYnZYtH7GawW589vYLe4sK2P1eLJ6mVMFjPO72Oy
        WLSsldni0NS9jBZHvqxisXjxXNriwcUuFotjC8Qsuh6vZLNY0PqUxeLb6TeMFs2fXjFZ/J54
        kc1B3OPytYvMHjvuLmH02LLyJpPHzll32T0+fIzzWLCp1OPphMnsHptWdbJ5HLn5kNFj547P
        TB53fixl9Hi/7yqbx813r5g9/jdfZvFYv+Uqi8fnTXIBQlF6NkX5pSWpChn5xSW2StGGFkZ6
        hpYWekYmlnqGxuaxVkamSvp2NimpOZllqUX6dgl6GY++32Yv+KpasezFDKYGxoVyXYycHBIC
        JhK3jr9g6WLk4hASWMoosflYByNEQkbi5LQGVghbWOLPtS42iKL3jBLzWm6CFfEK2Els2XyI
        CcRmEVCVuPyxgR0iLihxcuYToKkcHKICSRJHDvODhIUF8iRON78Bm8ksIC5x68l8sFYRASWJ
        pinvmEDmMws8ZpOY8HUmO8SyNUwSG+7PYgOpYhMwlOh62wVmcwroS2z7OZMZYpKZRNfWLkYI
        W15i+9s5zBMYhWYhuWMWkoWzkLTMQtKygJFlFaNIamlxbnpusZFecWJucWleul5yfu4mRmDy
        2Xbs55YdjCtffdQ7xMjEwXiIUYKDWUmElzG3JUmINyWxsiq1KD++qDQntfgQoykwMCYyS4km
        5wPTX15JvKGZgamhiZmlgamlmbGSOK9nQUeikEB6YklqdmpqQWoRTB8TB6dUA1Peo7dvZzQa
        XeDef8d1e/jZdS2aWz6xfdXcJ3TL/uWveV9r2tWuWss9sgz2rklef2jSki3nmXPm89Tfzmq6
        9eos3wHD5fFP+ExtHgr9KbLgks06pHZ4+17VqTVnuxPefwoKT38VZ3J6Vr/GXa/9nOdPPAzR
        nMWQaTdNa3rJXN0oDRHnpTznI/anbdRVu/V06eQD7bsmcJywcn1pvH9CeNLudypZpXFbyx9w
        HioJuKjuEMvZtEt6g+Hf35zTezKMm0WZHQvOFIi5sn6b7DR9/cXcuRIP+f7ZSXHOFXx41aPz
        IPcJyfWWzZ0rlVofXNf8kKUi9lane7mHXNWsh7s49jW9i7Tbmla0ate3qMute2uUWIozEg21
        mIuKEwEVk8I/xwMAAA==
X-CMS-MailID: 20220519212237eucas1p28d609f0dec68094e98eed9fe74963746
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99
References: <cover.1652343655.git.lukas@wunner.de>
        <748ac44eeb97b209f66182f3788d2a49d7bc28fe.1652343655.git.lukas@wunner.de>
        <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
        <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
        <20220519190841.GA30869@wunner.de>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukas,

On 19.05.2022 21:08, Lukas Wunner wrote:
> On Tue, May 17, 2022 at 12:18:45PM +0200, Marek Szyprowski wrote:
>> This patch landed in the recent linux next-20220516 as commit
>> 1ce8b37241ed ("usbnet: smsc95xx: Forward PHY interrupts to PHY driver to
>> avoid polling"). Unfortunately it breaks smsc95xx usb ethernet operation
>> after system suspend-resume cycle. On the Odroid XU3 board I got the
>> following warning in the kernel log:
>>
>> # time rtcwake -s10 -mmem
>> rtcwake: wakeup from "mem" using /dev/rtc0 at Tue May 17 09:16:07 2022
>> PM: suspend entry (deep)
>> Filesystems sync: 0.001 seconds
>> Freezing user space processes ... (elapsed 0.002 seconds) done.
>> OOM killer disabled.
>> Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
>> printk: Suspending console(s) (use no_console_suspend to debug)
>> smsc95xx 4-1.1:1.0 eth0: entering SUSPEND2 mode
>> smsc95xx 4-1.1:1.0 eth0: Failed to read reg index 0x00000114: -113
>> smsc95xx 4-1.1:1.0 eth0: Error reading MII_ACCESS
>> smsc95xx 4-1.1:1.0 eth0: __smsc95xx_mdio_read: MII is busy
>> ------------[ cut here ]------------
>> WARNING: CPU: 2 PID: 73 at drivers/net/phy/phy.c:946
>> phy_state_machine+0x98/0x28c
> [...]
>> It looks that the driver's suspend/resume operations might need some
>> adjustments. After the system suspend/resume cycle the driver is not
>> operational anymore. Reverting the $subject patch on top of linux
>> next-20220516 restores ethernet operation after system suspend/resume.
> Thanks a lot for the report.  It seems the PHY is signaling a link change
> shortly before system sleep and by the time the phy_state_machine() worker
> gets around to handle it, the device has already been suspended and thus
> refuses any further USB requests with -EHOSTUNREACH (-113):
>
> usb_suspend_both()
>    usb_suspend_interface()
>      smsc95xx_suspend()
>        usbnet_suspend()
>          __usbnet_status_stop_force() # stops interrupt polling,
>                                       # link change is signaled before this
>
>    udev->can_submit = 0               # refuse further URBs
>
> Assuming the above theory is correct, calling phy_stop_machine()
> after usbnet_suspend() would be sufficient to fix the issue.
> It cancels the phy_state_machine() worker.
>
> The small patch below does that.  Could you give it a spin?

That's it. Your analysis is right and the patch fixes the issue. Thanks!

Feel free to add:

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

> Taking a step back though, I'm wondering if there's a bigger problem here:
> This is a USB device, so we stop receiving interrupts once the Interrupt
> Endpoint is no longer polled.  But what if a PHY's interrupt is attached
> to a GPIO of the SoC and that interrupt is raised while the system is
> suspending?  The interrupt handler may likewise try to reach an
> inaccessible (suspended) device.
>
> The right thing to do would probably be to signal wakeup.  But the
> PHY drivers' irq handlers instead schedule the phy_state_machine().
> Perhaps we need something like the following at the top of
> phy_state_machine():
>
> 	if (phydev->suspended) {
> 		pm_wakeup_dev_event(&phydev->mdio.dev, 0, true);
> 		return;
> 	}
>
> However, phydev->suspended is set at the *bottom* of phy_suspend(),
> it would have to be set at the *top* of mdio_bus_phy_suspend()
> for the above to be correct.  Hmmm...
Well, your concern sounds valid, but I don't have a board with such hw 
configuration, so I cannot really test.
> Thanks,
>
> Lukas
>
> -- >8 --
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index bd03e16..d351a6c 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -1201,6 +1201,7 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
>   	}
>   
>   	pdata->phydev->irq = phy_irq;
> +	pdata->phydev->mac_managed_pm = true;
>   	pdata->phydev->is_internal = is_internal_phy;
>   
>   	/* detect device revision as different features may be available */
> @@ -1496,6 +1497,9 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
>   		return ret;
>   	}
>   
> +	if (netif_running(dev->net))
> +		phy_stop(pdata->phydev);
> +
>   	if (pdata->suspend_flags) {
>   		netdev_warn(dev->net, "error during last resume\n");
>   		pdata->suspend_flags = 0;
> @@ -1778,6 +1782,8 @@ static int smsc95xx_resume(struct usb_interface *intf)
>   	}
>   
>   	phy_init_hw(pdata->phydev);
> +	if (netif_running(dev->net))
> +		phy_start(pdata->phydev);
>   
>   	ret = usbnet_resume(intf);
>   	if (ret < 0)
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

