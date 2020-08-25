Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477D825156B
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgHYJdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728059AbgHYJdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:33:02 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB03FC061574;
        Tue, 25 Aug 2020 02:33:01 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y3so11989797wrl.4;
        Tue, 25 Aug 2020 02:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=message-id:subject:from:reply-to:to:cc:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=oSsjw6qVEWDLo6wldhEU65TwWL8DdbBYtgDRXUpawMk=;
        b=lVo1avDg9ug3B+EjY1iboBR4MzjzaMVjzey0c7rWEIiCmarHu2b9pn29kluDmL/gck
         2FgtG4YQvUqA9hTf95hMHlT1m6zWR+1RtFAedCelcHew1JVp4as934/9E24PJLfP75Zm
         UgQRMWWmjsTeUSVL3+F1CAvS3G1og1r3XDPq2EHk90+Ak2EZrRjhBqri0YzcC8wsyDHf
         A40sr9I4KgZx7O/KeI+/6LWtLYV5kuYr31lTKbAs/Xt3/gSVNcqD+LcNrxnXsKfpnQdB
         cr7ML8Q0jaK0pMXUzqKBMiWIMNDysgMpAR2JKrOskTbUshiR+tsPVsrBY3vFeHkAm2ru
         GfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :user-agent:mime-version:content-transfer-encoding;
        bh=oSsjw6qVEWDLo6wldhEU65TwWL8DdbBYtgDRXUpawMk=;
        b=n8J//HYU29exnqfdJ5uuhLnSD+YUHFulB0i2Mp/n7/5lOPsxBuyWhPPggwlscVhGSh
         l+X/J7hVK47jB4iE1PfoAzuQA2DjbRI68UhCiWHCK1AbBEGqXnGhczZ4Xz73brD84tDx
         3odGmb+lkGLhPm1FfaptfkKyLV1hMx8fW7hiYXMA3/WEyXqCzEb7ItFS05kc2zUQ3pS3
         W7pP6sulpwzni5DPR4d5GLT72kjo0YYLnjkRj1qFDyRsyadP5sEHI5sAZ8C4qqhUrXQf
         LHEcx+XiIvxqi3K1IcbJMlNhjPykIANzCsrP9pRcauP3yI8cpKEnWwTsgn3H1t9JvKme
         FDLA==
X-Gm-Message-State: AOAM531Fu6f9/55KKFdN6fNXfeykeXKeHsfSsdUkIlefVqXd49+8WCOF
        WaM9YABU+lJGTmUWNxsyzUI=
X-Google-Smtp-Source: ABdhPJwlsFsUn9Svs86bY3eTPNYO93Rzo9nyoi7Wgwo7aH/ESy8zjBP7Eihk3475vR0ZE9s9nuqp7w==
X-Received: by 2002:adf:f704:: with SMTP id r4mr9559217wrp.62.1598347978913;
        Tue, 25 Aug 2020 02:32:58 -0700 (PDT)
Received: from ?IPv6:2a02:8070:bb9:bc00::fc? ([2a02:8070:bb9:bc00::fc])
        by smtp.gmail.com with ESMTPSA id 126sm4982572wme.42.2020.08.25.02.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 02:32:58 -0700 (PDT)
Message-ID: <c3193408e36e762a53a13867c0ea8e253147edf2.camel@googlemail.com>
Subject: v4.19.132: r8169: possible bug during load
From:   Christoph Fritz <chf.fritz@googlemail.com>
Reply-To: chf.fritz@googlemail.com
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 25 Aug 2020 11:32:57 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Heiner,

please see the trace below.

With your upstream commit applied to v4.19 I'm not getting the issue
anymore:

[PATCH] r8169: handle all interrupt events in the hard irq handler
SHA1 ID: 260cfeb096f18ed8b54178d930ff5c61bf13b28b 

Would you recommend this commit for stable v4.19.y branch?

Thanks
  -- Christoph


