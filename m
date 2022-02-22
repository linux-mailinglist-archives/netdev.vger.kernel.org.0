Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB8C4BFD7B
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 16:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbiBVPvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 10:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiBVPvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 10:51:15 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2075.outbound.protection.outlook.com [40.107.236.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708BE46669;
        Tue, 22 Feb 2022 07:50:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQxU+xJjMvoJCTPjIKyFMEWe9qsJNMWLjfQE9BF/BbD9yGqM8NV+SBH8fh3UKiG0CVIUp9E7Tq+MEL377oEb2n9WJ1Bt9owLyXB2mtWpqDQqDyGeMbwJheABJik7EWgFd2I6HhKk2A+8INzUmge1lBckWUJu8zz2hvGrVm3QLQ1KCRdElkO/JTx2/xYDbqsBVbJKW5ZbeSNo/NHMzXmRNHtesxNrqAJsYS3mYljPsoEc9x4KxgwonS8NyN+iNjaUxv8p2phZgU05NOIiEbO/qIqoC54o385VJFZ1TcUr5dbEZFfx+83xGxh7Mtcx3CvwqZBXAl2Q40x/ZUH38Yk2Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dV5IswyX88HlEhFXUQgGyk4u0azJWRWqC0LXCVlPxJA=;
 b=Kmp8qJaoxPzcldhl0tnxamlphbV5ly4GWAAisGPvJE5VLxCrxQNd9B7fUKadv+biJYN6BJY0ngPcEVyPBdEIJNrIAzi8twndhUjqwuCgVT6fU+UnC4nZBsKRfXmtiAx71FAmUpEfH+VK0B6ICSQc7Fz8euEAP2zO40nFg9OxBVPfqMZlb9BakX7KEnlWWSgDThGTMXV4q9ZDNC4MqnbUkwgGVqOYSKtIeUBZfc9otvg6mWMLOdzYQK+wvBW4cs12lt1Rhutefd03hHWJyp6R1P+6MD15LGHVVtfBS//PeDD8mevQMXiHAdzr302qutH2UzSh7ypGfwZ+aWbYwIHJ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dV5IswyX88HlEhFXUQgGyk4u0azJWRWqC0LXCVlPxJA=;
 b=Mv69koDSLkFAgOGmlgTjsX9s+fqjPENjrJPdFkmxldBHgd8rVJFhfqXgBRwLZCQDTS19FkO5Vsia/LqThmAGJeNkTAKSRrlEhrhfUeSWr6kk33EX0n/0hMJClvQs9K+o1BN6RYTWkvc7X8svq/71/ZhMb8TU+yHy82GXajX+YctPqjKsPz4fMZdb2btwxS0GpRG9571fyPdYpES20OWAfVSosG2uZpC8MrUuzOc7zrR1PW+iHDi0TDItLHqfUxlDvmmTLwkviiUtnFOpZXhti/kM6r0nbVWGUumdrX1uUGbmCYkYaGS/gajjapldQiFQk/pnNgtfJH7m76nwNi9lWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.22; Tue, 22 Feb
 2022 15:50:48 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 15:50:48 +0000
Date:   Tue, 22 Feb 2022 11:50:46 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH V7 mlx5-next 15/15] vfio: Extend the device migration
 protocol with PRE_COPY
Message-ID: <20220222155046.GC10061@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-16-yishaih@nvidia.com>
 <BN9PR11MB527683AAB1D4CA76EB16ACF68C379@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220218140618.GO4160@nvidia.com>
 <BN9PR11MB5276C05DBC8C5E79154891B08C3B9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276C05DBC8C5E79154891B08C3B9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:208:fc::45) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 179bacb1-fcaf-4219-8fb0-08d9f61b1838
