Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC2626AA6A
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 19:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgIORV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 13:21:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55402 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727737AbgIORTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 13:19:46 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FH8mY0006471;
        Tue, 15 Sep 2020 10:18:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=C/xZZQ4aWrp6HiXiHjIIXA1zdB2LlmvnQ/MhlZ4JShY=;
 b=c2ipwib1VlcqN5ySgQLIh+qpMvv7JRNgKyjpGOMjx6FInWLtWqomexdcoMUIENNB1o5U
 W/2MFU/67gHykgnUK9eW+CzlB+APH7qLMTEy40Z1RYBmmTETAnb7mDKA8wohCLgn6uxi
 /fy8MuHvjUZjy5dvSo5nkIrFra0B/QaOulU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33j50e1fyr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Sep 2020 10:18:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 10:18:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DH+WtEQ5dhTDbU1x1HNRvmegE/A1NrQTESkZWMzy7LX3cWrEiRqDILr/yrS5c2PlFyX4hqecMzeix88UL0ysq1Tfpa4tBecsbVBoPzTUFfpRBfKUw5QPDyi2zKC2LzPSDmrIRQgQSXlyFQTi4wmUqvSaQhPZsiW+Nqu/xt3U2K+20O3G2Jnk90rKwhekkqEK4NR0k555aDikj1KfKfnD0nHstTloKqDNuOZ4rh4jsdTtLyrz7rnMMyRfvjhVefGKQp6qNZ6Rtihkw0+PoXPNzjjY2io7NJRbzGKUHyPXVovXsJAGtBDEfZg6WTGJ2wEztx3ZHWFi7XwJ3qLYiBT0Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/xZZQ4aWrp6HiXiHjIIXA1zdB2LlmvnQ/MhlZ4JShY=;
 b=EiRS8c8gUvEbcwQzSkYOV7+elRErZ23OlqKH7PrLqrfznfJT0FVvtKWllsPqhN/hyBVuqTPIoNVY/5CTjiE+Tl8ge8auyzUHScP/P8kCuxo91wDdSxLEikih/GfE/B/uo9KkbtxWnH94QyO6MTDabyMd5/gozypOMAxFGo70i1df84QGZ/xkZqeW7SVTRV/VXwqUG9maU/UL39aX8Jrss4myQa70HxXe9AGiGeTymhlcxK1rfYpBN6jgTQHcjacNXP2ZML1x09yID0xXDfApJyOgTufRdp4ea+iNsNIh4/e725XMc3+agezFYRf9LLCDztuM8QQrOx7DZjKaYRTFgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/xZZQ4aWrp6HiXiHjIIXA1zdB2LlmvnQ/MhlZ4JShY=;
 b=WZoxSCwKZqpdHNpVdeM81D3l5l86dS9t6vMHn5qzMHO7mnpaGLS0G1VNUy38WnHDe15k4GWN1ziKNxNcEJO6ojlLSf+Z3uNMUSke5Ud9lx96GmIkTYMek7ue0OVtjmzM6rce+RIk3PgQ+vTsyoSMpvzd4dX/AH/lLLqmwyp8TUk=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2197.namprd15.prod.outlook.com (2603:10b6:a02:8e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Tue, 15 Sep
 2020 17:18:56 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 17:18:56 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Nicolas Rybowski <nicolas.rybowski@tessares.net>
CC:     Song Liu <song@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "open list" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 4/5] bpf: selftests: add MPTCP test base
Thread-Topic: [PATCH bpf-next v2 4/5] bpf: selftests: add MPTCP test base
Thread-Index: AQHWiEg5lAOuSkQSgUOwFXGkhtXnPqloc0EAgAF4xICAAAv+gA==
Date:   Tue, 15 Sep 2020 17:18:56 +0000
Message-ID: <6BCFCB44-3CF4-47B0-BD59-720F32581E31@fb.com>
References: <20200911143022.414783-1-nicolas.rybowski@tessares.net>
 <20200911143022.414783-4-nicolas.rybowski@tessares.net>
 <CAPhsuW5Gbx2pWgM1XcSYqVsN6L=q+0u3QFNxG7A+Qez=Tziu2A@mail.gmail.com>
 <CACXrtpRzZuCyZnduYcV+1d2Z3qTK2b7Mcj2gQvcRbnv7+k0VRw@mail.gmail.com>
In-Reply-To: <CACXrtpRzZuCyZnduYcV+1d2Z3qTK2b7Mcj2gQvcRbnv7+k0VRw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: tessares.net; dkim=none (message not signed)
 header.d=none;tessares.net; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:f20e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2c42a33-d544-457c-8042-08d8599b6daf
