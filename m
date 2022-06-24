Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0314D55A417
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 00:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiFXWAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 18:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiFXWAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 18:00:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C3687D54;
        Fri, 24 Jun 2022 15:00:11 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OLaEdN018173;
        Fri, 24 Jun 2022 15:00:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=D864oJ+WKioD/cRG6TiVPTQvcU/Us3U55VYaHe1JU30=;
 b=q/m/n0vCH9jV/c9Os1faSq0D4/KMbDiQ8iulMrvOkjyUNAy8URd322Go7qz3fwQI0pza
 u9LxTifXveGvOfmYY4m+ar94/wMZ27aGdQDkoVrLTN9FBONOiUUYhdr66FJQGu9W6rOm
 q8odOnAxjzGcZlyWGQLrLkPxxTYMA9BADD8= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gvvmjgfqe-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jun 2022 15:00:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7+PSxvO3D33DAtIA09OQJJBd1EPm7DXUjaknF5CvBlD9xN8AHehhQmOjEGfYaCbOk65H1ZaK2iVxKYm1ft8av/ElfGURi7JrHTLOtj9YxflPGWETceMdo+OFWXtA3WampBlu2ZdyoQ6wwCHvYPwL0BcH+0HrdwLTvFJMaDm2AA255JNq1Pu9XUmDL7s41Zt8TKTzM7y9hsh6Xj56M3eNXjICRZp3lfIXhEeESBzBN8FZMUgwic8SAT/VCkGIIK4YrmnW8YmWFwyaMgG+F0G/CE12QJ60jDJ/NDAKK/3rMYxjySySweGXsqYHaETYSP4bdhYl0eZVmU9XUBAcPh23g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D864oJ+WKioD/cRG6TiVPTQvcU/Us3U55VYaHe1JU30=;
 b=dFTUlE0STVW4KFjkqiQ8exoLexC2lrmH+pkgsylcpS4umwOhd68MmqueXQgypBtJrOJXxX+WnWbkDIFOPH4uC80N+ZzQHYVRSV2Ad1xNE1VumSTxwjwZJ3Zij04KFEZLc+sXkW9gylxq+O8k/dez6CGnCZC00SII0DIRKI8RBjpYBDtdznkSv58UEGo8tgrSGrdlD5bTT0d7Yt2A19Mfh2k8HXoqW0PMwwzXgqxXsk67yzt9lY2mEv0VsHZDomusJWXau2pYQMmrk2fixbWmtLK1iMrEEmaXkE+uow4C2BsgIDDjaK5tx4v+eNwCpJE80FIXlTGnXH9eYPz9GF8bLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB4463.namprd15.prod.outlook.com (2603:10b6:510:84::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Fri, 24 Jun
 2022 22:00:08 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::b9ad:f353:17ee:7be3]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::b9ad:f353:17ee:7be3%6]) with mapi id 15.20.5353.022; Fri, 24 Jun 2022
 22:00:08 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Song Liu <song@kernel.org>
