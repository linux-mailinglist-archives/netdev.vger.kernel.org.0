Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F7237763D
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 12:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhEIKlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 06:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhEIKlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 06:41:39 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD93C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 03:40:35 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id n7so2818909vkl.2
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 03:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kpZn29NA9OywnkJMqu7D2/VFk4kL49g6OmXneyAMSis=;
        b=K+8E3lJzbD+qPWLyd49lWsH4y90jC/r5c39CzBOD87w9CP871zIHfPNUZUvtKLLjQs
         2S7LkWObiAK6c4lUoC/QdHN+sUD/IwJpV3pWxN1ZcxrGJs3fqAa6YZDSp1d/A14oJ4Nh
         N9h+vF5C+quX8UPvjI3uw7/kK5C+UJgmYrigwGn93NREqUCQkTM8XzKgIYxqb1EHEXtq
         kzAP0fV+4iLinZvBaPL2EiT7YNkUol/nO4lp5PxY41mfPlZPVE6pxzgkCEdEZXX1LToi
         o6Pj3cZooJXMQefD+boLHeoFZ0ygrW/vz0j95Ej/MA22fuaUIuP/ax3vD6FhQ5CJV1zh
         +UjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kpZn29NA9OywnkJMqu7D2/VFk4kL49g6OmXneyAMSis=;
        b=JgH9pDRLTEi7ybp09+41uWPBUYLJp6XaeKuVOqJZ+QeSNDSVKyfGMfDt5hHtbTkZZU
         cIUR9Mr8SLtJFDXqHvPHVtvzfZoU+qNzxd3coKfvuqRfm/Z4w3QerjjwAlFKqvvSVgp6
         H/oWumfZNIGktiZfkGrsDHiMj+98whx0DMLUSlEnGk/ItB3I5OJX3+G6OFIxKDZwP8BM
         P1J/mLtXn6SPleR4mSQrO4P/MctqV7ykHsGm2cfKQBlXvXHHEJWGkSpmekfwaNvlowwc
         vjTlJbWJHBWBMszU3AmRg2QDn5VX1/4yRpWIazEj5i/FTJFW+2OSZ3Z1847mvdOuOYQC
         QsFA==
X-Gm-Message-State: AOAM530NkqzDk5e6B96nuDY3dfEHf8XckiAgA0aatBfYm7hw2FounXrt
        fpts2ACHTSj36jNDO8mtDzeDz6z8g7U2Lf7QmzE=
X-Google-Smtp-Source: ABdhPJyHMnPmq+EQ5qOOjvgwYpFwscHqLMwz7Ag/YyM0b0agdFCHMu5vAvKE+JkiqydOWaq4uDi0vd6pyCix2gC/1eM=
X-Received: by 2002:a05:6122:72b:: with SMTP id 43mr14567460vki.11.1620556834138;
 Sun, 09 May 2021 03:40:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210316223647.4080796-1-weiwan@google.com> <6AF20AA6-07E7-4DDD-8A9E-BE093FC03802@gmail.com>
 <CANn89iJxXOZktXv6Arh82OAGOpn523NuOcWFDaSmJriOaXQMRw@mail.gmail.com>
 <AE7C80D4-DD7E-4AA7-B261-A66B30F57D3B@gmail.com> <CANn89iKyWgYeD_B-iJxL50C4BHYiDh+dWOyFYXatteF=eU7zoA@mail.gmail.com>
 <9F81F217-6E5C-49EB-95A7-CCB1D3C3ED4F@gmail.com> <00722e87685db9da3ef76166780dcbf5b4617bf7.camel@redhat.com>
In-Reply-To: <00722e87685db9da3ef76166780dcbf5b4617bf7.camel@redhat.com>
From:   Martin Zaharinov <micron10@gmail.com>
Date:   Sun, 9 May 2021 13:40:24 +0300
Message-ID: <CALidq=W-Q_450JghT8TTo0Xsm3cyQRbX9nNfM10eTUmL6-F1Fg@mail.gmail.com>
Subject: Re: Bug Report Napi GRO ixgbe
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo

Its  urgent

I get same bug with new kernel 5.12.1

its normal server with nat traffic and need GRO to be enabled to work
speed on users.

Please check :

