Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC0B35BA2D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 08:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhDLGiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 02:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhDLGiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 02:38:04 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6C5C061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 23:37:47 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 65so13877309ybc.4
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 23:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CM9/kfDJ5rMkfIhxkekRCqlKwW2DUk613Pkp4exRtSQ=;
        b=St6rdNRIwLhOYiH4zRNURADBsU5tl++51Ubk3yRyqfAOD92UQI5G2lBjg63MR+E5gl
         v4+EbPaCefpXMvCc7MwJyf/Qxbmd9ZO0q0F0pwu0fbyN0TeJZ99HPEtJ+X1MsWTZ6YR3
         AEf94FRiFMiyN/dl3BOhTHcUxP/7PWOZuTpwhUsibBl7A11qJeGbt2JsBAq50tTj2XFc
         NGKYJ2qGViVbHjMMNWD4ePVAL31i37DG8EIpTUQSfnpH/aRRc3tojCysDj8x/02fSVa8
         U1xBs4MZ3M7NadMjB9uQcoANjjnUXcezMXZjrOygwOzA2d4qdAARjCoqhHwDtd6uAlnf
         3Paw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CM9/kfDJ5rMkfIhxkekRCqlKwW2DUk613Pkp4exRtSQ=;
        b=iPDDIc2Ex68Jqnh4muzNoNSI70a3+KJnf3OZfrztSh31XMR8zQumOHWHoctsoV0zSG
         y+r1aby47PTi73i9p/SFpEgOKCKnB5atTkc1jNC2623tHx5D58yN6n8xp99xyNGOhGMK
         evowULG2OAV+7eLobNJIJUFDYOrRKCOrNlrWQDjoTiNMmdNYrbM4cRX/QAkIfOFcDbXU
         Sg9NmaQ8Bdkw7VBxwJUP7YlpGF//mVO2/pcxTR/7+IC3ux2AVnmA1zhJkbs7KgjE3/Ph
         odqfwY831q+hdpud8RDKMPblaQGgWFlkENnlz3M5cbA5f7jwE9GjT2yI+Wy+zoYFg5+M
         GGLA==
X-Gm-Message-State: AOAM533X4xdZfkYINTQWcx9LoifTU1MKDgwQDaaohjTuUBdb7zQhY1ls
        wJ06hiaIYd9RY5ikuHhS5qSdb2CaYNeI+UdW0qZ2XISBd7g=
X-Google-Smtp-Source: ABdhPJzviep7xXJgwmI/ncyoHL/0BCwNVqQB4P2RnZdBpif9BJ1t8SEPzUw2kYL71b53aGTSFqGnWC/CYhlYPNaWZdU=
X-Received: by 2002:a25:4244:: with SMTP id p65mr6922857yba.452.1618209465671;
 Sun, 11 Apr 2021 23:37:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210402132602.3659282-1-eric.dumazet@gmail.com>
 <20210411134329.GA132317@roeck-us.net> <CANn89iJ+RjYPY11zUtvmMkOp1E2DKLuAk2q0LHUbcJpbcZVSjw@mail.gmail.com>
 <0f63dc52-ea72-16b6-7dcd-efb24de0c852@roeck-us.net> <CANn89iJa8KAnfWvUB8Jr8hsG5x_Amg90DbpoAHiuNZigv75MEA@mail.gmail.com>
 <c1d15bd0-8b62-f7c0-0f2e-1d527827f451@roeck-us.net> <CANn89iK-AO4MpWQzh_VkMjUgdcsP4ibaV4RhsDF9RHcuC+_=-g@mail.gmail.com>
 <ad232021-d30a-da25-c1d5-0bd79628b5e1@roeck-us.net> <CANn89iLZyvjE-wUxfJ1FtAqZdD3OroObBdR9-bXR=GGb1ZASOw@mail.gmail.com>
 <CANn89i+g2uiYNUCvXH4YKQqPeSw+Ad4n6_=r3DBZTdHS8hBkMQ@mail.gmail.com> <20210412062329.GA50510@roeck-us.net>
