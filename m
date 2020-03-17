Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B69E188E6A
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgCQTzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:55:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63376 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726294AbgCQTzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:55:03 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02HJZNw0027483;
        Tue, 17 Mar 2020 12:54:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fLO/Dq9G36waLOY96EaCNktwpfP0Vn/VL4I0Z284o7w=;
 b=FySzspT1AiWLzkBGmHUzpS5CPA0MHH58BL2zloCnCIOpmaohkZvrVlUx6Tx6hO27MHfk
 sGDPKtNU9nVjVtIPWQoOesAMK8U/+X/t13O7ibIKzyrj00JjMuZLWx3k+Y/3Q6/B8068
 cOE4r2qa4N/teDIQP9lRsgFS8AcQhe0qf34= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysf3741k9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Mar 2020 12:54:46 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 17 Mar 2020 12:54:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obQ8oqiglOC9fL+8gbrWm1/mAM/qYYp4rThiLpA7UTSbX92dHdOoFxCQUHSffOl8wStuOuhJtkHnZf38xwIUIZ5j1OD1n2HcIa2+12aL/YCdf8LZR1JBUmqg2B5sj+DBPNW2yovDRX252IF/wo9Bs5c5YEFHCJJdnepLe1zmkTPqTM3uE/m6Zxv38no5urVgExbuaJXYYxNHcay0EHUHotLBt9FRyuqEj4cM/Y+qiudwOBwbJHabra7gCYAqrAkOl7cTdlzDkDkhJ5ZDX8dXzyS9ynsHDQgQT5rbDc9c8lwX0DJlI5i/vYEVxFGEUTcwBDdJWGeFixgQoftJpXhtrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLO/Dq9G36waLOY96EaCNktwpfP0Vn/VL4I0Z284o7w=;
 b=OJFxpUEcuEbwZB8Rf4Ny97T0wUhDhNUnu801BvCTBSJy6FHj0C0B+VGBH60rVTACzaD8d2eoqFS9z4ewiRib0A5CHnyNUV4bzgRNHbDPowga5jLdJKoDfiI/hSmJImbJ/bSfij9l8qQoM2s+xshjyRLtQqy9hqzQRfc5AYpK3aUVoH9eK0nGAgyXLRY3mQMvPI7Lnmp+96wnetdXmp58pk8E3yzoPcgi51OkV3NfGZqaXaNgOeVa99bDhTnI8CBbcWxHS8Pqj9/LLMSWR0NGp7wktqjIyb3BUOBt4U0Fd/HzJkIlg0vReFCf4GYoUfF2TIf401KFkqvOdUITmPwa4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLO/Dq9G36waLOY96EaCNktwpfP0Vn/VL4I0Z284o7w=;
 b=KdSaF1MVDtXAJ8VMKrJRMjcvY3kEbeMWA2kcQaZ3kSVItl+vY4Hmwy8jxGIU0aF+qW8OJlgTdtRcxtd1uLzdp04Bqona9ZHD5PF2D5C3q7XmGnzkiKaVDY1azww03JLMMl3g+/zkG5cs2+G11VNwnwnf6XStG9CBaWuR40E5VbE=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Tue, 17 Mar
 2020 19:54:43 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 19:54:43 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "yzaikin@google.com" <yzaikin@google.com>
Subject: Re: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with
 /dev/bpf_stats
Thread-Topic: [PATCH v2 bpf-next] bpf: sharing bpf runtime stats with
 /dev/bpf_stats
Thread-Index: AQHV+9Iy3gdyr8P9PUGp5sv3FGMYHqhNLWaAgAAGw4A=
Date:   Tue, 17 Mar 2020 19:54:43 +0000
Message-ID: <920839AF-AC7A-4CD3-975F-111C3C6F75B9@fb.com>
References: <20200316203329.2747779-1-songliubraving@fb.com>
 <eb31bed3-3be4-501e-4340-bd558b31ead2@iogearbox.net>
