Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10F2454574
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbhKQLQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:16:33 -0500
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:42112
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233710AbhKQLQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 06:16:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMPhN4wulEZT0bhdp0onBpQAk+Ia8txRSSb9xvgrq0bCsssTrdktghZJFC/i/VsH5wTGffVPYO5RVkpeBUpz1yHB2cxde2Nj0JT9VG1mJl7LN+b/0mAH5tUHGdyKo8Ct/q4KZSXfstdg3y/WTYr5qUEuYCe3GSurc3XyjFCqPIZdBF/TOmTVcZAcGPQLBLAnrnYzNfecmmzWYH8DpACg6szy+InQGCzwivYhal4WV7AzOe3PXfdu3wLGXacKFYPfD5Bo0SnfeqwiTXtaZ0tSzFujWRxKAtqx2l0f4I0bTGnHs894xX/7XcSQlf9GdiKU0SoR0cBx2FI3D+zKozExyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=styLDeFadgr3pU5mhdw69tcp9iRTQv5TeRGmEYub3Ho=;
 b=a2HXMOlK4eSiuNj4lFjPcuPrLhhz1HHImcTKubAiG2WdhRpIL2nF4b9Ef+GDuiUvd7hHiH+V1KyuWfTia/0/ZGPIJmaBrbVOPWsQNoTX7bmnLH55wr8KOltT0xRHlrfcrRdww84D8RlEAXDqmfP5WYSc3+CDSEI7KAByY6RzXZD0LStCl6LRrZFZZD5k4pqdtNTbrbs6N6or+Nz1Ktv5/JKmSJJmg4P9Y7M3eZF2/jtJZ3Bc33wA2iVljUfH9/g3nEL8PmJuPDpwCAfJf87K9n20defSs13N6jAIAY6wap3kwTXYCJU+2RVD0qwXXb5iQ655e9wejOAR77ofstMpxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=styLDeFadgr3pU5mhdw69tcp9iRTQv5TeRGmEYub3Ho=;
 b=hMxN94Wkbkf+2GTkQhkJoDMs2v8HXLvTrtcvBMLRV+dwqtsT0OgF1j35xlt9USu+9N2NyZuKY44nXk8QRb/dj1BZf97eaFQfYfrVTEHlllSmTKxebpOJ8FqXaxjM2UxKe0EY+X/RIHYK8L7AM2bYEpPTIopF7a7SD/kXGtsLU9Q=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3207.eurprd04.prod.outlook.com (2603:10a6:6:6::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.27; Wed, 17 Nov 2021 11:13:27 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d9c3:a779:c114:afe3]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d9c3:a779:c114:afe3%9]) with mapi id 15.20.4713.019; Wed, 17 Nov 2021
 11:13:27 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jun Li <jun.li@nxp.com>
