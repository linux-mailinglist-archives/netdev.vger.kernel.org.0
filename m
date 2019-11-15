Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE07CFE3A6
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 18:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbfKORJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 12:09:46 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:39469 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfKORJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 12:09:45 -0500
Received: by mail-io1-f68.google.com with SMTP id k1so11208531ioj.6
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 09:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3GuXTyEp+/CEiQYWz6xuuVqIXrSgWJEVfhnqFNXZVMo=;
        b=hD9LuNsfCIcsd5ehUq3O00nxq+ldFdnY1+O4xTyjoVEgApwrtadpQ0Av35FOqAhiPP
         rmxA/SjRrbGG7TX5LjF67v8ke8OYdgAGXjSrk2CwjWK3ESuSTNM5biLCJBqrVkrjRYzi
         X0yHwKh5mNRgSOnZK6qHIP1dKRI4/Ti0C0dw0gOTySur1nGAbOuMuMX3dSOs/jPdIZo8
         dQyxpDNcH8yEtNwjpEURfuMK2msHv6+F6L1rqotCg4EPWW0ol+wJ6f5NhfOOAbocutVR
         QtCR0qTHdIk5LYb0YNJjtx6fi5Xm8/xQBjXM4kZ4TPjmwBLnvDWJmtnZyo7NzePVX1oW
         wMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3GuXTyEp+/CEiQYWz6xuuVqIXrSgWJEVfhnqFNXZVMo=;
        b=bOIN8MDxt0B5uSn6Ne0DvnZvpcfumKgM4BWJf0SJgjlZaVmEIXhZWcF4rYuwjMk70k
         yPUD2/CryvqnX2lZqnxTVkRYeWZhF6svY6rAqxAECX3zHLYZir/p5k/VfySk8V3bkNd7
         YH1aufonuROUQc0NHEsiY8LzE7tRp95nBoax5dRq/SQNNEJdHOe/u8EhfLtArDNGEvwY
         tj0/0m7PVZcXvXW30X/rPkJsS+Kg+Hv/kZ94ZYabxX1kQ81LiTwt2gX1Pufssi01NkP0
         3vrrFDYge0tEwvGV8q5i5B3dlcINecAKXwRDVxVvXIER/qzN/wSmRJcoZm/WAyn9C8fK
         KH/g==
X-Gm-Message-State: APjAAAUiKMknFEiuxhzlEqH4WKNlTJ5eE3bK0xd6UEkErIdu///yYCEw
        vx4CZK3mPZhvGi77NOnAZ/mbc6zDAlalUHoyIYkbp7qLhLM=
X-Google-Smtp-Source: APXvYqyhKRO6CrAv15WFbGFi6cizX9lMXVeHkAH0JDrhNE2z62Njkm9AsnorE85Dmlf4PQp+CwoQkGKwPsaFo5O9efw=
X-Received: by 2002:a5d:8953:: with SMTP id b19mr1796400iot.168.1573837784235;
 Fri, 15 Nov 2019 09:09:44 -0800 (PST)
MIME-Version: 1.0
References: <cc0add2f-4ae7-70cb-2c98-242d0f0aede9@ncentric.com>
 <CANn89iJxhte1yH6-dhvRpwWsOm-=P0PtzpAzsLgYtzOQSoqA9w@mail.gmail.com> <43e827b5-15af-96c5-b633-d8355d1c6c0b@ncentric.com>
In-Reply-To: <43e827b5-15af-96c5-b633-d8355d1c6c0b@ncentric.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 15 Nov 2019 09:09:32 -0800
Message-ID: <CANn89iJ6OOQG8PZ1qDXP-EsOLKip44rcQhn+LNTUM1HezRwvNA@mail.gmail.com>
Subject: Re: crash since commit "net/flow_dissector: switch to siphash"
To:     Koen Vandeputte <koen.vandeputte@ncentric.com>
Cc:     netdev <netdev@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 3:30 AM Koen Vandeputte
<koen.vandeputte@ncentric.com> wrote:
>
>
> On 13.11.19 15:50, Eric Dumazet wrote:
> > On Wed, Nov 13, 2019 at 3:52 AM Koen Vandeputte
> > <koen.vandeputte@ncentric.com> wrote:
> >> Hi Eric,
> >>
> >> I'm currently testing kernel 4.14.153 bump for OpenWrt and noticed splat
> >> below on my testing boards.
> >> They all reboot continuously nearly immediately when linked.
> >>
> >> It feels like it's tied to a commit of yours [1]
> > Have you tried current upstream kernels ?
>
> No.
>
> This board is only supported on OpenWrt currently using 4.14 and it's
> not natively supported by upstream.
>
> >
> > Is is a backport issue, or a bug in original commit ?
>
> No idea .. and I'm not profound enough on that part of the code to judge
> this,
>
> which is why I'm consulting your expert opinion.
>
> >
> > Can you give us gcc version ?
> 7.4.0
> >
> > Can you check what SIPHASH_ALIGNMENT value is at compile time ?
> 8 (exposed it in dmesg on boot)

Please ask OpenWrt specialists for support.

The code is probably mishandled by the compiler.

siphash() is supposed to handle misaligned data just fine, and
net/core/flow_dissector.c tries hard to align the keys anyway.

