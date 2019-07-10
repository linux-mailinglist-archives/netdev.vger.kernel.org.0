Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E0B64478
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 11:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfGJJgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 05:36:49 -0400
Received: from mail-eopbgr10057.outbound.protection.outlook.com ([40.107.1.57]:2048
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbfGJJgs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 05:36:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3GtCSjbPJ/wD+Hofw7xtXdPpKVyp1ITyLPAjWW3gqqQ=;
 b=oKxo33j2vSbrSdylJXXaU6UsDjNg1+HYbGJs/pwwqEpOl1oYz+AtBANesR3d7qv5lAzZk/cAa3jJnneS2rhoUKGwRU7F/3UXmyogSRN5hmqEK2So1+GM6Nz02uaCGkFSIJjjLElY6/6pjPYB/ioSPke63asLvdJhy3QDRK2RTNM=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6454.eurprd05.prod.outlook.com (20.179.7.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Wed, 10 Jul 2019 09:36:42 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::4923:8635:3371:e4f0]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::4923:8635:3371:e4f0%3]) with mapi id 15.20.2052.020; Wed, 10 Jul 2019
 09:36:42 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Stefan Lippers-Hollmann <s.l-h@gmx.de>
CC:     David Miller <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH net v2] Validate required parameters in
 inet6_validate_link_af
Thread-Topic: [PATCH net v2] Validate required parameters in
 inet6_validate_link_af
Thread-Index: AQHVD6AFTi+u8kJV8UmGG73D0HNr46Z3hAkAgEpDN4CAAh9xAA==
Date:   Wed, 10 Jul 2019 09:36:41 +0000
Message-ID: <929f7f20-d266-0cc6-fbba-4a77f5c1e306@mellanox.com>
References: <20190521063941.7451-1-maximmi@mellanox.com>
 <20190522.120748.42244348495685617.davem@davemloft.net>
 <20190709031135.123a5b19@mir>
In-Reply-To: <20190709031135.123a5b19@mir>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0902CA0060.eurprd09.prod.outlook.com
 (2603:10a6:7:15::49) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac8cb0cf-c558-4293-ec3f-08d7051a1d43
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6454;
x-ms-traffictypediagnostic: AM6PR05MB6454:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <AM6PR05MB6454C2A7D179FA5CABFA8110D1F00@AM6PR05MB6454.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(199004)(189003)(8676002)(476003)(486006)(446003)(11346002)(76176011)(25786009)(6306002)(81156014)(53546011)(6512007)(68736007)(8936002)(2906002)(6486002)(6246003)(107886003)(26005)(36756003)(66066001)(52116002)(4326008)(54906003)(2616005)(81166006)(31686004)(316002)(102836004)(6506007)(386003)(186003)(966005)(99286004)(15650500001)(478600001)(71200400001)(66946007)(53936002)(86362001)(14454004)(5024004)(14444005)(229853002)(256004)(31696002)(66476007)(66556008)(66446008)(64756008)(6116002)(305945005)(6436002)(3846002)(5660300002)(6916009)(71190400001)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6454;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XMY8ise94bB6inPnlwol1PWjvIpH0kyY5PehKVdWEJCJXtgmBOopILiBldOCfKDpqc5pUjk8iY8XA/aRDJFNeH/UgjNmL5U4QHqmb2xA5U/5sskaawZ9y7V41oJWs7CojoRCeZ70gmw0X+L3VXI2mzXPL2My4Rxy6Yn5ctGVGs5axi1qvcP/plYxHkKo1MS2j0FBLzS3mJrJl2q6+SkowKC6TM5xKpAlL4b8mfHgqErxflA3mxWRQ7v7s3RYELW9Cy0/20IWVutOJgMBNjucvik0aVj4M57HtbQcF6uxD9PKp+cY+uy/7UN1E9VTBxLVyX9ik5AeNtdRpkAaB5i9JNVvOWdy44QPXz4ZJme5jW7QSrx42TReiO+82sEVjhY43xunF6Mqhiq8Go6RrthbWLlg96yUSr8+LUbCCWFzNKY=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <452F1DCCB69C4D469F1035F1E7BF775C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac8cb0cf-c558-4293-ec3f-08d7051a1d43
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 09:36:41.6442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6454
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-07-09 04:11, Stefan Lippers-Hollmann wrote:
> Hi
>=20
> On 2019-05-22, David Miller wrote:
>> From: Maxim Mikityanskiy <maximmi@mellanox.com>
>> Date: Tue, 21 May 2019 06:40:04 +0000
>>
>>> inet6_set_link_af requires that at least one of IFLA_INET6_TOKEN or
>>> IFLA_INET6_ADDR_GET_MODE is passed. If none of them is passed, it
>>> returns -EINVAL, which may cause do_setlink() to fail in the middle of
>>> processing other commands and give the following warning message:
>>>
>>>    A link change request failed with some changes committed already.
>>>    Interface eth0 may have been left with an inconsistent configuration=
,
>>>    please check.
>>>
>>> Check the presence of at least one of them in inet6_validate_link_af to
>>> detect invalid parameters at an early stage, before do_setlink does
>>> anything. Also validate the address generation mode at an early stage.
>>>
>>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
>>
>> Applied, thank you.
>=20
> After updating from kernel 5.1.16 to 5.2, I noticed that my
> systemd-networkd (241-5, Debian/unstable) managed bridges didn't
> come up and needed a manual "ip link set dev br-lan up" to get
> configured. Bisecting between v5.1 and v5.2 pointed to this
> patch and reverting just this change from v5.2 fixes the issue
> for me again.

