Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D1922A8D3
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgGWGUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:20:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35200 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725984AbgGWGUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:20:53 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06N6AlNh006540;
        Wed, 22 Jul 2020 23:20:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=UhwR0T2vMUNqABzRoeZrzbAvRhkDEuRcZILTsvvlwLQ=;
 b=la6rYz1rpkVcSmo6EnPBlDyuQM2ak/LTaSZPW3Zu3Bp0hR6PIBVX8g8gyyxQLdWrmCUq
 9hUxSdJnO/asIAgMlbZ3nDFgAyv1MGMsQRcFXHyiYza/L/KjqEE7j/ygVQcRtH17c/24
 PnbxkZFzC1pcVx11zo2t7MnuGqS6lZzQp1A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32etmwajhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Jul 2020 23:20:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 23:20:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOaIimL2vUNvgfz7C/6id2c8GU7yyc+v17W4IFuW11UE17MP1S3AQa9o7/d5pza3QauV1AFvzjOwTgJqmmu7DizPj6Lb6ZsePj28dWVb7sRsqnQxmre2ELkQFiqFVU/enXMVOxhk2xYZycBF+mX6jAbuTyyM2KYMooz0OTyOup2ZWsGIZnfSkbxie8MOqPQLkPTZaXP4Gh2kvEnIG6gmCcrC/A5ekZldPbddOTJKVTslzszxTbJSrBDkG+SO8pbh//MpN0V0DprRKFyrQfd2cfo5dMpgfBkilea7k37MbppM3K4aNtVPbELYv2Kh8dQdgnxkL37iwjqousrScvttQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UhwR0T2vMUNqABzRoeZrzbAvRhkDEuRcZILTsvvlwLQ=;
 b=a1fg9LyZ4fcIDKpAgwy6uDOLRK4CttEF0pG1eGq62WbZ83M7VE4BFvdBD6hITmFezSpnvEQSjDWWjyeSmJlkkUTPEjsjPzCeEQv6TfY+Nnd6gHdgztX/g61hjpQ07qJmH4+3FsmZ2mxBuqqFY065vQQD4vt/bIEZr3bErhA0gSfJr+x78fGQIGSCFzOK6MlN/sIV0WzkzU+J+SrH9JjE3uBlE0rSA21ZHSAREIpqfVrJFBCzhhhAoGsnmzXpPqMUhNKDcCpeirxSh3UCxilutyKUfO8jWOaewqjRZ5BGVAI7vV/5ReUctloL79LFdJCr0BboKsUp6CC0dWBkPRTXaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UhwR0T2vMUNqABzRoeZrzbAvRhkDEuRcZILTsvvlwLQ=;
 b=FdfHArwFStdsgsHFvCURQ5jfki2o5DZWZqOuySos+AALmRuzGmjhObxAxegvLZS4N5C3fqI/JlRA1dhscMuDjeo8lNG+Em6dUTvTMAtUjbtnOb/cfir4cMrIDfawy+qXL2oAvJjfzZ1v7gADeDpKUhVex1AKuFjuEpLzS79uiTQ=
