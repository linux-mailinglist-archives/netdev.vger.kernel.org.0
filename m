Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84770494D46
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiATLnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:43:04 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:42868 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231593AbiATLnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:43:03 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20K9UXO3001468;
        Thu, 20 Jan 2022 11:42:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=JdrC42gx8PrJ13yPopG2XAxyRTIq/dZC4cGea0M3kSw=;
 b=GfkBnBdb8k31GdZ+4sGUDWaEVOv7Vtqv4qkZJQJDdNvTgLiNzG8norkh6k6WpFeShRn5
 dqHgz9mkbsvOgkUkvQn4Rs6EXRN21g9XKo+IBvO5JLYfX6KjMAy3Rf5VVJlGXmnGAJGT
 hjV/bgJo8pWOdkI5khUOplrH0OLwiM7nuVlBmMwxEdH/LUP30SWPWU4GmXDd5e+8s2HD
 8KjsdwtkWsE+luHFBVEIKKLhIZ6TGh+u+zM2pDVEh+Nudg4EWfbn0+vrIvHHXd0VCqmX
 m5S5QOa8r43jsot9aMpQUzLRnMrGvlCjt2ZYbWUZlZQI25W4bsFAKbhuaezazVH2WgoT KA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc5f7x4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 11:42:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KBaB30151224;
        Thu, 20 Jan 2022 11:42:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3020.oracle.com with ESMTP id 3dkqqs9385-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 11:42:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J79/beFF9tqk5PBz9qJRInqaoy7Ru+y+TLWPpueAjc2hCPPpjXd+uDgIeNN1R2sk5922EOC2sbCu4YgIJUX9s4IjEZcqFIqLDNy1dWRYdCaHd4IylAmUIgZA5z5ZQiUUfVSLmh/3GeRykT1PDSwvn7Wy0yF0XmxVto+X0xCPDWu6Mj47x9gmUcoFO9+MlqhDjmNZ+emkQQOXd+bXKzccBp/vrgfl/mDwoQMGzWnccmmDUPVPzKB9ZJZ2KG9ua6KyJ6dzOQ3K4TCMM1PueshGWOg0O799spV4KRioZRAs3nqAEDWz1+6wdimJ17QwqvtUpBZ01dkIylApyhcexKpkCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JdrC42gx8PrJ13yPopG2XAxyRTIq/dZC4cGea0M3kSw=;
 b=Dn9fxHv/MMXZHBoRgxn9pPnpJ2QpdJxFiN4wF21GJjmDb2XClzFIQKBElZskwr7vZECXncKdgYeXolqX4DT6nMlCvAVxhfTuWPWW+2P8cFQrvduc2SqGyNS4djGLLowT4mSK2kVcckjNJ6ch6rVEqNDHlNrp640nd3RLUfjWx0H6R4ViTWA7qDRj0lbO6SCHRIOgUTTl1iR7pEpxxWV53X6V3pYatoVu44ROatx4VSjzLfnSCwyQnMsCD7DSXPvkOV2V0uxdZsQaaF4SggkM4hQjrptt91UjjJfSYkWP1EO30KHKnb5sRemdXnb1vcIh1U+wO67ha7KBmctDa3n/9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdrC42gx8PrJ13yPopG2XAxyRTIq/dZC4cGea0M3kSw=;
 b=rV4nQgZBvK+gp06yfbWXpuBHS5DvUlMAtAA4yaFoVFYhrAnQXpo3vowmglop0Ibw17oALdRX4/isRsLdpBVuM04mBbGC1EmGc3028FuzyYslh5tC2M0kNv6v3CZjEZCo5WsZsbidD6X2fidUARF76Fs1d7eD79Vw7UxS5/mb9xw=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM6PR10MB2923.namprd10.prod.outlook.com (2603:10b6:5:70::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Thu, 20 Jan
 2022 11:42:36 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::49df:513e:bdbb:33a6%4]) with mapi id 15.20.4909.010; Thu, 20 Jan 2022
 11:42:35 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 0/3] libbpf: name-based u[ret]probe attach
