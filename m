Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA944C6AF7
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbiB1LlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbiB1LlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:41:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEAB71C8B;
        Mon, 28 Feb 2022 03:40:42 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21S9cW2R008190;
        Mon, 28 Feb 2022 11:39:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=OqbNlEGVi0Jhv1xB49AY5u0qmTkxv1WHdEQutQxlTT8=;
 b=WUSt1la7FIyC8ZUVQu5nCaBTXgKOLI/Q6bKKhlaHU30XfXgGPEAo3gmzBt/NE/JaCfhj
 O+hoiRx4PSkEcmWeUQDXx4RplN3znxyQGuUUxtx8+aQ1fvj6k+WCvCCLs5hMZG/vZX/N
 jg/fUHOCjUX5voQefXR+XB4BsDw3Irc/v1R+wnH4iol3bZs1O3TKRE0H8ZH0OS7h1+Vq
 p5GtUcrhSRtwoVgdyau19oh0Ahwnv75FOWDyTK50CZPLlRYGGL1N0Bs2/SbR+4CPW52r
 VKDCn0x4c1cgHZSRfnI6Qb+jA9wMWpTKGiAKWga/ruqdV97Tmk6MiOMaIiOvgrFrPGCV +g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efb02m17t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 11:39:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SBVPlj016430;
        Mon, 28 Feb 2022 11:39:40 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by aserp3030.oracle.com with ESMTP id 3efa8cckpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 11:39:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCQX5NY4dE2xQvEr0sL98uvLyQoyLrh5a0jWSWIQp/huSfot/3vl03g7He1qmTVAdwOVsI8iZK8z29JKf6cZJIiayYEgyaGYH1b2Fmediy8GivFX+pTHBKMEyzgr+BXF3656H1N+weUyR03HzFfrJoFV3d+1SYYII2bBPsz9w75MLmWrHEN90kGiqvr6ePt0KrX667W3VO0vTikYvpawYZ6A7nYWmrySCGawdSP5xUv8RCmVHVtsLdrqIJ1Lj0/gWIhJFvXkb4tBYJQB1183OcrQrHogQ4CK/on3caF+WTtaqYFHPF5Q/scwOlrmRpjJvTx1ga3ncsIIDqZE1UkJGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqbNlEGVi0Jhv1xB49AY5u0qmTkxv1WHdEQutQxlTT8=;
 b=V1HATOWw3GxC5jn/JGCZc33bIUy+LQmOZQ4IqghYANez6+035Jfu02X8uRq+RZ7S1LN0D/Dj9a4izsxewWAo+6QfsT/oh8zL884ZjjzUxLNzTsUYpgl4AejViQJwkXmpkuS5QO5ugmCPuLC3bHHzopefW2y3rjgkndXf2YQmweHaEQRXYLlDwxqgQ3Zm3Rfx3bcKL/BWf04MwC6hmicsOfAQwttMUM5qIAmfUgJCotiDFqBolSMpj3+A49rCtySpwF0uxcQgvmcQmEsau+fKqf7Ji+xXWu83lKdes20/mktmWdd1lpcSnowoVw1H89mQEz9jzzL/SOteEFB/6jNMww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqbNlEGVi0Jhv1xB49AY5u0qmTkxv1WHdEQutQxlTT8=;
 b=wGS8NmDTNU/GV1DmxKgvxarGxBre6uklesfQdatmpiYNNK8g0Vm+Ds4DkLPUTxj9C1DB0e5mWC5AgMr+6jre59U09N4kgFx8wK5YB6HrGCI1iZ/Su4cYx1eLRbmnT9whQg36qICZFSeFhBP21mRBkSAncZXkC+RPQRfMmivuA4U=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CY4PR10MB1992.namprd10.prod.outlook.com
 (2603:10b6:903:124::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 11:39:36 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 11:39:36 +0000
Date:   Mon, 28 Feb 2022 14:38:58 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sgx@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        bcm-kernel-feedback-list@broadcom.com, linux-tegra@vger.kernel.org,
        linux-mediatek@lists.infradead.org, kvm@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        v9fs-developer@lists.sourceforge.net,
        tipc-discussion@lists.sourceforge.net, alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/6] treewide: fix incorrect use to determine if list is
 empty
