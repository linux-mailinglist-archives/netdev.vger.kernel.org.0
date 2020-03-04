Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85679179AC3
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 22:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387931AbgCDVSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 16:18:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20974 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbgCDVSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 16:18:10 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 024LFsw7026284;
        Wed, 4 Mar 2020 13:17:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OoseVWKLW2lHf3K3Dr1FB+T4m1qonnv8Hm2viNwgJx4=;
 b=JDuBajMtf1QaQGcXig8LEvOHP2Ci3YRlfIfgTKq1xfxUVPGBndE8yaAtKfrHu6gyAyi3
 Q4ydRUMRveMDKA3/Bm5qb6HcDV/TsJgHCNay7/scVn6m28VaTNCHt7TDUptw6QAGiQVs
 lxHyxaGEFfPgG14hSryOIph7cKT8B7StFwI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yjk74r8vb-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 04 Mar 2020 13:17:55 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 4 Mar 2020 13:17:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCG3iZ2nDs+5yt5yrTiczH6Ld4LY6BVGNjq84OW454ZvbjagVEMzXE22kxl/RgZgLMDNhfCwVzOr5gkdAUWvYYeUNx8mqWooaARffJMq2LHy6WPDDPw9EPQivuiXIVSKWnbfUW99PCUeAEquwouUu1v7226YFRlKkqB6VEtfCk9O1Dzvkp2eHfkVpyLpO1s+L0Y/w6QnAbRhuCCpXeM7UcVLBp0rq7J1G/Bk1i/y1Nf/6IPr40awI8US922XR0fMkcRXg26iudoL836URdZuEpC0/pWyK6Rm8pu3pLUZjfKELFLw+oxOr1id6eG8mm+b4UtCdKj9uAYjIv16u0nhiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoseVWKLW2lHf3K3Dr1FB+T4m1qonnv8Hm2viNwgJx4=;
 b=dj6sQNsq65abgI2QzyO87YaYdOHqVaR49GFOSMENyMI5msIksurL0hdnhhQvYOkzHKvWHvy/xlyKeWEZ+oJ3hb0CHtl9bY32eE6yPTZshTQx3y4zwtolT77K6z9oUphQR/s1CoE7i8xd8sMz11GMN7oXCxbORG0DcVce8SmCkaaldlKjF3jKy9N2Wd4TVwWm9NdJZmGwj5kbR64z/uFM4A/0bH6RDWB/TzG1P2dwVhrekdloOMc9MW5LUoc1hFbIxCCZkbFjG8CR+fc9F0qwLAzHiSyYzGi4sUr6TdrPfY+ya39xDnQdqWA/smYWJVejymyjZoWWR8JWTiQO/LKbLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoseVWKLW2lHf3K3Dr1FB+T4m1qonnv8Hm2viNwgJx4=;
 b=UgBDGFS/aX09TeEOo9VSfMdEjSyKuLwwUBF4jml2aIfUaAYPgrttRghYtcpHqjfZKMnjWG3M4nCwMt8UUpyrDYrusjr5zgDk20UZhyaeK3siXIZBzZRgdR4hyqN0BM/e2R40XRjS3HW5CBWo9x6DA5Freb5Eta1vnWfsIE5dhvM=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3884.namprd15.prod.outlook.com (2603:10b6:303:42::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Wed, 4 Mar
 2020 21:17:45 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 21:17:45 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "quentin@isovalent.com" <quentin@isovalent.com>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 1/4] bpftool: introduce "prog profile" command
Thread-Topic: [PATCH v4 bpf-next 1/4] bpftool: introduce "prog profile"
 command
Thread-Index: AQHV8k/mDsDjDFnh2UKZj3OeScEaTag4z4CAgAAgkoA=
Date:   Wed, 4 Mar 2020 21:17:45 +0000
Message-ID: <D54E47E1-AB6B-46C7-8139-3C43F3E316A8@fb.com>
References: <20200304180710.2677695-1-songliubraving@fb.com>
 <20200304180710.2677695-2-songliubraving@fb.com>
 <20200304192111.GB168640@krava>
