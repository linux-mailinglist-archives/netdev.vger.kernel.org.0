Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D897456293
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhKRSmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:42:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31306 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229554AbhKRSmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:42:54 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1AIHEdcY014616;
        Thu, 18 Nov 2021 10:39:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=hbO9YNGrK9CT+YVOIM3darqVrJP4d8wpYPG1e7Y1sOg=;
 b=FK/A+GR5AFGtsA9O7PHyMvFEpOeTnFkq8fut8nbrEg4EWHJ6ucMt563vsL4g53QLWjaq
 Bid54i/FHZuMD/im8vKUdx46JibzDJK4Do+XbdwfvLPHmaXshKudvxLs7OWZ3l5SKfI8
 OichgeTN8GybM8Q4kp71w+AiKdk4zRAN91s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3cdj39ck7u-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Nov 2021 10:39:52 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 18 Nov 2021 10:39:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UkZXaeJYI/CpRFvNPeeR/CSXAmxE3zShy4UOTIuws1anJJ0aO8oR9GacqpK06zkgOgoKonMOIFoBzu+jWtWhHgALPRFdogPRhIgh7WLqqHeq+HG58IkJtCV405GJk7H1aaVmigaQfJ7YtPMuSsOO+OP3W1htfn83YTiGloN2l9MQc02+9uGNfWfMgeFSchCVkymrDQQYUDyHIMf4J4f3E+7pbH16eXIIzHEW4kGsuKA/mmMqqFsUSG+Qp6hL0i4rO2T751ALAaUjO+tcdQ3hEI2y2ShzcXOaiFwObvsa/f4Kl57zzTxIheLGQAK1tZZ82igQ/dT6k5TaA6jqJRACqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbO9YNGrK9CT+YVOIM3darqVrJP4d8wpYPG1e7Y1sOg=;
 b=oaFt6iH64ltsgTmx+we1sBz1D1pLJjTbtzJSYb0imwkG6/eJaNO0c+BJqvmUmrVDC6+/yLX0/5fUCUfFe3cl+pLaudhNfIl6KsREeT0hj8EcBy4LpZvlWGS8YG+InKeIJHUb1G5rvwgkmLBI+MwxAcMZx4Dus+sn7/f88FUrLCbTP3cTNZS5oIGM90blDEKbT0zr7yEaX+6aB7sg0+qmZdx2o1rKLu2tJOXbol4nJjeODAozkWX9mMihWls3DuLG4hs8X4+E1JVJu13OR+RXOmj7zkEi8IlIaRI+YkKXCx2TGo+cjlEkPH9KxSIpChAHXX36BVKAn4PQeChpsY3Elw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5139.namprd15.prod.outlook.com (2603:10b6:806:233::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 18 Nov
 2021 18:39:49 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%4]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 18:39:49 +0000
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
Thread-Index: AQHX2rsqg2QxafvOqk+EnT2R5OJ5LqwFyq6AgAJ2NACAAAcDAIAAIFIAgACFb4CAAJzpgIAAFDQAgAADGgA=
Date:   Thu, 18 Nov 2021 18:39:49 +0000
Message-ID: <510E6FAA-0485-4786-87AA-DF2CEE0C4903@fb.com>
References: <20211116071347.520327-1-songliubraving@fb.com>
 <20211116071347.520327-3-songliubraving@fb.com>
 <20211116080051.GU174703@worktop.programming.kicks-ass.net>
 <768FB93A-E239-4B21-A0F1-C1206112E37E@fb.com>
 <20211117220132.GC174703@worktop.programming.kicks-ass.net>
 <73EBD706-4FEC-4976-9041-036EB3032478@fb.com>
 <20211118075447.GG174703@worktop.programming.kicks-ass.net>
 <9DB9C25B-735F-4310-B937-56124DB59CDF@fb.com>
 <20211118182842.GJ174703@worktop.programming.kicks-ass.net>
