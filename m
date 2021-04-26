Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52A336ADB5
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 09:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhDZHiG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Apr 2021 03:38:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40158 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbhDZHhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 03:37:19 -0400
Received: from mail-wr1-f70.google.com ([209.85.221.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <chia-lin.kao@canonical.com>)
        id 1lavnI-00054p-J8
        for netdev@vger.kernel.org; Mon, 26 Apr 2021 07:36:36 +0000
Received: by mail-wr1-f70.google.com with SMTP id 65-20020adf82c70000b0290107593a42c3so6971703wrc.5
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 00:36:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Hv+x9onO5eW3FH66okgrjnOSHrmS6UheiLB3gLXIK+w=;
        b=FSDkL7zXkpWQdhVbSnbebh8WYezhZRGxD5BsnKiWljPOslYozDhN8KwySlKLYEzdBh
         Gh4IjX4b1yeTGm4zwvbGD1VohqaK+mwqlycffniX/n7v+ejQfhYaoVPKkZhRkj3TNuZm
         0MRkB7/CXOHtOd1PMtTV9R3euEYkym85aXSIRROi9+P0OoYKPlMQFO+GiKS3HDZVhYjr
         Vw6031CGeLc9UKVW1I4NTeIIfmB6axk1ZI91RxmMWgvq9uV4ZZWZ4zql4QdsjT81IFTU
         DZOdVHwg+BSizjanc5CuV5EgD3oebejhmNLMQK4liI9OOWMnP/Ztg07elQxg5lYOAKIK
         JI5g==
X-Gm-Message-State: AOAM5323N9QaHE35JBkSzhQE5gxlLYNYwnLzRbvB4e/VUFDA+7f6ws0I
        iN8W+E+gUi0qbOsZH3qoSiNIdxK1HleClzzN5lyV9hNZFfQP0neif8/MTGCBTxh6yEzoFgXGvSN
        CSssTSL2/SBp9NvohVXxeq/hIFVI1NVOWXm24Y3LDUlA4ncDFxA==
X-Received: by 2002:a5d:47cc:: with SMTP id o12mr21081337wrc.227.1619422596220;
        Mon, 26 Apr 2021 00:36:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhwcdZzB8GkvUdRs2ccBExeFVZENZacqcgKr0wB1V2ISehY8nuzd47yhJf5GCDjjSt1zvi3p8kCOXUjV4T6Dc=
X-Received: by 2002:a5d:47cc:: with SMTP id o12mr21081311wrc.227.1619422595990;
 Mon, 26 Apr 2021 00:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210420075406.64105-1-acelan.kao@canonical.com>
 <CANn89iJLSmtBNoDo8QJ6a0MzsHjdLB0Pf=cs9e4g8Y6-KuFiMQ@mail.gmail.com>
 <20210420122715.2066b537@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFv23Q=ywiuZp7Y=bj=SAZmDdAnanAXA954hdO3GpkjmDo=RpQ@mail.gmail.com>
 <c10a6c72-9db7-18c8-6b03-1f8c40b8fd87@gmail.com> <CAFv23QkUsTf5M0MoUEFNYeFCtShAn3EmA3u8vXVeZyJa20Bx=g@mail.gmail.com>
 <f06e0e2b-c6bb-ef5a-f629-d1ab82b7aee2@gmail.com>
In-Reply-To: <f06e0e2b-c6bb-ef5a-f629-d1ab82b7aee2@gmail.com>
From:   AceLan Kao <acelan.kao@canonical.com>
Date:   Mon, 26 Apr 2021 15:36:24 +0800
Message-ID: <CAFv23Qnf3aJQyXyDbb_nvq2XU8t9Gy5sLFyzM251-FU_qBBUjw@mail.gmail.com>
Subject: Re: [PATCH] net: called rtnl_unlock() before runpm resumes devices
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> 於 2021年4月25日 週日 上午4:07寫道：
>
> On 23.04.2021 05:42, AceLan Kao wrote:
> > Heiner Kallweit <hkallweit1@gmail.com> 於 2021年4月22日 週四 下午3:09寫道：
> >>
> >> On 22.04.2021 08:30, AceLan Kao wrote:
> >>> Yes, should add
> >>>
> >>> Fixes: 9474933caf21 ("igb: close/suspend race in netif_device_detach")
> >>> and also
> >>> Fixes: 9513d2a5dc7f ("igc: Add legacy power management support")
> >>>
> >> Please don't top-post. Apart from that:
> >> If the issue was introduced with driver changes, then adding a workaround
> >> in net core may not be the right approach.
> > It's hard to say who introduces this issue, we probably could point
> > our finger to below commit
> > bd869245a3dc net: core: try to runtime-resume detached device in __dev_open
> >
> > This calling path is not usual, in my case, the NIC is not plugged in
> > any Ethernet cable,
> > and we are doing networking tests on another NIC on the system. So,
> > remove the rtnl lock from igb driver will affect other scenarios.
> >
> >>
> >>> Jakub Kicinski <kuba@kernel.org> 於 2021年4月21日 週三 上午3:27寫道：
> >>>>
> >>>> On Tue, 20 Apr 2021 10:34:17 +0200 Eric Dumazet wrote:
> >>>>> On Tue, Apr 20, 2021 at 9:54 AM AceLan Kao <acelan.kao@canonical.com> wrote:
> >>>>>>
> >>>>>> From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
> >>>>>>
> >>>>>> The rtnl_lock() has been called in rtnetlink_rcv_msg(), and then in
> >>>>>> __dev_open() it calls pm_runtime_resume() to resume devices, and in
> >>>>>> some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
> >>>>>> again. That leads to a recursive lock.
> >>>>>>
> >>>>>> It should leave the devices' resume function to decide if they need to
> >>>>>> call rtnl_lock()/rtnl_unlock(), so call rtnl_unlock() before calling
> >>>>>> pm_runtime_resume() and then call rtnl_lock() after it in __dev_open().
> >>>>>>
> >>>>>>
> >>>>>
> >>>>> Hi Acelan
> >>>>>
> >>>>> When was the bugg added ?
> >>>>> Please add a Fixes: tag
> >>>>
> >>>> For immediate cause probably:
> >>>>
> >>>> Fixes: 9474933caf21 ("igb: close/suspend race in netif_device_detach")
> >>>>
> >>>>> By doing so, you give more chances for reviewers to understand why the
> >>>>> fix is not risky,
> >>>>> and help stable teams work.
> >>>>
> >>>> IMO the driver lacks internal locking. Taking 看rtnl from resume is just
> >>>> one example, git history shows many more places that lacked locking and
> >>>> got papered over with rtnl here.
> >>
>
> You could alternatively try the following. It should avoid the deadlock,
> and when runtime-resuming if __IGB_DOWN is set all we do is marking the
> net_device as present (because of PCI D3 -> D0 transition).
> I do basically the same in r8169 and it works as intended.
>
> Disclaimer: I don't have an igb-driven device and therefore can't test
> the proposal.
>
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 038a9fd1a..21436626a 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -9300,6 +9300,14 @@ static int __maybe_unused igb_runtime_suspend(struct device *dev)
>
>  static int __maybe_unused igb_runtime_resume(struct device *dev)
>  {
> +       struct net_device *netdev = dev_get_drvdata(dev);
> +       struct igb_adapter *adapter = netdev_priv(netdev);
> +
> +       if (test_bit(__IGB_DOWN, &adapter->state)) {
> +               netif_device_attach(netdev);
> +               return 0;
> +       }
> +
>         return igb_resume(dev);
>  }
>
> --
> 2.31.1
>

Hi Heiner,

I encountered below error after applied your patch.

[  121.489970] u kernel: ------------[ cut here ]------------
[  121.489979] u kernel: igb 0000:05:00.0: disabling already-disabled device
[  121.490008] u kernel: WARNING: CPU: 7 PID: 258 at
drivers/pci/pci.c:2146 pci_disable_device+0x91/0xb0
[  121.490028] u kernel: Modules linked in: rfcomm cmac algif_hash
algif_skcipher af_alg bnep btusb btrtl btbcm btintel bluetooth
ecdh_generic ecc joydev input_leds inte
l_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp
coretemp ath10k_pci ath10k_core kvm_intel ath mac80211 kvm
snd_sof_pci_intel_tgl snd_soc_acpi_intel_ma
tch snd_sof_intel_hda_common nls_iso8859_1 soundwire_intel
soundwire_generic_allocation soundwire_cadence soundwire_bus
snd_sof_pci snd_soc_acpi snd_sof snd_soc_core snd
_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi
crct10dif_pclmul crc32_pclmul snd_sof_xtensa_dsp ghash_clmulni_intel
ledtrig_audio aesni_intel snd_hda_intel
libarc4 crypto_simd snd_intel_dspcfg snd_intel_sdw_acpi cryptd
snd_hda_codec cfg80211 mei_hdcp snd_hwdep snd_hda_core
intel_wmi_thunderbolt snd_pcm wmi_bmof snd_seq inte
l_cstate efi_pstore snd_timer snd_seq_device ee1004 mei_me snd mei
ucsi_acpi soundcore typec_ucsi typec wmi mac_hid acpi_pad acpi_tad
sch_fq_codel
[  121.490314] u kernel:  parport_pc ppdev lp parport ip_tables
x_tables autofs4 btrfs blake2b_generic zstd_compress raid10 raid456
async_raid6_recov async_memcpy async_
pq async_xor async_tx libcrc32c xor raid6_pq raid1 raid0 multipath
linear hid_generic usbhid hid i915 drm_kms_helper syscopyarea
sysfillrect sysimgblt fb_sys_fops cec rc
_core igb drm nvme e1000e nvme_core i2c_i801 dca i2c_smbus
i2c_algo_bit intel_lpss_pci intel_lpss ahci idma64 video xhci_pci
libahci virt_dma xhci_pci_renesas pinctrl_ti
gerlake
[  121.490508] u kernel: CPU: 7 PID: 258 Comm: kworker/7:2 Tainted: G
   U            5.12.0-rc7+ #79
[  121.490518] u kernel: Hardware name: Dell Inc. OptiPlex 7090/, BIOS
0.12.80 02/23/2021
[  121.490525] u kernel: Workqueue: pm pm_runtime_work
[  121.490540] u kernel: RIP: 0010:pci_disable_device+0x91/0xb0
[  121.490550] u kernel: Code: 4d 85 e4 75 07 4c 8b a3 c8 00 00 00 48
8d bb c8 00 00 00 e8 61 8d 17 00 4c 89 e2 48 c7 c7 60 5a e0 a5 48 89
c6 e8 9b a3 59 00 <0f> 0b eb 8
d 48 89 df e8 e3 fe ff ff 80 a3 49 0a 00 00 df 5b 41 5c
[  121.490558] u kernel: RSP: 0018:ffffb76b4169fc90 EFLAGS: 00010286
[  121.490569] u kernel: RAX: 0000000000000000 RBX: ffff9e2581ee6000
RCX: 0000000000000027
[  121.490576] u kernel: RDX: 0000000000000027 RSI: ffffffffa493bca0
RDI: ffff9e27073e89b8
[  121.490582] u kernel: RBP: ffffb76b4169fca0 R08: ffff9e27073e89b0
R09: 0000000000000000
[  121.490588] u kernel: R10: 0000000000000000 R11: 0000000000000001
R12: ffff9e2581af7c80
[  121.490594] u kernel: R13: ffff9e2581ee6000 R14: ffff9e25a0914000
R15: ffff9e25a0915280
[  121.490600] u kernel: FS:  0000000000000000(0000)
GS:ffff9e2707200000(0000) knlGS:0000000000000000
[  121.490608] u kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  121.490614] u kernel: CR2: 00007ff86ec8d024 CR3: 0000000189c28002
CR4: 0000000000770ee0
[  121.490621] u kernel: PKRU: 55555554
[  121.490626] u kernel: Call Trace:
[  121.490638] u kernel:  __igb_shutdown+0xf2/0x1c0 [igb]
[  121.490676] u kernel:  igb_runtime_suspend+0x1c/0x20 [igb]
[  121.490703] u kernel:  pci_pm_runtime_suspend+0x63/0x180
[  121.490715] u kernel:  ? pci_pm_runtime_resume+0x90/0x90
[  121.490727] u kernel:  __rpm_callback+0xc7/0x140
[  121.490740] u kernel:  rpm_callback+0x57/0x80
[  121.490750] u kernel:  ? pci_pm_runtime_resume+0x90/0x90
[  121.490759] u kernel:  rpm_suspend+0x119/0x640
[  121.490774] u kernel:  pm_runtime_work+0x64/0xc0
[  121.490784] u kernel:  process_one_work+0x2af/0x5d0
[  121.490803] u kernel:  worker_thread+0x4d/0x3e0
[  121.490814] u kernel:  ? process_one_work+0x5d0/0x5d0
[  121.490825] u kernel:  kthread+0x12a/0x160
[  121.490834] u kernel:  ? kthread_park+0x90/0x90
[  121.490844] u kernel:  ret_from_fork+0x1f/0x30
[  121.490867] u kernel: irq event stamp: 0[  121.490871] u kernel:
hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[  121.490916] u kernel: hardirqs last disabled at (0):
[<ffffffffa489ea44>] copy_process+0x714/0x1cc0
[  121.490929] u kernel: softirqs last  enabled at (0):
[<ffffffffa489ea44>] copy_process+0x714/0x1cc0
[  121.490938] u kernel: softirqs last disabled at (0): [<0000000000000000>] 0x0
[  121.490949] u kernel: ---[ end trace a9c7ffc27c226979 ]---
