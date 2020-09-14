Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A05269836
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgINVqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:46:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26114 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726059AbgINVq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:46:29 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08ELipXg031386;
        Mon, 14 Sep 2020 14:46:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7dnzZ7wuveHr9P271oBkkZLzZ97Tizbeh9ckf8tkhi8=;
 b=igkz1hdJj6BeDaz4hua8LOrDqqq11d26irWS4ZjiIYlX3dSdqeQVHmGUIsb2ypfujSQS
 FR0ZFpcCrruSniA4A2kU7LyG7MUe+o/NrV8n5kerlO4XrTH16HqXdT4sI1CfSXAOPO1E
 I2eOARwkL+DhqfGfnc/o0Yjg2tnJmmApNe8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33j50dvtmm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Sep 2020 14:46:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 14:46:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAwtSuPva0+S/btvUpxRKEY05bCI9Kx3zUuXSQv6NYd/57bMGu/65eptaWmc31KCqRu/JC7R2D6qp8e2dtckUw7BsdvIdUs+BVm4vzl+IGuCitj5nZnlrMCH9GlXHmtLlzsEC50/8fkhkWVj6NBknE9sVXQLJF7m1FeGJbu+7T1ZfLTWPK7d2KBvoULZWf2VTe0dFg9+eYmD/EuEz2JnTASHW1tSWDR2IrSjz8/xMkTGk3IBi1BkGF+a/zfVDTiSOspBdbx+dRtFlzSI6mo+vD+lyzLfd7NP1HldS22EipYMkQDyxwU0H5TcvuSc3qa0ssvntVxkTp1VIz0iASfIeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dnzZ7wuveHr9P271oBkkZLzZ97Tizbeh9ckf8tkhi8=;
 b=SxFpIfdbOzd2FzIFwWAYslUNLQQyuNieEUmM+1/2gzXkIZ/BHtkW3Gk2j/cxdAj7rBIbQP6wlJNHEfWxYwQ6BFpomOoUNMWfEYuew2nWfabzyBisEHnzAYm5Bd0WFmkJ5+tA9QDPquEI1d/C/zRcPoVJYwYLW3wdbTFzE9Zvg7l1i3nsc409lY4sKUQF5Nqg5Rtj/dMZ5IxvuJiI4jw2geJA1a0pHlUc05Cz1+QBAms+xdWYvzdUUV5N03kZD5CPRBQKz2yCK63wK+XUZGre5ssgo/VKP9JC5RL92Sl8YHMso1YT9EZdwxFxv/8wicm8Hdprd65wvY5Va2mq1hdbWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dnzZ7wuveHr9P271oBkkZLzZ97Tizbeh9ckf8tkhi8=;
 b=hZhILga6A6ME9iuQ+r7vQedxga+Pk1mo7q/Y0PFZ6oyOPG9CYi+akpjLm1do37uJX2YJUxEhLWgFbAbNoVqWaZsHvm+NdoKrn5tTPrG0Rjsef/7Vg5i9R0ayMDSQP4wo6hG71r23hWsBuND8chk82FfB8POu43aMdTtV8FO9qYw=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3509.namprd15.prod.outlook.com (2603:10b6:a03:108::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Mon, 14 Sep
 2020 21:46:11 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 21:46:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v3] bpftool: fix build failure
