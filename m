Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF18EF3C1D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfKGXWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:22:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50596 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbfKGXWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:22:52 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7NEnJP022378;
        Thu, 7 Nov 2019 15:22:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wYtWegmH29JI+MTq06CFict3lHhh2rqciyyhUpKj8qA=;
 b=DL3krBixQF0024m/M332Vw8mxMw33NfVAkSMQTif9b+K0cC0h+oUwYwjqVNS5KzOaIR3
 WEL4IwimpDIQacSbd0heQ20KjNhj5Yj2cbpoDJ9Y4WG0KHunRrRgMb1gCAjSrkXpz6V9
 u2KbFekzuD+/MR9qqC6E6dKHILU5EsqqzLQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0r1xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 15:22:38 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 15:22:37 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 15:22:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPCrGk/PRGU2kHhOqcdBJhXaWYNFP97cQurmhHezZ41Img6Sb3rdc3vKw9ApvlAkqsLn2oHEt7BUe6VJAOsqFBDYLnMwwpVyirLpkJV4FMEQch6JBVJOCdczVgXZyGeupUK81Qv9WePdtoTqrENduPfoQ4BGj9vY18Oe6gVRnq8sQ9AMXN0OxPyJxGI8IA7Jv7hilvL6DT4weaEQt8Sq3XJeC7frn178c4LSwgXD9gbT8Uq847AQI0bkfN1AD+GOhE9mDJoxWoX3A9xpvbnorQndUii9bdJROS2L3cqq3l693twUbu4M99CfTVjporqex0G1uHjmeAwbf/DxollBbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYtWegmH29JI+MTq06CFict3lHhh2rqciyyhUpKj8qA=;
 b=MF+eSYIH7+zUg6c85AfCYzNa9mlbZpSn6btwJNDhKk+GWzG8Ao7ABaQARt4Xob98pxFwzZHA5e2LY1jZb3QbhQ6SugDxiNMhZGN/iDHywiBs9CI/YeAzapMGgbSPSobiZ/2K7hqF/oUC7OZYHUzJY/ET7yj9dK47IRUgfK+um3WiYA3RqAwXHhyOv/ukZ8/hDO4vzSU2++bykPzjLX8b/Qsm9QICc1vAitLaFZ/Pr5dkpoR4cHeWJ5yHPwFtEpB3AW8Nfg+FO44gMMohkvgYJAsVYKH6ecgSWp2QwjBlNa3ofcyuBzeZvsZvalCyajA/TG1KALFx2HGinXF418lmaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wYtWegmH29JI+MTq06CFict3lHhh2rqciyyhUpKj8qA=;
 b=MeaI+EXGoAjjZuwsTVP7EN95+NSlU+vzz0/jl1FT1diqgR4xLE9P5CYXcTSQBPciza8DifdBdVuF8dKxlKEKgRCu7aM8lDSfIZWGMJ/s3sd7FBr0WiRH/Un9zf4CkLwTAzyGnp6Wr0tbXGFqigxDEB5vDA758XtJ/zdMM3A3cfE=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1758.namprd15.prod.outlook.com (10.174.255.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 23:22:35 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 23:22:35 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 05/17] selftest/bpf: Simple test for
 fentry/fexit
Thread-Topic: [PATCH v2 bpf-next 05/17] selftest/bpf: Simple test for
 fentry/fexit
Thread-Index: AQHVlS7UrGe1ly36jEqr1lul4NBozKeAWhuA
Date:   Thu, 7 Nov 2019 23:22:35 +0000
Message-ID: <BAE2CAC8-EE85-41FD-AB1D-DAAE81E97CBA@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-6-ast@kernel.org>
In-Reply-To: <20191107054644.1285697-6-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::1:11cf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f02217e-4a13-46cb-011f-08d763d95f71
x-ms-traffictypediagnostic: MWHPR15MB1758:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1758772A185DB6A2E0F1C729B3780@MWHPR15MB1758.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(136003)(366004)(396003)(189003)(199004)(46003)(25786009)(66946007)(66446008)(64756008)(316002)(54906003)(66556008)(66476007)(478600001)(2906002)(256004)(4326008)(8676002)(8936002)(81166006)(81156014)(6436002)(5660300002)(33656002)(558084003)(50226002)(36756003)(2616005)(476003)(99286004)(6506007)(86362001)(6246003)(229853002)(11346002)(53546011)(102836004)(446003)(486006)(6486002)(76176011)(6512007)(7736002)(6916009)(305945005)(6116002)(14454004)(186003)(76116006)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1758;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 26eIrpEhY4/R3H4fnI881bzt7kTg7dX7AytPoKdDSxyIsYR2+Nci1oiHaU7Exr8jV2mDfQ5JcdORBqtppg4xL6yBFr/acApf8yRYIgvH/AuS2MIL+dhbunI0yXzZJKdcp15I/9lgNLyJCpDTX/C4lXRBlcif2TFC3wjyp/4lTWsSZW2D886ERA5heqXFGCOUhFWfGccXeWc3DuSkW3pT5qtZbW2nUS1M1y+jXZPBL8IWs/53aUqg1++3uXRpSfT/6Y9Xp/roo1CAzXJaUAA8kicA8dhVHggk1+Kfk4jW2UwqQifVQ9ZF+FbFdmLle4pxnFyi59280AobA4gX3kHXUrVdAxlnZDRgY9lalXTavbrUMZxlEm9FszTijaaZGPUB4QzDOLxxnvAFfixxPKsiTBJFv/x8iRFSl3PAKJ+H0ySH5W4gBAbU4dZ+OUyLhqfq
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DAA32EC7641AD24E98016859C08688C1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f02217e-4a13-46cb-011f-08d763d95f71
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 23:22:35.2930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DHfhnE3VTv6N6uPPYJUjRWm1mxP/5R3ZELnPAjlL9neCeEbCzWNQJQfat+66vMTwP6hUTHvEQlJ5MffSQR7btw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1758
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=683
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070214
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 6, 2019, at 9:46 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Add simple test for fentry and fexit programs around eth_type_trans.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

