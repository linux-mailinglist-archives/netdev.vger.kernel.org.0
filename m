Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC56D88B2
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 08:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389203AbfJPGjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 02:39:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23824 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388357AbfJPGji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 02:39:38 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9G6bLKj018760;
        Tue, 15 Oct 2019 23:39:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=2Z3byKjRW62HaJAimRVJUJ4zGPi0Cl4vQYpT7zEOOK0=;
 b=dHMB/9NwORAhXXIMQA8Y0w3wHApsDhHWkFbur7Zqs/T+9rXW0s4Vrmbclve7nD+dQt8o
 Nt2G1pGJAnbjukdNydWuZd2LO/AgY800ByHsVbDJx1qnHR0gzbVnFiLXUkYjc5Q+SH7C
 S2u5kqDCWIR3oWSOd/ZIuLjrt1BnjW3ArfQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2vn6m8dyre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Oct 2019 23:39:33 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 23:39:33 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 15 Oct 2019 23:39:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NAtHvjT5Zc7qHTMD0sBfLtQyjfBllir2zfNdU1P9vaFc18AKaYO0YTh2RFyv/b8I9gMZBumo5d/GY5W1BkQTXRaNmk9XYR3exoPlOg4cKz5cZBGbC3fqcfsYtNiZLvEOFk9BzYQqBkzUE9xLRXGDs8e6i00ijPV0dzlMWLfRxKIJ1L4gfe8QEjeVb4pzNZzvIs+gAt+Cr9YP20mLEnQ9bZTXIjtrKsAvJL6DSXE3r1Z45OrTNGmWpBsWO0K0hAN23I90Tw+KMnfPNJUxf5joOvPRURBsSsph/MKW+8FvOYO5aBT+rHTXkRW0RrHkkAp70nw2vmXKwnF24v1IaE5PaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Z3byKjRW62HaJAimRVJUJ4zGPi0Cl4vQYpT7zEOOK0=;
 b=LT8ZBEA5bwpaNLcdTOtkEH6h9HTGI3j1mv1UXx2YaAm5NyLgWU0Ma2WBpW6alzBUbIOl+d8oI8AIcO+2/1rvWYnVW/QFjI3o+QpUkgOjw9RjtwrJ2xC3vnq73qatejvFXIuEOvqg4ZMKup+OWxXZRBucvWBPMhsJr3Dx0xLgxOCXLtG7XrDonSulvTtGLPTn9DBlsFlrP8ID4/6a9t2Lw2idY163tJpLreXj6bT/Q2gGE6zZnnw98USpjVSp16zMaaqIHr0Yu9X/UXHLGkaWa9jF5w6kHxgyuMNTBme81cjpHiW5yxx9gH55tiNWRS79WoGRjvOjBgOi4QHXDzeGOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Z3byKjRW62HaJAimRVJUJ4zGPi0Cl4vQYpT7zEOOK0=;
 b=V4u16+uadUFWyMkf+jdK/Vr4m1wKQQYbhUTP/+R/OTIpntw6x8uaC0wSaHy3q1GR3QEvR2Ug96uP083gcmfIpatZrRaLxCrGScM431bPHn5yaknFMD413EC6V8Dykr0MTFYHuoTioWSo1o2u9Kxkyo1g59l4dXlclO46RL9fZIE=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3661.namprd15.prod.outlook.com (52.132.173.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 16 Oct 2019 06:39:32 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::d5a4:a2a6:a805:6647%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 06:39:32 +0000
From:   Martin Lau <kafai@fb.com>
To:     Wei Wang <weiwan@google.com>
CC:     Jesse Hathaway <jesse@mbuki-mvuki.org>,
        Ido Schimmel <idosch@idosch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: Race condition in route lookup
Thread-Topic: Race condition in route lookup
Thread-Index: AQHVfrqzp034SiLNvUyIFpgTa/vMKqdTjKQAgAH4ioCAABJQAIAAJNSAgAYQMgCAACWQgIAA6WEA
Date:   Wed, 16 Oct 2019 06:39:31 +0000
Message-ID: <20191016063928.rwxe65paunw3jwel@kafai-mbp.dhcp.thefacebook.com>
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter>
 <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter>
 <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
 <CANSNSoVMXcPpnHBYvDJ9P4PVB2pLGEBHW2j-iD7QqQrFmGFt_Q@mail.gmail.com>
 <CAEA6p_BQp1O6jGc+RY2YAHFVC3df7MEm9he7cajUnccVCzkMvw@mail.gmail.com>
In-Reply-To: <CAEA6p_BQp1O6jGc+RY2YAHFVC3df7MEm9he7cajUnccVCzkMvw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0060.namprd22.prod.outlook.com
 (2603:10b6:300:12a::22) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::4559]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65429493-4008-4316-4caa-08d7520399fd
