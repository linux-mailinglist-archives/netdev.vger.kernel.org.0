Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752ED3A10C3
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238527AbhFIKBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:01:22 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27748 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238516AbhFIKBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:01:21 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210609095924euoutp01e148656a497b924cfcbc34716070e09b~G4Zl0O6yz0249202492euoutp01X
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 09:59:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210609095924euoutp01e148656a497b924cfcbc34716070e09b~G4Zl0O6yz0249202492euoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623232764;
        bh=PNF4oj4T2wiId9L9eStaVmpwCSBjsFT3cPfCtE1+zUA=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=AOGn6/pgmD1Kvm3uzbngoVgBE+56IAVd1icDP88PMPxR2x6wYQC7VrAyrC1jcZqu6
         F0I62WXEx3//5Q6gzUCxaDwxrmY6JVjFkAW2XN1ZisOFHSZZC8ctZaPQpgx71EBHkZ
         myb5ODs7fFIOPaS0yPxvHvXjkyIs4uRbjOavN8sg=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210609095924eucas1p1894b153766be276a26b0ee14a3249811~G4ZlenpFK1710817108eucas1p14;
        Wed,  9 Jun 2021 09:59:24 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 01.4A.09444.CF090C06; Wed,  9
        Jun 2021 10:59:24 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210609095923eucas1p2e692c9a482151742d543316c91f29802~G4Zk9Y0r80881108811eucas1p2B;
        Wed,  9 Jun 2021 09:59:23 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210609095923eusmtrp13c13a3cbbfd1435655cb331ef9d11f06~G4Zk8jN0n0824108241eusmtrp11;
        Wed,  9 Jun 2021 09:59:23 +0000 (GMT)
X-AuditID: cbfec7f4-dd5ff700000024e4-59-60c090fc910a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id C2.77.08696.BF090C06; Wed,  9
        Jun 2021 10:59:23 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210609095923eusmtip1f9fe49effa3b110e3e63f886986942ab~G4ZkO_Xn53114331143eusmtip1H;
        Wed,  9 Jun 2021 09:59:23 +0000 (GMT)
Subject: Re: [PATCH net-next v2 4/8] net: usb: asix: ax88772: add phylib
 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <84ff1dab-ab0a-f27c-a948-e1ebdf778485@samsung.com>
