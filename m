Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FBF2809B1
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733235AbgJAVwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:52:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:20279 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733093AbgJAVwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 17:52:15 -0400
IronPort-SDR: fVyjNKKtLmEoUuXtgxImYFL64hd9mgHuP3iIN+HA6649ZtTBVQghRuGj5OKZc+gjfqo1ciV4xX
 kA0AqimLQ8lA==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="180994368"
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="180994368"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 14:52:14 -0700
IronPort-SDR: H/1bgRe8RBTHx6sBqEf7QCNL1JqHfkcVyOxLPHfrgJzfDI4hk25aPY+Z9cT5EVsB4TRpyKnZFf
 ueOuCRAeswjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="351319703"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Oct 2020 14:52:14 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 1 Oct 2020 14:52:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 1 Oct 2020 14:52:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 1 Oct 2020 14:52:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 1 Oct 2020 14:52:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONZP5Pc1WMHzMff5BFSmdFZwMCBuEErEWWueR0Yx+l6T1xgKOG8PQ2nEKd+nOOj412G+e+f2R2PXW8Euuu7+xE+0vX0W+ZQEfSRtkKuo4kd+fPsTVskEi2/RHq/9NHyIP1qstCMWoRfqcnXut2OP9GdgAvyH+k+xLVVr36kmQohEix7uJyjqA66VoFOUT8DoeXSFHkLYorY3qtVfUN0YGvgwsMWbUxtREvYvlvApwk0qxen2VaDyWZ3GZm41NTbpr0+IcoCVn0teQ3CSnI5u2uM2IZ+h941bVP7sPYSnTJQYL7g8G6K4foMUKPpfo0kxLBMBn4+KjX+J6b+XUK8h7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QngxF/V9rF2PKcJrz65zB2MXhvxX1YwtY0y09hQ7uUU=;
 b=od+iaQ4o3U5VvFbgJXfVubfBsrr3lrpLHN7CpiDDuODPkcbAFg33WMbezK+hxx6nL5bwE2jM6zrV53n0aHYWlPUonb5ulCncxGqSrGJuzHrbE33oqVTYr3eM4otP+v30M9Qis46448DNcXmqFRlm6uvjjpH4UhFuYL3wl7j0CYl9lzZpKZkTc6T54XQl5oU0bv36OjTMHGJdNSd2nyJ0lPjKCrcaujNs7LWUCpGF7ZFpsPQnLjVV91CXCs9uDsQ5L22slIt+9BzfqrR5kxMX35WGDf4TRatE5owiKgKhYJRY3z3E3k4NcizNXKHmQTaykbJ5OMXav/TTLgY8Y0PHxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QngxF/V9rF2PKcJrz65zB2MXhvxX1YwtY0y09hQ7uUU=;
 b=WsBZhxvcTEBxxJw27Es0QitiRmgw6V3xk9blclXvHbmDG0RRtWMeGWvtna2zbaGHqrfR/0R0a6j2DEp0uskeXb6cbXmEmBmxN9ghhFTFk4LN4TmN0Lx+2Mv/f76EkA3+VtZr0IsvppljI1K5Ec5/a1LMjuBKsILRJqjW2P58Fkc=
