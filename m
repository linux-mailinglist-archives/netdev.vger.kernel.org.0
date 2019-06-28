Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD2345A4C1
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfF1TFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:05:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16530 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbfF1TFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:05:06 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SJ3YQC028170;
        Fri, 28 Jun 2019 12:04:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=S5QH4BVKGeBUZnH0Y7rXt5wyQUJd1/Z5F2AJK2iZL4E=;
 b=EHfdBzdwvBxLaMsCzNdVNKh5sESSDn0GZs/WW6piDUialnCdN0txkef6SM5LHJy7P4GA
 0RUuQXXDucfBETnbaIsRAXmtWzVZ3T+XUPkTnEuEKFAjrFO5R4m21qLgjN3H+2X2Tiax
 BzCUM1dh7ThWL2ub7j9wqKauvIRlUGaj7Dk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2td9ka31w1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 28 Jun 2019 12:04:30 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Jun 2019 12:04:28 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 28 Jun 2019 12:04:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=g8vil7AjTXxxaazzjur3er/lUJVLITQMeNZGIO3pEgJRssnnOaAGrNmSquQOvkL+2o6oaY1uxonDvtxhZ+Dw8UANK5yZIdeLZKeJsrvpR5uJhgzSx4RfpoR0fzLteiWeC2mGCgGu3nu0bgxWLbxjXaDFUb8KiwqvRdhgD/E4SdU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5QH4BVKGeBUZnH0Y7rXt5wyQUJd1/Z5F2AJK2iZL4E=;
 b=pqa+eC4br+yXvj8wdzYCfHQgccoclSjuqNd6U6qn/Ez4qZWG9DxmTfyNvQq5H0CIAEYcHlX7pTNr4/0iO+Q4i2RgOjG82AFeg2Afw+MMTzhFuIO639mfKUL8jLNNQxYCwV6rQdk7p/32BkPlpVwHZZLWagRTMjS55hMuxxp8anE=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5QH4BVKGeBUZnH0Y7rXt5wyQUJd1/Z5F2AJK2iZL4E=;
 b=nh3IYwTK4hsIhKSeWcP2GeK7YWueEblyviEg7R58ZCOULT1M+K4ghLefmQn065SQwOcw8gvnZD+cy2iBFzxO4xwM4hCRlmn677rSlfg3/1Z4hil676SwCZinl1fad6mk8L16v7I/xx9mguOEWIMN/3wRAlKwU0H2k04fN8Kxtc4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1838.namprd15.prod.outlook.com (10.174.255.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 19:04:24 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Fri, 28 Jun 2019
 19:04:24 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-abi@vger.kernel.org" <linux-abi@vger.kernel.org>,
        "kees@chromium.org" <kees@chromium.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via
 /dev/bpf
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awKSYAgAFFJoA=
Date:   Fri, 28 Jun 2019 19:04:24 +0000
Message-ID: <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
In-Reply-To: <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::2127]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 646e147e-5cb0-4f02-5d39-08d6fbfb6f52
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1838;
x-ms-traffictypediagnostic: MWHPR15MB1838:
x-microsoft-antispam-prvs: <MWHPR15MB1838BFEE640EBBFB3BB5A7DBB3FC0@MWHPR15MB1838.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(376002)(136003)(39860400002)(189003)(199004)(6506007)(4326008)(2906002)(57306001)(68736007)(36756003)(54906003)(53936002)(11346002)(46003)(6246003)(446003)(5660300002)(476003)(316002)(6512007)(71200400001)(2616005)(486006)(71190400001)(25786009)(76116006)(229853002)(478600001)(53546011)(99286004)(6916009)(81166006)(81156014)(66476007)(76176011)(66946007)(86362001)(256004)(6436002)(66446008)(6486002)(186003)(73956011)(14444005)(50226002)(6116002)(64756008)(8936002)(66556008)(33656002)(102836004)(14454004)(7416002)(7736002)(8676002)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1838;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VOBquLOJy518kQIBeS0UTiWod/vtsqynze0QGWp6O163xktoENly2sPAB+QzXvd9sUOAX8s3MJ5riMkw3Pu0oKhH82DUk5Oqsd2P9JSrdPLK5s790NmXWLwmBoc4qs2eld/tyz8mkjnwAI5WpSfJUW2+MIfQ6ftFRs9U76Qk/qawqFvKqagdgcHUJqwMmJRqGxWjvNDQjuoxUboEcmlQ+6yT8yyMPyom0FYszTWinMeqEqzxM5hgrG0zMSq5hbtA0Hhy3jFQgn5syfeZqp7U9TR1E+dW+ODsfU0dsxF28Yba7VTv8S4EezRZ0UX3gNOHgHDSRtCXXvXuw2iT60O94UFKluNz2R49pTIjv7w2gXwqO2vILGT8iru8gIFAsXyfFC8ZWg3I/NWq0BelXY+GtD+9eVK/QJ8hTuIbUfDjUBs=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D168CFEC5201244EA94512D309D9EBC6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 646e147e-5cb0-4f02-5d39-08d6fbfb6f52
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 19:04:24.0364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1838
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280215
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,=20

