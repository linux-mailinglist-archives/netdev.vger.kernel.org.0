Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620D0130A33
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgAEWWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:22:04 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38634 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgAEWWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 17:22:03 -0500
Received: by mail-pl1-f193.google.com with SMTP id f20so21109547plj.5;
        Sun, 05 Jan 2020 14:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8kerBVRkk84cjC6T6qwed9ESYieZ/qfnqyK9xJHPGjo=;
        b=EVyLoYEkeN5rjLZ7eO/Ot/edkvCk+cI4BtZqpf1CnMni1h4z0g7jiF6PD9+mUvuXgd
         40Gej/pR9/EgaQg6X3DgarUPONWgXNK1l5XJiqayLQRhLhp7NOTYRdKnl8DyaSTDZtQZ
         UA9jkouWqcZR11u3OiTTDWNo0dQDjg+VE4wLkdo9sNrAqqrYGS6FxkxgV3CYiyeUuc1R
         W3OJKSjLxZQzYVPF5bsVKD55PdMoeqAb7QEerLUefquyHgbwXL1S9eMqi5CIhFtCEkpD
         c9Be/0gnIj5W/buHY8vFumABrA4Fn7rh132VpZ6rUmFdi2fWrAPnH3fw2WDmWuXNHLYD
         wz2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8kerBVRkk84cjC6T6qwed9ESYieZ/qfnqyK9xJHPGjo=;
        b=VVLpU1RcSdUs2p6wdrMKuLAC5sDqsCNK5jjcc3aBeCEvVr/XLbcxxuSFETQ1eeM9XF
         Ar9CHcWZ2fb35So58Jl5dZg1T8pEi6O5MxrN5RTytz5/7HTECqfV3xhDUpFMLgHeQyLZ
         dmg8zEJSHOU8vnSXG3y+XkxX9KVIzrbAKgIuA1ldAtGLorx+WX+QJwTRT43W7VZSy1Wl
         ddCRnt7w0g1Z1XFw7KDVUY/xw3HhgKecdP7aptubyNhhm9Idz1a6LyijtDzWWUALYjKh
         r7Q9/X5OYzEi0P8lxSBWqdYl7dzMmc+MBRWj4h1ZO9dywXcE/xByCMH8LFhORPAKHy0r
         A3Xg==
X-Gm-Message-State: APjAAAUeApUwM0wCWCne5RBlzIgsl95p9Q83VMrL8AorVeZv5TfgHHUw
        byhRK2M6ZePd3k7D5Y6h/nM=
X-Google-Smtp-Source: APXvYqzfoBpzqctZdzjfhmb6BzPY7Np8IhxEXe95q94lL5/MH2lVChZI9h/4xOJaMv1zYgOhx21eqw==
X-Received: by 2002:a17:902:8503:: with SMTP id bj3mr100530216plb.180.1578262922683;
        Sun, 05 Jan 2020 14:22:02 -0800 (PST)
Received: from [10.230.28.123] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b193sm67411327pfb.57.2020.01.05.14.22.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jan 2020 14:22:02 -0800 (PST)
Subject: Re: [PATCH] net: stmmac: platform: Fix MDIO init for platforms
 without PHY
To:     =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>,
        linux-arm-kernel@lists.infradead.org,
        David Miller <davem@davemloft.net>, sriram.dash@samsung.com,
        p.rajanbabu@samsung.com, pankaj.dubey@samsung.com
Cc:     Jose.Abreu@synopsys.com, jayati.sahu@samsung.com,
        alexandre.torgue@st.com, rcsekar@samsung.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, peppe.cavallaro@st.com,
        linux-stm32@st-md-mailman.stormreply.com
References: <CGME20191219102407epcas5p103b26e6fb191f7135d870a3449115c89@epcas5p1.samsung.com>
 <1576750621-78066-1-git-send-email-p.rajanbabu@samsung.com>
 <20191220.212918.1661751615125167321.davem@davemloft.net>
 <1700835.tBzmY8zkgn@diego>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <c25fbdb3-0e60-6e54-d58a-b05e8b805a58@gmail.com>
Date:   Sun, 5 Jan 2020 14:22:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <1700835.tBzmY8zkgn@diego>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiko,

On 1/5/2020 12:43 PM, Heiko Stübner wrote:
> Hi,
> 
> Am Samstag, 21. Dezember 2019, 06:29:18 CET schrieb David Miller:
>> From: Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>
>> Date: Thu, 19 Dec 2019 15:47:01 +0530
>>
>>> The current implementation of "stmmac_dt_phy" function initializes
>>> the MDIO platform bus data, even in the absence of PHY. This fix
>>> will skip MDIO initialization if there is no PHY present.
>>>
>>> Fixes: 7437127 ("net: stmmac: Convert to phylink and remove phylib logic")
>>> Acked-by: Jayati Sahu <jayati.sahu@samsung.com>
>>> Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
>>> Signed-off-by: Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>
>>
>> Applied and queued up for -stable, thanks.
> 
> with this patch applied I now run into issues on multiple rockchip
> platforms using a gmac interface.

