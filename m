Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DC16593E5
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 01:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbiL3Atp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 19:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiL3Ato (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 19:49:44 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE73515F12;
        Thu, 29 Dec 2022 16:49:40 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id h27so6288929vsq.3;
        Thu, 29 Dec 2022 16:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cG2XkDaU2GusbSRxfQENLNyYze+JZyOiStHWHfd7dzw=;
        b=ouW6K099a6s16zrnCrVGknfVSxFc3LREF0TvZ1hImKA33zYqevVaA6hWFuSss1iMRj
         XSPuVOB4vq6a1uyJpjmrd4cmQz+q3/Ogv8h8cwXLIJojXMmZ7KripxregeT1Pupr0/qU
         nUb2uWGdJ8uhNeKraHFpnkCI3l2et/IpzFuHP0N2e6ljM5cfL1hopk0y3hyasx/EyKfb
         wrm8LdFKokWdj0v3j0/G/rCdTtIpwyBLfMdXRf/AN2P/VKNWbHfEe4HqQJRrpUqIhQcD
         gV2LzdtVTPxebwfL0R0XBbvWce4vyKI26oxt8cKNrNR1dEEPq39yXIENywxIAP20xUZc
         Cy9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cG2XkDaU2GusbSRxfQENLNyYze+JZyOiStHWHfd7dzw=;
        b=3nQ5oM+VBR/8aXpdi4hbYRP1bLIRS/AdWeZX1PBNDKHI1B0lmNyf6RPHGVXmuBcXyD
         OX7gheXTwkfGQQ1E17lPVzT7aCbNHIBjT/0RdpQWnAr28LF5lUFjJdRskrN//PdH7lfi
         HZ4P8uXbNEfW9VwvHpHJO5OBrn0uKuHkSbvhG6CNltg28YOGIsG5C+Z9AMGVkq32o5Dv
         6jc7H/gz42vTGJzYtMXZKfk24SKCni2Ibcr6IziLa+DCu8yekM3Gy2h+7pcomC1YXasf
         boz6UkWSmoC2kI1CYe9gUmAmbiLZZ7MMzg6nOS+Lyo2X4mqgqyVlnkjSBi02Yhm9MDJy
         JVCg==
X-Gm-Message-State: AFqh2krqWxzC1dJb/KqxI6HQxXTeAw+OzsA7iRrRkKmJ/0EuiGWsrHoE
        93nY4LHX5UCUru5UHWp/PAD4aHSaPm5CIlbBY5E=
X-Google-Smtp-Source: AMrXdXueQkIQzNHoBJQbdQFu/zawF2PiKied3iiyKga0yV6c3wcXZ/AHDaktqPWylQZ78/d3X4mcJbeT2T+lR5BA3YQ=
X-Received: by 2002:a05:6102:819:b0:3b0:af48:e6b2 with SMTP id
 g25-20020a056102081900b003b0af48e6b2mr3318555vsb.38.1672361379785; Thu, 29
 Dec 2022 16:49:39 -0800 (PST)
MIME-Version: 1.0
References: <CACsaVZL6ykbsVvEaV2Cv3r6m_jKt04MEUOw5=mSnR5AYTyE7qg@mail.gmail.com>
 <a752422c-4630-e53d-c9cd-cc9ed866f853@intel.com> <CACsaVZJXqkWGOQhe-GzRKJSfYn-3+dZTyHNZC97npCxzqr+R9g@mail.gmail.com>
 <CACsaVZLh0WFu1p7TUxE=RwucoTcZwsfQ5+ivorcbwCiRneeVFg@mail.gmail.com>
 <70eea40e-808c-e9ee-9aab-617ebe67d67c@intel.com> <CACsaVZ+icDmY15bqHuSR=KUBx0tbpDVXasuuYPjWg6aVAyy2hg@mail.gmail.com>
 <CACsaVZKr=B6xNrxM_J60+pg48onQf1jQJYNRDLwgESje_fN13Q@mail.gmail.com>
 <BYAPR11MB2727764EB94F647479731DAB96F39@BYAPR11MB2727.namprd11.prod.outlook.com>
 <CACsaVZJnKMcAtKdfgNKSzH8VNW-Lw5JN=+C+CDHcotpZJQCaeQ@mail.gmail.com> <BYAPR11MB2727B1CA9A658119793B2F7896F39@BYAPR11MB2727.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB2727B1CA9A658119793B2F7896F39@BYAPR11MB2727.namprd11.prod.outlook.com>
From:   Kyle Sanderson <kyle.leet@gmail.com>
Date:   Thu, 29 Dec 2022 16:49:28 -0800
Message-ID: <CACsaVZJTZon4VZ5X35o1avkKrskkcU_Qfru7FMTYHJ+cPeXpnw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] igc: 5.10.146 Kernel BUG at 0xffffffff813ce19f
To:     "MP, Sureshkumar" <sureshkumar.mp@intel.com>
Cc:     "Neftin, Sasha" <sasha.neftin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        "Torvalds, Linus" <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "naamax.meir" <naamax.meir@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>
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

On Thu, Dec 29, 2022 at 1:21 AM MP, Sureshkumar
<sureshkumar.mp@intel.com> wrote:
> 1. Can you share the HW and SW BKC used to do this experiment?

This is a retail appliance. They ship with FBSD out of the box
(OPNsense / pfSense), or a Windows OS. I'm hoping we can fix Linux
support for these.
The NICs are embedded on the board, as to the bus they're using it's
beyond me as an end consumer (basically an stb with a console port).

> 2. How about this test results with i225 AIC on these kernels?

I don't have this controller, but now that we know the steps to
reproduce (enable IP Forwarding and send traffic until buffering
happens) it should be reproducible by anyone.

> 3. Did you test this with kernel.org igc driver code on these kernels? If=
 yes, share the results.

Yes. Kernel panic'd (from the BUG_ON) on 5.10, 5.15, and 6.0.

> 4. How did you connect 6x i226 AICs in the EHL board?

Port 1 and Port 6. Using the ports independently doesn't seem to
reproduce the issue, and is only when traffic is forwarded between
them.

> 5. Did you test with 1x i226 AIC on these kernels in EHL board?

Yes, the problem does not persist. 2 NICs need to be used (on igc),
with traffic passing between them.

K.

On Thu, Dec 29, 2022 at 1:21 AM MP, Sureshkumar
<sureshkumar.mp@intel.com> wrote:
>
> Ok K.
>
> 1. Can you share the HW and SW BKC used to do this experiment?
> 2. How about this test results with i225 AIC on these kernels?
> 3. Did you test this with kernel.org igc driver code on these kernels? If=
 yes, share the results.
> 4. How did you connect 6x i226 AICs in the EHL board?
> 5. Did you test with 1x i226 AIC on these kernels in EHL board?
>
> Best Regards,
> Sureshkumar
>
> -----Original Message-----
> From: Kyle Sanderson <kyle.leet@gmail.com>
> Sent: Thursday, December 29, 2022 9:58 AM
> To: MP, Sureshkumar <sureshkumar.mp@intel.com>
> Cc: Neftin, Sasha <sasha.neftin@intel.com>; intel-wired-lan@lists.osuosl.=
org; Ruinskiy, Dima <dima.ruinskiy@intel.com>; Avivi, Amir <amir.avivi@inte=
l.com>; Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L <=
anthony.l.nguyen@intel.com>; Linux-Kernel <linux-kernel@vger.kernel.org>; T=
orvalds, Linus <torvalds@linux-foundation.org>; netdev@vger.kernel.org; Lif=
shits, Vitaly <vitaly.lifshits@intel.com>; naamax.meir <naamax.meir@linux.i=
ntel.com>; Greg KH <gregkh@linuxfoundation.org>
> Subject: Re: [Intel-wired-lan] igc: 5.10.146 Kernel BUG at 0xffffffff813c=
e19f
>
> On Wed, Dec 28, 2022 at 8:12 PM MP, Sureshkumar <sureshkumar.mp@intel.com=
> wrote:
> >
> > Not getting the exact issue here. Can someone explain what is the issue=
 with i226 in EHL platform?
