Return-Path: <netdev+bounces-12147-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C5EA736692
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:44:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A9C91C20B64
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC401BE68;
	Tue, 20 Jun 2023 08:44:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAD3AD56
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:44:47 +0000 (UTC)
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BC7E71;
	Tue, 20 Jun 2023 01:44:45 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b52e55f45bso18726815ad.2;
        Tue, 20 Jun 2023 01:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687250685; x=1689842685;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iiVO44Bmw/slZHbXkcnh+CmEPPQRB8XJKAU2tOpfE5U=;
        b=qCfR9MZHqM//GGBuxOJ7ZDyLXE4JTuNEJUxeEuq4SO0HJzqkMjmaq5W0pOZQzOAbUu
         IsWuLkMynS3YE83w9CbyF5uOCmSugxH69jKXdVzOIbk0vhEyKzj329LX+pP4qIGT4CnU
         x8oJ/1D2Me/Fh6EsExHqj8LZfc7chjqSU1m4hsAck3ZPXGZA62XyVMWkrtEYgDCeaSAS
         JHc8Fn0MT8Au8zafW64rHozUul3sKPXOVlrg7MM3hKagxlIHeTG/50yvu0nF/GH1bizx
         iwXsPqhb7xU7zAazdxSonCRA+HO3wCpz7l4ZIS7Is9EENFT90rOnbO7iLCm8rX2R6kHz
         NcpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687250685; x=1689842685;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iiVO44Bmw/slZHbXkcnh+CmEPPQRB8XJKAU2tOpfE5U=;
        b=V/dfV7Gl0TA3sc2DxY36wWI3TpTvwIGDbRfdDIVTENiStDrhjWflokwpnR8DcPw5eg
         HlTZqlJaV4gzt0o1/2+FVi3DTKHm10WZto38HoQtY9N338PUjT9xSL9jb2u2zgFIcg62
         EHxqmRLd8qRqZ4b/SXnLW4C9J1NAY/tEw/1De+wiHTnY0H2cHLIs6oS6xYnxQL4GKM3X
         7FxVMglOf2aKSrt1exhDHUbyriGRv/WIvcfiN/D+094Qc97OcaMIoAFVoD2twg4fPSk0
         CZDQt9JGVezeyPz1RIdvweS6c93B/RZJ20oNJ4HNCjEy+4QOFPhrd1EWQPjK6UYnqlIX
         lnyg==
X-Gm-Message-State: AC+VfDyTytN2YuIgpf2PuroOgCvuqEOKCYXCWqt8WMCx6rzzmQw9E46+
	iKTkH1dsHkzsunmiHdd3gZJAJLnvzHX4pw==
X-Google-Smtp-Source: ACHHUZ4NC4rJxY6xrn1wBTK/AvuKpYmOlJbienbRZZETbZpig9EBQEMgILuK8jYFTNbR9tfrGu9HOQ==
X-Received: by 2002:a17:903:278e:b0:1b3:cd90:79bb with SMTP id jw14-20020a170903278e00b001b3cd9079bbmr6347466plb.25.1687250685066;
        Tue, 20 Jun 2023 01:44:45 -0700 (PDT)
Received: from [192.168.0.103] ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id m14-20020a170902db0e00b001aad714400asm1069392plx.229.2023.06.20.01.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 01:44:44 -0700 (PDT)
Message-ID: <dbfa25f5-64c8-5574-4f5d-0151ba95d232@gmail.com>
Date: Tue, 20 Jun 2023 15:44:34 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
To: M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, Florian Klink <flokli@flokli.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Wireless <linux-wireless@vger.kernel.org>,
 Linux Networking <netdev@vger.kernel.org>,
 Linux Regressions <regressions@lists.linux.dev>
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Fwd: iosm: detected field-spanning write for XMM7360
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

I notice a regression report on Bugzilla [1]. Quoting from it:

> Hey!
>=20
> I'm using Linux 6.3.0 on x86_64. Distro is NixOS.
>=20
> I'm using the XMM7360 WWAN device:
>=20
> 05:00.0 Wireless controller [0d40]: Intel Corporation XMM7360 LTE Advan=
ced Modem (rev 01)
>=20
> As discussed in https://gitlab.freedesktop.org/mobile-broadband/ModemMa=
nager/-/issues/612, the device currently needs some manual babysitting du=
e to broken suspend/resume, and some (slightly patched) python script sen=
ding commands to `/dev/wwan0xmmrpc0`:
>=20
> ```
> echo 1 > /sys/bus/pci/devices/0000:05:00.0/reset
> echo 1 > /sys/bus/pci/devices/0000:05:00.0/remove
> echo 1 > /sys/bus/pci/rescan
> # wait
> open_xdatachannel.py --apn "internet"
> ```
>=20
>=20
> I saw the following messages in dmesg:
> ```
> [Sa Jun 17 20:09:42 2023] pci_bus 0000:01: Allocating resources
> [Sa Jun 17 20:09:42 2023] pci_bus 0000:02: Allocating resources
> [Sa Jun 17 20:09:42 2023] pci_bus 0000:03: Allocating resources
> [Sa Jun 17 20:09:42 2023] pci_bus 0000:04: Allocating resources
> [Sa Jun 17 20:09:42 2023] pci_bus 0000:05: Allocating resources
> [Sa Jun 17 20:09:42 2023] pci_bus 0000:06: Allocating resources
> [Sa Jun 17 20:09:42 2023] pci_bus 0000:07: Allocating resources
> [Sa Jun 17 20:09:49 2023] iosm 0000:05:00.0: msg timeout
> [Sa Jun 17 20:09:49 2023] iosm 0000:05:00.0: msg timeout
> [Sa Jun 17 20:09:49 2023] pci 0000:05:00.0: Removing from iommu group 1=
5
> [Sa Jun 17 20:09:52 2023] pci 0000:05:00.0: [8086:7360] type 00 class 0=
x0d4000
> [Sa Jun 17 20:09:52 2023] pci 0000:05:00.0: reg 0x10: [mem 0xfd500000-0=
xfd500fff 64bit]
> [Sa Jun 17 20:09:52 2023] pci 0000:05:00.0: reg 0x18: [mem 0xfd501000-0=
xfd5013ff 64bit]
> [Sa Jun 17 20:09:52 2023] pci 0000:05:00.0: PME# supported from D0 D3ho=
t D3cold
> [Sa Jun 17 20:09:52 2023] pci 0000:05:00.0: Adding to iommu group 15
> [Sa Jun 17 20:09:52 2023] pci 0000:05:00.0: BAR 0: assigned [mem 0xfd50=
0000-0xfd500fff 64bit]
> [Sa Jun 17 20:09:52 2023] pci 0000:05:00.0: BAR 2: assigned [mem 0xfd50=
1000-0xfd5013ff 64bit]
> [Sa Jun 17 20:10:09 2023] ------------[ cut here ]------------
> [Sa Jun 17 20:10:09 2023] memcpy: detected field-spanning write (size 1=
6) of single field "&adth->dg" at drivers/net/wwan/iosm/iosm_ipc_mux_code=
c.c:852 (size 8)
> [Sa Jun 17 20:10:09 2023] WARNING: CPU: 11 PID: 0 at drivers/net/wwan/i=
osm/iosm_ipc_mux_codec.c:852 ipc_mux_ul_adb_finish+0x17e/0x290 [iosm]
> [Sa Jun 17 20:10:09 2023] Modules linked in: hid_multitouch qrtr ccm sn=
d_seq_dummy snd_hrtimer snd_seq snd_seq_device hid_lenovo uhid xt_CHECKSU=
M xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_comp=
at nft_chain_nat nf_tables nfnetlink af_packet rfcomm cmac algif_hash alg=
if_skcipher af_alg bnep nls_iso8859_1 nls_cp437 vfat fat joydev mousedev =
amdgpu iwlmvm r8153_ecm cdc_ether snd_soc_dmic snd_acp3x_pdm_dma snd_acp3=
x_rn usbnet snd_sof_amd_rembrandt snd_sof_amd_renoir snd_sof_amd_acp mac8=
0211 snd_sof_pci snd_sof_xtensa_dsp snd_ctl_led snd_sof snd_hda_codec_rea=
ltek snd_sof_utils intel_rapl_msr snd_hda_codec_generic libarc4 iommu_v2 =
snd_hda_codec_hdmi snd_soc_core uvcvideo btusb gpu_sched snd_compress eda=
c_mce_amd videobuf2_vmalloc drm_ttm_helper btrtl snd_hda_intel ac97_bus e=
dac_core snd_pcm_dmaengine uvc btbcm videobuf2_memops ttm snd_intel_dspcf=
g intel_rapl_common videobuf2_v4l2 snd_intel_sdw_acpi crc32_pclmul btinte=
l tps6598x snd_pci_ps polyval_clmulni regmap_i2c snd_hda_codec btmtk snd_=
rpl_pci_acp6x think_lmi
> [Sa Jun 17 20:10:09 2023]  polyval_generic iwlwifi wmi_bmof firmware_at=
tributes_class videodev drm_display_helper snd_acp_pci gf128mul snd_hda_c=
ore bluetooth ghash_clmulni_intel thinkpad_acpi r8152 r8169 videobuf2_com=
mon snd_pci_acp6x snd_hwdep nvram drm_kms_helper cfg80211 snd_pci_acp5x u=
csi_acpi mii sp5100_tco rapl ledtrig_audio mc psmouse ecdh_generic snd_pc=
m drm_buddy platform_profile typec_ucsi snd_rn_pci_acp3x ecc watchdog rea=
ltek snd_acp_config snd_timer crc16 agpgart iosm k10temp typec i2c_algo_b=
it ipmi_devintf snd_soc_acpi mdio_devres syscopyarea snd sysfillrect vide=
o snd_pci_acp3x libphy sysimgblt wwan 8250_pci ipmi_msghandler rfkill i2c=
_piix4 ac soundcore roles thermal battery tiny_power_button serial_multi_=
instantiate evdev i2c_scmi i2c_designware_platform wmi acpi_cpufreq mac_h=
id button i2c_designware_core serio_raw sch_cake ctr loop xt_nat nf_nat n=
f_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter veth tun tap macvl=
an bridge stp llc kvm_amd ccp kvm irqbypass tcp_bbr i2c_dev drm fuse back=
light i2c_core deflate
> [Sa Jun 17 20:10:09 2023]  efi_pstore configfs efivarfs dmi_sysfs ip_ta=
bles x_tables dm_crypt cbc encrypted_keys trusted asn1_encoder tee hid_ge=
neric usbhid hid mmc_block dm_mod dax btrfs rtsx_pci_sdmmc nvme mmc_core =
nvme_core input_leds led_class xhci_pci atkbd tpm_crb xhci_pci_renesas t1=
0_pi libps2 vivaldi_fmap xhci_hcd sha512_ssse3 ehci_pci crc64_rocksoft eh=
ci_hcd sha512_generic crc64 blake2b_generic crc_t10dif aesni_intel rtsx_p=
ci xor usbcore libaes libcrc32c tpm_tis crct10dif_generic crypto_simd tpm=
_tis_core cryptd crct10dif_pclmul crc32c_generic crc32c_intel tpm mfd_cor=
e crct10dif_common usb_common i8042 rng_core rtc_cmos serio raid6_pq auto=
fs4
> [Sa Jun 17 20:10:09 2023] CPU: 11 PID: 0 Comm: swapper/11 Tainted: G   =
     W          6.3.0 #1-NixOS
> [Sa Jun 17 20:10:09 2023] Hardware name: LENOVO 20UF000LGE/20UF000LGE, =
BIOS R1CET72W(1.41 ) 06/27/2022
> [Sa Jun 17 20:10:09 2023] RIP: 0010:ipc_mux_ul_adb_finish+0x17e/0x290 [=
iosm]
> [Sa Jun 17 20:10:09 2023] Code: 00 00 0f 85 44 ff ff ff b9 08 00 00 00 =
48 c7 c2 a8 1d 20 c1 48 89 ee 48 c7 c7 e0 1c 20 c1 c6 05 e8 e9 00 00 01 e=
8 92 65 ea eb <0f> 0b e9 1b ff ff ff 48 8b 83 b4 02 00 00 c7 00 00 00 00 =
00 0f b7
> [Sa Jun 17 20:10:09 2023] RSP: 0018:ffff9b9b80424ef0 EFLAGS: 00010282
> [Sa Jun 17 20:10:09 2023] RAX: 0000000000000000 RBX: ffff8d1bbe562000 R=
CX: 0000000000000027
> [Sa Jun 17 20:10:09 2023] RDX: ffff8d1e212e14c8 RSI: 0000000000000001 R=
DI: ffff8d1e212e14c0
> [Sa Jun 17 20:10:09 2023] RBP: 0000000000000010 R08: 0000000000000000 R=
09: ffff9b9b80424d98
> [Sa Jun 17 20:10:09 2023] R10: 0000000000000003 R11: ffffffffae938888 R=
12: 0000000000000000
> [Sa Jun 17 20:10:09 2023] R13: 00000000000000d8 R14: ffff8d1bbe5622e4 R=
15: ffff8d1ba1c40108
> [Sa Jun 17 20:10:09 2023] FS:  0000000000000000(0000) GS:ffff8d1e212c00=
00(0000) knlGS:0000000000000000
> [Sa Jun 17 20:10:09 2023] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005=
0033
> [Sa Jun 17 20:10:09 2023] CR2: 000026180d354000 CR3: 0000000033b0c000 C=
R4: 0000000000350ee0
> [Sa Jun 17 20:10:09 2023] Call Trace:
> [Sa Jun 17 20:10:09 2023]  <IRQ>
> [Sa Jun 17 20:10:09 2023]  ipc_imem_tq_adb_timer_cb+0x12/0x20 [iosm]
> [Sa Jun 17 20:10:09 2023]  ipc_task_queue_handler+0xa1/0x100 [iosm]
> [Sa Jun 17 20:10:09 2023]  tasklet_action_common.constprop.0+0x132/0x14=
0
> [Sa Jun 17 20:10:09 2023]  __do_softirq+0xca/0x2ae
> [Sa Jun 17 20:10:09 2023]  __irq_exit_rcu+0xab/0xe0
> [Sa Jun 17 20:10:09 2023]  sysvec_apic_timer_interrupt+0x72/0x90
> [Sa Jun 17 20:10:09 2023]  </IRQ>
> [Sa Jun 17 20:10:09 2023]  <TASK>
> [Sa Jun 17 20:10:09 2023]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [Sa Jun 17 20:10:09 2023] RIP: 0010:cpuidle_enter_state+0xcc/0x440
> [Sa Jun 17 20:10:09 2023] Code: 2a d8 66 ff e8 25 f2 ff ff 8b 53 04 49 =
89 c5 0f 1f 44 00 00 31 ff e8 a3 eb 65 ff 45 84 ff 0f 85 57 02 00 00 fb 0=
f 1f 44 00 00 <45> 85 f6 0f 88 85 01 00 00 49 63 d6 48 8d 04 52 48 8d 04 =
82 49 8d
> [Sa Jun 17 20:10:09 2023] RSP: 0018:ffff9b9b801d7e90 EFLAGS: 00000246
> [Sa Jun 17 20:10:09 2023] RAX: ffff8d1e212f2780 RBX: ffff8d1b83198c00 R=
CX: 0000000000000000
> [Sa Jun 17 20:10:09 2023] RDX: 000000000000000b RSI: 0000000cb4e6e5b9 R=
DI: 0000000000000000
> [Sa Jun 17 20:10:09 2023] RBP: 0000000000000002 R08: 0000000000000004 R=
09: 000000003d113146
> [Sa Jun 17 20:10:09 2023] R10: 0000000000000018 R11: 000000000000055e R=
12: ffffffffae9b3860
> [Sa Jun 17 20:10:09 2023] R13: 0000052a93e6f49a R14: 0000000000000002 R=
15: 0000000000000000
> [Sa Jun 17 20:10:09 2023]  cpuidle_enter+0x2d/0x40
> [Sa Jun 17 20:10:09 2023]  do_idle+0x1bf/0x220
> [Sa Jun 17 20:10:09 2023]  cpu_startup_entry+0x1d/0x20
> [Sa Jun 17 20:10:09 2023]  start_secondary+0x115/0x140
> [Sa Jun 17 20:10:09 2023]  secondary_startup_64_no_verify+0xe5/0xeb
> [Sa Jun 17 20:10:09 2023]  </TASK>
> [Sa Jun 17 20:10:09 2023] ---[ end trace 0000000000000000 ]---
> ```
>=20
> `drivers/net/wwan/iosm/iosm_ipc_mux_codec.c:852` was introduced in 1f52=
d7b622854b8bd7a1be3de095ca2e1f77098e ("net: wwan: iosm: Enable M.2 7360 W=
WAN card support")


See Bugzilla for the full thread.

M Chetan Kumar: Can you take a look on this issue please?

Anyway, to be sure this issue doesn't fall through the cracks unnoticed,
I'm adding it to regzbot:

#regzbot introduced: 1f52d7b622854b https://bugzilla.kernel.org/show_bug.=
cgi?id=3D217569
#regzbot title: field-spanning write (memcpy) detected on Intel XMM7360
#regzbot link: https://gitlab.freedesktop.org/mobile-broadband/ModemManag=
er/-/issues/612

Thanks.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=3D217569

--=20
An old man doll... just what I always wanted! - Clara

