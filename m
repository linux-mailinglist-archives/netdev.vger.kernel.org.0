Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C362B109583
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 23:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfKYWaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 17:30:13 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34448 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725912AbfKYWaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 17:30:13 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAPM5Usg031256;
        Mon, 25 Nov 2019 14:30:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=i5iB3asyddE72/xdXVpQxbDywzQUDG9FCHgJ9csAO2U=;
 b=f8a1GiZpc05kfeOFwHT+pJMBcJ6kML7lp64NLcIKI8teE9cpKq8ksyi8jQbUc5QTLK3m
 M1zORwpZ3Ci7uewYrLA9c4w0HSZPSGYOa6PSQgxf5wKIivXguqFTxKCSDvxqz59T/EAL
 P34q3vtKbpYzdYrOqkG6L3u7m42Cw+zcsPE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wf3crbp3y-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Nov 2019 14:30:07 -0800
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 25 Nov 2019 14:30:03 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 25 Nov 2019 14:30:02 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 25 Nov 2019 14:30:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImBnSK+JMZT9WxLvy2x4F4CBheRWDRV9fEiW8O/3ZpIIKozrI0micxI3whnuAGAkRgf0itpLZ/PHzEaOmlbtFVG00IHwZTJYxcPgKxzSVN2oMW327melS28nbq7gebcLD/I6CFi3su5i9nbRvtFUOSd7oE1wagieM7fRx6ekNPi39zByj6/49dWykbcd5GPG45XTbpkX5RqknvxfJVjk8HUJp9kwiWWhMFAaS/Bn+15o9TbCy5/28u+/+VKMXhEyTevPURaIgKTbjPPTTTRYiBJlYM12O5Dg8Et2A+qeqjrhFAHlck2OCt0bL+KhYf+alEymZfuKmirhC4ZaKbGJgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5iB3asyddE72/xdXVpQxbDywzQUDG9FCHgJ9csAO2U=;
 b=JtRR6cTI8Bzs+t2OrPt/K0p3kSZbspr/uAmArb5ah2O+guqCv6z+HB680TnaQofYMPOW7cCuE+Nd6v5wuWmBrlwr3FhkXzofvKRh/imERPnAXaAnAFWDHRrLbp1ZqUzq6ZI5Bu/oubtJSxTk75O6zT8VFbYwjzpga7B/FP0Sk65snRexubfWu+JC8qzc1AywKjA4IwaHtlrBkGr1jAe6SQRr447rAML6awlraD9t5QGeEEv0OYL4ksQCZnSDDE8S0OE2k99K4YQnGBBF3a5W+Q57w9/e2huOMbrG3da4NymBi6Ekzlw1z2Fjsuo1XE5WCha1ranCEiS889GwSEaUmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5iB3asyddE72/xdXVpQxbDywzQUDG9FCHgJ9csAO2U=;
 b=TsXlVQ8v/ahFwW4aJtMAb70+h7Ity7MIRolEl11oU+zODzCQYL6ziXpX10q0fJJ/QOf9mFXtQa7sH05rh9LeQg7wdrPaMu9F7zdkOtwnCLWflLoou8umo2hP4y3LRFnXEI13adQUcz9iK8+rpkUfz219FVkeHtFQ/xeB8xlNsBY=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3072.namprd15.prod.outlook.com (20.178.254.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Mon, 25 Nov 2019 22:30:01 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c%7]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 22:30:01 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next 7/8] selftests/bpf: Extend SK_REUSEPORT tests to
 cover SOCKMAP
Thread-Topic: [PATCH bpf-next 7/8] selftests/bpf: Extend SK_REUSEPORT tests to
 cover SOCKMAP
Thread-Index: AQHVoe5MlmxtGrxbYUi0aPcV+GncKqece+AA
Date:   Mon, 25 Nov 2019 22:30:01 +0000
Message-ID: <20191125222958.aaplyw7ebtqs6yyl@kafai-mbp>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-8-jakub@cloudflare.com>
In-Reply-To: <20191123110751.6729-8-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0016.namprd14.prod.outlook.com
 (2603:10b6:301:4b::26) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:c9b2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5895780a-0990-44c8-e3f3-08d771f702ef
