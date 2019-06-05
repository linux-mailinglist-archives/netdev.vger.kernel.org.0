Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D4F3568B
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 08:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfFEGB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 02:01:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47488 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbfFEGB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 02:01:29 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x555qWDP016194;
        Tue, 4 Jun 2019 23:01:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=MCR9H8Z9lYv0HqZRcHqVHEtGZO0Wr2cwhjDGBvWTHxA=;
 b=VBnZVdX3dfyTkmZkvPm5/bu8Ye5Eft8UUjhnP2lkMy4wU+C0uw4iWs3Ffmg2FtyJY2Xx
 zKGqE4TtbFvGTaBW0HP8sJVFebdXbEq4TPtXqZeEyUo2ddlzxBcL3HMcXbKgLEKeGeSI
 9/ayRUJVCkiNLM3VRoCHUzqtOGglH8Q6yZA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sx4mugf1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 04 Jun 2019 23:01:19 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 4 Jun 2019 23:01:17 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 4 Jun 2019 23:01:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCR9H8Z9lYv0HqZRcHqVHEtGZO0Wr2cwhjDGBvWTHxA=;
 b=AaBHrLajOHu73wJhi3QaNFnPODxPUw1XFMF0dYKUkwR/t5pR2eebq+KKGXbMFS2ut4bDiUSrF5y7tlV1h2nOHgEbgqMxlkt9CmafO6lPt3Ttc+cA+CVfHn+VGo5zWxeYa5q4hExLdNR6/X3nlSo7SJ7E756JwM0/TTByVSgmm1c=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1760.namprd15.prod.outlook.com (10.174.97.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Wed, 5 Jun 2019 06:01:16 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.018; Wed, 5 Jun 2019
 06:01:16 +0000
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
Thread-Index: AQHVGcH9d/t3D+2G4E2ABG2B/dN1r6aKO5OAgAAqigCAABVZAIAACmiAgAAIXYCAAAN5gP//prsAgAB/zgCAAEE1gIAA+BkAgAANpoCAAAIMAIAABmCAgAAzBICAABhJAIAAQbkA
Date:   Wed, 5 Jun 2019 06:01:15 +0000
Message-ID: <20190605060112.so7i4aku2htxng2z@kafai-mbp.dhcp.thefacebook.com>
References: <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
 <20190604005840.tiful44xo34lpf6d@kafai-mbp.dhcp.thefacebook.com>
 <453565b0-d08a-be96-3cd7-5608d4c21541@gmail.com>
 <20190604052929.4mlxa5sswm46mwrq@kafai-mbp.dhcp.thefacebook.com>
 <c7fb6999-16a2-001d-8e9a-ac44ed9e9fa2@gmail.com>
 <20190604210619.kq5jnkinak7izn2u@kafai-mbp.dhcp.thefacebook.com>
 <0c307c47-4cde-1e55-8168-356b2ef30298@gmail.com>
 <CAEA6p_AAP10bXOQPfOqY253H7BQYgksP_iDXDi-RKguLcKh0SA@mail.gmail.com>
 <20190605003903.zxxrebpzq2rfzy52@kafai-mbp.dhcp.thefacebook.com>
 <a5838766-529c-75dd-5793-3abe4e56ed1c@gmail.com>
In-Reply-To: <a5838766-529c-75dd-5793-3abe4e56ed1c@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR18CA0049.namprd18.prod.outlook.com
 (2603:10b6:104:2::17) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::5655]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f416a41-4048-47ae-2101-08d6e97b3826
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1760;
x-ms-traffictypediagnostic: MWHPR15MB1760:
x-microsoft-antispam-prvs: <MWHPR15MB17608F05B6E1AEB77CCB84E1D5160@MWHPR15MB1760.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(39860400002)(346002)(376002)(189003)(199004)(6512007)(9686003)(8676002)(6506007)(81156014)(6916009)(386003)(66446008)(66556008)(53546011)(102836004)(68736007)(73956011)(66946007)(66476007)(64756008)(478600001)(46003)(99286004)(8936002)(6246003)(14454004)(2906002)(486006)(52116002)(11346002)(446003)(476003)(186003)(4326008)(76176011)(25786009)(1411001)(229853002)(6436002)(81166006)(6486002)(5660300002)(71200400001)(316002)(53936002)(1076003)(86362001)(305945005)(54906003)(71190400001)(6116002)(256004)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1760;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: l3JgI/TKNsz0dHW536v1PGeyyZrogb9jO+ujhVnJMZR9Yd/tn7SUcUUyQfmVHz8UejInz9I5pUrsvfOpFdzNHDq174VAoqBF2NzTPQN6r/RrkX/29z3I2PQ7jI1/uQU9bIcDpz0DQr3oaP4sZeztLmhiqgh1Lcix8HCTDC6wgelLOE+xSArhisgRNJiDx5+cDNallriL5ma0fz9wVObWqRhzrTcTd0ujbpJuV8HeZE/mkE0g1ibVBVE5DkBQUPLtiFv3asVG5HfpnwTy9YKId16JOSq0QaxJA6B1wRKsxtLGTVO+uBPqbdfDY2O98PKNJ6H+UkST0FmR4SWnvol/n6QqAWVkXhoyaD4jMfo2u3bPhSeOiPIFt4hVoadwUfupaobtDmDKBa3jpfGAYUVx8SXvzT5mH9gmRHq++AHLg+4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A928746943EC4D45AAE6B1AECFA3A5CD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f416a41-4048-47ae-2101-08d6e97b3826
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 06:01:15.8661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1760
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-05_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=617 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906050037
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 08:05:58PM -0600, David Ahern wrote:
> On 6/4/19 6:39 PM, Martin Lau wrote:
> > IMO, ip6_create_rt_rcu(), which returns untracked rt, was a mistake
> > and removing it has been overdue.  Tracking down the unregister dev
> > bug is not easy.
>=20
> I must be missing something because I don't have the foggiest idea why
> you are barking up this tree.
>=20
> If code calls a function that returns a dst_entry with a refcount taken,
> that code is responsible for releasing it.
The code is responsible but there is no control on when.
That code can cache it for a long time.  May be re-look at the dev_put() in
this recent bug fix to begin with?
f5b51fe804ec ("ipv6: route: purge exception on removal")

and also the current rt6_uncached_list + rt6_uncached_list_flush_dev()

> Using a pcpu cached dst
> versus a new one in no way tells you who took the dst and bumped the
> refcnt on the netdev. Either way the dst refcount is bumped. Tracking
> netdev refcnt is the only way to methodically figure it out.
>=20
> What am I overlooking here?
