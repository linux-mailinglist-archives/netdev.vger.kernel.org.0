Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F58F2A3A9C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 03:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKCCwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 21:52:37 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37588 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725968AbgKCCwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 21:52:37 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A32np1T021706;
        Mon, 2 Nov 2020 18:52:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cFvEr6sLeFkWlBkDHbatTjX6oS0mFaLTmIt8vFApVO4=;
 b=P9xq7GfdquJ84t21K0vPIsy3tFZcwjajdEUxRTH450VhjtMmfGmTlThga8ggdngp/Zg1
 53Y3XcZLco/sWXf43LHeZOUGH9E/RL0Dz2gFogEqy2h7WpjSGgnjKwAFp2Is7erhrrTV
 Ibg7in6ndo2TlQZj9JrTtiC6M+88FwfCynk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34hr3h8k5v-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 18:52:24 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 18:52:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itiDyLR2AR75aDuTmK9Br8TG1aIaO9PsWl0SRRV8emIsUTp3HXKBaRDBg4K4rtZZkFcetibm3JDckSnfAdp16cAb69kNy+ViCmUog5NNs2q5FrxxTzkp+ywiKnejDVlfgXPq5JZWd5f7JDLhNfpXFGtc7JEf7266bd1DzlF2rGQkroY7kGAdKBjXc9iiREalB2cRlgI3jDDkOroX3cc/Pub0pNXPB+jbjwJjaHH5TlzAPJzT1dI9pOBqfGDifhK8F5teozMbHAzyKga1N2JOr8Wo3BKqJPmJtMGcW+yO/8WlyLjrQrfxqsaD2aqSfAAeL/zFS0Sn3XkA8hTY37+b5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFvEr6sLeFkWlBkDHbatTjX6oS0mFaLTmIt8vFApVO4=;
 b=ZcmbznfTCJnkcOixzG1ia7dq9Y1YF9BYGP9QsfkRb7oUfQDhHbuRFJKg8JOw5RFFM5jdClYjkS8TXJCm594yqLiJayFJ5pW5TB37guOF2TArozHYo3et/jJ24JWNMMcPCqmKrGMWx+H6RUBUJFTSbyV0fxecKweSa62lyBJwHRxW6g7FmurAplUx7HTHdvrLfS/vGquIk6C9HfsOa3BRpG+aOPqYb28VcT7MF/qS6ZeI6XaTMJ3tYC80mi2lHqV3CZ8rcApqBPHLCrASUzLstiJJvNOltNiNHoNEjEcH3bgxj45C8BxCJq1jbZkBSJNk8vdvEfG7QXz3SRVZhH8nYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFvEr6sLeFkWlBkDHbatTjX6oS0mFaLTmIt8vFApVO4=;
 b=E9GVf/GMdOsCCDia62mKK+c49YCP+R0ux8b/huxE0gmmkrt+C1lDLyWtgnmv5RpM0z57WTf2mfQIub19FFkiR1nxF78gJtJVKiIAAKXlcI4hDjx4eQ1EmNBq0vgGlZVEwM/bmAPyhqyc1oFryM0A4sdEdRSTlmANZzKUk1Pc2KM=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3416.namprd15.prod.outlook.com (2603:10b6:a03:110::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 02:52:19 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 02:52:19 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 09/11] libbpf: accomodate DWARF/compiler bug with
 duplicated identical arrays
Thread-Topic: [PATCH bpf-next 09/11] libbpf: accomodate DWARF/compiler bug
 with duplicated identical arrays