Date:   Wed, 9 Jun 2021 11:59:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210607082727.26045-5-o.rempel@pengutronix.de>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsWy7djP87p/JhxIMLh4Wsri/N1DzBZzzrew
        WCx6P4PVYtXUnSwWF7b1sVpc3jWHzWLRslZmi0NT9zJaHFsgZvHkHqMDl8flaxeZPbasvMnk
        sXPWXXaPTas62Tx27vjM5NH/18Dj8ya5APYoLpuU1JzMstQifbsErozvvbuYC471Mla8mnyP
        qYFxQnEXIyeHhICJxK4Zj1i6GLk4hARWMEosufSREcL5wigxed4bJgjnM6PE9wOvWWFazqze
        zQyRWM4osebeCjYI5yOjxJeD+4D6OTiEBYIklh8MAmkQEXjJKLF6XjaIzSyQI/H3QgcTiM0m
        YCjR9baLDcTmFbCTeHf7LNgCFgEViQePHzODjBEVSJb4vVEXokRQ4uTMJywgNqeArcTC2e8Z
        IUbKSzRvnc0MYYtL3HoyH+xoCYH/HBJTlv1hgjjaReL64+1sELawxKvjW9ghbBmJ05N7WCAa
        mhklHp5byw7h9DBKXG6awQhRZS1x59wvNpCLmAU0Jdbv0ocIO0rsvvWKFSQsIcAnceOtIMQR
        fBKTtk1nhgjzSnS0CUFUq0nMOr4Obu3BC5eYJzAqzULy2iwk78xC8s4shL0LGFlWMYqnlhbn
        pqcWG+WllusVJ+YWl+al6yXn525iBCas0/+Of9nBuPzVR71DjEwcjIcYJTiYlUR4ywz3JQjx
        piRWVqUW5ccXleakFh9ilOZgURLnTdqyJl5IID2xJDU7NbUgtQgmy8TBKdXAJLz4un/eH1mV
        5xe2L9MS48rcE378kVah6/ojuy/FLI//JWSa+i/vxJUCX3VGdrZH7uvvcXEedW2Sz7rrv+sV
        F3f2Xcv9xXeCQ5bLn3m14ZBpoY/gufTsSaU5X/IX1/OKePr6xm5Y+HqJpfrv11c+stamFgQ3
        ry4wmta+p+3Znsxbuydr5k+IDTbUWJReIxEdvWjL+53aZlKZPWs3bZyom/Av+bPzgukabF73
        Pxzmvif09rDKfY161rdvTz+adTDt2sI0lmKp/5M9JW/IsJUnFl48IJD8i7Xab77vteaICRv/
        NDxb5rzYYLnK7Pz38j2bbjAHur3ePyfptfr1s8vusux4Z2oby+o6n1sovSpARImlOCPRUIu5
        qDgRABUlKfPHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t/xu7q/JxxIMJi7w9Ti/N1DzBZzzrew
        WCx6P4PVYtXUnSwWF7b1sVpc3jWHzWLRslZmi0NT9zJaHFsgZvHkHqMDl8flaxeZPbasvMnk
        sXPWXXaPTas62Tx27vjM5NH/18Dj8ya5APYoPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9
        Q2PzWCsjUyV9O5uU1JzMstQifbsEvYzvvbuYC471Mla8mnyPqYFxQnEXIyeHhICJxJnVu5m7
        GLk4hASWMkos7jnJBJGQkTg5rYEVwhaW+HOtiw2i6D2jRHP3PqAiDg5hgSCJ5QeDQOIiAi8Z
        JX5tfcIG0sAskCOxY8NlFhBbSCBf4vyzWWA2m4ChRNfbLrAaXgE7iXe3z4ItYBFQkXjw+DEz
        iC0qkCyxof0/K0SNoMTJmU/AejkFbCUWzn7PCDHfTGLe5ofMELa8RPPW2VC2uMStJ/OZJjAK
        zULSPgtJyywkLbOQtCxgZFnFKJJaWpybnltspFecmFtcmpeul5yfu4kRGKPbjv3csoNx5auP
        eocYmTgYDzFKcDArifCWGe5LEOJNSaysSi3Kjy8qzUktPsRoCvTPRGYp0eR8YJLIK4k3NDMw
        NTQxszQwtTQzVhLnNTmyJl5IID2xJDU7NbUgtQimj4mDU6qByWfzo/DdHrbzrO6fDF64MFnC
        /IV2U5mX2b5quXWCfCZfm/RtWMvZuVQvCL+tve0st/My9+8eS/Nr7g+3SrM8PWYc09NbI/8w
        8ZNqUNjThUmHvzz9U7yL7faLFG3zjKoFMrIKUjtbA0JV3l+quB5wpn/XaoGEKZYSjc46BTcK
        FjBIzt2+Y5cg14tt105rhFUXLmOW38J2iMt10ofJM9vs9Ou9cl7+jFKNf6bUl3y5defRbce8
        jB+5bPVVMQz8lXpiyunQXU1N95a8UQq77hXwvF3xSWvvY1aBhYeOTnN7kHOtuDNGZK8aK4+4
        2qR7T541H5I7qPnNYOafP2x2ZodFrP59/nO8IXpam+b8LXETlViKMxINtZiLihMBBiBrZVoD
        AAA=
X-CMS-MailID: 20210609095923eucas1p2e692c9a482151742d543316c91f29802
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210609095923eucas1p2e692c9a482151742d543316c91f29802
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210609095923eucas1p2e692c9a482151742d543316c91f29802
References: <20210607082727.26045-1-o.rempel@pengutronix.de>
        <20210607082727.26045-5-o.rempel@pengutronix.de>
        <CGME20210609095923eucas1p2e692c9a482151742d543316c91f29802@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On 07.06.2021 10:27, Oleksij Rempel wrote:
> To be able to use ax88772 with external PHYs and use advantage of
> existing PHY drivers, we need to port at least ax88772 part of asix
> driver to the phylib framework.
>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

