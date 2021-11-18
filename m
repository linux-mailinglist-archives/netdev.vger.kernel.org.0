Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB71455187
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 01:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241832AbhKRAPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 19:15:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241818AbhKRAPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 19:15:15 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1AHLe8bS032300;
        Wed, 17 Nov 2021 16:12:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=KnMZPBr0Bl6kbYEjV7SUgZ99zbXQTuq13ENZjde3VJ4=;
 b=C2Bri6LszYoDaTNoLgYCkobpdZYsNUbPTPohlwloWpZ2LZ9IUS8RLvBUjGqYtWiL7ZJI
 kK8gt6m8IPs27MhIpspr+mbwdu2FXW4VXaZlNxIz3Zd/7dsuABtyYJddZcTFL9xGZZKM
 b/PiYo7m2KsZPk6japa/MIe06i+4vYh8X6Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3cd3ahvecf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 17 Nov 2021 16:12:15 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 17 Nov 2021 16:11:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmRSLnagGBQ5uKqaDbgdCSts0b2Lxa1ExLk9smH6s2yNjg/XO/j0414AggIlE75pBMIXyTLo64DYummmVXfRXe03dTBF77memdYBYwhum12OpN90ibU4f2/w5C0BzyYnN12qdZHPCGkK3TarQjtX+ebC3Zx9LSgg4C0Jh/c92U5qskSeGvvy+4H2TNTy/jW8ZYysaA7Ku9+SihOin2wuztOBnwlctRciIeTRPyi8k18/tw5e7T/HwogyCliVg4fnM1YUBYbyhrk6UHfKe4qsrIggkh8DgSKF8PuuovccJlatPIyCdRwtfMPi+X4xdDOLay8wixhm6Uau1VpQLVJM3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnMZPBr0Bl6kbYEjV7SUgZ99zbXQTuq13ENZjde3VJ4=;
 b=iT4IdfS855Yl1qroG0CJb4s/EnmnVvsBeVRQ8avyJzfM7BX+0bBoWDOfUNnYImXTVN3gcAzoL7umwMjnm7CX4AOGMR0bc8GwWbmVoz8WR8yts2SHZuQ+47iE4nZz34turmVfIy6jZ+ankBCr1DEpQCOIedxR0m7ZAfkUavhAqDjKxE3cnFJzU4dtSDtDRC5jG1IAReUV9d6bUsVje4ewVqad/OM9nRdoXpPy9XTYet9/lsmaymU6KSjX1r6U2ymOEOSMi8zu80bfb8ClmbvhH75Dc6Kc2PGvzW+dPkcPUJEYyXpYPKds+8oXgBnC5UQw8O/AXwpqLPxIAj9vSyxM4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5300.namprd15.prod.outlook.com (2603:10b6:806:23f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 18 Nov
 2021 00:11:49 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%4]) with mapi id 15.20.4713.021; Thu, 18 Nov 2021
 00:11:49 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Johannes Weiner <hannes@cmpxchg.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/7] set_memory: introduce
 set_memory_[ro|x]_noalias
Thread-Topic: [PATCH bpf-next 2/7] set_memory: introduce
 set_memory_[ro|x]_noalias
Thread-Index: AQHX2rsqg2QxafvOqk+EnT2R5OJ5LqwFyq6AgAJ2NACAAAcDAIAAIFIAgAAEFYA=
Date:   Thu, 18 Nov 2021 00:11:49 +0000
Message-ID: <B50E9A96-E7AD-4C33-8CDC-AAD058C32401@fb.com>
References: <20211116071347.520327-1-songliubraving@fb.com>
 <20211116071347.520327-3-songliubraving@fb.com>
 <20211116080051.GU174703@worktop.programming.kicks-ass.net>
 <768FB93A-E239-4B21-A0F1-C1206112E37E@fb.com>
 <20211117220132.GC174703@worktop.programming.kicks-ass.net>
 <73EBD706-4FEC-4976-9041-036EB3032478@fb.com>
