Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830ED3D1177
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238885AbhGUNzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbhGUNzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 09:55:35 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2441C061575;
        Wed, 21 Jul 2021 07:36:10 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 42-20020a9d012d0000b02904b98d90c82cso2241506otu.5;
        Wed, 21 Jul 2021 07:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jb//JA0HCehT+ryTpbbhEgNEGTC456eMZeBfSEzmc1w=;
        b=WQL1YTyH9Fi7gcKwTGq1psAt+IdH/cU6PV/LEEcnvhUv/3FG/MdRKFO3WnjJOcohpb
         nknCyEeXw4AkO7lX32FiC/ryqimhK7i82AwqMBuBuYGXDZ9A8sWj/QPUaMeGna/dtxj/
         CMwFvE9RqBtue0aNSGsPiOah6YK8HzgQ/0jyTuRr4fjI4EGbUTQ5pTUtaglZAHyQIONR
         DYE6bmHR2JShkwqN+UJtKtk2KpuG53PhIT3A2lRC4Ep/hlHX2dJxwrQlTBJUNlxmyU/U
         DHl8gPshd4SnZhtz26unPkfCSyCypXJDQgfBK2pKrgDM4kz1tVbEmRc8ILIwYdyTvvuX
         8Bhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jb//JA0HCehT+ryTpbbhEgNEGTC456eMZeBfSEzmc1w=;
        b=FTRJs7IyztDRRAFtjmjgt5xomJvPYF7Ho87VUFFhtGBC6Uh+hSqbHiE4u9cjRNOeKK
         +Gf/gZUqU2H+SNEoe1EZND1UNsDfsjTyIcvP1RD0qgd+jlXMse3lVvwdrGqAqTbo2KDA
         ZOA1uRcXWMbisM3tQeH76ut945elR8ST73hd11NqVmXhLfD7RqzNZnMsZZSPPNKyo9cB
         0A94DvngeaWPZkQKv4UYn8+v52IqM1FCDBCkSYxEnVqC5oymmuWgBSakBwfoS1y5kJve
         644u4579lxDkSEBSSmdNJqV2FkFB3ienVrSi0y+vTegQ/0gmZDGBpkxXxd27gKcVQomP
         2E/Q==
X-Gm-Message-State: AOAM532x+L9ktn31wVNtVg+eEHkM5fCBSnVL6ZnDfme8xzCKuRnIiUQh
        KXIUR2954o5f9HwN9PVxwMEBrUgoPSrldwwv+Fo=
X-Google-Smtp-Source: ABdhPJzElHKkv6pbiZK6/Z+v9k7EoyFqJh/QCfKga0NBCGjPSYlvzX5wuz9QJ9aBOf0j3Nbn1uebTBgMIOAag3b7vuk=
X-Received: by 2002:a05:6830:1c2f:: with SMTP id f15mr16186401ote.23.1626878170040;
 Wed, 21 Jul 2021 07:36:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210720172216.59613-1-kai.heng.feng@canonical.com>
In-Reply-To: <20210720172216.59613-1-kai.heng.feng@canonical.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 21 Jul 2021 10:35:59 -0400
Message-ID: <CADnq5_NH-zKwwgfhT5uDwzoVGZgRfK8p4v2AVNvWmPcQAUzYsg@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu/acp: Make PM domain really work
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     "Deucher, Alexander" <alexander.deucher@amd.com>,
        Christian Koenig <christian.koenig@amd.com>,
        xinhui pan <Xinhui.Pan@amd.com>,
        Song Liu <songliubraving@fb.com>,
        Maruthi Srinivas Bayyavarapu <Maruthi.Bayyavarapu@amd.com>,
        Deepak R Varma <mh12gx2825@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "open list:RADEON and AMDGPU DRM DRIVERS" 
        <amd-gfx@lists.freedesktop.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Nirmoy Das <nirmoy.das@amd.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        "open list:BPF Safe dynamic programs and tools" 
        <netdev@vger.kernel.org>, KP Singh <kpsingh@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        "open list:BPF Safe dynamic programs and tools" <bpf@vger.kernel.org>,
        Evan Quan <evan.quan@amd.com>,
        Lee Jones <lee.jones@linaro.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Applied.  Thanks!  I've removed the unused variables when I applied.

Alex

On Tue, Jul 20, 2021 at 1:31 PM Kai-Heng Feng
<kai.heng.feng@canonical.com> wrote:
>
> Devices created by mfd_add_hotplug_devices() don't really increase the
> index of its name, so get_mfd_cell_dev() cannot find any device, hence a
> NULL dev is passed to pm_genpd_add_device():
> [   56.974926] (NULL device *): amdgpu: device acp_audio_dma.0.auto added=
 to pm domain
> [   56.974933] (NULL device *): amdgpu: Failed to add dev to genpd
> [   56.974941] [drm:amdgpu_device_ip_init [amdgpu]] *ERROR* hw_init of IP=
 block <acp_ip> failed -22
