Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0CB6DC1E6
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 00:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjDIWVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 18:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIWVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 18:21:16 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9BFB1;
        Sun,  9 Apr 2023 15:21:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id B124B604F5;
        Mon, 10 Apr 2023 00:21:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1681078872; bh=SHq6RVGPKUvfjuFGoSowA6z7L1xnFVJl9q7NhCshIfs=;
        h=Date:To:Cc:From:Subject:From;
        b=TsKwwbsNAgf82VdwqY8+P9PPzxmcdq793AYhA2hHddrhIBaXUsHkE3GEsqF67Otza
         3sIUUpCTxEyoNqInyb8aoQt5MIwoW6HXAwEqVdJymJJvsda35AysLyppX0qwrs1oBo
         lZwv/3TYQ6QC/7/Lz8eOle/0KknQ/vKbpjHa8jCPzrrSVWuUGfSpsivD8vV/kAJyEx
         T6cQ/R4SjYQNB0UTtQKVlMP7Ubeli3HTSKeulw019P/6Dp62ma6VRA+foY/DUKcXda
         /BpeWdZxZCGAzuFsHt8BH6cbLrGYtOSArP+PhvxQy1A/0AeG34J3jMR3yIplyQwASB
         jCLMyTeS09ppA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Vp72i1YNjGFV; Mon, 10 Apr 2023 00:21:09 +0200 (CEST)
Received: from [192.168.1.4] (unknown [94.250.188.177])
        by domac.alu.hr (Postfix) with ESMTPSA id 7D1B3604ED;
        Mon, 10 Apr 2023 00:21:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1681078869; bh=SHq6RVGPKUvfjuFGoSowA6z7L1xnFVJl9q7NhCshIfs=;
        h=Date:To:Cc:From:Subject:From;
        b=dUeq882BBGwjMsXqv1KjqW2Na/0qJjM2w74tbn++B4jL9hJ0Nioqvx53u5J2lB/6A
         Nc6H5rDn5Ipv479wptyRKcmXkbw1y4lPvP2zZVaoVNHJxNaXkafm9S+hUl7Y0/fcYH
         IcrJchJIRXMTRn4YqKns8NeNnTo8mYRAL2vemon+efzfMTPe/FMl+bULr9RBCIbQ7H
         XJQVz9vr3oJmgGRrNKqbuFBJ1pChHrXWxegR0qgsRPOLoKN8I7u1cisFhbB30IKCuK
         I/nFyLcsbDOMfE5Q9Lx3w1KClrMLp1mouFVMW6opzLu/7com++U5wWOezlnJ4pu2Cu
         +/ZxRZUOjXRqQ==
Message-ID: <1f58a0d1-d2b9-d851-73c3-93fcc607501c@alu.unizg.hr>
Date:   Mon, 10 Apr 2023 00:21:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US, hr
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: BUG: drivers/net/wireless: iwlwifi: IWL Error: ieee80211 phy0:
 Hardware restart was requested
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This is an error is the syslog found after investigating a Youtube FF chi=
rping hang
while running kseftest of 6.3-rc6 torvalds tree kernel.

Running multimedia and kselftest might seem off, but multimedia performan=
ce on Linux
and open source software is a very interesting research area.

Here is the trace from the log:

