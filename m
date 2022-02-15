Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2A74B7244
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236038AbiBOQEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 11:04:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiBOQEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 11:04:32 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5DD624A;
        Tue, 15 Feb 2022 08:04:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lp2js/0US3EyxSB418wnv0iUBeniFWQk/xxQti24g0Z4UyJk31AZsspCHP/0K1DhJdxaysyygs6tckzh6YCGO66V4d5Nag1RzMDs4H8oNJRZh/NDOljMaRDpo9qoz2vsiDJhG4P4U3JWhW4Y0EshxW5INaCqgly5W+YsfIzlCAqUcACjBY9lOSCNRta+6LtOQb/X1vVAZ5yYOpJhm4xpWTM7qAkJ+IMCnnfidCzv713EpWl2yJlL56mqHBwV5FCG0pbWMfLDY5N8OF8qsOgM+9T8rHLmfJ9OBapZeddk2ihtRFhAmY8Lcs74F0X6ujqY0qgPSu8RQAf7MaErODvRng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsKY1jDFmA38zIvx2fZCClWnGHtCX8wp6pGlV3qbOAo=;
 b=dl59TXjDT/O+ht8OhcgOJMIx23AqkNftY+p6A9PqXI7HDpWqs9YYkGSbbSSKrzigIeskhXS/Agd3ItPvZbxACLnoYXEXk5FOL3iT1yfBGyGNWeQx+C0C84ABzgwMRgwtQDDoD+EDtZnQTn4lWeRXnudq18mLPTq6ZkvK+6FG/CGG6L4lA9npNwNoytLPvQZcmtzy+Q81cyfaZpqnWT4kqWLxPGP/IqQAnmTwT/0PUh2kn+xwFjOkrpoPDkPYiTffD77QTQ986Qlc77BTGHwRRkdGPqvputTv+p3FP2o1LDk34/2pCV1FU0QWYAKanW6r/ej3J0qjdkMvI0lI3ZhwYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsKY1jDFmA38zIvx2fZCClWnGHtCX8wp6pGlV3qbOAo=;
 b=irW73Gkruj10kAfTlYNtxTApASQzZrjc7bVNghxc9FzFTPeKC2Sc8Kkloi3rSvlSZUlo6Rlk/ly9E2iehPNVzzVo1sleYOiDD7L3oWPrMIb0ymQGspMOTZLIKQH+v4XdMltaapVlFinB77lfPnvPzea9We3b2Q5kh6+WeU6Neh7Eep/P4psDOr9AQWz74n4icfkcxAzYCENa+SoH9YzbByEY1tWkZGIK8pEJuO41VdnP+XC/R+mg6Wh7sAOI1yOwdo8KHhQSIdiI6yqQ8fITSgeTwwKUlf+wdNFwvCby+/iRAw7LqISObhIKMpGMyWltIG9Ka1eGfszAuMUTjVGgPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by BYAPR12MB3445.namprd12.prod.outlook.com (2603:10b6:a03:ac::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Tue, 15 Feb
 2022 16:04:20 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::287d:b5f6:ed76:64ba%4]) with mapi id 15.20.4975.019; Tue, 15 Feb 2022
 16:04:20 +0000
Date:   Tue, 15 Feb 2022 12:04:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V7 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220215160419.GC1046125@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-9-yishaih@nvidia.com>
 <20220208170754.01d05a1d.alex.williamson@redhat.com>
 <20220209023645.GN4160@nvidia.com>
 <BN9PR11MB5276BD03F292902A803FA0E58C349@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276BD03F292902A803FA0E58C349@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:208:d4::42) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a3464f4-ad5e-47f9-b161-08d9f09cd377
