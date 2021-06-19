Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF3E3ADA89
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 17:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbhFSPQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 11:16:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64846 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234128AbhFSPQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 11:16:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15JFAK6e023110;
        Sat, 19 Jun 2021 08:14:39 -0700
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by mx0b-0016f401.pphosted.com with ESMTP id 399g3qgdet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Jun 2021 08:14:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHUL1JC1N5T2eUZRjHcj/XJE8Q9Ifam6YwH6hjsxX85up42F3z3EpVeCNHUPlCJngiHoa429F3o5BGjC0SQ2dYfryAq5iV5ItndZ1wy2+uSqqK6cLttRb0yB24C8cUGz00qC4R0tT/vYHMarioOeuvOUm1LjVnf3emYtEgLj3aJ8AELSqaHXS8U4ZYdQW4ZZqu4Q78iqU6u0F+ieN9K2WkksHqg2KMesRVr8Soi2j1uAK7acVEaU/hcdW1bJkkT6/nmaMITwQo3L68R3nNybzwyQ74guDNAweO7HcVMj76nkcGzACcX+9SHJpUWsnSBQ2xAgYQ6ogbs6z9CF0Dk3Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guFHYwapM0iQaWRhUrq/k8FABUmYT1XYpmD+Vev2Q7s=;
 b=m2t70vJXdpyb50JCfle44bExEfUdgwFjth3e32JqQmhYduOxez4XkFyCkU4QML3QgPpWVe4WLfMOIlAkKm2IbWEG/kTBWcdFBEIrL/xvsWlRfatcDzgjDLPPG9WQTNbUjm+c1qmIhsXzasVfE4EOT7mt0kXBQE+JNsrYtrCwiOmiKI4U1hYa7uTpGDFCV6lLw+5JZ6wrYuu4Q6jiDmCRRKQ469uyn7d/EbL8YELxWZtcGaek/h7hgjH3t3wAOLQdkpNQ0CwjiMrrgtuDOh51mWmihOgeTDAsWCd9U2y8jNUmKYr0V+WrWTnrIszFt9CSky/RIIUn0DEqyJdqrw19jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guFHYwapM0iQaWRhUrq/k8FABUmYT1XYpmD+Vev2Q7s=;
 b=JcpOXFyV1xqyGrGf4A2zsD7zx20Ff4+p2i1Z1BER7ucrJbo61rGrGtHJ4AkF+l0gwrxotVEKG5joRGCJNiHpV+xn00a2d7ZSje4Dc1XSkd240ftH2PGLy5zeJMiQgN/g2PCIwdRp6f2+AWigNv0fLa1oeHDnwJQbQfXIjCxMIBk=
