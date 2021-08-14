Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBFD3EC262
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 13:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238213AbhHNLfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 07:35:42 -0400
Received: from mout.gmx.net ([212.227.17.22]:36057 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238053AbhHNLfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 07:35:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1628940799;
        bh=cCjVf4j91gw+QhSCL99zmK+t+X4+yzpKlIk+1eVjv3o=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=A6zCt4cBc65HnDIH/tcj67tdSZ/r/B6srCcQ+dM01mJkzkX1MqEpgtb+cbxhllyVK
         3y1kR+v77Kr/YsFiNXXM49g/zqgJLGyatVXyBj24AT22IML44K/BkNHmkK8ecPDsKO
         GP0GuD7s2+Mm9F4aRyJUkMKI2QDDEzuh8pqIwLwA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.100] ([79.206.240.54]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M6Daq-1mCg350RVg-006bDh; Sat, 14
 Aug 2021 13:33:19 +0200
Subject: Re: [PATCH V2] ath10k: don't fail if IRAM write fails
To:     Axel Rasmussen <axel.rasmussen1@gmail.com>, ojab // <ojab@ojab.ru>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20210722193459.7474-1-ojab@ojab.ru>
 <CAKzrAgRvOLX6rcKKz=8ghD+QLyMu-1KEPm5HkkLEAzuE1MQpDA@mail.gmail.com>
 <CACC2YF1j45r0chib-HC463FVO_a1Um1f+7PvuRBYVLC7WbgGnQ@mail.gmail.com>
 <CACC2YF1WCSZqLrCig-O-_wJ9s4x47iTc2Xa0-LnyqLm8EWfUHg@mail.gmail.com>
From:   "sparks71@gmx.de" <sparks71@gmx.de>
Message-ID: <b3aa258f-9002-f53b-5fd7-98e773dbeff5@gmx.de>
Date:   Sat, 14 Aug 2021 13:33:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CACC2YF1WCSZqLrCig-O-_wJ9s4x47iTc2Xa0-LnyqLm8EWfUHg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:bYrMIP8NbdP3LCTRBQl+RWFYK5X46lZ2WTJPdYciARVlZsyw1xQ
 eFi9A9CJzCW9xhZ5tLTVA2tsZdnrp9+c4hYIKE9yD4/IUzFhL6D1pLsBkMglZ9vGhmcJngQ
 VdwtZggMGHW8WhEMvsttkLIUrnZvzqG96ery2uTb/GB7/I9jHkaAN1RtrqY95ix8ucm54hr
 mezZ5FiYPJYXqjW3X65nQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8PW8q2EGZX8=:tYuHZnvNoRIVi1YMncMBWd
 FD3+G1775Tiv5DLg32ZTKZNSDlyXEO+KPFqgISodGPjm1ovSBwP8ArK7cokU5q8RnQ/hqhn7/
 LseNfxi0+B7IzF97DEubU8wM/ru1nRNo6gDx2EYJnCtYaD0kULv9XS2LFlajqx6ohxUObwl8T
 Sr9j8LdMEkFPb7yRJYhtF/f2B1xv2A4t1NxwnOR2Yr6T27Qm7rWeQHVwPmbBvTenkpdMIRl6V
 rtt4E8yexxUVE3BQKPf2pMnVwODAH84vZwmBXFQNsuJdl2cpiXw9JayFjcilFXHK9/OLe5ony
 Y5O7MQy+1iGVhNibpBL6UnK8owFfqlRZAowjMWBEFluJ9kmRZkIX4fP/N5x1b6irVx2wivnLu
 DOhVpFAzgIwSFrUZyMNT92jt5ZVi3BTFGtLz0d2XkFO6zwV9KwRiaVyCYMkE4ttjibjQ3iXRt
 mJ+Bl9yuA3wLUDwMgKAeC+zzdvsASI7DLju9KiTUw9XU6Suv/3fI6yrbf96rwbJNkaWiLgYmR
 iVTyyf8K8AYy0YzfciY5DBcgca9/Q0in/gYcqzdRjDk9TVcUQe1csAK0JliVDg5hn6xkhwSd/
 VbdkFIDHSSyVgtUex2f4P5gMxk4xeCytmfoXRrU5RMMfWOquqSRy/Qb5tYDokmy/aUkFCcktj
 kIJj/+wKNPqtSzUDD1+WVV7xZZ03WmuxLTfTsm1HOgVJpusSI2AlgwGsgGmeKWBH6CyqfnHMz
 zn6xkcP2IFlopWXDCdvvqpzoDrDg/xr+Nu3EzGWQVIH4QKnfTlubtP259SUHxoHuOkc1E9ypX
 qFg4v9aJEu10MBEyKdrLreekozjGPlgCvHFK3j/Zhfrs5kJ2Z8H0GioUc3kfPzWHO7pwhpfhG
 ue46fYcwi678K4v7bFG50vzl18EJvko9NrjFXQbojjOrl4G91edbjs1/zTjb+XdWFETyDBXM3
 CxOuskRWw4JTDTbAyXVcVFx0efKM4z7WNoqUiV6bL9+2MT+zm8W1M8AfL5F2aRLOSQmR0BOpu
 K3FRM1HFuQCdgaZUBiPl9S6A+erWMrA1y3yb8G03yRbxZyurdgmgbfMR7/fah/aoohVwD4Gfl
 8+ACRJgfQQTBD2lcHokXx02wenPyiAKbPMrh3BxoUHhFVn/JCYSikSDNg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, I have the same problem with my QCA9984 cards and also tested the
patch successfully.

See > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1939937

best regards



Am 12.08.21 um 22:21 schrieb Axel Rasmussen:
> Sorry again for the slow response time.
>
> I got around to testing this today on my hardware. I tested with a
> vanilla 5.13.8 kernel, and then the same kernel with this patch
> applied. Long story short, the patch does indeed seem to at least work
> around the issue I was seeing in [1]. With this patch applied, I still
> get the same "failed to copy target iram contents" error, but the
> interface comes up and seems to be functional regardless.
>
> So, for what it's worth (granted I am no wireless expert!), you can take=
:
>
> Tested-by: Axel Rasmussen <axelrasmussen@google.com>
>
> (This issue has nothing to do with my full time job, but I'm meant to
> use my @google.com address for any open source contributions, which I
> believe applies to commit messages too.)
>
> [1]: https://lists.infradead.org/pipermail/ath10k/2021-May/012626.html
>
>
>
> Here are the two dmesg outputs, for comparison:
>
> # uname -a
> Linux router 5.13.8 #1 SMP Wed Aug 11 20:18:51 PDT 2021 x86_64 AMD
> GX-412TC SOC AuthenticAMD GNU/Linux
> # dmesg | grep ath
> [   12.491747] ath10k_pci 0000:04:00.0: pci irq msi oper_irq_mode 2
> irq_mode 0 reset_mode 0
> [   12.613341] ath10k_pci 0000:04:00.0: qca9984/qca9994 hw1.0 target
> 0x01000000 chip_id 0x00000000 sub 168c:cafe
> [   12.613367] ath10k_pci 0000:04:00.0: kconfig debug 1 debugfs 1
> tracing 1 dfs 1 testmode 0
> [   12.615071] ath10k_pci 0000:04:00.0: firmware ver
> 10.4-3.9.0.2-00131 api 5 features
> no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps,peer-fixe=
d-rate,iram-recovery
> crc32 23bd9e43
> [   13.846538] ath10k_pci 0000:04:00.0: board_file api 2 bmi_id 0:31
> crc32 85498734
> [   16.428502] ath10k_pci 0000:04:00.0: failed to copy target iram conte=
nts: -12
> [   16.518692] ath10k_pci 0000:04:00.0: could not init core (-12)
> [   16.518950] ath10k_pci 0000:04:00.0: could not probe fw (-12)
>
>
>
> # uname -a
> Linux router 5.13.8+ #2 SMP Wed Aug 11 20:28:56 PDT 2021 x86_64 AMD
> GX-412TC SOC AuthenticAMD GNU/Linux
> # dmesg | grep ath
> [   12.201239] ath10k_pci 0000:04:00.0: pci irq msi oper_irq_mode 2
> irq_mode 0 reset_mode 0
> [   12.323354] ath10k_pci 0000:04:00.0: qca9984/qca9994 hw1.0 target
> 0x01000000 chip_id 0x00000000 sub 168c:cafe
> [   12.323407] ath10k_pci 0000:04:00.0: kconfig debug 1 debugfs 1
> tracing 1 dfs 1 testmode 0
> [   12.325162] ath10k_pci 0000:04:00.0: firmware ver
> 10.4-3.9.0.2-00131 api 5 features
> no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps,peer-fixe=
d-rate,iram-reco
> very crc32 23bd9e43
> [   13.556748] ath10k_pci 0000:04:00.0: board_file api 2 bmi_id 0:31
> crc32 85498734
> [   16.155848] ath10k_pci 0000:04:00.0: No hardware memory
> [   16.155873] ath10k_pci 0000:04:00.0: failed to copy target iram conte=
nts: -12
> [   16.267376] ath10k_pci 0000:04:00.0: htt-ver 2.2 wmi-op 6 htt-op 4
> cal otp max-sta 512 raw 0 hwcrypto 1
> [   16.382257] ath: EEPROM regdomain sanitized
> [   16.382289] ath: EEPROM regdomain: 0x64
> [   16.382306] ath: EEPROM indicates we should expect a direct regpair m=
ap
> [   16.382312] ath: Country alpha2 being used: 00
> [   16.382316] ath: Regpair used: 0x64
> [   16.393599] ath10k_pci 0000:04:00.0 wlp4s0: renamed from wlan0
> [   41.264025] ath10k_pci 0000:04:00.0: No hardware memory
> [   41.264045] ath10k_pci 0000:04:00.0: failed to copy target iram conte=
nts: -12
> [   41.480677] ath10k_pci 0000:04:00.0: Unknown eventid: 36933
>
> On Sun, Aug 1, 2021 at 7:23 PM Axel Rasmussen <axel.rasmussen1@gmail.com=
> wrote:
>> On Thu, Jul 22, 2021 at 12:42 PM ojab // <ojab@ojab.ru> wrote:
>>> See also: https://lists.infradead.org/pipermail/ath10k/2021-May/012626=
.html
>>>
>>> On Thu, 22 Jul 2021 at 22:36, ojab <ojab@ojab.ru> wrote:
>>>> After reboot with kernel & firmware updates I found `failed to copy
>>>> target iram contents:` in dmesg and missing wlan interfaces for both
>>>> of my QCA9984 compex cards. Rolling back kernel/firmware didn't fixed
>>>> it, so while I have no idea what's actually happening, I don't see wh=
y
>>>> we should fail in this case, looks like some optional firmware abilit=
y
>>>> that could be skipped.
>>>>
>>>> Also with additional logging there is
>>>> ```
>>>> [    6.839858] ath10k_pci 0000:04:00.0: No hardware memory
>>>> [    6.841205] ath10k_pci 0000:04:00.0: failed to copy target iram co=
ntents: -12
>>>> [    6.873578] ath10k_pci 0000:07:00.0: No hardware memory
>>>> [    6.875052] ath10k_pci 0000:07:00.0: failed to copy target iram co=
ntents: -12
>>>> ```
>>>> so exact branch could be seen.
>>>>
>>>> Signed-off-by: Slava Kardakov <ojab@ojab.ru>
>>>> ---
>>>>   Of course I forgot to sing off, since I don't use it by default bec=
ause I
>>>>   hate my real name and kernel requires it
>> Thanks for working on this! And sorry for the slow response. I've been
>> unexpectedly very busy lately, but I plan to test out this patch next
>> week.
>>
>>>>   drivers/net/wireless/ath/ath10k/core.c | 9 ++++++---
>>>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wir=
eless/ath/ath10k/core.c
>>>> index 2f9be182fbfb..d9fd5294e142 100644
>>>> --- a/drivers/net/wireless/ath/ath10k/core.c
>>>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>>>> @@ -2691,8 +2691,10 @@ static int ath10k_core_copy_target_iram(struct=
 ath10k *ar)
>>>>          u32 len, remaining_len;
>>>>
>>>>          hw_mem =3D ath10k_coredump_get_mem_layout(ar);
>>>> -       if (!hw_mem)
>>>> +       if (!hw_mem) {
>>>> +               ath10k_warn(ar, "No hardware memory");
>>>>                  return -ENOMEM;
>>>> +       }
>>>>
>>>>          for (i =3D 0; i < hw_mem->region_table.size; i++) {
>>>>                  tmp =3D &hw_mem->region_table.regions[i];
>>>> @@ -2702,8 +2704,10 @@ static int ath10k_core_copy_target_iram(struct=
 ath10k *ar)
>>>>                  }
>>>>          }
>>>>
>>>> -       if (!mem_region)
>>>> +       if (!mem_region) {
>>>> +               ath10k_warn(ar, "No memory region");
>>>>                  return -ENOMEM;
>>>> +       }
>>>>
>>>>          for (i =3D 0; i < ar->wmi.num_mem_chunks; i++) {
>>>>                  if (ar->wmi.mem_chunks[i].req_id =3D=3D
>>>> @@ -2917,7 +2921,6 @@ int ath10k_core_start(struct ath10k *ar, enum a=
th10k_firmware_mode mode,
>>>>                  if (status) {
>>>>                          ath10k_warn(ar, "failed to copy target iram =
contents: %d",
>>>>                                      status);
>>>> -                       goto err_hif_stop;
>>>>                  }
>>>>          }
>>>>
>>>> --
>>>> 2.32.0
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
>
>