This patch changes behavior only in case of invalid input. If the=20
userspace sends a valid message over netlink, nothing changes after my=20
patch. However, for some subset of invalid inputs, it used to be=20
undefined behavior, and the kernel used to apply partial configuration=20
before it noticed that the input was invalid and failed. After my patch,=20
this subset of invalid inputs is handled properly, resulting in an=20
immediate error returned to the userspace, and no configuration is=20
affected. So, my patch is actually a bug fix.

Unfortunately, commit [1] introduced a regression in systemd, and it=20
started sending invalid input to the kernel, apparently didn't pay=20
attention to the error returned and relied on the undefined behavior=20
(the partial configuration update that took place before my patch).

Later on, commit [2] was introduced, and it should fix that regression=20
in systemd.

What you experience may be explained by this bug in systemd:

1. systemd broke, but the issue remained unnoticed, because some part of=20
the configuration was still applied.

2. The bug in systemd was eventually fixed, but apparently you haven't=20
updated to the version that has this fix yet.

3. My fix for the kernel was merged.

4. As you are using a systemd without fix, the issue led to more severe=20
consequences, because now no configuration is applied after an invalid=20
request from systemd.

I haven't tried to reproduce your configuration though, but I guess the=20
things above are what has happened. I suggest you to update systemd to a=20
version that has commit [2] (or to build it from master if no newer=20
version has been released since then) - I hope it solves your issue.=20
Otherwise, let me know.

[1]:=20
https://github.com/systemd/systemd/commit/0e2fdb83bb5e22047e0c7cc058b415d0e=
93f02cf

[2]:=20
https://github.com/systemd/systemd/commit/4d48747c43922250a62cf6e0ad9ee3646=
65ef82d

> $ git bisect start
> # good: [e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd] Linux 5.1
> git bisect good e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd
> # bad: [46713c3d2f8da5e3d8ddd2249bcb1d9974fb5d28] Merge tag 'for-linus-20=
190706' of git://git.kernel.dk/linux-block
> git bisect bad 46713c3d2f8da5e3d8ddd2249bcb1d9974fb5d28
> # good: [a2d635decbfa9c1e4ae15cb05b68b2559f7f827c] Merge tag 'drm-next-20=
19-05-09' of git://anongit.freedesktop.org/drm/drm
> git bisect good a2d635decbfa9c1e4ae15cb05b68b2559f7f827c
> # good: [22c58fd70ca48a29505922b1563826593b08cc00] Merge tag 'armsoc-soc'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
> git bisect good 22c58fd70ca48a29505922b1563826593b08cc00
> # good: [61939b12dc24d0ac958020f261046c35a16e0c48] block: print offending=
 values when cloned rq limits are exceeded
