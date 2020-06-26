Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A556C20BBB5
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgFZVjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:39:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36144 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725793AbgFZVjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:39:05 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QLZak8012229;
        Fri, 26 Jun 2020 14:38:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=17ZlsX80hnSL3sieLssFH+DkG3R92yDfkOBBrO2w3ko=;
 b=Y1gXiaMSK9Qnol8AR/sIWDq3YNuZcDPmvNwyfbcXPH1aOBVTzaaCPuqjUiPcNvYLVDaI
 ZXxJSWSv83Ayt1oOGBnSS8NNWCn3MvBX2Qy7Iapnq19u5cGYPcR90KQa2shGQnu9z2sF
 +xdjDJ1fAUt4Cu4eW7VopTbIAaSGBA3f/ao= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0w7mms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 26 Jun 2020 14:38:45 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 14:38:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVFcncOIjVXlC6CymZQBh8opClXAwvzuBxVMAdYaXA39p5sRu7X1Rf6xoyyxF0/hfKXcvVl0K0Cb67sDDcxRG0iHuektw/dtFpghPtLHdWP0J7Fx3Y+wKC/TSax4lWw2s4arK7rYqmEg+81bM011X3esXkX0WlmGxX5upDZQcfKD2szlR2695KnTsbIOyQKLgnkkdBW3he9km72WLaH1Gh+3xYc6U9vh0YVNp2Mwu01HkNEBtUVid8/eaRv9DA+14z/DhmcAcgLiUYzXEOe9G9uuzqQlM1O61hJmaQ5dZ5TvtrN904WwfP7qT+sDgjJNf8nLKl9432QRR/9jArro7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=17ZlsX80hnSL3sieLssFH+DkG3R92yDfkOBBrO2w3ko=;
 b=YPaP2RNsbo3Kao6oapdyVeu5vW+ENuymIQq8ScrjZiyyQLi/JnpMm/C3BlxD8Oy+O4BZ+zwvrnjlSI2VIqptgtNCIxFNJNaSWI2kyfekILYkKPhHlrwTP0uBPD8BLiDemUO+wBLz8xReNk/hLnWFGqN8Imuzk8dvkEAAhsEsktrzfFkkZwX0NuCbELvb7+MVV+baUUtTez9bA13Gk480YGHJCxx0MQbD3i87SzdWHjbqwlvT4v4/DSqzfAcjkYrNHUiNBsgsIhuYI8vsu5dqngeRnKNnE7lroM518jL1n1ZBfsD88TuOy/dQn6oDussRahLYvAiKjCkmzIGaYtYNew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=17ZlsX80hnSL3sieLssFH+DkG3R92yDfkOBBrO2w3ko=;
 b=Rx9ibOEknqHYO9dnc5i3mstJVPh+SXXPp1ccjc7kg0GMbADloaXXO81oxw3HBRY3jSCo48ysTRvkNyx+IaXDxzP2OaGqEj9MzEbXsLx2xVfDNA/n6/RjeSr6BDvOqr7JtpqOWzgniviAHb8iB+U9tIn82yDLCXTnyDRwl3CpbsI=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2727.namprd15.prod.outlook.com (2603:10b6:a03:15b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Fri, 26 Jun
 2020 21:38:42 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Fri, 26 Jun 2020
 21:38:42 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Peter Zijlstra <peterz@infradead.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "john fastabend" <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH v2 bpf-next 1/4] perf: export get/put_chain_entry()
Thread-Topic: [PATCH v2 bpf-next 1/4] perf: export get/put_chain_entry()
Thread-Index: AQHWS06t5H2BZnsAuEuKRuZX7jQ17qjqu3gAgACYV4CAABnmAA==
Date:   Fri, 26 Jun 2020 21:38:42 +0000
Message-ID: <ED1F39FC-AE00-4243-8903-9B353DA42C8F@fb.com>
References: <20200626001332.1554603-1-songliubraving@fb.com>
 <20200626001332.1554603-2-songliubraving@fb.com>
 <20200626110046.GB4817@hirez.programming.kicks-ass.net>
 <CAEf4BzbgyBWpHdxe8LdHp+48fazS6JLEdaEd09p40s=+cy4Phw@mail.gmail.com>
