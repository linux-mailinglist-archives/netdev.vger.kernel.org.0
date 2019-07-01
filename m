Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 298705B76C
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 11:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbfGAJD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 05:03:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36964 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728184AbfGAJD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 05:03:56 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6191Qta019619;
        Mon, 1 Jul 2019 02:03:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=5pPQA3eDoT2uzeKpqBy+7qUIvZr06Lma1aAosBNWor0=;
 b=D23MhP6vfYs0JeYJkTAR0W4s4GqHpYtU5KX0/gqCx1KpypmEMzJAn3YRwtKsrgUSb/XX
 +BSe0Cv0dWpi/I8SGEFGuJuoCbM1bTM4JVpRDVPpFV5au8A3ou6gL8NBJO0GCh9QAHa+
 ux7dSbioBOmu4UgVVpgnwoWbg6FC6NENEuE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2te3t354wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 01 Jul 2019 02:03:31 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 1 Jul 2019 02:03:30 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 02:03:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=VIlBtjxDI8h8w5NKb+XaQ5SuNXGmno0FwRAm54UruM1qegDStPBmjiks4Fc/mpwny1SHTZ/Ve0OeImDhUsr+WiYjXLNJn+0qZre1vZZnUpwLPjbw5H7HHjk+6pAcxGS1Cw83+A7oznjMA2wpHW33R9Lcv9RasJC43vy7zDg9or4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5pPQA3eDoT2uzeKpqBy+7qUIvZr06Lma1aAosBNWor0=;
 b=fapGmhYy0CLNPPjjpOs6NYIxm94ZwoonL2SbKDuINmeoJFKnFgWe/MHZyxI8VD0NbAvbE9LvArqxyBV6XWr6XTo8cujR4RdrGoYFlpsTccO7hHV2iLevQJ48kR9+cYdtyM/2Xvlf10fjm5LcN//uKNHy7QDY3x0Y1HMtBlitBMk=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5pPQA3eDoT2uzeKpqBy+7qUIvZr06Lma1aAosBNWor0=;
 b=DtdKXgW8aZYCA1pQ5DqlapTAc6vCsBdePAPDiGBVJd1D+UYRSot0Cc/TQ9grQ0NGoEPjczveka6PNp/jtb/lkerUOh9dwCSAWE716IHPw5NSe5X5sIKNp6IWMMps/6TRnibdllADSAC8B3A8hMJJsLVwZ8Jc6KwMglilAlhyLBw=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1582.namprd15.prod.outlook.com (10.173.234.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 1 Jul 2019 09:03:29 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::c804:a8f3:8e8b:3311]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::c804:a8f3:8e8b:3311%8]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 09:03:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
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
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awKSYAgAFFJoCAAehSgIACJsgA
Date:   Mon, 1 Jul 2019 09:03:29 +0000
Message-ID: <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
 <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
In-Reply-To: <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c095:180::1:d150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 803c93c8-4b95-41a5-6743-08d6fe02fc2b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1582;
x-ms-traffictypediagnostic: MWHPR15MB1582:
x-microsoft-antispam-prvs: <MWHPR15MB15822DC67F2A74756F00EA52B3F90@MWHPR15MB1582.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39860400002)(376002)(136003)(346002)(189003)(199004)(51914003)(66446008)(64756008)(66556008)(66946007)(73956011)(25786009)(76116006)(53546011)(7736002)(66476007)(76176011)(36756003)(71200400001)(71190400001)(316002)(102836004)(6246003)(305945005)(6506007)(4326008)(54906003)(81166006)(6916009)(53936002)(50226002)(8936002)(99286004)(81156014)(8676002)(446003)(6436002)(11346002)(68736007)(6512007)(5660300002)(6486002)(6116002)(7416002)(86362001)(478600001)(57306001)(229853002)(14444005)(486006)(2616005)(476003)(256004)(33656002)(2906002)(46003)(186003)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1582;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 96HDMGGOjfTFSZ7XDRONzjs/GZPW/J4Po0XtPwZaiPcw625TtZV7P3XlsaFMilNikSWqIsDiXJ4r2nY06pHm04MNCK0ShwwEDZVorFpEblZNDVs7VsMMbo88v7MJOCPkq4AxQaBuTwv27JWmnid7K7awFt+fbpSYWH00SzvcfFiF9ihRYbFEkn3cibWvBFAWHt+0M7QjtVp0oFhN+Cj1iWZGAmRyAXzCoObOKw8NxiEe3hyZTXFH0ojNzs2zpNPMg1hQUP4zMPrPUkWb/lpVflclru9yTYvi9GZkxeE3HVWWwQar5mUhTA/2iuGTqsC3oma+2QBGR5wjO3QNmsMYOOkcWGOTNfOksg6Jn+BIkIF8uyvTGqQixPfQGm3eOyG2wWW7Y8ihu9CcsiHvpIm/hgJeuY0d75SS5ghxL0dIIX0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <45EE87FC0E16944BB86134ADC4141846@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 803c93c8-4b95-41a5-6743-08d6fe02fc2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 09:03:29.1744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1582
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010113
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

