Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59EB578019
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 17:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfG1PW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 11:22:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41726 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbfG1PW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 11:22:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6SFB8Ci006303;
        Sun, 28 Jul 2019 08:22:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=cSQVJyW/9AM5hIgpy6ngWzW8XX1h7ZEjtVAMF/yPE3U=;
 b=Iym8ONwLk3+StmpHXKyTaf3OFXoF+/pSVgQRc8M1Zs6YZXc1nXwPC8mOHSKegAf/LbsT
 6Zv6wQUMqsEG9ec8RpYtqAhACjNHDWM201qCSu24npZZhwYXpYNYiuUS8A3XLoO8LuKR
 Sv1cFvd6suBcmeMpbEtvQgmtga4ZFcTW4anDeaSpei4q+z/v+/0WbDF9u/GNoZ4ZIjGt
 ydSg7LlKZoK+RCBeTVARVmYh429g5GudJnIUHQAE/LW6jQaNNA4RsAmfKUNQ/q9lT8CS
 dq/WcvqQiEz4wOJNSqZ22kvSJNR+FMwMO7E0shSK63b4vv/tNmw4gpThuVis+2ebgE7K gw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2u0kypvpwp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 28 Jul 2019 08:22:18 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 28 Jul
 2019 08:22:17 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.53) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 28 Jul 2019 08:22:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+IMgqxlwCP/VbK4BZ1ds8PgjakjldHwAV8k/kaYH6tlBhWYLpgz8UtZNtsH0xZATn3HvL8hcmlRtbruW69QJ2NfXqzeqTi1OnfaLES3KQKrlouCW2fy+TS9nL7Nlb3TTAEUxIGp9ai7Sa0ti5v+4z/lZZn002w+vzI1/lfZW5VEq5Fs1UdQoQh40V33zB00Gs/zD+fv7wAQv2zWX3Bu3YS1jGBwNyQ1ywR8VmGYENvXzyGbIBw9CLQfrzzUbIDRxKUT0X91qmhbHYwdoz57jY8xtwr3T7CRApgYHiVxu5h1x0WoyY4NV/jTzrMXEnZnIL44f5LrFP/WTanOlCKeBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSQVJyW/9AM5hIgpy6ngWzW8XX1h7ZEjtVAMF/yPE3U=;
 b=GzgQCrvDM95bxDJ9kMxXbpJWO7ulGUbKPb215C8PZm4LlJKCV+2gOG6G7YOBg5qlVhXVMsoT3XC6NdGoYnXw4g3Dr9tTAJY+PmceTo8FZ/2aVsSnZeCynNjG1WF2/4zdd6SAxon12yCztXcFSkgJn+19LZigYdr3poM5Yc1TFSir9wKaTRPUYlvq7Zgn9gzSG2NdkYHjOIa+zAlsUrqCf9QO6ifehpHp/tzTqhB5MTRIYBaK/rzmSYvOP66SVnLw6QBMRKroD5Ul/CwdpuzeVebLVgzM2MpQZaNlyPkWKi3Z+e1l3iyRwFxKVLlrBJeBHJGvo5KICjsn0c6pK9mLUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSQVJyW/9AM5hIgpy6ngWzW8XX1h7ZEjtVAMF/yPE3U=;
 b=Lxc6Y/uCa1QEVbbXGxVcOW4IvMQbDkbELgmy3x7nZxrPnDZdXpc6Pc5Eohw0BmxLRNNtZ9h5giGCLd8svqEG6LjmSX2mzUXyJgk3/TuiDN/DVov5/Siu2rRXByLMUXNxYBX21EgVgIx6vnCGagOKoi/8LzkORoMZ2Rvx0wMtXHM=