May  9 12:30:23 [126568.653018][ T3527] ------------[ cut here ]-----------=
-
May  9 12:30:23 [126568.653019][ T3527] list_del corruption.
prev->next should be ffff9478d6b55a00, but was ffffb0ebc3123d88
May  9 12:30:23 [126568.653023][ T3527] WARNING: CPU: 20 PID: 3527 at
lib/list_debug.c:51 __list_del_entry_valid+0x79/0x90
May  9 12:30:23 [126568.653026][ T3527] Modules linked in:
nf_conntrack_netlink nfnetlink vlan_mon(O) pppoe pppox ppp_generic
slhc xt_dtvqos(O) xt_TCPMSS xt_nat iptable_mangle iptable_nat
ip_tables team_mode_loadbalance team netconsole coretemp ixgbe mdio
mdio_devres libphy nf_nat_sip nf_conntrack_sip nf_nat_pptp
nf_conntrack_pptp nf_nat_tftp nf_conntrack_tftp nf_nat_ftp
nf_conntrack_ftp nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler rtc_cmos
May  9 12:30:23 [126568.653049][ T3527] CPU: 20 PID: 3527 Comm:
napi/eth1-542 Tainted: G        W  O      5.12.1 #1
May  9 12:30:23 [126568.653050][ T3527] Hardware name: Supermicro
Super Server/X10SRi-F, BIOS 3.3 10/28/2020
May  9 12:30:23 [126568.653051][ T3527] RIP:
0010:__list_del_entry_valid+0x79/0x90
May  9 12:30:23 [126568.653054][ T3527] Code: c3 48 89 fe 4c 89 c2 48
c7 c7 08 db 34 b8 e8 2c df 51 00 0f 0b 31 c0 c3 48 89 f2 48 89 fe 48
c7 c7 40 db 34 b8 e8 15 df 51 00 <0f> 0b 31 c0 c3 48 c7 c7 80 db 34 b8
e8 04 df 51 00 0f 0b 31 c0 c3
May  9 12:30:23 [126568.653055][ T3527] RSP: 0018:ffffb0ebc3123d78
EFLAGS: 00010296
May  9 12:30:23 [126568.653056][ T3527] RAX: 0000000000000054 RBX:
ffff9478d6b55a00 RCX: 80000000fff832ec
May  9 12:30:23 [126568.653057][ T3527] RDX: 0000000000000000 RSI:
0000000000000002 RDI: ffffffffb8b59898
May  9 12:30:23 [126568.653058][ T3527] RBP: ffff9477eac08158 R08:
00000000000098c4 R09: 000000000000000f
May  9 12:30:23 [126568.653059][ T3527] R10: 0000000000000004 R11:
ffff947f1e8fa1b4 R12: ffff9478d6b54400
May  9 12:30:23 [126568.653059][ T3527] R13: ffff9478d6b55a00 R14:
ffff94789340d400 R15: ffffb0ebc3123d88
May  9 12:30:23 [126568.653060][ T3527] FS:  0000000000000000(0000)
GS:ffff947f1fd00000(0000) knlGS:0000000000000000
May  9 12:30:23 [126568.653061][ T3527] CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
May  9 12:30:24 [126568.653062][ T3527] CR2: 00007fc73d0e0000 CR3:
00000001dea18003 CR4: 00000000001706e0
May  9 12:30:24 [126568.653063][ T3527] Call Trace:
May  9 12:30:24 [126568.653063][ T3527]
netif_receive_skb_list_internal+0x5e/0x2b0
May  9 12:30:24 [126568.653066][ T3527]  ? napi_gro_receive+0x14d/0x160
May  9 12:30:24 [126568.653068][ T3527]  ? enqueue_to_backlog+0x39/0x250
May  9 12:30:24 [126568.653069][ T3527]  napi_gro_flush+0x11b/0x260
May  9 12:30:24 [126568.653071][ T3527]  napi_complete_done+0x107/0x180
May  9 12:30:24 [126568.653073][ T3527]  ixgbe_poll+0x10e/0x2a0 [ixgbe]
May  9 12:30:24 [126568.653080][ T3527]  __napi_poll+0x1f/0x130
May  9 12:30:24 [126568.653082][ T3527]  napi_threaded_poll+0x105/0x150
May  9 12:30:24 [126568.653084][ T3527]  ? __napi_poll+0x130/0x130
May  9 12:30:24 [126568.653086][ T3527]  kthread+0xea/0x120
May  9 12:30:24 [126568.653088][ T3527]  ? kthread_park+0x80/0x80
May  9 12:30:24 [126568.653090][ T3527]  ret_from_fork+0x1f/0x30
May  9 12:30:24 [126568.653092][ T3527] ---[ end trace 946b481f5c11bfe9 ]--=
-
May  9 12:30:24 [126568.653092][ T3527] ------------[ cut here ]-----------=
-
May  9 12:30:24 [126568.653093][ T3527] list_del corruption.
prev->next should be ffff9478d6b54400, but was ffffb0ebc3123d88
May  9 12:30:24 [126568.653097][ T3527] WARNING: CPU: 20 PID: 3527 at
lib/list_debug.c:51 __list_del_entry_valid+0x79/0x90
May  9 12:30:24 [126568.653099][ T3527] Modules linked in:
nf_conntrack_netlink nfnetlink vlan_mon(O) pppoe pppox ppp_generic
slhc xt_dtvqos(O) xt_TCPMSS xt_nat iptable_mangle iptable_nat
ip_tables team_mode_loadbalance team netconsole coretemp ixgbe mdio
mdio_devres libphy nf_nat_sip nf_conntrack_sip nf_nat_pptp
nf_conntrack_pptp nf_nat_tftp nf_conntrack_tftp nf_nat_ftp
nf_conntrack_ftp nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler rtc_cmos
May  9 12:30:24 [126568.653113][ T3527] CPU: 20 PID: 3527 Comm:
napi/eth1-542 Tainted: G        W  O      5.12.1 #1
May  9 12:30:24 [126568.653114][ T3527] Hardware name: Supermicro
Super Server/X10SRi-F, BIOS 3.3 10/28/2020
May  9 12:30:24 [126568.653114][ T3527] RIP:
0010:__list_del_entry_valid+0x79/0x90
May  9 12:30:24 [126568.653116][ T3527] Code: c3 48 89 fe 4c 89 c2 48
c7 c7 08 db 34 b8 e8 2c df 51 00 0f 0b 31 c0 c3 48 89 f2 48 89 fe 48
c7 c7 40 db 34 b8 e8 15 df 51 00 <0f> 0b 31 c0 c3 48 c7 c7 80 db 34 b8
e8 04 df 51 00 0f 0b 31 c0 c3
May  9 12:30:24 [126568.653117][ T3527] RSP: 0018:ffffb0ebc3123d78
EFLAGS: 00010296
May  9 12:30:24 [126568.653118][ T3527] RAX: 0000000000000054 RBX:
ffff9478d6b54400 RCX: 80000000fff8330b
May  9 12:30:24 [126568.653119][ T3527] RDX: 0000000000000000 RSI:
0000000000000002 RDI: ffffffffb8b59898
May  9 12:30:24 [126568.653120][ T3527] RBP: ffff9477eac08158 R08:
0000000000009921 R09: 000000000000000f
May  9 12:30:24 [126568.653120][ T3527] R10: 0000000000000004 R11:
ffff947f1e8fab74 R12: ffff9478d6b55800
May  9 12:30:24 [126568.653121][ T3527] R13: ffff9478d6b54400 R14:
ffff9478d6b54700 R15: ffffb0ebc3123d88
May  9 12:30:25 [126568.653122][ T3527] FS:  0000000000000000(0000)
GS:ffff947f1fd00000(0000) knlGS:0000000000000000
May  9 12:30:25 [126568.653123][ T3527] CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
May  9 12:30:25 [126568.653124][ T3527] CR2: 00007fc73d0e0000 CR3:
00000001dea18003 CR4: 00000000001706e0
May  9 12:30:25 [126568.653124][ T3527] Call Trace:
May  9 12:30:25 [126568.653125][ T3527]
netif_receive_skb_list_internal+0x5e/0x2b0
May  9 12:30:25 [126568.653127][ T3527]  ? napi_gro_receive+0x14d/0x160
May  9 12:30:25 [126568.653129][ T3527]  ? enqueue_to_backlog+0x39/0x250
May  9 12:30:25 [126568.653130][ T3527]  napi_gro_flush+0x11b/0x260
May  9 12:30:25 [126568.653132][ T3527]  napi_complete_done+0x107/0x180
May  9 12:30:25 [126568.653134][ T3527]  ixgbe_poll+0x10e/0x2a0 [ixgbe]
May  9 12:30:25 [126568.653140][ T3527]  __napi_poll+0x1f/0x130
May  9 12:30:25 [126568.653142][ T3527]  napi_threaded_poll+0x105/0x150
May  9 12:30:25 [126568.653144][ T3527]  ? __napi_poll+0x130/0x130
May  9 12:30:25 [126568.653146][ T3527]  kthread+0xea/0x120
May  9 12:30:25 [126568.653148][ T3527]  ? kthread_park+0x80/0x80
May  9 12:30:25 [126568.653151][ T3527]  ret_from_fork+0x1f/0x30
May  9 12:30:25 [126568.653152][ T3527] ---[ end trace 946b481f5c11bfea ]--=
-

