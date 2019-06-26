Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52CA574FC
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 01:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfFZXoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 19:44:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4630 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726410AbfFZXoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 19:44:12 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5QNhgSm006076;
        Wed, 26 Jun 2019 16:43:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OPt0+aQu0EdCFoNb3g7E8gC5dnojXiR6cAzDC+sAzTk=;
 b=ma9Svl366+vnWoAcVuHkhhAyfYg67w8TwE1ICEbnNm62vXRuD+2bR9GADaE8IAU6c4Fb
 JHhLYg91p5evMTYZl0CbjizRXWmHbkmni/9qSMmqUgs8D+ayhq7M7AlZNUCCpQzV9V19
 AaVPaDYI3+HpyY0YlxHAABnDlfLy6lx4XfU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2tceeh0xc5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Jun 2019 16:43:42 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 26 Jun 2019 16:43:40 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 26 Jun 2019 16:43:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=tmQkiFNgsJs/z/rtcntnKwbkG88GNPe1XcX6KhPl/Lqf81Y3NR19n+SGe0q0eDq0ONgst6T4X3HJxDIcM+w+0NuDXFfdkCgOq4glcLvdwZmetND/N40Sr4w1Kf55XtKTIPIkCuLF4FE7o1MZkPaaXalsJsmkHrmt1dmkrzyErNM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPt0+aQu0EdCFoNb3g7E8gC5dnojXiR6cAzDC+sAzTk=;
 b=kcc6MzqnMArC54SVl2rAnJJKSbYaoDuIH8dQWoiSEQSYIVVZCIoXta7OvwVbaARiTDPpf3R0h4ElyZgAKki670pwlxxr3jQ22uG6QezxTRh5vAXu8AgAzNiCgMChEM3Zic2ZlOMzHtT6NhhwoX5zEWo2ejTxrk4e962k4B08jsk=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPt0+aQu0EdCFoNb3g7E8gC5dnojXiR6cAzDC+sAzTk=;
 b=HJkVSjDOtb1bSqeusbuo0iZjGpYfc6lpnMQxGjrFLM4xcYR8uGQfhpS8oThHh0uWnyLWZp1tmJKvGTL0HDWPc4QWRtAud606oZ8Xj68YBelsLd5Bw45Rm2Xm8LWhyc6jDZcjp7PWJd+nX9mQjcbuSe5Stm+diI2bF31mD2nldOI=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB3059.namprd15.prod.outlook.com (20.178.221.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 23:43:39 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::e594:155f:a43:92ad]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::e594:155f:a43:92ad%6]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 23:43:39 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the bpf tree
Thread-Topic: linux-next: Fixes tag needs some work in the bpf tree
Thread-Index: AQHVLGtWobJf9y3bFk6A9OxwhHLb36augAKAgAAXNQCAAAHggA==
Date:   Wed, 26 Jun 2019 23:43:38 +0000
Message-ID: <20190626234333.GA20313@tower.DHCP.thefacebook.com>
References: <20190627080521.5df8ccfc@canb.auug.org.au>
 <20190626221347.GA17762@tower.DHCP.thefacebook.com>
 <CAADnVQJiMH=jfuD0FGpr2JmzyQsMKHJ4pM1kfQ8jhSxrAe0XWg@mail.gmail.com>
In-Reply-To: <CAADnVQJiMH=jfuD0FGpr2JmzyQsMKHJ4pM1kfQ8jhSxrAe0XWg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0023.namprd22.prod.outlook.com
 (2603:10b6:300:ef::33) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:d2c9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 054b0d0a-89d7-40b7-372a-08d6fa901ce5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR15MB3059;
x-ms-traffictypediagnostic: BN8PR15MB3059:
x-microsoft-antispam-prvs: <BN8PR15MB30591F3993FE14FF9B71A638BEE20@BN8PR15MB3059.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:513;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39860400002)(376002)(346002)(366004)(199004)(189003)(53754006)(6486002)(99286004)(11346002)(1076003)(256004)(6436002)(2906002)(316002)(446003)(229853002)(54906003)(7736002)(476003)(6506007)(386003)(186003)(86362001)(14454004)(53546011)(102836004)(6916009)(478600001)(486006)(305945005)(6116002)(66946007)(66476007)(52116002)(73956011)(64756008)(81156014)(81166006)(6246003)(6512007)(76176011)(33656002)(8676002)(53936002)(25786009)(71190400001)(71200400001)(66446008)(5660300002)(68736007)(4326008)(8936002)(66556008)(46003)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB3059;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 08zHEEVX2QN3MdNC03jT7ajRgy1JqHCLICXjK+FyIUTBngFDDAPWsekSDrEEK55oB9XYY8scEheHgcxScZYGpc3hWl2H2u4E/FgIdnXO+Nat0HTeoPjXiqRQFS929kWpDu3DkpYFaxhmllBMy2w+8O8bV1r+BQWr+M3HgS+trH+vBqqLeFj+FRMa1bSZIgjJ5M+iuktS9Na5m2CO487RiZPnKfiLgHXv1L/u8fhFl7r632f6eric+r7o/oVvxmyRy8OdgE7dxAks6pIyjnGX5OydOS+Ujg0MUKLc37Y2IJNctNa0ukuMMTMvlT66XjMMxZ5vxjQMDJ21IqSURx78is7VC53Sjplv8UIyDvFpBa2+9FRtFz+AkkayXb43jkGisS3c/CSwuulBFsd0uYxBljcwmiVnJjukl4/rvzoyqr0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <681F0949CE4E94498E54E86A4258CDF0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 054b0d0a-89d7-40b7-372a-08d6fa901ce5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 23:43:38.8861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3059
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=854 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260273
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 04:36:50PM -0700, Alexei Starovoitov wrote:
> On Wed, Jun 26, 2019 at 3:14 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Thu, Jun 27, 2019 at 08:05:21AM +1000, Stephen Rothwell wrote:
> > > Hi all,
> > >
> > > In commit
> > >
> > >   12771345a467 ("bpf: fix cgroup bpf release synchronization")
> > >
> > > Fixes tag
> > >
> > >   Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from
> > >
> > > has these problem(s):
> > >
> > >   - Subject has leading but no trailing parentheses
> > >   - Subject has leading but no trailing quotes
> > >
> > > Please don't split Fixes tags across more than one line.
> >
> > Oops, sorry.
> >
> > Alexei, can you fix this in place?
> > Or should I send an updated version?
>=20
> I cannot easily do it since -p and --signoff are incompatible flags.
> I need to use -p to preserve merge commits,
> but I also need to use --signoff to add my sob to all
> other commits that were committed by Daniel
> after your commit.

I see... Sorry for the hassle!

>=20
> Daniel, can you fix Roman's patch instead?
> you can do:
> git rebase -i -p  12771345a467^
> fix Roman's, add you sob only to that one
> and re-push the whole thing.

Thanks!
