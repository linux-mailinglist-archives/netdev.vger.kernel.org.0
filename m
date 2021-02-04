Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A72A3100DC
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 00:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhBDXno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 18:43:44 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33568 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231157AbhBDXnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 18:43:31 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 114NeTpe024807;
        Thu, 4 Feb 2021 15:41:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=PBYX2an5VPJuXTlNkDIetMKouARv3SqpZcmCLRv16YI=;
 b=XXje9jc6Rt23J4kApOFngCnxsFZV2kB3io3u/DZQhmZ9qB5udLW4ZVaRNTuMy5YSbzji
 lM0gifn2f6IfKXDv0uilj5mkwElRDlIQgulaMKJV4mDT2gAbChvYiLLg57q3gfoiulxs
 +vmDOG8iC24iG5qh48ZDHbysuxSOIfYmP+s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 36g18bqxq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Feb 2021 15:41:29 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 4 Feb 2021 15:41:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ef230aF6ba8oWBx8u1b+aRH5nYOfqaGWu+CpcpxN6Zeb0RUa8rUhPnQupnxALboCB7BoK/5FTdbHpiDuj9d2aeEvcTJ3kd5XU403ChhIFip/b7Ym6exoL/oDUyEcp5kundY+wkYsPZqnfoZGrZzoAab0USapPcGgU1ZmWAc4cf1tF03pha54KTCLyDKboj+pooVQ4sK/7s4/YBRYBX0atN5XOk75QJ9Tazl2Z5BwjpCzAzsHNZhZdsnH+3GiKOZ+jgVz53CCTGmwuaQz29ZBgbnO7dqc0Xr80Bgx4SrmKETgqMqCVOG1rC9+CdMDffeIR0iogumYITM/vVXRq0x/Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBYX2an5VPJuXTlNkDIetMKouARv3SqpZcmCLRv16YI=;
 b=J2qdUUDCptJCrZGRTA5hynHpk9VXnFGG/Xzj81wA+JSTmtgVwyTGBMObp2CJstOQCZbPjGt2iFIanqjLt4I27QhMXA5dYT7c5zD9SiIbmqwGhFFPx8vL9lW0mIKcIzx25qsjdp9V0jcRz9+U1VUXjnwyR8U0viQ1NGp1ON3BzTlQAZJXejFNonHx4+B9eR9uMnIzavk2PgfIwsJuaFAuB637QPbbpaffZLUft696xdxrtVHYaUlNIeZd2IbYrruq2ZMZLwksEoMndw4Mmjon11S9ZgGb+2+dFyX2PaDEuucI0AdP0ACW45q4qtRDRFt4qfN+x55Pwi2b1PtTIzFvag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBYX2an5VPJuXTlNkDIetMKouARv3SqpZcmCLRv16YI=;
 b=QqcME0Ks/R4ab8tdatpAc0vHidgoEULtT5a4ZtdHYw0uJfyJIwcEfKqGflzsoz1PWN0Dli/Z88GHaQdS+A3pcHPSPHo7QiViGqEu+c0SAASkD39bEdFoISSDilxRKEDn/v71dla0HuKlegxgOgam6g3hOpiOTKkhWm3KreJVrIo=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2565.namprd15.prod.outlook.com (2603:10b6:a03:14f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 23:41:26 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.019; Thu, 4 Feb 2021
 23:41:26 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/4] tools/resolve_btfids: Set srctree variable
 unconditionally
Thread-Topic: [PATCH bpf-next 3/4] tools/resolve_btfids: Set srctree variable
 unconditionally
Thread-Index: AQHW+ztbAyo95jsUA0qIqulLBpeFPKpIqAmA
Date:   Thu, 4 Feb 2021 23:41:26 +0000
Message-ID: <F9F430CE-4CEB-435C-8488-C5ADB2D06106@fb.com>
References: <20210129134855.195810-1-jolsa@redhat.com>
 <20210204211825.588160-1-jolsa@kernel.org>
 <20210204211825.588160-4-jolsa@kernel.org>
