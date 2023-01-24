Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FE5679BE8
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbjAXOc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbjAXOc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:32:27 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E09448596;
        Tue, 24 Jan 2023 06:32:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjdsqVIBzAFjcpch2AlDdp/1oStpJWcNAVmFi/08xeG64S4qX9yDhpBAmd2oDs6teqmjU/uHoab8zjtax6UAkGtxG5mO3MRllYhcUOBnPHH1S6gWYf0UDUg9cFbFLQoy9JtcbuzOKgWqovSpTX7JAOYOK8I4W7JDb87HOxObN7CwRilavsboC8gAhyB5QfGIRP69F0WoLhsDxcWqBvjVy5wVFs5PVaPqeDW8y1t6N7n06MFfJcGdcGElx+7D7VF95yX4c3UPZVPGC8VTTClt8PnTacfd2+LkPVdDwEZzhz+H/790RBtsrYQw8PZGsxvWKfYCY4O6hx3rSxn0OeYBVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vsBlTKh5R4cJPeMAqeQeMUgK8zdy+41wL/FQjMAupEQ=;
 b=gqCu64KKIMZD+9t5DX2ouvQyF24GM9F1+57VOOQ2CrgE5rAmGFfECs1mO/18RFZe5EEPt9GenJJ5OkaRM+5OOAkdqalPKMEJVF0VtM+XtoUswZ40wmGm2q2vHvriLmSKp+7SQ4SzYABBYkKJhPq0/ScRHjEuMQiReHf2uvn4Rl8cE8YvMW0GEWmKSyhRAbfUZRyLGq6vjsfWfiDMT32h/587z5TJ6CWQKf26sJXUBKgXBBuxBhGEYS/sxsIosKeXU6tRHOUptt5xVujdbkngSWadAxyp/uKWE6KNkW6Ngk9/kIF3/lEruots00llPPFho3bunyf8JNXg4TBZJ/MVOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsBlTKh5R4cJPeMAqeQeMUgK8zdy+41wL/FQjMAupEQ=;
 b=fIB4EZKTLSWqGqDyFD6rLHiA0hEEZq8edtlzWQ/2L+zHACQn4KTST7CbpiwLnI8bymb8nf1LEfc/Ut57ufMteWd5Qagx2Zb0nWCVzpQaXBESethtqQb3dPJ6S3XimrqURbI/xWSDS1xgT+J0vtqUohKVJM7vvwrLj9IP98ZVj0ZjD7LDXEBOLbolgCAgeizwI4KexKRBb2CRivjmAHxWton34Shj0+1jJJloDTVBM7otOkSSgY0IIRwRPEXpD/0gt9lRj6zXsP/e69hIn9T0c1a7CxcBNLesEq1MlqCAPbPSyKGQ3OV5cfOWiXPbeCeeB4u5jNinP9v61A/NWNXYkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4353.namprd12.prod.outlook.com (2603:10b6:5:2a6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:32:23 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 14:32:23 +0000
Date:   Tue, 24 Jan 2023 10:32:23 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch, linuxppc-dev@lists.ozlabs.org,
        linux-fpga@vger.kernel.org, linux-rdma@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 01/19] mm: Introduce vm_account