X-MS-TrafficTypeDiagnostic: SA0PR12MB4446:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4446D1F18B556AFB358A3B22C23B9@SA0PR12MB4446.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JGtyJW0Wiqs9Dj0OrtA2eNQtzU8pdZKRoztkwxuiAU44jJrIGWZln6i0Yp/sTQB8r+nrGPuSo+RwCcPR4DNsVVmUyNTMlKvo7ij7bI+iiQvapprHdx9nU2lUrbAabRPxAsBlR9dnxBNWe4bL/AvRUEHjTqebTKwSXilFDD/aQ0zBEa5sLypnmzyyS7zIY381NqqixrrbPTo52VgCzR8aOqA+eekUWqxTtF8g7gtfuUJOOkKJnEXf3zeWBWHkhm/lvSX7Emk01YNhJxieVZ+bwOAz6LIeBMekdboGpqZHPSDROGkeuJIt3cduw41bXIBL+oaW2cCgWh9IM2F5kTWKnSPejcV+OgnNSIp8Llpq+f1FSzSwbOvVWVZ0OjO8XvQxHIIuLczyGxPfEwhVXJk4BlmuGB6tvK/XhKb7+vXLZReffP06tn4NwzrgqdSz60sAcPiTH2i4fTVK3alMJxfbjJPqXSlpS2iYK+PwblGuUeG60OMusxSMgi4F/Q++ElRGJerrmAfEAOB2w6aXo3TVU5tg5cxXD0idrkk5QdWWxXPTS8fq5OJjeAwv5fCmvKQA6RFdm8Pm1yDAVydOUg5qXCYA3jO/cPuVzrwqAP6Dx0i3BSUtvFkmkEmeLaFOO+xU0G/pjqDChsV1lNQSO/Hd6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(4326008)(6486002)(508600001)(66946007)(8676002)(66556008)(6916009)(316002)(33656002)(66476007)(6512007)(1076003)(8936002)(5660300002)(2616005)(36756003)(26005)(6506007)(86362001)(186003)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6DeHxg/KwoFY61KH0x2hFyf14lsNKGfCSHOYXI6UCKTqOo4xgxyI+vQkZciy?=
 =?us-ascii?Q?WwQ4haz69LaNlqOFAqiStWx71tUjtqDAHZxt+y7oAsURkh1YkWS4VTJ6MqGv?=
 =?us-ascii?Q?jJOneeSLNMeanuRA8LVM7lOiwXc/+V3prQA+rlJKcr03U8+g+nn2zW3Lh5ZA?=
 =?us-ascii?Q?oO9Uu5CsRUEzZsA3H4qN7pz8RLEu7+diLOshJeACQ2winV+wxrUOBXZjbFKv?=
 =?us-ascii?Q?48B9rsJptoooc30eKPUC4z4Pxe0KhDmjzlBhglnAzPYr9yOLhozXdQhzusH0?=
 =?us-ascii?Q?njvcNL6tYAVvLR6TcNeUP9KrPQr2aY8rVzKl7l80L2JnddbVPFGBHktAJW0U?=
 =?us-ascii?Q?3K+1iT/P/D9HHh2D8aQVHxhrcUwmeSsdJ2/D6arv0ppgKW4nI6sLfj81zMIY?=
 =?us-ascii?Q?CWEwiDw8luz1EDHHtLS/dBA0fxABbkbbpt6T3wU09ykHqaZL1ZkF4LRqfGUc?=
 =?us-ascii?Q?/J82LdAbVrqcFw7gGClaygW5ZjJbCEDzsIqgepy/aeO47Okx9FtnKISXmzcR?=
 =?us-ascii?Q?0WmjFF9PuI4cNut0mn9DzdHVdM1rmAirC4XuNLc0LBusFmEHDYhaviO6Lhyp?=
 =?us-ascii?Q?AeYEvbUbtpR4jPLqdQrPA7RpQZVvoOXgTA76tGW1JjjN8RZjAtnhKKDAMhf1?=
 =?us-ascii?Q?MZpDOzudGnZvNfg3vnx5dkhwyL8r5PeqXRUaRMf7Y3JAWKtsXpF4kPPFUSlK?=
 =?us-ascii?Q?S0rTMmR6/p9B9040yVRU7iT1TP6gNjDredepQkRUbpGsOxQ83QqUeitAfJ41?=
 =?us-ascii?Q?EAkI+MVP5V65pSTbuZ3At/qJcENpCt7cCBrMk+TjGv7OFxTqV/RDYgA8GNu4?=
 =?us-ascii?Q?pefJ7FlUC0gUsh1WlcBZxcF5Ex7YaO2O64H0xDBDF8kIJ302x1dKJNGUZOjm?=
 =?us-ascii?Q?v7Or0+uvSnmBbBSh7m84shADf+hrEshfVAMuq35FsuFw0KUR/hWQcqLpFPZ0?=
 =?us-ascii?Q?yKgEf8HNQ0tK5FWb42sCg/hJd53KTFj7Hle+DGrbJkxvE66ifrOjNYgOm+Zk?=
 =?us-ascii?Q?WZAXa1Esm18+s/mH1AXK5u8xXASJBhuD/ORf6cpB+/go2T9udj193R9iJE9x?=
 =?us-ascii?Q?AiUBDU3/Vv9xdhnrI8bV6SNtUtix6GDKEZ/Palnxm/G5KDWmEXcN34wHRsID?=
 =?us-ascii?Q?ck6u2nID5nJpfczfUYuJhjsgbllh9r82Oe8PphL9rphDCmsauKbuGxwddMKD?=
 =?us-ascii?Q?c5ZqWfFgohbJVKxrsvcRVTChdkzFCgUkfc+wPgIOfjDMSdGoM0V0QhiAJ8lh?=
 =?us-ascii?Q?4jeHwrUXGhI84/chZ1hvWVW2P5GlC7G5B6roH+dVN/+BUgT5OgrK1+dE3gby?=
 =?us-ascii?Q?GReFFm8l+geXtvo7Id8UbTc7gVdfC7TDMTDUzyhIRx8LfW9N+EWUAkDMEIL3?=
 =?us-ascii?Q?FQ89uL6SVNvMGEAsc+HMFgTM2zUaGwbs/jnkqf47WSpcnirjTVl7XqaJSLPY?=
 =?us-ascii?Q?CniIftnhnUisC1ltd67Ubw3u+EzJIDOCuod4j2Fzm2AZSXCEcdhBdlfmu2dg?=
 =?us-ascii?Q?AcWWSnihdAHEzIOgb4tjAYnjrvsvsRsJainCL0GDW2elyvz20gBtg4d9Az6k?=
 =?us-ascii?Q?FFrJjS4JLBRkkCzDS3g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 179bacb1-fcaf-4219-8fb0-08d9f61b1838
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 15:50:48.3513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cv6Ebg2rx7pO3JP3tM6pGv2dyl6E0HKXNZETxxgFIDqOFScaQueKQ8+OGfoAif1J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 01:43:13AM +0000, Tian, Kevin wrote:

> > > > + * Drivers should attempt to return estimates so that initial_bytes +
> > > > + * dirty_bytes matches the amount of data an immediate transition to
> > > > STOP_COPY
> > > > + * will require to be streamed.
> > >
> > > I didn't understand this requirement. In an immediate transition to
> > > STOP_COPY I expect the amount of data covers the entire device
> > > state, i.e. initial_bytes. dirty_bytes are dynamic and iteratively returned
> > > then why we need set some expectation on the sum of
> > > initial+round1_dity+round2_dirty+...
> > 
> > "will require to be streamed" means additional data from this point
> > forward, not including anything already sent.
> > 
> > It turns into the estimate of how long STOP_COPY will take.
> 
> I still didn't get the 'match' part. Why should the amount of data which
> has already been sent match the additional data to be sent in STOP_COPY?

None of it is 'already been sent' the return values are always 'still
to be sent'

Jason
