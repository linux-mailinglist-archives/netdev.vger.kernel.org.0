Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85135AC3F1
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 12:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbiIDKiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 06:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiIDKiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 06:38:05 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C5C43E67;
        Sun,  4 Sep 2022 03:38:03 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id b16so7804442wru.7;
        Sun, 04 Sep 2022 03:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=en2bMa7Tvn6mXgMJx32xko0FtvjfntDVh3+tDwQ3FQA=;
        b=MKF5QhVELRPgQMeyyyeXkR7MzydxLa/CGLVgArAH6RzC3qDnLWApp7vmu8PByNW3Dv
         6/m+n/ICHtX1Bbr+IeTmo4SrIUrABUE/2i+dp3JL9DSwHEB3uP+cSsvt3abXa5w6bHVB
         78pz9hr8jzIxejj+cgaQuwP7y67Y+/u4mQMmTiQ/r93PbZRx2sOcHPt6ZFVmrtfhbBFU
         VKOI7WLGg47T1v4i1rYcEyxnvXL92Ig6jAAoQzkc+xLyWI4W5NirZdKDYM8kGxn2N1xD
         Fbd55T2E90d6Mz33FGO7nGdGP7n5twRwT+8i1HNu/rzN4XT2h3HNfx0NNy5B5ajWemwA
         uuCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=en2bMa7Tvn6mXgMJx32xko0FtvjfntDVh3+tDwQ3FQA=;
        b=qX7YwDRxYJbvHuWJpT1aXgYHgMnC2Q2EOAQmmMwK6Gv/TItsLid989rUIYgl+AyOYo
         LmZWFv0HzbnckHNyC2ANtCa+3HyJkNOvZdB3CACRNUJgQjcsXf3aKbm6bXzucm8n2EVA
         vosy/TaXfalI2QBhOhQ3H3PmzQauLOaPsMQXRmOft8YxjdxWEup1Rsjh5p5IdUm6N+kE
         V48esjjK41IhmMSnzDd7ICzQuJRqjvzzaYA6meDYraaTJ8qEAUzW3m4kB0yyygmRgoti
         dcwW85KRyl4pXK0KDUndmn03qkMl2O91xkP/cdY+lJJK/cdPNIDEUC++bytC35k7d5dx
         h7+w==
X-Gm-Message-State: ACgBeo2SEIcpDnHDwW8ihMK2XWtH8nluyimro85bzZW5mkI1zng5UnY8
        VlaDz40MxsGgWH9V0rvADP7C4Tm+KANtPA==
X-Google-Smtp-Source: AA6agR6K7d11l4eXepWb7ATb6H3Ricw9KkeZoykHdtYtCS558OLoce7i7j3vUyuOcmz4zjX29TppCQ==
X-Received: by 2002:a05:6000:1a8b:b0:222:cac3:769a with SMTP id f11-20020a0560001a8b00b00222cac3769amr21181117wry.120.1662287881664;
        Sun, 04 Sep 2022 03:38:01 -0700 (PDT)
Received: from [44.168.19.21] (lfbn-idf1-1-596-24.w86-242.abo.wanadoo.fr. [86.242.59.24])
        by smtp.gmail.com with ESMTPSA id m8-20020a05600c3b0800b003a35ec4bf4fsm7941980wms.20.2022.09.04.03.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Sep 2022 03:38:00 -0700 (PDT)
Message-ID: <9090eda2-5ab2-9d7e-2d41-f21db2a90573@gmail.com>
Date:   Sun, 4 Sep 2022 12:37:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: [AX25] [ROSE] refcount_t: decrement hit 0; leaking memory
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
References: <20220728051821.3160118-1-eric.dumazet@gmail.com>
 <c1b350f033f0e07f45351689499bbed98b987f3e.camel@redhat.com>
 <CANn89iLQibnxDzQmuNB2qJ98wvC_R99OD3bPJVEsREmtUPxiXQ@mail.gmail.com>
 <0ca8e102e553c86bb0e3f2e6d76c883ff8d411b1.camel@redhat.com>
 <CANn89i+qDDtnUvF5F5zz5pHNzC=pxvJ8-uyta5aLtgSGwh5pcg@mail.gmail.com>
 <b7ea9aaf-374a-c4dd-2fef-ace17a8ccae2@gmail.com>
 <CANn89iJRppvogY5FFp5cACd4yZCp000EqjU5_-KqStH55METCg@mail.gmail.com>
