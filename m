Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044A5145E76
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 23:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgAVWRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 17:17:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29806 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725884AbgAVWRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 17:17:47 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00MM8x8J021854;
        Wed, 22 Jan 2020 14:17:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=GN3kjQ1Gfv57lPQ4zHImwcQZd07Ww75wlrsECSixLbY=;
 b=a/K6ZKr5v3G+2sitJW/0V/aR0kGxwJG2VvfQmMb5ZkZ/5aqiZmU3JgoyOFjYZz5ZZcw5
 GTZvciOi9pnEsO2/ABClz9L5xSGL2hl7JaU40mkNi9pzaiETwkTUQWmFjQveQTVfDbUx
 +OPBDh/O1Q1uM2BYc+usQO14Kq/meOe/HZY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2xp5vs6hvd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Jan 2020 14:17:29 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 22 Jan 2020 14:17:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJHsIHTmXnzT97ZhJbXYRS5dG6Ncf46II1NGu4i6k7oXjzgSdctbgs44S3QTiPPkitYAVFq3LzkpLPBd+rCVpcqAX4bYb5HHvxqpo1On3Z0gQZH9Y0zgwNBvGxpCMqK++ilQkPWoymCtM0GZ9yqpgni9aRizWLBEWxkhjq6M22yjIqgHnRSVxVN4S20Dl7WJFuVHiSlgVRT8/ZngY9du6C80CRp0sMqdJz5B8EXfmPOLjqgw5g+KzOg25wuf4E0j7j2+JDE1B/Wx7J7iPJAbi8UT/Pv1aHAFurmmDQqzESoCQI4uz7ZOj+xU6nImGOXC0HLzuP7V6LioCUHTvjJGHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GN3kjQ1Gfv57lPQ4zHImwcQZd07Ww75wlrsECSixLbY=;
 b=H9tQfkX/g50znUuMQedqL768RfkgjqzPgYa87iPiOASMec/1Sd5cdh9KxHcVhTvF/IGiPc+JttmYErtjoAeO9ICRTwe6zvzXUTlhMNHNVCc9KMxJhnBjNRWQZ4t00o5GDxscQNEbdU0ViVSQq7BIQmgAgc7GEIAbZ2u2LuoCuhPbzCdFGPQN/rXxMKWbkhxeZydp5EN3FAXD2YlYG4x3a+lCeTJ6CYVo0ZRIMusDZDlfnMLG0HWP2BQh+K/FLloKS86IEqAr5/CD4tKxAnUWGIISqxM2xfTH+I++QEZZwtLNtr3xjZkf4L5rOWxkGXY4EBPzWYdjoYdiMuAt8vORGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GN3kjQ1Gfv57lPQ4zHImwcQZd07Ww75wlrsECSixLbY=;
 b=RLFlRRnc9hzhX3xFVtXmHtpFGfA+gZf8XEh6gUnm/+zBt0UliPHjSZHiJLAKK2WGuOWXbvvj+kzU6t96Asg6L/82j/bwp1h/gbQ4ifNP7BaYDGHLAGtJAIuo4dcbMP8/ymB1DLlzWuPbuQ4mixVKSgGhDgaEwWtCXokeax6tqLo=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2637.namprd15.prod.outlook.com (20.179.148.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 22 Jan 2020 22:17:24 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 22:17:24 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::ccdf) by MWHPR18CA0045.namprd18.prod.outlook.com (2603:10b6:320:31::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.19 via Frontend Transport; Wed, 22 Jan 2020 22:17:23 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Kernel Team <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/3] bpf: tcp: Add bpf_cubic example
Thread-Topic: [PATCH v2 bpf-next 3/3] bpf: tcp: Add bpf_cubic example
Thread-Index: AQHV0O8Y5b/yD+QqlkOxhucFUYMpGaf3OveAgAAGlwA=
Date:   Wed, 22 Jan 2020 22:17:24 +0000
Message-ID: <20200122221720.fdfw2sp5fwagl3rm@kafai-mbp.dhcp.thefacebook.com>
References: <20200122064152.1833564-1-kafai@fb.com>
 <20200122064210.1834848-1-kafai@fb.com>
 <CAEf4BzYU2xZkUvK-JP53jrKXnWryACHsaX4JO_trEn=1N9-k1A@mail.gmail.com>