Apr  9 23:01:11 marvin-IdeaPad-3-15ITL6 kernel: [  615.957145] mmiotrace:=
 disabled.
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.881758] iwlwifi 00=
00:00:14.3: Error sending STATISTICS_CMD: time out after 2000ms.
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.882332] iwlwifi 00=
00:00:14.3: Current CMD queue read_ptr 67 write_ptr 68
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884299] iwlwifi 00=
00:00:14.3: Start IWL Error Log Dump:
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884373] iwlwifi 00=
00:00:14.3: Transport status: 0x0000004A, valid: 6
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884446] iwlwifi 00=
00:00:14.3: Loaded firmware version: 73.35c0a2c6.0 QuZ-a0-jf-b0-73.ucode
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884520] iwlwifi 00=
00:00:14.3: 0x00000084 | NMI_INTERRUPT_UNKNOWN      =20
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884624] iwlwifi 00=
00:00:14.3: 0x000022F0 | trm_hw_status0
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884695] iwlwifi 00=
00:00:14.3: 0x00000000 | trm_hw_status1
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884766] iwlwifi 00=
00:00:14.3: 0x004C352E | branchlink2
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884837] iwlwifi 00=
00:00:14.3: 0x004BA12A | interruptlink1
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.884907] iwlwifi 00=
00:00:14.3: 0x004BA12A | interruptlink2
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885309] iwlwifi 00=
00:00:14.3: 0x0000CEEA | data1
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885444] iwlwifi 00=
00:00:14.3: 0x01000000 | data2
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885526] iwlwifi 00=
00:00:14.3: 0x00000000 | data3
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885598] iwlwifi 00=
00:00:14.3: 0x840075C7 | beacon time
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885670] iwlwifi 00=
00:00:14.3: 0x5282AA44 | tsf low
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885741] iwlwifi 00=
00:00:14.3: 0x00000082 | tsf hi
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885812] iwlwifi 00=
00:00:14.3: 0x00000000 | time gp1
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885885] iwlwifi 00=
00:00:14.3: 0x24D400DC | time gp2
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.885963] iwlwifi 00=
00:00:14.3: 0x00000001 | uCode revision type
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886040] iwlwifi 00=
00:00:14.3: 0x00000049 | uCode version major
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886117] iwlwifi 00=
00:00:14.3: 0x35C0A2C6 | uCode version minor
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886193] iwlwifi 00=
00:00:14.3: 0x00000351 | hw version
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886268] iwlwifi 00=
00:00:14.3: 0x00489001 | board version
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886344] iwlwifi 00=
00:00:14.3: 0x80B3F400 | hcmd
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886420] iwlwifi 00=
00:00:14.3: 0x00020000 | isr0
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886496] iwlwifi 00=
00:00:14.3: 0x00000000 | isr1
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886632] iwlwifi 00=
00:00:14.3: 0x08F00002 | isr2
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886750] iwlwifi 00=
00:00:14.3: 0x00C3028C | isr3
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.886889] iwlwifi 00=
00:00:14.3: 0x00000000 | isr4
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887035] iwlwifi 00=
00:00:14.3: 0x05C8001C | last cmd Id
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887180] iwlwifi 00=
00:00:14.3: 0x0000CEEA | wait_event
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887326] iwlwifi 00=
00:00:14.3: 0x00000854 | l2p_control
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887467] iwlwifi 00=
00:00:14.3: 0x00000020 | l2p_duration
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887610] iwlwifi 00=
00:00:14.3: 0x0000000F | l2p_mhvalid
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887756] iwlwifi 00=
00:00:14.3: 0x00000000 | l2p_addr_match
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.887895] iwlwifi 00=
00:00:14.3: 0x00000009 | lmpm_pmg_sel
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.888150] iwlwifi 00=
00:00:14.3: 0x00000000 | timestamp
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.888288] iwlwifi 00=
00:00:14.3: 0x00006868 | flow_handler
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.888730] iwlwifi 00=
00:00:14.3: Start IWL Error Log Dump:
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.888867] iwlwifi 00=
00:00:14.3: Transport status: 0x0000004A, valid: 7
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889159] iwlwifi 00=
00:00:14.3: 0x20000066 | NMI_INTERRUPT_HOST
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889306] iwlwifi 00=
00:00:14.3: 0x00000000 | umac branchlink1
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889450] iwlwifi 00=
00:00:14.3: 0x80453B88 | umac branchlink2
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889594] iwlwifi 00=
00:00:14.3: 0x8046FE32 | umac interruptlink1
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889740] iwlwifi 00=
00:00:14.3: 0x8046FE32 | umac interruptlink2
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.889886] iwlwifi 00=
00:00:14.3: 0x01000000 | umac data1
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890033] iwlwifi 00=
00:00:14.3: 0x8046FE32 | umac data2
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890176] iwlwifi 00=
00:00:14.3: 0x00000000 | umac data3
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890323] iwlwifi 00=
00:00:14.3: 0x00000049 | umac major
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890468] iwlwifi 00=
00:00:14.3: 0x35C0A2C6 | umac minor
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890613] iwlwifi 00=
00:00:14.3: 0x24D400DA | frame pointer
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890759] iwlwifi 00=
00:00:14.3: 0xC0886264 | stack pointer
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.890905] iwlwifi 00=
00:00:14.3: 0x0043019C | last host cmd
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891050] iwlwifi 00=
00:00:14.3: 0x00000000 | isr status reg
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891323] iwlwifi 00=
00:00:14.3: IML/ROM dump:
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891469] iwlwifi 00=
00:00:14.3: 0x00000003 | IML/ROM error/state
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891731] iwlwifi 00=
00:00:14.3: 0x000053F8 | IML/ROM data1
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.891997] iwlwifi 00=
00:00:14.3: 0x00000080 | IML/ROM WFPM_AUTH_KEY_0
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.892216] iwlwifi 00=
00:00:14.3: Fseq Registers:
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.893775] iwlwifi 00=
00:00:14.3: 0x60000000 | FSEQ_ERROR_CODE
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.893927] iwlwifi 00=
00:00:14.3: 0x80260000 | FSEQ_TOP_INIT_VERSION
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894077] iwlwifi 00=
00:00:14.3: 0x00020006 | FSEQ_CNVIO_INIT_VERSION
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894227] iwlwifi 00=
00:00:14.3: 0x0000A384 | FSEQ_OTP_VERSION
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894374] iwlwifi 00=
00:00:14.3: 0x3D544A68 | FSEQ_TOP_CONTENT_VERSION
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894526] iwlwifi 00=
00:00:14.3: 0x4552414E | FSEQ_ALIVE_TOKEN
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894675] iwlwifi 00=
00:00:14.3: 0x20000302 | FSEQ_CNVI_ID
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894826] iwlwifi 00=
00:00:14.3: 0x01300202 | FSEQ_CNVR_ID
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.894976] iwlwifi 00=
00:00:14.3: 0x20000302 | CNVI_AUX_MISC_CHIP
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.895129] iwlwifi 00=
00:00:14.3: 0x01300202 | CNVR_AUX_MISC_CHIP
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.895282] iwlwifi 00=
00:00:14.3: 0x0000485B | CNVR_SCU_SD_REGS_SD_REG_DIG_DCDC_VTRIM
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.895463] iwlwifi 00=
00:00:14.3: 0xA5A5A5A2 | CNVR_SCU_SD_REGS_SD_REG_ACTIVE_VDIG_MIRROR
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.898477] iwlwifi 00=
00:00:14.3: WRT: Collecting data: ini trigger 4 fired (delay=3D0ms).
Apr  9 23:01:25 marvin-IdeaPad-3-15ITL6 kernel: [  629.899785] ieee80211 =
phy0: Hardware restart was requested
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.878162] iwlwifi 00=
00:00:14.3: HCMD_ACTIVE already clear for command STATISTICS_CMD
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.878273] iwlwifi 00=
00:00:14.3: Hardware error detected. Restarting.
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.881860] ----------=
--[ cut here ]------------
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.882201] WARNING: C=
PU: 5 PID: 47 at drivers/net/wireless/intel/iwlwifi/mvm/../iwl-trans.h:12=
00 iwl_mvm_rx_tx_cmd+0xc65/0xd50 [iwlmvm]
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.882380] Modules li=
nked in: ftrace_direct ccm rfcomm snd_seq_dummy snd_hrtimer cmac algif_sk=
cipher snd_ctl_led snd_soc_skl_hda_dsp snd_soc_intel_hda_dsp_common snd_s=
oc_hdac_hdmi snd_sof_probes snd_hda_codec_hdmi snd_hda_codec_realtek snd_=
hda_codec_generic ledtrig_audio bnep joydev uvcvideo videobuf2_vmalloc bt=
usb uvc videobuf2_memops btrtl videobuf2_v4l2 btbcm videodev btintel btmt=
k usbhid videobuf2_common bluetooth mc ecdh_generic ecc snd_soc_dmic snd_=
sof_pci_intel_tgl snd_sof_intel_hda_common soundwire_intel soundwire_gene=
ric_allocation soundwire_cadence hid_multitouch snd_sof_intel_hda snd_sof=
_pci snd_sof_xtensa_dsp snd_sof hid_generic snd_sof_utils snd_soc_hdac_hd=
a snd_hda_ext_core snd_soc_acpi_intel_match snd_soc_acpi intel_tcc_coolin=
g soundwire_bus x86_pkg_temp_thermal sunrpc mei_pxp intel_powerclamp mei_=
hdcp snd_soc_core snd_compress coretemp ac97_bus spi_pxa2xx_platform crct=
10dif_pclmul snd_pcm_dmaengine dw_dmac crc32_pclmul dw_dmac_core ghash_cl=
mulni_intel snd_hda_intel sha512_ssse3 8250_dw
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.885849]  snd_intel=
_dspcfg snd_intel_sdw_acpi aesni_intel crypto_simd wmi_bmof snd_hda_codec=
 cryptd binfmt_misc snd_hda_core rapl snd_hwdep pmt_telemetry intel_rapl_=
