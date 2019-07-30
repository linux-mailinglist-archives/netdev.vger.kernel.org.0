Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4FDA7B13B
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 20:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbfG3SFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 14:05:18 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19330 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbfG3SFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 14:05:17 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6UI3AdC002673;
        Tue, 30 Jul 2019 11:04:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=N+Ky9NTjMD8/rdxe8aS3AqheINM0Mxf9g7pfJFTUvd4=;
 b=D2V/XWyHxgMcLCQNPklFj+iw1C/kOF6IOmMvUXyRhUKCTS2yk8pyYQPwnlD/gj0EAMDt
 xZWMqpD6rDQR14UDnPh2adG2Kvlhf+zI3KtEK/YSGpRXWY3QrIa53InE4TyB1ou5XaMa
 BBC5A7nUugu8JGdP7WUhqhIdsEsNN8mTnwM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2u2gk2t5r3-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 30 Jul 2019 11:04:56 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 30 Jul 2019 11:04:55 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 11:04:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYKb/hPzfD422JSnW9rEvYbWi9qeVTiMILd2FrsZ4lZuOMvdIJIhN2SWHyFPrrljMuVaVl4RLRLzJceCPhJFC1BfbD2bbXS3pAQuisbC2JQwv7e33//4M1CaccQpj7AJFCq/T4/vuWHqrKVI8lWESh1PNmcbY9g5eb8LtwOrnYdm2GI5gk22gU3NLle7FD9cEmy8wEXWWNRXT1Lfxm3yWUj20br4aBZn4Xwjo04MTlMGjLC7a8ZwnvsfjjsCDU6LQU5m0Jui9Sa5yWojBk0P7qT5xHZqnhFWl2FeCHq81DolOSnDA2xOY3X2rbHVXyeLbpPnctHAdzOBeyYp1T8JfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+Ky9NTjMD8/rdxe8aS3AqheINM0Mxf9g7pfJFTUvd4=;
 b=M7hQh9/nOZ9nTfJB5umtuMHIorjAUjKCYvtxrQNTjWegn5PNhlMijK8G/8ZLp2KilDTTiPwr/WLD7iHoDqFdk6CNqYzDBEcbEuqgbV18CGbdWLvQ1LnY1Qx5yLS6zUEJfNC1uH/iWMDFPlc0yfOgxbS5IApp1Ygm5QWCBGL5BiM5BbvCKUe2BFtlp4GYazUmtzWjoMcmaOAkA9sIgUeRrIMMfZW2CkKiXpS/Nk+ebXYzJm0On6UKUCjwC7ub47cCGmQvnqa3UFTNlXX3buYIa/pfuxaR7kHFB37dwxUkNsIhiFT+37sewvHN0Cfve0DV57cYEbTYseBj6UK1OsURFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+Ky9NTjMD8/rdxe8aS3AqheINM0Mxf9g7pfJFTUvd4=;
 b=YAQPOlwzlIfUkGxvDbsrJ1hwex6KhcAmXD5Z2ijeUYXz+p0bANfLVIeM7iN6d/GHARKGW3DCuU4Q4gm38VslTkHJMNqdGB2jvi4JgYwE1CEhmFPZFfkDx2X1SW1sQCikBLWzJyOGhs5ytwX3qcEyYOgZEGwF/91I/V3fYnTjUGU=