x-ms-traffictypediagnostic: MN2PR15MB3072:
x-microsoft-antispam-prvs: <MN2PR15MB3072E14369DF2FC38AAD1BB1D54A0@MN2PR15MB3072.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(346002)(39860400002)(136003)(366004)(376002)(396003)(199004)(189003)(305945005)(25786009)(316002)(7736002)(14454004)(54906003)(6916009)(446003)(478600001)(186003)(8936002)(8676002)(81166006)(2906002)(6116002)(81156014)(66476007)(66556008)(64756008)(66446008)(46003)(33716001)(76176011)(6436002)(11346002)(99286004)(52116002)(6512007)(6486002)(9686003)(71200400001)(71190400001)(6246003)(102836004)(386003)(6506007)(5660300002)(229853002)(4326008)(66946007)(86362001)(1076003)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3072;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 40iCQrrOSB+AaGJcjReswurYLjWJYWZBlGkMJxVpAPPzKuZlQLolBG4XMrq59s3hUrEudiDx4SbGPEw+wYviVSI1RouOiHHZiVhAo1NTCenr6ezIfYZGYxVXKOmV+YArcSEsWgoDG5Hx2LCIQL0eiyKO/KkjrT1m93BMiiEYIqF6gdwjhusMtyNZBrU0kM99Q5nqNP85qRvgf4bszomTptp/XJqtMFQp0+90z62TiBYKeF2XCQKvc9abjQW2oPD+9+9mY8uL0Wgujniwjp1MYRMfS0xbfWRHL4uVDdMJmdN0XjEL5vXIB1WU+fRGBF9QgG8pPFOFu4L3L2RF74unXTvAYPUWkMb31lCEduTSAaPRRWthidaeYWio39X6nldI4Xtt93mgGjnan3cvTLp4XdUZmCsQA7d33/s1C1RwO4h5jl/1qRTE7021BPSdy4PL
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FC017FE0F60005429205217101C3E9CA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5895780a-0990-44c8-e3f3-08d771f702ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 22:30:01.8480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jeYhVNiaQlHjY2TlX4qPniUTRggsc8HoNLPLDqzepkVdjtdn3zcy4wkMn21Jrm9E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3072
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-25_06:2019-11-21,2019-11-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 mlxlogscore=932
 malwarescore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911250176
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 12:07:50PM +0100, Jakub Sitnicki wrote:
> Parametrize the SK_REUSEPORT tests so that the map type for storing socke=
ts
> can be selected at run-time. Also allow choosing which L4 protocols get
> tested.
If new cmdline args are added to select different subtests,
I would prefer to move it to the test_progs framework and reuse the subtest=
s
support in test_progs commit 3a516a0a3a7b ("selftests/bpf: add sub-tests su=
pport for test_progs").
Its default is to run all instead of having a separate bash script to
do that.

>=20
> Run the extended reuseport program test two times, once for
> REUSEPORT_ARRAY, and once for SOCKMAP but just with TCP to cover the newl=
y
> enabled map type.
>=20
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

[ ... ]
> +static const char *family_to_str(int family)
> +{
> +	switch (family) {
> +	case AF_INET:
> +		return "IPv4";
> +	case AF_INET6:
> +		return "IPv6";
> +	default:
> +		return "unknown";
> +	}
> +}
> +
> +static const char *type_to_str(int type)
> +{
> +	switch (type) {
> +	case SOCK_STREAM:
> +		return "TCP";
> +	case SOCK_DGRAM:
> +		return "UDP";
> +	default:
> +		return "unknown";
> +	}
> +}
+1

[ ... ]
> +static void parse_opts(int argc, char **argv)
> +{
> +	unsigned int sock_types =3D 0;
> +	int c;
> +
> +	while ((c =3D getopt(argc, argv, "hm:tu")) !=3D -1) {
> +		switch (c) {
> +		case 'h':
> +			usage();
> +			break;
> +		case 'm':
> +			cfg_map_type =3D parse_map_type(optarg);
> +			break;
> +		case 't':
> +			sock_types |=3D 1 << SOCK_STREAM;
> +			break;
> +		case 'u':
> +			sock_types |=3D 1 << SOCK_DGRAM;
> +			break;
>  		}
>  	}
> +
> +	if (cfg_map_type =3D=3D BPF_MAP_TYPE_UNSPEC)
> +		usage();
> +	if (sock_types !=3D 0)
> +		cfg_sock_types =3D sock_types;
>  }
> =20
> -int main(int argc, const char **argv)
> +int main(int argc, char **argv)
>  {
> +	parse_opts(argc, argv);
>  	create_maps();
>  	prepare_bpf_obj();
>  	saved_tcp_fo =3D read_int_sysctl(TCP_FO_SYSCTL);
> diff --git a/tools/testing/selftests/bpf/test_select_reuseport.sh b/tools=
/testing/selftests/bpf/test_select_reuseport.sh
> new file mode 100755
> index 000000000000..1951b4886021
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_select_reuseport.sh
> @@ -0,0 +1,14 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +set -eu
> +
> +DIR=3D$(dirname $0)
> +
> +echo "Testing reuseport with REUSEPORT_SOCKARRAY..."
> +$DIR/test_select_reuseport -m reuseport_sockarray
> +
> +echo "Testing reuseport with SOCKMAP (TCP only)..."
> +$DIR/test_select_reuseport -m sockmap -t
> +
> +exit 0
> --=20
> 2.20.1
>=20