Thread-Topic: [PATCH bpf-next v3] bpftool: fix build failure
Thread-Index: AQHWisU/SdS6TAnPtky2D6LqvwFJ1aloq2AA
Date:   Mon, 14 Sep 2020 21:46:11 +0000
Message-ID: <85A0240D-076D-4686-8A4A-A636AC268557@fb.com>
References: <20200914183110.999906-1-yhs@fb.com>
In-Reply-To: <20200914183110.999906-1-yhs@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
x-originating-ip: [2620:10d:c090:400::5:f20e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2999c333-7f41-454c-eeca-08d858f798f0
x-ms-traffictypediagnostic: BYAPR15MB3509:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB35094A9F0D7DCD6C05627CF0B3230@BYAPR15MB3509.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TFUduz1Tn/QTftd60AkOD70KFvqgC3CmqU6iKUelcvZi/63RF0of8m/JDoptnDCHPWoL7sCabZFqjhsUr2BBPAznbQe7IuaulLmfm1Js+TlnIJORbMepk9eeEJ8sJLMnBD1VrVrwbddD4uN6xRPOoG2q83xfoBTkMv/Vp5QeAUiRwgJDND962+VHbhyz9FCjitvar13JU74IYn5Mkv8Bs7wXnUd6fDzwXqAAHoowjPji8cKr7fDC3CjWhgEN/ZPxCaUAM4Q6/wxcdptqZRD+tiE212Jr0klKsPHIodXjr4vbW/aoUBLcgxTbKmVSh41EjC82iGnDfBoAiGA1IZPTsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(366004)(39860400002)(136003)(2616005)(478600001)(6486002)(86362001)(37006003)(71200400001)(4326008)(316002)(36756003)(6636002)(53546011)(6512007)(83380400001)(186003)(8676002)(91956017)(33656002)(6506007)(6862004)(54906003)(2906002)(76116006)(66476007)(64756008)(66556008)(66946007)(66446008)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: akfrhyxv2LTWn4mfnDPjrjWlyScH3VylOWmcXMKkPevpqOcLje1vv9ocQ0CnsL+BBWrw7GxmgJw2jMiyrXVN5/NH0qwYE3BoHEPI1Jqu74VdAT23oDtdgK4cV/7UHGFY8RPDWsr0fyKi9G/JgVvU9L60Bk3Zt726FrnT2vE+EvS2Q6CyoSnr+5FwQHZ/eMse6P5uFyIzsx417UvFXuId9WV1g760qW24VMEa6+ClAlZcPVQN6CRvJLOc9yqcbbZftIfkQX+z83M7Ihr9/BKE8yrN6JZ5CsvEXQ2WpcPfJ61cps8PmX+cbnnvfVItn+GPEtBaq8Ku/GbfsgxKCXs5O6R0idlgi7MuojfxH1MIAd7w4oo7sOdAJhBeFpP28vlCn89vDo+VN4RCnsF0zBoXyLyVLQrC62BPHhPiMG/c7xM99PYKLgOTBXBZ/ZBSdgggOM2HXmcwKNySZBntsxGolLbfBQXLy0oS0VsKQi5f/JsUjZZffjeWC3pkV9LGp10ERcc1zqhvFJGh4L2P93/9V88Z6xnORePgG9mRoQJUM9o6IsJ+8QQysXjSqJaQv67fExGtWlyvf2MTB2OPGkJmynp5NZKk1m9DZWVywD+Zt7QVp1HEBwaPhr0rRtcb71Xgwo/oeTFn3DB22vqBsa0iJfNfNx05wCVJ3IuFdnHk0aVAxgz8R+3a5fwnUh7uGejx
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3EDD5F9EFF71F94FBB1AC564CE0FDCE0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2999c333-7f41-454c-eeca-08d858f798f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 21:46:11.7289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PhITukOW/hlvOn5e8UTT+6WjmRpPNtXuwZnamopx448xxvCTMv17jMBKXRwoL82g8R8N0jPTGRt7lRh8BpYVUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3509
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_09:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1011 priorityscore=1501 mlxscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140167
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 14, 2020, at 11:31 AM, Yonghong Song <yhs@fb.com> wrote:
>=20
> When building bpf selftests like
>  make -C tools/testing/selftests/bpf -j20
> I hit the following errors:
>  ...
>  GEN      /net-next/tools/testing/selftests/bpf/tools/build/bpftool/Docum=
entation/bpftool-gen.8
>  <stdin>:75: (WARNING/2) Block quote ends without a blank line; unexpecte=
d unindent.
>  <stdin>:71: (WARNING/2) Literal block ends without a blank line; unexpec=
ted unindent.
>  <stdin>:85: (WARNING/2) Literal block ends without a blank line; unexpec=
ted unindent.
>  <stdin>:57: (WARNING/2) Block quote ends without a blank line; unexpecte=
d unindent.
>  <stdin>:66: (WARNING/2) Literal block ends without a blank line; unexpec=
ted unindent.
>  <stdin>:109: (WARNING/2) Literal block ends without a blank line; unexpe=
cted unindent.
>  <stdin>:175: (WARNING/2) Literal block ends without a blank line; unexpe=
cted unindent.
>  <stdin>:273: (WARNING/2) Literal block ends without a blank line; unexpe=
cted unindent.
>  make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/=
Documentation/bpftool-perf.8] Error 12
>  make[1]: *** Waiting for unfinished jobs....
>  make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/=
Documentation/bpftool-iter.8] Error 12
>  make[1]: *** [/net-next/tools/testing/selftests/bpf/tools/build/bpftool/=
Documentation/bpftool-struct_ops.8] Error 12
>  ...
>=20
> I am using:
>  -bash-4.4$ rst2man --version
>  rst2man (Docutils 0.11 [repository], Python 2.7.5, on linux2)
>  -bash-4.4$
>=20
> The Makefile generated final .rst file (e.g., bpftool-cgroup.rst) looks l=
ike
>  ...
>      ID       AttachType      AttachFlags     Name
>  \n SEE ALSO\n=3D=3D=3D=3D=3D=3D=3D=3D\n\t**bpf**\ (2),\n\t**bpf-helpers*=
*\
>  (7),\n\t**bpftool**\ (8),\n\t**bpftool-btf**\
>  (8),\n\t**bpftool-feature**\ (8),\n\t**bpftool-gen**\
>  (8),\n\t**bpftool-iter**\ (8),\n\t**bpftool-link**\
>  (8),\n\t**bpftool-map**\ (8),\n\t**bpftool-net**\
>  (8),\n\t**bpftool-perf**\ (8),\n\t**bpftool-prog**\
>  (8),\n\t**bpftool-struct_ops**\ (8)\n
>=20
> The rst2man generated .8 file looks like
> Literal block ends without a blank line; unexpected unindent.
> .sp
> n SEEALSOn=3D=3D=3D=3D=3D=3D=3D=3Dnt**bpf**(2),nt**bpf\-helpers**(7),nt**=
bpftool**(8),nt**bpftool\-btf**(8),nt**
> bpftool\-feature**(8),nt**bpftool\-gen**(8),nt**bpftool\-iter**(8),nt**bp=
ftool\-link**(8),nt**
> bpftool\-map**(8),nt**bpftool\-net**(8),nt**bpftool\-perf**(8),nt**bpftoo=
l\-prog**(8),nt**
> bpftool\-struct_ops**(8)n
>=20
> Looks like that particular version of rst2man prefers to have actual new =
line
> instead of \n.
>=20
> Since `echo -e` may not be available in some environment, let us use `pri=
ntf`.
> Format string "%b" is used for `printf` to ensure all escape characters a=
re
> interpretted properly.
>=20
> Cc: Quentin Monnet <quentin@isovalent.com>
> Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Fixes: 18841da98100 ("tools: bpftool: Automate generation for "SEE ALSO" =
sections in man pages")
> Signed-off-by: Yonghong Song <yhs@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

