Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D62E205868
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732985AbgFWRTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:19:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9604 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732408AbgFWRTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 13:19:45 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NGoesY005225;
        Tue, 23 Jun 2020 10:19:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jUVjdLrtC0uVDY2zx7tO9JEIbaR6bkJME3oy8mhWkT4=;
 b=e7SJehilhfdN7XDLHEmkUGNG41UE+kVvqce4/ZJpXIKO3vW5zILacjGt6fWMcsBGP4pD
 GGScCReii008LL48zQY3kZPRn8Nm7NhlWjLPgh91K90/mmyOK8oHb+X0FZuxqAIznOna
 BatdCYxlWubiitswGpnW2cfV9FRVIRgsNuM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk21h25c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 10:19:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 10:19:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZ8dwa+7K5ZDPchxwTnHoUBLhphJ+KLe+fuhSEYTqvrNVHKLNR6CWnpmoI5wtnx+6rqYXMgO+62vjRDZXxU0G8lCOfHPnpO9xxzX/X2Fe33U0SxS2FF4Xz+4qLfQ/EPrYgqlcBojF7mgWSQCqRKSCVViwhSBOuViOka9qv4thUCHriPYSdAvSg+XgXvihPd4xGk2eBLkkVUlu9Nz7Xzi1KuUyQkzCoebj1IlvQ99KWbgxYm4t8j9bF1ohWPBP3zqo74qiQ4aQG30DR36OjBZKB0ZTWrPMQz3TUf5im5hnkwkBRpHfHlhk3r3Zl1dtJGX6mIh1DmjA6WXZiqiBVT9cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUVjdLrtC0uVDY2zx7tO9JEIbaR6bkJME3oy8mhWkT4=;
 b=Yifoj5D71FIXU3PrrTaZWRaX0avS2UIt/2dLDB7zE8Awmul9Wk2m53IK6f2hI+tvTlWljJ7c9UaqjRDWA75BVISMdLpEbJr/JhrxSQRr4BHXfAlPdlCo13RAshg5b/DzWufzXwCVYD8bXqvUNtg8w2Ou3s/qZyXXel2rF6ceswpe/bFDKM8hFYugHi9BtJlYtrJNLLklvYB/kwJcge06KcbrZdrVxSSMrxRkeWz62v0+nCW6p+jhAEkCVOP0BT5alLCK480SLHroudMLhq9HSaVWL91+ri2eW/g3qr2XNHqqfsMa9UPEuMX5Y6nRJBEHJdOQKoVyq6Ekh8LxOC2ztg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUVjdLrtC0uVDY2zx7tO9JEIbaR6bkJME3oy8mhWkT4=;
 b=SK12sFJzeEzuEAo+lPVWZXDSO5M4vMNdgXUAFhFumnGZAgQxOFM7Q2KN866QOq6at2czdYb7DhSN3ok4VrMJHRLZm5uRv1lvbPQsW2JJn6Dz5OYpq7PDtwwsKd7zCpQdO0FYxaB65tasKVmw/21QXKEYdvV7/0ctZulYeiZHXgY=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2376.namprd15.prod.outlook.com (2603:10b6:a02:8c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.24; Tue, 23 Jun
 2020 17:19:27 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 17:19:27 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 2/3] bpf: allow %pB in bpf_seq_printf()
Thread-Topic: [PATCH bpf-next 2/3] bpf: allow %pB in bpf_seq_printf()
Thread-Index: AQHWSS0YVDMh9BiQgUKRrbLCkCwThKjmU9qAgAAeqgA=
Date:   Tue, 23 Jun 2020 17:19:27 +0000
Message-ID: <823792EE-E55E-439D-AA13-C8C6B7EDD00B@fb.com>
References: <20200623070802.2310018-1-songliubraving@fb.com>
 <20200623070802.2310018-3-songliubraving@fb.com>
 <677dc8f7-d4e9-7717-5def-935340a23cd2@iogearbox.net>
