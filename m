Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECD01BD210
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 04:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgD2CGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 22:06:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52238 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726158AbgD2CGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 22:06:34 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T24tbg012935;
        Tue, 28 Apr 2020 19:06:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=n6vyZ9X8GmglwGqww4tPImMKFEHpCn3UBwtf6IzrK6w=;
 b=fqoxHRpP3SYOFtx+wrRu4IkNrL6s7U4KIdyxGsEM2rdd1CJfZVQvsg+0/ubUeDlgZE4/
 RMSSqRnMM104PTO8eZT/sXjOlILxqmJ8ujmrx+ngrltWNba/yn8xnjxbCL7IPa3frI1r
 c5Fd7rL0L16zLDRlPR2KTZHqeYX0LMqczCI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30pq0dc822-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 19:06:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 19:06:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hqyej9j9X8vwhhOd8iXvbLjPL/azwkM8gwjQJVzZueoehXPVl8PHEK+d0/aHQbMbO9jh8mvaMN0UsAmPb+hrY3WVoTrDEU45cqiTnBpi22aJ5n5G1wPZb2+b9WFd3tNIyLa2fs0lCI6CAXFnTN+Xhh8cVxS+vSHf02xNSl218I3urW/nyi76K0OOS7mAwjRxji8zGlnSmxTS7ZSggXmfUusiT670l34Z+44aXpCFTx932O5not1frt47OOWQluUYj8Z6oE8YVp9e8oCVsck1QFj2rdSO9gczlqJCwH9JZKVCyPWtvrkyiNEayiiOoZywnIuOUbWCI+krgPtoRmJ8nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6vyZ9X8GmglwGqww4tPImMKFEHpCn3UBwtf6IzrK6w=;
 b=ZL4ZfDYNioVr6sFseRELDFuvHkJtU387aeqGFyHPua3Hr1VbEqUIpQm/NsBxv0DqHJsOInGCLZsrjhUePJzBxeBx9Q4bo0VZjlC01zflrBAWfjP2ugQYVNbzC3VHc7/lpDUa4I5k0A14NJQZUJVzRrjSeoUWmGTOHo8Nrv1oRSSxyGRoAcje/N4NnY18VAY8lkgLiZmDcQN7d9LQWPINWpTNZ4PjCC3olC4VmZPtWCsqQNt2d/W+9cj1Ngv/lvUFAj25Yej8hkQTjQ5Jt5P6DAkxNuWWGOFA2HTnfV0QOtsJ70aabBLd+iljpeo6d+RMNFy8R9yJyIj38kKe0Tbgxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6vyZ9X8GmglwGqww4tPImMKFEHpCn3UBwtf6IzrK6w=;
 b=JM97H2dZV4z6neFbOJ/4vjK7qft8c15OQcpjftSWtV6GFxDzDzHDpwv7IqZR855dcK9q34M7tWu8VxTWWhb+/n5A0CWIp1BD1ZKKd9pznPzcfzk5/ViJbZrWWQTx4+sEVm6e1WmKE8mCTE65lVo6Lzp8ZjZpulWsAmDyrC/ob3I=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3397.namprd15.prod.outlook.com (2603:10b6:a03:10b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 02:06:15 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 02:06:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v6 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Thread-Topic: [PATCH v6 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Thread-Index: AQHWHb1NltGNzgSfaEStSSTqu/dK9aiPQD4AgAACuwCAABcRAA==
Date:   Wed, 29 Apr 2020 02:06:15 +0000
Message-ID: <78ED2E6A-BA51-4A1A-80C9-865215A25760@fb.com>
References: <20200429002922.3064669-1-songliubraving@fb.com>
 <20200429002922.3064669-4-songliubraving@fb.com>
 <290a94fb-f3ee-227c-ffa0-66629ce8327a@fb.com>
 <20200429004340.5y2c3rkr64u43sfg@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200429004340.5y2c3rkr64u43sfg@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c58d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8790a44-ba80-4136-5bd7-08d7ebe1e601
x-ms-traffictypediagnostic: BYAPR15MB3397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33978089DCAC2F6555C6F461B3AD0@BYAPR15MB3397.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(136003)(396003)(346002)(376002)(66556008)(53546011)(66476007)(76116006)(66946007)(6506007)(91956017)(64756008)(2616005)(66446008)(4326008)(6486002)(478600001)(54906003)(186003)(86362001)(2906002)(5660300002)(8936002)(8676002)(6512007)(36756003)(316002)(6916009)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T/ykHsHpHRgUDXaA6E9x2nr0jOpEKkDQZcNU9VT9qHE61y+StX6yRMhPotAZzXYPGJCH0MXm57A9czmAkoGbSbX6GT5QVUYZM2FZGbJvvtOeqqQ7rr60kqfSs9jdSx2sgXhkInCxM/apwwEn7pm0tV8rPzlA4y4SDf2rbFOElj8zGzTBG1Q2UkxD0RDDrr1I2pRmhc+BCvSGy5MJfpq2cQia+173FOEbvXsMo3gps+WNRoIoNFE3zf4xHGkUkR+JABdwCdM2ppFaMbq45ZULnxyc86/oyn5OSLFclb/abYqg3Iyr1iCt5beEkRgzd684cHYsajWD04yBO0JANOLsRjPF1+tWDncYhUXHto3g1gbTpf2Yj9nr9kXs3b5gpjW0pGyFcOXC2rL7+bRqGllCH1tQ3Fiam/VkU7DkJhiEs4qXYRT+wvlzJ1bYOnipqqXA
x-ms-exchange-antispam-messagedata: 7PZLjZXjsyMl3MyDUF/8s5Ly/FX4Qakx0mR92tYT6Yq1yX+uPKidUqq0gJ10AFodb5/gcIFoU5R6Jy/RCpW6d2Oe7xRTmtyrve9eUGKdJROA5Zst3azmzEZrWVxqT1fCRzhwshKVOC/Wi95BiUgRLWOTQi7+U2CzEClm0d0ta1GycxIV3N83mwAqb03zQGSzGp3e2WbkIXvXANjXFHFZxxwBDHmgGh7QYxcqxr5MiYO1qrXJDjPRvOoH0w4IhEZMf1Sankufmo1qsHpUB6Fp9z6hL68AX37ol7uzglhG9Q5rXO2xgXwO36f+1KlEVTO/uFA2Qt+8vMNQbrXkAbMyNuGs9jvIRh4vYOej75kY8CemNlgpvCsHkRNMlgJyT1IXPXoZRfaivGZ3FppzMoTvUiHmVRWfKs8nuvPQ/CQSN3P7wDPPrqcSNwhruYKKIHV2RVfNkkJ6puq+XMSNx21VNdq0w7e8NVMWP+ANHlvC1t0+XhtCJ/bQrZVQGw4sTSjIRO6jLGA+QtkylK5RtXNpvLwDuXvZi7OvfRbB3XFxFsCKevS1HdrdxIV0Sk5oQnT5+/6HJ4b0yGDAMgxeI3ZF3cVfIkYVC7Ow6UtShlBulvpMrDA1W+jyjaaR2LXTcOXrdzS4v8KGTXgjV95jDOmmsXiJK05+3dRMx60xW0RS8WS4Jlq3zmFhd9vFmp8GTMqPp7N5D9pFN2nfdOzYk6sqQjCIFrgkIEVj6nmwVgmetAOY+ObzqQWqWJjXtjW0d79C92OZWn7hTjUCwXK+9sC4JFPqJXYIzpUbEFWCJPmC8ON5edPGhf02KOkwIeQ+AnrSnUy63xTKffGOoYda2KI1Ng==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <496A8AB254760241B37F7049287A1CA9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a8790a44-ba80-4136-5bd7-08d7ebe1e601
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 02:06:15.4602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Us7OCXHnBlKOYAGauDzEKs3ahU66uRjjD7gtwK9/zsj0f/fdwCU+c7+rYDUPfV7REPBiOF51b+p7v370Qz+UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3397
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290015
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 28, 2020, at 5:43 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Tue, Apr 28, 2020 at 05:33:54PM -0700, Yonghong Song wrote:
>>=20
>>=20
>> On 4/28/20 5:29 PM, Song Liu wrote:
>>> Add test for  BPF_ENABLE_STATS, which should enable run_time_ns stats.
>>>=20
>>> ~/selftests/bpf# ./test_progs -t enable_stats  -v
>>> test_enable_stats:PASS:skel_open_and_load 0 nsec
>>> test_enable_stats:PASS:get_stats_fd 0 nsec
>>> test_enable_stats:PASS:attach_raw_tp 0 nsec
>>> test_enable_stats:PASS:get_prog_info 0 nsec
>>> test_enable_stats:PASS:check_stats_enabled 0 nsec
>>> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
> ...
>>> +static int val =3D 1;
>>> +
>>> +SEC("raw_tracepoint/sys_enter")
>>> +int test_enable_stats(void *ctx)
>>> +{
>>> +	__u32 key =3D 0;
>>> +	__u64 *val;
>>=20
>> The above two declarations (key/val) are not needed,
>> esp. "val" is shadowing.
>> Maybe the maintainer can fix it up before merging
>> if there is no other changes for this patch set.
>>=20
>>> +
>>> +	val +=3D 1;
>=20
> I think 'PASSED' above is quite misleading.
> How it can pass when it wasn't incremented?
> The user space test_enable_stats() doesn't check this val.
> Please fix.
>=20
> usleep(1000); needs an explanation as well.
> Why 1000 ? It should work with any syscall. like getpid ?
> and with value 1 ?
> Since there is bpf_obj_get_info_by_fd() that usleep()
> is unnecessary. What am I missing?

This test currently doesn't test the value. It simply checks
run_time_ns is none zero. I guess it is good to actually=20
test the value. Let me add that.

Thanks,
Son