Date:   Thu, 20 Jan 2022 11:42:27 +0000
Message-Id: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0358.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::21) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e50ce0b9-ae76-4e3b-0e24-08d9dc09f41c
X-MS-TrafficTypeDiagnostic: DM6PR10MB2923:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB29234B2E7DFC8FA43EF8D3ACEF5A9@DM6PR10MB2923.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xRTaX+lwZPlndH8U5KVxQSLvmeXxpeJEzmO6HV2UxinzDLt9+Jdp9+ebEFk4DQdQbBbw2QQfB4PwbEbXfZdy1dGIAqcjdVevjywKILcBM+EXJkHsBpQLfVMy5ugWA7c+vvcEXxP2ruW6SdkEj7VeA3KQQqNGAYfQDMU80rqZxYfweFrJxP1Fozw5a46b0NlKfPrGFHqJAVON14zCUjWlo+5KSndyEytTAV4FEHlWs8ekWTwxE2uJ4t7q3eF1kV4/viNIIVaDfIdXVr+WmXNGq8InjweB1yEaYNYI6o8z4eWbtHrxJIbP3oCE3/uPX71iIsfS11HSHNIR77J7jjx/5NA63z1IwbM2FPG+tEw7wUJv5Vr+K2UuY5zznDiF95LouzEYhZmfBH6NP12i8io6xggpSlMivYteRUaZc4BSUR0e8adEgIGnb8PJgCsKOIHOJmHcXsy4Lujw0eY6hvbuaKbADG+tUEpewSjrTgk28sCMTrZ6u/h4GzxQZadUcgjCL1UzzwZ4pv+5iqA9PYJTFcleKZs4VPJ//UXFjKLAub31qZxAzpKdfRQfkRI85Sk7FilRexDXd054FrnPPOmq3CdJunIcbGbuPXmk3hGi6+aPwpV2gRNDgHWOqtPNplzE9UAHxRSryx9sBjvW2+Dy+Ihch60y5oTxd0AkRy2NJS6rb3Xf1pKd2k1zsASL2UDuWU/ayl7zr5YzalFjmSa23tSTBJTgHpGOfA5t3fKdQXJ1+dgLfETbz3CQw7V0tx++z6z8Z84KQoynYJUPSAZhQsFBpkbADhvwsGKP+XIodY5dQxpVj4Aeta7X0YVZi3HQXsnUJaJI6++gRIBksE5RVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(2616005)(8936002)(186003)(86362001)(6666004)(6506007)(2906002)(44832011)(8676002)(26005)(107886003)(508600001)(36756003)(83380400001)(66476007)(66556008)(966005)(66946007)(52116002)(38350700002)(38100700002)(4326008)(6486002)(6512007)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oYzafmoICh2DdvoRXqWpUh6l2JJnYSdnGdU0x2AQ6yUOX2w4BJbMc7E0WF7t?=
 =?us-ascii?Q?OdBYKIL0QLzBjclTUo9HxODvAKpegSrIOQpAVniC1bgEkotcXPbZJMtyvGk5?=
 =?us-ascii?Q?+zsnd4ahbeVcyxyUGVZM4mpobb++gBGbMoO37Tioeg6h9hZOKajEudQdeY3W?=
 =?us-ascii?Q?wVbY4KR77otYUhCX/lg+CkE5eXEKK4+TsWNKAM0/pLQP0uDVFyI993l6n585?=
 =?us-ascii?Q?mW0OTEZOw2DXj5dc3G3rR38Ma3tE1/k4HDy9KNe2uG/lL95HWwHcDT5QHY0Q?=
 =?us-ascii?Q?o0zq0VBGPs3miypr5eVKctHRaOFQiezwyta2laOSVvTpQOkCFLNYqEbYD7p+?=
 =?us-ascii?Q?riXR8rRqOkPiJBWtyKlzk4EwdH5cbM2IEDftEeBdVzo+ZwEaruoKU+px2aKw?=
 =?us-ascii?Q?Gm8iB6iY+4EoADoY/tEJ4y5CbtDo69S9EZN05K2qpzUfbZ+cr3KwpsMK03nU?=
 =?us-ascii?Q?LeTuQDVxaKG/WTTrKlxbxSvtbywv3xWIRo2y9mXYrQKi+Ew1kgJ3ijEnnga7?=
 =?us-ascii?Q?fox2pcFIRUf9PLU4gKKYl0VsJpnf+OKDkhBpM9+6G5pMP3KgRhrfv3SyhtyK?=
 =?us-ascii?Q?ZLb+UOkhqXTZoFyvz3A0M3g7HJzrUygdnL87wOYSvuxBbLRbLkaLtt1UHpD3?=
 =?us-ascii?Q?nRaxUM3Au96e3LH59ZJI1QL5rRUMNN9OE+sDomIYQbtUQvYSRhACjGczGPej?=
 =?us-ascii?Q?ztkLaCBM/Q/PPL4gtEQ/Hr8D905iABNuq/TrTp6ASdP5r/SE8przsaaHbLcf?=
 =?us-ascii?Q?6wlFUYqKt/+Foa1pdOwv6GPHT1CHcn+GffUbrhBsdb33zAErHY9b04ieRg+6?=
 =?us-ascii?Q?+oic1P3LHHE2vjILjK/aU58sZ3D+OLdkZ4KjhnRc6pga8pdo8K8sIJ+l47tg?=
 =?us-ascii?Q?MFRokNBvEsZXFgrLkgAE/bTdPBQN40jcqn5ddAXcO66uuTyi6bEiytmbw7ru?=
 =?us-ascii?Q?eIkh/F/bH91WHCG5ZUsqSxMVXxHZN59OopLY7OfgkJgkTOz29GtAwjUPEDOs?=
 =?us-ascii?Q?GlNKR3lAhl/IsCF1WLJ82Jmt/7odMeBJCjHLM/KQKvBKy48lo0o9oZY/+ubW?=
 =?us-ascii?Q?M56+b73+l24ANrbIkk3aPHZx9V6eRa6lmEaezDReNNParZbWRa8hyNULFqRE?=
 =?us-ascii?Q?AvauSReY56pS92KyTqAa5UWLe25vYOgVClocI3g7xb2E6I06YTDvY+HUFbrP?=
 =?us-ascii?Q?Fnl2EPoTWiEvmexC4Np6tWIewyNhZyX+5lpJPuB88VFjCcL57l3NMC28kR0R?=
 =?us-ascii?Q?C6X4jFFhQvV7c45+0q/HLZBnxSUz9lL4Slz9jrSczp9tTxYciEG+r/ghwx8a?=
 =?us-ascii?Q?Vsi2N8j8GxSykzg7lFJCaxwj00wlOZ+FtGO+3Cs8AOw+k1QNz8/FcmS8mKxD?=
 =?us-ascii?Q?8tuoalSRM7U/GzDwUDs2cfTXaEih6HYIhZdcz/hkiKme0vWlVf0UloMBVMF3?=
 =?us-ascii?Q?46djXxmt0NxMsFir9VuvkX+6TYCH8XAwdAhobWi1PCJHMvBHBIF5dxo3OVo8?=
 =?us-ascii?Q?N+fuaP7eUg94W9hOgDaSJVT9QFXKppy/r40gNMEURYmuLAI5mkZfg4uMgqVa?=
 =?us-ascii?Q?MddgPpifQRYGKH2iuxLdZyLqKLJKSMVYGe38Dt7ozRR6UZqRUlSYtrAc5Lot?=
 =?us-ascii?Q?/JWG5za1AmSXX0COlfQafTA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e50ce0b9-ae76-4e3b-0e24-08d9dc09f41c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 11:42:35.9493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OyUy4MtSZgtYW+K8yGO+kWDiYviIBnS14PRhI1JdxSXUNN7vqnxUT6/0n4+rcReDNnhGvtjZT7jbB4qu1C7f5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2923
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200059
X-Proofpoint-GUID: CtwKWRvc_G7gmce4Zlljp44BIrxBbqs8
X-Proofpoint-ORIG-GUID: CtwKWRvc_G7gmce4Zlljp44BIrxBbqs8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is a refinement of the RFC patchset [1], focusing
on support for attach by name for uprobes and uretprobes.  Still
marked RFC as there are unresolved questions.

