Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D591351A1
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfFDVGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:06:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39982 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726352AbfFDVGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:06:35 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x54KsvaZ010324;
        Tue, 4 Jun 2019 14:06:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=3IRqdt8ojEQHKfsI+p38055q863Kyv4Nu2O1LdTjJcQ=;
 b=a4ddq1frHBn41bvLKTwtaXlX/BaUnG2u585lpdPBzIUf1HhSXEZifuRAXDTtBYMpaA/o
 UN/cWBs7oCApHxSKcdxsY5y8SQ/6TcqQ3m3HLsIY/dKRUrr1zIJHC4sH8uiDiZjNCYcx
 3L4TQs7vMjP8TWehk9x84/DtSIOBz9G8DcU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2swwg2rmcw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 04 Jun 2019 14:06:24 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 4 Jun 2019 14:06:24 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 4 Jun 2019 14:06:23 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 4 Jun 2019 14:06:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3IRqdt8ojEQHKfsI+p38055q863Kyv4Nu2O1LdTjJcQ=;
 b=lhPOAkqitqFFLlnXMtL291Xaq99IfygQfu1K5Zx/G5llm0rOnFOb/zJd0eCVHcg0lzWucq+BnpQxrjfs5JL/3VWmu0elLYDaEBlFCeMvvCtiIxdscdPsxii54IPEoL7XPGOLA2xbSNx3uQZ9wu+5slt4vtCWs4lv0hhqUWDOy7k=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1854.namprd15.prod.outlook.com (10.174.255.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Tue, 4 Jun 2019 21:06:22 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 21:06:22 +0000
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
Thread-Index: AQHVGcH9d/t3D+2G4E2ABG2B/dN1r6aKO5OAgAAqigCAABVZAIAACmiAgAAIXYCAAAN5gP//prsAgAB/zgCAAEE1gIAA+BkAgAANpoA=
Date:   Tue, 4 Jun 2019 21:06:21 +0000
Message-ID: <20190604210619.kq5jnkinak7izn2u@kafai-mbp.dhcp.thefacebook.com>
References: <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com>
 <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com>
 <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
 <5263d3ae-1865-d935-cb03-f6dfd4604d15@gmail.com>
 <CAEA6p_CixzdRNUa46YZusFg-37MFAVqQ8D09rxVU5Nja6gO1SA@mail.gmail.com>
 <4cdcdf65-4d34-603e-cb21-d649b399d760@gmail.com>
 <20190604005840.tiful44xo34lpf6d@kafai-mbp.dhcp.thefacebook.com>
 <453565b0-d08a-be96-3cd7-5608d4c21541@gmail.com>
 <20190604052929.4mlxa5sswm46mwrq@kafai-mbp.dhcp.thefacebook.com>
 <c7fb6999-16a2-001d-8e9a-ac44ed9e9fa2@gmail.com>
In-Reply-To: <c7fb6999-16a2-001d-8e9a-ac44ed9e9fa2@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR16CA0035.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::48) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:9b09]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a47f856-4329-48f8-92f3-08d6e9307ed2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1854;
x-ms-traffictypediagnostic: MWHPR15MB1854:
x-microsoft-antispam-prvs: <MWHPR15MB1854FDF8F28CE4F702C4E5D1D5150@MWHPR15MB1854.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(39860400002)(376002)(346002)(199004)(189003)(53936002)(81166006)(81156014)(6246003)(71200400001)(14454004)(71190400001)(6916009)(478600001)(476003)(8936002)(73956011)(76176011)(446003)(25786009)(68736007)(256004)(305945005)(8676002)(53546011)(7736002)(11346002)(386003)(14444005)(6506007)(229853002)(2906002)(46003)(86362001)(486006)(102836004)(6486002)(66556008)(54906003)(66476007)(66946007)(66446008)(6116002)(52116002)(6436002)(5660300002)(64756008)(6512007)(4326008)(316002)(9686003)(99286004)(1411001)(186003)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1854;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: onjL9R1UCH62tSfnMZMyUGK3PTn71GsipT3TQqHkkOjga385y1AVw/XUdq2NQI39Fy1K/iWz4hpE/zGeHz8VX4DUWjI9Y5Z71IL4gN2nH++wp8yfTpNii1ZGmnt9FkWktLwtDzs/lI2InP6lg8WxFmXG0d1w65Wgnd8An1hvFNUaUnvCrGRdcbLstXzEfqeYnO8V7m8sUg6bfxgtMJzQiv3KsjKwvXzcDjqUvzc8bmNVbnSLtK231Yc9peVw5JTAWU4bD8ua78deulq9n6qh0T/8KPvmD4kVDQEpRGTrF9Ies+hhWh7lRZs+U/KHylcwyNByF7rHzIFozaVM6M0wAKBvR3qcX0W7JJNBZtRC6PJILtgLmr+iPsKU8gDLrHuNUxCUR63E0tpmQMfQPzd34gdsjKwmUQalgmNP6xc/2Nw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E8211ECBE0F04E40A31C50A1E872F3AF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a47f856-4329-48f8-92f3-08d6e9307ed2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 21:06:21.9128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1854
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 02:17:28PM -0600, David Ahern wrote:
> On 6/3/19 11:29 PM, Martin Lau wrote:
> > On Mon, Jun 03, 2019 at 07:36:06PM -0600, David Ahern wrote:
> >> On 6/3/19 6:58 PM, Martin Lau wrote:
> >>> I have concern on calling ip6_create_rt_rcu() in general which seems
> >>> to trace back to this commit
> >>> dec9b0e295f6 ("net/ipv6: Add rt6_info create function for ip6_pol_rou=
te_lookup")
> >>>
> >>> This rt is not tracked in pcpu_rt, rt6_uncached_list or exception buc=
ket.
> >>> In particular, how to react to NETDEV_UNREGISTER/DOWN like
> >>> the rt6_uncached_list_flush_dev() does and calls dev_put()?
> >>>
> >>> The existing callers seem to do dst_release() immediately without
> >>> caching it, but still concerning.
> >>
> >> those are the callers that don't care about the dst_entry, but are
> >> forced to deal with it. Removing the tie between fib lookups an
> >> dst_entry is again the right solution.
> > Great to know that there will be a solution.  It would be great
> > if there is patch (or repo) to show how that may look like on
> > those rt6_lookup() callers.
>=20
> Not 'will be', 'there is' a solution now. Someone just needs to do the
> conversions and devise the tests for the impacted users.
I don't think everyone will convert to the new nexthop solution
immediately.

How about ensuring the existing usage stays solid first?
>> Before that,
>> although it seems fine now (__ip6_route_redirect() is
>> harder to confirm since rt is passed around but it
>> seems to be ok),
>> instead of risking for "unregister_netdevice: waiting for eth0 to become=
 free"
>> in case some future patch is caching this rt,
>> why pcpu_rt cannot be used in all occasions? and also
>> avoid re-creating the same rt.
