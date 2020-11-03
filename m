Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E253E2A3C89
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 07:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgKCGE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 01:04:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6010 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725968AbgKCGE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 01:04:28 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A364EI4031790;
        Mon, 2 Nov 2020 22:04:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=i2IJqNMAV3y8SLNEtzuMIVFcD7//HhlDZLXeISTQu1c=;
 b=BIc1vIYZBiRimeXvXM69pac/1H8VVfTmdu/3BbT2oFQWY3cvbfwuzgT2clGuBDk3Ck1P
 RhyrxmzWMzVolUgCzai82r5ZtVzqrxDbnT+m2EPviobAkG2RbGr11ZQKtOsF1p9aIN+c
 cXEC3B4c+F897FA1l//Xam4Dcn5/g0HxIt0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34hr6p1fmg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 22:04:14 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 22:03:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctjFGK/JmFmUO0ZonXdQ01VNdM4euUVtf6IPSqut4aBIdYy26gVWsNLaSauF7nY66lMtIYuGMUq49addS3AMeXolgDN1hD673UyiOo9eM3CA12BKVBfg4VD1NRPsPd2K4DktQ6g79zx3awIYFgFyX5yWU+NDKjWcL0jQVWJ2icyLCfySCRLZUTozQ2oLJv6sYIJkVrzNW2G6SSpDSXHgrVAf3IAfhB/rImMeclkOC2vNRtczN+tTzNb7EzGMmUR1q3PqIYyGzWqxElwPYb8YqcvoNSyN9Ns07O4j77HBn0ySlT9koymK7v/fZtgDyBsD9RM1HiL/6iQWXx5NhyeGZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2IJqNMAV3y8SLNEtzuMIVFcD7//HhlDZLXeISTQu1c=;
 b=SF3YdasGuAmDgAuvnDjmJdwRqqy6gkJkud7oBht+HndYY8GsclzKWNdWrT3iYU5nTiYffAttrwMaUShcnBjaa7yr9jmPqAz/46t6sYaacKBErtxaP1pRakopAz2EaRrQ9W+tchw5SDajssmt7D2eaMBv2GreqQzDQqZHn0Bjb/eaP0Di8YPrfeRCbD8TDMkpmLqnSFdvuAVIyQFsRGyYGiP2lyeYTy80NBwln9l7xeXblUFHUJFPxlJtkJo11glZFqwdr7CWTw/Ehn6MRCctOa+HS5jlCul4QAyLiy/cZhCWH6SG3REZEKG/E2HoS0aOVAAYHr1uF0XyFrH0iSw8jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2IJqNMAV3y8SLNEtzuMIVFcD7//HhlDZLXeISTQu1c=;
 b=FJPsrWQ0E3B8Ljsk6Q/hDnKzVxwCWMvG/Tkf4mmbdaFEX2zMr4kuwR9+lPXSakqAYs3xbQlWD5cQ17QeISdevWMb/jiA79gx7H29z5ijjJv80zhq+RbXPYZXXDfm/hDDmo7XGP64d2087Z3S29wB5EAWknEgmMXQRJH0LnVCMcQ=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 06:03:44 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 06:03:44 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/11] tools/bpftool: add bpftool support for
 split BTF
Thread-Topic: [PATCH bpf-next 11/11] tools/bpftool: add bpftool support for
 split BTF
