Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D099B42BEE8
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 13:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhJMLbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 07:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhJMLb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 07:31:29 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207EBC061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 04:29:26 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g14so2197836pfm.1
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 04:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YuWBjOBWFaZ9lrZUP7rUQNvD8WGdCrnx1RCHoRN4vG4=;
        b=gvDJHW8xOgjDGJ68oY19cG8LUlkrOqdCnDFCI7u4mQv73QvzNAW1eZjZTsEUTTZSGt
         wqDqupw1B9GLCtgi67kbpQhQShir3Aw845SOOspsEaOKWZLgC7P+Sq7WZfPiIOHYrfPn
         uDJTBUVABgIyrClGmQPuq38oG5VAxzJMwqkvN4cqizJmY+7yZC7hb+31h53pM7TQDuKo
         hOiV0CrEjzalhNu55lTbB3frXnelqHKizlqjx18DtIV5KHZcvqMVc3sWdOtzzHo6QHZX
         q8sLvhaZwNdBaJUWTF7zvqAkN/HnVsDhXjtCTVxmcTB/E3R6dKUGvQ4lda2hjy/aily7
         dNsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YuWBjOBWFaZ9lrZUP7rUQNvD8WGdCrnx1RCHoRN4vG4=;
        b=l783BU7czINho+CqJVfRkF8FwC2DJ1XaOmA7P9Fm1X0MA2FhcsFBlSM31RgKIw0bid
         HEdNn5csqsCUGwrs65BrJ4WF+r8ioYaUIbYmcQ/Vui2r5kedTkhJD9/+OPguD2JSxfpt
         CVKEjA2zb4uKOVvL1nYKyWXtO5iCOOHyN3SDKnjmD3JTqum3poZ0M9NqH/uHb5N777eU
         C5hEcxprZCAjx40uChc1slWGe8SzccanjX0WTXR8ieFlYp6oxz1TQxXaTb+4CMfIGqX3
         pySb6TKBCB63V2L73mizbISRPW1rLIVwPKzuIJ8QDfUQEtBoQmF/MWkVINYPQn87VUmt
         kZKw==
X-Gm-Message-State: AOAM532mLp7e0UUDqLUQvFpt2yc+xNzU7bZP8VkKOJ8D8PIKt8Ed+vx1
        PS7cYyr6edPj7E4LdPu324O65A==
X-Google-Smtp-Source: ABdhPJxSk/gxyRSi14qShY3arNwIDjljb6lcvx8WXPNb4o1XjlQzGEH08kKzO4L/554uHlqXYRm5LA==
X-Received: by 2002:aa7:9523:0:b0:44c:c171:9ae with SMTP id c3-20020aa79523000000b0044cc17109aemr36174264pfp.75.1634124565321;
        Wed, 13 Oct 2021 04:29:25 -0700 (PDT)
Received: from localhost.localdomain ([182.2.74.1])
        by smtp.gmail.com with ESMTPSA id u65sm6212700pfb.208.2021.10.13.04.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 04:29:24 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: WARNING: CPU: 2 PID: 633 at net/wireless/sme.c:974 cfg80211_roamed+0x265/0x2a0 [cfg80211]
