Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6768E426435
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 07:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhJHFsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 01:48:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43054 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229511AbhJHFsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 01:48:47 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1984B9W5021193;
        Thu, 7 Oct 2021 22:46:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=ByJT+NiDCbA6ZMtHB8H/mQhfHpohCLg0aBV3dIZ/tlk=;
 b=bMKbYMaSIjz45MluNQtXqDFQ6bhNWWI2P5gJrZfWPNn+8aQrD72DTLNYLb1yyO4+Lv42
 Lq4GBmk/KCAuCvlEcr7e3wiZbAQFbwXoX/3JYamTN173wRBuqS47ByhpgAwv6to84BKE
 IOHL5YEILrsisUJ+0S+gDB2dtlBIvR0z+Rg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bjeqy8hmg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Oct 2021 22:46:52 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 7 Oct 2021 22:46:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xc6tM04Zle1f89VnA8RdR0T6aX/PAAKb4dlwAeVrLsdOlkK607M9ncEpuWmYnCK1r8moug6xs1P/U5rzeyghjeMeJFeleR+fLP/GeE2HYnx8nD8o9dV7VjbejDCwKYAQ+BqFxm0AWddf+lzPmd2N9+sfKpPmge2vK2BeZiMJtbS8IpmcyZT7E7GuLTXYzGyKGORyFw0bsbY1ZOYVJ9tWFzaAEIMvGnQBL7PpTVhWmR5emm8QMp/w6EWq3Wg/4gjYuLljqUkaT6bFwts67yevT2wvnfvsse1Hu4lipPc5oqgfZZ+ptbL+YGSusEM4aJs3DcLiiqwFp/jAUZ1SHY4m8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByJT+NiDCbA6ZMtHB8H/mQhfHpohCLg0aBV3dIZ/tlk=;
 b=DGeiF4yyYKsBFzqOPHkSlq1JJtOVo59f0Bhd5f25b4wSowWY9uCBpIvaVpweqgzlpacV7jrRJOaFt17Lc2WrZFj18KajjUOy1LYvhLGi8R2OmTkOw+ZnETdRV6W1Ufuw/TAsGprgoPdPHglnCuqY9vpRrfCrSqPyTNJSCy4B90gA0nZ5/QF0/qyvAJrZZdB867uCAYt1eA+iBh9C+K+qzyfnjx8p/VA0VVzRuzd7CMKxYBiQF4MLEhwpfGStR6zBXQHORrT8uXjTSKq4KYneeflG5qTNvS7CUnlvpTAjC0WDTvaxTk8dV5OlvieQKN/PF72WsXWQZ5P210qhgbtYVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5064.namprd15.prod.outlook.com (2603:10b6:806:1df::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 05:46:49 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%8]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 05:46:49 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Like Xu <like.xu.linux@gmail.com>
CC:     Peter Zijlstra <peterz@infradead.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "like.xu@linux.intel.com" <like.xu@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Liang, Kan" <kan.liang@intel.com>
Subject: Re: bpf_get_branch_snapshot on qemu-kvm
Thread-Topic: bpf_get_branch_snapshot on qemu-kvm
Thread-Index: AQHXtMWNyKWclBi4s0iJww6HNTXDJ6u6n6yAgABLWQCAAAXKgIAAJheAgAAVeoCAAAoigIAAOogAgA0QG4CAACUTgA==
Date:   Fri, 8 Oct 2021 05:46:49 +0000
Message-ID: <7B80A399-1F96-4375-A306-A4142B44FFBF@fb.com>
References: <0E5E6FCA-23ED-4CAA-ADEA-967430C62F6F@fb.com>
 <YVQXT5piFYa/SEY/@hirez.programming.kicks-ass.net>
 <d75f6a9a-dbb3-c725-c001-ec9bdd55173f@gmail.com>
 <YVRbX6vBgz+wYzZK@hirez.programming.kicks-ass.net>
 <C6DF009D-161A-4B17-88AE-3982DD6F22A2@fb.com>
 <YVSNV/1tFRGWIa6c@hirez.programming.kicks-ass.net>
 <SJ0PR11MB4814BBE6651FB9F8F05868FBE8A99@SJ0PR11MB4814.namprd11.prod.outlook.com>
 <0676194C-3ADF-4FF9-8655-2B15D54E72BE@fb.com>
 <ee2a1209-8572-a147-fdac-1a3d83862022@gmail.com>
