Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9FC1FC74
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 23:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfEOVzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 17:55:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36356 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726381AbfEOVzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 17:55:02 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4FLCl0X017474;
        Wed, 15 May 2019 14:54:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VSJ18wEGwy75W08pPfgVyMXgVFFHEI6MboIkm+1MaWg=;
 b=Ihp3+TYQ3n8WcQ7w6onbzBEjocAbsikaYbev+GPktChVpPvAJ4v+OoLBbtUEy8G8r5dv
 ZtB1mX2MlDLIwCtOM4JszPB/b5hv03vDC4m89ysO95dzEZhCay0T9u3FnVPYDEnJqEvN
 eh1zg3NbAreOYX/n7A2GmDU+TRyxVlcnCAY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sgt0188br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 May 2019 14:54:50 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 15 May 2019 14:54:49 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 15 May 2019 14:54:49 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 15 May 2019 14:54:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSJ18wEGwy75W08pPfgVyMXgVFFHEI6MboIkm+1MaWg=;
 b=NDGwh3a3iWiIOp3wySfin9p1tUmdlKWz7xdM0lVVmMJ+rOUb4xnKdbCh0AtBsoFlYUCja/aVwY+/59wV7rjPlmJfvKADhFfl7D4+RvkyxsIN2uPiuv6O1PDRR2Id43XWbFrfbNIySV3Y0W4nLZmRhh8Yznt0KTiuwOk3iXOgmd0=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1277.namprd15.prod.outlook.com (10.175.3.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 15 May 2019 21:54:47 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1878.024; Wed, 15 May 2019
 21:54:47 +0000
From:   Martin Lau <kafai@fb.com>
To:     Wei Wang <weiwan@google.com>
CC:     Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>
Subject: Re: IPv6 PMTU discovery fails with source-specific routing
Thread-Topic: IPv6 PMTU discovery fails with source-specific routing
Thread-Index: AQHVCcIoB8QGRT3FL0iSjpfHnIY8CqZp+KyAgAAr1oCAAIvfAIAAU+aAgAF57QCAAAcsAIAAOLoA
Date:   Wed, 15 May 2019 21:54:47 +0000
Message-ID: <20190515215445.jlzbk37xuwtn2den@kafai-mbp>
References: <71e7331f-d528-430e-f880-e995ff53d362@lists.m7n.se>
 <2667a075-7a51-d1e0-c4e7-cf0d011784b9@gmail.com>
 <CAEA6p_AddQqy+v+LUT6gsqOC31RhMkVnZPLja8a4n9XQmK8TRA@mail.gmail.com>
 <20190514163308.2f870f27@redhat.com>
 <CAEA6p_Cs7ExpRtTHeTXFFwLEF27zs6_fFOMVN7cgWUuA3=M1rA@mail.gmail.com>
 <20190515180604.sgz4omfwhcgfn6t3@kafai-mbp>
 <CAEA6p_CneEoUMx+=QOm7sp2iW=1uSoHeOHYPChHqBEqahCa6tQ@mail.gmail.com>
In-Reply-To: <CAEA6p_CneEoUMx+=QOm7sp2iW=1uSoHeOHYPChHqBEqahCa6tQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0042.namprd14.prod.outlook.com
 (2603:10b6:300:12b::28) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:5597]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdcd61d1-7370-4a21-63c5-08d6d97ff276
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1277;
x-ms-traffictypediagnostic: MWHPR15MB1277:
x-microsoft-antispam-prvs: <MWHPR15MB12777D5134CE3B1668B50C8AD5090@MWHPR15MB1277.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(39860400002)(136003)(396003)(376002)(346002)(51914003)(189003)(199004)(64756008)(66556008)(66476007)(52116002)(73956011)(66946007)(256004)(6116002)(76176011)(6916009)(54906003)(66446008)(68736007)(5660300002)(99286004)(46003)(386003)(53546011)(102836004)(6506007)(33716001)(186003)(1076003)(11346002)(446003)(476003)(7736002)(305945005)(486006)(53936002)(4326008)(25786009)(81166006)(81156014)(8676002)(6246003)(8936002)(86362001)(316002)(71200400001)(71190400001)(2906002)(229853002)(6486002)(478600001)(14454004)(6512007)(9686003)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1277;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: esJFMHsBYXCzMUOFozHX8bykRwNh6leTSS/LOLQSKisFRyN/SBI4LxhD1z1pEOs7usK4gRhd8opDZwth07KRywzeaEIYv0B/EuXapIevOD73+6V0OJtkCqNZmdsXy3BhPa99t0F8Loeje/TEHw7KQZ/uY4qWO1JNTU3Ox/831OyUnArX7oiLm8yb1ZtZV8YCkvv9Pm0+jD203wWG++dDdb/aJpeJdFNfcEb2i6t3cV2ego/9RyQzFhujRz666LrPChgSeM1P5HZ7hAQDs3osX4Zepu0jxc1bnKnIc+WxPmbOYToFXkwuOnrUPdJW7fW1B8EqnmHFAPLvi8retloIAIVHU6XggO8l9wY61ZVoMiizgWoYLtB5RwMAMrDRRl7BVNm2hp8jrNxg9jYHxkvl7BEA4xE0L7WgQX3mOVR052A=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4FF3DE7DC50F7843B336E40A7DBE4F95@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cdcd61d1-7370-4a21-63c5-08d6d97ff276
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 21:54:47.7017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1277
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_15:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 11:31:44AM -0700, Wei Wang wrote:
> On Wed, May 15, 2019 at 11:06 AM Martin Lau <kafai@fb.com> wrote:
> >
> > On Tue, May 14, 2019 at 12:33:25PM -0700, Wei Wang wrote:
> > > I think the bug is because when creating exceptions, src_addr is not
> > > always set even though fib6_info is in the subtree. (because of
> > > rt6_is_gw_or_nonexthop() check)
> > > However, when looking up for exceptions, we always set src_addr to th=
e
> > > passed in flow->src_addr if fib6_info is in the subtree. That causes
> > > the exception lookup to fail.
> > > I will make it consistent.
> > > However, I don't quite understand the following logic in ip6_rt_cache=
_alloc():
> > >         if (!rt6_is_gw_or_nonexthop(ort)) {
> > >                 if (ort->fib6_dst.plen !=3D 128 &&
> > >                     ipv6_addr_equal(&ort->fib6_dst.addr, daddr))
> > >                         rt->rt6i_flags |=3D RTF_ANYCAST;
> > > #ifdef CONFIG_IPV6_SUBTREES
> > >                 if (rt->rt6i_src.plen && saddr) {
> > >                         rt->rt6i_src.addr =3D *saddr;
> > >                         rt->rt6i_src.plen =3D 128;
> > >                 }
> > > #endif
> > >         }
> > > Why do we need to check that the route is not gateway and has next ho=
p
> > > for updating rt6i_src? I checked the git history and it seems this
> > > part was there from very early on (with some refactor in between)...
> > I also failed to understand the RTF_GATEWAY check.  The earliest relate=
d
> > commit seems to be c440f1609b65 ("ipv6: Do not depend on rt->n in ip6_p=
ol_route().")
> >
> > How was it working when the exception route was in the tree?
> >
> When adding all exception route to the main routing tree, because
> route cache has dest_addr as /128, the longest prefix match will
> always match the /128 route entry.
Got it.  Thanks for the explanation.

>=20
> > >
> > >
> > > From: Stefano Brivio <sbrivio@redhat.com>
> > > Date: Tue, May 14, 2019 at 7:33 AM
> > > To: Mikael Magnusson
> > > Cc: Wei Wang, David Ahern, Linux Kernel Network Developers, Martin Ka=
Fai Lau
> > >
> > > > On Mon, 13 May 2019 23:12:31 -0700
> > > > Wei Wang <weiwan@google.com> wrote:
> > > >
> > > > > Thanks Mikael for reporting this issue. And thanks David for the =
bisection.
> > > > > Let me spend some time to reproduce it and see what is going on.
> > > >
> > > > Mikael, by the way, once this is sorted out, it would be nice if yo=
u
> > > > could add your test as a case in tools/testing/selftests/net/pmtu.s=
h --
> > > > you could probably reuse all the setup parts that are already
> > > > implemented there.
> > > >
> > > > --
> > > > Stefano