In-Reply-To: <CAEf4BzYU2xZkUvK-JP53jrKXnWryACHsaX4JO_trEn=1N9-k1A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR18CA0045.namprd18.prod.outlook.com
 (2603:10b6:320:31::31) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::ccdf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00db61a3-3df6-4924-4e91-08d79f88db73
x-ms-traffictypediagnostic: MN2PR15MB2637:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB26372760744C085FE1708668D50C0@MN2PR15MB2637.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(396003)(346002)(376002)(199004)(189003)(16526019)(5660300002)(186003)(478600001)(7696005)(4326008)(6916009)(52116002)(86362001)(2906002)(8676002)(81166006)(53546011)(81156014)(8936002)(71200400001)(6506007)(55016002)(66946007)(64756008)(66476007)(66446008)(66556008)(316002)(9686003)(1076003)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2637;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M1QPBsPwV6hpxtTFXRAt1cRRcFyqCSAniIFU1lP3PxT33cvjGH6xc8s60uAEYNx2uXkyf9U6duEVzNZz9WBVOtDHWTv93yYsGFEoEQdmDHn6bifUgJTbTFAZ6yNvAnTPVXW8FrotPlNBtP1fBKBEc0z3OGTKqbbMYI8H3neqF8MfW9BfB1o1Bce43kqoNpdJ5yh1+EYbnLNm2ylUfgtfuhnE7UKrzkEVLBYWprMwkxJlYaph06cZnAHaMzsZyxiSfGZn8cX5sGwS6Ro5T5HdP6+rAFIXM8nlBpGrcBjgBN2AE5NHXRU8mIVxNHcXyMsFz/mnXmMQ/ujQ167N4D2pUH/X6zbdGrkWZhj8uSGTqYHsNgrbvdwrPoAg4hh9HyDdvpbGAxAyYlkJcHCLbFXN+3tcB4IBPSL+lbN8rrL0NVVNBpYpBBd1i6G6glh51etr
Content-Type: text/plain; charset="us-ascii"
Content-ID: <62E4E214827523419BA1D297E46007F3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 00db61a3-3df6-4924-4e91-08d79f88db73
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 22:17:24.4109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cG49Wbl8qbZPokd0aDfBGtgX6QxhrdUOlgnCVsoZbkZ2GzMS//7CHpRL2npLPiy/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2637
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=969
 bulkscore=0 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001220185
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 01:53:45PM -0800, Andrii Nakryiko wrote:
> On Tue, Jan 21, 2020 at 10:42 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch adds a bpf_cubic example.  Some highlights:
> > 1. CONFIG_HZ .kconfig map is used.
> > 2. In bictcp_update(), calculation is changed to use usec
> >    resolution (i.e. USEC_PER_JIFFY) instead of using jiffies.
> >    Thus, usecs_to_jiffies() is not used in the bpf_cubic.c.
> > 3. In bitctcp_update() [under tcp_friendliness], the original
> >    "while (ca->ack_cnt > delta)" loop is changed to the equivalent
> >    "ca->ack_cnt / delta" operation.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
>=20
> just my few cents below...
>=20
> [...]
>=20
> >
> > +static void test_cubic(void)
> > +{
> > +       struct bpf_cubic *cubic_skel;
> > +       struct bpf_link *link;
> > +
> > +       cubic_skel =3D bpf_cubic__open_and_load();
> > +       if (CHECK(!cubic_skel, "bpf_cubic__open_and_load", "failed\n"))
> > +               return;
> > +
> > +       link =3D bpf_map__attach_struct_ops(cubic_skel->maps.cubic);
>=20
> we should probably teach bpftool and libbpf to generate a link for
> struct_ops map and also auto-attach it as part of skeleton's attach...
> I'll add it if noone gets to it sooner
It is in my TODO list.  I am happy to be beaten though ;)

>=20
> > +       if (CHECK(IS_ERR(link), "bpf_map__attach_struct_ops", "err:%ld\=
n",
> > +                 PTR_ERR(link))) {
> > +               bpf_cubic__destroy(cubic_skel);
> > +               return;
> > +       }
> > +
> > +       do_test("bpf_cubic");
> > +
> > +       bpf_link__destroy(link);
> > +       bpf_cubic__destroy(cubic_skel);
> > +}
> > +
>=20
> [...]
>=20
> > +
> > +extern unsigned long CONFIG_HZ __kconfig __weak;
>=20
> you probably don't want __weak, if CONFIG_HZ is not defined in
> Kconfig, then something wrong is going on, probably, so it's better to
> error out early
Thanks for pointing it out.  Will do.
