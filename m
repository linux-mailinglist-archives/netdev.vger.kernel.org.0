Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F1D4A32C9
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 01:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353541AbiA3AV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 19:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353529AbiA3AVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 19:21:55 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0405AC061714;
        Sat, 29 Jan 2022 16:21:55 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id jx6so30238072ejb.0;
        Sat, 29 Jan 2022 16:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZQaIehgXeuA4euu7fUr1NZwAZWdGjLXP2W1GG/EJe78=;
        b=lne+hv2bkrsEsd3f5N9TuK4uAc8P372g1pkCINu+zXKJfNiXkaip9GXZ8uzwcHHjBT
         Zkn5P7wBIsM3F/HZtnPRQK1g6xNGYTJdtKv/tTLNWOwDPqjlEaefww3J7PUpkpykYnFI
         98R6s/EmHmZpXkY5ZtuGzlZ5rYRAFIYH+uu1Adata79LKNXsoJubQpNk8kk9Z2aL2308
         0HGStXwpBugSl2btb1KNadBxO4Juu7yxkByDPrXrT6ZuAKlmuz/fe28leMfBZjUO6cqd
         YkL4+7kSxHfXT2H9qvap4oNBh50ls4z+rE6iHPC0cMCBfv23h6Eh8rr0kawg1SEIN6XF
         oeLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZQaIehgXeuA4euu7fUr1NZwAZWdGjLXP2W1GG/EJe78=;
        b=Wdmyl6GpwmFBGzogVvBY2yWqpqLVDtoO/Ukc51RKZGIAcU2qT2QXsTCPr/lCk0vCkQ
         gWj8Ybp6w2ZZkHMXXZEqpcKiBYDjO28EP5OmQ91TtpGRT/OBCHM+itTpL+LBBqPnlP5I
         nxZBmUgn6kf5zxb7FiDnQ2jVjHDDLfzWoewS2w29uL01IpweBD4S9nBh6Q4e5y/UNVDV
         0nBViQY2JmWsyDt/YthmS2I+eR9d/6riPkt2ccQGDaYKkvmJbXnFTJ70EkdXxFxgSo0I
         oepRAji9au1BZu+sX0eeGUBg9T9n2FxNGINEEIBVuPsR6VJRdkpQzIgVA6MTYIBhFOph
         lAsg==
X-Gm-Message-State: AOAM532N9io5vcVm6i8RzKhiyjmzzvtVVrJ1iOaM7uhQ1mZxnrAFazR6
        6vVviy4qs0+5sx+YYmNJrXfAB0LkFNVHIuSWPJA=
X-Google-Smtp-Source: ABdhPJwDojIzwvYYox5AhJniOifzj8etz2yBw2OL6AHjEfHm6QCO8eEogKCw6AjcCgRZQLdWNiHAAT/2mntSq2TarMY=
X-Received: by 2002:a17:907:3f9d:: with SMTP id hr29mr11926680ejc.614.1643502113431;
 Sat, 29 Jan 2022 16:21:53 -0800 (PST)
MIME-Version: 1.0
References: <159db05f-539c-fe29-608b-91b036588033@molgen.mpg.de>
 <CAABZP2xampOLo8k93OLgaOfv9LreJ+f0g0_1mXwqtrv_LKewQg@mail.gmail.com> <3534d781-7d01-b42a-8974-0b1c367946f0@molgen.mpg.de>
In-Reply-To: <3534d781-7d01-b42a-8974-0b1c367946f0@molgen.mpg.de>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Sun, 30 Jan 2022 08:21:41 +0800
Message-ID: <CAABZP2zFDY-hrZqE=-c0uW8vFMH+Q9XezYd2DcBX4Wm+sxzK1g@mail.gmail.com>
Subject: Re: BUG: Kernel NULL pointer dereference on write at 0x00000000 (rtmsg_ifinfo_build_skb)
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        rcu <rcu@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Paul,

Thank you for your instructions, I learned a lot from this process.

