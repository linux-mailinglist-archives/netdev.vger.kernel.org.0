Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB173EAB91
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 22:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbhHLUVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 16:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbhHLUVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 16:21:38 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF78C061756;
        Thu, 12 Aug 2021 13:21:12 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id d6so11651819edt.7;
        Thu, 12 Aug 2021 13:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zxDq/g55N5DEIwhH9XICScXN1w2LO9Qk4UYDqTLhh/A=;
        b=n/tkJnXPPwW7dKTrYhLSNmMKuAs4GHsquvwta/yYLlNe/EIt8h1eQjB5DaXk6awxnl
         785O1/zvphm103vRd03laIhXfnArC/6smO/fQDrGMt9vDHcVHb2URq+pq/n82PsCjA2P
         Ci6BfKU5C14HfTLeu4ZKtRKj3jnI7pseWOMYOz4B/68cUmhMFEQkM9CG6cmNEnoytk2z
         JHeUfc2MxRfi8EQkKyVQdafyFwYuHmdMhicxAujGnrMe5FWeVFrOIFrB8fsUYIcQKbs8
         5p7J+p/yJuxs2zjIumnGQ/rpW6I2MNEeayjatJbS0t/Pnx47j0RoD3NXGv1AygivUHk7
         k2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zxDq/g55N5DEIwhH9XICScXN1w2LO9Qk4UYDqTLhh/A=;
        b=oNJxFAmBz4FNZ7Jy6EnxzxfsbSDm4Di644AC2bkrEPmQiBWuYrrJclUfRKYjGD8ROx
         e2NtnHR+r/a+kJi8ldMr3cMd20hwSB2jXKOxZu3h/L2RqAtZwFQUsTofwHUoMCwqZ0y+
         kl3ypcr2cm7oMyKX5zMWVTCo3q+bZOzZyi01hZcOcvO4m4PzlIuMLnB8a/jc0vL0rXpR
         zOdTTJFg8nxCvKZlQJyQETM9nyKLsudiPUkg+lDL/OlxjWJ/N5lqp3S4D6VPbah6j6dQ
         93PRxlmBmxbHLuir/Dwu7qHZa4RRRxRlUKmFI08dd8ugKOq5tfCEpd103+WBI/LL6Q7B
         82EQ==
X-Gm-Message-State: AOAM532S2EcsSgIvnpQdyU32i3KeflSGY/rXM3hhQ9pCPyqGVKaNysBp
        bOl5qmrmxazx6wh6jMa9iXfoAEudWlbZ/UsBVBM=
X-Google-Smtp-Source: ABdhPJzIA90SX1dcZVwlK0blAjYG/13v3H2FbFsdiHFKDL7L2S7GOZLTHRfW/M/AEnefrqHLRp2ZiCuiP5TV3vaISLs=
X-Received: by 2002:aa7:c4d4:: with SMTP id p20mr7713351edr.382.1628799671438;
 Thu, 12 Aug 2021 13:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210722193459.7474-1-ojab@ojab.ru> <CAKzrAgRvOLX6rcKKz=8ghD+QLyMu-1KEPm5HkkLEAzuE1MQpDA@mail.gmail.com>
 <CACC2YF1j45r0chib-HC463FVO_a1Um1f+7PvuRBYVLC7WbgGnQ@mail.gmail.com>
In-Reply-To: <CACC2YF1j45r0chib-HC463FVO_a1Um1f+7PvuRBYVLC7WbgGnQ@mail.gmail.com>
From:   Axel Rasmussen <axel.rasmussen1@gmail.com>
Date:   Thu, 12 Aug 2021 13:21:00 -0700
Message-ID: <CACC2YF1WCSZqLrCig-O-_wJ9s4x47iTc2Xa0-LnyqLm8EWfUHg@mail.gmail.com>
Subject: Re: [PATCH V2] ath10k: don't fail if IRAM write fails
To:     "ojab //" <ojab@ojab.ru>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry again for the slow response time.

I got around to testing this today on my hardware. I tested with a
vanilla 5.13.8 kernel, and then the same kernel with this patch
applied. Long story short, the patch does indeed seem to at least work
around the issue I was seeing in [1]. With this patch applied, I still
get the same "failed to copy target iram contents" error, but the
interface comes up and seems to be functional regardless.

So, for what it's worth (granted I am no wireless expert!), you can take:

Tested-by: Axel Rasmussen <axelrasmussen@google.com>

(This issue has nothing to do with my full time job, but I'm meant to
use my @google.com address for any open source contributions, which I
believe applies to commit messages too.)

[1]: https://lists.infradead.org/pipermail/ath10k/2021-May/012626.html



Here are the two dmesg outputs, for comparison:

# uname -a
Linux router 5.13.8 #1 SMP Wed Aug 11 20:18:51 PDT 2021 x86_64 AMD
GX-412TC SOC AuthenticAMD GNU/Linux
# dmesg | grep ath
[   12.491747] ath10k_pci 0000:04:00.0: pci irq msi oper_irq_mode 2
irq_mode 0 reset_mode 0
[   12.613341] ath10k_pci 0000:04:00.0: qca9984/qca9994 hw1.0 target
0x01000000 chip_id 0x00000000 sub 168c:cafe
[   12.613367] ath10k_pci 0000:04:00.0: kconfig debug 1 debugfs 1
tracing 1 dfs 1 testmode 0
[   12.615071] ath10k_pci 0000:04:00.0: firmware ver
10.4-3.9.0.2-00131 api 5 features
no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps,peer-fixed-rate,iram-recovery
crc32 23bd9e43
[   13.846538] ath10k_pci 0000:04:00.0: board_file api 2 bmi_id 0:31
crc32 85498734
[   16.428502] ath10k_pci 0000:04:00.0: failed to copy target iram contents: -12
[   16.518692] ath10k_pci 0000:04:00.0: could not init core (-12)
[   16.518950] ath10k_pci 0000:04:00.0: could not probe fw (-12)



