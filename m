Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1456272DE
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbfEVXUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:20:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54992 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727936AbfEVXUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:20:24 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MNDMJU015106;
        Wed, 22 May 2019 16:20:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=neuB7kOtjPjVNsQiYpjxhh4qw6MP1AxSqcWVcBpfwiI=;
 b=mtXW+JcNh2NX0GnCTMJofk/Y3w91D9GsJdd8aQZVl4NO19SrVFSl5myiNTbBWc/n4qq4
 40n7g6AEakParC2VkpG6lkDc3VXXf/tA4PMRlmC582hA73RCcy7SyGVP3bxCTt5Xk93p
 vseqUC5O7NmRNGEpXpc2zoOGNonuMbSE300= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn8rt9sgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 16:20:03 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 22 May 2019 16:20:02 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 22 May 2019 16:20:02 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 22 May 2019 16:20:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=neuB7kOtjPjVNsQiYpjxhh4qw6MP1AxSqcWVcBpfwiI=;
 b=Q8qBK66gzprMTHerkNx2TZAop3X7fHpJY+1CCOh22T+ZYadlW/WmN/IS9xiWtw1JvLGFyTmBfzGmcBqkTlAFRKsyPiyFTAsn2i1gHCQQRzwc5H6gZmWHeOAl0Qu1OwGxIDF/ktU0A+aWcycYbKIBMZfpOT4A99sXTnVHop0eAYQ=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB2615.namprd15.prod.outlook.com (20.179.155.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 22 May 2019 23:20:00 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::d4f6:b485:69ee:fd9a%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 23:20:00 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Topic: [PATCH bpf-next 4/4] selftests/bpf: add auto-detach test
Thread-Index: AQHVEOV6qenHistAZ0WXzSfuc95yzqZ3uH0AgAAPcQA=
Date:   Wed, 22 May 2019 23:19:59 +0000
Message-ID: <20190522231954.GB20167@tower.DHCP.thefacebook.com>
References: <20190522212932.2646247-1-guro@fb.com>
 <20190522212932.2646247-5-guro@fb.com> <20190522222438.GB3032@mini-arch>
In-Reply-To: <20190522222438.GB3032@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0036.namprd22.prod.outlook.com
 (2603:10b6:301:28::49) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::7d4f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59f8b9b6-3e8e-4cfb-3179-08d6df0c0290
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2615;
x-ms-traffictypediagnostic: BYAPR15MB2615:
x-microsoft-antispam-prvs: <BYAPR15MB2615DDF4664F685BD2EFF7F6BE000@BYAPR15MB2615.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(39860400002)(396003)(346002)(199004)(189003)(229853002)(46003)(54906003)(53936002)(2906002)(6246003)(478600001)(8936002)(81166006)(81156014)(6436002)(9686003)(186003)(6486002)(8676002)(6916009)(11346002)(33656002)(446003)(6116002)(486006)(316002)(476003)(6512007)(305945005)(99286004)(5660300002)(6506007)(71190400001)(14444005)(68736007)(71200400001)(7736002)(76176011)(102836004)(5024004)(386003)(73956011)(52116002)(4326008)(86362001)(1076003)(14454004)(25786009)(66556008)(66446008)(64756008)(66476007)(66946007)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2615;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xktschjKKGgfm8e6zZlXkNI/IFyUQg94Guow49gf+pPwmnyjjmAWx7i4/3HqSLZTkmsY0MmuHW8TTGb4m0+ETSTH7YtXvLTGaLrA/GfvA8zJJxLMvnaoyElY0dQBSNbZc7UYFooFlA10HTvSp1YMCTSReTS+t03CS9DTkobZPHU/m0BDEUne6EhYenNHJdaC/pKGwIuPYAFk9+UpdCigK6Afhj3CDajUuaQxOkMoU3cCv0lTjhtU1HdDDJ7et+igHrPiiWZ7JeU8wTkvqD7ITW2m4Dd2o0jhoamODFKb3wCl+t6wPHZscXkUzmS2MQul3dYtfr5dxbndfMf1Ekc6KVGOVULJjK6jBB6aHa47NFoAn5WLjm2rzIf41NUXwseWQBFSD+C7Ld0Rb6dgKgfD0I8VgIGFKfw+gvYGPW47QK0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EE6BDDC0F0D64B4B934848EF010D42BF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f8b9b6-3e8e-4cfb-3179-08d6df0c0290
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 23:19:59.8347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2615
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 03:24:38PM -0700, Stanislav Fomichev wrote:
> On 05/22, Roman Gushchin wrote:
> > Add a kselftest to cover bpf auto-detachment functionality.
> > The test creates a cgroup, associates some resources with it,
> > attaches a couple of bpf programs and deletes the cgroup.
> >=20
> > Then it checks that bpf programs are going away in 5 seconds.
> >=20
> > Expected output:
> >   $ ./test_cgroup_attach
> >   #override:PASS
> >   #multi:PASS
> >   #autodetach:PASS
> >   test_cgroup_attach:PASS
> >=20
> > On a kernel without auto-detaching:
> >   $ ./test_cgroup_attach
> >   #override:PASS
> >   #multi:PASS
> >   #autodetach:FAIL
> >   test_cgroup_attach:FAIL
> >=20
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > ---
> >  .../selftests/bpf/test_cgroup_attach.c        | 108 +++++++++++++++++-
> >  1 file changed, 107 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/tools/testing/selftests/bpf/test_cgroup_attach.c b/tools/t=
esting/selftests/bpf/test_cgroup_attach.c
> > index 93d4fe295e7d..36441fd0f392 100644
> > --- a/tools/testing/selftests/bpf/test_cgroup_attach.c
> > +++ b/tools/testing/selftests/bpf/test_cgroup_attach.c
> > @@ -456,9 +456,115 @@ static int test_multiprog(void)
> >  	return rc;
> >  }
> > =20
> > +static int test_autodetach(void)
> > +{
> > +	__u32 prog_cnt =3D 4, attach_flags;
> > +	int allow_prog[2] =3D {0};
> > +	__u32 prog_ids[2] =3D {0};
> > +	int cg =3D 0, i, rc =3D -1;
> > +	void *ptr =3D NULL;
> > +	int attempts;
> > +
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(allow_prog); i++) {
> > +		allow_prog[i] =3D prog_load_cnt(1, 1 << i);
> > +		if (!allow_prog[i])
> > +			goto err;
> > +	}
> > +
> > +	if (setup_cgroup_environment())
> > +		goto err;
> > +
> > +	/* create a cgroup, attach two programs and remember their ids */
> > +	cg =3D create_and_get_cgroup("/cg_autodetach");
> > +	if (cg < 0)
> > +		goto err;
> > +
> > +	if (join_cgroup("/cg_autodetach"))
> > +		goto err;
> > +
> > +	for (i =3D 0; i < ARRAY_SIZE(allow_prog); i++) {
> > +		if (bpf_prog_attach(allow_prog[i], cg, BPF_CGROUP_INET_EGRESS,
> > +				    BPF_F_ALLOW_MULTI)) {
> > +			log_err("Attaching prog[%d] to cg:egress", i);
> > +			goto err;
> > +		}
> > +	}
> > +
> > +	/* make sure that programs are attached and run some traffic */
> > +	assert(bpf_prog_query(cg, BPF_CGROUP_INET_EGRESS, 0, &attach_flags,
> > +			      prog_ids, &prog_cnt) =3D=3D 0);
> > +	assert(system(PING_CMD) =3D=3D 0);
> > +
> > +	/* allocate some memory (4Mb) to pin the original cgroup */
> > +	ptr =3D malloc(4 * (1 << 20));
> > +	if (!ptr)
> > +		goto err;
> > +
> > +	/* close programs and cgroup fd */
> > +	for (i =3D 0; i < ARRAY_SIZE(allow_prog); i++) {
> > +		close(allow_prog[i]);
> > +		allow_prog[i] =3D 0;
> > +	}
> > +
> > +	close(cg);
> > +	cg =3D 0;
> > +
> > +	/* leave the cgroup and remove it. don't detach programs */
> > +	cleanup_cgroup_environment();
> > +
>=20
> [..]
> > +	/* programs must stay pinned by the allocated memory */
> > +	for (i =3D 0; i < ARRAY_SIZE(prog_ids); i++) {
> > +		int fd =3D bpf_prog_get_fd_by_id(prog_ids[i]);
> > +
> > +		if (fd < 0)
> > +			goto err;
> > +		close(fd);
> > +	}
> This looks a bit flaky. It's essentially the same check you later
> do in a for loop. I guess there is a chance that async auto-detach
> might happen right after cleanup_cgroup_environment and before this for l=
oop?

Ah, this section remained from an earlier version which had another step.
I'll remove it completely, it's totally useless now.

Thanks!