Thread-Index: AQHWrY7RhfvPuN9xQ0WbAmRP06roI6m1vZEA
Date:   Tue, 3 Nov 2020 02:52:19 +0000
Message-ID: <E169E3EC-8718-46EC-AF40-9A108CE1AF15@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <20201029005902.1706310-10-andrii@kernel.org>
In-Reply-To: <20201029005902.1706310-10-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b74e487e-66f6-4cff-0f3a-08d87fa37b2c
x-ms-traffictypediagnostic: BYAPR15MB3416:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3416131BDD90D8FE7DBCFCD3B3110@BYAPR15MB3416.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZnvXVGn8qkx/8+xWSDOH4W2ZEHDQNocRzCRFot70KJiEmT2LT/zKCKA5exhcb38JFN7yMurQakUyjKjrQt0MYzF6gHDnckOs8mgRf+rdGsMDZJ50MpZ7rjvSHGsnXMPenEliqFEEdSCJ3ZwNuFwGoHOEbFVMJd7G2CFlEwj1qczJV9Do7arTtEiFJoZSOwBeIRmfzr4ppxv4KMlybmQ7cdKxQ+bUM6NlmUrMm3c9suJmV2pdUWBHZqOI4enUZouVQ3icKjoKucIvUiUmthb73pVZkBYMtpTg0RLW9PwrXF0Jq9BzeGX0LAidXz8XHD7DjWzR6Zvoj9jD13SIDFLvUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(396003)(136003)(376002)(4326008)(71200400001)(66556008)(6506007)(64756008)(478600001)(66476007)(66946007)(2906002)(66446008)(5660300002)(2616005)(8676002)(53546011)(76116006)(86362001)(8936002)(316002)(6916009)(54906003)(4744005)(186003)(91956017)(36756003)(6486002)(33656002)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tpHzXEHNuPVSEAdxa70xvlmgHHW5bW+D1eHNQXaR+l3Nn0XMyr1IzBKosZGHxZVWTC7tGWhE1M/Pd9Mx1a1SMFLN0hSHivnGqzAu9H0igAh1DfjbGhcQPcOqqxWK5DklGwGYISrVkoiEs0O7m5gX0OQ2agU31OMMMIpnDm+DykvwU7jxO5fAGP1Hwg+8D5GmvXeE1gRG1e3erYhOkkvg8D48SRzgy45HCYohXfd/kcSPLAGWtQUFBIdVTXZ9xqdRAfSGpkb81FqWC/Mh53aSFsoxtrAKlRAf2yhZhNdKCoDBDuxPozHHhoX8VEc+Xse1h/XhDqHqXJFT11MURhIAZ/JCGFGaqjDWrmvF8Tc8s7VMImjAU0ueMLybVMSvwZDtUocwlpNqsmt2Khy/TyRk+xB6W4TspUSKtqcYx2p769oLr0tdl+pE3dTbNEnhWxekXlVj179vo1wOjGj12B1wxmtNOwNrvAot+91HL3+EYkF33ixR4nt3s5oDCpaqsydUz9By9pW73EzLhaYMnMuq1pzc20gNuPPhDVx3xDkYAw/oeBLET43R2qQixIgB/HgXObz2fCnNb6YibPfJ15gvmKAoGOCjNC5uwkv/uVP19fL3IzSIKuA2qSqZ4Cy7aLWOFfy92dwwrS//NFgU0EHMV6veTv4u6VtGYYe/lz91sUqcwhTWqJA3OozAhLRzsP58
Content-Type: text/plain; charset="us-ascii"
Content-ID: <04B56033CCAEE04CBFA3EB237EC88D19@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74e487e-66f6-4cff-0f3a-08d87fa37b2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 02:52:19.4747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NImoyzLQ4JZWtCfpePXh38XWgQ3PGesZfM2BG3RFxEnLb+zk0VBOWn6fX9T6oPASF4A0L2MLyKtDUxYot2jzdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3416
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_16:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 mlxlogscore=563
 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030019
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 28, 2020, at 5:59 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> In some cases compiler seems to generate distinct DWARF types for identic=
al
> arrays within the same CU. That seems like a bug, but it's already out th=
ere
> and breaks type graph equivalence checks, so accommodate it anyway by che=
cking
> for identical arrays, regardless of their type ID.
>=20
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

[...]