Subject: NFS break if unplug one when connect two cables 
Thread-Topic: NFS break if unplug one when connect two cables 
Thread-Index: AdfboN5KL9qsyUTWSD+v/jdc9YvrAA==
Date:   Wed, 17 Nov 2021 11:13:27 +0000
Message-ID: <DB8PR04MB679527531E203AE5B3A8FEFAE69A9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 210be4f2-43a5-4b59-d56c-08d9a9bb47b1
x-ms-traffictypediagnostic: DB6PR04MB3207:
x-microsoft-antispam-prvs: <DB6PR04MB320794BEE9CB5A7AD90C6F60E69A9@DB6PR04MB3207.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: or2kMO1Zp/T/QWGoEUcvgYDOFLnTAnU0i0ft9RFNwkTdntbWIB6neJ/NpyUXpsT70wjSLwYbvLMsYBIKhLaIS4VasrAxQn6Olh83avbdDOsVsl6/v0CYMRTAKGW+qPRon/A8qiCzGkcmc5GQAfpo7agCWD/Hw+eFJl92lD/yBifdd/h4rGM+/BYIJ2nshNK2lmPeAKM/jWxAr4VCrppWLzZH150+oQKwJTLizbEN7UCSwXT6Q9sOCdXa7e6cs6drgPnAOuenJ2w4AC6v5RWrbG14uM9Pt4PlH49DLvpqxJ7Um3Mlj1C+8yFhFMsfsRe/z4OTgA0G5Psnd8mayAhkQhEw1oCyHR8+eGuM+OBDBBWqVW9MfZz3DXstVgmcPScKzwg+aaj7fXNVJ3Ulnj0vyX0P+5xnQf4vTPRR/S3eVE/HPWJSYfM7/5LZDAR52RnBVp7d2hrVcFx4M4xGDaJuYyYa1NQ5VtvExe8SPvuUg8CG5hJYKN0FdjIqeMsrutnB8mToA+eewDAYfT9j9dyiibOzo36c762tp88g32REPn/dj+WVHr7k+C3FA9oEHfTLN/f6bQz5R1I5eGSU4JkKxQxEfsbXsLo8ZcbiUschJnmU11DF7WNw5D54VUGxDIxrf+xpBF3c4pr46sI0HDUtFtzYeOhWZNmddZZ6A1zVYr6SMxbpIEd7hU5NE/fcEZUcWSnW77XpblFMRr/k+tYFvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(26005)(66476007)(38070700005)(66946007)(66446008)(2906002)(71200400001)(8936002)(7696005)(86362001)(76116006)(8676002)(4326008)(4743002)(55016002)(64756008)(316002)(122000001)(110136005)(54906003)(66556008)(508600001)(33656002)(5660300002)(186003)(66574015)(9686003)(6506007)(83380400001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JhA9bUEOkRISEWS1XEi7fi2MLSjD3FSFKuUHzg+wdS/Lg2RWzDEhQW0SinFv?=
 =?us-ascii?Q?ueWuqMTe+jb3GI8kp/vHF8gjbqFm2j8qIb3dhLeakpG4Db12el4JJjR6aNXG?=
 =?us-ascii?Q?7s6LHU6wj6T2ZNjm1VZZnjyIVIRylDzYk1ISxVAp9yIMjJx6/V56S5pOrJvu?=
 =?us-ascii?Q?s+B4hMBDcRtMM5x2Uc1z+YPrM6uRqezul/D0FOMFnG29fcKeCaSJoBkt3a3N?=
 =?us-ascii?Q?s4q2mRHynfHcHtnPPC/gWcpvl7ZZnwqbfgbGpIzDc2Hf81QILtIWq5wDJ3Ew?=
 =?us-ascii?Q?2Bm1qElR26Rx4IOKJuVnE+aegtsMc9bGzFUB0QAVHOWPT4qfh9j1d5zssaRL?=
 =?us-ascii?Q?xDJDkPWjllAWnzcM4acvVujPi8803qgi6zBm5pUl4pt4aA0u/9aI1ggeCKrE?=
 =?us-ascii?Q?kQj1MuYOeyf5AQEskRyNT+Ob3mNk62LFAvO50FKDQ4Fac2Ch2dSa97IML0H+?=
 =?us-ascii?Q?9InvsiYwQjPg3aoSpON3WK9Sqkz6hyMV2iye7PPYj4NzvLYLkTWm0YPWZhSm?=
 =?us-ascii?Q?0u2f8Iqq+RECmunEirw+X8qT/azL2Pm2U4ZexAOndxmh38cxpHOICENv+0h5?=
 =?us-ascii?Q?MsGbMGhUUfNbUVUIfAnYSrmvyf70E7ggkeMIxrPw0WYogWuW+O2BJN3X/xdc?=
 =?us-ascii?Q?nwK5y9IeDpLQd3TcNtDHuhfdWwx8bMV+UvRQun2bzY/eym6ffMTNsz0ig2eB?=
 =?us-ascii?Q?QduscrUyFFJMzwTOZ2NK1gYR7YJU1b4TKsoKbW6tIMO1JYy3LUWGPoGqJe2n?=
 =?us-ascii?Q?bJyn4PsT3pFqHLbxEhZoOsbCGUo+ZMAyeXUGrjWbLNVNJiulNPECtKsGvNAN?=
 =?us-ascii?Q?hp3iUhVP6y+IdQokt4bGjT5Al8VukwciSCQ1u+FuO7vG35exdNTTTF4I6UUe?=
 =?us-ascii?Q?LURRqfR7fdTyVqlsBeKJmInevauZcjXhi+GzRWZdaapVKjgN3638bBrnUBQh?=
 =?us-ascii?Q?c08cnDiSvqsNuZA3NTeT1pi36ynzk9ZUx9S42Nt3GBQNNWsH7NHIkLXtol54?=
 =?us-ascii?Q?gbW7QfS7Ey7eIYtm3rAt+R0/TQHNVzU9DF2rVHwHhNrWpZjRiSJuZKQ+PZFV?=
 =?us-ascii?Q?U3DF7aX0pKEJbFMLbWWznbFFP0JguXWC2blEDoH//SM/7k8pHra06wafhVkZ?=
 =?us-ascii?Q?OLhXQPLlZLGYQRvWV0ejp8TkCEmo4SjeW1m1aVkfMI0ZoQ1/fTBYJycoUKL/?=
 =?us-ascii?Q?XxLfoOHYE0Exmu9UeAFUFujvFXKSQF68sCs6Zf2vo/rMsnhnMWwbcDH4XNcO?=
 =?us-ascii?Q?w1DYDA5XSc3i0lx2NpdbLVpPX9bPGoKTtVLMdQTyEdAdT9KzvdNGoUFeOmWe?=
 =?us-ascii?Q?W8m3RW59B1awlj1DHl2479ZEZqwSzW4hdUuXgZtrZ4SUFBZyvKU7hhTyiicM?=
 =?us-ascii?Q?NfKZONu7PSSs4JJRKgAukKFQxJW8/Iuff9Eqd8S+uKnnINdvx8+WUmZ5RgYH?=
 =?us-ascii?Q?C2PmXigywmzkbRHCpRIKknTK+iCAcW3jDHLrXzpCdKKNUIjQ0piIbjWu/2ow?=
 =?us-ascii?Q?BsKb9/MPu7JPjn7x4TobZoPB+nMk72QHEbtVq6O3SKkQURD5JTYknl93Atk4?=
 =?us-ascii?Q?LLOLkOMKc6PssDFepDMcgopSmRMJnuaD+TUfxa7/cqK2LBvPlHS7XoeDJ7Q/?=
 =?us-ascii?Q?Zg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 210be4f2-43a5-4b59-d56c-08d9a9bb47b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 11:13:27.5266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OiowcOCuoYEBP7m60IkZ4WD6plZKMbSNTbY2NNbqkOPibdy/o1G2ysv5ZOc1DgOCczO/KrKPsTiuN8OT1X47Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3207
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi community guys,

I encountered a NFS issue at my side, which bothering me much, could you he=
lp me if you have some ideas? That would be appreciated if you have some in=
sights. :-)

