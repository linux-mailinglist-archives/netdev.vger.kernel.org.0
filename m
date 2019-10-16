Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97BB0D88AC
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 08:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388884AbfJPGf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 02:35:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34652 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388357AbfJPGf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 02:35:26 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9G6Ycn9003507;
        Tue, 15 Oct 2019 23:35:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=FqqPAkOwPOxYMny1MVnhfh8veEvMj/rTD0hIJ1bGOw0=;
 b=MESE+j5MO5AHNFtfY2duYko51XgmYj9hRyYY3bCV3wQb+aZaiU9VIPOC1d2Vlz5JSY34
 RYnR5TpyXLVUi09MS9DAUK6QxA2glaI+ExZ/ztX6EOZYhjydvgYr/rjJ4BsCq1pfPqdl
 i3PB/GT5pTvVwK7bxMMGfBtj3aCqrehNA/4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vnccacppu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 23:35:19 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 15 Oct 2019 23:35:18 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 15 Oct 2019 23:35:17 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 15 Oct 2019 23:35:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXY27YjMeOyLa41k1UgKjykNe4U2ux8RIkFG8GnA85TjiX65ycAVpe6G/Rkbi07m2puuZFsx0YrGVJCmhT+B/8HMeoAwa2gR4Fp5fawjK3xo26/OUYPmo+M2lJ17bCWdk5c4PqWki3KWy+dcgWbzuzdSsLsmAL4jlLlMP4RhdEuVphjuTUEbN62m7xL3vT8CaSlHAVITdrONUG2/N2l//ZYUQADS52liqqXwaLd++HpVtkM0+RIoJjre3H0tojjTZJ+1zPz7GiTmAGgIY7Ro7UP2jv1lGZeD+9FjQYd8He3ceYP66mKIA1JT8eZNPufveCC+LBZnuND5fUmve4928g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqqPAkOwPOxYMny1MVnhfh8veEvMj/rTD0hIJ1bGOw0=;
 b=aRfELgFtf+hVGX1sryLHR8eorOphMPTi76f6kswqT7XzO6XXgBQ9xoN3pJzs/kLTtU2sCXKwZCAjx6O2QHgOm9kvWY4GSqOcWD+vJFOwUYCRNcrpTCU9mFdjz5THTkyzDaY1MzdTF+odOQPb8fZhk1tTOJO5PF1lC0zunFkV3xoyuKRGNQ/+zuG/T0hO/vUDgDkFJBwWGtAcxdWw0dS4kqobycUiMOERw3oIKpczi+EVACMAB9xKfDVPOepPoBhtmhG8XQQEqmU5CgqfKCXXn2wwKALW3Xxebw4p5AW08/8msYmf6b3mVYEOuBMXSy6FdTQy6cQ7dFeNilsCLYm9VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqqPAkOwPOxYMny1MVnhfh8veEvMj/rTD0hIJ1bGOw0=;
 b=XT7wrL2hs/Wge4oITj2ClHt+TByiqfLx3Hxcz8/0OEdJY8S2tJKFpxRjqnoZZUSMMj0arGCKaMr2JkcjzsWKb4Xd7tSpzuFitf6rS7f1+E8Le0Tdf2CIYCF0n5LIWYKn24N3uF/GhXmQ6+5Ba0aAaeaNuc5aNNVpHghyqkfbWVw=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3071.namprd15.prod.outlook.com (20.178.252.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 16 Oct 2019 06:35:16 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 06:35:16 +0000
From:   Martin Lau <kafai@fb.com>
To:     Wei Wang <weiwan@google.com>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@idosch.org>,
        "Jesse Hathaway" <jesse@mbuki-mvuki.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: Race condition in route lookup
Thread-Topic: Race condition in route lookup
Thread-Index: AQHVfrqzp034SiLNvUyIFpgTa/vMKqdTjKQAgAH4ioCAABJQAIAAJNSAgADadwCAArbUgIABHgEAgAFlOwCAACDagIAA6JAA
Date:   Wed, 16 Oct 2019 06:35:15 +0000
Message-ID: <20191016063512.fnq7e74hrnqdsj7f@kafai-mbp.dhcp.thefacebook.com>
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter>
 <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter>
 <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
 <20191012065608.igcba7tcjr4wkfsf@kafai-mbp.dhcp.thefacebook.com>
 <CAEA6p_A_kNA8kVLmVn0e=fp=vx3xpHTTaVrx62NVCDLowVxaog@mail.gmail.com>
 <20191014172640.hezqrjpu43oggqjt@kafai-mbp.dhcp.thefacebook.com>
 <9d4dd279-b20a-e333-2dd6-fe2901e67bce@gmail.com>
 <CAEA6p_A_zB0uLn34UeCpXOSQZiOsPFfcfvDtmNZWrks6PCj0=g@mail.gmail.com>
In-Reply-To: <CAEA6p_A_zB0uLn34UeCpXOSQZiOsPFfcfvDtmNZWrks6PCj0=g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0048.namprd08.prod.outlook.com
 (2603:10b6:a03:117::25) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::4559]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4567c2ba-acf8-41b9-712d-08d752030149