>
>
> Hw used:
>
> system type        : Qualcomm Atheros QCA9558 ver 1 rev 0
> machine            : MikroTik RouterBOARD 922UAGS-5HPacD
> processor        : 0
> cpu model        : MIPS 74Kc V5.0
>
> >
> >
> >> Any idea?
> >>
> >> If you need more info, please let me know.
> >>
> >> Thanks,
> >>
> >> Koen
> >>
> >>
> >> [1]:
> >> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.14.154&id=a9de6f42e945cdb24b59c7ab7ebad1eba6cb5875
> >>
> >>
> >> [   48.269789] wlan0: Trigger new scan to find an IBSS to join
> >> [   48.680754] wlan0: Trigger new scan to find an IBSS to join
> >> [   49.041907] wlan0: Trigger new scan to find an IBSS to join
> >> [   49.079668] wlan0: Trigger new scan to find an IBSS to join
> >> [   49.149738] wlan0: Selected IBSS BSSID 16:5b:94:39:cb:5f based on
> >> configured SSID
> >> [   49.199633] Unhandled kernel unaligned access[#1]:
> >> [   49.204505] CPU: 0 PID: 1634 Comm: wpa_supplicant Tainted: G
> >> W       4.14.153 #0
> >> [   49.212619] task: 87d14580 task.stack: 860c6000
> >> [   49.217209] $ 0   : 00000000 77ea0b33 00000000 ceb5840c
> >> [   49.222515] $ 4   : 860c7a78 00000014 67aae3bf 00000000
> >> [   49.227821] $ 8   : 00000000 8040c9b0 87d1e460 0000d000
> >> [   49.233128] $12   : 74650000 00000000 00000001 00000002
> >> [   49.238435] $16   : 0000fffe 804f0000 67aae3bf 8766e5a4
> >> [   49.243741] $20   : 00000000 804f0000 804f3978 87d1e054
> >> [   49.249048] $24   : 00000002 00000003
> >> [   49.254353] $28   : 860c6000 860c7a30 00000000 8032cff8
> >> [   49.259661] Hi    : 00000050
> >> [   49.262573] Lo    : 00000002
> >> [   49.265500] epc   : 804061a4 __siphash_aligned+0x24/0x730
> >> [   49.270985] ra    : 8032cff8 skb_get_hash_perturb+0x160/0x1a8
> >> [   49.276803] Status: 1100dc03 KERNEL EXL IE
> >> [   49.281045] Cause : 00800010 (ExcCode 04)
> >> [   49.285110] BadVA : 67aae3c7
> >> [   49.288024] PrId  : 00019750 (MIPS 74Kc)
> >> [   49.291990] Modules linked in: mbt ath9k ath9k_common qcserial pppoe
> >> ppp_async option cdc_mbim ath9k_hw ath10k_pci ath10k_core ath usb_wwan
> >> sierra_net sierra rndis_host qmi_wwan pppox ppp_generic mac80211
> >> iptable_nat iptable_mangle iptable_filter ipt_REJECT ipt_MASQUERADE
> >> ip_tables huawei_cdc_ncm ftdi_sio cfg80211 cdc_subset cdc_ncm cdc_ether
> >> xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_lim2
> >> [   49.363914]  cls_tcindex cls_route cls_matchall cls_fw cls_flow
> >> cls_basic act_skbedit act_mirred i2c_dev ledtrig_usbport cryptodev msdos
> >> bonding ip_gre gre dummy udp_tunnel ip_tunnel tun vfat fat nls_utf8
> >> nls_iso8859_1 nls_cp437 authenc ehci_platform sd_mod scsi_mod ehci_hcd
> >> gpio_button_hotplug ext4 mbcache jbd2 usbcore nls_base usb_common ptp
> >> pps_core mii aead crypto_null cryptomgr crc32c_generic crypto_hash
> >> [   49.400738] Process wpa_supplicant (pid: 1634, threadinfo=860c6000,
> >> task=87d14580, tls=77f6defc)
> >> [   49.409638] Stack : 67aae3bf 0000fffe 804f0000 67aae3bf 8766e5a4
> >> 00000000 804f0000 804f3978
> >> [   49.418121]         00000056 80580000 879b84c8 879cb088 00000000
> >> 00000000 00000085 00000004
> >> [   49.426604]         00220000 00000000 888e0000 00000000 00000000
> >> 00000000 00000000 00000000
> >> [   49.435087]         00000000 00000000 00000000 00000000 00000000
> >> 00000000 00000000 00000000
> >> [   49.443570]         860c7b68 ceb5840c 86cb0bc0 860c2300 8766e508
> >> 86d2b604 879cb088 8793a750
> >> [   49.452053]         ...
> >> [   49.454537] Call Trace:
> >> [   49.457014] [<804061a4>] __siphash_aligned+0x24/0x730
> >> [   49.462146] [<8032cff8>] skb_get_hash_perturb+0x160/0x1a8
> >> [   49.467737] [<86d2b604>] ieee80211_reserve_tid+0x26c/0xeb8 [mac80211]
> >> [   49.474300] Code: afb2000c  afb10008  afb00004 <8cd40008> 8cc90000
> >> 3c136c79  3c02646f  3c07736f  24427261
> >> [   49.484200]
> >> [   49.485774] ---[ end trace ec8947d373843bf7 ]---
> >> [   49.492228] Kernel panic - not syncing: Fatal exception in interrupt
> >> [   49.499642] Rebooting in 3 seconds..
> >>
