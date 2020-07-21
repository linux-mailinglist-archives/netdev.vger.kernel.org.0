Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD6E228C11
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgGUWks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:40:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21556 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbgGUWkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:40:47 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06LMdOjV027739;
        Tue, 21 Jul 2020 15:40:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=CPmMphmg2cWfdiAV+qBP2rm8T0W9k0tHWlSklDm03NI=;
 b=MZZFN9NfeZ+PNK4Y2zZyC0JCeKKLeuTcfaafrG1TcUmITu09uhJuFmFY3U4FglG95TNX
 b3z0XxzzXxqFqW0RmkgnMgz2u3xGv0l4Pq2l09GXxZphTq6n3Db9vDjSD6YcFptzXaDW
 CcSc9vYrS3AvGk/plFeak5hbsD3Fwv3j4rU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32ch2rkwqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Jul 2020 15:40:25 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 15:40:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FokWl9snh8EWJtj2sREH7kcP9amuK2gN5wlT+xoYm77HbDcrbULnkSgPZuRYdzJRYF1zU9B+dk77EmlZ3Omr1iSjls0td7XP8BOpm0ke/SVaumIg/v+aY7pKpvNGEp6oQyLUE08aKobZ7flaw1kgEPf7/P6uPk4EvcKE7KrSKYmxRuFQnSmtIVNQ16NWGivgkWJ+/m8+RfY/rP/gXxAbyxE+EBsrBiO5ZtnB6k/s2fw8uMLHhmYetRAtNXTIau8sXFqoslZsSxILQXCe11F/aNyFvYZww1uP8gAPHthGonBPq84oFxs5andIBZLZmxesrNiJcnbcMALZmRYUnzJbsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPmMphmg2cWfdiAV+qBP2rm8T0W9k0tHWlSklDm03NI=;
 b=f8Z300Wylb3Y2UDp8xC6lKuO1RFRGdasNIUtZPiMkyynuyKqdm9hFnZlMyY/dLo7k0edjN8psgUFc4cE5ARZx/eQDW8od2rLmFo/4wbzoQEbrLBOfCuG/QHPOKqIPt47NR6d+JpPbGhlbm38+fnsfftMUrCtIyNTj0EJKkUC8Btzqzyj7oCnEfe8jZGeF3oaNJYoDhiV49CeW4IBH0OEvpO3sdKK76mVqMBQt2zEbEoRIPTs6oFQQyuM1X8ZcbeheKqzmH+Ep5Po+gw3c8JelKH1O4il5Z9+ASGaw42iT992oUfczSkpLqL43OhuRiAaYVbnKMm0PqA0apo3m7Faug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPmMphmg2cWfdiAV+qBP2rm8T0W9k0tHWlSklDm03NI=;
 b=TZSUDSRc0YF+jO4ipXGdxWanQPeZMp4P3t9/QYbTNd/1H+C+//4k2MekNU48FqcfQ5GexBUwM+M/azkyRG4bVJpfwpiaI2TyyPdeBsbGZYuO/OXN0B93Oz4z/YuiJfg4mPG/Nz3lzf9qgYIAKsL0p8IamYBLtfdedHJreWSSdj0=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3464.namprd15.prod.outlook.com (2603:10b6:a03:10a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 22:40:20 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 22:40:20 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: separate bpf_get_[stack|stackid] for
 perf events BPF
Thread-Topic: [PATCH v3 bpf-next 1/2] bpf: separate bpf_get_[stack|stackid]
 for perf events BPF
Thread-Index: AQHWW8VAnRb4OqAgyEOVqqMnP7xn/akSbY+AgAA6uIA=
Date:   Tue, 21 Jul 2020 22:40:19 +0000
Message-ID: <42DEE452-F411-4098-917B-11B23AC99F5F@fb.com>
References: <20200716225933.196342-1-songliubraving@fb.com>
 <20200716225933.196342-2-songliubraving@fb.com>
 <20200721191009.5khr7blivtuv3qfj@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200721191009.5khr7blivtuv3qfj@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:bb45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a85f7c06-5551-4bb1-6886-08d82dc70c3d