Date:   Wed, 13 Oct 2021 18:27:09 +0700
Message-Id: <20211013112709.636468-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <874k9l1p19.fsf@tynnyri.adurom.net>
References: <874k9l1p19.fsf@tynnyri.adurom.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 12:18 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> >
> > Here is the log:
> >
> > <4>[266728.385936][  T633] ------------[ cut here ]------------
> > <4>[266728.385946][  T633] WARNING: CPU: 2 PID: 633 at net/wireless/sme.c:974 cfg80211_roamed+0x265/0x2a0 [cfg80211]
> > <4>[266728.386040][ T633] Modules linked in: rfcomm xt_CHECKSUM
> > xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp
> > nft_compat nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6
> > nf_defrag_ipv4 nft_counter nf_tables nfnetlink bridge stp llc bfq cmac
> > algif_hash algif_skcipher af_alg bnep dm_multipath scsi_dh_rdac
> > scsi_dh_emc scsi_dh_alua snd_hda_codec_realtek snd_hda_codec_hdmi
> > uvcvideo snd_hda_codec_generic ledtrig_audio snd_hda_intel
> > videobuf2_vmalloc snd_intel_dspcfg videobuf2_memops snd_intel_sdw_acpi
> > btusb btrtl videobuf2_v4l2 videobuf2_common btbcm snd_hda_codec
> > btintel videodev snd_hda_core bluetooth snd_hwdep wl(OE) mc snd_pcm
> > ecdh_generic snd_seq_midi ecc snd_seq_midi_event edac_mce_amd
> > snd_rawmidi kvm_amd acer_wmi snd_seq sparse_keymap kvm cfg80211
> > wmi_bmof input_leds serio_raw snd_seq_device snd_timer snd soundcore
> > ccp fam15h_power k10temp mac_hid sch_fq_codel msr ip_tables x_tables
> > autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_recov
> > async_memcpy async_pq
> > <4>[266728.386224][ T633] async_xor async_tx xor raid6_pq libcrc32c
> > raid1 raid0 multipath linear amdgpu iommu_v2 gpu_sched radeon
> > i2c_algo_bit drm_ttm_helper ttm hid_generic drm_kms_helper syscopyarea
> > usbhid crct10dif_pclmul sysfillrect crc32_pclmul sysimgblt hid
> > ghash_clmulni_intel fb_sys_fops cec aesni_intel rc_core rtsx_pci_sdmmc
> > sdhci_pci crypto_simd cqhci r8169 cryptd psmouse ahci xhci_pci
> > rtsx_pci realtek libahci drm sdhci i2c_piix4 xhci_pci_renesas wmi
> > video
> > <4>[266728.386330][ T633] CPU: 2 PID: 633 Comm: wl_event_handle
> > Tainted: G W OE 5.15.0-rc4-for-5.16-io-uring-00060-g4922ab639eb6 #4
> > 8b24b2500a34cedea2e69c8d84eb4c855e713e61
> > <4>[266728.386337][  T633] Hardware name: Acer Aspire ES1-421/OLVIA_BE, BIOS V1.05 07/02/2015
> > <4>[266728.386341][  T633] RIP: 0010:cfg80211_roamed+0x265/0x2a0 [cfg80211]
> > <4>[266728.386408][ T633] Code: 4c 89 f7 49 8d 8d 22 01 00 00 45 0f b6
> > 85 42 01 00 00 6a 02 48 8b 36 e8 79 ab fc ff 48 89 43 08 5a 48 85 c0
> > 0f 85 d6 fd ff ff <0f> 0b 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3
> > 0f 0b 48 8b 73
> > <4>[266728.386412][  T633] RSP: 0018:ffffc9000157bdd8 EFLAGS: 00010246
> > <4>[266728.386418][  T633] RAX: 0000000000000000 RBX: ffffc9000157be20 RCX: 0000000000000000
> > <4>[266728.386421][  T633] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffffffff8109ead2
> > <4>[266728.386425][  T633] RBP: ffffc9000157be10 R08: 0000000000000001 R09: 0000000000000001
> > <4>[266728.386428][  T633] R10: fffffffefb3c8d52 R11: ffff8881328b75b2 R12: 0000000000000cc0
> > <4>[266728.386431][  T633] R13: ffff888105873800 R14: ffff8881328b6580 R15: dead000000000100
> > <4>[266728.386435][  T633] FS:  0000000000000000(0000) GS:ffff888313d00000(0000) knlGS:0000000000000000
> > <4>[266728.386439][  T633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > <4>[266728.386443][  T633] CR2: 00007f3033edd000 CR3: 000000011a878000 CR4: 00000000000406e0
> > <4>[266728.386447][  T633] Call Trace:
> > <4>[266728.386456][  T633]  ? wl_update_bss_info.isra.0+0xf5/0x210 [wl 47ce17d152623ac79abb5e1d4a28d4375eb94473]
> > <4>[266728.386555][  T633]  wl_bss_roaming_done.constprop.0+0xc4/0x100 [wl 47ce17d152623ac79abb5e1d4a28d4375eb94473]
> > <4>[266728.386648][  T633]  wl_notify_roaming_status+0x3f/0x60 [wl 47ce17d152623ac79abb5e1d4a28d4375eb94473]
> > <4>[266728.386730][  T633]  wl_event_handler+0x5f/0x140 [wl 47ce17d152623ac79abb5e1d4a28d4375eb94473]
> > <4>[266728.386808][  T633]  ? wl_cfg80211_del_key+0x100/0x100 [wl 47ce17d152623ac79abb5e1d4a28d4375eb94473]
>
> What wireless device and driver you have? Based on the call trace it
> looks like you are using Broadcom's out-of-tree driver called wl.
>

Yes, it is. Here is the info when I load the module.

<5>[329274.450461][T634003] cfg80211: Loading compiled-in X.509 certificates for regulatory database
<5>[329274.451011][T634003] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
<4>[329274.876411][T634003] wlan0: Broadcom BCM4365 802.11 Hybrid Wireless Controller 6.30.223.271 (r587334)
<4>[329274.876424][T634003]
<6>[329275.232559][T634007] wl 0000:02:00.0 wlp2s0: renamed from wlan0
<6>[329294.320737][  T892] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready

Any direction where to go or what to do?

-- 
Ammar Faizi
