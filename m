Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C734A89BC7
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfHLKnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:43:23 -0400
Received: from mout.gmx.net ([212.227.17.22]:47963 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727795AbfHLKnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 06:43:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1565606589;
        bh=wp3YFiI3potydFc2/yf2oqLRxfV7Zlo9+YnNBxFcidY=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=CqfskxwIwwrL2tZI6Q82uyp/rKaBWgO5cLPnqI6JKzYQvXbaZDedKnEUM1W7i1ueS
         pMeItaRURYXg/WnE2tfvzvILTKGVt5tyNYHL8UmR4A935HRmPIFaeSHxm60A0cskP4
         CRR6Gj3ACHxZrgN/eTLyVDPSBWLcJAptrh3uX6VA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.152.193] ([217.61.152.193]) by web-mail.gmx.net
 (3c-app-gmx-bs80.server.lan [172.19.170.228]) (via HTTP); Mon, 12 Aug 2019
 12:43:09 +0200
MIME-Version: 1.0
Message-ID: <trinity-99bcd71d-8f78-4bbe-a439-f6a915040b0a-1565606589515@3c-app-gmx-bs80>
From:   "Frank Wunderlich" <frank-w@public-files.de>
To:     "Andrew Lunn" <andrew@lunn.ch>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [BUG] access to null-pointer in dsa_switch_event when bridge set up
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 12 Aug 2019 12:43:09 +0200
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:XZaEfDZ0Ncu+3+6X6bUwMHapo0wNaUT8Qi3PhKcK1Mig1tjZh9ahK7cgpMS5V4HSXEoa5
 bGGChxuDlrel/7NC/F+8gKXgOqg0FqKuJ5wkcmYWeoYeAKNfJz55B+gmVh3hzR40dw4YlCytQ3Sk
 /qIAiOL/rxO9v9Mzr2JDTkF+olqHHAhd8uPqPhQmQ+1tq4r3Jin6kKS93aOgVQYrIphx0It18914
 or9fikXSpnTAnG5e4o+2HGH+j8IayUfjZqbYiWPJx7L/CJaadc9M12wAXrJ9b6B9LDjMLpHFR4Qh
 mk=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:n7Oi+tCz/8k=:xAYheaxeiAPMGelHJN5t9O
 kkVB250qoZ6j0o0ks1/l3bDNiB+soHuqoYwoHE8EV860nBu7xj+rxHIJCYOvq6JU0/eees5Wx
 7pgGQAU5EwJ29JKU+1IyRjZnx1H50NzK0O/WAbY/I+Y6GRCUGo5SIUvMoZvi0Ls5eJXMDsRgO
 Iw78XtohKI4HqKuP+ByVXdVwWpkgiYc54S8YtDzYMs62YdP+GUbsUfUNtKGhnRdlarryrLBCu
 xpv6n9tg22yfDsnrvOcGrPZUUYo3Z/Gmfpb8ExMY9UhAo/7JUxoEiGWjSnyHCkHnaEWZ/0rTT
 O6EGOqrol0l9jmAwv53m3nYgmemTe4AHaNrBeH11uec2T6XY0sB0HSGX5lpfK6R8qsj2fhGf4
 QtPNeucgw9KctcrKCIxUYpLlwkBFM7Wg40g4NXpWF1xhYBBcag5MSe6hEwi/yZvOFduplCpzg
 nxApEe8vnb8aM13zlJlp82EaNriffvfOOAu+WA64ZOOanHlDmsrzvvEChobo98jjDKHiSRR53
 YYmiHkyMX4sNeXHShXJtP5d8cWqbm1RyOr3DOXIVHhTstKhWEpBrq22ut0MCwnyNghOoDOW9A
 +2AFN/FTV+AeDK7Sn2nL6riH7isU9ISjVLRkql4o7mmN3UOZavi4syBtfGUf1PKmBVB3KSCPn
 onp8h1mj/XTZ/3sGV5WYTNJl7eVe0L2XOlhGK+TDQ5WK3RA==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

i've noticed a bug when using bridge on dsa-ports. Tested on Bpi-r2, Crash=
 happens on 5.3-rc1 and rc4, 5.2-rc7 (last version pre 5.3 i have found on=
 my tftp) is not affected.

root@bpi-r2:~# brctl addbr br0
root@bpi-r2:~# ip addr add 192.168.0.11/24 dev br0
root@bpi-r2:~# brctl addif br0 lan0
[   47.731914] br0: port 1(lan0) entered blocking state
[   47.736898] br0: port 1(lan0) entered disabled state
[   47.742586] device lan0 entered promiscuous mode
root@bpi-r2:~# ip link set br0 up
[  114.675568] br0: port 1(lan0) entered blocking state
[  114.680612] br0: port 1(lan0) entered forwarding state
[  114.686643] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
root@bpi-r2:~# [  114.718094] 8<--- cut here ---
[  114.721167] Unable to handle kernel NULL pointer dereference at virtual=
 address 00000000
