Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638CA36BF31
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 08:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhD0GTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 02:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhD0GTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 02:19:24 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA3BC061574;
        Mon, 26 Apr 2021 23:18:41 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o21-20020a1c4d150000b029012e52898006so6179055wmh.0;
        Mon, 26 Apr 2021 23:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ws57Pt4UoEnqzr+91oE4gWmTufw0NTeaN+/QoL/Vx20=;
        b=YDpKC0E2gNiwkb4Il7VqDwD7nTynn6pmUAJhk04Jmo25p6pr0mOBeRtVXjxzazkSyw
         0ETtJSAh/rUInKKKItlxdDudzHq64pqBNt3pAheYja7FDcCnjg1lfvTQg8E1afuKITSF
         IHzVcPjfZOWX1kfzbNCcPq8/hcBsAw39GtSb2fBYlM4TxwMSC5RtC9SXW0BAFbgw+pDC
         3fWlbpXaNxBaUDcM37qqnIZaeyxgrqQZno/61XBOlAZ3xrtz9HfvjrUPuj/v8vOuWoZI
         ZXpO0PmNEx0tFJdBbuapLIVvXOg0/6SS/RtLKZbjhhztU7YVzbB0HOLHD/XL3d5bFQ7+
         yDhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ws57Pt4UoEnqzr+91oE4gWmTufw0NTeaN+/QoL/Vx20=;
        b=ZkkPTgvrVlCOFiEdgwuiNwJrXuJ37HsWEuDt5XHxSoZi34Y9Lvbzj1L2iSA9RymKKy
         Ik1jqJRWj0bno605dnM5NK2cLJraD0ArexHay9JSJOySB5D1XKUSqS2JcNh62+pBwzPG
         GnlnAyXLIuo7rCuWSrw7kA8uEIOaUXfvOE/hZeZHKz4IX5m0VFGVXbmlupWGqQd6XSX8
         QBYvn0e2U8th7Gay/xkXoL0Obnm17EEBEpAlXSyl9MDZJfXgJxS/q+Smq5Y+vKeCZnRN
         XHz7X2WOM+sbnj4M7q3EdRbbV+VUCMaxNpb5Hj6oiJoluOd9o4tafaPvqbL1i6d3ENOY
         +snA==
X-Gm-Message-State: AOAM532zABvRv0IEuRk0guzfbgkWcmrIoIqb6yTODBh9LV1hENYD13iO
        WTYMdCXg+TyHHPwsf6JRinG7EBE5N224ew==
X-Google-Smtp-Source: ABdhPJyDrOGTzW+y8cGjy/C8JGJf8A45G/ApjN8Z5QYfSz+94dZznD4/sg08ebMVu6Hvma8LHcgAqw==
X-Received: by 2002:a05:600c:4f48:: with SMTP id m8mr2575517wmq.45.1619504319671;
        Mon, 26 Apr 2021 23:18:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:adbf:8f0b:9d4c:1d12? (p200300ea8f384600adbf8f0b9d4c1d12.dip0.t-ipconnect.de. [2003:ea:8f38:4600:adbf:8f0b:9d4c:1d12])
        by smtp.googlemail.com with ESMTPSA id d5sm2690404wrv.43.2021.04.26.23.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 23:18:39 -0700 (PDT)
To:     AceLan Kao <acelan.kao@canonical.com>
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
References: <20210420075406.64105-1-acelan.kao@canonical.com>
 <CANn89iJLSmtBNoDo8QJ6a0MzsHjdLB0Pf=cs9e4g8Y6-KuFiMQ@mail.gmail.com>
 <20210420122715.2066b537@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFv23Q=ywiuZp7Y=bj=SAZmDdAnanAXA954hdO3GpkjmDo=RpQ@mail.gmail.com>
 <c10a6c72-9db7-18c8-6b03-1f8c40b8fd87@gmail.com>
 <CAFv23QkUsTf5M0MoUEFNYeFCtShAn3EmA3u8vXVeZyJa20Bx=g@mail.gmail.com>
 <f06e0e2b-c6bb-ef5a-f629-d1ab82b7aee2@gmail.com>
 <CAFv23Qnf3aJQyXyDbb_nvq2XU8t9Gy5sLFyzM251-FU_qBBUjw@mail.gmail.com>
 <9caae1c4-7132-4827-ef36-7aade74e4084@gmail.com>
 <CAFv23Q=p+XM-p75RE--EHqkqtwqH743nTdb_-PSKpXbfAjpbrw@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: called rtnl_unlock() before runpm resumes devices
