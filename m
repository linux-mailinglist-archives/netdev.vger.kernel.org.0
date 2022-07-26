Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1D65815EB
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 17:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239477AbiGZPE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 11:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239221AbiGZPE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 11:04:56 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9C42E9D0;
        Tue, 26 Jul 2022 08:04:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUGEdlUd/CSR6ccanjvhXJ0uX4yg4grE2g+mtjNjGAADeF5/N+fHuKbonG2QY6qxa//VJ4Q0LwL/yxnBIbeTLFDDtonqRkqxIAoV+ErZEhXkXGVVsHXSBp+ibWSoZv3or36s+XXN4ncxsDjnEYtsgVQpx/1N/88fv3IkcbbY6RYeeB+KV23xF8EOkJgIeYgB9PG5p+1mULFEuC5JT3mNd1LrvLZ1LMKI4wIQxtTmn43QllOGM5DokdxdEhU8hmg4KeZcSuoo6glyA9329id93CIlz/AMXrpuabQqYY59mELIeqUrH0nIi7hy4jMVo9MNU4JlSnpEodoVxUVY1stYsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CODqjuSbytRfAVHlFl1B6uln75MZUVEcKcxPeDqKCyI=;
 b=J28AXibUxSHrrhOSTphvKbPb2m/OfofGZVA7DJmHc6PNxBotSzdDtaljdbkoxePFE+TuDs5GKFZqLnL8MhV72D/8Sw0qG/o13wr/92zvCrbxtszqJh0Fkjvi8wnWPEl8TvH0pEa0Z+qOCRs5+vv98gcf7qU8VItSmcCOiNRxeG/NBbFzaqqaRlNX6RpHoArbFLSNZMGubThybDqrvzzl6ro8VvCbZBjjEjD0NxSKV2V8iQdPry1B+hFoZy0afd3Sh7vroWnZzht7O1R01TsVLZVluVrM/bsb/35SoYaS9rWWlHjONvNEDbdir97K6Y6dfmZmgCWt6/e+Ecs5i1MbIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CODqjuSbytRfAVHlFl1B6uln75MZUVEcKcxPeDqKCyI=;
 b=Y6cD1T89PbdoqWKNCHO8QPLfnzc1q+0M91gsDq5CQdAkBYmNWiapm5gC4VP7znxnokfU1l9apkVPevGNa5OLopN2Ci1Aicrw8J1uRrwB6CUoE/LKoNqXayT1YP32TGLVCEFpCdI5A1lyE7Sotu8bVqV+uQusKFlxSBs8DhkGQ7rIoLBg6rL+7ho7BAVcFdbCaDNeuzqYpApWw9PxNwtf1Giq/sZYjZROagoMeacftv7a5HblvFvEJwxDyb3UA/a6KgeM/McrjyMxYt5Rhy06JijcyEKpsB4dj1fild/UhRg646dc1mrwfjgC9PH6RyLgNM+FsGnY+tD0k3CUDBmNEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3807.namprd12.prod.outlook.com (2603:10b6:208:16c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Tue, 26 Jul
 2022 15:04:53 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 15:04:53 +0000
Date:   Tue, 26 Jul 2022 12:04:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Message-ID: <20220726150452.GE4438@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
 <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <56bd06d3-944c-18da-86ed-ae14ce5940b7@nvidia.com>
 <BN9PR11MB5276BEDFBBD53A44C1525A118C959@BN9PR11MB5276.namprd11.prod.outlook.com>
 <eab568ea-f39e-5399-6af6-0518832dfc91@nvidia.com>
 <20220726080320.798129d5.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726080320.798129d5.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR14CA0002.namprd14.prod.outlook.com
 (2603:10b6:208:23e::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac131d7e-c508-4d5f-1dc6-08da6f1831de
X-MS-TrafficTypeDiagnostic: MN2PR12MB3807:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q4U6qNdo8vo3edhdB5diKaxUwa8R4sQ0aRZWQZAvcZWYJS76wdeLpFWniS5vdR3oS/QrIFW5uV1+iIK4ctaPEDrGk77GamKF/5Bz6mBh6zm5P9d278BrU46jCycuL8PWTWOfJZdcMfz7pvOMMPyTXapbe7UMR6CVZ2Eg9fLXfQPfUL7TMSThqTpbk/QBVHuoVWOqBZU6pENPAAW+oTr+JebLLI/G65PAchI/eFdIZQRbNqgSKkv3gzAj5R1i407s5ztLMKrqFrLKdFX7MP8ibSePskT6wFhzLLUK9hJCRJHYw8oxG8J2a4Ku0dkLQ6Xe7/Z3Wi6XOAGNX2jn0KtL+1XSGxYuY/COGFgeA2mwdpIQ5PGTIsxiBusdCJ4AgdQk3oUAV0SPOYXYJWqC7YOzTexN0D7ob+f4MTMaF1TsGqLcUdBwF6cUXl+e4XeQLUAsHy6iBZQWDd10EQ3daOYq/IG3NfvfVB490clyNhDOUrFlFwCHjxOmdiGv21xPoFwHm43OPVhN2gpQLZzvX1IaHozkEO80tOeIgKh6marxRYuDK2g9OOl9OlozXAMp5wDvGXDOuUQyfQiwDkYF0pcoiSn7tWsDdlpKKtaRY7VOlFr4lRXCrRUIHlg2ypztlIsN9+kPn/3FZdwMgY1D9E4nOLAP0BzkixKkZApWQ/dKjLjip3vThO72PmTzBOaczqE2fnE38SVSmhrlUkyFQjLG6expn+M+Z21S/6kFNjgBjxSp+XWyKbrfQGDaHE7/i+AB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(54906003)(83380400001)(6916009)(186003)(41300700001)(5660300002)(2616005)(36756003)(1076003)(6512007)(26005)(6506007)(316002)(2906002)(38100700002)(478600001)(33656002)(6486002)(66946007)(66556008)(66476007)(8936002)(8676002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ysJfyEYIeXQ1t6uvHT4g9merlVoNPGCQONY+QmVCG8eTRfnsofVMuALc28iC?=
 =?us-ascii?Q?Hb8F5HBnfdj8MT4nQVxYaP0QWy6xf28B1vLOKIZy4xe3uwMN7x4hBqsQjSjN?=
 =?us-ascii?Q?yvwATmyyqPRxW4AvVsT/aREa9Dx1og8ERbH8G3PR42zRTJv7KRyuQpb2S9dm?=
 =?us-ascii?Q?SOGr+Onw/xa1W+BaGiHRdtFLIS5hIbsKNWNiMIjCoQHn/TCT8dGAtCB6n8qW?=
 =?us-ascii?Q?IjSRaQ/7iMFun/lz5E/0f+GDIqaHIxctrbfcUDOIi5RegkaeaQyHWiUdAmmV?=
 =?us-ascii?Q?u0WLWFJDFx2VxaZgFZ52IJM6tlbzy979n+oda7XOWVVeSMUo/tAKw+KHOXcq?=
 =?us-ascii?Q?wwhlqmHOEl2PXI9KaKuj57PudVmB6KpGdutbjPXacvgUJ9yGg1Uf0g7ozP2g?=
 =?us-ascii?Q?34e0u/BxrajtsZp1flEddSfGRG1AFLnqjZr6jzDvOpXN67pzNPfZoPxC1NeB?=
 =?us-ascii?Q?68IwCdg1kprrEKiZ0C57ZxUJO95EMoAZQqgBQbyYvTGp1y6s/fOXVWwvfIQS?=
 =?us-ascii?Q?lY466Ej1xfI1fLvIK6yt3fAZHsQbcZvqB5bEXo9IDqVZBMa6wEPDiPU5do8c?=
 =?us-ascii?Q?50yjGSe5ZJHMqwyR0Wt5FoANqag/FrHSkXCrrWpkY3+k2LfNfizJNBGis2hs?=
 =?us-ascii?Q?YmJL+NCNxY9FrtA5xxKDZgc39Behr6ECGHfNc8rvRzalWtWsI4QZ8xB/xd5h?=
 =?us-ascii?Q?aNXq1xwenHHM2ASS9v983migJclcRa3h7AayFE0xTETtXzoS02bhyV0YY+FX?=
 =?us-ascii?Q?Uza3dykS4teJ04+kGXmFhKDrp/Ejw4JRyhE+uq+v/fT7Dn5taAvB0C+TTpl0?=
 =?us-ascii?Q?G78oO5QjEnlzUU278ayZ1di/1QsqRSgGJ/CpgfSlMoEnJrSEnpiav2qnfnCd?=
 =?us-ascii?Q?utuow5XlaRkEh73suZdSuuytUzChvQIr9zbt0l2ZpcbCo2O0PdvrIgwD2TPk?=
 =?us-ascii?Q?Fz4M9AxY5fPi4Usfm5L8t2x/gEM/m5NO25r2tHPDSPKyLh/NN+eWPzPG/zUm?=
 =?us-ascii?Q?onQy++xYaXsRiVQRmPeuosvqYxVsubLq0la0roAk7ELJhkurFbILI12tfqE2?=
 =?us-ascii?Q?tFqsA3P8ZEJMFvc2uVrUJzQE0UVtKULEWqYUz+GeuNMuwDakK7AnWY2ek5Uy?=
 =?us-ascii?Q?YEtxQ/TJuJX8bABv3WUmWKFtGYWahHuvbT3wdQGOQoMkDz3fny2wmnR2+h6X?=
 =?us-ascii?Q?wEvVVs83rAvO/U1ctXdHWIs1QhxW7WDQzOqfrnU6Ic7H0Y6n+6GMHfnaoNOD?=
 =?us-ascii?Q?mJ0d7lFmKsyuoYf3+GkHKFEuhiqX4/xvyUE25l3x5uLhFmS73kk5Z7SMt7CM?=
 =?us-ascii?Q?191fl80+zb/58SctjE0+w7WdVRHRLedXb9rmwt+MYcxVIxLg4iFEWq8uwIR1?=
 =?us-ascii?Q?gMLR6dhmqnTrhrvV+9Cd/u2EOXJ3qSbIWI00mazF7BjXYeERNNweG4UQbRON?=
 =?us-ascii?Q?Ot9NaBCom0zF42vye9N7c0yd8bw8FOydBMspFaxtPydpQYmgTBBmjRIKd3MB?=
 =?us-ascii?Q?LPpcQ/0JAp45ir0z8k+AFiI1UdPSPLR93id6hi/VaOEBRWBZt9WxTMPY2a88?=
 =?us-ascii?Q?ss40ZYWcrJ+rOY30AJFr1LGCBPIlBxYORJq/gyx4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac131d7e-c508-4d5f-1dc6-08da6f1831de
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 15:04:53.4446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F3c6qlueHVtFFXpnBwtnkktm+VY1rtndPJwh32CWBwxssAGUzM83Yz3x+lJVS9Z/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3807
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 08:03:20AM -0600, Alex Williamson wrote:

> I raised the same concern myself, the reason for having a limit is
> clear, but focusing on a single use case and creating an arbitrary
> "good enough" limit that isn't exposed to userspace makes this an
> implementation detail that can subtly break userspace.  For instance,
> what if userspace comes to expect the limit is 1000 and we decide to be
> even more strict?  If only a few 10s of entries are used, why isn't 100
> more than sufficient?  

So lets use the number of elements that will fit in PAGE_SIZE as the
guideline. It means the kernel can memdup the userspace array into a
single kernel page of memory to process it, which seems reasonably
future proof in that we won't need to make it lower. Thus we can
promise we won't make it smaller.

However, remember, this isn't even the real device limit - this is
just the limit that the core kernel code will accept to marshal the
data to pass internally the driver.

I fully expect that the driver will still refuse ranges in certain
configurations even if they can be marshaled.

This is primarily why I don't think it make sense to expose some
internal limit that is not even the real "will the call succeed"
parameters.

The API is specifically designed as 'try and fail' to allow the
drivers flexibility it how they map the requested ranges to their
internal operations.

> We change it, we break userspace.  OTOH, if we simply make use of
> that reserved field to expose the limit, now we have a contract with
> userspace and we can change our implementation because that detail
> of the implementation is visible to userspace.  Thanks,

I think this is not correct, just because we made it discoverable does
not absolve the kernel of compatibility. If we change the limit, eg to
1, and a real userspace stops working then we still broke userspace.

Complaining that userspace does not check the discoverable limit
doesn't help matters - I seem to remember Linus has written about this
in recent times even.

So, it is ultimately not different from 'try and fail', unless we
implement some algorithm in qemu - an algorithm that would duplicate
the one we already have in the kernel :\

Jason
