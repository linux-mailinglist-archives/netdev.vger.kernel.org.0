Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7BD81F9B3
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 20:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfEOSGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 14:06:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49330 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726335AbfEOSGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 14:06:21 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4FI3jDn025702;
        Wed, 15 May 2019 11:06:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=emXuN0Oj004aHVjq9wiQYaRe1OK+HZJvOpI9HBGOH5M=;
 b=HTnHmWrtZFan9I7V+J2YCXPwbG390YWViDllDrYlJCab8exmQFw8aq8iHx4QzLif33k4
 zfzGkl/ws2krYhRqDmbPLTnyLwEosuepckORIplf4V9SemUn19SwhgdgUwIp2V+WwZr8
 hCcyanybHQCBjaBm3STDG23q8tdD1tJRrFs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sgjyxh5e0-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 May 2019 11:06:10 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 15 May 2019 11:06:07 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 15 May 2019 11:06:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emXuN0Oj004aHVjq9wiQYaRe1OK+HZJvOpI9HBGOH5M=;
 b=cT8tNXL/Upu/6qGG/m9xBM96Exe5lAdMohNZRHNA9WFO2Hnd0ZLPO1U0f2Rhc5VPD9J3kKn4SixCSn3YxbbOvBn7ld7xj6Y9lHDThjM6NMMrA8GXb3c6jHld2GH0Bum+NT+oY/eEeLEQ1kaRZ6gQSht55UOVTBU4otP0I13jMmo=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1470.namprd15.prod.outlook.com (10.173.234.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Wed, 15 May 2019 18:06:06 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1878.024; Wed, 15 May 2019
 18:06:06 +0000
From:   Martin Lau <kafai@fb.com>
To:     Wei Wang <weiwan@google.com>
CC:     Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>
Subject: Re: IPv6 PMTU discovery fails with source-specific routing
Thread-Topic: IPv6 PMTU discovery fails with source-specific routing
Thread-Index: AQHVCcIoB8QGRT3FL0iSjpfHnIY8CqZp+KyAgAAr1oCAAIvfAIAAU+aAgAF57QA=
Date:   Wed, 15 May 2019 18:06:06 +0000
Message-ID: <20190515180604.sgz4omfwhcgfn6t3@kafai-mbp>
References: <71e7331f-d528-430e-f880-e995ff53d362@lists.m7n.se>
 <2667a075-7a51-d1e0-c4e7-cf0d011784b9@gmail.com>
 <CAEA6p_AddQqy+v+LUT6gsqOC31RhMkVnZPLja8a4n9XQmK8TRA@mail.gmail.com>
 <20190514163308.2f870f27@redhat.com>
 <CAEA6p_Cs7ExpRtTHeTXFFwLEF27zs6_fFOMVN7cgWUuA3=M1rA@mail.gmail.com>
In-Reply-To: <CAEA6p_Cs7ExpRtTHeTXFFwLEF27zs6_fFOMVN7cgWUuA3=M1rA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:300:4b::30) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:f9cc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92b2fd22-08c1-4e3c-b9e6-08d6d9600008
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1470;
x-ms-traffictypediagnostic: MWHPR15MB1470:
x-microsoft-antispam-prvs: <MWHPR15MB147062B7AD023A43FF5F097ED5090@MWHPR15MB1470.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(346002)(39860400002)(396003)(366004)(376002)(136003)(199004)(189003)(64756008)(66556008)(66446008)(66476007)(73956011)(66946007)(316002)(256004)(5660300002)(6486002)(229853002)(6512007)(9686003)(6436002)(7736002)(478600001)(305945005)(52116002)(1076003)(6506007)(68736007)(53546011)(386003)(102836004)(14454004)(81156014)(6916009)(8676002)(8936002)(33716001)(99286004)(54906003)(81166006)(6116002)(71200400001)(11346002)(476003)(25786009)(4326008)(53936002)(46003)(76176011)(6246003)(446003)(71190400001)(2906002)(86362001)(486006)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1470;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pdEjAy1ZlacAj0OdEZzTx5mcsYEvxoUGsPuIPSF/nFPU96XFlTjrJdhJL/VbGqjsg1+HUgTKKisTe4JLHOYeY/1mKxTeTFsKzfT95DTPnWikDiNcsQUFfzTJ4fKs+5uiEOGeg6Lr4ov2EzR9zqyvyLvCtnG0lG30r2+enT84SKs7OLRowwaZ1yQ0uf/O15bs5oUdMQRd5XDyBiiOu0ZlUeRlV6HclbLQsLhuktppqlZnGI20FzoHuytd5w/iOjy4DfAuPJZXOsNRaQ6zob8gu/OA/VKM1uMz7d7/Ac1ORQSHSoEuet5M8seZ/QBEtq3aR9GYI5yoLSxb0SsR9S4DkxYMnpnbGtdyE69fMFrjo0QOOuyl6DfCqI0vk9IuRsFbz/+RsEXPP/c5jAU76NH8BcdDnSZ+Py/zW2CVtswjvvM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23D9421EBDEC3D448B58411B4EF7EDC9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b2fd22-08c1-4e3c-b9e6-08d6d9600008
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 18:06:06.4847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1470
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_12:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 12:33:25PM -0700, Wei Wang wrote:
> I think the bug is because when creating exceptions, src_addr is not
> always set even though fib6_info is in the subtree. (because of
> rt6_is_gw_or_nonexthop() check)
> However, when looking up for exceptions, we always set src_addr to the
> passed in flow->src_addr if fib6_info is in the subtree. That causes
> the exception lookup to fail.
> I will make it consistent.
> However, I don't quite understand the following logic in ip6_rt_cache_all=
oc():
>         if (!rt6_is_gw_or_nonexthop(ort)) {
>                 if (ort->fib6_dst.plen !=3D 128 &&
>                     ipv6_addr_equal(&ort->fib6_dst.addr, daddr))
>                         rt->rt6i_flags |=3D RTF_ANYCAST;
> #ifdef CONFIG_IPV6_SUBTREES
>                 if (rt->rt6i_src.plen && saddr) {
>                         rt->rt6i_src.addr =3D *saddr;
>                         rt->rt6i_src.plen =3D 128;
>                 }
> #endif
>         }
> Why do we need to check that the route is not gateway and has next hop
> for updating rt6i_src? I checked the git history and it seems this
> part was there from very early on (with some refactor in between)...
I also failed to understand the RTF_GATEWAY check.  The earliest related
commit seems to be c440f1609b65 ("ipv6: Do not depend on rt->n in ip6_pol_r=
oute().")

How was it working when the exception route was in the tree?

>=20
>=20
> From: Stefano Brivio <sbrivio@redhat.com>
> Date: Tue, May 14, 2019 at 7:33 AM
> To: Mikael Magnusson
> Cc: Wei Wang, David Ahern, Linux Kernel Network Developers, Martin KaFai =
Lau
>=20
> > On Mon, 13 May 2019 23:12:31 -0700
> > Wei Wang <weiwan@google.com> wrote:
> >
> > > Thanks Mikael for reporting this issue. And thanks David for the bise=
ction.
> > > Let me spend some time to reproduce it and see what is going on.
> >
> > Mikael, by the way, once this is sorted out, it would be nice if you
> > could add your test as a case in tools/testing/selftests/net/pmtu.sh --
> > you could probably reuse all the setup parts that are already
> > implemented there.
> >
> > --
> > Stefano