msr pmt_class intel_cstate snd_pcm i2c_hid_acpi i915 iwlmvm i2c_hid snd_s=
eq_midi snd_seq_midi_event nls_iso8859_1 snd_rawmidi mac80211 drm_buddy l=
ibarc4 ttm snd_seq drm_display_helper processor_thermal_device_pci_legacy=
 cec snd_seq_device ideapad_laptop snd_timer btrfs sparse_keymap processo=
r_thermal_device drm_kms_helper iwlwifi platform_profile processor_therma=
l_rfim processor_thermal_mbox int3400_thermal mei_me blake2b_generic xhci=
_pci xor processor_thermal_rapl video wmi acpi_thermal_rel mei acpi_tad i=
2c_algo_bit acpi_pad int3403_thermal intel_rapl_common snd xhci_pci_renes=
as i2c_i801 syscopyarea ahci cfg80211 intel_vsec int340x_thermal_zone int=
el_lpss_pci sysfillrect soundcore i2c_smbus intel_lpss sysimgblt intel_so=
c_dts_iosf libahci igen6_edac idma64 raid6_pq msr parport_pc ppdev lp par=
port ramoops pstore_blk reed_solomon pstore_zone drm
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.886823]  efi_pstor=
e ip_tables x_tables autofs4 nvme nvme_core input_leds vmd serio_raw mac_=
hid pinctrl_tigerlake [last unloaded: ftrace_direct]
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.886986] CPU: 5 PID=
: 47 Comm: ksoftirqd/5 Not tainted 6.3.0-rc6-mt-20230401-00001-gf86822a11=
70f #4
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887006] Hardware n=
ame: LENOVO 82H8/LNVNB161216, BIOS GGCN51WW 11/16/2022
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887022] RIP: 0010:=
iwl_mvm_rx_tx_cmd+0xc65/0xd50 [iwlmvm]
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887096] Code: 85 c=
0 74 0d 0f b6 40 27 89 f1 21 c1 84 c0 0f 45 f1 40 0f b6 f6 4c 89 ff e8 e8=
 3f ff ff 41 88 84 24 7e 14 00 00 e9 7c fe ff ff <0f> 0b 48 8b 7f 40 48 c=
