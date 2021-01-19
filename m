Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB092FBB67
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391619AbhASPkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:40:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37522 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389723AbhASPiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:38:55 -0500
Received: from mail-wm1-f69.google.com ([209.85.128.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <juerg.haefliger@canonical.com>)
        id 1l1t51-0003Cb-Hz
        for netdev@vger.kernel.org; Tue, 19 Jan 2021 15:38:03 +0000
Received: by mail-wm1-f69.google.com with SMTP id u1so68221wml.2
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 07:38:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version;
        bh=zmr+ZHeMH7TPPiTw35fY+HSgafuN9c9R211kvmDv84k=;
        b=d6pIyZZs6+1jmclFXnXCT+0Beskkd3qc0wnsV8GiJZDejTMxfgBEyYp1/uLA6anICp
         1zIErQ659EVxDUwvO7+6DIttWx0X5DHhajN+2BPLh0YdjIsvoWB7za1rSkKZdW/Cdkei
         wCaY+KB31OmRZVRRlDeiJ3nCbIp1wbiC83pJNh0gtlzV+6R/vxVxhD4NaGHPd5U9v23q
         GbOUkMzcV+FJnL4kfCMlBuHVelGk0TmrIYVsYWgW8CtAQdmGrJScUz2wPq7WT3tFePE9
         jBJzeEa98JA0JWyZ2SeVYLrl2PdEmntC+vhNIy6xstl2X0YQaGpL1dkrnrpfKV3eUVQX
         6Ndw==
X-Gm-Message-State: AOAM5314E0s+i+Npr10d88Z4Tcatr58xZx4kwmH9Yy4Uu/t5Oz3GWbEn
        igw1JLz/jvboKYZKChl8gjSkx9/G2jxHw49b3tEHNrCfcUwJs2knROBa1xI+svIsjFfLwUJiRJs
        inxEke1Ubfu8Aju8v/PVFIG1RIVO+0AFrjA==
X-Received: by 2002:a1c:9e02:: with SMTP id h2mr187106wme.107.1611070683094;
        Tue, 19 Jan 2021 07:38:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGEw0UbwzlPYPTLPOSTBiJ/2jK9yxyirFrvq1DAj9Rw1vq+rnYBF/85CcqrbJQvbaZo+2ctQ==
X-Received: by 2002:a1c:9e02:: with SMTP id h2mr187080wme.107.1611070682640;
        Tue, 19 Jan 2021 07:38:02 -0800 (PST)
Received: from gollum ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id o9sm3944992wrw.81.2021.01.19.07.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:38:01 -0800 (PST)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
Date:   Tue, 19 Jan 2021 16:38:00 +0100
To:     Eric Dumazet <edumazet@google.com>
Cc:     Juerg Haefliger <juerg.haefliger@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
Message-ID: <20210119163800.4859912e@gollum>
In-Reply-To: <CANn89iJOK2ZznurYCnP4y8xjkocm6t+AZG1DaSnpe-ZDFUfdaA@mail.gmail.com>
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
        <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com>
        <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
        <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com>
        <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
        <b6ff841a-320c-5592-1c2b-650e18dfe3e0@gmail.com>
        <CANn89iJ2KxQKZmT2ShVZRTjdgyYkF_2ZWBraTZE4TJVtUKh--Q@mail.gmail.com>
        <9e4b2b1f-c2d9-dbd0-c7ce-49007ddd7af2@gmail.com>
        <CANn89iJwwDCkdmFFAkXav+HNJQEEKZsp8PKvEuHc4gNJ=4iCoQ@mail.gmail.com>
        <77541223-8eaf-512c-1930-558e8d23eb33@gmail.com>
        <CANn89i+dtetSScxtSRWX8BEgcW_uJ7vzvb+8sW57b7DJ3r=fXQ@mail.gmail.com>
        <20210119134023.082577ca@gollum>
        <CANn89iJOK2ZznurYCnP4y8xjkocm6t+AZG1DaSnpe-ZDFUfdaA@mail.gmail.com>
Organization: Canonical Ltd
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ipSp+2EomV4W6M0lLL8aqU9";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ipSp+2EomV4W6M0lLL8aqU9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Jan 2021 14:54:31 +0100
Eric Dumazet <edumazet@google.com> wrote:

> On Tue, Jan 19, 2021 at 1:40 PM Juerg Haefliger
> <juerg.haefliger@canonical.com> wrote:
>=20
> >
> > I seem to have stumbled over the same or a similar issue with a Raspber=
ry Pi
> > 3B+ running 5.11-rc4 and using the on-board lan78xx USB NIC. The Pi is =
used
> > as a gateway. If I enable IP forwarding on the Pi and pound on eth0 [1]=
, I
> > get tons of the below warnings after a couple of seconds:
> >
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.744157] skb len=
=3D54 headroom=3D5194 headlen=3D54 tailroom=3D10816
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.744157] mac=3D(5=
194,14) net=3D(5208,20) trans=3D5228
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.744157] shinfo(t=
xflags=3D0 nr_frags=3D0 gso(size=3D1448 type=3D0 segs=3D1))
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.744157] csum(0xe=
505 ip_summed=3D0 complete_sw=3D0 valid=3D0 level=3D0)
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.744157] hash(0x0=
 sw=3D0 l4=3D0) proto=3D0x0800 pkttype=3D0 iif=3D2
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.774147] dev name=
=3Deth0 feat=3D0x0x0000010000114b09
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.779355] skb line=
ar:   00000000: e0 28 6d 9e b9 22 b8 27 eb 3e ab fb 08 00 45 00
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.787365] skb line=
ar:   00000010: 00 28 00 00 40 00 3f 06 41 d0 c0 a8 63 84 02 14
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.795266] skb line=
ar:   00000020: d3 bf ed 3e 01 bb d4 0f 88 7e 00 00 00 00 50 04
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.803168] skb line=
ar:   00000030: 00 00 6a 58 00 00
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.808384] --------=
----[ cut here ]------------
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.813200] lan78xx:=
 caps=3D(0x0000010000114b09, 0x0000000000000000)
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.819717] WARNING:=
 CPU: 0 PID: 0 at net/core/dev.c:3197 skb_warn_bad_offload+0x84/0x100
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.828190] Modules =
linked in:
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.831354] CPU: 0 P=
ID: 0 Comm: swapper/0 Not tainted 5.11.0-rc4 #103
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.838009] Hardware=
 name: Raspberry Pi 3 Model B Plus Rev 1.3 (DT)
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.844478] pstate: =
60000005 (nZCv daif -PAN -UAO -TCO BTYPE=3D--)
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.850685] pc : skb=
_warn_bad_offload+0x84/0x100
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.855464] lr : skb=
_warn_bad_offload+0x84/0x100
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.860242] sp : fff=
f800010003850
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.863665] x29: fff=
f800010003850 x28: ffff7a96fb196290
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.869160] x27: fff=
f7a96c5958300 x26: 0000000000000001
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.874654] x25: fff=
fa73eee323000 x24: ffff7a96ee84b000
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.880148] x23: fff=
fa73eee7f4f00 x22: 0000000000000000
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.885642] x21: fff=
fa73eee0327e0 x20: ffff7a96ee84b000
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.891136] x19: fff=
f7a96c5958300 x18: 0000000000000010
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.896630] x17: 000=
0000000000000 x16: 0000000000000000
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.902123] x15: 000=
000000000ad55 x14: 0000000000000010
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.907617] x13: 000=
00000ffffffff x12: ffffa73eedd9d950
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.913109] x11: fff=
fa73eee885de0 x10: ffffa73eee86dda0
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.918603] x9 : fff=
fa73eecf2f45c x8 : 0000000000017fe8
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.924097] x7 : c00=
00000ffffefff x6 : 0000000000000003
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.929590] x5 : 000=
0000000000000 x4 : 0000000000000000
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.935081] x3 : 000=
0000000000100 x2 : 0000000000001000
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.940575] x1 : 000=
0000000000000 x0 : 0000000000000000
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.946070] Call tra=
ce:
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.948599]  skb_war=
n_bad_offload+0x84/0x100
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.953020]  netif_s=
kb_features+0x218/0x2a0
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.957350]  validat=
e_xmit_skb.isra.0+0x28/0x2c8
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.962125]  validat=
e_xmit_skb_list+0x44/0x98
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.966631]  sch_dir=
ect_xmit+0xf0/0x3a8
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.970599]  __qdisc=
_run+0x140/0x668
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.974297]  __dev_q=
ueue_xmit+0x59c/0x980
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.978446]  dev_que=
ue_xmit+0x1c/0x28
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.982237]  ip_fini=
sh_output2+0x30c/0x558
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.986476]  __ip_fi=
nish_output+0xe4/0x260
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.990715]  ip_fini=
sh_output+0x3c/0xd8
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.994683]  ip_outp=
ut+0xb4/0x148
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1914.998116]  ip_forw=
ard_finish+0x7c/0xc0
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.002174]  ip_forw=
ard+0x42c/0x4f0
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.005783]  ip_rcv_=
finish+0x98/0xb8
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.009481]  ip_rcv+=
0xe0/0xf0
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.012552]  __netif=
_receive_skb_one_core+0x5c/0x88
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.017597]  __netif=
_receive_skb+0x20/0x70
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.021834]  process=
_backlog+0xc0/0x1d0
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.025802]  net_rx_=
action+0x134/0x478
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.029682]  __do_so=
ftirq+0x130/0x378
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.033472]  irq_exi=
t+0xc0/0xe8
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.036725]  __handl=
e_domain_irq+0x70/0xc8
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.040963]  bcm2836=
_arm_irqchip_handle_irq+0x6c/0x80
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.046185]  el1_irq=
+0xb4/0x140
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.053377]  arch_cp=
u_idle+0x18/0x28
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.060981]  default=
_idle_call+0x44/0x178
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.069009]  do_idle=
+0x224/0x270
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.076147]  cpu_sta=
rtup_entry+0x30/0x98
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.083916]  rest_in=
it+0xc8/0xd8
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.090937]  arch_ca=
ll_rest_init+0x18/0x24
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.098829]  start_k=
ernel+0x57c/0x5b8
> > Jan 19 07:55:22 rpi-3b-plus-rev1d3-abfb kernel: [ 1915.106251] ---[ end=
 trace c3d8dd12ce1805e0 ]---