In-Reply-To: <20210412062329.GA50510@roeck-us.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 12 Apr 2021 08:37:33 +0200
Message-ID: <CANn89iJO4C2HeQUPsVd_X4C3pU6HPPCU-hLMSOY+Nzu3r03zkQ@mail.gmail.com>
Subject: Re: [PATCH net] virtio_net: Do not pull payload in skb->head
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 8:23 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Hi Eric,
>
> On Mon, Apr 12, 2021 at 07:53:43AM +0200, Eric Dumazet wrote:
> > On Mon, Apr 12, 2021 at 7:48 AM Eric Dumazet <edumazet@google.com> wrot=
e:
> > >
> >
> > > give a verdict.
> > >
> > > Please post the whole strace output.
> > >
> > > Thanks.
> >
> > Also please add -tt option to strace so that we have an idea of time
> > delays just in case.
> >
>
> The exact command as executed is:
>
> strace -tt -o /tmp/STRACE -f -s 1000 udhcpc -n -q
>
> Log is below. This is the complete log: nothing was truncated, neither
> at the beginning nor at the end. The log ends with sendto().
>
> Hope this helps,
>
> Guenter
>
> ---
> 148   00:01:14.802467 execve("/sbin/udhcpc", ["udhcpc", "-n", "-q"], 0x7b=
bbbe10 /* 11 vars */) =3D 0
> 148   00:01:14.804496 set_tid_address(0x295faf94) =3D 148
> 148   00:01:14.805081 brk(NULL)         =3D 0x4c0000
> 148   00:01:14.805495 brk(0x4c2000)     =3D 0x4c2000
> 148   00:01:14.805998 mmap2(0x4c0000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FI=
XED|MAP_ANONYMOUS, -1, 0) =3D 0x4c0000
> 148   00:01:14.806750 mprotect(0x295f8000, 4096, PROT_READ) =3D 0
> 148   00:01:14.807524 mprotect(0x4be000, 4096, PROT_READ) =3D 0
> 148   00:01:14.808169 getuid32()        =3D 0
> 148   00:01:14.808670 open("/dev/null", O_RDWR|O_LARGEFILE) =3D 3
> 148   00:01:14.809415 close(3)          =3D 0
> 148   00:01:14.809886 pipe([3, 0])      =3D 3
> 148   00:01:14.810373 fcntl64(3, F_SETFD, FD_CLOEXEC) =3D 0
> 148   00:01:14.810827 fcntl64(4, F_SETFD, FD_CLOEXEC) =3D 0
> 148   00:01:14.811274 fcntl64(3, F_GETFL) =3D 0 (flags O_RDONLY)
> 148   00:01:14.811703 fcntl64(3, F_SETFL, O_RDONLY|O_NONBLOCK|O_LARGEFILE=
) =3D 0
> 148   00:01:14.812156 fcntl64(4, F_GETFL) =3D 0x1 (flags O_WRONLY)
> 148   00:01:14.812602 fcntl64(4, F_SETFL, O_WRONLY|O_NONBLOCK|O_LARGEFILE=
) =3D 0
> 148   00:01:14.813088 rt_sigprocmask(SIG_UNBLOCK, [RT_1 RT_2], NULL, 8) =
=3D 0
> 148   00:01:14.813648 rt_sigaction(SIGUSR1, {sa_handler=3D0x4328b0, sa_ma=
sk=3D[], sa_flags=3DSA_RESTORER|SA_RESTART, sa_restorer=3D0x295b6a2a}, {sa_=
handler=3DSIG_DFL, sa_mask=3D[], sa_flags=3D0}, 8) =3D 0
> 148   00:01:14.814381 rt_sigaction(SIGUSR2, {sa_handler=3D0x4328b0, sa_ma=
sk=3D[], sa_flags=3DSA_RESTORER|SA_RESTART, sa_restorer=3D0x295b6a2a}, {sa_=
handler=3DSIG_DFL, sa_mask=3D[], sa_flags=3D0}, 8) =3D 0
> 148   00:01:14.815106 rt_sigaction(SIGTERM, {sa_handler=3D0x4328b0, sa_ma=
sk=3D[], sa_flags=3DSA_RESTORER|SA_RESTART, sa_restorer=3D0x295b6a2a}, {sa_=
handler=3DSIG_DFL, sa_mask=3D[], sa_flags=3D0}, 8) =3D 0
> 148   00:01:14.815910 socket(AF_INET, SOCK_RAW, IPPROTO_RAW) =3D 5
> 148   00:01:14.816484 ioctl(5, SIOCGIFINDEX, {ifr_name=3D"eth0", }) =3D 0
> 148   00:01:14.817111 ioctl(5, SIOCGIFHWADDR, {ifr_name=3D"eth0", ifr_hwa=
ddr=3D{sa_family=3DARPHRD_ETHER, sa_data=3D52:54:00:12:34:56}}) =3D 0
> 148   00:01:14.818042 close(5)          =3D 0
> 148   00:01:14.818660 write(2, "udhcpc: started, v1.33.0\n", 25) =3D 25
> 148   00:01:14.819387 clock_gettime64(CLOCK_MONOTONIC, {tv_sec=3D74, tv_n=
sec=3D819590988}) =3D 0
> 148   00:01:14.820117 vfork( <unfinished ...>
> 149   00:01:14.820652 execve("/usr/share/udhcpc/default.script", ["/usr/s=
hare/udhcpc/default.script", "deconfig"], 0x295fbfb0 /* 12 vars */ <unfinis=
hed ...>
> 148   00:01:14.821800 <... vfork resumed>) =3D 149
> 148   00:01:14.822606 wait4(149,  <unfinished ...>
> 149   00:01:14.823007 <... execve resumed>) =3D 0
> 149   00:01:14.823559 set_tid_address(0x295faf94) =3D 149
> 149   00:01:14.824135 brk(NULL)         =3D 0x4c0000
> 149   00:01:14.824568 brk(0x4c2000)     =3D 0x4c2000
> 149   00:01:14.824983 mmap2(0x4c0000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FI=
XED|MAP_ANONYMOUS, -1, 0) =3D 0x4c0000
> 149   00:01:14.825728 mprotect(0x295f8000, 4096, PROT_READ) =3D 0
> 149   00:01:14.826526 mprotect(0x4be000, 4096, PROT_READ) =3D 0
> 149   00:01:14.827180 getuid32()        =3D 0
> 149   00:01:14.827748 getpid()          =3D 149
> 149   00:01:14.828221 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE=
|MAP_ANONYMOUS, -1, 0) =3D 0x295ea000
> 149   00:01:14.828963 rt_sigprocmask(SIG_UNBLOCK, [RT_1 RT_2], NULL, 8) =
=3D 0
> 149   00:01:14.829549 rt_sigaction(SIGCHLD, {sa_handler=3D0x4379f4, sa_ma=
sk=3D~[RTMIN RT_1 RT_2], sa_flags=3DSA_RESTORER, sa_restorer=3D0x295b6a2a},=
 NULL, 8) =3D 0
> 149   00:01:14.830347 getppid()         =3D 148
> 149   00:01:14.830837 uname({sysname=3D"Linux", nodename=3D"buildroot", .=
..}) =3D 0
> 149   00:01:14.831484 statx(AT_FDCWD, "/tmp", AT_STATX_SYNC_AS_STAT, STAT=
X_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=
=3DSTATX_ATTR_MOUNT_ROOT, stx_mode=3DS_IFDIR|S_ISVTX|0777, stx_size=3D140, =
...}) =3D 0
> 149   00:01:14.832588 statx(AT_FDCWD, ".", AT_STATX_SYNC_AS_STAT, STATX_B=
ASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=3DST=
ATX_ATTR_MOUNT_ROOT, stx_mode=3DS_IFDIR|S_ISVTX|0777, stx_size=3D140, ...})=
 =3D 0
