Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508691BD40B
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 07:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgD2Fgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 01:36:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9662 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725798AbgD2Fgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 01:36:50 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03T5Tker031566;
        Tue, 28 Apr 2020 22:36:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QJ78uHbcXlBpHJszjwK9vp4OhUEmi/NiycTk2sp42G4=;
 b=gC48lbLx3Y7uRHClT3443/aBbzr8+bHiW2VbjzGYhPnWCfq4YZt51dvcLpTt7uBOXEiA
 QU6anpVrbp/JJYLS4imlu9L0/eXHC89s7LzvnukZ7BpUVSE3VOQAbVBbzrfi+CjEazXE
 SLtrp/3uTGAcEHDXt2Gdc/+4GNgfPxslduI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 30ntjvxuuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 22:36:36 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 22:36:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXf8LIggt7t5XonUr/UO7DTe+kOrkd3BX7l4kwFYHENhGUdnDD1y/k/u1cTjo5XaXw4ZNIEnd+KPfiINDoY7qeskNSoY/ySFYZQAr3vFM1gf/YeW/95wNq3AHRzG+tXuwBZOofT0EO+PlwkgkbL0KDV+K+/cSy0IaUo+ahD/6dtRVZaB6p7YFeE7dnrJ2jUKNPjHEOktjPUgU0DUUmhfdAl+Rl5Y5DaavGA8Y9gYoTupNvgINxiOlN4YBmhK3pcalsaVMSv16+rwfRfccZzvrNtl94MR5nHff1v6RM7p4m9MzI+qYHfKMBJ7/k1BzNlcSFsXkxzeVFBFOKI/c6lc0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJ78uHbcXlBpHJszjwK9vp4OhUEmi/NiycTk2sp42G4=;
 b=PXBBzYWj7ikw0tV6iicfs3d8JycSt/sNkSjT/b4tsJZqao9CW7IexHkLjJ6/GgcVDloXBylSJxzGLAv2lIyyW6yhdUO8W9bNdd34SFvoqst2glaSUml4DqUillsL1ClCT7lsNtfIGuXnTJ9+8UlXeHFoZ0pV7Z6EytJzCEiGVk0CZRzEsdkmhZR8TKfjOPhf89biFpXo0U+/VVCKQMmgt8tQpSP5/PdIHwMhnNOVSCQmbI8jonlFWCyL5AO8qUuLiVWXx70EUSXCuPWdiX0UbZgSNxiFrS1v8y6TG6WEIREqA1kPBeCWI5Ne8q31My1pbjyNkaoplnF4Smn09PcfUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJ78uHbcXlBpHJszjwK9vp4OhUEmi/NiycTk2sp42G4=;
 b=JU7AjqXBReFz8hgRsCTQyOPmVpQKqA4ExSzKWdIm4bZ1/BeGJMNsp/6ygog1CyWdXmUcQDXbF4Iy6TdyJTaXHFzv8Cvg44rPgoIvANm1t+yreM9SLmhiAoqmHPmxRmq1s7G2lLPDNimob8kG+p/QJfjffdh7zlGYMBwPqSNBDAM=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3365.namprd15.prod.outlook.com (2603:10b6:a03:111::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 05:36:34 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 05:36:34 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH v7 bpf-next 2/3] libbpf: add support for command
 BPF_ENABLE_STATS
Thread-Topic: [PATCH v7 bpf-next 2/3] libbpf: add support for command
 BPF_ENABLE_STATS
Thread-Index: AQHWHdqFa4uLsAbzeE6NdAZI/bF/9qiPk4IAgAABEYA=
Date:   Wed, 29 Apr 2020 05:36:34 +0000
Message-ID: <CFA6B73B-32FF-4CFF-A953-7CF897A36868@fb.com>
References: <20200429035841.3959159-1-songliubraving@fb.com>
 <20200429035841.3959159-3-songliubraving@fb.com>
 <CAEf4BzZsQxTW_aQp02cj3L3BofpQ3q76VOX_otA5q1v5EF7q6Q@mail.gmail.com>