> git bisect good 61939b12dc24d0ac958020f261046c35a16e0c48
> # bad: [3510955b327176fd4cbab5baa75b449f077722a2] mm/list_lru.c: fix memo=
ry leak in __memcg_init_list_lru_node
> git bisect bad 3510955b327176fd4cbab5baa75b449f077722a2
> # bad: [30d1d92a888d03681b927c76a35181b4eed7071f] Merge tag 'nds32-for-li=
nux-5.2-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/greentime/lin=
ux
> git bisect bad 30d1d92a888d03681b927c76a35181b4eed7071f
> # bad: [dbde71df810c62e72e2aa6d88a0686a6092956cd] Merge tag 'tty-5.2-rc3'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
> git bisect bad dbde71df810c62e72e2aa6d88a0686a6092956cd
> # bad: [100f6d8e09905c59be45b6316f8f369c0be1b2d8] net: correct zerocopy r=
efcnt with udp MSG_MORE
> git bisect bad 100f6d8e09905c59be45b6316f8f369c0be1b2d8
> # bad: [4ca6dee5220fe2377bf12b354ef85978425c9ec7] dpaa2-eth: Make constan=
t 64-bit long
> git bisect bad 4ca6dee5220fe2377bf12b354ef85978425c9ec7
> # bad: [b5730061d1056abf317caea823b94d6e12b5b4f6] cxgb4: offload VLAN flo=
ws regardless of VLAN ethtype
> git bisect bad b5730061d1056abf317caea823b94d6e12b5b4f6
> # bad: [c1e85c6ce57ef1eb73966152993a341c8123a8ea] net: macb: save/restore=
 the remaining registers and features
> git bisect bad c1e85c6ce57ef1eb73966152993a341c8123a8ea
> # bad: [f42c104f2ec94a9255a835cd4cd1bd76279d4d06] Documentation: add TLS =
offload documentation
> git bisect bad f42c104f2ec94a9255a835cd4cd1bd76279d4d06
> # bad: [d008b3d2be4b00267e7af5c21269e7af4f65c6e2] mISDN: Fix indenting in=
 dsp_cmx.c
> git bisect bad d008b3d2be4b00267e7af5c21269e7af4f65c6e2
> # bad: [40a1578d631a8ac1cf0ef797c435114107747859] ocelot: Dont allocate a=
nother multicast list, use __dev_mc_sync
> git bisect bad 40a1578d631a8ac1cf0ef797c435114107747859
> # bad: [7dc2bccab0ee37ac28096b8fcdc390a679a15841] Validate required param=
eters in inet6_validate_link_af
> git bisect bad 7dc2bccab0ee37ac28096b8fcdc390a679a15841
> # first bad commit: [7dc2bccab0ee37ac28096b8fcdc390a679a15841] Validate r=
equired parameters in inet6_validate_link_af
>=20
> While I originally noticed this issue on real hardware (r8169, e1000,
> e1000e, e100, alx) and multiple systems with a slightly complex bridge
> setup, I can reproduce it with a very basic configuration under kvm
> (upon which all the tests below are based):
>=20
> $ cat /etc/systemd/network/20-wired.network
> [Match]
> Name=3Dens4
>=20
> [Network]
> DHCP=3Dyes
>=20
> (same results with just DHCP=3Dipv4)
>=20
> With the above systemd-networkd configuration, the system comes up
> without network access:
>=20
> # ip a
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group=
 default qlen 1000