X-MS-TrafficTypeDiagnostic: BYAPR12MB3445:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB34450C331DD6E53EE706CAD6C2349@BYAPR12MB3445.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /3YwK5rZXO58g4tNxC8gZ/I9JSpD5aF3iU3Q5X6yp/lBuJcwsw75G83fcDcrTCCsyheDmJ8WcwL4AEE+WjM83p4Jk21WA1QViPBobsBPlJmUPm+6cuGx0yEk5BYjWGonKlxYf1Kcv2yOC+6KYegxvV8n4pUuN1tuQZjGq5D6/z6ocD5Ljqb0qVPO1JNn2Of8njJogorSr7kvvKRku0ITYyG6eMCffGjrOGUgtVCdlqs0cQeC8HrmeOKx2TGmrnn65Naj8YSBRiPJUAbq5Q8sWjdISpGq8VsnhzcPP5dwOkelzvKcaW22zFgrx0XQpR3bR9rKMsCZQd/vmV+EJZcZ9Vrl0dyTydlQePTXPUV6l7c35OJuLytxIRA9EiHYljd1EgnBJGR7IkOzLMgLjQJ9KI4vj1sGBKlUQBd3K6Q0sX2pEs9RlYnNgpJ2xQclgJ/fC1czCvlgdFqsXgduNLJAl4nabsiepU/N1FHOdMjLxYl5OQAaQC5QBdGzrHx4CsAnAv3Orv9tFPZM4aY3Zd60n/xrpgDNs4AMnqJuBiH72g39xShtMPQJv/pMLdc2vZWz/R50+YjwxOptVHKK55xTrkutpgFe4rJBP+ugzh9uTy2ubIHi+RmJsSiEzLXCK3+/vRRTNM7zA6YIowSDns+wVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(5660300002)(8676002)(508600001)(54906003)(6486002)(2906002)(6916009)(2616005)(26005)(186003)(1076003)(8936002)(6506007)(4326008)(66556008)(66946007)(6512007)(33656002)(86362001)(316002)(36756003)(38100700002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cp/yThN8YdGIc/nMNdeupJV5xQkggvPs0fujdDTNcB+HeBUUYG55+g+9yqZn?=
 =?us-ascii?Q?ltWov5iPPoKzH+sumOkmGbi4jInp97d/k5J8/Qp300kAijdP+bgoyka5ywDg?=
 =?us-ascii?Q?SvSOhDw4+PPiz6/LTMNMK9bvDhk7ODgC1zJvWL/qbz9dTBUNBOMPuPq4+EUX?=
 =?us-ascii?Q?t+56A2Leug/GPq1qJMQmlujLFmJnatToWOUgIXmWPPsoRAHmcNLzAiKJKwu7?=
 =?us-ascii?Q?APUDq5s4uLLLXHbYw6jyivxGk3ReHMA6aUBX1NIavsedJp0mkFU7t8BCjx1n?=
 =?us-ascii?Q?wjLtIU4cWriUKWm2rz7OAs3EgmlarOFGUYsa0XGXT5dP5EILgzMApjzvgkCg?=
 =?us-ascii?Q?cGAKg2mc2fWMQ/USg7YkA9D8Z/fcwPVSGk9DelvuOeL0XwXhzJFtZeAF6QuY?=
 =?us-ascii?Q?bfLLJsgeWFVOBRObAblAqT9hqJ0vDaHi+xBJVLX+Nvpw02y7g/4TvK7yAUU7?=
 =?us-ascii?Q?hm6aYjYlVa/EpG7egqBnMG8sujEyqKaB9UsDV1aXRONnRYUhcxd0xRkEaGuc?=
 =?us-ascii?Q?lqHGLk+jTZTJ+FhfqFq9a6gs0gXGvdYlSznNNbqAper/OJPFvRA59/NDBwWt?=
 =?us-ascii?Q?5KeJOfovs3UnQr3e8JMiXNkPCRCzZL8OSztwdTgbR2VvN9tF0izazAWUjlZq?=
 =?us-ascii?Q?zc0JSyof/CS5xBW8X3RHrHjXLvTgzaBh0+VxwrXRyZ/t5WkGe5TJw2uaoBpE?=
 =?us-ascii?Q?XRgsXwP6Dwwz0UOVNtBrIpM2+sfWTmWx2y3vj8F66DEtGboGYTYf5UUlFwcD?=
 =?us-ascii?Q?EQEiXfVSW2a9iRHvEpwdKZNUXiB0bhhadXadCVkOFfkJd00tvCvxjqMZn3jZ?=
 =?us-ascii?Q?KKRlu37fXu2t1oQ+RdUusIUtgobmf4+SEZuhxO9Ppsb+ysVPeBZtRfB2pUey?=
 =?us-ascii?Q?TuIKNhdYx8/YyLwUTWaJ0E7ivRY7dHrZP15rPnhypsuCxHADlKnClX/Mt+O5?=
 =?us-ascii?Q?sfQNlDk7VQ5+C8n6MGQB3aal1UZcYhmIVeHb58n356rF5okPUVSTnL1na973?=
 =?us-ascii?Q?4DY3f1PceQAGo/GayWSUBn2BAVQ1teAQ2KP7M4y5TRe80TlRRukzfiwHr9e3?=
 =?us-ascii?Q?wYxhQOjl53Ae/rAZMJ5Ba/T6eg5JvsP1+Uc8qB1grpW2maTh7DjrKpbaevAO?=
 =?us-ascii?Q?O3491Hkzv+sjBBdv/rVB/0LaCmzO5pwzYFRDMjxbgu83vGBEwcGlYgozoauT?=
 =?us-ascii?Q?gANnHbUzRXsHnD+UOI0tKPxITJV+Rv4/SoOD4QrTQypfDgG4SERVe2aynZ8K?=
 =?us-ascii?Q?g9NJmY+9o0p4OkYQtCHIMiNpPJbmJrKDbh817lbGKzFc0N8AZ/XE6Qh14/q5?=
 =?us-ascii?Q?VS1CKtlaqxsr/u5iEL7/EFTeKqELnA8VlTCIZFb7Xt9P9xPHgBW6r919rNAo?=
 =?us-ascii?Q?1ZrdzEp1b71tJ39V8zF4keJk8LQgJ2uMM49nF1qIw0R1Q9IdaXvuCeL66t5B?=
 =?us-ascii?Q?JUnTuvRP5vhDqO8chFOn9C07lBMam6s+YZYogDKAjsb/1s/5sz1qN6Elh3o2?=
 =?us-ascii?Q?DbYzDlk3O4XB6h/LWluChNfBc3w/6SSuizuv9QbGmfS2dO13IbAubxCK2uLL?=
 =?us-ascii?Q?dNkZrFwDFb+AJXYBgm8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3464f4-ad5e-47f9-b161-08d9f09cd377
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 16:04:20.4755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d37/kEMpRzk3QUBALPzyHU2s/DRIe+cpp9CvgoDW39adspHcSmqRz8477+Dj/usy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3445
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 10:41:56AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, February 9, 2022 10:37 AM
> > 
> > > >  /* -------- API for Type1 VFIO IOMMU -------- */
> > > >
> > > >  /**
> > >
> > > Otherwise, I'm still not sure how userspace handles the fact that it
> > > can't know how much data will be read from the device and how important
> > > that is.  There's no replacement of that feature from the v1 protocol
> > > here.
> > 
> > I'm not sure this was part of the v1 protocol either. Yes it had a
> > pending_bytes, but I don't think it was actually expected to be 100%
> > accurate. Computing this value accurately is potentially quite
> > expensive, I would prefer we not enforce this on an implementation
> > without a reason, and qemu currently doesn't make use of it.
> > 
> > The ioctl from the precopy patch is probably the best approach, I
> > think it would be fine to allow that for stop copy as well, but also
> > don't see a usage right now.
> > 
> > It is not something that needs decision now, it is very easy to detect
> > if an ioctl is supported on the data_fd at runtime to add new things
> > here when needed.
> > 
> 
> Another interesting thing (not an immediate concern on this series)
> is how to handle devices which may have long time (e.g. due to 
> draining outstanding requests, even w/o vPRI) to enter the STOP 
> state. that time is not as deterministic as pending bytes thus cannot
> be reported back to the user before the operation is actually done.

Well, it is not deterministic at all..

I suppose you have to do as Alex says and try to estimate how much
time the stop phase of migration will take and grant only the
remaining time from the SLA to the guest to finish its PRI flushing,
otherwise go back to PRE_COPY and try again later if the timer hits.

This suggests to me the right interface from the driver is some
estimate of time to enter STOP_COPY and resulting required transfer
size.

Still, I just don't see how SLAs can really be feasible with this kind
of HW that requires guest co-operation..

Jason