In-Reply-To: <CAEf4BzZsQxTW_aQp02cj3L3BofpQ3q76VOX_otA5q1v5EF7q6Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:b1c4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50d5a069-a01c-42a4-b6f6-08d7ebff474f
x-ms-traffictypediagnostic: BYAPR15MB3365:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3365B704FFFC47CD3359C5EEB3AD0@BYAPR15MB3365.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:561;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(39860400002)(346002)(136003)(396003)(66946007)(66556008)(64756008)(66476007)(6506007)(53546011)(8936002)(6916009)(5660300002)(2906002)(76116006)(66446008)(91956017)(36756003)(71200400001)(86362001)(186003)(6486002)(2616005)(478600001)(8676002)(6512007)(54906003)(4326008)(33656002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OhjepMs+bkjvV5ihqPty8fzG8B0o+pjuOKRzzTB7PL7b92YHmWp8LljCozwok1GU6+pEncVze8ObmSVg7exe5dqKZpymkUHvniOwokDMSB/GsmjI6HMAXF731K8V3VeB7X8vEa6vJf6WC+/DIKgtGSG2IxmvLJMRnVS4kcZhcht5+9d309aRpmd2bp2AkSsievnZ7im5neUNEotPk4SQDbE9qO7xsFzpVjN7mOt5EAk8HQeJAuGarXqpCZKS6N4koeZmWL4m6+THh52/L0pFfjNIHJPZDF+KccoWkltRzJ2pc7R5QeKRgMhwido2d+vjpS+mU+KH97Hs8Wx29pirYHIIHCgbBtz3Z6DyOHfTvd9ZTrVt1Vu0cXlVehhEvQ6gmbyeSgcyuqqW3io9PP4bcIIC7Ox6pidDqivkRr/KuV6R5+/lCPxLZWjzv5d89Sak
x-ms-exchange-antispam-messagedata: jc6j1N8sniIko6BJDrJYd50weTwg34PKxdGLsY9aqRRGr2mWKClqyak4iEijAl45BXGcxEmJgudlcWfXyrbL7vIWyb7NEeP7iOJ5TOtTbiVjCK5FRNZSK9ndZWpGuWXhLKfu/wYgRVSCkFOF6h+z9V9YZW+yAhF8JLOd4Y3eSLb7NqLZxnLVrKu0+ZRHWIZis8U89RqBh60OBUUcwvaIKnts01PaMOtf2UdIHE74hPVIYxkJskxpRG5nYr+tFDsJz6AL9fFZ4LtMKXRKyjdymW1FI6MMeBHbc8OVb4p4q57SBU23HHsSxt+sNK0yJ8WF/ihwoKEddW/8wVTFl+8SeePneLhZYWqPwSc3pbo/BRexXEA2RaxhjidkGy/hqubJjKSTc6Iyrw1rifu3sGTrzi1s7X5nGNfACxGsjkT27qDStn8g63MuNj2FkIsQLg4UP90ypoxfbqK74qA352gyRbwnUv8+4JbQjIZboWr988thKRx97wVg5a+nfo+PNBDdpg5Zn5XdCuSW5nlGd6Xe3WwNHcS1S+GxLi/xyQeP4tATJ9KQ1lyL6gob6lIoAmWPwsKiC2WzxVq6vxtKcuZjAvqd+Whkxc7cpqIpvo0LBGWHoH85+CI66b3Mc6bEZkeHOfsAyYls54fSnDkS5LCHyNsuryHoWTtUJlMO3FORceVioTO7DcyRv1+s+BgzvpR9Y5piTyImgaHDn+aTrrh4BWjmmCtUVeifUehoIExiCEHVfNBUn5Dm99+dYrB8aUla9UOeclW/vJ9wqxGsaUgD5m77/zGFsOcfz2SRaC8X+s2yFvKyV9fTQM1Dy8v8HXRS5LYsebQydKwWYRltEtGA6Q==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D507B6F93A45C14692CC1221A7FFC16F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d5a069-a01c-42a4-b6f6-08d7ebff474f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 05:36:34.1179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3/zSjo4hSI0e+mqDi8mow5Z5mof71L/1TdEQIIhN7jSVyb6qwENm51iH52ZGj/D3TUHMgZAuI2A01MMdjbihEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3365
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_01:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290043
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 28, 2020, at 10:32 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Tue, Apr 28, 2020 at 8:59 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> bpf_enable_stats() is added to enable given stats.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> tools/lib/bpf/bpf.c      | 10 ++++++++++
>> tools/lib/bpf/bpf.h      |  1 +
>> tools/lib/bpf/libbpf.map |  5 +++++
>> 3 files changed, 16 insertions(+)
>>=20
>> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
>> index 5cc1b0785d18..17bb4ad06c0e 100644
>> --- a/tools/lib/bpf/bpf.c
>> +++ b/tools/lib/bpf/bpf.c
>> @@ -826,3 +826,13 @@ int bpf_task_fd_query(int pid, int fd, __u32 flags,=
 char *buf, __u32 *buf_len,
>>=20
>>        return err;
>> }
>> +
>> +int bpf_enable_stats(enum bpf_stats_type type)
>> +{
>> +       union bpf_attr attr;
>> +
>> +       memset(&attr, 0, sizeof(attr));
>> +       attr.enable_stats.type =3D type;
>> +
>> +       return sys_bpf(BPF_ENABLE_STATS, &attr, sizeof(attr));
>> +}
>> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
>> index 46d47afdd887..5996e64d324c 100644
>> --- a/tools/lib/bpf/bpf.h
>> +++ b/tools/lib/bpf/bpf.h
>> @@ -229,6 +229,7 @@ LIBBPF_API int bpf_load_btf(void *btf, __u32 btf_siz=
e, char *log_buf,
>> LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf=
,
>>                                 __u32 *buf_len, __u32 *prog_id, __u32 *f=
d_type,
>>                                 __u64 *probe_offset, __u64 *probe_addr);
>> +LIBBPF_API int bpf_enable_stats(enum bpf_stats_type type);
>>=20
>> #ifdef __cplusplus
>> } /* extern "C" */
>> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
>> index bb8831605b25..ebd946faada5 100644
>> --- a/tools/lib/bpf/libbpf.map
>> +++ b/tools/lib/bpf/libbpf.map
>> @@ -254,3 +254,8 @@ LIBBPF_0.0.8 {
>>                bpf_program__set_lsm;
>>                bpf_set_link_xdp_fd_opts;
>> } LIBBPF_0.0.7;
>> +
>> +LIBBPF_0.0.9 {
>> +       global:
>=20
> You forgot to pull and rebase. LIBBPF_0.0.9 is already in master.

Hmm.. I pulled earlier today. Let me pull again..

Thanks,
Song

