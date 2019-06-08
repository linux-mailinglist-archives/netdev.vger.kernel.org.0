Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3F139B7F
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 09:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfFHHTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 03:19:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34220 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726204AbfFHHTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 03:19:37 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x587JQMn021118;
        Sat, 8 Jun 2019 00:19:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+2R3Wn0BLwTIFBrU4UkroiQVENlCXZklJFYUVVrul3o=;
 b=RV28bZ21TgbWLFx5La/zm0xlAeUvsVwEkWKsayWUfbIW7sieMXI0LEd6B/GxZtGpw37c
 rh1mBwaOCkZgfkS68Ifw/CvQ7EXrTX6nDVKJWkLxHr6SleLT5CDtSeoc8PFRgqYOJ2Hh
 sTvxxkSbUt5MD4nYqh3pfGcczpzVaR6XR2E= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2syydvh841-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 08 Jun 2019 00:19:26 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 8 Jun 2019 00:19:25 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 8 Jun 2019 00:19:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2R3Wn0BLwTIFBrU4UkroiQVENlCXZklJFYUVVrul3o=;
 b=MmHkZvQFXc0m59dBZAsA33ra4hZywEu6xJxARBwsPPcpd1PmTT/cnGreO64BXVtJDI97hTtc88cDLPZJtiAU5QvytMYV5isafQ7E9yq1VFzvvdbnU23eGRZt5nY663TwRMqYVfzgqnp5fBQk0L56+GYdY5LKv0S1Jw5VLTeZGsk=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1375.namprd15.prod.outlook.com (10.173.233.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Sat, 8 Jun 2019 07:19:23 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Sat, 8 Jun 2019
 07:19:23 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stefano Brivio <sbrivio@redhat.com>
CC:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Topic: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Index: AQHVHKR0wP/xeYS/HEuAq3WE7PiYfKaPG6OAgAAF3wCAABi1AIACBb2AgAAFWICAABZlAA==
Date:   Sat, 8 Jun 2019 07:19:23 +0000
Message-ID: <20190608071920.rio4ldr4fhjm2ztv@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
 <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
 <fbe7cbf3-c298-48d5-ad1b-78690d4203b5@gmail.com>
 <20190606231834.72182c33@redhat.com>
 <05041be2-e658-8766-ba77-ee01cdfe62bb@gmail.com>
 <20190608054003.5uwggebuawjtetyg@kafai-mbp.dhcp.thefacebook.com>
 <20190608075911.2622aecf@redhat.com>
In-Reply-To: <20190608075911.2622aecf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:102:2::49) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:14ab]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d03db69-2b26-4e6e-e9f2-08d6ebe1a183
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1375;
x-ms-traffictypediagnostic: MWHPR15MB1375:
x-microsoft-antispam-prvs: <MWHPR15MB137599A8D433F49258832A31D5110@MWHPR15MB1375.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0062BDD52C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(376002)(136003)(346002)(366004)(189003)(199004)(53936002)(305945005)(25786009)(14454004)(7736002)(99286004)(6246003)(4326008)(256004)(8936002)(2906002)(6116002)(186003)(81156014)(81166006)(8676002)(316002)(6916009)(54906003)(73956011)(66946007)(66476007)(11346002)(66556008)(86362001)(6486002)(64756008)(1076003)(66446008)(76176011)(386003)(6506007)(476003)(446003)(52116002)(6512007)(486006)(46003)(9686003)(53546011)(71200400001)(102836004)(478600001)(68736007)(6436002)(71190400001)(229853002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1375;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YVcLbRZ6uoftzT0uvUV1w7ZLFutkcIbiHoDaNfQDCdHIS6RB3stTC7KVerKXf2YmGLMfmP0JEELkdGtPV6xRIczwp38fOT413sIgYL9/dVXg6XqzTc/uCou9JZG85wukw4YVgzEU6soFRoLD1EqpRTmVkdNLI5fJrD5ySfDtLA26X2aZ+YBsN9QBa1BRJfa/UCF4LAslRzFzePRXvxbmBz9ud0eUd2Nc5ja6OcqWaAD5GyAj9+YCa7Lu+ORXwlzgya8paNp5620VZyeZUJBh3MRM0x+NRz4fAyvsjlg2ceOTNdVWol2PZmHKpcgG/P/b6WGPGPuqMVHqX1098D6GmsxvCOGRgZYRnmSaQimlv3WPGhvKVWHY/rS1KhISTBhR4XGskVrU8ZEyYBBhmcYdZRVqTO63QLNWOToL5NlUWx4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9D876B74B7344046AD497E049692FE8F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d03db69-2b26-4e6e-e9f2-08d6ebe1a183
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2019 07:19:23.3543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1375
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-08_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906080055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 07:59:11AM +0200, Stefano Brivio wrote:
> On Sat, 8 Jun 2019 05:40:06 +0000
> Martin Lau <kafai@fb.com> wrote:
>=20
> > On Thu, Jun 06, 2019 at 04:47:00PM -0600, David Ahern wrote:
> > > On 6/6/19 3:18 PM, Stefano Brivio wrote: =20
> > > > On Thu, 6 Jun 2019 14:57:33 -0600
> > > > David Ahern <dsahern@gmail.com> wrote:
> > > >  =20
> > > >>> This will cause a non-trivial conflict with commit cc5c073a693f
> > > >>> ("ipv6: Move exception bucket to fib6_nh") on net-next. I can sub=
mit
> > > >>> an equivalent patch against net-next, if it helps.
> > > >>>    =20
> > > >>
> > > >> Thanks for doing this. It is on my to-do list.
> > > >>
> > > >> Can you do the same for IPv4? =20
> > > >=20
> > > > You mean this same fix? On IPv4, for flushing, iproute2
> > > > uses /proc/sys/net/ipv4/route/flush in iproute_flush_cache(), and t=
hat
> > > > works.
> > > >=20
> > > > Listing doesn't work instead, for some different reason I haven't
> > > > looked into yet. That doesn't look as critical as the situation on =
IPv6
> > > > where one can't even flush the cache: exceptions can also be fetche=
d
> > > > with 'ip route get', and that works.
> > > >=20
> > > > Still, it's bad, I can look into it within a few days.
> > > >  =20
> > >=20
> > > I meant the ability to dump the exception cache.
> > >=20
> > > Currently, we do not get the exceptions in a fib dump. There is a fla=
g
> > > to only show cloned (cached) entries, but no way to say 'no cloned
> > > entries'. Maybe these should only be dumped if the cloned flag is set=
.
> > > That's the use case I was targeting:
> > > 1. fib dumps - RTM_F_CLONED not set =20
> > I also think the fib dump should stay as is.
> >=20
> > To be clear, I do not expect exception routes output from the
> > 'ip [-6] r l'.  Otherwise, I will get pages of exceptions
> > that I am not interested at.  This should apply for both
> > v4 and v6.
>=20
> I also agree it makes more sense to filter routes this way.
>=20
> But it wasn't like this before 2b760fcf5cfb, so this smells like
> breaking userspace expectations, even though iproute already filters
> routes this way: with 'cache' it only displays routes with
> RTM_F_CLONED, without, it won't display exceptions, see filter_nlmsg():
Thanks for pointing it out.

>=20
> 	if (filter.cloned =3D=3D !(r->rtm_flags & RTM_F_CLONED))
> 		return 0;
>=20
> This, together with the fact it's been like that for almost two years
> now, makes it acceptable in my opinion. What do you think?
With learning the above fact on iproute2,
it makes even less sense to dump exceptions from the kernel side
when RTM_F_CLONED is not set.

> If we agree on this, I'll go ahead and start changing this in my patch
> for IPv6.