Received: from BYAPR15MB3128.namprd15.prod.outlook.com (20.178.239.159) by
 BYAPR15MB2949.namprd15.prod.outlook.com (20.178.237.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Tue, 30 Jul 2019 18:04:54 +0000
Received: from BYAPR15MB3128.namprd15.prod.outlook.com
 ([fe80::99e:cade:56c3:74a3]) by BYAPR15MB3128.namprd15.prod.outlook.com
 ([fe80::99e:cade:56c3:74a3%4]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 18:04:54 +0000
From:   Takshak Chahande <ctakshak@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        Kernel Team <Kernel-team@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH bpf-next] tools: bpftool: add support for reporting the
 effective cgroup progs
Thread-Topic: [PATCH bpf-next] tools: bpftool: add support for reporting the
 effective cgroup progs
Thread-Index: AQHVRlWnbSsDrGF4hUW1Nvmn7/fJ/abjdduA
Date:   Tue, 30 Jul 2019 18:04:53 +0000
Message-ID: <20190730180443.GA48276@ctakshak-mbp.dhcp.thefacebook.com>
References: <20190729213538.8960-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190729213538.8960-1-jakub.kicinski@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0022.namprd22.prod.outlook.com
 (2603:10b6:301:28::35) To BYAPR15MB3128.namprd15.prod.outlook.com
 (2603:10b6:a03:b0::31)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:2b97]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bb27e5f-7d53-4220-b2e6-08d715186c45
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2949;
x-ms-traffictypediagnostic: BYAPR15MB2949:
x-microsoft-antispam-prvs: <BYAPR15MB29490DE4B83EFDFDD7E0BD5DBDDC0@BYAPR15MB2949.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(51914003)(476003)(7736002)(2906002)(316002)(5660300002)(6916009)(6116002)(76176011)(6436002)(52116002)(54906003)(9686003)(86362001)(99286004)(386003)(186003)(8936002)(68736007)(6512007)(81156014)(8676002)(102836004)(6506007)(14454004)(478600001)(33656002)(256004)(11346002)(71190400001)(71200400001)(446003)(6246003)(14444005)(25786009)(4326008)(486006)(6486002)(81166006)(305945005)(46003)(5024004)(1076003)(66446008)(66946007)(64756008)(66556008)(66476007)(229853002)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2949;H:BYAPR15MB3128.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eWh0/ujYdS05mWopvlVbj5HMvRgS/hhjogjkg212xOQErQ7OsF2uxrW4GpcDwT6QwOGxvvAsGvB3GaPQdZpLEaOiTiwT85ExaPD/97QZGH0EFj+y/voLP+1ojnXKR1Ij1GycELQunIji3Bj8vZDTCVptSxhdRU3XXGvTCUoYSVH3RZVdIFvoalF2hR3MMixn0D7Hp4AdntEzgxhn47a/02o5+sR1KfvoHCZv8dGlh5YwuTZ2Ekm4Jh80tXZ7pj0xNE1hTrJ8UYVY9oOCciwpzXivZsy48+GqLeLIKHSwYJ2qRDRhB5mmWYNQ281DnEWv9tnAizTOqHKYZ5ZXJptyZqgyssek/KAik6GqAM4K2oGI/BnO3lvEwpVTt95N+VBJ96MBLltTwfouI9UJSYydik9cE5+xZOjCwyHV+saTndg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6E46276F5F026B46840A432DEEB10E11@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bb27e5f-7d53-4220-b2e6-08d715186c45
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 18:04:53.9508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ctakshak@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2949
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=942 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <jakub.kicinski@netronome.com> wrote on Mon [2019-Jul-29 14:=
35:38 -0700]:
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
> Signed-off-by: Takshak Chahande <ctakshak@fb.com>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
> ---
>  .../bpftool/Documentation/bpftool-cgroup.rst  | 16 +++--
>  tools/bpf/bpftool/bash-completion/bpftool     | 15 +++--
>  tools/bpf/bpftool/cgroup.c                    | 65 ++++++++++++-------
>  3 files changed, 63 insertions(+), 33 deletions(-)
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
> index f3c05b08c68c..339c2c78b8e4 100644
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
> @@ -158,20 +161,30 @@ static int show_attached_bpf_progs(int cgroup_fd, e=
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
> +			query_flags |=3D BPF_F_QUERY_EFFECTIVE;
> +			NEXT_ARG();
> +		} else {
> +			p_err("expected no more arguments, 'effective', got: '%s'?",
> +			      *argv);
> +			return -1;
> +		}
>  	}
This while loop will allow multiple 'effective' keywords in the argument
unnecessarily. IMO, we should strictly restrict only for single
occurance of 'effective' word.

> =20
> -	cgroup_fd =3D open(argv[0], O_RDONLY);
> +	cgroup_fd =3D open(path, O_RDONLY);
>  	if (cgroup_fd < 0) {
> -		p_err("can't open cgroup %s", argv[0]);
> +		p_err("can't open cgroup %s", path);
>  		goto exit;
>  	}
> =20
> @@ -297,23 +310,29 @@ static int do_show_tree(int argc, char **argv)
>  	char *cgroup_root;
>  	int ret;
> =20
> -	switch (argc) {
> -	case 0:
> +	query_flags =3D 0;
> +
> +	if (!argc) {
>  		cgroup_root =3D find_cgroup_root();
>  		if (!cgroup_root) {
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
> +	} else {
> +		cgroup_root =3D GET_ARG();
> +
> +		while (argc) {
> +			if (is_prefix(*argv, "effective")) {
> +				query_flags |=3D BPF_F_QUERY_EFFECTIVE;
> +				NEXT_ARG();

NEXT_ARG() does update argc value; that means after this outer if/else we n=
eed=20
to know how argc has become 0 (through which path) before freeing up `cgrou=
p_root` allocated
memory later at the end of this function.

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
> @@ -459,8 +478,8 @@ static int do_help(int argc, char **argv)
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

Thanks for the patch. Apart from above two issues, patch looks good.