Thanks for these detailed analysis.=20

> On Jun 30, 2019, at 8:12 AM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Fri, Jun 28, 2019 at 12:05 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Hi Andy,
>>=20
>>> On Jun 27, 2019, at 4:40 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>>=20
>>> On 6/27/19 1:19 PM, Song Liu wrote:
>>>> This patch introduce unprivileged BPF access. The access control is
>>>> achieved via device /dev/bpf. Users with write access to /dev/bpf are =
able
>>>> to call sys_bpf().
>>>> Two ioctl command are added to /dev/bpf:
>>>> The two commands enable/disable permission to call sys_bpf() for curre=
nt
>>>> task. This permission is noted by bpf_permitted in task_struct. This
>>>> permission is inherited during clone(CLONE_THREAD).
>>>> Helper function bpf_capable() is added to check whether the task has g=
ot
>>>> permission via /dev/bpf.
>>>=20
>>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>>> index 0e079b2298f8..79dc4d641cf3 100644
>>>> --- a/kernel/bpf/verifier.c
>>>> +++ b/kernel/bpf/verifier.c
>>>> @@ -9134,7 +9134,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_=
attr *attr,
>>>>             env->insn_aux_data[i].orig_idx =3D i;
>>>>     env->prog =3D *prog;
>>>>     env->ops =3D bpf_verifier_ops[env->prog->type];
>>>> -    is_priv =3D capable(CAP_SYS_ADMIN);
>>>> +    is_priv =3D bpf_capable(CAP_SYS_ADMIN);
>>>=20
>>> Huh?  This isn't a hardening measure -- the "is_priv" verifier mode all=
ows straight-up leaks of private kernel state to user mode.
>>>=20
>>> (For that matter, the pending lockdown stuff should possibly consider t=
his a "confidentiality" issue.)
>>>=20
>>>=20
>>> I have a bigger issue with this patch, though: it's a really awkward wa=
y to pretend to have capabilities. For bpf, it seems like you could make th=
is be a *real* capability without too much pain since there's only one sysc=
all there.  Just find a way to pass an fd to /dev/bpf into the syscall.  If=
 this means you need a new bpf_with_cap() syscall that takes an extra argum=
ent, so be it.  The old bpf() syscall can just translate to bpf_with_cap(..=
., -1).
>>>=20
>>> For a while, I've considered a scheme I call "implicit rights".  There =
would be a directory in /dev called /dev/implicit_rights.  This would eithe=
r be part of devtmpfs or a whole new filesystem -- it would *not* be any ot=
her filesystem.  The contents would be files that can't be read or written =
and exist only in memory. You create them with a privileged syscall.  Certa=
in actions that are sensitive but not at the level of CAP_SYS_ADMIN (use of=
 large-attack-surface bpf stuff, creation of user namespaces, profiling the=
 kernel, etc) could require an "implicit right".  When you do them, if you =
don't have CAP_SYS_ADMIN, the kernel would do a path walk for, say, /dev/im=
plicit_rights/bpf and, if the object exists, can be opened, and actually re=
fers to the "bpf" rights object, then the action is allowed.  Otherwise it'=
s denied.
>>>=20
>>> This is extensible, and it doesn't require the rather ugly per-task sta=
te of whether it's enabled.
>>>=20
>>> For things like creation of user namespaces, there's an existing API, a=
nd the default is that it works without privilege.  Switching it to an impl=
icit right has the benefit of not requiring code changes to programs that a=
lready work as non-root.
>>>=20
>>> But, for BPF in particular, this type of compatibility issue doesn't ex=
ist now.  You already can't use most eBPF functionality without privilege. =
 New bpf-using programs meant to run without privilege are *new*, so they c=
an use a new improved API.  So, rather than adding this obnoxious ioctl, ju=
st make the API explicit, please.
>>>=20
>>> Also, please cc: linux-abi next time.
>>=20
>> Thanks for your inputs.
>>=20
>> I think we need to clarify the use case here. In this case, we are NOT
>> thinking about creating new tools for unprivileged users. Instead, we
>> would like to use existing tools without root.
>=20
> I read patch 4, and I interpret it very differently.  Patches 2-4 are
> creating a new version of libbpf and a new version of bpftool.  Given
> this, I see no real justification for adding a new in-kernel per-task
> state instead of just pushing the complexity into libbpf.

I am not sure whether we are on the same page. Let me try an example,=20
say we have application A, which calls sys_bpf().=20

Before the series: we have to run A with root;=20
After the series:  we add a special user with access to /dev/bpf, and=20
                   run A with this special user.=20

If we look at the whole system, I would say we are more secure after=20
the series.=20

I am not trying to make an extreme example here, because this use case
is the motivation here.=20

To stay safe, we have to properly manage the permission of /dev/bpf.=20
This is just like we need to properly manage access to /etc/sudoers and=20
/dev/mem.=20

Does this make sense?=20

Thanks,
Song

