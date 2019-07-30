Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 786A97B56C
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 00:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387933AbfG3WBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 18:01:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387561AbfG3WBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 18:01:33 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6ULvbf1027576;
        Tue, 30 Jul 2019 15:01:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cpL2smeGy6qNc/w9NBA67muGPiTV79geblZBI66d+A8=;
 b=IDhuSRSwVVWYz1x+vd+IVDZf0VtBbmtsOiRukjG2SH58D7+MdSJ/IskCX21ASHckS56x
 aKmnqdQbvOCUnQS1mWn1vnuAfFNwgcO7IDBdpNgAbRqIBaBsQkGbpeOagTlwQMZWVIa8
 8aEUl5zbgko3RcVpCUxFRvauSNWNsv/ctuE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2ty50svb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 30 Jul 2019 15:01:08 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 30 Jul 2019 15:01:07 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 15:01:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtSdhKpSNGpcBZSBE2gaOpvURPeWvXvhOXxcH5WMJzAsZ5QFS1tJztAS7+AOmrTkOTi3y2AA/sKTLc6PyXQJmrbiUGg6zZ6GJwJ7H5cawX2pGRB3HLcQB4Z5H3By3oyh2HSVW6gR1gUPSLuBWNhDysgwtJFG6IWGCLBrCLPgYt1jZsy6PJNUFCMPpDeNLSyz2Kep0KMDuHHxW1wo1LoSZEHecVGpPIiDd6R19Xfio1sVaWFR/bZtY8/46bfJCb8wZF3epwpldmXiShTm1w/DKRlnWghlbbbxRiT5FQl1tnjZvDxZNnNilBEqb8VnPY6z4GtV7JSW0qeUsBcTOsdeww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpL2smeGy6qNc/w9NBA67muGPiTV79geblZBI66d+A8=;
 b=BFDIFtYQHboPCyGc25eFzwjfSk54QesoTU6+p85p8/QYhgCKVUeBRI9nyrWPDkn7dD5jRWy8r5yKRafEweE0zwfWH93v5/TTgALR2WyAl18eHVhM+6HAkdEiQSeyUbY1feO/dxIEoIx7bxGDdZPwp5DBiyw7Rei48HM/MB2w5Xrr9FETc/+2O69e5Rr4l+D3fcZ/TqbLdcKfZN81TtF6lavKrrlPJuPGOKU5jxjwbLpPzOVLmpk2+lqaTGWKGqQCMl0oVUSHgMi83g784RCF4xU1ThbUwWJECC2SpHvpTv1nOTMZEa8JYfc8dplFUAMzanqaG3RoS5lHtdQ/n4c53A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpL2smeGy6qNc/w9NBA67muGPiTV79geblZBI66d+A8=;
 b=NlAj/cSzPyzyeo7r6nj4XuWKujQ3LbSIwHe4EYnaS1jwvwNqoEF0TekRJZyW/bJtk1yWwmlpuliWEeNLmtOfSjeXIU9esVMANjbWl86kXPOGpaDsKi+84RrU2BG5xtqBRBw8NgZ8w9wQudLmf5TMHnWTLUQXJApY48MVwEA7Sus=