7 c1 10 ba fa c0 48 c7 c2 58 ce fb c0 31 f6
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887114] RSP: 0018:=
ffffb60200267b70 EFLAGS: 00010293
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887142] RAX: 00000=
00000001c80 RBX: ffff8b5af378c000 RCX: 0000000000000005
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887159] RDX: 00000=
00000000000 RSI: ffffb60200267bb0 RDI: ffff8b5a8ff20028
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887174] RBP: ffffb=
60200267c40 R08: 0000000000000000 R09: 0000000000000001
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887189] R10: ffffb=
60200267c58 R11: 0000000000000000 R12: 0000000000000000
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887205] R13: 00000=
00000000030 R14: ffffb60200267d18 R15: ffff8b5aa39d33e8
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887221] FS:  00000=
00000000000(0000) GS:ffff8b5c27a80000(0000) knlGS:0000000000000000
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887238] CS:  0010 =
DS: 0000 ES: 0000 CR0: 0000000080050033
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887255] CR2: 00007=
f49f4dfe008 CR3: 000000017d850001 CR4: 0000000000f70ee0
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887271] PKRU: 5555=
5554
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887286] Call Trace=
:
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887302]  <TASK>
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887359]  ? __pfx_i=
wl_mvm_rx_tx_cmd+0x10/0x10 [iwlmvm]
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887446]  ? iwl_mvm=
_rx_tx_cmd+0x9/0xd50 [iwlmvm]
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887540]  ftrace_re=
gs_caller_end+0x66/0x66
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887563]  ? ftrace_=
regs_caller_end+0x66/0x66
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887582]  ? iwl_mvm=
_rx_common+0xde/0x390 [iwlmvm]
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887650]  ? iwl_mvm=
_rx_mq+0x9/0xc0 [iwlmvm]
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887739]  ? ftrace_=
regs_caller_end+0x66/0x66
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887757]  iwl_mvm_r=
x_mq+0x79/0xc0 [iwlmvm]
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887821]  ? ftrace_=
regs_caller_end+0x66/0x66
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887839]  iwl_pcie_=
rx_handle+0x402/0xaa0 [iwlwifi]
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887979]  ? ftrace_=
regs_caller_end+0x66/0x66
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.887997]  iwl_pcie_=
napi_poll_msix+0x39/0xf0 [iwlwifi]
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888086]  ? ftrace_=
regs_caller_end+0x66/0x66
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888105]  __napi_po=
ll+0x2e/0x1f0
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888146]  ? ftrace_=
regs_caller_end+0x66/0x66
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888164]  net_rx_ac=
tion+0x1a5/0x330
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888240]  ? ftrace_=
regs_caller_end+0x66/0x66
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888258]  __do_soft=
irq+0xb4/0x3a4
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888311]  ? smpboot=
_thread_fn+0x2a/0x290
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888340]  ? ftrace_=
regs_caller_end+0x66/0x66
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888358]  run_ksoft=
irqd+0x44/0x80
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888382]  ? ftrace_=
regs_caller_end+0x66/0x66
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888400]  smpboot_t=
hread_fn+0x1d9/0x290
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888435]  ? __pfx_s=
mpboot_thread_fn+0x10/0x10
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888458]  kthread+0=
x10f/0x140
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888481]  ? __pfx_k=
thread+0x10/0x10
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888517]  ret_from_=
fork+0x29/0x50
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888609]  </TASK>
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888623] irq event =
stamp: 4206602
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888636] hardirqs l=
ast  enabled at (4206608): [<ffffffffb9a51c98>] __up_console_sem+0x68/0x8=
0
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888657] hardirqs l=
ast disabled at (4206613): [<ffffffffb9a51c7d>] __up_console_sem+0x4d/0x8=
0
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888676] softirqs l=
ast  enabled at (4196852): [<ffffffffb9965b60>] return_to_handler+0x0/0x4=
0
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888695] softirqs l=
ast disabled at (4196891): [<ffffffffb9965b60>] return_to_handler+0x0/0x4=
0
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888714] ---[ end t=
race 0000000000000000 ]---
Apr  9 23:01:26 marvin-IdeaPad-3-15ITL6 kernel: [  630.888732] iwlwifi 00=
00:00:14.3: iwl_trans_reclaim bad state =3D 0

Hope this helps.

The platform is Ubuntu 22.10 kinetic kudu on Lenovo IdeaPad 3 15ITL6,
the above mentioned 6.3-rc6 torvalds tree kernel and GGCN51WW original
Lenovo BIOS.

Please find the config and the lshw output and this listing at the URL:

=E2=86=92 https://domac.alu.unizg.hr/~mtodorov/linux/bugreports/intel/iwl=
wifi/

Best regards,
Mirsad

--=20
Mirsad Goran Todorovac
Sistem in=C5=BEenjer
Grafi=C4=8Dki fakultet | Akademija likovnih umjetnosti
Sveu=C4=8Dili=C5=A1te u Zagrebu
=20
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union

"I see something approaching fast ... Will it be friends with me?"