Message-ID: <Y8/r91PGGiY5JJvE@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
X-ClientProxiedBy: MN2PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:208:239::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4353:EE_
X-MS-Office365-Filtering-Correlation-Id: d6fba86b-cbab-4703-a200-08dafe17cf02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bpjBOe+AyQreOlwg43PuBAgXiFFmYCCTbEFwZ2w7fcfIlBwNunCOD2rZNMXxnqe8WN05r1zd0oe2W0eZXhxbUlwdHmywxID+ZSy2rEa8fzASysNwbHxILzHFjnv8kD9zfHWADOs9iNMJN3+sqG6aAztztWSGZxT4uSW9AH3r7ALSRC1I5CrdaxTG+j79brO5Von3l1WIUUCvWv3In2k0zD/SAKxMvxTe0IHStIxh5txFjzBsygvSIR9Idcn1SmVd1FOq3eUA9FJtBzJFZ/TJvxfDFnPgDSenWIja9FqRgwGSa7Q3tLMC6N3SVBYgNQempO4cA4QpH297IOlfT6+PpqO/Nsj8e/+xjRwjgVYHs2/f/2GpVqooqXh/owiNOSW6NbqjIDMAx6Ke1yp9CfwME9voi1cBW+z+VpdfxUloWrhj9tavyLNQqEI6z7FGtd/UkVO/c1CkqZWvYIrhxg2V7WQZvuH1B0wCr97/4Wd3CAM0gfwt3jjtU34F1K532UuXJK+IYcIM/ZppzCRDnFOupmMP7yPREsX+VxQW8GBhR6xWm9aGHjNd4VcB3T7mEN9jJeCnQSze2nHizfIeBHYor1PpRTh6T2whll/Gh91eZUlYt0e51Ev9MAshaJZRPj3OMYnKTgG5IctE3Y4EWFv4bQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199015)(36756003)(41300700001)(86362001)(7416002)(8936002)(5660300002)(4326008)(6862004)(2906002)(83380400001)(38100700002)(6486002)(478600001)(66946007)(6512007)(26005)(6506007)(186003)(8676002)(316002)(37006003)(2616005)(6636002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iqD/moe6RmhzboXaYo1NEZEX7vca62fKm3eg/SmFVpSe/1a+sImdMc1AvRHe?=
 =?us-ascii?Q?fHRR99xnfiB5iA6u67q+z/HbGMjZrd8Kx/MZAVRJtsMDRJK4CUL0EB5T/4ne?=
 =?us-ascii?Q?Ta5R36WXyAfobPRXHTzfdEqraA6n6ZBaNhyz+C+FPsJEmyCFq9O/sKptqsql?=
 =?us-ascii?Q?WZ/RqnW8PXuV2sj7q5iiXylMMkpWnFNOVoqOPaYLX0KNRim3BGLlQNZSkZ5r?=
 =?us-ascii?Q?fqsharArSnrx73l5WGwQGyFbMkTi7ClmEcukIOCp92aXfaxSTcHw8UiU2vFt?=
 =?us-ascii?Q?w0n9vky9tVSUEKcuzrctnb5XWpddOu7SB6FnRBUZd2DcAGBXAQ/PB9kh/FTX?=
 =?us-ascii?Q?5MEbb2eaelIwGwHQlya4o7h49OBDH+ycScKFK48Fh6YxZngFdaMx3Swx+vrq?=
 =?us-ascii?Q?yBNzpqW1SATEQ3YJq/awWdqdY55xrtn5xdz9MKQDCySDwvbL3apSCil0+0ib?=
 =?us-ascii?Q?uAlQh6OyWQc6kKKO1v6zc4hol+qW80SQkan4++xxmoJIns1WsVkvTa50S/BL?=
 =?us-ascii?Q?CNBgDmWjl/QthibbegowI3kYkXA9LAhPmPTz8kv5m0j0BxIGvVQlU7ptEZ+5?=
 =?us-ascii?Q?LNl7B+t3zHfL6VNY+Y+Du+ErebknddA3mYyUo9+sHHWZ0tAQ8PcIzNEh3LCx?=
 =?us-ascii?Q?R6aduizD/PaSlbUndG1mVvWbi+cvoIISu822lPKVuH1r6Aqh1EUl0OvWHqQ8?=
 =?us-ascii?Q?YfHRxLrf2lbOdak7P2li9emcAADOYlWVKBQX2bFsrBdwaTNhclwqpxZjlqx0?=
 =?us-ascii?Q?hLedvwDhh87HCRwdpVjtmPtPqfn0CkGDh6qFqjV0l8QAR6MNPrROCfRfn5CD?=
 =?us-ascii?Q?u4ymfGRaso6T14UhfP4ZOYcYEx6+WChCH2tYFKkSAod5MGGoaOPNdDqkVOqG?=
 =?us-ascii?Q?aQTtbD+lqMJOF17SqUnMV4C/G0j+r8NuAS3MPHuP4eUIJNiNy5mOf1bQ/E7a?=
 =?us-ascii?Q?OEGBj/gAaZio5aE0MlstA5MVcLqSG2tN60KrzlPtiy4Ef45bhJlLe8H0ZhYu?=
 =?us-ascii?Q?+lAPEOb5Qu9/RwyH0mz5QWGuGu3dzEMlpCJTlHsD2rgIYs8pBZ8QItQU24rf?=
 =?us-ascii?Q?NMK+kIzTwMwowXtjivosLhqyW67RzRRzV9Lh3KUDfMtzbZMgz5SO2lnFAyNc?=
 =?us-ascii?Q?1K11+GvOKmlhTK2pv9wgG5Mpg4T6GOF4WGFv7wbw/xgaWptjU4yF9R2Jjk/x?=
 =?us-ascii?Q?uIOdNBRWaLJv2iiVsZcqoHHdwVJS4/jT93+a7DofIX7Hvcgn1Zcajtddozzq?=
 =?us-ascii?Q?D7zW30xtz01pzL9X1loBya5U2ytMs06+mqBpN0Soqa70swhUb1xCYQE1n0gv?=
 =?us-ascii?Q?m8pBPEuK1iPkjqH3ndEEtbXT7QcttcoxagoNzmPHk9ypgsHBDaS6fratdHj5?=
 =?us-ascii?Q?cpZsllh/AYXPXOGkaLbbUkKA9I6YPEOLEG5aIcUXBnQF5S/8K0kbDtoiqmkp?=
 =?us-ascii?Q?bw6Pm6bUxMEZfPmWvy95AT05rwqPLFVw7ImA7TGu3RfcGRs0oGO3Me/Lawbb?=
 =?us-ascii?Q?hObM8oMyxN1KJFpiX29Lqr9PECqB+ppiOgxIzCu2OHgCDCInySzY4+AzBG1I?=
 =?us-ascii?Q?HrzVWHZAkdi8+iy+USoy3adIYQfXCd0dqcZOVYoE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6fba86b-cbab-4703-a200-08dafe17cf02
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:32:23.8355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMSKI9iOCEC2XSC2VoTJqBt/X5rOcq2vFitihoENlRaaMkBKWBOuVsWE30CUtqjs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4353
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 04:42:30PM +1100, Alistair Popple wrote:
> +/**
> + * enum vm_account_flags - Determine how pinned/locked memory is accounted.
> + * @VM_ACCOUNT_TASK: Account pinned memory to mm->pinned_vm.
> + * @VM_ACCOUNT_BYPASS: Don't enforce rlimit on any charges.
> + * @VM_ACCOUNT_USER: Accounnt locked memory to user->locked_vm.
> + *
> + * Determines which statistic pinned/locked memory is accounted
> + * against. All limits will be enforced against RLIMIT_MEMLOCK and the
> + * pins cgroup if CONFIG_CGROUP_PINS is enabled.
> + *
> + * New drivers should use VM_ACCOUNT_TASK. VM_ACCOUNT_USER is used by
> + * pre-existing drivers to maintain existing accounting against
> + * user->locked_mm rather than mm->pinned_mm.

I thought the guidance was the opposite of this, it is the newer
places in the kernel that are using VM_ACCOUNT_USER?

I haven't got to the rest of the patches yet, but isn't there also a
mm->pinned_vm vs mm->locked_vm variation in the current drivers as
well?

> +void vm_account_init_current(struct vm_account *vm_account)
> +{
> +	vm_account_init(vm_account, current, NULL, VM_ACCOUNT_TASK);
> +}
> +EXPORT_SYMBOL_GPL(vm_account_init_current);

This can probably just be a static inline

You might consider putting all this in some new vm_account.h - given
how rarely it is used? Compile times and all

Jason