> 149   00:01:14.833685 open("/usr/share/udhcpc/default.script", O_RDONLY|O=
_LARGEFILE|O_CLOEXEC) =3D 3
> 149   00:01:14.834370 fcntl64(3, F_SETFD, FD_CLOEXEC) =3D 0
> 149   00:01:14.834866 fcntl64(3, F_DUPFD_CLOEXEC, 10) =3D 10
> 149   00:01:14.835292 fcntl64(10, F_SETFD, FD_CLOEXEC) =3D 0
> 149   00:01:14.835741 close(3)          =3D 0
> 149   00:01:14.836188 rt_sigaction(SIGINT, NULL, {sa_handler=3DSIG_DFL, s=
a_mask=3D[], sa_flags=3D0}, 8) =3D 0
> 149   00:01:14.836753 rt_sigaction(SIGINT, {sa_handler=3D0x4379f4, sa_mas=
k=3D~[RTMIN RT_1 RT_2], sa_flags=3DSA_RESTORER, sa_restorer=3D0x295b6a2a}, =
NULL, 8) =3D 0
> 149   00:01:14.837374 rt_sigaction(SIGQUIT, NULL, {sa_handler=3DSIG_DFL, =
sa_mask=3D[], sa_flags=3D0}, 8) =3D 0
> 149   00:01:14.837985 rt_sigaction(SIGQUIT, {sa_handler=3DSIG_IGN, sa_mas=
k=3D~[RTMIN RT_1 RT_2], sa_flags=3DSA_RESTORER, sa_restorer=3D0x295b6a2a}, =
NULL, 8) =3D 0
> 149   00:01:14.838602 rt_sigaction(SIGTERM, NULL, {sa_handler=3DSIG_DFL, =
sa_mask=3D[], sa_flags=3D0}, 8) =3D 0
> 149   00:01:14.839200 read(10, "#!/bin/sh\n\n# udhcpc script edited by Ti=
m Riker <Tim@Rikers.org>\n\n[ -z \"$1\" ] && echo \"Error: should be called=
 from udhcpc\" && exit 1\n\nRESOLV_CONF=3D\"/etc/resolv.conf\"\n[ -e $RESOL=
V_CONF ] || touch $RESOLV_CONF\n[ -n \"$broadcast\" ] && BROADCAST=3D\"broa=
dcast $broadcast\"\n[ -n \"$subnet\" ] && NETMASK=3D\"netmask $subnet\"\n# =
Handle stateful DHCPv6 like DHCPv4\n[ -n \"$ipv6\" ] && ip=3D\"$ipv6/128\"\=
n\nif [ -z \"${IF_WAIT_DELAY}\" ]; then\n\tIF_WAIT_DELAY=3D10\nfi\n\nwait_f=
or_ipv6_default_route() {\n\tprintf \"Waiting for IPv6 default route to app=
ear\"\n\twhile [ $IF_WAIT_DELAY -gt 0 ]; do\n\t\tif ip -6 route list | grep=
 -q default; then\n\t\t\tprintf \"\\n\"\n\t\t\treturn\n\t\tfi\n\t\tsleep 1\=
n\t\tprintf \".\"\n\t\t: $((IF_WAIT_DELAY -=3D 1))\n\tdone\n\tprintf \" tim=
eout!\\n\"\n}\n\ncase \"$1\" in\n\tdeconfig)\n\t\t/sbin/ifconfig $interface=
 up\n\t\t/sbin/ifconfig $interface 0.0.0.0\n\n\t\t# drop info from this int=
erface\n\t\t# resolv.conf may be a symlink to /tmp/, so take care\n\t\tTMPF=
ILE=3D$(mktemp)\n\t\tgrep -vE \"# $interface\\$\" $RESOLV_CONF > $TMPFILE\n=
\t\tcat $TMPFILE > $RESOLV_CONF\n\t\t"..., 1023) =3D 1023
> 149   00:01:14.840495 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE=
|MAP_ANONYMOUS, -1, 0) =3D 0x295eb000
> 149   00:01:14.841488 statx(AT_FDCWD, "/etc/resolv.conf", AT_STATX_SYNC_A=
S_STAT, STATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_=
attributes=3D0, stx_mode=3DS_IFREG|0644, stx_size=3D27, ...}) =3D 0
> 149   00:01:14.845240 read(10, "-x /usr/sbin/avahi-autoipd ]; then\n\t\t\=
t/usr/sbin/avahi-autoipd -c $interface && /usr/sbin/avahi-autoipd -k $inter=
face\n\t\tfi\n\t\t;;\n\n\tleasefail|nak)\n\t\tif [ -x /usr/sbin/avahi-autoi=
pd ]; then\n\t\t\t/usr/sbin/avahi-autoipd -c $interface || /usr/sbin/avahi-=
autoipd -wD $interface --no-chroot\n\t\tfi\n\t\t;;\n\n\trenew|bound)\n\t\ti=
f [ -x /usr/sbin/avahi-autoipd ]; then\n\t\t\t/usr/sbin/avahi-autoipd -c $i=
nterface && /usr/sbin/avahi-autoipd -k $interface\n\t\tfi\n\t\t/sbin/ifconf=
ig $interface $ip $BROADCAST $NETMASK\n\t\tif [ -n \"$ipv6\" ] ; then\n\t\t=
\twait_for_ipv6_default_route\n\t\tfi\n\n\t\t# RFC3442: If the DHCP server =
returns both a Classless\n\t\t# Static Routes option and a Router option, t=
he DHCP\n\t\t# client MUST ignore the Router option.\n\t\tif [ -n \"$static=
routes\" ]; then\n\t\t\techo \"deleting routers\"\n\t\t\troute -n | while r=
ead dest gw mask flags metric ref use iface; do\n\t\t\t\t[ \"$iface\" !=3D =
\"$interface\" -o \"$gw\" =3D \"0.0.0.0\" ] || \\\n\t\t\t\t\troute del -net=
 \"$dest\" netmask \"$mask\" gw \"$gw\" dev \"$interface\"\n\t\t\tdone\n\n\=
t\t\t# format: dest1/mask gw1"..., 1023) =3D 1023
> 149   00:01:14.847204 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE=
|MAP_ANONYMOUS, -1, 0) =3D 0x295ec000
> 149   00:01:14.848965 read(10, "set -- $staticroutes\n\t\t\twhile [ -n \"=
$1\" -a -n \"$2\" ]; do\n\t\t\t\troute add -net \"$1\" gw \"$2\" dev \"$int=
erface\"\n\t\t\t\tshift 2\n\t\t\tdone\n\t\telif [ -n \"$router\" ] ; then\n=
\t\t\techo \"deleting routers\"\n\t\t\twhile route del default gw 0.0.0.0 d=
ev $interface 2> /dev/null; do\n\t\t\t\t:\n\t\t\tdone\n\n\t\t\tfor i in $ro=
uter ; do\n\t\t\t\troute add default gw $i dev $interface\n\t\t\tdone\n\t\t=
fi\n\n\t\t# drop info from this interface\n\t\t# resolv.conf may be a symli=
nk to /tmp/, so take care\n\t\tTMPFILE=3D$(mktemp)\n\t\tgrep -vE \"# $inter=
face\\$\" $RESOLV_CONF > $TMPFILE\n\t\tcat $TMPFILE > $RESOLV_CONF\n\t\trm =
-f $TMPFILE\n\n\t\t# prefer rfc3397 domain search list (option 119) if avai=
lable\n\t\tif [ -n \"$search\" ]; then\n\t\t\tsearch_list=3D$search\n\t\tel=
if [ -n \"$domain\" ]; then\n\t\t\tsearch_list=3D$domain\n\t\tfi\n\n\t\t[ -=
n \"$search_list\" ] &&\n\t\t\techo \"search $search_list # $interface\" >>=
 $RESOLV_CONF\n\n\t\tfor i in $dns ; do\n\t\t\techo adding dns $i\n\t\t\tec=
ho \"nameserver $i # $interface\" >> $RESOLV_CONF\n\t\tdone\n\t\t;;\nesac\n=
\nHOOK_DIR=3D\"$0.d\"\nfor hook in \"${HOOK_DIR}/\"*; do\n    [ -f \"${hook=
"..., 1023) =3D 1023
> 149   00:01:14.850631 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE=
|MAP_ANONYMOUS, -1, 0) =3D 0x295ed000
> 149   00:01:14.852772 rt_sigprocmask(SIG_BLOCK, ~[RTMIN RT_1 RT_2], [], 8=
) =3D 0
> 149   00:01:14.853427 rt_sigprocmask(SIG_BLOCK, ~[], ~[KILL STOP RTMIN RT=
_1 RT_2], 8) =3D 0
> 149   00:01:14.854067 fork()            =3D 150
> 149   00:01:14.854756 rt_sigprocmask(SIG_SETMASK, ~[KILL STOP RTMIN RT_1 =
RT_2], NULL, 8) =3D 0
> 149   00:01:14.855340 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
> 149   00:01:14.855911 wait4(-1,  <unfinished ...>
> 150   00:01:14.856325 gettid()          =3D 150
> 150   00:01:14.856883 rt_sigprocmask(SIG_SETMASK, ~[KILL STOP RTMIN RT_1 =
RT_2], NULL, 8) =3D 0
> 150   00:01:14.857476 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
> 150   00:01:14.858144 close(10)         =3D 0
> 150   00:01:14.858604 rt_sigaction(SIGQUIT, {sa_handler=3DSIG_DFL, sa_mas=
k=3D~[RTMIN RT_1 RT_2], sa_flags=3DSA_RESTORER, sa_restorer=3D0x295b6a2a}, =
NULL, 8) =3D 0
> 150   00:01:14.859379 execve("/sbin/ifconfig", ["/sbin/ifconfig", "eth0",=
 "up"], 0x295eda04 /* 12 vars */) =3D 0
> 150   00:01:14.862391 set_tid_address(0x295faf94) =3D 150
> 150   00:01:14.863655 brk(NULL)         =3D 0x4c0000
> 150   00:01:14.864532 brk(0x4c2000)     =3D 0x4c2000
> 150   00:01:14.865440 mmap2(0x4c0000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FI=
XED|MAP_ANONYMOUS, -1, 0) =3D 0x4c0000
> 150   00:01:14.867189 mprotect(0x295f8000, 4096, PROT_READ) =3D 0
> 150   00:01:14.869004 mprotect(0x4be000, 4096, PROT_READ) =3D 0
> 150   00:01:14.870087 getuid32()        =3D 0
> 150   00:01:14.870621 socket(AF_INET, SOCK_DGRAM, IPPROTO_IP) =3D 3
> 150   00:01:14.871171 ioctl(3, SIOCGIFFLAGS, {ifr_name=3D"eth0", ifr_flag=
s=3DIFF_UP|IFF_BROADCAST|IFF_RUNNING|IFF_MULTICAST}) =3D 0
> 150   00:01:14.871909 ioctl(3, SIOCSIFFLAGS, {ifr_name=3D"eth0", ifr_flag=
s=3DIFF_UP|IFF_BROADCAST|IFF_RUNNING|IFF_MULTICAST}) =3D 0
> 150   00:01:14.872659 exit_group(0)     =3D ?
> 150   00:01:14.873240 +++ exited with 0 +++
> 149   00:01:14.873549 <... wait4 resumed>[{WIFEXITED(s) && WEXITSTATUS(s)=
 =3D=3D 0}], 0, NULL) =3D 150
> 149   00:01:14.874007 --- SIGCHLD {si_signo=3DSIGCHLD, si_code=3DCLD_EXIT=
ED, si_pid=3D150, si_uid=3D0, si_status=3D0, si_utime=3D0, si_stime=3D0} --=
-
> 149   00:01:14.874460 sigreturn()       =3D 150
> 149   00:01:14.874828 wait4(-1, 0x7b8b8964, WNOHANG, NULL) =3D -1 ECHILD =
(No child process)
> 149   00:01:14.875593 rt_sigprocmask(SIG_BLOCK, ~[RTMIN RT_1 RT_2], [], 8=
) =3D 0
> 149   00:01:14.876216 rt_sigprocmask(SIG_BLOCK, ~[], ~[KILL STOP RTMIN RT=
_1 RT_2], 8) =3D 0
> 149   00:01:14.876812 fork()            =3D 151
> 149   00:01:14.877442 rt_sigprocmask(SIG_SETMASK, ~[KILL STOP RTMIN RT_1 =
RT_2], NULL, 8) =3D 0
> 149   00:01:14.878210 rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
> 151   00:01:14.878585 gettid( <unfinished ...>
> 149   00:01:14.878827 <... rt_sigprocmask resumed>NULL, 8) =3D 0
> 151   00:01:14.879189 <... gettid resumed>) =3D 151
> 149   00:01:14.879636 wait4(-1,  <unfinished ...>
> 151   00:01:14.879908 rt_sigprocmask(SIG_SETMASK, ~[KILL STOP RTMIN RT_1 =
RT_2], NULL, 8) =3D 0
> 151   00:01:14.880474 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
> 151   00:01:14.881077 close(10)         =3D 0
> 151   00:01:14.881578 rt_sigaction(SIGQUIT, {sa_handler=3DSIG_DFL, sa_mas=
k=3D~[RTMIN RT_1 RT_2], sa_flags=3DSA_RESTORER, sa_restorer=3D0x295b6a2a}, =
NULL, 8) =3D 0
> 151   00:01:14.882387 execve("/sbin/ifconfig", ["/sbin/ifconfig", "eth0",=
 "0.0.0.0"], 0x295eda04 /* 12 vars */) =3D 0
> 151   00:01:14.884044 set_tid_address(0x295faf94) =3D 151
> 151   00:01:14.884600 brk(NULL)         =3D 0x4c0000
> 151   00:01:14.884991 brk(0x4c2000)     =3D 0x4c2000
> 151   00:01:14.885424 mmap2(0x4c0000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FI=
XED|MAP_ANONYMOUS, -1, 0) =3D 0x4c0000
> 151   00:01:14.886221 mprotect(0x295f8000, 4096, PROT_READ) =3D 0
> 151   00:01:14.886999 mprotect(0x4be000, 4096, PROT_READ) =3D 0
> 151   00:01:14.887634 getuid32()        =3D 0
> 151   00:01:14.888176 socket(AF_INET, SOCK_DGRAM, IPPROTO_IP) =3D 3
> 151   00:01:14.888763 ioctl(3, SIOCSIFADDR, {ifr_name=3D"eth0", ifr_addr=
=3D{sa_family=3DAF_INET, sin_port=3Dhtons(0), sin_addr=3Dinet_addr("0.0.0.0=
")}}) =3D 0
> 151   00:01:14.890126 ioctl(3, SIOCGIFFLAGS, {ifr_name=3D"eth0", ifr_flag=
s=3DIFF_UP|IFF_BROADCAST|IFF_RUNNING|IFF_MULTICAST}) =3D 0
> 151   00:01:14.890830 ioctl(3, SIOCSIFFLAGS, {ifr_name=3D"eth0", ifr_flag=
s=3DIFF_UP|IFF_BROADCAST|IFF_RUNNING|IFF_MULTICAST}) =3D 0
> 151   00:01:14.891587 exit_group(0)     =3D ?
> 151   00:01:14.892248 +++ exited with 0 +++
> 149   00:01:14.892437 <... wait4 resumed>[{WIFEXITED(s) && WEXITSTATUS(s)=
 =3D=3D 0}], 0, NULL) =3D 151
> 149   00:01:14.892855 --- SIGCHLD {si_signo=3DSIGCHLD, si_code=3DCLD_EXIT=
ED, si_pid=3D151, si_uid=3D0, si_status=3D0, si_utime=3D0, si_stime=3D0} --=
-
> 149   00:01:14.893283 sigreturn()       =3D 151
> 149   00:01:14.893676 wait4(-1, 0x7b8b8964, WNOHANG, NULL) =3D -1 ECHILD =
(No child process)
> 149   00:01:14.894402 pipe([3, 0])      =3D 3
> 149   00:01:14.894941 rt_sigprocmask(SIG_BLOCK, ~[RTMIN RT_1 RT_2], [], 8=
) =3D 0
> 149   00:01:14.895579 rt_sigprocmask(SIG_BLOCK, ~[], ~[KILL STOP RTMIN RT=
_1 RT_2], 8) =3D 0
> 149   00:01:14.896185 fork()            =3D 152
> 149   00:01:14.896824 rt_sigprocmask(SIG_SETMASK, ~[KILL STOP RTMIN RT_1 =
RT_2], NULL, 8) =3D 0
> 149   00:01:14.897379 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
> 149   00:01:14.898012 close(4)          =3D 0
> 149   00:01:14.898493 read(3,  <unfinished ...>
> 152   00:01:14.898909 gettid()          =3D 152
> 152   00:01:14.899453 rt_sigprocmask(SIG_SETMASK, ~[KILL STOP RTMIN RT_1 =
RT_2], NULL, 8) =3D 0
> 152   00:01:14.900073 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
> 152   00:01:14.900694 close(10)         =3D 0
> 152   00:01:14.901215 rt_sigaction(SIGQUIT, {sa_handler=3DSIG_DFL, sa_mas=
k=3D~[RTMIN RT_1 RT_2], sa_flags=3DSA_RESTORER, sa_restorer=3D0x295b6a2a}, =
NULL, 8) =3D 0
> 152   00:01:14.901947 close(3)          =3D 0
> 152   00:01:14.902386 dup2(4, 1)        =3D 1
> 152   00:01:14.902828 close(4)          =3D 0
> 152   00:01:14.903493 statx(AT_FDCWD, "/sbin/mktemp", AT_STATX_SYNC_AS_ST=
AT, STATX_BASIC_STATS, 0x7b8b867c) =3D -1 ENOENT (No such file or directory=
)
> 152   00:01:14.904350 statx(AT_FDCWD, "/usr/sbin/mktemp", AT_STATX_SYNC_A=
S_STAT, STATX_BASIC_STATS, 0x7b8b867c) =3D -1 ENOENT (No such file or direc=
tory)
> 152   00:01:14.905219 statx(AT_FDCWD, "/bin/mktemp", AT_STATX_SYNC_AS_STA=
T, STATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attri=
butes=3D0, stx_mode=3DS_IFREG|S_ISUID|0755, stx_size=3D719260, ...}) =3D 0
> 152   00:01:14.906411 execve("/bin/mktemp", ["mktemp"], 0x295ed9e4 /* 12 =
vars */) =3D 0
> 152   00:01:14.908077 set_tid_address(0x295faf94) =3D 152
> 152   00:01:14.908657 brk(NULL)         =3D 0x4c0000
> 152   00:01:14.909091 brk(0x4c2000)     =3D 0x4c2000
> 152   00:01:14.909509 mmap2(0x4c0000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FI=
XED|MAP_ANONYMOUS, -1, 0) =3D 0x4c0000
> 152   00:01:14.910324 mprotect(0x295f8000, 4096, PROT_READ) =3D 0
> 152   00:01:14.911111 mprotect(0x4be000, 4096, PROT_READ) =3D 0
> 152   00:01:14.911775 getuid32()        =3D 0
> 152   00:01:14.912527 clock_gettime64(CLOCK_REALTIME, {tv_sec=3D74, tv_ns=
ec=3D912746788}) =3D 0
> 152   00:01:14.913100 open("/tmp/tmp.kJfCJh", O_RDWR|O_CREAT|O_EXCL|O_LAR=
GEFILE, 0600) =3D 3
> 152   00:01:14.913909 ioctl(1, _IOC(_IOC_READ, 0x74, 0x68, 0x8), 0x7ba83d=
58) =3D -1 ENOTTY (Not a tty)
> 152   00:01:14.914501 writev(1, [{iov_base=3D"/tmp/tmp.kJfCJh", iov_len=
=3D15}, {iov_base=3D"\n", iov_len=3D1}], 2) =3D 16
> 149   00:01:14.915257 <... read resumed>"/tmp/tmp.kJfCJh\n", 128) =3D 16
> 152   00:01:14.915787 exit_group(0 <unfinished ...>
> 149   00:01:14.916074 read(3,  <unfinished ...>
> 152   00:01:14.916360 <... exit_group resumed>) =3D ?
> 152   00:01:14.916808 +++ exited with 0 +++
> 149   00:01:14.916995 <... read resumed>"", 128) =3D 0
> 149   00:01:14.917317 --- SIGCHLD {si_signo=3DSIGCHLD, si_code=3DCLD_EXIT=
ED, si_pid=3D152, si_uid=3D0, si_status=3D0, si_utime=3D0, si_stime=3D0} --=
-
> 149   00:01:14.917754 sigreturn()       =3D 0
> 149   00:01:14.918225 close(3)          =3D 0
> 149   00:01:14.918716 wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) =3D=3D 0=
}], 0, NULL) =3D 152
> 149   00:01:14.919344 wait4(-1, 0x7b8b887c, WNOHANG, NULL) =3D -1 ECHILD =
(No child process)
> 149   00:01:14.920220 open("/tmp/tmp.kJfCJh", O_WRONLY|O_CREAT|O_TRUNC|O_=
LARGEFILE, 0666) =3D 3
> 149   00:01:14.921007 fcntl64(1, F_DUPFD_CLOEXEC, 10) =3D 11
> 149   00:01:14.921455 fcntl64(11, F_SETFD, FD_CLOEXEC) =3D 0
> 149   00:01:14.921995 dup2(3, 1)        =3D 1
> 149   00:01:14.922436 close(3)          =3D 0
> 149   00:01:14.922910 statx(AT_FDCWD, "/sbin/grep", AT_STATX_SYNC_AS_STAT=
, STATX_BASIC_STATS, 0x7b8b8868) =3D -1 ENOENT (No such file or directory)
> 149   00:01:14.923774 statx(AT_FDCWD, "/usr/sbin/grep", AT_STATX_SYNC_AS_=
STAT, STATX_BASIC_STATS, 0x7b8b8868) =3D -1 ENOENT (No such file or directo=
ry)
> 149   00:01:14.924634 statx(AT_FDCWD, "/bin/grep", AT_STATX_SYNC_AS_STAT,=
 STATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attribu=
tes=3D0, stx_mode=3DS_IFREG|S_ISUID|0755, stx_size=3D719260, ...}) =3D 0
> 149   00:01:14.925771 rt_sigprocmask(SIG_BLOCK, ~[RTMIN RT_1 RT_2], [], 8=
) =3D 0
> 149   00:01:14.926468 rt_sigprocmask(SIG_BLOCK, ~[], ~[KILL STOP RTMIN RT=
_1 RT_2], 8) =3D 0
> 149   00:01:14.927060 fork()            =3D 153
> 149   00:01:14.927718 rt_sigprocmask(SIG_SETMASK, ~[KILL STOP RTMIN RT_1 =
RT_2], NULL, 8) =3D 0
> 149   00:01:14.928310 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
> 149   00:01:14.928897 wait4(-1,  <unfinished ...>
> 153   00:01:14.929332 gettid()          =3D 153
> 153   00:01:14.929944 rt_sigprocmask(SIG_SETMASK, ~[KILL STOP RTMIN RT_1 =
RT_2], NULL, 8) =3D 0
> 153   00:01:14.930555 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
> 153   00:01:14.931195 close(10)         =3D 0
> 153   00:01:14.931657 rt_sigaction(SIGQUIT, {sa_handler=3DSIG_DFL, sa_mas=
k=3D~[RTMIN RT_1 RT_2], sa_flags=3DSA_RESTORER, sa_restorer=3D0x295b6a2a}, =
NULL, 8) =3D 0
> 153   00:01:14.932491 execve("/bin/grep", ["grep", "-vE", "# eth0$", "/et=
c/resolv.conf"], 0x295eda3c /* 12 vars */) =3D 0
> 153   00:01:14.934241 set_tid_address(0x295faf94) =3D 153
> 153   00:01:14.934826 brk(NULL)         =3D 0x4c0000
> 153   00:01:14.935235 brk(0x4c2000)     =3D 0x4c2000
> 153   00:01:14.935675 mmap2(0x4c0000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FI=
XED|MAP_ANONYMOUS, -1, 0) =3D 0x4c0000
> 153   00:01:14.936442 mprotect(0x295f8000, 4096, PROT_READ) =3D 0
> 153   00:01:14.937215 mprotect(0x4be000, 4096, PROT_READ) =3D 0
> 153   00:01:14.937884 getuid32()        =3D 0
> 153   00:01:14.938548 open("/etc/resolv.conf", O_RDONLY|O_LARGEFILE) =3D =
3
> 153   00:01:14.939278 mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE=
|MAP_ANONYMOUS, -1, 0) =3D 0x295ea000
> 153   00:01:14.939984 read(3, "nameserver 10.0.2.3 # eth0\n", 1024) =3D 2=
7
> 153   00:01:14.940648 mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE=
|MAP_ANONYMOUS, -1, 0) =3D 0x295eb000
> 153   00:01:14.941526 munmap(0x295eb000, 8192) =3D 0
> 153   00:01:14.942271 read(3, "", 1024) =3D 0
> 153   00:01:14.942796 close(3)          =3D 0
> 153   00:01:14.943267 munmap(0x295ea000, 4096) =3D 0
> 153   00:01:14.943777 exit_group(1)     =3D ?
> 153   00:01:14.944421 +++ exited with 1 +++
> 149   00:01:14.944623 <... wait4 resumed>[{WIFEXITED(s) && WEXITSTATUS(s)=
 =3D=3D 1}], 0, NULL) =3D 153
> 149   00:01:14.945037 --- SIGCHLD {si_signo=3DSIGCHLD, si_code=3DCLD_EXIT=
ED, si_pid=3D153, si_uid=3D0, si_status=3D1, si_utime=3D0, si_stime=3D0} --=
-
> 149   00:01:14.945505 sigreturn()       =3D 153
> 149   00:01:14.945946 wait4(-1, 0x7b8b89bc, WNOHANG, NULL) =3D -1 ECHILD =
(No child process)
> 149   00:01:14.946566 dup2(11, 1)       =3D 1
> 149   00:01:14.947085 close(11)         =3D 0
> 149   00:01:14.947752 open("/etc/resolv.conf", O_WRONLY|O_CREAT|O_TRUNC|O=
_LARGEFILE, 0666) =3D 3
> 149   00:01:14.948764 fcntl64(1, F_DUPFD_CLOEXEC, 10) =3D 11
> 149   00:01:14.949223 fcntl64(11, F_SETFD, FD_CLOEXEC) =3D 0
> 149   00:01:14.949681 dup2(3, 1)        =3D 1
> 149   00:01:14.950166 close(3)          =3D 0
> 149   00:01:14.950615 statx(AT_FDCWD, "/sbin/cat", AT_STATX_SYNC_AS_STAT,=
 STATX_BASIC_STATS, 0x7b8b8894) =3D -1 ENOENT (No such file or directory)
> 149   00:01:14.951450 statx(AT_FDCWD, "/usr/sbin/cat", AT_STATX_SYNC_AS_S=
TAT, STATX_BASIC_STATS, 0x7b8b8894) =3D -1 ENOENT (No such file or director=
y)
> 149   00:01:14.952318 statx(AT_FDCWD, "/bin/cat", AT_STATX_SYNC_AS_STAT, =
STATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attribut=
es=3D0, stx_mode=3DS_IFREG|S_ISUID|0755, stx_size=3D719260, ...}) =3D 0
> 149   00:01:14.953416 rt_sigprocmask(SIG_BLOCK, ~[RTMIN RT_1 RT_2], [], 8=
) =3D 0
> 149   00:01:14.954072 rt_sigprocmask(SIG_BLOCK, ~[], ~[KILL STOP RTMIN RT=
_1 RT_2], 8) =3D 0
> 149   00:01:14.954710 fork()            =3D 154
> 149   00:01:14.955371 rt_sigprocmask(SIG_SETMASK, ~[KILL STOP RTMIN RT_1 =
RT_2], NULL, 8) =3D 0
> 149   00:01:14.955915 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
> 149   00:01:14.956480 wait4(-1,  <unfinished ...>
> 154   00:01:14.956911 gettid()          =3D 154
> 154   00:01:14.957469 rt_sigprocmask(SIG_SETMASK, ~[KILL STOP RTMIN RT_1 =
RT_2], NULL, 8) =3D 0
> 154   00:01:14.958107 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
> 154   00:01:14.958726 close(10)         =3D 0
> 154   00:01:14.959220 rt_sigaction(SIGQUIT, {sa_handler=3DSIG_DFL, sa_mas=
k=3D~[RTMIN RT_1 RT_2], sa_flags=3DSA_RESTORER, sa_restorer=3D0x295b6a2a}, =
NULL, 8) =3D 0
> 154   00:01:14.960010 execve("/bin/cat", ["cat", "/tmp/tmp.kJfCJh"], 0x29=
5eda0c /* 12 vars */) =3D 0
> 154   00:01:14.961650 set_tid_address(0x295faf94) =3D 154
> 154   00:01:14.962260 brk(NULL)         =3D 0x4c0000
> 154   00:01:14.962677 brk(0x4c2000)     =3D 0x4c2000
> 154   00:01:14.963093 mmap2(0x4c0000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FI=
XED|MAP_ANONYMOUS, -1, 0) =3D 0x4c0000
> 154   00:01:14.963855 mprotect(0x295f8000, 4096, PROT_READ) =3D 0
> 154   00:01:14.964649 mprotect(0x4be000, 4096, PROT_READ) =3D 0
> 154   00:01:14.965332 getuid32()        =3D 0
> 154   00:01:14.965963 open("/tmp/tmp.kJfCJh", O_RDONLY|O_LARGEFILE) =3D 3
> 154   00:01:14.966693 sendfile64(1, 3, NULL, 16777216) =3D 0
> 154   00:01:14.967225 close(3)          =3D 0
> 154   00:01:14.967771 exit_group(0)     =3D ?
> 154   00:01:14.968431 +++ exited with 0 +++
> 149   00:01:14.968637 <... wait4 resumed>[{WIFEXITED(s) && WEXITSTATUS(s)=
 =3D=3D 0}], 0, NULL) =3D 154
> 149   00:01:14.969062 --- SIGCHLD {si_signo=3DSIGCHLD, si_code=3DCLD_EXIT=
ED, si_pid=3D154, si_uid=3D0, si_status=3D0, si_utime=3D0, si_stime=3D0} --=
-
> 149   00:01:14.969524 sigreturn()       =3D 154
> 149   00:01:14.970021 wait4(-1, 0x7b8b89e8, WNOHANG, NULL) =3D -1 ECHILD =
(No child process)
> 149   00:01:14.970630 dup2(11, 1)       =3D 1
> 149   00:01:14.971135 close(11)         =3D 0
> 149   00:01:14.971803 statx(AT_FDCWD, "/sbin/rm", AT_STATX_SYNC_AS_STAT, =
STATX_BASIC_STATS, 0x7b8b88c0) =3D -1 ENOENT (No such file or directory)
> 149   00:01:14.972693 statx(AT_FDCWD, "/usr/sbin/rm", AT_STATX_SYNC_AS_ST=
AT, STATX_BASIC_STATS, 0x7b8b88c0) =3D -1 ENOENT (No such file or directory=
)
> 149   00:01:14.973506 statx(AT_FDCWD, "/bin/rm", AT_STATX_SYNC_AS_STAT, S=
TATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS|STATX_MNT_ID, stx_attribute=
s=3D0, stx_mode=3DS_IFREG|S_ISUID|0755, stx_size=3D719260, ...}) =3D 0
> 149   00:01:14.974668 rt_sigprocmask(SIG_BLOCK, ~[RTMIN RT_1 RT_2], [], 8=
) =3D 0
> 149   00:01:14.975332 rt_sigprocmask(SIG_BLOCK, ~[], ~[KILL STOP RTMIN RT=
_1 RT_2], 8) =3D 0
> 149   00:01:14.975936 fork()            =3D 155
> 149   00:01:14.976585 rt_sigprocmask(SIG_SETMASK, ~[KILL STOP RTMIN RT_1 =
RT_2], NULL, 8) =3D 0
> 149   00:01:14.977166 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
> 149   00:01:14.977733 wait4(-1,  <unfinished ...>
> 155   00:01:14.978296 gettid()          =3D 155
> 155   00:01:14.978860 rt_sigprocmask(SIG_SETMASK, ~[KILL STOP RTMIN RT_1 =
RT_2], NULL, 8) =3D 0
> 155   00:01:14.979466 rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
> 155   00:01:14.980076 close(10)         =3D 0
> 155   00:01:14.980557 rt_sigaction(SIGQUIT, {sa_handler=3DSIG_DFL, sa_mas=
k=3D~[RTMIN RT_1 RT_2], sa_flags=3DSA_RESTORER, sa_restorer=3D0x295b6a2a}, =
NULL, 8) =3D 0
> 155   00:01:14.981350 execve("/bin/rm", ["rm", "-f", "/tmp/tmp.kJfCJh"], =
0x295eda04 /* 12 vars */) =3D 0
> 155   00:01:14.983082 set_tid_address(0x295faf94) =3D 155
> 155   00:01:14.983662 brk(NULL)         =3D 0x4c0000
> 155   00:01:14.984120 brk(0x4c2000)     =3D 0x4c2000
> 155   00:01:14.984536 mmap2(0x4c0000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FI=
XED|MAP_ANONYMOUS, -1, 0) =3D 0x4c0000
> 155   00:01:14.985336 mprotect(0x295f8000, 4096, PROT_READ) =3D 0
> 155   00:01:14.986187 mprotect(0x4be000, 4096, PROT_READ) =3D 0
> 155   00:01:14.986851 getuid32()        =3D 0
> 155   00:01:14.987464 statx(AT_FDCWD, "/tmp/tmp.kJfCJh", AT_STATX_SYNC_AS=
_STAT|AT_SYMLINK_NOFOLLOW, STATX_BASIC_STATS, {stx_mask=3DSTATX_BASIC_STATS=
|STATX_MNT_ID, stx_attributes=3D0, stx_mode=3DS_IFREG|0600, stx_size=3D0, .=
..}) =3D 0
> 155   00:01:14.988583 unlink("/tmp/tmp.kJfCJh") =3D 0
> 155   00:01:14.989318 exit_group(0)     =3D ?
> 155   00:01:14.989984 +++ exited with 0 +++
> 149   00:01:14.990176 <... wait4 resumed>[{WIFEXITED(s) && WEXITSTATUS(s)=
 =3D=3D 0}], 0, NULL) =3D 155