In-Reply-To: <20211118182842.GJ174703@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31b3b1cc-c4ef-4c71-174d-08d9aac2cd8d
x-ms-traffictypediagnostic: SA1PR15MB5139:
x-microsoft-antispam-prvs: <SA1PR15MB51398133B1B65BF411B1E101B39B9@SA1PR15MB5139.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ZHpnrtTfJgDGk9WReIKHta1HdMBvTRpWNdCZCkYeSgjv9NeAy+3VXK2Ew2ZcwbO+bhNEEMIiNmapqGAFNdKbIKW1K+57+dgPlz+S0whH11+M19p6CuwUdm4NJKbOOUgdyu/RVIKLVTWla2cieUCXyn8uQkWX0k4R5MEP9QbI2wfLbOYJUpkImhJB5iLcAiLA8DjbGqiZXLCbHUP8LBYnK+OEgTwKZMG+yvVuALv6uFPVe84nybbg6wozTvfC3uoOC8J+9qpnf2yj7Q8qKtMAQ7LNPlwn7O4GBBYoKIsghUEEdQB2l8WI19aQC0mLlcfZomqF6Rn3G1JO1WkqS28ASk4dVFCXcn2urSFvnq8T4L64Gs0MP0GOnCIx9y0Hl47EANkqmQb7CmaU9LQgJ6iQ7F+1LEmdCLjpAis1XnjVaRZAo3M7cWea9kCSUKETrpRpBktVbIriGdakeVSNmaDrCMPugZMIuqkhn0UUmBMm4pY2V79VHJVRDghGakhny71KEiH3hhjOgvszHyigP7OPj+mutXwnps+tVjT9bxW62cV2J0YpF6igooBgt+pUecipLoQYqteQ2l0GZO3zpl4tWK3LSk673gHPbjLv9Lv6H4C1r9n2JC2lMj5k4mn2vB+YKXSPE/9KKK5kHhafZo1WVO25FWt7/4HEnbfdyaFE3ajkY/O6T3J9McZYD9Pfw5UNgD3tssgQBQSqKzkP5u0Pgxdu5HG928G8J+xREF9ZKhgQJsFAGSF7YG6aUip59kk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66556008)(6506007)(53546011)(66446008)(38100700002)(8676002)(71200400001)(6916009)(36756003)(64756008)(33656002)(186003)(2616005)(54906003)(6486002)(316002)(91956017)(8936002)(76116006)(83380400001)(66946007)(6512007)(508600001)(2906002)(122000001)(7416002)(38070700005)(5660300002)(86362001)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?V98seOhTmfHiQNfLX1xRyiZUdIma7tSO5zFUXLHmC0GqRtKpVm5IeBPcKYw1?=
 =?us-ascii?Q?AOAyPxcA5AYqNfT/adjaOQ0fRDCspKg6B3FCuSmMtlv+GzpEYFOkkAmqxVD3?=
 =?us-ascii?Q?iJcf24jhsN1Vj0xaYZc7G5OwutdnRwOqQVs0GlesWO8X8zPupZn6otBG5oQC?=
 =?us-ascii?Q?uoiZ17MZW2/rL0tOTOjfw/VHlszua+ETBDCqg4ODeig7pbG7MHQPvVyzm2vo?=
 =?us-ascii?Q?ejAkkJJ5bz8VlHWqTerlZ78OMO22OAQJwskGGY2iecrh84Z/XVTwp5gpngnq?=
 =?us-ascii?Q?lr4RC/ma0g2ExkCw92AaTx7OLEgh7FFkhRTMuKPuNOAFwoqVuPJhm/SWNQS4?=
 =?us-ascii?Q?OdO475/6OQs/QfpBoQRfrqjiKbh9eQq7f63hi6C2eToL8+rzcr+thHwKZb/H?=
 =?us-ascii?Q?/Cfk7787tFFqbuXJnoDe4a2bWcEgGuTppEjm9+mZA7nuZFjszo4akIuOQbld?=
 =?us-ascii?Q?f0jjl2YFSJHlPXfcTj6SbFiwLW0fLcX3sZU8+cvYCT76Dc4K6KtfIAwe5tgo?=
 =?us-ascii?Q?Iox5zv7mpFNo/3Na4uiHo1IuE9zuu3O55/pWrUipuGlrhkhKBc3E6DdIG4OR?=
 =?us-ascii?Q?DAzoGQNrTOA3xQ/zo2faauzrVB1LbjctXgu60FMN4S++K9b1tIRKUj4iRdXi?=
 =?us-ascii?Q?x7+pi/acc5EUCwkmpG+PmBHpMpPasjBWj6+BjZgH5LSKMtCkiRQLJCsMJHEH?=
 =?us-ascii?Q?c9DItMXRQym5wJn8tVl/QFWLHz13Zvxkfg95JkbaWEmn8Ui8cSb44Mc5izUA?=
 =?us-ascii?Q?1vvG1Sz+lKpTujRlHsBQKSvnshFTL/aaSeHHMPXqtoFXtxrZ3jIRQCtDH+i1?=
 =?us-ascii?Q?qYL5f4GE8osZsgmR+bt3hJcFPhL3ud4lVkywhQ29wfcgy2HJYglHfGoiHsT9?=
 =?us-ascii?Q?FIgkckFQj1RxQdaBFcqysakzcOwqK2xl0YFOzDUnjiieFP8SiGabg0wBst9/?=
 =?us-ascii?Q?j92iL212s0Jub3u4FvpkFwHwPdQm/b0yfhCu1hr+Hna9VsP8KcuaV/K2oB6Y?=
 =?us-ascii?Q?vrZ33815yXITmqi7r2vTXMG/EDEzo2XFBEGrzieZoN2qM7hfy6+N9OtDOsFo?=
 =?us-ascii?Q?r/mjyXRi9iYPPIzXPOtJBw/oJlkuAHj9Zf0RgP8bNxS9P9MWdx7FkF4vq86c?=
 =?us-ascii?Q?w40VlTDiRpreWjW0vWjkdaycJzhS1xQpx3DZH4ZkBUStZvMhEY6tPY+xhOy2?=
 =?us-ascii?Q?0GzeqIF444T6uJS7OQqycCj/Z66tDCirRZxPc6UL4fmXrZhviC6QUamePu5e?=
 =?us-ascii?Q?1xepidCkUAuoDbiCLDyLVr9ZXrGVnIjgNqymIT/QTguISJcM/G+mD/PL/jTO?=
 =?us-ascii?Q?GOmzU5TV/uqJc9j0QSWoxOo4DhTxs76zWTvfCIYi7bvbobWDukBjuMQ3dwkc?=
 =?us-ascii?Q?aeeKCeOZTigZAMbi58qrDo3+2bUmbKyUC9R7EwlW3ITN27IeaYp0kzpSgfEJ?=
 =?us-ascii?Q?4unyXoltHD8giTjx5NKPM0qXBOEc7hReSc7X0a/Xw50+5zE/YIBYrcRsHNe6?=
 =?us-ascii?Q?VEUTslnuQ76u0bvnGw8NAM1TA1lVKaJ8AcQ6IBiD2UKW13vugueVMV2N0qhy?=
 =?us-ascii?Q?iRkt7jj7uHCgcko34w7AJKptg7Trw0mvXuzk7zYrc74j8QFZWc/1U3UnHX0H?=
 =?us-ascii?Q?6aWTITJlfVHnQlwU0r0A3R4tH7hhsQ6s/r5tLxRQK1gHAIF6f15OU8+8fXvW?=
 =?us-ascii?Q?bz6BGg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7F7ACCAD233EA9499354FC1B82C565DA@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b3b1cc-c4ef-4c71-174d-08d9aac2cd8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 18:39:49.7772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 52OzgY+0yhg2RfqmZHLFCpdhQIviu3vlIPVPO0w2OFduXLjBB6V3jgAvGgEcpeRZgyvC/aQxcSKyX5lajcTlcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5139
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: azxrF7bKgrv9tuP_yvyRJy02bGuItrvQ
X-Proofpoint-ORIG-GUID: azxrF7bKgrv9tuP_yvyRJy02bGuItrvQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=918 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111180098
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 18, 2021, at 10:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
> On Thu, Nov 18, 2021 at 05:16:24PM +0000, Song Liu wrote:
>> 
>> 
>>> On Nov 17, 2021, at 11:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> 
>>> On Wed, Nov 17, 2021 at 11:57:12PM +0000, Song Liu wrote:
>>> 
>>>> I would agree that __text_poke() is a safer option. But in this case, we 
>>>> will need the temporary hole to be 2MB in size. Also, we will probably 
>>>> hold the temporary mapping for longer time (the whole JITing process). 
>>>> Does this sound reasonable?
>>> 
>>> No :-)
>>> 
>>> Jit to a buffer, then copy the buffer into the 2M page using 4k aliases.
>>> IIRC each program is still smaller than a single page, right? So at no
>>> point do you need more than 2 pages mapped anyway.
>> 
>> JITing to a separate buffer adds complexity to the JIT process, as we 
>> need to redo some offsets before the copy to match the final location of 
>> the program. I don't have much experience with the JIT engine, so I am
>> not very sure how much work it gonna be. 
> 
> You're going to have to do that anyway if you're going to write to the
> directmap while executing from the alias.

Not really. If you look at current version 7/7, the logic is mostly 
straightforward. We just make all the writes to the directmap, while 
calculate offset from the alias. 

> 
>> The BPF program could have up to 1000000 (BPF_COMPLEXITY_LIMIT_INSNS)
>> instructions (BPF instructions). So it could easily go beyond a few 
>> pages. Mapping the 2MB page all together should make the logic simpler. 
> 
> Then copy it in smaller chunks I suppose.

How fast/slow is the __text_poke routine? I guess we cannot do it thousands
of times per BPF program (in chunks of a few bytes)? 

Thanks,
Song
