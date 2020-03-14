Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1987185489
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 04:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgCNDsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 23:48:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36178 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726399AbgCNDsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 23:48:17 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02E3ew53027178;
        Fri, 13 Mar 2020 20:47:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=u53MbnbekFYHRfYzQAp8S1l2rnNrP+X3OuM1QNlxj6I=;
 b=Hpo7qnjQkum5PU4rOoKAbCHHv0cI37+XoISP7x5B/9MJ2t4L2vDTac3Cf9Sp0/7Zehr4
 XicUp3A76S4coBBUgL05GGDzP8Sx4GnxC0eHG0KRxUdOphXMXxi+mC04FH2h59brrrHE
 pcfEf/J9Qo02SWaLCmpj1t6D3+8nv/XBrME= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt80ykcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Mar 2020 20:47:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 20:47:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lzb06Ygf5q+BJezx11H4nGI4XjP5BF81CS1TiSqS6RpqFjfLnjSeWPXx9etjwde+JiKjASaxTLn/O8D1MvGC1cmkUEke26sPUlvGisyjg3pbcg538PLw4kF81IfzejnWjyrwitWztdR3XlL0IXqSASPhpHMmvdrDTW2xqYv2JMrvJ8bkbITR09nUQ3gkNCe2l0t27gtkkaOC4GdUMHrKgrV9Mctl58o/2A6LiNN0BB0h+BWuExl43VidDvum5UeuhItz6gYZHBMUQTZVT3eySU0b2m8hKrqPht8dXdfhahZYXj9py8jZewzppNkylq/9u6jEV/LmsB1epT0t/aSa6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u53MbnbekFYHRfYzQAp8S1l2rnNrP+X3OuM1QNlxj6I=;
 b=Z6enHWPjO6P9Izaf7507nkbyq8n9j8r7/tQaYGg56CrDVD7gtbkBM1q+gXYOU2uW3SGTzRTlcBuPZXUF/LilkcCGUt2ZgHjPtF1NwvUzzrQ31sPBmY4ZyZLGgLVA6Pea7P62UC0NNIB6HcR6maD/UeSKw2EnJWkuSnqRjjNMU8++eho5VaGAtQfr2P/knLoD95cutmkXbaPpB7GrAu0XuG29N3Qan9AKpikWZtiVpzTUvUBaekh3N9JRPu/erKZjXBPAN8O/taKkIjpsuuH1ZXERM03MJpN925c9wb+X5oRnltzACIpOrwqO0smtoAEdBSJhpdb1IaxsW/t78AMYaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u53MbnbekFYHRfYzQAp8S1l2rnNrP+X3OuM1QNlxj6I=;
 b=SUAif4JNbcZnWG9m7xfJfReB22npuvr7Ttiqsmuw2TpdbRAQ6rHSr7NTbQMrxShN+blhRLNviRDR26hlle722m1KRgVPS6nuRMu1Y/dojMhV1CX58CkWYkZok6+M72EVrk7vvgpvHQHmgulJeR+IGYRgpl2jperVK0turEHiQ/0=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB4027.namprd15.prod.outlook.com (2603:10b6:303:4f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Sat, 14 Mar
 2020 03:47:50 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2814.018; Sat, 14 Mar 2020
 03:47:50 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "yzaikin@google.com" <yzaikin@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "bristot@redhat.com" <bristot@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: Re: [RFC bpf-next 0/2] sharing bpf runtime stats with /dev/bpf_stats
Thread-Topic: [RFC bpf-next 0/2] sharing bpf runtime stats with /dev/bpf_stats
Thread-Index: AQHV+ZrMj1Iy/L1gLESYfUQuCI4fzqhHYXEAgAASAwA=
Date:   Sat, 14 Mar 2020 03:47:50 +0000
Message-ID: <E7BBB6E4-F911-47D4-A4BC-3DF3D29B557B@fb.com>
References: <20200314003518.3114452-1-songliubraving@fb.com>
 <20200314024322.vymr6qkxsf6nzpum@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200314024322.vymr6qkxsf6nzpum@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:7990]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 121b601f-2c4e-4706-08c8-08d7c7ca7806
