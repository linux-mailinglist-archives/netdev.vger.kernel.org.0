Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600861319D3
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 21:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgAFUuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 15:50:15 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33039 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgAFUuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 15:50:15 -0500
Received: by mail-ed1-f67.google.com with SMTP id r21so48555196edq.0;
        Mon, 06 Jan 2020 12:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BuPEyza3GZ2kJMIldpXVSw9iuf937T+5+sT3lcdzid0=;
        b=XiwSRSuar+rkEWCedTTw7PBZDOAiqfHiOdXvD8HbyI0vVWZznS3kvBEMxn650RGvBD
         hK+rRebNnU/Oc1UC0fi018MU5bY7y3+oOoyYcVlp+Avy+tKyLW53OldhiCFPpLU98a4U
         tPqfhO1XGICJYeJXs7u58uPLm4vLHL4ILgM++H1l/UCkxrg25XL4h3bt0oQkTKcxS2C2
         XIfk7TP+EEX1yt1MiHE8Zl+URuj2+UhSAPqcKSFVKy1rXBUx0PGKGp+EngGfyfHaMPR1
         Dv2L6TzQu7lERqynzKj9gi5CovSOzTfdAvPac9UFJhbysUsHDiR0aPYc4t29xLNeLWoH
         njXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BuPEyza3GZ2kJMIldpXVSw9iuf937T+5+sT3lcdzid0=;
        b=np4Hg74ESR807Qaie9WoeUp5oFkXOTp7+NCKIjurCKldQasjqB6/sihQUuEFkz8yBI
         Vev4KmBNiGqrWczYD41KqDogQgIkQh/nPzNN/9QJoVsvVnvLrm45xdRqKR8ZOP5iuwaP
         1R5EUGAbq6oUJLPb3HxoxwNcIPLD71oLR50VV9R8nj6YuZ2GVLbXqZ36MKaEU21JT18F
         A3bZrS9/03Xu67VNMVhc0Dj+pCXnHd1OMzauvpZlzQ6cLhXd3Ww/NkNSnZoDVkClebiU
         WRFg2yzK222LqtQK+K3g4tLf993jq2c0OwVI0mBJErRI4vh6ep1i+lkD+YlhsYVRf/yY
         +QLg==
X-Gm-Message-State: APjAAAUE4Dkdgc+VFr2sZ5YUlQXQFOY5+gWJB583nHGM40RpY6c3F3IU
        J40mW3D6aFLaKXHsBQMO6RyU9o5r
X-Google-Smtp-Source: APXvYqwuvHt1oJy1cnOUcseyJDedFdMfsCXLDMPB23SKvLrswNwlUvwXf/g1nVrveTt++7RnLB2DkQ==
X-Received: by 2002:aa7:ccc7:: with SMTP id y7mr111376554edt.45.1578343811946;
        Mon, 06 Jan 2020 12:50:11 -0800 (PST)
Received: from [10.67.50.41] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p6sm8052810eja.63.2020.01.06.12.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2020 12:50:10 -0800 (PST)
Subject: Re: [PATCH] net: stmmac: platform: Fix MDIO init for platforms
 without PHY
To:     =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>
Cc:     linux-arm-kernel@lists.infradead.org,
        David Miller <davem@davemloft.net>, sriram.dash@samsung.com,
        p.rajanbabu@samsung.com, pankaj.dubey@samsung.com,
        Jose.Abreu@synopsys.com, jayati.sahu@samsung.com,
        alexandre.torgue@st.com, rcsekar@samsung.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, peppe.cavallaro@st.com,
        linux-stm32@st-md-mailman.stormreply.com
References: <CGME20191219102407epcas5p103b26e6fb191f7135d870a3449115c89@epcas5p1.samsung.com>
 <1700835.tBzmY8zkgn@diego> <c25fbdb3-0e60-6e54-d58a-b05e8b805a58@gmail.com>
 <1599392.7x4dJXGyiB@diego>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <13a2756a-4011-81cc-beba-5319f3626c7f@gmail.com>