---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
---------------------------------------
Environment:
	1) A board with two ethernet controllers, eth0 is FEC, eth1 is STMMAC.
	2) plugged two cables in the same router.
	3) NFS is Yocto.

The kernel boot log, we can see that NFS mount via eth0.
[    8.860717] Sending DHCP requests ., OK
[    9.009096] IP-Config: Got DHCP answer from 10.193.102.254, my address i=
s 10.193.102.150
[    9.017377] IP-Config: Complete:
[    9.020737]      device=3Deth0, hwaddr=3D00:04:9f:06:e2:97, ipaddr=3D10.=
193.102.150, mask=3D255.255.255.0, gw=3D10.193.102.254
[    9.032123]      host=3D10.193.102.150, domain=3Dap.freescale.net, nis-d=
omain=3D(none)
[    9.039614]      bootserver=3D0.0.0.0, rootserver=3D10.193.108.176, root=
path=3D
[    9.039625]      nameserver0=3D165.114.89.4, nameserver1=3D134.27.184.42

After NFS mounted, I dump the below info:
~# cat /proc/cmdline
console=3Dttymxc1,115200 root=3D/dev/nfs ip=3Ddhcp nfsroot=3D10.193.108.176=
:/home/nfsroot/imx8mpevk,v3,tcp

~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group d=
efault qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group=
 default qlen 1000
    link/ether 00:04:9f:06:e2:97 brd ff:ff:ff:ff:ff:ff
    inet 10.193.102.150/24 brd 10.193.102.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::204:9fff:fe06:e297/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,DYNAMIC,UP,LOWER_UP> mtu 1500 qdisc mq state =
