Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA2F6610C3
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 19:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjAGSYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 13:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjAGSYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 13:24:09 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 07 Jan 2023 10:24:06 PST
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD893E85F
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 10:24:06 -0800 (PST)
X-KPN-MessageId: 4fbe1b25-8eb8-11ed-884e-005056999439
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
        by ewsoutbound.so.kpn.org (Halon) with ESMTPS
        id 4fbe1b25-8eb8-11ed-884e-005056999439;
        Sat, 07 Jan 2023 19:22:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=xs4all.nl; s=xs4all01;
        h=content-type:from:subject:to:mime-version:date:message-id;
        bh=tIQzIu6Kq04eAu3MoX2ZT3ID+EbllazaX+vekax476I=;
        b=hmZ8J1aNI9fb5d+2gsUA7k/q8fN4VqlaU4Q0uz8/ZRMmS46RX0FTvgrsbg5Tqr/yLojQVZQWgrCQw
         eqlznRsNnaxf+tKlS8Mce4FO+KmmMTzysg+VSWJiYxE5Rcn/xBADzlkRfhh+kLc0VBhMjpEd/16Fpl
         80gJMA1pDRG5tukDmm4JO5EOhu4SYH7kjORJ67dX8SeiC2cAE8CqzSBZjycURauNxbCy0qhSeUDhNK
         gEr0xSbHSxpw/2NyDkEwKSGYPQvNg2v5xdIZM9T504/zapORg/ibzbriGE70aFCWcbnzpFOtlrBeqO
         YFjN1l11Dx1HuNbv1geeIz+YSPlqJ2w==
X-KPN-MID: 33|Oi0uzOVax6vMZpG70bVyKa7H7XfGUTRUMQIE4GEqKoA3fc82m+YfAm08/RepjJp
 Q87+Hco1peyueqQ1nHQPc3RoRP4sgLliAY2KUoQQtlQ8=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|WJRXUvRKxL0pkGvl1Zrnpy1eMP0J+Lq87BBd4mz060Zw6uksPFH3nDBnf3GPp2h
 yClo+5DXK5g0QKmfZLEDIPw==
X-Originating-IP: 77.169.97.182
Received: from [192.168.0.11] (77-169-97-182.fixed.kpn.net [77.169.97.182])
        by smtp.xs4all.nl (Halon) with ESMTPSA
        id 51abfe33-8eb8-11ed-9e25-00505699b758;
        Sat, 07 Jan 2023 19:23:01 +0100 (CET)
Message-ID: <8434a0c6-839c-36cc-2539-a00d1e32bd8d@xs4all.nl>
Date:   Sat, 7 Jan 2023 19:23:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To:     martin.blumenstingl@googlemail.com
Cc:     kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pkshih@realtek.com, s.hauer@pengutronix.de, tony0620emma@gmail.com
References: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
Subject: Re: [PATCH 0/4] rtw88: Four fixes found while working on SDIO support
Content-Language: en-US
From:   gert erkelens <g.erkelens5@xs4all.nl>
In-Reply-To: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


In the course of 3 weeks my Shuttle DS10U bare bone running Ubuntu 22.04 server locked up 3 times. 
I'm using the Realtek RTL8822CE PCIe module in access point mode.
Below a dump of the first lock up. There is no log from the other two lockups, possibly because of 
'options rtw88_pci disable_aspm=1' in rtw88_pci.conf

I hope this is of any use to you.

Best regards,
Gert Erkelens


