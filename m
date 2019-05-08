Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF9016FE4
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 06:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfEHEVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 00:21:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35636 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbfEHEVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 00:21:19 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x484IgYb003510;
        Tue, 7 May 2019 21:20:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=PL+cCfAiQG1R6Xx5r1Hl7gTS8cogqZ6EL7hry29zehU=;
 b=W7cBdHkUidgmx6lLbaJHhmKy+QsaO+D1AqbDPASomvL6lyq1tqoOOBhe1HDV6OfhQyzc
 ye460NxRVg4Bh+AZKsiNtiaErpaoM1EsjYVI1e++0m1AFqFN/axfmMMvKyfDWJ7EOF8O
 ELVr1erwxaMMxJT1R/WY2gGplm0Ro/h39r0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sbh8r990g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 07 May 2019 21:20:03 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 7 May 2019 21:20:01 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 7 May 2019 21:20:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PL+cCfAiQG1R6Xx5r1Hl7gTS8cogqZ6EL7hry29zehU=;
 b=BqdEm1/r762Z6yHeYGy196B/G7KmjmNjl7DHda2ktwUFRQu/rymHqqDNLOWD+GUSf/UVe579UyrsPVCO1EaYgQ5b9KNhgdoDtfsb6OQTj9LKkmHHI72BKliIrhIx2b5H0rFXGCYNF3Aa8nC9Cm5mx0fEElayklGng9u+pvOJwDg=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.156.24) by
 BYAPR15MB3223.namprd15.prod.outlook.com (20.179.56.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Wed, 8 May 2019 04:19:58 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::ddd2:172e:d688:b5b7]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::ddd2:172e:d688:b5b7%3]) with mapi id 15.20.1856.012; Wed, 8 May 2019
 04:19:58 +0000
From:   Roman Gushchin <guro@fb.com>
To:     syzbot <syzbot+f14868630901fc6151d3@syzkaller.appspotmail.com>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Martin Lau <kafai@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "tj@kernel.org" <tj@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: WARNING in cgroup_exit
Thread-Topic: WARNING in cgroup_exit
Thread-Index: AQHVBU8zxkbcSw7ynEe7cfC6yRSyx6Zgn/OA
Date:   Wed, 8 May 2019 04:19:58 +0000
Message-ID: <20190508041950.GA29396@castle>
References: <000000000000a573da058858083c@google.com>
In-Reply-To: <000000000000a573da058858083c@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0037.namprd21.prod.outlook.com
 (2603:10b6:300:129::23) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:152::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::2e8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4fa84ef-891d-486a-6875-08d6d36c6e8e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB3223;