> >
> > If I also add the following rule:
> >   $ iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
> > I get a single warning followed by a TX timeout:
> >
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.516888] skb len=
=3D66 headroom=3D5194 headlen=3D66 tailroom=3D10804
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.516888] mac=3D(5=
194,14) net=3D(5208,20) trans=3D5228
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.516888] shinfo(t=
xflags=3D0 nr_frags=3D0 gso(size=3D1448 type=3D0 segs=3D1))
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.516888] csum(0xe=
edb ip_summed=3D1 complete_sw=3D0 valid=3D0 level=3D0)
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.516888] hash(0x0=
 sw=3D0 l4=3D0) proto=3D0x0800 pkttype=3D0 iif=3D2
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.546872] dev name=
=3Deth0 feat=3D0x0x0000010000114b09
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.552060] skb line=
ar:   00000000: e0 28 6d 9e b9 22 b8 27 eb 3e ab fb 08 00 45 00
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.560090] skb line=
ar:   00000010: 00 34 90 99 40 00 3f 06 87 40 c0 a8 63 84 22 6b
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.568019] skb line=
ar:   00000020: dd 52 d0 ac 00 50 35 e0 1e 2c 78 02 47 fa 80 10
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.575921] skb line=
ar:   00000030: 01 f6 d6 96 00 00 01 01 08 0a 50 c9 d7 4b cd 2e
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.583918] skb line=
ar:   00000040: 9f fc
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.588105] --------=
----[ cut here ]------------
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.592920] lan78xx:=
 caps=3D(0x0000010000114b09, 0x0000000000000000)
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.599429] WARNING:=
 CPU: 0 PID: 0 at net/core/dev.c:3197 skb_warn_bad_offload+0x84/0x100
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.607900] Modules =
linked in:
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.611064] CPU: 0 P=
ID: 0 Comm: swapper/0 Not tainted 5.11.0-rc4 #103
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.617720] Hardware=
 name: Raspberry Pi 3 Model B Plus Rev 1.3 (DT)
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.624189] pstate: =
60000005 (nZCv daif -PAN -UAO -TCO BTYPE=3D--)
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.630396] pc : skb=
_warn_bad_offload+0x84/0x100
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.635175] lr : skb=
_warn_bad_offload+0x84/0x100
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.639953] sp : fff=
f800010003810
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.643374] x29: fff=
f800010003810 x28: ffff50043b196290
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.648870] x27: fff=
f500407371600 x26: 0000000000000001
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.654365] x25: fff=
fa1fa11b23000 x24: ffff50042e96b000
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.659859] x23: fff=
fa1fa11ff4f00 x22: 0000000000000000
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.665353] x21: fff=
fa1fa118327e0 x20: ffff50042e96b000
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.670847] x19: fff=
f500407371600 x18: 0000000000000010
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.676340] x17: 000=
0000000000000 x16: 0000000000000000
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.681833] x15: 000=
000000000ad55 x14: 0000000000000010
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.687326] x13: 000=
00000ffffffff x12: ffffa1fa1159d950
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.692819] x11: fff=
fa1fa12085de0 x10: ffffa1fa1206dda0
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.698313] x9 : fff=
fa1fa1072f45c x8 : 0000000000017fe8
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.703806] x7 : c00=
00000ffffefff x6 : 0000000000000003
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.709300] x5 : 000=
0000000000000 x4 : 0000000000000000
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.714791] x3 : 000=
0000000000100 x2 : 0000000000001000
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.720283] x1 : 000=
0000000000000 x0 : 0000000000000000
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.725778] Call tra=
ce:
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.728306]  skb_war=
n_bad_offload+0x84/0x100
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.732728]  netif_s=
kb_features+0x218/0x2a0
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.737057]  validat=
e_xmit_skb.isra.0+0x28/0x2c8
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.741833]  validat=
e_xmit_skb_list+0x44/0x98
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.746339]  sch_dir=
ect_xmit+0xf0/0x3a8
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.750309]  __qdisc=
_run+0x140/0x668
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.754008]  __dev_q=
ueue_xmit+0x59c/0x980
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.758156]  dev_que=
ue_xmit+0x1c/0x28
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.761945]  neigh_r=
esolve_output+0x108/0x230
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.766450]  ip_fini=
sh_output2+0x180/0x558
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.770690]  __ip_fi=
nish_output+0xe4/0x260
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.774928]  ip_fini=
sh_output+0x3c/0xd8
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.778896]  ip_outp=
ut+0xb4/0x148
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.782328]  ip_forw=
ard_finish+0x7c/0xc0
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.786385]  ip_forw=
ard+0x42c/0x4f0
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.789995]  ip_rcv_=
finish+0x98/0xb8
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.793694]  ip_rcv+=
0xe0/0xf0
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.796765]  __netif=
_receive_skb_one_core+0x5c/0x88
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.801810]  __netif=
_receive_skb+0x20/0x70
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.806047]  process=
_backlog+0xc0/0x1d0
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.810016]  net_rx_=
action+0x134/0x478
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.813897]  __do_so=
ftirq+0x130/0x378
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.817686]  irq_exi=
t+0xc0/0xe8
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.820940]  __handl=
e_domain_irq+0x70/0xc8
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.829099]  bcm2836=
_arm_irqchip_handle_irq+0x6c/0x80
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.838223]  el1_irq=
+0xb4/0x140
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.845371]  arch_cp=
u_idle+0x18/0x28
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.852882]  default=
_idle_call+0x44/0x178
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.860756]  do_idle=
+0x224/0x270
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.867794]  cpu_sta=
rtup_entry+0x30/0x98
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.875516]  rest_in=
it+0xc8/0xd8
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.882496]  arch_ca=
ll_rest_init+0x18/0x24
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.890352]  start_k=
ernel+0x57c/0x5b8
> > Jan 19 08:15:47 rpi-3b-plus-rev1d3-abfb kernel: [   81.897706] ---[ end=
 trace a5789410f231a10b ]---
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.046337] --------=
----[ cut here ]------------
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.054787] NETDEV W=
ATCHDOG: eth0 (lan78xx): transmit queue 0 timed out
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.065356] WARNING:=
 CPU: 2 PID: 0 at net/sched/sch_generic.c:442 dev_watchdog+0x384/0x390
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.077534] Modules =
linked in:
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.084361] CPU: 2 P=
ID: 0 Comm: swapper/2 Tainted: G        W         5.11.0-rc4 #103
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.096114] Hardware=
 name: Raspberry Pi 3 Model B Plus Rev 1.3 (DT)
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.106246] pstate: =
60000005 (nZCv daif -PAN -UAO -TCO BTYPE=3D--)
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.116085] pc : dev=
_watchdog+0x384/0x390
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.123857] lr : dev=
_watchdog+0x384/0x390
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.131558] sp : fff=
f800010013d90
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.138497] x29: fff=
f800010013d90 x28: 0000000000000140
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.147472] x27: 000=
00000ffffffff x26: ffffa1fa11b23000
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.156489] x25: 000=
0000000000002 x24: 0000000000000000
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.165496] x23: 000=
0000000000001 x22: ffff50042e96b000
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.174494] x21: fff=
f50042e96b440 x20: ffffa1fa11fe7000
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.183490] x19: 000=
0000000000000 x18: 0000000000000010
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.192493] x17: 000=
0000000000000 x16: 0000000000000000
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.201473] x15: 000=
000000000ad55 x14: 0000000000000010
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.210439] x13: 000=
00000ffffffff x12: ffffa1fa1159d950
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.219397] x11: fff=
fa1fa12085de0 x10: ffffa1fa1206dda0
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.228367] x9 : fff=
fa1fa1072f45c x8 : 0000000000017fe8
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.237362] x7 : c00=
00000ffffefff x6 : 0000000000000003
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.246353] x5 : 000=
0000000000000 x4 : 0000000000000000
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.255328] x3 : 000=
0000000000100 x2 : 0000000000001000
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.264273] x1 : 000=
0000000000000 x0 : 0000000000000000
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.273192] Call tra=
ce:
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.279183]  dev_wat=
chdog+0x384/0x390
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.286461]  call_ti=
mer_fn+0x38/0x188
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.293762]  run_tim=
er_softirq+0x494/0x688
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.301489]  __do_so=
ftirq+0x130/0x378
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.308767]  irq_exi=
t+0xc0/0xe8
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.315500]  __handl=
e_domain_irq+0x70/0xc8
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.323214]  bcm2836=
_arm_irqchip_handle_irq+0x6c/0x80
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.331940]  el1_irq=
+0xb4/0x140
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.338706]  arch_cp=
u_idle+0x18/0x28
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.345916]  default=
_idle_call+0x44/0x178
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.353577]  do_idle=
+0x224/0x270
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.360433]  cpu_sta=
rtup_entry+0x2c/0x98
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.368000]  seconda=
ry_start_kernel+0x148/0x180
> > Jan 19 08:16:15 rpi-3b-plus-rev1d3-abfb kernel: [  110.376199] ---[ end=
 trace a5789410f231a10c ]---
