Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B504A367C
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 14:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354808AbiA3NZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 08:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347097AbiA3NY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 08:24:59 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2C1C061714;
        Sun, 30 Jan 2022 05:24:58 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id l5so21364595edv.3;
        Sun, 30 Jan 2022 05:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N1QmzdzCYsHC6SY/Q4WL1ZwoBgiRCfTctmBNhjjzljQ=;
        b=mdYMVtJzc8Z/E0LfINUJPIDY8WrmdB/ulYFHU3gsQNdAkwpsFVtb9qVHFEI0FoTDu1
         DI7MtPtmKoqCW4PPF7Qtv8VLnG44D2nqTJo6fyasXl0sQCPSzwduBkflu0HPTYPf9Rtp
         tkWthv040BT0GEWOgU6UlN0C1tP3iMhVrBGHpjYajtfNeB/ycdlXGC7jXPs/L9qiE1mH
         H0muOOW4wLtlylX5itjdR0mQEfIqPLRJ/23VOJSon2sKRt/OE2fAG9u+GD8ynjD/89zK
         b1o5JoO2/9tuEVMZSlquxZwVauaSpXPkIK5wWUAnE5ySc/QSlU6s/wr099wou/6rJWLx
         Xc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N1QmzdzCYsHC6SY/Q4WL1ZwoBgiRCfTctmBNhjjzljQ=;
        b=1l8lGgRskr2YMgV8owHDhoZevgf/TvDhHCwSplqeGWrcJVRMU0D5U++cSEy6kvHh7F
         8MTehHMIWE2mBVGMKrkqfHKKVl03stcM5384tmHdPX50pgwamOQ1RZLCzEGYxm/Bfkb4
         99xPOIptaCNIPz2B/6TdgvJES6v3wpYfVm6WzA3XBTn3N4krn5Q4U61TLX6ackCAaczP
         28bu1iZCaL9E5ElYiKYf/wwo1xQooc5XqbQ6W3UIYV0Z8YIzdEzG0hpvg1JV9gbnyxWE
         Nz3sU5UGVFM36Q2aQ1NK7ElW2/rOYvbBuR1KKhxbc3QzHuRIF2mOmtV23tNG0HICyDon
         jorg==
X-Gm-Message-State: AOAM532dnVG/dfFn3uTJ6wZuvr8g4kUIMppZdC3ZnAV4X/cLMWKSd/KU
        coTP/YWXsi6HuuhuqBpbx6dtarB8Sr2Fa/B0ebPd1eMsKCdb4g==
X-Google-Smtp-Source: ABdhPJyXUdnxVeWth60dEXH6P1Jjy2c/+HfUHf4xpV4FSiZyAHXYh1wHV2irP0cMCp1sZT6TePlD6hfP6xOuA8lte48=
X-Received: by 2002:aa7:c258:: with SMTP id y24mr16654168edo.288.1643549096917;
 Sun, 30 Jan 2022 05:24:56 -0800 (PST)
MIME-Version: 1.0
References: <159db05f-539c-fe29-608b-91b036588033@molgen.mpg.de>
 <CAABZP2xampOLo8k93OLgaOfv9LreJ+f0g0_1mXwqtrv_LKewQg@mail.gmail.com>
 <3534d781-7d01-b42a-8974-0b1c367946f0@molgen.mpg.de> <CAABZP2zFDY-hrZqE=-c0uW8vFMH+Q9XezYd2DcBX4Wm+sxzK1g@mail.gmail.com>
 <04a597dc-64aa-57e6-f7fb-17bd2ec58159@molgen.mpg.de>
In-Reply-To: <04a597dc-64aa-57e6-f7fb-17bd2ec58159@molgen.mpg.de>
From:   Zhouyi Zhou <zhouzhouyi@gmail.com>
Date:   Sun, 30 Jan 2022 21:24:44 +0800
Message-ID: <CAABZP2yb7-xa4F_2c6tuzkv7x902wU-hqgD_pqRooGC6C7S20A@mail.gmail.com>
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

Dear Paul

