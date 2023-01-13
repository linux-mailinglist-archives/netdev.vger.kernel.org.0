Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB5A66A41F
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 21:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjAMUeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 15:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjAMUeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 15:34:04 -0500
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC8810FD;
        Fri, 13 Jan 2023 12:34:00 -0800 (PST)
Received: by mail-vk1-xa32.google.com with SMTP id t2so10736694vkk.9;
        Fri, 13 Jan 2023 12:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BdLqTQ3v63DRFeMJ8FWD/G9MX1mstv6nGqZYVTqLC4s=;
        b=Syn2lSFziLpMg/brZCsrjb0n048s8n9xn0fVMdkYdqw2YdMlRo0fEkOjttJuwsGw9B
         ZFPXgNp2fag/h9wetXJ+DsSC7p56hVbyLn36W5Z9kQ47DY3J/SKHpeRNsTLuFcqYxv/9
         o4EBx+9zFkq2Gnl6KJoCwY7EGCsOkChEkTdkIIVKu+h3aCHJGUpvAplIolPj9XSwTo6d
         l4WTBCh9IhtoCTnpaEZP9AGcl776n52wDYFcXVgNUNlu2oo+99N156SW6lvcPfffpXDu
         tmR/OlpywdmRQG7jPKWqkF4NutE6+dbPDNKJRAyU5Q2auRbswz1DVd89cdV9TP0d1o1E
         7p7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :references:in-reply-to:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BdLqTQ3v63DRFeMJ8FWD/G9MX1mstv6nGqZYVTqLC4s=;
        b=3fnB8iY3ZcjvMJUhBJqZAeI+WqhoXn+9qMnypbHr8Z/CicIeViSEHZYUTXfmqSlBkV
         I2m/s1MhgIifiAS2cIzwuuH0xfiRlJvfBu0GI7w+mn/GIwZZY3224JEdimFt3sNUh92W
         F2LbHwuaU7k7/zpuWSBeavimVHjREVMydbggIzTeYYapXJL1oJ3IN2IM7ckYCGjUgjV1
         ZaOIVqWg/SG9n1N460VNcCm1joNNRkHPNcS3yXX3F2Jppd1lN2yMCm5nupVwK34LW7rc
         X3vy9LZKNnvCIZ4bABSOc2UE6squPCrMXaX6+izhMUlyducDParWqWK6cE3xlqOyPF/W
         ESbg==
X-Gm-Message-State: AFqh2kr71oD4ZsJv6FaXhE9l1vIYc1Dag6EL6j6Wlk4Kf68QNre3a0Jl
        LIfyEPkboqnjlckRgXu94h+pAS/uM7TMmMZmm+8=
X-Google-Smtp-Source: AMrXdXvqybELRwDJp1J8CCzPupdM1ULUnqNLfDLwQkKYHqX0P5jotcjalDj/HCasmEcn8z51kd+kS8ZwS0B38P6XYLA=
X-Received: by 2002:a1f:e847:0:b0:3da:de55:ba68 with SMTP id
 f68-20020a1fe847000000b003dade55ba68mr1976656vkh.38.1673642038966; Fri, 13
 Jan 2023 12:33:58 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:954c:0:b0:2f5:cc2a:677 with HTTP; Fri, 13 Jan 2023
 12:33:57 -0800 (PST)
In-Reply-To: <43ea7fbf-9a2f-07a0-9633-b42271815a71@intel.com>
References: <CACsaVZL6ykbsVvEaV2Cv3r6m_jKt04MEUOw5=mSnR5AYTyE7qg@mail.gmail.com>
 <a752422c-4630-e53d-c9cd-cc9ed866f853@intel.com> <CACsaVZJXqkWGOQhe-GzRKJSfYn-3+dZTyHNZC97npCxzqr+R9g@mail.gmail.com>
 <CACsaVZLh0WFu1p7TUxE=RwucoTcZwsfQ5+ivorcbwCiRneeVFg@mail.gmail.com>
 <70eea40e-808c-e9ee-9aab-617ebe67d67c@intel.com> <CACsaVZ+icDmY15bqHuSR=KUBx0tbpDVXasuuYPjWg6aVAyy2hg@mail.gmail.com>
 <CACsaVZKr=B6xNrxM_J60+pg48onQf1jQJYNRDLwgESje_fN13Q@mail.gmail.com>
 <BYAPR11MB2727764EB94F647479731DAB96F39@BYAPR11MB2727.namprd11.prod.outlook.com>
 <CACsaVZJnKMcAtKdfgNKSzH8VNW-Lw5JN=+C+CDHcotpZJQCaeQ@mail.gmail.com>
 <BYAPR11MB2727B1CA9A658119793B2F7896F39@BYAPR11MB2727.namprd11.prod.outlook.com>
 <CACsaVZJTZon4VZ5X35o1avkKrskkcU_Qfru7FMTYHJ+cPeXpnw@mail.gmail.com>
 <CACsaVZ+1QhryQU+=pPHHrWLqfwO+17oP8zZu6Csizgqutj5a=A@mail.gmail.com> <43ea7fbf-9a2f-07a0-9633-b42271815a71@intel.com>
From:   Kyle Sanderson <kyle.leet@gmail.com>
Date:   Fri, 13 Jan 2023 16:33:57 -0400
Message-ID: <CACsaVZ+OXhp1+4t4YOm8+9fJcQOVVNckwVppzikkGBHUi-PFcw@mail.gmail.com>
Subject: Re: igc: 5.10.146 Kernel BUG at 0xffffffff813ce19f
To:     "Ruinskiy, Dima" <dima.ruinskiy@intel.com>
Cc:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Avivi, Amir" <amir.avivi@intel.com>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        "Torvalds, Linus" <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "naamax.meir" <naamax.meir@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "MP, Sureshkumar" <sureshkumar.mp@intel.com>
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

> On Wednesday, January 11, 2023, Ruinskiy, Dima <dima.ruinskiy@intel.com> =
wrote:
> We are going to try to get a reliable reproduction internally, based on t=
he instructions provided, to simplify triage and debug.

Understood, thank you Dima.

> Could you share the exact model of the retail appliance you are using, ju=
st in case I can locate someone here with a similar device?

https://www.servethehome.com/intel-celeron-j6413-powered-6x-i226-2-5gbe-fan=
less-firewall-review/