> 149   00:01:14.990593 --- SIGCHLD {si_signo=3DSIGCHLD, si_code=3DCLD_EXIT=
ED, si_pid=3D155, si_uid=3D0, si_status=3D0, si_utime=3D0, si_stime=3D0} --=
-
> 149   00:01:14.991041 sigreturn()       =3D 155
> 149   00:01:14.991439 wait4(-1, 0x7b8b8a14, WNOHANG, NULL) =3D -1 ECHILD =
(No child process)
> 149   00:01:14.992291 statx(AT_FDCWD, "/usr/sbin/avahi-autoipd", AT_STATX=
_SYNC_AS_STAT, STATX_BASIC_STATS, 0x7b8b87c0) =3D -1 ENOENT (No such file o=
r directory)
> 149   00:01:14.993194 munmap(0x295ed000, 4096) =3D 0
> 149   00:01:14.993755 munmap(0x295ec000, 4096) =3D 0
> 149   00:01:14.994865 read(10, " continue\n    \"${hook}\" \"${@}\"\ndone=
\n\nexit 0\n", 1023) =3D 44
> 149   00:01:14.995743 mmap2(NULL, 16384, PROT_READ|PROT_WRITE, MAP_PRIVAT=
E|MAP_ANONYMOUS, -1, 0) =3D 0x295ec000
> 149   00:01:14.996482 open("/usr/share/udhcpc/default.script.d/", O_RDONL=
Y|O_LARGEFILE|O_CLOEXEC|O_DIRECTORY) =3D 3
> 149   00:01:14.997188 fcntl64(3, F_SETFD, FD_CLOEXEC) =3D 0
> 149   00:01:14.997687 mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE=
|MAP_ANONYMOUS, -1, 0) =3D 0x295f0000
> 149   00:01:14.998402 getdents64(3, 0x295f0088 /* 2 entries */, 2048) =3D=
 48