x-ms-traffictypediagnostic: MW3PR15MB4027:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB4027C934253EFA8E8B18B329B3FB0@MW3PR15MB4027.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 034215E98F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(478600001)(186003)(36756003)(33656002)(5660300002)(8936002)(86362001)(4326008)(6486002)(6512007)(53546011)(71200400001)(2616005)(6506007)(66946007)(66556008)(66476007)(54906003)(6916009)(64756008)(76116006)(81166006)(81156014)(8676002)(66446008)(7416002)(316002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB4027;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OVjmxPL0lQidTRnxCkjyGUVr7RPL3/z5JVYCTQ390uDtkFigemrO5SzU58rDjFmNfFZVdDUwQqfsN4t8tkIaTJ2GaC9AGIbrWP3wcQrOqJXhMCwf+VUUGqFUmC6zXM3laO73DRVkF4LxAJ6aRwAsCcUuT6dwB+90wl+UBL2htX7TWo1fof+SOgIhOUaqzQg+kn3BbhRMCZkGN47cs6o84mMf6R4W66gaDOEuhJULc21U93ER64h7x2Ilxs9g3z4sO179GOt322pihr0QseGg9WlQebIyUYV0VhurbTUCRTaJcqcz6c59Dyb58/FQiQRIZJd0kM3BLDIV2DYDjFUDWMRPIR80cPjxz6LxxCCFSykzk8/TbBfIuOabVdtfXrBCv3OLH5bL+4i5VKocxeQA7y0i0MEFuBSigDEIy2xNJMXA0RuMrqV6IwpSVZUsA76i
x-ms-exchange-antispam-messagedata: 0rpnbBsLcDyBkedtEUnj11J0mh9GNqsUiaroDCb5lEXGdfwIjsm0Iw52IiXcwX2i5fDS2wXAbVvc5Ynfyz+7VIM9KecrmSP5b2f2JrH05auZFer5R6166anS0ehscycrPpgnOtQBuwYq5W1tpmZmEK7LZBnFg/d4cCwyzdsOEJ1fW87q6ynMfgdudkl4N75v
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CB7BA1325CAFD246A722BA4C4E79064A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 121b601f-2c4e-4706-08c8-08d7c7ca7806
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2020 03:47:50.5833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QwZr3o63Bx96YBBYFfV5nr5aBehegDDWC/afcCJxfQ+sKCSpGdeBKHIXK+rdi7b0pyeAnJ1acKN/+N+43PucTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4027
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_12:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 clxscore=1011 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=996 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003140018
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 13, 2020, at 7:43 PM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Fri, Mar 13, 2020 at 05:35:16PM -0700, Song Liu wrote:
>> Motivation (copied from 2/2):
>>=20
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D 8<=
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> Currently, sysctl kernel.bpf_stats_enabled controls BPF runtime stats.
>> Typical userspace tools use kernel.bpf_stats_enabled as follows:
>>=20
>>  1. Enable kernel.bpf_stats_enabled;
>>  2. Check program run_time_ns;
>>  3. Sleep for the monitoring period;
>>  4. Check program run_time_ns again, calculate the difference;
>>  5. Disable kernel.bpf_stats_enabled.
>>=20
>> The problem with this approach is that only one userspace tool can toggl=
e
>> this sysctl. If multiple tools toggle the sysctl at the same time, the
>> measurement may be inaccurate.
>>=20
>> To fix this problem while keep backward compatibility, introduce
>> /dev/bpf_stats. sysctl kernel.bpf_stats_enabled will only change the
>> lowest bit of the static key. /dev/bpf_stats, on the other hand, adds 2
>> to the static key for each open fd. The runtime stats is enabled when
>> kernel.bpf_stats_enabled =3D=3D 1 or there is open fd to /dev/bpf_stats.
>>=20
>> With /dev/bpf_stats, user space tool would have the following flow:
>>=20
>>  1. Open a fd to /dev/bpf_stats;
>>  2. Check program run_time_ns;
>>  3. Sleep for the monitoring period;
>>  4. Check program run_time_ns again, calculate the difference;
>>  5. Close the fd.
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D 8<=
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>=20
>> 1/2 adds a few new API to jump_label.
>> 2/2 adds the /dev/bpf_stats and adjust kernel.bpf_stats_enabled handler.
>>=20
>> Please share your comments.
>=20
> Conceptually makes sense to me. Few comments:
> 1. I don't understand why +2 logic is necessary.
> Just do +1 for every FD and change proc_do_static_key() from doing
> explicit enable/disable to do +1/-1 as well on transition from 0->1 and 1=
->0.
> The handler would need to check that 1->1 and 0->0 is a nop.

With the +2/-2 logic, we use the lowest bit of the counter to remember=20
the value of the sysctl. Otherwise, we cannot tell whether we are making
0->1 transition or 1->1 transition.=20

>=20
> 2. /dev is kinda awkward. May be introduce a new bpf command that returns=
 fd?

Yeah, I also feel /dev is awkward. fd from bpf command sounds great.=20

>=20
> 3. Instead of 1 and 2 tweak sysctl to do ++/-- unconditionally?
> Like repeated sysctl kernel.bpf_stats_enabled=3D1 will keep incrementing =
it
> and would need equal amount of sysctl kernel.bpf_stats_enabled=3D0 to get
> it back to zero where it will stay zero even if users keep spamming
> sysctl kernel.bpf_stats_enabled=3D0.
> This way current services that use sysctl will keep working as-is.
> Multiple services that currently collide on sysctl will magically start
> working without any changes to them. It is still backwards compatible.

I think this is not fully backwards compatible. With current logic, the=20
following sequence disables stats eventually.=20

  sysctl kernel.bpf_stats_enabled=3D1
  sysctl kernel.bpf_stats_enabled=3D1
  sysctl kernel.bpf_stats_enabled=3D0

The same sequence will not disable stats with the ++/-- sysctl.=20

Thanks,
Song