x-ms-traffictypediagnostic: MN2PR15MB3661:
x-microsoft-antispam-prvs: <MN2PR15MB3661694C490BB61F62910709D5920@MN2PR15MB3661.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(39860400002)(136003)(396003)(376002)(346002)(366004)(189003)(199004)(51444003)(256004)(6512007)(71190400001)(6436002)(86362001)(6116002)(102836004)(71200400001)(81166006)(186003)(8676002)(66946007)(81156014)(478600001)(6486002)(53546011)(229853002)(64756008)(66476007)(66446008)(6246003)(9686003)(66556008)(14454004)(8936002)(305945005)(99286004)(316002)(52116002)(7736002)(76176011)(6916009)(5660300002)(4326008)(386003)(486006)(476003)(2906002)(11346002)(446003)(54906003)(1076003)(46003)(25786009)(6506007)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3661;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1EsVg05gCu3kER1srNBGcjsM5HJOdDDN+hJHV8FnbLBI3cNyUaccrU5R783PntlQQ9EQdouM1puoYVlgR2f+uzvuxljnzkVsz9f/jmLN45TTaJ4w6XOLo8CpekF45vtMkSy4ltOQxRty+SwzpgTbOncWF/g80Z0+mClbBm4dpkNQ8XC7bocu9EQhU21+9j6dXgcNO5NpeMk6hSVsJCE+0zSUgznZSp/AGbmTha7D0ssHgqpnRHI35J9gisSvsx4AYwwJrZSi37sGn3JpRHFOfHxrbPhRrOehvt5YpjZFMebbIgVBskBJRwDzIjVfUgeOaeWQo3IEMSgdF1Wy7142UmxK1jDEb6Zss4oSlb6QlZVejA6H6lve0zBbZlI5yoGACwHEjgwp0L57d/p4Mj7i+wcAp57W2lVoMb2uOhXKt/0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6817D61DF4F0D445A56C3BC8FCFE0EC1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 65429493-4008-4316-4caa-08d7520399fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 06:39:32.0377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /hPqQ8puVBrAuSICgCrcPh9Zd08fcUt3TvcTF8pjhOymNyZVV+IUQCZfrfnXKY37
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3661
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_02:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015 suspectscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160061
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 09:44:11AM -0700, Wei Wang wrote:
> On Tue, Oct 15, 2019 at 7:29 AM Jesse Hathaway <jesse@mbuki-mvuki.org> wr=
ote:
> >
> > On Fri, Oct 11, 2019 at 12:54 PM Wei Wang <weiwan@google.com> wrote:
> > > Hmm... Yes... I would think a per-CPU input cache should work for the
> > > case above.
> > > Another idea is: instead of calling dst_dev_put() in rt_cache_route()
> > > to switch out the dev, we call, rt_add_uncached_list() to add this
> > > obsolete dst cache to the uncached list. And if the device gets
> > > unregistered, rt_flush_dev() takes care of all dst entries in the
> > > uncached list. I think that would work too.
> > >
> > > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > > index dc1f510a7c81..ee618d4234ce 100644
> > > --- a/net/ipv4/route.c
> > > +++ b/net/ipv4/route.c
> > > @@ -1482,7 +1482,7 @@ static bool rt_cache_route(struct fib_nh_common
> > > *nhc, struct rtable *rt)
> > >         prev =3D cmpxchg(p, orig, rt);
> > >         if (prev =3D=3D orig) {
> > >                 if (orig) {
> > > -                       dst_dev_put(&orig->dst);
> > > +                       rt_add_uncached_list(orig);
> > >                         dst_release(&orig->dst);
> > >                 }
> > >         } else {
> > >
> >
> > Thanks Wei for your work on this issue,
> >
> > Any chance this patch will make it into 5.4?
>=20
> I can submit the patch to NET branch if everyone agrees with this one lin=
er fix.
Acked-by: Martin KaFai Lau <kafai@fb.com>

I don't think it is a very critical bug though.  Not sure
how far it should be ported.

> Then I believe it will be patched into the next 5.4 release automatically=
?