> >
> > Best Regards,
> > Sureshkumar
>
> hi Sureshkumar,
>
> If you forward traffic on an igc kmod NIC the kernel will panic with the =
call traces provided from the three different kernel versions.
> This happens when there's traffic passing through the nic, and the cable =
is removed. When the cable is returned to the device, the panic occurs. Eac=
h controller (as far as I'm aware) is exposed as a standalone device.
>
> This has never worked on 5.10, 5.15, or 6.0 kernels. There is no device s=
upport on 5.4, so I can't test that far back unfortunately. We also don't k=
now if it's exclusive to this phy, or if it's impacting other devices using=
 the kmod.
>
> K.
>
> On Wed, Dec 28, 2022 at 8:12 PM MP, Sureshkumar <sureshkumar.mp@intel.com=
> wrote:
> >
> > Not getting the exact issue here. Can someone explain what is the issue=
 with i226 in EHL platform?
> >
> > Best Regards,
> > Sureshkumar
> >
> > -----Original Message-----
> > From: Kyle Sanderson <kyle.leet@gmail.com>
> > Sent: Thursday, December 29, 2022 8:18 AM
> > To: Neftin, Sasha <sasha.neftin@intel.com>;
> > intel-wired-lan@lists.osuosl.org; Ruinskiy, Dima
> > <dima.ruinskiy@intel.com>; Avivi, Amir <amir.avivi@intel.com>
> > Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com>; MP, Sureshkumar
> > <sureshkumar.mp@intel.com>; Linux-Kernel
> > <linux-kernel@vger.kernel.org>; Torvalds, Linus
> > <torvalds@linux-foundation.org>; netdev@vger.kernel.org; Lifshits,
> > Vitaly <vitaly.lifshits@intel.com>; naamax.meir
> > <naamax.meir@linux.intel.com>; Greg KH <gregkh@linuxfoundation.org>;
> > therbert@google.com
> > Subject: Re: [Intel-wired-lan] igc: 5.10.146 Kernel BUG at
> > 0xffffffff813ce19f
> >
> > On Wed, Dec 28, 2022 at 2:34 PM Kyle Sanderson <kyle.leet@gmail.com> wr=
ote:
> > >
> > > On Tue, Dec 27, 2022 at 11:07 PM Neftin, Sasha <sasha.neftin@intel.co=
m> wrote:
> > > > 1. Does the problem reproduce on the latest upstream kernel?(worth
> > > > to check)
> > >
> > > The box is a bit problematic to try things on (it's all done through
> > > the COM port).
> > > Will try spinning an image for retail and seeing if it continues (I
> > > did go back and look at the commits, post 5.15 the diffs looked like
> > > cleanups).
> >
> > Yes, this is reproducible on 6.0.7. What I noticed though is, when the =
device is operating in client mode (Fedora), I cannot reproduce the panic.
> >
> > The only way I was able to reproduce the panic was forwarding traffic f=
rom another device, which was confirmed by turning on IP forwarding and pas=
sing traffic from another asset (using the same fast.com test, this time on=
 Fedora). Which means (I believe), this should be reproducible on Dual / Qu=
ad port NICs using igc as long as they're routing traffic through the same =
card.
> >
> > Based on the relatively recent availability of the phy, and most
> > (noted) consumers using this single port onboard from a OEM it would be=
 more difficult to encounter in the wild.
> >
> > Thank you very much for your help so far.
> >
> > K.
> >
> > On Wed, Dec 28, 2022 at 2:34 PM Kyle Sanderson <kyle.leet@gmail.com> wr=
ote:
> > >
> > > On Tue, Dec 27, 2022 at 11:07 PM Neftin, Sasha <sasha.neftin@intel.co=
m> wrote:
> > > >
> > > > I do not know if it is an SW problem.
> > >
> > > I'm not experiencing the same failure on FBSD, so it's quite likely
> > > software (somewhere :-)).
> > >
> > > > 1. Does the problem reproduce on the latest upstream kernel?(worth
> > > > to check)
> > >
> > > The box is a bit problematic to try things on (it's all done through
> > > the COM port).
> > > Will try spinning an image for retail and seeing if it continues (I
> > > did go back and look at the commits, post 5.15 the diffs looked like
> > > cleanups).
> > >
> > > > 2. I do not see this crash in our labs. I haven't a platform with
> > > > six
> > > > i226 parts.(Trying find folks who work with this platform.)
> > >
> > > I'm not sure this (port count) is related. How I'm reproducing the
> > > issue now is simply going to fast.com on a client with aggressive
> > > settings (20cons minimum, 90s test duration), waiting until it
> > > starts to buffer (latency increases, so packets are being deferred /
> > > scheduled) then removing the ethernet cable from the laptop. The
> > > device seems to operate indefinitely in this mode, and only when the
> > > link comes back up, and traffic is sent again, do these kernels panic=
.
> > > It doesn't seem to matter how long the cable is disconnected for
> > > (another trace below where I did it for 30s). If the resets are fast
> > > enough, the failure seemed less likely to occur.
> > >
> > > > 3. I am working on a patch to address .ndo_tx_timeout support.
> > > > (pass the reset task to netdev while the link disconnected during
> > > > traffic, under testing). It could be related and worth checking -
> > > > please, let me know if you want to apply on your platform (against =
upstream).
> > > > Reach us (Dima, Amir, and me) directly off the list.
> > >
> > > Will try pending outcome on #1, If you can target the latest stable
> > > RC that you're aware of that would be appreciated.
> > >
> > > [   62.209563] igc 0000:01:00.0 eth0: Reset adapter
> > > [   89.560331] kernel BUG at lib/dynamic_queue_limits.c:27!
> > > [   89.567779] invalid opcode: 0000 [#1] SMP NOPTI
> > > [   89.573229] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 5.15.85-amd6=
4-vyos #1
> > > [   89.579989] ------------[ cut here ]------------
> > > [   89.581328] Hardware name: Default string Default string/Default
> > > string, BIOS 5.19 09/23/2022
> > > [   89.581329] RIP: 0010:dql_completed+0x12f/0x140
> > > [   89.586873] kernel BUG at lib/dynamic_queue_limits.c:27!
> > > [   89.596627] Code: cf c9 00 48 89 57 58 e9 54 ff ff ff 85 ed 40 0f
> > > 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d8 e9 36
> > > ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc cc 41 56
> > > 49
> > > 89 f3
> > > [   89.596630] RSP: 0018:ffffb3324018ce20 EFLAGS: 00010283
> > > [   89.636568] RAX: 0000000000000003 RBX: ffff97640754eb40 RCX: 00000=
00000000036
> > > [   89.644842] RDX: ffff976407704000 RSI: 0000000000000620 RDI: ffff9=
76407708c80
> > > [   89.653108] RBP: 0000000000000000 R08: 000000000000a1f0 R09: da49c=
ae6d4ba44ce
> > > [   89.661379] R10: 000000000000a226 R11: ffffffffa05fee80 R12: 00000=
00000000620
> > > [   89.669657] R13: ffff97640754eb40 R14: ffffb33240cf9540 R15: 00000=
000ffffff18
> > > [   89.677942] FS:  0000000000000000(0000) GS:ffff97733ff80000(0000)
> > > knlGS:0000000000000000
> > > [   89.687275] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   89.694065] CR2: 00007f6c7c9e9b40 CR3: 000000064f610000 CR4: 00000=
00000350ee0
> > > [   89.702353] Call Trace:
> > > [   89.705549]  <IRQ>
> > > [   89.708269]  igc_poll+0x19d/0x14b0 [igc]
> > > [   89.713073]  ? __ip_finish_output+0xc0/0x1a0
> > > [   89.718255]  ? __netif_receive_skb_one_core+0x86/0xa0
> > > [   89.724269]  __napi_poll+0x22/0x110
> > > [   89.728597]  net_rx_action+0xe9/0x250
> > > [   89.733093]  ? igc_msix_ring+0x51/0x60 [igc]
> > > [   89.738230]  __do_softirq+0xb8/0x1e9
> > > [   89.742616]  irq_exit_rcu+0x84/0xb0
> > > [   89.746915]  common_interrupt+0x78/0x90
> > > [   89.751566]  </IRQ>
> > > [   89.754323]  <TASK>
> > > [   89.757070]  asm_common_interrupt+0x22/0x40
> > > [   89.762066] RIP: 0010:cpuidle_enter_state+0xb5/0x2a0
> > > [   89.767931] Code: c1 48 b2 ff 65 8b 3d b2 58 a9 60 e8 65 47 b2 ff
> > > 31 ff 49 89 c5 e8 6b 52 b2 ff 45 84 f6 0f 85 85 01 00 00 fb 66 0f 1f
> > > 44 00 00 <45> 85 ff 0f 88 bb 00 00 00 49 63 c7 4c 2b 2c 24 48 8d 14
> > > 40
> > > 48 8d
> > > [   89.789731] RSP: 0018:ffffb332400ffea8 EFLAGS: 00000246
> > > [   89.795904] RAX: ffff97733ffa3440 RBX: 0000000000000003 RCX: 00000=
0000000001f
> > > [   89.804138] RDX: 0000000000000000 RSI: 0000000046ec0743 RDI: 00000=
00000000000
> > > [   89.812376] RBP: ffff97733ffac910 R08: 00000014da35607b R09: 00000=
014bbdae179
> > > [   89.820594] R10: 00000000000000e2 R11: 000000000000357c R12: fffff=
fffa00ccb40
> > > [   89.828795] R13: 00000014da35607b R14: 0000000000000000 R15: 00000=
00000000003
> > > [   89.837026]  ? cpuidle_enter_state+0xa5/0x2a0
> > > [   89.842226]  cpuidle_enter+0x24/0x40
> > > [   89.846558]  do_idle+0x1e4/0x280
> > > [   89.850516]  cpu_startup_entry+0x14/0x20
> > > [   89.855223]  secondary_startup_64_no_verify+0xb0/0xbb
> > > [   89.861153]  </TASK>
> > > [   89.863953] Modules linked in: wireguard curve25519_x86_64
> > > libcurve25519_generic libchacha20poly1305 chacha_x86_64
> > > poly1305_x86_64 ip6_udp_tunnel udp_tunnel libchacha vrf nft_masq
> > > nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip
> > > nf_nat_pptp nf_conntrack_pptp nf_nat_h323 nf_conntrack_h323
> > > nf_nat_ftp nf_conntrack_ftp nft_objref nft_counter nft_ct
> > > nft_chain_nat nf_nat nf_tables nfnetlink_cthelper nf_conntrack
> > > nf_defrag_ipv6
> > > nf_defrag_ipv4 libcrc32c nfnetlink af_packet x86_pkg_temp_thermal
> > > intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul
> > > ghash_clmulni_intel aesni_intel crypto_simd cryptd intel_cstate
> > > iTCO_wdt evdev mei_me pcspkr efi_pstore iTCO_vendor_support mei sg
> > > tpm_crb tpm_tis tpm_tis_core tpm rng_core button acpi_pad
> > > mpls_iptunnel mpls_router ip_tunnel br_netfilter bridge stp llc fuse
> > > configfs efivarfs ip_tables x_tables autofs4 usb_storage ohci_hcd
> > > uhci_hcd ehci_hcd squashfs zstd_decompress lz4_decompress loop
> > > overlay
> > > ext4 crc32c_generic crc16 mbcache jbd2 nls_cp437
> > > [   89.864000]  vfat fat efivars nls_ascii hid_generic usbhid hid
> > > sd_mod t10_pi xhci_pci ahci libahci libata crc32c_intel i2c_i801
> > > i2c_smbus scsi_mod igc xhci_hcd scsi_common thermal fan
> > > [   89.982932] invalid opcode: 0000 [#2] SMP NOPTI
> > > [   89.982934] ---[ end trace b0c0da59c18b279b ]---
> > > [   89.988461] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D
> > >   5.15.85-amd64-vyos #1
> > > [   90.031995] Hardware name: Default string Default string/Default
> > > string, BIOS 5.19 09/23/2022
> > > [   90.079903] RIP: 0010:dql_completed+0x12f/0x140
> > > [   90.099780] RIP: 0010:dql_completed+0x12f/0x140
> > > [   90.101151] Code: cf c9 00 48 89 57 58 e9 54 ff ff ff 85 ed 40 0f
> > > 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d8 e9 36
> > > ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc cc 41 56
> > > 49
> > > 89 f3
> > > [   90.106717] Code: cf c9 00 48 89 57 58 e9 54 ff ff ff 85 ed 40 0f
> > > 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d8 e9 36
> > > ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc cc 41 56
> > > 49
> > > 89 f3
> > > [   90.129020] RSP: 0018:ffffb33240003e20 EFLAGS: 00010293
> > > [   90.151344] RSP: 0018:ffffb3324018ce20 EFLAGS: 00010283
> > > [   90.157686] RAX: 0000000000000000 RBX: ffff97640754bb40 RCX: 00000=
00000000bd4
> > > [   90.157686]
> > > [   90.157687] RDX: ffff976407704000 RSI: 0000000000002966 RDI: ffff9=
764077088c0
> > > [   90.164026] RAX: 0000000000000003 RBX: ffff97640754eb40 RCX: 00000=
00000000036
> > > [   90.172433] RBP: 0000000000000000 R08: 000000000002bdba R09: 00000=
00000000000
> > > [   90.174719] RDX: ffff976407704000 RSI: 0000000000000620 RDI: ffff9=
76407708c80
> > > [   90.183146] R10: 000000000002c98e R11: ffffffffa05fee80 R12: 00000=
00000002966
> > > [   90.191560] RBP: 0000000000000000 R08: 000000000000a1f0 R09: da49c=
ae6d4ba44ce
> > > [   90.199977] R13: ffff97640754bb40 R14: ffffb3324087d4c0 R15: 00000=
000ffffffa8
> > > [   90.208382] R10: 000000000000a226 R11: ffffffffa05fee80 R12: 00000=
00000000620
> > > [   90.216792] FS:  0000000000000000(0000) GS:ffff97733fe00000(0000)
> > > knlGS:0000000000000000
> > > [   90.225213] R13: ffff97640754eb40 R14: ffffb33240cf9540 R15: 00000=
000ffffff18
> > > [   90.233641] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   90.242058] FS:  0000000000000000(0000) GS:ffff97733ff80000(0000)
> > > knlGS:0000000000000000
> > > [   90.251492] CR2: 00007f6097a90010 CR3: 0000000101468000 CR4: 00000=
00000350ef0
> > > [   90.259887] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   90.266776] Call Trace:
> > > [   90.276193] CR2: 00007f6c7c9e9b40 CR3: 0000000104378000 CR4: 00000=
00000350ee0
> > > [   90.284596]  <IRQ>
> > > [   90.284597]  igc_poll+0x19d/0x14b0 [igc]
> > > [   90.291475] Kernel panic - not syncing: Fatal exception in interru=
pt
> > > [   90.294754]  __napi_poll+0x22/0x110
> > > [   90.322584]  net_rx_action+0xe9/0x250
> > > [   90.327118]  ? igc_msix_ring+0x51/0x60 [igc]
> > > [   90.332311]  __do_softirq+0xb8/0x1e9
> > > [   90.336716]  irq_exit_rcu+0x84/0xb0
> > > [   90.341031]  common_interrupt+0x78/0x90
> > > [   90.345725]  </IRQ>
> > > [   90.348534]  <TASK>
> > > [   90.351325]  asm_common_interrupt+0x22/0x40
> > > [   90.356365] RIP: 0010:cpuidle_enter_state+0xb5/0x2a0
> > > [   90.362239] Code: c1 48 b2 ff 65 8b 3d b2 58 a9 60 e8 65 47 b2 ff
> > > 31 ff 49 89 c5 e8 6b 52 b2 ff 45 84 f6 0f 85 85 01 00 00 fb 66 0f 1f
> > > 44 00 00 <45> 85 ff 0f 88 bb 00 00 00 49 63 c7 4c 2b 2c 24 48 8d 14
> > > 40
> > > 48 8d
> > > [   90.384058] RSP: 0018:ffffffffa0003e60 EFLAGS: 00000246
> > > [   90.390221] RAX: ffff97733fe23440 RBX: 0000000000000001 RCX: 00000=
0000000001f
> > > [   90.398453] RDX: 0000000000000000 RSI: 0000000046ec0743 RDI: 00000=
00000000000
> > > [   90.406695] RBP: ffff97733fe2c910 R08: 00000014db620c58 R09: 00000=
00000000018
> > > [   90.414928] R10: 0000000000000259 R11: 00000000000000da R12: fffff=
fffa00ccb40
> > > [   90.423151] R13: 00000014db620c58 R14: 0000000000000000 R15: 00000=
00000000001
> > > [   90.431387]  cpuidle_enter+0x24/0x40
> > > [   90.435751]  do_idle+0x1e4/0x280
> > > [   90.439733]  cpu_startup_entry+0x14/0x20
> > > [   90.444462]  start_kernel+0x627/0x650
> > > [   90.448909]  secondary_startup_64_no_verify+0xb0/0xbb
> > > [   90.454863]  </TASK>
> > > [   90.457714] Modules linked in: wireguard curve25519_x86_64
> > > libcurve25519_generic libchacha20poly1305 chacha_x86_64
> > > poly1305_x86_64 ip6_udp_tunnel udp_tunnel libchacha vrf nft_masq
> > > nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip
> > > nf_nat_pptp nf_conntrack_pptp nf_nat_h323 nf_conntrack_h323
> > > nf_nat_ftp nf_conntrack_ftp nft_objref nft_counter nft_ct
> > > nft_chain_nat nf_nat nf_tables nfnetlink_cthelper nf_conntrack
> > > nf_defrag_ipv6
> > > nf_defrag_ipv4 libcrc32c nfnetlink af_packet x86_pkg_temp_thermal
> > > intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul
> > > ghash_clmulni_intel aesni_intel crypto_simd cryptd intel_cstate
> > > iTCO_wdt evdev mei_me pcspkr efi_pstore iTCO_vendor_support mei sg
> > > tpm_crb tpm_tis tpm_tis_core tpm rng_core button acpi_pad
> > > mpls_iptunnel mpls_router ip_tunnel br_netfilter bridge stp llc fuse
> > > configfs efivarfs ip_tables x_tables autofs4 usb_storage ohci_hcd
> > > uhci_hcd ehci_hcd squashfs zstd_decompress lz4_decompress loop
> > > overlay
> > > ext4 crc32c_generic crc16 mbcache jbd2 nls_cp437
> > > [   90.457755]  vfat fat efivars nls_ascii hid_generic usbhid hid
> > > sd_mod t10_pi xhci_pci ahci libahci libata crc32c_intel i2c_i801
> > > i2c_smbus scsi_mod igc xhci_hcd scsi_common thermal fan
> > > [   90.576795] Kernel Offset: 0x1e000000 from 0xffffffff81000000
> > > (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> > > [   90.704454] ---[ end Kernel panic - not syncing: Fatal exception i=
n
> > > interrupt ]---
> > >
> > > K.
> > >
> > > On Tue, Dec 27, 2022 at 11:07 PM Neftin, Sasha <sasha.neftin@intel.co=
m> wrote:
> > > >
> > > > On 12/28/2022 06:45, Kyle Sanderson wrote:
> > > > > hi Intel IGC Maintainers,
> > > > >
> > > > > I've managed to reproduce this issue on 5.15.85 (same steps to
> > > > > reproduce), and have symbols and line numbers in the below panic.
> > > > > There's no device support in 5.4 for this hardware, so I was
> > > > > unable to reproduce the issue there in igc.
> > > > >
> > > > >  From the Kernel BUG_ON, it's being asked to read beyond the
> > > > > array size. The min call looks very suspicious (igb, and other
> > > > > drives don't appear to do that), but I don't know if that's where=
 the issue is.
> > > > >
> > > > > Please let me know if there's anything more I can do to help.
> > > > I do not know if it is an SW problem.
> > > > 1. Does the problem reproduce on the latest upstream kernel?(worth
> > > > to check) 2. I do not see this crash in our labs. I haven't a
> > > > platform with six
> > > > i226 parts.(Trying find folks who work with this platform.) 3. I
> > > > am working on a patch to address .ndo_tx_timeout support. (pass
> > > > the reset task to netdev while the link disconnected during
> > > > traffic, under testing). It could be related and worth checking -
> > > > please, let me know if you want to apply on your platform (against =
upstream).
> > > > Reach us (Dima, Amir, and me) directly off the list.
> > > > >
> > > > > [  223.725003] igc 0000:01:00.0 eth0: Reset adapter [
> > > > > 233.139441] kernel BUG at lib/dynamic_queue_limits.c:27!
> > > > > [  233.146814] invalid opcode: 0000 [#1] SMP NOPTI [
> > > > > 233.146816]
> > > > > refcount_t: saturated; leaking memory.
> > > > > [  233.146833] WARNING: CPU: 0 PID: 0 at lib/refcount.c:19
> > > > > refcount_warn_saturate+0x97/0x110
> > > > > [  233.153243] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W
> > > > >    5.15.85-amd64-vyos #1
> > > > > [  233.159216] Modules linked in:
> > > > > [  233.168451] Hardware name: Default string Default
> > > > > string/Default string, BIOS 5.19 09/23/2022 [  233.177895]
> > > > > wireguard [  233.181645] RIP: 0010:dql_completed+0x12f/0x140 [
> > > > > 233.191360]  curve25519_x86_64 [  233.194406] Code: cf c9 00 48
> > > > > 89
> > > > > 57 58 e9 54 ff ff ff 85 ed 40 0f
> > > > > 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d8
> > > > > e9
> > > > > 36 ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc cc
> > > > > 41 56 49
> > > > > 89 f3
> > > > > [  233.199767]  libcurve25519_generic [  233.203540] RSP:
> > > > > 0018:ffffa85dc0134e20 EFLAGS: 00010283 [  233.225248]
> > > > > libchacha20poly1305 [  233.229417] [  233.229417] RAX:
> > > > > 0000000000000001 RBX: ffff934002104b40 RCX: 00000000000005ea [
> > > > > 233.235539]  chacha_x86_64 [  233.239508] RDX: ffff934002110000
> > > > > RSI: 0000000000001d92 RDI: ffff93400211a200 [  233.241606]
> > > > > poly1305_x86_64 [  233.249796] RBP: 0000000000000000 R08:
> > > > > 000000000004ad4e R09: 0000000000000000 [  233.253226]
> > > > > ip6_udp_tunnel [  233.261445] R10: 000000000004b338 R11:
> > > > > ffffffffbabfee80 R12: 0000000000001d92 [  233.261446] R13:
> > > > > ffff934002104b40 R14: ffffa85dc09d1450 R15: 00000000ffffffa6 [
> > > > > 233.265054]  udp_tunnel [  233.273314] FS:
> > > > > 0000000000000000(0000)
> > > > > GS:ffff934f3fe80000(0000)
> > > > > knlGS:0000000000000000
> > > > > [  233.276826]  libchacha
> > > > > [  233.285023] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > [ 233.285025] CR2: 00007f294393fe84 CR3: 0000000605e10000 CR4:
> > > > > 0000000000350ee0 [  233.285026] Call Trace:
> > > > > [  233.285026]  <IRQ>
> > > > > [  233.285027]  igc_poll+0x19d/0x14b0 [igc] [  233.293242]  vrf
> > > > > [ 233.296396]  __napi_poll+0x22/0x110 [  233.305688]  nft_masq [
> > > > > 233.308763]  net_rx_action+0xe9/0x250 [  233.315455]
> > > > > nf_nat_tftp [  233.323756]  ? igc_msix_ring+0x51/0x60 [igc] [
> > > > > 233.326946] nf_conntrack_tftp [  233.329661]
> > > > > __do_softirq+0xb8/0x1e9 [ 233.334471]  nf_nat_sip [  233.336991]
> > > > > irq_exit_rcu+0x84/0xb0 [ 233.341290]  nf_conntrack_sip [
> > > > > 233.344284]
> > > > > common_interrupt+0x78/0x90 [  233.348778]  nf_nat_pptp [
> > > > > 233.352104]  </IRQ> [  233.357240]  nf_conntrack_pptp [
> > > > > 233.361052]  <TASK> [  233.365360]  nf_nat_h323 [  233.368484]
> > > > > asm_common_interrupt+0x22/0x40 [  233.372723]  nf_conntrack_h323
> > > > > [ 233.376363] RIP: 0010:cpuidle_enter_state+0xb5/0x2a0
> > > > > [  233.380952]  nf_nat_ftp
> > > > > [  233.384155] Code: c1 48 b2 ff 65 8b 3d b2 58 49 46 e8 65 47
> > > > > b2 ff
> > > > > 31 ff 49 89 c5 e8 6b 52 b2 ff 45 84 f6 0f 85 85 01 00 00 fb 66
> > > > > 0f 1f
> > > > > 44 00 00 <45> 85 ff 0f 88 bb 00 00 00 49 63 c7 4c 2b 2c 24 48 8d
> > > > > 14 40
> > > > > 48 8d
> > > > > [  233.386840]  nf_conntrack_ftp [  233.390553] RSP:
> > > > > 0018:ffffa85dc00efea8 EFLAGS: 00000246 [ 233.393224]  nft_objref
> > > > > [  233.396340] [  233.396340] RAX:
> > > > > ffff934f3fea3440 RBX: 0000000000000003 RCX: 000000000000001f [
> > > > > 233.401256]  nft_counter [  233.404981] RDX: 0000000000000000 RSI=
:
> > > > > 0000000046ec0743 RDI: 0000000000000000 [  233.410769]  nft_ct [
> > > > > 233.413816] RBP: ffff934f3feac910 R08: 00000036481c5d1b R09:
> > > > > 0000003605db0041 [  233.435320]  nft_chain_nat [  233.438947] R10=
:
> > > > > 0000000000000072 R11: 0000000000000164 R12: ffffffffba6ccb40 [
> > > > > 233.445014]  nf_nat [  233.448065] R13: 00000036481c5d1b R14:
> > > > > 0000000000000000 R15: 0000000000000003 [  233.450073]  nf_tables
> > > > > [ 233.458210]  ? cpuidle_enter_state+0xa5/0x2a0 [  233.461335]
> > > > > nfnetlink_cthelper [  233.469449]  cpuidle_enter+0x24/0x40 [
> > > > > 233.472106]  nf_conntrack [  233.480247]  do_idle+0x1e4/0x280 [
> > > > > 233.483580]  nf_defrag_ipv6 [  233.491703]
> > > > > cpu_startup_entry+0x14/0x20 [  233.494399]  nf_defrag_ipv4 [
> > > > > 233.502517]  secondary_startup_64_no_verify+0xb0/0xbb
> > > > > [  233.505503]  libcrc32c
> > > > > [  233.510641]  </TASK>
> > > > > [  233.514474]  nfnetlink
> > > > > [  233.518787] Modules linked in: wireguard [  233.522065]
> > > > > af_packet [  233.525975]  curve25519_x86_64 [  233.529441]
> > > > > x86_pkg_temp_thermal [  233.534136]  libcurve25519_generic [
> > > > > 233.537612]  intel_powerclamp [  233.543511]
> > > > > libchacha20poly1305 [  233.546508]  coretemp [  233.549313]
> > > > > chacha_x86_64
> > > > > poly1305_x86_64 [  233.552304]  crct10dif_pclmul [  233.556981]
> > > > > ip6_udp_tunnel udp_tunnel libchacha vrf nft_masq nf_nat_tftp
> > > > > nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_pptp
> > > > > nf_conntrack_pptp nf_nat_h323 nf_conntrack_h323 nf_nat_ftp
> > > > > nf_conntrack_ftp [  233.559990]  crc32_pclmul [  233.563754]
> > > > > nft_objref nft_counter [  233.567791]  ghash_clmulni_intel [
> > > > > 233.571912]  nft_ct [  233.575569]  aesni_intel [  233.579500]
> > > > > nft_chain_nat [  233.582390]  crypto_simd [  233.587225]  nf_nat
> > > > > [ 233.590841]  cryptd [  233.612012]  nf_tables [  233.615288]
> > > > > intel_cstate [  233.619486]  nfnetlink_cthelper [  233.623388]
> > > > > iTCO_wdt [  233.626063]  nf_conntrack [  233.629196]  efi_pstore
> > > > > [ 233.632499]  nf_defrag_ipv6 [  233.635597]  pcspkr [
> > > > > 233.638218]
> > > > > nf_defrag_ipv4 [  233.640825]  evdev [  233.643700]  libcrc32c [
> > > > > 233.646869]  iTCO_vendor_support [  233.650591]  nfnetlink [
> > > > > 233.653355]  sg [  233.656497]  af_packet [  233.659446]
> > > > > tpm_crb [  233.662775]  x86_pkg_temp_thermal [  233.665337]
> > > > > tpm_tis [ 233.668670]  intel_powerclamp [  233.671144]
> > > > > tpm_tis_core [ 233.673993]  coretemp [  233.677768]  tpm [
> > > > > 233.680591] crct10dif_pclmul [  233.682782]  rng_core [
> > > > > 233.685624] crc32_pclmul [  233.688271]  mei_me [  233.692161]
> > > > > ghash_clmulni_intel [  233.694799]  mei [  233.698290]
> > > > > aesni_intel [  233.701384]  button [  233.704125]  crypto_simd [
> > > > > 233.706379]  acpi_pad [  233.709861]  cryptd [  233.712587]
> > > > > mpls_iptunnel [  233.715682]  intel_cstate [  233.718177]
> > > > > mpls_router [  233.721872]  iTCO_wdt [  233.724077]  ip_tunnel [
> > > > > 233.727034]  efi_pstore [  233.729533]  br_netfilter [
> > > > > 233.732471]  pcspkr [  233.735139]  bridge [  233.737627]  evdev
> > > > > [ 233.740768]  stp [  233.743827]  iTCO_vendor_support [
> > > > > 233.746789]  llc [  233.749457]  sg [  233.752222]  fuse [
> > > > > 233.755071]  tpm_crb [  233.758113]  configfs [  233.760589]
> > > > > tpm_tis [  233.763065]  efivarfs [  233.765437]  tpm_tis_core [
> > > > > 233.767622]  ip_tables [  233.771314]  tpm [  233.773511]
> > > > > x_tables [  233.775607]  rng_core [  233.777893]  autofs4 [
> > > > > 233.780456]  mei_me [  233.783120]  usb_storage [  233.785686]
> > > > > mei [  233.788319]  ohci_hcd [  233.791358]  button [
> > > > > 233.794104] uhci_hcd [  233.796287]  acpi_pad [  233.798948]
> > > > > ehci_hcd [ 233.801608]  mpls_iptunnel [  233.804146]  squashfs [
> > > > > 233.806598] mpls_router [  233.809530]  zstd_decompress [
> > > > > 233.811719] ip_tunnel [  233.814378]  lz4_decompress [
> > > > > 233.816841] br_netfilter [  233.819492]  loop [  233.822152]
> > > > > bridge [ 233.824802]  overlay [  233.827927]  stp [  233.830564]
> > > > > ext4 [ 233.833498]  llc [  233.836805]  crc32c_generic [
> > > > > 233.839557] fuse [  233.842787]  crc16 [  233.845815]  configfs
> > > > > [  233.848084] mbcache [  233.850564]  efivarfs [  233.853117]
> > > > > jbd2 [ 233.855296]  ip_tables [  233.857561]  nls_cp437 [
> > > > > 233.859722] x_tables autofs4 [  233.862950]  vfat [  233.865216]
> > > > > usb_storage [  233.867585]  fat [  233.870239]  ohci_hcd
> > > > > uhci_hcd [ 233.872779]  efivars [  233.875414]  ehci_hcd [
> > > > > 233.877693] nls_ascii [  233.880433]  squashfs zstd_decompress [
> > > > > 233.883172] hid_generic [  233.886580]  lz4_decompress [
> > > > > 233.888861]  usbhid [  233.891803]  loop [  233.893980]  hid [
> > > > > 233.897493]  overlay [ 233.900050]  sd_mod [  233.902702]  ext4
> > > > > [  233.905446]  t10_pi [ 233.909612]  crc32c_generic [
> > > > > 233.912548]  ahci [  233.915776]
> > > > > crc16 [  233.918244]  libahci [  233.920540]  mbcache [
> > > > > 233.922740]  crc32c_intel [  233.925303]  jbd2 [  233.927777]
> > > > > libata [  233.930058]  nls_cp437 [  233.932530]  i2c_i801 [
> > > > > 233.935740]  vfat fat [  233.938022]  i2c_smbus [  233.940397]
> > > > > efivars [  233.942945]  xhci_pci [  233.945504]  nls_ascii
> > > > > hid_generic [  233.948535]  xhci_hcd [  233.950814]  usbhid [
> > > > > 233.953282]  scsi_mod [  233.956022]  hid [  233.958671]
> > > > > scsi_common [  233.961327]  sd_mod t10_pi [  233.964066]  igc [
> > > > > 233.966618]  ahci [  233.969274]  thermal [  233.973168]
> > > > > libahci [  233.975830]  fan [  233.978310]  crc32c_intel [
> > > > > 233.980975] [ 233.983158]  libata
> > > > > [  233.986113] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W
> > > > >    5.15.85-amd64-vyos #1
> > > > > [  233.989257]  i2c_i801
> > > > > [  233.991441] Hardware name: Default string Default
> > > > > string/Default string, BIOS 5.19 09/23/2022 [  233.993730]
> > > > > i2c_smbus [  233.996286] RIP:
> > > > > 0010:refcount_warn_saturate+0x97/0x110
> > > > > [  233.998850]  xhci_pci
> > > > > [  234.001055] Code: 00 01 e8 cb 40 42 00 0f 0b c3 cc cc cc cc
> > > > > 80 3d
> > > > > 39 f4 da 00 00 75 a8 48 c7 c7 d8 13 43 ba c6 05 29 f4 da 00 01
> > > > > e8
> > > > > a8
> > > > > 40 42 00 <0f> 0b c3 cc cc cc cc 80 3d 13 f4 da 00 00 75 85 48 c7
> > > > > c7 30
> > > > > 14 43
> > > > > [  234.004069]  xhci_hcd scsi_mod [  234.005878] RSP:
> > > > > 0018:ffffa85dc0003ae0 EFLAGS: 00010282 [ 234.008348]
> > > > > scsi_common igc [  234.017611] [  234.020297] thermal fan [
> > > > > 234.029764] RAX: 0000000000000000 RBX:
> > > > > 0000000000005837 RCX: 0000000000000000 [  234.032559] [
> > > > > 234.032585] ---[ end trace 8acd09a29bf2e660 ]--- [  234.038458]
> > > > > RDX: ffff934f3fe1f3e0 RSI: ffff934f3fe1c490 RDI:
> > > > > 0000000000000300 [  234.141617] RIP:
> > > > > 0010:dql_completed+0x12f/0x140 [  234.146459]
> > > > > RBP: ffff9340074b28c0 R08: 0000000000000000 R09:
> > > > > ffffa85dc0003908 [  234.150075] Code: cf c9 00 48 89 57 58 e9 54
> > > > > ff ff ff 85 ed 40 0f
> > > > > 95 c5 41 39 d8 41 0f 95 c0 44 84 c5 74 04 85 d2 78 0a 44 89 d8
> > > > > e9
> > > > > 36 ff ff ff <0f> 0b 01 f6 44 89 da 29 f2 0f 48 d0 eb 8d cc cc cc
> > > > > 41 56 49
> > > > > 89 f3
> > > > > [  234.156048] R10: ffffa85dc0003900 R11: ffffffffba6b0ce8 R12:
> > > > > ffff9340074b2908 [  234.159502] RSP: 0018:ffffa85dc0134e20 EFLAGS=
:
> > > > > 00010283 [  234.161442] R13: ffffffffba28eb60 R14:
> > > > > fffffffffffffff0 R15: ffffa85dc0003b40 [  234.164506] [
> > > > > 234.172573] FS:  0000000000000000(0000)
> > > > > GS:ffff934f3fe00000(0000)
> > > > > knlGS:0000000000000000
> > > > > [  234.174545] RAX: 0000000000000001 RBX: ffff934002104b40 RCX:
> > > > > 00000000000005ea [  234.179914] CS:  0010 DS: 0000 ES: 0000 CR0:
> > > > > 0000000080050033 [  234.188023] RDX: ffff934002110000 RSI:
> > > > > 0000000000001d92 RDI: ffff93400211a200 [  234.193301] CR2:
> > > > > 000055e26436ee10 CR3: 0000000605e10000 CR4: 0000000000350ef0 [
> > > > > 234.201457] RBP: 0000000000000000 R08: 000000000004ad4e R09: 0000=
000000000000 [  234.223063] Call Trace:
> > > > > [  234.231267] R10: 000000000004b338 R11: ffffffffbabfee80 R12:
> > > > > 0000000000001d92 [  234.237398]  <IRQ> [  234.245613] R13:
> > > > > ffff934002104b40 R14: ffffa85dc09d1450 R15: 00000000ffffffa6 [
> > > > > 234.247734]  __nf_conntrack_find_get+0x331/0x340 [nf_conntrack]
> > > > > [ 234.256997] FS:  0000000000000000(0000)
> > > > > GS:ffff934f3fe80000(0000)
> > > > > knlGS:0000000000000000
> > > > > [  234.265245]  nf_conntrack_in+0x1e1/0x760 [nf_conntrack] [
> > > > > 234.271954] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [
> > > > > 234.280252]  nf_hook_slow+0x37/0xb0 [  234.288537] CR2:
> > > > > 00007f294393fe84 CR3: 000000011da48000 CR4: 0000000000350ee0 [
> > > > > 234.296788]  nf_hook_slow_list+0x8c/0x130 [  234.300002] Kernel
> > > > > panic - not syncing: Fatal exception in interrupt [  234.308339]
> > > > > ip_sublist_rcv+0x1fa/0x220 [  234.319422] Kernel Offset:
> > > > > 0x38600000 from 0xffffffff81000000 (relocation range:
> > > > > 0xffffffff80000000-0xffffffffbfffffff)
> > > > > [  234.494681] ---[ end Kernel panic - not syncing: Fatal
> > > > > exception in interrupt ]---
> > > > >
> > > > > Kyle.
> > > > >
> > > > > On Tue, Dec 20, 2022 at 10:29 AM Kyle Sanderson <kyle.leet@gmail.=
com> wrote:
> > > > >>
> > > > >> re-sending as plain text - my apologies.
> > > > >>
> > > > >>> On Sun, 18 Dec 2022, 23:31 Neftin, Sasha wrote:
> > > > >>> What is a board in use (LAN on board or NIC)?
> > > > >>> What is lspci, lspci -t and lspci -s 0000:[lan bus:device.funct=
ion] -vvv output?
> > > > >>
> > > > >> It's embedded on the board, could very well be on a bridge
> > > > >> though as a card. The box has 6 ports, 2 were in-use while testi=
ng.
> > > > >>
> > > > >> 00:00.0 Host bridge: Intel Corporation Device 4522 (rev 01)
> > > > >> 00:02.0 VGA compatible controller: Intel Corporation Elkhart
> > > > >> Lake [UHD Graphics Gen11 16EU] (rev 01)
> > > > >> 00:08.0 System peripheral: Intel Corporation Device 4511 (rev
> > > > >> 01)
> > > > >> 00:14.0 USB controller: Intel Corporation Device 4b7d (rev 11)
> > > > >> 00:14.2 RAM memory: Intel Corporation Device 4b7f (rev 11)
> > > > >> 00:16.0 Communication controller: Intel Corporation Device 4b70
> > > > >> (rev 11)
> > > > >> 00:17.0 SATA controller: Intel Corporation Device 4b63 (rev 11)
> > > > >> 00:1c.0 PCI bridge: Intel Corporation Device 4b38 (rev 11)
> > > > >> 00:1c.1 PCI bridge: Intel Corporation Device 4b39 (rev 11)
> > > > >> 00:1c.2 PCI bridge: Intel Corporation Device 4b3a (rev 11)
> > > > >> 00:1c.3 PCI bridge: Intel Corporation Device 4b3b (rev 11)
> > > > >> 00:1c.4 PCI bridge: Intel Corporation Device 4b3c (rev 11)
> > > > >> 00:1c.6 PCI bridge: Intel Corporation Device 4b3e (rev 11)
> > > > >> 00:1f.0 ISA bridge: Intel Corporation Device 4b00 (rev 11)
> > > > >> 00:1f.3 Audio device: Intel Corporation Device 4b58 (rev 11)
> > > > >> 00:1f.4 SMBus: Intel Corporation Device 4b23 (rev 11)
> > > > >> 00:1f.5 Serial bus controller: Intel Corporation Device 4b24
> > > > >> (rev
> > > > >> 11)
> > > > >> 01:00.0 Ethernet controller: Intel Corporation Device 125c (rev
> > > > >> 04)
> > > > >> 02:00.0 Ethernet controller: Intel Corporation Device 125c (rev
> > > > >> 04)
> > > > >> 03:00.0 Ethernet controller: Intel Corporation Device 125c (rev
> > > > >> 04)
> > > > >> 04:00.0 Ethernet controller: Intel Corporation Device 125c (rev
> > > > >> 04)
> > > > >> 05:00.0 Ethernet controller: Intel Corporation Device 125c (rev
> > > > >> 04)
> > > > >> 06:00.0 Ethernet controller: Intel Corporation Device 125c (rev
> > > > >> 04)
> > > > >>
> > > > >> -[0000:00]-+-00.0
> > > > >>             +-02.0
> > > > >>             +-08.0
> > > > >>             +-14.0
> > > > >>             +-14.2
> > > > >>             +-16.0
> > > > >>             +-17.0
> > > > >>             +-1c.0-[01]----00.0
> > > > >>             +-1c.1-[02]----00.0
> > > > >>             +-1c.2-[03]----00.0
> > > > >>             +-1c.3-[04]----00.0
> > > > >>             +-1c.4-[05]----00.0
> > > > >>             +-1c.6-[06]----00.0
> > > > >>             +-1f.0
> > > > >>             +-1f.3
> > > > >>             +-1f.4
> > > > >>             \-1f.5
> > > > >>
> > > > >>
> > > > >> 01:00.0 Ethernet controller: Intel Corporation Device 125c (rev =
04)
> > > > >>   Subsystem: Intel Corporation Device 0000
> > > > >>   Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > > > >> ParErr-
> > > > >> Stepping- SERR- FastB2B- DisINTx+
> > > > >>   Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast
> > > > >> >TAbort-
> > > > >> <TAbort- <MAbort- >SERR- <PERR- INTx-
> > > > >>   Latency: 0
> > > > >>   Interrupt: pin A routed to IRQ 16
> > > > >>   Region 0: Memory at 80600000 (32-bit, non-prefetchable) [size=
=3D1M]
> > > > >>   Region 3: Memory at 80700000 (32-bit, non-prefetchable) [size=
=3D16K]
> > > > >>   Capabilities: [40] Power Management version 3
> > > > >>    Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,=
D3hot+,D3cold+)
> > > > >>    Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D1 PME-
> > > > >>   Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable+ 64bit+
> > > > >>    Address: 0000000000000000 Data: 0000
> > > > >>    Masking: 00000000 Pending: 00000000
> > > > >>   Capabilities: [70] MSI-X: Enable+ Count=3D5 Masked-
> > > > >>    Vector table: BAR=3D3 offset=3D00000000
> > > > >>    PBA: BAR=3D3 offset=3D00002000
> > > > >>   Capabilities: [a0] Express (v2) Endpoint, MSI 00
> > > > >>    DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <512ns=
, L1 <64us
> > > > >>     ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+ SlotPowerLim=
it 0W
> > > > >>    DevCtl: CorrErr+ NonFatalErr+ FatalErr+ UnsupReq+
> > > > >>     RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
> > > > >>     MaxPayload 128 bytes, MaxReadReq 512 bytes
> > > > >>    DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr+ Tra=
nsPend-
> > > > >>    LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L1, Exit Latency=
 L1 <4us