Best Regards,
Martin

=D0=9D=D0=B0 =D0=BF=D0=BD, 12.04.2021 =D0=B3. =D0=B2 11:37 =D1=87. Paolo Ab=
eni <pabeni@redhat.com> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0:
>
> Hello,
>
> On Sat, 2021-04-10 at 14:22 +0300, Martin Zaharinov wrote:
> > Hi  Team
> >
> > One report latest kernel 5.11.12
> >
> > Please check and help to find and fix
>
> Please provide a complete splat, including the trapping instruction.
> >
> > Apr 10 12:46:25  [214315.519319][ T3345] R13: ffff8cf193ddf700 R14: fff=
f8cf238ab3500 R15: ffff91ab82133d88
> > Apr 10 12:46:26  [214315.570814][ T3345] FS:  0000000000000000(0000) GS=
:ffff8cf3efb00000(0000) knlGS:0000000000000000
> > Apr 10 12:46:26  [214315.622416][ T3345] CS:  0010 DS: 0000 ES: 0000 CR=
0: 0000000080050033
> > Apr 10 12:46:26  [214315.648390][ T3345] CR2: 00007f7211406000 CR3: 000=
00001a924a004 CR4: 00000000001706e0
> > Apr 10 12:46:26  [214315.698998][ T3345] DR0: 0000000000000000 DR1: 000=
0000000000000 DR2: 0000000000000000
> > Apr 10 12:46:26  [214315.749508][ T3345] DR3: 0000000000000000 DR6: 000=
00000fffe0ff0 DR7: 0000000000000400
> > Apr 10 12:46:26  [214315.799749][ T3345] Call Trace:
> > Apr 10 12:46:26  [214315.824268][ T3345]  netif_receive_skb_list_intern=
al+0x5e/0x2c0
> > Apr 10 12:46:26  [214315.848996][ T3345]  napi_gro_flush+0x11b/0x260
> > Apr 10 12:46:26  [214315.873320][ T3345]  napi_complete_done+0x107/0x18=
0
> > Apr 10 12:46:26  [214315.897160][ T3345]  ixgbe_poll+0x10e/0x2a0 [ixgbe=
]
> > Apr 10 12:46:26  [214315.920564][ T3345]  __napi_poll+0x1f/0x130
> > Apr 10 12:46:26  [214315.943475][ T3345]  napi_threaded_poll+0x110/0x16=
0
> > Apr 10 12:46:26  [214315.966252][ T3345]  ? __napi_poll+0x130/0x130
> > Apr 10 12:46:26  [214315.988424][ T3345]  kthread+0xea/0x120
> > Apr 10 12:46:26  [214316.010247][ T3345]  ? kthread_park+0x80/0x80
> > Apr 10 12:46:26  [214316.031729][ T3345]  ret_from_fork+0x1f/0x30
>
> Could you please also provide the decoded the stack trace? Something
> alike the following will do:
>
> cat <file contaning the splat> | ./scripts/decode_stacktrace.sh <path to =
vmlinux>
>
> Even more importantly:
>
> threaded napi is implemented with the merge
> commit adbb4fb028452b1b0488a1a7b66ab856cdf20715, which landed into the
> vanilla tree since v5.12.rc1 and is not backported to 5.11.x. What
> kernel are you really using?
>
> Thanks,
>
> Paolo
>