Thread-Index: AQHWrY7fk0j3grsiq0upz8EX0y6TV6m18wyA
Date:   Tue, 3 Nov 2020 06:03:44 +0000
Message-ID: <42EC1BE8-70F3-4B97-91CC-D2ED2AF310C3@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-12-andrii@kernel.org>
In-Reply-To: <20201029005902.1706310-12-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 160adc8c-546b-447c-d4b0-08d87fbe389b
x-ms-traffictypediagnostic: BYAPR15MB2999:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2999EE03508CF3F6C0A8B54CB3110@BYAPR15MB2999.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:172;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0QYbxhUBFp9b/AuwhQV6vUsafWuSOL/n0BZnCkfxb5kngW/ZwAVKRpSyU4znK5jtl47UjIZGmcJZ3KcZhsX7hdADouVY0ono3eCcquYo6L60hIOf5JmQYDYE9A/z/hR1qZ+hnSua5GvaE8cBa11KloOKWVLwdcNESsTSwgANznm/0dZKeq2tgQYfpBgB8cYKU2Ocs9R0E/wWcM2CtVs4JzKpW/HaRovtkSoMfS1T72LWhN8UOCVngJGbHjZ6oRYOXZ4QYHWkTWVz/KNTyFZaSRtxRsIXau/KsGe+ZmDCtezjuQucmEY+JvD18QZqa4hHpA63YuB/7LNh/VIL7ZeU1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(366004)(346002)(136003)(86362001)(2616005)(83380400001)(6512007)(36756003)(33656002)(6506007)(71200400001)(316002)(53546011)(2906002)(478600001)(186003)(6486002)(5660300002)(66946007)(8676002)(66446008)(54906003)(66476007)(76116006)(6916009)(64756008)(66556008)(8936002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xe413ihFbkb9mBGXugNA7RnGYfKvJ2ZoqchXRxW7O0nunpgdIZ0K/lp8YkZ/DKo2ZjCdxqPBzwXEuTx2Za5+s8MRXdVSoour0e622+QUBBapm5lFJ7TATo8zx85qkF5i5cjPmB/rim3RGvJrWht+2wIrpskt29av13EYPRnUmRQRjZcT8cEnSDGtPekPsseB0WBBL001+HqUWHGqCFdL0Ahg8JKLy0h/OHrRP7gAHvm1jrq19gKiDqZCmGGYZbLhAqUqJWVTAWSrM9/foSrEJY4Z1Mv8WTS0H8qN90NPNLfXoqMtE4ErbDwEcILlf5+vUSVeJpzx6T9lsT8BJlNvsw+AiKX9SLB1JZcG07oBjK3cxHQpWou+BnJ6j5G4QUPSBd3fge8WzINVW7T2234mFSkakPy+7ZMUcS7O93ALaKqlbi3fI1v6zcvjO+wZZce9EXL4Dl7EcuMaEu52EMRd45hQCPVzjld6NQmpk3ylOO9Cd6g28SEjotMvbzzOgJlQeUEbzb/cMlJqXJz9hdV1twqVXO4APBlkj6vGzZVzEDMnErAZm15FpOr2S6imFckR8u2h+eXcw+iBoWyfFYzTzCQI/PzKG817Ludkb9B1gpLgMrN340z7AMZne+2ibHQrc6BUz84fGUm7UDJ3hs8SR4rLLh32lgPph2/8X47BkTBPgzqqIZfdh2Z/oorWSO/L
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1441E7B843D5C34FB71CC1B0B41DD8C6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 160adc8c-546b-447c-d4b0-08d87fbe389b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 06:03:44.1846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qne9+aWdMBM0V+tVXkA2T4WsOOw47wF8nfWV7KAM5BcQAUldl4D3rbuKsOrG84CXEfmEbZ8kUBLAt45/xTPweg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2999
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_02:2020-11-02,2020-11-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030045
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 28, 2020, at 5:59 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> Add ability to work with split BTF by providing extra -B flag, which allo=
ws to
> specify the path to the base BTF file.
>=20
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> tools/bpf/bpftool/btf.c  |  9 ++++++---
> tools/bpf/bpftool/main.c | 15 ++++++++++++++-
> tools/bpf/bpftool/main.h |  1 +
> 3 files changed, 21 insertions(+), 4 deletions(-)
>=20
> diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> index 8ab142ff5eac..c96b56e8e3a4 100644
> --- a/tools/bpf/bpftool/btf.c
> +++ b/tools/bpf/bpftool/btf.c
> @@ -358,8 +358,12 @@ static int dump_btf_raw(const struct btf *btf,
> 		}
> 	} else {
> 		int cnt =3D btf__get_nr_types(btf);
> +		int start_id =3D 1;
>=20
> -		for (i =3D 1; i <=3D cnt; i++) {
> +		if (base_btf)
> +			start_id =3D btf__get_nr_types(base_btf) + 1;
> +
> +		for (i =3D start_id; i <=3D cnt; i++) {
> 			t =3D btf__type_by_id(btf, i);
> 			dump_btf_type(btf, i, t);
> 		}
> @@ -438,7 +442,6 @@ static int do_dump(int argc, char **argv)
> 		return -1;
> 	}
> 	src =3D GET_ARG();
> -
> 	if (is_prefix(src, "map")) {
> 		struct bpf_map_info info =3D {};
> 		__u32 len =3D sizeof(info);
> @@ -499,7 +502,7 @@ static int do_dump(int argc, char **argv)
> 		}
> 		NEXT_ARG();
> 	} else if (is_prefix(src, "file")) {
> -		btf =3D btf__parse(*argv, NULL);
> +		btf =3D btf__parse_split(*argv, base_btf);
> 		if (IS_ERR(btf)) {
> 			err =3D -PTR_ERR(btf);
> 			btf =3D NULL;
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 682daaa49e6a..b86f450e6fce 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -11,6 +11,7 @@
>=20
> #include <bpf/bpf.h>
> #include <bpf/libbpf.h>
> +#include <bpf/btf.h>
>=20
> #include "main.h"
>=20
> @@ -28,6 +29,7 @@ bool show_pinned;
> bool block_mount;
> bool verifier_logs;
> bool relaxed_maps;
> +struct btf *base_btf;
> struct pinned_obj_table prog_table;
> struct pinned_obj_table map_table;
> struct pinned_obj_table link_table;
> @@ -391,6 +393,7 @@ int main(int argc, char **argv)
> 		{ "mapcompat",	no_argument,	NULL,	'm' },
> 		{ "nomount",	no_argument,	NULL,	'n' },
> 		{ "debug",	no_argument,	NULL,	'd' },
> +		{ "base-btf",	required_argument, NULL, 'B' },
> 		{ 0 }
> 	};
> 	int opt, ret;
> @@ -407,7 +410,7 @@ int main(int argc, char **argv)
> 	hash_init(link_table.table);
>=20
> 	opterr =3D 0;
> -	while ((opt =3D getopt_long(argc, argv, "Vhpjfmnd",
> +	while ((opt =3D getopt_long(argc, argv, "VhpjfmndB:",
> 				  options, NULL)) >=3D 0) {
> 		switch (opt) {
> 		case 'V':
> @@ -441,6 +444,15 @@ int main(int argc, char **argv)
> 			libbpf_set_print(print_all_levels);
> 			verifier_logs =3D true;
> 			break;
> +		case 'B':
> +			base_btf =3D btf__parse(optarg, NULL);
> +			if (libbpf_get_error(base_btf)) {
> +				p_err("failed to parse base BTF at '%s': %ld\n",
> +				      optarg, libbpf_get_error(base_btf));
> +				base_btf =3D NULL;
> +				return -1;
> +			}
> +			break;
> 		default:
> 			p_err("unrecognized option '%s'", argv[optind - 1]);
> 			if (json_output)
> @@ -465,6 +477,7 @@ int main(int argc, char **argv)
> 		delete_pinned_obj_table(&map_table);
> 		delete_pinned_obj_table(&link_table);
> 	}
> +	btf__free(base_btf);
>=20
> 	return ret;
> }
> diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
> index c46e52137b87..76e91641262b 100644
> --- a/tools/bpf/bpftool/main.h
> +++ b/tools/bpf/bpftool/main.h
> @@ -90,6 +90,7 @@ extern bool show_pids;
> extern bool block_mount;
> extern bool verifier_logs;
> extern bool relaxed_maps;
> +extern struct btf *base_btf;
> extern struct pinned_obj_table prog_table;
> extern struct pinned_obj_table map_table;
> extern struct pinned_obj_table link_table;
> --=20
> 2.24.1
>=20