x-ms-traffictypediagnostic: BYAPR15MB3464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3464592A1DFA7D5604810B6EB3780@BYAPR15MB3464.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8OqGcX95ApjB4VfwTCom6fnsRd4lFAJFxf5WuuioHRcDL0Nl6+k+rY5poKWQhrx3AB3XXK2yf5OINf6C2u3oIgj65AY+7fYBaY/1su5V5Qr+LwR0lPU1spmH4bT+s0nzjbsg6mbBGABriV3afhZUDFwKpdtJ/qEnr0e+MHfdRQt9ZKfWnG25cerSf3+/Ad0bRftzQS1vZgmdLZWWApWudrpgY3WlpCYz0Nu1lhqFMX2jojj50B9Hm0vt8vzzcfoeyguMvwuV5UN1hraGfL92hoIXTD5vOxun+0yWoB0N5kXJTSKZJbsjF1+zV3SL2x07/q6Urn1qRmkLlnI9gEUNVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(346002)(39840400004)(376002)(136003)(83380400001)(66446008)(76116006)(64756008)(186003)(6512007)(8936002)(66946007)(66556008)(66476007)(6506007)(36756003)(6916009)(478600001)(53546011)(8676002)(6486002)(54906003)(86362001)(71200400001)(2906002)(5660300002)(2616005)(316002)(7416002)(4326008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: M00xqr2p2QLBLOa/cTjQ7EvVhfqtlO1fhydwB61OP4bDrqpKjnhAqpoWomdlvNZ9fe0Oe+DUD3RlFn1EW4A/chbzJ5AOglKle6voJh4eEvX0Nn4R+dEoND0stSn8jyLS5zAqHJp5IuGmoSE3KTROf5BbJqn8AEV6DdWThSEaJUEwdSudbJ2xlxxUbqNMOaNtw70maiNpLf7itdCPHcm2FE8wti1/iH+F5fF1sjL1CvJ7blSJehSiwi3a/u3MC1wN4+rpaOf4B6osoHQYDHGZpCzRJBBeVvg7JxVD3SzMY797cufVsjVcBiBUmosB1gG+BUwLS6ieIY4HXHgpC8c/XD7n4h3qHp10EPmlDy38K/4yzpsFBemhjMa28sUxUD1esyC86x0+CDrWQTVOgwuNt0fStt5A2CyffdTJjYiay2LsQXrCJz3j4dVBJk3WwPAXMdX8PsyrIIUeSjLRtvcYY6agkSsAb4jP/FHcClIPW5jLJtjYMfAD5cWO54DIX6CH+iK4zDVzGb465PN0Vxy9ZA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1C8836F68A3ADA4FBDB45592CCE0073D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a85f7c06-5551-4bb1-6886-08d82dc70c3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 22:40:19.8029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GyN/GUjXtMaNToH7fzKgd60BBrxeb2ofElIunbnKErYtVzzaqdHk50eX/yehNy7GVBt4g2v34Zo8l8bI8/QUDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3464
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_15:2020-07-21,2020-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 21, 2020, at 12:10 PM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>=20
> On Thu, Jul 16, 2020 at 03:59:32PM -0700, Song Liu wrote:
>> +
>> +BPF_CALL_3(bpf_get_stackid_pe, struct bpf_perf_event_data_kern *, ctx,
>> +	   struct bpf_map *, map, u64, flags)
>> +{
>> +	struct perf_event *event =3D ctx->event;
>> +	struct perf_callchain_entry *trace;
>> +	bool has_kernel, has_user;
>> +	bool kernel, user;
>> +
>> +	/* perf_sample_data doesn't have callchain, use bpf_get_stackid */
>> +	if (!(event->attr.sample_type & __PERF_SAMPLE_CALLCHAIN_EARLY))
>=20
> what if event was not created with PERF_SAMPLE_CALLCHAIN ?
> Calling the helper will still cause crashes, no?

Yeah, it may still crash. Somehow I messed up this logic...

>=20
>> +		return bpf_get_stackid((unsigned long)(ctx->regs),
>> +				       (unsigned long) map, flags, 0, 0);
>> +
>> +	if (unlikely(flags & ~(BPF_F_SKIP_FIELD_MASK | BPF_F_USER_STACK |
>> +			       BPF_F_FAST_STACK_CMP | BPF_F_REUSE_STACKID)))
>> +		return -EINVAL;
>> +
>> +	user =3D flags & BPF_F_USER_STACK;
>> +	kernel =3D !user;
>> +
>> +	has_kernel =3D !event->attr.exclude_callchain_kernel;
>> +	has_user =3D !event->attr.exclude_callchain_user;
>> +
>> +	if ((kernel && !has_kernel) || (user && !has_user))
>> +		return -EINVAL;
>=20
> this will break existing users in a way that will be very hard for them t=
o debug.
> If they happen to set exclude_callchain_* flags during perf_event_open
> the helpers will be failing at run-time.
> One can argue that when precise_ip=3D1 the bpf_get_stack is broken, but
> this is a change in behavior.
> It also seems to be broken when PERF_SAMPLE_CALLCHAIN was not set at even=
t
> creation time, but precise_ip=3D1 was.
>=20
>> +
>> +	trace =3D ctx->data->callchain;
>> +	if (unlikely(!trace))
>> +		return -EFAULT;
>> +
>> +	if (has_kernel && has_user) {
>=20
> shouldn't it be || ?

It should be &&. We only need to adjust the attached calltrace when it has =
both=20
kernel and user stack.=20

>=20
>> +		__u64 nr_kernel =3D count_kernel_ip(trace);
>> +		int ret;
>> +
>> +		if (kernel) {
>> +			__u64 nr =3D trace->nr;
>> +
>> +			trace->nr =3D nr_kernel;
>> +			ret =3D __bpf_get_stackid(map, trace, flags);
>> +
>> +			/* restore nr */
>> +			trace->nr =3D nr;
>> +		} else { /* user */
>> +			u64 skip =3D flags & BPF_F_SKIP_FIELD_MASK;
>> +
>> +			skip +=3D nr_kernel;
>> +			if (skip > BPF_F_SKIP_FIELD_MASK)
>> +				return -EFAULT;
>> +
>> +			flags =3D (flags & ~BPF_F_SKIP_FIELD_MASK) | skip;
>> +			ret =3D __bpf_get_stackid(map, trace, flags);
>> +		}
>> +		return ret;
>> +	}
>> +	return __bpf_get_stackid(map, trace, flags);
> ...
>> +	if (has_kernel && has_user) {
>> +		__u64 nr_kernel =3D count_kernel_ip(trace);
>> +		int ret;
>> +
>> +		if (kernel) {
>> +			__u64 nr =3D trace->nr;
>> +
>> +			trace->nr =3D nr_kernel;
>> +			ret =3D __bpf_get_stack(ctx->regs, NULL, trace, buf,
>> +					      size, flags);
>> +
>> +			/* restore nr */
>> +			trace->nr =3D nr;
>> +		} else { /* user */
>> +			u64 skip =3D flags & BPF_F_SKIP_FIELD_MASK;
>> +
>> +			skip +=3D nr_kernel;
>> +			if (skip > BPF_F_SKIP_FIELD_MASK)
>> +				goto clear;
>> +
>> +			flags =3D (flags & ~BPF_F_SKIP_FIELD_MASK) | skip;
>> +			ret =3D __bpf_get_stack(ctx->regs, NULL, trace, buf,
>> +					      size, flags);
>> +		}
>=20
> Looks like copy-paste. I think there should be a way to make it
> into common helper.

I thought about moving this logic to a helper. But we are calling
__bpf_get_stackid() above, and __bpf_get_stack() here. So we can't=20
easily put all the logic in a big helper. Multiple small helpers=20
looks messy (to me).=20

>=20
> I think the main isssue is wrong interaction with event attr flags.
> I think the verifier should detect that bpf_get_stack/bpf_get_stackid
> were used and prevent attaching to perf_event with attr.precise_ip=3D1
> and PERF_SAMPLE_CALLCHAIN is not specified.
> I was thinking whether attaching bpf to event can force setting of
> PERF_SAMPLE_CALLCHAIN, but that would be a surprising behavior,
> so not a good idea.
> So the only thing left is to reject attach when bpf_get_stack is used
> in two cases:
> if attr.precise_ip=3D1 and PERF_SAMPLE_CALLCHAIN is not set.
>  (since it will lead to crashes)

We only need to block precise_ip >=3D 2. precise_ip =3D=3D 1 is OK.=20

> if attr.precise_ip=3D1 and PERF_SAMPLE_CALLCHAIN is set,
> but exclude_callchain_[user|kernel]=3D1 is set too.
>  (since it will lead to surprising behavior of bpf_get_stack)
>=20
> Other ideas?

Yes, this sounds good.=20

Thanks,
Song