Received: from SJ0PR18MB3994.namprd18.prod.outlook.com (2603:10b6:a03:2ec::17)
 by BYAPR18MB2949.namprd18.prod.outlook.com (2603:10b6:a03:109::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Sat, 19 Jun
 2021 15:14:35 +0000
Received: from SJ0PR18MB3994.namprd18.prod.outlook.com
 ([fe80::4:8e25:8456:941d]) by SJ0PR18MB3994.namprd18.prod.outlook.com
 ([fe80::4:8e25:8456:941d%7]) with mapi id 15.20.4242.023; Sat, 19 Jun 2021
 15:14:35 +0000
From:   Arijit De <arijitde@marvell.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: Ping frame drop
Thread-Topic: [EXT] Re: Ping frame drop
Thread-Index: AddkUykF2PIKwZ4CQOyORMa4KSD6LAAPN9mAACKrYZA=
Date:   Sat, 19 Jun 2021 15:14:35 +0000
Message-ID: <SJ0PR18MB39942C03084DA2E773928C72D40C9@SJ0PR18MB3994.namprd18.prod.outlook.com>
References: <SJ0PR18MB3994A5156DF9B144838A746ED40D9@SJ0PR18MB3994.namprd18.prod.outlook.com>
 <20210618151941.04a2494d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210618151941.04a2494d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [49.207.192.244]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7508df80-55a2-4636-516e-08d93334f2bd
x-ms-traffictypediagnostic: BYAPR18MB2949:
x-microsoft-antispam-prvs: <BYAPR18MB2949F098EC1DB446FB1CBD56D40C9@BYAPR18MB2949.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k334oH41/SCZ74K4zDgakm+Ln0kdQwNo02dumlBMiKP0hdqy4Eg20dwjVg43cMgBz5LU2D1vFrPv1THdLfsS7gAqJo0GNR51crKS0wLKFON88eA119wpOj2zA5ezkcllDrWSrYSflaXDvgTB3TybWhm9dNwEj5HzZZUtNSHh9LLombac3TY0/SpA2zTPqkj7jcl/HoKtwBJDiHg6pxoL8OX84cBe6n2K2lyoQY0wkdTZks4scEuT6IByBxvLHIUMaJmgdYcPqOs+6vGxXl/Z0R4P8rlIJPvLtClc8hyifwRyJ9JMcPi4R0SLNj0NZ2lEhvvj3uPQk4laKw2WH2Ys9Ot5j8prTyi0Imj+uloQ+PsjiQhX9MMy364ly/ExtT1zA2GTzVfp8RU3pTjN3LZPKDofmedrCEtgWW8QleTr2e+jk8GxmB4dxVShTy07XovY8V4dnKoRWHOv49YG02rPdHot3X6Srmw40SmceOs7+zRBmr8WSk/SGfPmFIsKcdEfOQcoRX33054aEtXHfk8AvnBmARHbkkZFLB48szmEsxxSaaIIqjTCocADTi3EX3iPeXk34XMrhOoTScvn93b+EFpbMl2CJ9BLB7LDbNCVzIN9Aq9ggVSncj5t9tcA/+cmG9+wJp1b3JQZwS/IueUGg1V0T9YJ4oc40OH/at2JqR9RO4Macc4cAR5+U67V2Fixkg7mRJN/IexJNYOMuncgPfm2NQXk6kv4P1NA9VsDE9FkFJ0xi2DCnrMZOQ1u4bqS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3994.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39850400004)(66946007)(26005)(186003)(316002)(33656002)(76116006)(66476007)(64756008)(478600001)(66446008)(9686003)(122000001)(66556008)(2906002)(966005)(6506007)(52536014)(71200400001)(55016002)(38100700002)(8676002)(5660300002)(8936002)(83380400001)(6916009)(53546011)(86362001)(55236004)(7696005)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZkbB46P+Z4hggiMdh0ZGdztJQPOx6dbq/eXNyN+D7jXoQZ7ByraS6KwiorFN?=
 =?us-ascii?Q?QjDuTFNgsK1DQznrQHDBFL9NbqjOuScLb0c7UBKABVNgSnENimmz+Vn9+7Fk?=
 =?us-ascii?Q?yelBOrVK7nuhfxJOQDF3ZkriPRGtd22NHbWPJnKs/HMK7w1nBBjEXHRffkSa?=
 =?us-ascii?Q?V7ZdPTq0Fc8cwKlR2TAPcR4qWkKApuOg54vPJrlbFP3PHYAf0spg22zwapoq?=
 =?us-ascii?Q?8/l4hDzyvXFkmsHa+hAUg3eei4qn7Sx8KrwwBnTtAr0GFNWj4mVr7QDaOk73?=
 =?us-ascii?Q?nOW5Xsh4XcIBPKhsMe8awzmAOJbEuscAGItCYjgdMzPId03HscXPJTGMBcnN?=
 =?us-ascii?Q?MM7tEYljpZyRT4h4Vp03SZDNPAVqhPRyB4jroN3jgzMfhY7uPTkcyT3iov5h?=
 =?us-ascii?Q?cVmM3jp3P08u9wWNKmJwZdVLBjHv6aFdRtVmdPpPQLjkwoKI8y6Q8wviAEtc?=
 =?us-ascii?Q?U0JF/LAZcTB+wTUsT4trNi30I0HwVM2/HIBfXNzoB/PMSdacnLEQC5s6zNFC?=
 =?us-ascii?Q?2UblamFcR3TaYksbjH3rEyN0fcUg8QQ0XNNQO35SX1hKMdjDDT05LpmpYF+Z?=
 =?us-ascii?Q?NQeadwtYFIKD9+CWkAKRetOEIjJIAWjebB6wMP7rnSs9N6CtAC4zI/QBQpTL?=
 =?us-ascii?Q?M0P+eVFaFVPGJK9p+8YdURtNsytCZw57VaPFDZw3uVT6/3L3yI8eFH/6sDYc?=
 =?us-ascii?Q?vEmnNPZrlwYLDlEWDHIC0IxSFkxbOo/zgnUjjYGrT6HcYb/ioOPH0EGOTZtT?=
 =?us-ascii?Q?RrFnyrdcXWGxJuowtN39rVErnCUWVa3FIu5cJatcAGpTxKaD4cPSB8Ziomm1?=
 =?us-ascii?Q?yPFxTeMM5H1cPyhn9lVuvI0rtzpbJbysAY7psMzfUfUSe9PtGqoWT3QOXjUv?=
 =?us-ascii?Q?X9zC+iF8tW5RxjhEAojp+WdnPDHIoXNjBPC475+HEuj9PW7CJi3zPAVOUpl0?=
 =?us-ascii?Q?kHSZcSDkCGJff9luhXeTVhVS1Rvo7z/xMVza2vttoUaVMxX63VQ3tcGXkbXD?=
 =?us-ascii?Q?n12L3YXFv2rw2SoW10l+/MjEgfLkOBcwb4zM0omLXiuPe+LEef0LUQG+u22B?=
 =?us-ascii?Q?Bc6PqHSYpWkonNrOAWyfWWDviLxcuhdO0CiOX69FE7bZraCGMyGBoWpfClTG?=
 =?us-ascii?Q?XSHsCZgicq63jSyofsGJtdiJyrm1njHvxIRIat6bwUJfsec0sjn4KW2RhB3T?=
 =?us-ascii?Q?6jxV20wDYzbplw9Bsv0UiRg/Nyf8/OqjrwsZwsMVQmrIJp2G6GlMgJUqg9cN?=
 =?us-ascii?Q?GD5tPOrHvpRtN2nK16xC2gksKex4O/uCWdYio/+h78r94xmkx5bwwMjAbGI2?=
 =?us-ascii?Q?f2o=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3994.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7508df80-55a2-4636-516e-08d93334f2bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2021 15:14:35.2379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iByRD5j+wRPiFu4JL9vF+bx0zws/YxiXDoK+3/SieX82GziuEst2drV/TBsjc7aGzvAnTacC8Q1u/dYsXby5MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2949
