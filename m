Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BE83100E0
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 00:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhBDXny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 18:43:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18536 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231184AbhBDXnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 18:43:50 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 114NeMJn020647;
        Thu, 4 Feb 2021 15:42:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9tlpvXoilb4N79Q4JwgF+NYOmUuQ+acQ6nyoqAXRoBM=;
 b=CalXsSVauJuaRGDrK61ZE9dXA2XH4IaBHMAUHQJUl7Z55NXWrtnMl1/jvpXq0WiKYIYs
 H8fHZV6bKUyKfjlTjPLF2Sxco9FJBnpoiZCUB6P576LA6EASiOBL8y98bHYRa0JBrXx0
 2/PV8Qd4HquZsR1N8V95uJdSNwwSx08bPHQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36gfa1m2ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Feb 2021 15:42:09 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 4 Feb 2021 15:42:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AnmAed0mcd0zWh8QdTw3eY8JPikWMo5uj7EREi5eKUY6JRZjDqx3m5niV3h1h+vUTlUvhuwwx7lN0Pg1OKyDiNM7LrNawx1adpxCKW0OKRxwjuJkLlF4JFtN+kTmO+PBtBx9cKEA2IsY5nlYRFh6ebKGTFSyf6kpQ4KdI5jTxX+GiLZpjdR/j1TtvZBAS4KXW3ci2e4dCsC0yA9qVSyHsqirWfdAt1XvS5gTqza4i8JzXQFbJv7C47EcO549XbnNdoFK/3jT8A1b7rpT/ZKjbCdCLaPMtxvNsiOqFZaePMBIs2lnB/oOkOtjqnIJ0C1xrLrO386NYVR6ieT74wEM9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tlpvXoilb4N79Q4JwgF+NYOmUuQ+acQ6nyoqAXRoBM=;
 b=klWYmo+TToV1qiJy7kAPSYHdbBWduCiDQxCHIEqGJ/lWqmdWhU7dy0Orjrv9bUnblsbm4DNAVfI4fFr+nxUMQMACq1kzE/aR7s1pxNsoTz9omXQ+ImYtSfJDC3dlPa3Wf85hUle7Qf0cEdcxuz7JviXkU5N2QYJvSQlXRcZzTipC7nBYru8g4Wcf6LMLXpH+f2YWKOFx7Zj0XgVXlFO3zG0K4x+vD8nBEm7JRigcqv3XqB3zloa6x74dBptOhfS/wuGEYBgCQWKKEcpZqJHbnCUy39/oM2oa+0h0rmgH/iTXtGhxWgqz4SpMFnn/NiS4c+qAzSsFHXrQ2WGMTTBWaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tlpvXoilb4N79Q4JwgF+NYOmUuQ+acQ6nyoqAXRoBM=;
 b=Ic0yZDZUZ0LhfHW7aBwldLJbii71QzJsYCpWzxpvOmI9ZMsLaly4A13lkgqsyNHTGQKtd3Cgq9lGM0aKsVhHyn5BMMgWQ7HKi+qfrytmaeUBoTsKqXaNmYcyCwUlF7QjBxq9oSwpv9Yv9hoUNtSzsrxmC5lKQvsFZYL3h31iWho=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB4086.namprd15.prod.outlook.com (2603:10b6:a02:ca::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.20; Thu, 4 Feb
 2021 23:42:06 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.019; Thu, 4 Feb 2021
 23:42:06 +0000
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
Subject: Re: [PATCH bpf-next 4/4] kbuild: Add resolve_btfids clean to root
 clean target
Thread-Topic: [PATCH bpf-next 4/4] kbuild: Add resolve_btfids clean to root
 clean target
Thread-Index: AQHW+ztzucvu+jvqx0uJK7//vWiA+apIqDiA
Date:   Thu, 4 Feb 2021 23:42:06 +0000
Message-ID: <68566AA9-C290-4638-B838-EA80BDCFF1C9@fb.com>
References: <20210129134855.195810-1-jolsa@redhat.com>
 <20210204211825.588160-1-jolsa@kernel.org>
 <20210204211825.588160-5-jolsa@kernel.org>
In-Reply-To: <20210204211825.588160-5-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:aa49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0cd62cf2-bc90-46cd-c4a0-08d8c9667b5e
x-ms-traffictypediagnostic: BYAPR15MB4086:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB40865AD727C0683721167289B3B39@BYAPR15MB4086.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Iib3ZfZUyjChdAmwP/VcxQ8TRFsJY7/Et4/kU+RBRFbCeqRnWRCNNmS3xthqkMPonMEh7RgWaNXBUK+vwZveytq0dMybxlle1wDXgSlKhdsuo99FEUAL6N9iybAxtHOSWOYTYBn2wHRxUaRjkru7hXUiCMn8X2HAvuIkxAm5xOlAeQxJT8PSN/HXAuI5MJdQDgmjmia5Eoqxfku7u6/UgwnMgoDC9jIphje9frq0qcSafHYF0ZdP2SI8ydA2abNSkvi2m2b0fHFRsAXwzHZ/fbuuzn8qcUOuNvNszm4YKdEVyogJcGI9knd52Ar4aQGu8Sdix9us9DTPNSv2dguedF7Tu7Om3B0HLFikKe90yr/3A7vOU6rAUMSy2Ry9lwlZEis9PfLlpNyJ7bD68XbOkrJS3jRqz+Ilf1Ly+1SlDPB63oj3L0OFi+gSL57kQYrasblfntLcfPQAF1ShEKXw/SEIYrUsjjdSzwo2hPpHy0txal5FbXDg6eVxVZp58fvLs+WaRlLl3qk0f4G5f8QNICjRDf6LCBsB3nvrc51OlaAO+zB7krhrBhorkXUYkfTF6ECxQcAImirFN4le9waOyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(396003)(136003)(346002)(53546011)(54906003)(66946007)(66446008)(6486002)(2906002)(4326008)(71200400001)(66476007)(64756008)(6916009)(36756003)(316002)(5660300002)(478600001)(83380400001)(6506007)(7416002)(8676002)(76116006)(91956017)(186003)(33656002)(2616005)(8936002)(86362001)(6512007)(66556008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vFV+LBHwKoIZHX2EF5202sgsLwHp/TaAbn4yarJ4LBLeWP//mHh43aTUwjFE?=
 =?us-ascii?Q?1PSwkOw3zLaf+77aoPoB/M0hnyIk2hY7kl4He1hTaDFkWya22BsPF/X0szIQ?=
 =?us-ascii?Q?EUfLXwltI/CY+VXx1Yf41iulEIzBpzY72PU87mkYrd5CKD+skOW3SnpKNSds?=
 =?us-ascii?Q?Rdmr0tphu+ag6oyG+a/2+MMWA3Ar7N7ugPh7ViVhvEcYEzmTtLtC3RFMIVf8?=
 =?us-ascii?Q?PVNarRwlCFPnqPl9h6v5Q95xFmdD57FJuPG75Gow9Px0E3z8NMhDxwzwRzGS?=
 =?us-ascii?Q?NHRWNMzXKzJ/CfNLvdWr0WPj2owaxuHth6ojKEOVP1VHWLWWwHIIbw1L5/eO?=
 =?us-ascii?Q?23dpztSYUyCwoBJUPS+pUJBp9noFbgv81m49pcfEL/v281S6wgeVikksTc29?=
 =?us-ascii?Q?9diyd8nLeQBzuTrFNxiKrSOOFrAGNNPsXae093S8G6HfaEkUReZkBKjcssJp?=
 =?us-ascii?Q?2dOfEH8XEDapA+LahLRpAxKagXvq4/RoWhPwcyicoljC9dvvOLm033yh+evR?=
 =?us-ascii?Q?ntyeoK37v6VEtAkYPqQEhUS0GwIf6ubGgYjwlwBYEjNqaa6j5epW2fRtRbav?=
 =?us-ascii?Q?hTAYU+iEIii2ovEZFk/08rUnAq9DhaUZ0xCc3ZBI3mVvufp44ufLrcRWT6EI?=
 =?us-ascii?Q?gky5VeRSgCikMKtZr2wP28IRwr91GNL7ITBPOug1K+rTey64m9JdqAnb20vu?=
 =?us-ascii?Q?3CeQ1eJOx2/196VVHyIH2mXO7dYgZ81NRfO6gQqHM33LCbq0k2Qq2IlYtsiN?=
 =?us-ascii?Q?omyPm6NUfbkuV6a4B0x+9cvt9r/4FykFt+wnhnfYqHydnDZ32TPVXbkhHBlU?=
 =?us-ascii?Q?ckuoVQwGrto9IiBQYeRpUagvexU0ur3IZx4Am+gz9d55nLNkou8mGhLI2ErM?=
 =?us-ascii?Q?wLgzuoHUVK08Lmea0cup63bQjBxJVGwxXcP9jR9HEDerG3LW4w1nblnlLpQM?=
 =?us-ascii?Q?jF9/3KNdf3awNrtQrYQTLzR3w3BSjG9sxCM6cDtMQ67hpmwzi4Zkb5ddGa6a?=
 =?us-ascii?Q?uV26VebbUX3LqsQ+bSJR+S/6Byr3KTk8maPeX5Kmgzj9oanjfjN2VFN7q8A0?=
 =?us-ascii?Q?sJh6D9yq+pqnFBDvgs620KJ0kyZ1rwChgl7/mPAfCqSZfuOA9WnDaJdlEwbV?=
 =?us-ascii?Q?T8ecRnyq2cZ8qCT6aea2agzNaaxI/x8Cb5ODRLcSW+Ka2yAYRAH1ax2EO2qd?=
 =?us-ascii?Q?rumRRaYI8Et7fLI70bMtN2CHCfMLqbslfWGmVSsiy8qQHB5PzCoaPHaM/utZ?=
 =?us-ascii?Q?t2sc+ySyPU/GXvAeXE9kkLilyqo5reBR2bcHeIXns6Dm/qHPiyOFqmdBkFaJ?=
 =?us-ascii?Q?lBvqQKM4WWFlCYCh5rdHTFIpvXXjAw6WIlBI6h1qfJ+tHuO6SwOPAFcld0rn?=
 =?us-ascii?Q?SLcnats=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <99F1F92AD87DFF499FF7DD3BEF29788E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cd62cf2-bc90-46cd-c4a0-08d8c9667b5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 23:42:06.5361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dJ1mAuzJVww9al1ueSuYNHBh/YGF5jLOYV7+/60J/Os7H1IOpFZy/DPbFzxzTZBcvIe6Z2+oARp2+KxYdUZyxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4086
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_13:2021-02-04,2021-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040144
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 4, 2021, at 1:18 PM, Jiri Olsa <jolsa@kernel.org> wrote:
>=20
> The resolve_btfids tool is used during the kernel build,
> so we should clean it on kernel's make clean.
>=20
> Invoking the the resolve_btfids clean as part of root
> 'make clean'.
>=20
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> Makefile | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/Makefile b/Makefile
> index b0e4767735dc..159d9592b587 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1086,6 +1086,11 @@ ifdef CONFIG_STACK_VALIDATION
>   endif
> endif
>=20
> +PHONY +=3D resolve_btfids_clean
> +
> +resolve_btfids_clean:
> +	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=3D$(abspath $(obj=
tree))/tools/bpf/resolve_btfids clean
> +
> ifdef CONFIG_BPF
> ifdef CONFIG_DEBUG_INFO_BTF
>   ifeq ($(has_libelf),1)
> @@ -1495,7 +1500,7 @@ vmlinuxclean:
> 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
> 	$(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
>=20
> -clean: archclean vmlinuxclean
> +clean: archclean vmlinuxclean resolve_btfids_clean
>=20
> # mrproper - Delete all generated files, including .config
> #
> --=20
> 2.26.2
>=20