In-Reply-To: <ee2a1209-8572-a147-fdac-1a3d83862022@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba7600c8-14ff-4602-cb90-08d98a1f05ae
x-ms-traffictypediagnostic: SA1PR15MB5064:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA1PR15MB506452DF8247DE6CF0FEF541B3B29@SA1PR15MB5064.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mdL0G9WNVMIcMSd6pyja8NdgaLZm3gEC/VV8JB11cWsLoDBw0KiOUhik9rc9sGaOFFI0zHaYi4Z2Hr9RyIz0FZJhPA3SQpb5fgvQeNQif1OS/NWUDtcdEO8So+mzop3v7fqIs8yLvf2FH96EWEGz04dBR6oBphge1r8sG+YlJ5ShxppxpiQnYMTLmiN8O1Hpa/VKmBhORkJ6QcyU1eLNDFg87+fNcSd/7fTebaHSONn1XESaEF/2FssYgPAahOXTsekAYdfwvOb5zt4ACqwgKdTCCDpMN5YNT86/7XATiHsc6aWgQ7bwY23XwmBym0XHSjtXJ2zUz1wPcyZYgR9kuYIccUJQxm4bnO2dR6aJQ0mQVnh4J5G4p5tWcKRvOzFsNuN5LQwfOiKTlHBxG9DmFpDGYShyet+7GCv39fH7HAqXZ5AYqBLPush70Nm8Gpt6LG3QDwWCO5Pb7yNxM9s1Qt7d2Fa952xvwxV2yv2fU53GuiDhpf0KS6u39Ivtpm4uN6PD+nDxNsFZX/R8rpRCW7hIIzn1oiFyCfmog5ltxtTo2yDiYpHNOe7T4NPWdLZEE+V8O54xKho5cQkmS9V9GpTd7Gw/oWN0yynspLX2tWnEQR+AZkj8Ux9jD2WH1rO6vc1EIHYSbL/PCJYnrKaW9bMCVTk105995e+JtN4tJqEtLyzujbCJe7ivCYYJPb55i228CX6qijRbYo+6muipAUavxnudhU2w+k/Aipu+KHE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(6486002)(508600001)(5660300002)(71200400001)(316002)(8936002)(38100700002)(38070700005)(6512007)(2616005)(8676002)(122000001)(6916009)(186003)(4326008)(36756003)(86362001)(33656002)(91956017)(76116006)(66946007)(66476007)(2906002)(66446008)(64756008)(83380400001)(66556008)(53546011)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jFRU9w32LAPGCGOaYhga/vsR3xRnwP4j9b3VUC7bpHvHomviPBwvNf/an9pC?=
 =?us-ascii?Q?bsdydKrMzCaYireFUgFMS4m2LhZJg79g4s37jFaQRyk4jQZcc1yb1IPywLxX?=
 =?us-ascii?Q?Hp+xXwZ4qnXX3RqMSI2okSYsLZIaLtQ0WJc2jVotK4idvQyGGO2DatR2GKcx?=
 =?us-ascii?Q?Qm1rseCduZ9drCJGNO9RLxnyP1N86ptpUKu0ZBZlPijG3UtvqHdwlh63ELRG?=
 =?us-ascii?Q?E/b2YvZrpGuvNro+ssCDlg+ANi2rMvG9QPWuM7NR+NBS0T+enJl3clDPJpjl?=
 =?us-ascii?Q?+ykUunAkE9xG7SXUUoBGsTU4sNlj84bWsv2f2ToHbpXUEJz8d74wEF3gKIyg?=
 =?us-ascii?Q?FHqLlGZQ9Du2fWySAOJ9p3zL0TYUB27yXvQmOn3A+HmejWliHkdIMxFUPoXU?=
 =?us-ascii?Q?i0QY5XT/K2HAqJfq9f0VO4E8S1H0TZfH8Ju6k27Q9MYH9A5KDeBqGHoN1FAI?=
 =?us-ascii?Q?FpAh6gaFK8ouAq1vGoCB1NoMlrP20N+mk/MAvGqZ6xOm+cZy/gs8QY+LVvVv?=
 =?us-ascii?Q?biKo64tNR/ksyQF1N3Sxvzvo62tlEgINqWvl9+ymEYVDXAcfsBmWsib/qmgH?=
 =?us-ascii?Q?wZNS+uBdDMqsVNykT1/lTBmuEvaFKDpCqXJwiB1FIJcuELDQxXfalLwAQGq3?=
 =?us-ascii?Q?5k62AthL3QyAJ1KfhjjY3Kp1+0FhoiPCQNxE7hwBzhF81TFJmPcB1MHxrT3+?=
 =?us-ascii?Q?5B806Umg1pW4U0uvpDABH2nL8sYBOm0Intxye52fpJ8U/whmmwtKX+Ht1igF?=
 =?us-ascii?Q?eOkAGy9OSz/ePwyatYV0KyMbMMMbTPMHVQq2AUHXjEYCKVC2N8etZAYlVi2w?=
 =?us-ascii?Q?UDMcbePrw45qLTWZKSqN6yhz2RHLhL8vLa9P+BI3ZZVKYR6QI7z0V0xp7hFT?=
 =?us-ascii?Q?OCdJ1PmQr/sPAKpcXrb2rEau3VhtN4Upy4fEO+gjwIjg/gR/lzV92RLU2qIZ?=
 =?us-ascii?Q?muiMv0Ge9QVa1YkY+As208mVlKtZ0+fKj5vbRBnMa+MDkmQYX7zUYWGCYFNW?=
 =?us-ascii?Q?dkj6TZGWuh8sAFe6Y01hltppsoSlf1CBv1PgOJqJSNSD4YX2i5vuohhGlKSl?=
 =?us-ascii?Q?8qftIoqvSrl2dGUl33p7C27cpoq2LuxPt8GAUDZ5w9wo3SvcGhvSyE9kzyPC?=
 =?us-ascii?Q?5Rc63gb9biW0HC4zsi2pLiy7DolIRxue/u5a8wkcAggf92zKmOYJWOz3Irwj?=
 =?us-ascii?Q?yRsBoNefQCriQ9/rmdN0ps1WL2sJTujU14Fyk/WrJFFvdn0uxyBebD99vW5W?=
 =?us-ascii?Q?4eAE1ta7gjQV4eVsjrDYs8h1FUnX4ZfjLZD8+bgY4NreESselLbe9o5K9JBf?=
 =?us-ascii?Q?UQY6KzDMB21rvLd5psipWVKMj6L2wXY0XbxF0+5dCspWsS+db4Y8Y0qoWSaG?=
 =?us-ascii?Q?7GS9aig=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AFA5858E235D064885D0B24CDEC10D0A@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7600c8-14ff-4602-cb90-08d98a1f05ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2021 05:46:49.1585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2LLn/rKD774LbQ68THFc0Mjb6E0N9N4whGeVfKzVBFiR37RJZaKdzaAUzWO6VnviFKtQ1yylNMoGh3Y2yKzPRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5064
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Vib2TIIVHlErNX9DSJQMX-sSKmNTObLz
X-Proofpoint-ORIG-GUID: Vib2TIIVHlErNX9DSJQMX-sSKmNTObLz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-07_05,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 spamscore=0 mlxlogscore=866 adultscore=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 impostorscore=0 mlxscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 7, 2021, at 8:34 PM, Like Xu <like.xu.linux@gmail.com> wrote:
> 
> On 30/9/2021 4:05 am, Song Liu wrote:
>> Hi Kan,
>>> On Sep 29, 2021, at 9:35 AM, Liang, Kan <kan.liang@intel.com> wrote:
>>> 
>>>>>> - get confirmation that clearing GLOBAL_CTRL is suffient to supress
>>>>>>  PEBS, in which case we can simply remove the PEBS_ENABLE clear.
>>>>> 
>>>>> How should we confirm this? Can we run some tests for this? Or do we
>>>>> need hardware experts' input for this?
>>>> 
>>>> I'll put it on the list to ask the hardware people when I talk to them next. But
>>>> maybe Kan or Andi know without asking.
>>> 
>>> If the GLOBAL_CTRL is explicitly disabled, the counters do not count anymore.
>>> It doesn't matter if PEBS is enabled or not.
>>> 
>>> See 6c1c07b33eb0 ("perf/x86/intel: Avoid unnecessary PEBS_ENABLE MSR
>>> access in PMI "). We optimized the PMU handler base on it.
>> Thanks for these information!
>> IIUC, all we need is the following on top of bpf-next/master:
>> diff --git i/arch/x86/events/intel/core.c w/arch/x86/events/intel/core.c
>> index 1248fc1937f82..d0d357e7d6f21 100644
>> --- i/arch/x86/events/intel/core.c
>> +++ w/arch/x86/events/intel/core.c
>> @@ -2209,7 +2209,6 @@ intel_pmu_snapshot_branch_stack(struct perf_branch_entry *entries, unsigned int
>>         /* must not have branches... */
>>         local_irq_save(flags);
>>         __intel_pmu_disable_all(false); /* we don't care about BTS */
> 
> If the value passed in is true, does it affect your use case?
> 
>> -       __intel_pmu_pebs_disable_all();
> 
> In that case, we can reuse "static __always_inline void intel_pmu_disable_all(void)"
> regardless of whether PEBS is supported or enabled inside the guest and the host ?
> 
>>         __intel_pmu_lbr_disable();
> 
> How about using intel_pmu_lbr_disable_all() to cover Arch LBR?

We are using LBR without PMI, so there isn't any hardware mechanism to 
stop the LBR, we have to stop it in software. There is always a delay
between the event triggers and the LBR is stopped. In this window, 
the LBR is still running and old entries are being replaced by new entries. 
We actually need the old entries before the triggering event, so the key
design goal here is to minimize the number of branch instructions between
the event triggers and the LBR is stopped. 

Here, both __intel_pmu_disable_all(false) and __intel_pmu_lbr_disable()
are used to optimize for this goal: the fewer branch instructions the 
better. 

After removing __intel_pmu_pebs_disable_all() from 
intel_pmu_snapshot_branch_stack(), we found quite a few LBR entries in 
extable related code. With these entries, snapshot branch stack is not 
really useful in the VM, because all the interesting entries are flushed
by these. I am not sure how to further optimize these. Do you have some
suggestions on this? 

Thanks,
Song