From:   Bernard Pidoux <bernard.f6bvp@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, linux-hams@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>
In-Reply-To: <CANn89iJRppvogY5FFp5cACd4yZCp000EqjU5_-KqStH55METCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount warning when a rose connection is performed from remote node:

[26215.100860] NET: Registered PF_AX25 protocol family

[26215.108188] mkiss: AX.25 Multikiss, Hans Albas PE1AYX

[26215.108896] mkiss: ax0: crc mode is auto.

[26215.109078] IPv6: ADDRCONF(NETDEV_CHANGE): ax0: link becomes ready

[26219.157349] NET: Registered PF_ROSE protocol family

[26226.215278] mkiss: ax0: Trying crc-smack

[26226.215429] mkiss: ax0: Trying crc-flexnet

[26442.283263] ------------[ cut here ]------------

[26442.283282] refcount_t: decrement hit 0; leaking memory.

[26442.283309] WARNING: CPU: 3 PID: 5541 at lib/refcount.c:31 
refcount_warn_saturate+0x4c/0x150

[26442.283333] Modules linked in: rose mkiss ax25 rfcomm 
snd_hda_codec_hdmi cmac algif_hash algif_skcipher af_alg bnep i915 
nls_iso8859_1 x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel 
snd_hda_codec_realtek snd_hda_codec_generic rtw88_8821ce ledtrig_audio 
kvm i2c_algo_bit rtw88_8821c drm_buddy snd_hda_intel rtw88_pci btusb 
drm_display_helper snd_intel_dspcfg btrtl rtw88_core snd_hda_codec 
crct10dif_pclmul snd_hwdep crc32_pclmul snd_hda_core ghash_clmulni_intel 
btbcm aesni_intel drm_kms_helper btintel snd_pcm mei_hdcp btmtk 
crypto_simd intel_rapl_msr mac80211 syscopyarea snd_seq cryptd 
sysfillrect bluetooth sysimgblt fb_sys_fops cec 
processor_thermal_device_pci_legacy rapl snd_timer intel_soc_dts_iosf 
libarc4 rc_core at24 input_leds joydev processor_thermal_device 
intel_cstate cfg80211 snd_seq_device processor_thermal_rfim ecdh_generic 
ttm snd processor_thermal_mbox processor_thermal_rapl mei_me 
intel_pch_thermal ecc mei intel_rapl_common soundcore

[26442.283525]  int340x_thermal_zone acpi_pad video mac_hid ipmi_devintf 
ipmi_msghandler drm msr parport_pc ppdev lp ramoops parport pstore_blk 
reed_solomon pstore_zone efi_pstore ip_tables x_tables autofs4 btrfs 
blake2b_generic libcrc32c xor raid6_pq zstd_compress dm_mirror 
dm_region_hash dm_log hid_generic usbhid hid i2c_i801 ahci r8169 
i2c_smbus libahci lpc_ich xhci_pci realtek xhci_pci_renesas

[26442.283644] CPU: 3 PID: 5541 Comm: kworker/u8:2 Not tainted 
6.0.0-rc3-DEBUG+ #5

[26442.283655] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./CK3, BIOS 5.011 09/16/2020

[26442.283663] Workqueue: events_unbound flush_to_ldisc

[26442.283686] RIP: 0010:refcount_warn_saturate+0x4c/0x150

[26442.283711] Code: 00 00 0f b6 1d 6c 10 52 01 80 fb 01 0f 87 3a 04 6c 
00 83 e3 01 75 34 48 c7 c7 70 bc 21 bb c6 05 50 10 52 01 01 e8 59 0c 68 
00 <0f> 0b eb 1d 85 f6 74 4f 0f b6 1d 3f 10 52 01 80 fb 01 0f 87 f6 03

[26442.283723] RSP: 0018:ffffa20940174ad8 EFLAGS: 00010286

[26442.283734] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
0000000000000000

[26442.283742] RDX: 0000000000000504 RSI: ffffffffbb1cdaf1 RDI: 
00000000ffffffff

[26442.283750] RBP: ffffa20940174ae0 R08: 0000000000000003 R09: 
3b30207469682074

[26442.283758] R10: 203a745f746e756f R11: 746e756f63666572 R12: 
ffff92316c140490

[26442.283766] R13: 0000000000000000 R14: 0000000000000001 R15: 
ffff92316b561800