> >
> > I did some bisecting and found commit [2] to be problematic. Reverting =
that
> > commit plus the two follow-on fixes [3] and [4] prevents the warnings a=
nd
> > timeout. I'm no networking expert so can't determine if [2] is broken or
> > merely exposes a different underlying issue. I failed to reproduce the =
problem
> > using a dedicated Realtek-based USB NIC plugged into the Pi, which poin=
ts
> > towards the lan78xx driver/HW being the culprit.
> >
> > Enabling KASAN didn't trigger any error reports.
> >
> > Let me know if there's anything else I can try to narrow this down.
> >
> > ...Juerg
> >
> > [1]
> > On the Pi, I run:
> >   $ nc -l 1234 | dd status=3Dprogress >/dev/null
> >
> > And on another machine, that is configured to use the Pi as the gateway:
> >   $ nc 192.168.99.115 1234 < /dev/urandom
> > and a couple of firefox instances that keep opening public URls.
> >
> > [2]
> > Author: Eric Dumazet <edumazet@google.com>
> > Date:   Tue Nov 27 14:42:03 2018 -0800
> >
> >     tcp: implement coalescing on backlog queue
> >
> >     In case GRO is not as efficient as it should be or disabled,
> >     we might have a user thread trapped in __release_sock() while
> >     softirq handler flood packets up to the point we have to drop.
> >
> >     This patch balances work done from user thread and softirq,
> >     to give more chances to __release_sock() to complete its work
> >     before new packets are added the the backlog.
> >
> >     This also helps if we receive many ACK packets, since GRO
> >     does not aggregate them.
> >
> >     This patch brings ~60% throughput increase on a receiver
> >     without GRO, but the spectacular gain is really on
> >     1000x release_sock() latency reduction I have measured.
> >
> >     Signed-off-by: Eric Dumazet <edumazet@google.com>
> >     Cc: Neal Cardwell <ncardwell@google.com>
> >     Cc: Yuchung Cheng <ycheng@google.com>
> >     Acked-by: Neal Cardwell <ncardwell@google.com>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> > [3] 86bccd036713 tcp: fix receive window update in tcp_add_backlog()
> > [4] ca2fe2956ace tcp: add sanity tests in tcp_add_backlog() =20
>=20
>=20
> Oops. Very nice detective work :)
>=20
> It is true that the skb_clone() done in lan78xx (and some other usb
> drivers) is probably triggering this issue.
> (lan78xx is also lying about skb->truesize)
>=20
> skb_try_coalesce() bails if the target  skb is cloned, but not if the sou=
rce is.
>=20
>=20
> Can you try the following patch ?

