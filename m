Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9144AA1153
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfH2GFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:05:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46196 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfH2GF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:05:29 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7T64sD0030678;
        Wed, 28 Aug 2019 23:04:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=SLtcQMyiV5xHTgNCS8xtaHfwavOhr1jY5qhRlzTnLMc=;
 b=QOxJrSgZB5EMmBpESaNUYNzBu1t1H3+4y9S10cVMBjqWD/YgqHsDRXC7tTIxfV/gs+zx
 ussAe4d83a30AgNGJpU0ZfGxqf/Z0hR34UojE4d10C8mKUi2rG8rxqxvfnSkS3ECru0O
 +vdR0WvPf4L9GPPGZsPxVtsaKXEt8Sxl4zs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2up8cqr4h8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 28 Aug 2019 23:04:55 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 28 Aug 2019 23:04:43 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 28 Aug 2019 23:04:43 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 28 Aug 2019 23:04:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fV86hvJpAlZJN4aYzaD+Meiaf2P03WEc7HdTku6LoZeaQMOC3nCQt+Gm2EY/b3vUEVQbNiIm8C3WO2ZQ9YrYFXUOfIeRPdkCfs+01McHwz7EwROpCdPp4+Lgph+PlsCT7sVfa7pVzoL67jEOj0Chiq99vp5jrn0zMidcCJBsjZC1+c+AOpPC4UfCmdt93vHlh85y0gEk+d8T7CaGbl29cCT1Fc3WUyCQZ+CzqrkBk3DyKxctSWWkBT45fqWYvOsssV2g0jAhcRPmGcse4rUvi144tsg+7xH86WOue94k6jDlp4HBpDUM6I0/IZdeXEGJFvnoyMJXaj4gcGivQ8NMrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLtcQMyiV5xHTgNCS8xtaHfwavOhr1jY5qhRlzTnLMc=;
 b=FF2jaV4OSv+QurKkBkyKPG/KtFwwnOfAwJFRTZymX2zipUgoRzz2WEVTMk4LEJVmpW8BzPRmHMtHjnG1kDg3XrmtNeyYbtSASSC3DUl2XqPiXud6gPmkxOhjXFkxDpv88IuCEutkn23f+fnu0C0g9f//ViiGxRC3WyIgEeF6jDD0rS391pJ/q9N7BHpOedK6sUK054GJ+56OY54EoJs4kj80HgmpY+wXespNBZaMDJ9Bmtb9lhgHDDBEPkvzvN3Loc9kf2RFuGCRRub8KNIdDwtyxeU/QpJCT8gsCMDdISAk/qP2ztAuRMnwNekotbFR2Ysvwh+sPaXSndVwOwQ6Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLtcQMyiV5xHTgNCS8xtaHfwavOhr1jY5qhRlzTnLMc=;
 b=SsExKjMwb4ihVt50DyVlac+TenBMB1GZt6mSpT9PChkTKnT5dD91+5E23w0sfyfs6No1l5B8Ljni/Sm9k6UOt0SNV4ENZ61tNiL/+UDZYKdf5dkY7UdltrGgNx8yMLVN+sTjFiJ21+x8cG27SThPQidBonIAq5bIq31LWjhoxbs=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Thu, 29 Aug 2019 06:04:42 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 06:04:42 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Andy Lutomirski <luto@amacapital.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Thread-Topic: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Thread-Index: AQHVXiiEwXAAFA/96kiorDSqao1avqcRovmA