Do you have a list of DTS files that are affected by any chance? For the
32-bit platforms that I looked it, it seems like:

arch/arm/boot/dts/rk3228-evb.dts is OK because it has a MDIO bus node
arch/arm/boot/dts/rk3229-xms6.dts is also OK

arch/arm/boot/dts/rk3229-evb.dts is probably broken, there is no
phy-handle property or MDIO bus node, so it must be relying on
auto-scanning of the bus somehow that this patch broke.

And likewise for most 64-bit platforms except a1 and nanopi4.

> 
> When probing the driver and trying to establish a connection for a nfsroot
> it always runs into a null pointer in mdiobus_get_phy():
> 
> [   26.878839] rk_gmac-dwmac ff360000.ethernet: IRQ eth_wake_irq not found
> [   26.886322] rk_gmac-dwmac ff360000.ethernet: IRQ eth_lpi not found
> [   26.894505] rk_gmac-dwmac ff360000.ethernet: PTP uses main clock
> [   26.908209] rk_gmac-dwmac ff360000.ethernet: clock input or output? (output).
> [   26.916269] rk_gmac-dwmac ff360000.ethernet: Can not read property: tx_delay.
> [   26.924297] rk_gmac-dwmac ff360000.ethernet: set tx_delay to 0x30
> [   26.931150] rk_gmac-dwmac ff360000.ethernet: Can not read property: rx_delay.
> [   26.939166] rk_gmac-dwmac ff360000.ethernet: set rx_delay to 0x10
> [   26.946021] rk_gmac-dwmac ff360000.ethernet: integrated PHY? (no).
> [   26.953032] rk_gmac-dwmac ff360000.ethernet: cannot get clock clk_mac_refout
> [   26.966161] rk_gmac-dwmac ff360000.ethernet: init for RMII
> [   26.972633] rk_gmac-dwmac ff360000.ethernet: User ID: 0x10, Synopsys ID: 0x35
> [   26.980830] rk_gmac-dwmac ff360000.ethernet:         DWMAC1000
> [   26.986735] rk_gmac-dwmac ff360000.ethernet: DMA HW capability register supported
> [   26.995145] rk_gmac-dwmac ff360000.ethernet: RX Checksum Offload Engine supported
> [   27.003540] rk_gmac-dwmac ff360000.ethernet: COE Type 2
> [   27.009408] rk_gmac-dwmac ff360000.ethernet: TX Checksum insertion supported
> [   27.017320] rk_gmac-dwmac ff360000.ethernet: Wake-Up On Lan supported
> [   27.024577] rk_gmac-dwmac ff360000.ethernet: Normal descriptors
> [   27.031211] rk_gmac-dwmac ff360000.ethernet: Ring mode enabled
> [   27.037743] rk_gmac-dwmac ff360000.ethernet: Enable RX Mitigation via HW Watchdog Timer
> [   27.209823] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000398
>  2IP-Config: eth0 hardware address  66:e4:9b:b1:30:c3 mtu 1500 DHCP
> 7.219681] Mem abort info:
> [   27.229322]   ESR = 0x96000006
> [   27.229328]   EC = 0x25: DABT (current EL), IL = 32 bits
> [   27.229330]   SET = 0, FnV = 0
> [   27.229332]   EA = 0, S1PTW = 0
> [   27.229334] Data abort info:
> [   27.229336]   ISV = 0, ISS = 0x00000006
> [   27.229338]   CM = 0, WnR = 0
> [   27.229342] user pgtable: 4k pages, 48-bit VAs, pgdp=000000003e7d4000
> [   27.229345] [0000000000000398] pgd=0000000036739003, pud=0000000035894003, pmd=0000000000000000
> [   27.273398] Internal error: Oops: 96000006 [#1] SMP
> [   27.273403] Modules linked in: smsc95xx smsc75xx ax88179_178a asix usbnet panel_leadtek_ltk500hd1829 dwmac_rk stmmac_platform stmmac rockchipdrm phy_rockchip_inno_dsidphy analogix_dp dw_hdmi cec r
> c_core dw_mipi_dsi drm_kms_helper rtc_rk808 drm drm_panel_orientation_quirks
> [   27.305785] CPU: 3 PID: 1388 Comm: ipconfig Not tainted 5.5.0-rc4-00934-gd57e566e6874 #1463
> [   27.305790] Hardware name: Theobroma Systems Cobra with Leadtek Display (DT)
> [   27.323006] pstate: 40000005 (nZcv daif -PAN -UAO)
> [   27.323020] pc : mdiobus_get_phy+0x4/0x20
> [   27.332867] lr : stmmac_open+0x780/0xa78 [stmmac]
> [   27.332872] sp : ffff80001113b9a0
> [   27.341823] x29: ffff80001113b9a0 x28: 0000000000401003
> [   27.347761] x27: ffff00003d5cf200 x26: 0000000000000000
> [   27.353699] x25: 0000000000000001 x24: 0000000000000000
> [   27.359636] x23: 0000000000001002 x22: ffff800008b790a0
> [   27.365575] x21: ffff000035f84000 x20: 00000000ffffffff
> [   27.371513] x19: ffff000035f84800 x18: 0000000000000000
> [   27.377451] x17: 0000000000000000 x16: 0000000000000000
> [   27.383389] x15: 0000000000000000 x14: ffffffffffffffff
> [   27.389328] x13: 0000000000000020 x12: 0101010101010101
> [   27.395266] x11: 0000000000000003 x10: 0101010101010101
> [   27.401203] x9 : fffffffffffffffd x8 : 7f7f7f7f7f7f7f7f
> [   27.407143] x7 : fefefeff646c606d x6 : 1e091448e4e5f6e9
> [   27.413074] x5 : 697665644814091e x4 : 8080808000000000
> [   27.419013] x3 : 8343c96b232bb348 x2 : ffff00003d63f880
> [   27.424953] x1 : fffffffffffffff8 x0 : 0000000000000000
> [   27.430882] Call trace:
> [   27.433620]  mdiobus_get_phy+0x4/0x20
> [   27.437715]  __dev_open+0xe4/0x160
> [   27.441515]  __dev_change_flags+0x160/0x1b8
> [   27.446191]  dev_change_flags+0x20/0x60
> [   27.450478]  devinet_ioctl+0x66c/0x738
> [   27.454666]  inet_ioctl+0x2f4/0x360
> [   27.458565]  sock_do_ioctl+0x44/0x2b0
> [   27.462657]  sock_ioctl+0x1c8/0x508
> [   27.466556]  do_vfs_ioctl+0x604/0xbd0
> [   27.470646]  ksys_ioctl+0x78/0xa8
> [   27.474351]  __arm64_sys_ioctl+0x1c/0x28
> [   27.478737]  el0_svc_common.constprop.0+0x68/0x160
> [   27.484083]  el0_svc_handler+0x20/0x80
> [   27.488273]  el0_sync_handler+0x10c/0x180
> [   27.492753]  el0_sync+0x140/0x180
> [   27.496462] Code: 97ffffb0 a8c17bfd d65f03c0 8b21cc01 (f941d020)
> [   27.503275] ---[ end trace 6f6ca54e66af6d48 ]---
> 
> With the expected output being normally at this point:
> [   18.575321] rk_gmac-dwmac ff360000.ethernet eth0: PHY [stmmac-0:00] driver [RTL8201F Fast Ethernet]
> [   18.602975] rk_gmac-dwmac ff360000.ethernet eth0: No Safety Features support found
> [   18.611505] rk_gmac-dwmac ff360000.ethernet eth0: PTP not supported by HW
> [   18.619117] rk_gmac-dwmac ff360000.ethernet eth0: configuring for phy/rmii link mode
> [   22.719478] rk_gmac-dwmac ff360000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> 
> or
> 
> [   27.326984] rk_gmac-dwmac ff360000.ethernet eth0: PHY [stmmac-0:00] driver [Generic PHY]
> [   27.353543] rk_gmac-dwmac ff360000.ethernet eth0: No Safety Features support found
> [   27.362055] rk_gmac-dwmac ff360000.ethernet eth0: PTP not supported by HW
> [   27.369663] rk_gmac-dwmac ff360000.ethernet eth0: configuring for phy/rmii link mode
> [   29.406784] rk_gmac-dwmac ff360000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> 
> 
> This is torvalds git head and it was still working at -rc1 and all kernels
> before that. When I just revert this commit, things also start working
> again, so I guess something must be wrong here?

Yes, this was also identified to be problematic by the kernelci boot
farms on another platform, see [1].

[1]:
https://lore.kernel.org/linux-arm-kernel/5e0314da.1c69fb81.a7d63.29c1@mx.google.com/

Do you mind trying this patch and letting me know if it works for you.
Sriram, please also try it on your platforms and let me know if solves
the problem you were after. Thanks

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index cc8d7e7bf9ac..e192b8e0809e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -320,7 +320,7 @@ static int stmmac_mtl_setup(struct platform_device
*pdev,
 static int stmmac_dt_phy(struct plat_stmmacenet_data *plat,
                         struct device_node *np, struct device *dev)
 {
-       bool mdio = false;
+       bool mdio = true;
        static const struct of_device_id need_mdio_ids[] = {
                { .compatible = "snps,dwc-qos-ethernet-4.10" },
                {},
@@ -341,8 +341,9 @@ static int stmmac_dt_phy(struct plat_stmmacenet_data
*plat,
        }

        if (plat->mdio_node) {
-               dev_dbg(dev, "Found MDIO subnode\n");
-               mdio = true;
+               mdio = of_device_is_available(plat->mdio_node);
+               dev_dbg(dev, "Found MDIO subnode, status: %sabled\n",
+                       mdio ? "en" : "dis");
        }

        if (mdio) {
-- 
Florian