Message-ID: <98fed606-d336-f550-dc29-76916253cb88@gmail.com>
Date:   Tue, 27 Apr 2021 08:18:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAFv23Q=p+XM-p75RE--EHqkqtwqH743nTdb_-PSKpXbfAjpbrw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.04.2021 03:58, AceLan Kao wrote:
> I got another issue ticket with the same dump_stack with igc NIC.
> To fix this on the device side would lead to many other issues and we
> have to check on the device side if the calling path contains
> rtnl_lock already.

I think it's not clean that the igb/igc runtime_resume handlers call
__igb_open() before ndo_open(). I understand why it works in the
drivers, but I'd consider it a little bit hacky. And there's no
need for the drivers to acquire rtnl_lock before ndo_open().

> I still think we should not keep rtnl locked when calling functions
> outside of network stack.
> 
Well, the runtime pm handlers of a MAC driver are within the network
stack. I understand that your proposed change is the easiest way to
work around the issue you're facing. I'm not sure it's the best way
however, but I don't have a strong opinion here and would leave it
to the maintainers which option they prefer.

> Heiner Kallweit <hkallweit1@gmail.com> 於 2021年4月26日 週一 下午4:42寫道：
>>
>> On 26.04.2021 09:36, AceLan Kao wrote:
>>> Heiner Kallweit <hkallweit1@gmail.com> 於 2021年4月25日 週日 上午4:07寫道：
>>>>
>>>> On 23.04.2021 05:42, AceLan Kao wrote:
>>>>> Heiner Kallweit <hkallweit1@gmail.com> 於 2021年4月22日 週四 下午3:09寫道：
>>>>>>
>>>>>> On 22.04.2021 08:30, AceLan Kao wrote:
>>>>>>> Yes, should add
>>>>>>>
>>>>>>> Fixes: 9474933caf21 ("igb: close/suspend race in netif_device_detach")
>>>>>>> and also
>>>>>>> Fixes: 9513d2a5dc7f ("igc: Add legacy power management support")
>>>>>>>
>>>>>> Please don't top-post. Apart from that:
>>>>>> If the issue was introduced with driver changes, then adding a workaround
>>>>>> in net core may not be the right approach.
>>>>> It's hard to say who introduces this issue, we probably could point
>>>>> our finger to below commit
>>>>> bd869245a3dc net: core: try to runtime-resume detached device in __dev_open
>>>>>
>>>>> This calling path is not usual, in my case, the NIC is not plugged in
>>>>> any Ethernet cable,
>>>>> and we are doing networking tests on another NIC on the system. So,
>>>>> remove the rtnl lock from igb driver will affect other scenarios.
>>>>>
>>>>>>
>>>>>>> Jakub Kicinski <kuba@kernel.org> 於 2021年4月21日 週三 上午3:27寫道：
>>>>>>>>
>>>>>>>> On Tue, 20 Apr 2021 10:34:17 +0200 Eric Dumazet wrote:
>>>>>>>>> On Tue, Apr 20, 2021 at 9:54 AM AceLan Kao <acelan.kao@canonical.com> wrote:
>>>>>>>>>>
>>>>>>>>>> From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
>>>>>>>>>>
>>>>>>>>>> The rtnl_lock() has been called in rtnetlink_rcv_msg(), and then in
>>>>>>>>>> __dev_open() it calls pm_runtime_resume() to resume devices, and in
>>>>>>>>>> some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
>>>>>>>>>> again. That leads to a recursive lock.
>>>>>>>>>>
>>>>>>>>>> It should leave the devices' resume function to decide if they need to
>>>>>>>>>> call rtnl_lock()/rtnl_unlock(), so call rtnl_unlock() before calling
>>>>>>>>>> pm_runtime_resume() and then call rtnl_lock() after it in __dev_open().
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Hi Acelan
>>>>>>>>>
>>>>>>>>> When was the bugg added ?
>>>>>>>>> Please add a Fixes: tag
>>>>>>>>
>>>>>>>> For immediate cause probably:
>>>>>>>>
>>>>>>>> Fixes: 9474933caf21 ("igb: close/suspend race in netif_device_detach")
>>>>>>>>
>>>>>>>>> By doing so, you give more chances for reviewers to understand why the
>>>>>>>>> fix is not risky,
>>>>>>>>> and help stable teams work.
>>>>>>>>
>>>>>>>> IMO the driver lacks internal locking. Taking 看rtnl from resume is just
>>>>>>>> one example, git history shows many more places that lacked locking and
>>>>>>>> got papered over with rtnl here.
>>>>>>
>>>>
>>>> You could alternatively try the following. It should avoid the deadlock,
>>>> and when runtime-resuming if __IGB_DOWN is set all we do is marking the
>>>> net_device as present (because of PCI D3 -> D0 transition).
>>>> I do basically the same in r8169 and it works as intended.
>>>>
>>>> Disclaimer: I don't have an igb-driven device and therefore can't test
>>>> the proposal.
>>>>
>>>> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
>>>> index 038a9fd1a..21436626a 100644
>>>> --- a/drivers/net/ethernet/intel/igb/igb_main.c
>>>> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
>>>> @@ -9300,6 +9300,14 @@ static int __maybe_unused igb_runtime_suspend(struct device *dev)
>>>>
>>>>  static int __maybe_unused igb_runtime_resume(struct device *dev)
>>>>  {
>>>> +       struct net_device *netdev = dev_get_drvdata(dev);
>>>> +       struct igb_adapter *adapter = netdev_priv(netdev);
>>>> +
>>>> +       if (test_bit(__IGB_DOWN, &adapter->state)) {
>>>> +               netif_device_attach(netdev);
>>>> +               return 0;
>>>> +       }
>>>> +
>>>>         return igb_resume(dev);
>>>>  }
>>>>
>>>> --
>>>> 2.31.1
>>>>
>>>
>>> Hi Heiner,
>>>
>>> I encountered below error after applied your patch.
>>>
>> Presumably similar changes are needed also for the runtime_suspend callback.
>> If __IGB_DOWN is set, I think just the net_device needs to be detached.
>>
>>
>>> [  121.489970] u kernel: ------------[ cut here ]------------
>>> [  121.489979] u kernel: igb 0000:05:00.0: disabling already-disabled device
>>> [  121.490008] u kernel: WARNING: CPU: 7 PID: 258 at
>>> drivers/pci/pci.c:2146 pci_disable_device+0x91/0xb0
>>> [  121.490028] u kernel: Modules linked in: rfcomm cmac algif_hash
>>> algif_skcipher af_alg bnep btusb btrtl btbcm btintel bluetooth
>>> ecdh_generic ecc joydev input_leds inte
>>> l_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp
>>> coretemp ath10k_pci ath10k_core kvm_intel ath mac80211 kvm
>>> snd_sof_pci_intel_tgl snd_soc_acpi_intel_ma
>>> tch snd_sof_intel_hda_common nls_iso8859_1 soundwire_intel
>>> soundwire_generic_allocation soundwire_cadence soundwire_bus
>>> snd_sof_pci snd_soc_acpi snd_sof snd_soc_core snd
>>> _hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi
>>> crct10dif_pclmul crc32_pclmul snd_sof_xtensa_dsp ghash_clmulni_intel
>>> ledtrig_audio aesni_intel snd_hda_intel
>>> libarc4 crypto_simd snd_intel_dspcfg snd_intel_sdw_acpi cryptd
>>> snd_hda_codec cfg80211 mei_hdcp snd_hwdep snd_hda_core
>>> intel_wmi_thunderbolt snd_pcm wmi_bmof snd_seq inte
>>> l_cstate efi_pstore snd_timer snd_seq_device ee1004 mei_me snd mei
>>> ucsi_acpi soundcore typec_ucsi typec wmi mac_hid acpi_pad acpi_tad
>>> sch_fq_codel
>>> [  121.490314] u kernel:  parport_pc ppdev lp parport ip_tables
>>> x_tables autofs4 btrfs blake2b_generic zstd_compress raid10 raid456
>>> async_raid6_recov async_memcpy async_
>>> pq async_xor async_tx libcrc32c xor raid6_pq raid1 raid0 multipath
>>> linear hid_generic usbhid hid i915 drm_kms_helper syscopyarea
>>> sysfillrect sysimgblt fb_sys_fops cec rc
>>> _core igb drm nvme e1000e nvme_core i2c_i801 dca i2c_smbus
>>> i2c_algo_bit intel_lpss_pci intel_lpss ahci idma64 video xhci_pci
>>> libahci virt_dma xhci_pci_renesas pinctrl_ti
>>> gerlake
>>> [  121.490508] u kernel: CPU: 7 PID: 258 Comm: kworker/7:2 Tainted: G
>>>    U            5.12.0-rc7+ #79
>>> [  121.490518] u kernel: Hardware name: Dell Inc. OptiPlex 7090/, BIOS
>>> 0.12.80 02/23/2021
>>> [  121.490525] u kernel: Workqueue: pm pm_runtime_work
>>> [  121.490540] u kernel: RIP: 0010:pci_disable_device+0x91/0xb0
>>> [  121.490550] u kernel: Code: 4d 85 e4 75 07 4c 8b a3 c8 00 00 00 48
>>> 8d bb c8 00 00 00 e8 61 8d 17 00 4c 89 e2 48 c7 c7 60 5a e0 a5 48 89
>>> c6 e8 9b a3 59 00 <0f> 0b eb 8
>>> d 48 89 df e8 e3 fe ff ff 80 a3 49 0a 00 00 df 5b 41 5c
>>> [  121.490558] u kernel: RSP: 0018:ffffb76b4169fc90 EFLAGS: 00010286
>>> [  121.490569] u kernel: RAX: 0000000000000000 RBX: ffff9e2581ee6000
>>> RCX: 0000000000000027
>>> [  121.490576] u kernel: RDX: 0000000000000027 RSI: ffffffffa493bca0
>>> RDI: ffff9e27073e89b8
>>> [  121.490582] u kernel: RBP: ffffb76b4169fca0 R08: ffff9e27073e89b0
>>> R09: 0000000000000000
>>> [  121.490588] u kernel: R10: 0000000000000000 R11: 0000000000000001
>>> R12: ffff9e2581af7c80
>>> [  121.490594] u kernel: R13: ffff9e2581ee6000 R14: ffff9e25a0914000
>>> R15: ffff9e25a0915280
>>> [  121.490600] u kernel: FS:  0000000000000000(0000)
>>> GS:ffff9e2707200000(0000) knlGS:0000000000000000
>>> [  121.490608] u kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  121.490614] u kernel: CR2: 00007ff86ec8d024 CR3: 0000000189c28002
>>> CR4: 0000000000770ee0
>>> [  121.490621] u kernel: PKRU: 55555554
>>> [  121.490626] u kernel: Call Trace:
>>> [  121.490638] u kernel:  __igb_shutdown+0xf2/0x1c0 [igb]
>>> [  121.490676] u kernel:  igb_runtime_suspend+0x1c/0x20 [igb]
>>> [  121.490703] u kernel:  pci_pm_runtime_suspend+0x63/0x180
>>> [  121.490715] u kernel:  ? pci_pm_runtime_resume+0x90/0x90
>>> [  121.490727] u kernel:  __rpm_callback+0xc7/0x140
>>> [  121.490740] u kernel:  rpm_callback+0x57/0x80
>>> [  121.490750] u kernel:  ? pci_pm_runtime_resume+0x90/0x90
>>> [  121.490759] u kernel:  rpm_suspend+0x119/0x640
>>> [  121.490774] u kernel:  pm_runtime_work+0x64/0xc0
>>> [  121.490784] u kernel:  process_one_work+0x2af/0x5d0
>>> [  121.490803] u kernel:  worker_thread+0x4d/0x3e0
>>> [  121.490814] u kernel:  ? process_one_work+0x5d0/0x5d0
>>> [  121.490825] u kernel:  kthread+0x12a/0x160
>>> [  121.490834] u kernel:  ? kthread_park+0x90/0x90
>>> [  121.490844] u kernel:  ret_from_fork+0x1f/0x30
>>> [  121.490867] u kernel: irq event stamp: 0[  121.490871] u kernel:
>>> hardirqs last  enabled at (0): [<0000000000000000>] 0x0
>>> [  121.490916] u kernel: hardirqs last disabled at (0):
>>> [<ffffffffa489ea44>] copy_process+0x714/0x1cc0
>>> [  121.490929] u kernel: softirqs last  enabled at (0):
>>> [<ffffffffa489ea44>] copy_process+0x714/0x1cc0
>>> [  121.490938] u kernel: softirqs last disabled at (0): [<0000000000000000>] 0x0
>>> [  121.490949] u kernel: ---[ end trace a9c7ffc27c226979 ]---
>>>
>>

