Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3538928E0D
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 01:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388561AbfEWXtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 19:49:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46168 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388232AbfEWXtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 19:49:36 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NNebEZ013857;
        Thu, 23 May 2019 16:49:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=anCZnXPpuXMoJ38NqQSh+Qtwb41WA2uoelsm1QZ8uEE=;
 b=VHUCEEc6N5HIwlXBknPvEPi3Jsm2MBaeZgi9nfO+FBSYI0OQxt85T0fIfO+FMHoO1VSf
 YLq84Mjy0/FerjN4zsd8XljFSO2t4DXU+1+M09CInEc7n5Li4FNvIsfZ3BjlbaH/VW2e
 PeX8QRDu1raN2uvduHq9HHRIfJMb/K5Q+nk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sp15ngwxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 May 2019 16:49:13 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 23 May 2019 16:49:12 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 23 May 2019 16:49:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anCZnXPpuXMoJ38NqQSh+Qtwb41WA2uoelsm1QZ8uEE=;
 b=hp7xUepN5hpeij2BdcGbiIqJDT5nqzyJesPxioEAs+JS0ok2j0/Z/s2/LIVmNimxELhvG5RVaukfUhLrbg1edRpyzVQHCz5JY4Gl+3YNwH5qkejR2gOwFPAjP9o5Pzdxuz/LJ2BImc+HDZIPN1IKqmWA3NyB8RSRrW3oD58JI3c=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB3142.namprd15.prod.outlook.com (20.178.239.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 23 May 2019 23:49:10 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a%7]) with mapi id 15.20.1922.018; Thu, 23 May 2019
 23:49:10 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Topic: [PATCH v3 bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Index: AQHVEaCPg78JwYs3bk+j5PuTlvgUDqZ5VeUAgAALEoA=
Date:   Thu, 23 May 2019 23:49:10 +0000
Message-ID: <20190523234904.GA18995@tower.DHCP.thefacebook.com>
References: <20190523194532.2376233-1-guro@fb.com>
 <20190523194532.2376233-5-guro@fb.com>
 <4ff840cb-7e24-62d5-4ea7-fbca34218800@fb.com>
In-Reply-To: <4ff840cb-7e24-62d5-4ea7-fbca34218800@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0079.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::20) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:3036]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f33cfa2-1f54-4439-b419-08d6dfd94045
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB3142;
x-ms-traffictypediagnostic: BYAPR15MB3142:
x-microsoft-antispam-prvs: <BYAPR15MB31422B0E27D121BE7EFC017DBE010@BYAPR15MB3142.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(346002)(396003)(376002)(189003)(199004)(486006)(81156014)(81166006)(33656002)(8936002)(6862004)(4326008)(25786009)(14454004)(316002)(186003)(99286004)(53936002)(68736007)(54906003)(66446008)(6246003)(256004)(2906002)(64756008)(5024004)(14444005)(66476007)(66556008)(8676002)(66946007)(6116002)(73956011)(76176011)(6512007)(46003)(9686003)(386003)(6506007)(53546011)(71200400001)(71190400001)(1076003)(5660300002)(446003)(6486002)(476003)(102836004)(52116002)(478600001)(86362001)(11346002)(6436002)(229853002)(6636002)(7736002)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3142;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JhUW2OPRCQhUXOmRB2XndGhV6WAaJfRuEhcasuAFnRT4Ee/UCj3k4/dlQTXtmnr/zq6kG8MrGbaDgm9OeTyBDAbqpCCrOLn0HuiBr7YlOL7cU6EGIsGLoCZlaQa2PGlMuSDAVc80TV4kmX9ndI9kCZ63zw9k5/8gfqBUNYepoHUOhG4WucUGI8D7txWG2GE+IIQZ2U0BMg2lEnskn76Z065E1ug265SCT2QySDx56OUFQCMjcWB3Yx2dpQKcXFg0yVuykY5XzV/Fp+yvmFFAqvQ2YoJTxL/95xOZC1uhMiRVn5YZm7AMtclX85BYzcdHBoNOIQ7+kT6WIvYZmb3TZHcEzoK+/OGV8ertnaq4G2TP2XaOi4UQ2QA/fTPUucOJkdNooa3NVGFY5miEVIyc4HxFNwXC2/Xn8sQBUQhjuPI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0AC895CF89FF2D42A731CD648CA32C9B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f33cfa2-1f54-4439-b419-08d6dfd94045
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 23:49:10.1509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3142
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_18:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 04:09:30PM -0700, Yonghong Song wrote:
>=20
>=20
> On 5/23/19 12:45 PM, Roman Gushchin wrote:
> > Add a kselftest to cover bpf auto-detachment functionality.
> > The test creates a cgroup, associates some resources with it,
> > attaches a couple of bpf programs and deletes the cgroup.
> >=20
> > Then it checks that bpf programs are going away in 5 seconds.
> >=20
> > Expected output:
> >    $ ./test_cgroup_attach
> >    #override:PASS
> >    #multi:PASS
> >    #autodetach:PASS
> >    test_cgroup_attach:PASS
> >=20
> > On a kernel without auto-detaching:
> >    $ ./test_cgroup_attach
> >    #override:PASS
> >    #multi:PASS
> >    #autodetach:FAIL
> >    test_cgroup_attach:FAIL
> >=20
> > Signed-off-by: Roman Gushchin <guro@fb.com>
>=20
> Looks good to me. It will be good if you can add test_cgroup_attach
> to .gitignore to avoid it shows up in `git status`. With that,
>

Here it is!

Thanks!

---

From 150fb4db7ab37f0e8b6482386e8830f3d11b64e1 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Thu, 23 May 2019 16:46:58 -0700
Subject: [PATCH bpf-next] selftests/bpf: add test_cgroup_attach to .gitigno=
re

Add test_cgroup_attach binary to .gitignore.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 tools/testing/selftests/bpf/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftes=
ts/bpf/.gitignore
index dd5d69529382..86a546e5e4db 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -22,6 +22,7 @@ test_lirc_mode2_user
 get_cgroup_id_user
 test_skb_cgroup_id_user
 test_socket_cookie
+test_cgroup_attach
 test_cgroup_storage
 test_select_reuseport
 test_flow_dissector
--=20
2.20.1

