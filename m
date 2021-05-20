Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27FA38BA89
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 01:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbhETXq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 19:46:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24954 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233104AbhETXqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 19:46:52 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14KNa7pO022420;
        Thu, 20 May 2021 16:45:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=KxsKnpoO/clg1pG2sFrsBo7sPq/fQk/hjlIzVM90hGk=;
 b=JJMaInxZwra8ilwJ3VEvEH+jCah9vWyGKeF9J+hdkJpQGHouOh5k/4+W+xEoZPmaqw/S
 kkyuhfz9nhMdVf9MJVPxZ8OmV5aWaW4RcNDCTXD5NQ0kRavdYomN8TS4LVMJC6eE9tHk
 awXRNZYaKqC2UcJl42W6m8OGDDmGN7Mtk20= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38nntr4upc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 May 2021 16:45:07 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 16:45:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3PX5FbPjL8/K20KzD9a6rbqHTW7bMiPHMt4SH+4zaUTIqqj2seQVpFUG4dYTGWYF3YlWfjEQcxLGz/PTQ2rr1RQhbGm4z/mfD+Lt4E6wBKuS3AuT+SSk/JPUwvIp+je+HowkOMAy3whFlWZycWCPPUFYLYpX+lnOZScuG2322/8TT4WLHTd0B2RcYnD5cOAlp0a7nlGBOzikqripoZB7Lt0NNJHmhaMe9BrS4JOOmykuVnV+9IsSNp59dRlGan1nKjnYpkiPijw11Po3BbEvHJPffgQLLOQKtXuUVzCWAzJxHV8bZ7g+0UqPcvs2MuIBdtpvIX2TPEJPDH0sX9Ppw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KxsKnpoO/clg1pG2sFrsBo7sPq/fQk/hjlIzVM90hGk=;
 b=Q1IhAc383PNIDYONX+ubDY3BJqm3hQE9Jli8z5IpmSHRvKqxwv8L2lQ5Tw48pPkwddn+3dgulGfCjxE1mJ5BtGo93DXYJiSgNVdMbVmCZQkzh6l9TkJmS2BgytxNDSuaaGHmBnu/Va1npjzMKjWHFhREpWFtnZXB4LRHEXPv2WTxyDa4Pnr+OgOXoAquYroO4v9axv7gdZVfMxDs+lzFstF7Fvc9NOvEI7POw29ssTmto/IC6iSxpaBcrblugGrmquf9/vMCEGqZ4WZFcV9TadhlqKeYQX2CNRY+zHQ5neDaL3h0S4MMqKNvjq+wxBU7m0mq/YdR53HLkBQE3dprhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3256.namprd15.prod.outlook.com (2603:10b6:a03:10f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 20 May
 2021 23:45:04 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 23:45:04 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: Re: [PATCH 13/23] io_uring: implement bpf prog registration
Thread-Topic: [PATCH 13/23] io_uring: implement bpf prog registration
Thread-Index: AQHXTLk8zkjzYkgRkUicNr3AoH9hg6rtCtyA
Date:   Thu, 20 May 2021 23:45:04 +0000
Message-ID: <E5C654FA-1F38-43C4-940D-80563A3B2647@fb.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
 <c246d3736b9440532f3e82199a616e3f74d1b8ba.1621424513.git.asml.silence@gmail.com>
In-Reply-To: <c246d3736b9440532f3e82199a616e3f74d1b8ba.1621424513.git.asml.silence@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:fa93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a802c2f-6caf-43a5-1ea5-08d91be94ae5
x-ms-traffictypediagnostic: BYAPR15MB3256:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3256D25246637CEAEDB98138B32A9@BYAPR15MB3256.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:392;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d+VqJeKvN+rjohtpfOdQ6qQX6fx7upLn4N8VQ1TOCLyDWgZvkoXfMV6rihkXL2iXJZtDdpxDQTnDwc5lMEWvU7BPSV97X0Xv6zgTeaaylmKt1KlWvmDLXSNAMPLDYbgJ/7Ye9rRPIAdQGN3nyJUSxP5Nt8tv0E0XXp4NHWfAGkZbRgXOPP5F3JsR+nSOoe+gRfzTmaJcGUgodjvSIIXca9hxhfBs+py9jMnqhvkfp+Jt/Uk6P8QQEn6+fDrvjXkHAe8lmxK12v220WnSu1lcGA1lvmDmfEA8PAcMBV8AwG80byIRGd6GiIXuUfzz8gDC0ONKL+GuSBNbuua/dGcDAmIIOIh8p2v8lCs7ZB0jx5RZn77UwydGq9sZjdfJ11+iMkJeVvDeGqavK49ahXoNAhGNlQVisMoldsak0r5+ooppxLof7Ydisfr1j5J6OuxHmVcbq9DsT5oRjaRHAz0EJbFPZShjSVBiUR1fgPrdQu/gu7KzCQlUZ03uck7H/OQ3/A3ndHyl3yxCyxto/s9EquXKN+nSMJJ8bfB15wKcb5fKliqmXBFomB2g9zrBfLwSca1LPvu9anxbPPLLxFeloyCn67uPK2rJs7otsU14hqVJTyr34Z7LGM3RhhOSp2AFMEDA8DlYg6WPGs+s5aEUrCz5XhkCMuy99I9Wn22Hc2o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39850400004)(33656002)(122000001)(38100700002)(7416002)(2616005)(71200400001)(8676002)(36756003)(86362001)(8936002)(316002)(4326008)(4744005)(5660300002)(6486002)(66556008)(66946007)(66476007)(66446008)(64756008)(91956017)(478600001)(186003)(6916009)(54906003)(76116006)(6512007)(2906002)(53546011)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?z8RcDAv5qkgzW04VHZMH3A2cv8ifudmQv3oN7PaZSXFLvcrjcAHsRAq7z1Za?=
 =?us-ascii?Q?lubEW71jufb1oxWHa50tUxn3z7jdGdd01QuM8GIZdplmNgBCYYiX74R0fkJX?=
 =?us-ascii?Q?xSZEmgrrrfWbRf4ChWm3RQN2GqQn6DUjfotDiRwz2mf2Yp1Cn+S8+QSqxsdH?=
 =?us-ascii?Q?uF75W6a4lqxmoEOUsLqxYsw0HRK1tNFYLCs82E3unxPjtxLPehN1GxU8TjJc?=
 =?us-ascii?Q?OZkxSwPZCrta/bHJV7beAobdtzqYJwisY3PqtJS0Lh5zEzGxdQx0A8VJhbNc?=
 =?us-ascii?Q?/frRfU8N/EQfoiyvAnxgtnQdV3Jm4u+pcIuN9YNdwyrGq6QiKYPriLSQe7u7?=
 =?us-ascii?Q?NsVR+VsWZqLCu4OKQk6PVPFmPIVBPgFofHUiRqTc5/WABv0mlInFFc0adFdm?=
 =?us-ascii?Q?KqBa9caynwfUMH6i+uSl3KqJTYk/hKIhoLIQa7v04Fc6qcpCPKxB8WMRgCQk?=
 =?us-ascii?Q?Lft/ORS+2hCHx44bvosXh1kico/H3CZMv3f0eCZtiFavWL2i7C/4tBPEzt23?=
 =?us-ascii?Q?SHpMdKDZ4STc+89WaMoKNegYH1PiFKEnwAhxPI02+DMTRfSw3BtrhPFuipaH?=
 =?us-ascii?Q?pNwlJVNBm4oPeiKkSVEnnXtRhnmWJ5AYe7EdMWqg+Z0QN3ily52PpTQEUsl7?=
 =?us-ascii?Q?e/uv/8Mi8UT//egd8prtD2uwZpdVFpYoX++PDFp5Y1WqK6ea5nacytETK5Vo?=
 =?us-ascii?Q?WART/JdvxloYmn9nOF/F2S0jJonbVep8dGreoqv7+DYgZX9FWjJx/XytcGMS?=
 =?us-ascii?Q?JVWwZJw5lepHCgPRtH5CHtxV8QKjuiwBXDUYhMMe+2Sb3THY1MIfyA1ipStd?=
 =?us-ascii?Q?95uY6QzuJGhGn/yL/MxwKXPR2JB3pXfBPFnicaMHqieW2kaRTzjafYb31GXN?=
 =?us-ascii?Q?DSa7gtiX8PnLl+9Ix9adj70Emr0IrxTey8a+ba67GirVaPkJGpJRaSf8Djyq?=
 =?us-ascii?Q?GPnV2G8o3de5Z6ry3R9hDVmeGBsQopAOSsALjcbbePC6x8yKc2A07Ab4iDUH?=
 =?us-ascii?Q?/d750ALYt/jmcIUAh3ltgMTJLzM/e2pn7kK6n04TEulNTFVgu3SFY+UEDvW6?=
 =?us-ascii?Q?mNBRTGV1kO4amun6/SVkB4oEnqRVuP9X/v8ovC77je+ezylgbKWqD8OKu0YH?=
 =?us-ascii?Q?2VQj4RKcMCGNtE29erye9DJ+WCN4jw05xa2zScdqxOC0BH1Eq8KOEzerC4mV?=
 =?us-ascii?Q?te/vmEL6QohmRLGeQrWAF/9t5YI+DvgqMQSOyWsUf/a9e/YbHvuVKwX8zFey?=
 =?us-ascii?Q?5OeStSGLQYK0LQ5aZF4sMzhQ6BTvMvOm/4u6Pp1Ra1fzfAdXA7VUhh3ZzRif?=
 =?us-ascii?Q?zRYbNFFsVbd4CR79+2PS6gFrUnP/iyfs853GH71ruL6/xZ1gSkqFf+9Bpcwn?=
 =?us-ascii?Q?STNly+k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <52EFC524896D104DBB408A697C8C1E36@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a802c2f-6caf-43a5-1ea5-08d91be94ae5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 23:45:04.5366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pWjUySmT6J4r+/A+7QLGA+xAOpUptsE2X2YrC1RAJtxTXPSHAwb8R4myztbOCp0n0UwXHzzr44ZqS0qF3msKxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3256
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: s82cwcl-7wmUBtkqG_lEkFTpbmk2fny2
X-Proofpoint-ORIG-GUID: s82cwcl-7wmUBtkqG_lEkFTpbmk2fny2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_07:2021-05-20,2021-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 malwarescore=0 suspectscore=0 bulkscore=0
 mlxscore=0 phishscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200153
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 19, 2021, at 7:13 AM, Pavel Begunkov <asml.silence@gmail.com> wrot=
e:
>=20
> [de]register BPF programs through io_uring_register() with new
> IORING_ATTACH_BPF and IORING_DETACH_BPF commands.
>=20
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> fs/io_uring.c                 | 81 +++++++++++++++++++++++++++++++++++
> include/uapi/linux/io_uring.h |  2 +
> 2 files changed, 83 insertions(+)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 882b16b5e5eb..b13cbcd5c47b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -78,6 +78,7 @@
> #include <linux/task_work.h>
> #include <linux/pagemap.h>
> #include <linux/io_uring.h>
> +#include <linux/bpf.h>
>=20
> #define CREATE_TRACE_POINTS
> #include <trace/events/io_uring.h>
> @@ -103,6 +104,8 @@
> #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
> 				 IORING_REGISTER_LAST + IORING_OP_LAST)
>=20
> +#define IORING_MAX_BPF_PROGS	100

Is 100 a realistic number here?=20

> +
> #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
> 				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
> 				IOSQE_BUFFER_SELECT)
> @@ -266,6 +269,10 @@ struct io_restriction {
> 	bool registered;
> };
>=20

[...]