Received: from MN2PR18MB2367.namprd18.prod.outlook.com (20.179.80.88) by
 MN2PR18MB2575.namprd18.prod.outlook.com (20.179.82.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Sun, 28 Jul 2019 15:22:16 +0000
Received: from MN2PR18MB2367.namprd18.prod.outlook.com
 ([fe80::11cf:da10:eafc:649d]) by MN2PR18MB2367.namprd18.prod.outlook.com
 ([fe80::11cf:da10:eafc:649d%6]) with mapi id 15.20.2115.005; Sun, 28 Jul 2019
 15:22:16 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Matteo Croce <mcroce@redhat.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "Maxime Chevallier" <maxime.chevallier@bootlin.com>
CC:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [EXT] Re: [PATCH net-next] mvpp2: document HW checksum behaviour
Thread-Topic: [EXT] Re: [PATCH net-next] mvpp2: document HW checksum behaviour
Thread-Index: AQHVQ7GqDF03fYQcLEmrZeT3Zv1deKbfQmCAgADYSwCAAAuFMA==
Date:   Sun, 28 Jul 2019 15:22:16 +0000
Message-ID: <MN2PR18MB23674C19A0AF33951791F0F0B0C20@MN2PR18MB2367.namprd18.prod.outlook.com>
References: <20190725231546.23878-1-mcroce@redhat.com>
 <20190726125715.GB5031@kwain>
 <CAGnkfhycOc8mvqeQDBcnXueUjrFQMC7hdfAOkxr5k0+xc_tnDw@mail.gmail.com>
 <CAGnkfhz+PezeLT+gyXdsnyJz2dnKpYkcb2HbqvXJoLdzNxuC6g@mail.gmail.com>
In-Reply-To: <CAGnkfhz+PezeLT+gyXdsnyJz2dnKpYkcb2HbqvXJoLdzNxuC6g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad9a3a4b-aad1-41bb-abcf-08d7136f5fa6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2575;
x-ms-traffictypediagnostic: MN2PR18MB2575:
x-microsoft-antispam-prvs: <MN2PR18MB25750C61608BACF67CA6510FB0C20@MN2PR18MB2575.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01128BA907
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39850400004)(136003)(346002)(376002)(199004)(189003)(53754006)(52536014)(186003)(66066001)(76116006)(305945005)(7696005)(53936002)(26005)(446003)(5660300002)(6246003)(102836004)(486006)(54906003)(110136005)(74316002)(6506007)(76176011)(99286004)(66946007)(11346002)(316002)(4326008)(7736002)(476003)(66446008)(64756008)(66476007)(66556008)(14444005)(256004)(33656002)(229853002)(6436002)(3846002)(71200400001)(8676002)(6116002)(71190400001)(68736007)(14454004)(81156014)(81166006)(2906002)(8936002)(478600001)(9686003)(25786009)(86362001)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2575;H:MN2PR18MB2367.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HnpDqfZ/eVLPjQ5izJF0MR98rjxYUGtMnYjgSYl3D+y9yV55av/dl0w2VnYHnnqfhgMGFYFWX7YAZfeMfPi8qCQ2+JLiCZ7HjZbL25epuerGqeXHcS/6VT0TqOiA/O4krji9WkQ/OVgAims1W8KlZNS0QYIaIaRPUliMnTMTYxdHBRrROD6+Gu9gtjgKR1E20ATt88RmDCRyAopwR+gbJoB7KEVpj+ygj/rkKADRKKpUG/jNTtkuP3fpfhjPyt6uAZcGrZgCTYqLEsqAQEcYv0GJuczgM7cqf1QHDFeVdyXx46wpFzO01/Rd0ic9uObaqVBTAZceaHN+3EsfsWvlpKgITLZ5bXVJtRQ1s1XL6FBsve9sEmBDYjK9TU26w2/+KhPNmt8yPgJcpHa+9qsvQCVzd/3NDaADAlDKF8iKhwo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ad9a3a4b-aad1-41bb-abcf-08d7136f5fa6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2019 15:22:16.2301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: stefanc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2575
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-28_10:2019-07-26,2019-07-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi all,
>=20
> probably dev->vlan_features is safe to keep the CSUM features to avoid
> unnecessary calculation in some cases, but I have another question.
> Does the PP2 hardware support checksumming within any offset? I replaced
> 'NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM' with NETIF_F_HW_CSUM and
> then stacked 5 VxLANS on top of a mvpp2 device, to have the last IP heade=
r
> at offset 264:
>=20
> ip link set $dev up
> ip addr add 192.168.0.$last/24 dev $dev
>=20
> for i in {1..5}; do
> 	ip link add vx$i type vxlan id $i dstport 4789 remote 192.168.$((i-
> 1)).$other
> 	ip link set vx$i up
> 	ip addr add 192.168.$i.$last/24 dev vx$i done
>=20
> 00:51:82:11:22:00 > 3c:fd:fe:9c:60:6c, ethertype IPv4 (0x0800), length 34=
8:
> 192.168.0.1.33625 > 192.168.0.2.4789: VXLAN, flags [I] (0x08), vni 1
> 02:25:60:da:87:03 > 92:20:05:45:3d:d3, ethertype IPv4 (0x0800), length 29=
8:
> 192.168.1.1.33625 > 192.168.1.2.4789: VXLAN, flags [I] (0x08), vni 2
> 12:20:97:15:8f:aa > 66:08:23:c7:72:ea, ethertype IPv4 (0x0800), length 24=
8:
> 192.168.2.1.33625 > 192.168.2.2.4789: VXLAN, flags [I] (0x08), vni 3
> c6:1c:b9:fd:9d:28 > 22:ca:cb:6a:ea:68, ethertype IPv4 (0x0800), length 19=
8:
> 192.168.3.1.33625 > 192.168.3.2.4789: VXLAN, flags [I] (0x08), vni 4
> 02:34:5f:45:a5:9d > d2:4e:d4:d7:42:31, ethertype IPv4 (0x0800), length 14=
8:
> 192.168.4.1.34504 > 192.168.4.2.4789: VXLAN, flags [I] (0x08), vni 5
> a2:99:fd:9c:1b:05 > 5a:81:3b:fc:6a:07, ethertype IPv4 (0x0800), length 98=
:
> 192.168.5.1 > 192.168.5.2: ICMP echo request, id 1654, seq 156, length 64
>=20
> It seems that the HW is capable of doing it, can someone with a datasheet
> confirm this?

L3_offset in TX descriptor has 7 bits, so beginning of Layer3 should be les=
s than 128 Bytes.

Stefan,
Regards.