[14654.062099] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[14654.062108] PGD 0 P4D 0 
[14654.062117] Oops: 0000 [#1] SMP NOPTI
[14654.062125] CPU: 1 PID: 0 Comm: swapper/1 Tainted: P           OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.062130] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.062143] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.062150] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.062155] RSP: 0018:ffff8b6b2ea43bf0 EFLAGS: 00010292
[14654.062160] RAX: 0000000000000000 RBX: ffff8b6889e0fb00 RCX: 0000000000000014
[14654.062164] RDX: 0000000000000000 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.062168] RBP: ffff8b6b2860cc80 R08: 0000000000000001 R09: ffff8b6889e0fb00
[14654.062170] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000014
[14654.062173] R13: 0000000000000020 R14: ffff8b68983a3322 R15: ffff8b6889e0fb00
[14654.062178] FS:  0000000000000000(0000) GS:ffff8b6b2ea40000(0000) knlGS:0000000000000000
[14654.062181] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[14654.062184] CR2: 0000000000000010 CR3: 000000032f242000 CR4: 00000000000406e0
[14654.062187] Call Trace:
[14654.062191]  <IRQ>
[14654.062201]  sk_filter_trim_cap+0xcd/0x1b0
[14654.062207]  tcp_v4_rcv+0xa41/0xc20
[14654.062222]  ? nft_do_chain_inet+0x8a/0x100 [nf_tables]
[14654.062229]  ip_local_deliver_finish+0x63/0x1e0
[14654.062234]  ip_local_deliver+0xe0/0xf0
[14654.062240]  ? ip_sublist_rcv_finish+0x80/0x80
[14654.062244]  ip_rcv+0xbc/0xd0
[14654.062249]  ? ip_rcv_finish_core.isra.18+0x360/0x360
[14654.062254]  __netif_receive_skb_one_core+0x5a/0x80
[14654.062259]  netif_receive_skb_internal+0x2f/0xa0
[14654.062264]  napi_gro_receive+0xba/0xe0
[14654.062273]  rtl8169_poll+0x24e/0x640 [r8169]
[14654.062280]  net_rx_action+0x149/0x3b0
[14654.062286]  __do_softirq+0xde/0x2d8
[14654.062293]  irq_exit+0xba/0xc0
[14654.062298]  do_IRQ+0x7f/0xe0
[14654.062303]  common_interrupt+0xf/0xf
[14654.062306]  </IRQ>
[14654.062312] RIP: 0010:finish_task_switch+0x7a/0x280
[14654.062316] Code: 8b 1c 25 40 5c 01 00 0f 1f 44 00 00 0f 1f 44 00 00 41 c7 46 38 00 00 00 00 4c 89 e7 c6 07 00 0f 1f 40 00 fb 66 0f 1f 44 00 00 <65> 48 8b 04 25 40 5c 01 00 e9 af 00 00 00 4d 85 ed 74 21 65 48 8b
[14654.062319] RSP: 0018:ffffa6b0c191be30 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdb
[14654.062323] RAX: 0000000080000000 RBX: ffff8b6b2caa0ec0 RCX: 0000000000000000
[14654.062326] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8b6b2ea620c0
[14654.062329] RBP: ffffa6b0c191be58 R08: 0000000000000002 R09: 0000000000021980
[14654.062332] R10: 0000353f734bd430 R11: 0000000000000000 R12: ffff8b6b2ea620c0
[14654.062334] R13: ffff8b6a2f336a40 R14: ffff8b6b1f4cac40 R15: 0000000000000001
[14654.062342]  __schedule+0x2aa/0x870
[14654.062348]  schedule_idle+0x1e/0x40
[14654.062354]  do_idle+0x165/0x270
[14654.062359]  cpu_startup_entry+0x6f/0x80
[14654.062364]  start_secondary+0x1a4/0x200
[14654.062369]  secondary_startup_64+0xa4/0xb0
[14654.062373] Modules linked in: can_isotp(OE) peak_usb can_dev can vhost_net vhost tap nft_chain_route_ipv4 xt_CHECKSUM ipt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_counter xt_tcpudp nft_compat tun bridge stp llc devlink rfkill snd_hda_codec_hdmi binfmt_misc nls_ascii nls_cp437 vfat fat nvidia_drm(POE) drm_kms_helper drm nvidia_modeset(POE) edac_mce_amd kvm_amd ccp rng_core kvm irqbypass efi_pstore snd_usb_audio snd_hda_intel snd_usbmidi_lib snd_hda_codec snd_rawmidi snd_seq_device pcspkr efivars joydev ftdi_sio pcc_cpufreq snd_hda_core fam15h_power k10temp usbserial snd_hwdep snd_pcm snd_timer snd sp5100_tco sg soundcore evdev acpi_cpufreq nvidia(POE) nft_masq_ipv4 nft_masq nft_chain_nat_ipv4 nf_nat_ipv4 nfsd nf_nat nf_conntrack nf_defrag_ipv6 ipmi_devintf nf_defrag_ipv4 libcrc32c ipmi_msghandler
[14654.062425]  auth_rpcgss nfs_acl nf_tables lockd grace sunrpc nfnetlink efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 crc32c_generic fscrypto ecb algif_skcipher af_alg dm_crypt dm_mod hid_generic usbhid hid sd_mod ohci_pci crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc xhci_pci xhci_hcd ohci_hcd ehci_pci ahci ehci_hcd libahci aesni_intel libata r8169 nvme aes_x86_64 realtek crypto_simd cryptd usbcore glue_helper scsi_mod libphy i2c_piix4 nvme_core usb_common button
[14654.062463] CR2: 0000000000000010
[14654.062472] ---[ end trace fc1db597273db48c ]---
[14654.081935] BUG: unable to handle kernel paging request at 0000000300000010
[14654.081939] PGD 0 P4D 0 
[14654.081945] Oops: 0000 [#2] SMP NOPTI
[14654.081950] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D    OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.081954] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.081961] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.081966] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.081969] RSP: 0018:ffff8b6b2ea03c40 EFLAGS: 00010286
[14654.081973] RAX: 0000000300000000 RBX: ffff8b68d1b2a4e8 RCX: 0000000000000000
[14654.081976] RDX: 0000000000000001 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.081980] RBP: ffff8b6b2860cc80 R08: ffff8b68d1b2a4e8 R09: ffff8b68d1b2a4e8
[14654.081982] R10: 0000000000000001 R11: ffff8b6b23c33b80 R12: 0000000000000000
[14654.081985] R13: 0000000000000000 R14: ffff8b6b2860cfc0 R15: ffff8b68d1b2a4e8
[14654.081989] FS:  0000000000000000(0000) GS:ffff8b6b2ea00000(0000) knlGS:0000000000000000
[14654.081992] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[14654.081995] CR2: 0000000300000010 CR3: 000000042a8d6000 CR4: 00000000000406f0
[14654.081998] Call Trace:
[14654.082001]  <IRQ>
[14654.082008]  ip_finish_output+0x228/0x270
[14654.082014]  ? nf_hook_slow+0x44/0xc0
[14654.082019]  ip_output+0x6c/0xe0
[14654.082028]  ? ip_append_data.part.49+0xd0/0xd0
[14654.082034]  __ip_queue_xmit+0x15d/0x410
[14654.082040]  __tcp_transmit_skb+0x527/0xb10
[14654.082047]  tcp_write_xmit+0x384/0x1000
[14654.082053]  tcp_send_loss_probe+0xec/0x200
[14654.082057]  tcp_write_timer_handler+0xce/0x210
[14654.082062]  tcp_write_timer+0x71/0x90
[14654.082066]  ? tcp_write_timer_handler+0x210/0x210
[14654.082072]  call_timer_fn+0x2b/0x130
[14654.082077]  run_timer_softirq+0x1c7/0x3e0
[14654.082082]  ? __hrtimer_run_queues+0x130/0x280
[14654.082086]  ? ktime_get+0x3a/0xa0
[14654.082092]  __do_softirq+0xde/0x2d8
[14654.082098]  irq_exit+0xba/0xc0
[14654.082103]  smp_apic_timer_interrupt+0x74/0x140
[14654.082108]  apic_timer_interrupt+0xf/0x20
[14654.082112]  </IRQ>
[14654.082118] RIP: 0010:cpuidle_enter_state+0xb9/0x320
[14654.082122] Code: e8 4c b9 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e a9 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
[14654.082125] RSP: 0018:ffffffffa3e03e70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[14654.082129] RAX: ffff8b6b2ea220c0 RBX: 00000d53eb58c94d RCX: 000000000000001f
[14654.082132] RDX: 00000d53eb58c94d RSI: 000000002011bc2e RDI: 0000000000000000
[14654.082135] RBP: ffff8b6b2138e000 R08: 0000000000000002 R09: 0000000000021980
[14654.082139] R10: 0000353f780efd09 R11: ffff8b6b2ea210a8 R12: 0000000000000002
[14654.082141] R13: ffffffffa3eba4d8 R14: 0000000000000002 R15: 00000000bc141a22
[14654.082153]  do_idle+0x228/0x270
[14654.082158]  cpu_startup_entry+0x6f/0x80
[14654.082164]  start_kernel+0x50c/0x52f
[14654.082170]  secondary_startup_64+0xa4/0xb0
[14654.082175] Modules linked in: can_isotp(OE) peak_usb can_dev can vhost_net vhost tap nft_chain_route_ipv4 xt_CHECKSUM ipt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_counter xt_tcpudp nft_compat tun bridge stp llc devlink rfkill snd_hda_codec_hdmi binfmt_misc nls_ascii nls_cp437 vfat fat nvidia_drm(POE) drm_kms_helper drm nvidia_modeset(POE) edac_mce_amd kvm_amd ccp rng_core kvm irqbypass efi_pstore snd_usb_audio snd_hda_intel snd_usbmidi_lib snd_hda_codec snd_rawmidi snd_seq_device pcspkr efivars joydev ftdi_sio pcc_cpufreq snd_hda_core fam15h_power k10temp usbserial snd_hwdep snd_pcm snd_timer snd sp5100_tco sg soundcore evdev acpi_cpufreq nvidia(POE) nft_masq_ipv4 nft_masq nft_chain_nat_ipv4 nf_nat_ipv4 nfsd nf_nat nf_conntrack nf_defrag_ipv6 ipmi_devintf nf_defrag_ipv4 libcrc32c ipmi_msghandler
[14654.082219]  auth_rpcgss nfs_acl nf_tables lockd grace sunrpc nfnetlink efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 crc32c_generic fscrypto ecb algif_skcipher af_alg dm_crypt dm_mod hid_generic usbhid hid sd_mod ohci_pci crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc xhci_pci xhci_hcd ohci_hcd ehci_pci ahci ehci_hcd libahci aesni_intel libata r8169 nvme aes_x86_64 realtek crypto_simd cryptd usbcore glue_helper scsi_mod libphy i2c_piix4 nvme_core usb_common button
[14654.082249] CR2: 0000000300000010
[14654.082255] ---[ end trace fc1db597273db48d ]---
[14654.082260] BUG: scheduling while atomic: swapper/0/0/0x00000100
[14654.082262] Modules linked in: can_isotp(OE) peak_usb can_dev can vhost_net vhost tap nft_chain_route_ipv4 xt_CHECKSUM ipt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_counter xt_tcpudp nft_compat tun bridge stp llc devlink rfkill snd_hda_codec_hdmi binfmt_misc nls_ascii nls_cp437 vfat fat nvidia_drm(POE) drm_kms_helper drm nvidia_modeset(POE) edac_mce_amd kvm_amd ccp rng_core kvm irqbypass efi_pstore snd_usb_audio snd_hda_intel snd_usbmidi_lib snd_hda_codec snd_rawmidi snd_seq_device pcspkr efivars joydev ftdi_sio pcc_cpufreq snd_hda_core fam15h_power k10temp usbserial snd_hwdep snd_pcm snd_timer snd sp5100_tco sg soundcore evdev acpi_cpufreq nvidia(POE) nft_masq_ipv4 nft_masq nft_chain_nat_ipv4 nf_nat_ipv4 nfsd nf_nat nf_conntrack nf_defrag_ipv6 ipmi_devintf nf_defrag_ipv4 libcrc32c ipmi_msghandler
[14654.082301]  auth_rpcgss nfs_acl nf_tables lockd grace sunrpc nfnetlink efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 crc32c_generic fscrypto ecb algif_skcipher af_alg dm_crypt dm_mod hid_generic usbhid hid sd_mod ohci_pci crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc xhci_pci xhci_hcd ohci_hcd ehci_pci ahci ehci_hcd libahci aesni_intel libata r8169 nvme aes_x86_64 realtek crypto_simd cryptd usbcore glue_helper scsi_mod libphy i2c_piix4 nvme_core usb_common button
[14654.082331] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D    OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.082334] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.082337] Call Trace:
[14654.082340]  <IRQ>
[14654.082346]  dump_stack+0x66/0x90
[14654.082351]  __schedule_bug.cold.84+0x5/0x1d
[14654.082357]  __schedule+0x69f/0x870
[14654.082367]  schedule+0x28/0x80
[14654.082370]  schedule_timeout+0x26d/0x390
[14654.082377]  ? sprintf+0x56/0x70
[14654.082383]  __down_interruptible+0xe6/0x120
[14654.082390]  down_interruptible+0x42/0x50
[14654.082397]  pstore_dump+0x9e/0x340
[14654.082402]  ? wake_up_klogd+0x30/0x40
[14654.082406]  ? vprintk_emit+0x215/0x270
[14654.082410]  ? wake_up_klogd+0x30/0x40
[14654.082415]  ? printk+0x58/0x6f
[14654.082423]  kmsg_dump+0xb9/0xe0
[14654.082430]  oops_end+0x64/0xd0
[14654.082435]  no_context+0x1be/0x380
[14654.082440]  __do_page_fault+0xb2/0x4f0
[14654.082445]  page_fault+0x1e/0x30
[14654.082451] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.082454] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.082458] RSP: 0018:ffff8b6b2ea03c40 EFLAGS: 00010286
[14654.082461] RAX: 0000000300000000 RBX: ffff8b68d1b2a4e8 RCX: 0000000000000000
[14654.082465] RDX: 0000000000000001 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.082468] RBP: ffff8b6b2860cc80 R08: ffff8b68d1b2a4e8 R09: ffff8b68d1b2a4e8
[14654.082471] R10: 0000000000000001 R11: ffff8b6b23c33b80 R12: 0000000000000000
[14654.082474] R13: 0000000000000000 R14: ffff8b6b2860cfc0 R15: ffff8b68d1b2a4e8
[14654.082482]  ip_finish_output+0x228/0x270
[14654.082490]  ? nf_hook_slow+0x44/0xc0
[14654.082495]  ip_output+0x6c/0xe0
[14654.082501]  ? ip_append_data.part.49+0xd0/0xd0
[14654.082506]  __ip_queue_xmit+0x15d/0x410
[14654.082512]  __tcp_transmit_skb+0x527/0xb10
[14654.082518]  tcp_write_xmit+0x384/0x1000
[14654.082525]  tcp_send_loss_probe+0xec/0x200
[14654.082529]  tcp_write_timer_handler+0xce/0x210
[14654.082533]  tcp_write_timer+0x71/0x90
[14654.082537]  ? tcp_write_timer_handler+0x210/0x210
[14654.082541]  call_timer_fn+0x2b/0x130
[14654.082550]  run_timer_softirq+0x1c7/0x3e0
[14654.082555]  ? __hrtimer_run_queues+0x130/0x280
[14654.082559]  ? ktime_get+0x3a/0xa0
[14654.082564]  __do_softirq+0xde/0x2d8
[14654.082570]  irq_exit+0xba/0xc0
[14654.082575]  smp_apic_timer_interrupt+0x74/0x140
[14654.082580]  apic_timer_interrupt+0xf/0x20
[14654.082583]  </IRQ>
[14654.082587] RIP: 0010:cpuidle_enter_state+0xb9/0x320
[14654.082591] Code: e8 4c b9 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e a9 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
[14654.082594] RSP: 0018:ffffffffa3e03e70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[14654.082598] RAX: ffff8b6b2ea220c0 RBX: 00000d53eb58c94d RCX: 000000000000001f
[14654.082601] RDX: 00000d53eb58c94d RSI: 000000002011bc2e RDI: 0000000000000000
[14654.082604] RBP: ffff8b6b2138e000 R08: 0000000000000002 R09: 0000000000021980
[14654.082607] R10: 0000353f780efd09 R11: ffff8b6b2ea210a8 R12: 0000000000000002
[14654.082610] R13: ffffffffa3eba4d8 R14: 0000000000000002 R15: 00000000bc141a22
[14654.082617]  do_idle+0x228/0x270
[14654.082623]  cpu_startup_entry+0x6f/0x80
[14654.082627]  start_kernel+0x50c/0x52f
[14654.082632]  secondary_startup_64+0xa4/0xb0
[14654.082637] bad: scheduling from the idle thread!
[14654.082641] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D W  OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.082644] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.082647] Call Trace:
[14654.082649]  <IRQ>
[14654.082654]  dump_stack+0x66/0x90
[14654.082659]  dequeue_task_idle+0x28/0x40
[14654.082664]  __schedule+0x317/0x870
[14654.082670]  schedule+0x28/0x80
[14654.082674]  schedule_timeout+0x26d/0x390
[14654.082679]  ? sprintf+0x56/0x70
[14654.082685]  __down_interruptible+0xe6/0x120
[14654.082691]  down_interruptible+0x42/0x50
[14654.082700]  pstore_dump+0x9e/0x340
[14654.082705]  ? wake_up_klogd+0x30/0x40
[14654.082709]  ? vprintk_emit+0x215/0x270
[14654.082713]  ? wake_up_klogd+0x30/0x40
[14654.082717]  ? printk+0x58/0x6f
[14654.082722]  kmsg_dump+0xb9/0xe0
[14654.082727]  oops_end+0x64/0xd0
[14654.082731]  no_context+0x1be/0x380
[14654.082735]  __do_page_fault+0xb2/0x4f0
[14654.082741]  page_fault+0x1e/0x30
[14654.082746] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.082749] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.082753] RSP: 0018:ffff8b6b2ea03c40 EFLAGS: 00010286
[14654.082756] RAX: 0000000300000000 RBX: ffff8b68d1b2a4e8 RCX: 0000000000000000
[14654.082759] RDX: 0000000000000001 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.082763] RBP: ffff8b6b2860cc80 R08: ffff8b68d1b2a4e8 R09: ffff8b68d1b2a4e8
[14654.082766] R10: 0000000000000001 R11: ffff8b6b23c33b80 R12: 0000000000000000
[14654.082769] R13: 0000000000000000 R14: ffff8b6b2860cfc0 R15: ffff8b68d1b2a4e8
[14654.082776]  ip_finish_output+0x228/0x270
[14654.082780]  ? nf_hook_slow+0x44/0xc0
[14654.082785]  ip_output+0x6c/0xe0
[14654.082791]  ? ip_append_data.part.49+0xd0/0xd0
[14654.082796]  __ip_queue_xmit+0x15d/0x410
[14654.082801]  __tcp_transmit_skb+0x527/0xb10
[14654.082808]  tcp_write_xmit+0x384/0x1000
[14654.082814]  tcp_send_loss_probe+0xec/0x200
[14654.082818]  tcp_write_timer_handler+0xce/0x210
[14654.082825]  tcp_write_timer+0x71/0x90
[14654.082829]  ? tcp_write_timer_handler+0x210/0x210
[14654.082834]  call_timer_fn+0x2b/0x130
[14654.082839]  run_timer_softirq+0x1c7/0x3e0
[14654.082844]  ? __hrtimer_run_queues+0x130/0x280
[14654.082848]  ? ktime_get+0x3a/0xa0
[14654.082853]  __do_softirq+0xde/0x2d8
[14654.082858]  irq_exit+0xba/0xc0
[14654.082863]  smp_apic_timer_interrupt+0x74/0x140
[14654.082868]  apic_timer_interrupt+0xf/0x20
[14654.082871]  </IRQ>
[14654.082875] RIP: 0010:cpuidle_enter_state+0xb9/0x320
[14654.082879] Code: e8 4c b9 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e a9 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
[14654.082883] RSP: 0018:ffffffffa3e03e70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[14654.082891] RAX: ffff8b6b2ea220c0 RBX: 00000d53eb58c94d RCX: 000000000000001f
[14654.082894] RDX: 00000d53eb58c94d RSI: 000000002011bc2e RDI: 0000000000000000
[14654.082897] RBP: ffff8b6b2138e000 R08: 0000000000000002 R09: 0000000000021980
[14654.082900] R10: 0000353f780efd09 R11: ffff8b6b2ea210a8 R12: 0000000000000002
[14654.082903] R13: ffffffffa3eba4d8 R14: 0000000000000002 R15: 00000000bc141a22
[14654.082910]  do_idle+0x228/0x270
[14654.082915]  cpu_startup_entry+0x6f/0x80
[14654.082920]  start_kernel+0x50c/0x52f
[14654.082925]  secondary_startup_64+0xa4/0xb0
[14654.082930] bad: scheduling from the idle thread!
[14654.082934] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D W  OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.082937] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.082939] Call Trace:
[14654.082942]  <IRQ>
[14654.082947]  dump_stack+0x66/0x90
[14654.082952]  dequeue_task_idle+0x28/0x40
[14654.082957]  __schedule+0x317/0x870
[14654.082963]  schedule+0x28/0x80
[14654.082967]  schedule_timeout+0x26d/0x390
[14654.082972]  ? sprintf+0x56/0x70
[14654.082978]  __down_interruptible+0xe6/0x120
[14654.082984]  down_interruptible+0x42/0x50
[14654.082989]  pstore_dump+0x9e/0x340
[14654.082994]  ? wake_up_klogd+0x30/0x40
[14654.082998]  ? vprintk_emit+0x215/0x270
[14654.083002]  ? wake_up_klogd+0x30/0x40
[14654.083007]  ? printk+0x58/0x6f
[14654.083011]  kmsg_dump+0xb9/0xe0
[14654.083016]  oops_end+0x64/0xd0
[14654.083021]  no_context+0x1be/0x380
[14654.083025]  __do_page_fault+0xb2/0x4f0
[14654.083031]  page_fault+0x1e/0x30
[14654.083036] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.083039] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.083042] RSP: 0018:ffff8b6b2ea03c40 EFLAGS: 00010286
[14654.083046] RAX: 0000000300000000 RBX: ffff8b68d1b2a4e8 RCX: 0000000000000000
[14654.083049] RDX: 0000000000000001 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.083052] RBP: ffff8b6b2860cc80 R08: ffff8b68d1b2a4e8 R09: ffff8b68d1b2a4e8
[14654.083055] R10: 0000000000000001 R11: ffff8b6b23c33b80 R12: 0000000000000000
[14654.083058] R13: 0000000000000000 R14: ffff8b6b2860cfc0 R15: ffff8b68d1b2a4e8
[14654.083066]  ip_finish_output+0x228/0x270
[14654.083070]  ? nf_hook_slow+0x44/0xc0
[14654.083075]  ip_output+0x6c/0xe0
[14654.083080]  ? ip_append_data.part.49+0xd0/0xd0
[14654.083085]  __ip_queue_xmit+0x15d/0x410
[14654.083091]  __tcp_transmit_skb+0x527/0xb10
[14654.083097]  tcp_write_xmit+0x384/0x1000
[14654.083103]  tcp_send_loss_probe+0xec/0x200
[14654.083107]  tcp_write_timer_handler+0xce/0x210
[14654.083111]  tcp_write_timer+0x71/0x90
[14654.083116]  ? tcp_write_timer_handler+0x210/0x210
[14654.083120]  call_timer_fn+0x2b/0x130
[14654.083125]  run_timer_softirq+0x1c7/0x3e0
[14654.083130]  ? __hrtimer_run_queues+0x130/0x280
[14654.083134]  ? ktime_get+0x3a/0xa0
[14654.083143]  __do_softirq+0xde/0x2d8
[14654.083150]  irq_exit+0xba/0xc0
[14654.083155]  smp_apic_timer_interrupt+0x74/0x140
[14654.083159]  apic_timer_interrupt+0xf/0x20
[14654.083162]  </IRQ>
[14654.083166] RIP: 0010:cpuidle_enter_state+0xb9/0x320
[14654.083170] Code: e8 4c b9 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e a9 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
[14654.083173] RSP: 0018:ffffffffa3e03e70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[14654.083177] RAX: ffff8b6b2ea220c0 RBX: 00000d53eb58c94d RCX: 000000000000001f
[14654.083180] RDX: 00000d53eb58c94d RSI: 000000002011bc2e RDI: 0000000000000000
[14654.083183] RBP: ffff8b6b2138e000 R08: 0000000000000002 R09: 0000000000021980
[14654.083186] R10: 0000353f780efd09 R11: ffff8b6b2ea210a8 R12: 0000000000000002
[14654.083189] R13: ffffffffa3eba4d8 R14: 0000000000000002 R15: 00000000bc141a22
[14654.083196]  do_idle+0x228/0x270
[14654.083201]  cpu_startup_entry+0x6f/0x80
[14654.083208]  start_kernel+0x50c/0x52f
[14654.083213]  secondary_startup_64+0xa4/0xb0
[14654.083218] bad: scheduling from the idle thread!
[14654.083223] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D W  OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.083226] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.083228] Call Trace:
[14654.083231]  <IRQ>
[14654.083236]  dump_stack+0x66/0x90
[14654.083241]  dequeue_task_idle+0x28/0x40
[14654.083246]  __schedule+0x317/0x870
[14654.083252]  schedule+0x28/0x80
[14654.083256]  schedule_timeout+0x26d/0x390
[14654.083261]  ? sprintf+0x56/0x70
[14654.083267]  __down_interruptible+0xe6/0x120
[14654.083272]  down_interruptible+0x42/0x50
[14654.083278]  pstore_dump+0x9e/0x340
[14654.083283]  ? wake_up_klogd+0x30/0x40
[14654.083287]  ? vprintk_emit+0x215/0x270
[14654.083291]  ? wake_up_klogd+0x30/0x40
[14654.083295]  ? printk+0x58/0x6f
[14654.083299]  kmsg_dump+0xb9/0xe0
[14654.083304]  oops_end+0x64/0xd0
[14654.083309]  no_context+0x1be/0x380
[14654.083313]  __do_page_fault+0xb2/0x4f0
[14654.083319]  page_fault+0x1e/0x30
[14654.083324] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.083327] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.083330] RSP: 0018:ffff8b6b2ea03c40 EFLAGS: 00010286
[14654.083334] RAX: 0000000300000000 RBX: ffff8b68d1b2a4e8 RCX: 0000000000000000
[14654.083337] RDX: 0000000000000001 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.083340] RBP: ffff8b6b2860cc80 R08: ffff8b68d1b2a4e8 R09: ffff8b68d1b2a4e8
[14654.083343] R10: 0000000000000001 R11: ffff8b6b23c33b80 R12: 0000000000000000
[14654.083346] R13: 0000000000000000 R14: ffff8b6b2860cfc0 R15: ffff8b68d1b2a4e8
[14654.083353]  ip_finish_output+0x228/0x270
[14654.083357]  ? nf_hook_slow+0x44/0xc0
[14654.083362]  ip_output+0x6c/0xe0
[14654.083368]  ? ip_append_data.part.49+0xd0/0xd0
[14654.083373]  __ip_queue_xmit+0x15d/0x410
[14654.083378]  __tcp_transmit_skb+0x527/0xb10
[14654.083384]  tcp_write_xmit+0x384/0x1000
[14654.083390]  tcp_send_loss_probe+0xec/0x200
[14654.083394]  tcp_write_timer_handler+0xce/0x210
[14654.083398]  tcp_write_timer+0x71/0x90
[14654.083402]  ? tcp_write_timer_handler+0x210/0x210
[14654.083407]  call_timer_fn+0x2b/0x130
[14654.083412]  run_timer_softirq+0x1c7/0x3e0
[14654.083417]  ? __hrtimer_run_queues+0x130/0x280
[14654.083421]  ? ktime_get+0x3a/0xa0
[14654.083426]  __do_softirq+0xde/0x2d8
[14654.083432]  irq_exit+0xba/0xc0
[14654.083437]  smp_apic_timer_interrupt+0x74/0x140
[14654.083446]  apic_timer_interrupt+0xf/0x20
[14654.083449]  </IRQ>
[14654.083453] RIP: 0010:cpuidle_enter_state+0xb9/0x320
[14654.083456] Code: e8 4c b9 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e a9 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
[14654.083459] RSP: 0018:ffffffffa3e03e70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[14654.083463] RAX: ffff8b6b2ea220c0 RBX: 00000d53eb58c94d RCX: 000000000000001f
[14654.083471] RDX: 00000d53eb58c94d RSI: 000000002011bc2e RDI: 0000000000000000
[14654.083474] RBP: ffff8b6b2138e000 R08: 0000000000000002 R09: 0000000000021980
[14654.083477] R10: 0000353f780efd09 R11: ffff8b6b2ea210a8 R12: 0000000000000002
[14654.083480] R13: ffffffffa3eba4d8 R14: 0000000000000002 R15: 00000000bc141a22
[14654.083487]  do_idle+0x228/0x270
[14654.083492]  cpu_startup_entry+0x6f/0x80
[14654.083496]  start_kernel+0x50c/0x52f
[14654.083501]  secondary_startup_64+0xa4/0xb0
[14654.083506] bad: scheduling from the idle thread!
[14654.083511] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D W  OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.083514] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.083516] Call Trace:
[14654.083519]  <IRQ>
[14654.083523]  dump_stack+0x66/0x90
[14654.083532]  dequeue_task_idle+0x28/0x40
[14654.083537]  __schedule+0x317/0x870
[14654.083543]  schedule+0x28/0x80
[14654.083546]  schedule_timeout+0x26d/0x390
[14654.083551]  ? sprintf+0x56/0x70
[14654.083557]  __down_interruptible+0xe6/0x120
[14654.083562]  down_interruptible+0x42/0x50
[14654.083568]  pstore_dump+0x9e/0x340
[14654.083573]  ? wake_up_klogd+0x30/0x40
[14654.083577]  ? vprintk_emit+0x215/0x270
[14654.083581]  ? wake_up_klogd+0x30/0x40
[14654.083585]  ? printk+0x58/0x6f
[14654.083589]  kmsg_dump+0xb9/0xe0
[14654.083598]  oops_end+0x64/0xd0
[14654.083602]  no_context+0x1be/0x380
[14654.083607]  __do_page_fault+0xb2/0x4f0
[14654.083612]  page_fault+0x1e/0x30
[14654.083617] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.083621] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.083624] RSP: 0018:ffff8b6b2ea03c40 EFLAGS: 00010286
[14654.083627] RAX: 0000000300000000 RBX: ffff8b68d1b2a4e8 RCX: 0000000000000000
[14654.083630] RDX: 0000000000000001 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.083633] RBP: ffff8b6b2860cc80 R08: ffff8b68d1b2a4e8 R09: ffff8b68d1b2a4e8
[14654.083636] R10: 0000000000000001 R11: ffff8b6b23c33b80 R12: 0000000000000000
[14654.083639] R13: 0000000000000000 R14: ffff8b6b2860cfc0 R15: ffff8b68d1b2a4e8
[14654.083647]  ip_finish_output+0x228/0x270
[14654.083651]  ? nf_hook_slow+0x44/0xc0
[14654.083656]  ip_output+0x6c/0xe0
[14654.083661]  ? ip_append_data.part.49+0xd0/0xd0
[14654.083666]  __ip_queue_xmit+0x15d/0x410
[14654.083672]  __tcp_transmit_skb+0x527/0xb10
[14654.083678]  tcp_write_xmit+0x384/0x1000
[14654.083684]  tcp_send_loss_probe+0xec/0x200
[14654.083688]  tcp_write_timer_handler+0xce/0x210
[14654.083692]  tcp_write_timer+0x71/0x90
[14654.083696]  ? tcp_write_timer_handler+0x210/0x210
[14654.083701]  call_timer_fn+0x2b/0x130
[14654.083705]  run_timer_softirq+0x1c7/0x3e0
[14654.083710]  ? __hrtimer_run_queues+0x130/0x280
[14654.083719]  ? ktime_get+0x3a/0xa0
[14654.083724]  __do_softirq+0xde/0x2d8
[14654.083729]  irq_exit+0xba/0xc0
[14654.083734]  smp_apic_timer_interrupt+0x74/0x140
[14654.083739]  apic_timer_interrupt+0xf/0x20
[14654.083742]  </IRQ>
[14654.083746] RIP: 0010:cpuidle_enter_state+0xb9/0x320
[14654.083749] Code: e8 4c b9 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e a9 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
[14654.083752] RSP: 0018:ffffffffa3e03e70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[14654.083756] RAX: ffff8b6b2ea220c0 RBX: 00000d53eb58c94d RCX: 000000000000001f
[14654.083759] RDX: 00000d53eb58c94d RSI: 000000002011bc2e RDI: 0000000000000000
[14654.083762] RBP: ffff8b6b2138e000 R08: 0000000000000002 R09: 0000000000021980
[14654.083765] R10: 0000353f780efd09 R11: ffff8b6b2ea210a8 R12: 0000000000000002
[14654.083768] R13: ffffffffa3eba4d8 R14: 0000000000000002 R15: 00000000bc141a22
[14654.083775]  do_idle+0x228/0x270
[14654.083785]  cpu_startup_entry+0x6f/0x80
[14654.083790]  start_kernel+0x50c/0x52f
[14654.083795]  secondary_startup_64+0xa4/0xb0
[14654.083799] bad: scheduling from the idle thread!
[14654.083804] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D W  OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.083807] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.083809] Call Trace:
[14654.083812]  <IRQ>
[14654.083816]  dump_stack+0x66/0x90
[14654.083821]  dequeue_task_idle+0x28/0x40
[14654.083826]  __schedule+0x317/0x870
[14654.083832]  schedule+0x28/0x80
[14654.083836]  schedule_timeout+0x26d/0x390
[14654.083844]  ? sprintf+0x56/0x70
[14654.083850]  __down_interruptible+0xe6/0x120
[14654.083855]  down_interruptible+0x42/0x50
[14654.083861]  pstore_dump+0x9e/0x340
[14654.083866]  ? wake_up_klogd+0x30/0x40
[14654.083870]  ? vprintk_emit+0x215/0x270
[14654.083874]  ? wake_up_klogd+0x30/0x40
[14654.083878]  ? printk+0x58/0x6f
[14654.083883]  kmsg_dump+0xb9/0xe0
[14654.083888]  oops_end+0x64/0xd0
[14654.083892]  no_context+0x1be/0x380
[14654.083896]  __do_page_fault+0xb2/0x4f0
[14654.083902]  page_fault+0x1e/0x30
[14654.083907] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.083910] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.083913] RSP: 0018:ffff8b6b2ea03c40 EFLAGS: 00010286
[14654.083917] RAX: 0000000300000000 RBX: ffff8b68d1b2a4e8 RCX: 0000000000000000
[14654.083920] RDX: 0000000000000001 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.083923] RBP: ffff8b6b2860cc80 R08: ffff8b68d1b2a4e8 R09: ffff8b68d1b2a4e8
[14654.083926] R10: 0000000000000001 R11: ffff8b6b23c33b80 R12: 0000000000000000
[14654.083928] R13: 0000000000000000 R14: ffff8b6b2860cfc0 R15: ffff8b68d1b2a4e8
[14654.083936]  ip_finish_output+0x228/0x270
[14654.083940]  ? nf_hook_slow+0x44/0xc0
[14654.083945]  ip_output+0x6c/0xe0
[14654.083950]  ? ip_append_data.part.49+0xd0/0xd0
[14654.083955]  __ip_queue_xmit+0x15d/0x410
[14654.083961]  __tcp_transmit_skb+0x527/0xb10
[14654.083967]  tcp_write_xmit+0x384/0x1000
[14654.083973]  tcp_send_loss_probe+0xec/0x200
[14654.083981]  tcp_write_timer_handler+0xce/0x210
[14654.083985]  tcp_write_timer+0x71/0x90
[14654.083989]  ? tcp_write_timer_handler+0x210/0x210
[14654.083993]  call_timer_fn+0x2b/0x130
[14654.083998]  run_timer_softirq+0x1c7/0x3e0
[14654.084004]  ? __hrtimer_run_queues+0x130/0x280
[14654.084007]  ? ktime_get+0x3a/0xa0
[14654.084012]  __do_softirq+0xde/0x2d8
[14654.084018]  irq_exit+0xba/0xc0
[14654.084023]  smp_apic_timer_interrupt+0x74/0x140
[14654.084028]  apic_timer_interrupt+0xf/0x20
[14654.084030]  </IRQ>
[14654.084034] RIP: 0010:cpuidle_enter_state+0xb9/0x320
[14654.084038] Code: e8 4c b9 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e a9 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
[14654.084045] RSP: 0018:ffffffffa3e03e70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[14654.084049] RAX: ffff8b6b2ea220c0 RBX: 00000d53eb58c94d RCX: 000000000000001f
[14654.084052] RDX: 00000d53eb58c94d RSI: 000000002011bc2e RDI: 0000000000000000
[14654.084055] RBP: ffff8b6b2138e000 R08: 0000000000000002 R09: 0000000000021980
[14654.084058] R10: 0000353f780efd09 R11: ffff8b6b2ea210a8 R12: 0000000000000002
[14654.084060] R13: ffffffffa3eba4d8 R14: 0000000000000002 R15: 00000000bc141a22
[14654.084067]  do_idle+0x228/0x270
[14654.084072]  cpu_startup_entry+0x6f/0x80
[14654.084077]  start_kernel+0x50c/0x52f
[14654.084082]  secondary_startup_64+0xa4/0xb0
[14654.084087] bad: scheduling from the idle thread!
[14654.084091] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D W  OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.084094] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.084096] Call Trace:
[14654.084099]  <IRQ>
[14654.084103]  dump_stack+0x66/0x90
[14654.084108]  dequeue_task_idle+0x28/0x40
[14654.084113]  __schedule+0x317/0x870
[14654.084119]  schedule+0x28/0x80
[14654.084123]  schedule_timeout+0x26d/0x390
[14654.084128]  ? sprintf+0x56/0x70
[14654.084134]  __down_interruptible+0xe6/0x120
[14654.084139]  down_interruptible+0x42/0x50
[14654.084145]  pstore_dump+0x9e/0x340
[14654.084150]  ? wake_up_klogd+0x30/0x40
[14654.084154]  ? vprintk_emit+0x215/0x270
[14654.084158]  ? wake_up_klogd+0x30/0x40
[14654.084162]  ? printk+0x58/0x6f
[14654.084166]  kmsg_dump+0xb9/0xe0
[14654.084171]  oops_end+0x64/0xd0
[14654.084176]  no_context+0x1be/0x380
[14654.084180]  __do_page_fault+0xb2/0x4f0
[14654.084189]  page_fault+0x1e/0x30
[14654.084194] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.084197] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.084200] RSP: 0018:ffff8b6b2ea03c40 EFLAGS: 00010286
[14654.084204] RAX: 0000000300000000 RBX: ffff8b68d1b2a4e8 RCX: 0000000000000000
[14654.084206] RDX: 0000000000000001 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.084209] RBP: ffff8b6b2860cc80 R08: ffff8b68d1b2a4e8 R09: ffff8b68d1b2a4e8
[14654.084212] R10: 0000000000000001 R11: ffff8b6b23c33b80 R12: 0000000000000000
[14654.084215] R13: 0000000000000000 R14: ffff8b6b2860cfc0 R15: ffff8b68d1b2a4e8
[14654.084223]  ip_finish_output+0x228/0x270
[14654.084226]  ? nf_hook_slow+0x44/0xc0
[14654.084231]  ip_output+0x6c/0xe0
[14654.084237]  ? ip_append_data.part.49+0xd0/0xd0
[14654.084242]  __ip_queue_xmit+0x15d/0x410
[14654.084250]  __tcp_transmit_skb+0x527/0xb10
[14654.084256]  tcp_write_xmit+0x384/0x1000
[14654.084262]  tcp_send_loss_probe+0xec/0x200
[14654.084266]  tcp_write_timer_handler+0xce/0x210
[14654.084270]  tcp_write_timer+0x71/0x90
[14654.084274]  ? tcp_write_timer_handler+0x210/0x210
[14654.084278]  call_timer_fn+0x2b/0x130
[14654.084283]  run_timer_softirq+0x1c7/0x3e0
[14654.084288]  ? __hrtimer_run_queues+0x130/0x280
[14654.084292]  ? ktime_get+0x3a/0xa0
[14654.084297]  __do_softirq+0xde/0x2d8
[14654.084302]  irq_exit+0xba/0xc0
[14654.084308]  smp_apic_timer_interrupt+0x74/0x140
[14654.084312]  apic_timer_interrupt+0xf/0x20
[14654.084315]  </IRQ>
[14654.084319] RIP: 0010:cpuidle_enter_state+0xb9/0x320
[14654.084323] Code: e8 4c b9 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e a9 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
[14654.084326] RSP: 0018:ffffffffa3e03e70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[14654.084330] RAX: ffff8b6b2ea220c0 RBX: 00000d53eb58c94d RCX: 000000000000001f
[14654.084333] RDX: 00000d53eb58c94d RSI: 000000002011bc2e RDI: 0000000000000000
[14654.084336] RBP: ffff8b6b2138e000 R08: 0000000000000002 R09: 0000000000021980
[14654.084339] R10: 0000353f780efd09 R11: ffff8b6b2ea210a8 R12: 0000000000000002
[14654.084342] R13: ffffffffa3eba4d8 R14: 0000000000000002 R15: 00000000bc141a22
[14654.084348]  do_idle+0x228/0x270
[14654.084354]  cpu_startup_entry+0x6f/0x80
[14654.084358]  start_kernel+0x50c/0x52f
[14654.084363]  secondary_startup_64+0xa4/0xb0
[14654.084368] bad: scheduling from the idle thread!
[14654.084377] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D W  OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.084380] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.084382] Call Trace:
[14654.084385]  <IRQ>
[14654.084389]  dump_stack+0x66/0x90
[14654.084394]  dequeue_task_idle+0x28/0x40
[14654.084399]  __schedule+0x317/0x870
[14654.084405]  schedule+0x28/0x80
[14654.084409]  schedule_timeout+0x26d/0x390
[14654.084414]  ? sprintf+0x56/0x70
[14654.084420]  __down_interruptible+0xe6/0x120
[14654.084425]  down_interruptible+0x42/0x50
[14654.084432]  pstore_dump+0x9e/0x340
[14654.084441]  ? wake_up_klogd+0x30/0x40
[14654.084445]  ? vprintk_emit+0x215/0x270
[14654.084449]  ? wake_up_klogd+0x30/0x40
[14654.084454]  ? printk+0x58/0x6f
[14654.084458]  kmsg_dump+0xb9/0xe0
[14654.084463]  oops_end+0x64/0xd0
[14654.084468]  no_context+0x1be/0x380
[14654.084472]  __do_page_fault+0xb2/0x4f0
[14654.084478]  page_fault+0x1e/0x30
[14654.084483] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.084487] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.084490] RSP: 0018:ffff8b6b2ea03c40 EFLAGS: 00010286
[14654.084493] RAX: 0000000300000000 RBX: ffff8b68d1b2a4e8 RCX: 0000000000000000
[14654.084496] RDX: 0000000000000001 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.084500] RBP: ffff8b6b2860cc80 R08: ffff8b68d1b2a4e8 R09: ffff8b68d1b2a4e8
[14654.084503] R10: 0000000000000001 R11: ffff8b6b23c33b80 R12: 0000000000000000
[14654.084506] R13: 0000000000000000 R14: ffff8b6b2860cfc0 R15: ffff8b68d1b2a4e8
[14654.084514]  ip_finish_output+0x228/0x270
[14654.084517]  ? nf_hook_slow+0x44/0xc0
[14654.084522]  ip_output+0x6c/0xe0
[14654.084528]  ? ip_append_data.part.49+0xd0/0xd0
[14654.084533]  __ip_queue_xmit+0x15d/0x410
[14654.084538]  __tcp_transmit_skb+0x527/0xb10
[14654.084544]  tcp_write_xmit+0x384/0x1000
[14654.084550]  tcp_send_loss_probe+0xec/0x200
[14654.084557]  tcp_write_timer_handler+0xce/0x210
[14654.084564]  tcp_write_timer+0x71/0x90
[14654.084568]  ? tcp_write_timer_handler+0x210/0x210
[14654.084573]  call_timer_fn+0x2b/0x130
[14654.084578]  run_timer_softirq+0x1c7/0x3e0
[14654.084583]  ? __hrtimer_run_queues+0x130/0x280
[14654.084587]  ? ktime_get+0x3a/0xa0
[14654.084592]  __do_softirq+0xde/0x2d8
[14654.084598]  irq_exit+0xba/0xc0
[14654.084603]  smp_apic_timer_interrupt+0x74/0x140
[14654.084607]  apic_timer_interrupt+0xf/0x20
[14654.084610]  </IRQ>
[14654.084614] RIP: 0010:cpuidle_enter_state+0xb9/0x320
[14654.084618] Code: e8 4c b9 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e a9 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
[14654.084621] RSP: 0018:ffffffffa3e03e70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[14654.084626] RAX: ffff8b6b2ea220c0 RBX: 00000d53eb58c94d RCX: 000000000000001f
[14654.084629] RDX: 00000d53eb58c94d RSI: 000000002011bc2e RDI: 0000000000000000
[14654.084631] RBP: ffff8b6b2138e000 R08: 0000000000000002 R09: 0000000000021980
[14654.084635] R10: 0000353f780efd09 R11: ffff8b6b2ea210a8 R12: 0000000000000002
[14654.084637] R13: ffffffffa3eba4d8 R14: 0000000000000002 R15: 00000000bc141a22
[14654.084644]  do_idle+0x228/0x270
[14654.084650]  cpu_startup_entry+0x6f/0x80
[14654.084654]  start_kernel+0x50c/0x52f
[14654.084659]  secondary_startup_64+0xa4/0xb0
[14654.084664] bad: scheduling from the idle thread!
[14654.084668] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D W  OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.084671] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.084673] Call Trace:
[14654.084676]  <IRQ>
[14654.084681]  dump_stack+0x66/0x90
[14654.084686]  dequeue_task_idle+0x28/0x40
[14654.084691]  __schedule+0x317/0x870
[14654.084697]  schedule+0x28/0x80
[14654.084700]  schedule_timeout+0x26d/0x390
[14654.084705]  ? sprintf+0x56/0x70
[14654.084712]  __down_interruptible+0xe6/0x120
[14654.084717]  down_interruptible+0x42/0x50
[14654.084723]  pstore_dump+0x9e/0x340
[14654.084727]  ? wake_up_klogd+0x30/0x40
[14654.084731]  ? vprintk_emit+0x215/0x270
[14654.084735]  ? wake_up_klogd+0x30/0x40
[14654.084740]  ? printk+0x58/0x6f
[14654.084747]  kmsg_dump+0xb9/0xe0
[14654.084753]  oops_end+0x64/0xd0
[14654.084757]  no_context+0x1be/0x380
[14654.084761]  __do_page_fault+0xb2/0x4f0
[14654.084767]  page_fault+0x1e/0x30
[14654.084772] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.084775] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.084778] RSP: 0018:ffff8b6b2ea03c40 EFLAGS: 00010286
[14654.084782] RAX: 0000000300000000 RBX: ffff8b68d1b2a4e8 RCX: 0000000000000000
[14654.084785] RDX: 0000000000000001 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.084788] RBP: ffff8b6b2860cc80 R08: ffff8b68d1b2a4e8 R09: ffff8b68d1b2a4e8
[14654.084791] R10: 0000000000000001 R11: ffff8b6b23c33b80 R12: 0000000000000000
[14654.084794] R13: 0000000000000000 R14: ffff8b6b2860cfc0 R15: ffff8b68d1b2a4e8
[14654.084802]  ip_finish_output+0x228/0x270
[14654.084805]  ? nf_hook_slow+0x44/0xc0
[14654.084810]  ip_output+0x6c/0xe0
[14654.084816]  ? ip_append_data.part.49+0xd0/0xd0
[14654.084821]  __ip_queue_xmit+0x15d/0x410
[14654.084827]  __tcp_transmit_skb+0x527/0xb10
[14654.084833]  tcp_write_xmit+0x384/0x1000
[14654.084839]  tcp_send_loss_probe+0xec/0x200
[14654.084843]  tcp_write_timer_handler+0xce/0x210
[14654.084847]  tcp_write_timer+0x71/0x90
[14654.084851]  ? tcp_write_timer_handler+0x210/0x210
[14654.084856]  call_timer_fn+0x2b/0x130
[14654.084860]  run_timer_softirq+0x1c7/0x3e0
[14654.084866]  ? __hrtimer_run_queues+0x130/0x280
[14654.084869]  ? ktime_get+0x3a/0xa0
[14654.084874]  __do_softirq+0xde/0x2d8
[14654.084880]  irq_exit+0xba/0xc0
[14654.084885]  smp_apic_timer_interrupt+0x74/0x140
[14654.084890]  apic_timer_interrupt+0xf/0x20
[14654.084893]  </IRQ>
[14654.084897] RIP: 0010:cpuidle_enter_state+0xb9/0x320
[14654.084900] Code: e8 4c b9 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e a9 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
[14654.084903] RSP: 0018:ffffffffa3e03e70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[14654.084908] RAX: ffff8b6b2ea220c0 RBX: 00000d53eb58c94d RCX: 000000000000001f
[14654.084911] RDX: 00000d53eb58c94d RSI: 000000002011bc2e RDI: 0000000000000000
[14654.084914] RBP: ffff8b6b2138e000 R08: 0000000000000002 R09: 0000000000021980
[14654.084917] R10: 0000353f780efd09 R11: ffff8b6b2ea210a8 R12: 0000000000000002
[14654.084920] R13: ffffffffa3eba4d8 R14: 0000000000000002 R15: 00000000bc141a22
[14654.084926]  do_idle+0x228/0x270
[14654.084934]  cpu_startup_entry+0x6f/0x80
[14654.084939]  start_kernel+0x50c/0x52f
[14654.084944]  secondary_startup_64+0xa4/0xb0
[14654.084949] bad: scheduling from the idle thread!
[14654.084954] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D W  OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.084956] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.084959] Call Trace:
[14654.084962]  <IRQ>
[14654.084966]  dump_stack+0x66/0x90
[14654.084971]  dequeue_task_idle+0x28/0x40
[14654.084976]  __schedule+0x317/0x870
[14654.084982]  schedule+0x28/0x80
[14654.084986]  schedule_timeout+0x26d/0x390
[14654.084991]  ? sprintf+0x56/0x70
[14654.085001]  __down_interruptible+0xe6/0x120
[14654.085006]  down_interruptible+0x42/0x50
[14654.085012]  pstore_dump+0x9e/0x340
[14654.085017]  ? wake_up_klogd+0x30/0x40
[14654.085021]  ? vprintk_emit+0x215/0x270
[14654.085025]  ? wake_up_klogd+0x30/0x40
[14654.085030]  ? printk+0x58/0x6f
[14654.085034]  kmsg_dump+0xb9/0xe0
[14654.085039]  oops_end+0x64/0xd0
[14654.085043]  no_context+0x1be/0x380
[14654.085048]  __do_page_fault+0xb2/0x4f0
[14654.085053]  page_fault+0x1e/0x30
[14654.085058] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.085062] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.085068] RSP: 0018:ffff8b6b2ea03c40 EFLAGS: 00010286
[14654.085102] RAX: 0000000300000000 RBX: ffff8b68d1b2a4e8 RCX: 0000000000000000
[14654.085137] RDX: 0000000000000001 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.085147] RBP: ffff8b6b2860cc80 R08: ffff8b68d1b2a4e8 R09: ffff8b68d1b2a4e8
[14654.085158] R10: 0000000000000001 R11: ffff8b6b23c33b80 R12: 0000000000000000
[14654.085169] R13: 0000000000000000 R14: ffff8b6b2860cfc0 R15: ffff8b68d1b2a4e8
[14654.085191]  ip_finish_output+0x228/0x270
[14654.085203]  ? nf_hook_slow+0x44/0xc0
[14654.085222]  ip_output+0x6c/0xe0
[14654.085233]  ? ip_append_data.part.49+0xd0/0xd0
[14654.085244]  __ip_queue_xmit+0x15d/0x410
[14654.085257]  __tcp_transmit_skb+0x527/0xb10
[14654.085276]  tcp_write_xmit+0x384/0x1000
[14654.085289]  tcp_send_loss_probe+0xec/0x200
[14654.085307]  tcp_write_timer_handler+0xce/0x210
[14654.085320]  tcp_write_timer+0x71/0x90
[14654.085331]  ? tcp_write_timer_handler+0x210/0x210
[14654.085341]  call_timer_fn+0x2b/0x130
[14654.085352]  run_timer_softirq+0x1c7/0x3e0
[14654.085363]  ? __hrtimer_run_queues+0x130/0x280
[14654.085374]  ? ktime_get+0x3a/0xa0
[14654.085385]  __do_softirq+0xde/0x2d8
[14654.085398]  irq_exit+0xba/0xc0
[14654.085417]  smp_apic_timer_interrupt+0x74/0x140
[14654.085428]  apic_timer_interrupt+0xf/0x20
[14654.085439]  </IRQ>
[14654.085450] RIP: 0010:cpuidle_enter_state+0xb9/0x320
[14654.085461] Code: e8 4c b9 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e a9 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
[14654.085469] RSP: 0018:ffffffffa3e03e70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[14654.085480] RAX: ffff8b6b2ea220c0 RBX: 00000d53eb58c94d RCX: 000000000000001f
[14654.085488] RDX: 00000d53eb58c94d RSI: 000000002011bc2e RDI: 0000000000000000
[14654.085497] RBP: ffff8b6b2138e000 R08: 0000000000000002 R09: 0000000000021980
[14654.085505] R10: 0000353f780efd09 R11: ffff8b6b2ea210a8 R12: 0000000000000002
[14654.085513] R13: ffffffffa3eba4d8 R14: 0000000000000002 R15: 00000000bc141a22
[14654.085524]  do_idle+0x228/0x270
[14654.085539]  cpu_startup_entry+0x6f/0x80
[14654.085547]  start_kernel+0x50c/0x52f
[14654.085557]  secondary_startup_64+0xa4/0xb0
[14654.085572] bad: scheduling from the idle thread!
[14654.085582] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D W  OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.085590] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.085598] Call Trace:
[14654.085606]  <IRQ>
[14654.085614]  dump_stack+0x66/0x90
[14654.085622]  dequeue_task_idle+0x28/0x40
[14654.085631]  __schedule+0x317/0x870
[14654.085641]  schedule+0x28/0x80
[14654.085650]  schedule_timeout+0x26d/0x390
[14654.085664]  ? sprintf+0x56/0x70
[14654.085675]  __down_interruptible+0xe6/0x120
[14654.085689]  down_interruptible+0x42/0x50
[14654.085698]  pstore_dump+0x9e/0x340
[14654.085706]  ? wake_up_klogd+0x30/0x40
[14654.085714]  ? vprintk_emit+0x215/0x270
[14654.085723]  ? wake_up_klogd+0x30/0x40
[14654.085731]  ? printk+0x58/0x6f
[14654.085740]  kmsg_dump+0xb9/0xe0
[14654.085748]  oops_end+0x64/0xd0
[14654.085756]  no_context+0x1be/0x380
[14654.085766]  __do_page_fault+0xb2/0x4f0
[14654.085774]  page_fault+0x1e/0x30
[14654.085782] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.085791] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.085800] RSP: 0018:ffff8b6b2ea03c40 EFLAGS: 00010286
[14654.085808] RAX: 0000000300000000 RBX: ffff8b68d1b2a4e8 RCX: 0000000000000000
[14654.085816] RDX: 0000000000000001 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.085825] RBP: ffff8b6b2860cc80 R08: ffff8b68d1b2a4e8 R09: ffff8b68d1b2a4e8
[14654.085833] R10: 0000000000000001 R11: ffff8b6b23c33b80 R12: 0000000000000000
[14654.085841] R13: 0000000000000000 R14: ffff8b6b2860cfc0 R15: ffff8b68d1b2a4e8
[14654.085859]  ip_finish_output+0x228/0x270
[14654.085873]  ? nf_hook_slow+0x44/0xc0
[14654.085882]  ip_output+0x6c/0xe0
[14654.085890]  ? ip_append_data.part.49+0xd0/0xd0
[14654.085899]  __ip_queue_xmit+0x15d/0x410
[14654.085909]  __tcp_transmit_skb+0x527/0xb10
[14654.085926]  tcp_write_xmit+0x384/0x1000
[14654.085935]  tcp_send_loss_probe+0xec/0x200
[14654.085943]  tcp_write_timer_handler+0xce/0x210
[14654.085952]  tcp_write_timer+0x71/0x90
[14654.085964]  ? tcp_write_timer_handler+0x210/0x210
[14654.085971]  call_timer_fn+0x2b/0x130
[14654.085980]  run_timer_softirq+0x1c7/0x3e0
[14654.085988]  ? __hrtimer_run_queues+0x130/0x280
[14654.085996]  ? ktime_get+0x3a/0xa0
[14654.086005]  __do_softirq+0xde/0x2d8
[14654.086017]  irq_exit+0xba/0xc0
[14654.086032]  smp_apic_timer_interrupt+0x74/0x140
[14654.086041]  apic_timer_interrupt+0xf/0x20
[14654.086049]  </IRQ>
[14654.086057] RIP: 0010:cpuidle_enter_state+0xb9/0x320
[14654.086066] Code: e8 4c b9 b0 ff 80 7c 24 0b 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 3b 02 00 00 31 ff e8 1e a9 b6 ff fb 66 0f 1f 44 00 00 <48> b8 ff ff ff ff f3 01 00 00 48 2b 1c 24 ba ff ff ff 7f 48 39 c3
[14654.086072] RSP: 0018:ffffffffa3e03e70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[14654.086083] RAX: ffff8b6b2ea220c0 RBX: 00000d53eb58c94d RCX: 000000000000001f
[14654.086091] RDX: 00000d53eb58c94d RSI: 000000002011bc2e RDI: 0000000000000000
[14654.086099] RBP: ffff8b6b2138e000 R08: 0000000000000002 R09: 0000000000021980
[14654.086108] R10: 0000353f780efd09 R11: ffff8b6b2ea210a8 R12: 0000000000000002
[14654.086116] R13: ffffffffa3eba4d8 R14: 0000000000000002 R15: 00000000bc141a22
[14654.086126]  do_idle+0x228/0x270
[14654.086141]  cpu_startup_entry+0x6f/0x80
[14654.086150]  start_kernel+0x50c/0x52f
[14654.086159]  secondary_startup_64+0xa4/0xb0
[14654.086883] bad: scheduling from the idle thread!
[14654.086898] CPU: 0 PID: 0 Comm: swapper/0 Tainted: P      D W  OE     4.19.0-10-amd64 #1 Debian 4.19.132-1
[14654.086906] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./970M Pro3, BIOS P1.60 06/17/2016
[14654.086915] Call Trace:
[14654.086923]  <IRQ>
[14654.086932]  dump_stack+0x66/0x90
[14654.086949]  dequeue_task_idle+0x28/0x40
[14654.086961]  __schedule+0x317/0x870
[14654.086969]  schedule+0x28/0x80
[14654.086971]  schedule_timeout+0x26d/0x390
[14654.086978]  ? sprintf+0x56/0x70
[14654.086985]  __down_interruptible+0xe6/0x120
[14654.086993]  down_interruptible+0x42/0x50
[14654.087001]  pstore_dump+0x9e/0x340
[14654.087003]  ? wake_up_klogd+0x30/0x40
[14654.087010]  ? vprintk_emit+0x215/0x270
[14654.087017]  ? wake_up_klogd+0x30/0x40
[14654.087019]  ? printk+0x58/0x6f
[14654.087026]  kmsg_dump+0xb9/0xe0
[14654.087033]  oops_end+0x64/0xd0
[14654.087040]  no_context+0x1be/0x380
[14654.087042]  __do_page_fault+0xb2/0x4f0
[14654.087050]  page_fault+0x1e/0x30
[14654.087058] RIP: 0010:__cgroup_bpf_run_filter_skb+0xbd/0x1e0
[14654.087065] Code: 00 00 00 49 89 7f 18 48 89 0c 24 44 89 e1 48 29 c8 48 89 4c 24 08 49 89 87 d8 00 00 00 89 d2 48 8d 84 d6 b0 03 00 00 48 8b 00 <48> 8b 58 10 4c 8d 70 10 48 85 db 0f 84 01 01 00 00 4d 8d 6f 30 bd
[14654.087069] RSP: 0018:ffff8b6b2ea03c40 EFLAGS: 00010286
[14654.087080] RAX: 0000000300000000 RBX: ffff8b68d1b2a4e8 RCX: 0000000000000000
[14654.087082] RDX: 0000000000000001 RSI: ffff8b6b25ffb000 RDI: ffff8b6b2860cc80
[14654.087089] RBP: ffff8b6b2860cc80 R08: ffff8b68d1b2a4e8 R09: ffff8b68d1b2a4e8
[14654.087090] R10: 0000000000000001 R11: ffff8b6b23c33b80 R12: 0000000000000000
[14654.087096] R13: 0000000000000000 R14: ffff8b6b2860cfc0 R15: ffff8b68d1b2a4e8
[14654.087104]  ip_finish_output+0x228/0x270
[14654.087111]  ? nf_hook_slow+0x44/0xc0
[14654.087113]  ip_output+0x6c/0xe0
[14654.087122]  ? ip_append_data.part.49+0xd0/0xd0
[14654.087125]  __ip_queue_xmit+0x15d/0x410
[14654.087138]  __tcp_transmit_skb+0x527/0xb10
[14654.087146]  tcp_write_xmit+0x384/0x1000
[14654.087153]  tcp_send_loss_probe+0xec/0x200
[14654.087155]  tcp_write_timer_handler+0xce/0x210
[14654.087162]  tcp_write_timer+0x71/0x90
[14654.087169]  ? tcp_write_timer_handler+0x210/0x210
[14654.087171]  call_timer_fn+0x2b/0x130
[14654.087178]  run_timer_softirq+0x1c7/0x3e0
[14654.087185]  ? __hrtimer_run_queues+0x130/0x280
[14654.087187]  ? ktime_get+0x3a/0xa0
[14654.087208]  __do_softirq+0xde/0x2d8
[14654.087231]  irq_exit+0xba/0xc0
[14654.087262]  smp_apic_timer_interrupt+0x74/0x140
[14654.087279]  apic_timer_interrupt+0xf/0x20
[14654.087294]  </IRQ>
<SNIP>


