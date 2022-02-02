Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2CE44A70A1
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344108AbiBBMWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:22:15 -0500
Received: from mail-bn8nam11on2079.outbound.protection.outlook.com ([40.107.236.79]:28455
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239210AbiBBMWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 07:22:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHDPxpRnDjWfyJT+DkMm9qewLGekp2xDZoQtjCcKlYqdAaOKRAiaKPQ4WJnJONlGLzpQct2YMu3LU7rLUNtTjMCQ80G5e9yrWP9m4scKbVKYysLWFCAM7bVeu0p0uGkzCBx9FKHnDUuvtExrASBDUL4nr8qoo5fWOnzDlQhPQ3dqjWSbVJpLyIN/I1a4AAOV6zEMKH/cULT8FEDjnBcErI+wcgk/Q3FKYsJfiy6EoBUY+QMa/Ojmn0Fq/KmhRKkUlFfzhExZHSXIt97UT2JngpDrsBxfYUk749SJfApfxTE9WWupTTd1mQWIW6inG2RSkGd/TtOT8VpD6bQyDbJJNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epySmBv6PMNevS3D7OzaABzO4HnAOGWmIARtxERxjxE=;
 b=OEIOpUITX9yUpJr1E3fsv7TQyzUsdQnPzqkZ6ZBXSkXcT2uaGRyVtC0nQS85+F5mVtDfX4MAsD/0Bg+7sQm3yxsN6+Dk4Qp7FkZ5+sGtaUxAMgGB5Ze5ublNDAnPze/hrTDophqV5bFZ0CbMJ1JFNIkxaYH2JCl4ab0kpSwmFe55RAtbH86h8FjWuJZ24i5x+CFln1ZFh7bjfEbnYSPtSbAI+JYGwmV5I/WoV1VOACaDxVQMBs0u8TKytLZ0XFbQQA7hG1m9/4TeHtfbQToLlx3H8WN93HfdFAeQ2KEeb36yIczvk7cvE1e8mGUqxFPMa4pRurnc6PXXmWZiX/1oYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epySmBv6PMNevS3D7OzaABzO4HnAOGWmIARtxERxjxE=;
 b=CjSIzV2VxhZ5epyYCducDIT6gCEjCLsFdAI/O9zbCOihCAUHyhG647TUK99FmCP77MOJ1lazYmX1xLWV2BD4BS23pKVdhcLaiWsxHQ5ctNc0pIKqjtG4jf5Kej524QJ78jkjCS/yqrRiX2n9PB1GRsLq31spPzRtIg/dpKfhIwp8JBbOprLstY9CwOHl5plz/f3gEaBqPh3GN/N7JPEhQvizJoyvcx7aAIrR0E3Ci2dl6IGOm+Pe987RWdcH5902rllybfMnHuDYkOdmb3bvUSEBbWLsBr/pUNCHHZLlFjrYx6jw0WWFfSK7F3Hge36uqoTXVN2E2Al2VaqAlJscLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3530.namprd12.prod.outlook.com (2603:10b6:5:18a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Wed, 2 Feb
 2022 12:22:12 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 12:22:12 +0000
Date:   Wed, 2 Feb 2022 08:22:10 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 10/15] vfio: Remove migration protocol v1
Message-ID: <20220202122210.GS1786498@nvidia.com>
References: <20220130160826.32449-11-yishaih@nvidia.com>
 <874k5izv8m.fsf@redhat.com>
 <20220201121325.GB1786498@nvidia.com>
 <87sft2yd50.fsf@redhat.com>
 <20220201125444.GE1786498@nvidia.com>
 <87mtjayayi.fsf@redhat.com>
 <20220201135231.GF1786498@nvidia.com>
 <87k0eey8ih.fsf@redhat.com>
 <20220201142930.GG1786498@nvidia.com>
 <878ruty01k.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878ruty01k.fsf@redhat.com>
X-ClientProxiedBy: BLAP220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 340403f0-b743-4e8d-39a8-08d9e646a3f3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3530:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3530DB631712634A8C04A8AEC2279@DM6PR12MB3530.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 52JkSpXlW/lcgf7KoBpLh8DWRHzB0sZMdZjrc7FAtdcmggXIad/GbRqHfkfIvSoqGRS7C7AL0PXW7lKJePjZQia2NLIqzRXQpx8ogmhEbbdFa+dUvcel3Kd+a8bHNKSFdsIneUnDysfHq3CIgBC3aqp68J1eb0JxBITv4Ip+7/vMFOW1K6Djyz6LtWu5VfU6DWIEF0C8Rcy0aadXDp86volJwbf1TIoSDcFDXFhPX3qkm8MDwWjUiRS73LSUAb1sLyA8uAkRJ225+nF20u/TEOBAvJ8YHZsC6vAtD7qE6iy+u+qZfNNlin1C5KLXENk9uVfRdCbjfuIBxnLrJdFudYiyEg8Ziv5oddZ+FTe42fXGs6eexET3d5TnADaDHR1cx35Yhu3XCDOtmVLv+VNKX/cDH/DYcKMbqXWUJRfZw05qMRX3qVLlmnrg9+L7NVr50DKYcedg8qggrH0meDD9H9CnDSBNQ+5sVcyq8vP8bqAFEBCHyC5MQ1w7ntqoQQv/zr0va7YZn+ntis8M3WZllhc9p57Zx7JJeO+gaEc93ZVTJYPU0qjWFwse1m2Ip0adG1LV0tIBtSLM6JFiFgsg434O50EfQs20J7LRgUDpzfQDqIpM95HvmduOppVUgHffgIW+bwOeA9I0xi2vDe8CEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(45080400002)(316002)(5660300002)(66946007)(508600001)(66476007)(6916009)(36756003)(6486002)(86362001)(38100700002)(8676002)(66556008)(8936002)(4326008)(6512007)(2906002)(33656002)(186003)(83380400001)(2616005)(1076003)(107886003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C3tBwb0/u1/RqqojPtgWv2/2xt775zmKCl0ldlLj46oUIpSRbTiFbdb52VsZ?=
 =?us-ascii?Q?pqRwwv1yG3mWtMTd7knz/Y05fUvkjmfZ/WxPjSB/VycK6cF1H6j+MTrgFx/3?=
 =?us-ascii?Q?jNBj0UOhy9+KfGqzER+HeNeXICKm63ZiUleO4bSECTBVaasUoqK0dddMn5rB?=
 =?us-ascii?Q?ombZzYVXRONfBXuQs4Pd7aWbIxFD7sEOFy4FUE1WYe6oz1rVSv0ZssorVVk1?=
 =?us-ascii?Q?QU63oT1u4Fh++BbsdPl/zEponBMNuPs86mSp3oRCxRtMf65ErR8J9oMVEUQm?=
 =?us-ascii?Q?lDtknuu9VNEYr4n22o3KCvZlZLvm3Kk2GXWRTbz1WeShPDLrEnJ4SiXSzQUx?=
 =?us-ascii?Q?i+GIKsl+GeY8P/b6esRwU5i7lFD919MjCPChBeEPFV/Me9rYiMHdN36tCnS2?=
 =?us-ascii?Q?rYpQ1eBvJA+Rv4kZZJK0W7HAvJNAF9MJaxg3cDdvFyKQObl/al3/qHCE06c7?=
 =?us-ascii?Q?UsWvULGfLBrzuRSHvrpVGgSEaoSPX9nyIZk6+DGR7i33XMkhuWqIHLZWgMyE?=
 =?us-ascii?Q?MedFbJnSMhwPyICFUF7RzpMmFG2XHbOqOSVrdhcVMjZutPf5f+6smqSuo2sE?=
 =?us-ascii?Q?Vl6LxfoaVflfSgrTAQxozeGTFSRL9w973WQ6G3bZKhrX5OhlPQsqXazdqt/S?=
 =?us-ascii?Q?OtKaRMaNmUpxJ7Bb1OJrLGxZ/LVc+QBWK0C057taEddijrJloj+GItNpvqxk?=
 =?us-ascii?Q?4pwHBz0nJnch6KKvGvMmjTXPCxP7kbiQfupM2IkiKED8Lw0zr6dTDFKKRIfy?=
 =?us-ascii?Q?7okE8oTbW1TtSQd06okNLxAaEc/hWEchyRUO/tPjPSA2gD+oDXovPQhBMhB6?=
 =?us-ascii?Q?pBGmugHyCDnPwpGtGFtSy69GDl+5YrJdFHoXOhs8MkbTdmWuT3GhF74InPzW?=
 =?us-ascii?Q?JEE3P3Nd0gRyvmYyXk8GCS4ZpOT3QofyqVNiFifSg2Np/UX9ubteWvL+Eusl?=
 =?us-ascii?Q?P833suQ2RK7tB5Yo4YriCpPCHTsmsI3Dfc7SfcuzmRIQvwfmykVmdsvq7NKj?=
 =?us-ascii?Q?3pUgyk/Yz+/iE7jGWsSdtqZPjC1fWi3JN4ozOEGtHOC+w9LbE5GZJuQ+AANo?=
 =?us-ascii?Q?iBKEHhlSrCe1QcfxaEJQTCzmUmW9dfeLoMJ+xcmaVHhzlUu5rny7Om8dz0eA?=
 =?us-ascii?Q?wRqqErXFr1cHYIZviZBm5w/E/4Bbf6EUNU2q2FoXsYWbAcuAzVDq5hpALb42?=
 =?us-ascii?Q?BP3Adh8HEyY60KbvFNINY6w8Qy0E/Q1pLXj+nI/qaKeePEn2LAEM+Pi+Y+Cc?=
 =?us-ascii?Q?xJANMud6CpLqmH/ZdX78sVXJinkEq/wBKDsvsn1V8C7/ZFcm7Douzr3OltaH?=
 =?us-ascii?Q?nkVD9wbR0A3vOQLdLWmprgcx/ZlcnL1g8lW9Qc4FPTWhFOfVou/J0lgbWPzs?=
 =?us-ascii?Q?bR9Stt+pUupwVCwh23Hht0W41EkFlkx4UCCP4gFkGa2t2PtgK9vh1QMPeYO5?=
 =?us-ascii?Q?r01qpJpeXRMBb3NgmOqtz0i0DCPFHcz/u19jwv8FDH14YIhq6JWXCFbXddRo?=
 =?us-ascii?Q?AOfwy9hzBSZ40NShAsht4sXTfUm6cb2+rwjpg+n3GPA7gqJsRiiTq7Y9oXBN?=
 =?us-ascii?Q?5p2gA0bjGeji1yugRog=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 340403f0-b743-4e8d-39a8-08d9e646a3f3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 12:22:12.4391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E70O5PD3Ja7T3sLFDnB6OAUkUJqx/QqbQBpNt1BiF0+HLGoENzajUMGIP5aSmQ5t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3530
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 12:34:31PM +0100, Cornelia Huck wrote:
> On Tue, Feb 01 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Feb 01, 2022 at 03:19:18PM +0100, Cornelia Huck wrote:
> >> - have an RFC for QEMU that contains a provisional update of the
> >>   relevant vfio headers so that we can discuss the QEMU side (and maybe
> >>   shoot down any potential problems in the uapi before they are merged
> >>   in the kernel)
> >
> > This qemu patch is linked in the cover letter.
>
> The QEMU changes need to be discussed on qemu-devel, a link to a git
> tree with work in progress only goes so far.

Of course, but we are not going to bother the qemu community until the
kernel side is settled.

> (From my quick look there, this needs to have any headers changes split
> out into a separate patch. The changes in migration.c are hard to
> review; is there any chance to split the error path cleanups from the
> interface changes?)

We can do whatever, once we figure out what it actually needs to look
like. Rip and replace might be the best option.

Jason
