Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6E08138A
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 09:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfHEHhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 03:37:18 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15114 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726394AbfHEHhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 03:37:17 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x757VSn0003935;
        Mon, 5 Aug 2019 00:36:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=omjDMBNfqUxM0LXx5+WLNfPqkBvrFjhTpCvj6pVmqX0=;
 b=hWa63ADyWIAumFH6iPhNu/HTqwReaOEfmpBdqSaNaA5V3qCL3DxnXDDSu+6u+hNp7R8r
 13FH8pm5T0jkFfxHhiGZoeTv7wv7crfgOjdcHEuOcD18ypS6lCpaHZbY7GTWGLJchjvp
 zWCmJpaAqDN7X59M7dg7eIAzXD2WR6nRo/M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2u55xdw7cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 05 Aug 2019 00:36:53 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 5 Aug 2019 00:36:52 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 5 Aug 2019 00:36:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtzVV7ek7qN4qp0MH9SMHhFbw5Hahj2eFN8usVAOxRWlrAF8xFEg8LJUr7RTqFKqpn2CFovg9lhZXlb/2X6cLx9L37NY7MBSCHkowb/IR/RYsqY0zg5RtkhpMEbEa4aZJ1dfahSp2Rcaa0qQ7ta9A/TMfdFc2w5oexvZSE8NkfFUG+nLL5YrPK6GR0KDFumlVw0t3Eu+80ihwcigiSSDEna1L2razLCIRatP6QESUGe20c27uwL0nP/+orrUCUcplBhQnF8nwZUpDqPar3bk0E/hARzGqJEVbgMp8LO74RZLpSJHeu5O/9Qwx/DbXaQxFtKEzGQaKHSMd+fzgFwQow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=omjDMBNfqUxM0LXx5+WLNfPqkBvrFjhTpCvj6pVmqX0=;
 b=XG8JeLIYgq9JJ8ayDR2Unlg9JGbQBJX0kszl3vwmjnzOhL/ZkAIF7mpubxqIyEUmEbXSD3YXQJq6sAzTUXGVLvAZ0sqaytdpGopd1IlmQMlE+H3QB3cG6nv1cAbNlyhd785uv4DnZ3qCIQLwkRuHNuzQq/SrDsbxW3qP4LCOYof5XTgYbRmDIPQzkpgr8jCzZxGp7HMbE8YnDzemY1tQxXP+6ssBMlbEAm/MuhC65k2vEXBwgphcspRXAcF9jb65yDyl1QZkp4xW9utHyWn5TUW4poeJQKOJurC+wJlQ9upWM1hROptsR+G7FA6C8cK0n5Jz4qPZLx8kH49XIygEoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=omjDMBNfqUxM0LXx5+WLNfPqkBvrFjhTpCvj6pVmqX0=;
 b=gcQE4cH6vtVp2SsNjPhAL3rFd4EPMSd5CxnmyUa/D8iicN8nlgz3b7asJBJSF6KkcflYoE8HxamGGGHlTY+p2WAyxOyqZQlYU70f4lypS4m+jbVt+BI17fbkZJp/kBORQKBw9KudUO7CNbR/tb+n4NvOtgd1jhKKEHkwB0i1Ssc=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1822.namprd15.prod.outlook.com (10.174.98.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.19; Mon, 5 Aug 2019 07:36:50 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::79c8:442d:b528:802d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::79c8:442d:b528:802d%9]) with mapi id 15.20.2136.010; Mon, 5 Aug 2019
 07:36:50 +0000
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
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awKSYAgAFFJoCAAehSgIACJsgAgAEbzICAARNPgIAANGYAgB9j6wCAATKggIAAgfQAgAAt2QCAAFEqAIAFfSwAgAPZeACAAQAYAIAAxVOAgAC4LoCAAl7hgIAEHsgAgAAfGQCAAF7NAIAAHpUA
Date:   Mon, 5 Aug 2019 07:36:50 +0000
Message-ID: <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
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
 <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com>
 <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
