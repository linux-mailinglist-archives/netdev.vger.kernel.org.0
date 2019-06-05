Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D2B36784
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 00:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfFEWbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 18:31:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46022 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726510AbfFEWbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 18:31:50 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x55MVFFR018208;
        Wed, 5 Jun 2019 15:31:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6j7vpSvSiDYY9IH9/wBwCX0diYbT/eJGELH4MxsjmbM=;
 b=Sldww/YkWyfU1Jfp3qX9UwC+owaFELDgYCidW9/2i23ScUosqj86vS6kkzWG1mFZboQp
 Q0vMiIn4vYjBDNd0MiPxbjL/HguFa4TkgUWGQuqIAorU0JtqRv2szqu4uZlOnJSyrrQ1
 sKYZtzUkF+RwcNi9F9GArbx1YK6s5/2B2Pk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sxdvpj1yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 05 Jun 2019 15:31:19 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Jun 2019 15:31:17 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Jun 2019 15:31:16 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 5 Jun 2019 15:31:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6j7vpSvSiDYY9IH9/wBwCX0diYbT/eJGELH4MxsjmbM=;
 b=e/xVmgI6JEPyjIsGVvIjET+oWz8BXcxaOuAyZFWO1wTFV5ZMx7tlZDTqZCVWKD0IAny0iaDaRbPGj2ChCSUG1AqpyhzpD8va57/DP3vFgbPLzNCoZ8v99hoDaTWKkUaPBPerD/ISp2e87ApJ7PCfAiwVo1XXz4EZkeasJofZZvc=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1711.namprd15.prod.outlook.com (10.174.254.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.13; Wed, 5 Jun 2019 22:31:14 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1943.023; Wed, 5 Jun 2019
 22:31:14 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>
Subject: Re: [PATCH 1/1] bpf: Allow bpf_map_lookup_elem() on an xskmap
Thread-Topic: [PATCH 1/1] bpf: Allow bpf_map_lookup_elem() on an xskmap
Thread-Index: AQHVG7eCV7MKSsPZgkW3+/mLD2Xff6aNpVGA
Date:   Wed, 5 Jun 2019 22:31:14 +0000
Message-ID: <20190605223111.rgsd3tyl7jvahvgc@kafai-mbp.dhcp.thefacebook.com>
References: <20190605155756.3779466-1-jonathan.lemon@gmail.com>
 <20190605155756.3779466-2-jonathan.lemon@gmail.com>
In-Reply-To: <20190605155756.3779466-2-jonathan.lemon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1301CA0035.namprd13.prod.outlook.com
 (2603:10b6:301:29::48) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:b7bf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a871879-357a-4145-f507-08d6ea058474
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1711;
x-ms-traffictypediagnostic: MWHPR15MB1711:
x-microsoft-antispam-prvs: <MWHPR15MB1711DED9A5128781735BD9FAD5160@MWHPR15MB1711.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 00594E8DBA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(396003)(346002)(366004)(39860400002)(189003)(199004)(99286004)(86362001)(6916009)(8936002)(2906002)(4326008)(66946007)(76176011)(53936002)(5660300002)(316002)(52116002)(54906003)(6116002)(386003)(81166006)(6506007)(102836004)(66446008)(66556008)(305945005)(7736002)(66476007)(4744005)(64756008)(229853002)(478600001)(81156014)(8676002)(486006)(476003)(68736007)(9686003)(6512007)(1076003)(73956011)(256004)(6436002)(6486002)(71200400001)(71190400001)(6246003)(46003)(14444005)(14454004)(186003)(446003)(25786009)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1711;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tidX0EhjpECynAYatESLY/bCMaPgx1bhpDY65iZ6Zsdv7RYRw9yrV68bTrJaNnHEUIE5kWKTUPj04KJz1wsyNEpU8cepb/S2R1NvnLuaBGDf+4fN/mLHDB8qkzJEmRMQddCydTrcrbX7WDHDhtZCLG+9lG8452BNRwIyUaoC/QAQaxjWiWGzqrBpDaeyEibbdi0xKudLsBBsPjoctfehR7N7T0OSpQDJWD1TYU1UzQcgXr2oo7O+PWBNW2uKzYioMq9biMTA7V7wU0Bw6rB4Jn/ebzLa/RJbm4F13pbtHiTMn5eS1GpfOlp10LpgqdkiyBw7UTwydHLWAQ5a0+BE5Q1DuHq+o15vtEjy+/Pkdo1zRdPmZ6quFZYkRJ+ptN2qY5SGSWBx711igv7rX9/Dx2rrFcLyXsr2b8bxug45cZg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B1D6EC19BC4ABA4A8288857EC27CFBB7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a871879-357a-4145-f507-08d6ea058474
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2019 22:31:14.2421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1711
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-05_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=490 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906050143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 08:57:56AM -0700, Jonathan Lemon wrote:
> Currently, the AF_XDP code uses a separate map in order to
> determine if an xsk is bound to a queue.  Instead of doing this,
> have bpf_map_lookup_elem() return a xdp_sock.
>=20
> Rearrange some xdp_sock members to eliminate structure holes.
>=20
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/linux/bpf.h                           |  8 ++++
>  include/net/xdp_sock.h                        |  4 +-
>  include/uapi/linux/bpf.h                      |  4 ++
>  kernel/bpf/verifier.c                         | 26 +++++++++++-
>  kernel/bpf/xskmap.c                           |  7 ++++
>  net/core/filter.c                             | 40 +++++++++++++++++++
>  tools/include/uapi/linux/bpf.h                |  4 ++P
The convention is to submit this uapi's bpf.h sync to tools/ in
a separate patch to make conflicts easier to be dealt with.
It will be the 2nd patch.

>  .../bpf/verifier/prevent_map_lookup.c         | 15 -------
>  tools/testing/selftests/bpf/verifier/sock.c   | 18 +++++++++
Hence, the selftest changes will be in the 3rd patch.

Others LGTM,
Acked-by: Martin KaFai Lau <kafai@fb.com>