x-ms-traffictypediagnostic: MN2PR15MB3071:
x-microsoft-antispam-prvs: <MN2PR15MB3071AEA5F72988A0C0528CC7D5920@MN2PR15MB3071.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(396003)(366004)(376002)(136003)(199004)(189003)(5660300002)(1076003)(4326008)(6436002)(102836004)(186003)(6506007)(53546011)(6246003)(46003)(6486002)(86362001)(229853002)(6512007)(9686003)(316002)(25786009)(256004)(66946007)(66476007)(76176011)(6916009)(52116002)(71200400001)(14444005)(99286004)(66556008)(64756008)(66446008)(71190400001)(6116002)(446003)(11346002)(486006)(8676002)(476003)(386003)(81156014)(81166006)(54906003)(8936002)(2906002)(14454004)(7736002)(478600001)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3071;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: epCuQjBMl+RBbUZC6qSNNVoo5+QgsluXtcsCRD9xrP6w3gGGdDRR8zDoC2jyn2SU3oHQ0qZ6nt/iydl6u3Jfwv5Twwu4j574XQY64DwJXnYuhQD7lcTr7Ks3BziEuvJxmt+HklaEM15x6caynv8KuxKxQ6YGTL1v4xRCT+5jwEfzo48gbRTK/ivB72WQrqMPceIsFJ0m9K5D5uuLU6NfxL9bJKB2GNxGGgL1/0HTWmGWmCGZ3IU3V9mYJD9a14p9ogSyKPwW3d59Pt9cvW+PQDgM0xJe2gFf4kssCuG1KrUoUz2u2mQ8fWtVJ3oDcPUu/TtHKGmO5aFboIR8A5hHsxv2uUcK25iMI7ubidT4ZUsJpxCZeOZb3u4fZlDYcQVat5d6DEvEmflui1PKiDbvHQnKyUcK8+RR6WkgaRgSNM4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7DA86A33E8AC244E908DADD686034BF6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4567c2ba-acf8-41b9-712d-08d752030149
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 06:35:15.8802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O2FluCaQNA7a5mLb04DpgIxFhUCeGW++Oolxxl1bcKBndVaqDh7/6RLmn5e1tLCl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3071
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_02:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160060
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 09:42:49AM -0700, Wei Wang wrote:
> On Tue, Oct 15, 2019 at 7:45 AM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 10/14/19 1:26 PM, Martin Lau wrote:
> > >
> > > AFAICT, even for the route that are affected by fib6_update_sernum_up=
to_root(),
> > > I don't see the RTF_PCPU route is re-created.  v6 sk does
> > > dst_check() =3D> re-lookup the fib6 =3D>
> > > found the same RTF_PCPU (but does not re-create it) =3D>
> > > update the sk with new cookie in ip6_dst_store()
> > >
> Hmm... That is a good point. Why does v4 need to recreate the dst
> cache even though the route itself is not changed?
> Now that I think about it, I agree with Martin's previous comment: it
> probably is because v4 code does not cache rt->rt_genid into the
> socket and every user of the rt is sharing the same rt_genid stored in
> the route itself.
Exactly	:) If no re-create, dst_dev_put() can be avoided.
The root cause is not really related to the global NS rt_genid.
A granular rt_genid may help to reduce the race on dst_dev_put()
but it will still happen.  (that aside, improving the NS rt_genid
would still be great).

Thinking more about it,	this issue should not be limited to input.
I think you fix is right.

>=20
> >
> > That's fine. The pcpu cache is per nexthop (fib6_nh) for a specific
> > gateway/device.
> >
> > The invalidate forces another lookup for the intended destination after
> > the change to the fib. If the lookup resolves to the same fib entry and
> > nexthop, then re-using the same cached dst/rt6_info is ok.