# uname -a
Linux router 5.13.8+ #2 SMP Wed Aug 11 20:28:56 PDT 2021 x86_64 AMD
GX-412TC SOC AuthenticAMD GNU/Linux
# dmesg | grep ath
[   12.201239] ath10k_pci 0000:04:00.0: pci irq msi oper_irq_mode 2
irq_mode 0 reset_mode 0
[   12.323354] ath10k_pci 0000:04:00.0: qca9984/qca9994 hw1.0 target
0x01000000 chip_id 0x00000000 sub 168c:cafe
[   12.323407] ath10k_pci 0000:04:00.0: kconfig debug 1 debugfs 1
tracing 1 dfs 1 testmode 0
[   12.325162] ath10k_pci 0000:04:00.0: firmware ver
10.4-3.9.0.2-00131 api 5 features
no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps,peer-fixed-rate,iram-reco
very crc32 23bd9e43
[   13.556748] ath10k_pci 0000:04:00.0: board_file api 2 bmi_id 0:31
crc32 85498734
[   16.155848] ath10k_pci 0000:04:00.0: No hardware memory
[   16.155873] ath10k_pci 0000:04:00.0: failed to copy target iram contents: -12
[   16.267376] ath10k_pci 0000:04:00.0: htt-ver 2.2 wmi-op 6 htt-op 4
cal otp max-sta 512 raw 0 hwcrypto 1
[   16.382257] ath: EEPROM regdomain sanitized
[   16.382289] ath: EEPROM regdomain: 0x64
[   16.382306] ath: EEPROM indicates we should expect a direct regpair map
[   16.382312] ath: Country alpha2 being used: 00
[   16.382316] ath: Regpair used: 0x64
[   16.393599] ath10k_pci 0000:04:00.0 wlp4s0: renamed from wlan0
[   41.264025] ath10k_pci 0000:04:00.0: No hardware memory
[   41.264045] ath10k_pci 0000:04:00.0: failed to copy target iram contents: -12
[   41.480677] ath10k_pci 0000:04:00.0: Unknown eventid: 36933

On Sun, Aug 1, 2021 at 7:23 PM Axel Rasmussen <axel.rasmussen1@gmail.com> wrote:
>
> On Thu, Jul 22, 2021 at 12:42 PM ojab // <ojab@ojab.ru> wrote:
> >
> > See also: https://lists.infradead.org/pipermail/ath10k/2021-May/012626.html
> >
> > On Thu, 22 Jul 2021 at 22:36, ojab <ojab@ojab.ru> wrote:
> > >
> > > After reboot with kernel & firmware updates I found `failed to copy
> > > target iram contents:` in dmesg and missing wlan interfaces for both
> > > of my QCA9984 compex cards. Rolling back kernel/firmware didn't fixed
> > > it, so while I have no idea what's actually happening, I don't see why
> > > we should fail in this case, looks like some optional firmware ability
> > > that could be skipped.
> > >
> > > Also with additional logging there is
> > > ```
> > > [    6.839858] ath10k_pci 0000:04:00.0: No hardware memory
> > > [    6.841205] ath10k_pci 0000:04:00.0: failed to copy target iram contents: -12
> > > [    6.873578] ath10k_pci 0000:07:00.0: No hardware memory
> > > [    6.875052] ath10k_pci 0000:07:00.0: failed to copy target iram contents: -12
> > > ```
> > > so exact branch could be seen.
> > >
> > > Signed-off-by: Slava Kardakov <ojab@ojab.ru>
> > > ---
> > >  Of course I forgot to sing off, since I don't use it by default because I
> > >  hate my real name and kernel requires it
>
> Thanks for working on this! And sorry for the slow response. I've been
> unexpectedly very busy lately, but I plan to test out this patch next
> week.
>
> > >
> > >  drivers/net/wireless/ath/ath10k/core.c | 9 ++++++---
> > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> > > index 2f9be182fbfb..d9fd5294e142 100644
> > > --- a/drivers/net/wireless/ath/ath10k/core.c
> > > +++ b/drivers/net/wireless/ath/ath10k/core.c
> > > @@ -2691,8 +2691,10 @@ static int ath10k_core_copy_target_iram(struct ath10k *ar)
> > >         u32 len, remaining_len;
> > >
> > >         hw_mem = ath10k_coredump_get_mem_layout(ar);
> > > -       if (!hw_mem)
> > > +       if (!hw_mem) {
> > > +               ath10k_warn(ar, "No hardware memory");
> > >                 return -ENOMEM;
> > > +       }
> > >
> > >         for (i = 0; i < hw_mem->region_table.size; i++) {
> > >                 tmp = &hw_mem->region_table.regions[i];
> > > @@ -2702,8 +2704,10 @@ static int ath10k_core_copy_target_iram(struct ath10k *ar)
> > >                 }
> > >         }
> > >
> > > -       if (!mem_region)
> > > +       if (!mem_region) {
> > > +               ath10k_warn(ar, "No memory region");
> > >                 return -ENOMEM;
> > > +       }
> > >
> > >         for (i = 0; i < ar->wmi.num_mem_chunks; i++) {
> > >                 if (ar->wmi.mem_chunks[i].req_id ==
> > > @@ -2917,7 +2921,6 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
> > >                 if (status) {
> > >                         ath10k_warn(ar, "failed to copy target iram contents: %d",
> > >                                     status);
> > > -                       goto err_hif_stop;
> > >                 }
> > >         }
> > >
> > > --
> > > 2.32.0