> [   56.975810] amdgpu 0000:00:01.0: amdgpu: amdgpu_device_ip_init failed
> [   56.975839] amdgpu 0000:00:01.0: amdgpu: Fatal error during GPU init
> [   56.977136] ------------[ cut here ]------------
> [   56.977143] kernel BUG at mm/slub.c:4206!
> [   56.977158] invalid opcode: 0000 [#1] SMP NOPTI
> [   56.977167] CPU: 1 PID: 1648 Comm: modprobe Not tainted 5.12.0-051200r=
c8-generic #202104182230
> [   56.977175] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.=
M./FM2A68M-HD+, BIOS P5.20 02/13/2019
> [   56.977180] RIP: 0010:kfree+0x3bf/0x410
> [   56.977195] Code: 89 e7 48 d3 e2 f7 da e8 5f 0d 02 00 80 e7 02 75 3e 4=
4 89 ee 4c 89 e7 e8 ef 5f fd ff e9 fa fe ff ff 49 8b 44 24 08 a8 01 75 b7 <=
0f> 0b 4c 8b 4d b0 48 8b 4d a8 48 89 da 4c 89 e6 41 b8 01 00 00 00
> [   56.977202] RSP: 0018:ffffa48640ff79f0 EFLAGS: 00010246
> [   56.977210] RAX: 0000000000000000 RBX: ffff9286127d5608 RCX: 000000000=
0000000
> [   56.977215] RDX: 0000000000000000 RSI: ffffffffc099d0fb RDI: ffff92861=
27d5608
> [   56.977220] RBP: ffffa48640ff7a48 R08: 0000000000000001 R09: 000000000=
0000001
> [   56.977224] R10: 0000000000000000 R11: ffff9286087d8458 R12: fffff3ae0=
449f540
> [   56.977229] R13: 0000000000000000 R14: dead000000000122 R15: dead00000=
0000100
> [   56.977234] FS:  00007f9de5929540(0000) GS:ffff928612e80000(0000) knlG=
S:0000000000000000
> [   56.977240] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   56.977245] CR2: 00007f697dd97160 CR3: 00000001110f0000 CR4: 000000000=
01506e0
> [   56.977251] Call Trace:
> [   56.977261]  amdgpu_dm_encoder_destroy+0x1b/0x30 [amdgpu]
> [   56.978056]  drm_mode_config_cleanup+0x4f/0x2e0 [drm]
> [   56.978147]  ? kfree+0x3dd/0x410
> [   56.978157]  ? drm_managed_release+0xc8/0x100 [drm]
> [   56.978232]  drm_mode_config_init_release+0xe/0x10 [drm]
> [   56.978311]  drm_managed_release+0x9d/0x100 [drm]
> [   56.978388]  devm_drm_dev_init_release+0x4d/0x70 [drm]
> [   56.978450]  devm_action_release+0x15/0x20
> [   56.978459]  release_nodes+0x77/0xc0
> [   56.978469]  devres_release_all+0x3f/0x50
> [   56.978477]  really_probe+0x245/0x460
> [   56.978485]  driver_probe_device+0xe9/0x160
> [   56.978492]  device_driver_attach+0xab/0xb0
> [   56.978499]  __driver_attach+0x8f/0x150
> [   56.978506]  ? device_driver_attach+0xb0/0xb0
> [   56.978513]  bus_for_each_dev+0x7e/0xc0
> [   56.978521]  driver_attach+0x1e/0x20
> [   56.978528]  bus_add_driver+0x135/0x1f0
> [   56.978534]  driver_register+0x91/0xf0
> [   56.978540]  __pci_register_driver+0x54/0x60
> [   56.978549]  amdgpu_init+0x77/0x1000 [amdgpu]
> [   56.979246]  ? 0xffffffffc0dbc000
> [   56.979254]  do_one_initcall+0x48/0x1d0
> [   56.979265]  ? kmem_cache_alloc_trace+0x120/0x230
> [   56.979274]  ? do_init_module+0x28/0x280
> [   56.979282]  do_init_module+0x62/0x280
> [   56.979288]  load_module+0x71c/0x7a0
> [   56.979296]  __do_sys_finit_module+0xc2/0x120
> [   56.979305]  __x64_sys_finit_module+0x1a/0x20
> [   56.979311]  do_syscall_64+0x38/0x90
> [   56.979319]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   56.979328] RIP: 0033:0x7f9de54f989d
> [   56.979335] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 4=
8 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <=
48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 f5 0c 00 f7 d8 64 89 01 48
> [   56.979342] RSP: 002b:00007ffe3c395a28 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000139
> [   56.979350] RAX: ffffffffffffffda RBX: 0000560df3ef4330 RCX: 00007f9de=
54f989d
> [   56.979355] RDX: 0000000000000000 RSI: 0000560df3a07358 RDI: 000000000=
000000f
> [   56.979360] RBP: 0000000000040000 R08: 0000000000000000 R09: 000000000=
0000000
> [   56.979365] R10: 000000000000000f R11: 0000000000000246 R12: 0000560df=
3a07358
> [   56.979369] R13: 0000000000000000 R14: 0000560df3ef4460 R15: 0000560df=
3ef4330
> [   56.979377] Modules linked in: amdgpu(+) iommu_v2 gpu_sched drm_ttm_he=
lper ttm drm_kms_helper cec rc_core i2c_algo_bit fb_sys_fops syscopyarea sy=
sfillrect sysimgblt nft_counter xt_tcpudp ipt_REJECT nf_reject_ipv4 xt_conn=
track iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 iptable=
_mangle iptable_raw iptable_security ip_set nf_tables libcrc32c nfnetlink i=
p6_tables iptable_filter bpfilter input_leds binfmt_misc edac_mce_amd kvm_a=
md ccp kvm snd_hda_codec_realtek snd_hda_codec_generic crct10dif_pclmul snd=
_hda_codec_hdmi ledtrig_audio ghash_clmulni_intel aesni_intel snd_hda_intel=
 snd_intel_dspcfg snd_seq_midi crypto_simd snd_intel_sdw_acpi cryptd snd_hd=