Date:   Thu, 29 Aug 2019 06:04:42 +0000
Message-ID: <B28631A9-BB92-404A-BD58-7A737BCF10C9@fb.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
In-Reply-To: <20190829051253.1927291-2-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::6d75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75c0b693-dd32-45f1-a08b-08d72c46c8e6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1790;
x-ms-traffictypediagnostic: MWHPR15MB1790:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1790ED66F29C8F8DEC7E5EEFB3A20@MWHPR15MB1790.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(366004)(136003)(376002)(346002)(199004)(189003)(99286004)(4326008)(50226002)(478600001)(6116002)(229853002)(25786009)(102836004)(46003)(305945005)(33656002)(81156014)(81166006)(316002)(8676002)(76176011)(7736002)(14454004)(8936002)(54906003)(2616005)(14444005)(66446008)(76116006)(53936002)(476003)(5660300002)(486006)(6436002)(186003)(36756003)(6512007)(2906002)(11346002)(446003)(71200400001)(71190400001)(6486002)(66946007)(57306001)(66556008)(64756008)(6246003)(86362001)(6506007)(256004)(53546011)(66476007)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1790;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BXIXJKt9ygQ1OtJ/Geh65UbKutHNXo+8jEqkQNI1g5sfY1JxcCIwZCu7fti6AX1aT/5bQnWAy/cR/CpV6ZbWnYANbDkCgk8jlKAEHPZhqaevSmW4eqVusVJzzQ1yhPsSNxwaq6ZWdi+xzs9iu2mDtxecEA3Nj2QrkB2m3N55rKAQNApCnG77ueTAgJzj5U3WXMtwFF3+PHZVEJExPFKO7jm+sCKZK6C2ahIdkfNljWLNt8Mt3IsUu6tPX4gqUNbRA2Xq8S+TO4KZd6uTFLm+tyA6FxaSaozPQUwKcwJWBSbwvWnyNc12TDpPxDzL3XkPCjYo97O4nF/sC4DzkqZjuYJDNWAPKFjO7cZSoIBc1mqQx/STB5SIBTLNEFUTIxdFWTk0y0oHFXCvtY85I7EcjATbNoHQnghY5agy+kT3rGU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <71D458617FE4954DA46A61851BAB0604@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 75c0b693-dd32-45f1-a08b-08d72c46c8e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 06:04:42.4375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qvrjhBZ1G15hnaIToP1oPQwtnwAK+P+Hnot4JjfOixthOk6BgS1mOsmw5Ut1OYYCw01zJERHJgMZ9Jc+vsEePg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1790
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_04:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908290067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 28, 2019, at 10:12 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20

[...]

> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/=
selftests/bpf/test_verifier.c
> index 44e2d640b088..91a7f25512ca 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -805,10 +805,20 @@ static void do_test_fixup(struct bpf_test *test, en=
um bpf_prog_type prog_type,
> 	}
> }
>=20
> +struct libcap {
> +	struct __user_cap_header_struct hdr;
> +	struct __user_cap_data_struct data[2];
> +};
> +

I am confused by struct libcap. Why do we need it?=20

> static int set_admin(bool admin)
> {
> 	cap_t caps;
> -	const cap_value_t cap_val =3D CAP_SYS_ADMIN;
> +	/* need CAP_BPF to load progs and CAP_NET_ADMIN to run networking progs=
,
> +	 * and CAP_TRACING to create stackmap
> +	 */
> +	const cap_value_t cap_net_admin =3D CAP_NET_ADMIN;
> +	const cap_value_t cap_sys_admin =3D CAP_SYS_ADMIN;
> +	struct libcap *cap;
> 	int ret =3D -1;
>=20
> 	caps =3D cap_get_proc();
> @@ -816,11 +826,26 @@ static int set_admin(bool admin)
> 		perror("cap_get_proc");
> 		return -1;
> 	}
> -	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_val,
> +	cap =3D (struct libcap *)caps;
> +	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_sys_admin, CAP_CLEAR)) {
> +		perror("cap_set_flag clear admin");
> +		goto out;
> +	}
> +	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_admin,
> 				admin ? CAP_SET : CAP_CLEAR)) {
> -		perror("cap_set_flag");
> +		perror("cap_set_flag set_or_clear net");
> 		goto out;
> 	}
> +	/* libcap is likely old and simply ignores CAP_BPF and CAP_TRACING,
> +	 * so update effective bits manually
> +	 */
> +	if (admin) {
> +		cap->data[1].effective |=3D 1 << (38 /* CAP_BPF */ - 32);
> +		cap->data[1].effective |=3D 1 << (39 /* CAP_TRACING */ - 32);
> +	} else {
> +		cap->data[1].effective &=3D ~(1 << (38 - 32));
> +		cap->data[1].effective &=3D ~(1 << (39 - 32));
> +	}

And why we do not need cap->data[0]?

Thanks,
Song