Received: from BN8PR15MB2995.namprd15.prod.outlook.com (2603:10b6:408:8a::16)
 by BN7PR15MB2483.namprd15.prod.outlook.com (2603:10b6:406:87::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Thu, 23 Jul
 2020 06:20:29 +0000
Received: from BN8PR15MB2995.namprd15.prod.outlook.com
 ([fe80::a89e:b0f9:d0b9:51a2]) by BN8PR15MB2995.namprd15.prod.outlook.com
 ([fe80::a89e:b0f9:d0b9:51a2%5]) with mapi id 15.20.3195.028; Thu, 23 Jul 2020
 06:20:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: fail PERF_EVENT_IOC_SET_BPF when
 bpf_get_[stack|stackid] cannot work
Thread-Topic: [PATCH v4 bpf-next 2/4] bpf: fail PERF_EVENT_IOC_SET_BPF when
 bpf_get_[stack|stackid] cannot work
Thread-Index: AQHWYFg8vuUCJ74xFUm7fXSqHe+MGakUqv8AgAAHCAA=
Date:   Thu, 23 Jul 2020 06:20:29 +0000
Message-ID: <684DA506-6780-4CB5-B99C-24D939CDE6DF@fb.com>
References: <20200722184210.4078256-1-songliubraving@fb.com>
 <20200722184210.4078256-3-songliubraving@fb.com>
 <20200723055518.onydx7uhmzomt7ud@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200723055518.onydx7uhmzomt7ud@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:b2a1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 473dd7a5-9ff3-497c-e88e-08d82ed07f1f
x-ms-traffictypediagnostic: BN7PR15MB2483:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR15MB248366052172F7D06FBC90E8B3760@BN7PR15MB2483.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p+tvIytnJycn7Bg/I4y9nevEPQtgss/9fDneOk+zQ72OEzwImLDvzy28k/0Mb5O9bTnxzSO8S7k5ApDq3+7PmMt6+qSvSe1Z3XLu8lxacyD7yr6X9YCSxsAKk5M0UzO3eJ0AL63vZ+yh0yXBeN+xwoCXHEBX9awvaTgoaCbpWzVy3vueomObZAhTCzRL3N0Bb6rGGyPhNxWJ+bK3F2xZ/ZjfK1RUc21w5gcYkGGdz79kIa+6fsiTHE0GDqEwneO4MIaY08jvWaXBNeC8W/b+X3pYmiaE5FCaTDesU3DpRsOn/0fgtTDQFVEABixnquFSC3GSYQIkEnPGGm9Qcs9Esw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB2995.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(136003)(396003)(346002)(366004)(8936002)(33656002)(316002)(2906002)(86362001)(6486002)(8676002)(71200400001)(186003)(83380400001)(66446008)(66946007)(66556008)(66476007)(7416002)(478600001)(4326008)(5660300002)(6506007)(6916009)(54906003)(53546011)(91956017)(6512007)(76116006)(64756008)(2616005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: AwP9K7xihoJAdFhvQ5FCbiudCXXCDISZzzCfrMeTlGNB8e55fvqx3ybdwhRGWK0SlTVlc4zv60BI5mksYxhSSowd6/7L7Cj/RD7LV0EU9lG4HXFkHXcIAyhI6S+N9BiRJyBLOCapKJltQA8SMx5t4c5QdVrKQtOnopa+rVbbB8mkPmLJw7NHJWpsBELTKSD4dkCM6QV+HLtl2R7c2+5686DMsVQCFf/v+GFV6I9AmzYEaKfU0mdtX7Wy5f7ba7fiVEsUdT8gyAICqf+/CdCRf1Smrz2KUqdOPmIO8S6ZCYnldTJWL6MYgC1/yx+ur9Ewb9gQGTbjdi+AHlV31JqP1Me3xfrWGFRaGGKJgo0Cqejum3oVavdgstTnQaCQPS2R0RuxmT2zR3GteTDuRvkA4jhecKL+y2Cf2HFeWMZ1m0yNExYY2YPQw38+knFlen93MM8nK2pnnUJJJEjlB+4uxxHOyyIWfle5wG27d3FsP5ThwNgWCYUQ3Cxr3Lrv1pyb4DELFoovg+saI1ph22agXg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4C7094C581011D4E9F3722B2F188D225@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB2995.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 473dd7a5-9ff3-497c-e88e-08d82ed07f1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 06:20:29.2638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vAU2WF8NegWfn6WGcbfOaf7helyzLdqdctl7Nieuml9VmelVWgbj9K51oAuUC9I8RcJQf32yLwalpuY/13HbYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2483
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_02:2020-07-22,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 clxscore=1015 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007230050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 22, 2020, at 10:55 PM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>=20
> On Wed, Jul 22, 2020 at 11:42:08AM -0700, Song Liu wrote:
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 856d98c36f562..f77d009fcce95 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -9544,6 +9544,24 @@ static int perf_event_set_bpf_handler(struct perf=
_event *event, u32 prog_fd)
>> 	if (IS_ERR(prog))
>> 		return PTR_ERR(prog);
>>=20
>> +	if (event->attr.precise_ip &&
>> +	    prog->call_get_stack &&
>> +	    (!(event->attr.sample_type & __PERF_SAMPLE_CALLCHAIN_EARLY) ||
>> +	     event->attr.exclude_callchain_kernel ||
>> +	     event->attr.exclude_callchain_user)) {
>> +		/*
>> +		 * On perf_event with precise_ip, calling bpf_get_stack()
>> +		 * may trigger unwinder warnings and occasional crashes.
>> +		 * bpf_get_[stack|stackid] works around this issue by using
>> +		 * callchain attached to perf_sample_data. If the
>> +		 * perf_event does not full (kernel and user) callchain
>> +		 * attached to perf_sample_data, do not allow attaching BPF
>> +		 * program that calls bpf_get_[stack|stackid].
>> +		 */
>> +		bpf_prog_put(prog);
>> +		return -EINVAL;
>=20
> I suspect this will be a common error. bpftrace and others will be hittin=
g
> this issue and would need to fix how they do perf_event_open.
> But EINVAL is too ambiguous and sys_perf_event_open has no ability to
> return a string.
> So how about we pick some different errno here to make future debugging
> a bit less painful?
> May be EBADFD or EPROTO or EPROTOTYPE ?
> I think anything would be better than EINVAL.

I like EPROTO most. I will change it to EPROTO if we don't have better idea=
s.

Btw, this is not the error code on sys_perf_event_open(). It is the ioctl()
on the perf_event fd. So debugging this error will be less painful than=20
debugging sys_perf_event_open() errors.=20

Thanks,
Song=