In-Reply-To: <20210204211825.588160-4-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:aa49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0de4f7f2-cc6c-4b3a-390c-08d8c9666382
x-ms-traffictypediagnostic: BYAPR15MB2565:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB25653D09D5346A0A2035ED65B3B39@BYAPR15MB2565.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4jC9CiSro3ySwgEilSuVsCIx5ZZ0H/5S89u6gyudviXJR/aXw2KALFBchRLl/3rLabdyV+9rtx8EOiI4vgcd9PsRZ/lZyr5Ocsmg2OP43j56YOjZtVwcMPTFxxdM83n/XAsKR20oQiPqX5UHKdo3tVZ/EnSKr4+SleiT/rcapnyPR8R3IFGN9/r6NUHOWRR2Rcs8HBDJF2G8KJq+HI3b1/as3T4N8pfUp1AOQGCVxpYzDiyZhUgBIAwcsSE/Xx7VgKKOWDIDby7ms9ypMN8howAn+nXNcEJarapMggsxKQjm/Cgsn+T4fMNLBSXp92l0/wW9f/r28JN1Hn1YPhLV0Gy4tCpuKkHV/2k7hJ3Qw93eZTZCnAgZOFeem24K526p8Qi8L81+RS1fSsBruZtqwXx02khuthFe+x1rI8ZpxFcXqVCDVLKqXeDVHY+KH8oavQiSEdUEXkn30WqjSf/mTle/ZCQLKRFLL7F1FIGbFSNYFJyVvsP3wjjJH2bMmP0cDIR1iIHLMoP1lbEeVUXJtWvW3JwfwOEf5eD7yaFUd9258bXJ3UAj+BG54DfzOJAPP296VaNCcuR/l+CPYLB+xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(53546011)(86362001)(6512007)(7416002)(6506007)(186003)(66946007)(4326008)(2906002)(6486002)(36756003)(6916009)(66556008)(66476007)(64756008)(2616005)(71200400001)(478600001)(66446008)(54906003)(5660300002)(316002)(8676002)(91956017)(8936002)(76116006)(83380400001)(33656002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Gr8B4iChfX9bAGSZ2Rc/TKZRg5f30tqIFhhPM2rDw8+kFQj8Ihf7d/5NUvTK?=
 =?us-ascii?Q?0l2w11QmgDkrOe0hBrWuPSAFkdoDV0z+9u+5+bCB1jW7SJyS5XOLgtKpVhJv?=
 =?us-ascii?Q?62Qy4tsyBXb5jGzM0yQSH2KkHn18Mo/afX4RMJRqkqW82yHAoVuO4kT7KpT6?=
 =?us-ascii?Q?ynCaaQzGkPSi9bCx5nXTBCWFzK5KrUxOl3lspr5PC6xmiebxIrxTAB0mK6lq?=
 =?us-ascii?Q?cW1IzVvDHtt4/oxeavm0Cf9OisRNKNds6zmTjX664bIgDrqVDi55mzshJe2H?=
 =?us-ascii?Q?adjoo0RBTUMUQGc63Y18WkcuuyN6C3AlsKNhwP7Mo+3uxPjqP/eLIehNqq4y?=
 =?us-ascii?Q?NxFHUZtcu6htBMWgCcRZ1hKYL6IK2FoPGzUHsUxET6VaVIHlEWFGhByLS1x6?=
 =?us-ascii?Q?lYHVac1TDd1N+IMF5WkXY7X8jQW6vXJO40ZNPFwqpYVkfTx0jHRgB9cy7M3L?=
 =?us-ascii?Q?s6NnqnmI8jb5iGIUIjG0MPg2CrPPODKdn8bUPcgtGsQ58xmfbtd/BQQl2Cv8?=
 =?us-ascii?Q?q87qcKFYk0HaUp3lIv43bjtI3A1NhmoJNKhC9XGbPJO1yaQ8+Bo2RwZEnKdw?=
 =?us-ascii?Q?7Ju2pU6yNSxJrBVM9NqMiiYuWX+ifQdXGNyYZdzPtvyPp+TJ9jwlrRrc1VHK?=
 =?us-ascii?Q?at/E97X5zhajEhxE71It7lMYlzzHnq+P1Z7DDJ17KNrTGUOeDa2V0J5xWw+7?=
 =?us-ascii?Q?449W78DbTZjS++IBHwuCFporG25S6ewo8nnPnALwxFKIGkenatB4U5PecjUZ?=
 =?us-ascii?Q?bWrpUKSQr3j9gBfJHJDgtX5XqPi029NoxtXHrqPyNHiAwSZy6nu9EnRx+MQp?=
 =?us-ascii?Q?NHMEZkyCDvtoy7cQXjmMgYdjFOmeac+GWBnwxjZjTEtRbQVgj6CYY1+YOR4m?=
 =?us-ascii?Q?XdI6VcQA8/h8JsK6PdYTdzGFUFSTYJZH1ed3jjCF3DPqr17sNlV+b5sngwFs?=
 =?us-ascii?Q?hq/zw1Cl16IuwGlCNnR8DBr2OBIno+Ae8+0i5n0FXTdYBWS3eUIq62QuFhQy?=
 =?us-ascii?Q?LnOWa2CNopY4NcmBxHGsKqAmbPsCDbsTee7+Ljlcxp9Ocv4NuGajbs1WMVCT?=
 =?us-ascii?Q?O/DOhw+8TxP5k+JumrWuhM74QX4sRioup45nui7Adk6Tehelx2R9bi70aJr8?=
 =?us-ascii?Q?YDicmJtvLFoVMvq3Hy0EsyMctfEZD7EOJF+2TaXpFqtBk76hzO53yhHHtXup?=
 =?us-ascii?Q?eJQvPu4cpslPz1cqLGevwEsc2VzJ/51IYzEByTr1dfUBVj6Qb7uS4jplzOJq?=
 =?us-ascii?Q?0q1shjxl8PE7BPuc4GpzRzy2rwkX3732+f/uKEX6+Dp6U/R3IzOJT/fn5R8b?=
 =?us-ascii?Q?kzH25qTcijtH4w8wUEF6PFeIIzRsRblxQPu20J4FTttn1eTbhiyWp7A7CzYk?=
 =?us-ascii?Q?bmvZ4Jc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AF3B18B269241B4686201DF810A7CABD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0de4f7f2-cc6c-4b3a-390c-08d8c9666382
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 23:41:26.5541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7fjETco/lzgBtQ99rjum+9EXOOzXN9cdL575EA3VwN3YK3L7feWzJGYPPaZVDxVPFJD0/R8aP0MHhWH7LHL8Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2565
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_13:2021-02-04,2021-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040144
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 4, 2021, at 1:18 PM, Jiri Olsa <jolsa@kernel.org> wrote:
>=20
> We want this clean to be called from tree's root Makefile,
> which defines same srctree variable and that will screw
> the make setup.
>=20
> We actually do not use srctree being passed from outside,
> so we can solve this by setting current srctree value
> directly.
>=20
> Also root Makefile does not define the implicit RM variable,
> so adding RM initialization.
>=20
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>


> ---
> tools/bpf/resolve_btfids/Makefile | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids=
/Makefile
> index 3007cfabf5e6..b41fc9a81e83 100644
> --- a/tools/bpf/resolve_btfids/Makefile
> +++ b/tools/bpf/resolve_btfids/Makefile
> @@ -2,11 +2,9 @@
> include ../../scripts/Makefile.include
> include ../../scripts/Makefile.arch
>=20
> -ifeq ($(srctree),)
> srctree :=3D $(patsubst %/,%,$(dir $(CURDIR)))
> srctree :=3D $(patsubst %/,%,$(dir $(srctree)))
> srctree :=3D $(patsubst %/,%,$(dir $(srctree)))
> -endif
>=20
> ifeq ($(V),1)
>   Q =3D
> @@ -22,6 +20,7 @@ AR       =3D $(HOSTAR)
> CC       =3D $(HOSTCC)
> LD       =3D $(HOSTLD)
> ARCH     =3D $(HOSTARCH)
> +RM      ?=3D rm
>=20
> OUTPUT ?=3D $(srctree)/tools/bpf/resolve_btfids/
>=20
> --=20
> 2.26.2
>=20

