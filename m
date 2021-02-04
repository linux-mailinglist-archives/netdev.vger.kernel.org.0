Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713963100F3
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 00:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhBDXoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 18:44:46 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10486 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231180AbhBDXnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 18:43:51 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 114NaprI020566;
        Thu, 4 Feb 2021 15:41:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6iRL3lCTVq2+Tf8Ig58O4c37TXvSYSz86SzugcjS53A=;
 b=nRjuYUYrZAoldCIgVzvvkVx9HHuUB+XMOQ5XRq4zsEUCMLOV47gnzIO7cPLwYev2I4/G
 pyoABXgxsAJCDPQG03kXmdJHlgzKJJwbQnlOr19K7GClJTIuIbM0f5Jg3/D+iZnMqSXn
 8R/ccubVOg7YWmU5IS9NkCIdwI3j4iub5x8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36fh1uvphq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Feb 2021 15:41:52 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 4 Feb 2021 15:41:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhAcNXQ+WSSmMiinld/8irpstpRJPNsAvKlPhlt3w5Yy6xEgj/hZM/8EHn/3GMMMm4iZglIZDD498LHcAwpX04pB9W0cFXvSkuyCAAn2TIUkc7zqIyEOC2oTWgwW/fh8OhM1rK4l9CIZx0l4Q4+3GoVVrNxG5tDlyAM9+WAUmSUIOqkeOXkRsAHgzjCkKqoOpwPrqtd7PiDLckAIOYRUtRV43kiy28q3WWXMcQy5TUSSfx5YwEbGRBxSxSobKPzgfinU8MAcI63zq7IPYDToI1lMz28eJLUef9HSmrrDSPv4W8i8io+POVcNldCBRVbzOTHT2IVnF7/SCHJwoc4NYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iRL3lCTVq2+Tf8Ig58O4c37TXvSYSz86SzugcjS53A=;
 b=OMJph7x/dBHWWpFQkhCvItjVq9MnrTFxWsb2M5KXl9kwxwUDdL/4N7F7+NVX0UpcZYyBSlydpZUgP14g1bIXa1tNoGse6gCi5/4XCTnUsjQV600MiLUcpZaJzBqoHl1mH8aBDwB2LzjqErme6U957zpJqeNRTs0/DDNNCHRHOewrMH3P8HTTdhwr14TS6B75gV+uQCpw+NYDDA9PXsN2J6T/YuwyfYioHAtk8okwT2h4iCbhdhTWQNgzaHAVobuok71hVhJ2HeEtZ9mox5gD4AE/YA6HK/BYtsEAKJvLlcG5eYyT/TtR4dctHt4GRaijuvJtWb6sLbWmVSzxEL1McA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iRL3lCTVq2+Tf8Ig58O4c37TXvSYSz86SzugcjS53A=;
 b=VnLgxqZfyeHTYILC3SgBuPspY9lGolnSlGrLwxGJtT+pdGFuvohu+Di1wIyF6UfEAE/5UwhcOBYP97cfKrx2vtFxB9fX7vAFbTQHwCJZFR72ztxAvR1zP0QLjhGo011XU88R5hDGhoQEufbmkUrJb8sQdZZezcl393JRplSoeic=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB4086.namprd15.prod.outlook.com (2603:10b6:a02:ca::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.20; Thu, 4 Feb
 2021 23:41:49 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.019; Thu, 4 Feb 2021
 23:41:49 +0000
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
Subject: Re: [PATCH bpf-next 2/4] tools/resolve_btfids: Check objects before
 removing
Thread-Topic: [PATCH bpf-next 2/4] tools/resolve_btfids: Check objects before
 removing
Thread-Index: AQHW+ztfJ9rUk/7B6UKNtOkCD8ckBapIqCQA
Date:   Thu, 4 Feb 2021 23:41:49 +0000
Message-ID: <41FF93D0-10DF-4ED3-92D8-E30220010845@fb.com>
References: <20210129134855.195810-1-jolsa@redhat.com>
 <20210204211825.588160-1-jolsa@kernel.org>
 <20210204211825.588160-3-jolsa@kernel.org>
In-Reply-To: <20210204211825.588160-3-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c091:480::1:aa49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0b5b2aa-2457-484a-79d4-08d8c9667126
x-ms-traffictypediagnostic: BYAPR15MB4086:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB4086739DB4BE80F31C4B3860B3B39@BYAPR15MB4086.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wvFk0Q5zgrIF1mOdqgvaLd6XyYpg9F3+wxXxXtmuRkqqeg4kIZQ4AkHM79vGHkldMgLzWTUVpbRC28Ga4lIh7wKtN4RWqB5imb+59O0zSCLTlMMrQpKjBtB92m1Q7WaRRFNPBiNqxji76YisDNrXp/T3mVIu7ttT+C5PpOQ3/CTlRiGQbPjQGiJa0zXmgcMAa48oCRAMFYU8pTYOq5fvvwZaxIV6yWBXPZmC4j850NzB/B8+i9Nfof3nbvB376kWXwyePC5mmfNVAx9rFAGFQnhRZhZRIvGdap9RzQUVcoNSYb+CYMgmLAzIYYykgQQhVRnuPUl2ZlCzEHsFRxgKOEEVb+5sIZzgQLqFUoBLdZGpj40IdedA3SzIpQGZ3fMV9dihjbHxidwDPiIfv7VclDlE2+ZFxQm8CLC/ymVahCjZYR68ZtwS09WWDy6+Ny0dwCOomJFWoOERMxeGKXNhdFUbWO98oEKL3b/AQAZm9qfvgUlmevGndNFS8wJmzplEqdJynqaWNuvjojNK7Fmab+dr+sIB2E3sypk+NebvaGM5McL27/VQ2poUjlLT0PaIjHV7SnajnTTkdOEHO9UvvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(396003)(136003)(346002)(53546011)(54906003)(66946007)(66446008)(6486002)(2906002)(4326008)(71200400001)(66476007)(64756008)(6916009)(36756003)(316002)(5660300002)(478600001)(83380400001)(6506007)(7416002)(8676002)(76116006)(91956017)(186003)(33656002)(2616005)(8936002)(86362001)(6512007)(66556008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?txljXtD1IukI4FfxuhHDLcGofKHV+P6GEQeOB9VlPx1gHiMCezstmCFWi7Md?=
 =?us-ascii?Q?P01mxYDMsSX2rBZMpwSW0yd2LTjI7mPww6CikvD3WukCY0crN9KbR3OwMTTM?=
 =?us-ascii?Q?RoqwhnB12ShCheYjycKOQAthFp6oKvoO3nKTf+ghkdYdKex2zEpSl5o05GCU?=
 =?us-ascii?Q?bsh2pJtPCQttwGcz2Go5nFvvS8DElkW78LacyxYrsOYzs+4NDnrsUEuCRKd0?=
 =?us-ascii?Q?XjejA7E2msLbfVQ343WFNTwyQohFLwBQeARw17lpzIWKVzvyXag/0bhaCwmB?=
 =?us-ascii?Q?rfasJT4FVPvMtI4XD2M3opiDZtz9ELX8Q6gOtGwFtRm1L8Nol3be92B46OXn?=
 =?us-ascii?Q?zQdKo9gYhTd0C1kugLSlYYCOgH6iF1Xa+IoNKJwpJ7bUXrN/mIaLaeCssUe1?=
 =?us-ascii?Q?YSIizy3lMQJywLqjWPFxMttC5itdL1Ee3engFeSVw+z/eeHfDnFxP7uqmWMP?=
 =?us-ascii?Q?WzRZ4QsdZnmGB8oM/UtIo/wKi0hfHUZVhk2ALWyffy494NmgPSfp1PtR4S8C?=
 =?us-ascii?Q?NZVLJ9O84ZeIURWkO6aU7xMO2TQL02oMs2DTXlz4rqNYKo3ecgkyeYk+iOCp?=
 =?us-ascii?Q?eWw9mGZzA3oFyzyzb4KFXCKtA8vRXd23HwUL9yW80zCjxNGg/AjMyGl0+Fuk?=
 =?us-ascii?Q?x8gOsaBskzHQgi3iYDYIFTwxdqiFiGvDL9w8bgGgbnk5MN3oOV67rQB+zes+?=
 =?us-ascii?Q?efNOjs37Uch6ZHYK+F9jqnfLoZuj7te0eA84wYm9aM3v/SYuxF9RSLpBvsAS?=
 =?us-ascii?Q?5qiIt2hBXiEaXL0hTXfpDa6dw7R0JV6k0x8P6eIQfSoHkuPQpgWW5RSkdyIx?=
 =?us-ascii?Q?oHyw1h0f1n9XZJvNXcgg4U5mSe0CcL7kfPSm+4UvYPWZoNi9amm19bET2ehH?=
 =?us-ascii?Q?QUMDEuAYbV7JGOtlGK7VM901DoKrM6JtTWRFHjBeydiPFDzyUpRbgAS9QstM?=
 =?us-ascii?Q?o0ZbY+5xNR+5gE7J0hJEQhsP7jViLvXRo5V8fWDlyXXRzDKKuY1kJQ4DzdmK?=
 =?us-ascii?Q?CI7WEnDTpk511ro+ARbyLwdJpqaBclee1VRwi7nFKwcvNwhPt0ABdeKmHxX5?=
 =?us-ascii?Q?BbYb4RIW5okD5i9Ip8vZs95NMSFuL181gpGvS2JbE8UGHzFJe7qxFbjqZ18X?=
 =?us-ascii?Q?/iJ15Y3PWrXS16tLh5rDf4mLZKrCCJkXlnZAiMuiU8riF+QoUSw/0WC957Ny?=
 =?us-ascii?Q?+PHreFVIiteVymou45VW9TZUAKy/DZ93ABB75Kn55plpPC2HPHxYmLcdN8pD?=
 =?us-ascii?Q?/0DA8dkC7c/1bhln0jF4zWCuhHTfEY+aWJOuu0zkKT9k+AAKtYosghR0AFbb?=
 =?us-ascii?Q?mif1Agiix1WGD6Zby38ckPusS4sHP2RaHJR7yOSVpi1YJ/903Y5moMH9zf72?=
 =?us-ascii?Q?3CiEiyg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <73A53B3E70A54A4F8785F7DCE786F5CC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b5b2aa-2457-484a-79d4-08d8c9667126
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 23:41:49.4019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W3K6Z1FHTYIvujeo7T0vCS72YUI51PDY+JIbTIh5DVH9pJezRGyyQPePPOYZAdfPHzlasXJw5WkAXknn2TgVuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4086
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_13:2021-02-04,2021-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102040143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 4, 2021, at 1:18 PM, Jiri Olsa <jolsa@kernel.org> wrote:
>=20
> We want this clean to be called from tree's root clean
> and that one is silent if there's nothing to clean.
>=20
> Adding check for all object to clean and display CLEAN
> messages only if there are objects to remove.
>=20
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> tools/bpf/resolve_btfids/Makefile | 17 ++++++++++++-----
> 1 file changed, 12 insertions(+), 5 deletions(-)
>=20
> diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids=
/Makefile
> index b780b3a9fb07..3007cfabf5e6 100644
> --- a/tools/bpf/resolve_btfids/Makefile
> +++ b/tools/bpf/resolve_btfids/Makefile
> @@ -64,13 +64,20 @@ $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
> 	$(call msg,LINK,$@)
> 	$(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
>=20
> +clean_objects :=3D $(wildcard $(OUTPUT)/*.o                \
> +                            $(OUTPUT)/.*.o.cmd           \
> +                            $(OUTPUT)/.*.o.d             \
> +                            $(OUTPUT)/libbpf             \
> +                            $(OUTPUT)/libsubcmd          \
> +                            $(OUTPUT)/resolve_btfids)
> +
> +clean:
> +
> +ifneq ($(clean_objects),)
> clean: fixdep-clean
> 	$(call msg,CLEAN,$(BINARY))
> -	$(Q)$(RM) -f $(BINARY); \
> -	$(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
> -	$(RM) -rf $(OUTPUT)libbpf; \
> -	$(RM) -rf $(OUTPUT)libsubcmd; \
> -	find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o -or -name \*.o.cmd -or -nam=
e \*.o.d | xargs $(RM)
> +	$(Q)$(RM) -rf $(clean_objects)
> +endif
>=20
> tags:
> 	$(call msg,GEN,,tags)
> --=20
> 2.26.2
>=20