In-Reply-To: <20200304192111.GB168640@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:4f8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78e24a9b-fac9-423a-9ca2-08d7c0817bf8
x-ms-traffictypediagnostic: MW3PR15MB3884:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB38847DBE27FEF36C33BF0C5CB3E50@MW3PR15MB3884.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0332AACBC3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(39860400002)(376002)(366004)(199004)(189003)(5660300002)(4326008)(86362001)(81156014)(8676002)(81166006)(478600001)(36756003)(316002)(6916009)(54906003)(8936002)(6486002)(2906002)(76116006)(66446008)(64756008)(66556008)(66476007)(6512007)(2616005)(66946007)(33656002)(6506007)(53546011)(71200400001)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3884;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T00CBBe79f5c4HxfhGvf0QjN76LZJvLE69FxvUVJBbodloZpKuUBZTlAl65TSi833ygR0Pdmz+spcyPeaEPrxB33HhKQqcbRPJ2ZN9AePYK/VSQZay7U18RQh2pU0/Zk7kMr5/SMlnl9azBbDdUihd4smkCh/MJGrENB/+JpI/EWNEAPP2RddO66d4Oqp/iUFahHHc3agkp08GKCnIAXJgQ8zpttw6NJBtnxfPqaMzQaH0BIo8+/prkmT8/hnCBL1bYPnWj1Oao6wJfiieOSUcLqpov00NO15/RJLLkp39DwFZ9M7lfLZYGf20tgIB6O5yY4Cn1JGtHnOrmn/fnegrilckD+zDom8cRIncZcYRLGAfhzZ3znm8QzW0YpK5QjcMrCZm5Me5AQOowQlHEqBd2EV5CcGxDX7p45TAERb9qc0GVUKy0ETYfeYO6VTa15
x-ms-exchange-antispam-messagedata: dFxzx+m6nCHeYH4MhmXQpwtkrjDORpfcnFGpql5/eSnE1u6Zy4j634UKRPodHhL/5Krabp4Z7nNehfqfWEvGz4PTbAuu7t3bGXYKkWOvie2mwmSiBi7x3K7ogRMMevYJluMpk3BOfm1yP/1rYbi99OhPydYxv8Aso34mkjBgTJ09ytiAF/o5A/QeIXrJdwYc
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C98DA36054AFF041AB68C6F4FE331436@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e24a9b-fac9-423a-9ca2-08d7c0817bf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2020 21:17:45.7706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n0YuBHLKCS7z92N6SNS0RqqvQ0XczIBqgZ3fAREyLgMBJzz7wGEPw07YKhjr9k/MBqZBjb/+If7DTFvrQNiNQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3884
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-04_09:2020-03-04,2020-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 clxscore=1015 lowpriorityscore=0 phishscore=0 malwarescore=0 adultscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 4, 2020, at 11:21 AM, Jiri Olsa <jolsa@redhat.com> wrote:
>=20
> On Wed, Mar 04, 2020 at 10:07:07AM -0800, Song Liu wrote:
>> With fentry/fexit programs, it is possible to profile BPF program with
>> hardware counters. Introduce bpftool "prog profile", which measures key
>> metrics of a BPF program.
>>=20
>> bpftool prog profile command creates per-cpu perf events. Then it attach=
es
>> fentry/fexit programs to the target BPF program. The fentry program save=
s
>> perf event value to a map. The fexit program reads the perf event again,
>> and calculates the difference, which is the instructions/cycles used by
>> the target program.
>>=20
>> Example input and output:
>>=20
>>  ./bpftool prog profile id 337 duration 3 cycles instructions llc_misses
>>=20
>>        4228 run_cnt
>>     3403698 cycles                                              (84.08%)
>>     3525294 instructions   #  1.04 insn per cycle               (84.05%)
>>          13 llc_misses     #  3.69 LLC misses per million isns  (83.50%)
>=20
> FYI I'm in the middle of moving perf's 'events parsing' interface to libp=
erf,
> which takes event name/s on input and returns list of perf_event_attr obj=
ects
>=20
>  parse_events("cycles") -> ready to use 'struct perf_event_attr'
>=20
> You can use any event that's listed in 'perf list' command, which include=
s
> also all vendor (Intel/Arm/ppc..) events. It might be useful extension fo=
r
> this command.

That's great news! Thanks for the information!

Song

