Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A277421C286
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 08:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgGKG3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 02:29:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39118 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726671AbgGKG3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 02:29:16 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06B6KaSo023412;
        Fri, 10 Jul 2020 23:28:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tz6O9fUcICd+iA9/lskKSbWp8q6PgzVLZo20V6Fs1OI=;
 b=YXLN3pGPJT6cGHOyOYS/E1+GuciIHVT7tOFmhK8xE38IBSYORQtZ77WWkhJLStivgyzf
 X+Brw4/wC9H8rwQq0Xnpcw8XIpnuP65Ajg86a3uggR6HQNo5p5EUME6819OxzTUnY2/H
 VndrGPDgFWjxJESZhKj7r/q/k9xcJTzdOso= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 326yxdshw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Jul 2020 23:28:55 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 10 Jul 2020 23:28:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RM1BRTPRRFwklzitSi5gD5ZjqTuHm/T9Nj67koFe/Ougo8dkFMZO3RckxIKC57atWYb7YnDw+cs2RsAfdK6AI2c/3BzzFBine19xTzCBDIg2vdlJT8LT0P5yRWjcGZXcmekUrhMgY55d9rn92acY44ejRYV2+pBGnhP2GRjZO1CiKs096YJYxDtn2GK41w1mqcjPmpeqOgXPkzBFbXeZMOjWdvQ5fV9Sau7TSZsfNVLa5FwdAuX5pcHG+9mtBleAPfDZeuXfRqrUOnSA5WWEjazDkp993irjABGVxf1uB9LBfasCs4tyPak4RaHzVOjGgNEk4ABFcWueHjSvEMTsiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tz6O9fUcICd+iA9/lskKSbWp8q6PgzVLZo20V6Fs1OI=;
 b=BUIwJNSHIiBQWitii9REIlUJyk/U3Awkcq4TVFcyWpWlNmFRdW/F1WoPMVAe+21bNTMb1p2TiPpkwJYYUnMDoBkiSSzuROqEkLoWLXX4aUzXHm1GBbe8BTfqXj1DiSLsgwadKGspxeGDjUxSvfuY0S3dbow4lhN809sJMHJa87LUEI0mjMY6qJHktDOROhsxeGREfNO4py4jnRqmsXwvr/vDXTBTw/b6G+ux+Wiw6dgUuNhr1UnTbagLgLYf6LLhF6Qey+WI27DU35L2we8huSqNRNmFm09M+/Cq4KgBYWFRAfJjlBDTnrBy1DNR7Y0w0AtgNhwgq8Ivu0CyNrGVaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tz6O9fUcICd+iA9/lskKSbWp8q6PgzVLZo20V6Fs1OI=;
 b=RPDpgAr6DVYKeW8QyQO5RfV9VRfWW/fGP24J1PAhHJPMj0WwpPCtOjI4Rir/am5Xmt/I/SX4Gno3orjkofgfBAUyioyvohset+jm2ZOcY4WoqSa83Cq3/a/J5ew0FY/2UYI3IdaYqs8tLYjFQW16kn5RYATOE8O71AHl3Gezhk8=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2454.namprd15.prod.outlook.com (2603:10b6:a02:89::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Sat, 11 Jul
 2020 06:28:46 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3174.022; Sat, 11 Jul 2020
 06:28:45 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Peter Ziljstra <peterz@infradead.org>
Subject: Re: [PATCH bpf-next 1/5] bpf: block bpf_get_[stack|stackid] on
 perf_event with PEBS entries
Thread-Topic: [PATCH bpf-next 1/5] bpf: block bpf_get_[stack|stackid] on
 perf_event with PEBS entries
Thread-Index: AQHWVyKzhisy7cu33UCexze8SbKGKKkBv0iAgAArfwA=
Date:   Sat, 11 Jul 2020 06:28:45 +0000
Message-ID: <DEF050B0-E423-4442-9C95-02FB20F6BA57@fb.com>
References: <20200711012639.3429622-1-songliubraving@fb.com>
 <20200711012639.3429622-2-songliubraving@fb.com>
 <CAEf4BzaHAFNdEPp38ZnKOYTy3CfRCwaxDykS_Xir_VqDm0Kiug@mail.gmail.com>
In-Reply-To: <CAEf4BzaHAFNdEPp38ZnKOYTy3CfRCwaxDykS_Xir_VqDm0Kiug@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:f0b7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 046d5471-edf8-404b-9f76-08d82563aa1d
x-ms-traffictypediagnostic: BYAPR15MB2454:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB24546573355B5C0724D19387B3620@BYAPR15MB2454.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2oX005GTi7ewiotC9OaUbHQO1vvP2GjpJluzS2cYtkNG7aD6RR+iCfLIRTpFzGZZQG5IWvnBGOPFMifYcn2aUTOxAbpJaLL9tiFu5Vb/hf1JTXBy4jkTM9yOn0gcSwdTc7DM40+XD6m7dJFdtq+bR8KWJatUqOxHSOVVJHoBaRiUpDXr4ku5bVoYYSZZTgGykxFL2royrAOmQX5W19ZLsy5DP5rOah7CCaa5p7KAAsS5CCWNDaXQUceslXb8Ub3e375bORgSFfM5DwgU+lxYwzlqHeVaJ6NUWaGdxeXasTedUEh0dSLNddIh3/POBqJ0dd4Dx8rJvpH+yigqpYVC4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(396003)(346002)(136003)(366004)(4326008)(33656002)(2616005)(54906003)(2906002)(5660300002)(7416002)(71200400001)(53546011)(36756003)(8676002)(6506007)(316002)(86362001)(6512007)(6486002)(186003)(478600001)(83380400001)(76116006)(66446008)(6916009)(66946007)(66556008)(66476007)(64756008)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vO0ibpWzpYhRVg41mx6xwIvI1jdK2tm3kExnl0CdZs0VFcOUs9DrOdkxuMYnCGg7UxxJ/K6X+CSllOW4hwzasozkOptaLj+d0JfpsBzVmXJSaiwOSCR9uI1/xI7Tyhpww6plvRM6j4Esn+G3Df/x6KsGeE34cisTl9xKPtYVkVvXtvfMCDJgPrWzFi3EPQENDNTmLKW073KLg7nKTsbd77fwEGMaxWXsmpwF5aYq3gaOXPtCQOc4ES9lki30acQPz4H2W65AhJlD83NYz/vj34qeW8FC4XTznTsP8Q+x2p6bpj+zSCA9Ix1SrbYL+54d2KLTvCGsbPpWNg9d1QysBkZ+fPE6PdbAifwgDDHXVef4r7AS+dHM8thbFda1JyBmw7FgmZ4V7iXBJD8fyQxWXlKVgDykRttGpTkr1J9OK7zoC1huYydzvIg4GxT0qOs16zt188Ox10PfR6kKwlO0TBYL5yDMrmyRh3rBTilABoEepMAhIFii1OZfLYqiQi94jemxVHnCCk4piqo0ajw6Uw==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <01818A7A6E0BCE4D969F17D94EE6E372@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 046d5471-edf8-404b-9f76-08d82563aa1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2020 06:28:45.7514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GbowPEgYCTRfIQVfCVtaj+RiIvU/tCEjir5Tt0Yiqoz59wsWW4yWsuRHr7+5sLne3fta6FNZoosUnMzgIlZlWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2454
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-10_14:2020-07-10,2020-07-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007110047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 10, 2020, at 8:53 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Fri, Jul 10, 2020 at 6:30 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Calling get_perf_callchain() on perf_events from PEBS entries may cause
>> unwinder errors. To fix this issue, the callchain is fetched early. Such
>> perf_events are marked with __PERF_SAMPLE_CALLCHAIN_EARLY.
>>=20
>> Similarly, calling bpf_get_[stack|stackid] on perf_events from PEBS may
>> also cause unwinder errors. To fix this, block bpf_get_[stack|stackid] o=
n
>> these perf_events. Unfortunately, bpf verifier cannot tell whether the
>> program will be attached to perf_event with PEBS entries. Therefore,
>> block such programs during ioctl(PERF_EVENT_IOC_SET_BPF).
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>=20
> Perhaps it's a stupid question, but why bpf_get_stack/bpf_get_stackid
> can't figure out automatically that they are called from
> __PERF_SAMPLE_CALLCHAIN_EARLY perf event and use different callchain,
> if necessary?
>=20
> It is quite suboptimal from a user experience point of view to require
> two different BPF helpers depending on PEBS or non-PEBS perf events.

I am not aware of an easy way to tell the difference in bpf_get_stack.=20
But I do agree that would be much better.=20

Thanks,
Song=
