Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759183CF6B6
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 11:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbhGTIgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:36:01 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47794 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232246AbhGTIeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 04:34:18 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16K9CIcU010269;
        Tue, 20 Jul 2021 09:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Foc0GOAo+GPaVqP1pYscO0GE6mWGHXrpR2pZCFT46oM=;
 b=PVcw1kElTcmryC8TjWDoARGKpt3acb84SLyNjfkhvMwfAZzUSkZzdiRXMu4Oh1xCkNEN
 c9QQjpdKBdi7jbbO/dooW9EhkOcvwWTpuK5VUuZ6lGxIDPyqQlsRMEOs6p4ISuuiRW51
 ruCFILNqbnJ8J0tJIA9fmXoRTaRuL2zkEucK2i8XjvlMKPnFYzN/gBz39/hLq73l+x8O
 xWBMdP+eS3Tzwv6rTnaJ3MELFtkSTqLBuv43D5gEjWLsyvFzyq+Eozq6u0OER4qcwW9R
 pMIcTINGUc3yYlW/gTiA/zybjWmnKOjyPtOvdveXAt3Qm30gO2+OwU8QImupwQFbkN7t Jw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Foc0GOAo+GPaVqP1pYscO0GE6mWGHXrpR2pZCFT46oM=;
 b=gnCVYmOVbFX5qMug6jTE9PY1nmGPmCOvQcwH2QAk2hMg7rXo3hEQ8mp91xgPOdMbQ9At
 CYQ1Cuq3eBrYV1/TjekIaTI5BUQF9U5eNsIAKEybkB/KUQZ2GuKInZdp8Mj+9MwkXe/T
 2nLuRHytArNRLSFVPWNZGWWCnv/BEgK/rW4s1KVn+OHV+mr4r0xULtSYws9fUHS3r6h1
 lQAckUjjRS8X/qqPj5xYi+JjrdGtZCC8sQygeOEdlV/MxrAYaqL5VxSjoKqCAJPj53YQ
 zLs4wjKl4JWkS0N3gp2mwK5zDL8kCpkHT52z4a81xTWjRmyDSV+cOkhzd1TwxPtmtOlL mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w9hft67y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 09:14:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16K9ASaR079337;
        Tue, 20 Jul 2021 09:14:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3030.oracle.com with ESMTP id 39umayv3fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 09:14:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOxWvcQbV/OdFmeQnQ2rK2ah3xwx4tDde8DogvIEEgvEQ5Hiwz8L4ITA6hhDEDKu7zzPqxsPWv9/Er/IJmGFJACNPymgcrC82a6Civdr88bW2sqTBmoRoXus6MBp9Ck7fNpviCxbwyszWlXy71ywXkB95Pwx9yS1p2ScaE156rkWRH3WCemJlLC0aK3vzEXK3DatMmkEloFDgC/7MVs0+UwHbqblP2GYapWshXx/a51LAa3VpYdJfWbp5Noq2HHQHqfkVDO2ibMndCggJI/YxhmVIoCHLMW4ch8p2UOAtFgUEZTM1nu7R3flEI/ck8npw3eDZJKaa5V7kLT9GjB6qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Foc0GOAo+GPaVqP1pYscO0GE6mWGHXrpR2pZCFT46oM=;
 b=KFGEgrFIO5ynJC5ZAW919q4p6wt59HtK68Tw5rUccK0l/zdqwma9MmX1b6dIteNJ/BaClTDslkn7FJrtVVCdJegazgqGc5EBn2yQV2wGJ8E1hN6XZtVWEfqRgeM5WHkpqsirzE1FYR3RrbwyB9/yUej9ksURBoPUg8ILKZ7MVp4mYM9pcIhCQAMta+SSapxAXk1qBl4xJUP/N1SrrK1iK/fQiDLYMEPrB97tuqdNYRxp2cBsGCSh3jYTTeNDeXMdUQ1g2ShtfZxRJB0MXMJArfo3WHtQDi6IkqQJNJiSNMnl3oprV68IBEdvjXrlApb68Tgr/x3zO2vnjewz6EMX2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Foc0GOAo+GPaVqP1pYscO0GE6mWGHXrpR2pZCFT46oM=;
 b=fdGFTrJ+r0KdPr7tpBSR4Yj1rEFjh30rI05BwrxNR6fjwimvHikHCW88wKM1afkd+8uAIpSEud7bNYaE/8VCrnZhXcGALHLWntPUinP9IwbOlgiYF0JjZyItOpi3uQSG237KkEQBwj9xwH0NWZfx7326KM2cVxPOwbYdvublENI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3693.namprd10.prod.outlook.com (2603:10b6:208:111::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 09:14:32 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 09:14:32 +0000
Date:   Tue, 20 Jul 2021 10:13:48 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] libbpf: avoid use of __int128 in typed dump
 display
