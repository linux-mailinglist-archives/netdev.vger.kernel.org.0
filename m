Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E5135250
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFDVyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:54:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44926 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726341AbfFDVyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:54:07 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x54LqFPC003816;
        Tue, 4 Jun 2019 14:53:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XpQM5FP7OaXU9H0sICOxs/keu37MEcjuvVV5jw8ISo0=;
 b=WQTcjER0IOZzPMYXpNhqWeDlayIrGYAZMAq/l+cCLcv2GODO1z98pyowpO4gsAuSO3FB
 gLDvIppMda2AcePExFci0b6WATIrYtJyrNMoqLDTliulfy+bvhgCQ4staXykvm3wXLEt
 CpxJhzjmMfh8nW4HAo9TLfdWJ1+Wb22JX/o= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sx0j782uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 04 Jun 2019 14:53:58 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 4 Jun 2019 14:53:57 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 4 Jun 2019 14:53:57 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 4 Jun 2019 14:53:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpQM5FP7OaXU9H0sICOxs/keu37MEcjuvVV5jw8ISo0=;
 b=pLBhnY6Ta8mPRj1S+vD/djuGuM/fdxdfpIO8GnKtkuTxXi2q9n5WqGtJbeuxPf1J2utL5Yuck3Uzol0vGept0gyloNBRqcoIzoi8UCFRQduWNnxj4YpH9pRAzICkG4B9TKCKfFoEL8S4uGbz3QkGvQFDZXFVP+h01o/DKx6Q7OU=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1246.namprd15.prod.outlook.com (10.175.3.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.20; Tue, 4 Jun 2019 21:53:55 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 21:53:55 +0000
From:   Martin Lau <kafai@fb.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Wei Wang <weiwan@google.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
Thread-Topic: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object
 in a fib6_info
Thread-Index: AQHVGcH9d/t3D+2G4E2ABG2B/dN1r6aKO5OAgAAqigCAABVZAIAACmiAgAAIXYCAAAN5gP//prsAgAB/zgCAAEE1gIAA+BkAgAANpoCAAAIMAIAACzkA
Date:   Tue, 4 Jun 2019 21:53:54 +0000
Message-ID: <20190604215334.wdvogz7qeg3jbbvl@kafai-mbp.dhcp.thefacebook.com>
References: <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
 <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
 <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
 <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
 <20190604005840.tiful44xo34lpf6d@kafai-mbp.dhcp.thefacebook.com>
 <453565b0-d08a-be96-3cd7-5608d4c21541@gmail.com>
 <20190604052929.4mlxa5sswm46mwrq@kafai-mbp.dhcp.thefacebook.com>
 <c7fb6999-16a2-001d-8e9a-ac44ed9e9fa2@gmail.com>
 <20190604210619.kq5jnkinak7izn2u@kafai-mbp.dhcp.thefacebook.com>
 <0c307c47-4cde-1e55-8168-356b2ef30298@gmail.com>
In-Reply-To: <0c307c47-4cde-1e55-8168-356b2ef30298@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0100.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::41) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:9b09]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ddc820ec-cd06-4f25-37ba-08d6e937234f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1246;
x-ms-traffictypediagnostic: MWHPR15MB1246:
x-microsoft-antispam-prvs: <MWHPR15MB1246D6ECF9ABE5854F4B72B6D5150@MWHPR15MB1246.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(136003)(346002)(396003)(366004)(199004)(189003)(51914003)(6916009)(186003)(2906002)(6116002)(554214002)(229853002)(316002)(54906003)(68736007)(1076003)(99286004)(9686003)(6512007)(73956011)(14454004)(5660300002)(6436002)(476003)(446003)(486006)(52116002)(6486002)(46003)(1411001)(102836004)(478600001)(11346002)(256004)(53546011)(81156014)(71200400001)(53936002)(386003)(66476007)(66556008)(64756008)(66446008)(66946007)(8676002)(6246003)(6506007)(86362001)(305945005)(7736002)(71190400001)(25786009)(76176011)(8936002)(4326008)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1246;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9E+GYbBYobQv7AWqTmfrAwjUTf57z8FGOXbjsS5RSKU32NZzl2tDr4ta+7qb81ZfmLk+QKuRUMytX4lRHqDCHSx8zfAHYxN8ocTfqID/cRd2aM732zVDtLk+CeiV8J/Dm/PinoSRT3yY6hV1EHZUJ6xjUG5izMWYydKxf8bjcysINrMMqeNk8JL/58OoSPPeSfnYuE+KFR158ao8xgNjzap5kE8zJHbFdAlezB9bKGjGHeUQBd0T9g0uMWiagDcSZ8sgzVSqMz5X6iCfqIVGKF74A9VUaFB238jjGmO6lwVoUp9Vrl/+tyrxvfEbIJPsoMVmO2y4E+7J0h4XUDSrfTOgcyY18C8hyyrJokrvHkh5tRHSkki2OdZIOz+A9k4wQz7ABCrGScNj+QTBQT0vy7Kz631bpeVhN8VKGAqfdMY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CC5DCDD63D3570489CEA980EED732686@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ddc820ec-cd06-4f25-37ba-08d6e937234f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 21:53:54.8504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 03:13:38PM -0600, David Ahern wrote:
> On 6/4/19 3:06 PM, Martin Lau wrote:
> > On Tue, Jun 04, 2019 at 02:17:28PM -0600, David Ahern wrote:
> >> On 6/3/19 11:29 PM, Martin Lau wrote:
> >>> On Mon, Jun 03, 2019 at 07:36:06PM -0600, David Ahern wrote:
> >>>> On 6/3/19 6:58 PM, Martin Lau wrote:
> >>>>> I have concern on calling ip6_create_rt_rcu() in general which seem=
s
> >>>>> to trace back to this commit
> >>>>> dec9b0e295f6 ("net/ipv6: Add rt6_info create function for ip6_pol_r=
oute_lookup")
> >>>>>
> >>>>> This rt is not tracked in pcpu_rt, rt6_uncached_list or exception b=
ucket.
> >>>>> In particular, how to react to NETDEV_UNREGISTER/DOWN like
> >>>>> the rt6_uncached_list_flush_dev() does and calls dev_put()?
> >>>>>
> >>>>> The existing callers seem to do dst_release() immediately without
> >>>>> caching it, but still concerning.
> >>>>
> >>>> those are the callers that don't care about the dst_entry, but are
> >>>> forced to deal with it. Removing the tie between fib lookups an
> >>>> dst_entry is again the right solution.
> >>> Great to know that there will be a solution.  It would be great
> >>> if there is patch (or repo) to show how that may look like on
> >>> those rt6_lookup() callers.
> >>
> >> Not 'will be', 'there is' a solution now. Someone just needs to do the
> >> conversions and devise the tests for the impacted users.
> > I don't think everyone will convert to the new nexthop solution
> > immediately.
> >=20
> > How about ensuring the existing usage stays solid first?
>=20
> Use of nexthop objects has nothing to do with separating fib lookups
> from dst_entries, but with the addition of fib6_result it Just Works.
>=20
> Wei converted ipv6 to use exception caches instead of adding them to the
> FIB.
>=20
> I converted ipv6 to use separate data structures for fib entries, added
> direct fib6 lookup functions and added fib6_result. See the
> net/core/filter.c.
>=20
> The stage is set for converting users.
>=20
> For example, ip6_nh_lookup_table does not care about the dst entry, only
> the fib entry. This converts it:
>=20
> static int ip6_nh_lookup_table(struct net *net, struct fib6_config *cfg,
>                                const struct in6_addr *gw_addr, u32 tbid,
>                                int flags, struct fib6_result *res)
> {
>         struct flowi6 fl6 =3D {
>                 .flowi6_oif =3D cfg->fc_ifindex,
>                 .daddr =3D *gw_addr,
>                 .saddr =3D cfg->fc_prefsrc,
>         };
>         struct fib6_table *table;
>         struct rt6_info *rt;
>=20
>         table =3D fib6_get_table(net, tbid);
>         if (!table)
>                 return -EINVAL;
>=20
>         if (!ipv6_addr_any(&cfg->fc_prefsrc))
>                 flags |=3D RT6_LOOKUP_F_HAS_SADDR;
>=20
>         flags |=3D RT6_LOOKUP_F_IGNORE_LINKSTATE;
>=20
>         fib6_table_lookup(net, table, cfg->fc_ifindex, fl6, res, flags);
>         if (res.f6i =3D=3D net->ipv6.fib6_null_entry)
>                 return -ENETUNREACH;
>=20
>         fib6_select_path(net, &res, fl6, oif, false, NULL, flags);
>=20
>         return 0;
> }
Thanks for the example.  This patch/example is what I am looking for.
These changes are still "will be" done.

AFAICT, there are more than 10 rt6_lookup() usages which may end up calling
ip6_create_rt_rcu() and return an untracked rt.
It is very difficult to audit the future changes on them to ensure they wil=
l
not cache them till the above suggested changes to be done or
completely remove ip6_create_rt_rcu() for now.
