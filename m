Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81CA323284
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhBWUxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:53:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29270 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234530AbhBWUwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 15:52:24 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NKfUpg029459;
        Tue, 23 Feb 2021 12:51:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=V2zBGnkFCTuVMBWQZEs9H5NQzVEmKEglsXSUsDktdKY=;
 b=DX4FSjQfq5FXxSH+iGc1x7WsRJ3hkyWeFB4TIdypkpGCHPF/jxpAG8R8fD8fTPe/DGsG
 hxjZZ6E7hqY4EWgw62bDHzQHhgRt2GA4O2SrcjKF7KZYFvuakgrjx7XVkCoEnhO/5tmo
 DuZcDOJSjIaUp3SknYlLrYUtdS5fPOuP6xc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36u14q8f8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Feb 2021 12:51:29 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Feb 2021 12:51:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kc8sKGDKgIYHSHJvaJLAbXv7RosWO2x5HarX8XVaKJPC/SESJQp48IuhOcYejTs7G/JXi8VBHAvBeSciDdqdEpXGG2wy1/wItw+QM9FZxyZTUhlYmJCcLxZntfITA6kwNiLCDye/Qy8sDOmbdm6WrZSznMY+aiugIUH58tqaxisy6YT9Yv/QMlyp4KTAnjqo7dnhglftmDDbkZmU6jUTygZQmlq7/Pu+3mzVJPcKe13CDqAKf7GWZn4Q73FGQKoYDekqgBzV0NUkCLjGIejzFRjVP8nxr4Efdfgxua+0krSTnP4OvcLIhbXAOe2Sow1sO1Ae/TlFemC3JKc4LNBs4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2zBGnkFCTuVMBWQZEs9H5NQzVEmKEglsXSUsDktdKY=;
 b=LqgtEbp1cFaqEUUK3IrcPx6WQ8DkCoCL96SIIoPJ5oRJmGvOTCiKurSlHFbUdu4qxj3nPYfWK8F0RyEo10dHuLQ+QjxCC3kP9edaT/fBTxkK99yiChxKe+sZlWva34kY5yXbfmsKR8RYF/Bt1uzqr7AdjpYgxH5RBhvdhwFj+/U8IuRkNvuA3FfVJOv4gazj4P8V4gzGw7h/Q2y4VTtlQhvHoqSjEs67ZYZQ8W4IRTcqX+ACWBS+0gB1Hbf5z/A5etVBBC8ZjojMR+mjzXFxYKCP5GT/7fx83j7vGSag7TVgsVFEFQAB4cw2Z5g34/8llt+Ckqu9ycL+BB9t+QJUig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BN8PR15MB2995.namprd15.prod.outlook.com (2603:10b6:408:8a::16)
 by BN7PR15MB2483.namprd15.prod.outlook.com (2603:10b6:406:87::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Tue, 23 Feb
 2021 20:51:26 +0000
Received: from BN8PR15MB2995.namprd15.prod.outlook.com
 ([fe80::15e7:9706:a9a9:c13e]) by BN8PR15MB2995.namprd15.prod.outlook.com
 ([fe80::15e7:9706:a9a9:c13e%3]) with mapi id 15.20.3846.041; Tue, 23 Feb 2021
 20:51:26 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Martin Lau <kafai@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        KP Singh <kpsingh@kernel.org>
Subject: Re: [PATCH v4 bpf-next 1/6] bpf: enable task local storage for
 tracing programs
Thread-Topic: [PATCH v4 bpf-next 1/6] bpf: enable task local storage for
 tracing programs
Thread-Index: AQHXCYIuKEHXcKCMU0m4MKXErpSFUqpmH7aAgAAYkoA=
Date:   Tue, 23 Feb 2021 20:51:26 +0000
Message-ID: <CB9251DE-7372-4AE1-B758-528DFA22D515@fb.com>
References: <20210223012014.2087583-1-songliubraving@fb.com>
 <20210223012014.2087583-2-songliubraving@fb.com>
 <20210223192329.lutwo4ols75ut5ai@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210223192329.lutwo4ols75ut5ai@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
x-originating-ip: [2620:10d:c091:480::1:8f65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3df1488-692d-4087-159c-08d8d83cc9a7
x-ms-traffictypediagnostic: BN7PR15MB2483:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR15MB24830C5E746B77D0545C33C5B3809@BN7PR15MB2483.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2F5DinzBJfvvVDud3bGQ5ndcN2MpVyOLA5eIvzSA+ASuUfIafJaH3oGAel6E5G01/gVq3OX//p/28xGIRWSiy+c9OODC9XcPX0wJY/9DUBwMg1cjQts2few5vqNxpvAq+ta7JqpZg219ZZbkh4GRpsD2b2u/I7ZprJBGEVSBtHFMkqpJkefMRcbb/urMs8RmivA4Zk2Hb+Q3f4l9jlwEURdF11vWE3pJC2slaZutQEgUCLaBhP793eMB5/qBF1Ip4sH4f3DZXqtjSJbaR4LZfOW+ZoU0Q5lrKGgaD4zwUHr/Q75/LRBwTyrlHQ0sUwcO+R4rlNPedPbrNSrO/qA4jvMY1d3pOv2rwYvM4JgHwwbgImu4AIorDpbO3BrrgjLWvluY4MiUeMMpORXANFTbww9lCr3FFSadwhg6YshrDq6WLzI+yO359YzubxSguS3M4bLe2RR71zJ0+vAWDnaMxyAd/eipVHcNFMeVMpf4MEzP5+3gIIS7L1diFl2SOWOp7IlY157JYY7W1534Vn6i8Sc230P3DUazji/uI4FZ513zTHtDEJGADG3NAJqOwumzZv4Kjb8WKVrlnRXkLQtwvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB2995.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(376002)(396003)(39860400002)(2616005)(36756003)(6636002)(83380400001)(33656002)(64756008)(316002)(66556008)(66946007)(91956017)(66446008)(86362001)(6512007)(76116006)(6486002)(186003)(4744005)(71200400001)(66476007)(53546011)(8676002)(4326008)(6506007)(37006003)(54906003)(478600001)(5660300002)(8936002)(2906002)(6862004)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vrBHtMz4odFI7l4h6dcQ39e9MQzrTrFqacLC5Lq9UCY36wlYVqmagJJXLO+t?=
 =?us-ascii?Q?YIhZNVhZ4anxmHWz2rDhPd1oiX1dLLNavFnH4FgIiHIOY6ybRRtGgIlY3CU2?=
 =?us-ascii?Q?M/uWOuH25klD+Fvk+OB/Qvywwrwum2a4TgatBD7+wdE32v7963i0GazvgaK/?=
 =?us-ascii?Q?gIdAgMKeWgUI0CVaxWc7qTkIRUQ3DErBCfFn96f1m0kVw4Kk3Z2pGU+Ym10x?=
 =?us-ascii?Q?9VOmcZySH0A1lXGCbWqB+xVIfR2kQrDEtYx+BY/K5sduunjsY2N7z//FH1k3?=
 =?us-ascii?Q?h4ExV87GKusRDuaafFcht09bc9ITuIaySqkPUerBfmvwCiLXIhMwTB2KEhAc?=
 =?us-ascii?Q?jbjK4t6EFKV7yRHYK+7D5YubRTbhvEvh+nELrr+VUFNVhyTDTmVA+vrsIS5O?=
 =?us-ascii?Q?eFQAs2D/SCYw/Nn4C2cMVqm6rlkMDGEAx5mbAiBOq78Vkf2WAqKnA6tpQSe5?=
 =?us-ascii?Q?8ToPK3Wt8XP1aUgtCv0CMtn5bGxbh/au4vkTAOmVY2iVzsHH4DH8+cNCmTVN?=
 =?us-ascii?Q?iusN1iFFINCaJY8SuCa6S+48RgULW4dITnyZVYEKJtUCeSt2WTCHak5iXEw/?=
 =?us-ascii?Q?MDUdgozWg3OPPp9LIVoD5OVUyQmXurm+202+zsl07jTjmsHoz/TwYxS2dwcQ?=
 =?us-ascii?Q?OFgS8RnZKxtIJQS/ZY5nrB2ZqEWoBa7c/juYxB/3IPpJaJ41CVBXt2HLiPS4?=
 =?us-ascii?Q?Ao+qljgEQmxkj/JU7YEhzoTAz7OxaubLPMLt/gz10Csa/6OqKiTzl2cHaFe/?=
 =?us-ascii?Q?Y6KfKkINNKW5Q+CZ3LJOxoXLWaryFF03ipyZhZnDQx3IQF+3AR4N0erU5eEt?=
 =?us-ascii?Q?D//8Kkh8MIVi2m2cgudiwC+Fup8ULW2HGNGi2kIn+1bVLbyikktA5VAfg41z?=
 =?us-ascii?Q?D/sPmi/VWsxvY5Dztjs1Ik7UCMzRpS5vVDBRiip/AA4ABJfyzZIHaWvlDQmI?=
 =?us-ascii?Q?lUTbNZibjcGIaQ0GbIgkYRi1NbAKQ6nzzxprQwDLaS28Jh//N27ThxGe5qC+?=
 =?us-ascii?Q?32D2IhN0yacL3pGNwgCMHvHTbDI5cZ9QWjZpYI1+Xuko+4fce9lEKw3N/UEH?=
 =?us-ascii?Q?K3tW57wmIO0ZQZsuJRcgi0/6sCBNwd8V6UzX826RDeWmsArLIthZaXYoTua9?=
 =?us-ascii?Q?2nV/JJHCRQ+UJNeCOsWPYojiOz2DknciJXTNq4cpPb+eQRF0oHeORJHpoPTQ?=
 =?us-ascii?Q?103BbvJ+xNjMJmwgbaQwrqx8g7sr5u3RvjZouIRBc3rBIO8q8ncBP5rAGy1N?=
 =?us-ascii?Q?qOnkWqzXL7KP/6n1C06gGYUyCLvP/S7wk/5N5jkk4IQuCD8WH+J9t+vtPgvi?=
 =?us-ascii?Q?3tPfFQpgqhKybGrgjDTLuaC/Fz+e0jym1YavdETXvNUSdJDnusgu4bDjXd0q?=
 =?us-ascii?Q?eqL3YkY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <52B24FA9B43667458AFC19BA136F6FD9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB2995.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3df1488-692d-4087-159c-08d8d83cc9a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 20:51:26.4623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q2WyHVMrPygS3WaP/APtbjH3Z/4Sd/K/RaSZlKIhVeTPQTf2ldShgH7AGHtzsRTpkbeTu+3bu6YvIf1oshcFyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2483
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 clxscore=1015 mlxlogscore=967
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230175
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 23, 2021, at 11:23 AM, Martin Lau <kafai@fb.com> wrote:
>=20
> On Mon, Feb 22, 2021 at 05:20:09PM -0800, Song Liu wrote:
> [ ... ]
>=20
>> diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage=
.c
>> index e0da0258b732d..2034019966d44 100644
>> --- a/kernel/bpf/bpf_task_storage.c
>> +++ b/kernel/bpf/bpf_task_storage.c
>> @@ -15,7 +15,6 @@
>> #include <linux/bpf_local_storage.h>
>> #include <linux/filter.h>
>> #include <uapi/linux/btf.h>
>> -#include <linux/bpf_lsm.h>
>> #include <linux/btf_ids.h>
>> #include <linux/fdtable.h>
>>=20
>> @@ -24,12 +23,8 @@ DEFINE_BPF_STORAGE_CACHE(task_cache);
>> static struct bpf_local_storage __rcu **task_storage_ptr(void *owner)
>> {
>> 	struct task_struct *task =3D owner;
>> -	struct bpf_storage_blob *bsb;
>>=20
>> -	bsb =3D bpf_task(task);
>> -	if (!bsb)
>> -		return NULL;
> task_storage_ptr() no longer returns NULL.  All "!task_storage_ptr(task)"
> checks should be removed also.  e.g. In bpf_task_storage_get
> and bpf_pid_task_storage_update_elem.

Good catch! Fixed it in v5.=20

Thanks,
Song

>=20
>> -	return &bsb->storage;
>> +	return &task->bpf_storage;
>> }
>>=20

