Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA1D34D2D0
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 16:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhC2Oua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 10:50:30 -0400
Received: from mx0b-00273201.pphosted.com ([67.231.152.164]:3922 "EHLO
        mx0b-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231474AbhC2OuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 10:50:09 -0400
Received: from pps.filterd (m0108163.ppops.net [127.0.0.1])
        by mx0b-00273201.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TEmte5021288;
        Mon, 29 Mar 2021 07:49:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS1017;
 bh=INTiwXdVr1PTP4VRgjcCgohdgWR83ScKrzBQttZBAQk=;
 b=eWXJ0aX8uj8JF0QXjpzoVlQBlYUA/LD0ieCCeuiG0psl1kdujwOzPhRPyFF3b8kG8nus
 MqvypEAYkkS7gBi+ml0qaqvUafBqdjPRw2/mvlfO7R310M8Dt2yCFEtQFUMNCuO6zK0e
 IAN23/VnjXsLCGkxOQSXCINvd3GOP78BeX7tOZ+8trXX1a+jwe7TVHelGnAGKCPh9J9i
 WRie5hkt/aoKODnYwmSveJh7FlyRMoclFe0X+lcreUVIJUDqkabjldcEMzZrwmeMy9QG
 PPcvFwPjgIHObEUOx4fDXndfHT/Q9A6gHgMM3UOg7P9sEPmwV8Xj/zysZJ0B99BnCbbW eQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0b-00273201.pphosted.com with ESMTP id 37kbj28p5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 07:49:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jAI6ynBDRxiHqySQeueSQ1QxCqRj6QY9mLw1TmX1tsN0qSgCzb1c5/lfi+jAxuQ7mWe+6WovRe9aHZvP7zwSnS7Bd/BYcYYGqg5XffI6s5k7aXO6AAZYEprKVONhHMSqzq47fCBsWtBLOS4rBrIbRnx42RRrAGaouXJp/M0oXU5Vz4LXVqDQf8xzLOfLho54ctcU3I3GDRn9B/dlJgP4JvEQEfx8XbCOx51K6AHcdK6QMu1/xamjD1xCbkbhD0Jm90DJLGKFYcypIKhVAm4FKh/LeGYzUCn6SLBmUAby9H8ZZHCYCmDR+MjYY0JHSlofiYUv/9r4qt+HqXGhR8uyRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INTiwXdVr1PTP4VRgjcCgohdgWR83ScKrzBQttZBAQk=;
 b=CSh1EcpUFfDULJgTV/n1Yj2x1WBj512ImjuFaodD4kEeKBXwrkp4pj014bud6usMVQ9MeEFOk1bpo0Q0XjXpCZfy4QmleJtKMXoD2641Y2dbMHLBBmOFWxPEgk6Uqk5LXihZshDIbLbh6T10ZtoLh3TQz1H74+RFwXZHAktJTSLmILgbPRtnvN+o8XyWY5e7lLvRH6NOPtKSs4VlPgu4mDU8a0u/dcvcgsT82T6LLY1ab65SsnCwTRqpTJUObsG/6Z06uxdS7ymK4l261eRPTE5EDr0hJYGBOLlxeMGcSlOjNcQJE9dQmNmJQ92vADiuHqXLM13RNeWwJsLFlSkESQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INTiwXdVr1PTP4VRgjcCgohdgWR83ScKrzBQttZBAQk=;
 b=Bdr5uNDprej02IeaS70NqiMF851TFPqjITAFvivPggjcvo56d60gmtaLEHzRapAKnruNYw8ph+2g/b2sXNGKUPbPDCSm/L/2xX0LMiFtVFVmqSl7JRSVpqbUDvwO4WTHQeix+NE0LjoLBA/GAnHC8h1IEanlxZ5HjVklq5SVLEM=
Received: from BL0PR05MB5316.namprd05.prod.outlook.com (2603:10b6:208:2f::25)
 by MN2PR05MB6976.namprd05.prod.outlook.com (2603:10b6:208:188::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.16; Mon, 29 Mar
 2021 14:49:55 +0000
Received: from BL0PR05MB5316.namprd05.prod.outlook.com
 ([fe80::7841:1b7c:2f3d:54fe]) by BL0PR05MB5316.namprd05.prod.outlook.com
 ([fe80::7841:1b7c:2f3d:54fe%2]) with mapi id 15.20.3999.019; Mon, 29 Mar 2021
 14:49:55 +0000
From:   Ron Bonica <rbonica@juniper.net>
To:     David Ahern <dsahern@gmail.com>, Zachary Dodds <zdodds@gmail.com>,
        Ishaan Gandhi <ishaangandhi@gmail.com>
CC:     Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "junipeross20@cs.hmc.edu" <junipeross20@cs.hmc.edu>
Subject: RE: rfc5837 and rfc8335
Thread-Topic: rfc5837 and rfc8335
Thread-Index: AQHXHr2uLkiNuGD0bUKudZz6Kl88daqRUnMAgABYvQCAAmKXAIAG//Zg
Date:   Mon, 29 Mar 2021 14:49:55 +0000
Message-ID: <BL0PR05MB5316527A1739025552EB8BB6AE7E9@BL0PR05MB5316.namprd05.prod.outlook.com>
References: <20210317221959.4410-1-ishaangandhi@gmail.com>
 <f65cb281-c6d5-d1c9-a90d-3281cdb75620@gmail.com>
 <5E97397E-7028-46E8-BC0D-44A3E30C41A4@gmail.com>
 <45eff141-30fb-e8af-5ca5-034a86398ac9@gmail.com>
 <CA+FuTSd9kEnU3wysOVE21xQeC_M3c7Rm80Y72Ep8kvHaoyox+w@mail.gmail.com>
 <6a7f33a5-13ca-e009-24ac-fde59fb1c080@gmail.com>
 <a41352e8-6845-1031-98ab-6a8c62e44884@gmail.com>
 <5A3D866B-F2BF-4E30-9C2E-4C8A2CFABDF2@gmail.com>
 <CAJByZJBNMqVDXjcOGCJHGcAv+sT4oEv1FD608TpA_e-J2a3L2w@mail.gmail.com>
 <BL0PR05MB5316A2F5C2F1A727FA0190F3AE649@BL0PR05MB5316.namprd05.prod.outlook.com>
 <994ee235-2b1f-bec8-6f3d-bb73c1a76c3a@gmail.com>
In-Reply-To: <994ee235-2b1f-bec8-6f3d-bb73c1a76c3a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
msip_labels: MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Enabled=true;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SetDate=2021-03-29T14:49:54Z;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Method=Standard;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Name=0633b888-ae0d-4341-a75f-06e04137d755;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SiteId=bea78b3c-4cdb-4130-854a-1d193232e5f4;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ActionId=883f2ac4-c2c8-404c-b2cc-6f63c1b12763;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ContentBits=2
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=juniper.net;
x-originating-ip: [173.79.122.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 29c60ba5-0f18-41fa-f117-08d8f2c1eaec
x-ms-traffictypediagnostic: MN2PR05MB6976:
x-microsoft-antispam-prvs: <MN2PR05MB69766B8421E7741CCDAF7A55AE7E9@MN2PR05MB6976.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PCxZMoHlx2uj3zS6vRz86dZzR9aAq+iof1mcMEP/rUF4weXl7QSoQB/sulH1esLASqjYmvIzRLd5iM9aKm5sDY5vs0KycOvZ54FzQ43ll8kDNA9LyVooNYIJC9iML2IkBc9s/LKiEQ5TJWFxF4IyI5xdkfAN19z/8xpTZjPH8xjc319K/ZmkREzqgpibv18PpbUBsapgufHzinaLnhR0Y8NcxL7+VUEwEb9C8WE/gVpNAldwhX2nDOJi+HBQBfSWBQBkcwzpW4m/MaaqrM/2AK5Z3EBRUbUWKejXagFoVSYo5GjAwsII4cf4QlSVVU42kGSQqk4ZDk61d6CUvdSuZjDPNrk64e1RB7Yqgz0whxmu4WJV+BTPJoJl55GOUq2xvDF39aNHqO+bpyt4zltK9twUjWMkxkCpU4Ybid/P/QN8wKYJm++hmJyG7iqvxj1PZSbVMk3KUvkAiMuloWzn11D4K6VfopV7VZd300n+FIWxDTMEeoepl4kXprqmtEO9gVc/hxGlkwexscib8oe++qwBSab9AYfARShy3ctX3QN15A1RIkxRGCdw90xd97llt9zuXIw6nmK/MJ1A7fBlVq84K8C32H/8GdGxO06mPsN3REwmRdRJOHtHtILumv/5AoWO0k43fMf8N9/Z5eVGKu8k0tsHp+Rp+c8or22kCQI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR05MB5316.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(5660300002)(33656002)(54906003)(52536014)(316002)(55016002)(38100700001)(110136005)(2906002)(66556008)(71200400001)(64756008)(6506007)(478600001)(76116006)(9686003)(4326008)(8676002)(66946007)(186003)(7696005)(7116003)(83380400001)(66574015)(8936002)(66476007)(66446008)(86362001)(26005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?te2zhEuCTaJKXV7dg6z2f0QRa/dFG2eHnY0OVi1RbF+ROlHH9RE7DfmbK1UW?=
 =?us-ascii?Q?UpW4YuTq4VlOv4EFbKjYwI+sAQk9cVphMpIE/MEjt+lRHxCZHcQ8/D90/OOu?=
 =?us-ascii?Q?YAvjd0MCn3gHffC1w5eldvjM6pdtvjvV+eFXo4PBO5Tdq8/KhGCf34xDstEN?=
 =?us-ascii?Q?Sez6K8p0pfQzyzvOB39qvHlyHdRUL4EwQ22O+pHRLMP+Wcuh0KB66/+MhD+p?=
 =?us-ascii?Q?q7yUX2wZxUvp21tYA9ydSVCwwcIyhFfCGbtbYsJo715AVlYY1uiiEosWWLfr?=
 =?us-ascii?Q?PKGb4jVKF97nECgs5/6Txo01sJk5d4ujPigmeZHX3eVAef1ptIzsgQoRPkaD?=
 =?us-ascii?Q?Xtt4igFF2GMCNoBUSl45T6dfHdTOnEbYJMad/FP2gW5UEnbstXaR8b3Jlevk?=
 =?us-ascii?Q?CHass81sRwu9VG7Hqo1ZOwzoX+CCd5Fj/1EnsFFpALBRjN2Dfor3G7JvZATV?=
 =?us-ascii?Q?XYDeZRvsBAp775Te6/cInmVgrxc5qnuRlqxdFNObHXnjLdt9HkaolK2gYOMr?=
 =?us-ascii?Q?XxA9cTmb+oAXSD3khGJMFpJUYjPY7I0LL0upBTcffdRHn7jjx8OKg0YxrFGa?=
 =?us-ascii?Q?UInwferDSHl4maYrobphdQj3k8Np2fe37tuIYQzCVDDDYvNtt+dRn3CdK8sF?=
 =?us-ascii?Q?fzLZd+wOsxXsNQUMKVpnrk5dlNJVSmbqsc/RUuaO8jRdoi9sgRU5lsLg1Zuh?=
 =?us-ascii?Q?9TvKMeoeJ2uxPymxLtBybtCbQXGJ9i+RLW4+eNIGX87vZX5U5rpXbLJ/sGhO?=
 =?us-ascii?Q?QgLR/Wy77oGuNp3nFZ+BOnFWNzlDKOg4ApgjOrIM8irQAUOQO56oGU6Tv9D6?=
 =?us-ascii?Q?9qTwGw5wEP1EYhL5JIjhwWh5dhcDhi/tBg/TzehlPZqjfwd1gyX9WETHiFOT?=
 =?us-ascii?Q?SWZfPAJ13PGHBtKa70WQTKhiof+86A8xxBWiJ2ASCabYzPwddXevb3+tofRV?=
 =?us-ascii?Q?AgQQ3w+iWGIxb7PKWAtWnlJS13tNlrULrvYnqRFMjUPtNeHzQ1ABcFAsuC/0?=
 =?us-ascii?Q?SCDaZve3DlX4B/OWDPofGPOw2l5XLyVneDo5GgL5FtDiAfU3ycxXnaS0jgJ/?=
 =?us-ascii?Q?JY8Fln6gLoKORPD9j96A16O6Qv4eKm+NEYrh9hU7dz19ptWvN85iCDagbPHS?=
 =?us-ascii?Q?7A11IFhzf+SRCDcEy4jI/GVIlJ+qczsZG5cpRDVan9ZH8gw1jdGT1W/r7gbQ?=
 =?us-ascii?Q?ueu69OZ5ZIT5G8KcMbc4MVzq8iggcXABHMkbm7j96p3tGbltWgoM7e7IaKx+?=
 =?us-ascii?Q?R3FcPyb3rpoNpobjRlEFBjvHY5Fcsyu5rNZU8k/YoTcA0yLViFp5ZrAUQckf?=
 =?us-ascii?Q?QGQBey63yNE6CbdyZekrqj0e?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR05MB5316.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c60ba5-0f18-41fa-f117-08d8f2c1eaec
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 14:49:55.5692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bXoG2px+hrPOK54++tTJw4Q6HOSGDOV7T6tK0q6homeF3jRq/CNlTPui9D805n//Ram2qkHx8xjvm+z5V49iWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6976
X-Proofpoint-GUID: -LPMdicxyskXQ_CPpAyimPNY31yaR7WM
X-Proofpoint-ORIG-GUID: -LPMdicxyskXQ_CPpAyimPNY31yaR7WM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_09:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 malwarescore=0
 spamscore=0 mlxscore=0 clxscore=1015 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290113
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David,

Juniper networks is motivated to promote RFC 5837 now, as opposed to eleven=
 years ago, because the deployment of parallel links between routers is bec=
oming more common

Large network operators frequently require more than 400 Gbps connectivity =
between their backbone routers. However, the largest interfaces available c=
an only handle 400 Gbps. So, parallel links are required. Moreover, it is f=
requently cheaper to deploy 4 100 Gbps interfaces than a single 400 Gbps in=
terface. So, it is not uncommon to see two routers connected by many, paral=
lel 100 Gbps links. RFC 5837 allows a network operator to trace a packet in=
terface to interface, as opposed to node to node.

I think that you are correct in saying that:

- LINUX is more likely to be implemented on a host than a router
- Therefore, LINUX hosts will  not send RFC 5837 ICMP extensions often

However, LINUX hosts are frequently used in network management stations. Th=
erefore, it would be very useful if LINUX hosts could parse and display inc=
oming RFC 5837 extensions, just as they display RFC 4950 ICMP extensions.

Juniper networks plans to support RFC 5837 on one platform in an upcoming r=
elease and on other platforms soon after that.

                                                                           =
      Ron




Juniper Business Use Only

-----Original Message-----
From: David Ahern <dsahern@gmail.com>=20
Sent: Wednesday, March 24, 2021 11:19 PM
To: Ron Bonica <rbonica@juniper.net>; Zachary Dodds <zdodds@gmail.com>; Ish=
aan Gandhi <ishaangandhi@gmail.com>
Cc: Andreas Roeseler <andreas.a.roeseler@gmail.com>; David Miller <davem@da=
vemloft.net>; Network Development <netdev@vger.kernel.org>; Stephen Hemming=
er <stephen@networkplumber.org>; Willem de Bruijn <willemdebruijn.kernel@gm=
ail.com>; junipeross20@cs.hmc.edu
Subject: Re: rfc5837 and rfc8335

[External Email. Be cautious of content]


On 3/23/21 10:39 AM, Ron Bonica wrote:
> Hi Folks,
>
>
>
> The rationale for RFC 8335 can be found in Section 5.0 of that document.
> Currently, ICMP ECHO and ECHO RESPONSE messages can be used to=20
> determine the liveness of some interfaces. However, they cannot=20
> determine the liveness of:
>
>
>
>   * An unnumbered IPv4 interface
>   * An IPv6 interface that has only a link-local address
>
>
>
> A router can have hundreds, or even thousands of interfaces that fall=20
> into these categories.
>
>
>
> The rational for RFC 5837 can be found in the Introduction to that=20
> document. When a node sends an ICMP TTL Expired message, the node=20
> reports that a packet has expired on it. However, the source address=20
> of the ICMP TTL Expired message doesn't necessarily identify the=20
> interface upon which the packet arrived. So, TRACEROUTE can be relied=20
> upon to identify the nodes that a packet traverses along its delivery=20
> path. But it cannot be relied upon to identify the interfaces that a=20
> packet traversed along its deliver path.
>
>

It's not a question of the rationale; the question is why add this support =
to Linux now? RFC 5837 is 11 years old. Why has no one cared to add support=
 before now? What tooling supports it? What other NOS'es support it to real=
ly make the feature meaningful? e.g., Do you know what Juniper products sup=
port RFC 5837 today?

More than likely Linux is the end node of the traceroute chain, not the tra=
nsit or path nodes. With Linux, the ingress interface can lost in the layer=
s (NIC port, vlan, bond, bridge, vrf, macvlan), and to properly support eit=
her you need to return information about the right one.
Unnumbered interfaces can make that more of a challenge.