This patch landed recently in linux-next as commit e532a096be0e ("net: 
usb: asix: ax88772: add phylib support"). I found that it causes some 
warnings on boards with those devices, see the following log:

root@target:~# time rtcwake -s10 -mmem
rtcwake: wakeup from "mem" using /dev/rtc0 at Wed Jun  9 08:16:41 2021
[  231.226579] PM: suspend entry (deep)
[  231.231697] Filesystems sync: 0.002 seconds
[  231.261761] Freezing user space processes ... (elapsed 0.002 seconds) 
done.
[  231.270526] OOM killer disabled.
[  231.273557] Freezing remaining freezable tasks ... (elapsed 0.002 
seconds) done.
[  231.282229] printk: Suspending console(s) (use no_console_suspend to 
debug)
...
[  231.710852] Disabling non-boot CPUs ...
...
[  231.901794] Enabling non-boot CPUs ...
...
[  232.225640] usb usb3: root hub lost power or was reset
[  232.225746] usb usb1: root hub lost power or was reset
[  232.225864] usb usb5: root hub lost power or was reset
[  232.226206] usb usb6: root hub lost power or was reset
[  232.226207] usb usb4: root hub lost power or was reset
[  232.297749] usb usb2: root hub lost power or was reset
[  232.343227] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
[  232.343293] asix 3-1:1.0 eth0: Failed to enable software MII access
[  232.344486] asix 3-1:1.0 eth0: Failed to read reg index 0x0000: -22
[  232.344512] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
[  232.344529] PM: dpm_run_callback(): mdio_bus_phy_resume+0x0/0x78 
returns -22
[  232.344554] Asix Electronics AX88772C usb-003:002:10: PM: failed to 
resume: error -22
[  232.563712] usb 1-1: reset high-speed USB device number 2 using 
exynos-ehci
[  232.757653] usb 3-1: reset high-speed USB device number 2 using xhci-hcd
[  233.730994] OOM killer enabled.
[  233.734122] Restarting tasks ... done.
[  233.754992] PM: suspend exit

real    0m11.546s
user    0m0.000s
sys     0m0.530s
root@target:~# sleep 2
root@target:~# time rtcwake -s10 -mmem
rtcwake: wakeup from "mem" using /dev/rtc0 at Wed Jun  9 08:17:02 2021
[  241.959608] PM: suspend entry (deep)
[  241.963446] Filesystems sync: 0.001 seconds
[  241.978619] Freezing user space processes ... (elapsed 0.004 seconds) 
done.
[  241.989199] OOM killer disabled.
[  241.992215] Freezing remaining freezable tasks ... (elapsed 0.005 
seconds) done.
[  242.003979] printk: Suspending console(s) (use no_console_suspend to 
debug)
...
[  242.592030] Disabling non-boot CPUs ...
...
[  242.879721] Enabling non-boot CPUs ...
...
[  243.145870] usb usb3: root hub lost power or was reset
[  243.145910] usb usb4: root hub lost power or was reset
[  243.147084] usb usb5: root hub lost power or was reset
[  243.147157] usb usb6: root hub lost power or was reset
[  243.147298] usb usb1: root hub lost power or was reset
[  243.217137] usb usb2: root hub lost power or was reset
[  243.283807] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
[  243.284005] asix 3-1:1.0 eth0: Failed to enable software MII access
[  243.285526] asix 3-1:1.0 eth0: Failed to read reg index 0x0000: -22
[  243.285676] asix 3-1:1.0 eth0: Failed to read reg index 0x0004: -22
[  243.285769] ------------[ cut here ]------------
[  243.286011] WARNING: CPU: 2 PID: 2069 at drivers/net/phy/phy.c:916 
phy_error+0x28/0x68
[  243.286115] Modules linked in: cmac bnep mwifiex_sdio mwifiex 
sha256_generic libsha256 sha256_arm cfg80211 btmrvl_sdio btmrvl 
bluetooth s5p_mfc uvcvideo s5p_jpeg exynos_gsc v
[  243.287490] CPU: 2 PID: 2069 Comm: kworker/2:5 Not tainted 
5.13.0-rc5-next-20210608 #10443
[  243.287555] Hardware name: Samsung Exynos (Flattened Device Tree)
[  243.287609] Workqueue: events_power_efficient phy_state_machine
[  243.287716] [<c0111920>] (unwind_backtrace) from [<c010d0cc>] 
(show_stack+0x10/0x14)
[  243.287807] [<c010d0cc>] (show_stack) from [<c0b62360>] 
(dump_stack_lvl+0xa0/0xc0)
[  243.287882] [<c0b62360>] (dump_stack_lvl) from [<c0127960>] 
(__warn+0x118/0x11c)
[  243.287954] [<c0127960>] (__warn) from [<c0127a18>] 
(warn_slowpath_fmt+0xb4/0xbc)
[  243.288021] [<c0127a18>] (warn_slowpath_fmt) from [<c0734968>] 
(phy_error+0x28/0x68)
[  243.288094] [<c0734968>] (phy_error) from [<c0735d6c>] 
(phy_state_machine+0x218/0x278)
[  243.288173] [<c0735d6c>] (phy_state_machine) from [<c014ae08>] 
(process_one_work+0x30c/0x884)
[  243.288254] [<c014ae08>] (process_one_work) from [<c014b3d8>] 
(worker_thread+0x58/0x594)
[  243.288333] [<c014b3d8>] (worker_thread) from [<c0153944>] 
(kthread+0x160/0x1c0)
[  243.288408] [<c0153944>] (kthread) from [<c010011c>] 
(ret_from_fork+0x14/0x38)
[  243.288475] Exception stack(0xc4683fb0 to 0xc4683ff8)
[  243.288531] 3fa0:                                     00000000 
00000000 00000000 00000000
[  243.288587] 3fc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[  243.288641] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  243.288690] irq event stamp: 1611
[  243.288744] hardirqs last  enabled at (1619): [<c01a6ef0>] 
vprintk_emit+0x230/0x290
[  243.288830] hardirqs last disabled at (1626): [<c01a6f2c>] 
vprintk_emit+0x26c/0x290
[  243.288906] softirqs last  enabled at (1012): [<c0101768>] 
__do_softirq+0x500/0x63c
[  243.288978] softirqs last disabled at (1007): [<c01315b4>] 
irq_exit+0x214/0x220
[  243.289055] ---[ end trace eeacda95eb7db60a ]---
[  243.289345] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
[  243.289466] asix 3-1:1.0 eth0: Failed to write Medium Mode mode to 
0x0000: ffffffea
[  243.289540] asix 3-1:1.0 eth0: Link is Down
[  243.482809] usb 1-1: reset high-speed USB device number 2 using 
exynos-ehci
[  243.647251] usb 3-1: reset high-speed USB device number 2 using xhci-hcd
[  244.847161] OOM killer enabled.
[  244.850221] Restarting tasks ... done.
[  244.861372] PM: suspend exit

