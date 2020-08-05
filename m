Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F77D23D441
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 01:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgHEXup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 19:50:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21378 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725969AbgHEXun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 19:50:43 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 075NnnIi020753;
        Wed, 5 Aug 2020 16:50:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9tukbzHfY5wl0oA+ruWE2aIr+IuF0R+RiKoUEVZ4544=;
 b=Qwn9BsHSjgFXh1nTnk55l0gj3WnS//Bw/NKQgk1U3Uz1yTOH1uHEgW8MyJK2XHecY02/
 HjMO7ptVy+syt7IrBWmXSddkii8rT8CygVMs3ZJHJwGC8opYGrej/wrQKab/JuYJcNKX
 i7T2GU7vig8IS6OsffDcxrG9zsTjaYEvPHs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32qy47ahjm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 05 Aug 2020 16:50:24 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 5 Aug 2020 16:50:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvqgd/mJ74gapkJ3gkU4WWeh3zZtOEf1UgkdCOmxD2XoYxmEduCV/q/jBcUepvKNMYHvuMgQMA2j3WaIOiMQ+oN6pr9wJSWdF1+WYUNuh9BKArp1FAgMYYuaG5zldKXO8sCmMEHlmr4Mt+1/w0DoW4nbCcOBFpw//3NLFMouED6nbzENzp5buLT5E3qr1eSpSCwu3cLjroMmxHfKLHYQ8V2rbNVLH6f5kLauUkvTTW3mpM48C2QljhEC8sEuwYB/hS8KgBmO1Uh7gf9JOlTwltC2IfLefQtUzXaPX7cTfbgbe4H6TSM7b7kRdkelVt+Tki5VJS7mA3KZ8BemHZUMpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tukbzHfY5wl0oA+ruWE2aIr+IuF0R+RiKoUEVZ4544=;
 b=NjbOBo+j+5Otdt1JG1vL0LFcFwnfMCWU1moN4SJiKjjHxD+RLgelHWyVoJwBSKMtBizTTC1iEiH9juETTJFDn2a+MB8SpQ5sWZfOrKHWbOEvLbZ1RB6FLNAZkOZG2UiQGJYgBl//pFNgCTNI0Yq6zGnEpbNyWvfzFLdN111031s3rYN3NOx3njkARkpjLRdPGUU/GpPm/CH2qy5ltA3WDWBMOdsq1iSz4SVpSQpTY43EFM+DuBtI1c2Gy00VezjrNPSdqR0MkWiFqIh/tU+ld+UqNr3CYirKX6Npq9O2sUc+eGyi5wul08EoFImf3oA3bm3nYMlKBvQi2pB6uY6pAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tukbzHfY5wl0oA+ruWE2aIr+IuF0R+RiKoUEVZ4544=;
 b=Qhh39vDG3KTyAXMghQzq3qWAB9DkE0rkz1YqnYQLlYr43+WUtoMTrvrukiAoGHpkUc6Mlte0xTPGCQnqgVIJ1huT3r52f2j9BLCGDgnO1vjxJncrd4dL6eNJsnnA36KFE3N9ukhi8M6nHZB/CdIE88eei7SeKEbA06mpcFJLnFQ=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2326.namprd15.prod.outlook.com (2603:10b6:a02:84::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Wed, 5 Aug
 2020 23:50:09 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.023; Wed, 5 Aug 2020
 23:50:09 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "john fastabend" <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs.
 user_prog
Thread-Topic: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs.
 user_prog
Thread-Index: AQHWZ+C4z/mDZUCS20yCUvtKcPb5ZakloXcAgAAxPICAAAZdgIACmfGAgABTZwCAADDfgIAA0VOAgAAb4ICAAEFVgIAAELqA
Date:   Wed, 5 Aug 2020 23:50:08 +0000
Message-ID: <5D24F0EF-6592-402C-BFF8-34119FFF7A2C@fb.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-6-songliubraving@fb.com>
 <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
 <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com>
 <CAEf4BzY5RYMM6w8wn3qEB3AsuKWv-TMaD5NVFj=YqbCW4DLjqA@mail.gmail.com>
 <7384B583-EE19-4045-AC72-B6FE87C187DD@fb.com>
 <CAEf4BzaiJnCu14AWougmxH80msGdOp4S8ZNmAiexMmtwUM_2Xg@mail.gmail.com>
 <AF9D0E8C-0AA5-4BE4-90F4-946FABAB63FD@fb.com>
 <20200805171639.tsqjmifd7eb3htou@ast-mbp.dhcp.thefacebook.com>
 <31754A5F-AD12-44D2-B80A-36638684C2CE@fb.com>
 <20200805225015.kd4tx6w3wh67oara@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200805225015.kd4tx6w3wh67oara@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d107cbe7-5980-4dc0-a854-08d8399a494a
x-ms-traffictypediagnostic: BYAPR15MB2326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB23261AE9FA567CF0A91D4206B34B0@BYAPR15MB2326.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MSDvRyuDlz5dqMfagDMlr1CmwBI1o1wfw0gkP6OWGorUUXwJr+6behMYe5ysm7Ok6bhfeKuYlE7j0zQeLfyKTcFTmf82PQbVSFS5NvEqm6tGBbDpLBJBeKDHuJktEQXPPWO7djgi/TFnbi5HYndzkCZwZ1Td7OmRRc+QqZDXmJRRM/U23VsIH1GHsDViEhHkSr8qq33rsGXIK+opFJKxfKDWovyCic+8oSAWdMnqgJGSWhjORiKufu9S76wyfC1TLfa2puLvKwH5NMWIO5N+83hiP3ZGLWtDAeHAFjqBeAwoJlx9LDjFdREKFBAgOxz4va6wbIJGNClp+w/wW8gLsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(136003)(376002)(396003)(39860400002)(2616005)(86362001)(5660300002)(6506007)(6916009)(53546011)(186003)(36756003)(83380400001)(6486002)(316002)(54906003)(7416002)(478600001)(71200400001)(33656002)(6512007)(4326008)(8936002)(66556008)(66946007)(66476007)(76116006)(64756008)(8676002)(66446008)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OOQTykUUiUhCNiWJ/M0zUbrbD5koKqpBWopwXfZaUHG0UEtcWk+SVv3aH/vZQgr2MswOsqFQMXaCJcOUiFtERmXFBYKriyxnd9Z55sFuiV262nX7tIWKZmpbCTh4hgHMS8+A81w6DjduL4dAWum33vDOHgujQKpcgp4VB3Y8e1/q3ogm31vHqCCCdjWWAuTFpjIaivS07IswB0dL9LO84LnU222Teut7QqhEYagrhr2lzRukXRrJHKTVhvg82V6By2/ImZ/SokHo0Q9KCIWu24IAI0knh4mPOkWO+/CbGO5koi3dj/L3SLDldymSk3/+7QI6T9P0Az4NZe4AvLjUT9Gfn9sO+sDjdsNMgciU13v5LeKjoRoT3sXoFWBX4tGI31UBRLkuStRDAO9MlDwTz4XgYGLuf4b200zuOMXG9gSN/yWvWshl0f2/f8v38tazRLVL6ZA+YEkQx49Kqs5DShp0ua6015n2b73hVoBHef//pJZPnkbt2uI36REoHAPAxu8p0CnGsv1TvhP74Y4Z/8YrrjOCwdV0K9mCc7pXIxKfUbhO4AnB6nh1DQI+QxyI7fl/y7TB8Z6w4QX+8MN8CMGfLBhMz7KSK1hqzBzqcOxG1kUkYDSbLmz3OEHiZlt7rbiuxpuhBpqRoFl++eUwb7Yrxpc+L7VBfQwWSuenHHw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C4E665DA60B4284C9CF95B6E6A3FDC73@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d107cbe7-5980-4dc0-a854-08d8399a494a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 23:50:08.8082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZyF9IB4Jtp3fYT+4WWkZ1FsF/kMCB5Ntp35vFQxJWQuqy5mtbwTS6gluqUFnTA7IgzPyfQk5v26M1HKJyK7Q0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2326
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_18:2020-08-03,2020-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008050174
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 5, 2020, at 3:50 PM, Alexei Starovoitov <alexei.starovoitov@gmail.=
com> wrote:
>=20
> On Wed, Aug 05, 2020 at 06:56:26PM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Aug 5, 2020, at 10:16 AM, Alexei Starovoitov <alexei.starovoitov@gma=
il.com> wrote:
>>>=20
>>> On Wed, Aug 05, 2020 at 04:47:30AM +0000, Song Liu wrote:
>>>>=20
>>>> Being able to trigger BPF program on a different CPU could enable many
>>>> use cases and optimizations. The use case I am looking at is to access
>>>> perf_event and percpu maps on the target CPU. For example:
>>>> 	0. trigger the program
>>>> 	1. read perf_event on cpu x;
>>>> 	2. (optional) check which process is running on cpu x;
>>>> 	3. add perf_event value to percpu map(s) on cpu x.=20
>>>=20
>>> If the whole thing is about doing the above then I don't understand why=
 new
>>> prog type is needed.
>>=20
>> I was under the (probably wrong) impression that adding prog type is not
>> that big a deal.=20
>=20
> Not a big deal when it's necessary.
>=20
>>> Can prog_test_run support existing BPF_PROG_TYPE_KPROBE?
>>=20
>> I haven't looked into all the details, but I bet this is possible.
>>=20
>>> "enable many use cases" sounds vague. I don't think folks reading
>>> the patches can guess those "use cases".
>>> "Testing existing kprobe bpf progs" would sound more convincing to me.
>>> If the test_run framework can be extended to trigger kprobe with correc=
t pt_regs.
>>> As part of it test_run would trigger on a given cpu with $ip pointing
>>> to some test fuction in test_run.c. For local test_run the stack trace
>>> would include bpf syscall chain. For IPI the stack trace would include
>>> the corresponding kernel pieces where top is our special test function.
>>> Sort of like pseudo kprobe where there is no actual kprobe logic,
>>> since kprobe prog doesn't care about mechanism. It needs correct
>>> pt_regs only as input context.
>>> The kprobe prog output (return value) has special meaning though,
>>> so may be kprobe prog type is not a good fit.
>>> Something like fentry/fexit may be better, since verifier check_return_=
code()
>>> enforces 'return 0'. So their return value is effectively "void".
>>> Then prog_test_run would need to gain an ability to trigger
>>> fentry/fexit prog on a given cpu.
>>=20
>> Maybe we add a new attach type for BPF_PROG_TYPE_TRACING, which is in=20
>> parallel with BPF_TRACE_FENTRY and BPF_TRACE_EXIT? Say BPF_TRACE_USER?=20
>> (Just realized I like this name :-D, it matches USDT...). Then we can=20
>> enable test_run for most (if not all) tracing programs, including
>> fentry/fexit.=20
>=20
> Why new hook? Why prog_test_run cmd cannot be made to work
> BPF_PROG_TYPE_TRACING when it's loaded as BPF_TRACE_FENTRY and attach_btf=
_id
> points to special test function?
> The test_run cmd will trigger execution of that special function.

I am not sure I am following 100%. IIUC, the special test function is a=20
kernel function, and we attach fentry program to it. When multiple fentry
programs attach to the function, these programs will need proper filter
logic.=20

Alternatively, if test_run just prepare the ctx and call BPF_PROG_RUN(),=20
like in bpf_test_run(), we don't need the special test function.=20

So I do think the new attach type requires new hook. It is just like
BPF_TRACE_FENTRY without valid attach_btf_id. Of course, we can reserve
a test function and use it for attach_btf_id. If test_run just calls
BPF_PROG_RUN(), we will probably never touch the test function.=20

IMO, we are choosing from two options.=20
1. FENTRY on special function. User will specify attach_btf_id on the
   special function.=20
2. new attach type (BPF_TRACE_USER), that do not require attach_btf_id;
   and there is no need for a special function.=20

I personally think #2 is cleaner API. But I have no objection if #1 is=20
better in other means.=20

Thanks,
Song


