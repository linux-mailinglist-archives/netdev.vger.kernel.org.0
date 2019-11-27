Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8491E10B709
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfK0Ttf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:49:35 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35105 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbfK0Ttf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 14:49:35 -0500
Received: by mail-lf1-f65.google.com with SMTP id r15so15202455lff.2
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 11:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=tpa6qsgsffF6MZ2hAroMhBII3NVwR7/Y88cSdiliNf0=;
        b=HyzdQVmo2vsOZyvKTv/HixleVW+fE/oq7v6M/t9xSKYG/a1OT34vVXcp5W3hNJy1zP
         mB75uz9wyD1j/1SGSqhE57PHS5G23SWJpr2Uj8ojzcXEQj4dG4HZYvtr/XAQY7QYe1+M
         9p1r2GJ8BRVNhwtH8IsnohsSkt7IdYgL+GgwzqZ15Af1HRQWQJRlbrlJ54p/MElxPUw3
         q4jG/caVgnm2ZOko1agVFfd9raXvqkuNsBCBB1v35QlfzkZp7mVGVY+qZiCf+5XyTciZ
         W3yfw0segLv00PbeIPWCzrQKnilNCrs28T2ucr53EdN6MBs+nzbnoUf4Gikmcpnq1f+m
         mCmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=tpa6qsgsffF6MZ2hAroMhBII3NVwR7/Y88cSdiliNf0=;
        b=UOzeVqGsA+B20+2WylziPhYceD+Fa5TgZ9G32o1hylvofVysKAApk6/1d3F5DCNOhz
         PVVDLLoVgWK3IIm7XthhBy/xZpOiM70ZwfckvlGnryCCfaWLtSlUL83zkGRKfsM/hJ8f
         F+JQZ1HjqT2kO957rUXUNSq85CeWj1tkSeU3Kxt0pbnx1YNbm1e/0KOP5lq7kkjn+e+E
         R0Lx1QHNBTJY88D+Q+5mx4tp9SGxCx4j/OnBY97IEgiksDHR91BpPl6XYkUzJzz8To/s
         S5Egeql+bmQvzn2HqYhI2WcPGriTB/6BuvJuAl/XRwOa+g3zI1gtLVI7Ipl5gQJQooVf
         Xhnw==
X-Gm-Message-State: APjAAAUkl0ek588SLC+ZlkYRwlSgnUkYEadz60Njr80g5LRsAkgMk1vn
        5ssnv76NDhDEitqtnp1l/sh+cQ==
X-Google-Smtp-Source: APXvYqybDtB2Ovw/ENr4nkvummmpv5ttVbYMaxRqCU1q3wmSBePOoBmSZRFDwa9J2xUg1ekUya/ruA==
X-Received: by 2002:a19:8104:: with SMTP id c4mr24228921lfd.191.1574884172084;
        Wed, 27 Nov 2019 11:49:32 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o15sm7741773ljc.28.2019.11.27.11.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 11:49:31 -0800 (PST)
Date:   Wed, 27 Nov 2019 11:49:13 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Michael S . Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
        netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, kvm@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC net-next 00/18] virtio_net XDP offload
Message-ID: <20191127114913.0363a0e8@cakuba.netronome.com>
In-Reply-To: <48cec928-871f-3f50-e99f-c6a6d124cf4c@redhat.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
        <20191126123514.3bdf6d6f@cakuba.netronome.com>
        <48cec928-871f-3f50-e99f-c6a6d124cf4c@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Nov 2019 10:59:37 +0800, Jason Wang wrote:
> On 2019/11/27 =E4=B8=8A=E5=8D=884:35, Jakub Kicinski wrote:
> > On Tue, 26 Nov 2019 19:07:26 +0900, Prashant Bhole wrote: =20
> >> Note: This RFC has been sent to netdev as well as qemu-devel lists
> >>
> >> This series introduces XDP offloading from virtio_net. It is based on
> >> the following work by Jason Wang:
> >> https://netdevconf.info/0x13/session.html?xdp-offload-with-virtio-net
> >>
> >> Current XDP performance in virtio-net is far from what we can achieve
> >> on host. Several major factors cause the difference:
> >> - Cost of virtualization
> >> - Cost of virtio (populating virtqueue and context switching)
> >> - Cost of vhost, it needs more optimization
> >> - Cost of data copy
> >> Because of above reasons there is a need of offloading XDP program to
> >> host. This set is an attempt to implement XDP offload from the guest. =
=20
> > This turns the guest kernel into a uAPI proxy.
> >
> > BPF uAPI calls related to the "offloaded" BPF objects are forwarded
> > to the hypervisor, they pop up in QEMU which makes the requested call
> > to the hypervisor kernel. Today it's the Linux kernel tomorrow it may
> > be someone's proprietary "SmartNIC" implementation.
> >
> > Why can't those calls be forwarded at the higher layer? Why do they
> > have to go through the guest kernel? =20
>=20
>=20
> I think doing forwarding at higher layer have the following issues:
>=20
> - Need a dedicated library (probably libbpf) but application may choose=20
>   to do eBPF syscall directly
> - Depends on guest agent to work

This can be said about any user space functionality.

> - Can't work for virtio-net hardware, since it still requires a hardware=
=20
> interface for carrying=C2=A0 offloading information

The HW virtio-net presumably still has a PF and hopefully reprs for
VFs, so why can't it attach the program there?

> - Implement at the level of kernel may help for future extension like=20
>   BPF object pinning and eBPF helper etc.

No idea what you mean by this.

> Basically, this series is trying to have an implementation of=20
> transporting eBPF through virtio, so it's not necessarily a guest to=20
> host but driver and device. For device, it could be either a virtual one=
=20
> (as done in qemu) or a real hardware.

SmartNIC with a multi-core 64bit ARM CPUs is as much of a host as=20
is the x86 hypervisor side. This set turns the kernel into a uAPI
forwarder.

3 years ago my answer to this proposal would have been very different.
Today after all the CPU bugs it seems like the SmartNICs (which are=20
just another CPU running proprietary code) may just take off..

> > If kernel performs no significant work (or "adds value", pardon the
> > expression), and problem can easily be solved otherwise we shouldn't
> > do the work of maintaining the mechanism. =20
>=20
> My understanding is that it should not be much difference compared to=20
> other offloading technology.

I presume you mean TC offloads? In virtualization there is inherently a
hypervisor which will receive the request, be it an IO hub/SmartNIC or
the traditional hypervisor on the same CPU.

The ACL/routing offloads differ significantly, because it's either the=20
driver that does all the HW register poking directly or the complexity
of programming a rule into a HW table is quite low.

Same is true for the NFP BPF offload, BTW, the driver does all the
heavy lifting and compiles the final machine code image.

You can't say verifying and JITing BPF code into machine code entirely
in the hypervisor is similarly simple.

So no, there is a huge difference.

> > The approach of kernel generating actual machine code which is then
> > loaded into a sandbox on the hypervisor/SmartNIC is another story. =20
>=20
> We've considered such way, but actual machine code is not as portable as=
=20
> eBPF bytecode consider we may want:
>=20
> - Support migration
> - Further offload the program to smart NIC (e.g through macvtap=20
>   passthrough mode etc).

You can re-JIT or JIT for SmartNIC..? Having the BPF bytecode does not
guarantee migration either, if the environment is expected to be
running different version of HW and SW. But yes, JITing in the guest
kernel when you don't know what to JIT for may be hard, I was just
saying that I don't mean to discourage people from implementing
sandboxes which run JITed code on SmartNICs. My criticism is (as
always?) against turning the kernel into a one-to-one uAPI forwarder
into unknown platform code.

For cloud use cases I believe the higher layer should solve this.