Works. Nice :-)

If you submit this and care you can add:

Tested-by: Juerg Haefliger <juergh@canonical.com>

Thanks a lot for the quick turnaround!

...Juerg


> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 58207c7769d05693b650e3c93e4ef405a5d4b23a..4e82745d336fc3fb0d9ce8c92=
aaeb39702f64b8a
> 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1760,6 +1760,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
>  bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
>  {
>         u32 limit =3D READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf);
> +       u32 tail_gso_size, tail_gso_segs;
>         struct skb_shared_info *shinfo;
>         const struct tcphdr *th;
>         struct tcphdr *thtail;
> @@ -1767,6 +1768,7 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buf=
f *skb)
>         unsigned int hdrlen;
>         bool fragstolen;
>         u32 gso_segs;
> +       u32 gso_size;
>         int delta;
>=20
>         /* In case all data was pulled from skb frags (in __pskb_pull_tai=
l()),
> @@ -1792,13 +1794,6 @@ bool tcp_add_backlog(struct sock *sk, struct
> sk_buff *skb)
>          */
>         th =3D (const struct tcphdr *)skb->data;
>         hdrlen =3D th->doff * 4;
> -       shinfo =3D skb_shinfo(skb);
> -
> -       if (!shinfo->gso_size)
> -               shinfo->gso_size =3D skb->len - hdrlen;
> -
> -       if (!shinfo->gso_segs)
> -               shinfo->gso_segs =3D 1;
>=20
>         tail =3D sk->sk_backlog.tail;
>         if (!tail)
> @@ -1821,6 +1816,15 @@ bool tcp_add_backlog(struct sock *sk, struct
> sk_buff *skb)
>                 goto no_coalesce;
>=20
>         __skb_pull(skb, hdrlen);
> +
> +       shinfo =3D skb_shinfo(skb);
> +       gso_size =3D shinfo->gso_size ?: skb->len;
> +       gso_segs =3D shinfo->gso_segs ?: 1;
> +
> +       shinfo =3D skb_shinfo(tail);
> +       tail_gso_size =3D shinfo->gso_size ?: (tail->len - hdrlen);
> +       tail_gso_segs =3D shinfo->gso_segs ?: 1;
> +
>         if (skb_try_coalesce(tail, skb, &fragstolen, &delta)) {
>                 TCP_SKB_CB(tail)->end_seq =3D TCP_SKB_CB(skb)->end_seq;
>=20
> @@ -1847,11 +1851,8 @@ bool tcp_add_backlog(struct sock *sk, struct
> sk_buff *skb)
>                 }
>=20
>                 /* Not as strict as GRO. We only need to carry mss max va=
lue */
> -               skb_shinfo(tail)->gso_size =3D max(shinfo->gso_size,
> -                                                skb_shinfo(tail)->gso_si=
ze);
> -
> -               gso_segs =3D skb_shinfo(tail)->gso_segs + shinfo->gso_seg=
s;
> -               skb_shinfo(tail)->gso_segs =3D min_t(u32, gso_segs, 0xFFF=
F);
> +               shinfo->gso_size =3D max(gso_size, tail_gso_size);
> +               shinfo->gso_segs =3D min_t(u32, gso_segs + tail_gso_segs,=
 0xFFFF);