CC:     lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Kernel Team <Kernel-team@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v5 bpf-next 0/5] bpf_prog_pack followup
Thread-Topic: [PATCH v5 bpf-next 0/5] bpf_prog_pack followup
Thread-Index: AQHYiBVqRcsv4pKMTEywFT4m+5cI7q1fG14A
Date:   Fri, 24 Jun 2022 22:00:08 +0000
Message-ID: <93DA8BBD-0599-4384-B73E-FAC1DC047D10@fb.com>
References: <20220624215712.3050672-1-song@kernel.org>
In-Reply-To: <20220624215712.3050672-1-song@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 639493c5-b905-4287-a982-08da562ce74a
x-ms-traffictypediagnostic: PH0PR15MB4463:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ORNpHNZRkflmprNGq3MXWeDVKCIC/TUvfQEAJdkpHA8SA25a/6siy2puXc9PbZr8hIH0wJVopHZReb+mzt7BBNevkw66NOe9MUjhAFhNCGg25qj3/Ki9+4Vel2fWH2YjjgDMdndSRSOjw/G4YGcrxJ3o7PLedYB1QvFEaOYlUpA1xyQ3e9xNbD+D0cZlewatjPHCCX0QMbRmaGHugTw3fMO2iLJ3LaaKbU2LyGwwBc4r/xJ31G/9biLOyiF8tf7nQRXzHfyqpRtglNYOLinKJmH2QmJ7NnArdmx6XtRLK/msPKikY1OWTkwVRxzhAoPsWiDzUyWPOsdWGnqXVvl2POlE44Sm9yN1l8DJSbB98uFr5y7prYUXudubWxK0o/ERTRQUoJp0RvfcDOx1DISoiFMBj+kBF8WDVEX3ghD9mYICV8oo+5JohQuZGINVEXDuP7S8QLSPQUKjx7muIhMfMluo0cvT5mZRjk6L2MBgPnFM0jLsSDVSfiaY4FFLIWrq/PLUlTxpkiv7EjFTrsorXZaVoWFEjr1VesU6kn7lIz+6WMRfymO5YY4EY8SsvEJgoVDluGeKFL8fpflJOwS0zeeRljvwfab4yvUnmSg9zmP6nHfK5ZjYvVlVFnEuS5rdxS8serKfPWfioW+787SsemZCa7Gd1e0pJcNhl8tINicTehPpv7HrgyWgbfG92pDbz5DhWwEGi9uSE2GnphiD2HqIC2XCEmPKkQ/Rqz7h0B9ystOuy9C3vGE9//gc8k0NTfv0nFH1R+uNCGr/WBiqeu8iExzVs8dUeLqnuhgiBM8QufQdITT/+NKqGyY3lnQoQHrLDYg7lvHiJxOQLZVtwWB1JkP9/uJXaauItTiVW/M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(86362001)(53546011)(6916009)(6506007)(122000001)(38100700002)(6512007)(83380400001)(2616005)(41300700001)(186003)(64756008)(38070700005)(66476007)(5660300002)(2906002)(66556008)(4326008)(76116006)(36756003)(66946007)(66446008)(91956017)(8936002)(316002)(33656002)(71200400001)(6486002)(966005)(478600001)(8676002)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Zv18MIyzzGNqvALRK3xzGnBk/sSbyAoDa8YkCcyvSqTB+e9A1fMHd7r7vYZp?=
 =?us-ascii?Q?A7LU8qsRAfcWSvuEUsAYx3t1cLeRX7Gb5ICyZvD0nXczazNWejf31vFKyO41?=
 =?us-ascii?Q?Makpmz7FQ3h5gjRUqiHLWZ7ELvltdYmnB9/sH/kpYL6vKP/G7g8tyjGOth1d?=
 =?us-ascii?Q?Gw0gZ/jkyrFOMTlbueRhDe1/B0d2ULKbDa5aX3ld/If6WRZ1LdxUVuvZKPf6?=
 =?us-ascii?Q?JhSdECw0OHJGkXFinANayFqQvNESlfnufbEmb5JIG3lhVT+fx6tarZ7QKimR?=
 =?us-ascii?Q?l5dRbGMqFXDgpP8t4/9ruasex76TNovjBLWO2cvgIRocJlfKlUvnMMAUeSme?=
 =?us-ascii?Q?0SARWNBXDcS/usVA/NG4xcV/85cBEhjxzd0w+a5rkHNFu+Sd2dpFLN0sb3/C?=
 =?us-ascii?Q?4ZVk7vDwwRuEejVcEUsMf1GMoDmBWC5g4kEV3BJFFNq4AqNr5tavYVWMcHlV?=
 =?us-ascii?Q?XC8qWVbvEOZelUg2K4LAzzeRZIUjo9SIhWDSn7taMy/JIdKQtN5xVxB8aL7V?=
 =?us-ascii?Q?fo6I+W6Vt5Am3Um4dEw0vSx3+CajWfSzg4UJypAYUmzaZax1L0Ma/EAbelst?=
 =?us-ascii?Q?nLrPB8UEs6nb11BTywMh09WjiNcueOpxe14lCKPGHuM8RZFtc2zcY+E50H+5?=
 =?us-ascii?Q?GvEpVtCaHMiJrTsXtHRH6BpYlppm7eEy2Q5ER+/0KGiuAbULsJlzaUGUq4Vs?=
 =?us-ascii?Q?vQFv2gECx1nSQojZPfYcDtjqtWuTEDo0609zJPo594ef5Z/fYldhtq0oISS9?=
 =?us-ascii?Q?WnmT+ne2Tt2+YzsUYg8LTwGa8Xtq3u5EWi45ccsb1+NeAc2Btquy/qHdOEvz?=
 =?us-ascii?Q?jD8s468nX2K1nKm6GiQcFjT4v/C71NPCTwH7+9xyS3fm8UJHZ4LtgO3UHbq+?=
 =?us-ascii?Q?1v7ae07zRfJ1Wt9PCHH0JcHrSodc9jqxEpo4iTlV9ULedsr5OTXHfYx/COM2?=
 =?us-ascii?Q?uE7XOdj4ikssGDn80de6mFTv8G6k+bcvpivUDuVCjluB2l5xBHIJ/sQFVOVG?=
 =?us-ascii?Q?32mxUGL/oEXxUN/ZkPhm6tNJZoUjZOmsrshr/+FDecJPFExzx/8EJw32CQmC?=
 =?us-ascii?Q?4BI/e/z1YbTxsywb8XfAxXMJKFL+aW0kWYwaED1ShzyLOAHGqbxXd5RobQAl?=
 =?us-ascii?Q?hpMSVyPeyYZhHiQHEJWHFZVIwrDIVBxUpm65uh2j0f9C6jvUcVK50hALtM/s?=
 =?us-ascii?Q?9aT6U6jds7clb7rGQW8ScNPC9+BQkNjowqWrGiR4tJ9l5T0LgmkDCexd+8mH?=
 =?us-ascii?Q?tmGYcdPNg5ky65k9Qi5gQnZxYBnIQAop3Pss2dFkNk7n0UsFTL6m9NDE+C7S?=
 =?us-ascii?Q?ma6DTBIWEF1D1WkNV1oYnXrNBalT2CSTrwB12JMOKc1Q+8omXO/uciqizJ99?=
 =?us-ascii?Q?U5mRbHmluqu8rBOGEIBsg/shPSneNixtFAYmtfBOOMjkXHL7t3qfd+StzTtc?=
 =?us-ascii?Q?GBILh6wcZfZjFxF1yAixUK5KOi85nMCC6GYsIiQE8nghOrGYMn32lYaDTnEr?=
 =?us-ascii?Q?3y4l1RTfSOkopOC1TkGGbt81hNnOkHrWJ8OB4T7nH/410BR4BIHLTpVFZ50i?=
 =?us-ascii?Q?xtNI/aWu6MCDelBt3VKhMnvXGTX2NjgUMMJpg8TEC63UUkxIXz+vX+pbhBce?=
 =?us-ascii?Q?RLe40F0IcuX/I61XJlouL+g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <254BB741E519864DA0C548B2C109234A@namprd15.prod.outlook.com>
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 639493c5-b905-4287-a982-08da562ce74a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2022 22:00:08.5013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZlfz6NNWEViUj1rIU0mOHF4sm8UEVfqD9aZHaWrqDkQ+vBNRu7mXZTks64NMzyP+DOUPBnEXSafvjYOcdoU4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4463
X-Proofpoint-ORIG-GUID: 9u8h3DC0Q1cSCvyHRq4NhUngyZAV940o
X-Proofpoint-GUID: 9u8h3DC0Q1cSCvyHRq4NhUngyZAV940o
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-24_09,2022-06-24_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

