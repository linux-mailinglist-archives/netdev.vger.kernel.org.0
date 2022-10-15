Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1BE5FF914
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 09:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJOHzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 03:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJOHzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 03:55:16 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D8E3054A
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 00:55:12 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id n73so5566290iod.13
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 00:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAuMzPjmqVIn7xBU6udhXeL9GoW7qvzrTN2xPuaLh+Y=;
        b=kGV6SKBcYjbfpCcQ32uaHVp9bQbhaUwllgfq2iNjNiuf/jhLgbuhiWbaEX/xlc2G+X
         D4iNsTwBASgKPh0eBoy9MVRn9kW1JgyXS6oonzL7ADuimKvKTX6Iw9S/7WCTOICVGA6g
         ryrAUQm/jyAvXiFuGPoi/zYgPUDxN0Rfgn8/1yC/3Be2HQku5A6dqjkrJV4g55b5dTeE
         6vwXaqc/4yZFe68Bj26seAKzoFdcl+i7sJOBy01zvHMbXtWXmKU4sjHYIshH7Nk+NJwb
         X0sG7G7IHCKUORaEFZW7BWkgC+0VDkYWvGq/VX+Eves8oqQZFnJLS+L7TtrP6xJR9D/x
         ESVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAuMzPjmqVIn7xBU6udhXeL9GoW7qvzrTN2xPuaLh+Y=;
        b=PoceZN/+wAK0y4WQSDEvEET0vl0hsl78BplW36eqsh2VXdEE8OH3UD+DXzjYue9GJH
         9OZqZLhrO+BGNBVANBUl7h97OlLtkxNqiQSoNh1Yz5yg4q2BqY5qql3P1s2T/CcOGsRM
         gABALK5XV6IJcRbhByKsJDc9dIOeO4qQVya1JHqMtohzTF2XoBYwASLsLgaAvxjpWceI
         8x0ivRftU7gaxPW7M/0/VfG4SJxualYfT+aLgUufcwHtnNKaXDODS5VVEFVH7H+iiP2W
         mcnh31nB3ck9MuAmGVaHTv1p3fxBl72UE+ErbSy2/wUUA7UW9oDgVIyZtkWjL1veey3C
         4I4A==
X-Gm-Message-State: ACrzQf2lW13NfKJi6wfwkvkBX7KA3n8Dkn3beyQhgA73yVCIvCPvnXTY
        pJvxETg2uyN3EOUTdByZ5Iub9xszPyWnHLMhKi0=
X-Google-Smtp-Source: AMsMyM6+cA4AWRK2IrXh5aZEv91+m3CH4n4AFS+8fM2dlSHUDzgExFojEOF19euOf6ZNXgR/ztb1w+Ar767qrl7ZDU4=
X-Received: by 2002:a05:6638:d04:b0:363:ec0b:8d7d with SMTP id
 q4-20020a0566380d0400b00363ec0b8d7dmr791988jaj.169.1665820511366; Sat, 15 Oct
 2022 00:55:11 -0700 (PDT)
MIME-Version: 1.0
References: <20221014093632.8487-1-hdegoede@redhat.com>
In-Reply-To: <20221014093632.8487-1-hdegoede@redhat.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 15 Oct 2022 11:55:10 +0400
Message-ID: <CAHNKnsSvvM3_JEdr1znAWTup-LG-A=cuO8h-A8G6Cwf=h_rjNQ@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: iosm: initialize pc_wwan->if_mutex earlier
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 1:36 PM Hans de Goede <hdegoede@redhat.com> wrote:
> wwan_register_ops() ends up calls ipc_wwan_newlink() before it returns.
>
> ipc_wwan_newlink() uses pc_wwan->if_mutex, so we must initialize it
> before calling wwan_register_ops(). This fixes the following WARN()
> when lock-debugging is enabled:
>
> [  610.708713] ------------[ cut here ]------------
> [  610.708721] DEBUG_LOCKS_WARN_ON(lock->magic !=3D lock)
> [  610.708727] WARNING: CPU: 11 PID: 506 at kernel/locking/mutex.c:582 __=
mutex_lock+0x3e4/0x7e0
> [  610.708736] Modules linked in: iosm snd_seq_dummy snd_hrtimer rfcomm q=
rtr bnep binfmt_misc snd_ctl_led snd_soc_skl_hda_dsp snd_soc_intel_hda_dsp_=
common snd_soc_hdac_hdmi snd_sof_probes snd_soc_dmic iTCO_wdt intel_pmc_bxt=
 mei_hdcp mei_pxp iTCO_vendor_support pmt_telemetry intel_rapl_msr pmt_clas=