[26442.283774] FS:  0000000000000000(0000) GS:ffff92328f380000(0000) 
knlGS:0000000000000000

[26442.283783] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033

[26442.283791] CR2: 00005634bae01a08 CR3: 0000000166410006 CR4: 
00000000001706e0

[26442.283801] Call Trace:

[26442.283807]  <IRQ>

[26442.283816]  ref_tracker_free+0x181/0x1c0

[26442.283836]  rose_route_frame+0x298/0x740 [rose]

[26442.283856]  ? pollwake+0x72/0x90

[26442.283869]  ? wake_up_q+0x90/0x90

[26442.283884]  ? __wake_up_common+0x7d/0x140

[26442.283896]  ? rose_link_device_down+0x50/0x50 [rose]

[26442.283916]  ax25_rx_iframe.part.0+0x8a/0x340 [ax25]

[26442.283937]  ax25_rx_iframe+0x13/0x20 [ax25]

[26442.283957]  ax25_std_frame_in+0x7ae/0x810 [ax25]

[26442.283979]  ax25_rcv.constprop.0+0x5ee/0x880 [ax25]

[26442.284002]  ? __netif_receive_skb_core.constprop.0+0x725/0x10b0

[26442.284021]  ax25_kiss_rcv+0x6c/0x90 [ax25]

[26442.284041]  __netif_receive_skb_one_core+0x91/0xa0

[26442.284054]  __netif_receive_skb+0x15/0x60

[26442.284066]  process_backlog+0x96/0x140

[26442.284079]  __napi_poll+0x33/0x190

[26442.284091]  net_rx_action+0x19f/0x300

[26442.284105]  __do_softirq+0x103/0x366

[26442.284123]  do_softirq.part.0+0xa4/0xd0

[26442.284138]  </IRQ>

[26442.284145]  <TASK>

[26442.284152]  __local_bh_enable_ip+0x87/0x90

[26442.284166]  _raw_spin_unlock_bh+0x1d/0x30

[26442.284178]  mkiss_receive_buf+0x330/0x3d0 [mkiss]

[26442.284195]  tty_ldisc_receive_buf+0x4b/0x60

[26442.284209]  tty_port_default_receive_buf+0x42/0x70

[26442.284225]  flush_to_ldisc+0xb8/0x1b0

[26442.284240]  process_one_work+0x21f/0x3f0

[26442.284257]  worker_thread+0x50/0x3e0

[26442.284271]  ? process_one_work+0x3f0/0x3f0

[26442.284326]  kthread+0xfd/0x130

[26442.284345]  ? kthread_complete_and_exit+0x20/0x20

[26442.284365]  ret_from_fork+0x22/0x30

[26442.284393]  </TASK>

[26442.284404] ---[ end trace 0000000000000000 ]---

[26442.284494] ------------[ cut here ]------------

[26442.284508] refcount_t: saturated; leaking memory.

[26442.284537] WARNING: CPU: 3 PID: 34 at lib/refcount.c:22 
refcount_warn_saturate+0x144/0x150

[26442.284564] Modules linked in: rose mkiss ax25 rfcomm 
snd_hda_codec_hdmi cmac algif_hash algif_skcipher af_alg bnep i915 
nls_iso8859_1 x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel 
snd_hda_codec_realtek snd_hda_codec_generic rtw88_8821ce ledtrig_audio 
kvm i2c_algo_bit rtw88_8821c drm_buddy snd_hda_intel rtw88_pci btusb 
drm_display_helper snd_intel_dspcfg btrtl rtw88_core snd_hda_codec 
crct10dif_pclmul snd_hwdep crc32_pclmul snd_hda_core ghash_clmulni_intel 
btbcm aesni_intel drm_kms_helper btintel snd_pcm mei_hdcp btmtk 
crypto_simd intel_rapl_msr mac80211 syscopyarea snd_seq cryptd 
sysfillrect bluetooth sysimgblt fb_sys_fops cec 
processor_thermal_device_pci_legacy rapl snd_timer intel_soc_dts_iosf 
libarc4 rc_core at24 input_leds joydev processor_thermal_device 
intel_cstate cfg80211 snd_seq_device processor_thermal_rfim ecdh_generic 
ttm snd processor_thermal_mbox processor_thermal_rapl mei_me 
intel_pch_thermal ecc mei intel_rapl_common soundcore

