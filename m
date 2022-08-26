Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5AD5A2137
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 08:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239601AbiHZGwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 02:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235903AbiHZGwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 02:52:04 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB50FD1275
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:52:02 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220826065201euoutp013d2d796b2dbedab87e524cd191b6646b~O0ncHlyDi1919119191euoutp01w
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 06:52:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220826065201euoutp013d2d796b2dbedab87e524cd191b6646b~O0ncHlyDi1919119191euoutp01w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661496721;
        bh=SLj360xnTj6kGDPF6JmBxasPLiWgx7pBYkGeIApy3qU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=prJQhgvgDJI4DnCkaoP+VFBY7dYBdsEoyDvfPWYL/HM6QfYdK38b8aZ9EotPVRVPw
         L90awOUe49KpBSElGWdNAOU7WWcMt/Wufqfb2Yc7Dhz5MId6YhfKI9XwAG9oFmvvhB
         UTtnTb2lpjTc2ewgvp72CzAnrU8TpDsvURqkpmtY=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220826065200eucas1p2520da7f0fa1a2b3852778148f893a6ee~O0nbt0_0N0105001050eucas1p2a;
        Fri, 26 Aug 2022 06:52:00 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id BA.42.29727.09D68036; Fri, 26
        Aug 2022 07:52:00 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220826065200eucas1p269812df7f3883e14369248e797166439~O0nbR8hxw0097800978eucas1p2a;
        Fri, 26 Aug 2022 06:52:00 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220826065200eusmtrp1b36d5c4ef16b4855a2c57b7d2163ebfc~O0nbQ2s6s1442814428eusmtrp1V;
        Fri, 26 Aug 2022 06:52:00 +0000 (GMT)
X-AuditID: cbfec7f2-205ff7000001741f-d6-63086d90e5d1
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 44.1A.07473.09D68036; Fri, 26
        Aug 2022 07:52:00 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220826065158eusmtip2d83128b117fe974ca16b4ca68ce5b752~O0nZ5XZ2a3256932569eusmtip2J;
        Fri, 26 Aug 2022 06:51:58 +0000 (GMT)
Message-ID: <e598a232-6c78-782a-316f-77902644ad6c@samsung.com>
Date:   Fri, 26 Aug 2022 08:51:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY
 interrupts to PHY driver to avoid polling