These boxes (like the protectli) boxes all ship with BSD. I know the
IPS cases are private - were you able to connect with the group
working on that? (Sureshkumar cc'd was in the to: field.)

Kyle.

On Wednesday, January 11, 2023, Ruinskiy, Dima <dima.ruinskiy@intel.com> wr=
ote:
> Hey Kyle,
>
> We are going to try to get a reliable reproduction internally, based on t=
he instructions provided, to simplify triage and debug.
>
> Could you share the exact model of the retail appliance you are using, ju=
st in case I can locate someone here with a similar device?
>
> Thanks,
> Dima.
>
> On 04/01/2023 7:23, Kyle Sanderson wrote:
>>
>> hi Intel IGC Maintainers,
>>
>> I know a very kind gentleman from a large networking vendor reached
>> out last week to a group on here saying they're seeing something
>> eerily similar to this failure (and that they have an IPS case open).
>>
>> Is there any additional information that you're looking for that I can
>> help with? One of my colleagues just had his UFS install corrupt
>> itself, so having non-panic'ing Linux support is still very much-so
>> desired.
>>
>> Kyle.
>>
>> On Thu, Dec 29, 2022 at 4:49 PM Kyle Sanderson <kyle.leet@gmail.com> wro=
te:
>>>
>>> On Thu, Dec 29, 2022 at 1:21 AM MP, Sureshkumar
>>> <sureshkumar.mp@intel.com> wrote:
>>>>
>>>> 1. Can you share the HW and SW BKC used to do this experiment?
>>>
>>> This is a retail appliance. They ship with FBSD out of the box
>>> (OPNsense / pfSense), or a Windows OS. I'm hoping we can fix Linux
>>> support for these.
>>> The NICs are embedded on the board, as to the bus they're using it's
>>> beyond me as an end consumer (basically an stb with a console port).
>>>
>>>> 2. How about this test results with i225 AIC on these kernels?
>>>
>>> I don't have this controller, but now that we know the steps to
>>> reproduce (enable IP Forwarding and send traffic until buffering
>>> happens) it should be reproducible by anyone.
>>>
>>>> 3. Did you test this with kernel.org igc driver code on these kernels?=
 If yes, share the results.
>>>
>>> Yes. Kernel panic'd (from the BUG_ON) on 5.10, 5.15, and 6.0.
>>>
>>>> 4. How did you connect 6x i226 AICs in the EHL board?
>>>
>>> Port 1 and Port 6. Using the ports independently doesn't seem to
>>> reproduce the issue, and is only when traffic is forwarded between
>>> them.
>>>
>>>> 5. Did you test with 1x i226 AIC on these kernels in EHL board?
>>>
>>> Yes, the problem does not persist. 2 NICs need to be used (on igc),
>>> with traffic passing between them.
>>>
>>> K.
>>>
>>> On Thu, Dec 29, 2022 at 1:21 AM MP, Sureshkumar
>>> <sureshkumar.mp@intel.com> wrote:
>>>>
>>>> Ok K.
>>>>
>>>> 1. Can you share the HW and SW BKC used to do this experiment?
>>>> 2. How about this test results with i225 AIC on these kernels?
>>>> 3. Did you test this with kernel.org igc driver code on these kernels?=
 If yes, share the results.
>>>> 4. How did you connect 6x i226 AICs in the EHL board?
>>>> 5. Did you test with 1x i226 AIC on these kernels in EHL board?
>>>>
>>>> Best Regards,
>>>> Sureshkumar
>>>>
>>>> -----Original Message-----
>>>> From: Kyle Sanderson <kyle.leet@gmail.com>
>>>> Sent: Thursday, December 29, 2022 9:58 AM
>>>> To: MP, Sureshkumar <sureshkumar.mp@intel.com>
>>>> Cc: Neftin, Sasha <sasha.neftin@intel.com>; intel-wired-lan@lists.osuo=
sl.org; Ruinskiy, Dima <dima.ruinskiy@intel.com>; Avivi, Amir <amir.avivi@i=
ntel.com>; Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony =
L <anthony.l.nguyen@intel.com>; Linux-Kernel <linux-kernel@vger.kernel.org>=
; Torvalds, Linus <torvalds@linux-foundation.org>; netdev@vger.kernel.org; =
Lifshits, Vitaly <vitaly.lifshits@intel.com>; naamax.meir <naamax.meir@linu=
x.intel.com>; Greg KH <gregkh@linuxfoundation.org>
>>>> Subject: Re: [Intel-wired-lan] igc: 5.10.146 Kernel BUG at 0xffffffff8=
13ce19f
>>>>
>>>> On Wed, Dec 28, 2022 at 8:12 PM MP, Sureshkumar <sureshkumar.mp@intel.=
com> wrote:
>>>>>
>>>>> Not getting the exact issue here. Can someone explain what is the iss=
ue with i226 in EHL platform?
>>>>>
>>>>> Best Regards,
>>>>> Sureshkumar
>>>>
>>>> hi Sureshkumar,
>>>>
>>>> If you forward traffic on an igc kmod NIC the kernel will panic with t=
he call traces provided from the three different kernel versions.
>>>> This happens when there's traffic passing through the nic, and the cab=
le is removed. When the cable is returned to the device, the panic occurs. =
Each controller (as far as I'm aware) is exposed as a standalone device.
>>>>
>>>> This has never worked on 5.10, 5.15, or 6.0 kernels. There is no devic=
e support on 5.4, so I can't test that far back unfortunately. We also don'=
t know if it's exclusive to this phy, or if it's impacting other devices us=
ing the kmod.
>>>>
>>>> K.
>>>>
>>>> On Wed, Dec 28, 2022 at 8:12 PM MP, Sureshkumar <sureshkumar.mp@intel.=
com> wrote:
>>>>>
>>>>> Not getting the exact issue here. Can someone explain what is the iss=
ue with i226 in EHL platform?
>>>>>
>>>>> Best Regards,
>>>>> Sureshkumar
>>>>>
>>>>> -----Original Message-----
>>>>> From: Kyle Sanderson <kyle.leet@gmail.com>
>>>>> Sent: Thursday, December 29, 2022 8:18 AM
>>>>> To: Neftin, Sasha <sasha.neftin@intel.com>;
>>>>> intel-wired-lan@lists.osuosl.org; Ruinskiy, Dima
>>>>> <dima.ruinskiy@intel.com>; Avivi, Amir <amir.avivi@intel.com>
>>>>> Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
>>>>> <anthony.l.nguyen@intel.com>; MP, Sureshkumar
>>>>> <sureshkumar.mp@intel.com>; Linux-Kernel
>>>>> <linux-kernel@vger.kernel.org>; Torvalds, Linus
>>>>> <torvalds@linux-foundation.org>; netdev@vger.kernel.org; Lifshits,
>>>>> Vitaly <vitaly.lifshits@intel.com>; naamax.meir
>>>>> <naamax.meir@linux.intel.com>; Greg KH <gregkh@linuxfoundation.org>;
>>>>> therbert@google.com
>>>>> Subject: Re: [Intel-wired-lan] igc: 5.10.146 Kernel BUG at
>>>>> 0xffffffff813ce19f
>>>>>
>>>>> On Wed, Dec 28, 2022 at 2:34 PM Kyle Sanderson <kyle.leet@gmail.com> =
wrote:
>>>>>>
>>>>>> On Tue, Dec 27, 2022 at 11:07 PM Neftin, Sasha <sasha.neftin@intel.c=
om> wrote:
>>>>>>>
>>>>>>> 1. Does the problem reproduce on the latest upstream kernel?(worth
>>>>>>> to check)
>>>>>>
>>>>>> The box is a bit problematic to try things on (it's all done through
>>>>>> the COM port).
>>>>>> Will try spinning an image for retail and seeing if it continues (I
>>>>>> did go back and look at the commits, post 5.15 the diffs looked like
>>>>>> cleanups).
>>>>>
>>>>> Yes, this is reproducible on 6.0.7. What I noticed though is, when th=
e device is operating in client mode (Fedora), I cannot reproduce the panic=
.
>>>>>
>>>>> The only way I was able to reproduce the panic was forwarding traffic=
 from another device, which was confirmed by turning on IP forwarding and p=
assing traffic from another asset (using the same fast.com test, this time =
on Fedora). Which means (I believe), this should be reproducible on Dual / =
Quad port NICs using igc as long as they're routing traffic through the sam=
e card.
>>>>>
>>>>> Based on the relatively recent availability of the phy, and most
>>>>> (noted) consumers using this single port onboard from a OEM it would =
be more difficult to encounter in the wild.
>>>>>
>>>>> Thank you very much for your help so far.
>>>>>
>>>>> K.
>>>>>
>>>>> On Wed, Dec 28, 2022 at 2:34 PM Kyle Sanderson <kyle.leet@gmail.com> =
wrote:
>>>>>>
>>>>>> On Tue, Dec 27, 2022 at 11:07 PM Neftin, Sasha <sasha.neftin@intel.c=
om> wrote:
>>>>>>>
>>>>>>> I do not know if it is an SW problem.
>>>>>>
>>>>>> I'm not experiencing the same failure on FBSD, so it's quite likely
>>>>>> software (somewhere :-)).
>>>>>>
>>>>>>> 1. Does the problem reproduce on the latest upstream kernel?(worth
>>>>>>> to check)
>>>>>>
>>>>>> The box is a bit problematic to try things on (it's all done through
>>>>>> the COM port).
>>>>>> Will try spinning an image for retail and seeing if it continues (I
>>>>>> did go back and look at the commits, post 5.15 the diffs looked like
>>>>>> cleanups).
>>>>>>
>>>>>>> 2. I do not see this crash in our labs. I haven't a platform with
>>>>>>> six
>>>>>>> i226 parts.(Trying find folks who work with this platform.)
>>>>>>
>>>>>> I'm not sure this (port count) is related. How I'm reproducing the
>>>>>> issue now is simply going to fast.com on a client with aggressive
>>>>>> settings (20cons minimum, 90s test duration), waiting until it
>>>>>> starts to buffer (latency increases, so packets are being deferred /
>>>>>> scheduled) then removing the ethernet cable from the laptop. The
>>>>>> device seems to operate indefinitely in this mode, and only when the
>>>>>> link comes back up, and traffic is sent again, do these kernels pani=
c.
>>>>>> It doesn't seem to matter how long the cable is disconnected for
>>>>>> (another trace below where I did it for 30s). If the resets are fast
>>>>>> enough, the failure seemed less likely to occur.
>>>>>>
>>>>>>> 3. I am working on a patch to address .ndo_tx_timeout support.
>>>>>>> (pass the reset task to netdev while the link disconnected during
>>>>>>> traffic, under testing). It could be related and worth checking -
>>>>>>> please, let me know if you want to apply on your platform (against =
upstream).
>>>>>>> Reach us (Dima, Amir, and me) directly off the list.
>>>>>>
>>>>>> Will try pending outcome on #1, If you can target the latest stable
>>>>>> RC that you're aware of that would be appreciated.
>>>>>>
>>>>>> [=C2=A0 =C2=A062.209563] igc 0000:01:00.0 eth0: Reset adapter
>>>>>> [=C2=A0 =C2=A089.560331] kernel BUG at lib/dynamic_queue_limits.c:27=
!
>>>>>> [=C2=A0 =C2=A089.567779] invalid opcode: 0000 [#1] SMP NOPTI
>>>>>> [=C2=A0 =C2=A089.573229] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5=
.15.85-amd64-vyos #1
>>>>>> [=C2=A0 =C2=A089.579989] ------------[ cut here ]------------
>>>>>> [=C2=A0 =C2=A089.581328] Hardware name: Default string Default strin=
g/Default
>>>>>> string, BIOS 5.19 09/23/2022
>>>>>> [=C2=A0 =C2=A089.581329] RIP: 0010:dql_completed+0x12f/0x140
>>>>>> [=C2=A0 =C2=A089.586873] kernel BUG at lib/dynamic_queue_limits.c:27=
!
>>>>>> [=C2=A0 =C2=A089.596627] Code: cf c9 00 48 89 57 58 e9 54 ff ff ff 8=
5 ed 40 0f
>>>>>> 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d8 e9 36
>>>>>> ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc cc 41 56
>>>>>> 49
>>>>>> 89 f3
>>>>>> [=C2=A0 =C2=A089.596630] RSP: 0018:ffffb3324018ce20 EFLAGS: 00010283
>>>>>> [=C2=A0 =C2=A089.636568] RAX: 0000000000000003 RBX: ffff97640754eb40=
 RCX: 0000000000000036
>>>>>> [=C2=A0 =C2=A089.644842] RDX: ffff976407704000 RSI: 0000000000000620=
 RDI: ffff976407708c80
>>>>>> [=C2=A0 =C2=A089.653108] RBP: 0000000000000000 R08: 000000000000a1f0=
 R09: da49cae6d4ba44ce
>>>>>> [=C2=A0 =C2=A089.661379] R10: 000000000000a226 R11: ffffffffa05fee80=
 R12: 0000000000000620
>>>>>> [=C2=A0 =C2=A089.669657] R13: ffff97640754eb40 R14: ffffb33240cf9540=
 R15: 00000000ffffff18
>>>>>> [=C2=A0 =C2=A089.677942] FS:=C2=A0 0000000000000000(0000) GS:ffff977=
33ff80000(0000)
>>>>>> knlGS:0000000000000000
>>>>>> [=C2=A0 =C2=A089.687275] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000=
00080050033
>>>>>> [=C2=A0 =C2=A089.694065] CR2: 00007f6c7c9e9b40 CR3: 000000064f610000=
 CR4: 0000000000350ee0
>>>>>> [=C2=A0 =C2=A089.702353] Call Trace:
>>>>>> [=C2=A0 =C2=A089.705549]=C2=A0 <IRQ>
>>>>>> [=C2=A0 =C2=A089.708269]=C2=A0 igc_poll+0x19d/0x14b0 [igc]
>>>>>> [=C2=A0 =C2=A089.713073]=C2=A0 ? __ip_finish_output+0xc0/0x1a0
>>>>>> [=C2=A0 =C2=A089.718255]=C2=A0 ? __netif_receive_skb_one_core+0x86/0=
xa0
>>>>>> [=C2=A0 =C2=A089.724269]=C2=A0 __napi_poll+0x22/0x110
>>>>>> [=C2=A0 =C2=A089.728597]=C2=A0 net_rx_action+0xe9/0x250
>>>>>> [=C2=A0 =C2=A089.733093]=C2=A0 ? igc_msix_ring+0x51/0x60 [igc]
>>>>>> [=C2=A0 =C2=A089.738230]=C2=A0 __do_softirq+0xb8/0x1e9
>>>>>> [=C2=A0 =C2=A089.742616]=C2=A0 irq_exit_rcu+0x84/0xb0
>>>>>> [=C2=A0 =C2=A089.746915]=C2=A0 common_interrupt+0x78/0x90
>>>>>> [=C2=A0 =C2=A089.751566]=C2=A0 </IRQ>
>>>>>> [=C2=A0 =C2=A089.754323]=C2=A0 <TASK>
>>>>>> [=C2=A0 =C2=A089.757070]=C2=A0 asm_common_interrupt+0x22/0x40
>>>>>> [=C2=A0 =C2=A089.762066] RIP: 0010:cpuidle_enter_state+0xb5/0x2a0
>>>>>> [=C2=A0 =C2=A089.767931] Code: c1 48 b2 ff 65 8b 3d b2 58 a9 60 e8 6=
5 47 b2 ff
>>>>>> 31 ff 49 89 c5 e8 6b 52 b2 ff 45 84 f6 0f 85 85 01 00 00 fb 66 0f 1f
>>>>>> 44 00 00 <45> 85 ff 0f 88 bb 00 00 00 49 63 c7 4c 2b 2c 24 48 8d 14
>>>>>> 40
>>>>>> 48 8d
>>>>>> [=C2=A0 =C2=A089.789731] RSP: 0018:ffffb332400ffea8 EFLAGS: 00000246
>>>>>> [=C2=A0 =C2=A089.795904] RAX: ffff97733ffa3440 RBX: 0000000000000003=
 RCX: 000000000000001f
>>>>>> [=C2=A0 =C2=A089.804138] RDX: 0000000000000000 RSI: 0000000046ec0743=
 RDI: 0000000000000000
>>>>>> [=C2=A0 =C2=A089.812376] RBP: ffff97733ffac910 R08: 00000014da35607b=
 R09: 00000014bbdae179
>>>>>> [=C2=A0 =C2=A089.820594] R10: 00000000000000e2 R11: 000000000000357c=
 R12: ffffffffa00ccb40
>>>>>> [=C2=A0 =C2=A089.828795] R13: 00000014da35607b R14: 0000000000000000=
 R15: 0000000000000003
>>>>>> [=C2=A0 =C2=A089.837026]=C2=A0 ? cpuidle_enter_state+0xa5/0x2a0
>>>>>> [=C2=A0 =C2=A089.842226]=C2=A0 cpuidle_enter+0x24/0x40
>>>>>> [=C2=A0 =C2=A089.846558]=C2=A0 do_idle+0x1e4/0x280
>>>>>> [=C2=A0 =C2=A089.850516]=C2=A0 cpu_startup_entry+0x14/0x20
>>>>>> [=C2=A0 =C2=A089.855223]=C2=A0 secondary_startup_64_no_verify+0xb0/0=
xbb
>>>>>> [=C2=A0 =C2=A089.861153]=C2=A0 </TASK>
>>>>>> [=C2=A0 =C2=A089.863953] Modules linked in: wireguard curve25519_x86=
_64
>>>>>> libcurve25519_generic libchacha20poly1305 chacha_x86_64
>>>>>> poly1305_x86_64 ip6_udp_tunnel udp_tunnel libchacha vrf nft_masq
>>>>>> nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip
>>>>>> nf_nat_pptp nf_conntrack_pptp nf_nat_h323 nf_conntrack_h323
>>>>>> nf_nat_ftp nf_conntrack_ftp nft_objref nft_counter nft_ct
>>>>>> nft_chain_nat nf_nat nf_tables nfnetlink_cthelper nf_conntrack
>>>>>> nf_defrag_ipv6
>>>>>> nf_defrag_ipv4 libcrc32c nfnetlink af_packet x86_pkg_temp_thermal
>>>>>> intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul
>>>>>> ghash_clmulni_intel aesni_intel crypto_simd cryptd intel_cstate
>>>>>> iTCO_wdt evdev mei_me pcspkr efi_pstore iTCO_vendor_support mei sg
>>>>>> tpm_crb tpm_tis tpm_tis_core tpm rng_core button acpi_pad
>>>>>> mpls_iptunnel mpls_router ip_tunnel br_netfilter bridge stp llc fuse
>>>>>> configfs efivarfs ip_tables x_tables autofs4 usb_storage ohci_hcd
>>>>>> uhci_hcd ehci_hcd squashfs zstd_decompress lz4_decompress loop
>>>>>> overlay
>>>>>> ext4 crc32c_generic crc16 mbcache jbd2 nls_cp437
>>>>>> [=C2=A0 =C2=A089.864000]=C2=A0 vfat fat efivars nls_ascii hid_generi=
c usbhid hid
>>>>>> sd_mod t10_pi xhci_pci ahci libahci libata crc32c_intel i2c_i801
>>>>>> i2c_smbus scsi_mod igc xhci_hcd scsi_common thermal fan
>>>>>> [=C2=A0 =C2=A089.982932] invalid opcode: 0000 [#2] SMP NOPTI
>>>>>> [=C2=A0 =C2=A089.982934] ---[ end trace b0c0da59c18b279b ]---
>>>>>> [=C2=A0 =C2=A089.988461] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G=C2=
=A0 =C2=A0 =C2=A0 D
>>>>>> =C2=A0 =C2=A05.15.85-amd64-vyos #1
>>>>>> [=C2=A0 =C2=A090.031995] Hardware name: Default string Default strin=
g/Default
>>>>>> string, BIOS 5.19 09/23/2022
>>>>>> [=C2=A0 =C2=A090.079903] RIP: 0010:dql_completed+0x12f/0x140
>>>>>> [=C2=A0 =C2=A090.099780] RIP: 0010:dql_completed+0x12f/0x140
>>>>>> [=C2=A0 =C2=A090.101151] Code: cf c9 00 48 89 57 58 e9 54 ff ff ff 8=
5 ed 40 0f
>>>>>> 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d8 e9 36
>>>>>> ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc cc 41 56
>>>>>> 49
>>>>>> 89 f3
>>>>>> [=C2=A0 =C2=A090.106717] Code: cf c9 00 48 89 57 58 e9 54 ff ff ff 8=
5 ed 40 0f
>>>>>> 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d8 e9 36
>>>>>> ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc cc 41 56
>>>>>> 49
>>>>>> 89 f3
>>>>>> [=C2=A0 =C2=A090.129020] RSP: 0018:ffffb33240003e20 EFLAGS: 00010293
>>>>>> [=C2=A0 =C2=A090.151344] RSP: 0018:ffffb3324018ce20 EFLAGS: 00010283
>>>>>> [=C2=A0 =C2=A090.157686] RAX: 0000000000000000 RBX: ffff97640754bb40=
 RCX: 0000000000000bd4
>>>>>> [=C2=A0 =C2=A090.157686]
>>>>>> [=C2=A0 =C2=A090.157687] RDX: ffff976407704000 RSI: 0000000000002966=
 RDI: ffff9764077088c0
>>>>>> [=C2=A0 =C2=A090.164026] RAX: 0000000000000003 RBX: ffff97640754eb40=
 RCX: 0000000000000036
>>>>>> [=C2=A0 =C2=A090.172433] RBP: 0000000000000000 R08: 000000000002bdba=
 R09: 0000000000000000
>>>>>> [=C2=A0 =C2=A090.174719] RDX: ffff976407704000 RSI: 0000000000000620=
 RDI: ffff976407708c80
>>>>>> [=C2=A0 =C2=A090.183146] R10: 000000000002c98e R11: ffffffffa05fee80=
 R12: 0000000000002966
>>>>>> [=C2=A0 =C2=A090.191560] RBP: 0000000000000000 R08: 000000000000a1f0=
 R09: da49cae6d4ba44ce
>>>>>> [=C2=A0 =C2=A090.199977] R13: ffff97640754bb40 R14: ffffb3324087d4c0=
 R15: 00000000ffffffa8
>>>>>> [=C2=A0 =C2=A090.208382] R10: 000000000000a226 R11: ffffffffa05fee80=
 R12: 0000000000000620
>>>>>> [=C2=A0 =C2=A090.216792] FS:=C2=A0 0000000000000000(0000) GS:ffff977=
33fe00000(0000)
>>>>>> knlGS:0000000000000000
>>>>>> [=C2=A0 =C2=A090.225213] R13: ffff97640754eb40 R14: ffffb33240cf9540=
 R15: 00000000ffffff18
>>>>>> [=C2=A0 =C2=A090.233641] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000=
00080050033
>>>>>> [=C2=A0 =C2=A090.242058] FS:=C2=A0 0000000000000000(0000) GS:ffff977=
33ff80000(0000)
>>>>>> knlGS:0000000000000000
>>>>>> [=C2=A0 =C2=A090.251492] CR2: 00007f6097a90010 CR3: 0000000101468000=
 CR4: 0000000000350ef0
>>>>>> [=C2=A0 =C2=A090.259887] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000=
00080050033
>>>>>> [=C2=A0 =C2=A090.266776] Call Trace:
>>>>>> [=C2=A0 =C2=A090.276193] CR2: 00007f6c7c9e9b40 CR3: 0000000104378000=
 CR4: 0000000000350ee0
>>>>>> [=C2=A0 =C2=A090.284596]=C2=A0 <IRQ>
>>>>>> [=C2=A0 =C2=A090.284597]=C2=A0 igc_poll+0x19d/0x14b0 [igc]
>>>>>> [=C2=A0 =C2=A090.291475] Kernel panic - not syncing: Fatal exception=
 in interrupt
>>>>>> [=C2=A0 =C2=A090.294754]=C2=A0 __napi_poll+0x22/0x110
>>>>>> [=C2=A0 =C2=A090.322584]=C2=A0 net_rx_action+0xe9/0x250
>>>>>> [=C2=A0 =C2=A090.327118]=C2=A0 ? igc_msix_ring+0x51/0x60 [igc]
>>>>>> [=C2=A0 =C2=A090.332311]=C2=A0 __do_softirq+0xb8/0x1e9
>>>>>> [=C2=A0 =C2=A090.336716]=C2=A0 irq_exit_rcu+0x84/0xb0
>>>>>> [=C2=A0 =C2=A090.341031]=C2=A0 common_interrupt+0x78/0x90
>>>>>> [=C2=A0 =C2=A090.345725]=C2=A0 </IRQ>
>>>>>> [=C2=A0 =C2=A090.348534]=C2=A0 <TASK>
>>>>>> [=C2=A0 =C2=A090.351325]=C2=A0 asm_common_interrupt+0x22/0x40
>>>>>> [=C2=A0 =C2=A090.356365] RIP: 0010:cpuidle_enter_state+0xb5/0x2a0
>>>>>> [=C2=A0 =C2=A090.362239] Code: c1 48 b2 ff 65 8b 3d b2 58 a9 60 e8 6=
5 47 b2 ff
>>>>>> 31 ff 49 89 c5 e8 6b 52 b2 ff 45 84 f6 0f 85 85 01 00 00 fb 66 0f 1f
>>>>>> 44 00 00 <45> 85 ff 0f 88 bb 00 00 00 49 63 c7 4c 2b 2c 24 48 8d 14
>>>>>> 40
>>>>>> 48 8d
>>>>>> [=C2=A0 =C2=A090.384058] RSP: 0018:ffffffffa0003e60 EFLAGS: 00000246
>>>>>> [=C2=A0 =C2=A090.390221] RAX: ffff97733fe23440 RBX: 0000000000000001=
 RCX: 000000000000001f
>>>>>> [=C2=A0 =C2=A090.398453] RDX: 0000000000000000 RSI: 0000000046ec0743=
 RDI: 0000000000000000
>>>>>> [=C2=A0 =C2=A090.406695] RBP: ffff97733fe2c910 R08: 00000014db620c58=
 R09: 0000000000000018
>>>>>> [=C2=A0 =C2=A090.414928] R10: 0000000000000259 R11: 00000000000000da=
 R12: ffffffffa00ccb40
>>>>>> [=C2=A0 =C2=A090.423151] R13: 00000014db620c58 R14: 0000000000000000=
 R15: 0000000000000001
>>>>>> [=C2=A0 =C2=A090.431387]=C2=A0 cpuidle_enter+0x24/0x40
>>>>>> [=C2=A0 =C2=A090.435751]=C2=A0 do_idle+0x1e4/0x280
>>>>>> [=C2=A0 =C2=A090.439733]=C2=A0 cpu_startup_entry+0x14/0x20
>>>>>> [=C2=A0 =C2=A090.444462]=C2=A0 start_kernel+0x627/0x650
>>>>>> [=C2=A0 =C2=A090.448909]=C2=A0 secondary_startup_64_no_verify+0xb0/0=
xbb
>>>>>> [=C2=A0 =C2=A090.454863]=C2=A0 </TASK>
>>>>>> [=C2=A0 =C2=A090.457714] Modules linked in: wireguard curve25519_x86=
_64
>>>>>> libcurve25519_generic libchacha20poly1305 chacha_x86_64
>>>>>> poly1305_x86_64 ip6_udp_tunnel udp_tunnel libchacha vrf nft_masq
>>>>>> nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip
>>>>>> nf_nat_pptp nf_conntrack_pptp nf_nat_h323 nf_conntrack_h323
>>>>>> nf_nat_ftp nf_conntrack_ftp nft_objref nft_counter nft_ct
>>>>>> nft_chain_nat nf_nat nf_tables nfnetlink_cthelper nf_conntrack
>>>>>> nf_defrag_ipv6
>>>>>> nf_defrag_ipv4 libcrc32c nfnetlink af_packet x86_pkg_temp_thermal
>>>>>> intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul
>>>>>> ghash_clmulni_intel aesni_intel crypto_simd cryptd intel_cstate
>>>>>> iTCO_wdt evdev mei_me pcspkr efi_pstore iTCO_vendor_support mei sg
>>>>>> tpm_crb tpm_tis tpm_tis_core tpm rng_core button acpi_pad
>>>>>> mpls_iptunnel mpls_router ip_tunnel br_netfilter bridge stp llc fuse
>>>>>> configfs efivarfs ip_tables x_tables autofs4 usb_storage ohci_hcd
>>>>>> uhci_hcd ehci_hcd squashfs zstd_decompress lz4_decompress loop
>>>>>> overlay
>>>>>> ext4 crc32c_generic crc16 mbcache jbd2 nls_cp437
>>>>>> [=C2=A0 =C2=A090.457755]=C2=A0 vfat fat efivars nls_ascii hid_generi=
c usbhid hid
>>>>>> sd_mod t10_pi xhci_pci ahci libahci libata crc32c_intel i2c_i801
>>>>>> i2c_smbus scsi_mod igc xhci_hcd scsi_common thermal fan
>>>>>> [=C2=A0 =C2=A090.576795] Kernel Offset: 0x1e000000 from 0xffffffff81=
000000
>>>>>> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>>>>>> [=C2=A0 =C2=A090.704454] ---[ end Kernel panic - not syncing: Fatal =
exception in
>>>>>> interrupt ]---
>>>>>>
>>>>>> K.
>>>>>>
>>>>>> On Tue, Dec 27, 2022 at 11:07 PM Neftin, Sasha <sasha.neftin@intel.c=
om> wrote:
>>>>>>>
>>>>>>> On 12/28/2022 06:45, Kyle Sanderson wrote:
>>>>>>>>
>>>>>>>> hi Intel IGC Maintainers,
>>>>>>>>
>>>>>>>> I've managed to reproduce this issue on 5.15.85 (same steps to
>>>>>>>> reproduce), and have symbols and line numbers in the below panic.
>>>>>>>> There's no device support in 5.4 for this hardware, so I was
>>>>>>>> unable to reproduce the issue there in igc.
>>>>>>>>
>>>>>>>> =C2=A0 From the Kernel BUG_ON, it's being asked to read beyond the
>>>>>>>> array size. The min call looks very suspicious (igb, and other
>>>>>>>> drives don't appear to do that), but I don't know if that's where =
the issue is.
>>>>>>>>
>>>>>>>> Please let me know if there's anything more I can do to help.
>>>>>>>
>>>>>>> I do not know if it is an SW problem.
>>>>>>> 1. Does the problem reproduce on the latest upstream kernel?(worth
>>>>>>> to check) 2. I do not see this crash in our labs. I haven't a
>>>>>>> platform with six
>>>>>>> i226 parts.(Trying find folks who work with this platform.) 3. I
>>>>>>> am working on a patch to address .ndo_tx_timeout support. (pass
>>>>>>> the reset task to netdev while the link disconnected during
>>>>>>> traffic, under testing). It could be related and worth checking -
>>>>>>> please, let me know if you want to apply on your platform (against =
upstream).
>>>>>>> Reach us (Dima, Amir, and me) directly off the list.
>>>>>>>>
>>>>>>>> [=C2=A0 223.725003] igc 0000:01:00.0 eth0: Reset adapter [
>>>>>>>> 233.139441] kernel BUG at lib/dynamic_queue_limits.c:27!
>>>>>>>> [=C2=A0 233.146814] invalid opcode: 0000 [#1] SMP NOPTI [
>>>>>>>> 233.146816]
>>>>>>>> refcount_t: saturated; leaking memory.
>>>>>>>> [=C2=A0 233.146833] WARNING: CPU: 0 PID: 0 at lib/refcount.c:19
>>>>>>>> refcount_warn_saturate+0x97/0x110
>>>>>>>> [=C2=A0 233.153243] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G=C2=A0=
 =C2=A0 =C2=A0 =C2=A0 W
>>>>>>>> =C2=A0 =C2=A0 5.15.85-amd64-vyos #1
>>>>>>>> [=C2=A0 233.159216] Modules linked in:
>>>>>>>> [=C2=A0 233.168451] Hardware name: Default string Default
>>>>>>>> string/Default string, BIOS 5.19 09/23/2022 [=C2=A0 233.177895]
>>>>>>>> wireguard [=C2=A0 233.181645] RIP: 0010:dql_completed+0x12f/0x140 =
[
>>>>>>>> 233.191360]=C2=A0 curve25519_x86_64 [=C2=A0 233.194406] Code: cf c=
9 00 48
>>>>>>>> 89
>>>>>>>> 57 58 e9 54 ff ff ff 85 ed 40 0f
>>>>>>>> 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d8
>>>>>>>> e9
>>>>>>>> 36 ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc cc
>>>>>>>> 41 56 49
>>>>>>>> 89 f3
>>>>>>>> [=C2=A0 233.199767]=C2=A0 libcurve25519_generic [=C2=A0 233.203540=
] RSP:
>>>>>>>> 0018:ffffa85dc0134e20 EFLAGS: 00010283 [=C2=A0 233.225248]
>>>>>>>> libchacha20poly1305 [=C2=A0 233.229417] [=C2=A0 233.229417] RAX:
>>>>>>>> 0000000000000001 RBX: ffff934002104b40 RCX: 00000000000005ea [
>>>>>>>> 233.235539]=C2=A0 chacha_x86_64 [=C2=A0 233.239508] RDX: ffff93400=
2110000
>>>>>>>> RSI: 0000000000001d92 RDI: ffff93400211a200 [=C2=A0 233.241606]
>>>>>>>> poly1305_x86_64 [=C2=A0 233.249796] RBP: 0000000000000000 R08:
>>>>>>>> 000000000004ad4e R09: 0000000000000000 [=C2=A0 233.253226]
>>>>>>>> ip6_udp_tunnel [=C2=A0 233.261445] R10: 000000000004b338 R11:
>>>>>>>> ffffffffbabfee80 R12: 0000000000001d92 [=C2=A0 233.261446] R13:
>>>>>>>> ffff934002104b40 R14: ffffa85dc09d1450 R15: 00000000ffffffa6 [
>>>>>>>> 233.265054]=C2=A0 udp_tunnel [=C2=A0 233.273314] FS:
>>>>>>>> 0000000000000000(0000)
>>>>>>>> GS:ffff934f3fe80000(0000)
>>>>>>>> knlGS:0000000000000000
>>>>>>>> [=C2=A0 233.276826]=C2=A0 libchacha
>>>>>>>> [=C2=A0 233.285023] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 00000000=
80050033
>>>>>>>> [ 233.285025] CR2: 00007f294393fe84 CR3: 0000000605e10000 CR4:
>>>>>>>> 0000000000350ee0 [=C2=A0 233.285026] Call Trace:
>>>>>>>> [=C2=A0 233.285026]=C2=A0 <IRQ>
>>>>>>>> [=C2=A0 233.285027]=C2=A0 igc_poll+0x19d/0x14b0 [igc] [=C2=A0 233.=
293242]=C2=A0 vrf
>>>>>>>> [ 233.296396]=C2=A0 __napi_poll+0x22/0x110 [=C2=A0 233.305688]=C2=
=A0 nft_masq [
>>>>>>>> 233.308763]=C2=A0 net_rx_action+0xe9/0x250 [=C2=A0 233.315455]
>>>>>>>> nf_nat_tftp [=C2=A0 233.323756]=C2=A0 ? igc_msix_ring+0x51/0x60 [i=
gc] [
>>>>>>>> 233.326946] nf_conntrack_tftp [=C2=A0 233.329661]
>>>>>>>> __do_softirq+0xb8/0x1e9 [ 233.334471]=C2=A0 nf_nat_sip [=C2=A0 233=
.336991]
>>>>>>>> irq_exit_rcu+0x84/0xb0 [ 233.341290]=C2=A0 nf_conntrack_sip [
>>>>>>>> 233.344284]
>>>>>>>> common_interrupt+0x78/0x90 [=C2=A0 233.348778]=C2=A0 nf_nat_pptp [
>>>>>>>> 233.352104]=C2=A0 </IRQ> [=C2=A0 233.357240]=C2=A0 nf_conntrack_pp=
tp [
>>>>>>>> 233.361052]=C2=A0 <TASK> [=C2=A0 233.365360]=C2=A0 nf_nat_h323 [=
=C2=A0 233.368484]
>>>>>>>> asm_common_interrupt+0x22/0x40 [=C2=A0 233.372723]=C2=A0 nf_conntr=
ack_h323
>>>>>>>> [ 233.376363] RIP: 0010:cpuidle_enter_state+0xb5/0x2a0
>>>>>>>> [=C2=A0 233.380952]=C2=A0 nf_nat_ftp
>>>>>>>> [=C2=A0 233.384155] Code: c1 48 b2 ff 65 8b 3d b2 58 49 46 e8 65 4=
7
>>>>>>>> b2 ff
>>>>>>>> 31 ff 49 89 c5 e8 6b 52 b2 ff 45 84 f6 0f 85 85 01 00 00 fb 66
>>>>>>>> 0f 1f
>>>>>>>> 44 00 00 <45> 85 ff 0f 88 bb 00 00 00 49 63 c7 4c 2b 2c 24 48 8d
>>>>>>>> 14 40
>>>>>>>> 48 8d
>>>>>>>> [=C2=A0 233.386840]=C2=A0 nf_conntrack_ftp [=C2=A0 233.390553] RSP=
:
>>>>>>>> 0018:ffffa85dc00efea8 EFLAGS: 00000246 [ 233.393224]=C2=A0 nft_obj=
ref
>>>>>>>> [=C2=A0 233.396340] [=C2=A0 233.396340] RAX:
>>>>>>>> ffff934f3fea3440 RBX: 0000000000000003 RCX: 000000000000001f [
>>>>>>>> 233.401256]=C2=A0 nft_counter [=C2=A0 233.404981] RDX: 00000000000=
00000 RSI:
>>>>>>>> 0000000046ec0743 RDI: 0000000000000000 [=C2=A0 233.410769]=C2=A0 n=
ft_ct [
>>>>>>>> 233.413816] RBP: ffff934f3feac910 R08: 00000036481c5d1b R09:
>>>>>>>> 0000003605db0041 [=C2=A0 233.435320]=C2=A0 nft_chain_nat [=C2=A0 2=
33.438947] R10:
>>>>>>>> 0000000000000072 R11: 0000000000000164 R12: ffffffffba6ccb40 [
>>>>>>>> 233.445014]=C2=A0 nf_nat [=C2=A0 233.448065] R13: 00000036481c5d1b=
 R14:
>>>>>>>> 0000000000000000 R15: 0000000000000003 [=C2=A0 233.450073]=C2=A0 n=
f_tables
>>>>>>>> [ 233.458210]=C2=A0 ? cpuidle_enter_state+0xa5/0x2a0 [=C2=A0 233.4=
61335]
>>>>>>>> nfnetlink_cthelper [=C2=A0 233.469449]=C2=A0 cpuidle_enter+0x24/0x=
40 [
>>>>>>>> 233.472106]=C2=A0 nf_conntrack [=C2=A0 233.480247]=C2=A0 do_idle+0=
x1e4/0x280 [
>>>>>>>> 233.483580]=C2=A0 nf_defrag_ipv6 [=C2=A0 233.491703]
>>>>>>>> cpu_startup_entry+0x14/0x20 [=C2=A0 233.494399]=C2=A0 nf_defrag_ip=
v4 [
>>>>>>>> 233.502517]=C2=A0 secondary_startup_64_no_verify+0xb0/0xbb
>>>>>>>> [=C2=A0 233.505503]=C2=A0 libcrc32c
>>>>>>>> [=C2=A0 233.510641]=C2=A0 </TASK>
>>>>>>>> [=C2=A0 233.514474]=C2=A0 nfnetlink
>>>>>>>> [=C2=A0 233.518787] Modules linked in: wireguard [=C2=A0 233.52206=
5]
>>>>>>>> af_packet [=C2=A0 233.525975]=C2=A0 curve25519_x86_64 [=C2=A0 233.=
529441]
>>>>>>>> x86_pkg_temp_thermal [=C2=A0 233.534136]=C2=A0 libcurve25519_gener=
ic [
>>>>>>>> 233.537612]=C2=A0 intel_powerclamp [=C2=A0 233.543511]
>>>>>>>> libchacha20poly1305 [=C2=A0 233.546508]=C2=A0 coretemp [=C2=A0 233=
.549313]
>>>>>>>> chacha_x86_64
>>>>>>>> poly1305_x86_64 [=C2=A0 233.552304]=C2=A0 crct10dif_pclmul [=C2=A0=
 233.556981]
>>>>>>>> ip6_udp_tunnel udp_tunnel libchacha vrf nft_masq nf_nat_tftp
>>>>>>>> nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_pptp
>>>>>>>> nf_conntrack_pptp nf_nat_h323 nf_conntrack_h323 nf_nat_ftp
>>>>>>>> nf_conntrack_ftp [=C2=A0 233.559990]=C2=A0 crc32_pclmul [=C2=A0 23=
3.563754]
>>>>>>>> nft_objref nft_counter [=C2=A0 233.567791]=C2=A0 ghash_clmulni_int=
el [
>>>>>>>> 233.571912]=C2=A0 nft_ct [=C2=A0 233.575569]=C2=A0 aesni_intel [=
=C2=A0 233.579500]
>>>>>>>> nft_chain_nat [=C2=A0 233.582390]=C2=A0 crypto_simd [=C2=A0 233.58=
7225]=C2=A0 nf_nat
>>>>>>>> [ 233.590841]=C2=A0 cryptd [=C2=A0 233.612012]=C2=A0 nf_tables [=
=C2=A0 233.615288]
>>>>>>>> intel_cstate [=C2=A0 233.619486]=C2=A0 nfnetlink_cthelper [=C2=A0 =
233.623388]
>>>>>>>> iTCO_wdt [=C2=A0 233.626063]=C2=A0 nf_conntrack [=C2=A0 233.629196=
]=C2=A0 efi_pstore
>>>>>>>> [ 233.632499]=C2=A0 nf_defrag_ipv6 [=C2=A0 233.635597]=C2=A0 pcspk=
r [
>>>>>>>> 233.638218]
>>>>>>>> nf_defrag_ipv4 [=C2=A0 233.640825]=C2=A0 evdev [=C2=A0 233.643700]=
=C2=A0 libcrc32c [
>>>>>>>> 233.646869]=C2=A0 iTCO_vendor_support [=C2=A0 233.650591]=C2=A0 nf=
netlink [
>>>>>>>> 233.653355]=C2=A0 sg [=C2=A0 233.656497]=C2=A0 af_packet [=C2=A0 2=
33.659446]
>>>>>>>> tpm_crb [=C2=A0 233.662775]=C2=A0 x86_pkg_temp_thermal [=C2=A0 233=
.665337]
>>>>>>>> tpm_tis [ 233.668670]=C2=A0 intel_powerclamp [=C2=A0 233.671144]
>>>>>>>> tpm_tis_core [ 233.673993]=C2=A0 coretemp [=C2=A0 233.677768]=C2=
=A0 tpm [
>>>>>>>> 233.680591] crct10dif_pclmul [=C2=A0 233.682782]=C2=A0 rng_core [
>>>>>>>> 233.685624] crc32_pclmul [=C2=A0 233.688271]=C2=A0 mei_me [=C2=A0 =
233.692161]
>>>>>>>> ghash_clmulni_intel [=C2=A0 233.694799]=C2=A0 mei [=C2=A0 233.6982=
90]
>>>>>>>> aesni_intel [=C2=A0 233.701384]=C2=A0 button [=C2=A0 233.704125]=
=C2=A0 crypto_simd [
>>>>>>>> 233.706379]=C2=A0 acpi_pad [=C2=A0 233.709861]=C2=A0 cryptd [=C2=
=A0 233.712587]
>>>>>>>> mpls_iptunnel [=C2=A0 233.715682]=C2=A0 intel_cstate [=C2=A0 233.7=
18177]
>>>>>>>> mpls_router [=C2=A0 233.721872]=C2=A0 iTCO_wdt [=C2=A0 233.724077]=
=C2=A0 ip_tunnel [
>>>>>>>> 233.727034]=C2=A0 efi_pstore [=C2=A0 233.729533]=C2=A0 br_netfilte=
r [
>>>>>>>> 233.732471]=C2=A0 pcspkr [=C2=A0 233.735139]=C2=A0 bridge [=C2=A0 =
233.737627]=C2=A0 evdev
>>>>>>>> [ 233.740768]=C2=A0 stp [=C2=A0 233.743827]=C2=A0 iTCO_vendor_supp=
ort [
>>>>>>>> 233.746789]=C2=A0 llc [=C2=A0 233.749457]=C2=A0 sg [=C2=A0 233.752=
222]=C2=A0 fuse [
>>>>>>>> 233.755071]=C2=A0 tpm_crb [=C2=A0 233.758113]=C2=A0 configfs [=C2=
=A0 233.760589]
>>>>>>>> tpm_tis [=C2=A0 233.763065]=C2=A0 efivarfs [=C2=A0 233.765437]=C2=
=A0 tpm_tis_core [
>>>>>>>> 233.767622]=C2=A0 ip_tables [=C2=A0 233.771314]=C2=A0 tpm [=C2=A0 =
233.773511]
>>>>>>>> x_tables [=C2=A0 233.775607]=C2=A0 rng_core [=C2=A0 233.777893]=C2=
=A0 autofs4 [
>>>>>>>> 233.780456]=C2=A0 mei_me [=C2=A0 233.783120]=C2=A0 usb_storage [=
=C2=A0 233.785686]
>>>>>>>> mei [=C2=A0 233.788319]=C2=A0 ohci_hcd [=C2=A0 233.791358]=C2=A0 b=
utton [
>>>>>>>> 233.794104] uhci_hcd [=C2=A0 233.796287]=C2=A0 acpi_pad [=C2=A0 23=
3.798948]
>>>>>>>> ehci_hcd [ 233.801608]=C2=A0 mpls_iptunnel [=C2=A0 233.804146]=C2=
=A0 squashfs [
>>>>>>>> 233.806598] mpls_router [=C2=A0 233.809530]=C2=A0 zstd_decompress =
[
>>>>>>>> 233.811719] ip_tunnel [=C2=A0 233.814378]=C2=A0 lz4_decompress [
>>>>>>>> 233.816841] br_netfilter [=C2=A0 233.819492]=C2=A0 loop [=C2=A0 23=
3.822152]
>>>>>>>> bridge [ 233.824802]=C2=A0 overlay [=C2=A0 233.827927]=C2=A0 stp [=
=C2=A0 233.830564]
>>>>>>>> ext4 [ 233.833498]=C2=A0 llc [=C2=A0 233.836805]=C2=A0 crc32c_gene=
ric [
>>>>>>>> 233.839557] fuse [=C2=A0 233.842787]=C2=A0 crc16 [=C2=A0 233.84581=
5]=C2=A0 configfs
>>>>>>>> [=C2=A0 233.848084] mbcache [=C2=A0 233.850564]=C2=A0 efivarfs [=
=C2=A0 233.853117]
>>>>>>>> jbd2 [ 233.855296]=C2=A0 ip_tables [=C2=A0 233.857561]=C2=A0 nls_c=
p437 [
>>>>>>>> 233.859722] x_tables autofs4 [=C2=A0 233.862950]=C2=A0 vfat [=C2=
=A0 233.865216]
>>>>>>>> usb_storage [=C2=A0 233.867585]=C2=A0 fat [=C2=A0 233.870239]=C2=
=A0 ohci_hcd
>>>>>>>> uhci_hcd [ 233.872779]=C2=A0 efivars [=C2=A0 233.875414]=C2=A0 ehc=
i_hcd [
>>>>>>>> 233.877693] nls_ascii [=C2=A0 233.880433]=C2=A0 squashfs zstd_deco=
mpress [
>>>>>>>> 233.883172] hid_generic [=C2=A0 233.886580]=C2=A0 lz4_decompress [
>>>>>>>> 233.888861]=C2=A0 usbhid [=C2=A0 233.891803]=C2=A0 loop [=C2=A0 23=
3.893980]=C2=A0 hid [
>>>>>>>> 233.897493]=C2=A0 overlay [ 233.900050]=C2=A0 sd_mod [=C2=A0 233.9=
02702]=C2=A0 ext4
>>>>>>>> [=C2=A0 233.905446]=C2=A0 t10_pi [ 233.909612]=C2=A0 crc32c_generi=
c [
>>>>>>>> 233.912548]=C2=A0 ahci [=C2=A0 233.915776]
>>>>>>>> crc16 [=C2=A0 233.918244]=C2=A0 libahci [=C2=A0 233.920540]=C2=A0 =
mbcache [
>>>>>>>> 233.922740]=C2=A0 crc32c_intel [=C2=A0 233.925303]=C2=A0 jbd2 [=C2=
=A0 233.927777]
>>>>>>>> libata [=C2=A0 233.930058]=C2=A0 nls_cp437 [=C2=A0 233.932530]=C2=
=A0 i2c_i801 [
>>>>>>>> 233.935740]=C2=A0 vfat fat [=C2=A0 233.938022]=C2=A0 i2c_smbus [=
=C2=A0 233.940397]
>>>>>>>> efivars [=C2=A0 233.942945]=C2=A0 xhci_pci [=C2=A0 233.945504]=C2=
=A0 nls_ascii
>>>>>>>> hid_generic [=C2=A0 233.948535]=C2=A0 xhci_hcd [=C2=A0 233.950814]=
=C2=A0 usbhid [
>>>>>>>> 233.953282]=C2=A0 scsi_mod [=C2=A0 233.956022]=C2=A0 hid [=C2=A0 2=
33.958671]
>>>>>>>> scsi_common [=C2=A0 233.961327]=C2=A0 sd_mod t10_pi [=C2=A0 233.96=
4066]=C2=A0 igc [
>>>>>>>> 233.966618]=C2=A0 ahci [=C2=A0 233.969274]=C2=A0 thermal [=C2=A0 2=
33.973168]
>>>>>>>> libahci [=C2=A0 233.975830]=C2=A0 fan [=C2=A0 233.978310]=C2=A0 cr=
c32c_intel [
>>>>>>>> 233.980975] [ 233.983158]=C2=A0 libata
>>>>>>>> [=C2=A0 233.986113] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G=C2=A0=
 =C2=A0 =C2=A0 =C2=A0 W
>>>>>>>> =C2=A0 =C2=A0 5.15.85-amd64-vyos #1
>>>>>>>> [=C2=A0 233.989257]=C2=A0 i2c_i801
>>>>>>>> [=C2=A0 233.991441] Hardware name: Default string Default
>>>>>>>> string/Default string, BIOS 5.19 09/23/2022 [=C2=A0 233.993730]
>>>>>>>> i2c_smbus [=C2=A0 233.996286] RIP:
>>>>>>>> 0010:refcount_warn_saturate+0x97/0x110
>>>>>>>> [=C2=A0 233.998850]=C2=A0 xhci_pci
>>>>>>>> [=C2=A0 234.001055] Code: 00 01 e8 cb 40 42 00 0f 0b c3 cc cc cc c=
c
>>>>>>>> 80 3d
>>>>>>>> 39 f4 da 00 00 75 a8 48 c7 c7 d8 13 43 ba c6 05 29 f4 da 00 01
>>>>>>>> e8
>>>>>>>> a8
>>>>>>>> 40 42 00 <0f> 0b c3 cc cc cc cc 80 3d 13 f4 da 00 00 75 85 48 c7
>>>>>>>> c7 30
>>>>>>>> 14 43
>>>>>>>> [=C2=A0 234.004069]=C2=A0 xhci_hcd scsi_mod [=C2=A0 234.005878] RS=
P:
>>>>>>>> 0018:ffffa85dc0003ae0 EFLAGS: 00010282 [ 234.008348]
>>>>>>>> scsi_common igc [=C2=A0 234.017611] [=C2=A0 234.020297] thermal fa=
n [
>>>>>>>> 234.029764] RAX: 0000000000000000 RBX:
>>>>>>>> 0000000000005837 RCX: 0000000000000000 [=C2=A0 234.032559] [
>>>>>>>> 234.032585] ---[ end trace 8acd09a29bf2e660 ]--- [=C2=A0 234.03845=
8]
>>>>>>>> RDX: ffff934f3fe1f3e0 RSI: ffff934f3fe1c490 RDI:
>>>>>>>> 0000000000000300 [=C2=A0 234.141617] RIP:
>>>>>>>> 0010:dql_completed+0x12f/0x140 [=C2=A0 234.146459]
>>>>>>>> RBP: ffff9340074b28c0 R08: 0000000000000000 R09:
>>>>>>>> ffffa85dc0003908 [=C2=A0 234.150075] Code: cf c9 00 48 89 57 58 e9=
 54
>>>>>>>> ff ff ff 85 ed 40 0f
>>>>>>>> 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d8
>>>>>>>> e9
>>>>>>>> 36 ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc cc
>>>>>>>> 41 56 49
>>>>>>>> 89 f3
>>>>>>>> [=C2=A0 234.156048] R10: ffffa85dc0003900 R11: ffffffffba6b0ce8 R1=
2:
>>>>>>>> ffff9340074b2908 [=C2=A0 234.159502] RSP: 0018:ffffa85dc0134e20 EF=
LAGS:
>>>>>>>> 00010283 [=C2=A0 234.161442] R13: ffffffffba28eb60 R14:
>>>>>>>> fffffffffffffff0 R15: ffffa85dc0003b40 [=C2=A0 234.164506] [
>>>>>>>> 234.172573] FS:=C2=A0 0000000000000000(0000)
>>>>>>>> GS:ffff934f3fe00000(0000)
>>>>>>>> knlGS:0000000000000000
>>>>>>>> [=C2=A0 234.174545] RAX: 0000000000000001 RBX: ffff934002104b40 RC=
X:
>>>>>>>> 00000000000005ea [=C2=A0 234.179914] CS:=C2=A0 0010 DS: 0000 ES: 0=
000 CR0:
>>>>>>>> 0000000080050033 [=C2=A0 234.188023] RDX: ffff934002110000 RSI:
>>>>>>>> 0000000000001d92 RDI: ffff93400211a200 [=C2=A0 234.193301] CR2:
>>>>>>>> 000055e26436ee10 CR3: 0000000605e10000 CR4: 0000000000350ef0 [
>>>>>>>> 234.201457] RBP: 0000000000000000 R08: 000000000004ad4e R09: 00000=
00000000000 [=C2=A0 234.223063] Call Trace:
>>>>>>>> [=C2=A0 234.231267] R10: 000000000004b338 R11: ffffffffbabfee80 R1=
2:
>>>>>>>> 0000000000001d92 [=C2=A0 234.237398]=C2=A0 <IRQ> [=C2=A0 234.24561=
3] R13:
>>>>>>>> ffff934002104b40 R14: ffffa85dc09d1450 R15: 00000000ffffffa6 [
>>>>>>>> 234.247734]=C2=A0 __nf_conntrack_find_get+0x331/0x340 [nf_conntrac=
k]
>>>>>>>> [ 234.256997] FS:=C2=A0 0000000000000000(0000)
>>>>>>>> GS:ffff934f3fe80000(0000)
>>>>>>>> knlGS:0000000000000000
>>>>>>>> [=C2=A0 234.265245]=C2=A0 nf_conntrack_in+0x1e1/0x760 [nf_conntrac=
k] [
>>>>>>>> 234.271954] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033=
 [
>>>>>>>> 234.280252]=C2=A0 nf_hook_slow+0x37/0xb0 [=C2=A0 234.288537] CR2:
>>>>>>>> 00007f294393fe84 CR3: 000000011da48000 CR4: 0000000000350ee0 [
>>>>>>>> 234.296788]=C2=A0 nf_hook_slow_list+0x8c/0x130 [=C2=A0 234.300002]=
 Kernel
>>>>>>>> panic - not syncing: Fatal exception in interrupt [=C2=A0 234.3083=
39]
>>>>>>>> ip_sublist_rcv+0x1fa/0x220 [=C2=A0 234.319422] Kernel Offset:
>>>>>>>> 0x38600000 from 0xffffffff81000000 (relocation range:
>>>>>>>> 0xffffffff80000000-0xffffffffbfffffff)
>>>>>>>> [=C2=A0 234.494681] ---[ end Kernel panic - not syncing: Fatal
>>>>>>>> exception in interrupt ]---
>>>>>>>>
>>>>>>>> Kyle.
>>>>>>>>
>>>>>>>> On Tue, Dec 20, 2022 at 10:29 AM Kyle Sanderson <kyle.leet@gmail.c=
om> wrote:
>>>>>>>>>
>>>>>>>>> re-sending as plain text - my apologies.
>>>>>>>>>
>>>>>>>>>> On Sun, 18 Dec 2022, 23:31 Neftin, Sasha wrote:
>>>>>>>>>> What is a board in use (LAN on board or NIC)?
>>>>>>>>>> What is lspci, lspci -t and lspci -s 0000:[lan bus:device.functi=
on] -vvv output?
>>>>>>>>>
>>>>>>>>> It's embedded on the board, could very well be on a bridge
>>>>>>>>> though as a card. The box has 6 ports, 2 were in-use while testin=
g.
>>>>>>>>>
>>>>>>>>> 00:00.0 Host bridge: Intel Corporation Device 4522 (rev 01)
>>>>>>>>> 00:02.0 VGA compatible controller: Intel Corporation Elkhart
>>>>>>>>> Lake [UHD Graphics Gen11 16EU] (rev 01)
>>>>>>>>> 00:08.0 System peripheral: Intel Corporation Device 4511 (rev
>>>>>>>>> 01)
>>>>>>>>> 00:14.0 USB controller: Intel Corporation Device 4b7d (rev 11)
>>>>>>>>> 00:14.2 RAM memory: Intel Corporation Device 4b7f (rev 11)
>>>>>>>>> 00:16.0 Communication controller: Intel Corporation Device 4b70
>>>>>>>>> (rev 11)
>>>>>>>>> 00:17.0 SATA controller: Intel Corporation Device 4b63 (rev 11)
>>>>>>>>> 00:1c.0 PCI bridge: Intel Corporation Device 4b38 (rev 11)
>>>>>>>>> 00:1c.1 PCI bridge: Intel Corporation Device 4b39 (rev 11)
>>>>>>>>> 00:1c.2 PCI bridge: Intel Corporation Device 4b3a (rev 11)
>>>>>>>>> 00:1c.3 PCI bridge: Intel Corporation Device 4b3b (rev 11)
>>>>>>>>> 00:1c.4 PCI bridge: Intel Corporation Device 4b3c (rev 11)
>>>>>>>>> 00:1c.6 PCI bridge: Intel Corporation Device 4b3e (rev 11)
>>>>>>>>> 00:1f.0 ISA bridge: Intel Corporation Device 4b00 (rev 11)
>>>>>>>>> 00:1f.3 Audio device: Intel Corporation Device 4b58 (rev 11)
>>>>>>>>> 00:1f.4 SMBus: Intel Corporation Device 4b23 (rev 11)
>>>>>>>>> 00:1f.5 Serial bus controller: Intel Corporation Device 4b24
>>>>>>>>> (rev
>>>>>>>>> 11)
>>>>>>>>> 01:00.0 Ethernet controller: Intel Corporation Device 125c (rev
>>>>>>>>> 04)
>>>>>>>>> 02:00.0 Ethernet controller: Intel Corporation Device 125c (rev
>>>>>>>>> 04)
>>>>>>>>> 03:00.0 Ethernet controller: Intel Corporation Device 125c (rev
>>>>>>>>> 04)
>>>>>>>>> 04:00.0 Ethernet controller: Intel Corporation Device 125c (rev
>>>>>>>>> 04)
>>>>>>>>> 05:00.0 Ethernet controller: Intel Corporation Device 125c (rev
>>>>>>>>> 04)
>>>>>>>>> 06:00.0 Ethernet controller: Intel Corporation Device 125c (rev
>>>>>>>>> 04)
>>>>>>>>>
>>>>>>>>> -[0000:00]-+-00.0
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-02.0
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-08.0
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-14.0
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-14.2
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-16.0
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-17.0
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-1c.0-[01]----00=
.0
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-1c.1-[02]----00=
.0
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-1c.2-[03]----00=
.0
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-1c.3-[04]----00=
.0
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-1c.4-[05]----00=
.0
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-1c.6-[06]----00=
.0
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-1f.0
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-1f.3
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+-1f.4
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\-1f.5
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> 01:00.0 Ethernet controller: Intel Corporation Device 125c (rev 0=
4)
>>>>>>>>> =C2=A0 =C2=A0Subsystem: Intel Corporation Device 0000
>>>>>>>>> =C2=A0 =C2=A0Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VG=
ASnoop-
>>>>>>>>> ParErr-
>>>>>>>>> Stepping- SERR- FastB2B- DisINTx+
>>>>>>>>> =C2=A0 =C2=A0Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Df=
ast
>>>>>>>>>>
>>>>>>>>>> TAbort-
>>>>>>>>>
>>>>>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>>>>> =C2=A0 =C2=A0Latency: 0
>>>>>>>>> =C2=A0 =C2=A0Interrupt: pin A routed to IRQ 16
>>>>>>>>> =C2=A0 =C2=A0Region 0: Memory at 80600000 (32-bit, non-prefetchab=
le) [size=3D1M]
>>>>>>>>> =C2=A0 =C2=A0Region 3: Memory at 80700000 (32-bit, non-prefetchab=
le) [size=3D16K]
>>>>>>>>> =C2=A0 =C2=A0Capabilities: [40] Power Management version 3
>>>>>>>>> =C2=A0 =C2=A0 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0=
+,D1-,D2-,D3hot+,D3cold+)
>>>>>>>>> =C2=A0 =C2=A0 Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=
=3D1 PME-
>>>>>>>>> =C2=A0 =C2=A0Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable=
+ 64bit+
>>>>>>>>> =C2=A0 =C2=A0 Address: 0000000000000000 Data: 0000
>>>>>>>>> =C2=A0 =C2=A0 Masking: 00000000 Pending: 00000000
>>>>>>>>> =C2=A0 =C2=A0Capabilities: [70] MSI-X: Enable+ Count=3D5 Masked-
>>>>>>>>> =C2=A0 =C2=A0 Vector table: BAR=3D3 offset=3D00000000
>>>>>>>>> =C2=A0 =C2=A0 PBA: BAR=3D3 offset=3D00002000
>>>>>>>>> =C2=A0 =C2=A0Capabilities: [a0] Express (v2) Endpoint, MSI 00
>>>>>>>>> =C2=A0 =C2=A0 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency =
L0s <512ns, L1 <64us
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLRese=
t+ SlotPowerLimit 0W
>>>>>>>>> =C2=A0 =C2=A0 DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ =
FLReset-
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0MaxPayload 128 bytes, MaxReadReq 512 bytes
>>>>>>>>> =C2=A0 =C2=A0 DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- A=
uxPwr+ TransPend-
>>>>>>>>> =C2=A0 =C2=A0 LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L1, Ex=
it Latency L1 <4us
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0ClockPM- Surprise- LLActRep- BwNot- ASPMOptCo=
mp+
>>>>>>>>> =C2=A0 =C2=A0 LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- Comm=
Clk+
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt=
-
>>>>>>>>> =C2=A0 =C2=A0 LnkSta: Speed 5GT/s, Width x1
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWM=
gmt-
>>>>>>>>> =C2=A0 =C2=A0 DevCap2: Completion Timeout: Range ABCD, TimeoutDis=
+ NROPrPrP- LTR+
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 10BitTagComp- 10BitTagReq- OBFF Not Supporte=
d, ExtFmt- EETLPPrefix-
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 EmergencyPowerReduction Not Supported, Emerg=
encyPowerReductionInit-
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 FRS- TPHComp- ExtTPHComp-
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 AtomicOpsCap: 32bit- 64bit- 128bitCAS-
>>>>>>>>> =C2=A0 =C2=A0 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutD=
is- LTR+
>>>>>>>>> 10BitTagReq- OBFF Disabled,
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 AtomicOpsCtl: ReqEn-
>>>>>>>>> =C2=A0 =C2=A0 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-=
 SpeedDis-
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 Transmit Margin: Normal Operating Range,
>>>>>>>>> EnterModifiedCompliance-
>>>>>>>>> ComplianceSOS-
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 Compliance Preset/De-emphasis: -6dB de-empha=
sis, 0dB preshoot
>>>>>>>>> =C2=A0 =C2=A0 LnkSta2: Current De-emphasis Level: -6dB,
>>>>>>>>> EqualizationComplete-
>>>>>>>>> EqualizationPhase1-
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 EqualizationPhase2- EqualizationPhase3- Link=
EqualizationRequest-
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 Retimer- 2Retimers- CrosslinkRes: unsupporte=
d
>>>>>>>>> =C2=A0 =C2=A0Capabilities: [100 v2] Advanced Error Reporting
>>>>>>>>> =C2=A0 =C2=A0 UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- Unx=
Cmplt-
>>>>>>>>> RxOF-
>>>>>>>>> MalfTLP- ECRC- UnsupReq- ACSViol-
>>>>>>>>> =C2=A0 =C2=A0 UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- Unx=
Cmplt-
>>>>>>>>> RxOF-
>>>>>>>>> MalfTLP- ECRC- UnsupReq- ACSViol-
>>>>>>>>> =C2=A0 =C2=A0 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- Un=
xCmplt-
>>>>>>>>> RxOF+
>>>>>>>>> MalfTLP+ ECRC- UnsupReq- ACSViol-
>>>>>>>>> =C2=A0 =C2=A0 CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- A=
dvNonFatalErr-
>>>>>>>>> =C2=A0 =C2=A0 CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- A=
dvNonFatalErr+
>>>>>>>>> =C2=A0 =C2=A0 AERCap: First Error Pointer: 00, ECRCGenCap+ ECRCGe=
nEn- ECRCChkCap+ ECRCChkEn-
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrL=
ogCap-
>>>>>>>>> =C2=A0 =C2=A0 HeaderLog: 00000000 00000000 00000000 00000000
>>>>>>>>> =C2=A0 =C2=A0Capabilities: [140 v1] Device Serial Number e4-3a-6e=
-ff-ff-5d-bb-54
>>>>>>>>> =C2=A0 =C2=A0Capabilities: [1c0 v1] Latency Tolerance Reporting
>>>>>>>>> =C2=A0 =C2=A0 Max snoop latency: 3145728ns
>>>>>>>>> =C2=A0 =C2=A0 Max no snoop latency: 3145728ns
>>>>>>>>> =C2=A0 =C2=A0Capabilities: [1f0 v1] Precision Time Measurement
>>>>>>>>> =C2=A0 =C2=A0 PTMCap: Requester:+ Responder:- Root:-
>>>>>>>>> =C2=A0 =C2=A0 PTMClockGranularity: 4ns
>>>>>>>>> =C2=A0 =C2=A0 PTMControl: Enabled:- RootSelected:-
>>>>>>>>> =C2=A0 =C2=A0 PTMEffectiveGranularity: Unknown
>>>>>>>>> =C2=A0 =C2=A0Capabilities: [1e0 v1] L1 PM Substates
>>>>>>>>> =C2=A0 =C2=A0 L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM=
_L1.1+ L1_PM_Substates+
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0PortCommonModeRestoreTime=3D55us PortT=
PowerOnTime=3D70us
>>>>>>>>> =C2=A0 =C2=A0 L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASP=
M_L1.1-
>>>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 T_CommonMode=3D0us LTR1.2_Threshold=
=3D81920ns
>>>>>>>>> =C2=A0 =C2=A0 L1SubCtl2: T_PwrOn=3D50us
>>>>>>>>> =C2=A0 =C2=A0Kernel driver in use: igc
>>>>>>>>> =C2=A0 =C2=A0Kernel modules: igc
>>>>>>>>>
>>>>>>>>> On Sun, Dec 18, 2022 at 10:31 PM Neftin, Sasha <sasha.neftin@inte=
l.com> wrote:
>>>>>>>>>>
>>>>>>>>>> On 12/16/2022 00:28, Kyle Sanderson wrote:
>>>>>>>>>>>
>>>>>>>>>>> (Un)fortunately I can reproduce this bug by simply removing
>>>>>>>>>>> the ethernet cable from the box while there is traffic flowing.
>>>>>>>>>>> kprint below from a console line. Please CC / to me for any
>>>>>>>>>>> additional information I can provide for this panic.
>>>>>>>>>>
>>>>>>>>>> What is a board in use (LAN on board or NIC)? What is lspci,
>>>>>>>>>> lspci -t and lspci -s 0000:[lan bus:device.function] -vvv output=
?
>>>>>>>>>>>
>>>>>>>>>>> [=C2=A0 156.707054] igc 0000:01:00.0 eth0: NIC Link is Down [
>>>>>>>>>>> 156.712981] br-lan: port 1(eth0) entered disabled state [
>>>>>>>>>>> 156.719246] igc 0000:01:00.0 eth0: Register Dump
>>>>>>>>>>> [=C2=A0 156.724784] igc 0000:01:00.0 eth0: Register Name=C2=A0 =
=C2=A0Value
>>>>>>>>>>> [=C2=A0 156.731067] igc 0000:01:00.0 eth0: CTRL=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 181c0641
>>>>>>>>>>> [=C2=A0 156.737607] igc 0000:01:00.0 eth0: STATUS=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 00380681
>>>>>>>>>>> [=C2=A0 156.744133] igc 0000:01:00.0 eth0: CTRL_EXT=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 100000c0
>>>>>>>>>>> [=C2=A0 156.750759] igc 0000:01:00.0 eth0: MDIC=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 18017949
>>>>>>>>>>> [=C2=A0 156.757258] igc 0000:01:00.0 eth0: ICR=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A000000001
>>>>>>>>>>> [=C2=A0 156.763785] igc 0000:01:00.0 eth0: RCTL=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0440803a
>>>>>>>>>>> [=C2=A0 156.770324] igc 0000:01:00.0 eth0: RDLEN[0-3]=C2=A0 =C2=
=A0 =C2=A0 00001000
>>>>>>>>>>> 00001000 00001000 00001000
>>>>>>>>>>> [=C2=A0 156.779457] igc 0000:01:00.0 eth0: RDH[0-3]=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 000000ef
>>>>>>>>>>> 000000a1 00000092 000000ba
>>>>>>>>>>> [=C2=A0 156.788500] igc 0000:01:00.0 eth0: RDT[0-3]=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 000000ee
>>>>>>>>>>> 000000a0 00000091 000000b9
>>>>>>>>>>> [=C2=A0 156.797650] igc 0000:01:00.0 eth0: RXDCTL[0-3]=C2=A0 =
=C2=A0 =C2=A002040808
>>>>>>>>>>> 02040808 02040808 02040808
>>>>>>>>>>> [=C2=A0 156.806688] igc 0000:01:00.0 eth0: RDBAL[0-3]=C2=A0 =C2=
=A0 =C2=A0 02f43000
>>>>>>>>>>> 02180000 02e7f000 02278000
>>>>>>>>>>> [=C2=A0 156.815781] igc 0000:01:00.0 eth0: RDBAH[0-3]=C2=A0 =C2=
=A0 =C2=A0 00000001
>>>>>>>>>>> 00000001 00000001 00000001
>>>>>>>>>>> [=C2=A0 156.824928] igc 0000:01:00.0 eth0: TCTL=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 a503f0fa
>>>>>>>>>>> [=C2=A0 156.831587] igc 0000:01:00.0 eth0: TDBAL[0-3]=C2=A0 =C2=
=A0 =C2=A0 02f43000
>>>>>>>>>>> 02180000 02e7f000 02278000
>>>>>>>>>>> [=C2=A0 156.840637] igc 0000:01:00.0 eth0: TDBAH[0-3]=C2=A0 =C2=
=A0 =C2=A0 00000001
>>>>>>>>>>> 00000001 00000001 00000001
>>>>>>>>>>> [=C2=A0 156.849753] igc 0000:01:00.0 eth0: TDLEN[0-3]=C2=A0 =C2=
=A0 =C2=A0 00001000
>>>>>>>>>>> 00001000 00001000 00001000
>>>>>>>>>>> [=C2=A0 156.858760] igc 0000:01:00.0 eth0: TDH[0-3]=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 000000d4
>>>>>>>>>>> 0000003d 000000af 0000002a
>>>>>>>>>>> [=C2=A0 156.867771] igc 0000:01:00.0 eth0: TDT[0-3]=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 000000e4
>>>>>>>>>>> 0000005a 000000c8 0000002a
>>>>>>>>>>> [=C2=A0 156.876864] igc 0000:01:00.0 eth0: TXDCTL[0-3]=C2=A0 =
=C2=A0 =C2=A002100108
>>>>>>>>>>> 02100108 02100108 02100108
>>>>>>>>>>> [=C2=A0 156.885905] igc 0000:01:00.0 eth0: Reset adapter [
>>>>>>>>>>> 160.307195] igc 0000:01:00.0 eth0: NIC Link is Up 1000 Mbps
>>>>>>>>>>> Full Duplex, Flow Control: RX/TX [=C2=A0 160.317974] br-lan: po=
rt
>>>>>>>>>>> 1(eth0) entered blocking state [=C2=A0 160.324532] br-lan: port
>>>>>>>>>>> 1(eth0) entered forwarding state [=C2=A0 161.197263] ----------=
--[
>>>>>>>>>>> cut here ]------------ [=C2=A0 161.202669] Kernel BUG at
>>>>>>>>>>> 0xffffffff813ce19f [verbose debug info unavailable] [
>>>>>>>>>>> 161.210769] invalid opcode: 0000 [#1] SMP NOPTI [
>>>>>>>>>>> 161.216022]
>>>>>>>>>>> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.10.146 #0 [
>>>>>>>>>>> 161.222980] Hardware name: Default string Default
>>>>>>>>>>> string/Default string, BIOS 5.19 09/23/2022 [=C2=A0 161.232546]=
 RIP:
>>>>>>>>>>> 0010:0xffffffff813ce19f [=C2=A0 161.237167] Code: 03 01 4c 89 4=
8
>>>>>>>>>>> 58
>>>>>>>>>>> e9 2f ff ff ff 85 db 41 0f 95
>>>>>>>>>>> c2 45 39 d9 41 0f 95 c1 45 84 ca 74 05 45 85 e4 78 0a 44 89
>>>>>>>>>>> c2
>>>>>>>>>>> e9 10 ff ff ff <0f> 0b 01 d2 45 89 c1 41 29 d1 ba 00 00 00 00
>>>>>>>>>>> 44 0f 48 ca eb
>>>>>>>>>>> 80 cc
>>>>>>>>>>> [=C2=A0 161.258651] RSP: 0018:ffffc90000118e88 EFLAGS: 00010283=
 [
>>>>>>>>>>> 161.264736] RAX: ffff888101f8f200 RBX: ffffc900006f9bd0 RCX:
>>>>>>>>>>> 000000000000050e [=C2=A0 161.272837] RDX: ffff888101fec000 RSI:
>>>>>>>>>>> 0000000000000a1c RDI: 0000000000061a10 [=C2=A0 161.280942] RBP:
>>>>>>>>>>> ffffc90000118ef8 R08: 0000000000000000 R09: 0000000000061502
>>>>>>>>>>> [ 161.289089] R10: 0000000000000000 R11: 0000000000000000 R12:
>>>>>>>>>>> 00000000ffffff3f [=C2=A0 161.297229] R13: ffff888101f8f140 R14:
>>>>>>>>>>> 0000000000000000 R15: ffff888100ad9b00 [=C2=A0 161.305345] FS:
>>>>>>>>>>> 0000000000000000(0000) GS:ffff88903fe80000(0000)
>>>>>>>>>>> knlGS:00000 00000000000
>>>>>>>>>>> [=C2=A0 161.314492] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0:
>>>>>>>>>>> 0000000080050033 [=C2=A0 161.321139] CR2: 00007f941ad43a9b CR3:
>>>>>>>>>>> 000000000340a000 CR4: 0000000000350ee0 [=C2=A0 161.329284] Call=
 Trace:
>>>>>>>>>>> [=C2=A0 161.332373]=C2=A0 <IRQ>
>>>>>>>>>>> [=C2=A0 161.334981]=C2=A0 ? 0xffffffffa0185f78
>>>>>>>>>>> [igc@00000000f400031b+0x13000] [=C2=A0 161.341949]
>>>>>>>>>>> 0xffffffff8185b047 [=C2=A0 161.345797]=C2=A0 0xffffffff8185b2ca=
 [
>>>>>>>>>>> 161.349637]=C2=A0 0xffffffff81e000bb [=C2=A0 161.353465]
>>>>>>>>>>> 0xffffffff81c0109f [=C2=A0 161.357304]=C2=A0 </IRQ> [=C2=A0 161=
.359988]
>>>>>>>>>>> 0xffffffff8102cdac [=C2=A0 161.363783]=C2=A0 0xffffffff810bfdaf=
 [
>>>>>>>>>>> 161.367584]=C2=A0 0xffffffff81a2e616 [=C2=A0 161.371374]
>>>>>>>>>>> 0xffffffff81c00c9e [=C2=A0 161.375192] RIP:
>>>>>>>>>>> 0010:0xffffffff817e331b [=C2=A0 161.379840] Code: 21 90 ff 65 8=
b
>>>>>>>>>>> 3d 45 23 83 7e e8 80 20 90 ff 31 ff 49 89 c6 e8 26 2d 90 ff
>>>>>>>>>>> 80 7d d7 00 0f 85 9e 01 00 00 fb 66 0f 1f
>>>>>>>>>>> 44 00 00 <45> 85 ff 0f 88 cf 00 00 00 49 63 cf 48 8d 04 49 48
>>>>>>>>>>> 8d 14 81
>>>>>>>>>>> 48 c1
>>>>>>>>>>> [=C2=A0 161.401397] RSP: 0018:ffffc900000d3e80 EFLAGS: 00000246=
 [
>>>>>>>>>>> 161.407493] RAX: ffff88903fea5180 RBX: ffff88903feadf00 RCX:
>>>>>>>>>>> 000000000000001f [=C2=A0 161.415648] RDX: 0000000000000000 RSI:
>>>>>>>>>>> 0000000046ec0743 RDI: 0000000000000000 [=C2=A0 161.423811] RBP:
>>>>>>>>>>> ffffc900000d3eb8 R08: 00000025881a3b81 R09: ffff888100317340
>>>>>>>>>>> [ 161.432003] R10: 0000000000000001 R11: 0000000000000000 R12:
>>>>>>>>>>> 0000000000000003 [=C2=A0 161.440154] R13: ffffffff824c7bc0 R14:
>>>>>>>>>>> 00000025881a3b81 R15: 0000000000000003 [=C2=A0 161.448285]
>>>>>>>>>>> 0xffffffff817e357f [=C2=A0 161.452123]=C2=A0 0xffffffff810e6258=
 [
>>>>>>>>>>> 161.455938]=C2=A0 0xffffffff810e63fb [=C2=A0 161.459746]
>>>>>>>>>>> 0xffffffff8104bec0 [=C2=A0 161.463526]=C2=A0 0xffffffff810000f5=
 [
>>>>>>>>>>> 161.467290] Modules linked in: pppoe ppp_async nft_fib_inet
>>>>>>>>>>> nf_flow_table_ipv 6 nf_flow_table_ipv4 nf_flow_table_inet
>>>>>>>>>>> wireguard pppox ppp_generic nft_reject_i pv6 nft_reject_ipv4
>>>>>>>>>>> nft_reject_inet nft_reject nft_redir nft_quota nft_objref nf
>>>>>>>>>>> t_numgen nft_nat nft_masq nft_log nft_limit nft_hash
>>>>>>>>>>> nft_flow_offload nft_fib_ip v6 nft_fib_ipv4 nft_fib nft_ct
>>>>>>>>>>> nft_counter nft_chain_nat nf_tables nf_nat nf_flo w_table
>>>>>>>>>>> nf_conntrack libchacha20poly1305 curve25519_x86_64
>>>>>>>>>>> chacha_x86_64 slhc r8 169 poly1305_x86_64 nfnetlink
>>>>>>>>>>> nf_reject_ipv6
>>>>>>>>>>> nf_reject_ipv4 nf_log_ipv6 nf_log_i pv4 nf_log_common
>>>>>>>>>>> nf_defrag_ipv6
>>>>>>>>>>> nf_defrag_ipv4 libcurve25519_generic libcrc32c libchacha igc
>>>>>>>>>>> forcedeth e1000e crc_ccitt bnx2 i2c_dev ixgbe e1000 amd_xgbe
>>>>>>>>>>> ip6_u dp_tunnel udp_tunnel mdio nls_utf8 ena kpp
>>>>>>>>>>> nls_iso8859_1
>>>>>>>>>>> nls_cp437 vfat fat igb button_hotplug tg3 ptp realtek
>>>>>>>>>>> pps_core mii [=C2=A0 161.550507] ---[ end trace b1cb18ab2d1741b=
d
>>>>>>>>>>> ]--- [ 161.555938] RIP: 0010:0xffffffff813ce19f [=C2=A0 161.560=
634] Code:
>>>>>>>>>>> 03 01 4c 89 48 58 e9 2f ff ff ff 85 db 41 0f 95
>>>>>>>>>>> c2 45 39 d9 41 0f 95 c1 45 84 ca 74 05 45 85 e4 78 0a 44 89
>>>>>>>>>>> c2
>>>>>>>>>>> e9 10 ff ff ff <0f> 0b 01 d2 45 89 c1 41 29 d1 ba 00 00 00 00
>>>>>>>>>>> 44 0f 48 ca eb
>>>>>>>>>>> 80 cc
>>>>>>>>>>> [=C2=A0 161.582281] RSP: 0018:ffffc90000118e88 EFLAGS: 00010283=
 [
>>>>>>>>>>> 161.588426] RAX: ffff888101f8f200 RBX: ffffc900006f9bd0 RCX:
>>>>>>>>>>> 000000000000050e [=C2=A0 161.596668] RDX: ffff888101fec000 RSI:
>>>>>>>>>>> 0000000000000a1c RDI: 0000000000061a10 [=C2=A0 161.604860] RBP:
>>>>>>>>>>> ffffc90000118ef8 R08: 0000000000000000 R09: 0000000000061502
>>>>>>>>>>> [ 161.613052] R10: 0000000000000000 R11: 0000000000000000 R12:
>>>>>>>>>>> 00000000ffffff3f [=C2=A0 161.621291] R13: ffff888101f8f140 R14:
>>>>>>>>>>> 0000000000000000 R15: ffff888100ad9b00 [=C2=A0 161.629505] FS:
>>>>>>>>>>> 0000000000000000(0000) GS:ffff88903fe80000(0000)
>>>>>>>>>>> knlGS:00000 00000000000
>>>>>>>>>>> [=C2=A0 161.638781] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0:
>>>>>>>>>>> 0000000080050033 [=C2=A0 161.645549] CR2: 00007f941ad43a9b CR3:
>>>>>>>>>>> 000000000340a000 CR4: 0000000000350ee0 [=C2=A0 161.653841] Kern=
el
>>>>>>>>>>> panic - not syncing: Fatal exception in interrupt [
>>>>>>>>>>> 161.661287] Kernel Offset: disabled [=C2=A0 161.665644] Rebooti=
ng in 3 seconds..
>>>>>>>>>>> [=C2=A0 164.670313] ACPI MEMORY or I/O RESET_REG.
>>>>>>>>>>>
>>>>>>>>>>> Kyle.
>>>>>>>>>>> _______________________________________________
>>>>>>>>>>> Intel-wired-lan mailing list
>>>>>>>>>>> Intel-wired-lan@osuosl.org
>>>>>>>>>>> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
>>>>>>>>>>
>>>>>>>
>
>