In-Reply-To: <677dc8f7-d4e9-7717-5def-935340a23cd2@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:d062]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e378259-b67f-480f-4718-08d817999561
x-ms-traffictypediagnostic: BYAPR15MB2376:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2376CF2F6BC92D6421D107DFB3940@BYAPR15MB2376.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:324;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E+248zLSP97xsU82Y/23Hmdj/HnNuAD7QaJC4rda9OtmPcJrcJYaB6vt3ENDgTdg/cq4bbE2t2irdZG5WhMe4tF7Kqzn7e09rmhclTUyMX691rnbUTIPUIFd+vzEJ8IGgfRs1nCgZYpclBB6JpNbuPAEBYGLFZKb0cvxMP/AVMvau4euiZsT9p4Mf+tnWBwC0uh/U56JJ+vDsimMoEWN3CTrAA2BQwqS0+Co7p9hOb/I5OFpmVYw39BN+ZOPOt24bsnhbDoJ1WTWrZRLtXgaVUvI6gGxk2hprQfPYP/W1v4KntUyoMhHHRVfR/aVEL15xKkl4yqImTTomvIRpjyKOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(396003)(346002)(376002)(366004)(478600001)(186003)(5660300002)(36756003)(8936002)(83380400001)(8676002)(2616005)(316002)(2906002)(6512007)(4326008)(33656002)(6506007)(76116006)(53546011)(66476007)(66556008)(64756008)(66446008)(66946007)(54906003)(4744005)(6486002)(6916009)(71200400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: O2OZSmUbzX0ZwQfI4WGSXoqcwSPNgiiURlywP7WyHJZS+UXfnx9RY5Ns0SJHFVvmsGgC/D7pkiNF657nZqoHgI5xHowrScpaBM4AaclJq5kqaXBV/i6v1Klu9U4ALtZjEv0rowSx29bMH/pLI5bafgjXWQOGZ7wfen1S4OiY1zgmluTcR4CCI6Xrhf5Tl9KJpFVXQU7uDOoSBjYZdfeo0avDHgJBdGh5cOhzbQKxAeQ7o52FU8vswT3SkIAB4LjuuV3cZAxXX0XQ+0JJMd1FcN8VpbBg7DrKb97ebiQ7SfJj/zcJcRpx8Jc48rUoZ1VMFP/VCkEvF2oW8fXIBxfG0xr9S56OD9fFB3di6ivsitfse7xhTosaGJTm2/tbtO75bYbuo/udCEWO3FD24TgI3/LYV7H2gObLHfWEmUejXneh7tQtvyw6mvID2ZzGLqa16ejAN+cQw5dL/ewidFP8JpALLU2YLF65YqRnF7QE8uDHn/rMnEWGGRJJo36BbGeCnE6jWTlnRhoP40ALwFmVjA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9BA8FC6297725A498FB2B6917C2E5B4B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e378259-b67f-480f-4718-08d817999561
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 17:19:27.5061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZrecQUsJBG66ZQuReanvxdE97qAPkwcY/LHl4T6HOdDBfZ51LcSW5/jiXdMXoFfWOkXRzWyRM9j0N24geSzMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2376
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_11:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 23, 2020, at 8:29 AM, Daniel Borkmann <daniel@iogearbox.net> wrote=
:
>=20
> On 6/23/20 9:08 AM, Song Liu wrote:
>> This makes it easy to dump stack trace with bpf_seq_printf().
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>  kernel/trace/bpf_trace.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>> index 2c13bcb5c2bce..ced3176801ae8 100644
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -636,7 +636,8 @@ BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, cha=
r *, fmt, u32, fmt_size,
>>  		if (fmt[i] =3D=3D 'p') {
>>  			if (fmt[i + 1] =3D=3D 0 ||
>>  			    fmt[i + 1] =3D=3D 'K' ||
>> -			    fmt[i + 1] =3D=3D 'x') {
>> +			    fmt[i + 1] =3D=3D 'x' ||
>> +			    fmt[i + 1] =3D=3D 'B') {
>>  				/* just kernel pointers */
>>  				params[fmt_cnt] =3D args[fmt_cnt];
>>  				fmt_cnt++;
>=20
> Why only bpf_seq_printf(), what about bpf_trace_printk()?

The use case we are looking at needs bpf_seq_printf(). Let me also add it t=
o
bpf_trace_printk().=20

Thanks,
Song=
