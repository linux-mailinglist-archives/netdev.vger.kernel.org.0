Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32ABF2A373C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgKBXg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:36:59 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32838 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725831AbgKBXg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 18:36:59 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A2NXJqW030807;
        Mon, 2 Nov 2020 15:36:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=FIuBskFN1AeFHSF+39mz1ezyOPDowNwnkja34j2U+Hc=;
 b=kvmHnkuvQ385oAfX6Rzyo7OCTn3CaYdusw6rD6ajzTwWMClwWZTFNu0jaxNrPQHlQRrU
 TP65JZ7X1LCTIiMiLa/YkIdIcQOtPcGH0JzwmRbZNQDlx7wT/XVbHeJI2tciCXi2XpTX
 HwYVExhLXUatZRqsgBUsDqaXR6pZ/FHRfig= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34hqrkr5t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 15:36:45 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 15:36:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PH6+rx/2i3QoYECNwX61VuI9MmLGmLQByt53LBEWPWjdHJ2vcSbhfEUWwG7y+H33KO1BNg47nhZ/bBYf8D0wWIPcSCuRRMXa+XVGXx9DCSdy0p0FP9vvkgkTxrTSm3L5SkMF+j/ZMc6Tp5dHBU3ZA86mbghH80GIARPd1DJDLmF6o6x1p4sq3xRpqAj9wltM+bc6uZr6pzPHdqTnHlArK4ZtVwsSI5tRcyIX4Nrl9spgsoSNunkflWs3InpUOV59rTwpnlNmUcfyuyHXmVC8/d7ezQqmLar5H2OPO/Bpv8UQIY4r7XUYIKOlCSDlBHpyZSBYvX8+m8ilIK8GlbfGLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIuBskFN1AeFHSF+39mz1ezyOPDowNwnkja34j2U+Hc=;
 b=ZO2f4d6c4hwuYyEQbfK6cgRiecYyqoalEn/c/S/qH15xGJvhJqAXeRf4zGh4lXeGLkkc2WqkpFlkWBc1nz7/xUJr0JOmCNcxMMF0Cr92490/UwDVpJsypzWpRVyeQDTIgRman9NMDGdNwiCyQzln4e11j3ZqEj8UjyTfak9N9NhDowfJukKOT/42jvgXmD7AlOOOEuF2gn0Um87MQC9fyAYG5fNmN+DdQRzHdJuJeKPsi0ozU9E7d7SkOMsVhYlOFfbvCEUFBmVO1RThREVvW1l2C2QjCISD1cJdqtihggSJ4I9WRMsCFLeL/kmcGDZvtuNjPUl8CUmAtPRxov4Gtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIuBskFN1AeFHSF+39mz1ezyOPDowNwnkja34j2U+Hc=;
 b=A9y5Pyw3u6VCCTDuB9Q7ik/tYpPEeY5NbgrJYDEKgl91peK96M+IfK6zIsgSwO3dmRGQoIrSxtXJpPd3DbhN49y/0gTVb/fdrhxWZe7p8PpTuKwZw16BSUd3jhe2U+Ydk0raFfn7/+U7mL/sPjWFFkoZ8Ygsbi8PnLVba8ORruI=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4202.namprd15.prod.outlook.com (2603:10b6:a03:2ed::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Mon, 2 Nov
 2020 23:36:43 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 23:36:43 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 05/11] selftests/bpf: add split BTF basic test
