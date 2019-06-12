Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6C54493F
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfFMRQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:16:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50018 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728729AbfFLVro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 17:47:44 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CLleBd000812;
        Wed, 12 Jun 2019 14:47:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8LXXR8WGSmTXtXMu3e8cWsAgW/66TR3+i28iwl+pNhI=;
 b=ZEyU6SvOHJIR22ezXmhmnRdGxxPYTSNx4xgO+l+WVUH589zU4U7jisw6Fu0IlAjVXPbg
 nE0J9hacUfcmmwUeVk1JvSuFLDHXpNMVV5E0nD4mIxXtYahPlDmfr+qpE0LDYTKZO9Xf
 oOL9d3q4+KfYo3Ut+A6kXbALwEsrRNP56uU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t37b0ggar-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Jun 2019 14:47:40 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 12 Jun 2019 14:47:35 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 12 Jun 2019 14:47:34 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 12 Jun 2019 14:47:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8LXXR8WGSmTXtXMu3e8cWsAgW/66TR3+i28iwl+pNhI=;
 b=hT2UyHFnedbVqNXfkox7gglUS2nSFvLovmUbWZIpzdJ7T+opHgoSNsjlw/BT/SkW3iGS4n+gdV8JckUkZ9rORsLl+p5khwwb307pp7eNiQ+I1U3Etjtg7PxrSIoKuRuLrtu+7/2Ugo6yLSABeq+cb8UbuPn7jnxo+2lizMELTik=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1597.namprd15.prod.outlook.com (10.173.234.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Wed, 12 Jun 2019 21:47:33 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 21:47:33 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: Add test for SO_REUSEPORT_DETACH_BPF
Thread-Topic: [PATCH bpf-next 2/2] bpf: Add test for SO_REUSEPORT_DETACH_BPF
Thread-Index: AQHVIVHaRrrhQKOS0kuUzzPvAtDO2KaYb/6AgAAeNwA=
Date:   Wed, 12 Jun 2019 21:47:33 +0000
Message-ID: <20190612214726.dx42e2yjbk3eng6y@kafai-mbp.dhcp.thefacebook.com>
References: <20190612190536.2340077-1-kafai@fb.com>
 <20190612190539.2340343-1-kafai@fb.com> <20190612195917.GB9056@mini-arch>
In-Reply-To: <20190612195917.GB9056@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0014.namprd08.prod.outlook.com
 (2603:10b6:301:5f::27) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:564c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 542dac74-a384-4d36-731e-08d6ef7f934e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1597;
x-ms-traffictypediagnostic: MWHPR15MB1597:
x-microsoft-antispam-prvs: <MWHPR15MB1597DBA5DA2CFD96AA2E475AD5EC0@MWHPR15MB1597.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(39860400002)(346002)(366004)(199004)(189003)(5660300002)(52116002)(229853002)(14444005)(76176011)(386003)(256004)(6506007)(102836004)(6486002)(68736007)(6116002)(71200400001)(71190400001)(1076003)(6436002)(73956011)(64756008)(66946007)(66556008)(99286004)(66476007)(66446008)(6512007)(9686003)(53936002)(25786009)(476003)(186003)(305945005)(7736002)(316002)(6916009)(4326008)(2906002)(8936002)(446003)(81166006)(8676002)(14454004)(86362001)(81156014)(6246003)(11346002)(46003)(486006)(478600001)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1597;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qcOtqM4HpWMd1G9reqQzUhOvVM7XQiBwgxWzDzWbx2EwlcqAvGoh2u2dckDknIHiyTDJlH7mcu501reB8Ah3Jo+mTD5rdNpKDtAtoZklE7L1eO6WWN5Cn0+/SbzSmxCdjHFvStSLkJ1X5FRa9fkURNHFHqTkhm5GaXCGUfLHxmhyxmT3fyAo8WjRv/rbbgvnYCL7Fnju5d1WQLcuxygLhLtfzbEouzfYiDBHBooYJqrDA7A9sXINTjp/JitRhpvtQk9Ew81+yQ41jL3Zh0vs87MlaB7dsVWNLvvJoIqS7e1UEkLuqSs8OYpkE2E2xkygmsBCsiNh2NTs7c7FN1B1zajn/0hw3F0CCqF+PKhd6EInmABJO4XsY/fN+Wgodlx/oTCAwexlExsmogUl+zRSdFH/G54letrKF0d9yJBSMpk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DDD13CA509EF3D44A6882209C6FE045C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 542dac74-a384-4d36-731e-08d6ef7f934e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 21:47:33.5354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1597
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=926 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 12:59:17PM -0700, Stanislav Fomichev wrote:
> On 06/12, Martin KaFai Lau wrote:
> > This patch adds a test for the new sockopt SO_REUSEPORT_DETACH_BPF.
> >=20
> > '-I../../../../usr/include/' is added to the Makefile to get
> > the newly added SO_REUSEPORT_DETACH_BPF.
> >=20
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  tools/testing/selftests/bpf/Makefile          |  1 +
> >  .../selftests/bpf/test_select_reuseport.c     | 50 +++++++++++++++++++
> >  2 files changed, 51 insertions(+)
> >=20
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selft=
ests/bpf/Makefile
> > index 44fb61f4d502..c7370361fa81 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -16,6 +16,7 @@ LLVM_OBJCOPY	?=3D llvm-objcopy
> >  LLVM_READELF	?=3D llvm-readelf
> >  BTF_PAHOLE	?=3D pahole
> >  CFLAGS +=3D -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(GENDIR) =
$(GENFLAGS) -I../../../include \
> > +	  -I../../../../usr/include/ \
> Why not copy inlude/uapi/asm-generic/socket.h into tools/include
> instead? Will that work?
Sure. I am ok with copy.  I don't think we need to sync very often.
Do you know how to do that considering multiple arch's socket.h
have been changed in Patch 1?

Is copy better?

>=20
> >  	  -Dbpf_prog_load=3Dbpf_prog_test_load \
> >  	  -Dbpf_load_program=3Dbpf_test_load_program
> >  LDLIBS +=3D -lcap -lelf -lrt -lpthread
> > diff --git a/tools/testing/selftests/bpf/test_select_reuseport.c b/tool=
s/testing/selftests/bpf/test_select_reuseport.c
> > index 75646d9b34aa..5aa00b4a4702 100644
> > --- a/tools/testing/selftests/bpf/test_select_reuseport.c
> > +++ b/tools/testing/selftests/bpf/test_select_reuseport.c
> > @@ -523,6 +523,54 @@ static void test_pass_on_err(int type, sa_family_t=
 family)
> >  	printf("OK\n");
> >  }
> > =20
> > +static void test_detach_bpf(int type, sa_family_t family)
> > +{
> > +	__u32 nr_run_before =3D 0, nr_run_after =3D 0, tmp, i;
> > +	struct epoll_event ev;
> > +	int cli_fd, err, nev;
> > +	struct cmd cmd =3D {};
> > +	int optvalue =3D 0;
> > +
> > +	printf("%s: ", __func__);
> > +	err =3D setsockopt(sk_fds[0], SOL_SOCKET, SO_DETACH_REUSEPORT_BPF,
> > +			 &optvalue, sizeof(optvalue));
> > +	CHECK(err =3D=3D -1, "setsockopt(SO_DETACH_REUSEPORT_BPF)",
> > +	      "err:%d errno:%d\n", err, errno);
> > +
> > +	err =3D setsockopt(sk_fds[1], SOL_SOCKET, SO_DETACH_REUSEPORT_BPF,
> > +			 &optvalue, sizeof(optvalue));
> > +	CHECK(err =3D=3D 0 || errno !=3D ENOENT, "setsockopt(SO_DETACH_REUSEP=
ORT_BPF)",
> > +	      "err:%d errno:%d\n", err, errno);
> > +
> > +	for (i =3D 0; i < NR_RESULTS; i++) {
> > +		err =3D bpf_map_lookup_elem(result_map, &i, &tmp);
> > +		CHECK(err =3D=3D -1, "lookup_elem(result_map)",
> > +		      "i:%u err:%d errno:%d\n", i, err, errno);
> > +		nr_run_before +=3D tmp;
> > +	}
> > +
> > +	cli_fd =3D send_data(type, family, &cmd, sizeof(cmd), PASS);
> > +	nev =3D epoll_wait(epfd, &ev, 1, 5);
> > +	CHECK(nev <=3D 0, "nev <=3D 0",
> > +	      "nev:%d expected:1 type:%d family:%d data:(0, 0)\n",
> > +	      nev,  type, family);
> > +
> > +	for (i =3D 0; i < NR_RESULTS; i++) {
> > +		err =3D bpf_map_lookup_elem(result_map, &i, &tmp);
> > +		CHECK(err =3D=3D -1, "lookup_elem(result_map)",
> > +		      "i:%u err:%d errno:%d\n", i, err, errno);
> > +		nr_run_after +=3D tmp;
> > +	}
> > +
> > +	CHECK(nr_run_before !=3D nr_run_after,
> > +	      "nr_run_before !=3D nr_run_after",
> > +	      "nr_run_before:%u nr_run_after:%u\n",
> > +	      nr_run_before, nr_run_after);
> > +
> > +	printf("OK\n");
> > +	close(cli_fd);
> > +}
> > +
> >  static void prepare_sk_fds(int type, sa_family_t family, bool inany)
> >  {
> >  	const int first =3D REUSEPORT_ARRAY_SIZE - 1;
> > @@ -664,6 +712,8 @@ static void test_all(void)
> >  			test_pass(type, family);
> >  			test_syncookie(type, family);
> >  			test_pass_on_err(type, family);
> > +			/* Must be the last test */
> > +			test_detach_bpf(type, family);
> > =20
> >  			cleanup_per_test();
> >  			printf("\n");
> > --=20
> > 2.17.1
> >=20
