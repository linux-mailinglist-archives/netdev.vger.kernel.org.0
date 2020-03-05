Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25FB717AF54
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 21:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgCEUDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 15:03:20 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15404 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726183AbgCEUDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 15:03:20 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 025JxQLJ007714;
        Thu, 5 Mar 2020 12:03:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=RgEVZj7MUT1TG9sAxzK95CnPGcWERvcTcUhcmslh24s=;
 b=brbzCyq6lTsZs80jN15M/kqrrhpWZp8ckg4QwY/iuZErv+JCbb3pbTpJrj+dzt5yTo42
 OjyraKrN+iO3Nz/tEnuCJBD3wSnup+CQCF3ooFFXn2fN1Ed9yI0LtbJbkxRHOQRAVFUa
 KUim4GvE/WFSiZ1uq+ynO3bG+/8lIthAEJE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yjurfunr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 05 Mar 2020 12:03:04 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 5 Mar 2020 12:03:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HREMAOctD3YnYKsfyLRn9DH5mwuYJK0MTGPj/p2DPt7jk37k+g6fTH4lyjp9DM1A5GXqG0qRSkniTipwnB7Cp8iRyY718rkE+x1cE4GnvBENyK7CECerE/Oqqp/nFx1NQR1WzSTVFiMhAQf/m0xASQK3gsCOTbtLytuMo3OTahd+zcWN61l1jE9zG2ffQzkp8jfe003LQ2IWMnOdIk6l5xiN8YeOz0x4tGFMFsdUAgEv32M0mzTmcLrOJqZ9V+6GM0mm65f9FgQxXZ0l72A3xSRjklo/h3qthVfOZoxY/j9TsS+PIC25ztLwkCdOzdK9rNupFtObVARCRpzg6ZBmKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgEVZj7MUT1TG9sAxzK95CnPGcWERvcTcUhcmslh24s=;
 b=e3ZF7fBwe23yFrUElFXacvkB7Fe2ZPqV/miwvKn2wOc9tOhErYc5PrGPsnJh6BebxrnmO3fhQK5Soq/os1kXCok3i4j6QqBUj6obuMPWIqp7iwokzvQUXWkvUbEy9TmKHKWzCH/VKltIMO28pSi14V7G1aD8gKggA994BCbxhwc1Oavi3YYsgmAIbqmHtSlL7EhUPAp+fz4Fa5PgtGlREndzihoJKUpIf7AyjA3aQ5kE4LFjZLPNAuCi7TaY3AhgRhJXjCPEzyKmeEM9m+mSkzGqAXz3FobBPigbCUC6PpzAAQa4NVqnTesGTg9oJQyeJBBMYq09TVhaSpuoVw52gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgEVZj7MUT1TG9sAxzK95CnPGcWERvcTcUhcmslh24s=;
 b=GzGwj3vUUbd2txVqsGrDrEeUzggjhnPb4zMIabp+fFlMUgnExoY/MfLxLzwpROZRsNh9YI6fqtTrWn0Aihl1H/aY0vs18rVFTT6sSwl36CB9jBDprZ9Sbz4YcARZ3vlcJ94Um9eN6MGDmiIxfInbEot2tGMbWOt3z4uHF+Hva/c=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3913.namprd15.prod.outlook.com (2603:10b6:303:42::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Thu, 5 Mar
 2020 20:03:02 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 20:03:02 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Quentin Monnet" <quentin@isovalent.com>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 1/4] bpftool: introduce "prog profile" command
Thread-Topic: [PATCH v4 bpf-next 1/4] bpftool: introduce "prog profile"
 command
Thread-Index: AQHV8k/mDsDjDFnh2UKZj3OeScEaTag45RSAgAGIcYA=
Date:   Thu, 5 Mar 2020 20:03:02 +0000
Message-ID: <5BAF92A4-6CE4-4578-8481-96678D4E1201@fb.com>
References: <20200304180710.2677695-1-songliubraving@fb.com>
 <20200304180710.2677695-2-songliubraving@fb.com>
 <20200304203825.GC168640@krava>
In-Reply-To: <20200304203825.GC168640@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:f61b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0951acc6-30dc-4e12-2242-08d7c140361c
x-ms-traffictypediagnostic: MW3PR15MB3913:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB3913EA410180433CDE3BF9EFB3E20@MW3PR15MB3913.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 03333C607F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(66476007)(64756008)(66446008)(66556008)(6512007)(478600001)(6486002)(66946007)(2906002)(8676002)(186003)(81166006)(8936002)(81156014)(86362001)(4326008)(76116006)(54906003)(53546011)(6506007)(6916009)(36756003)(33656002)(2616005)(71200400001)(5660300002)(4744005)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3913;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kUFAo3ylQtCiQwOBrCmJyfO0m7mJ0rg+Wj5bHNUyPD+x5oj1NHpBHsEQxvHqn7shldWSWg/f+Baqg6gR8W5ks71sczHX5Y329vYobwOha3KEl2l7AeMD7LLzWg8woXooXh2YogiR5y7biop3cT7S3vGBto7XDrxBDczhikIKMmopQJ3XM1fyh+aihgClRlHCoo6M7XgXzY2J73L5Q0MUNHmZNUE3wPKet3QPi/FxeGl690l9Gc4fA3br4d706AXK82yKXYi+ZOcbJb9poJJn8Kd3EEEpAKOVxlNY8nkvWZvX9C+FO88OR7McT1plTIeGaV/4IiiQwdVV8Ds3ztz6w4DAa3xPjMH9XElvp/HbKR9penLaIISHdMaIJTEJ7Vder7zlHOuaRMjdWXaqP6YbzZO/D/lPhvb08BkjVJI2zNrixUt8Ba4Kfv/D00cjlrUH
x-ms-exchange-antispam-messagedata: cHw+zXKDeH8gMRD/7U3PeLjUo4hHP2MR6cwsYv05jr52TDTHbyXckGzR2xtTm0JQZ42OLd8Mv20TGuskqA+IZhmfXNn/S2qcwGmKFps98kbcRqP82yV2eoyg8TTCyBnpSylJOex5H5WkSWeQMCLbm/r+mWq4Jc68OmZlBxwSadPY09ufbZOGv5/gv2RBeLSw
Content-Type: text/plain; charset="us-ascii"
Content-ID: <53340D223C1A9344B2A31BF2D0F5D8A8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0951acc6-30dc-4e12-2242-08d7c140361c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 20:03:02.4273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kxlLoJbZZpvGhNrscJeIZSH1dVpf+X66ZeYfMvc+oxG3vQAhdWFYjZIhWD66I9cBjb2NJMlefSvL9WrPQkk6Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3913
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-05_06:2020-03-05,2020-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=0 spamscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003050116
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 4, 2020, at 12:38 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>=20
> On Wed, Mar 04, 2020 at 10:07:07AM -0800, Song Liu wrote:
>=20
> SNIP
>=20
>> +
>> +#include "profiler.skel.h"
>> +
>> +#define SAMPLE_PERIOD  0x7fffffffffffffffULL
>> +struct profile_metric {
>> +	const char *name;
>> +	struct bpf_perf_event_value val;
>> +	struct perf_event_attr attr;
>> +	bool selected;
>> +
>> +	/* calculate ratios like instructions per cycle */
>> +	const int ratio_metric; /* 0 for N/A, 1 for index 0 (cycles) */
>> +	const char *ratio_desc;
>> +	const float ratio_mul;
>> +} metrics[] =3D {
>> +	{
>> +		.name =3D "cycles",
>> +		.attr =3D {
>> +			.sample_period =3D SAMPLE_PERIOD,
>=20
> I don't think you need to set sample_period for counting.. why?
>=20
>> +			.type =3D PERF_TYPE_HARDWARE,
>> +			.config =3D PERF_COUNT_HW_CPU_CYCLES,
>=20
> you could also add .exclude_user =3D 1

Fixed this in v5. Thanks!
Song

