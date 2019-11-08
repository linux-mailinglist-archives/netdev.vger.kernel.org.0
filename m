Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E51EF40D5
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 08:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfKHHE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 02:04:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56298 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbfKHHE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 02:04:28 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA870keL000721;
        Thu, 7 Nov 2019 23:04:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xnqsdnnnt3TOs/yuWzPSK+7GVfE+3jE3HDNBZ5NOzNo=;
 b=iXOtonzmcw7w0GjBG04shEF3HpyRDgJ9zx3XNkw6gvkVai4MoiyZLZkMZ9pSvMiWMFuV
 cN8thF1YtaBgFFj7fgEP6mFJx531Bz4hcBpkko4GLjfWTQli9u/zvZg/sZNQG5NTfZq8
 yOt2lXMHLqdC+i8DV/vAk0M5DIYLyj89xjU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41ue9rv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 23:04:14 -0800
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 23:04:13 -0800
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 23:04:13 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 23:04:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALrKT1XAmeYPugau1+umiwU7TtdC7/2HOVbOJ+ctpP1lKdKUj78tbGZbs5rNuNWLftsXUMI6W9Wj/OPFLk3o+tcLuZyiKjuQn8fxHZjFUPKUjRwGJ/ja4tNymue0toKuzv66DziRCmvaCI/sAwz8h9Arv1pofzgkQEB6uR9UZ3arxD9rRivRz9WXIwFz//1emdHl67Td/2i6dfxPSGNXRdkNrtBUmkuCf9fTjucsDtZU1o1KrtSbL5aXJyGvFQyfdk2Jn6syEVm35N2/iK/IRKU08OQIK8UnzWzrO/IR+KDlLQAzmTqYkjccO5jV465HGuEPlyMAqG39UHyJQR3H7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnqsdnnnt3TOs/yuWzPSK+7GVfE+3jE3HDNBZ5NOzNo=;
 b=e0HHl9+TUutsx3cME07LMjfLTxExqrayCzMcShnOjmezxgRzBQUYEYjx0Ben7U3U/9ez8sLX18UF1L9Mp3D91E4h/LMUK6aUqTZOJZNhLE97yUH5QMnmqI0oeD30irnX63Hpy/XWxgp+lQgjvIKBMFOq8LVwI6g7gMfSKA/yNjxLpvgF4ZDDIbgQKTWvL5LzPKfhT6XgoSd6R51DxJDBBkg11mEW7qPupInC9TACx3e04iFrzp77gdAn/jVTlie/T6bB56dOP0hzgCtvyFEpd4cNWODTbkQsk7PF2ORGRZKCgG3SiUIJ88nPWBWbWnFmO+4P5TGjW8D5WO78rEKL0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnqsdnnnt3TOs/yuWzPSK+7GVfE+3jE3HDNBZ5NOzNo=;
 b=isYWuXhrMnEuQkK1ev+plq1JSxs/cmRz0aAbDNzLWSCf0bE6yBsNtwNYjjgCZ2EcRA63warhcCRq+kZTVEwvXOok8U6gCEzHZjW/Szm1GqcWLsR3HjJBQsURDY44LL6Zw55TnX1mY3xejBTsxDiu5rKmUQ/O3h2oJjwMQRB0rak=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1696.namprd15.prod.outlook.com (10.175.135.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 07:04:12 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 07:04:12 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 03/18] bpf: Introduce BPF trampoline
Thread-Topic: [PATCH v3 bpf-next 03/18] bpf: Introduce BPF trampoline
Thread-Index: AQHVlf+GPFlfAbcaPUWM9PNtedqB5aeA2XMA
Date:   Fri, 8 Nov 2019 07:04:12 +0000
Message-ID: <921B7346-5B86-4ADD-BDC7-B1BA35F2476B@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-4-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-4-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:180::c4b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6140f279-7199-4496-ba8f-08d76419dc3b
x-ms-traffictypediagnostic: MWHPR15MB1696:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB16965BE306122C28A6E90FE7B37B0@MWHPR15MB1696.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(376002)(396003)(346002)(189003)(199004)(446003)(11346002)(2616005)(5660300002)(25786009)(256004)(486006)(476003)(86362001)(71190400001)(71200400001)(36756003)(46003)(54906003)(4744005)(6486002)(2906002)(6246003)(4326008)(8936002)(305945005)(53546011)(6506007)(478600001)(316002)(81156014)(76176011)(186003)(6116002)(102836004)(50226002)(7736002)(33656002)(6916009)(8676002)(66946007)(66476007)(66556008)(64756008)(66446008)(14454004)(6436002)(229853002)(6512007)(99286004)(76116006)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1696;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lnjNndzNgy5K2oYEsJ2Kefd8R5jtPcdhUvWwKfHNtZJT4sF0omy/1Bi6wrmtyf4mxXa0C5v2ZdO0Xn8NcWIw8qxe1smXpdV8SN0xTbQVZr59TL3F/LbdzQoG3FAye24ULmzs3Rl8bMNdoDVW3ms31hGO9alhTNrPaet0CZi8smkKg4tHUiXE/No/+YSsjTYF7/pXMNCG7rFNQ2W2XoJVjJXClE5346vLHHGLzKRszq8NHtFbLJ3gtu+s7PGEWQsDmN6PO09bg3/5azCmOJsu/3xSK3oHKFytcH7aZsiUbQA2g1SvzUVY7CQ79IFfqsdFyv5+4YMrUAPSFVTFyCnJXnpRYGiPqoP/29V55IsldkQG7uMNY6EEQS4rQXgSG1PHmhxJjLPNOrp8Y3qy0yGJxk/F96qmE3weoVfAnSyQtgIPbsky38sJo1BU+n8ozyP4
Content-Type: text/plain; charset="us-ascii"
Content-ID: <35873FA5619C9C4DABE2A93E342BF31B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6140f279-7199-4496-ba8f-08d76419dc3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 07:04:12.6047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fwsPER5Eh4jLWx6BrCI40ehSl78L+c5Vawbl+qtC4In3qEtyLu+90RKdHnfGuBpgi+0H+tyvAL9hRDsMNqSm2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1696
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=569 suspectscore=0 adultscore=0
 mlxscore=0 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080069
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:

[...]

> BPF trampoline is intended to be used beyond tracing and fentry/fexit use=
 cases
> in the future. For example to remove retpoline cost from XDP programs.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>