x-ms-traffictypediagnostic: BYAPR15MB2197:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB219754A02A1A2A4837CB30CEB3200@BYAPR15MB2197.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1bPAWGMhZvn7yan5FcMnLaW+iASYJyvaL9ajnzYqrwHRBCuvBsem6ejYn+ouJf9DUmNOINXk3F+LgUAPZ4bx+Kx3tptHOnPSn02HJDs3oUQr+Cu1WCn1zuAKqyezCLicldr5hMVUwkwo/38W79p+IOn0/+GMnstJDTqmppBgzxhfBT0X6zyCEJ6Gzo+Lr2uyPV01mVbDgP++EOEaiJk5tuYSCvy0jP8gabFjoGAcgde71cV/yFKdi5LnD1b92TBOqrpJr0tRIWD/CJey30uXL57Pkn/1/u+O3V7qM0TtiuWNmWptunlEsbJdscklnfhZghTs2wRvJ8gY2pZ7mZXCdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39860400002)(396003)(136003)(6512007)(6486002)(186003)(2616005)(316002)(4326008)(86362001)(478600001)(8936002)(33656002)(6916009)(6506007)(8676002)(2906002)(7416002)(36756003)(54906003)(5660300002)(66476007)(66556008)(64756008)(66446008)(53546011)(91956017)(83380400001)(76116006)(66946007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: HG79JIEEF1eNfjeOYAsUW5nmUCBrcxKBiYlxMeZulPWHtU0Ao6W1w0L95nGaoLKcAPHhVGgvJWpW+kdYZ7v2coyNU3vDJImi2dmz92ADR+b7MFCRbvQurLdeotLwf3XPAKfCNPuppPMntCzdKxZulHSrtOKwpAFgpHRI+46anBrY/CCOKwefWj9gsNLR+WRr9qwLUmlO0/MhINBkgf+cMzQYdDZmVREFvP9FhqsKD3RtHVEFYnyGD1QxCiuXh2di1GFed/hPa6uHT3v6mid/knsQSHMlHCpY6IP4Wb6zglxjSMqZKAzWONhNGOS7J9vcJPUK+WkrQFYmm+597iNJPVi+y3dLkzXAv5W5759oGbcXCwjz0FJCOHYW3Vl9is4jpp+Sjsuj/2CCy+JZ8XUc9bSCg0oroa43OTHN7UzBNLLkkAxS3FFYMc35PVqnPdlC23hgk9kFNfnfPs53DEzdjY5Jma8OS4/EQpfc1eMhxTfu079Wn/Bq/E7uc6Zz9XMgZ4q0PF6GogMKoPfOr3qITWHqWqhnGEtxTUctCUQKnI10rCoeGEhgZFmACCzK6lMlex4/v4EK2KW+pjCz+/cjiIiidSh19qgEeNQLuP9kGPHy1Lu4ZeFvb72bOLuJKFICRH1oNLcHZFmvYJ8y7HwdTG8hr28DEB2lF0Y9d/1RtTMb+ULZD6uod4sH901a1HaN
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3BE0F881EB00B04C84DF90A443A9D9E0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2c42a33-d544-457c-8042-08d8599b6daf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2020 17:18:56.6337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oda95L09On1+cpkYGHa0laGQU4tS4KmfU+EicbXiP6JPjfgz9wEF5wvCBfXEIiJwGOiRFqhIIHbfgG9LeD7t7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2197
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_12:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1011 priorityscore=1501 mlxscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 15, 2020, at 9:35 AM, Nicolas Rybowski <nicolas.rybowski@tessares.=
net> wrote:
>=20
> Hi Song,
>=20
> Thanks for the feedback !
>=20
> On Mon, Sep 14, 2020 at 8:07 PM Song Liu <song@kernel.org> wrote:
>>=20
>> On Fri, Sep 11, 2020 at 8:02 AM Nicolas Rybowski
>> <nicolas.rybowski@tessares.net> wrote:
>>>=20
>>> This patch adds a base for MPTCP specific tests.
>>>=20
>>> It is currently limited to the is_mptcp field in case of plain TCP
>>> connection because for the moment there is no easy way to get the subfl=
ow
>>> sk from a msk in userspace. This implies that we cannot lookup the
>>> sk_storage attached to the subflow sk in the sockops program.
>>>=20
>>> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
>>> Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>
>>=20
>> Acked-by: Song Liu <songliubraving@fb.com>
>>=20
>> With some nitpicks below.
>>=20
>>> ---
>>>=20
>>> Notes:
>>>    v1 -> v2:
>>>    - new patch: mandatory selftests (Alexei)
>>>=20
>> [...]
>>>                     int timeout_ms);
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/tes=
ting/selftests/bpf/prog_tests/mptcp.c
>>> new file mode 100644
>>> index 000000000000..0e65d64868e9
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
>>> @@ -0,0 +1,119 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +#include <test_progs.h>
>>> +#include "cgroup_helpers.h"
>>> +#include "network_helpers.h"
>>> +
>>> +struct mptcp_storage {
>>> +       __u32 invoked;
>>> +       __u32 is_mptcp;
>>> +};
>>> +
>>> +static int verify_sk(int map_fd, int client_fd, const char *msg, __u32=
 is_mptcp)
>>> +{
>>> +       int err =3D 0, cfd =3D client_fd;
>>> +       struct mptcp_storage val;
>>> +
>>> +       /* Currently there is no easy way to get back the subflow sk fr=
om the MPTCP
>>> +        * sk, thus we cannot access here the sk_storage associated to =
the subflow
>>> +        * sk. Also, there is no sk_storage associated with the MPTCP s=
k since it
>>> +        * does not trigger sockops events.
>>> +        * We silently pass this situation at the moment.
>>> +        */
>>> +       if (is_mptcp =3D=3D 1)
>>> +               return 0;
>>> +
>>> +       if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &cfd, &val) < 0)) {
>>> +               perror("Failed to read socket storage");
>>=20
>> Maybe simplify this with CHECK(), which contains a customized error mess=
age?
>> Same for some other calls.
>>=20
>=20
> The whole logic here is strongly inspired from prog_tests/tcp_rtt.c
> where CHECK_FAIL is used.
> Also the CHECK macro will print a PASS message on successful map
> lookup, which is not expected at this point of the tests.
> I think it would be more interesting to leave it as it is to keep a
> cohesion between TCP and MPTCP selftests. What do you think?

I guess CHECK_FAIL makes sense when we don't need the PASS message.=20
Let's keep this part as-is then.=20

Thanks,
Song