Dec 29 22:24:29 shuttle kernel: [98328.813880] BUG: scheduling while atomic: 
kworker/u4:0/7592/0x00000700
Dec 29 22:24:29 shuttle kernel: [98328.813889] Modules linked in: tls ccm xt_nat xt_state 
xt_MASQUERADE nft_reject_ipv4 nft_reject nft_ct nft_masq nft_chain_nat nf_nat_h323 nf_conntrack_h323 
nf_nat_pptp nf_conntrack_pptp nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc 
nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp iptable_nat nf_nat ip6t_REJECT nf_reject_ipv6 xt_hl 
ip6_tables ip6t_rt ipt_REJECT nf_reject_ipv4 xt_LOG nf_log_syslog nft_limit binfmt_misc xt_limit 
xt_addrtype xt_tcpudp xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nft_compat nft_counter 
nf_tables nfnetlink nls_iso8859_1 snd_sof_pci_intel_cnl snd_sof_intel_hda_common soundwire_intel 
rtw88_8822ce soundwire_generic_allocation rtw88_8822c soundwire_cadence snd_sof_intel_hda rtw88_pci 
snd_sof_pci intel_tcc_cooling snd_sof_xtensa_dsp x86_pkg_temp_thermal intel_powerclamp rtw88_core 
coretemp snd_sof snd_soc_hdac_hda snd_hda_ext_core mac80211 snd_soc_acpi_intel_match kvm_intel 
snd_soc_acpi mei_hdcp intel_rapl_msr soundwire_bus kvm
Dec 29 22:24:29 shuttle kernel: [98328.813949]  snd_hda_codec_hdmi snd_hda_codec_realtek 
snd_hda_codec_generic ledtrig_audio snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine 
snd_hda_intel snd_intel_dspcfg btusb rapl intel_cstate snd_intel_sdw_acpi btrtl cfg80211 
snd_hda_codec btbcm snd_hda_core btintel snd_hwdep snd_pcm wmi_bmof 
processor_thermal_device_pci_legacy snd_timer processor_thermal_device bluetooth libarc4 
processor_thermal_rfim snd ee1004 processor_thermal_mbox ecdh_generic soundcore 
processor_thermal_rapl mei_me ecc intel_rapl_common mei int340x_thermal_zone intel_pch_thermal 
intel_soc_dts_iosf mac_hid acpi_pad acpi_tad ramoops pstore_blk reed_solomon pstore_zone efi_pstore 
dm_multipath scsi_dh_rdac scsi_dh_emc sch_fq_codel scsi_dh_alua msr ip_tables x_tables autofs4 btrfs 
blake2b_generic zstd_compress raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor 
async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear i915 ttm drm_kms_helper syscopyarea 
sysfillrect sysimgblt fb_sys_fops
Dec 29 22:24:29 shuttle kernel: [98328.814014]  crct10dif_pclmul cec crc32_pclmul 
ghash_clmulni_intel igb rc_core aesni_intel i2c_i801 drm crypto_simd cryptd dca i2c_smbus 
i2c_algo_bit e1000e xhci_pci xhci_pci_renesas ahci libahci wmi video pinctrl_cannonlake
Dec 29 22:24:29 shuttle kernel: [98328.814032] CPU: 0 PID: 7592 Comm: kworker/u4:0 Not tainted 
5.15.0-56-generic #62-Ubuntu
Dec 29 22:24:29 shuttle kernel: [98328.814037] Hardware name: Shuttle Inc. DS10U/DS10U, BIOS 1.07 
11/18/2022
Dec 29 22:24:29 shuttle kernel: [98328.814038] Workqueue: phy0 rtw_watch_dog_work [rtw88_core]
Dec 29 22:24:29 shuttle kernel: [98328.814054] Call Trace:
Dec 29 22:24:29 shuttle kernel: [98328.814056]  <IRQ>
Dec 29 22:24:29 shuttle kernel: [98328.814059]  show_stack+0x52/0x5c
Dec 29 22:24:29 shuttle kernel: [98328.814064] dump_stack_lvl+0x4a/0x63
Dec 29 22:24:29 shuttle kernel: [98328.814070]  dump_stack+0x10/0x16
Dec 29 22:24:29 shuttle kernel: [98328.814074] __schedule_bug.cold+0x4e/0x60
Dec 29 22:24:29 shuttle kernel: [98328.814077] __schedule+0x449/0x590
Dec 29 22:24:29 shuttle kernel: [98328.814081]  schedule+0x69/0x110
Dec 29 22:24:29 shuttle kernel: [98328.814084] schedule_preempt_disabled+0xe/0x20
Dec 29 22:24:29 shuttle kernel: [98328.814088] __mutex_lock.constprop.0+0x484/0x490
Dec 29 22:24:29 shuttle kernel: [98328.814091]  ? __qdisc_run+0x96/0xe0
Dec 29 22:24:29 shuttle kernel: [98328.814097] __mutex_lock_slowpath+0x13/0x20
Dec 29 22:24:29 shuttle kernel: [98328.814100]  mutex_lock+0x38/0x50
Dec 29 22:24:29 shuttle kernel: [98328.814104] rtw_ops_set_tim+0x20/0x40 [rtw88_core]
Dec 29 22:24:29 shuttle kernel: [98328.814117] __sta_info_recalc_tim+0x1a1/0x3d0 [mac80211]
Dec 29 22:24:29 shuttle kernel: [98328.814172] sta_info_recalc_tim+0x10/0x20 [mac80211]
Dec 29 22:24:29 shuttle kernel: [98328.814221] ieee80211_tx_h_unicast_ps_buf+0x225/0x310 [mac80211]
Dec 29 22:24:29 shuttle kernel: [98328.814283] invoke_tx_handlers_early+0xbf/0x360 [mac80211]
Dec 29 22:24:29 shuttle kernel: [98328.814341] ieee80211_tx+0x9c/0x160 [mac80211]
Dec 29 22:24:29 shuttle kernel: [98328.814398] ieee80211_xmit+0xc0/0x100 [mac80211]
Dec 29 22:24:29 shuttle kernel: [98328.814454] __ieee80211_subif_start_xmit+0x1f6/0x360 [mac80211]
Dec 29 22:24:29 shuttle kernel: [98328.814509]  ? consume_skb+0x43/0xb0
Dec 29 22:24:29 shuttle kernel: [98328.814515] ieee80211_subif_start_xmit+0x47/0x190 [mac80211]
Dec 29 22:24:29 shuttle kernel: [98328.814570]  ? dev_queue_xmit_nit+0x275/0x2b0
Dec 29 22:24:29 shuttle kernel: [98328.814574] xmit_one.constprop.0+0x99/0x160
Dec 29 22:24:29 shuttle kernel: [98328.814576] dev_hard_start_xmit+0x45/0x90
Dec 29 22:24:29 shuttle kernel: [98328.814580] __dev_queue_xmit+0x46d/0x510
Dec 29 22:24:29 shuttle kernel: [98328.814583]  ? neigh_add_timer+0x37/0x60
Dec 29 22:24:29 shuttle kernel: [98328.814588] dev_queue_xmit+0x10/0x20
Dec 29 22:24:29 shuttle kernel: [98328.814591] neigh_resolve_output+0x114/0x1b0
Dec 29 22:24:29 shuttle kernel: [98328.814594] ip_finish_output2+0x17a/0x460
Dec 29 22:24:29 shuttle kernel: [98328.814597] __ip_finish_output+0xb7/0x180
Dec 29 22:24:29 shuttle kernel: [98328.814599] ip_finish_output+0x2e/0xc0
Dec 29 22:24:29 shuttle kernel: [98328.814602]  ip_output+0x78/0x100
Dec 29 22:24:29 shuttle kernel: [98328.814604]  ? __ip_finish_output+0x180/0x180
Dec 29 22:24:29 shuttle kernel: [98328.814606] ip_forward_finish+0x8b/0xb0
Dec 29 22:24:29 shuttle kernel: [98328.814612] ip_forward+0x3fc/0x550
Dec 29 22:24:29 shuttle kernel: [98328.814616]  ? __build_flow_key.constprop.0+0x92/0xf0
Dec 29 22:24:29 shuttle kernel: [98328.814620]  ? ip_expire+0x1a0/0x1a0
Dec 29 22:24:29 shuttle kernel: [98328.814624] ip_sublist_rcv_finish+0x6f/0x80
Dec 29 22:24:29 shuttle kernel: [98328.814628] ip_sublist_rcv+0x17c/0x200
Dec 29 22:24:29 shuttle kernel: [98328.814633]  ? ip_sublist_rcv+0x200/0x200
Dec 29 22:24:29 shuttle kernel: [98328.814637] ip_list_rcv+0xf9/0x120
Dec 29 22:24:29 shuttle kernel: [98328.814641] __netif_receive_skb_list_core+0x218/0x240
Dec 29 22:24:29 shuttle kernel: [98328.814645] netif_receive_skb_list_internal+0x18e/0x2a0
Dec 29 22:24:29 shuttle kernel: [98328.814649]  ? e1000_clean_rx_irq+0x34d/0x3a0 [e1000e]
Dec 29 22:24:29 shuttle kernel: [98328.814669] napi_complete_done+0x7a/0x1c0
Dec 29 22:24:29 shuttle kernel: [98328.814672] e1000e_poll+0xcf/0x2d0 [e1000e]
Dec 29 22:24:29 shuttle kernel: [98328.814690] __napi_poll+0x30/0x180
Dec 29 22:24:29 shuttle kernel: [98328.814693] net_rx_action+0x126/0x280
Dec 29 22:24:29 shuttle kernel: [98328.814697] __do_softirq+0xd6/0x2e7
Dec 29 22:24:29 shuttle kernel: [98328.814701] irq_exit_rcu+0x94/0xc0
Dec 29 22:24:29 shuttle kernel: [98328.814706] common_interrupt+0x8e/0xa0
Dec 29 22:24:29 shuttle kernel: [98328.814710]  </IRQ>
Dec 29 22:24:29 shuttle kernel: [98328.814712]  <TASK>
Dec 29 22:24:29 shuttle kernel: [98328.814713] asm_common_interrupt+0x27/0x40
Dec 29 22:24:29 shuttle kernel: [98328.814715] RIP: 0010:rtw_pci_read32+0x14/0x20 [rtw88_pci]
Dec 29 22:24:29 shuttle kernel: [98328.814721] Code: b7 30 7a 00 00 48 89 e5 66 8b 06 5d c3 cc cc cc 
cc 0f 1f 44 00 00 0f 1f 44 00 00 55 89 f6 48 03 b7 30 7a 00 00 48 89 e5 8b 06 <5d> c3 cc cc cc cc 66 
0f 1f 44 00 00 0f 1f 44 00 00 55 89 f6 48 03
Dec 29 22:24:29 shuttle kernel: [98328.814724] RSP: 0018:ffffbff902427da0 EFLAGS: 00000282
Dec 29 22:24:29 shuttle kernel: [98328.814727] RAX: 00000000c0000000 RBX: 0000000000000002 RCX: 
000000000000000c
Dec 29 22:24:29 shuttle kernel: [98328.814729] RDX: 0000000012baa000 RSI: ffffbff900a11d2c RDI: 
ffff9b370b9b2020
Dec 29 22:24:29 shuttle kernel: [98328.814731] RBP: ffffbff902427da0 R08: 0000000000000000 R09: 
0000000000000000
Dec 29 22:24:29 shuttle kernel: [98328.814732] R10: 0000000000000005 R11: 0000000000000000 R12: 
ffff9b370b9b2020
Dec 29 22:24:29 shuttle kernel: [98328.814734] R13: 0000000000000000 R14: 0000000000000000 R15: 
0000000000000000
Dec 29 22:24:29 shuttle kernel: [98328.814737] rtw8822c_false_alarm_statistics+0x26d/0x350 [rtw88_8822c]
Dec 29 22:24:29 shuttle kernel: [98328.814744] rtw_phy_dynamic_mechanism+0x71/0x320 [rtw88_core]
Dec 29 22:24:29 shuttle kernel: [98328.814761] rtw_watch_dog_work+0x1cd/0x260 [rtw88_core]
Dec 29 22:24:29 shuttle kernel: [98328.814773] process_one_work+0x228/0x3d0
Dec 29 22:24:29 shuttle kernel: [98328.814776] worker_thread+0x53/0x420
Dec 29 22:24:29 shuttle kernel: [98328.814779]  ? process_one_work+0x3d0/0x3d0
Dec 29 22:24:29 shuttle kernel: [98328.814781]  kthread+0x127/0x150
Dec 29 22:24:29 shuttle kernel: [98328.814785]  ? set_kthread_struct+0x50/0x50
Dec 29 22:24:29 shuttle kernel: [98328.814789] ret_from_fork+0x1f/0x30
Dec 29 22:24:29 shuttle kernel: [98328.814796]  </TASK>
Dec 29 22:24:29 shuttle kernel: [98328.814811] NOHZ tick-stop error: Non-RCU local softirq work is 
pending, handler #88!!!
Dec 29 22:24:35 shuttle kernel: [98333.925935] Dead loop on virtual device wlp2s0, fix it urgently!
Dec 29 22:24:36 shuttle kernel: [98334.949866] Dead loop on virtual device wlp2s0, fix it urgently!
Dec 29 22:24:37 shuttle kernel: [98335.974049] Dead loop on virtual device wlp2s0, fix it urgently!