x-ms-traffictypediagnostic: BYAPR15MB3223:
x-ms-exchange-purlcount: 9
x-microsoft-antispam-prvs: <BYAPR15MB3223DAEB70A614A11B0E530CBE320@BYAPR15MB3223.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0031A0FFAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(376002)(346002)(136003)(396003)(39860400002)(189003)(199004)(6436002)(2906002)(6486002)(966005)(71200400001)(71190400001)(25786009)(86362001)(229853002)(33656002)(1076003)(4326008)(33716001)(5660300002)(73956011)(66446008)(64756008)(66946007)(66476007)(66556008)(6246003)(8936002)(11346002)(52116002)(486006)(6512007)(478600001)(8676002)(7736002)(53936002)(305945005)(6116002)(9686003)(6306002)(6506007)(81156014)(81166006)(14454004)(68736007)(76176011)(316002)(386003)(54906003)(14444005)(99286004)(46003)(7116003)(102836004)(446003)(256004)(186003)(476003)(7416002)(99710200001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3223;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jdwlYzn+hvICg57ttlrHTFkBerHjSp9jWyjuBAnkURVxXM0Y7sXp34ouXbZJcfg5MU1RpErcmbxZIFwRikAOQp+SBtwSUuUkyKKXp8O+05KUcMjy0f1ePN7DCRUaOnYjvBeCRPC7DO6TMjp8d71zzVWqqNaDYqhiv4GsF+scZ4pT1klgt/DLL2Knr5rYxZ3AuqjCxmPG7eonwjaXzdDvWNHdmuxiid7MpKloOWFiwxSA90lx2Y5LAH6jSJhS6KvefxjMAn3Dhvfnss6TwsDTvEJ8CuWM00Cc0md8dhkQkC7zNSlbGSGSsiWzER1gRGk/6lZLGAWPwPvjP7MG/gRk+g3uJ2nL88hjNmeJmY3pCR68zU3vA0ncm9su502IGIsKTYinNHuScr36b1j4E4wJlAzPDKtLMSQgFBNaDWmRwGQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5ABAAF49F10CC241A744BA0F8295D68F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b4fa84ef-891d-486a-6875-08d6d36c6e8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2019 04:19:58.7961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3223
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_04:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

I'm aware of this problem and presumably know where it comes from. I expect=
 that
https://github.com/rgushchin/linux/commit/b1b6d210789ac0f5d83fd45fdab35eba1=
3cd2ce8
will fix it. I'll post it upstream tomorrow after some additional checks.

Thanks!

Roman

On Tue, May 07, 2019 at 08:36:07PM -0700, syzbot wrote:
> Hello,
>=20
> syzbot found the following crash on:
>=20
> HEAD commit:    00c3bc00 Add linux-next specific files for 20190507
> git tree:       linux-next
> console output: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__sy=
zkaller.appspot.com_x_log.txt-3Fx-3D15220ec8a00000&d=3DDwIBaQ&c=3D5VD0RTtNl=
Th3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4iaRvebxGXyCS0fK4EQzBl8b5C4bdR=
pBidLVWLI_GuM&s=3DhD1Gj5E63Z0nnx5OQgxeVKb91lJkZHE3qat1sAGP1ZI&e=3D
> kernel config:  https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__sy=
zkaller.appspot.com_x_.config-3Fx-3D63cd766601c6c9fc&d=3DDwIBaQ&c=3D5VD0RTt=
NlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4iaRvebxGXyCS0fK4EQzBl8b5C4b=
dRpBidLVWLI_GuM&s=3D_232tg9h9GVIkU_E6zSkqXt_VzdcnBSpy_oTxiER55s&e=3D
> dashboard link: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__sy=
zkaller.appspot.com_bug-3Fextid-3Df14868630901fc6151d3&d=3DDwIBaQ&c=3D5VD0R=
TtNlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4iaRvebxGXyCS0fK4EQzBl8b5C=
4bdRpBidLVWLI_GuM&s=3DodzDbHDodu7xVLUX5bYH4hZS4TDEJ_Q-Wda-pamijDo&e=3D
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__sy=
zkaller.appspot.com_x_repro.syz-3Fx-3D10fcf758a00000&d=3DDwIBaQ&c=3D5VD0RTt=
NlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4iaRvebxGXyCS0fK4EQzBl8b5C4b=
dRpBidLVWLI_GuM&s=3DynJR0QYyNDxBMdGoc8vUawwmdbQQ4uGaH47E1lCToTw&e=3D
> C reproducer:   https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__sy=
zkaller.appspot.com_x_repro.c-3Fx-3D1202ffa4a00000&d=3DDwIBaQ&c=3D5VD0RTtNl=
Th3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4iaRvebxGXyCS0fK4EQzBl8b5C4bdR=
pBidLVWLI_GuM&s=3DTOZmN6wU-5eoDmgsf8dUSHVHfd8PiXWMHtLF8zIfVR0&e=3D
>=20
> IMPORTANT: if you fix the bug, please add the following tag to the commit=
:
> Reported-by: syzbot+f14868630901fc6151d3@syzkaller.appspotmail.com
>=20
> WARNING: CPU: 0 PID: 8653 at kernel/cgroup/cgroup.c:6008
> cgroup_exit+0x51a/0x5d0 kernel/cgroup/cgroup.c:6008
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 8653 Comm: syz-executor076 Not tainted 5.1.0-next-20190507 #2
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>  panic+0x2cb/0x75a kernel/panic.c:218
>  __warn.cold+0x20/0x47 kernel/panic.c:575
>  report_bug+0x263/0x2b0 lib/bug.c:186
>  fixup_bug arch/x86/kernel/traps.c:179 [inline]
>  fixup_bug arch/x86/kernel/traps.c:174 [inline]
>  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
>  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
>  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:972
> RIP: 0010:cgroup_exit+0x51a/0x5d0 kernel/cgroup/cgroup.c:6008
> Code: 00 48 c7 c2 20 7f 6d 87 be d3 01 00 00 48 c7 c7 20 80 6d 87 c6 05 0=
1
> 93 f1 07 01 e8 fb 03 ed ff e9 b1 fb ff ff e8 96 f9 05 00 <0f> 0b e9 75 fc=
 ff
> ff e8 8a f9 05 00 48 c7 c2 e0 82 6d 87 be 85 02
> RSP: 0018:ffff888086c17a80 EFLAGS: 00010093
> RAX: ffff88808e99a000 RBX: 0000000000000001 RCX: ffffffff816b0b5e
> RDX: 0000000000000000 RSI: ffffffff816b0eea RDI: 0000000000000001
> RBP: ffff888086c17b18 R08: ffff88808e99a000 R09: ffffed1010d82f3e
> R10: ffffed1010d82f3d R11: 0000000000000003 R12: ffff88808e99a000
> R13: ffff8880981c3200 R14: ffff888086c17af0 R15: 1ffff11010d82f52
>  do_exit+0x97a/0x2fa0 kernel/exit.c:889
>  do_group_exit+0x135/0x370 kernel/exit.c:980
>  get_signal+0x425/0x2270 kernel/signal.c:2638
>  do_signal+0x87/0x1900 arch/x86/kernel/signal.c:815
>  exit_to_usermode_loop+0x244/0x2c0 arch/x86/entry/common.c:163
>  prepare_exit_to_usermode arch/x86/entry/common.c:198 [inline]
>  syscall_return_slowpath arch/x86/entry/common.c:276 [inline]
>  do_syscall_64+0x57e/0x670 arch/x86/entry/common.c:301
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x4471e9
> Code: e8 3c e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f=
7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff
> 0f 83 ab 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f479f748db8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 00000000006dcc38 RCX: 00000000004471e9
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006dcc38
> RBP: 00000000006dcc30 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc3c
> R13: 00007ffd1ab0c31f R14: 00007f479f7499c0 R15: 0000000000000001
> Shutting down cpus with NMI
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>=20
>=20
> ---
> This bug is generated by a bot. It may contain errors.
> See https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__goo.gl_tpsmEJ&=
d=3DDwIBaQ&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4iaRve=
bxGXyCS0fK4EQzBl8b5C4bdRpBidLVWLI_GuM&s=3D-w9lCOsM40BNPAQbJETOta_aO2oUunuWH=
F7_HEF_s4M&e=3D for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this bug report. See:
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__goo.gl_tpsmEJ-23st=
atus&d=3DDwIBaQ&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3D4=
iaRvebxGXyCS0fK4EQzBl8b5C4bdRpBidLVWLI_GuM&s=3DwbPAdt5WlkacKUJ6S-HTGGEVDOC1=
zOhIrPgSCdOq3UI&e=3D for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__goo.gl_tpsmEJ-23te=
sting-2Dpatches&d=3DDwIBaQ&c=3D5VD0RTtNlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d=
29HYQ&m=3D4iaRvebxGXyCS0fK4EQzBl8b5C4bdRpBidLVWLI_GuM&s=3DOmC7nK5BIF4c92BuG=
G7AK2hjFHZhajxJG-VJh0jJRvc&e=3D
