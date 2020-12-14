Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FE32DA372
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 23:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441065AbgLNWcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 17:32:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22534 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440920AbgLNWca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 17:32:30 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BEMPMJh016557;
        Mon, 14 Dec 2020 14:31:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hsD4+QyIj9YPGG9zC2UdEBM9rIjgZe1DB+hhl2vyeUI=;
 b=NS1dWnU36MWn9T7X2maksEBap4cV113kIICnnGb8kYeB+30W6sUujL2qL3W7NWIHmyP2
 2KTEypYrwOW86Ng4ophOnJyJCtkgVfd0516lsClR/O1LVi1c9LJXMUYzmMWx9Bj2K9Gm
 LlugWJekPBJM8/KVDeHEKYkckh7ilaOVfEA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35desu7gbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Dec 2020 14:31:30 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Dec 2020 14:31:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVhxoq2rnJ0LTo+I/qlMXbpivMYr9YDz0sETXmAOyT3/Z1mGXFezlLOJnuFnCIyo5DaK2QAzZDTC0EFpxL24kvt2Ut0YzLiXyllKmiTiOnv0mJLaRkrjyEbCz2ymmampjpDO0R/BRPdPi+pSmaAD4pQXDcSffkMDP00pk57YEcU0wII4V3IfskuH77FTXLd/Kc6xQjMwze7/LyB1m8joZM7S5YvEZ9wqt+Rd+W+xA5Mr+LsUQ03P2vN2Yg5O44LYpU1hUSZjOcdHAk+3E/yCxekwp3JlpLCG5v+OWVM7uZS0YsTcROwZ1tuBmb2D80DAzASYylPi9ItLEzuMhYTjGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsD4+QyIj9YPGG9zC2UdEBM9rIjgZe1DB+hhl2vyeUI=;
 b=YofJhNihpox5mK2eIBdlgqSs/aAv5OAr4Xli2+4orpTtCHT7lIaE+fnsvmMZL6JACXhQ6aiQvSbnvZcb9HH+XG2SN9NORgG7vfQVYL+pc7wgncqBLl0ntqLZtYLYC1jfQ+5o7hT5dW1efRT5wRwkWzE4d0Pr91UEd+URvffp3dNY6eIW3zMPu5o4LhYD/xrKP/twnTtBwSSKs5b7w0tnOzGDrXiZnK/n9CJszdHQpqwbywLcbZCPoCBzdaKVOY/62YxmQjuvxC8j0Yta8pFOHi9siQ0VrYNZL7hQURkWyt0plGtbGgKoUub4Pgp8HpVl4KWmDSoMLUOlKpmoR0Y0Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsD4+QyIj9YPGG9zC2UdEBM9rIjgZe1DB+hhl2vyeUI=;
 b=OMS6S/t4dGy2jL6WaO+KwR8oaZJVJmj4TAU1Zn7Rk0W8PUefgBo38M9HEAI/6/BxQdpl7cxfEuQfnEH16aXoTXpSnfZD5s3/F/ojn+zsgXUdetexoPsaTU7Fq8rTSzaWqe1lu3qczZ3Zc8Mw3Y4LTRH9DyTdWjNOrNaUSdnMsZI=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2325.namprd15.prod.outlook.com (2603:10b6:a02:85::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Mon, 14 Dec
 2020 22:31:27 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 22:31:27 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Topic: [PATCH bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Index: AQHW0DFNJTOqP3EvakKTkVmHEnfoS6n2MOWAgAEAboA=
Date:   Mon, 14 Dec 2020 22:31:27 +0000
Message-ID: <8CFC68B4-B4AD-4FDB-96ED-0E1E24C08F22@fb.com>
References: <20201212024810.807616-1-songliubraving@fb.com>
 <20201212024810.807616-2-songliubraving@fb.com>
 <ec9dbc75-84e7-45fe-65ab-5b0b6d86507a@fb.com>
In-Reply-To: <ec9dbc75-84e7-45fe-65ab-5b0b6d86507a@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-originating-ip: [2620:10d:c091:480::1:e346]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 980689a6-e46a-4b6f-f7e9-08d8a07fff59
x-ms-traffictypediagnostic: BYAPR15MB2325:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2325922ACC954E5CA9101549B3C70@BYAPR15MB2325.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xqFjm1ybsgicEF5o2A22PCH8RIAZDH9QC+PFp4fy/EefD2z0ry8lD6EhUtUxu+1dGgB3YpRDhHoZcZlC/0y32kKHJoPNm8Od9TABKlBYvkaWOfFcj78BpxFUeBxdHk6BL5rD5A/HL+eQZI8MNy23gZ/3FWgW8CvCuI1I0MIOYrWyMNPzlw+EFgyjbANBmVLnnnK+LTkD4bRfOWfiPm2h46UBepy6bNjbRdsgDaKNKS5HUZUJEXHft4h3Zk0w0h3wbxlRH+WpUrJmi2AdKREM6LWfcXBrxgdqlKBDxr1gfVsYZe4YnPBGtGN9pLP2nWTC5B3uRUCkdMIRkKdBiUmpVIzn/ktUYsY0xWBexHhCPE916zjABcfJxRLoVCAxwenR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(376002)(36756003)(6512007)(37006003)(6486002)(2906002)(5660300002)(33656002)(8676002)(64756008)(86362001)(4326008)(66476007)(66946007)(76116006)(66446008)(6862004)(91956017)(508600001)(71200400001)(54906003)(53546011)(2616005)(186003)(6506007)(8936002)(83380400001)(6636002)(66556008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?M3jKSpZsM4TmqgeYLs2oZ1MGHxSM8MdRENw0jCmls2iA+hHH5+rMmGx6pU1I?=
 =?us-ascii?Q?qq9nPpFQdnni3sI1Vi2zCP4eR0yj/BLN8dtv7f7n23sXgJ+9VK7kjq2fvDiG?=
 =?us-ascii?Q?dp/mPZBYQXCb8oLvvuPId5zMnQuGn7zTx3UFicOfylwyTctbuDClpbhIRl9r?=
 =?us-ascii?Q?q4C1hGZjFTYN325/WI+xVBJVrYYCCX8vuonMSMZuCS2/spFUvIA4oA7jD0i9?=
 =?us-ascii?Q?eQjBB13wt1+zCrve704Pv2MH2nZB0tp6TWGRLqyxGv6aubbpsoqFwlbR9Sau?=
 =?us-ascii?Q?Buya5wRTiDaLB6/cm/u6VOOp7HR646UBCYGkV2R0R3QK6gukPQQiK9+A+Zzm?=
 =?us-ascii?Q?hTcUPbiZO7T1ylwHMbj8lbo9PHaRMvISI6PTsoH5H2CO6IuOvxdVOseZf/Ka?=
 =?us-ascii?Q?Qjn/xkYQVkB3iw6dqwQkqzBjU0VNDrm33AX3PtMZORWuuesqB1CQkszMC2Gd?=
 =?us-ascii?Q?6KuzWGOycXDQUR9+d6HJcjH9Ft4O2R2Hx5FF0VZUofVesNjgzSsh057XCy6G?=
 =?us-ascii?Q?qnLPYeqAbZUBn8JpHu0k+A5Z4pqmMaK2CJMTLuyimThQnoe7e4fWdhtrK3uH?=
 =?us-ascii?Q?9NmJV+d7CNNCgXrwQcQO+FN856YFijJlwazceWGfi+oDl9iQTwuj8uOuV1bf?=
 =?us-ascii?Q?ipEy7PM6pGSmGbyp3Odgx4c+plIsxrcL1GdFQLDd3B/eHRSa8kXY+C5OEFgL?=
 =?us-ascii?Q?3Bxz4eVhHhrmf1PXAjSt1dOzZfmy08YgzE4Bjqy2UyR1Zu9R62nSnSfIpZ34?=
 =?us-ascii?Q?6ak9Sxsw24l8cOAc2JL9X6VdaxcSL40+lgMzV7UIvt+RqW7Ma0Nw4M0af2c8?=
 =?us-ascii?Q?rCqBEmDg4IgrbHaCJUmDUnQzm+LlcyhE3SthWAndbfwnAfsKNIwTgBjwxV8C?=
 =?us-ascii?Q?ohWgWSj/FwsKjRAVPRt9YkV0zxJwogvOQzz8T1JuuIwZnY19dQJnhoEyg5Oo?=
 =?us-ascii?Q?nVUloyN9qXPXOTdXuZV5pe5sRdDRCOwcemh/v/9vLij/ocg/aXSn3kHZkx8a?=
 =?us-ascii?Q?/NcwHVdgKgNCpsnVj2IhQZzvYvN5CAV5e1Po7GgA7/avrnA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B1440A48C071D40BF8D80FFC870A841@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 980689a6-e46a-4b6f-f7e9-08d8a07fff59
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2020 22:31:27.7262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saCBq/cEQ7pGalBBSvwpGeyPxhMAAYq+ClQeC2YcmsMDsRxk3dCDNWH/FD/Hvdx4jQDakQkJJNwCBKbK5Dw+Kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2325
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_12:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 mlxlogscore=999 phishscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140149
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 13, 2020, at 11:13 PM, Yonghong Song <yhs@fb.com> wrote:
>=20
>=20
>=20
> On 12/11/20 6:48 PM, Song Liu wrote:
>> Introduce task_vma bpf_iter to print memory information of a process. It
>> can be used to print customized information similar to /proc/<pid>/maps.
>> task_vma iterator releases mmap_lock before calling the BPF program.
>> Therefore, we cannot pass vm_area_struct directly to the BPF program. A
>> new __vm_area_struct is introduced to keep key information of a vma. On
>> each iteration, task_vma gathers information in __vm_area_struct and
>> passes it to the BPF program.
>> If the vma maps to a file, task_vma also holds a reference to the file
>> while calling the BPF program.
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>  include/linux/bpf.h      |   2 +-
>>  include/uapi/linux/bpf.h |   7 ++
>>  kernel/bpf/task_iter.c   | 193 ++++++++++++++++++++++++++++++++++++++-
>>  3 files changed, 200 insertions(+), 2 deletions(-)
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 07cb5d15e7439..49dd1e29c8118 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1325,7 +1325,7 @@ enum bpf_iter_feature {
>>  	BPF_ITER_RESCHED	=3D BIT(0),
>>  };
>>  -#define BPF_ITER_CTX_ARG_MAX 2
>> +#define BPF_ITER_CTX_ARG_MAX 3
>>  struct bpf_iter_reg {
>>  	const char *target;
>>  	bpf_iter_attach_target_t attach_target;
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 30b477a264827..c2db8a1d0cbd2 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -5151,4 +5151,11 @@ enum {
>>  	BTF_F_ZERO	=3D	(1ULL << 3),
>>  };
>>  +struct __vm_area_struct {
>> +	__u64 start;
>> +	__u64 end;
>> +	__u64 flags;
>> +	__u64 pgoff;
>> +};
>=20
> Probably we should not expose the above structure as uapi.
> All other bpf_iter ctx argument layouts are btf based
> and consider unstable. btf_iter itself is considered
> as an unstable interface to dump kernel internal
> data structures.

Yes, we can keep it in task_iter.c. I moved it to uapi to follow __sk_buff
pattern. It works fine in task_iter.c

Thanks,
Song



>=20
>> +
>>  #endif /* _UAPI__LINUX_BPF_H__ */
>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>> index 0458a40edf10a..30e5475d0831e 100644
>> --- a/kernel/bpf/task_iter.c
>> +++ b/kernel/bpf/task_iter.c
>> @@ -304,9 +304,171 @@ static const struct seq_operations task_file_seq_o=
ps =3D {
>>  	.show	=3D task_file_seq_show,
>>  };
>>  +struct bpf_iter_seq_task_vma_info {
>> +	/* The first field must be struct bpf_iter_seq_task_common.
>> +	 * this is assumed by {init, fini}_seq_pidns() callback functions.
>> +	 */
>> +	struct bpf_iter_seq_task_common common;
>> +	struct task_struct *task;
>> +	struct __vm_area_struct vma;
>> +	struct file *file;
>> +	u32 tid;
>> +};
>> +
> [...]