On Sun, Jan 30, 2022 at 4:19 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear Zhouyi,
>
>
> Am 30.01.22 um 01:21 schrieb Zhouyi Zhou:
>
> > Thank you for your instructions, I learned a lot from this process.
>
> Same on my end.
>
> > On Sun, Jan 30, 2022 at 12:52 AM Paul Menzel <pmenzel@molgen.mpg.de> wr=
ote:
>
> >> Am 29.01.22 um 03:23 schrieb Zhouyi Zhou:
> >>
> >>> I don't have an IBM machine, but I tried to analyze the problem using
> >>> my x86_64 kvm virtual machine, I can't reproduce the bug using my
> >>> x86_64 kvm virtual machine.
> >>
> >> No idea, if it=E2=80=99s architecture specific.
> >>
> >>> I saw the panic is caused by registration of sit device (A sit device
> >>> is a type of virtual network device that takes our IPv6 traffic,
> >>> encapsulates/decapsulates it in IPv4 packets, and sends/receives it
> >>> over the IPv4 Internet to another host)
> >>>
> >>> sit device is registered in function sit_init_net:
> >>> 1895    static int __net_init sit_init_net(struct net *net)
> >>> 1896    {
> >>> 1897        struct sit_net *sitn =3D net_generic(net, sit_net_id);
> >>> 1898        struct ip_tunnel *t;
> >>> 1899        int err;
> >>> 1900
> >>> 1901        sitn->tunnels[0] =3D sitn->tunnels_wc;
> >>> 1902        sitn->tunnels[1] =3D sitn->tunnels_l;
> >>> 1903        sitn->tunnels[2] =3D sitn->tunnels_r;
> >>> 1904        sitn->tunnels[3] =3D sitn->tunnels_r_l;
> >>> 1905
> >>> 1906        if (!net_has_fallback_tunnels(net))
> >>> 1907            return 0;
> >>> 1908
> >>> 1909        sitn->fb_tunnel_dev =3D alloc_netdev(sizeof(struct ip_tun=
nel), "sit0",
> >>> 1910                           NET_NAME_UNKNOWN,
> >>> 1911                           ipip6_tunnel_setup);
> >>> 1912        if (!sitn->fb_tunnel_dev) {
> >>> 1913            err =3D -ENOMEM;
> >>> 1914            goto err_alloc_dev;
> >>> 1915        }
> >>> 1916        dev_net_set(sitn->fb_tunnel_dev, net);
> >>> 1917        sitn->fb_tunnel_dev->rtnl_link_ops =3D &sit_link_ops;
> >>> 1918        /* FB netdevice is special: we have one, and only one per=
 netns.
> >>> 1919         * Allowing to move it to another netns is clearly unsafe=
.
> >>> 1920         */
> >>> 1921        sitn->fb_tunnel_dev->features |=3D NETIF_F_NETNS_LOCAL;
> >>> 1922
> >>> 1923        err =3D register_netdev(sitn->fb_tunnel_dev);
> >>> register_netdev on line 1923 will call if_nlmsg_size indirectly.
> >>>
> >>> On the other hand, the function that calls the paniced strlen is if_n=
lmsg_size:
> >>> (gdb) disassemble if_nlmsg_size
> >>> Dump of assembler code for function if_nlmsg_size:
> >>>      0xffffffff81a0dc20 <+0>:    nopl   0x0(%rax,%rax,1)
> >>>      0xffffffff81a0dc25 <+5>:    push   %rbp
> >>>      0xffffffff81a0dc26 <+6>:    push   %r15
> >>>      0xffffffff81a0dd04 <+228>:    je     0xffffffff81a0de20 <if_nlms=
g_size+512>
> >>>      0xffffffff81a0dd0a <+234>:    mov    0x10(%rbp),%rdi
> >>>      ...
> >>>    =3D> 0xffffffff81a0dd0e <+238>:    callq  0xffffffff817532d0 <strl=
en>
> >>>      0xffffffff81a0dd13 <+243>:    add    $0x10,%eax
> >>>      0xffffffff81a0dd16 <+246>:    movslq %eax,%r12
> >>
> >> Excuse my ignorance, would that look the same for ppc64le?
> >> Unfortunately, I didn=E2=80=99t save the problematic `vmlinuz` file, b=
ut on a
> >> current build (without rcutorture) I have the line below, where strlen
> >> shows up.
> >>
> >>       (gdb) disassemble if_nlmsg_size
> >>       [=E2=80=A6]
> >>       0xc000000000f7f82c <+332>: bl      0xc000000000a10e30 <strlen>
> >>       [=E2=80=A6]
> >>
> >>> and the C code for 0xffffffff81a0dd0e is following (line 524):
> >>> 515    static size_t rtnl_link_get_size(const struct net_device *dev)
> >>> 516    {
> >>> 517        const struct rtnl_link_ops *ops =3D dev->rtnl_link_ops;
> >>> 518        size_t size;
> >>> 519
> >>> 520        if (!ops)
> >>> 521            return 0;
> >>> 522
> >>> 523        size =3D nla_total_size(sizeof(struct nlattr)) + /* IFLA_L=
INKINFO */
> >>> 524               nla_total_size(strlen(ops->kind) + 1);  /* IFLA_INF=
O_KIND */
> >>
> >> How do I connect the disassemby output with the corresponding line?
> > I use "make  ARCH=3Dpowerpc CC=3Dpowerpc64le-linux-gnu-gcc-9
> > CROSS_COMPILE=3Dpowerpc64le-linux-gnu- -j 16" to cross compile kernel
> > for powerpc64le in my Ubuntu 20.04 x86_64.
> >
> > gdb-multiarch ./vmlinux
> > (gdb)disassemble if_nlmsg_size
> > [...]
> > 0xc00000000191bf40 <+112>:    bl      0xc000000001c28ad0 <strlen>
> > [...]
> > (gdb) break *0xc00000000191bf40
> > Breakpoint 1 at 0xc00000000191bf40: file ./include/net/netlink.h, line =
1112.
> >
> > But in include/net/netlink.h:1112, I can't find the call to strlen
> > 1110static inline int nla_total_size(int payload)
> > 1111{
> > 1112        return NLA_ALIGN(nla_attr_size(payload));
> > 1113}
> > This may be due to the compiler wrongly encode the debug information, I=
 guess.
>
> `rtnl_link_get_size()` contains:
>
>              size =3D nla_total_size(sizeof(struct nlattr)) + /*
> IFLA_LINKINFO */
>                     nla_total_size(strlen(ops->kind) + 1);  /*
> IFLA_INFO_KIND */
>
> Is that inlined(?) and the code at fault?
Yes, that is inlined! because
(gdb) disassemble if_nlmsg_size
Dump of assembler code for function if_nlmsg_size:
[...]
0xc00000000191bf38 <+104>:    beq     0xc00000000191c1f0 <if_nlmsg_size+800=
>
0xc00000000191bf3c <+108>:    ld      r3,16(r31)
0xc00000000191bf40 <+112>:    bl      0xc000000001c28ad0 <strlen>
[...]
(gdb)
(gdb) break *0xc00000000191bf40
Breakpoint 1 at 0xc00000000191bf40: file ./include/net/netlink.h, line 1112=
.
(gdb) break *0xc00000000191bf38
Breakpoint 2 at 0xc00000000191bf38: file net/core/rtnetlink.c, line 520.

>
> >>> But ops is assigned the value of sit_link_ops in function sit_init_ne=
t
> >>> line 1917, so I guess something must happened between the calls.
> >>>
> >>> Do we have KASAN in IBM machine? would KASAN help us find out what
> >>> happened in between?
> >>
> >> Unfortunately, KASAN is not support on Power, I have, as far as I can
> >> see. From `arch/powerpc/Kconfig`:
> >>
> >>           select HAVE_ARCH_KASAN                  if PPC32 && PPC_PAGE=
_SHIFT <=3D 14
> >>           select HAVE_ARCH_KASAN_VMALLOC          if PPC32 && PPC_PAGE=
_SHIFT <=3D 14
> >>
> > en, agree, I invoke "make  menuconfig  ARCH=3Dpowerpc
> > CC=3Dpowerpc64le-linux-gnu-gcc-9 CROSS_COMPILE=3Dpowerpc64le-linux-gnu-=
 -j
> > 16", I can't find KASAN under Memory Debugging, I guess we should find
> > the bug by bisecting instead.
>
> I do not know, if it is a regression, as it was the first time I tried
> to run a Linux kernel built with rcutorture on real hardware.
I tried to add some debug statements to the kernel to locate the bug
more accurately,  you can try it when you're not busy in the future,
or just ignore it if the following patch looks not very effective ;-)
diff --git a/net/core/dev.c b/net/core/dev.c
index 1baab07820f6..969ac7c540cc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9707,6 +9707,9 @@ int register_netdevice(struct net_device *dev)
      *    Prevent userspace races by waiting until the network
      *    device is fully setup before sending notifications.
      */
+    if (dev->rtnl_link_ops)
+        printk(KERN_INFO "%lx IFLA_INFO_KIND %s %s\n", dev->rtnl_link_ops,
+               dev->rtnl_link_ops->kind, __FUNCTION__);
     if (!dev->rtnl_link_ops ||
         dev->rtnl_link_state =3D=3D RTNL_LINK_INITIALIZED)
         rtmsg_ifinfo(RTM_NEWLINK, dev, ~0U, GFP_KERNEL);
@@ -9788,6 +9791,9 @@ int register_netdev(struct net_device *dev)

     if (rtnl_lock_killable())
         return -EINTR;
+    if (dev->rtnl_link_ops)
+        printk(KERN_INFO "%lx IFLA_INFO_KIND %s %s\n", dev->rtnl_link_ops,
+               dev->rtnl_link_ops->kind, __FUNCTION__);
     err =3D register_netdevice(dev);
     rtnl_unlock();
     return err;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index e476403231f0..e08986ae6238 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -520,6 +520,8 @@ static size_t rtnl_link_get_size(const struct
net_device *dev)
     if (!ops)
         return 0;

+    printk(KERN_INFO "%lx IFLA_INFO_KIND %s %s\n", ops,
+           ops->kind, __FUNCTION__);
     size =3D nla_total_size(sizeof(struct nlattr)) + /* IFLA_LINKINFO */
            nla_total_size(strlen(ops->kind) + 1);  /* IFLA_INFO_KIND */

@@ -1006,6 +1008,9 @@ static size_t rtnl_proto_down_size(const struct
net_device *dev)
 static noinline size_t if_nlmsg_size(const struct net_device *dev,
                      u32 ext_filter_mask)
 {
+    if (dev->rtnl_link_ops)
+        printk(KERN_INFO "%lx IFLA_INFO_KIND  %s %s\n", dev->rtnl_link_ops=
,
+               dev->rtnl_link_ops->kind, __FUNCTION__);
     return NLMSG_ALIGN(sizeof(struct ifinfomsg))
            + nla_total_size(IFNAMSIZ) /* IFLA_IFNAME */
            + nla_total_size(IFALIASZ) /* IFLA_IFALIAS */
@@ -3825,7 +3830,9 @@ struct sk_buff *rtmsg_ifinfo_build_skb(int type,
struct net_device *dev,
     struct net *net =3D dev_net(dev);
     struct sk_buff *skb;
     int err =3D -ENOBUFS;
-
+    if (dev->rtnl_link_ops)
+        printk(KERN_INFO "%lx IFLA_INFO_KIND %s %s\n", dev->rtnl_link_ops,
+               dev->rtnl_link_ops->kind, __FUNCTION__);
     skb =3D nlmsg_new(if_nlmsg_size(dev, 0), flags);
     if (skb =3D=3D NULL)
         goto errout;
@@ -3861,7 +3868,9 @@ static void rtmsg_ifinfo_event(int type, struct
net_device *dev,

     if (dev->reg_state !=3D NETREG_REGISTERED)
         return;
-
+    if (dev->rtnl_link_ops)
+        printk(KERN_INFO "%lx IFLA_INFO_KIND  %s %s\n", dev->rtnl_link_ops=
,
+               dev->rtnl_link_ops->kind, __FUNCTION__);
     skb =3D rtmsg_ifinfo_build_skb(type, dev, change, event, flags, new_ns=
id,
                      new_ifindex);
     if (skb)
@@ -3871,6 +3880,9 @@ static void rtmsg_ifinfo_event(int type, struct
net_device *dev,
 void rtmsg_ifinfo(int type, struct net_device *dev, unsigned int change,
           gfp_t flags)
 {
+    if (dev->rtnl_link_ops)
+        printk(KERN_INFO "%lx IFLA_INFO_KIND  %s %s\n", dev->rtnl_link_ops=
,
+               dev->rtnl_link_ops->kind, __FUNCTION__);
     rtmsg_ifinfo_event(type, dev, change, rtnl_get_event(0), flags,
                NULL, 0);
 }
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index c0b138c20992..fa5b2725811c 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1919,6 +1919,8 @@ static int __net_init sit_init_net(struct net *net)
      * Allowing to move it to another netns is clearly unsafe.
      */
     sitn->fb_tunnel_dev->features |=3D NETIF_F_NETNS_LOCAL;
-
+    printk(KERN_INFO "%lx IFLA_INFO_KIND %s %s\n",
+           sitn->fb_tunnel_dev->rtnl_link_ops,
+           sitn->fb_tunnel_dev->rtnl_link_ops->kind, __FUNCTION__);
     err =3D register_netdev(sitn->fb_tunnel_dev);
     if (err)
         goto err_reg_dev;
>
> >>> Hope I can be of more helpful.
> >>
> >> Some distributions support multi-arch, so they easily allow
> >> crosscompiling for different architectures.
> > I use "make  ARCH=3Dpowerpc CC=3Dpowerpc64le-linux-gnu-gcc-9
> > CROSS_COMPILE=3Dpowerpc64le-linux-gnu- -j 16" to cross compile kernel
> > for powerpc64le in my Ubuntu 20.04 x86_64. But I can't boot the
> > compiled kernel using "qemu-system-ppc64le -M pseries -nographic -smp
> > 4 -net none -m 4G -kernel arch/powerpc/boot/zImage". I will continue
> > to explore it.
>
> Oh, that does not sound good. But I have not tried that in a long time
> either. It=E2=80=99s a separate issue, but maybe some of the PPC
> maintainers/folks could help.
I will do further research on this later.

Thanks for your time
Kind regards
Zhouyi
>
>
> Kind regards,
>
> Paul
