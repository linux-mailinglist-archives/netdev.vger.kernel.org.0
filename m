Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF2F44953
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfFMRQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:16:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34300 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726429AbfFLVbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 17:31:13 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CLU31M011895;
        Wed, 12 Jun 2019 14:30:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8LXXR8WGSmTXtXMu3e8cWsAgW/66TR3+i28iwl+pNhI=;
 b=qXsdTW1uMLX0cK7RtX1mmOZoiqyAyyDOYDyrGEYTU9Czjutu+LAcw8eDy4mOkuqIuf3e
 AnAt/q3SRT2UUgrxAIOgiu7Bq1XAepp6/t92MAym5GY/eFBRWiaBEB2URj6d9xXyyQzf
 fEkJ6na3/aizEgCqFE0bkLjKxemJRo+Se9o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t365k0rbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 12 Jun 2019 14:30:51 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Jun 2019 14:30:49 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 12 Jun 2019 14:30:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8LXXR8WGSmTXtXMu3e8cWsAgW/66TR3+i28iwl+pNhI=;
 b=LxDClT4ozT2CbdJROHrgNx+ENLsBX7vINdhi3Ap/CTKSmZSp+qLfJiQLh4BiaOYxV3PgaAhhHlBq2CGnz444Bm9CmxcJwnHG6AwkG4dwTM3hGSfNhyk8z34e2a3xwOUL5MYicQtgWsUnEqRzQC1VDXiape3IeAhSk7fq7GhJgz4=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1280.namprd15.prod.outlook.com (10.175.3.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Wed, 12 Jun 2019 21:30:48 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::6590:7f75:5516:3871%3]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 21:30:48 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: Add test for SO_REUSEPORT_DETACH_BPF
Thread-Topic: [PATCH bpf-next 2/2] bpf: Add test for SO_REUSEPORT_DETACH_BPF
Thread-Index: AQHVIVHaRrrhQKOS0kuUzzPvAtDO2KaYb/6AgAAZjwA=
Date:   Wed, 12 Jun 2019 21:30:48 +0000
Message-ID: <20190612213046.e7tkduk5nfuv5s6a@kafai-mbp.dhcp.thefacebook.com>
References: <20190612190536.2340077-1-kafai@fb.com>
 <20190612190539.2340343-1-kafai@fb.com> <20190612195917.GB9056@mini-arch>
In-Reply-To: <20190612195917.GB9056@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:301:4c::26) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:564c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d929790-bc3e-49cf-0c56-08d6ef7d3c2a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1280;
x-ms-traffictypediagnostic: MWHPR15MB1280:
x-microsoft-antispam-prvs: <MWHPR15MB1280BE8E10E626C81D55A260D5EC0@MWHPR15MB1280.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(346002)(366004)(396003)(376002)(189003)(199004)(6116002)(478600001)(14454004)(4326008)(6246003)(5660300002)(1076003)(7736002)(76176011)(25786009)(6436002)(52116002)(305945005)(2906002)(11346002)(476003)(99286004)(186003)(446003)(6506007)(102836004)(46003)(386003)(486006)(53936002)(68736007)(9686003)(6512007)(6916009)(71200400001)(8936002)(316002)(14444005)(256004)(71190400001)(6486002)(66446008)(229853002)(66556008)(81156014)(66946007)(64756008)(81166006)(8676002)(66476007)(73956011)(86362001)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1280;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dScK4jXckMnG14/bCCeyo4o0hMbIA7DfuTmo2yvMVZKrsT6BqQsUhIbGL/i3udZiOmkqczNMPaUOW6wc0YkMw/a5/L3Uas7FfEqd7gVF0DJgSiO2l75yH3XBu1bpABoYpTVPkO/bOlaSXSw5mP45ezhgP1Q1+m0dbo4WK9w1870oQ4i2A5he2cKrwOg3fc4t+1OynTxp5WYIzVo7YnhOlmXAL2rkhf4yhx/f9Vfdx/5KfhJOvwPtAwqfIN92fPn+i/xGK58kvEEGFY9QBedpt2cUNMsOrszPF/H7VA5IeY96nV44QxcND9UiAoWoVqoudS0h9426bp0LoZCQwlIM88QLPxAdh4yz07yAlwCotSJllfFQWJ+kXn8SiCwvRmT5BNksNVZT6PyirtjdOfdcR6bFSQ9vAhoujP3rQCe23SM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1E37CB011EC8934EABDE961CF4E33D70@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d929790-bc3e-49cf-0c56-08d6ef7d3c2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 21:30:48.4147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1280
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=928 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120148
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