On Sun, Jan 30, 2022 at 12:52 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Zhouyi,
>
>
> Thank you for taking the time.
>
>
> Am 29.01.22 um 03:23 schrieb Zhouyi Zhou:
>
> > I don't have an IBM machine, but I tried to analyze the problem using
> > my x86_64 kvm virtual machine, I can't reproduce the bug using my
> > x86_64 kvm virtual machine.
>
> No idea, if it=E2=80=99s architecture specific.
>
> > I saw the panic is caused by registration of sit device (A sit device
> > is a type of virtual network device that takes our IPv6 traffic,
> > encapsulates/decapsulates it in IPv4 packets, and sends/receives it
> > over the IPv4 Internet to another host)
> >
> > sit device is registered in function sit_init_net:
> > 1895    static int __net_init sit_init_net(struct net *net)
> > 1896    {
> > 1897        struct sit_net *sitn =3D net_generic(net, sit_net_id);
> > 1898        struct ip_tunnel *t;
> > 1899        int err;
> > 1900
> > 1901        sitn->tunnels[0] =3D sitn->tunnels_wc;
> > 1902        sitn->tunnels[1] =3D sitn->tunnels_l;
> > 1903        sitn->tunnels[2] =3D sitn->tunnels_r;
> > 1904        sitn->tunnels[3] =3D sitn->tunnels_r_l;
> > 1905
> > 1906        if (!net_has_fallback_tunnels(net))
> > 1907            return 0;
> > 1908
> > 1909        sitn->fb_tunnel_dev =3D alloc_netdev(sizeof(struct ip_tunne=
l), "sit0",
> > 1910                           NET_NAME_UNKNOWN,
> > 1911                           ipip6_tunnel_setup);
> > 1912        if (!sitn->fb_tunnel_dev) {
> > 1913            err =3D -ENOMEM;
> > 1914            goto err_alloc_dev;
> > 1915        }
> > 1916        dev_net_set(sitn->fb_tunnel_dev, net);
> > 1917        sitn->fb_tunnel_dev->rtnl_link_ops =3D &sit_link_ops;
> > 1918        /* FB netdevice is special: we have one, and only one per n=
etns.
> > 1919         * Allowing to move it to another netns is clearly unsafe.
> > 1920         */
> > 1921        sitn->fb_tunnel_dev->features |=3D NETIF_F_NETNS_LOCAL;
> > 1922
> > 1923        err =3D register_netdev(sitn->fb_tunnel_dev);
> > register_netdev on line 1923 will call if_nlmsg_size indirectly.
> >
> > On the other hand, the function that calls the paniced strlen is if_nlm=
sg_size:
> > (gdb) disassemble if_nlmsg_size
> > Dump of assembler code for function if_nlmsg_size:
> >     0xffffffff81a0dc20 <+0>:    nopl   0x0(%rax,%rax,1)
> >     0xffffffff81a0dc25 <+5>:    push   %rbp
> >     0xffffffff81a0dc26 <+6>:    push   %r15
> >     0xffffffff81a0dd04 <+228>:    je     0xffffffff81a0de20 <if_nlmsg_s=
ize+512>
> >     0xffffffff81a0dd0a <+234>:    mov    0x10(%rbp),%rdi
> >     ...
> >   =3D> 0xffffffff81a0dd0e <+238>:    callq  0xffffffff817532d0 <strlen>
> >     0xffffffff81a0dd13 <+243>:    add    $0x10,%eax
> >     0xffffffff81a0dd16 <+246>:    movslq %eax,%r12
>
> Excuse my ignorance, would that look the same for ppc64le?
> Unfortunately, I didn=E2=80=99t save the problematic `vmlinuz` file, but =
on a
> current build (without rcutorture) I have the line below, where strlen
> shows up.
>
>      (gdb) disassemble if_nlmsg_size
>      [=E2=80=A6]
>      0xc000000000f7f82c <+332>: bl      0xc000000000a10e30 <strlen>
>      [=E2=80=A6]
>
> > and the C code for 0xffffffff81a0dd0e is following (line 524):
> > 515    static size_t rtnl_link_get_size(const struct net_device *dev)
> > 516    {
> > 517        const struct rtnl_link_ops *ops =3D dev->rtnl_link_ops;
> > 518        size_t size;
> > 519
> > 520        if (!ops)
> > 521            return 0;
> > 522
> > 523        size =3D nla_total_size(sizeof(struct nlattr)) + /* IFLA_LIN=
KINFO */
> > 524               nla_total_size(strlen(ops->kind) + 1);  /* IFLA_INFO_=
KIND */
>
> How do I connect the disassemby output with the corresponding line?
I use "make  ARCH=3Dpowerpc CC=3Dpowerpc64le-linux-gnu-gcc-9
CROSS_COMPILE=3Dpowerpc64le-linux-gnu- -j 16" to cross compile kernel
for powerpc64le in my Ubuntu 20.04 x86_64.

gdb-multiarch ./vmlinux
(gdb)disassemble if_nlmsg_size
[...]
0xc00000000191bf40 <+112>:    bl      0xc000000001c28ad0 <strlen>
[...]
(gdb) break *0xc00000000191bf40
Breakpoint 1 at 0xc00000000191bf40: file ./include/net/netlink.h, line 1112=
.

But in include/net/netlink.h:1112, I can't find the call to strlen
1110static inline int nla_total_size(int payload)
1111{
1112        return NLA_ALIGN(nla_attr_size(payload));
1113}
This may be due to the compiler wrongly encode the debug information, I gue=
ss.

>
> > But ops is assigned the value of sit_link_ops in function sit_init_net
> > line 1917, so I guess something must happened between the calls.
> >
> > Do we have KASAN in IBM machine? would KASAN help us find out what
> > happened in between?
>
> Unfortunately, KASAN is not support on Power, I have, as far as I can
> see. From `arch/powerpc/Kconfig`:
>
>          select HAVE_ARCH_KASAN                  if PPC32 &&
> PPC_PAGE_SHIFT <=3D 14
>          select HAVE_ARCH_KASAN_VMALLOC          if PPC32 &&
> PPC_PAGE_SHIFT <=3D 14
>
en, agree, I invoke "make  menuconfig  ARCH=3Dpowerpc
CC=3Dpowerpc64le-linux-gnu-gcc-9 CROSS_COMPILE=3Dpowerpc64le-linux-gnu- -j
16", I can't find KASAN under Memory Debugging, I guess we should find
the bug by bisecting instead.

> > Hope I can be of more helpful.
>
> Some distributions support multi-arch, so they easily allow
> crosscompiling for different architectures.
I use "make  ARCH=3Dpowerpc CC=3Dpowerpc64le-linux-gnu-gcc-9
CROSS_COMPILE=3Dpowerpc64le-linux-gnu- -j 16" to cross compile kernel
for powerpc64le in my Ubuntu 20.04 x86_64. But I can't boot the
compiled kernel using "qemu-system-ppc64le -M pseries -nographic -smp
4 -net none -m 4G -kernel arch/powerpc/boot/zImage". I will continue
to explore it.

Kind regards
Zhouyi

>
>
> Kind regards,
>
> Paul
