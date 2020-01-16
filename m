Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF01013FB6E
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 22:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388421AbgAPV3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 16:29:47 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44092 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbgAPV3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 16:29:47 -0500
Received: by mail-qt1-f194.google.com with SMTP id w8so5754217qts.11
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 13:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ep1GXq3V1xNMyLxk5cfcDjvxSUznPR9wxS7KsNFrSd8=;
        b=h/Mb+lEcg4smiPrmDwFPlVVV/2nzlh01eaeL4obYAJ+BbAYmuxDTcidMJA93TqiZQ+
         1GW6dhY+5BStZU9X1LDfQcdElvkjHxryvhgquTeXPccnO73xEyLyPaEN8HANLXigbGTi
         pv1ct9vPVDVSgzx0ul9eua9VJOaD4eDdZnS1+ecJ3xphgl+c863dp+HJBA7EoKJZmuJF
         w20Dw9kEDyDILVeawc4LWhB2RwxO5RDYoRoDa8YCO53YZP14wbhgLQRDhPC9RJc5muQ9
         6LrQwMaQK+vY9Jfx8wb7fbA24zrEc7yypyLE/lJ+3C1JMbJ+eplI3zRztoxXlMdM5Gk9
         RZQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ep1GXq3V1xNMyLxk5cfcDjvxSUznPR9wxS7KsNFrSd8=;
        b=ZHbmZjYIopbD1BXZbz9uniJW3bfXeKK3g5TD3yBgrztEHktySQunajpo7Lj9SabNZo
         u0CptKEqWIkHgWIWe9bJ6wdsooFT+GjI08Rfr5LqYcuoWgj+JJOYF/14G9nrgaxz9Xhw
         6/wLTdMlOs8qLBzrrvzZeKFSLPT7xazXQMTX8i+YOB28sT3Dys3gy5zz/mo/xhls8I1d
         hQvqwHxjewQ9qrqITtN8uwW9saBHoM3xz2NE/2p54BTy8OaEMPEV4VWbfoilF/553bQ9
         fkMUHhNF602s5mZEfmc0W/IOS7bsIZDeoyWplFdNc5okUk/J23BVxnZ64ftGZ94dG6hO
         r9FA==
X-Gm-Message-State: APjAAAW2Gqn5ReUoxDdqXAVAfNumQUEGenuOvxifcgdhcN18/ClZyGOz
        7PyRvZBa0tWhoVvARYy19RnaogzHo3ehCZ4wocQ=
X-Google-Smtp-Source: APXvYqzAyONQVRd0ZlgGgkN2GZxf/YxjNzDOwJLiE4ad29BazNA0NIGBIH/DbMXHhvys+J0pnIj35OWTzm3RJBIYUL8=
X-Received: by 2002:aed:2e03:: with SMTP id j3mr4536537qtd.365.1579210185978;
 Thu, 16 Jan 2020 13:29:45 -0800 (PST)
MIME-Version: 1.0
References: <1D6D69BF-5643-45C2-A0F5-2D30C9C608E5@vmware.com> <fb2d324b-35fb-802d-2e1d-1ee1aa234c16@gmail.com>
In-Reply-To: <fb2d324b-35fb-802d-2e1d-1ee1aa234c16@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 16 Jan 2020 13:28:54 -0800
Message-ID: <CALDO+SafB63DY9xxC=gK94n2UkhxXxcXykd5jQLK7zAi2ef-fA@mail.gmail.com>
Subject: Re: Veth pair swallow packets for XDP_TX operation
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Hanlin Shi <hanlins@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 1:13 AM Toshiaki Makita
<toshiaki.makita1@gmail.com> wrote:
>
> Hi Hanlin,
>
> On 2020/01/16 7:35, Hanlin Shi wrote:
> > Hi community,
> >
> > I=E2=80=99m prototyping an XDP program, and the hit issues with XDP_TX =
operation on veth device. The following code snippet is working as expected=
 on 4.15.0-54-generic, but is NOT working on 4.20.17-042017-lowlatency (I g=
ot the kernel here: https://kernel.ubuntu.com/~kernel-ppa/mainline/v4.20.17=
/).
> >
> > Here=E2=80=99s my setup: I created a veth pair (namely veth1 and veth2)=
, and put them in two namespaces (namely ns1 and ns2). I assigned address 6=
0.0.0.1 on veth1 and 60.0.0.2 on veth2, set the device as the default inter=
face in its namespace respectively (e.g. in ns1, do =E2=80=9Cip r set defau=
lt dev veth1=E2=80=9D). Then in ns1, I ping 60.0.0.2, and tcpdump on veth1=
=E2=80=99s RX for ICMP.
> >
> > Before loading any XDP program on veth2, I can see ICMP replies on veth=
1 interface. I load a program which do =E2=80=9CXDP_TX=E2=80=9D for all pac=
kets on veth2. I expect to see the same ICMP packet being returned, but I s=
aw nothing.
> >
> > I added some debugging message in the XDP program so I=E2=80=99m sure t=
hat the packet is processed on veth2, but on veth1, even with promisc mode =
on, I cannot see any ICMP packets or even ARP packets. In my understanding,=
 4.15 is using generic XDP mode where 4.20 is using native XDP mode for vet=
