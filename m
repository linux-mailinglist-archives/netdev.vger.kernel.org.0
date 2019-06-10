Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016D83BD07
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389155AbfFJTnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:43:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36850 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389010AbfFJTnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 15:43:39 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5AJWbe4012879;
        Mon, 10 Jun 2019 12:42:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=S1EGp57Fa2qehR1rW12D17qKy6XkaMJlXeWtzEsDtH4=;
 b=ez/qFB+AgGC0W9DU+IzYyt2ecLTgQdLd810VnYaARLvTMPD9hVjCxxoZO6h1FarUjJeG
 OUrktVOZadxmXkyXiFDcnUUVkMIIqastAVqfxevlnHQT9bPtnoKRABB/ysa2uhbVFdAS
 EK694dqoGQ5faruITO13QtQQtwa/uFRd26w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2t08pc6y3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 10 Jun 2019 12:42:44 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 10 Jun 2019 12:42:43 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 10 Jun 2019 12:42:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S1EGp57Fa2qehR1rW12D17qKy6XkaMJlXeWtzEsDtH4=;
 b=PCBKoLtCCXi/28heMoTGCvq9oQmDrO+y/Ew583TGi7y8xeJIBFqiLkbjRl/AEQuReKQAx09yU5QFuVs19gOi6nylBECSTsU3ARz2J56CEj1/AsVenxqkKjcxv0UXtFu9ya0WfGJsHMCiiX5Y6MqfVok2l98nGq7h5zLrCvNWe6w=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1454.namprd15.prod.outlook.com (10.173.235.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Mon, 10 Jun 2019 19:42:41 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 19:42:41 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stefano Brivio <sbrivio@redhat.com>
CC:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Topic: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
Thread-Index: AQHVHKR0wP/xeYS/HEuAq3WE7PiYfKaPG6OAgAAF3wCAABi1AIACBb2AgAAFWICAABZlAIAAgUwAgAAMlICAA2Z3AA==
Date:   Mon, 10 Jun 2019 19:42:41 +0000
Message-ID: <20190610194238.3gke27kflrocrpwo@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
 <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
 <fbe7cbf3-c298-48d5-ad1b-78690d4203b5@gmail.com>
 <20190606231834.72182c33@redhat.com>
 <05041be2-e658-8766-ba77-ee01cdfe62bb@gmail.com>
 <20190608054003.5uwggebuawjtetyg@kafai-mbp.dhcp.thefacebook.com>
 <20190608075911.2622aecf@redhat.com>
 <20190608071920.rio4ldr4fhjm2ztv@kafai-mbp.dhcp.thefacebook.com>
 <20190608170206.4fa108f5@redhat.com> <20190608174707.33233a1b@redhat.com>
In-Reply-To: <20190608174707.33233a1b@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:300:13d::23) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:7d5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a51e4f0d-7835-424a-f96c-08d6eddbccab
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1454;
x-ms-traffictypediagnostic: MWHPR15MB1454:
x-microsoft-antispam-prvs: <MWHPR15MB14549718E5199C3FFBDE9EB3D5130@MWHPR15MB1454.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(376002)(136003)(366004)(199004)(189003)(256004)(316002)(1076003)(6916009)(54906003)(14444005)(76176011)(68736007)(6436002)(46003)(52116002)(6506007)(99286004)(386003)(102836004)(6512007)(9686003)(6486002)(7736002)(229853002)(11346002)(81166006)(81156014)(446003)(186003)(8676002)(14454004)(8936002)(2906002)(476003)(305945005)(64756008)(66476007)(71190400001)(66556008)(73956011)(6116002)(66946007)(4326008)(66446008)(478600001)(486006)(5660300002)(53936002)(71200400001)(6246003)(25786009)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1454;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2TPWCMCifHGWrcGjwQK9BChEGcOVy2oRElcrIKp7DeQf5s+4/qeBGsCWCrFk8L+l+Ha1egA9w/Byxir5uG5ielbOGscS3azbPrdDyHHt4pnWbOj8rYVHT9KPqPufffjc9BN9SHFYhxU3/aLTEIpgavkI3XhbHghEdZGL8bASSI4dYx41iz8yjB4fPcMyHSN+mXg55Cq9cgU4CdtyzK2kcFy+x6d6I9I7Y5ruDX9n1k0DwnsLzVPQKWjLFx0Un60T+bdl0DWAJB01qwdfJDa/Kg0BEV7EaapFbfwnDsxVLvY1iJ/y5Yf0+eLSKzFLEycNYOslYaPwZr8kePAQszkwb8CFnu6qkd8naTUtJrqtIsSRBowL3xEltnE2jEfuc1lxgpUXUzoIVyMU2FzrQCf+L094iHJHBq2hNfPiELahWw0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <524DB42A2794CA40BEE63EA870AB9B1F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a51e4f0d-7835-424a-f96c-08d6eddbccab
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 19:42:41.6685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1454
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-10_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906100132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 08, 2019 at 05:47:07PM +0200, Stefano Brivio wrote:
> On Sat, 8 Jun 2019 17:02:06 +0200
> Stefano Brivio <sbrivio@redhat.com> wrote:
>=20
> > On Sat, 8 Jun 2019 07:19:23 +0000
> > Martin Lau <kafai@fb.com> wrote:
> >=20
> > > On Sat, Jun 08, 2019 at 07:59:11AM +0200, Stefano Brivio wrote: =20
> > > > I also agree it makes more sense to filter routes this way.
> > > >=20
> > > > But it wasn't like this before 2b760fcf5cfb, so this smells like
> > > > breaking userspace expectations, even though iproute already filter=
s
> > > > routes this way: with 'cache' it only displays routes with
> > > > RTM_F_CLONED, without, it won't display exceptions, see filter_nlms=
g():   =20
> > > Thanks for pointing it out.
> > >  =20
> > > > 	if (filter.cloned =3D=3D !(r->rtm_flags & RTM_F_CLONED))
> > > > 		return 0;
> > > >=20
> > > > This, together with the fact it's been like that for almost two yea=
rs
> > > > now, makes it acceptable in my opinion. What do you think?   =20
> > > With learning the above fact on iproute2,
> > > it makes even less sense to dump exceptions from the kernel side
> > > when RTM_F_CLONED is not set. =20
> >=20
> > I just hit a more fundamental problem though: iproute2 filters on the
> > flag, but never sets it on a dump request. Flags will be NLM_F_DUMP |
> > NLM_F_REQUEST, no matter what, see rtnl_routedump_req(). So the current
> > iproute2 would have no way to dump cached routes.
>=20
> Partially wrong: it actually sets it on 'list':
>=20
> 	if (rtnl_routedump_req(&rth, dump_family, iproute_dump_filter) < 0) {
>=20
> [...]
> static int iproute_dump_filter(struct nlmsghdr *nlh, int reqlen)
> [...]
> 	if (filter.cloned)
> 		rtm->rtm_flags |=3D RTM_F_CLONED;
>=20
> but not on 'flush':
>=20
> 		if (rtnl_routedump_req(&rth, family, NULL) < 0) {
>=20
> but this doesn't change things much: it still has no way to flush the
> cache, because the dump to get the routes to flush doesn't contain the
> exceptions.
'ip -6 r l table cache' can be limited to dump the cache only, right?

I am still missing something about why the kernel is required
to output everything and then filtered out in the iproute2.

You meant either:
The kernel needs to dump everything first. iproute2 can then figure out
which one is cache and then flush them?
or
the iproute2 can be changed to only get the cache from the kernel and then
flush them?

AFAIK, the kernel has never dumped the cache routes for IPv4.
What is done here has to be consistent with the future patch in IPv4.
Each node can hold up to 5*1024 caches which is ok-ish but still a waste
to dump it and then not printing it.
