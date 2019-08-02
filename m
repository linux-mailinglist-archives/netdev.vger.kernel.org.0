Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C517ED55
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 09:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389491AbfHBHWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 03:22:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19084 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729406AbfHBHWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 03:22:03 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x727JKLo007031;
        Fri, 2 Aug 2019 00:21:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=a7GgpciAqWqK6WegyXOD7Kvxlbsz//PJzOpZmetIgQ8=;
 b=Q3uSPcn4eq5Ajg1lxCGqQT2wSt45n7MdkjKlEVKEUzypxRJsRrzpOYLOKvsUsLaaDalJ
 ZiU5cLf8F/yIREky45EX9x6rlLH0gL+lXgxKf22hjEM3DkU8G+BrGcWMwyv7sE9sEmhM
 NaicmtctQE9smK36ykbv2MbHksLGaMa/Yo4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2u43h7tjvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Aug 2019 00:21:40 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 2 Aug 2019 00:21:39 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 2 Aug 2019 00:21:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKBB/AD18DDYEUBsKi5jL9OsrEJxQ8uuLBajAZqNtY+NfhlHu2aO16qrJUrG0Ophdf3YAP+ZYuRi8C149HSOP8l7GlCP2Ndx/EEYFO/QTbyU9OiszKywjd962fVXIDH8hbYXei1VPP7wY1n11aVrqgLftHmWJHBFPo48XBjbQcnd9kjt1rMuC0wg8DfhdQlFO4ZT9nVj8HK3gtEdmYD2/Wk7Jote4EbrTqLQQi+PBx3Oup0Wo5iavxUV6F6KWx0nSNTHwWQgg2KMRuNQFED4sCZtqwQFJq1HiUXcA/+rHa6+72kfwf4gWB7vl5xhsvUgCzybJ1/FYDlrznypPEj5GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7GgpciAqWqK6WegyXOD7Kvxlbsz//PJzOpZmetIgQ8=;
 b=EKD/mAKnjS7ex36nNfYsPB32GW3v+1uMlf92V5dd3xWTIp/tZf/AnpBdTgWlTs7k356boOgS1h5SJ2XBkQDkfUgUN5CH2gl1wYKvP6O0p5+GwA+BY08GMwxXgK1LL+HzFbfjetF22dDdnaQ4qkxFOmk4uJpIQJa+0+BCpX3YGzyLY5vQXIbITDCCaHZ88lsMiW04GLhLNmGUGXqftouFCiUZtZOmNfvNlkWVigyaI7tkLfv2vKAwnYI8yNyDDNPYTWmqEzJJiFwZY9mfwk7Vh8RFs0ViVasulMp9bZnY9yPq1AxZdM7+rdmfaT3NON45z5t84tRBRAqJl+QMPqcfow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7GgpciAqWqK6WegyXOD7Kvxlbsz//PJzOpZmetIgQ8=;
 b=BAbmXkFOkYInTDnjQQGoUhzKH2KEeyjVUy4EH+ZMr85ZvU1bF6B746pMFOmvpR6iuWk6vPWwnrAi3RMxrlPvRO41kcHZQUliPfl8B1+8ssXYwU2SdgienuqTKf50wzjSKPOvI6bKhygnUOQPr7+8gohXCWcv3rY88oav407ZIyA=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1952.namprd15.prod.outlook.com (10.175.8.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Fri, 2 Aug 2019 07:21:34 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::d4fc:70c0:79a5:f41b%2]) with mapi id 15.20.2115.005; Fri, 2 Aug 2019
 07:21:34 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "Lorenz Bauer" <lmb@cloudflare.com>, Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via
 /dev/bpf
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awKSYAgAFFJoCAAehSgIACJsgAgAEbzICAARNPgIAANGYAgB9j6wCAATKggIAAgfQAgAAt2QCAAFEqAIAFfSwAgAPZeACAAQAYAIAAxVOAgAC4LoCAAl7hgA==
Date:   Fri, 2 Aug 2019 07:21:33 +0000
Message-ID: <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
 <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
 <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook>
 <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
 <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
 <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com>
 <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
 <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com>
 <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
 <369476A8-4CE1-43DA-9239-06437C0384C7@fb.com>
 <CALCETrUpVMrk7aaf0trfg9AfZ4fy279uJgZH7V+gZzjFw=hUxA@mail.gmail.com>
 <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com>
 <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
