Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7193133E62
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 07:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfFDF3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 01:29:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41114 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbfFDF3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 01:29:47 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x545Ruwg023565;
        Mon, 3 Jun 2019 22:29:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wrQsFvz0xAhSCAU9H6D89cQr7yB/v+aI8PU1dAZmSHk=;
 b=l3skk1w0AOCX0B/s6R783AHQOHMrwiauK90wPD9Hs0v4VmVT5j1BiViYCd6JtB/lVum0
 9NdB7W43VjMFjYyKpt4v2bRLGK5AynmHNdN3/f9tX9fe2uZxq/sFc/ZYPNwTssH3FWCM
 0aOkgTC6OOx06kmQpwKPDAj0y8ly85NkkIc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sw80b20vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 03 Jun 2019 22:29:35 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 3 Jun 2019 22:29:34 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 3 Jun 2019 22:29:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrQsFvz0xAhSCAU9H6D89cQr7yB/v+aI8PU1dAZmSHk=;
 b=isQ+6pHHRYCuaMMckKs16873xGFZwvLbFzaAB00rDX/rK7TQplzlpcBXKuWbHKhTzOr7BzunQaiAnSNL2b1F5pHkXaKR+v9C75n2nOVPqJYagwtYgaHMmAI1AyeOpXbRL3ZSleht8ThP/3kyvZOj07fn1Wu8vZzLFrqmdB/Dvzo=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1376.namprd15.prod.outlook.com (10.173.232.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Tue, 4 Jun 2019 05:29:32 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 05:29:32 +0000
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
Thread-Index: AQHVGcH9d/t3D+2G4E2ABG2B/dN1r6aKO5OAgAAqigCAABVZAIAACmiAgAAIXYCAAAN5gP//prsAgAB/zgCAAEE1gA==
Date:   Tue, 4 Jun 2019 05:29:32 +0000
Message-ID: <20190604052929.4mlxa5sswm46mwrq@kafai-mbp.dhcp.thefacebook.com>
References: <20190603040817.4825-1-dsahern@kernel.org>
 <20190603040817.4825-5-dsahern@kernel.org>
 <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
 <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com>
 <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
 <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
 <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
 <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
 <20190604005840.tiful44xo34lpf6d@kafai-mbp.dhcp.thefacebook.com>
 <453565b0-d08a-be96-3cd7-5608d4c21541@gmail.com>
In-Reply-To: <453565b0-d08a-be96-3cd7-5608d4c21541@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1001CA0014.namprd10.prod.outlook.com
 (2603:10b6:301:2a::27) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::fce9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c0e0246-98ad-4422-502f-08d6e8ad9f11
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1376;
x-ms-traffictypediagnostic: MWHPR15MB1376:
x-microsoft-antispam-prvs: <MWHPR15MB13766BC890DAE2CB371DBD2FD5150@MWHPR15MB1376.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(39860400002)(136003)(376002)(189003)(199004)(64756008)(66446008)(6246003)(53936002)(66556008)(54906003)(478600001)(14454004)(86362001)(73956011)(66946007)(81166006)(8676002)(81156014)(4326008)(66476007)(8936002)(25786009)(229853002)(256004)(14444005)(6486002)(5660300002)(6916009)(476003)(11346002)(46003)(446003)(1076003)(486006)(186003)(71200400001)(71190400001)(6436002)(9686003)(6512007)(68736007)(1411001)(53546011)(316002)(7736002)(6506007)(386003)(102836004)(76176011)(305945005)(52116002)(99286004)(6116002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1376;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fMU0HRZ4RnqpJUKOrIZxEE2zD2cdCbNC4Q1egz9ZTnNbf0Vb5/JoweGsIQ1+kR+y0swT9o7pNPiG+wF6qGEKw38+dVQyvO9jQj1UUFtGhy2PkOsVtehSjCK36N8oCVRoEYxsI25zd0Nb9gcDdkmMnwPEkGx63Li1qNjv8cOscJiJPZgEi7q/5QTuZtXyTFP+tuDtLqgSl87dpcEJ/JtDfrqi7A2L/+WQtJPhtTfkeF0o0mis0IwJzuin2cSsyKiMjKujKrVQCRgSnQs82JZO0Z8mHpcApvyCwCX/pSgrkCvAAPdyy7MNfULKVRFAJ8EV40m7+wYyLAX0rba9RRScVzQDgetMj5TIE8mrJmLu4SYgfooDwWBxSY7Qt6yuQ15EmsYG1D9QdzI6GTRB1chhTpZEbqRhgya+vHJB/BYCgmI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FD681E22855FD14694509D137BA3260F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c0e0246-98ad-4422-502f-08d6e8ad9f11
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 05:29:32.8302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1376
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=972 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040037
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 07:36:06PM -0600, David Ahern wrote:
> On 6/3/19 6:58 PM, Martin Lau wrote:
> > I have concern on calling ip6_create_rt_rcu() in general which seems
> > to trace back to this commit
> > dec9b0e295f6 ("net/ipv6: Add rt6_info create function for ip6_pol_route=
_lookup")
> >=20
> > This rt is not tracked in pcpu_rt, rt6_uncached_list or exception bucke=
t.
> > In particular, how to react to NETDEV_UNREGISTER/DOWN like
> > the rt6_uncached_list_flush_dev() does and calls dev_put()?
> >=20
> > The existing callers seem to do dst_release() immediately without
> > caching it, but still concerning.
>=20
> those are the callers that don't care about the dst_entry, but are
> forced to deal with it. Removing the tie between fib lookups an
> dst_entry is again the right solution.
Great to know that there will be a solution.  It would be great
if there is patch (or repo) to show how that may look like on
those rt6_lookup() callers.

Before that,
although it seems fine now (__ip6_route_redirect() is
harder to confirm since rt is passed around but it
seems to be ok),
instead of risking for "unregister_netdevice: waiting for eth0 to become fr=
ee"
in case some future patch is caching this rt,
why pcpu_rt cannot be used in all occasions? and also
avoid re-creating the same rt.