In-Reply-To: <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::57fe]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 544029af-a631-429e-99a2-08d71977ae06
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1822;
x-ms-traffictypediagnostic: MWHPR15MB1822:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR15MB182283AE5E82D8588A598536B3DA0@MWHPR15MB1822.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(366004)(39860400002)(346002)(396003)(199004)(189003)(51444003)(6512007)(966005)(14454004)(68736007)(5024004)(14444005)(256004)(486006)(186003)(25786009)(46003)(99286004)(71190400001)(71200400001)(2616005)(476003)(446003)(11346002)(4326008)(86362001)(478600001)(6306002)(76116006)(66946007)(91956017)(66446008)(57306001)(229853002)(66556008)(53546011)(6506007)(64756008)(316002)(54906003)(102836004)(5660300002)(33656002)(76176011)(7416002)(6486002)(6436002)(66476007)(6916009)(36756003)(53936002)(6246003)(50226002)(81166006)(81156014)(8676002)(6116002)(8936002)(305945005)(2906002)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1822;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PznA9JhQTUSvduI8FzKd3fMspUBEFdykwKWtfmaGBwvgIBGJ6t0DVJPTVknjehC+fg5ItCQOBJhqcERZ70jpvRTu2cgoV33wm3USF7dM5mzq81yHaGnVSciPhfG+NgLnS/KRTiH4N0/0HKeia6ydW52lfdxiz2ItRW7lxMGdNfJUZzl8GbZarp7EyjOpdmJ4Ux37yQvdPatiRBIUN9EOEJH87OTmZ9UAc5OsXvu51megkOqMHtrWqbwt5SJ3VNeRQLy1HnhDMGsxs8/HJDk/m0em8humRaJnlzuXVZOMLfAekwBbjNMTi6VU6dQkDf+G3zKiU45hFlTRi76hwQUJi16DtRjS0hSdpHFbUy0sxBKSILNptpCq/IKFqKqjLhiRFj4BljEIC49apjBzexv4zCdRB4RNv4HR0wqllCunJRA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <929F87C777254648A2737B8F6F5EF976@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 544029af-a631-429e-99a2-08d71977ae06
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 07:36:50.5506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1822
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050087
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,=20

> On Aug 4, 2019, at 10:47 PM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Sun, Aug 4, 2019 at 5:08 PM Andy Lutomirski <luto@kernel.org> wrote:
>>=20
>> On Sun, Aug 4, 2019 at 3:16 PM Andy Lutomirski <luto@kernel.org> wrote:
>>>=20
>>> On Fri, Aug 2, 2019 at 12:22 AM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>> Hi Andy,
>>>>=20
>>>>> I actually agree CAP_BPF_ADMIN makes sense. The hard part is to make
>>>>>> existing tools (setcap, getcap, etc.) and libraries aware of the new=
 CAP.