Message-ID: <20220228113858.GB2812@kadam>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-4-jakobkoschel@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228110822.491923-4-jakobkoschel@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0047.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::35)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2d38878-6d1e-4001-acf2-08d9faaeff5c
X-MS-TrafficTypeDiagnostic: CY4PR10MB1992:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB199245A769D59389E3932A138E019@CY4PR10MB1992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5WRTAwKBns2/XQ9PsyPpqednV8fus9ZsglKwbOmsgxlB7syM+0sD3GbxVb5jYdPYGhG4LadKveKCgpATaKtxLuSe+PcogCe0nRBaDyZq39uv4rPFOrUu3wOA2mehZPYjZWaY+vB8BznQMHFuQXJy53w2WXU10pM0NQdpjs28jqgJKMtQTt1eQIjdbTnkP4df+v/HV0kqBr6Ork6ytX78P4Fkn9hPuEFvnzSWDm3em34qX4kJyGWbB7rjhRhHYuqvyeuw2ZOS7wECMc524/JRIqlVBRqnsNUiHcOLu0OcqS75wpJseMatI0BKlWvRiworHJBPmPPdhX8hRgDfDuOF4utV5rfGnct7vEstIhmreKv5rZW9Ys9ioNrWHnFEV4BuzaeFKMz4Ffq+VmeJRQpG5g9DupQ8i3QXdR0AsSKPv5ORYbzkzGY4u64pKt6Aeo8q/VmvxJEiI9C+puGzwOiecyerJutHP1peoXsQjmN1xzvIoyVUIArMSgi7Ka2ycoazfimZ+wX1/HwF9xgUewn691VAzfKylohgnW8EWhQayEtmfaDz+xLwjc9rk2Kcx5Fdb3xKkhQ3VAzSQcjLik330N55oWtQN3jRBRb4Ake/IVffypQngavuoI7JHAxa3T5OB3UjXy10uAxuDUGS7MfPVkEetCWRT47h20rrQqd5N9uxfS+HYfVzIzwekqhthM4Uh9QxwPBa+Tel3BAiR8l8Pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(4744005)(38350700002)(6486002)(7366002)(6512007)(38100700002)(9686003)(7406005)(33716001)(83380400001)(2906002)(6506007)(52116002)(7416002)(6666004)(316002)(86362001)(508600001)(5660300002)(33656002)(44832011)(8936002)(186003)(54906003)(6916009)(1076003)(4326008)(66476007)(8676002)(66946007)(66556008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NA5Meblnx6V84SsPfqJWvMoKr+dP9hpfGzR4U3LvL1ahID65eQY1UcY57sic?=
 =?us-ascii?Q?0XeRZnJInYgM270YbWfQW0L3bYtzIg3cRtT2zttJWZuelv0UbS1CixTLcAkm?=
 =?us-ascii?Q?nXUtmqr5tatkFOhnVjKyU/KGn7r0aM7YzFN4dilEhhPM/zNaIlHwQo4QJBLd?=
 =?us-ascii?Q?PyJl3utnNe3hJr/jJqwECOjUxuC/2eujqTedNu64aUAdgcW/Lw/Rv4k7FY1H?=
 =?us-ascii?Q?ZW6OfRviTcAgC+GWZK+EUrZV5kkk4JzKI0zHpkYeaXiNaB1bnkVKRWLBxmof?=
 =?us-ascii?Q?mdSGQ8E5j5cqr5m7/4+XXdKHxqXYDRXnnzdk4Ph6NWtycYZg89Gb3iW9efAw?=
 =?us-ascii?Q?3W8P8vNQIfs+2g2t5praY4Lc96spQW/RXy6jDcevwMgTluX8GzXYCdpRAwJ6?=
 =?us-ascii?Q?K6KE1X+Eca+M6/41u4y379/ATNhTH/GCiOa1ljJP9FHxO7ZxdJtGDlMKKwnE?=
 =?us-ascii?Q?Rean1o/p2jRczmtcDxEq6d99tR2ZADj/shTPCDiuU75MErbSZlozrP4dESdT?=
 =?us-ascii?Q?yM0IJsglBTpjOo1QqSOtmMzpYOe+7DWs0zLA3U+UU+1LT1Sk8hksbJXprs2S?=
 =?us-ascii?Q?qqOf2vGFEHPi7EpEOREHIp4JwR1xAKcVczRQvC2zXPo8yVoNBEEeHzaVKib4?=
 =?us-ascii?Q?ZbJJdUZ7Y1hmYNgQRhCumjMx3HD5+p2/LcoVeaiNtDmxAxf34VsSWh+WEMrZ?=
 =?us-ascii?Q?eWkJdBrN4oZqrfUeBDzDiaaeCqwy1AJyk0blttzAJrDbGcH+ImpbsJb73YBf?=
 =?us-ascii?Q?DwxQfEu3vpeUep92um5/woZPP5HNZ1hzae9t6AVeFe7SQlLSYxkZOg2LRmLl?=
 =?us-ascii?Q?it/jW4zwfEQzp7vBNFI3KP7pl29Sutb506CCmG9iAK65ekCMp/02JvvtQrc/?=
 =?us-ascii?Q?I5cdf3XZguLuH5qCU9GyiODq2ggW3ANgCFb9D2BdZ87SN1Pi8FvN2+zkiq+3?=
 =?us-ascii?Q?1SCeRgvxyQcly22CHcVsqqLD2NFyQirmX++nDAukoV/s/Rnl0FIfzC8AkHQ9?=
 =?us-ascii?Q?/LaA7B8cKNVPkiKIigTqE162HDfHRx2wJfO1NVVtlEzYJfPNjaHm1zkm5ati?=
 =?us-ascii?Q?6GqSNKa8rJ68t3QTuAMONeK7KP9DSS/g7QcFomoodu8jXZoZvMqAUOTNx0qD?=
 =?us-ascii?Q?NQOGZ5SBEvJYILrvIiDmeu2XYScAsVaCVTqoEgSCCaJM1kn/AEuk0bhK1EKK?=
 =?us-ascii?Q?kbecQcVF2k6DyM7HaB1XQ5juQVi8VfbeCUWHB+61UhZRVrOGruEeFcuqIgUg?=
 =?us-ascii?Q?HasYt4CD1u8JqEw2tphWmyIg8F7orSEkP9fAKLRt3q//bEXGxt2Y5gKnQXfo?=
 =?us-ascii?Q?zJcJn7rWgrJKg8vHkmlmSLX1l2PVJ8YVnJnP7pJLrjNlQNtqLWHKk6IrqMYV?=
 =?us-ascii?Q?T4oXQzGhsgvyPz52Pnp9jIMj+Km4n63ZZ81jbVgTY+cEqGPY4myVJmqbyzYH?=
 =?us-ascii?Q?YYu8ndUXQ2dTJqYljZz+v5TfhksJ25cOI2cbsIZD8+R4AZm2QW1tA4ZrbFij?=
 =?us-ascii?Q?cFk2NbMoFGGiVGcP3N910jbPQiDn92BBsWw548NLTq9hjwAwuBT9JRA3iEW2?=
 =?us-ascii?Q?UwbbxQiZhQ3ffBhCRqAb8oc51lPG+l15Y9cGNeJA+0AgUzMq4o5x89Rrlm31?=
 =?us-ascii?Q?1g6zVA0FMVndR5JORsqDTnihObEqAXlLb6ILHWU/cDWTeWaVmm7KzDjevcYa?=
 =?us-ascii?Q?3aYugQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d38878-6d1e-4001-acf2-08d9faaeff5c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 11:39:36.8121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dkUwrPKpjs80RDqoyAOItasMuWoYE+Ye3JvGuw+6/228Sl54myDfnuMBziNyptgx5nEMsebN63SK9V7twBYSnLPH4MRsx5zMiCALFupkGdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10271 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280065
X-Proofpoint-GUID: 5d_oYQli914BnmJHotDzcMWXY7cT3DqS
X-Proofpoint-ORIG-GUID: 5d_oYQli914BnmJHotDzcMWXY7cT3DqS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 12:08:19PM +0100, Jakob Koschel wrote:
> The list iterator value will *always* be set by list_for_each_entry().
> It is incorrect to assume that the iterator value will be NULL if the
> list is empty.
> 
> Instead of checking the pointer it should be checked if
> the list is empty.
> In acpi_get_pmu_hw_inf() instead of setting the pointer to NULL
> on the break, it is set to the correct value and leaving it
> NULL if no element was found.
> 
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
> ---
>  arch/powerpc/sysdev/fsl_gtm.c            |  4 ++--
>  drivers/media/pci/saa7134/saa7134-alsa.c |  4 ++--
>  drivers/perf/xgene_pmu.c                 | 13 +++++++------
>  3 files changed, 11 insertions(+), 10 deletions(-)

These are all bug fixes.

1) Send them as 3 separate patches.
2) Add Fixes tags.

regards,
dan carpenter

