Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9AB355F87
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241318AbhDFXhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:37:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8116 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233184AbhDFXhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 19:37:19 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 136NYOqe000860;
        Tue, 6 Apr 2021 16:36:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=u6Am6iP3E8V/Hf2sdfQteqP1VRi4FeeYmpdVk2eZIbA=;
 b=NiP/2vFja7VkIvgCKaQHxrdHZh0mO79yXolT1gc2u2Vae0JCK5K1ZrQAaPR94b05/grY
 JL9lGv0apFXcDCj7tUY8lzLKlyuo0bA4U3wUFGCifVmbHnLkIzYuKY1wWkg+bIjCcUFY
 sgrgUE409QJJ/Wt/g9e4UMKh8yaX1IGa0yQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37rvb71wam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 06 Apr 2021 16:36:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 6 Apr 2021 16:36:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=beGlJq4oIgy31QtWvs2RODc85M2Xn7Qu6FnDsBx4Cdu4mgQ39qwvKyptdPlm4A82s1T3ainCZA8TrNmZmwcMJNEZ2uiOaouQN5nOfkMaOHL9Ri0nQlnoRPufL4FZPqNCUMNZBysdev7ICjvX8mP26QrJ7LhQiNOmR2gmhOA8m7UWbUa3bK62k/clEWu7k8+TE9SwvvHTbNbxWobmND3r60XHfAeIK2Ztq45BvAYm7vk90q6fWed3xgGOtgZiXnFAxZ++QrR3IpzYhlZZt9hZn8oUBzbbr8lj+HE44Aty/j0G8Q9EH7QJILcW/sUVtI3D9KhDfWaDyvXP8ymeCmkoZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X98zhLEuxRLKff7/4VxJ7bc9pECpJJt4ozWBQYSU0Mk=;
 b=oIeNf9+PPnBup4WdCZ02p00OOEoBO1UnCvFuyEc+atZR6WIAFQGzBYmcaLOlyzkFnEjWyJxFcH880cynNPwGLvzuM9OD1roAgjoXH5wKjJwCBct9oG+8yagGkGgVX2SLc63mLc1GZzzgAPVt6xMNc5o6a56rQxtVdaRnWeOWvC75K8PLh1taSFtngVjHHbY5rkdVSEtAx8rPW3NLWc13lZRBN8zlqoZhZBHRo2PqZ/B5FdJVP3MzlOmV0yK7iKqgYFvzOx8WPn+W6aAtOia2xC7gsG44de3fe1lkMVa0/jyJhRSZeTsORtpsUQ0QaDIOLfAEG9YR6iOYX9WPUIcWNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4421.namprd15.prod.outlook.com (2603:10b6:a03:372::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 23:36:48 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Tue, 6 Apr 2021
 23:36:48 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>,
        "duanxiongchun@bytedance.com" <duanxiongchun@bytedance.com>,
        "wangdongdong.6@bytedance.com" <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        "Cong Wang" <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
Thread-Topic: [RFC Patch bpf-next] bpf: introduce bpf timer
Thread-Index: AQHXJq9GCj74A7YdlUumCh5fgR8tjaqfNeUAgAC1hACAAC9hgIABZM4AgAAGWACAABPLgIAACd2AgAAUn4CAACsBAIAEvAoAgAAV7QCAAASQAIAAUgmAgACwOwCAAHIJgA==
Date:   Tue, 6 Apr 2021 23:36:48 +0000
Message-ID: <B014E4B4-D542-4005-97D5-5A3DDE446B95@fb.com>
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com>
 <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
 <E0D5B076-A726-4845-8F12-640BAA853525@fb.com>
 <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
 <93BBD473-7E1C-4A6E-8BB7-12E63D4799E8@fb.com>
 <CAM_iQpXEuxwQvT9FNqDa7y5kNpknA4xMNo_973ncy3iYaF-NTA@mail.gmail.com>
 <390A7E97-6A9A-48E4-A0B0-D1B9F5EB3308@fb.com>
 <CAM_iQpVZdju0KhTV1_jQYjad4p++hNAfikH5FsaOCZrcGFFDYA@mail.gmail.com>
 <93C90E13-4439-4467-811C-C6E410B1816D@fb.com>
 <CAM_iQpXrnXU85J=fa5+QjRqgo_evGfkfLU9_-aVdoyM_DJU2nA@mail.gmail.com>
 <DCAF6E05-7690-4B1D-B2AD-633B58E8985F@fb.com>
 <CAM_iQpW+=-RsxfYU_fWm+=9MSr6EzCvKwUayH3FyaPpopAtpWQ@mail.gmail.com>
 <45B3E744-000D-4958-89C0-A5E83959CD4A@fb.com>
 <CAM_iQpVwDvpMa2bVwx-2=ePGrkaeCG2HZh4szO9=vAP4ur4xzw@mail.gmail.com>
In-Reply-To: <CAM_iQpVwDvpMa2bVwx-2=ePGrkaeCG2HZh4szO9=vAP4ur4xzw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:57e2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b26e7b5-4673-4655-7819-08d8f954d901
x-ms-traffictypediagnostic: SJ0PR15MB4421:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB4421B8281338444FF39A9CCEB3769@SJ0PR15MB4421.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u7S3drr2Zcm9Z638jbEY9J6y7sBeCUIsEQDHpvoNUL7Ik7XX6OKsLRkBK1nheDiMbW6H2OTnmaPdHCoDC/jEVF8eIkCfT6OKCd+CnqNb9HCP2y5MVlI4o9dI7KzOlmJ+1n06uVyz7QKhExSxhBqYJ+VCVODi7G4CSL0p9ZcZfTIaB0QgFZzdb43XnSWZaZg0Cl75N8ISeyNbj4Q68N+XkaBZDGonueaTM3e/A4Dzt/5ehImq7KTUK9ljxa8nxOyjc0ePxBno3jGQxlkCNuDVLNf02QO33WRn244RDY9sKAseeTPK3YnnghOybn1z9Uo8hJPLJCgorIB/3WTNIjacRiLixQpKM6kujIrYAQTtmMaMEzbsAA/pLxX0vMwoZ/8LqTA5to9L+FHnOQDxQyHlOLxtsbtsoroHAk/3tHP3ANg8ys1yRoO2R+xsIZWWvM6Ec3F3/bbN7IM1+yxC5T4E+08eFwmBTK1BHfUqXMk9e43C6GT1ejSPCo8QPCkUf0NcCURAI1TJsg9gwFh7ndtQOYdMih7uXG0tz3ZsI1hjk+QLbrFzr7mCWI5gS0d7ITeEk+TawJXm04g3h65TrAgfOW7P/mKFrPOa7bOE0hYEwm6dKlgDP09Akp2hvBiXUpd4VZn5GTDsLblHby7zMqOn2QdrQ8zVyyVZ3TjmUBznMST9w0dm/4YLb/oT9xanXnrmMtJvFTHe48eZLo+mSOVW7cWKMlm8nL5V9a8nO5bPnkBpovdAfXoezlbKtvtmQj0YAZ5yaOoWHnSvmuiBxNJzkg8Jw2FEFF6GhL/uY/Hx9MA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(83380400001)(66446008)(38100700001)(64756008)(71200400001)(2616005)(33656002)(4326008)(6512007)(66556008)(2906002)(6506007)(53546011)(91956017)(36756003)(54906003)(7416002)(186003)(86362001)(6916009)(8676002)(8936002)(498600001)(6486002)(5660300002)(76116006)(66946007)(966005)(21314003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lt9trspPz6OwopRnx+K+ZIxftrRB9a7igRr+4id+1h/c8/Zj4iXZ9pvDlRPI?=
 =?us-ascii?Q?WSiYtV6vYo2f471hodt7Dg6kQtoRpLzU4K+ejn1iQTHTQAXTqxv6A0LcFAow?=
 =?us-ascii?Q?nxi8vs03LH6t1sOpYscGolgn3w9ivSR7g5XLhyFS6mWT6qt/zVN0xkPaf7CO?=
 =?us-ascii?Q?mG+YuuFoLdfrmo8O7Fj0ITugVtRdJW5KVG7i3TRqt7Q1aKwoFvl3Tavo5Opa?=
 =?us-ascii?Q?3Wv+DKGwy1hdxKfcg9S8Rd+JjGIDZG+setx9WQYIHtoBCdmAkkTYSCLD+o9Y?=
 =?us-ascii?Q?7vn8LXUtCJBdF08ZN5tEXHJ5/ywx0x7Bg35/ho64ZYmutNLsQqch7yVfWSkt?=
 =?us-ascii?Q?NBweUkcKTfjqr0PE/ObJN4zA9Fqrp69RX7cmX7eULsjat9lBZCBFmSAZGqiN?=
 =?us-ascii?Q?FsMI8gMNRkWP2dVRY3BDUjmorI+E3vziorMsdZgyaUe/RvDeuf8GjDIJpVZ1?=
 =?us-ascii?Q?a37Nj6kMw0h81NZrbohAjicAi1ajd166B+eYPuAho7qFDrwKhh6mJPIYd0g9?=
 =?us-ascii?Q?SnwM6L6UYuDjwGTN90bCL1dRJFpJwzNeZPQA8FBkOjC9VxBp0Jf7D2hytIDY?=
 =?us-ascii?Q?FIVdMldxeCf9uKpGlHufPhBtFVq+W7OaCNkeZl19e7QxgVTqe7ePjqrynZgg?=
 =?us-ascii?Q?K3twhFo9rZdBe/JAuvD80EOtg8uJyewm+oD4XKbDIaopQp7ubH8Jd72I4/mu?=
 =?us-ascii?Q?tG3135ZKBXsbsSio0LdCVPGG/VMBZKWqWdcgQ1YM4IYZTkXLnRI2FwQ/qJSc?=
 =?us-ascii?Q?iVBhe8Ti6UoxvrMwOjAAt26zLuT8Vbao3Z3UN108/vie0GCTIROQWCuC633I?=
 =?us-ascii?Q?dfUMH/tvx1+76O1y8bp2v7rB9I+xFEuOWqje1CTfC7oUTOE4EilEW+2D3T1Y?=
 =?us-ascii?Q?TvbopjCfTT2IYMQJfiSzJur7v/QOLPnhngWDIscYT16kLiku6sVI8+wi5kFj?=
 =?us-ascii?Q?DV7+HFtLuKm3j2l1HteA04SNqH/c9wqvAPPSD8ZFTppjN/R2jbsQBl3ZH2zH?=
 =?us-ascii?Q?HjgYqKiCWOMShNeaU/Mf3A+fu/GTld0gLRrGN7geJ1pLo4frJ2aAykkOs83y?=
 =?us-ascii?Q?qNB5lLA0/kq1NAcsVSD7Lnx91HcaPh4bslGZypNbFhG/UEek5rpxALYQjE+Y?=
 =?us-ascii?Q?jqnrhtuyh5Px74OTu7rpHG0B05ZQOwsxb8DcHj0HLXe+D3Rplnx54lRsFoj2?=
 =?us-ascii?Q?htYr4t0SPd29ccYhLjY0xRNe/jJ+TYQADbx/d5Ocjidt/eqnqkpzAiTKaQOp?=
 =?us-ascii?Q?6H1yvvchrC5WAjNQspk8Mh38cBO1E7ghQXKFGVuNgOcuw87WclV2eByGrqWl?=
 =?us-ascii?Q?2znE0cNwTrCM2z8FVE3Ca8XTSg42lFa2mDXO4pwe9ScKoQCiaWPY9BxSdNY1?=
 =?us-ascii?Q?EankNy8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EE3E876BC70A8F4ABD1BB3442288D33D@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b26e7b5-4673-4655-7819-08d8f954d901
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 23:36:48.4387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AS6VxUfQgtZU86UU+i02mEcKrDf0AaXRy543JjobYGhhi/0jTpjqGVTyebiBe8L0xILvgUf/42GguKevMmtNuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4421
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: QXos_E3FAgb1N7ZRBaDocpYQoQ44vswd
X-Proofpoint-ORIG-GUID: QXos_E3FAgb1N7ZRBaDocpYQoQ44vswd
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_09:2021-04-06,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104060162
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 6, 2021, at 9:48 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>=20
> On Mon, Apr 5, 2021 at 11:18 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Apr 5, 2021, at 6:24 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>=20
>>> On Mon, Apr 5, 2021 at 6:08 PM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Apr 5, 2021, at 4:49 PM, Cong Wang <xiyou.wangcong@gmail.com> wrot=
e:
>>>>>=20
>>>>> On Fri, Apr 2, 2021 at 4:31 PM Song Liu <songliubraving@fb.com> wrote:
>>>>>>=20
>>>>>>=20
>>>>>>=20
>>>>>>> On Apr 2, 2021, at 1:57 PM, Cong Wang <xiyou.wangcong@gmail.com> wr=
ote:
>>>>>>>=20
>>>>>>> Ideally I even prefer to create timers in kernel-space too, but as =
I already
>>>>>>> explained, this seems impossible to me.
>>>>>>=20
>>>>>> Would hrtimer (include/linux/hrtimer.h) work?
>>>>>=20
>>>>> By impossible, I meant it is impossible (to me) to take a refcnt to t=
he callback
>>>>> prog if we create the timer in kernel-space. So, hrtimer is the same =
in this
>>>>> perspective.
>>>>>=20
>>>>> Thanks.
>>>>=20
>>>> I guess I am not following 100%. Here is what I would propose:
>>>>=20
>>>> We only introduce a new program type BPF_PROG_TYPE_TIMER. No new map t=
ype.
>>>> The new program will trigger based on a timer, and the program can som=
ehow
>>>> control the period of the timer (for example, via return value).
>>>=20
>>> Like we already discussed, with this approach the "timer" itself is not
>>> visible to kernel, that is, only manageable in user-space. Or do you di=
sagree?
>>=20
>> Do you mean we need mechanisms to control the timer, like stop the timer,
>> trigger the timer immediately, etc.? And we need these mechanisms in ker=
nel?
>> And by "in kernel-space" I assume you mean from BPF programs.
>=20
> Yes, of course. In the context of our discussion, kernel-space only means
> eBPF code running in kernel-space. And like I showed in pseudo code,
> we want to manage the timer in eBPF code too, that is, updating timer
> expiration time and even deleting a timer. The point is we want to give
> users as much flexibility as possible, so that they can use it in whatever
> scenarios they want. We do not decide how they use them, they do.
>=20
>>=20
>> If these are correct, how about something like:
>>=20
>> 1. A new program BPF_PROG_TYPE_TIMER, which by default will trigger on a=
 timer.
>>   Note that, the timer here is embedded in the program. So all the opera=
tions
>>   are on the program.
>> 2. Allow adding such BPF_PROG_TYPE_TIMER programs to a map of type
>>   BPF_MAP_TYPE_PROG_ARRAY.
>> 3. Some new helpers that access the program via the BPF_MAP_TYPE_PROG_AR=
RAY map.
>>   Actually, maybe we can reuse existing bpf_tail_call().
>=20
> Reusing bpf_tail_call() just for timer sounds even crazier than
> my current approach. So... what's the advantage of your approach
> compared to mine?

Since I don't know much about conntrack, I don't know which is better.=20
The follow is just my thoughts based on the example you showed. It is=20
likely that I misunderstand something.=20

IIUC, the problem with user space timer is that we need a dedicated task=20
for each wait-trigger loop. So I am proposing a BPF program that would
trigger up on timer expiration.=20

The advantage (I think) is to not introduce a separate timer entity.=20
The timer is bundled with the program.=20=20

>=20
>=20
>>=20
>> The BPF program and map will look like:
>>=20
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D 8< =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> struct data_elem {
>>        __u64 expiration;
>>        /* other data */
>> };
>=20
> So, expiration is separated from "timer" itself. Naturally, expiration
> belongs to the timer itself.

In this example, expiration is not related to the timer. It is just part
of the data element. It is possible that we won't need the expiration for=20
some use cases.=20

>=20
>>=20
>> struct {
>>        __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
>>        __uint(max_entries, 256);
>>        __type(key, __u32);
>>        __type(value, struct data_elem);
>> } data_map SEC(".maps");
>>=20
>> struct {
>>        __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
>>        __uint(max_entries, 256);
>>        __type(key, __u32);
>>        __type(value, __u64);
>> } timer_prog_map SEC(".maps");
>=20
> So, users have to use two maps just for a timer. Looks unnecessarily
> complex to me.

The data_map is not for the timer program, it is for the actual data.=20
timer_prog_map is also optional here. We only need it when we want to=20
trigger the program sooner than the scheduled time. If we can wait a
little longer, timer_prog_map can also be removed.

>=20
>>=20
>> static __u64
>> check_expired_elem(struct bpf_map *map, __u32 *key, __u64 *val,
>>                 int *data)
>> {
>>        u64 expires =3D *val;
>>=20
>>        if (expires < bpf_jiffies64()) {
>=20
> Value is a 64-bit 'expiration', so it is not atomic to read/write it on 3=
2bit
> CPU. And user-space could update it in parallel to this timer callback.
> So basically we have to use a bpf spinlock here.
>=20
>=20
>>                bpf_map_delete_elem(map, key);
>>                *data++;
>>        }
>> return 0;
>> }
>>=20
>> SEC("timer")
>> int clean_up_timer(void)
>> {
>>        int count;
>>=20
>>        bpf_for_each_map_elem(&data_map, check_expired_elem, &count, 0);
>>        if (count)
>>                return 0; // not re-arm this timer
>>        else
>>                return 10; // reschedule this timer after 10 jiffies
>> }
>>=20
>> SEC("tp_btf/XXX")
>> int another_trigger(void)
>> {
>>        if (some_condition)
>>                bpf_tail_call(NULL, &timer_prog_map, idx);
>=20
> Are you sure you can use bpf_tail_call() to call a prog asynchronously?

I am not sure that we gonna use bpf_tail_call() here. If necessary, we=20
can introduce a new helper.=20


I am not sure whether this makes sense. I feel there is still some=20
misunderstanding. It will be helpful if you can share more information=20
about the overall design.=20

BTW: this could be a good topic for the BPF office hour. See more details
here:

https://docs.google.com/spreadsheets/d/1LfrDXZ9-fdhvPEp_LHkxAMYyxxpwBXjywWa=
0AejEveU/edit#gid=3D0

Thanks,
Song=