In-Reply-To: <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:7350]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a5d317d-4059-4301-25d5-08d7171a0c7b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1952;
x-ms-traffictypediagnostic: MWHPR15MB1952:
x-microsoft-antispam-prvs: <MWHPR15MB195224A9C8C9B23D722C9F0DB3D90@MWHPR15MB1952.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(39860400002)(366004)(136003)(51444003)(189003)(199004)(102836004)(4326008)(6506007)(53546011)(6512007)(57306001)(14454004)(316002)(6116002)(99286004)(6246003)(7416002)(6916009)(33656002)(76176011)(54906003)(53936002)(478600001)(68736007)(25786009)(476003)(91956017)(76116006)(2616005)(8936002)(486006)(2906002)(6486002)(5660300002)(229853002)(446003)(86362001)(305945005)(186003)(81166006)(81156014)(8676002)(11346002)(7736002)(5024004)(14444005)(256004)(71190400001)(71200400001)(66946007)(50226002)(6436002)(66476007)(46003)(36756003)(64756008)(66446008)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1952;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NziHfZqqOh0gXEl0HrYKppa+PWCP9BMDqNsp7AX5V4GMgPST0i6A+xBvnlXElAOcrPZ3B9FS+XoJiVE9o+n9O4kQlC05lxz15MHm5/bgacba4TRllzctSPOI2o3io70msx012Z3CN4Iy0HNi7a47sYeqL8XhxsXf70xXcp5dD8JJ3sqP3LTxye/WZEXw4T+Qyp1rkJx9NAvRmvrHgnk10Y/NpC8gYSl23SC9iHJ0/S9uuzyNmeEwWw7zgHBivNGmYCuvX6cSRaXTJyEQc8b3f92oWPQIJT9Dbn/45tQzByZ8urhtOH/P47zYwgcbcjxVS4F1b070njJw546uYztOvDaRnK/9Bb+ABv1UA1XOLePMWDylzrEkb8b6rk3mwOMqKHam4GomYXbRomex8NjGBaN9STPMfnI6mWdDO0GCI0c=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4D40F33B94638543A6BA3E1D1275382F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5d317d-4059-4301-25d5-08d7171a0c7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 07:21:33.9007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1952
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-02_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=945 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908020074
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

> On Jul 31, 2019, at 12:09 PM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Wed, Jul 31, 2019 at 1:10 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Jul 30, 2019, at 1:24 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>>=20
>>> On Mon, Jul 29, 2019 at 10:07 PM Song Liu <songliubraving@fb.com> wrote=
:
>>>>=20
>>>> Hi Andy,
>>>>=20
>>>>> On Jul 27, 2019, at 11:20 AM, Song Liu <songliubraving@fb.com> wrote:
>>>>>=20
>>>>> Hi Andy,
>>>>>=20
>>>>>=20
>>=20
>> [...]
>>=20
>>>>>=20
>>>>=20
>>>> I would like more comments on this.
>>>>=20
>>>> Currently, bpf permission is more or less "root or nothing", which we
>>>> would like to change.
>>>>=20
>>>> The short term goal is to separate bpf from root, in other words, it i=
s
>>>> "all or nothing". Special user space utilities, such as systemd, would
>>>> benefit from this. Once this is implemented, systemd can call sys_bpf(=
)
>>>> when it is not running as root.
>>>=20
>>> As generally nasty as Linux capabilities are, this sounds like a good
>>> use for CAP_BPF_ADMIN.
>>=20
>> I actually agree CAP_BPF_ADMIN makes sense. The hard part is to make
>> existing tools (setcap, getcap, etc.) and libraries aware of the new CAP=
.
>=20
> It's been done before -- it's not that hard.  IMO the main tricky bit
> would be try be somewhat careful about defining exactly what
> CAP_BPF_ADMIN does.

Agreed. I think defining CAP_BPF_ADMIN could be a good topic for the=20
Plumbers conference.=20

OTOH, I don't think we have to wait for CAP_BPF_ADMIN to allow daemons=20
like systemd to do sys_bpf() without root.=20

>=20
>>> I don't see why you need to invent a whole new mechanism for this.
>>> The entire cgroup ecosystem outside bpf() does just fine using the
>>> write permission on files in cgroupfs to control access.  Why can't
>>> bpf() do the same thing?
>>=20
>> It is easier to use write permission for BPF_PROG_ATTACH. But it is
>> not easy to do the same for other bpf commands: BPF_PROG_LOAD and
>> BPF_MAP_*. A lot of these commands don't have target concept. Maybe
>> we should have target concept for all these commands. But that is a
>> much bigger project. OTOH, "all or nothing" model allows all these
>> commands at once.
>=20
> For BPF_PROG_LOAD, I admit I've never understood why permission is
> required at all.  I think that CAP_SYS_ADMIN or similar should be
> needed to get is_priv in the verifier, but I think that should mainly
> be useful for tracing, and that requires lots of privilege anyway.
> BPF_MAP_* is probably the trickiest part.  One solution would be some
> kind of bpffs, but I'm sure other solutions are possible.

Improving permission management of cgroup_bpf is another good topic to
discuss. However, it is also an overkill for current use case.=20

Let me get more details about the use case, so that we have a clear=20
picture about short term and long term goals.=20

Thanks again for your suggestions.=20
Song