In-Reply-To: <CAEf4BzYUf_zgmJQ_3z=oYAiGOypYsAhvoaePQMB34P==4EOLbg@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2107201002170.11590@localhost>
References: <1626730889-5658-1-git-send-email-alan.maguire@oracle.com> <1626730889-5658-2-git-send-email-alan.maguire@oracle.com> <CAEf4BzYUf_zgmJQ_3z=oYAiGOypYsAhvoaePQMB34P==4EOLbg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: DBBPR09CA0013.eurprd09.prod.outlook.com
 (2603:10a6:10:c0::25) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2001:bb6:18f3:2e58:2fc8:ca6f:4a81:b0d) by DBBPR09CA0013.eurprd09.prod.outlook.com (2603:10a6:10:c0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 09:14:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db39df0c-4e96-442f-266e-08d94b5ec94e
X-MS-TrafficTypeDiagnostic: MN2PR10MB3693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3693E2E05021AC89839F743AEFE29@MN2PR10MB3693.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rd4Xk5owqwdDlNq9OJlyUk9YC1uEy8zdsT70HR+7xynM+oBD1hjV6LVcCm8IaZfUqP4HQ6pPxgsdTyWgSBcygAct1qxR2UTFxs0ecvUlS+IJu8RYKh/an+sdn8zBg4hHfAutxpv2BM31uTtsbAQYvWn/GEn1LgbVYhQcxSBZZJCDMXmfgJBspQ/Mm+8FH5Z+prmLQWhQaC1kE/pVOC+D/bFUEDnX/9NK4iRfHb1aCkNeYFqApwK85VmKCKrfJexkv7mMVS/qY7UjfBc1/HLIFNbM93wzJJILFFDk4SYlwGbsYJfQEOwvdMgeK6if6LX6H+puk5+YmYAgJtQ9tuHosxoZDv9cNPmGsZ/0rlE0sYYwdyMAPvxr7i1UoRSM0wGi4k5N8ubH/bPy4SjKs8+2U+5u0HTOoL13p+tIljcChGBXTyvXCy2MVa7j7FHPNXfF2JDQclGtmu1RSZvOna6IajBXXfbbOGBMVM6qTEXV/6FJtkGSNB9h+cebGy3YMLhF44pP/nQNH7c9kEbcpukfX01AKlKxUWXurf9AMPs2LjQ6aR6ap4MHmAgayD5iyM9dB0ExQrm0E2kvFHJoZc6fR6Urppd2ROVCenJ3Zv+7kGxDHiIAlZ2dqMia3T8ugKAv78ZsyuHyxwFJvFnVH8E73g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(366004)(376002)(346002)(9686003)(66946007)(6512007)(478600001)(9576002)(6666004)(66556008)(52116002)(8936002)(44832011)(38100700002)(4326008)(53546011)(33716001)(66476007)(5660300002)(7416002)(186003)(316002)(2906002)(86362001)(8676002)(6506007)(6486002)(6916009)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BvAGb6WME0MH6qI8xNFtK9fIM6nobrl4mSyh/3aVpmhSVxqMyhvuxI178HWX?=
 =?us-ascii?Q?KS3WBp1Z2dYuqSmAwAOnmMPkG0CnhYerUOzmVS8WiaRRsvRrZsgCekp6FFLo?=
 =?us-ascii?Q?dJJhrIqvm5rEAEil3sYxVmc/W374J7z7cMPQTa4q+TQdmOYAdka5PfakpAQq?=
 =?us-ascii?Q?QaNM2DUEYFG5Y3WjlwKRh5qDZTkaHFiCHS+FolpMrPWxuj58dzFses0pAQH/?=
 =?us-ascii?Q?YQutz+j2+/dVGQ2sGheTrGlfCb2Hzt5KoBS+AUCCUEIOHQlNpLgHYHhM5/gr?=
 =?us-ascii?Q?EVpCwboUMvOst6rx0R66SDy2R0afEgMlQX1g3aeEV0Unx7plQOy9Akpxcf7/?=
 =?us-ascii?Q?pz2gjfMnhYI5bUqpmSSiaU3jWu9D4U9kpHazgU7ZvAxyh/a3U/oiI2uBbXi0?=
 =?us-ascii?Q?FNENN6snxH7BfKZ/oQX+8V6PdiOajD3bVyBKSIWpIiLV/FWzv9JW2cAZlpE8?=
 =?us-ascii?Q?1Eh5PKiDtZ/ZuGxo/Jg/UBHLMPCWEyu2o8zJ2KQ4wTc/eKlzZ2IWtNkGVX7z?=
 =?us-ascii?Q?Xy7lDCLUg39dkHjRFnpQSk9MhW5maY8j3ubID09J1xp+SqbaQx/GfSsTcshz?=
 =?us-ascii?Q?wJ6rS1I2C659BTSVdGa67hhEbP3eKFlO72Rt+AkNuzxMmFngXiTESzvUlDU6?=
 =?us-ascii?Q?xkp6dhyg84suYFY68ZeH4dPvqA2hij+Mzgzsjhs4j5eTkkoKPPf1pbrW4Y0Q?=
 =?us-ascii?Q?Mq/ROBq7bxh1NhlJMXgDLkJ8R/MtOGvYuP3Y8+S5zhYw8x7pERhkrBWgeJdI?=
 =?us-ascii?Q?pLxEZ8UAhFOlQDTrlu3SLqo5ozfaIyN9RgRB4od6YY0aPV7Mrr2AXP37WGIt?=
 =?us-ascii?Q?ViRJdorjWM4ucWy2zakM/78zZUarhN0Dy12JVjBEY7DERAZgFesrtgFyiMMV?=
 =?us-ascii?Q?9AIbVS28FTfuBCDBksEjQMl3n/i3tTV35Lw1cVt8ycpfESQtGrHNU3UXCiVA?=
 =?us-ascii?Q?5edef9lj3vS2PnmSu3kmfxj/P9bXYQ7YUVbh7txU38wtRR0qJV9B/uNqXbS+?=
 =?us-ascii?Q?MBnvYinIYLE+pL1SfGki+WXpN6L9Jh94nkIM3CTKs/oFaaWSM2ZoV7trdgUu?=
 =?us-ascii?Q?r9nMIJiidGpsSWSPv+dJiG5yfsDkoI3D0lcrZ56Ozs30v39aaxapmTzyvGf9?=
 =?us-ascii?Q?QpHmtrgq3Wb3Q4otXwGuP22ui8Mh8kevFI3sP7ug9ghwK1FD02dMItqhIhzE?=
 =?us-ascii?Q?x/bbFDh4Ta4/VL92oHQ1r7IA+R2o5SAV5ZJQiFrUteduOzBvBVp65gMDG9JF?=
 =?us-ascii?Q?a4rfRE/kBaBwEqgLKPD4j9qCD97UGaAU041tzRsTKESdfc+qGiqMROY116+x?=
 =?us-ascii?Q?TxeqWxTyFDkWtgFCn8uoQU0emJ1emRte7FvBRw4HsLxZfeRjqWT4sZshkkhF?=
 =?us-ascii?Q?IWuX97RGlylc7ycPkf/QE7MY5Jd0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db39df0c-4e96-442f-266e-08d94b5ec94e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 09:14:32.8336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZYUNKzw/2hOfiyZE/aNuOVZ4qBiJdUQhVkZ1yoFiCet+EVq2oEt4LccMEg23zPiHDb1Kzc7VapyiAnRZgE771w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3693
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107200056
X-Proofpoint-GUID: 6vcK5WiWu5BLyJGRGRLhbZe8dEfCGAPJ
X-Proofpoint-ORIG-GUID: 6vcK5WiWu5BLyJGRGRLhbZe8dEfCGAPJ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Jul 2021, Andrii Nakryiko wrote:

> On Mon, Jul 19, 2021 at 2:41 PM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > __int128 is not supported for some 32-bit platforms (arm and i386).
> > __int128 was used in carrying out computations on bitfields which
> > aid display, but the same calculations could be done with __u64
> > with the small effect of not supporting 128-bit bitfields.
> >
> > With these changes, a big-endian issue with casting 128-bit integers
> > to 64-bit for enum bitfields is solved also, as we now use 64-bit
> > integers for bitfield calculations.
> >
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > ---
> 
> Changes look good to me, thanks. But they didn't appear in patchworks
> yet so I can't easily test and apply them. It might be because of
> patchworks delay or due to a very long CC list. Try trimming the cc
> list down and re-submit?
>

Done, looks like the v2 with the trimmed cc list made it into patchwork 
this time.
 
> Also, while I agree that supporting 128-bit bitfields isn't important,
> I wonder if we should warn/error on that (instead of shifting by
> negative amount and reporting some garbage value), what do you think?
> Is there one place in the code where we can error out early if the
> type actually has bitfield with > 64 bits? I'd prefer to keep
> btf_dump_bitfield_get_data() itself non-failing though.
> 

Sorry, I missed the last part and made that function fail since
it's probably the easiest place to capture too-large bitfields.
I renamed it to btf_dump_get_bitfield_value() to match
btf_dump_get_enum_value() which as a similar function signature
(return int, pass in a pointer to the value we want to retrieve).

We can't localize bitfield size checking to 
btf_dump_type_data_check_zero() because - depending on flags -
the associated checks might not be carried out.  So duplication
of bitfield size checks between the zero checking and bitfield/enum 
bitfield display seems inevitable, and that being the case, the
extra error checking required around btf_dump_get_bitfield_value()
seems to be required.

I might be missing a better approach here of course; let me know what you 
think. Thanks again!

Alan