>      link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>      inet 127.0.0.1/8 scope host lo
>         valid_lft forever preferred_lft forever
>      inet6 ::1/128 scope host
>         valid_lft forever preferred_lft forever
> 2: ens4: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group defau=
lt qlen 1000
>      link/ether 00:16:3e:00:00:00 brd ff:ff:ff:ff:ff:ff
>=20
> # networkctl | cat -
> IDX LINK             TYPE               OPERATIONAL SETUP
>    1 lo               loopback           carrier     unmanaged
>    2 ens4             ether              off         configuring
>=20
> 2 links listed.
>=20
> Manually enabling the interface does help:
>=20
> # ip link set dev ens4 up
>=20
> # ip a
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group=
 default qlen 1000
>      link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>      inet 127.0.0.1/8 scope host lo
>         valid_lft forever preferred_lft forever
>      inet6 ::1/128 scope host
>         valid_lft forever preferred_lft forever
> 2: ens4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast stat=
e UP group default qlen 1000
>      link/ether 00:16:3e:00:00:00 brd ff:ff:ff:ff:ff:ff
>      inet 172.23.6.0/14 brd 172.23.255.255 scope global dynamic ens4
>         valid_lft 43199sec preferred_lft 43199sec
>      inet6 2003:xxxx:xxxx:xxxx::197/128 scope global tentative dynamic no=
prefixroute
>         valid_lft 13809sec preferred_lft 1209sec
>      inet6 fdxx:xxxx:xxxx::197/128 scope global tentative noprefixroute
>         valid_lft forever preferred_lft forever
>      inet6 fdxx:xxxx:xxxx:0:216:3eff:fe00:0/64 scope global tentative mng=
tmpaddr noprefixroute
>         valid_lft forever preferred_lft forever
>      inet6 2003:xxxx:xxxx:xxxx:216:3eff:fe00:0/64 scope global tentative =
dynamic mngtmpaddr noprefixroute
>         valid_lft 13809sec preferred_lft 1209sec
>      inet6 fe80::216:3eff:fe00:0/64 scope link
>         valid_lft forever preferred_lft forever
>=20
> # networkctl | cat -
> IDX LINK             TYPE               OPERATIONAL SETUP
>    1 lo               loopback           carrier     unmanaged
>    2 ens4             ether              routable    configured
>=20
> 2 links listed.
>=20
> A quick test of upgrading all systemd packages to 242-2 from
> Debian/experimental shows the same issue; Debian 10/ buster (stable)
> is shipping with systemd 241-5.
>=20
> DHCPv4 is served by a recent OpenWrt/ master snapshot on ipq8065/ nbg6817
> (ARMv7), using dnsmasq 2.80-13 and odhcpd-ipv6only 2019-05-17-41a74cba-3
> covering DHCPv6 and prefix delegation.
>=20
> Attached are xz compressed versions of the kernel configuration (amd64),
> dmesg and journalctl output.
>=20
> The Debian/unstable VM was started with qemu-kvm 1:3.1+dfsg-8 on a
> Debian/unstable host running kernel 5.2 with this patch reverted:
>=20
> $ QEMU_AUDIO_DRV=3Dpa qemu-system-x86_64 \
> 	-machine accel=3Dkvm:tcg \
> 	-monitor stdio \
> 	-rtc base=3Dlocaltime \
> 	-cpu qemu64,+vmx \
> 	-smp 3 \
> 	-m 4096 \
> 	-device virtio-gpu-pci \
> 	-device virtio-net-pci,mac=3D00:16:3E:00:00:00,netdev=3Dtap-br-lan0 \
> 		-netdev tap,ifname=3Dtap-br-lan0,script=3Dno,id=3Dtap-br-lan0 \
> 	-device AC97 \
> 	-drive file=3D/srv/storage/vm/linux.qcow2.img,if=3Dnone,discard=3Dunmap,=
index=3D0,media=3Ddisk,id=3Dhd0 \
> 		-device virtio-scsi-pci,id=3Dscsi -device scsi-hd,drive=3Dhd0 \
> 	-usb \
> 		-device usb-tablet \
> 		-device usb-ehci,id=3Dehci \
> 		-device nec-usb-xhci,id=3Dxhci \
> 	-device virtio-rng-pci \
> 	-boot menu=3Don
>=20
> Regards
> 	Stefan Lippers-Hollmann
>=20

