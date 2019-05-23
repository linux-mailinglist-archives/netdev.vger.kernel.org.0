Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0AB28DF6
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 01:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388492AbfEWXnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 19:43:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49542 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388129AbfEWXnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 19:43:25 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NNea3u006535;
        Thu, 23 May 2019 16:43:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=f056jcvQEMd8XhBuxKG3eAcSjUdhkSgLRalk/El0N+A=;
 b=F4T0GEL1HOFBoMyaZLkCnbWi57oAi5qJzhOOsf+TsXSqgM2aUV5isfi1KP99pIko6SRg
 GnH1oE8bl4iP/CD5aJi525wNhogjZS6ZE8HMgdHXuLtzt7sgKE8eO1eIvew0otokB7P1
 PqM4MiBv5w0dCMgWmX0pfBZ/vk4irk1qbIA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sp3e0rcjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 May 2019 16:43:03 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 May 2019 16:43:02 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 May 2019 16:43:02 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 23 May 2019 16:43:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f056jcvQEMd8XhBuxKG3eAcSjUdhkSgLRalk/El0N+A=;
 b=GiO2qQwpaobSq+eJipapKcGrkwbwGvuBZ2A7X+ocKiXnnGTH35BEct8xvFDZCUmYv6mqKC4A1AEz7hQIgv8/6LBrucAHtqtaIuNDvgAMvqWt+Ngiz0vSo2iZUL8wJdfL7623/ulDzwCCOsViIUFlrbmWTFtaG82/bc1RpBxg9+A=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB3142.namprd15.prod.outlook.com (20.178.239.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 23 May 2019 23:43:00 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a%7]) with mapi id 15.20.1922.018; Thu, 23 May 2019
 23:43:00 +0000
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
Thread-Index: AQHVEaCPg78JwYs3bk+j5PuTlvgUDqZ5VeUAgAAJVwA=
Date:   Thu, 23 May 2019 23:43:00 +0000
Message-ID: <20190523234254.GA17907@tower.DHCP.thefacebook.com>
References: <20190523194532.2376233-1-guro@fb.com>
 <20190523194532.2376233-5-guro@fb.com>
 <4ff840cb-7e24-62d5-4ea7-fbca34218800@fb.com>
In-Reply-To: <4ff840cb-7e24-62d5-4ea7-fbca34218800@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0078.namprd02.prod.outlook.com
 (2603:10b6:301:75::19) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:3036]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a2cdaf1-f1b0-4ac0-4db2-08d6dfd863de
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB3142;
x-ms-traffictypediagnostic: BYAPR15MB3142:
x-microsoft-antispam-prvs: <BYAPR15MB3142D0BF135F4F5CC5E64E5DBE010@BYAPR15MB3142.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(346002)(396003)(376002)(189003)(199004)(486006)(81156014)(81166006)(33656002)(8936002)(6862004)(4326008)(25786009)(14454004)(316002)(186003)(99286004)(53936002)(68736007)(54906003)(66446008)(6246003)(256004)(2906002)(64756008)(5024004)(66476007)(66556008)(8676002)(66946007)(6116002)(73956011)(76176011)(6512007)(46003)(9686003)(386003)(6506007)(53546011)(71200400001)(71190400001)(1076003)(5660300002)(446003)(4744005)(6486002)(476003)(102836004)(52116002)(478600001)(86362001)(11346002)(6436002)(229853002)(6636002)(7736002)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3142;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: csUhtAAKF1/GJtflklgpZYsuPVt80h40oYov75PbRGEc0l1h7slRAcK0dYQtkmfPxg0Bti3Dk4l6m/hPhKewY2Bv/yY/BKcFiUpxk8z/8Nu9X1RVbC3zqkgPkR2WK5ioVYWVmHn7PM5VuHv4kR4p3rgvjRZHmj53CQhzOFUkNSV93cE5e7O8S2jyPDap1/6AxrHHi6MHrKFrWyOqfEy1WYijLQBoLXT4Vn77m56qxnWx4ciSQ1ecGaTke3wKYKU/12hzZnGHtHYemvopPHgDCbmScCSiJPFvizd7reV8T8OuaedcOyd8TirGPTiXL1VnRiu5bfNKFokQ3RchrTE+OTSRhH948VXvoNJxcvOCUo6192U3wA1oTqDjO9u22PMmcbGauaMdXowXt0VJbi/ctmL196pjJhI9Atyz8HE8iZM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <939DF126ABA27447928EED9237DE1734@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a2cdaf1-f1b0-4ac0-4db2-08d6dfd863de
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 23:43:00.3605
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
 mlxlogscore=471 adultscore=0 classifier=spam adjust=0 reason=mlx
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

I don't think it deserves a new version, I'll prepare a separate patch
for it.

>=20
> Acked-by: Yonghong Song <yhs@fb.com>

Thank you for the review!
