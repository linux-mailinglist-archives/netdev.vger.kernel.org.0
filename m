Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118CC109C0E
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbfKZKMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:12:36 -0500
Received: from mxex2.tik.uni-stuttgart.de ([129.69.192.21]:40026 "EHLO
        mxex2.tik.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727751AbfKZKMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:12:36 -0500
Received: from localhost (localhost [127.0.0.1])
        by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTP id 23507603E6;
        Tue, 26 Nov 2019 11:12:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=uni-stuttgart.de;
         h=content-transfer-encoding:content-language:content-type
        :content-type:in-reply-to:mime-version:user-agent:date:date
        :message-id:references:from:from:subject:subject:received
        :received; s=dkim; i=@tik.uni-stuttgart.de; t=1574763150; x=
        1576501951; bh=ME/Rmjh+bCu5yes93LRekaQTZfIINDvjtzEilFT+ZOo=; b=q
        bbzOuf1inLI6FBO4NHdpskVItOAlkLMcRD3EPqMCOc7iec9qzwKE6m4voReMy2lb
        DgqRuBb0RkMjrdIwy2Dn2xF1+NiXI8mly1b7T9rGP0D5QR2N/6/hlv965aG7VTl4
        BorUTKyfWncP2wSAS4LBcDYSdIUl3DFYlb+oxFXw9Q7CAAk1Joz4Xd5x91Xl8AZd
        gTviFFUf1aeA88svVDmslT0MpZdZnmwX9bsTvp+A09o7AV0ir/dUTN15WJ1Z18uT
        a8Rsy4DjXgiRhi3o343xDVjmAbRneNKj2aOJx7dHcydpwtCO2VzIQGBec7DGriMq
        nhXLOh29QbkiANq6Rn/Pg==
X-Virus-Scanned: USTUTT mailrelay AV services at mxex2.tik.uni-stuttgart.de
Received: from mxex2.tik.uni-stuttgart.de ([127.0.0.1])
        by localhost (mxex2.tik.uni-stuttgart.de [127.0.0.1]) (amavisd-new, port 10031)
        with ESMTP id dgNE55U0_1YY; Tue, 26 Nov 2019 11:12:30 +0100 (CET)
Received: from [IPv6:2001:7c0:7c0:111:b049:9ba6:92a3:7e6d] (unknown [IPv6:2001:7c0:7c0:111:b049:9ba6:92a3:7e6d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTPSA;
        Tue, 26 Nov 2019 11:12:30 +0100 (CET)
Subject: Re: [PATCH] cfg80211: fix double-free after changing network
 namespace
From:   "=?UTF-8?Q?Stefan_B=c3=bchler?=" 
        <stefan.buehler@tik.uni-stuttgart.de>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?Q?Stefan_B=c3=bchler?= <source@stbuehler.de>
References: <20191126100543.782023-1-stefan.buehler@tik.uni-stuttgart.de>
Openpgp: preference=signencrypt
Autocrypt: addr=stefan.buehler@tik.uni-stuttgart.de; prefer-encrypt=mutual;
 keydata=
 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
 rwHRmQ==
Message-ID: <dfdb5abc-0565-f19d-bb74-df42c0e0224e@tik.uni-stuttgart.de>
Date:   Tue, 26 Nov 2019 11:12:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191126100543.782023-1-stefan.buehler@tik.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'd also like to see this backported to stable, but
submitting-patches.rst says you don't like individual developers adding
the tag :)

Just for additional context, the KASAN log looks like this:

---
video: module verification failed: signature and/or required key missing
- tainting kernel
[...]
==================================================================
BUG: KASAN: use-after-free in ksize+0x20/0x60
Read of size 1 at addr ffff888152eb6000 by task ns-start/1947

CPU: 2 PID: 1947 Comm: ns-start Tainted: G            E     5.3.9-falcot #1
Hardware name: Intel(R) Client Systems NUC8i3BEK/NUC8BEB, BIOS
BECFL357.86A.0075.2019.1023.1448 10/23/2019
Call Trace:
 dump_stack+0x71/0xa0
 print_address_description.cold+0xd3/0x313
 ? ksize+0x20/0x60
 ? ksize+0x20/0x60
 __kasan_report.cold+0x1a/0x3d
 ? ksize+0x20/0x60
 kasan_report+0xe/0x12
 check_memory_region+0x11b/0x1a0
 ksize+0x20/0x60
 kzfree+0x14/0x30
 __cfg80211_unregister_wdev+0x1dc/0x380 [cfg80211]
 cfg80211_netdev_notifier_call+0x9d9/0x1240 [cfg80211]
 ? addrconf_ifdown+0xbcf/0xf00
 ? cfg80211_init_wdev+0x4c0/0x4c0 [cfg80211]
 ? addrconf_notify+0x11f/0x2050
 ? _raw_spin_lock+0xd0/0xd0
 ? mutex_lock+0x8e/0xe0
 ? __mutex_lock_slowpath+0x10/0x10
 ? inet6_ifinfo_notify+0x100/0x100
 ? mutex_unlock+0x1d/0x40
 notifier_call_chain+0xbe/0x130
 rollback_registered_many+0x686/0xb50
 ? unlist_netdevice+0x3e0/0x3e0
 ? free_one_page+0x78/0x1c0
 ? mutex_lock+0x8e/0xe0
 ? __mutex_lock_slowpath+0x10/0x10
 unregister_netdevice_many.part.0+0x13/0x1c0
 ieee80211_remove_interfaces+0x31f/0x760 [mac80211]
 ? kfree_call_rcu+0x10/0x10
 ? _raw_spin_lock_irqsave+0x8d/0xf0
 ? ieee80211_sdata_stop+0x70/0x70 [mac80211]
 ? mutex_lock+0x8e/0xe0
 ieee80211_unregister_hw+0x47/0x200 [mac80211]
 iwl_op_mode_mvm_stop+0x8b/0x5e0 [iwlmvm]
 _iwl_op_mode_stop.isra.0+0x74/0xc0 [iwlwifi]
 iwl_drv_stop+0x2e/0x560 [iwlwifi]
 iwl_pci_remove+0x8d/0xe0 [iwlwifi]
 pci_device_remove+0xf3/0x290
 ? pcibios_free_irq+0x10/0x10
 ? up_read+0x15/0x90
 device_release_driver_internal+0x1ad/0x440
 pci_stop_bus_device+0x123/0x190
 pci_stop_and_remove_bus_device_locked+0x16/0x30
 remove_store+0xcb/0xe0
 ? sriov_numvfs_store+0x250/0x250
 kernfs_fop_write+0x260/0x410
 ? security_file_permission+0x6e/0x2c0
 ? do_fcntl+0x48f/0x8d0
 vfs_write+0x14e/0x450
 ksys_write+0xed/0x1c0
 ? __ia32_sys_read+0xb0/0xb0
 ? fput_many+0x1c/0x130
 do_syscall_64+0x9c/0x2f0
 ? prepare_exit_to_usermode+0xe8/0x170
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f8d98487904
Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00
48 8d 05 d9 3a 0d 00 8b 00 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00
f0 ff ff 77 54 c3 0f 1f 00 48 83 ec 28 48 89 54 24 18 48
RSP: 002b:00007ffebd049408 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f8d98487904
RDX: 0000000000000002 RSI: 000056308a2a79e0 RDI: 0000000000000001
RBP: 000056308a2a79e0 R08: 00000000ffffffff R09: 000000000000000a
R10: 000056308a2af790 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f8d98556760 R14: 0000000000000002 R15: 00007f8d98556960

Allocated by task 1779:
 save_stack+0x1b/0x80
 __kasan_kmalloc.constprop.0+0xc2/0xd0
 __cfg80211_set_encryption+0xc87/0x1bd0 [cfg80211]
 cfg80211_wext_siwencodeext+0x414/0xa20 [cfg80211]
 ioctl_standard_iw_point+0x6b0/0x9e0
 ioctl_standard_call+0x12d/0x160
 wext_handle_ioctl+0xeb/0x170
 sock_ioctl+0x3b0/0x5f0
 do_vfs_ioctl+0x9a1/0xf10
 ksys_ioctl+0x5e/0x90
 __x64_sys_ioctl+0x6f/0xb0
 do_syscall_64+0x9c/0x2f0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 1878:
 save_stack+0x1b/0x80
 __kasan_slab_free+0x117/0x160
 kfree+0x86/0x260
 __cfg80211_unregister_wdev+0x1dc/0x380 [cfg80211]
 cfg80211_netdev_notifier_call+0x9d9/0x1240 [cfg80211]
 notifier_call_chain+0xbe/0x130
 dev_change_net_namespace+0x1cd/0xb00
 cfg80211_switch_netns+0xf0/0x570 [cfg80211]
 nl80211_wiphy_netns+0x107/0x210 [cfg80211]
 genl_family_rcv_msg+0x50e/0xe50
 genl_rcv_msg+0x9f/0x130
 netlink_rcv_skb+0x128/0x360
 genl_rcv+0x24/0x40
 netlink_unicast+0x3f2/0x5d0
 netlink_sendmsg+0x6c4/0xb10
 sock_sendmsg+0xe4/0x110
 ___sys_sendmsg+0x64e/0x9a0
 __sys_sendmsg+0xbe/0x150
 do_syscall_64+0x9c/0x2f0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888152eb6000
                                       which belongs to the cache
kmalloc-192 of size 192
The buggy address is located 0 bytes inside of
                                       192-byte region
[ffff888152eb6000, ffff888152eb60c0)
The buggy address belongs to the page:
page:ffffea00054bad80 refcount:1 mapcount:0 mapping:ffff888155003000
index:0xffff888152eb6000
flags: 0x17fffc000000200(slab)
raw: 017fffc000000200 0000000000000000 0000000100000001 ffff888155003000
raw: ffff888152eb6000 0000000080100002 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888152eb5f00: 00 fc fc 00 fc fc 00 fc fc 00 fc fc fb fc fc fb
 ffff888152eb5f80: fc fc 00 fc fc 00 fc fc 00 fc fc fb fc fc fc fc
>ffff888152eb6000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888152eb6080: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888152eb6100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
Disabling lock debugging due to kernel taint
==================================================================
---

And I trigger it by moving a phy to a namespace (using it there with
wpa_supplicant and dhcp), closing the namespace, and then try the same
again.

cheers,
Stefan

-- 
Stefan Bühler    Mail/xmpp: stefan.buehler@tik.uni-stuttgart.de
Netze und Kommunikationssysteme der Universität Stuttgart (NKS)
https://www.tik.uni-stuttgart.de/    Telefon: +49 711 685 60854
