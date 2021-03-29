Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510E534D867
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 21:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhC2TkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 15:40:17 -0400
Received: from mx0b-00273201.pphosted.com ([67.231.152.164]:44430 "EHLO
        mx0b-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230346AbhC2TkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 15:40:09 -0400
Received: from pps.filterd (m0108163.ppops.net [127.0.0.1])
        by mx0b-00273201.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TJYgKH014017;
        Mon, 29 Mar 2021 12:40:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS1017;
 bh=xCf42wSdHfjVEeEgmyVd3m6eUXlHL0wvXhcfPH21EUw=;
 b=xaSym3IZAJJdD1ATr66tM5BrsGFWGF0fcH1jSKrC3C6G3THF9eh0iVCGcSDB8m1M6R7X
 i7fKetf3uFINt65yO5qM2LS+IhpNaBGmMFmMTXnF7jZzai3ypIRaRSgSPl36tRb/Fo4t
 jHIa9ej/f+QDLkAmn4ym7Bmg/xt7OWhS9Xs3+zz4toVI0xuyg8pZGXeAkZ0AhX54T/3y
 T7LT9N3VjlDlmXsMfGTqdZn7lFSadCFApGWlm5IUsijslX/zwXvcg6jVf0vT9UGxIknT
 K/l5FQUSWHsFc2iz3l5bFCBwueZNtgeBqopmZ0e1rE5kU3llUFSS1wJ2B70/xpFcOP2p XQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0b-00273201.pphosted.com with ESMTP id 37kbj299dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 12:40:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQ4OdcT43yu1AqMhmCJxXHFKm3nXQMT+ZrRKgn9xd8jHIbgKsaUaOOZ1lfiTINUAJ8x0cpsU3o4XU8Sz+KLeN9DiWpYbXVh2Bi92i0m5xC5JvEM5ixjIUiE/PaE1Qdzm8bQ0ZlX0wDLjqw2WugBAC5kXJ3xpy3TxsakVw9wQFvAtumcHilCQHrLULRMg0McTexKzuSgEE8hePXQW5ZPJ8EcXuMmV8liDKNTgi5cd1J2dx6VJwoT+FbPD+Jhb3Bda/v4SnAPFS3faRxsSqE95J7R4cEr+R/l5kDGfez9CZ4Xo6cqmB51IVERxSo/AXVJyT3UzfgDOcsKHxDJdapGPVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCf42wSdHfjVEeEgmyVd3m6eUXlHL0wvXhcfPH21EUw=;
 b=OSRwFYAYngS9u7kH0Th0jOfMqou9Nn9dKlhNSGuuVysNiTrdUQhF4UeMnZ7zcBjzSigW8K4JCLruuoLudyyO494od1Q9EOwvvxMtcGYEg4+HvSq7qw/nudgy2F8xeunDqVckeZW/Y5mnLGXM8Zs9djzJ+7rvJiVE3xAYMosd2TfZ+DnB32Lj4CsgxvYp74DoH6zhK9REzfy0AtBGNQRIJHkAVE5cYqU+4S+nD3RKHTNwGPBJuNNkjdSYWLT7EhUwJXU7jChmee3MZBYy6lGak6n00hL+v/ZjqG59S+ztEirOuAfmQ9MPR8dtqpt0O/DMVl3rxU7koF1EKfmfkNq6VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCf42wSdHfjVEeEgmyVd3m6eUXlHL0wvXhcfPH21EUw=;
 b=XH6Ul6Y604/CwTzgvNUez6qNsQutPI2clsz0AsdS+Iu6iDtLhSfG9vbGrozD1P9yx2gqKVLHC99gF4HQOGnaFVvUWtidJKRE1+6e1uK5/29pdQCbiQw2jPqfYjjOuDSEMXLV1nHOjILRDBIXo7n5f9o/ZP4Gx45B0CikxcnHAHg=
Received: from BL0PR05MB5316.namprd05.prod.outlook.com (2603:10b6:208:2f::25)
 by MN2PR05MB7039.namprd05.prod.outlook.com (2603:10b6:208:193::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.15; Mon, 29 Mar
 2021 19:39:59 +0000
Received: from BL0PR05MB5316.namprd05.prod.outlook.com
 ([fe80::7841:1b7c:2f3d:54fe]) by BL0PR05MB5316.namprd05.prod.outlook.com
 ([fe80::7841:1b7c:2f3d:54fe%2]) with mapi id 15.20.3999.019; Mon, 29 Mar 2021
 19:39:59 +0000
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
Thread-Index: AQHXHr2uLkiNuGD0bUKudZz6Kl88daqRUnMAgABYvQCAAmKXAIAG//ZggABZEKA=
Date:   Mon, 29 Mar 2021 19:39:59 +0000
Message-ID: <BL0PR05MB531617E730233A4913B4C5B3AE7E9@BL0PR05MB5316.namprd05.prod.outlook.com>
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
 <BL0PR05MB5316527A1739025552EB8BB6AE7E9@BL0PR05MB5316.namprd05.prod.outlook.com>
In-Reply-To: <BL0PR05MB5316527A1739025552EB8BB6AE7E9@BL0PR05MB5316.namprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
msip_labels: MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Enabled=true;
 MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SetDate=2021-03-29T19:39:57Z;
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
x-ms-office365-filtering-correlation-id: 4547afe3-009b-4cb3-822a-08d8f2ea706f
x-ms-traffictypediagnostic: MN2PR05MB7039:
x-microsoft-antispam-prvs: <MN2PR05MB7039D8F578D22FB6AAADFE64AE7E9@MN2PR05MB7039.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9TDuvarU9wkZeSc6RPMnV/6VAMSA4loA3VwMZ1qc/VOvtcZ7vZNvMZqzwOLP/8WjI3imtZs77edh24xpxtfGKiQVel6h1NBEYSAI/2rs9P30sZ/gBKxPGyacEguKsyhXClKUobonyw47e83mCFOl6afw302RYdZbW6EoEyV1aEyAH+xJsZtQXU5cSYT8aAwWzUOeU8XTW/Fa8Vegh5yZj9dtPSwgRSkqiQskzn6NkaqRfzZsE7Ft6cu3kQJNgfKhZlBCQSxGE6ytAjtJFB0hJDtm06r5T/F9OQzfYhH7dalb1sq1B1N+FDUMxErdl9juqi+6mgu9xItMcK/IlwWZ6PAAgZCpmZvuCyW/26Hm4icXZB28Zq9JBw5/Ixs0083VOig9v6uk8JGvCbrEg5IG4skJ1cQmvQSd4JQV61fq2PXp51ZeRkJoiqvcZHis2FOp9RreU7R0efZlAnkHYXZMa7urI4bhAehnr1Wir1DD3K8MmXLlDhcaw8MNb8/NxT2/fqRL2F1nnA+XcaBzvz6s0hkehwc1vk6jwD3UIYtzxrRVDSesKAdSfueNFJffFSc9IlONwGSwtyJqZjpsw5G5uGpyaYMRQn5ppEvY2I7kw+z1utpB0Wp5pIdTkhsPggPn8T9hxOyrfYj72KKiNfVAQsQwef+lz0HbrF3WJ2tlU0U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR05MB5316.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(6506007)(33656002)(5660300002)(186003)(110136005)(52536014)(7116003)(7696005)(316002)(55016002)(478600001)(38100700001)(54906003)(8936002)(66476007)(66556008)(66946007)(8676002)(2906002)(4326008)(2940100002)(64756008)(53546011)(9686003)(83380400001)(66574015)(26005)(76116006)(86362001)(71200400001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Xfa1FjdShCnQKg4x3xB6Uex0acvVj4DAH5YtEPJIYWRAOMAQOpqLjvvbBsLC?=
 =?us-ascii?Q?4nC+kg2b8gM1EQ+XGSECk0UTQtD8Y0jC9wIOzAd5l5GNmNmkdLn3Brd33DRQ?=
 =?us-ascii?Q?2BxYYSXQA4SieoHqDd1frP6lIECwk9nXsnd0NTmV55BbYmvOZi7s3Jv1EQLl?=
 =?us-ascii?Q?umDuOn0fGF9ZyS6GZvaTS1IXr53Skwr6rTpqAV7ZlmitE72tbMFghFj6W8fU?=
 =?us-ascii?Q?qkkqdkVQ9Mlopu8A+hwFX+t61WQfcJT7tyYrE0oM8Egy/G60GXFw7D6/NcB0?=
 =?us-ascii?Q?zRacO/XetUwj2fxPzx6Cn//58zwY3YRVlMmnxDmh09YS1kwM4gMN0LvLIR5I?=
 =?us-ascii?Q?4zScUuinc8VhylI2c5lHk5VP4FzHDbLcW5R7aN0YlEz984cFfOc0FbYKvltC?=
 =?us-ascii?Q?vIl2OpWiJfcUB++pOGQK0HGRU1ebKm2KPXH1+5GUzoOpVXGjG2wYlZKyvhtE?=
 =?us-ascii?Q?+jdDIR8Z1ME4t18vEiaSC19SIfqLJ6jinM7sM5Oq8nyDrh2NQv5OOyB5BW4Z?=
 =?us-ascii?Q?iOW7gHifnM+8+cbg6aAQU5wdcTwezcCzLzfcyEICRQq3wGN7OHkAe9XpQddl?=
 =?us-ascii?Q?H8XxkpiAYy922q1lTUDRmPQyLYrJkzjuBZ0h4j0N0K+7VjMnigMLdNC48u7P?=
 =?us-ascii?Q?U6kCLodxM+RXxEmglDiT+dA9Lhd0WoZV9d4zFXL8JECAyCTFFC9iSuvWc4vk?=
 =?us-ascii?Q?YMcBEP8bjT+6SY9WSqur3kcdytIWCTJ8D+M9Jp0NQk6+f6BkMixr0ZARDHfz?=
 =?us-ascii?Q?seCxtC0OhVaVCis+RP+H/7M5itFsq+7CHy4WQchWwT+SywHNlwGKwPIThjJv?=
 =?us-ascii?Q?Zj16W/vXOII/WToaWw3utFuNZ9pUCPF83jDT2NgJOGd9cT8IdpOVG2opmOQB?=
 =?us-ascii?Q?FfTDQtrsvxH58PHsj6yvhZUXEUO+DrGbFyUX67s8vjN0CA3EBWkGFDmAbz5i?=
 =?us-ascii?Q?7T3YY5UgzjXvhkzUc2Ke6Y1ekzSRWoH1azOXktIDGHXxry8yN+EwJwLTXRtA?=
 =?us-ascii?Q?cX4pj1qNpNVMLdfxXH2+PZ8g6w+uacCUIClEkh5Cd6rM9GngJ4N1t4ELeFHt?=
 =?us-ascii?Q?Iee9GrqRupj1xqFi34YVzauj7dzn9UlgZlqOaChS0b5cCxi6prkVIWZyhcRX?=
 =?us-ascii?Q?ruaetFfCcNWkF+hK0IC9sSySkF1INhL6WQYqn3Wx5vbuUaOqJZN1bOG2K7Cq?=
 =?us-ascii?Q?uQSH+okP+XqUdnIxJ9ZZXhMXARrHO5sEFUNd6eLvqRhv37Z+K60Wzm4sxx+z?=
 =?us-ascii?Q?A+u0IsnjcIZqa02OMPI68sW/oTsovetne246slCVK9xhsKKc5faVDU4cROJD?=
 =?us-ascii?Q?BNB1CSEKyy0wR0inM95MqIHz?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR05MB5316.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4547afe3-009b-4cb3-822a-08d8f2ea706f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 19:39:59.4320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vPqw9lwJ0aHHjcQ+h9AS97BjmqbH1Y3n4PLabwDR8/zZRbgDpjCfX2oEUHNVwq/mcMvjm3R0nT8gMiGYtrqiOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB7039
X-Proofpoint-GUID: vkh_1V-OTJG9JcwI0jjRghw_6ZTv38WN
X-Proofpoint-ORIG-GUID: vkh_1V-OTJG9JcwI0jjRghw_6ZTv38WN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_12:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 malwarescore=0
 spamscore=0 mlxscore=0 clxscore=1015 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Folks,

Andreas reminds me that you may have the same questions regarding RFC 8335.=
....

The practice of assigning globally reachable IP addresses to infrastructure=
 interfaces cost network operators money. Normally, they number an interfac=
e from a IPv4  /30. Currently, a /30 costs 80 USD and the price is only exp=
ected to rise. Furthermore, most IP Address Management (IPAM) systems licen=
se by the address block. The more globally reachable addresses you use, the=
 more you pay.

They would prefer to use:

- IPv4 unnumbered interfaces
- IPv6 interfaces that have only link-local addresses

                                                                    Ron



Juniper Business Use Only

-----Original Message-----
From: Ron Bonica=20
Sent: Monday, March 29, 2021 10:50 AM
To: David Ahern <dsahern@gmail.com>; Zachary Dodds <zdodds@gmail.com>; Isha=
an Gandhi <ishaangandhi@gmail.com>
Cc: Andreas Roeseler <andreas.a.roeseler@gmail.com>; David Miller <davem@da=
vemloft.net>; Network Development <netdev@vger.kernel.org>; Stephen Hemming=
er <stephen@networkplumber.org>; Willem de Bruijn <willemdebruijn.kernel@gm=
ail.com>; junipeross20@cs.hmc.edu
Subject: RE: rfc5837 and rfc8335

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
From: David Ahern <dsahern@gmail.com>
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