In-Reply-To: <eb31bed3-3be4-501e-4340-bd558b31ead2@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:424]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23bf9a00-94ec-4c22-7214-08d7caad09b1
x-ms-traffictypediagnostic: MW3PR15MB4044:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB404465ABB23787A86115D214B3F60@MW3PR15MB4044.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(39860400002)(366004)(346002)(136003)(199004)(316002)(6916009)(54906003)(186003)(33656002)(86362001)(36756003)(53546011)(71200400001)(81156014)(8676002)(81166006)(2616005)(8936002)(6506007)(478600001)(5660300002)(76116006)(6512007)(66946007)(66556008)(66476007)(6486002)(2906002)(4326008)(66446008)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB4044;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h7m2y+An/UBrErGyyG5pVZyfOq2Fa12CVPkSrOl/bPQ21C7L94vye4GltzZ18uEBu8dfQsN5Tk0+27rGwwI4EsEu/ySyw9jzBuncyy07FuM/n/NtsY+ueEZ3DhajfBqXMSYqD3D9V9JoUwWBwZR9S4qzQUpEZmjFnBGwlQefm8SV6tTAhZhELrjxVH4IUhdS20tyGao4Ka0PyCWKubX0GujSJBKqYNlMFOzgjIHG07GccNx+AsM0kUX/2FqKdW54BAJcT4I5W814gJI98ByykQNbnBEk2w/4HfAn1evECZfBk0f0goPHNN+rOTH9QDM9OwqcKnTtPMQHOfQD/Ujv8I9SimIBZUg10JV/MWUSDjgj6WqbDeOkz4SRBELQGbEPXdiRZIg5MLsT1BCizf2YSjz/J805u+h7OtmxEoH+fh9TqZZPEodayufk1NAropnB
x-ms-exchange-antispam-messagedata: ZYSSe56Zqy7Qv4Nbd5/c5mp+S8voJTj02aqUWO0yZrhV/WlqrRIVmYAzouAuakNw+QkAyqsLYfEOJ5lddcC7FxlHpnweyYk4ByYRYjrGx8r60tBohirictn9CY9dHXjmXNEnlEr6Supck3jvsXJFOnR5LomIyrYIDdLQT4q5FH81OmE8BcxaW+8Uz0Cslzv0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <06E499519A4118418BBE60C11C3E2FC5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 23bf9a00-94ec-4c22-7214-08d7caad09b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2020 19:54:43.5617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eZr8utjBHQ1l0XLdNSuUQSejpy6t8Y0/hVnAOcgRifBsLZ6gC7F1vrE4D9Rk/9GMc6u/yFizHcFbgPx07IBMEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4044
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_08:2020-03-17,2020-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170075
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 17, 2020, at 12:30 PM, Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>=20
> On 3/16/20 9:33 PM, Song Liu wrote:
>> Currently, sysctl kernel.bpf_stats_enabled controls BPF runtime stats.
>> Typical userspace tools use kernel.bpf_stats_enabled as follows:
>>   1. Enable kernel.bpf_stats_enabled;
>>   2. Check program run_time_ns;
>>   3. Sleep for the monitoring period;
>>   4. Check program run_time_ns again, calculate the difference;
>>   5. Disable kernel.bpf_stats_enabled.
>> The problem with this approach is that only one userspace tool can toggl=
e
>> this sysctl. If multiple tools toggle the sysctl at the same time, the
>> measurement may be inaccurate.
>> To fix this problem while keep backward compatibility, introduce a new
>> bpf command BPF_ENABLE_RUNTIME_STATS. On success, this command enables
>> run_time_ns stats and returns a valid fd.
>> With BPF_ENABLE_RUNTIME_STATS, user space tool would have the following
>> flow:
>>   1. Get a fd with BPF_ENABLE_RUNTIME_STATS, and make sure it is valid;
>>   2. Check program run_time_ns;
>>   3. Sleep for the monitoring period;
>>   4. Check program run_time_ns again, calculate the difference;
>>   5. Close the fd.
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>=20
> Hmm, I see no relation to /dev/bpf_stats anymore, yet the subject still t=
alks
> about it?

My fault. Will fix..

>=20
> Also, should this have bpftool integration now that we have `bpftool prog=
 profile`
> support? Would be nice to then fetch the related stats via bpf_prog_info,=
 so users
> can consume this in an easy way.

We can add "run_time_ns" as a metric to "bpftool prog profile". But the=20
mechanism is not the same though. Let me think about this.=20

>=20
>> Changes RFC =3D> v2:
>> 1. Add a new bpf command instead of /dev/bpf_stats;
>> 2. Remove the jump_label patch, which is no longer needed;
>> 3. Add a static variable to save previous value of the sysctl.
>> ---
>>  include/linux/bpf.h            |  1 +
>>  include/uapi/linux/bpf.h       |  1 +
>>  kernel/bpf/syscall.c           | 43 ++++++++++++++++++++++++++++++++++
>>  kernel/sysctl.c                | 36 +++++++++++++++++++++++++++-
>>  tools/include/uapi/linux/bpf.h |  1 +
>>  5 files changed, 81 insertions(+), 1 deletion(-)
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 4fd91b7c95ea..d542349771df 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -970,6 +970,7 @@ _out:							\
>>    #ifdef CONFIG_BPF_SYSCALL
>>  DECLARE_PER_CPU(int, bpf_prog_active);
>> +extern struct mutex bpf_stats_enabled_mutex;
>>    /*
>>   * Block execution of BPF programs attached to instrumentation (perf,
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 40b2d9476268..8285ff37210c 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -111,6 +111,7 @@ enum bpf_cmd {
>>  	BPF_MAP_LOOKUP_AND_DELETE_BATCH,
>>  	BPF_MAP_UPDATE_BATCH,
>>  	BPF_MAP_DELETE_BATCH,
>> +	BPF_ENABLE_RUNTIME_STATS,
>>  };
>>    enum bpf_map_type {
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index b2f73ecacced..823dc9de7953 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -24,6 +24,9 @@
>>  #include <linux/ctype.h>
>>  #include <linux/nospec.h>
>>  #include <linux/audit.h>
>> +#include <linux/miscdevice.h>
>=20
> Is this still needed?

My fault again. Will fix.=20

Thanks,
Song