UP group default qlen 1000
    link/ether 00:04:9f:06:e2:98 brd ff:ff:ff:ff:ff:ff
    inet 10.193.102.85/24 brd 10.193.102.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::204:9fff:fe06:e298/64 scope link
       valid_lft forever preferred_lft forever
4: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN group default qlen 10
    link/can

~# ip route
default via 10.193.102.254 dev eth0
10.193.102.0/24 dev eth0 proto kernel scope link src 10.193.102.150
10.193.102.0/24 dev eth1 proto kernel scope link src 10.193.102.85
10.193.102.254 dev eth1 scope link
134.27.184.42 via 10.193.102.254 dev eth1
165.114.89.4 via 10.193.102.254 dev eth1

The issue is:
	1) unplug the eth1 then re-plug, NFS can't turn back.
	2) unplug the eth0 then re-plug, NFS can turn back.
My queston is that why unplug the eth1 would break the NFS? Is it a NFS lim=
itation?

---------------------------------------------------------------------------=
---------------------------------------------------------------------------=
----------------------------------------------
To figure out it, I tried below two approaches.

1) As you can see, eth0 and eth1 are in the same subnet, may this lead to t=
his issue? Firstly I connect eth1 to another board. After NFS mounted,
all is well, but minitues later, the NFS break, I supposed the reason is et=
h1 get a local ip which belong to another subnet. So what I can conclude
here is that, NFS still can work if eth0 and eth1 are in the same subnet, m=
eanwhile I didn't unplug eth1, but for different subnets, NFS can't work di=
rectly.
So this issue is not related to the same subnet.

2) I thought it should not be a kernel issue, may caused by userspace, so I=
 disable the network service.
	~# systemctl disable systemd-networkd.service
	~# systemctl disable connman.service
  I repeated the operation, after NFS mounted, only eth0 is up since I disa=
ble the network service, so I manually up the eth1 and use udhcpc to get th=
e ip.

~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group d=
efault qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group=
 default qlen 1000
    link/ether 00:04:9f:06:e2:97 brd ff:ff:ff:ff:ff:ff
    inet 10.193.102.53/24 brd 10.193.102.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::204:9fff:fe06:e297/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group=
 default qlen 1000
    link/ether 00:04:9f:06:e2:98 brd ff:ff:ff:ff:ff:ff
    inet 10.193.102.85/24 brd 10.193.102.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::204:9fff:fe06:e298/64 scope link
       valid_lft forever preferred_lft forever

~# ip route
default via 10.193.102.254 dev eth0
default via 10.193.102.254 dev eth1 metric 10
10.193.102.0/24 dev eth0 proto kernel scope link src 10.193.102.53
10.193.102.0/24 dev eth1 proto kernel scope link src 10.193.102.85

Now I unplug the eth1, the NFS still can work. For this experiment, this is=
sue seems related to network service.
What I suspected is that route changed by network service when unplug the e=
th1 or the original route has some limitation?
I compare the route with and w/o network service enabled.

Network service enabled:
~# ip route
default via 10.193.102.254 dev eth0
10.193.102.0/24 dev eth0 proto kernel scope link src 10.193.102.150
10.193.102.0/24 dev eth1 proto kernel scope link src 10.193.102.85
10.193.102.254 dev eth1 scope link
134.27.184.42 via 10.193.102.254 dev eth1
165.114.89.4 via 10.193.102.254 dev eth1

Network service disabled:
~# ip route
default via 10.193.102.254 dev eth0
default via 10.193.102.254 dev eth1 metric 10
10.193.102.0/24 dev eth0 proto kernel scope link src 10.193.102.53
10.193.102.0/24 dev eth1 proto kernel scope link src 10.193.102.85

Why only one route item towards "default" when network service enabled, but=
 there are two items when network service disabled?

I have little knowledge about this scope, do any one know more?

Best Regards,
Joakim Zhang