X-Proofpoint-GUID: NoOuYFPsCMwvQoMSZN73Jbe4IRzOeFcr
X-Proofpoint-ORIG-GUID: NoOuYFPsCMwvQoMSZN73Jbe4IRzOeFcr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-19_12:2021-06-18,2021-06-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

In my network card HW it can verify the received frame's checksum of IPv4 h=
eader, but it can't verify the checksum of ICMP header.
So for ICMP kind of received frames driver sets the checksum state to CHECK=
SUM_PARTIAL in skb->ip_summed. Which is as per the linux kernel documentati=
on also.
Now before the commit  https://git.kernel.org/pub/scm/linux/kernel/git/stab=
le/linux.git/commit/?id=3D8f9a69a92fc63917c9bd921b28e3b2912980becf this use=
 case was working.
But now after introducing this logic for CHECKSUM_PARTIAL case, my received=
 ICMP ping frames are getting dropped in the linux kernel pskb_trim_rcsum_s=
low().=20
I do understand that to bypass this scenario I can use CHECKSUM_NONE, but i=
n that case HW's capability where checksum is already verified for the IPv4=
 header will be unutilized.=20

So please do share if any documentation update has happened for the CHECKSU=
M_PARTIAL scenario or please do let me know what need to be updated in the =
skb for the receive frame in this scenario where only Networking layer (i.e=
. IPv4 in this case) checksum is verified but the ICMP(ping) header checksu=
m is not verified  ?

Thanks
Arijit

-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Saturday, June 19, 2021 3:50 AM
To: Arijit De <arijitde@marvell.com>
Cc: netdev@vger.kernel.org
Subject: [EXT] Re: Ping frame drop

