Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3FEE46D1B
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 02:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfFOAGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 20:06:25 -0400
Received: from mail-oln040092002055.outbound.protection.outlook.com ([40.92.2.55]:29852
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726329AbfFOAGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 20:06:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30HXd+dPJtY9USRwewE+Bx8bYj0GxNalDluahMAvmAA=;
 b=P3Wgja4ki15wIeHnix39n/Wm+5LJpLvalBRK6cZp8vSygMDI96MhjmlOC5blWCKTr1D2pCfaFkkLv3JCcqOHCz/WuUjseHnlQdw8VNv9k+B3wHX8ajpSE2elS4j2Ro2J694KfMay5bPAdzJ+gwLYk20ApIxg1y+knFJ5KjbAuUeLZm3TER4jkm/hEW8JYa/yz+UIXjjKZdEix1CjHUZLoyRSTu5I1e69cspGAUrwCag420F7gMrQeeJC5TuMLotiAcj7BbR/PXw/91gxMFWpHQ5U2anN/msPcDrimeNVqgnd+e/QPmazfO/DQ293ivqSlJm9O6OEFIxZSJ30AeaZqQ==
Received: from SN1NAM01FT041.eop-nam01.prod.protection.outlook.com
 (10.152.64.55) by SN1NAM01HT093.eop-nam01.prod.protection.outlook.com
 (10.152.65.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1987.11; Sat, 15 Jun
 2019 00:06:22 +0000
Received: from BYAPR02MB5704.namprd02.prod.outlook.com (10.152.64.54) by
 SN1NAM01FT041.mail.protection.outlook.com (10.152.65.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.1987.11 via Frontend Transport; Sat, 15 Jun 2019 00:06:22 +0000
Received: from BYAPR02MB5704.namprd02.prod.outlook.com
 ([fe80::18b:f08e:21ff:fa35]) by BYAPR02MB5704.namprd02.prod.outlook.com
 ([fe80::18b:f08e:21ff:fa35%5]) with mapi id 15.20.1987.013; Sat, 15 Jun 2019
 00:06:22 +0000
From:   abhja kaanlani <unidef_rogue@live.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        X86 ML <x86@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David Laight" <David.Laight@aculab.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 2/5] objtool: Fix ORC unwinding in non-JIT BPF
 generated code
Thread-Topic: [PATCH v2 2/5] objtool: Fix ORC unwinding in non-JIT BPF
 generated code
Thread-Index: AQHVItsbjvHW1pAgSkaM92TtuhP88aaboi8AgAACh4CAAAB3gIAAAtCAgAAA+oCAAB/wgIAAA5+AgAAJEQCAAAEGTw==
Date:   Sat, 15 Jun 2019 00:06:22 +0000
Message-ID: <BYAPR02MB57042A4F3AAA334A6349643183E90@BYAPR02MB5704.namprd02.prod.outlook.com>
References: <cover.1560534694.git.jpoimboe@redhat.com>
 <c0add777a2e0207c1474ce99baa492a7ce3502d6.1560534694.git.jpoimboe@redhat.com>
 <20190614205841.s4utbpurntpr6aiq@ast-mbp.dhcp.thefacebook.com>
 <20190614210745.kwiqm5pkgabruzuj@treble>
 <CAADnVQLK3ixK1JWF_mfScZoFzFF=6O8f1WcqkYqiejKeex1GSQ@mail.gmail.com>
 <20190614211929.drnnawbi7guqj2ck@treble>
 <CAADnVQ+BCxsKEK=ZzYOZkgTJAg_7jz1_f+FCX+Ms0vTOuW8Mxw@mail.gmail.com>
 <20190614231717.xukbfpc2cy47s4xh@treble>
 <CAADnVQJn+TnSj82MJ0ry1UTNGXD0qzESqfp7E1oi_HAYC-xTXg@mail.gmail.com>,<20190615000242.e5tcogffvyuuhnrs@treble>
In-Reply-To: <20190615000242.e5tcogffvyuuhnrs@treble>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-incomingtopheadermarker: OriginalChecksum:DB603815C01532625D1A267674924C175B13E31D40761902888A42887286FE9A;UpperCasedChecksum:C267D0A64ECB0339B6B7B385EF85E68656BD261CBC212BB4B7C483FD36C764C4;SizeAsReceived:8042;Count:44
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [QbZJjtTO8EPklbpsz0US2cH1AnpybpFKVX62RKtDOFog3dsjKtba8xX50oTC43yi]
x-ms-publictraffictype: Email
x-incomingheadercount: 44
x-eopattributedmessage: 0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(5050001)(7020095)(20181119110)(201702061078)(5061506573)(5061507331)(1603103135)(2017031320274)(2017031322404)(2017031323274)(2017031324274)(1601125500)(1603101475)(1701031045);SRVR:SN1NAM01HT093;
x-ms-traffictypediagnostic: SN1NAM01HT093:
x-microsoft-antispam-message-info: Q8qNuqf6Uuy02b1i3OVPLYOgHS376cv94/B8O4eqoPlHJ+HE1jAR9A2/9C5WM7rciEBPGYjAt45Rgve4I9n+VpZymPTTD3pY/lDgcDJFHP+PxtUYjj7/2891wOEq5Lz9WTjC8gEzmzi1mQW0gyqHA9rEbAdhSwRuRoHgZF0vDJyYZzwHlQVgLXyDZm/BR5S/
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: live.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d2cffa0-3052-41b6-d76d-08d6f1254cf9
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2019 00:06:22.3561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1NAM01HT093
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maybe add more multidimensional arrays?=20

Sent from my iPhone

>> On Jun 14, 2019, at 5:02 PM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>>=20
>>> On Fri, Jun 14, 2019 at 04:30:15PM -0700, Alexei Starovoitov wrote:
>>>> On Fri, Jun 14, 2019 at 4:17 PM Josh Poimboeuf <jpoimboe@redhat.com> w=
rote:
>>>>=20
>>>> On Fri, Jun 14, 2019 at 02:22:59PM -0700, Alexei Starovoitov wrote:
>>>> On Fri, Jun 14, 2019 at 2:19 PM Josh Poimboeuf <jpoimboe@redhat.com> w=
rote:
>>>>>>>>>=20
>>>>>>>>> +#define JUMP_TABLE_SYM_PREFIX "jump_table."
>>>>>>>>=20
>>>>>>>> since external tool will be looking at it should it be named
>>>>>>>> "bpf_jump_table." to avoid potential name conflicts?
>>>>>>>> Or even more unique name?
>>>>>>>> Like "bpf_interpreter_jump_table." ?
>>>>>>>=20
>>>>>>> No, the point is that it's a generic feature which can also be used=
 any
>>>>>>> non-BPF code which might also have a jump table.
>>>>>>=20
>>>>>> and you're proposing to name all such jump tables in the kernel
>>>>>> as static foo jump_table[] ?
>>>>>=20
>>>>> That's the idea.
>>>>=20
>>>> Then it needs much wider discussion.
>>>=20
>>> Why would it need wider discussion?  It only has one user.  If you
>>> honestly believe that it will be controversial to require future users
>>> to call a static jump table "jump_table" then we can have that
>>> discussion when it comes up.
>>=20
>> It's clearly controversial.
>> I nacked it already on pointless name change
>> from "jumptable" to "jump_table" and now you're saying
>> that no one will complain about "jump_table" name
>> for all jump tables in the kernel that will ever appear?
>=20
> Let me get this straight.  You're saying that "jumptable" and
> "bpf_interpreter_jump_table" are both acceptable.
>=20
> But NACK to "jump_table".
>=20
> Ok...
>=20
> --=20
> Josh