Received: from BY5PR11MB4354.namprd11.prod.outlook.com (2603:10b6:a03:1cb::16)
 by BYAPR11MB3304.namprd11.prod.outlook.com (2603:10b6:a03:7a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36; Thu, 1 Oct
 2020 21:52:12 +0000
Received: from BY5PR11MB4354.namprd11.prod.outlook.com
 ([fe80::55a5:cceb:40a7:aef2]) by BY5PR11MB4354.namprd11.prod.outlook.com
 ([fe80::55a5:cceb:40a7:aef2%6]) with mapi id 15.20.3433.038; Thu, 1 Oct 2020
 21:52:12 +0000
From:   "Pujari, Bimmy" <bimmy.pujari@intel.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>, "maze@google.com" <maze@google.com>,
        "Nikravesh, Ashkan" <ashkan.nikravesh@intel.com>,
        "Alvarez, Daniel A" <daniel.a.alvarez@intel.com>
Subject: RE: [PATCH bpf-next v7 2/2] selftests/bpf: Selftest for real time
 helper
Thread-Topic: [PATCH bpf-next v7 2/2] selftests/bpf: Selftest for real time
 helper
Thread-Index: AQHWl5c9zZhBAy/6Fkuo3HSPYHLAW6mCOgiAgAEQKnA=
Date:   Thu, 1 Oct 2020 21:52:12 +0000
Message-ID: <BY5PR11MB4354F2C9189C169C0CE40A9B86300@BY5PR11MB4354.namprd11.prod.outlook.com>
References: <20201001020504.18151-1-bimmy.pujari@intel.com>
 <20201001020504.18151-2-bimmy.pujari@intel.com>
 <20201001053501.mp6uqtan2bkhdgck@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201001053501.mp6uqtan2bkhdgck@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [98.33.67.35]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c33bf1f5-3993-40eb-c988-08d8665440b6
x-ms-traffictypediagnostic: BYAPR11MB3304:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3304C60AF38CB7DE033B7BF886300@BYAPR11MB3304.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R9ZK5hGXGheTsLnXhb65C9LV+kRl+KjJJJc68ymJYrIZdDTVFIlN9JtEckgSm9UHtV226wUoR/3o/MCNNHXbPPp+8hBKmUV+hATG8hUnWcAPEYtrP/65m/w1tqigXm/biqedKGFDvRgXMmg2XgeNYgXrmL2lGUDOFYd3UjNPKrdeqiISX1Ly0Kh4vqFN6YJQYXuXnR4+uizQqc6GBMX5IR2DA5Qs8TJWdyM3cviaU6UU849tOzLqKTDptABvtrkCMxkj4JHcCYukXmEKDkamJPu2w8NLy1+ghEu3Hm8SjjcaWi/sjBub9qtl1GJhZwT8crYMI9E03WhP2mHGkQRdPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4354.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(6916009)(316002)(7696005)(76116006)(66946007)(71200400001)(66446008)(64756008)(2906002)(66556008)(66476007)(107886003)(55016002)(9686003)(52536014)(26005)(6506007)(8676002)(86362001)(4326008)(33656002)(8936002)(5660300002)(54906003)(53546011)(83380400001)(478600001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: eSLOJzHhf2FsFfDXXSfoJapYlt7XeLtsz1MAbMbDzV8aA1GcTnze5zsLMSVtSmGczihuVCc4G5q+1yiLD5UbtvcnNB0MYfIlmR4RuPC3Bbucbd8j8Bqg3wTFSuYrhVze1gEAWTsyHxOUEpbjOpVkoYEtSl2EBJGbW6dnD9+dd82FfQ0og3/fl5tVX8tux2w0A3c46syjf3w0O5ivszaOLJU75oipIRNSVKEocMGqgPffr4Y9c6Bm/ohe7jLfPATh62rZD4whcOJMNngelWR5NKfYBsBjPyDJWxzOtqDsg3JwY3XVX/oNDsaJcbmu96irKt2pawzXTsJ/9E+Kvh82WYUAnw6TB3xYTfd49XadLwAQ5si9vGzvLcMAds1i/ZMhYuWNmu8tFeaRhK4ttL/Joi/BmdQhQ9ObCtILThXa4FnZQhxjQfs7C7M76hJLlTYldBngq7/R2YAwtKNomn0b1KU/AZktG+V6pqVSiAbtVRF/KoRsEknrGFTEo5yQDQQNvWTGUF4Y0BZ1DQ1ehzpbgECaCNNG1Oe1DgYt3VZ6+GhOtu73JqFtpKJ6NCjfAJhVYCZZnWdghdrl3rGcqWnbX8nf3FhvONyjg/QAfvD5wLyL9ADZzZ9uDbhu43SXSuB5DM9805pVxDxpNH+gq6BonQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4354.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33bf1f5-3993-40eb-c988-08d8665440b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2020 21:52:12.0562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 64Wkwc7wEQf2Ldb6EnHRRlFd0tHm3vYfuQD6cbZoAhccdnyn7Tz64lvyOZ0WoveITZa3xPWxKgArwc7tuHlhcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3304
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks everyone for putting your valuable time to review these patches. Can=
 any one from you suggest the best way to test this function in selftest?

Regards
Bimmy

-----Original Message-----
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>=20
Sent: Wednesday, September 30, 2020 10:35 PM
To: Pujari, Bimmy <bimmy.pujari@intel.com>
Cc: bpf@vger.kernel.org; netdev@vger.kernel.org; mchehab@kernel.org; ast@ke=
rnel.org; daniel@iogearbox.net; kafai@fb.com; maze@google.com; Nikravesh, A=
shkan <ashkan.nikravesh@intel.com>; Alvarez, Daniel A <daniel.a.alvarez@int=
el.com>
Subject: Re: [PATCH bpf-next v7 2/2] selftests/bpf: Selftest for real time =
helper

On Wed, Sep 30, 2020 at 07:05:04PM -0700, bimmy.pujari@intel.com wrote:
> +SEC("realtime_helper")
> +int realtime_helper_test(struct __sk_buff *skb) {
> +	unsigned long long *lasttime;
> +	unsigned long long curtime;
> +	int key =3D 0;
> +	int err =3D 0;
> +
> +	lasttime =3D bpf_map_lookup_elem(&time_map, &key);
> +	if (!lasttime)
> +		goto err;
> +
> +	curtime =3D bpf_ktime_get_real_ns();
> +	if (curtime <=3D *lasttime) {
> +		err =3D 1;
> +		goto err;
> +	}
> +	*lasttime =3D curtime;

so the test is doing exactly what comment in patch 1 is saying not to do.
I'm sorry but Andrii's comments are correct. If the authors of the patch ca=
nnot make it right we should not add this helper to general audience.
Just because POSIX allows it it doesn't mean that it did the good choice.