In-Reply-To: <CAEf4BzbgyBWpHdxe8LdHp+48fazS6JLEdaEd09p40s=+cy4Phw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:1a00]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c47e36f-190f-41a3-b3bf-08d81a194c2b
x-ms-traffictypediagnostic: BYAPR15MB2727:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2727CD88974DC8BA1802C7C4B3930@BYAPR15MB2727.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rBZysrHZ+HFYtuy9uqI32uQyByMYQ0ICZhl6HDcnIKC1A1mrLQ9I/SzNQyu3D9cTZYZpiPEcJkI0PLZ9+saGoF/vYZ3t5hm0clvtP1TkaWtVN7FgF8Qd1fWHT+uUBePukmy3hW8ZmeIakYU3FfFxWaVTcUnQGeQwXIHRPuQBz4cpAtd5ZoubYqUcmTDe8wTekfuAyUQP/NS4p2Pp+b92egw0r2tjfuRl7u3MIgNCP8pEuxmYOesVUqDmMVzarR7k03Pm1E/lx+uQbPFjdTo9wOMSDe4nOowS2dUY6DREgOAIhBYE1Dj7Bg271zgOap/hKIjjYdqNGpjc00S6hmsVFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(39860400002)(396003)(136003)(366004)(36756003)(86362001)(478600001)(8936002)(6506007)(66946007)(6916009)(71200400001)(6486002)(53546011)(33656002)(76116006)(8676002)(6512007)(66556008)(66476007)(64756008)(4326008)(66446008)(2906002)(2616005)(186003)(5660300002)(316002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: odreYjE2Ol4NdoQT+BMLzTVD0I4WbWdFKmpEar27amWRDXq76O7SCSQRNOaeJzJAtTwlAllRc/xwZk8zTcwUdWo1TwHrEu5GI33VhCFmz0WjqdeonN/aA8OtNrluBqNFKYAmgrmT6eNOREc1WVvoUoFMmJns/GVyJ4z572gGuXIHdG+cd2vxpdLBP9rzx7yDTdYNCRvC65NIGf46GiprarGHPbJgoD403Y2750rkqfzHR8Ry4HTDnsC+eBB9eXsBU7QXvHx0HN+CupuvDPdrm0KbX9Y4ddKsN5Z8CG3sxFm8gA9tC9qaYiuXdgjjhaAKmxG3SRAvvtq+EvIYNnup+m2CHqjEzwqGO52BgFWk2ui6SWBt9NS2wgxuBv2pYL2GPfYCz1h7+pFGu/KIpd1vPnqRiktY+AICxyG69+aZQTdqpLwReBAZPeek3NltawQ0aqJzPoPq984J02/Wvb2eIx4IOVPeteZtgO1m4HIcCgYWeiNgvAQkOOZ5irymF+1y8SR4Hg6aAAeL4IoB0ErdTQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <61BE7CCF87B2AA47B834F32C6AD6D635@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c47e36f-190f-41a3-b3bf-08d81a194c2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 21:38:42.6592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g7SQ/EyXtf+0o2hgpaYJMQpL5Y0lw/Ukc90Aw3+9Y5o+T6FMQYrHAd2Ae4O5kIvRDZfvrxDDlzg5fQL/UBQ1Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2727
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_12:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 cotscore=-2147483648 mlxscore=0 suspectscore=0 adultscore=0
 phishscore=0 clxscore=1015 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 26, 2020, at 1:06 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Fri, Jun 26, 2020 at 5:10 AM Peter Zijlstra <peterz@infradead.org> wro=
te:
>>=20
>> On Thu, Jun 25, 2020 at 05:13:29PM -0700, Song Liu wrote:
>>> This would be used by bpf stack mapo.
>>=20
>> Would it make sense to sanitize the API a little before exposing it?
>>=20
>> diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
>> index 334d48b16c36..016894b0d2c2 100644
>> --- a/kernel/events/callchain.c
>> +++ b/kernel/events/callchain.c
>> @@ -159,8 +159,10 @@ static struct perf_callchain_entry *get_callchain_e=
ntry(int *rctx)
>>                return NULL;
>>=20
>>        entries =3D rcu_dereference(callchain_cpus_entries);
>> -       if (!entries)
>> +       if (!entries) {
>> +               put_recursion_context(this_cpu_ptr(callchain_recursion),=
 rctx);
>>                return NULL;
>> +       }
>>=20
>>        cpu =3D smp_processor_id();
>>=20
>> @@ -183,12 +185,9 @@ get_perf_callchain(struct pt_regs *regs, u32 init_n=
r, bool kernel, bool user,
>>        int rctx;
>>=20
>>        entry =3D get_callchain_entry(&rctx);
>> -       if (rctx =3D=3D -1)
>> +       if (!entry || rctx =3D=3D -1)
>>                return NULL;
>>=20
>=20
> isn't rctx =3D=3D -1 check here not necessary anymore? Seems like
> get_callchain_entry() will always return NULL if rctx =3D=3D -1?

Yes, looks like we only need to check entry.=20

Thanks,
Song

