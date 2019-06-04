Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05B8733CA7
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 02:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfFDA66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 20:58:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53476 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726173AbfFDA65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 20:58:57 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x540usxE001132;
        Mon, 3 Jun 2019 17:58:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=f5VPi156QC6d0A1e66jv03RuTYBfUyVc1dX1dH8zVM4=;
 b=FWNvabX3wVa10d+1lkgI6AEqC/lEeFNwaxn6Y2iyZdxg3eYgvg7tEXy9/bB9g/+C8U1W
 7PXQuR2sik6xmVtGiU8QZg7/2/9HsvaLRWOOhVYGWEiqrbJOopP8OX2mln14iZn2bS1S
 oC/Qi3lot22I3p3S24kr8wvEyMXphxwX/tE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2sw8my97g6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 03 Jun 2019 17:58:48 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 3 Jun 2019 17:58:47 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 3 Jun 2019 17:58:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5VPi156QC6d0A1e66jv03RuTYBfUyVc1dX1dH8zVM4=;
 b=koSWGO5+gJnlaGYBFL7XYmGAeITgc/S/1xZltMvE+O1Co5kZB1l5p67a/kUV+JutCdnPxo5kRbui+XDk4JUcXIob5pC9Z3fJTh+OfV6afpB/8vYCwjPWruDOEFwxRzOdpYd3pXMnDurIwv59PqSk5PN+easefjoy36iVebN8fJI=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1405.namprd15.prod.outlook.com (10.173.233.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.17; Tue, 4 Jun 2019 00:58:46 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 00:58:45 +0000
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
Thread-Index: AQHVGcH9d/t3D+2G4E2ABG2B/dN1r6aKO5OAgAAqigCAABVZAIAACmiAgAAIXYCAAAN5gIAAHBMA
Date:   Tue, 4 Jun 2019 00:58:45 +0000
Message-ID: <20190604005840.tiful44xo34lpf6d@kafai-mbp.dhcp.thefacebook.com>
References: <20190603040817.4825-1-dsahern@kernel.org>
 <20190603040817.4825-5-dsahern@kernel.org>
 <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
 <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com>
 <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
 <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
 <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
 <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
In-Reply-To: <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0035.namprd12.prod.outlook.com
 (2603:10b6:301:2::21) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::b2c9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e85993bd-edbe-4d2f-58fc-08d6e887c996
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1405;
x-ms-traffictypediagnostic: MWHPR15MB1405:
x-microsoft-antispam-prvs: <MWHPR15MB14052C95FE62962715032158D5150@MWHPR15MB1405.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(136003)(366004)(396003)(376002)(199004)(189003)(9686003)(53936002)(6512007)(68736007)(1076003)(256004)(229853002)(5660300002)(6436002)(6486002)(8936002)(476003)(81166006)(8676002)(81156014)(25786009)(6246003)(6916009)(4326008)(46003)(7736002)(446003)(11346002)(305945005)(486006)(186003)(86362001)(478600001)(73956011)(14454004)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(71190400001)(99286004)(102836004)(52116002)(1411001)(386003)(6506007)(53546011)(6116002)(76176011)(316002)(2906002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1405;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8hgX9lwTpyn9pCXvYMunZquEC5NqbGKq1R71nxILHUbBycFgdIdgT0S2vT06rjK+OMg9VyNyZxFnS5SFybyCJidOYUe0+OuhFQBWEEZiyZty8D16zgkiMhmpM8NA7gPmeqDu0fQXDnTrsrkNbhTQc77m14gkMG/InpkRTwy9eErWwS3YS6yuzw8GgNMl96MZsdQDvI2tSbUQabRqoloqq/5O31qfBjKDA2CZiu6t49vSedN33LXelVey7ZcL0l9n2fABwhJILlCv5OePZcjF/ol6RATJnmAQuqHRfp4D7Byd1UNNKHi/4CqIbvJHtLs69JoltitSzberFxDsEMO7J6q1PAXfm2bvZrP3w1welN0ZTFCL8wpKH6SwBYE7/rvVSgVvv1SxIsrEpMyXCuKvEo4rSp/eqIN/bWffgsF5KbU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CC97FB465010F245A92352B207ED6318@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e85993bd-edbe-4d2f-58fc-08d6e887c996
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 00:58:45.4575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1405
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 05:18:11PM -0600, David Ahern wrote:
> On 6/3/19 5:05 PM, Wei Wang wrote:
> > On Mon, Jun 3, 2019 at 3:35 PM David Ahern <dsahern@gmail.com> wrote:
> >>
> >> On 6/3/19 3:58 PM, Wei Wang wrote:
> >>> Hmm... I am still a bit concerned with the ip6_create_rt_rcu() call.
> >>> If we have a blackholed nexthop, the lookup code here always tries to
> >>> create an rt cache entry for every lookup.
> >>> Maybe we could reuse the pcpu cache logic for this? So we only create
> >>> new dst cache on the CPU if there is no cache created before.
> >>
> >> I'll take a look.
> >>
>=20
> BTW, I am only updating ip6_pol_route to use pcpu routes for blackhole
> nexthops.
>=20
> ip6_pol_route_lookup will continue as is. That function does not use
> pcpu routes and will stay as is.
>=20
I have concern on calling ip6_create_rt_rcu() in general which seems
to trace back to this commit
dec9b0e295f6 ("net/ipv6: Add rt6_info create function for ip6_pol_route_loo=
kup")

This rt is not tracked in pcpu_rt, rt6_uncached_list or exception bucket.
In particular, how to react to NETDEV_UNREGISTER/DOWN like
the rt6_uncached_list_flush_dev() does and calls dev_put()?

The existing callers seem to do dst_release() immediately without
caching it, but still concerning.