Content-Language: en-US
From:   Marek Szyprowski <m.szyprowski@samsung.com>
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
In-Reply-To: <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sf1CTZRy/533fvXsHDV/Hao/SWfeWkXiiRNc9lyloXb7Xr+OMrMPK5ngD
        dGzcBol1XcSEYBIy0YA5ZHEIsko84rfnysGNk50bSFLzwGltAUPBMUowxRgvFv99vp/v5/t8
        Pt/vPRQuqSFXUxmqbE6jkisZMoxos885N5RlUopNv16IQaZCtxC5Rmw4+tN9lUQm1yEC+ey/
        C9HsyW4SuSrycVQ7VSlALtdZIepvKxUg73f1GKp0WTFUW1+AI9vx8wD1zFgINDYaha4P6Alk
        Nz+G9H80kshc4CPQ346bAOmm/Rj6xzBAJsrYwaEBnO0YqQNsS6MbYzuNI0L2duBD1tycw/rK
        yoVss6WYZHvcNwDb2RHE2OHZU4Cdsl4hWfekH2cf6AYJtqnlCsEGm9ckSVLCXkrllBmfcJqN
        Wz8KS69uOUJmVa/PtZa0kHkg72k9EFGQfh5aB+4RehBGSejTADaeMywVMwB2nTqB80UQwDqf
        mXw4kqcrxkNYQjcAOOHfwosCAF76KR8LNcT0VljuqReEMEGvhZ3+SgHPr4QXq7xECD9KK6DR
        bgchHEmr4ITbsqjBaRm86q1ZfIek46D+ln7RWEozMP/YJBYyw2kPCQM/9i2KRHQCHD9TjvPD
        T0BdKx8b0t+Gwduto0I+9itwatqF8zgS+ntblvjHoaO8ZCERtYDV8H5lPE/nwqGJ75fkm+Gw
        8y4ZkuD0OtjUtZGnt8HAz9dwfjIC/nZrJZ8gAh5tq1iixbCoUMKrn4HG3jP/eV7ov4yXAca4
        7CjGZcsbl+1i/N/XDAgLkHE52sw0Thun4g7EauWZ2hxVWqxCndkMFv6wY753ugNU+wOxNoBR
        wAYghTNS8Yt2QiERp8oPfspp1Hs0OUpOawNRFMHIxIqMs3IJnSbP5vZzXBanedjFKNHqPOzz
        XC775RWte7OiGO1OU1JCav/5B58VmxJF3uh2w1qZ9dya15KTsIhVfSsmb7R/9UPhB/u2J1aJ
        pp50nbZeBIGKHfOeR3a9OqSPtcxPnJgaCx9/q+e9oWb/uFTsS9hharjWp/T4AodF7VWeYHrj
        zs132tftMV6+e6g0m8EjaqRzuvnoe1Ct273q48ikLmdDzHEoPObdFX6gqOMp4xd90SlNM03J
        z90J9zqkb84Gd7998/Cz3UUlsu0NhpPqyi1/lXZihtf3Std3d+9vsB6t/dp5fVD17v30FzI3
        eJref+MXQ9EwU7Ap/hvnO/HKdHKU+jJFctDBXNKNbUsW7sMiBS5t/lwdQ2jT5XExuEYr/xdA
        hvDhMgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t/xe7oTcjmSDf4u4bSY03aT3eL83UPM
        Fs9u3mKzmHO+hcXi6bFH7BY/5h1mszg/vYnZYtH7GawW589vYLe4sK2P1eLJ6mVMFjPO72Oy
        WLSsldni0NS9jBZHvqxisXjxXNriwcUuFotjC8Qsuh6vZLNY0PqUxeLb6TeMFs2fXjFZ/J54
        kc1B3OPytYvMHjvuLmH02LLyJpPHzll32T0+fIzzWLCp1OPphMnsHptWdbJ5HLn5kNFj547P
        TB53fixl9Hi/7yqbx813r5g9/jdfZvFYv+Uqi8fnTXIBQlF6NkX5pSWpChn5xSW2StGGFkZ6
        hpYWekYmlnqGxuaxVkamSvp2NimpOZllqUX6dgl6GXO39LMVzNWu2Nezha2BsUGli5GTQ0LA
        RKKhuZMZxBYSWMooMW92CURcRuLktAZWCFtY4s+1LrYuRi6gmveMEm+7HzCBJHgF7CQm318G
        VsQioCqx89UMVoi4oMTJmU9YQGxRgWSJJQ33weLCAnkSp5vfgNnMAuISt57MB5vDJmAo0fUW
        ZAEnh4iAkkTTlHdMIMuYBR6zSUz4OpMdYvNDJokFHffAujkF7CVerpvMDDHJTKJraxcjhC0v
        0bx1NvMERqFZSA6ZhWThLCQts5C0LGBkWcUoklpanJueW2yoV5yYW1yal66XnJ+7iRGYfLYd
        +7l5B+O8Vx/1DjEycTAeYpTgYFYS4bU6xpIsxJuSWFmVWpQfX1Sak1p8iNEUGBoTmaVEk/OB
        6S+vJN7QzMDU0MTM0sDU0sxYSZzXs6AjUUggPbEkNTs1tSC1CKaPiYNTqoEpkndGwO1ymc18
        R07dEl4pfiNwReOU7vofNX/X+hwLrs0t0pwfqvvvl3HXj22fIxjMuqZpvjphxvZZKDK1PP+w
        u3i9hsCMFxP5riytT2mNrVxrPGmd7OPz2hXdUmzNPB8Prwn9/IlHkMMu/XvnDLdPDyY3cXx/
        UyO3crnyOr26B/etUzLeVm4V5FOQ8Paxt4n943uAgcl0XtI27V2KeaU5zWxcnPUvH3GE3THi
        und+amlG/v+sF+dizI4lzqvtCb9wqL5BYtqx1urnV86ZOEdcaGpW+Lc51PlH37erD5NFXx02
        2lsbW266Me67NgtHwHy/Ca0vZTYIVTx4lHl33W4X67XrPsRcCDH11tF/80KJpTgj0VCLuag4
        EQCIwLODxwMAAA==
X-CMS-MailID: 20220826065200eucas1p269812df7f3883e14369248e797166439
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
        <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.05.2022 23:22, Marek Szyprowski wrote:
> On 19.05.2022 21:08, Lukas Wunner wrote:
>> On Tue, May 17, 2022 at 12:18:45PM +0200, Marek Szyprowski wrote:
>>> This patch landed in the recent linux next-20220516 as commit
>>> 1ce8b37241ed ("usbnet: smsc95xx: Forward PHY interrupts to PHY 
>>> driver to
>>> avoid polling"). Unfortunately it breaks smsc95xx usb ethernet 
>>> operation
>>> after system suspend-resume cycle. On the Odroid XU3 board I got the
>>> following warning in the kernel log:
>>>
>>> # time rtcwake -s10 -mmem
>>> rtcwake: wakeup from "mem" using /dev/rtc0 at Tue May 17 09:16:07 2022
>>> PM: suspend entry (deep)
>>> Filesystems sync: 0.001 seconds
>>> Freezing user space processes ... (elapsed 0.002 seconds) done.
>>> OOM killer disabled.
>>> Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
>>> printk: Suspending console(s) (use no_console_suspend to debug)
>>> smsc95xx 4-1.1:1.0 eth0: entering SUSPEND2 mode
>>> smsc95xx 4-1.1:1.0 eth0: Failed to read reg index 0x00000114: -113
>>> smsc95xx 4-1.1:1.0 eth0: Error reading MII_ACCESS
>>> smsc95xx 4-1.1:1.0 eth0: __smsc95xx_mdio_read: MII is busy
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 2 PID: 73 at drivers/net/phy/phy.c:946
>>> phy_state_machine+0x98/0x28c
>> [...]
>>> It looks that the driver's suspend/resume operations might need some
>>> adjustments. After the system suspend/resume cycle the driver is not
>>> operational anymore. Reverting the $subject patch on top of linux
>>> next-20220516 restores ethernet operation after system suspend/resume.
>> Thanks a lot for the report.  It seems the PHY is signaling a link 
>> change
>> shortly before system sleep and by the time the phy_state_machine() 
>> worker
>> gets around to handle it, the device has already been suspended and thus
>> refuses any further USB requests with -EHOSTUNREACH (-113):
>>
>> usb_suspend_both()
>>    usb_suspend_interface()
>>      smsc95xx_suspend()
>>        usbnet_suspend()
>>          __usbnet_status_stop_force() # stops interrupt polling,
>>                                       # link change is signaled 
>> before this
>>
>>    udev->can_submit = 0               # refuse further URBs
>>
>> Assuming the above theory is correct, calling phy_stop_machine()
>> after usbnet_suspend() would be sufficient to fix the issue.
>> It cancels the phy_state_machine() worker.
>>
>> The small patch below does that.  Could you give it a spin?
>
> That's it. Your analysis is right and the patch fixes the issue. Thanks!
>
> Feel free to add:
>
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>


Gentle ping for the final patch...

It looks that the similar fix is posted for other drivers, i.e.:

https://lore.kernel.org/all/20220825023951.3220-1-f.fainelli@gmail.com/


>
>> Taking a step back though, I'm wondering if there's a bigger problem 
>> here:
>> This is a USB device, so we stop receiving interrupts once the Interrupt
>> Endpoint is no longer polled.  But what if a PHY's interrupt is attached
>> to a GPIO of the SoC and that interrupt is raised while the system is
>> suspending?  The interrupt handler may likewise try to reach an
>> inaccessible (suspended) device.
>>
>> The right thing to do would probably be to signal wakeup.  But the
>> PHY drivers' irq handlers instead schedule the phy_state_machine().
>> Perhaps we need something like the following at the top of
>> phy_state_machine():
>>
>>     if (phydev->suspended) {
>>         pm_wakeup_dev_event(&phydev->mdio.dev, 0, true);
>>         return;
>>     }
>>
>> However, phydev->suspended is set at the *bottom* of phy_suspend(),
>> it would have to be set at the *top* of mdio_bus_phy_suspend()
>> for the above to be correct.  Hmmm...
> Well, your concern sounds valid, but I don't have a board with such hw 
> configuration, so I cannot really test.
>> Thanks,
>>
>> Lukas
>>
>> -- >8 --
>> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
>> index bd03e16..d351a6c 100644
>> --- a/drivers/net/usb/smsc95xx.c
>> +++ b/drivers/net/usb/smsc95xx.c
>> @@ -1201,6 +1201,7 @@ static int smsc95xx_bind(struct usbnet *dev, 
>> struct usb_interface *intf)
>>       }
>>         pdata->phydev->irq = phy_irq;
>> +    pdata->phydev->mac_managed_pm = true;
>>       pdata->phydev->is_internal = is_internal_phy;
>>         /* detect device revision as different features may be 
>> available */
>> @@ -1496,6 +1497,9 @@ static int smsc95xx_suspend(struct 
>> usb_interface *intf, pm_message_t message)
>>           return ret;
>>       }
>>   +    if (netif_running(dev->net))
>> +        phy_stop(pdata->phydev);
>> +
>>       if (pdata->suspend_flags) {
>>           netdev_warn(dev->net, "error during last resume\n");
>>           pdata->suspend_flags = 0;
>> @@ -1778,6 +1782,8 @@ static int smsc95xx_resume(struct usb_interface 
>> *intf)
>>       }
>>         phy_init_hw(pdata->phydev);
>> +    if (netif_running(dev->net))
>> +        phy_start(pdata->phydev);
>>         ret = usbnet_resume(intf);
>>       if (ret < 0)
>>
> Best regards

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