In-Reply-To: <73EBD706-4FEC-4976-9041-036EB3032478@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 475d514c-140e-4767-ec55-08d9aa280461
x-ms-traffictypediagnostic: SA1PR15MB5300:
x-microsoft-antispam-prvs: <SA1PR15MB53003CD391FF764221D114D4B39B9@SA1PR15MB5300.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qJm29ug4XmqC7XQP6gKXPLG9+I6mPJoNprVMQUIITRmb8Lyvh//4ErEcYelg/Sx7zJ9mS2+e2SapCKQzdYsaBwMOOWeoVSBzeWKrS6zuTxVZn9hOQKUkamtUGJPUN92TDTXn/uSDLldos9QmqAfv8cHWpMBhwh5rnonWcEQfiOF+KLKr8bNJfOf5asx4Jr5+KoikS7OmbUbWD/j+giBJcGl3LD/UMS8Cs0n4EtSWsj6L0eo8VuQvG236kegRjNyGM/83dxyCFiH6RkwViRjpFl9L2NXePnIDd8SHvXPzu045/HVdFRN6vLu8nUvMY+DHdwn9WAIWW51XK4QPNu6rFNCDKaOJCn19PRW91iIdVi4Mxx2OHp9LbLwKel9VaA23WyPSzDgtp8aVhSsBqZ4S2v3t6WB+6mEDfBzhzmfv4+9WTRJSnFjo2PT/Vg55uoOYbQaBtRQPzeyJD5FohlZKCEl7u8K9pOZWDngcBv+T3e2oIdFxLDD2p0vaeMIqUzAiOR2pXiVjfew/UcIvEIfFny5xvPMVAYyzJv7uXElAfw5cgxRPOTDChaaAsSw7tVR+JKieKviFaXKxgOfGGxpD8mZ5WIQqMX0rAJlr1E4aiECXX2sgSuUWQBr4m8lKD5u2AHRrB826FjV966iW2ZxCNKizz8bU9jx2FKfXnG4z4oqqbeubLnvYAsmP6VygcBRw9kfnQ8PQWCtvy0150dSTiWqNMxTNcRlB4Zy1Jr5qlBRtSyVINCXE52fNlBwXzzgY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(83380400001)(86362001)(5660300002)(38100700002)(76116006)(4326008)(2906002)(6512007)(316002)(7416002)(66556008)(6916009)(38070700005)(91956017)(54906003)(64756008)(66446008)(71200400001)(6506007)(122000001)(66476007)(66946007)(53546011)(8676002)(8936002)(508600001)(36756003)(6486002)(186003)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XsoI8mejqjaMKue6xVF44TObmmC0a4WGMqMPM2H44ZUsFR2xS8KtFMQ4+4zt?=
 =?us-ascii?Q?9sMONgaEX9u2ZQhYHUxYoZ3gB1fYsNpSBplDuywUWdhPmT4O+gtJWL/gXVhA?=
 =?us-ascii?Q?NhLfbReO5XNne7duLugFekNQ4htomAQEwv9ixxUK4Ff9hALibA0ajG0g85cJ?=
 =?us-ascii?Q?flvjhYHu8La+DYwZlwfvDKY4kr9dZ3xHi/KoAvO0Rg88hooqHIKsa6sS6Yrz?=
 =?us-ascii?Q?S5LJomToVSKtkxD0a8XdU1KN02cp4pUzWPNXWSuHjqxw72kuNAmCf5bXArle?=
 =?us-ascii?Q?U3hGWDxy3VMA/amUKJRbseSOs7lSa1/rwekKXS5tAM7Ay6tMfHEpyc1M3fN8?=
 =?us-ascii?Q?fB1CGaUHWhGvmLi/unELNmNTQdf0IF4rQkoN645vrX4Ocs0T9edaF6woLAEO?=
 =?us-ascii?Q?D2owkB3apwoHje/JyFA/1h8cdadzAtYEOjWnJj0TTvLuv6h5JSaAmJMVKVmu?=
 =?us-ascii?Q?MEJnuM2JwF/yojH2mOl8a3yGwDVresNGcRzybh84HCuACkE8wTOd5KkTonUk?=
 =?us-ascii?Q?+xvWcchxpV7flkiPnNWlR10OmnlOLTLL9QQTSI90A5JUNtOqKok33HjnDWTX?=
 =?us-ascii?Q?tygr3NjFbEJnGddBjif/9B2XUDdHvZO6XgePwMa+2Ss3HzrqzUNaINiwxNgV?=
 =?us-ascii?Q?1fRVdjPhYKncuq+IYYh6JwRIy+fCKCHU+OZ6DDIxMT28R2MjOotiy6P/S5bE?=
 =?us-ascii?Q?jegAP4eLnmHWiHiODoq9jZCkq4ULVIFApjBVqqBuwDVs+Z93LePqoHcS220c?=
 =?us-ascii?Q?F0ZRGcFF2Sigx7jeZeQfAW6aZE2ytRolgBrh4IUhszYxaxbiFOizz9HkrP0q?=
 =?us-ascii?Q?q1vE8FDE2jR4XyYknASB7BcEThfLcGhzOVrimTZSYa1ADQwgP+lf3F1RcSCd?=
 =?us-ascii?Q?VHJM7F85MrRJ65xUdV6KVwKIQ6P2TSybkQMtf0ot8lU8Vo5MD9pBDx40K9YP?=
 =?us-ascii?Q?iSrsernaTxjEM/6oAYcNP+Xx/N18WxJ/fynY9v7ykHqs5MlZKqcjFCfNFvmZ?=
 =?us-ascii?Q?Vu4AA50oETTMYiMCqeWHGoOQUaH103pztxdVkYcs0SKqeN+py6DLDaRJykeU?=
 =?us-ascii?Q?TDBh+FNw9KJBhILH06Cg6h/8njZnv2LpUcqj+/UVyc6RwbjSBHrTyVyX0kN6?=
 =?us-ascii?Q?rGz2XJhOVsGFPKMe97cLo5uFEwbUsKjDmTLnqKsu/L+yZDAz8NqPmaAKIkcY?=
 =?us-ascii?Q?iBDcB943CdIdGf+yKJEMfUKeYNX5xbAsUcBEk2l+gTw/CF4McY2u1qZXe+2k?=
 =?us-ascii?Q?z6H3Oc7/PGW+RUt66FZALH7XbhkH7i32rVe7HcFIOsKhY8VJa6pJG2kVCOc8?=
 =?us-ascii?Q?rB/JiR7ruQ6iLWknANtYfqvtvmsJKOuM1/SUlfsSGGqSVMj1srDezafb6Dxs?=
 =?us-ascii?Q?xixCgaGeNd1Zt06iFfju36eTU7WY3Cfoi0ZupxqE+XwJ7e2aoa1kMTQyy7vN?=
 =?us-ascii?Q?2k0j+Nupeq1VDzdBnYBwMkfQfAP6Ptq/qrcYSvN1Tepy2N2Ve0GOGSmwKVAM?=
 =?us-ascii?Q?pbbHW+pQt581VpAy97wsUVAhaZKv0kQFivXn4zZ4GJd0uiwyP+iSgsH2+zMd?=
 =?us-ascii?Q?d0eHAlNf5JLijltsjRnFwCQNMTnUO+fRWLT9rE6CatnPhRi1ahOImZbWZI7S?=
 =?us-ascii?Q?F5ewCRvn03BZ6I2OoAbrEnwvKhCR3TC6XPCrwUe4iF0OvM4tzMNUaIuwCAru?=
 =?us-ascii?Q?66gbVA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA957B0A17988D4CABC68AB6A2E072A8@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 475d514c-140e-4767-ec55-08d9aa280461
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 00:11:49.7430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M9rbt2bYGUHambmUHhm6cMo3D2TF6HIxxBCt8HnlP33HZnP0Jhf77WTRZmeDqlMHlLBkT/eJogIw2LC/3m6SGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5300
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 60B_gy-m9SvG8PH-bTR5pNErZBgJDlFQ
X-Proofpoint-ORIG-GUID: 60B_gy-m9SvG8PH-bTR5pNErZBgJDlFQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-17_09,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 mlxlogscore=489
 priorityscore=1501 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111180000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 17, 2021, at 3:57 PM, Song Liu <songliubraving@fb.com> wrote:
> 
> 
> 
>> On Nov 17, 2021, at 2:01 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> 
>> On Wed, Nov 17, 2021 at 09:36:27PM +0000, Song Liu wrote:
>>> 
>>> 
>>>> On Nov 16, 2021, at 12:00 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>> 
>>>> On Mon, Nov 15, 2021 at 11:13:42PM -0800, Song Liu wrote:
>>>>> These allow setting ro/x for module_alloc() mapping, while leave the
>>>>> linear mapping rw/nx.
>>>> 
>>>> This needs a very strong rationale for *why*. How does this not
>>>> trivially circumvent W^X ?
>>> 
>>> In this case, we want to have multiple BPF programs sharing the 2MB page. 
>>> When the JIT engine is working on one program, we would rather existing
>>> BPF programs on the same page stay on RO+X mapping (the module_alloc() 
>>> address). The solution in this version is to let the JIT engine write to 
>>> the page via linear address. 
>>> 
>>> An alternative is to only use the module_alloc() address, and flip the 
>>> read-only bit (of the whole 2MB page) back and forth. However, this 
>>> requires some serialization among different JIT jobs. 
>> 
>> Neither options seem acceptible to me as they both violate W^X.
>> 
>> Please have a close look at arch/x86/kernel/alternative.c:__text_poke()
>> for how we modify active text. I think that or something very similar is
>> the only option. By having an alias in a special (user) address space
>> that is not accessible by any other CPU, only the poking CPU can expoit
>> this (temporary) hole, which is a much larger ask than any of the
>> proposed options.
> 
> I would agree that __text_poke() is a safer option. But in this case, we 
> will need the temporary hole to be 2MB in size. Also, we will probably 
> hold the temporary mapping for longer time (the whole JITing process). 
> Does this sound reasonable?

Actually, the hole is probably not always 2MB in size. But it could be up 
to 2MB in size. 

Song