>=20
>                 sk->sk_backlog.len +=3D delta;
>                 __NET_INC_STATS(sock_net(sk),


--Sig_/ipSp+2EomV4W6M0lLL8aqU9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEhZfU96IuprviLdeLD9OLCQumQrcFAmAG/NgACgkQD9OLCQum
QreWsg/8DFhdD5RryU5UqtzQFxKuhHqTqF7Q8CTF7wAmNLZw1CiSVpQYEX5M8Rdy
y7OsoBitb/bMc7j8yG2foQXsELkUTKpD+cvr7GBeFfX6slbpZFQcTbfKdMyMjg4+
Hkzk2BUN9yIbOYvXg6IVY0Q2jV5uJs2fnOK6RJpOfjS3nuXpm6nUKZuPNsRvj1EO
ud7Y3eRAdU4VIZZzdE/CoITJWhzPUdOv+bHwoP3bGHvHjBzx1ORW3D+4CMUay7kr
xmLjYkGQwbTQGqxM/9lk8Wrt4p6y4F84LxfYoNthbsZR9cAEXNOEKKtn9mkX7d7i
0ejKZFxt5gihl80ArElJxyRP3HPooNe1Ex+odHzCpThfun+YTg5otuRteknssH3d
XjmiHBtRZSaFwM6sGgPn4AeiO4O1Elrs9zBkXQeYstnfyT0mRxp5fsDONbLG+j+H
/iVgWWOVvsICw1LOjfE2wkj3sKoTvPoW+hD+HYIUNaVcklLaGOBlpPkntRTMgjg6
pemli10adkMvk9w4kcXoiJOqQK4vgAubkg+VqzNfqYOhJ3oJwdhGAQM0+7ovTyW7
x0DzgHKOnPdjHzQ2YGOEj+SeuDoV4CsEarHZhtmTO9JiDQxW0CdXnrzqDJBGiwvi
XqcN/94bY7yh1hwbpbZn4UEvmt3f4Wmx6g8Uao165eVC/61x2Hk=
=Ez6H
-----END PGP SIGNATURE-----

--Sig_/ipSp+2EomV4W6M0lLL8aqU9--