a_codec snd_seq_midi_event snd_rawmidi snd_hda_core snd_hwdep snd_seq fam15=
h_power k10temp snd_pcm snd_seq_device snd_timer snd mac_hid soundcore sch_=
fq_codel nct6775 hwmon_vid drm ip_tables x_tables autofs4 dm_mirror dm_regi=
on_hash dm_log hid_generic usbhid hid uas usb_storage r8169 crc32_pclmul re=
altek ahci xhci_pci i2c_piix4
> [   56.979521]  xhci_pci_renesas libahci video
> [   56.979541] ---[ end trace cb8f6a346f18da7b ]---
>
> Instead of finding MFD hotplugged device by its name, simply iterate
> over the child devices to avoid the issue.
>
> BugLink: https://bugs.launchpad.net/bugs/1920674
> Fixes: 25030321ba28 ("drm/amd: add pm domain for ACP IP sub blocks")
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c | 49 +++++++++++++------------
>  1 file changed, 25 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c b/drivers/gpu/drm/am=
d/amdgpu/amdgpu_acp.c
> index b8655ff73a658..8522f46d5d725 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
> @@ -160,17 +160,28 @@ static int acp_poweron(struct generic_pm_domain *ge=
npd)
>         return 0;
>  }
>
> -static struct device *get_mfd_cell_dev(const char *device_name, int r)
> +static int acp_genpd_add_device(struct device *dev, void *data)
>  {
> -       char auto_dev_name[25];
> -       struct device *dev;
> +       struct generic_pm_domain *gpd =3D data;
> +       int ret;
> +
> +       ret =3D pm_genpd_add_device(gpd, dev);
> +       if (ret)
> +               dev_err(dev, "Failed to add dev to genpd %d\n", ret);
>
> -       snprintf(auto_dev_name, sizeof(auto_dev_name),
> -                "%s.%d.auto", device_name, r);
> -       dev =3D bus_find_device_by_name(&platform_bus_type, NULL, auto_de=
v_name);
> -       dev_info(dev, "device %s added to pm domain\n", auto_dev_name);
> +       return ret;
> +}
>
> -       return dev;
> +static int acp_genpd_remove_device(struct device *dev, void *data)
> +{
> +       int ret;
> +
> +       ret =3D pm_genpd_remove_device(dev);
> +       if (ret)
> +               dev_err(dev, "Failed to remove dev from genpd %d\n", ret)=
;
> +
> +       /* Continue to remove */
> +       return 0;
>  }
>
>  /**
> @@ -341,15 +352,10 @@ static int acp_hw_init(void *handle)
>         if (r)
>                 goto failure;
>
> -       for (i =3D 0; i < ACP_DEVS ; i++) {
> -               dev =3D get_mfd_cell_dev(adev->acp.acp_cell[i].name, i);
> -               r =3D pm_genpd_add_device(&adev->acp.acp_genpd->gpd, dev)=
;
> -               if (r) {
> -                       dev_err(dev, "Failed to add dev to genpd\n");
> -                       goto failure;
> -               }
> -       }
> -
> +       r =3D device_for_each_child(adev->acp.parent, &adev->acp.acp_genp=
d->gpd,
> +                                 acp_genpd_add_device);
> +       if (r)
> +               goto failure;
>
>         /* Assert Soft reset of ACP */
>         val =3D cgs_read_register(adev->acp.cgs_device, mmACP_SOFT_RESET)=
;
> @@ -458,13 +464,8 @@ static int acp_hw_fini(void *handle)
>                 udelay(100);
>         }
>
> -       for (i =3D 0; i < ACP_DEVS ; i++) {
> -               dev =3D get_mfd_cell_dev(adev->acp.acp_cell[i].name, i);
> -               ret =3D pm_genpd_remove_device(dev);
> -               /* If removal fails, dont giveup and try rest */
> -               if (ret)
> -                       dev_err(dev, "remove dev from genpd failed\n");
> -       }
> +       device_for_each_child(adev->acp.parent, NULL,
> +                             acp_genpd_remove_device);
>
>         mfd_remove_devices(adev->acp.parent);
>         kfree(adev->acp.acp_res);
> --
> 2.31.1
>
