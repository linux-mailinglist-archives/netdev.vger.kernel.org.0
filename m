Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F11741864BC
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 06:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbgCPFwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 01:52:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27508 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728856AbgCPFwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 01:52:38 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02G5jEJR005933;
        Sun, 15 Mar 2020 22:52:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xhoT2KPabcncgBgHui0nALVc9WtV6L0R9wOoTjuwRRA=;
 b=M3Ey64Y1MKpqKYHsPoA+O2CH2I7wAxc01crLV7NmXptpPqN6tuL2uB7DB8zj64J6iLU+
 NR2QhHWqRseJ+e7jWMxeMHW+HRjLSeozLlF0YlahYS8vEQp/3MDFp9RKTvRSraIt0XTY
 rsJIl8LcVM65Cw4Oqk6HKZjNn2/5mkLHbq4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysfdx2yty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 15 Mar 2020 22:52:08 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 15 Mar 2020 22:52:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOZCK8JhN1jFOIa++J0QJC2yYh0tzzcDCfyKxzAfVWaGzppomgN3jDstgtaJ8Jy/xDgl2AncCGjLdp7GIzBCUXDER6iSdkhFn7IPInxcJgpp3df6/QU3Y6dvaxmY/JpxI57X1X/3U5zP7CYbGQPlfLZ7/pxq4ZmRSM3YkwK5t8bvBVFsMnC+tGUeRK3HRh8JTXm4l3ZYPk4+y69NEZF/OknbdaJjHwzCieGkadfzrBaWFqJB5x8yfLvxaRmV0K9Dh75mzcwBU3oe0/OrmpeOGQzx5oc+582kh9OuxxrVrB5yPO79ZiWps9blCjyKRrASJd/eN3AVH7alzDoQhk5KCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhoT2KPabcncgBgHui0nALVc9WtV6L0R9wOoTjuwRRA=;
 b=TFidUsG+Ty4k95rVM79/PD22kBbhlmiaXpcyMwe9RmuUiWVwq5q001N8KNjvsCI/JvATB3zi/XxjStY3JI1LxwnjrTBf003f++dlGij5ytVqkPXB4sx1vfwvsBjgHNGFEp6ys02gWUku4VEntX0suF54KutvNBW55UI0vBt+0MIlm+Cv5vaRVeVPm9L5HL212QBq+QySEnNiflRr5ReZGGxF46jmOho54gXt9KbxdTdZJuHUqKzuqX7Y4tVA8nKPjKhaQGzb6Sj+wSf+wyNs841bvZxJecKWQXLgk9Ny5+xYQ5kPM1WYGtA3zzAIHx0ot246hodypN7c7kYpoDfATw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhoT2KPabcncgBgHui0nALVc9WtV6L0R9wOoTjuwRRA=;
 b=MeTK0b4KtThZYegUuhqVS7aF2Ix8p8gfT2L2Sak9dJvBMquDWdMAtxmrhE+S8fAaWUvktE0+Jf/s2Hj4hj4QmLlln8PSMzVhhQuomvU0WrMHfShV4DdwiY4Sl10u0zA9tQkcUE+cKQXhP4t7RzNAUY0Aayxq0PL6jzlcgOPyd50=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3865.namprd15.prod.outlook.com (2603:10b6:303:42::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Mon, 16 Mar
 2020 05:52:05 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2814.021; Mon, 16 Mar 2020
 05:52:05 +0000
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
Thread-Index: AQHV+ZrMj1Iy/L1gLESYfUQuCI4fzqhHYXEAgAASAwCAAMu+gIACe6OA
Date:   Mon, 16 Mar 2020 05:52:05 +0000
Message-ID: <E2EAEA95-C05C-4CA1-9B92-D174B06907C4@fb.com>
References: <20200314003518.3114452-1-songliubraving@fb.com>
 <20200314024322.vymr6qkxsf6nzpum@ast-mbp.dhcp.thefacebook.com>
 <E7BBB6E4-F911-47D4-A4BC-3DF3D29B557B@fb.com>
 <20200314155703.bmtojqeofzxbqqhu@ast-mbp>
In-Reply-To: <20200314155703.bmtojqeofzxbqqhu@ast-mbp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:5df6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf783362-deff-4913-9659-08d7c96e285d
x-ms-traffictypediagnostic: MW3PR15MB3865:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB38656E35F6024CA571828764B3F90@MW3PR15MB3865.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03449D5DD1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(136003)(396003)(39860400002)(199004)(6486002)(2906002)(6506007)(53546011)(5660300002)(6916009)(7416002)(186003)(2616005)(316002)(33656002)(54906003)(478600001)(66946007)(4326008)(76116006)(66446008)(66556008)(66476007)(64756008)(8936002)(8676002)(81156014)(81166006)(6512007)(71200400001)(86362001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3865;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GZicqw1++fVn51ej+9a9KGoAy6BxqPQ37CONLzDIRoGW5q4yd8spKtBvZFSzLq5st+Q61ifhuUd1EqYyTHHEyvJTJI9BMj6R4w/KVo+SVI1gACbaN1S1G0ytq3cTNlQmfDv0aQTVxg5rczbvRtFkVi7rK1ZdPycJV3BPonKAKzKFCP3vkKgdCzpLnw3LCAbcXuJo22zBjs253Kh+ywZzWTtAAkUPtnawbQxzsFrx+hKqZNycwljQ2DCOTnmch+TLd5+kLZOz/X1I/jpzFuHPF/fGRpAFRCf6IimhSBCV+el17kTKLAzVlJzurWwIBMRuFeNX+8H675NBkaK+IPsIotl5QxG2Bn1QTwAYBpcc3gDsmAhpaXO5sbeqFEvUT0jbByHnY+MevdT5FiCzukEznD8fjComhiHjsCFFfhryUeUx9qYY0osSenaOyvC5Pp69
x-ms-exchange-antispam-messagedata: pIXqBrPyUnynU+kqrqqfJRycSEuoEMzxE2qJxOhX3iuzT7cjwfNG05He6btVeaShs3rmkHI6paWjMlX10OKADVQbyYCAa3TnRGyrflEAyV9SbbeafGDXpnisIZ8UI11gJ244Ayfj0Meb7GQUzPREOB0LrSX98iVYLtkFchi3sx8tYWpIkLXMIRirA96cG54z
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CA412405739B594EBD7EE8FE71F19178@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bf783362-deff-4913-9659-08d7c96e285d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2020 05:52:05.5379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3syjztk5nEoueQfIW0sZoUnR6+87gw2FeHnLJvzuoQ3Op6tRC2ZkchTgQ6/6HeSUmcb9y2lZ0garx2xoccVhwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3865
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-16_01:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160028
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 14, 2020, at 8:57 AM, Alexei Starovoitov <alexei.starovoitov@gmail=
.com> wrote:
>=20
> On Sat, Mar 14, 2020 at 03:47:50AM +0000, Song Liu wrote:
>>=20
>>=20
>>> On Mar 13, 2020, at 7:43 PM, Alexei Starovoitov <alexei.starovoitov@gma=
il.com> wrote:
>>>=20
>>> On Fri, Mar 13, 2020 at 05:35:16PM -0700, Song Liu wrote:
>>>> Motivation (copied from 2/2):
>>>>=20
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
8< =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>> Currently, sysctl kernel.bpf_stats_enabled controls BPF runtime stats.
>>>> Typical userspace tools use kernel.bpf_stats_enabled as follows:
>>>>=20
>>>> 1. Enable kernel.bpf_stats_enabled;
>>>> 2. Check program run_time_ns;
>>>> 3. Sleep for the monitoring period;
>>>> 4. Check program run_time_ns again, calculate the difference;
>>>> 5. Disable kernel.bpf_stats_enabled.
>>>>=20
>>>> The problem with this approach is that only one userspace tool can tog=
gle
>>>> this sysctl. If multiple tools toggle the sysctl at the same time, the
>>>> measurement may be inaccurate.
>>>>=20
>>>> To fix this problem while keep backward compatibility, introduce
>>>> /dev/bpf_stats. sysctl kernel.bpf_stats_enabled will only change the
>>>> lowest bit of the static key. /dev/bpf_stats, on the other hand, adds =
2
>>>> to the static key for each open fd. The runtime stats is enabled when
>>>> kernel.bpf_stats_enabled =3D=3D 1 or there is open fd to /dev/bpf_stat=
s.
>>>>=20
>>>> With /dev/bpf_stats, user space tool would have the following flow:
>>>>=20
>>>> 1. Open a fd to /dev/bpf_stats;
>>>> 2. Check program run_time_ns;
>>>> 3. Sleep for the monitoring period;
>>>> 4. Check program run_time_ns again, calculate the difference;
>>>> 5. Close the fd.
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
8< =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>=20
>>>> 1/2 adds a few new API to jump_label.
>>>> 2/2 adds the /dev/bpf_stats and adjust kernel.bpf_stats_enabled handle=
r.
>>>>=20
>>>> Please share your comments.
>>>=20
>>> Conceptually makes sense to me. Few comments:
>>> 1. I don't understand why +2 logic is necessary.
>>> Just do +1 for every FD and change proc_do_static_key() from doing
>>> explicit enable/disable to do +1/-1 as well on transition from 0->1 and=
 1->0.
>>> The handler would need to check that 1->1 and 0->0 is a nop.
>>=20
>> With the +2/-2 logic, we use the lowest bit of the counter to remember=20
>> the value of the sysctl. Otherwise, we cannot tell whether we are making
>> 0->1 transition or 1->1 transition.=20
>=20
> that can be another static int var in the handler.
> and no need for patch 1.

Good idea!

>=20
>>>=20
>>> 2. /dev is kinda awkward. May be introduce a new bpf command that retur=
ns fd?
>>=20
>> Yeah, I also feel /dev is awkward. fd from bpf command sounds great.=20
>>=20
>>>=20
>>> 3. Instead of 1 and 2 tweak sysctl to do ++/-- unconditionally?
>>> Like repeated sysctl kernel.bpf_stats_enabled=3D1 will keep incrementin=
g it
>>> and would need equal amount of sysctl kernel.bpf_stats_enabled=3D0 to g=
et
>>> it back to zero where it will stay zero even if users keep spamming
>>> sysctl kernel.bpf_stats_enabled=3D0.
>>> This way current services that use sysctl will keep working as-is.
>>> Multiple services that currently collide on sysctl will magically start
>>> working without any changes to them. It is still backwards compatible.
>>=20
>> I think this is not fully backwards compatible. With current logic, the=
=20
>> following sequence disables stats eventually.=20
>>=20
>>  sysctl kernel.bpf_stats_enabled=3D1
>>  sysctl kernel.bpf_stats_enabled=3D1
>>  sysctl kernel.bpf_stats_enabled=3D0
>>=20
>> The same sequence will not disable stats with the ++/-- sysctl.=20
>=20
> sure, but if a process holding an fd 'sysctl kernel.bpf_stats_enabled=3D0=
'
> won't disable stats either. So it's also not backwards compatible. imo it=
's a
> change in behavior whichever way, but either approach doesn't break user =
space.
> An advantage of not doing an fd is that some user that really wants to ha=
ve
> stats disabled for performance benchmarking can do
> 'sysctl kernel.bpf_stats_enabled=3D0' few times and the stats will be off=
.
> We can also make 'sysctl kernel.bpf_stats_enabled' to return current coun=
ter,
> so humans can see how many daemons are doing stats collection at that ver=
y
> moment.
> We can also do both new fd via bpf syscall and ++/-- via sysctl, but imo
> ++/-- via sysctl is enough to address the issue of multiple stats collect=
ing
> daemons. The patch would be small enough that we can push it via bpf tree
> and into older kernels as arguable 'fix'.

For multiple tools to share run_time_ns stats, I think we need to address t=
wo
issues:

  1. run_time_ns is turned off when the tool is monitoring;=20
  2. run_time_ns is left on when no one is using it.=20

On the the other hand, when the tool is not monitoring run_time_ns, it shou=
ld=20
not care whether the kernel is counting it.=20

Currently, we have both problem #1 and #2. ++/-- sysctl will help solve #1,=
 but
won't help #2, e.g., when the tool crashes. fd solution also solves #2.=20

Also, I think sysctl should not do ++/--? Most (all?) sysctl just does "set=
 the=20
value", no?=20

Eventually, we should ask all tools to use the fd interface, and deprecate =
the
sysctl. For backward compatibility, we can have one legacy tool (using sysc=
tl)
and multiple new tools (using fd interface) share run_time_ns. I feel this =
is=20
almost fully backward compatible, because when the tool is not monitoring i=
t=20
should not care whether run_time_ns is on.=20

Thanks,
Song=