Currently attach for such probes is done by determining the offset
manually, so the aim is to try and mimic the simplicity of kprobe
attach, making use of uprobe opts to specify a name string.

uprobe attach is done by specifying a binary path, a pid (where
0 means "this process" and -1 means "all processes") and an
offset.  Here a 'func_name' option is added to 'struct uprobe_opts'
and that name is searched for in symbol tables.  If the binary
is a program, relative offset calcuation must be done to the
symbol address as described in [2].

Having a name allows us to support auto-attach via SEC()
specification, for example

SEC("uprobe/usr/lib64/libc.so.6/malloc")

Unresolved questions:

 - the current scheme uses

u[ret]probe[/]/path/2/binary/function[+offset]

   ...as SEC() format for auto-attach, for example

SEC("uprobe/usr/lib64/libc.so.6/malloc")

   It would be cleaner to delimit binary and function with ':'
   as is done by bcc.  One simple way to achieve that would be
   to support section string pre-processing, where instances of
   ':' are replaced by a '/'; this would get us to supporting
   a similar probe specification as bcc without the backward
   compatibility headaches.  I can't think of any valid
   cases where SEC() definitions have a ':' that we would
   replace with '/' in error, but I might be missing something.

 - the current scheme doesn't support a raw offset address, since
   it felt un-portable to encourage that, but can add this support
   if needed.

 - The auto-attach behaviour is to attach to all processes.
   It would be good to have a way to specify the attach process
   target. A few possibilities that would be compatible with
   BPF skeleton support are to use the open opts (feels kind of
   wrong conceptually since it's an attach-time attribute) or
   to support opts with attach pid field in "struct bpf_prog_skeleton".
   Latter would even allow a skeleton to attach to multiple
   different processes with prog-level granularity (perhaps a union
   of the various attach opts or similar?). There may be other
   ways to achieve this.

Changes since RFC [1]:
 - focused on uprobe entry/return, omitting USDT attach (Andrii)
 - use ELF program headers in calculating relative offsets, as this
   works for the case where we do not specify a process.  The
   previous approach relied on /proc/pid/maps so would not work
   for the "all processes" case (where pid is -1).
 - add support for auto-attach (patch 2)
 - fix selftests to use a real library function.  I didn't notice
   selftests override the usleep(3) definition, so as a result of
   this, the libc function wasn't being called, so usleep() should
   not be used to test shared library attach.  Also switch to
   using libc path as the binary argument for these cases, as
   specifying a shared library function name for a program is
   not supported.  Tests now instrument malloc/free.
 - added selftest that verifies auto-attach.

[1] https://lore.kernel.org/bpf/1642004329-23514-1-git-send-email-alan.maguire@oracle.com/
[2] https://www.kernel.org/doc/html/latest/trace/uprobetracer.html

Alan Maguire (3):
  libbpf: support function name-based attach for uprobes
  libbpf: add auto-attach for uprobes based on section name
  selftests/bpf: add tests for u[ret]probe attach by name

 tools/lib/bpf/libbpf.c                             | 259 ++++++++++++++++++++-
 tools/lib/bpf/libbpf.h                             |  10 +-
 .../selftests/bpf/prog_tests/attach_probe.c        | 114 +++++++--
 .../selftests/bpf/progs/test_attach_probe.c        |  33 +++
 4 files changed, 396 insertions(+), 20 deletions(-)

-- 
1.8.3.1