real    0m13.050s
user    0m0.000s
sys     0m1.152s
root@target:~#

It looks that some kind of system suspend/resume integration for phylib 
is not implemented.

> ---
>   drivers/net/usb/asix.h         |   9 +++
>   drivers/net/usb/asix_common.c  |  37 ++++++++++
>   drivers/net/usb/asix_devices.c | 120 +++++++++++++++++++++------------
>   drivers/net/usb/ax88172a.c     |  14 ----
>   4 files changed, 122 insertions(+), 58 deletions(-)
>
> diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
> index edb94efd265e..2122d302e643 100644
> --- a/drivers/net/usb/asix.h
> +++ b/drivers/net/usb/asix.h
> @@ -25,6 +25,7 @@
>   #include <linux/usb/usbnet.h>
>   #include <linux/slab.h>
>   #include <linux/if_vlan.h>
> +#include <linux/phy.h>
>   
>   #define DRIVER_VERSION "22-Dec-2011"
>   #define DRIVER_NAME "asix"
> @@ -178,6 +179,10 @@ struct asix_common_private {
>   	u16 presvd_phy_advertise;
>   	u16 presvd_phy_bmcr;
>   	struct asix_rx_fixup_info rx_fixup_info;
> +	struct mii_bus *mdio;
> +	struct phy_device *phydev;
> +	u16 phy_addr;
> +	char phy_name[20];
>   };
>   
>   extern const struct driver_info ax88172a_info;
> @@ -214,6 +219,7 @@ int asix_write_rx_ctl(struct usbnet *dev, u16 mode, int in_pm);
>   
>   u16 asix_read_medium_status(struct usbnet *dev, int in_pm);
>   int asix_write_medium_mode(struct usbnet *dev, u16 mode, int in_pm);
> +void asix_adjust_link(struct net_device *netdev);
>   
>   int asix_write_gpio(struct usbnet *dev, u16 value, int sleep, int in_pm);
>   
> @@ -222,6 +228,9 @@ void asix_set_multicast(struct net_device *net);
>   int asix_mdio_read(struct net_device *netdev, int phy_id, int loc);
>   void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val);
>   
> +int asix_mdio_bus_read(struct mii_bus *bus, int phy_id, int regnum);
> +int asix_mdio_bus_write(struct mii_bus *bus, int phy_id, int regnum, u16 val);
> +
>   int asix_mdio_read_nopm(struct net_device *netdev, int phy_id, int loc);
>   void asix_mdio_write_nopm(struct net_device *netdev, int phy_id, int loc,
>   			  int val);
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index e1109f1a8dd5..085bc8281082 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -384,6 +384,27 @@ int asix_write_medium_mode(struct usbnet *dev, u16 mode, int in_pm)
>   	return ret;
>   }
>   
> +/* set MAC link settings according to information from phylib */
> +void asix_adjust_link(struct net_device *netdev)
> +{
> +	struct phy_device *phydev = netdev->phydev;
> +	struct usbnet *dev = netdev_priv(netdev);
> +	u16 mode = 0;
> +
> +	if (phydev->link) {
> +		mode = AX88772_MEDIUM_DEFAULT;
> +
> +		if (phydev->duplex == DUPLEX_HALF)
> +			mode &= ~AX_MEDIUM_FD;
> +
> +		if (phydev->speed != SPEED_100)
> +			mode &= ~AX_MEDIUM_PS;
> +	}
> +
> +	asix_write_medium_mode(dev, mode, 0);
> +	phy_print_status(phydev);
> +}
> +
>   int asix_write_gpio(struct usbnet *dev, u16 value, int sleep, int in_pm)
>   {
>   	int ret;
> @@ -506,6 +527,22 @@ void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
>   	mutex_unlock(&dev->phy_mutex);
>   }
>   
> +/* MDIO read and write wrappers for phylib */
> +int asix_mdio_bus_read(struct mii_bus *bus, int phy_id, int regnum)
> +{
> +	struct usbnet *priv = bus->priv;
> +
> +	return asix_mdio_read(priv->net, phy_id, regnum);
> +}
> +
> +int asix_mdio_bus_write(struct mii_bus *bus, int phy_id, int regnum, u16 val)
> +{
> +	struct usbnet *priv = bus->priv;
> +
> +	asix_mdio_write(priv->net, phy_id, regnum, val);
> +	return 0;
> +}
> +
>   int asix_mdio_read_nopm(struct net_device *netdev, int phy_id, int loc)
>   {
>   	struct usbnet *dev = netdev_priv(netdev);
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 00b6ac0570eb..e4cd85e38edd 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -285,7 +285,7 @@ static int ax88172_bind(struct usbnet *dev, struct usb_interface *intf)
>   
>   static const struct ethtool_ops ax88772_ethtool_ops = {
>   	.get_drvinfo		= asix_get_drvinfo,
> -	.get_link		= asix_get_link,
> +	.get_link		= usbnet_get_link,
>   	.get_msglevel		= usbnet_get_msglevel,
>   	.set_msglevel		= usbnet_set_msglevel,
>   	.get_wol		= asix_get_wol,
> @@ -293,37 +293,15 @@ static const struct ethtool_ops ax88772_ethtool_ops = {
>   	.get_eeprom_len		= asix_get_eeprom_len,
>   	.get_eeprom		= asix_get_eeprom,
>   	.set_eeprom		= asix_set_eeprom,
> -	.nway_reset		= usbnet_nway_reset,
> -	.get_link_ksettings	= usbnet_get_link_ksettings_mii,
> -	.set_link_ksettings	= usbnet_set_link_ksettings_mii,
> +	.nway_reset		= phy_ethtool_nway_reset,
> +	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
> +	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
>   };
>   
> -static int ax88772_link_reset(struct usbnet *dev)
> -{
> -	u16 mode;
> -	struct ethtool_cmd ecmd = { .cmd = ETHTOOL_GSET };
> -
> -	mii_check_media(&dev->mii, 1, 1);
> -	mii_ethtool_gset(&dev->mii, &ecmd);
> -	mode = AX88772_MEDIUM_DEFAULT;
> -
> -	if (ethtool_cmd_speed(&ecmd) != SPEED_100)
> -		mode &= ~AX_MEDIUM_PS;
> -
> -	if (ecmd.duplex != DUPLEX_FULL)
> -		mode &= ~AX_MEDIUM_FD;
> -
> -	netdev_dbg(dev->net, "ax88772_link_reset() speed: %u duplex: %d setting mode to 0x%04x\n",
> -		   ethtool_cmd_speed(&ecmd), ecmd.duplex, mode);
> -
> -	asix_write_medium_mode(dev, mode, 0);
> -
> -	return 0;
> -}
> -
>   static int ax88772_reset(struct usbnet *dev)
>   {
>   	struct asix_data *data = (struct asix_data *)&dev->data;
> +	struct asix_common_private *priv = dev->driver_priv;
>   	int ret;
>   
>   	/* Rewrite MAC address */
> @@ -342,6 +320,8 @@ static int ax88772_reset(struct usbnet *dev)
>   	if (ret < 0)
>   		goto out;
>   
> +	phy_start(priv->phydev);
> +
>   	return 0;
>   
>   out:
> @@ -586,7 +566,7 @@ static const struct net_device_ops ax88772_netdev_ops = {
>   	.ndo_get_stats64	= dev_get_tstats64,
>   	.ndo_set_mac_address 	= asix_set_mac_address,
>   	.ndo_validate_addr	= eth_validate_addr,
> -	.ndo_do_ioctl		= asix_ioctl,
> +	.ndo_do_ioctl		= phy_do_ioctl_running,
>   	.ndo_set_rx_mode        = asix_set_multicast,
>   };
>   
> @@ -677,12 +657,57 @@ static int asix_resume(struct usb_interface *intf)
>   	return usbnet_resume(intf);
>   }
>   
> +static int ax88772_init_mdio(struct usbnet *dev)
> +{
> +	struct asix_common_private *priv = dev->driver_priv;
> +
> +	priv->mdio = devm_mdiobus_alloc(&dev->udev->dev);
> +	if (!priv->mdio)
> +		return -ENOMEM;
> +
> +	priv->mdio->priv = dev;
> +	priv->mdio->read = &asix_mdio_bus_read;
> +	priv->mdio->write = &asix_mdio_bus_write;
> +	priv->mdio->name = "Asix MDIO Bus";
> +	/* mii bus name is usb-<usb bus number>-<usb device number> */
> +	snprintf(priv->mdio->id, MII_BUS_ID_SIZE, "usb-%03d:%03d",
> +		 dev->udev->bus->busnum, dev->udev->devnum);
> +
> +	return devm_mdiobus_register(&dev->udev->dev, priv->mdio);
> +}
> +
> +static int ax88772_init_phy(struct usbnet *dev)
> +{
> +	struct asix_common_private *priv = dev->driver_priv;
> +	int ret;
> +
> +	priv->phy_addr = asix_read_phy_addr(dev, true);
> +	if (priv->phy_addr < 0)
> +		return priv->phy_addr;
> +
> +	snprintf(priv->phy_name, sizeof(priv->phy_name), PHY_ID_FMT,
> +		 priv->mdio->id, priv->phy_addr);
> +
> +	priv->phydev = phy_connect(dev->net, priv->phy_name, &asix_adjust_link,
> +				   PHY_INTERFACE_MODE_INTERNAL);
> +	if (IS_ERR(priv->phydev)) {
> +		netdev_err(dev->net, "Could not connect to PHY device %s\n",
> +			   priv->phy_name);
> +		ret = PTR_ERR(priv->phydev);
> +		return ret;
> +	}
> +
> +	phy_attached_info(priv->phydev);
> +
> +	return 0;
> +}
> +
>   static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
>   {
> -	int ret, i;
>   	u8 buf[ETH_ALEN] = {0}, chipcode = 0;
> -	u32 phyid;
>   	struct asix_common_private *priv;
> +	int ret, i;
> +	u32 phyid;
>   
>   	usbnet_get_endpoints(dev, intf);
>   
> @@ -714,17 +739,6 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
>   
>   	asix_set_netdev_dev_addr(dev, buf);
>   
> -	/* Initialize MII structure */
> -	dev->mii.dev = dev->net;
> -	dev->mii.mdio_read = asix_mdio_read;
> -	dev->mii.mdio_write = asix_mdio_write;
> -	dev->mii.phy_id_mask = 0x1f;
> -	dev->mii.reg_num_mask = 0x1f;
> -
> -	dev->mii.phy_id = asix_read_phy_addr(dev, true);
> -	if (dev->mii.phy_id < 0)
> -		return dev->mii.phy_id;
> -
>   	dev->net->netdev_ops = &ax88772_netdev_ops;
>   	dev->net->ethtool_ops = &ax88772_ethtool_ops;
>   	dev->net->needed_headroom = 4; /* cf asix_tx_fixup() */
> @@ -768,11 +782,31 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
>   		priv->suspend = ax88772_suspend;
>   	}
>   
> +	ret = ax88772_init_mdio(dev);
> +	if (ret)
> +		return ret;
> +
> +	return ax88772_init_phy(dev);
> +}
> +
> +static int ax88772_stop(struct usbnet *dev)
> +{
> +	struct asix_common_private *priv = dev->driver_priv;
> +
> +	/* On unplugged USB, we will get MDIO communication errors and the
> +	 * PHY will be set in to PHY_HALTED state.
> +	 */
> +	if (priv->phydev->state != PHY_HALTED)
> +		phy_stop(priv->phydev);
> +
>   	return 0;
>   }
>   
>   static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
>   {
> +	struct asix_common_private *priv = dev->driver_priv;
> +
> +	phy_disconnect(priv->phydev);
>   	asix_rx_fixup_common_free(dev->driver_priv);
>   }
>   
> @@ -1161,8 +1195,8 @@ static const struct driver_info ax88772_info = {
>   	.bind = ax88772_bind,
>   	.unbind = ax88772_unbind,
>   	.status = asix_status,
> -	.link_reset = ax88772_link_reset,
>   	.reset = ax88772_reset,
> +	.stop = ax88772_stop,
>   	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR | FLAG_MULTI_PACKET,
>   	.rx_fixup = asix_rx_fixup_common,
>   	.tx_fixup = asix_tx_fixup,
> @@ -1173,7 +1207,6 @@ static const struct driver_info ax88772b_info = {
>   	.bind = ax88772_bind,
>   	.unbind = ax88772_unbind,
>   	.status = asix_status,
> -	.link_reset = ax88772_link_reset,
>   	.reset = ax88772_reset,
>   	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
>   	         FLAG_MULTI_PACKET,
> @@ -1209,7 +1242,6 @@ static const struct driver_info hg20f9_info = {
>   	.bind = ax88772_bind,
>   	.unbind = ax88772_unbind,
>   	.status = asix_status,
> -	.link_reset = ax88772_link_reset,
>   	.reset = ax88772_reset,
>   	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
>   	         FLAG_MULTI_PACKET,
> diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
> index c8ca5187eece..2e2081346740 100644
> --- a/drivers/net/usb/ax88172a.c
> +++ b/drivers/net/usb/ax88172a.c
> @@ -25,20 +25,6 @@ struct ax88172a_private {
>   	struct asix_rx_fixup_info rx_fixup_info;
>   };
>   
> -/* MDIO read and write wrappers for phylib */
> -static int asix_mdio_bus_read(struct mii_bus *bus, int phy_id, int regnum)
> -{
> -	return asix_mdio_read(((struct usbnet *)bus->priv)->net, phy_id,
> -			      regnum);
> -}
> -
> -static int asix_mdio_bus_write(struct mii_bus *bus, int phy_id, int regnum,
> -			       u16 val)
> -{
> -	asix_mdio_write(((struct usbnet *)bus->priv)->net, phy_id, regnum, val);
> -	return 0;
> -}
> -
>   /* set MAC link settings according to information from phylib */
>   static void ax88172a_adjust_link(struct net_device *netdev)
>   {

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

