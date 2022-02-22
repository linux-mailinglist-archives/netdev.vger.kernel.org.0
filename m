Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9578A4C010A
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbiBVSN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234926AbiBVSNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:13:55 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2052.outbound.protection.outlook.com [40.107.96.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F13F65830;
        Tue, 22 Feb 2022 10:13:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEvcB2B1VFAgV/fsXim+Buk5lytDI61a+GiDxI1kfBJcKOwF9NTBfJLhyQ3lHrx9tMggLPOTCkWBpBDVpNfsJu1RvsV3rMB3BhLpHg2RePvux891zjsPoSNxYwHXw0k2ycpidsdlVR1FcBJB8EOiNU0PnRdiQ8xC/VQfcTHmcItf2fB6YT9GP4mLUVUc5EZrXWAZniFiwmnq10sQdz3+Tcvc7OUWaXrE7bI1rsRO5tk5lR9SN+T2+6h8qL0BbLlCI2on3KsPGj5iUHMKzyu1/9fmepJIvazfNgDDPr6/UX4ys+B/S9MZlxPeHpS+FZgx5XJZ0VvzdKiT6g/YOaQwTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nynq5UHTuh3YMMKrju5ltP5Gqt6pCtq7Uxl6ChTSaSY=;
 b=XONd+R6JQ8o3E2SK9KxWZMN2d/809sc9RSJUoDrm3wJ7MnEUL9YEVHnroTzzMvOg7Nr3frix3BrOyrVRjbhYPRuwo+anPXT7T+bJCZuOgAeUjyesl2RnQU/xubYcUxzezOOOndAsjUeamPZ7XBw5LkUPHIO9vsQV/HoAsOUqXjvAh4tK9qTAIU7zwGAWfK44tTeqiJNtoEiz4IJf11lRwupiYMckUkZsuCXK8drkhCH8J97fw6Pa9OLxPcFPAm0WOvxpAx7SlIwDtSTvzx5epG6hvuomcEeYKzukwe9PDAGqWzUvwxk1X6OV+XqNIdMstwvE3NGVs9gc7dQNZ4HEmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nynq5UHTuh3YMMKrju5ltP5Gqt6pCtq7Uxl6ChTSaSY=;
 b=Krww5w1dKmSJV9o023T9qSYE33Nr0MzuAqqvR+kPqyjchr3UPtr3Q3W0vzRgUiv5f8hn4D7HxEkL53Q5ksGtvBYUnueLs4vEWUqd2Q/SeJUcodg4mBqtiqzryGFfEXp8nCZS86WnlXz9wEw+RCf03pl8dYveV8Q4AuBZ7JwQZBdks6pYsD2m66saC9tjgSW19vAuGr7F3w43xFv7AxLgbwrPioGJqLqx73pAv+Bsh/+8akD+MfjM5mL1MOUhOTuDWcjFiBAX3+SG4JwJp1meFpETcHspOPInycn2CoWQG2PV+j93xS1Ur38S+O1i6Qbi7Sx+fUiZwJ3ugcmRUdHB+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MW3PR12MB4523.namprd12.prod.outlook.com (2603:10b6:303:5b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Tue, 22 Feb
 2022 18:13:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 18:13:28 +0000
Date:   Tue, 22 Feb 2022 14:13:26 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V8 mlx5-next 08/15] vfio: Have the core code decode the
 VFIO_DEVICE_FEATURE ioctl
Message-ID: <20220222181326.GD10061@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
 <20220220095716.153757-9-yishaih@nvidia.com>
 <87o82y7sp2.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o82y7sp2.fsf@redhat.com>
X-ClientProxiedBy: MN2PR18CA0010.namprd18.prod.outlook.com
 (2603:10b6:208:23c::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2380f1b6-edc5-4b92-5e3d-08d9f62f063a
X-MS-TrafficTypeDiagnostic: MW3PR12MB4523:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB45237CBEC71C37CDFAF3B9E4C23B9@MW3PR12MB4523.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aGkjDseFjWxtrNFUOHviL2eT56c6bfhZODRtCSLy9g1ncpdgmOIc8bJ1oOMnVvnH9KQUV2tWd0n7fpiNMYgdTMgACqbG8sYAZMA6PHmsJ0HR2daUGkjDA5JyAroBFkK3UTEHABtEuHG1heCNruxU3EtC2wy1j1/jZO/AJszSq5nA4g2dD3Zm1L09Lpfn2fLet/X+dI2tTg2iL2VL57ia7MN7NeajjeLJQGcMXcLR0HUXxvyi7zpwYet1JVKnEhTUvL/X9Pshr46Pit6GekyLMmSFBsqia/ax/O/JzpV4/YxAxJblm2cQ/jkiKzGvVgzd2e/m97KsgKwnCnBWEF+oBpOSaWrGGn+KcDaSsZa7geUH+/xNhAkMyOV3wgB89nFoXOLpBKtTvSlINnh+IyAmwZKVTeX1n3daFsHSzRhh+ENIPYIod/9n4uAeb0W9E36q/dTCr2fK4ItPkDZZbJALEZlWn5S72eTY/ViRJr4DMqNvR7wAreDDlHV/l/Y21VM2lZs1+tLf3h6WeR3Mw0DfWUKUrz4LAIwlVX46zY/dnh9gKJMSg0uSDfXpjDT+7ZHfImkCXZ2+7uyELqGeea1B89MozJs4g5FVFifNB2c8XiUlq7aFkEcH4vKCmBit8gw5vy9UgNaRiet8x3aY/tIUNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4744005)(7416002)(38100700002)(5660300002)(6486002)(2906002)(508600001)(6506007)(8676002)(66476007)(66946007)(66556008)(83380400001)(4326008)(6916009)(8936002)(6512007)(26005)(186003)(316002)(2616005)(1076003)(36756003)(33656002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MbTdMumxG6xdpzvGirSdd/Yik36yusOtQIV5OfSmWenwr3I4fNHWCRtfFuiu?=
 =?us-ascii?Q?LLG9r5p0Qo8CdsEKJVzshylrg8rp9uXGu2JMKDXtr7jEztHvqvK/ubatPa1H?=
 =?us-ascii?Q?gXb9hGpsMyyg4HCMI8IP1VMNB5GPtxdHdj8n1TFvSf/pvrig3usAPWSKMWPx?=
 =?us-ascii?Q?0SoJU5AMmDNEgtmg8pqPDjF2BKX7VOc/IUCQkCgQeXvEtdA6UX/jvmdWhuk4?=
 =?us-ascii?Q?i5U4ONPzuudMmRFYufadi8XPGLCJGxupD/txBp+qfewfDMO6VPJfbIm74OMh?=
 =?us-ascii?Q?jgTOm9+F5TgItSz6g3pFtglvMt0r46L45FpPS0KY2E9uiK7odtVT6sM66g+J?=
 =?us-ascii?Q?FkND2v/i01Nu9gYbxFAJetKfecuJOEMfVEqM5dypyCKKXe7iATtvSmklkM5K?=
 =?us-ascii?Q?bxKcB2re+8qt3K7ZOvlLk52G0L81MijZY3e66LO9YCSIdcnd0fZQOq+V0Mp5?=
 =?us-ascii?Q?paIPp54BU9DajXZDc6g1ofVMQZGkGDbU/+NSjQmG7JlahjJGz6LWDfyr57eQ?=
 =?us-ascii?Q?K6q+3f3pZZQIQsCjTOdXNyqcSnK6COrFqogsH7tLv7+qUvioPhBo54ZyTC2u?=
 =?us-ascii?Q?otFbc/ygz81EqxHGSxLhGAtTgVJz9+/PswUyyMWjUikchPFeTGsPUmuVSrbg?=
 =?us-ascii?Q?QE3zJ4Ku452mq5c2kXynpzId++U5hTm3q36R5dLE6VmI2YN9MQ74zyrqVgfx?=
 =?us-ascii?Q?xiDjPavrsOjRAkTHS+ynrkqMzsxxcE/s7Ap3eT7ja23qFUWWEUf1wYgEhoyg?=
 =?us-ascii?Q?TJwZcb5BjlZDX6KDG+YXdBKoyCnoohpEEXjLct/+R2qsYom67jIuq+Ivx2LU?=
 =?us-ascii?Q?3L6tfgObcnxC3otjd32JWSrvx+1D2xOYfICJZo/SfVir5KqXvH11PTIP43BE?=
 =?us-ascii?Q?1ET9gTQOdx5SlIbDBlMYaYCB4FdnSmSxfDJ217MZ53IIlxEq5rBRCEoOmQwK?=
 =?us-ascii?Q?kcVgAlSqXv3I/Ci7cy9P/UV1yObqlcR0kMuvA7srMIIFRseR8Y2X606I4ujA?=
 =?us-ascii?Q?a1mAUyBg9rcP7iXb/j41mA+HhdtsYC9a2bXtBRt/kGoioUqsNjOkyobfAnXG?=
 =?us-ascii?Q?XicN/yHVhVEigXvYSO0okzhR2GZM2VP/FtovLv7r5G74PYR5ZhQGhI3WzuB6?=
 =?us-ascii?Q?RoKdZAinSuU8Mi9y6wq2VyUYQ99AFe9c4khRxWQ6X69StEn1GBR3Q6vkv6aG?=
 =?us-ascii?Q?iQu0/nwv62S1orDr6R/xyTWGf3qJJS/vH4VFuduV5NLEAINL6fg/hUJ7X63e?=
 =?us-ascii?Q?vioWH9vQ0Ms+MJW7HjpjcDVfOQEicxPrKWKDTxHJrT7MlzgrtyHKNYSeac+G?=
 =?us-ascii?Q?LiHuG43rCh/BmxOYNYr4Jd0RXSDNyZReuKnYPQ/r4yF6FWXj/VAumqnge6A5?=
 =?us-ascii?Q?Ih3l+fB9rpKXn5HxRnCwdn/Cuy1K9pvb3M4O3LxN1GyjJCVpAqePFnoeo/H2?=
 =?us-ascii?Q?J6Rh8ougN5fJ40IePyLwOY7xtlkSQZZGI6EZhJlvfbpLDkKB7xvb7G2pSsgV?=
 =?us-ascii?Q?ivg2CQpMkVmkWSVHU4JoeZDDtNNh33xHVRwEnZan/b4NM3ATFGNuyiKtoMti?=
 =?us-ascii?Q?NgLKNfSccUCyqzQmr5U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2380f1b6-edc5-4b92-5e3d-08d9f62f063a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 18:13:28.0050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mcrCx1TMROTOjOhzyof+EtLKI3H+M0alzErPE5r5Fubk08dMBgy9sZY4PIskszFc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4523
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 05:48:57PM +0100, Cornelia Huck wrote:

> One not-that-obvious change this is making is how VFIO_DEVICE_* ioctls
> are processed. With this patch, VFIO_DEVICE_FEATURE is handled a bit
> differently to other ioctl commands that are passed directly to the
> device; here we have the common handling first, then control is passed
> to the device. When I read in Documentation/driver-api/vfio.rst
> 
> "The ioctl interface provides a direct pass through for VFIO_DEVICE_*
> ioctls."

Hum. That whole docs section has fallen out of date, the
vfio_device_ops it quotes is quite out of date now.

It is all my fault, I'll send a seperate patch to sort it all after
this is merged.

Maybe we should be converting more of this to kdoc so we don't have
such duplication and it will be more maintainable. That is a bigger
project..

Thanks,
Jason