> 149   00:01:14.999027 getdents64(3, 0x295f0088 /* 0 entries */, 2048) =3D=
 0
> 149   00:01:14.999576 close(3)          =3D 0
> 149   00:01:15.000076 munmap(0x295f0000, 8192) =3D 0
> 149   00:01:15.000603 munmap(0x295ec000, 16384) =3D 0
> 149   00:01:15.001370 statx(AT_FDCWD, "/usr/share/udhcpc/default.script.d=
/*", AT_STATX_SYNC_AS_STAT, STATX_BASIC_STATS, 0x7b8b87d0) =3D -1 ENOENT (N=
o such file or directory)
> 149   00:01:15.002240 statx(AT_FDCWD, "/usr/share/udhcpc/default.script.d=
/*", AT_STATX_SYNC_AS_STAT, STATX_BASIC_STATS, 0x7b8b87bc) =3D -1 ENOENT (N=
o such file or directory)
> 149   00:01:15.003345 exit_group(0)     =3D ?
> 149   00:01:15.003998 +++ exited with 0 +++
> 148   00:01:15.004204 <... wait4 resumed>[{WIFEXITED(s) && WEXITSTATUS(s)=
 =3D=3D 0}], 0, NULL) =3D 149
> 148   00:01:15.004606 --- SIGCHLD {si_signo=3DSIGCHLD, si_code=3DCLD_EXIT=
ED, si_pid=3D149, si_uid=3D0, si_status=3D0, si_utime=3D0, si_stime=3D2} --=
-
> 148   00:01:15.005134 socket(AF_PACKET, SOCK_DGRAM, htons(ETH_P_IP)) =3D =
5
> 148   00:01:15.005673 bind(5, {sa_family=3DAF_PACKET, sll_protocol=3Dhton=
s(ETH_P_IP), sll_ifindex=3Dif_nametoindex("eth0"), sll_hatype=3DARPHRD_NETR=
OM, sll_pkttype=3DPACKET_HOST, sll_halen=3D0}, 20) =3D 0
> 148   00:01:15.006493 setsockopt(5, SOL_PACKET, PACKET_AUXDATA, [1], 4) =
=3D 0
> 148   00:01:15.007093 fcntl64(5, F_SETFD, FD_CLOEXEC) =3D 0
> 148   00:01:15.007594 socket(AF_INET, SOCK_RAW, IPPROTO_RAW) =3D 6
> 148   00:01:15.008067 ioctl(6, SIOCGIFINDEX, {ifr_name=3D"eth0", }) =3D 0
> 148   00:01:15.008670 ioctl(6, SIOCGIFHWADDR, {ifr_name=3D"eth0", ifr_hwa=
ddr=3D{sa_family=3DARPHRD_ETHER, sa_data=3D52:54:00:12:34:56}}) =3D 0
> 148   00:01:15.009520 close(6)          =3D 0
> 148   00:01:15.010058 clock_gettime64(CLOCK_MONOTONIC, {tv_sec=3D75, tv_n=
sec=3D10264188}) =3D 0
> 148   00:01:15.010691 write(2, "udhcpc: sending discover\n", 25) =3D 25
> 148   00:01:15.011397 socket(AF_PACKET, SOCK_DGRAM, htons(ETH_P_IP)) =3D =
6
> 148   00:01:15.011946 bind(6, {sa_family=3DAF_PACKET, sll_protocol=3Dhton=
s(ETH_P_IP), sll_ifindex=3Dif_nametoindex("eth0"), sll_hatype=3DARPHRD_NETR=
OM, sll_pkttype=3DPACKET_HOST, sll_halen=3D6, sll_addr=3D[0xff, 0xff, 0xff,=
 0xff, 0xff, 0xff]}, 20) =3D 0
> 148   00:01:15.012830 sendto(6, "E\0\1H\0\0\0\0@\21y\246\0\0\0\0\377\377\=
377\377\0D\0C\0014!~\1\1\6\0\272\352\336g\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0=
\0\0\0RT\0\0224V\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0=
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0=
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0c\202Sc5\1\1=3D\7\1RT\0\0224V9=
\2\2@7\7\1\3\6\f\17\34*<\fudhcp 1.33.0\377\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0\0\0\0", 328, 0, {sa_family=3DAF_PACKET, sll_protocol=3Dhtons(ETH_P_IP), s=
ll_ifindex=3Dif_nametoindex("eth0"), sll_hatype=3DARPHRD_NETROM, sll_pkttyp=
e=3DPACKET_HOST, sll_halen=3D6, sll_addr=3D[0xff, 0xff, 0xff, 0xff, 0xff, 0=
xff]}, 20

Ok, so we do not know how this process died ?

Something else is fishy, maybe with strace ?

Thanks.
