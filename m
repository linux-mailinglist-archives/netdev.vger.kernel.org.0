Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E275051B0FE
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378868AbiEDVhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378702AbiEDVhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:37:10 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9B452B10;
        Wed,  4 May 2022 14:33:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnXBJ6ZSwdntlzCf6VNoJX16z5I3bJcFO0lJpU9lx6/FEm5eRnx7ECYoEjUrZBKPtAooW7FgV1hlGH0vS9CTI1r7cx3juyRT8wMx1MP81ncucCJzcu0bKLOFk39Mzcl5w7yg8f7nqfsajCjHHNRgxHTEiSSSRSQ0e85YeoY+8nKMZnuZLja5HUPYcQsdKBhQIzFOg2putE7fdQTyxwLY+FVgS7nl+mjkRHTtjTij8uCBhHo90EKl/bPbaYyJPAe2DiMgrrTxrowho8N6ZU1AsnBVQUrT7meH1y9hKKyHsqqEUdMQhCfhTIVDI3TTDM29jWl5t9AjVCowkZxqm7Qa3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+jqWbxBUQWO3UK6voFzzHoWU/Vg5eHBQXG2P6JgU9DA=;
 b=Evg617uwPn/EBiStI8tpOZsSsQT+sg2LjIc9ptPZi2ii+lgy6uEN8EP9h8XceGys3n+yj+lYyRPdwqt5aC9lWB1XXrNCP7iWrp/8BKNF91u7BkHlXiGilqkNhkqWpCjnJHPSHag6a+/jpIqSBm3fQRYE/s2zbP2hU0N491l9YwsGdc4AhzmcZiahiX/C/ETxNW7ErEIc8pmsU9LoypmOK5X7HAKfv30uW4TjLAHhbD6dasmSy30VZk6tWGeoYFunhL5ymgKPvT5xmU+3cRV7JDCQUURzrFA0WMpntERrYvNfJx5ootZ9IqOgflgwLnW9hZDBxhcUklzvLo26pDg75A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+jqWbxBUQWO3UK6voFzzHoWU/Vg5eHBQXG2P6JgU9DA=;
 b=dKiKOFfYTvAHP2LyTTdBmrtOqlV+JEqGHTcU6KCxogYFyB4VOGXY3kHHWoKMY70F+fiHhDt1VT70F5dPzHuQ0z0VaIfhtS5FNAqRX34t0fRGt2OyXdzUBZE+mhVVe8cRpjgdLKzWmeI5bW1bYyw8aWCoOyHGmYGgGO9pTYNJx6X4Jv/C/eP3TPyKsSGP9q8B2YaZ3HFp5Slfsyr9vdvPHTLYHXq9b8kwhRBTtzcGt1j7Nlox7vMpc4KSNe6suOalNnkN+V3sEf6UKXMZPnAZHr1TS4E18VHL6k25mjcunkY/ST5s8DsbimIW9VFf4Prm3lZ3O9kfXQOH7sbAFnHXTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3487.namprd12.prod.outlook.com (2603:10b6:208:c7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 21:33:10 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 21:33:10 +0000
Date:   Wed, 4 May 2022 18:33:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH mlx5-next 0/5] Improve mlx5 live migration driver
Message-ID: <20220504213309.GM49344@nvidia.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
 <4295eaec-9b11-8665-d3b4-b986a65d1d47@nvidia.com>
 <20220504141919.3bb4ee76.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504141919.3bb4ee76.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P221CA0027.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::8) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0deef386-1578-4052-f4eb-08da2e15afab
