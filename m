Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E357354BD
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 02:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfFEAjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 20:39:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43376 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbfFEAjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 20:39:22 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x550d9to023237;
        Tue, 4 Jun 2019 17:39:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4BguUD+Bf5LNdLzbY5UKjDBBlk9qmRdXMdjczTXvsuI=;
 b=FxCP+nUnChrtoinqSTuFww5771ZRpi7yrcQox3/lrCXgJJyaodknpI4c4ruy2neqkRpQ
 db26DxDL+TiDdRdy03No7Z5ilkbUcYBOBjvq3l7Z3QXtXLHjHy6kEi3luY7PVREH655e
 2N6XUt3snbd6ulKU9/nxIyMy4Z+CJGppTkc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sx0wvrfe4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 04 Jun 2019 17:39:09 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 4 Jun 2019 17:39:07 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 4 Jun 2019 17:39:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4BguUD+Bf5LNdLzbY5UKjDBBlk9qmRdXMdjczTXvsuI=;
 b=KDqq7h7tyRGt89iwf9oaQ04TPVaFxvBeyFCBwkk0u2A3gZkToRbmc4DMdNC2XDVYv1UFFKiI74LZ0hyw8dFcZFSVhUYSqzXzt+zULhWV8xcmziCE5EAIsF7hjnP/C1o14KRPuWjOXXQ27+AL919BYfS98E4qiGoMMjaiAI9l82g=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1838.namprd15.prod.outlook.com (10.174.255.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Wed, 5 Jun 2019 00:39:05 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.018; Wed, 5 Jun 2019
 00:39:05 +0000
From:   Martin Lau <kafai@fb.com>
To:     Wei Wang <weiwan@google.com>
CC:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
Thread-Topic: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object
 in a fib6_info
Thread-Index: AQHVGcH9d/t3D+2G4E2ABG2B/dN1r6aKO5OAgAAqigCAABVZAIAACmiAgAAIXYCAAAN5gP//prsAgAB/zgCAAEE1gIAA+BkAgAANpoCAAAIMAIAABmCAgAAzBIA=
Date:   Wed, 5 Jun 2019 00:39:05 +0000
Message-ID: <20190605003903.zxxrebpzq2rfzy52@kafai-mbp.dhcp.thefacebook.com>
References: <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
 <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
 <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
 <20190604005840.tiful44xo34lpf6d@kafai-mbp.dhcp.thefacebook.com>
 <453565b0-d08a-be96-3cd7-5608d4c21541@gmail.com>
 <20190604052929.4mlxa5sswm46mwrq@kafai-mbp.dhcp.thefacebook.com>
 <c7fb6999-16a2-001d-8e9a-ac44ed9e9fa2@gmail.com>
 <20190604210619.kq5jnkinak7izn2u@kafai-mbp.dhcp.thefacebook.com>
 <0c307c47-4cde-1e55-8168-356b2ef30298@gmail.com>
 <CAEA6p_AAP10bXOQPfOqY253H7BQYgksP_iDXDi-RKguLcKh0SA@mail.gmail.com>
In-Reply-To: <CAEA6p_AAP10bXOQPfOqY253H7BQYgksP_iDXDi-RKguLcKh0SA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0072.namprd02.prod.outlook.com
 (2603:10b6:301:73::49) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:9b09]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81688ba3-bb45-44fd-b627-08d6e94e3671
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1838;
x-ms-traffictypediagnostic: MWHPR15MB1838:
x-microsoft-antispam-prvs: <MWHPR15MB1838957E14E0F95EB36997DDD5160@MWHPR15MB1838.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(39860400002)(396003)(346002)(366004)(189003)(199004)(6512007)(446003)(8676002)(7736002)(11346002)(6486002)(229853002)(9686003)(53936002)(81156014)(305945005)(486006)(476003)(81166006)(478600001)(46003)(76176011)(71190400001)(71200400001)(6436002)(6116002)(186003)(54906003)(52116002)(99286004)(1076003)(14454004)(53546011)(8936002)(25786009)(6506007)(86362001)(256004)(5660300002)(6246003)(4326008)(66946007)(64756008)(66446008)(6916009)(316002)(73956011)(66556008)(102836004)(386003)(66476007)(68736007)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1838;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qcH+81MPwO0X7N6Ss81DK1EdXPj1VokKPYwmBhCwGKTwwdgyO1UB7qS5eLycvi+CX6a36ohlbTKoIewhU/+54/jW4dhaLAVvPJgS3WHCp2nKv4ENim0I06X0eQhiJJVCZyjx0pC5DIypLfvKjW7oFwKOWhxy6FdXzLgpRv9Rlhgs78nEzTqbwGCgeXd1RCY3OuRRxNj5DWTbpUWIwon8R3gC+f78x9MFcslo4QdEzMcPXVAThC7p2iDxIX1PqU8cBBjM/HcsrGlidCxFngpYc1mK8EhQcAf7zO64ttcnbv9Gb6/9rugDPAGyKelBMFRRBXrUpcLkscLoOEfUG16P+NVfGnUkNOe2KB9c+jtyMsZ/rpt2zVwqXG5jjl1X0ReShHl9VgAv68DyJ0JIlI6B2NNfIYk/O6d0GyQfWPFp7Jo=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3B953F608974CD47A3F6D2D6356C42FB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 81688ba3-bb45-44fd-b627-08d6e94e3671
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 00:39:05.5031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1838
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-05_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906050001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 02:36:27PM -0700, Wei Wang wrote:
> On Tue, Jun 4, 2019 at 2:13 PM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 6/4/19 3:06 PM, Martin Lau wrote:
> > > On Tue, Jun 04, 2019 at 02:17:28PM -0600, David Ahern wrote:
> > >> On 6/3/19 11:29 PM, Martin Lau wrote:
> > >>> On Mon, Jun 03, 2019 at 07:36:06PM -0600, David Ahern wrote:
> > >>>> On 6/3/19 6:58 PM, Martin Lau wrote:
> > >>>>> I have concern on calling ip6_create_rt_rcu() in general which se=
ems
> > >>>>> to trace back to this commit
> > >>>>> dec9b0e295f6 ("net/ipv6: Add rt6_info create function for ip6_pol=
_route_lookup")
> > >>>>>
> > >>>>> This rt is not tracked in pcpu_rt, rt6_uncached_list or exception=
 bucket.
> > >>>>> In particular, how to react to NETDEV_UNREGISTER/DOWN like
> > >>>>> the rt6_uncached_list_flush_dev() does and calls dev_put()?
> > >>>>>
> > >>>>> The existing callers seem to do dst_release() immediately without
> > >>>>> caching it, but still concerning.
> > >>>>
> > >>>> those are the callers that don't care about the dst_entry, but are
> > >>>> forced to deal with it. Removing the tie between fib lookups an
> > >>>> dst_entry is again the right solution.
> > >>> Great to know that there will be a solution.  It would be great
> > >>> if there is patch (or repo) to show how that may look like on
> > >>> those rt6_lookup() callers.
> > >>
> > >> Not 'will be', 'there is' a solution now. Someone just needs to do t=
he
> > >> conversions and devise the tests for the impacted users.
> > > I don't think everyone will convert to the new nexthop solution
> > > immediately.
> > >
> > > How about ensuring the existing usage stays solid first?
> >
> > Use of nexthop objects has nothing to do with separating fib lookups
> > from dst_entries, but with the addition of fib6_result it Just Works.
> >
> > Wei converted ipv6 to use exception caches instead of adding them to th=
e
> > FIB.
> >
> > I converted ipv6 to use separate data structures for fib entries, added
> > direct fib6 lookup functions and added fib6_result. See the
> > net/core/filter.c.
> >
> > The stage is set for converting users.
> >
> > For example, ip6_nh_lookup_table does not care about the dst entry, onl=
y
> > the fib entry. This converts it:
> >
> > static int ip6_nh_lookup_table(struct net *net, struct fib6_config *cfg=
,
> >                                const struct in6_addr *gw_addr, u32 tbid=
,
> >                                int flags, struct fib6_result *res)
> > {
> >         struct flowi6 fl6 =3D {
> >                 .flowi6_oif =3D cfg->fc_ifindex,
> >                 .daddr =3D *gw_addr,
> >                 .saddr =3D cfg->fc_prefsrc,
> >         };
> >         struct fib6_table *table;
> >         struct rt6_info *rt;
> >
> >         table =3D fib6_get_table(net, tbid);
> >         if (!table)
> >                 return -EINVAL;
> >
> >         if (!ipv6_addr_any(&cfg->fc_prefsrc))
> >                 flags |=3D RT6_LOOKUP_F_HAS_SADDR;
> >
> >         flags |=3D RT6_LOOKUP_F_IGNORE_LINKSTATE;
> >
> >         fib6_table_lookup(net, table, cfg->fc_ifindex, fl6, res, flags)=
;
> >         if (res.f6i =3D=3D net->ipv6.fib6_null_entry)
> >                 return -ENETUNREACH;
> >
> >         fib6_select_path(net, &res, fl6, oif, false, NULL, flags);
> >
> >         return 0;
> > }
>=20
> I do agree with Martin that ip6_create_rt_rcu() seems to be dangerous
> as the dst cache created by this func does not get tracked anywhere
> and it is up to the user to not cache it for too long.
IMO, ip6_create_rt_rcu(), which returns untracked rt, was a mistake
and removing it has been overdue.  Tracking down the unregister dev
bug is not easy.

> But I think David, what you are suggesting is:
> instead of trying to convert ip6_create_rt_rcu() to use the pcpu_dst
> logic, completely get rid of the calling to ip6_create_rt_rcu(), and
> directly return f6i in those cases to the caller. Is that correct?
I am fine with either of these two ways to remove ip6_create_rt_rcu().
Further depending on ip6_create_rt_rcu() in this patch even in
ip6_pol_route_lookup() is arguably neither of these two ways...
