Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E075AA39B
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 01:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbiIAXR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 19:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbiIAXRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 19:17:16 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2086.outbound.protection.outlook.com [40.107.212.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7619F0CC;
        Thu,  1 Sep 2022 16:17:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIooZ0OlnpNtsfnKVZ3qGy5XtobU6KKH1ucGThoXswp5zChxpl0rclanaR5UP+CkX3ig2bFpee8cXjnHGYr/0A6EayUpvxeencgY6we27rp4YXs7JzMcuQx2D0qk2dke5TXKs+7mZG2zAWlIRcoJ+/YhgN7xOdzNwiCZzoXiTt7TN/qTwJOv6FjuKhPdR/bFA7B4zi1JRtKJbY6niB+VDjQK5I0yaGsFOqms+n0ulB6YbgibqGc7YqFgaWR6xn5dxxAoIEqUpTpB+mE1ave/lPHLc9asCkTyy7ByYVXaGyrwy6i0mKELBDcdAyYXJnX0UaBcnNUdPY7mvFuSjSG8fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1BVoKknxcH5J47QjwMykp+fCCRd03Mq2lvxpcDCzLc=;
 b=LFUoobgb9mThU8SxCqwFNfhY+qD2uJJmaEcSHQ9ZiWNm/ARBTS8/8MhlPr6oPLtT5uT1444iZ5Jpdd6cOwtVkUYQPBB+VWvSlRezatZosdHWMWr9fFXGXlV3Z7Osf1P1wI6znAwH2FISentDmf/CvBAo8LnnbAumg5phRLgi4eHDcgLEdpU+whI19IfyQk3z5xgcXFxdkjEQAUJrnpW0p9EOXlQzQFd84yQQrU4BHdLq3DJnPaIWnqii3XHLmdj0z8KVjd/JIHo23PcyokwooQoo1hdGNcYTuLcTX4Afld7D36tPcs5KGMPFIyiiFuC8LS08kAfi8xPFbhufMFXZ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1BVoKknxcH5J47QjwMykp+fCCRd03Mq2lvxpcDCzLc=;
 b=g3G1xZ48Z/L6b07GgDTGRDJHWKieyEEkFjyLegu6juU4qM+Qcz8jeJaYA1RrmQL/6bP+Eu0ZQKhCIakz2NA/qYXvSIQCMmTURJ1g36Z36iZ1QX3zU3fBitUmmzcSUKaGv1viHQ3UJotewNO4wR1fR45ouhQWDewUMsst3bEKtpKsqPZgZQoX6QEWfpkYGy3Uu642B78Goeoh7lrD1lhp42UonmOGCTK1rwab471Wl1YK4ORnUIBP4sWVSoYLIIzE36DODVO99T3mH7uXaSZzWNwIoRS26vAigEvqgpWuW+bwNTGz/jCi5qYhUI7Xc3gs16yfkz9EgawnKqAKgYc3jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB7081.namprd12.prod.outlook.com (2603:10b6:a03:4ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Thu, 1 Sep
 2022 23:17:00 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.012; Thu, 1 Sep 2022
 23:16:59 +0000
Date:   Thu, 1 Sep 2022 20:16:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     joao.m.martins@oracle.com, Yishai Hadas <yishaih@nvidia.com>,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V5 vfio 04/10] vfio: Add an IOVA bitmap support
Message-ID: <YxE9a8Kw5Vv3T/pz@nvidia.com>
References: <20220901093853.60194-1-yishaih@nvidia.com>
 <20220901093853.60194-5-yishaih@nvidia.com>
 <20220901124742.35648bd5.alex.williamson@redhat.com>
 <b3916258-bd64-5cc8-7cbe-f7338a96bf58@oracle.com>
 <20220901143625.4cbd3394.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901143625.4cbd3394.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:208:2d::48) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29e877f4-f112-44ec-390d-08da8c701243
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7081:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UOgMbbha0BxptEkIrehtlzRUv2jyslEUosXEIQSPCLAqu+Nc2emcMqX9cuSiWTJiX+3z97U3vXAlH4P8FzkY+rsb2CNIJ/GadGc4OH88get2Pyuy2FgIJBHsMp+EcHGJ2WcQFS9XMmey0hUR+3wulHPbt+B1XoinBN5ZupqOuGJFoA+b4LrGH6uFM2T2JO+n0IlI4QKIl+D0sm7cN1b1HorZCVnA5WPnVLc/IZEK57Jer3LpKhjiAkAa3KISh93TdUN3CylbGoDYESNm+5sfGr4yS+o/oXP2u5Q1mQYklpiqKoBrdNGkfzakHegShoOBIrnRO7zSJH9594FqC7xgoJPWLFP5XoiDmCLHbnjyUhyni0kKDDXDTnheQMp1NykGJqwsIT7pC6SzOEyW3olWQRzfU85U7XVkr/MU2BeiAxUbEr91IqR+jq9E6pvPbs+JOww+zO5CExRSCODQ7TktTS5cZjAGV1xIC6Xkile1qnjB3bqIGkJoYpxKLAbOp+5zOB4qNcPKDwR3FhKXmxMgEZNFOsRTkSrbi520OPKeuDY+WNL7NuNHHtqNjC6Z4UpOuoFJ6zNxmCiRXK5Pkhiw3U9EE2RA+6ECGcOFecIq/4nucucg+SBD2r1HTBXJ6d4CsgDagWGAcvVvBiQi7tExRFZsN1muzA26GR5/0GHIQCNQeyF6W0QXq+YnxjkihQC7uBsH0nX0ZJyR343sWcwHGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(86362001)(36756003)(83380400001)(6506007)(2616005)(186003)(41300700001)(26005)(6512007)(6916009)(66476007)(316002)(4326008)(8676002)(66556008)(478600001)(66946007)(6486002)(5660300002)(2906002)(4744005)(38100700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LTGl2m2GjlMS+qymY4ic0XGPy2Te7OipGSscTP3O24gMYpT+WScvbbUbm0Wa?=
 =?us-ascii?Q?+ydEcw2791A+OUTDJU+ROgDU2jPIUJ/kkg+jhH6S9ymIGGGhiACkX6Jk9bHa?=
 =?us-ascii?Q?5LG/PAysnC5z8VCtvRNmhnQxRq9OHiK8a7KWUq7ZPR9DTXEJGuvgyYWpyF1P?=
 =?us-ascii?Q?Z5lpngeV5ZUFxuGXywFwKdHFco6/aD/JBk9HZKSjR7M640YJOBdZQXkmDJ2d?=
 =?us-ascii?Q?qvNbs8QogU4rHS5FCm+/CO1w7DTrlGnrbhyGKu0EuWafYTw4iCmdALN+aMw5?=
 =?us-ascii?Q?I+RY1UoOEtDvp56r0MSzhLS2kORJ1kmpQCZrVOXTa+QvIPLbWUOjuDZzeowi?=
 =?us-ascii?Q?RXmhJfLdUkG1zTn7KayXNcU+8Jbi9XVHhzg2/aRvaxtx2AuFz0OtfiLX67Qt?=
 =?us-ascii?Q?ZR/mtiv1wjg2kSNHiRTMiGXqK+kHckKpyuRLdYOZWtbHHP6O4TxY3rb9OR5g?=
 =?us-ascii?Q?AiqZABmcUyhqExPwmpETWcrh7fh3tePc3SMDOrPS02e/hlZG/8ugxTgyvKjr?=
 =?us-ascii?Q?iqRn/c7Kt1lmDYK23ciCVFg0IHcEGrDLe8cs0UTTBtHPSISZiSk+/3VQVP+4?=
 =?us-ascii?Q?Q7A6BDxtwgB7v5Y3051q/2uXBq3xjUKLHy2GPco9IGHbTG6qxPM6PPYG2F69?=
 =?us-ascii?Q?8fVigXFlOgr3tlfaKTxc3MQzEvscLZpMlG6ng01xL2PJW9RzY52bJ8LrU34I?=
 =?us-ascii?Q?fN73FtfdFOPCB2oKQp62AVkqMYVeDMWJ85pEK20Yti9ZWOp/OHEZmeq/1k9N?=
 =?us-ascii?Q?Ofv9JMKx8zzDiUeFQC8DvWtVOlwXUGMMB4Jd1GLtOEYEPZ4uT6ZVsbIxPNrL?=
 =?us-ascii?Q?TjEEpKsUNjchMLjFI3vq0z6/IXq8Ygb8MY3nIa6PQ/YfX9PRPU99mRM53SLT?=
 =?us-ascii?Q?BrqPvdK04AE26xxh2FhNv/wBulqO1nMPrcL9FBctbU1/Guj5zwxI6SRXp57M?=
 =?us-ascii?Q?Jnh2aOb1qltYxQXutih2dNxlhSxyNZclrrYWrOom911YCz/h39CMspxWR9xj?=
 =?us-ascii?Q?Htev9wdxQilUEZursq7Rb4j+m8QgpRjwqPcyZCg70HrLq4lQ9IZ9BQ3sxGhI?=
 =?us-ascii?Q?GxYaV/JEpNaJkXbPBpE1Wwo5nFuopw4XtfbEw0vrZ2SHm/XnLS8nzg19iTea?=
 =?us-ascii?Q?d13YICvudC/1KkkvLTevSpjJdOGJzF2IByHDQd7k9I6zSZoDFNifqnh8Qu64?=
 =?us-ascii?Q?vgtgWkyKU93gaHGHLK/c0AckJH7d+VVASqeL1ASUBAmUmBHLnlVzOEuScQym?=
 =?us-ascii?Q?Iz3GXhqp8WRWn8nmZ4Ul9L43F8fz7acpPECc5BNAJjDuTuc2jFmqtnEImO0E?=
 =?us-ascii?Q?xL9zCCgqUdoU/Db/Ujgg0vX2DyVpdFK0rfwYKTjFx6M9QapBsK06WlUNoeIq?=
 =?us-ascii?Q?IwQ5w4y59jxGn/M+cYuHhSYPyzf56XHBGrPj+On7vBks12TyVVVAwRt/3550?=
 =?us-ascii?Q?tWE4Q4IHO0Y+LtsBc6YrfapxA6SbZsGj2EVHgHPYqp8kyXM7li8b0RDiOmxf?=
 =?us-ascii?Q?yoa+wXG/h6thfRv+KDTnrlA1TC5ceH0Wzxdig3Sg6EllpaIumg4198i06HiP?=
 =?us-ascii?Q?26WZeHwYGQP6ObiJfrJxUOjf4WeW2q+EAWHwBZAg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29e877f4-f112-44ec-390d-08da8c701243
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 23:16:59.8686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QhhZ4814ZRpegSSglE6tS9dTotUhqK0SxNk+Aet+7RgIWcNse78+dTL3Wp0o/oqC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7081
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 02:36:25PM -0600, Alex Williamson wrote:

> > Much of the bitmap helpers don't check that the offset is within the range
> > of the passed ulong array. So I followed the same thinking and the
> > caller is /provided/ with the range that the IOVA bitmap covers. The intention
> > was minimizing the number of operations given that this function sits on the
> > hot path. I can add this extra check.
> 
> Maybe Jason can quote a standard here, audit the callers vs sanitize
> the input.  It'd certainly be fair even if the test were a BUG_ON since
> it violates the defined calling conventions and we're not taking
> arbitrary input, but it could also pretty easily and quietly go into
> the weeds if we do nothing.  Thanks,

Nope, no consensus I know of

But generally people avoid sanity checks on hot paths

Linus will reject your merge request if you put a BUG_ON :)

Turn on a check if kasn is on or something if you think it is really
important?

Jason