X-MS-TrafficTypeDiagnostic: MN2PR12MB3487:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3487FD42AAB8B0CBA7A5737EC2C39@MN2PR12MB3487.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M9I4fcI7PI+6dqB2hvelsB7rjWs4Hm2RgGs0+UPw/eRGlFXAHCINUUXqi7nfGWd+aLab8mlo5Pke2TWQFuySTJGGu59hyPQxFVIc7v0yeYF6Z0bRq/8r9yEaTrtxrwLt2k7Fxat0FP6oDbxDqTLnF085h2szyU9LVG9RMi3oujBF7GzrIbYEI5eqi0pAlKph72m+Tl0sNgwTZmm+XH6rELNqQY/YAGN+kOVJktKW/Qu5DL6GIt3/+jhI4jG2hd7tE3PZ1WQB1MNtoVETr1dFUmA6mtNbWvtENEObJHEFLR+ZgV7Mnq5uSCB7poD1MgbgYNYJzZDEtjGj/L7/0bWbH311Uzwqg3koTU4/n6458jvmGStcOzMVu+mkkkMIgsU8rL7GIN57qk1qnhT09nP3UHxJqViqYlR5ygLHMuoX2C/095ZHfADMv57o2O6TkX3zO2HPGf0hQ4OQgHCTW4d8TEH6iWRD93uBSvfE9jwJm9qRxUxhgz/6T3715XmCx9lcQT0CJ8kDQpc8v541ywgHeJ2upliYQ6ky+HC52GV6by4W4sw0LU17N/X4R+eTr2kYzzOAIHRFFVgzLiHwnmuFQIx5TN+dTzCXXH/3hGgD/Qu1ok8yv9COfmjYg7iJvQ0bc9EbDcZMjK7md9HIxj9qew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(33656002)(6506007)(2616005)(186003)(6512007)(1076003)(86362001)(38100700002)(83380400001)(4326008)(6486002)(36756003)(316002)(6916009)(4744005)(508600001)(5660300002)(66946007)(8936002)(66476007)(66556008)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?69uIyKZxA7Y1dYtjtGnFG1uNSWE7quvEPf4i0fX1xCDEWV3GqOjSmcPg9aHH?=
 =?us-ascii?Q?vBQ/pAi/ENzjorOLMo3po7OmzuP9ViNTk9WSkIlHNjAcl5psicjhKYVrHUVu?=
 =?us-ascii?Q?SVdcFzPwnJ1C+38isXOHdWzDuRvFD8kIKbnPhEsluEbKMyPYxjvA6UqzZSA6?=
 =?us-ascii?Q?dKb0KOGc0ozC7F3WggheQ7PLkXb2cXTlOT7qMimH8Fp/8QJvDDB96HYESiiw?=
 =?us-ascii?Q?J/c1l0X7F3y+31f/iI/Bz/EPVFWIe2HygfyvE87TgcwtKiRYqKFmCFh7W1Io?=
 =?us-ascii?Q?+0y+Mx3l1XBr065rONwvA521oo/U00VqXXE4AGfOlzCqDgG3EHNRAFwcd5KC?=
 =?us-ascii?Q?P5ycMJ+vyhyLz9O4GA4Z7usGR8qelNzRWhMurwKLaSpMwwBaJ5VmyuqYLyDM?=
 =?us-ascii?Q?FCxrgyn+E7oHKSVkwQK9wSLtjej0s0jGYGs37VxXliGk3TKfSa5CS/73RlfF?=
 =?us-ascii?Q?4YVlGPkvana5kcSLH8TdbjYZIdtA9qHp2W9A9Ho1QsHRdztj4kP9az3bV/D8?=
 =?us-ascii?Q?9HTzJ/g7D1VrhOzK/VLjfEO6J0hTwwbQRywfX08zPBcjbH7tIx5CwN5wwSi5?=
 =?us-ascii?Q?jRkAC4nj8eExDdoD1bKIw4RL0oiI7CokJNHpETwD+uCcq8bWjN0N+3TMFuPC?=
 =?us-ascii?Q?FS1uxZYpVrgHUCwrBvPjIq5IoCWTPgd0fHY1Ur+q1IQ2Cbf7SDaprm7Wee+z?=
 =?us-ascii?Q?FL0zBAcV/P7IKSO+LHkwFvq47Grwi/5x9LXyPPlosiDsR2Yk4TI+CSKazvc8?=
 =?us-ascii?Q?2dBbSbH9lZlGMHOKvc2g1Y4LH8sj2p2u3cIEMEzNTbLu+3DSJwgPGiOymHLC?=
 =?us-ascii?Q?rhJFtHrVnU1gtOOWv8qCWdWiNJBcfzUvyLvmiP9Qp+2aMec2CBUeh07G8ThB?=
 =?us-ascii?Q?MhuiHZxSZRz+JV1oRzAo1WtkmzTmdHxy/dT2WZkmzJKRLe7Zg7aynaFukKhX?=
 =?us-ascii?Q?XlL6+tRfmUG/X2gUdN+YUxuGfJLdqH+uRv8v/zvxiscR7GwALLKPhhFFRKkS?=
 =?us-ascii?Q?NIiFl47n0XMmLl55UTWq9oaTRtKqCXQXzdd5JwbHcpvJ2uzsDylnG6myZ81f?=
 =?us-ascii?Q?ry2nE5WCzM5nNpNGuoFW0eze04QIR+uNWKJi3v49FLbfix5OBooaaKlitb73?=
 =?us-ascii?Q?bXtvMU0oOZ+u/6DVyyllpQcwq1SOTUcvaLvXavJb6Ja/ecGDYQj4CNDKlbyZ?=
 =?us-ascii?Q?6otKKszO2cgx2cloXX9FJ/jhgFhN6NDyYVoVn8FiDQ4u5A+X7rtusDSnSO+B?=
 =?us-ascii?Q?NG6qFlDAe3YNlWuTVHlXLXIWfRUXKRfldIA9CoB6qKDlvJAv2VS/Ms6XZHga?=
 =?us-ascii?Q?sw0WGT5QBL1o8ti/qXrI0skbePXDoO7MuxUDOXfFvMHh+Su5pDvgE06A1R4c?=
 =?us-ascii?Q?k5Ymy0p2WzZbBzPny+NcOiXn9iFGyBA0OINPyP4h14FcLO8fnX5km75fS9pG?=
 =?us-ascii?Q?gYoDaee7fjD7kAUTNPdb58B262ZKzQsNJi8dlxMtttRXhnCbapAIUbunI4i6?=
 =?us-ascii?Q?8qlAS1dclTAyAoPBZ+u25HFQm4fQ8HpuwDS6ovwi3qEMyk/gYP1OFVWV81o2?=
 =?us-ascii?Q?b+euE1OwmoH/bkJwNxCGcyeVpTLoiTdd00XlsG0zj5YTN6ABaSODuadVfI9q?=
 =?us-ascii?Q?l0Pbvxf1Ek/97nIb3KoBj3NATQHCcoeEiN6ZyfP8j1+1pavrWlou2Fty46hk?=
 =?us-ascii?Q?IOvVYizeGbZUgo9X3Q+ciwgtEm90EnXbZ+OZLnTS1OycErPUsRi6A/RwWU1I?=
 =?us-ascii?Q?UERz5jJ46A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0deef386-1578-4052-f4eb-08da2e15afab
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 21:33:10.4851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7xyN6oeIwEdZbxuAlN2oHEw9AyYBKP+VsyU1wlEJlt5bjN0cUm9JjOlrwXDTNRC2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3487
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 02:19:19PM -0600, Alex Williamson wrote:

> > This may go apparently via your tree as a PR from mlx5-next once you'll 
> > be fine with.
> 
> As Jason noted, the net/mlx5 changes seem confined to the 2nd patch,
> which has no other dependencies in this series.  Is there something
> else blocking committing that via the mlx tree and providing a branch
> for the remainder to go in through the vfio tree?  Thanks,

Our process is to not add dead code to our non-rebasing branches until
we have an ack on the consumer patches.

So you can get a PR from Leon with everything sorted out including the
VFIO bits, or you can get a PR from Leon with just the shared branch,
after you say OK.

Jason