> On Jun 27, 2019, at 4:40 PM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On 6/27/19 1:19 PM, Song Liu wrote:
>> This patch introduce unprivileged BPF access. The access control is
>> achieved via device /dev/bpf. Users with write access to /dev/bpf are ab=
le
>> to call sys_bpf().
>> Two ioctl command are added to /dev/bpf:
>> The two commands enable/disable permission to call sys_bpf() for current
>> task. This permission is noted by bpf_permitted in task_struct. This
>> permission is inherited during clone(CLONE_THREAD).
>> Helper function bpf_capable() is added to check whether the task has got
>> permission via /dev/bpf.
>=20
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 0e079b2298f8..79dc4d641cf3 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -9134,7 +9134,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_at=
tr *attr,
>>  		env->insn_aux_data[i].orig_idx =3D i;
>>  	env->prog =3D *prog;
>>  	env->ops =3D bpf_verifier_ops[env->prog->type];
>> -	is_priv =3D capable(CAP_SYS_ADMIN);
>> +	is_priv =3D bpf_capable(CAP_SYS_ADMIN);
>=20
> Huh?  This isn't a hardening measure -- the "is_priv" verifier mode allow=
s straight-up leaks of private kernel state to user mode.
>=20
> (For that matter, the pending lockdown stuff should possibly consider thi=
s a "confidentiality" issue.)
>=20
>=20
> I have a bigger issue with this patch, though: it's a really awkward way =
to pretend to have capabilities.  For bpf, it seems like you could make thi=
s be a *real* capability without too much pain since there's only one sysca=
ll there.  Just find a way to pass an fd to /dev/bpf into the syscall.  If =
this means you need a new bpf_with_cap() syscall that takes an extra argume=
nt, so be it.  The old bpf() syscall can just translate to bpf_with_cap(...=
, -1).
>=20
> For a while, I've considered a scheme I call "implicit rights".  There wo=
uld be a directory in /dev called /dev/implicit_rights.  This would either =
be part of devtmpfs or a whole new filesystem -- it would *not* be any othe=
r filesystem.  The contents would be files that can't be read or written an=
d exist only in memory.  You create them with a privileged syscall.  Certai=
n actions that are sensitive but not at the level of CAP_SYS_ADMIN (use of =
large-attack-surface bpf stuff, creation of user namespaces, profiling the =
kernel, etc) could require an "implicit right".  When you do them, if you d=
on't have CAP_SYS_ADMIN, the kernel would do a path walk for, say, /dev/imp=
licit_rights/bpf and, if the object exists, can be opened, and actually ref=
ers to the "bpf" rights object, then the action is allowed.  Otherwise it's=
 denied.
>=20
> This is extensible, and it doesn't require the rather ugly per-task state=
 of whether it's enabled.
>=20
> For things like creation of user namespaces, there's an existing API, and=
 the default is that it works without privilege.  Switching it to an implic=
it right has the benefit of not requiring code changes to programs that alr=
eady work as non-root.
>=20
> But, for BPF in particular, this type of compatibility issue doesn't exis=
t now.  You already can't use most eBPF functionality without privilege.  N=
ew bpf-using programs meant to run without privilege are *new*, so they can=
 use a new improved API.  So, rather than adding this obnoxious ioctl, just=
 make the API explicit, please.
>=20
> Also, please cc: linux-abi next time.

Thanks for your inputs.=20

I think we need to clarify the use case here. In this case, we are NOT=20
thinking about creating new tools for unprivileged users. Instead, we=20
would like to use existing tools without root. Currently, users of these
tools have to run them with root or sudo. But they would prefer not to.=20

On the kernel side, we are not planning provides a subset of safe=20
features for unprivileged users. The permission here is all-or-nothing.=20

Introducing bpf_with_cap() syscall means we need teach these tools to=20
manage the fd, and use the new API when necessary. This is clearly not=20
easy. On the other hand, current solution is easy to adopt for most=20
tools (see 4/4 of this set).=20

Also, for this use case, I don't see bpf_with_cap() more secure than=20
this patch.

Thanks,
Song


