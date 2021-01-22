Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6F22FFBC1
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 05:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbhAVEeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 23:34:46 -0500
Received: from mail-dm6nam12on2134.outbound.protection.outlook.com ([40.107.243.134]:6465
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbhAVEeo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 23:34:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkNjczZsza+5Z+x3uw4Y4XMxaVBNTtZ7E1trFXpGZTMyKCBQEt2cDFw6+ugydKnKQqfqBHX42Su2fqTyRdXU+UFB6xyVlsGEL4kz9g4zBkRTmDzyIeAAqkuf/3RJ+XaA5NdgD0JQFaHix41y7aca6ZVwmYGVHJydyclrsMjlymA3RbGBhAgf7KgE1tp7tHQKNPpstabqf8oHZnGKLIJA0VVfUk47N9d9nGdGHeFMp4uc3g2cW8jzOspwy3kEqHIPWuuzH4S/iozJbPab5c4ojQ+y61bF/5dsfFNx2lrMlSrBwTN+VxP2L/RnHqMVThJxr6q3X8gUraSloC5MPEFQuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93bViU8teq09TYwU3n2PtS//Wsa3NcszbERBUAgomkE=;
 b=dK9GgBZExUweXPY8qBouFOPwIIPi6kHeMAA78SZ0WU6mLAvMf74xB/HKhvquJqtlu909aWnnz8hivDn4ExXBYWNb3MhfGS/KGM/4+vAn/nyizuSJ7t1IH2L28pmLKRaEBw9AZ00HEpRVXJz0aZPbTAV6MOX0gazBWmQIqgBE27NeTb75Uc7nXUsh4mYTNxC7LAf5gxpIrqSkobDD5NZXQQ2YakiC4AwYpb5wnN8NyieuMxrvqdfT1T+aMBOQRumO4vHVpisLBkmOGr9pjM2NvVeFKhIHkYduOs0mA0wYfWRfXt/5sJJqk/pbIEn+B6qaRGhRkbCAKOiOU38nQqqXPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93bViU8teq09TYwU3n2PtS//Wsa3NcszbERBUAgomkE=;
 b=t5nWgjVFB758k5521vXJ+H0lYWCUKi+W5dLXl+/qNdvbiKNu6CQUn9s5CrW6avqi+oe7iR42qpfrDSVDPsuLbaBUh+Sftv1IhUN3PhgcZLTIyd1MHtusu8csfY9+LCpuu9synGxLiQz7LYEzX3ommM2HV+JOU4338AHZFM+Z5YE=
Received: from CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11)
 by CH2PR22MB2005.namprd22.prod.outlook.com (2603:10b6:610:8a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 22 Jan
 2021 04:33:56 +0000
Received: from CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::84e0:d3bf:c39c:43dd]) by CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::84e0:d3bf:c39c:43dd%4]) with mapi id 15.20.3763.014; Fri, 22 Jan 2021
 04:33:56 +0000
From:   "Gong, Sishuai" <sishuai@purdue.edu>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [Race] data race between dev_ifsioc_locked() and
 eth_commit_mac_addr_change()
Thread-Topic: [Race] data race between dev_ifsioc_locked() and
 eth_commit_mac_addr_change()