> > > > >>     ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
> > > > >>    LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
> > > > >>     ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > > > >>    LnkSta: Speed 5GT/s, Width x1
> > > > >>     TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
> > > > >>    DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ NROPrPrP=
- LTR+
> > > > >>      10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt- EETL=
PPrefix-
> > > > >>      EmergencyPowerReduction Not Supported, EmergencyPowerReduct=
ionInit-
> > > > >>      FRS- TPHComp- ExtTPHComp-
> > > > >>      AtomicOpsCap: 32bit- 64bit- 128bitCAS-
> > > > >>    DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- LTR+
> > > > >> 10BitTagReq- OBFF Disabled,
> > > > >>      AtomicOpsCtl: ReqEn-
> > > > >>    LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
> > > > >>      Transmit Margin: Normal Operating Range,
> > > > >> EnterModifiedCompliance-
> > > > >> ComplianceSOS-
> > > > >>      Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB presho=
ot
> > > > >>    LnkSta2: Current De-emphasis Level: -6dB,
> > > > >> EqualizationComplete-
> > > > >> EqualizationPhase1-
> > > > >>      EqualizationPhase2- EqualizationPhase3- LinkEqualizationReq=
uest-
> > > > >>      Retimer- 2Retimers- CrosslinkRes: unsupported
> > > > >>   Capabilities: [100 v2] Advanced Error Reporting
> > > > >>    UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > > > >> RxOF-
> > > > >> MalfTLP- ECRC- UnsupReq- ACSViol-
> > > > >>    UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > > > >> RxOF-
> > > > >> MalfTLP- ECRC- UnsupReq- ACSViol-
> > > > >>    UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> > > > >> RxOF+
> > > > >> MalfTLP+ ECRC- UnsupReq- ACSViol-
> > > > >>    CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatal=
Err-
> > > > >>    CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatal=
Err+
> > > > >>    AERCap: First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCC=
hkCap+ ECRCChkEn-
> > > > >>     MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
> > > > >>    HeaderLog: 00000000 00000000 00000000 00000000
> > > > >>   Capabilities: [140 v1] Device Serial Number e4-3a-6e-ff-ff-5d-=
bb-54
> > > > >>   Capabilities: [1c0 v1] Latency Tolerance Reporting
> > > > >>    Max snoop latency: 3145728ns
> > > > >>    Max no snoop latency: 3145728ns
> > > > >>   Capabilities: [1f0 v1] Precision Time Measurement
> > > > >>    PTMCap: Requester:+ Responder:- Root:-
> > > > >>    PTMClockGranularity: 4ns
> > > > >>    PTMControl: Enabled:- RootSelected:-
> > > > >>    PTMEffectiveGranularity: Unknown
> > > > >>   Capabilities: [1e0 v1] L1 PM Substates
> > > > >>    L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_=
PM_Substates+
> > > > >>       PortCommonModeRestoreTime=3D55us PortTPowerOnTime=3D70us
> > > > >>    L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
> > > > >>        T_CommonMode=3D0us LTR1.2_Threshold=3D81920ns
> > > > >>    L1SubCtl2: T_PwrOn=3D50us
> > > > >>   Kernel driver in use: igc
> > > > >>   Kernel modules: igc
> > > > >>
> > > > >> On Sun, Dec 18, 2022 at 10:31 PM Neftin, Sasha <sasha.neftin@int=
el.com> wrote:
> > > > >>>
> > > > >>> On 12/16/2022 00:28, Kyle Sanderson wrote:
> > > > >>>> (Un)fortunately I can reproduce this bug by simply removing
> > > > >>>> the ethernet cable from the box while there is traffic flowing=
.
> > > > >>>> kprint below from a console line. Please CC / to me for any
> > > > >>>> additional information I can provide for this panic.
> > > > >>> What is a board in use (LAN on board or NIC)? What is lspci,
> > > > >>> lspci -t and lspci -s 0000:[lan bus:device.function] -vvv outpu=
t?
> > > > >>>>
> > > > >>>> [  156.707054] igc 0000:01:00.0 eth0: NIC Link is Down [
> > > > >>>> 156.712981] br-lan: port 1(eth0) entered disabled state [
> > > > >>>> 156.719246] igc 0000:01:00.0 eth0: Register Dump
> > > > >>>> [  156.724784] igc 0000:01:00.0 eth0: Register Name   Value
> > > > >>>> [  156.731067] igc 0000:01:00.0 eth0: CTRL            181c0641
> > > > >>>> [  156.737607] igc 0000:01:00.0 eth0: STATUS          00380681
> > > > >>>> [  156.744133] igc 0000:01:00.0 eth0: CTRL_EXT        100000c0
> > > > >>>> [  156.750759] igc 0000:01:00.0 eth0: MDIC            18017949
> > > > >>>> [  156.757258] igc 0000:01:00.0 eth0: ICR             00000001
> > > > >>>> [  156.763785] igc 0000:01:00.0 eth0: RCTL            0440803a
> > > > >>>> [  156.770324] igc 0000:01:00.0 eth0: RDLEN[0-3]      00001000
> > > > >>>> 00001000 00001000 00001000
> > > > >>>> [  156.779457] igc 0000:01:00.0 eth0: RDH[0-3]        000000ef
> > > > >>>> 000000a1 00000092 000000ba
> > > > >>>> [  156.788500] igc 0000:01:00.0 eth0: RDT[0-3]        000000ee
> > > > >>>> 000000a0 00000091 000000b9
> > > > >>>> [  156.797650] igc 0000:01:00.0 eth0: RXDCTL[0-3]     02040808
> > > > >>>> 02040808 02040808 02040808
> > > > >>>> [  156.806688] igc 0000:01:00.0 eth0: RDBAL[0-3]      02f43000
> > > > >>>> 02180000 02e7f000 02278000
> > > > >>>> [  156.815781] igc 0000:01:00.0 eth0: RDBAH[0-3]      00000001
> > > > >>>> 00000001 00000001 00000001
> > > > >>>> [  156.824928] igc 0000:01:00.0 eth0: TCTL            a503f0fa
> > > > >>>> [  156.831587] igc 0000:01:00.0 eth0: TDBAL[0-3]      02f43000
> > > > >>>> 02180000 02e7f000 02278000
> > > > >>>> [  156.840637] igc 0000:01:00.0 eth0: TDBAH[0-3]      00000001
> > > > >>>> 00000001 00000001 00000001
> > > > >>>> [  156.849753] igc 0000:01:00.0 eth0: TDLEN[0-3]      00001000
> > > > >>>> 00001000 00001000 00001000
> > > > >>>> [  156.858760] igc 0000:01:00.0 eth0: TDH[0-3]        000000d4
> > > > >>>> 0000003d 000000af 0000002a
> > > > >>>> [  156.867771] igc 0000:01:00.0 eth0: TDT[0-3]        000000e4
> > > > >>>> 0000005a 000000c8 0000002a
> > > > >>>> [  156.876864] igc 0000:01:00.0 eth0: TXDCTL[0-3]     02100108
> > > > >>>> 02100108 02100108 02100108
> > > > >>>> [  156.885905] igc 0000:01:00.0 eth0: Reset adapter [
> > > > >>>> 160.307195] igc 0000:01:00.0 eth0: NIC Link is Up 1000 Mbps
> > > > >>>> Full Duplex, Flow Control: RX/TX [  160.317974] br-lan: port
> > > > >>>> 1(eth0) entered blocking state [  160.324532] br-lan: port
> > > > >>>> 1(eth0) entered forwarding state [  161.197263] ------------[
> > > > >>>> cut here ]------------ [  161.202669] Kernel BUG at
> > > > >>>> 0xffffffff813ce19f [verbose debug info unavailable] [
> > > > >>>> 161.210769] invalid opcode: 0000 [#1] SMP NOPTI [
> > > > >>>> 161.216022]
> > > > >>>> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.10.146 #0 [
> > > > >>>> 161.222980] Hardware name: Default string Default
> > > > >>>> string/Default string, BIOS 5.19 09/23/2022 [  161.232546] RIP=
:
> > > > >>>> 0010:0xffffffff813ce19f [  161.237167] Code: 03 01 4c 89 48
> > > > >>>> 58
> > > > >>>> e9 2f ff ff ff 85 db 41 0f 95
> > > > >>>> c2 45 39 d9 41 0f 95 c1 45 84 ca 74 05 45 85 e4 78 0a 44 89
> > > > >>>> c2
> > > > >>>> e9 10 ff ff ff <0f> 0b 01 d2 45 89 c1 41 29 d1 ba 00 00 00 00
> > > > >>>> 44 0f 48 ca eb
> > > > >>>> 80 cc
> > > > >>>> [  161.258651] RSP: 0018:ffffc90000118e88 EFLAGS: 00010283 [
> > > > >>>> 161.264736] RAX: ffff888101f8f200 RBX: ffffc900006f9bd0 RCX:
> > > > >>>> 000000000000050e [  161.272837] RDX: ffff888101fec000 RSI:
> > > > >>>> 0000000000000a1c RDI: 0000000000061a10 [  161.280942] RBP:
> > > > >>>> ffffc90000118ef8 R08: 0000000000000000 R09: 0000000000061502
> > > > >>>> [ 161.289089] R10: 0000000000000000 R11: 0000000000000000 R12:
> > > > >>>> 00000000ffffff3f [  161.297229] R13: ffff888101f8f140 R14:
> > > > >>>> 0000000000000000 R15: ffff888100ad9b00 [  161.305345] FS:
> > > > >>>> 0000000000000000(0000) GS:ffff88903fe80000(0000)
> > > > >>>> knlGS:00000 00000000000
> > > > >>>> [  161.314492] CS:  0010 DS: 0000 ES: 0000 CR0:
> > > > >>>> 0000000080050033 [  161.321139] CR2: 00007f941ad43a9b CR3:
> > > > >>>> 000000000340a000 CR4: 0000000000350ee0 [  161.329284] Call Tra=
ce:
> > > > >>>> [  161.332373]  <IRQ>
> > > > >>>> [  161.334981]  ? 0xffffffffa0185f78
> > > > >>>> [igc@00000000f400031b+0x13000] [  161.341949]
> > > > >>>> 0xffffffff8185b047 [  161.345797]  0xffffffff8185b2ca [
> > > > >>>> 161.349637]  0xffffffff81e000bb [  161.353465]
> > > > >>>> 0xffffffff81c0109f [  161.357304]  </IRQ> [  161.359988]
> > > > >>>> 0xffffffff8102cdac [  161.363783]  0xffffffff810bfdaf [
> > > > >>>> 161.367584]  0xffffffff81a2e616 [  161.371374]
> > > > >>>> 0xffffffff81c00c9e [  161.375192] RIP:
> > > > >>>> 0010:0xffffffff817e331b [  161.379840] Code: 21 90 ff 65 8b
> > > > >>>> 3d 45 23 83 7e e8 80 20 90 ff 31 ff 49 89 c6 e8 26 2d 90 ff
> > > > >>>> 80 7d d7 00 0f 85 9e 01 00 00 fb 66 0f 1f
> > > > >>>> 44 00 00 <45> 85 ff 0f 88 cf 00 00 00 49 63 cf 48 8d 04 49 48
> > > > >>>> 8d 14 81
> > > > >>>> 48 c1
> > > > >>>> [  161.401397] RSP: 0018:ffffc900000d3e80 EFLAGS: 00000246 [
> > > > >>>> 161.407493] RAX: ffff88903fea5180 RBX: ffff88903feadf00 RCX:
> > > > >>>> 000000000000001f [  161.415648] RDX: 0000000000000000 RSI:
> > > > >>>> 0000000046ec0743 RDI: 0000000000000000 [  161.423811] RBP:
> > > > >>>> ffffc900000d3eb8 R08: 00000025881a3b81 R09: ffff888100317340
> > > > >>>> [ 161.432003] R10: 0000000000000001 R11: 0000000000000000 R12:
> > > > >>>> 0000000000000003 [  161.440154] R13: ffffffff824c7bc0 R14:
> > > > >>>> 00000025881a3b81 R15: 0000000000000003 [  161.448285]
> > > > >>>> 0xffffffff817e357f [  161.452123]  0xffffffff810e6258 [
> > > > >>>> 161.455938]  0xffffffff810e63fb [  161.459746]
> > > > >>>> 0xffffffff8104bec0 [  161.463526]  0xffffffff810000f5 [
> > > > >>>> 161.467290] Modules linked in: pppoe ppp_async nft_fib_inet
> > > > >>>> nf_flow_table_ipv 6 nf_flow_table_ipv4 nf_flow_table_inet
> > > > >>>> wireguard pppox ppp_generic nft_reject_i pv6 nft_reject_ipv4
> > > > >>>> nft_reject_inet nft_reject nft_redir nft_quota nft_objref nf
> > > > >>>> t_numgen nft_nat nft_masq nft_log nft_limit nft_hash
> > > > >>>> nft_flow_offload nft_fib_ip v6 nft_fib_ipv4 nft_fib nft_ct
> > > > >>>> nft_counter nft_chain_nat nf_tables nf_nat nf_flo w_table
> > > > >>>> nf_conntrack libchacha20poly1305 curve25519_x86_64
> > > > >>>> chacha_x86_64 slhc r8 169 poly1305_x86_64 nfnetlink
> > > > >>>> nf_reject_ipv6
> > > > >>>> nf_reject_ipv4 nf_log_ipv6 nf_log_i pv4 nf_log_common
> > > > >>>> nf_defrag_ipv6
> > > > >>>> nf_defrag_ipv4 libcurve25519_generic libcrc32c libchacha igc
> > > > >>>> forcedeth e1000e crc_ccitt bnx2 i2c_dev ixgbe e1000 amd_xgbe
> > > > >>>> ip6_u dp_tunnel udp_tunnel mdio nls_utf8 ena kpp
> > > > >>>> nls_iso8859_1
> > > > >>>> nls_cp437 vfat fat igb button_hotplug tg3 ptp realtek
> > > > >>>> pps_core mii [  161.550507] ---[ end trace b1cb18ab2d1741bd
> > > > >>>> ]--- [ 161.555938] RIP: 0010:0xffffffff813ce19f [  161.560634]=
 Code:
> > > > >>>> 03 01 4c 89 48 58 e9 2f ff ff ff 85 db 41 0f 95
> > > > >>>> c2 45 39 d9 41 0f 95 c1 45 84 ca 74 05 45 85 e4 78 0a 44 89
> > > > >>>> c2
> > > > >>>> e9 10 ff ff ff <0f> 0b 01 d2 45 89 c1 41 29 d1 ba 00 00 00 00
> > > > >>>> 44 0f 48 ca eb
> > > > >>>> 80 cc
> > > > >>>> [  161.582281] RSP: 0018:ffffc90000118e88 EFLAGS: 00010283 [
> > > > >>>> 161.588426] RAX: ffff888101f8f200 RBX: ffffc900006f9bd0 RCX:
> > > > >>>> 000000000000050e [  161.596668] RDX: ffff888101fec000 RSI:
> > > > >>>> 0000000000000a1c RDI: 0000000000061a10 [  161.604860] RBP:
> > > > >>>> ffffc90000118ef8 R08: 0000000000000000 R09: 0000000000061502
> > > > >>>> [ 161.613052] R10: 0000000000000000 R11: 0000000000000000 R12:
> > > > >>>> 00000000ffffff3f [  161.621291] R13: ffff888101f8f140 R14:
> > > > >>>> 0000000000000000 R15: ffff888100ad9b00 [  161.629505] FS:
> > > > >>>> 0000000000000000(0000) GS:ffff88903fe80000(0000)
> > > > >>>> knlGS:00000 00000000000
> > > > >>>> [  161.638781] CS:  0010 DS: 0000 ES: 0000 CR0:
> > > > >>>> 0000000080050033 [  161.645549] CR2: 00007f941ad43a9b CR3:
> > > > >>>> 000000000340a000 CR4: 0000000000350ee0 [  161.653841] Kernel
> > > > >>>> panic - not syncing: Fatal exception in interrupt [
> > > > >>>> 161.661287] Kernel Offset: disabled [  161.665644] Rebooting i=
n 3 seconds..
> > > > >>>> [  164.670313] ACPI MEMORY or I/O RESET_REG.
> > > > >>>>
> > > > >>>> Kyle.
> > > > >>>> _______________________________________________
> > > > >>>> Intel-wired-lan mailing list
> > > > >>>> Intel-wired-lan@osuosl.org
> > > > >>>> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
> > > > >>>
> > > >