s intel_tcc_cooling x86_pkg_temp_thermal intel_powerclamp coretemp kvm_inte=
l kvm irqbypass rapl intel_cstate intel_uncore pcspkr think_lmi firmware_at=
tributes_class wmi_bmof snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_co=
dec_generic snd_sof_pci_intel_tgl snd_sof_intel_hda_common soundwire_intel =
soundwire_generic_allocation soundwire_cadence snd_sof_intel_hda snd_sof_pc=
i snd_sof_xtensa_dsp snd_sof snd_sof_utils snd_soc_hdac_hda snd_hda_ext_cor=
e snd_soc_acpi_intel_match snd_soc_acpi soundwire_bus snd_soc_core snd_comp=
ress ac97_bus snd_pcm_dmaengine snd_hda_intel snd_intel_dspcfg snd_intel_sd=
w_acpi snd_hda_codec snd_hda_core iwlmvm snd_hwdep snd_seq btusb snd_seq_de=
vice btrtl btbcm snd_pcm
> [  610.708767]  btintel mei_me mac80211 i2c_i801 btmtk libarc4 i2c_smbus =
snd_timer mei bluetooth hid_sensor_gyro_3d iwlwifi hid_sensor_accel_3d idma=
64 hid_sensor_trigger hid_sensor_iio_common ecdh_generic industrialio_trigg=
ered_buffer kfifo_buf cfg80211 joydev industrialio int3403_thermal soc_butt=
on_array ov2740 v4l2_fwnode v4l2_async videodev mc intel_skl_int3472_tps684=
70 tps68470_regulator clk_tps68470 intel_skl_int3472_discrete intel_hid spa=
rse_keymap int3400_thermal acpi_thermal_rel acpi_tad acpi_pad vfat fat proc=
essor_thermal_device_pci processor_thermal_device processor_thermal_rfim pr=
ocessor_thermal_mbox processor_thermal_rapl thunderbolt intel_rapl_common i=
ntel_vsec int340x_thermal_zone igen6_edac zram dm_crypt hid_sensor_hub inte=
l_ishtp_hid i915 thinkpad_acpi drm_buddy drm_display_helper snd soundcore l=
edtrig_audio crct10dif_pclmul wacom platform_profile crc32_pclmul cec nvme =
intel_ish_ipc rfkill crc32c_intel ucsi_acpi hid_multitouch serio_raw typec_=
ucsi ghash_clmulni_intel
> [  610.708798]  nvme_core video intel_ishtp ttm typec i2c_hid_acpi i2c_hi=
d wmi pinctrl_tigerlake ip6_tables ip_tables i2c_dev fuse
> [  610.708806] CPU: 11 PID: 506 Comm: kworker/11:2 Tainted: G        W   =
       6.0.0+ #505
> [  610.708809] Hardware name: LENOVO 21CEZ9Q3US/21CEZ9Q3US, BIOS N3AET66W=
 (1.31 ) 09/09/2022
> [  610.708811] Workqueue: events ipc_imem_run_state_worker [iosm]
> [  610.708831] RIP: 0010:__mutex_lock+0x3e4/0x7e0
> [  610.708836] Code: ff 85 c0 0f 84 9b fc ff ff 8b 15 6f 54 11 01 85 d2 0=
f 85 8d fc ff ff 48 c7 c6 f0 f0 84 94 48 c7 c7 83 07 83 94 e8 91 33 f8 ff <=
0f> 0b e9 73 fc ff ff f6 83 d1 0c 00 00 01 0f 85 4b ff ff ff 4c 89
> [  610.708837] RSP: 0018:ffffaf0b80767a50 EFLAGS: 00010282
> [  610.708840] RAX: 0000000000000028 RBX: 0000000000000000 RCX: 000000000=
0000000
> [  610.708841] RDX: 0000000000000001 RSI: ffffffff948b357c RDI: 00000000f=
fffffff
> [  610.708842] RBP: ffffaf0b80767ae0 R08: 0000000000000000 R09: ffffaf0b8=
0767900
> [  610.708843] R10: 0000000000000003 R11: ffff9c191b7fffe8 R12: 000000000=
0000002
> [  610.708845] R13: 0000000000000000 R14: ffff9c16a3044450 R15: ffff9c15e=
342ce40
> [  610.708846] FS:  0000000000000000(0000) GS:ffff9c18fd6c0000(0000) knlG=
S:0000000000000000
> [  610.708848] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  610.708849] CR2: 00001d40ba7bd008 CR3: 00000001d6c26002 CR4: 000000000=
0770ee0
> [  610.708850] PKRU: 55555554
> [  610.708851] Call Trace:
> [  610.708852]  <TASK>
> [  610.708856]  ? ipc_wwan_newlink+0x46/0xb0 [iosm]
> [  610.708862]  ? wwan_port_fops_read+0x1b0/0x1b0
> [  610.708867]  ? ipc_wwan_newlink+0x46/0xb0 [iosm]
> [  610.708872]  ipc_wwan_newlink+0x46/0xb0 [iosm]
> [  610.708877]  wwan_rtnl_newlink+0x7e/0xd0
> [  610.708880]  wwan_create_default_link+0x24c/0x2e0
> [  610.708890]  wwan_register_ops+0x71/0x90
> [  610.708893]  ipc_wwan_init+0x48/0x90 [iosm]
> [  610.708897]  ipc_imem_wwan_channel_init+0x81/0xa0 [iosm]
> [  610.708902]  ipc_imem_run_state_worker+0xab/0x1b0 [iosm]
> [  610.708907]  process_one_work+0x254/0x570
> [  610.708914]  worker_thread+0x4f/0x3a0
> [  610.708917]  ? process_one_work+0x570/0x570
> [  610.708919]  kthread+0xf2/0x120
> [  610.708922]  ? kthread_complete_and_exit+0x20/0x20
> [  610.708924]  ret_from_fork+0x1f/0x30
> [  610.708931]  </TASK>
> [  610.708931] irq event stamp: 89949
> [  610.708933] hardirqs last  enabled at (89949): [<ffffffff93ebc630>] _r=
aw_spin_unlock_irqrestore+0x30/0x60
> [  610.708936] hardirqs last disabled at (89948): [<ffffffff93ebc3bf>] _r=
aw_spin_lock_irqsave+0x5f/0x70
> [  610.708938] softirqs last  enabled at (89876): [<ffffffff93bc2509>] __=
netdev_alloc_skb+0xe9/0x150
> [  610.708942] softirqs last disabled at (89874): [<ffffffff93bc2509>] __=
netdev_alloc_skb+0xe9/0x150
> [  610.708944] ---[ end trace 0000000000000000 ]---
>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Should we add a Fixes: tag for this change? Besides this:

Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