Received: from BYAPR15MB3128.namprd15.prod.outlook.com (20.178.239.159) by
 BYAPR15MB2693.namprd15.prod.outlook.com (20.179.156.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Tue, 30 Jul 2019 22:01:04 +0000
Received: from BYAPR15MB3128.namprd15.prod.outlook.com
 ([fe80::99e:cade:56c3:74a3]) by BYAPR15MB3128.namprd15.prod.outlook.com
 ([fe80::99e:cade:56c3:74a3%4]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 22:01:04 +0000
From:   Takshak Chahande <ctakshak@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        Kernel Team <Kernel-team@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH bpf-next v2] tools: bpftool: add support for reporting the
 effective cgroup progs
Thread-Topic: [PATCH bpf-next v2] tools: bpftool: add support for reporting
 the effective cgroup progs
Thread-Index: AQHVRxo2uTWxGIQYaEuHTrJGkU+a/Kbjtk6A
Date:   Tue, 30 Jul 2019 22:01:03 +0000
Message-ID: <20190730220053.GA69301@ctakshak-mbp.dhcp.thefacebook.com>
References: <20190730210300.13113-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190730210300.13113-1-jakub.kicinski@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0036.namprd04.prod.outlook.com
 (2603:10b6:300:ee::22) To BYAPR15MB3128.namprd15.prod.outlook.com
 (2603:10b6:a03:b0::31)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:2b97]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b912204-d921-4d31-150f-08d715396a38
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB2693;
x-ms-traffictypediagnostic: BYAPR15MB2693:
x-microsoft-antispam-prvs: <BYAPR15MB26937F6099DBDEB3C601FDEFBDDC0@BYAPR15MB2693.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(39860400002)(136003)(376002)(396003)(199004)(189003)(66446008)(6436002)(33656002)(486006)(256004)(2906002)(6246003)(478600001)(8676002)(5024004)(46003)(476003)(6116002)(25786009)(14454004)(71200400001)(71190400001)(446003)(4326008)(6486002)(81156014)(81166006)(186003)(6512007)(53936002)(9686003)(8936002)(316002)(66556008)(54906003)(86362001)(99286004)(11346002)(305945005)(7736002)(6916009)(1076003)(5660300002)(68736007)(76176011)(229853002)(386003)(52116002)(102836004)(6506007)(66946007)(64756008)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2693;H:BYAPR15MB3128.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: paGXr1ryycjxFNI6yhh8GViywLmNpN3E4JueBL/MMaDwiQRyrOT9f+heh3RFSMuha7nP5xg/sTkVDxLwR4n/YCBZRJrXzUiH1y8egFFcYHF56My8tOYlP/+6iq4l4ymeX4Xe72rrPYw5DAMVIspPpxfkBLKKFbbRcU0Ui66xQtBBX/xp8dI4pdoO4qVZsoaitgbyYZQ3xBa3xo7wUDg3s/O0josxFuVjS/c5292kHZMm7/WZNcvd4eIXB7+sDdtDHeKpg+EChj8AVSUerHS5xlh6ryDTtxeAmgtvHW1k8dbryIkw9Q7052xvr4btuyzXQZR3GiY9wBQOgOWYSC/QqFCcHfhKpcab2fqwAf6RibI+fpub5DVA4Np5GTmq3EXE83VcHOxpdD9A8/J1DgfOKjHjIvGj9NNFCQ+1XYAQcQY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3DF13380FB5864408192986BA5F849F8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b912204-d921-4d31-150f-08d715396a38
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 22:01:03.8692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ctakshak@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300219
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <jakub.kicinski@netronome.com> wrote on Tue [2019-Jul-30 14:=
03:00 -0700]:
> Takshak said in the original submission:
>=20
> With different bpf attach_flags available to attach bpf programs speciall=
y
> with BPF_F_ALLOW_OVERRIDE and BPF_F_ALLOW_MULTI, the list of effective
> bpf-programs available to any sub-cgroups really needs to be available fo=
r
> easy debugging.
>=20
> Using BPF_F_QUERY_EFFECTIVE flag, one can get the list of not only attach=
ed
> bpf-programs to a cgroup but also the inherited ones from parent cgroup.
>=20
> So a new option is introduced to use BPF_F_QUERY_EFFECTIVE query flag her=
e
> to list all the effective bpf-programs available for execution at a speci=
fied
> cgroup.
>=20
> Reused modified test program test_cgroup_attach from tools/testing/selfte=
sts/bpf:
>   # ./test_cgroup_attach
>=20
> With old bpftool:
>=20
>  # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/
>   ID       AttachType      AttachFlags     Name
>   271      egress          multi           pkt_cntr_1
>   272      egress          multi           pkt_cntr_2
>=20
> Attached new program pkt_cntr_4 in cg2 gives following:
>=20
>  # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2
>   ID       AttachType      AttachFlags     Name
>   273      egress          override        pkt_cntr_4
>=20
> And with new "effective" option it shows all effective programs for cg2:
>=20
>  # bpftool cgroup show /sys/fs/cgroup/cgroup-test-work-dir/cg1/cg2 effect=
ive
>   ID       AttachType      AttachFlags     Name
>   273      egress          override        pkt_cntr_4
>   271      egress          override        pkt_cntr_1
>   272      egress          override        pkt_cntr_2
>=20
> Compared to original submission use a local flag instead of global
> option.
>=20
> We need to clear query_flags on every command, in case batch mode
> wants to use varying settings.
>=20
> v2: (Takshak)
>  - forbid duplicated flags;
>  - fix cgroup path freeing.
>=20
> Signed-off-by: Takshak Chahande <ctakshak@fb.com>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
> ---
>  .../bpftool/Documentation/bpftool-cgroup.rst  | 16 +++-
>  tools/bpf/bpftool/bash-completion/bpftool     | 15 ++--
>  tools/bpf/bpftool/cgroup.c                    | 83 ++++++++++++-------
>  3 files changed, 76 insertions(+), 38 deletions(-)
>=20
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/b=
pf/bpftool/Documentation/bpftool-cgroup.rst
> index 585f270c2d25..06a28b07787d 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
> @@ -20,8 +20,8 @@ SYNOPSIS
>  CGROUP COMMANDS
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> -|	**bpftool** **cgroup { show | list }** *CGROUP*
> -|	**bpftool** **cgroup tree** [*CGROUP_ROOT*]
> +|	**bpftool** **cgroup { show | list }** *CGROUP* [**effective**]
> +|	**bpftool** **cgroup tree** [*CGROUP_ROOT*] [**effective**]
>  |	**bpftool** **cgroup attach** *CGROUP* *ATTACH_TYPE* *PROG* [*ATTACH_F=
LAGS*]
>  |	**bpftool** **cgroup detach** *CGROUP* *ATTACH_TYPE* *PROG*
>  |	**bpftool** **cgroup help**
> @@ -35,13 +35,17 @@ CGROUP COMMANDS
> =20
>  DESCRIPTION
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -	**bpftool cgroup { show | list }** *CGROUP*
> +	**bpftool cgroup { show | list }** *CGROUP* [**effective**]
>  		  List all programs attached to the cgroup *CGROUP*.
> =20
>  		  Output will start with program ID followed by attach type,
>  		  attach flags and program name.
> =20
> -	**bpftool cgroup tree** [*CGROUP_ROOT*]
> +		  If **effective** is specified retrieve effective programs that
> +		  will execute for events within a cgroup. This includes
> +		  inherited along with attached ones.
> +
> +	**bpftool cgroup tree** [*CGROUP_ROOT*] [**effective**]
>  		  Iterate over all cgroups in *CGROUP_ROOT* and list all
>  		  attached programs. If *CGROUP_ROOT* is not specified,
>  		  bpftool uses cgroup v2 mountpoint.
> @@ -50,6 +54,10 @@ DESCRIPTION
>  		  commands: it starts with absolute cgroup path, followed by
>  		  program ID, attach type, attach flags and program name.
> =20
> +		  If **effective** is specified retrieve effective programs that
> +		  will execute for events within a cgroup. This includes
> +		  inherited along with attached ones.
> +
>  	**bpftool cgroup attach** *CGROUP* *ATTACH_TYPE* *PROG* [*ATTACH_FLAGS*=
]
>  		  Attach program *PROG* to the cgroup *CGROUP* with attach type
>  		  *ATTACH_TYPE* and optional *ATTACH_FLAGS*.
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftoo=
l/bash-completion/bpftool
> index 6b961a5ed100..df16c5415444 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -710,12 +710,15 @@ _bpftool()
>              ;;
>          cgroup)
>              case $command in
> -                show|list)
> -                    _filedir
> -                    return 0
> -                    ;;
> -                tree)
> -                    _filedir
> +                show|list|tree)
> +                    case $cword in
> +                        3)
> +                            _filedir
> +                            ;;
> +                        4)
> +                            COMPREPLY=3D( $( compgen -W 'effective' -- "=
$cur" ) )
> +                            ;;
> +                    esac
>                      return 0
>                      ;;
>                  attach|detach)
> diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
> index f3c05b08c68c..44352b5aca85 100644
> --- a/tools/bpf/bpftool/cgroup.c
> +++ b/tools/bpf/bpftool/cgroup.c
> @@ -29,6 +29,8 @@
>  	"                        recvmsg4 | recvmsg6 | sysctl |\n"	       \
>  	"                        getsockopt | setsockopt }"
> =20
> +static unsigned int query_flags;
> +
>  static const char * const attach_type_strings[] =3D {
>  	[BPF_CGROUP_INET_INGRESS] =3D "ingress",
>  	[BPF_CGROUP_INET_EGRESS] =3D "egress",
> @@ -107,7 +109,8 @@ static int count_attached_bpf_progs(int cgroup_fd, en=
um bpf_attach_type type)
>  	__u32 prog_cnt =3D 0;
>  	int ret;
> =20
> -	ret =3D bpf_prog_query(cgroup_fd, type, 0, NULL, NULL, &prog_cnt);
> +	ret =3D bpf_prog_query(cgroup_fd, type, query_flags, NULL,
> +			     NULL, &prog_cnt);
>  	if (ret)
>  		return -1;
> =20
> @@ -125,8 +128,8 @@ static int show_attached_bpf_progs(int cgroup_fd, enu=
m bpf_attach_type type,
>  	int ret;
> =20
>  	prog_cnt =3D ARRAY_SIZE(prog_ids);
> -	ret =3D bpf_prog_query(cgroup_fd, type, 0, &attach_flags, prog_ids,
> -			     &prog_cnt);
> +	ret =3D bpf_prog_query(cgroup_fd, type, query_flags, &attach_flags,
> +			     prog_ids, &prog_cnt);
>  	if (ret)
>  		return ret;
> =20
> @@ -158,20 +161,34 @@ static int show_attached_bpf_progs(int cgroup_fd, e=
num bpf_attach_type type,
>  static int do_show(int argc, char **argv)
>  {
>  	enum bpf_attach_type type;
> +	const char *path;
>  	int cgroup_fd;
>  	int ret =3D -1;
> =20
> -	if (argc < 1) {
> -		p_err("too few parameters for cgroup show");
> -		goto exit;
> -	} else if (argc > 1) {
> -		p_err("too many parameters for cgroup show");
> -		goto exit;
> +	query_flags =3D 0;
> +
> +	if (!REQ_ARGS(1))
> +		return -1;
> +	path =3D GET_ARG();
> +
> +	while (argc) {
> +		if (is_prefix(*argv, "effective")) {
> +			if (query_flags & BPF_F_QUERY_EFFECTIVE) {
> +				p_err("duplicated argument: %s", *argv);
> +				return -1;
> +			}
> +			query_flags |=3D BPF_F_QUERY_EFFECTIVE;
> +			NEXT_ARG();
> +		} else {
> +			p_err("expected no more arguments, 'effective', got: '%s'?",
> +			      *argv);
> +			return -1;
> +		}
>  	}
> =20
> -	cgroup_fd =3D open(argv[0], O_RDONLY);
> +	cgroup_fd =3D open(path, O_RDONLY);
>  	if (cgroup_fd < 0) {
> -		p_err("can't open cgroup %s", argv[0]);
> +		p_err("can't open cgroup %s", path);
>  		goto exit;
>  	}
> =20
> @@ -294,26 +311,37 @@ static char *find_cgroup_root(void)
> =20
>  static int do_show_tree(int argc, char **argv)
>  {
> -	char *cgroup_root;
> +	char *cgroup_root, *cgroup_alloced =3D NULL;
>  	int ret;
> =20
> -	switch (argc) {
> -	case 0:
> -		cgroup_root =3D find_cgroup_root();
> -		if (!cgroup_root) {
> +	query_flags =3D 0;
> +
> +	if (!argc) {
> +		cgroup_alloced =3D find_cgroup_root();
> +		if (!cgroup_alloced) {
>  			p_err("cgroup v2 isn't mounted");
>  			return -1;
>  		}
> -		break;
> -	case 1:
> -		cgroup_root =3D argv[0];
> -		break;
> -	default:
> -		p_err("too many parameters for cgroup tree");
> -		return -1;
> +		cgroup_root =3D cgroup_alloced;
> +	} else {
> +		cgroup_root =3D GET_ARG();
> +
> +		while (argc) {
> +			if (is_prefix(*argv, "effective")) {
> +				if (query_flags & BPF_F_QUERY_EFFECTIVE) {
> +					p_err("duplicated argument: %s", *argv);
> +					return -1;
> +				}
> +				query_flags |=3D BPF_F_QUERY_EFFECTIVE;
> +				NEXT_ARG();
> +			} else {
> +				p_err("expected no more arguments, 'effective', got: '%s'?",
> +				      *argv);
> +				return -1;
> +			}
> +		}
>  	}
> =20
> -
>  	if (json_output)
>  		jsonw_start_array(json_wtr);
>  	else
> @@ -338,8 +366,7 @@ static int do_show_tree(int argc, char **argv)
>  	if (json_output)
>  		jsonw_end_array(json_wtr);
> =20
> -	if (argc =3D=3D 0)
> -		free(cgroup_root);
> +	free(cgroup_alloced);
> =20
>  	return ret;
>  }
> @@ -459,8 +486,8 @@ static int do_help(int argc, char **argv)
>  	}
> =20
>  	fprintf(stderr,
> -		"Usage: %s %s { show | list } CGROUP\n"
> -		"       %s %s tree [CGROUP_ROOT]\n"
> +		"Usage: %s %s { show | list } CGROUP [**effective**]\n"
> +		"       %s %s tree [CGROUP_ROOT] [**effective**]\n"
>  		"       %s %s attach CGROUP ATTACH_TYPE PROG [ATTACH_FLAGS]\n"
>  		"       %s %s detach CGROUP ATTACH_TYPE PROG\n"
>  		"       %s %s help\n"
> --=20
> 2.21.0
>=20

Thanks for v2; looks good.

Reviewed-by: Takshak Chahande <ctakshak@fb.com>