>>>>>=20
>>>>> It's been done before -- it's not that hard.  IMO the main tricky bit
>>>>> would be try be somewhat careful about defining exactly what
>>>>> CAP_BPF_ADMIN does.
>>>>=20
>>>> Agreed. I think defining CAP_BPF_ADMIN could be a good topic for the
>>>> Plumbers conference.
>>>>=20
>>>> OTOH, I don't think we have to wait for CAP_BPF_ADMIN to allow daemons
>>>> like systemd to do sys_bpf() without root.
>>>=20
>>> I don't understand the use case here.  Are you talking about systemd
>>> --user?  As far as I know, a user is expected to be able to fully
>>> control their systemd --user process, so giving it unrestricted bpf
>>> access is very close to giving it superuser access, and this doesn't
>>> sound like a good idea.  I think that, if systemd --user needs bpf(),
>>> it either needs real unprivileged bpf() or it needs a privileged
>>> helper (SUID or a daemon) to intermediate this access.
>>>=20
>>>>=20
>>>>>=20
>>>>>>> I don't see why you need to invent a whole new mechanism for this.
>>>>>>> The entire cgroup ecosystem outside bpf() does just fine using the
>>>>>>> write permission on files in cgroupfs to control access.  Why can't
>>>>>>> bpf() do the same thing?
>>>>>>=20
>>>>>> It is easier to use write permission for BPF_PROG_ATTACH. But it is
>>>>>> not easy to do the same for other bpf commands: BPF_PROG_LOAD and
>>>>>> BPF_MAP_*. A lot of these commands don't have target concept. Maybe
>>>>>> we should have target concept for all these commands. But that is a
>>>>>> much bigger project. OTOH, "all or nothing" model allows all these
>>>>>> commands at once.
>>>>>=20
>>>>> For BPF_PROG_LOAD, I admit I've never understood why permission is
>>>>> required at all.  I think that CAP_SYS_ADMIN or similar should be
>>>>> needed to get is_priv in the verifier, but I think that should mainly
>>>>> be useful for tracing, and that requires lots of privilege anyway.
>>>>> BPF_MAP_* is probably the trickiest part.  One solution would be some
>>>>> kind of bpffs, but I'm sure other solutions are possible.
>>>>=20
>>>> Improving permission management of cgroup_bpf is another good topic to
>>>> discuss. However, it is also an overkill for current use case.
>>>>=20
>>>=20
>>> I looked at the code some more, and I don't think this is so hard
>>> after all.  As I understand it, all of the map..by_id stuff is, to
>>> some extent, deprecated in favor of persistent maps.  As I see it, the
>>> map..by_id calls should require privilege forever, although I can
>>> imagine ways to scope that privilege to a namespace if the maps
>>> themselves were to be scoped to a namespace.
>>>=20
>>> Instead, unprivileged tools would use the persistent map interface
>>> roughly like this:
>>>=20
>>> $ bpftool map create /sys/fs/bpf/my_dir/filename type hash key 8 value
>>> 8 entries 64 name mapname
>>>=20
>>> This would require that the caller have either CAP_DAC_OVERRIDE or
>>> that the caller have permission to create files in /sys/fs/bpf/my_dir
>>> (using the same rules as for any filesystem), and the resulting map
>>> would end up owned by the creating user and have mode 0600 (or maybe
>>> 0666, or maybe a new bpf_attr parameter) modified by umask.  Then all
>>> the various capable() checks that are currently involved in accessing
>>> a persistent map would instead check FMODE_READ or FMODE_WRITE on the
>>> map file as appropriate.
>>>=20
>>> Half of this stuff already works.  I just set my system up like this:
>>>=20
>>> $ ls -l /sys/fs/bpf
>>> total 0
>>> drwxr-xr-x. 3 luto luto 0 Aug  4 15:10 luto
>>>=20
>>> $ mkdir /sys/fs/bpf/luto/test
>>>=20
>>> $ ls -l /sys/fs/bpf/luto
>>> total 0
>>> drwxrwxr-x. 2 luto luto 0 Aug  4 15:10 test
>>>=20
>>> I bet that making the bpf() syscalls work appropriately in this
>>> context without privilege would only be a couple of hours of work.
>>> The hard work, creating bpffs and making it function, is already done
>>> :)
>>>=20
>>> P.S. The docs for bpftool create are less than fantastic.  The
>>> complete lack of any error message at all when the syscall returns
>>> -EACCES is also not fantastic.
>>=20
>> This isn't remotely finished, but I spent a bit of time fiddling with th=
is:
>>=20
>> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=
=3Dbpf/perms
>>=20
>> What do you think?  (It's obviously not done.  It doesn't compile, and
>> I haven't gotten to the permissions needed to do map operations.  I
>> also haven't touched the capable() checks.)
>=20
> I updated the branch.  It compiles, and basic map functionality works!

Thanks a lot for trying this out. This is a very interesting direction
that we will explore.=20

>=20
> # mount -t bpf bpf /sys/fs/bpf
> # cd /sys/fs/bpf
> # mkdir luto
> # chown luto: luto
> # setpriv --euid=3D1000 --ruid=3D1000 bash
> $ pwd
> /sys/fs/bpf
> bash-5.0$ ls -l
> total 0
> drwxr-xr-x 2 luto luto 0 Aug  4 22:41 luto
> bash-5.0$ bpftool map create /sys/fs/bpf/luto/filename type hash key 8
> value 8 entries 64 name mapname
> bash-5.0$ bpftool map dump pinned /sys/fs/bpf/luto/filename
> Found 0 elements
>=20
> # chown root: /sys/fs/bpf/luto/filename
>=20
> $ bpftool map dump pinned /sys/fs/bpf/luto/filename
> Error: bpf obj get (/sys/fs/bpf/luto): Permission denied
>=20
> So I think it's possible to get a respectable subset of bpf()
> functionality working without privilege in short order :)

I think we have two key questions to answer:=20
  1. What subset of bpf() functionality will the users need?
  2. Who are the users?=20

Different answers to these two questions lead to different directions.


In our use case, the answers are=20
  1) almost all bpf() functionality
  2) highly trusted users (sudoers)

So our initial approach of /dev/bpf allows all bpf() functionality
in one bit in task_struct. (Yes, we can just sudo. But, we would=20
rather not use sudo when possible.)


"cgroup management" use case may have answers like:
  1) cgroup_bpf only
  2) users in their own containers

For this case, getting cgroup_bpf related features (cgroup_bpf progs;=20
some map types, etc.) work with unprivileged users would be the right=20
direction.=20


"USDT tracing" use case may have answers like:
  1) uprobe, stockmap, histogram, etc.
  2) unprivileged user, w/ or w/o containers

For this case, the first step is likely hacking sys_perf_event_open().=20


I guess we will need more discussions to decide how to make bpf()=20
work better for all these (and more) use cases.=20

Thanks,
Song