External Email

----------------------------------------------------------------------
On Fri, 18 Jun 2021 15:03:59 +0000 Arijit De wrote:
> Hi,
>=20
> In the latest linux kernel (i.e. 5.12.x) I am observing that for my=20
> Ethernet driver ping test has stopped working, it was working in 5.4.x=20
> and all the older kernels. I have debugged the issue and root caused=20
> that it's because of the recent commit=20
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__git.kernel.org_pu
> b_scm_linux_kernel_git_stable_linux.git_commit_-3Fid-3D8f9a69a92fc6391
> 7c9bd921b28e3b2912980becf&d=3DDwICAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DTaxnD=
gE1
> 8KxGhqsUtny5eMiBbXC81IdotAx6pqBUXWE&m=3DllYaO7Eowy-EL2vj6Lr3tV6AWHL1zodg
> flS7funQd3I&s=3DfkqonnyQCEHc929sQLcwua-9L5utQkXp_kAr73NhQiA&e=3D
>=20
> In my Network card HW it supports checksum offload for IPv4 frame, but=20
> it can't verify checksum for the ICMP frames, so I use=20
> CHECKSUM_PARTIAL in the skb->ip_summed for this kind of scenario.

Do you mean that your drivers sets up CHECKSUM_PARTIAL on Rx? If HW hasn't =
validated the checksum just leave the skb with CHECKSUM_NONE, the stack wil=
l validate.

> But now because of this new logic what you have added ping frames are=20
> getting dropped.
>=20
> My Ping packets skb dump:
> [112241.545219] skb len=3D88 headroom=3D78 headlen=3D0 tailroom=3D0=20
> [112241.545219] mac=3D(64,-64) net=3D(0,-1) trans=3D-1 [112241.545219]=20
> shinfo(txflags=3D0 nr_frags=3D1 gso(size=3D0 type=3D0 segs=3D0)) [112241.=
545219]=20
> csum(0x0 ip_summed=3D3 complete_sw=3D0 valid=3D0 level=3D0) [112241.54521=
9]=20
> hash(0x0 sw=3D0 l4=3D0) proto=3D0x0800 pkttype=3D0 iif=3D0 [112241.572837=
] dev=20
> name=3Denp137s0 feat=3D0x0x0000010000004813 [112241.578141] skb headroom:=
=20
> 00000000: 4c 00 70 35 09 de b4 e4 00 11
> 22 33 44 01 08 06 [112241.585876] skb headroom: 00000010: 00 01 08 00
> 06 04 00 02 00 11 22 33 44 01 0a 1c [112241.593611] skb headroom:
> 00000020: 28 13 70 35 09 de b4 e4 0a 1c 28 01 00 00 00 00=20
> [112241.601345] skb headroom: 00000030: 50 04 00 00 55 50 00 00 14 00
> 03 00 00 00 00 00 [112241.609080] skb headroom: 00000040: 00 11 22 33
> 44 01 ac 1f 6b d2 c0 e5 08 00 [112241.616293] skb frag:     00000000:
> 45 00 00 54 87 a2 40 00 40 01 4d e3 0a 1c 28 d9 [112241.624027] skb
> frag:     00000010: 0a 1c 28 13 08 00 fd 50 0c a8 00 03 6a 94 cc 60
> [112241.631762] skb frag:     00000020: 00 00 00 00 f5 3b 03 00 00 00
> 00 00 10 11 12 13 [112241.639496] skb frag:     00000030: 14 15 16 17
> 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 [112241.647230] skb frag:
> 00000040: 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33
> [112241.654965] skb frag:     00000050: 34 35 36 37 9c b0 19 b9
>=20
> Its hitting the check for CHECKSUM_PARTIAL in pskb_trim_rcsum_slow()=20
> and getting dropped there. Can you please let me know how can I=20
> satisfy the requirement such that I can keep supporting the=20
> CHECKSUM_PARTIAL cases for my network card ? I have checked=20
> include/linux/skbuff.h For the documentation of CHECKSUM_PARTIAL, but=20
> could not understand what change I have to do to make it working=20
> again. My network driver is not up streamed yet in the linux kernel.
> For any more information please do let me know.