[26442.284833]  int340x_thermal_zone acpi_pad video mac_hid ipmi_devintf 
ipmi_msghandler drm msr parport_pc ppdev lp ramoops parport pstore_blk 
reed_solomon pstore_zone efi_pstore ip_tables x_tables autofs4 btrfs 
blake2b_generic libcrc32c xor raid6_pq zstd_compress dm_mirror 
dm_region_hash dm_log hid_generic usbhid hid i2c_i801 ahci r8169 
i2c_smbus libahci lpc_ich xhci_pci realtek xhci_pci_renesas

[26442.284958] CPU: 3 PID: 34 Comm: ksoftirqd/3 Tainted: G        W 
      6.0.0-rc3-DEBUG+ #5

[26442.284976] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./CK3, BIOS 5.011 09/16/2020

[26442.284987] RIP: 0010:refcount_warn_saturate+0x144/0x150

[26442.285008] Code: a0 bc 21 bb c6 05 71 0f 52 01 01 e8 7b 0b 68 00 0f 
0b e9 3c ff ff ff 48 c7 c7 f0 bb 21 bb c6 05 5b 0f 52 01 01 e8 61 0b 68 
00 <0f> 0b e9 22 ff ff ff 0f 1f 44 00 00 8b 07 3d 00 00 00 c0 74 12 83

[26442.285024] RSP: 0018:ffffa2094015f990 EFLAGS: 00010286

[26442.285042] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
0000000000000000

[26442.285056] RDX: 0000000000000503 RSI: ffffffffbb1cdaf1 RDI: 
00000000ffffffff

[26442.285070] RBP: ffffa2094015f998 R08: 0000000000000003 R09: 
3b64657461727574

[26442.285086] R10: 00000000756f6366 R11: 0000000063666572 R12: 
ffff92316c140490

[26442.285100] R13: 0000000000000a20 R14: 0000000000000000 R15: 
0000000000000000

[26442.285114] FS:  0000000000000000(0000) GS:ffff92328f380000(0000) 
knlGS:0000000000000000

[26442.285123] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033

[26442.285131] CR2: 00005634bae01a08 CR3: 0000000166410006 CR4: 
00000000001706e0

[26442.285140] Call Trace:

[26442.285146]  <TASK>

[26442.285155]  ref_tracker_alloc+0x170/0x220

[26442.285169]  ? __smp_call_single_queue+0x59/0x90

[26442.285184]  ? ttwu_queue_wakelist+0xff/0x1d0

[26442.285196]  ? _raw_spin_unlock_irqrestore+0x27/0x50

[26442.285210]  rose_dev_get+0x8a/0xa0 [rose]

[26442.285228]  rose_route_frame+0x267/0x740 [rose]

[26442.285245]  ? pollwake+0x72/0x90

[26442.285255]  ? wake_up_q+0x90/0x90

[26442.285268]  ? __wake_up_common+0x7d/0x140

[26442.285279]  ? rose_link_device_down+0x50/0x50 [rose]

[26442.285294]  ax25_rx_iframe.part.0+0x8a/0x340 [ax25]

[26442.285313]  ax25_rx_iframe+0x13/0x20 [ax25]

[26442.285330]  ax25_std_frame_in+0x7ae/0x810 [ax25]

[26442.285350]  ax25_rcv.constprop.0+0x5ee/0x880 [ax25]

[26442.285369]  ? __netif_receive_skb_core.constprop.0+0x725/0x10b0

[26442.285385]  ax25_kiss_rcv+0x6c/0x90 [ax25]

[26442.285402]  __netif_receive_skb_one_core+0x91/0xa0

[26442.285414]  __netif_receive_skb+0x15/0x60

[26442.285424]  process_backlog+0x96/0x140

[26442.285436]  __napi_poll+0x33/0x190

[26442.285447]  net_rx_action+0x19f/0x300

[26442.285460]  __do_softirq+0x103/0x366

[26442.285475]  run_ksoftirqd+0x39/0x50

[26442.285488]  smpboot_thread_fn+0x193/0x230

[26442.285500]  ? sort_range+0x30/0x30

[26442.285509]  kthread+0xfd/0x130

[26442.285521]  ? kthread_complete_and_exit+0x20/0x20

[26442.285534]  ret_from_fork+0x22/0x30

[26442.285551]  </TASK>

[26442.285557] ---[ end trace 0000000000000000 ]---

[26442.286648] ROSE: unknown 0F in state 3

[26442.287419] ROSE: unknown 17 in state 3

root@bernard-f6bvp:/home/bernard#



