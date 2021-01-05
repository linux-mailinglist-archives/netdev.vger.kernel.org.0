Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59EF2EB122
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbhAERMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:12:10 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60340 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727036AbhAERMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 12:12:08 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 105H4rvK004780;
        Tue, 5 Jan 2021 09:11:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xHya4biZPHKN7SOghnFgG87556Hs7DU2dB44Nrb5OJg=;
 b=oK7UIihBKr/K79DSeIdmuuWSu1ng9YRbzfYvGTx7iNFf3oa/TL88cm+gV0IAEJ1VGjaK
 JFFkupGN9m5z5+D+H5esqooY29yue7H6/9jlYO67mxYRtqZ268HNHC1AGRcBeKxDHBxN
 Dch1jgOVmtpjwcSXgQMBC3S2Vxmwz/Kbbv8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35tqhqvcay-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 Jan 2021 09:11:11 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 5 Jan 2021 09:10:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/Ymp7LlgRDJ4UUp2DUckFsZ1taEETwpkHQ9h1W+67afAMB3FSsWsDynAhLCmw9rvd0FwDvQ2nTDBLFp6mVxjPUeWvzvJDiUsghgXObccu98bgD0JiggGHNDQKMSFQ/XN2p1GoQXwzxVeT/D97JakMtKE31L0WhhsK8MMw7y37NVYoQXMeUCj9/eeCvQVp1NdM0+9MT5h0ydQKjoNZGxgDGI7hfsEh77/sUZsIDYd9kGNatGBY648Lje2LxctZwsxGF1xlR2ky8CWwryuIMkD8dX29Y/GbJToghsraHDbRF0wUIOrPTbv1VbhUnL+So26+VFt5fimVfe6weQPMj3WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHya4biZPHKN7SOghnFgG87556Hs7DU2dB44Nrb5OJg=;
 b=RUPRTvZnjacz/s4hKwrvQJaBlhpf6fY0YQI3eGsq+1DA+RdxMvcDRGRoiqkTj43vfmZyaJ3Cq7BpDNjtVNJj8wAn2BvCPowi2meJeOE2GoOcLcCD/c5vaurem2nR+jQuAMRUCZW44+5UXcQ1VtrNpUO4IM6jgHrniCfzlNbwlpUav12pTre93x+aDoQw+HJhmgAfKt/US2Q8vYud3e6nOly2JOFYz9dN0PGP7XzBeTl9ZfODWzWp8gq14XfkUdKHE+gCaZQv7Fl7UDNHIw4UuVV2eAkhAnA6zkL60ctAJdaVLlllavFhFAnhnBb/fiYFFcZnzaWZ+QQE/xxu4BBDeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHya4biZPHKN7SOghnFgG87556Hs7DU2dB44Nrb5OJg=;
 b=Z8dHMqxYuDa7pwyBVhVg3jiPlH6z6x0WfOKicrPFYxf3MBZgRNfoSATto3GC3TeagdZ6YijV73giTmwJ76xMxmJYClxUAjWUnvmJJx4c6T99BEADt3/3WMfkzDZoSIezE82I4BpBUJlASgq/qylhkOlfa1KE+/TK2KUzy6zC9t8=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3512.namprd15.prod.outlook.com (2603:10b6:a03:10a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 17:10:57 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 17:10:57 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Yonghong Song <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Thread-Index: AQHW0zs42cd9AcJBNEyi77fZmX7Jx6n7qAwAgAAzywCAAEpiAIAAIRcAgAAOLwCAALyEgIAADIEAgBtELICAAENfgIAAsrMAgAAMPQA=
Date:   Tue, 5 Jan 2021 17:10:57 +0000
Message-ID: <EB23A240-8A1B-468B-86C8-CF372FE745C5@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com>
 <20201217190308.insbsxpf6ujapbs3@ast-mbp>
 <C4D9D25A-C3DD-4081-9EAD-B7A5B6B74F45@fb.com>
 <20201218023444.i6hmdi3bp5vgxou2@ast-mbp>
 <D964C66B-2C25-4C3D-AFDE-E600364A721C@fb.com>
 <CAADnVQJyTVgnsDx6bJ1t-Diib9r+fiph9Ax-d97qSMvU3iKcRw@mail.gmail.com>
 <231d0521-62a7-427b-5351-359092e73dde@fb.com>
 <09DA43B9-0F6F-45C1-A60D-12E61493C71F@fb.com>
 <20210105014625.krtz3uzqtfu4y7m5@ast-mbp>
 <6E122A14-0F77-46F9-8891-EDF4DB494E37@fb.com>
 <CAADnVQJ5eKCnkoUV-K-S80-0CGLNstNw50OX2tndLM+Or+CSHQ@mail.gmail.com>
In-Reply-To: <CAADnVQJ5eKCnkoUV-K-S80-0CGLNstNw50OX2tndLM+Or+CSHQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:4dc5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f2c6f4c-6997-46ba-752d-08d8b19cde10
x-ms-traffictypediagnostic: BYAPR15MB3512:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3512C0C6750523091D6F69E8B3D10@BYAPR15MB3512.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HkibwEGUBGkVj8fPLAyGME9foPVrLhTXsH1Xk2OpmF6zLpjrsR+53Flt7sM8hpfTaOs1sCMGgewaWYMTVfNcl98PAWkn6QZ2cE4h4dlN8UJcDg70cvECLMgMdjynKL1Krz2++5OzGNaRNhwMUU+8woAJW9QIGuAxaCM8ocYwxDdAHjx73z74AqBTJn2zoV9OhCH+/8TAX/g333EfZhRm5ph1gJ7IPMd/sJhaP1ZpuctnSfggOX6eppfub9rQm2bCAMqRyuIOzGR0cnsJs+4v8t5kuQdZpuSvi9RqBN7LDNIaw9wUDv6zNbEycIQN6i/jPyEv497YslKyMNHnJSfCJfGdf6tvR0qFvgbTqGwUZuT52n9uRr8j9J0w2khSCZk8RaNgB7Cu1+hbDOl8DHibtENNUz19hplfxcdVYFvpfu56sj0DnAYxKdLK70LDypPL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39860400002)(53546011)(4326008)(2616005)(8936002)(36756003)(83380400001)(86362001)(2906002)(6506007)(6512007)(33656002)(5660300002)(478600001)(6916009)(66476007)(76116006)(71200400001)(66556008)(64756008)(66946007)(6486002)(54906003)(66446008)(316002)(186003)(8676002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?iDyc9MsJT4YRtxq4xjPwmCdGTYAzRQ9eCFC8ZA6xOTXFv6+x2V8dulg3mEFB?=
 =?us-ascii?Q?KrXfGZi77MktHWX1cUjroFJ/1L5sqSrn0psMGPaiFP/4AZs0on3CijvezVxp?=
 =?us-ascii?Q?5HZVP7ktxInxIx4mn+VQTL5fQcFlRikJM2xIsyjMIL4yZJbV+xWzF75KMPWq?=
 =?us-ascii?Q?fIJN8vvl15g+VYOWyXhL6/m4qmemzQAgNaugLN8ZrgUd6i3n7raGH4fY6hN1?=
 =?us-ascii?Q?AQBF/ixZ6IOIber/vs+TAAf59uI37GCgflGmFiJnH4zm4HmV1BB9buRlXOt2?=
 =?us-ascii?Q?nXOMN7L5ZaGqIJGTZXgaeeJd1zTEI4O6lFL3iNeNMyjK60mIUKNI5ngZonj3?=
 =?us-ascii?Q?8WWr4+ub/t0nSmKA3eTVdY5IkTKHWgr0bLf2XI2zGbbFoPdBiMGCiYv8QWYq?=
 =?us-ascii?Q?q/8tDaHjQOGBZ40Uyh+ZvG8sA+NIo/+cLZcRR/mcdU732L4quaTmbMcNIv6e?=
 =?us-ascii?Q?7kiisTzDcUVUQQS2zQXFvaLpKkQNcVsXdnIqrX7O+5wVLCErrGTLrcSDYh3U?=
 =?us-ascii?Q?v4TouQE2TWPItteghMiNwuH/0+9RCePu4Z8D7XkvLIxPmQBdNwlCKvEJDmF+?=
 =?us-ascii?Q?Qpk4T52KSM/wMCGwTP6xET8Prw27C1tgTrv9KCaYFi9WTD12pziPs3USeTZ5?=
 =?us-ascii?Q?vrLmOmYN+kkFGudgQRE4v4goxv96paxI3dEhQkjYWny10D75N8sBVKmqSx3c?=
 =?us-ascii?Q?0Sa8Hg79aD1QdENHCJ3SWjS7F+GqpbpAF/uUvtxfJF3M4T+B//WGXBFJyS7M?=
 =?us-ascii?Q?mWIsAWcgIjuNC+vRHJnf+Icz0ltYfKou7GPwpnxGb3VC5GKkFt/xWrT40dLG?=
 =?us-ascii?Q?HOe/tnmQYZIBMO0CCpLakcQHRWnTxvJVSzVhD72Sg3c5ZYTYF/nwYAQhfh9p?=
 =?us-ascii?Q?/mLoTDyPefYBOGPoiXWUj6C+7oA8rrM8BEP2oONOl/ATpeV8zvcMk7FavjSt?=
 =?us-ascii?Q?xbV1oRoG78oHtS85brD0FsZQCYM7ehcVFu/Fdn/V4PFkwfmzPLAgydhepdB1?=
 =?us-ascii?Q?qaaYmQ6OEdV+xy8+y4/TBtG1QVFvkrltcr6D0p22Y44ciCQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F1DB698DE8B5114B8500170D7AB6DE63@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f2c6f4c-6997-46ba-752d-08d8b19cde10
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 17:10:57.0500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QSqQmGWcTkCKdPxdeulhahV9V0Xkgc3oBhVjOiyTjxjZMJm1AxtCluVwEezfMG7cg3wnkyIylUs2zkNANcWBFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3512
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_05:2021-01-05,2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 5, 2021, at 8:27 AM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Mon, Jan 4, 2021 at 9:47 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jan 4, 2021, at 5:46 PM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>>>=20
>>> On Fri, Dec 18, 2020 at 05:23:25PM +0000, Song Liu wrote:
>>>>=20
>>>>=20
>>>>> On Dec 18, 2020, at 8:38 AM, Yonghong Song <yhs@fb.com> wrote:
>>>>>=20
>>>>>=20
>>>>>=20
>>>>> On 12/17/20 9:23 PM, Alexei Starovoitov wrote:
>>>>>> On Thu, Dec 17, 2020 at 8:33 PM Song Liu <songliubraving@fb.com> wro=
te:
>>>>>>>>=20
>>>>>>>> ahh. I missed that. Makes sense.
>>>>>>>> vm_file needs to be accurate, but vm_area_struct should be accesse=
d as ptr_to_btf_id.
>>>>>>>=20
>>>>>>> Passing pointer of vm_area_struct into BPF will be tricky. For exam=
ple, shall we
>>>>>>> allow the user to access vma->vm_file? IIUC, with ptr_to_btf_id the=
 verifier will
>>>>>>> allow access of vma->vm_file as a valid pointer to struct file. How=
ever, since the
>>>>>>> vma might be freed, vma->vm_file could point to random data.
>>>>>> I don't think so. The proposed patch will do get_file() on it.
>>>>>> There is actually no need to assign it into a different variable.
>>>>>> Accessing it via vma->vm_file is safe and cleaner.
>>>>>=20
>>>>> I did not check the code but do you have scenarios where vma is freed=
 but old vma->vm_file is not freed due to reference counting, but
>>>>> freed vma area is reused so vma->vm_file could be garbage?
>>>>=20
>>>> AFAIK, once we unlock mmap_sem, the vma could be freed and reused. I g=
uess ptr_to_btf_id
>>>> or probe_read would not help with this?
>>>=20
>>> Theoretically we can hack the verifier to treat some ptr_to_btf_id as "=
less
>>> valid" than the other ptr_to_btf_id, but the user experience will not b=
e great.
>>> Reading such bpf prog will not be obvious. I think it's better to run b=
pf prog
>>> in mmap_lock then and let it access vma->vm_file. After prog finishes t=
he iter
>>> bit can do if (mmap_lock_is_contended()) before iterating. That will de=
liver
>>> better performance too. Instead of task_vma_seq_get_next() doing
>>> mmap_lock/unlock at every vma. No need for get_file() either. And no
>>> __vm_area_struct exposure.
>>=20
>> I think there might be concern calling BPF program with mmap_lock, espec=
ially that
>> the program is sleepable (for bpf_d_path). It shouldn't be a problem for=
 common
>> cases, but I am not 100% sure for corner cases (many instructions in BPF=
 + sleep).
>> Current version is designed to be very safe for the workload, which migh=
t be too
>> conservative.
>=20
> I know and I agree with all that, but how do you propose to fix the
> vm_file concern
> without holding the lock while prog is running? I couldn't come up with a=
 way.

I guess the gap here is that I don't see why __vm_area_struct exposure is a=
n issue.=20
It is similar to __sk_buff, and simpler (though we had more reasons to intr=
oduce
__sk_buff back when there wasn't BTF).=20

If we can accept __vm_area_struct, current version should work, as it doesn=
't have=20
problem with vm_file.=20

Thanks,
Song=