[  114.729344] pgd =3D 661519c9
[  114.732055] [00000000] *pgd=3D00000000
[  114.735642] Internal error: Oops: 80000005 [#1] SMP ARM
[  114.740865] Modules linked in:
[  114.743925] CPU: 1 PID: 156 Comm: kworker/1:2 Not tainted 5.3.0-rc4-bpi=
-r2 #307
[  114.751231] Hardware name: Mediatek Cortex-A7 (Device Tree)
[  114.756816] Workqueue: events switchdev_deferred_process_work
[  114.762564] PC is at 0x0
[  114.765100] LR is at dsa_switch_event+0x640/0x6e8
[  114.769801] pc : [<00000000>]    lr : [<c09f2f00>]    psr: 20070013
[  114.776064] sp : e71edcc8  ip : 00000000  fp : e71edd0c
[  114.781285] r10: e71ede73  r9 : ea1b7088  r8 : e6932dd0
[  114.786506] r7 : ea1b7040  r6 : 00000006  r5 : c1104c48  r4 : ea1b704c
[  114.793030] r3 : 00000000  r2 : e6932dd0  r1 : 00000006  r0 : ea1b7040
[  114.799560] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segmen=
t none
[  114.806698] Control: 10c5387d  Table: a778006a  DAC: 00000051
[  114.812447] Process kworker/1:2 (pid: 156, stack limit =3D 0xb5a13451)
[  114.818801] Stack: (0xe71edcc8 to 0xe71ee000)
[  114.823162] dcc0:                   c086981c c11a5c20 00000001 600c0113=
 00000000 1021bd52
[  114.831347] dce0: e71edd08 ffffffff 00000000 e71edd54 00000005 00000000=
 c09f1dd0 00000000
[  114.839531] dd00: e71edd34 e71edd10 c014d4f8 c09f28cc c1104c48 c1104c48=
 00000000 e71fd800
[  114.847715] dd20: c09f0740 c09f1dd0 e71edd4c e71edd38 c014d658 c014d4ac=
 00000000 c017a738
[  114.855900] dd40: e71edd7c e71edd50 c09efe1c c014d63c e71eddac e6932dd0=
 e71ede73 00000000
[  114.864084] dd60: 00000006 1021bd52 00000000 e71ede38 e71edd8c e71edd80=
 c09f1e2c c09efdd0
[  114.872268] dd80: e71eddc4 e71edd90 c0b47cc4 c09f1ddc b43f0a89 1021bd52=
 00000000 ffffffff
[  114.880452] dda0: 00000000 e71ede38 00000006 00000000 00000000 00000000=
 e71eddd4 e71eddc8
[  114.888637] ddc0: c0b47d5c c0b47c6c e71edde4 e71eddd8 c09f1c58 c0b47d50=
 e71ede0c e71edde8
[  114.896821] dde0: c014d4f8 c09f1c14 00000006 c11bc820 e71ede38 e71fd800=
 e6932dd0 00000000
[  114.905006] de00: e71ede34 e71ede10 c014dd70 c014d4ac 00000000 e71ede20=
 c016a99c c1104c48
[  114.913190] de20: 1021bd52 00000000 e71ede64 e71ede38 c0b479ec c014dd28=
 e71fd800 00000000
[  114.921374] de40: e6932dd0 e71ede73 00000001 1021bd52 c1104c48 e71ede73=
 e71ede9c e71ede68
[  114.929559] de60: c0b47af4 c0b479a4 00000000 c0b65d88 0014d4f8 1021bd52=
 e6932dc0 e6932dd0
[  114.937743] de80: e71fd800 00000100 00000000 c11c50f0 e71edebc e71edea0=
 c0b47b8c c0b47a5c
[  114.945927] dea0: e6932dc0 c11bc818 c12332ac 00000100 e71edee4 e71edec0=
 c0b477e0 c0b47b74
[  114.954112] dec0: 010000ff c0898820 c11bc83c e909f380 ead8f100 ead92200=
 e71edef4 e71edee8
[  114.962296] dee0: c0b47890 c0b47768 e71edf34 e71edef8 c0144dac c0b47880=
 e90b12c0 ffffe000
[  114.970480] df00: e71edf1c e71edf10 c0146f48 e909f380 ead8f100 e909f394=
 ead8f118 ffffe000
[  114.978665] df20: 00000008 c1103d00 e71edf74 e71edf38 c0145b8c c0144c0c=
 ffffe000 c0e58270
[  114.986850] df40: c11c4939 ead8f100 c014b4f4 e910bf40 e910bf00 00000000=
 e71ec000 e909f380
[  114.995036] df60: c0145b30 ea13fe74 e71edfac e71edf78 c014ba18 c0145b3c=
 e910bf5c e910bf5c
[  115.003219] df80: e71edfac e910bf00 c014b8b0 00000000 00000000 00000000=
 00000000 00000000
[  115.011404] dfa0: 00000000 e71edfb0 c01010e8 c014b8bc 00000000 00000000=
 00000000 00000000
[  115.019587] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000=
 00000000 00000000
[  115.027770] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000=
 00000000 00000000
[  115.035948] Backtrace:
[  115.038406] [<c09f28c0>] (dsa_switch_event) from [<c014d4f8>] (notifier=
_call_chain+0x58/0x94)
[  115.046940]  r10:00000000 r9:c09f1dd0 r8:00000000 r7:00000005 r6:e71edd=
54 r5:00000000
[  115.054771]  r4:ffffffff
[  115.057308] [<c014d4a0>] (notifier_call_chain) from [<c014d658>] (raw_n=
otifier_call_chain+0x28/0x30)
[  115.066447]  r9:c09f1dd0 r8:c09f0740 r7:e71fd800 r6:00000000 r5:c1104c4=
8 r4:c1104c48
[  115.074197] [<c014d630>] (raw_notifier_call_chain) from [<c09efe1c>] (d=
sa_port_mdb_add+0x58/0x84)
[  115.083078] [<c09efdc4>] (dsa_port_mdb_add) from [<c09f1e2c>] (dsa_slav=
e_port_obj_add+0x5c/0x78)
[  115.091866]  r4:e71ede38
[  115.094403] [<c09f1dd0>] (dsa_slave_port_obj_add) from [<c0b47cc4>] (__=
switchdev_handle_port_obj_add+0x64/0xe4)
[  115.104499] [<c0b47c60>] (__switchdev_handle_port_obj_add) from [<c0b47=
d5c>] (switchdev_handle_port_obj_add+0x18/0x24)
[  115.115201]  r10:00000000 r9:00000000 r8:00000000 r7:00000006 r6:e71ede=
38 r5:00000000
[  115.123032]  r4:ffffffff
[  115.125570] [<c0b47d44>] (switchdev_handle_port_obj_add) from [<c09f1c5=
8>] (dsa_slave_switchdev_blocking_event+0x50/0xb0)
[  115.136535] [<c09f1c08>] (dsa_slave_switchdev_blocking_event) from [<c0=
14d4f8>] (notifier_call_chain+0x58/0x94)
[  115.146632] [<c014d4a0>] (notifier_call_chain) from [<c014dd70>] (block=
ing_notifier_call_chain+0x54/0x6c)
[  115.156206]  r9:00000000 r8:e6932dd0 r7:e71fd800 r6:e71ede38 r5:c11bc82=
0 r4:00000006
[  115.163956] [<c014dd1c>] (blocking_notifier_call_chain) from [<c0b479ec=
>] (switchdev_port_obj_notify+0x54/0xb8)
[  115.174049]  r6:00000000 r5:1021bd52 r4:c1104c48
[  115.178670] [<c0b47998>] (switchdev_port_obj_notify) from [<c0b47af4>] =
(switchdev_port_obj_add_now+0xa4/0x118)
[  115.188675]  r5:e71ede73 r4:c1104c48
[  115.192254] [<c0b47a50>] (switchdev_port_obj_add_now) from [<c0b47b8c>]=
 (switchdev_port_obj_add_deferred+0x24/0x70)
[  115.202698]  r9:c11c50f0 r8:00000000 r7:00000100 r6:e71fd800 r5:e6932dd=
0 r4:e6932dc0
[  115.210450] [<c0b47b68>] (switchdev_port_obj_add_deferred) from [<c0b47=
7e0>] (switchdev_deferred_process+0x84/0x118)
[  115.220978]  r7:00000100 r6:c12332ac r5:c11bc818 r4:e6932dc0
[  115.226643] [<c0b4775c>] (switchdev_deferred_process) from [<c0b47890>]=
 (switchdev_deferred_process_work+0x1c/0x24)
[  115.237085]  r7:ead92200 r6:ead8f100 r5:e909f380 r4:c11bc83c
[  115.242751] [<c0b47874>] (switchdev_deferred_process_work) from [<c0144=
dac>] (process_one_work+0x1ac/0x4bc)
[  115.252499] [<c0144c00>] (process_one_work) from [<c0145b8c>] (worker_t=
hread+0x5c/0x580)
[  115.260597]  r10:c1103d00 r9:00000008 r8:ffffe000 r7:ead8f118 r6:e909f3=
94 r5:ead8f100
[  115.268427]  r4:e909f380
[  115.270965] [<c0145b30>] (worker_thread) from [<c014ba18>] (kthread+0x1=
68/0x170)
[  115.278368]  r10:ea13fe74 r9:c0145b30 r8:e909f380 r7:e71ec000 r6:000000=
00 r5:e910bf00
[  115.286199]  r4:e910bf40
[  115.288737] [<c014b8b0>] (kthread) from [<c01010e8>] (ret_from_fork+0x1=
4/0x2c)
[  115.295961] Exception stack(0xe71edfb0 to 0xe71edff8)
[  115.301014] dfa0:                                     00000000 00000000=
 00000000 00000000
[  115.309197] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000=
 00000000 00000000
[  115.317379] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
[  115.323997]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:000000=
00 r5:c014b8b0
[  115.331827]  r4:e910bf00
[  115.334363] Code: bad PC value
[  115.337583] ---[ end trace 3bdbb989816b27f4 ]---

regards Frank