h, so I guess there=E2=80=99s something wrong with veth native XDP and need=
 some helps on fixing the issue.
>
> You need to load a dummy program to receive packets from peer XDP_TX when=
 using native veth XDP.
>
> The dummy program is something like this:
> int xdp_pass(struct xdp_md *ctx) {
>         return XDP_PASS;
> }
> And load this program on "veth1".
>
> For more information please refer to this slides.
> https://netdevconf.info/0x13/session.html?talk-veth-xdp
>
> Also there is a working example here.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/t=
ools/testing/selftests/bpf/test_xdp_veth.sh
>
> Toshiaki Makita
>
> >
> > Please let me know if you need help on reproducing the issue.
> >
> > Thanks,
> > Hanlin
> >
> > PS: here=E2=80=99s the src code for the XDP program:
> > #include <stddef.h>
> > #include <string.h>
> > #include <linux/if_vlan.h>
> > #include <stdbool.h>
> > #include <bpf/bpf_endian.h>
> > #include <linux/if_ether.h>
> > #include <linux/ip.h>
> > #include <linux/tcp.h>
> > #include <linux/udp.h>
> > #include <linux/in.h>#define DEBUG
> > #include "bpf_helpers.h"
> >
> > SEC("xdp")
> > int loadbal(struct xdp_md *ctx) {
> >    bpf_printk("got packet, direct return\n");
> >    return XDP_TX;
> > }char _license[] SEC("license") =3D "GPL";
> >
> > "bpf_helpers.h" can be found here: https://github.com/dropbox/goebpf/ra=
w/master/bpf_helpers.h
> >

Hi Hanlin,

I tested XDP_TX and the case you mentioned, and it works as OK on my 5.3 ke=
rnel.
I used the script to tested, can you give it a try?

#!/bin/bash
ip netns add at_ns0
ip link add p0 type veth peer name afxdp-p0
ip link set p0 netns at_ns0
ip addr add 10.1.1.2/24 dev afxdp-p0
ip link set dev afxdp-p0 up

ip netns exec at_ns0 sh << NS_EXEC_HEREDOC
ip addr add "10.1.1.1/24" dev p0
ip link set dev p0 up
NS_EXEC_HEREDOC

tcpdump -l -n -i afxdp-p0 -w /tmp/t.pcap icmp &
ping -c 100 10.1.1.1 &

# the xdp program return XDP_TX
ip netns exec at_ns0 ip link set dev p0 xdp obj xdp1_kern.o sec xdp1

$ tcpdump -r /tmp/t.pcap
13:24:59.925165 IP 10.1.1.1 > 10.1.1.2: ICMP echo reply, id 31521, seq
3, length 64
13:25:00.949240 IP 10.1.1.2 > 10.1.1.1: ICMP echo request, id 31521,
seq 4, length 64
13:25:00.949273 IP 10.1.1.1 > 10.1.1.2: ICMP echo reply, id 31521, seq
4, length 64
13:25:01.972369 IP 10.1.1.2 > 10.1.1.1: ICMP echo request, id 31521,
seq 5, length 64
13:25:01.972402 IP 10.1.1.1 > 10.1.1.2: ICMP echo reply, id 31521, seq
5, length 64
load the XDP_TX progam...
13:25:02.995996 IP 10.1.1.2 > 10.1.1.1: ICMP echo request, id 31521,
seq 6, length 64
13:25:04.021256 IP 10.1.1.2 > 10.1.1.1: ICMP echo request, id 31521,
seq 7, length 64
13:25:05.044943 IP 10.1.1.2 > 10.1.1.1: ICMP echo request, id 31521,
seq 8, length 64
13:25:06.069341 IP 10.1.1.2 > 10.1.1.1: ICMP echo request, id 31521,
seq 9, length 64
13:25:07.093121 IP 10.1.1.2 > 10.1.1.1: ICMP echo request, id 31521,
seq 10, length 64
13:25:08.115943 IP 10.1.1.2 > 10.1.1.1: ICMP echo request, id 31521,
seq 11, length 64
13:25:09.141542 IP 10.1.1.2 > 10.1.1.1: ICMP echo request, id 31521,
seq 12, length 64

William