oops, wrong address for x86@. 

CC x86@kernel.org

> On Jun 24, 2022, at 2:57 PM, Song Liu <song@kernel.org> wrote:
> 
> This set is the second half of v4 [1].
> 
> Changes v4 => v5:
> 1. Rebase and resolve conflicts due to module.c split.
> 2. Update experiment results (below).
> 
> For our web service production benchmark, bpf_prog_pack on 4kB pages
> gives 0.5% to 0.7% more throughput than not using bpf_prog_pack.
> bpf_prog_pack on 2MB pages 0.6% to 0.9% more throughput than not using
> bpf_prog_pack. Note that 0.5% is a huge improvement for our fleet. I
> believe this is also significant for other companies with many thousand
> servers.
> 
> Update: Further experiments (suggested by Rick Edgecombe) showed that most
> of benefit on the web service benchmark came from less direct map
> fragmentation. The experiment is as follows:
> 
> Side A: 2MB bpf prog pack on a single 2MB page;
> Side B: 2MB bpf prog pack on 512x 4kB pages;
> 
> The system only uses about 200kB for BPF programs, but 2MB is allocated
> for bpf_prog_pack (for both A and B). Therefore, direct map fragmentation
> caused by BPF programs is elminated, and we are only measuring the
> performance difference of 1x 2MB page vs. ~50 4kB pages (we only use
> about 50 out of the 512 pages). For these two sides, the difference in
> system throughput is within the noise. I also measured iTLB-load-misses
> caused by bpf programs, which is ~300/s for case A, and ~1600/s for case B.
> The overall iTLB-load-misses is about 1.5M/s on these hosts. Therefore,
> we can clearly see 2MB page reduces iTLB misses, but the difference is not
> enough to have visible impact on system throughput.
> 
> Of course, the impact of iTLB miss will be more significant for systems
> with more BPF programs loaded.
> 
> [1] https://lore.kernel.org/bpf/20220520235758.1858153-1-song@kernel.org/
> 
> Song Liu (5):
>  module: introduce module_alloc_huge
>  bpf: use module_alloc_huge for bpf_prog_pack
>  vmalloc: WARN for set_vm_flush_reset_perms() on huge pages
>  vmalloc: introduce huge_vmalloc_supported
>  bpf: simplify select_bpf_prog_pack_size
> 
> arch/x86/kernel/module.c     | 21 +++++++++++++++++++++
> include/linux/moduleloader.h |  5 +++++
> include/linux/vmalloc.h      |  7 +++++++
> kernel/bpf/core.c            | 25 ++++++++++---------------
> kernel/module/main.c         |  8 ++++++++
> mm/vmalloc.c                 |  5 +++++
> 6 files changed, 56 insertions(+), 15 deletions(-)
> 
> --
> 2.30.2