Date:   Mon, 6 Jan 2020 12:50:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1599392.7x4dJXGyiB@diego>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/20 3:05 PM, Heiko Stübner wrote:
> Hi Florian,
> 
> Am Sonntag, 5. Januar 2020, 23:22:00 CET schrieb Florian Fainelli:
>> On 1/5/2020 12:43 PM, Heiko Stübner wrote:
>>> Am Samstag, 21. Dezember 2019, 06:29:18 CET schrieb David Miller:
>>>> From: Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>
>>>> Date: Thu, 19 Dec 2019 15:47:01 +0530
>>>>
>>>>> The current implementation of "stmmac_dt_phy" function initializes
>>>>> the MDIO platform bus data, even in the absence of PHY. This fix
>>>>> will skip MDIO initialization if there is no PHY present.
>>>>>
>>>>> Fixes: 7437127 ("net: stmmac: Convert to phylink and remove phylib logic")
>>>>> Acked-by: Jayati Sahu <jayati.sahu@samsung.com>
>>>>> Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
>>>>> Signed-off-by: Padmanabhan Rajanbabu <p.rajanbabu@samsung.com>
>>>>
>>>> Applied and queued up for -stable, thanks.
>>>
>>> with this patch applied I now run into issues on multiple rockchip
>>> platforms using a gmac interface.
>>
>> Do you have a list of DTS files that are affected by any chance? For the
>> 32-bit platforms that I looked it, it seems like:
>>
>> arch/arm/boot/dts/rk3228-evb.dts is OK because it has a MDIO bus node
>> arch/arm/boot/dts/rk3229-xms6.dts is also OK
>>
>> arch/arm/boot/dts/rk3229-evb.dts is probably broken, there is no
>> phy-handle property or MDIO bus node, so it must be relying on
>> auto-scanning of the bus somehow that this patch broke.
>>
>> And likewise for most 64-bit platforms except a1 and nanopi4.
> 
> I primarily noticed that on the px30-evb.dts and the internal board I'm
> working on right now. Both don't have that mdio bus node right now.
> 
> 
>>> When probing the driver and trying to establish a connection for a nfsroot
>>> it always runs into a null pointer in mdiobus_get_phy():
>>>
>>> [   26.878839] rk_gmac-dwmac ff360000.ethernet: IRQ eth_wake_irq not found
>>> [   26.886322] rk_gmac-dwmac ff360000.ethernet: IRQ eth_lpi not found
>>> [   26.894505] rk_gmac-dwmac ff360000.ethernet: PTP uses main clock
>>> [   26.908209] rk_gmac-dwmac ff360000.ethernet: clock input or output? (output).
>>> [   26.916269] rk_gmac-dwmac ff360000.ethernet: Can not read property: tx_delay.
>>> [   26.924297] rk_gmac-dwmac ff360000.ethernet: set tx_delay to 0x30
>>> [   26.931150] rk_gmac-dwmac ff360000.ethernet: Can not read property: rx_delay.
>>> [   26.939166] rk_gmac-dwmac ff360000.ethernet: set rx_delay to 0x10
>>> [   26.946021] rk_gmac-dwmac ff360000.ethernet: integrated PHY? (no).
>>> [   26.953032] rk_gmac-dwmac ff360000.ethernet: cannot get clock clk_mac_refout
>>> [   26.966161] rk_gmac-dwmac ff360000.ethernet: init for RMII
>>> [   26.972633] rk_gmac-dwmac ff360000.ethernet: User ID: 0x10, Synopsys ID: 0x35
>>> [   26.980830] rk_gmac-dwmac ff360000.ethernet:         DWMAC1000
>>> [   26.986735] rk_gmac-dwmac ff360000.ethernet: DMA HW capability register supported
>>> [   26.995145] rk_gmac-dwmac ff360000.ethernet: RX Checksum Offload Engine supported
>>> [   27.003540] rk_gmac-dwmac ff360000.ethernet: COE Type 2
>>> [   27.009408] rk_gmac-dwmac ff360000.ethernet: TX Checksum insertion supported
>>> [   27.017320] rk_gmac-dwmac ff360000.ethernet: Wake-Up On Lan supported
>>> [   27.024577] rk_gmac-dwmac ff360000.ethernet: Normal descriptors
>>> [   27.031211] rk_gmac-dwmac ff360000.ethernet: Ring mode enabled
>>> [   27.037743] rk_gmac-dwmac ff360000.ethernet: Enable RX Mitigation via HW Watchdog Timer
>>> [   27.209823] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000398
>>>  2IP-Config: eth0 hardware address  66:e4:9b:b1:30:c3 mtu 1500 DHCP
>>> 7.219681] Mem abort info:
>>> [   27.229322]   ESR = 0x96000006
>>> [   27.229328]   EC = 0x25: DABT (current EL), IL = 32 bits
>>> [   27.229330]   SET = 0, FnV = 0
>>> [   27.229332]   EA = 0, S1PTW = 0
>>> [   27.229334] Data abort info:
>>> [   27.229336]   ISV = 0, ISS = 0x00000006
>>> [   27.229338]   CM = 0, WnR = 0
>>> [   27.229342] user pgtable: 4k pages, 48-bit VAs, pgdp=000000003e7d4000
>>> [   27.229345] [0000000000000398] pgd=0000000036739003, pud=0000000035894003, pmd=0000000000000000
>>> [   27.273398] Internal error: Oops: 96000006 [#1] SMP
>>> [   27.273403] Modules linked in: smsc95xx smsc75xx ax88179_178a asix usbnet panel_leadtek_ltk500hd1829 dwmac_rk stmmac_platform stmmac rockchipdrm phy_rockchip_inno_dsidphy analogix_dp dw_hdmi cec r
>>> c_core dw_mipi_dsi drm_kms_helper rtc_rk808 drm drm_panel_orientation_quirks
>>> [   27.305785] CPU: 3 PID: 1388 Comm: ipconfig Not tainted 5.5.0-rc4-00934-gd57e566e6874 #1463
>>> [   27.305790] Hardware name: Theobroma Systems Cobra with Leadtek Display (DT)
>>> [   27.323006] pstate: 40000005 (nZcv daif -PAN -UAO)
>>> [   27.323020] pc : mdiobus_get_phy+0x4/0x20
>>> [   27.332867] lr : stmmac_open+0x780/0xa78 [stmmac]
>>> [   27.332872] sp : ffff80001113b9a0
>>> [   27.341823] x29: ffff80001113b9a0 x28: 0000000000401003
>>> [   27.347761] x27: ffff00003d5cf200 x26: 0000000000000000
>>> [   27.353699] x25: 0000000000000001 x24: 0000000000000000
>>> [   27.359636] x23: 0000000000001002 x22: ffff800008b790a0
>>> [   27.365575] x21: ffff000035f84000 x20: 00000000ffffffff
>>> [   27.371513] x19: ffff000035f84800 x18: 0000000000000000
>>> [   27.377451] x17: 0000000000000000 x16: 0000000000000000
>>> [   27.383389] x15: 0000000000000000 x14: ffffffffffffffff
>>> [   27.389328] x13: 0000000000000020 x12: 0101010101010101
>>> [   27.395266] x11: 0000000000000003 x10: 0101010101010101
>>> [   27.401203] x9 : fffffffffffffffd x8 : 7f7f7f7f7f7f7f7f
>>> [   27.407143] x7 : fefefeff646c606d x6 : 1e091448e4e5f6e9
>>> [   27.413074] x5 : 697665644814091e x4 : 8080808000000000
>>> [   27.419013] x3 : 8343c96b232bb348 x2 : ffff00003d63f880
>>> [   27.424953] x1 : fffffffffffffff8 x0 : 0000000000000000
>>> [   27.430882] Call trace:
>>> [   27.433620]  mdiobus_get_phy+0x4/0x20
>>> [   27.437715]  __dev_open+0xe4/0x160
>>> [   27.441515]  __dev_change_flags+0x160/0x1b8
>>> [   27.446191]  dev_change_flags+0x20/0x60
>>> [   27.450478]  devinet_ioctl+0x66c/0x738
>>> [   27.454666]  inet_ioctl+0x2f4/0x360
>>> [   27.458565]  sock_do_ioctl+0x44/0x2b0
>>> [   27.462657]  sock_ioctl+0x1c8/0x508
>>> [   27.466556]  do_vfs_ioctl+0x604/0xbd0
>>> [   27.470646]  ksys_ioctl+0x78/0xa8
>>> [   27.474351]  __arm64_sys_ioctl+0x1c/0x28
>>> [   27.478737]  el0_svc_common.constprop.0+0x68/0x160
>>> [   27.484083]  el0_svc_handler+0x20/0x80
>>> [   27.488273]  el0_sync_handler+0x10c/0x180
>>> [   27.492753]  el0_sync+0x140/0x180
>>> [   27.496462] Code: 97ffffb0 a8c17bfd d65f03c0 8b21cc01 (f941d020)
>>> [   27.503275] ---[ end trace 6f6ca54e66af6d48 ]---
>>>
>>> With the expected output being normally at this point:
>>> [   18.575321] rk_gmac-dwmac ff360000.ethernet eth0: PHY [stmmac-0:00] driver [RTL8201F Fast Ethernet]
>>> [   18.602975] rk_gmac-dwmac ff360000.ethernet eth0: No Safety Features support found
>>> [   18.611505] rk_gmac-dwmac ff360000.ethernet eth0: PTP not supported by HW
>>> [   18.619117] rk_gmac-dwmac ff360000.ethernet eth0: configuring for phy/rmii link mode
>>> [   22.719478] rk_gmac-dwmac ff360000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
>>>
>>> or
>>>
>>> [   27.326984] rk_gmac-dwmac ff360000.ethernet eth0: PHY [stmmac-0:00] driver [Generic PHY]
>>> [   27.353543] rk_gmac-dwmac ff360000.ethernet eth0: No Safety Features support found
>>> [   27.362055] rk_gmac-dwmac ff360000.ethernet eth0: PTP not supported by HW
>>> [   27.369663] rk_gmac-dwmac ff360000.ethernet eth0: configuring for phy/rmii link mode
>>> [   29.406784] rk_gmac-dwmac ff360000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
>>>
>>>
>>> This is torvalds git head and it was still working at -rc1 and all kernels
>>> before that. When I just revert this commit, things also start working
>>> again, so I guess something must be wrong here?
>>
>> Yes, this was also identified to be problematic by the kernelci boot
>> farms on another platform, see [1].
>>
>> [1]:
>> https://lore.kernel.org/linux-arm-kernel/5e0314da.1c69fb81.a7d63.29c1@mx.google.com/
>>
>> Do you mind trying this patch and letting me know if it works for you.
>> Sriram, please also try it on your platforms and let me know if solves
>> the problem you were after. Thanks
> 
> Works on both boards I had that were affected, so
> Tested-by: Heiko Stuebner <heiko@sntech.de>

Thanks Heiko, I am keen on submitting the revert of the affected commit,
submit the second part where we actually ensure that the MDIO bus
controller node is available as net-next material, so hopefully the guys
at Samsung can test and response whether it fixes the problem they were
initially after.
--
Florian