Thread-Index: AQHWxyxGv+10UJrOLUG73NkqTMaUaKozYTwA
Date:   Fri, 22 Jan 2021 04:33:56 +0000
Message-ID: <DE84C07A-ABA3-431E-9ED4-874DCD3055EC@purdue.edu>
References: <F35A5D81-F42C-49BC-9F0B-94563C5B7436@purdue.edu>
In-Reply-To: <F35A5D81-F42C-49BC-9F0B-94563C5B7436@purdue.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [66.253.158.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 289cc6b5-ef31-4686-9c8a-08d8be8eee50
x-ms-traffictypediagnostic: CH2PR22MB2005:
x-microsoft-antispam-prvs: <CH2PR22MB2005B332457FED6900EAD4EFDFA00@CH2PR22MB2005.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SVKrMONnd2YUPXYtaJNc4869/bQNrBXIzqjFAYIM0cHqBI74Owdu0oFJcae/M0vQSy+VpuWRiNb3mk33TKvVR4GV67ycfAbZR45cc62QiDew3gwTxPG6Ibjyvs8i3PFdpv3J4CIiopX497Bays04PCzLYaFyTg+Y5jzXszLFXzg+HJ1dlnLUPOtgiGHw74IoL8UmwQ56WB9Z6dDx3bMB3G99o5vX9lO3VeBB1sCSCvEVjAfu/j5CuqUrNZ0P0QY+OdaPYPVrSW8Jg6RAwbXA+a91eQWbizJOeA5cc6xRsWuF6tHKzRQ7V3yjpCowAGEv3nzxwthJ8Z3MnQbEzxh6zE2pS4fvXQa8eCgEv+V3YomQe5/bJkLfKB3A/2pptU3i/mYcxOzMwPU8JXZSN72fCDd22jtGSmhtNQ8XP1X5pzpsqA1dsr7VZnZBm/jBiJzDOZjnT80blylQeMay4kV1Yi7/UMoX/2dj/+o4oayBYKGQ9/myhHtoTPJJQHH+tvObTD35fNhVSWzwItUUS300hBzRj0IF7Edenl5ln5mzA2EdjF7IwnkImruNyC+dqE6cficvG1zQyW+6wQ1HUPD/Jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR22MB2056.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(316002)(6506007)(786003)(83380400001)(86362001)(64756008)(2616005)(66946007)(75432002)(36756003)(71200400001)(2906002)(53546011)(76116006)(478600001)(186003)(6486002)(33656002)(8676002)(66556008)(6512007)(5660300002)(4326008)(8936002)(66476007)(6916009)(26005)(66446008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CV2x5M42OB8b/LLMDucNUUltXFOIEuonsLyirZMhfh0EkD1IXh6V4PV6MLIx?=
 =?us-ascii?Q?9yacZg5MEFdaDxCoBt4P5Sd0hn1wYKDttzcQvgdL4x+OxRV6vyoLWuxdEFSo?=
 =?us-ascii?Q?BMMTOIFNaGUzuE9m3XRHr3qYHN3NsxtQb0ZS6VX2d/ofKj3OxzmCZy+/lIxZ?=
 =?us-ascii?Q?ySLXLZBsK0pXgMyVSKkQoZJnZ1S/7uiZ4XkcuOIVgEh408blNqcEeDgRFLfi?=
 =?us-ascii?Q?5gkAeMFCWiBzqi8dbNdXNHpxAEXBTcPHgbE1J4dZtMcfia4WH1beaelK/Jry?=
 =?us-ascii?Q?OPnQNz9Dah0HU5fz96xJk7NnEGWVVY5DfDt+mn8zHX8ZdFhawqTqe10C5IcT?=
 =?us-ascii?Q?nlh3ucO/yXqNThSdRdLaQgWKf3JxyZeuqPiet4lJJMmyPzSJU9fbC36J5srY?=
 =?us-ascii?Q?HN005QrpBAxlcF526S/vzkG+rHhkHrjFqR0eDfWcW2iJ6lvTYzCWp4O7o4Dz?=
 =?us-ascii?Q?VW+r8Mhm/fmV2iLBmKEfdStglH4FvNjrA3Xsgnn84ERLHJWa0izy08zN7giJ?=
 =?us-ascii?Q?RYgm946Pl/7pZNcDRM8wpZrDcL9E24vRs7OlyzOZ6g0Fj8Dz2WjbwPQEEaFL?=
 =?us-ascii?Q?qCQ08QctNIF99DH3LTgAj/v/NNK2XF5l/BXk3XECJjgIGX99j7GCY8itepEE?=
 =?us-ascii?Q?oOXc1ddECuNs9kvtGRnVZq7NJY++uDmIy3j38Af4yCwm4JrkR8/ekRx4w3HP?=
 =?us-ascii?Q?e57tuVw4VHeKUYTRw7p8FYkTPFq9L4cwLa6FpcCIUjU5VKlZjlKaC0xU7JTe?=
 =?us-ascii?Q?YUUszWubZUJ3i71w0GF8SItXCRaNXfe9y2bxXC0MDv67ckKAmCMJ/23oVKig?=
 =?us-ascii?Q?LihWjcODHcpsZwthida4931FDv386QZUIrYHo4OEVx6VHc762E/+ii2UahqO?=
 =?us-ascii?Q?ftoVTJ7lmAgQahBywcci3mugAQD0pt+1yGLe6qBU1yuXbJq3qoCYNhxQK+Iq?=
 =?us-ascii?Q?l4zf4IldGbGRabMYKHfiYtQL8/igtkokV9JOJwlpttadIiHv4iemZBGuFD/U?=
 =?us-ascii?Q?bxQ1?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <81ED32E8CFB6F248886643B987CACCEA@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR22MB2056.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 289cc6b5-ef31-4686-9c8a-08d8be8eee50
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2021 04:33:56.5161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W9WuiAhaJYGCDqhvZuvoYlfktz6VrVq73ecJE/C/qZaCFYYctQMpGmBpe6xRP6rXR+SW6B1RD10LcECL48EmTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR22MB2005
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We found this data race can corrupt the variable ifr->ifr_hwaddr.sa_data as=
 only partially updated, so it should be harmful.

Under the following interleaving, the writer and reader from these 2 memcpy=
() can interleave with each other on the variable dev->dev_addr. Thus, ifr-=
>ifr_hwaddr.sa_data may end up being only partly updated and passed to user=
space as the return value of the syscall.

Thread 1													Thread 2
// eth_commit_mac_addr_change()
memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
														// dev_ifsioc_locked() inside rcu_reader_lock()
														memcpy(ifr->ifr_hwaddr.sa_data, dev->dev_addr, min(sizeof(ifr=
->ifr_hwaddr.sa_data),(size_t)dev->addr_len));

Thanks,
Sishuai

> On Nov 30, 2020, at 10:20 AM, Gong, Sishuai <sishuai@purdue.edu> wrote:
>=20
> Hi,
>=20
> We found a data race in linux kernel 5.3.11 that we are able to reproduce=
 in x86 under specific interleavings. Currently, we are not sure about the =
consequence of this race but it seems that the two memcpy can lead to some =
inconsistency.
>=20
> ------------------------------------------
> Writer site
>=20
> /tmp/tmp.B7zb7od2zE-5.3.11/extract/linux-5.3.11/net/ethernet/eth.c:307
>        298  /**
>        299   * eth_commit_mac_addr_change - commit mac change
>        300   * @dev: network device
>        301   * @p: socket address
>        302   */
>        303  void eth_commit_mac_addr_change(struct net_device *dev, void =
*p)
>        304  {
>        305      struct sockaddr *addr =3D p;
>        306
> =3D=3D>    307      memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
>        308  }
>=20
> ------------------------------------------
> Reader site
>=20
> /tmp/tmp.B7zb7od2zE-5.3.11/extract/linux-5.3.11/net/core/dev_ioctl.c:130
>        110
>        111      switch (cmd) {
>        112      case SIOCGIFFLAGS:  /* Get interface flags */
>        113          ifr->ifr_flags =3D (short) dev_get_flags(dev);
>        114          return 0;
>        115
>        116      case SIOCGIFMETRIC: /* Get the metric on the interface
>        117                     (currently unused) */
>        118          ifr->ifr_metric =3D 0;
>        119          return 0;
>        120
>        121      case SIOCGIFMTU:    /* Get the MTU of a device */
>        122          ifr->ifr_mtu =3D dev->mtu;
>        123          return 0;
>        124
>        125      case SIOCGIFHWADDR:
>        126          if (!dev->addr_len)
>        127              memset(ifr->ifr_hwaddr.sa_data, 0,
>        128                     sizeof(ifr->ifr_hwaddr.sa_data));
>        129          else
> =3D=3D>    130              memcpy(ifr->ifr_hwaddr.sa_data, dev->dev_addr=
,
>        131                     min(sizeof(ifr->ifr_hwaddr.sa_data),
>        132                     (size_t)dev->addr_len));
>        133          ifr->ifr_hwaddr.sa_family =3D dev->type;
>        134          return 0;
>        135
>        136      case SIOCGIFSLAVE:
>        137          err =3D -EINVAL;
>        138          break;
>        139
>        140      case SIOCGIFMAP:
>        141          ifr->ifr_map.mem_start =3D dev->mem_start;
>        142          ifr->ifr_map.mem_end   =3D dev->mem_end;
>        143          ifr->ifr_map.base_addr =3D dev->base_addr;
>        144          ifr->ifr_map.irq       =3D dev->irq;
>        145          ifr->ifr_map.dma       =3D dev->dma;
>        146          ifr->ifr_map.port      =3D dev->if_port;
>        147          return 0;
>        148
>        149      case SIOCGIFINDEX:
>        150          ifr->ifr_ifindex =3D dev->ifindex;
>=20
>=20
> ------------------------------------------
> Writer calling trace
>=20
> - __sys_sendmsg=20
> -- ___sys_sendmsg=20
> --- sock_sendmsg
> ---- netlink_unicast
> ----- netlink_rcv_skb
> ------ __rtnl_newlink
> ------- do_setlink
> -------- dev_set_mac_address
> --------- eth_commit_mac_addr_change
>=20
> ------------------------------------------
> Reader calling trace
>=20
> - ksys_ioctl
> -- do_vfs_ioctl
> --- vfs_ioctl
> ---- dev_ioctl
>=20
>=20
>=20
> Thanks,
> Sishuai
>=20