Thread-Topic: [PATCH bpf-next 05/11] selftests/bpf: add split BTF basic test
Thread-Index: AQHWrY7KbgzCAkRyykW/orFh7CKGn6m1husA
Date:   Mon, 2 Nov 2020 23:36:42 +0000
Message-ID: <62331693-EDCE-4173-86C0-D9E771DA5C22@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-6-andrii@kernel.org>
In-Reply-To: <20201029005902.1706310-6-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 540a0961-1b10-413b-e793-08d87f8827a0
x-ms-traffictypediagnostic: SJ0PR15MB4202:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB4202899D20729F5FFDFCFF12B3100@SJ0PR15MB4202.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:549;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ctXNtqHFfSi8vxNcXTu/ccSnbjCt4uMTR3hKMUefNVV9dxVmsUP9GkYkJ3Q6893c1DwEohYjiirYBz/9UsgbPwBRJfCSWNLsnrZDzB+Nm0hAUWA//WM0Oz6Wx83J5sEhPuUVkaLXuNN6uFBNWU74y0GQRAN+FLTO1khwZEyxdYCLt+WTJF7lquUWEDM7bZYBE15JJkd2Zpr6KE7ai2AyQZepgB7/lq+UUc+KwWsZjY6xRJq6i0wZlbIM45M6B/RsErAkeJi/SM9BxiICXO6keAiejm3hm0gIKFipV+ZL45Y7rbCvzFBw9vf4kC5yfgrC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(39860400002)(136003)(53546011)(6506007)(64756008)(2616005)(66556008)(66476007)(66946007)(91956017)(76116006)(6512007)(66446008)(71200400001)(5660300002)(4744005)(186003)(33656002)(2906002)(36756003)(316002)(6486002)(478600001)(54906003)(86362001)(4326008)(8676002)(6916009)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: t24RvinBz7mNqTY2jU0YLhLmAq0/TkA5aSiF6h1WPQkHIdLdYEXS4Sfr04F/oJ0sW8bUFEp+X2dGZRMPbavp7riPqkHm0p4YKx9aekNdSMpRPPqNvs5YvyVuVYJY8TpP530Td4x/k+qMbFE9vOLMIZ0k0RUMgGV3vSGYvUZ6kdAorxmPwLL5XgFP3MqmBR2VcKLk+xNCUfa0OWrQ0v57XprbJXt+brtygblBreWLknyF0uSUR7wIcO+x4e1DkNB7LSSkcZYLG0+n3bqeFyR6mvnwukHjAx5L+YhNd/jRqGTKMxrYyzUk8J5Q/XGMnKLXkYuxWX9DDhTDplGptR3Fy44zy3tBSpKjCkdLIDx2gdMLEnpe2dtZxaLc11IKz5o0k3fS31tV2UllfbdSDaiscjeUckoVoNflj/FAd1od7XjXQ0qLElRpX5HP09n8lJos152XUAuDbiC/b+w+AZ7LualMav0KYXCcxExSJ0+nwxC6sQFLA59FfsX9ogn16EWleyJogg5deJ6J9eBA2GMzGnXth77Qxv6RJB3Y7YxsgPz1Od/l+CxvGJBRCOQ6w2Q1J3oPg4MHUTUgCUZYohkoQ33VKdPjSSMXWBW6RjtdFaotfLe+Jw7Tq9yIDMRrNuGZ+3BTAsCPhMOnOO7wD5Vu4rXtrUDde0U9Ya1Bs4VZ2gjGEmjH1B561D4Icmi1St1/
Content-Type: text/plain; charset="us-ascii"
Content-ID: <869EEABE27A963448C10A1A98695F343@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 540a0961-1b10-413b-e793-08d87f8827a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 23:36:42.8352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: REq7NKOhb4FF1rZfQCqK53v/zqEGBkUc5QmtMyERcO8fkXMzFI7aPes34jY5+E1XWUXjYHeS1OvFJQTpM+Hxyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4202
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_16:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011020181
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> Add selftest validating ability to programmatically generate and then dum=
p
> split BTF.
>=20
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

With a nit:

[...]
>=20
> +
> +static void btf_dump_printf(void *ctx, const char *fmt, va_list args)
> +{
> +	vfprintf(ctx, fmt, args);
> +}
> +
> +void test_btf_split() {
> +	struct btf_dump_opts opts;
> +	struct btf_dump *d =3D NULL;
> +	const struct btf_type *t;
> +	struct btf *btf1, *btf2 =3D NULL;

No need to initialize btf2 to NULL.=20

> +	int str_off, i, err;
> +
> +	btf1 =3D btf__new_empty();
> +	if (!ASSERT_OK_PTR(btf1, "empty_main_btf"))
> +		return;
> +
>=20

[...]

