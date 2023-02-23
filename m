Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D73F6A0A7C
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbjBWN0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjBWN0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:26:17 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F7319F01;
        Thu, 23 Feb 2023 05:26:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHw0nkByFiCj1q3+Tcn5xRkJy01qDisxIczNwhlXGcaU4ut9ScbGx/hXiuNNPL+QJsmua2GHyNcq8gmxJYcR2C5+qzBq6UyuxWiAiRkhjdhwlUWRo/4tPqILHY4UjNR5ihUeyyt+igEw4hSsQPmI+GELIUaBsL6se7Zdly3bdiSFu57//jCTc8Ohb45J2BuL5uByer12FLQ2lq/G3g/WsGuQdywZt7pdC892pc8eNaIPOJeTZ/2H5sFHOC6Dmf7Qr0KcN3C/knk88sKFeGmNxTMbdyYMVu+6h6+GmJPdsiiLktUUcS+nDy6JrdknIovC08wbdJW2OjWZklunBYxsOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzpijwND0fyOfVIHetn0R2Nx8oQW+pRARcojRkUUbeM=;
 b=bY/uj8LpplgNdilFgSPInnc8fX3Xk+tmq2qPrvBTDDiiJlNA2j2YG+4OeWevsm0B6TbNRr8ySUG14XHxykWY7HCEjyg1VZzt3WAxz/NRIjNhuXkCqVB/qJhSH63MCiSJMGPfY26ugEH11jLqGEcEo7qjrTgCMPd8X6M+yrzOxQCH/2zkOIwEU2esMPqkmQ8y/2geHyQ2uKEcJxV/6qJAad5BRxxuOD75bVAYcI9ByZbGXOUt/AWPCojgaMNPAXmcN5pf1tKtWxhcMg7kThPBBlM34486WgTiWk4uk4hDpn+KmQOln9i/Uv00n5uZhN87RJ/e0QXbDtdXcy3Yg5aR1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzpijwND0fyOfVIHetn0R2Nx8oQW+pRARcojRkUUbeM=;
 b=FU8hbIGbVFlpRC+ybmoTFNh2aHSTwJlcywm9dFYE1cKZRti2t2Zdf4OyScgIfXA3tnsSRK1gKlCrOZChDSH32RZZZ2Qz1QJf9dLEiUmbB1EdSdHE5pjdPv9jmR+9Q1OwLqnTPyvH6/I+fwklw2EvkmbdNnM+OaeiKir4g1wcWh/aG2b/i4x1KIX31iYYBEMYw5hdjVCxR2Z70O1QImFlijEBSSZk7ilAaexo4kBhPoCNo853DNEXy8/5Jog8M4tjvHcPvJNBljl5Q6H9XvjFrviB0Esq4g9jf7uVv6RgMTFtKHuxk7dl3577Foxc0CI+9uRH2kJ6U16UwWy8sDOrcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5820.namprd12.prod.outlook.com (2603:10b6:8:64::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.21; Thu, 23 Feb 2023 13:26:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 13:26:13 +0000
Date:   Thu, 23 Feb 2023 09:26:12 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <bcreeley@amd.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v3 vfio 0/7] pds vfio driver
Message-ID: <Y/dpdJ650q/aRIO2@nvidia.com>
References: <20230219083908.40013-1-brett.creeley@amd.com>
 <Y/MTQZ53nVYMw9jI@infradead.org>
 <4220d8d7-1140-9570-3d6c-ba70c4048d98@amd.com>
 <Y/QaVdnL+URV7oAk@nvidia.com>
 <a797f017-4233-0464-45fb-0d9aeab6b4e4@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a797f017-4233-0464-45fb-0d9aeab6b4e4@amd.com>
X-ClientProxiedBy: BLAPR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:208:36e::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: 51f6b35d-3c29-4c67-9c8c-08db15a18906
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5vGb46wSlG7nDncLYaJYyxhUZRrty8c1RfzRPQcMJqHJdrQSI3qNnNO+fjYhdWrv6fnjYmrPJgtjUSdLiEhWJLmOQKI7YpLEvq2GdV0waXTSSFy3VB/niUEmYH3VcFRxoa2DomUwjTx/7abGkufBa3geRpci5S6CdydV7qQGx5ErwEEvK9j0/dW2OgQhdWEpEYgXTnSeXX/sVByD/CY0NVBCYF//36Wquz5yGOy4DgaqA3w/4sX1d0lEHY4r55WCs5AUXiJAdWTk4wvym2KgTWdAmU4armWJ+dz21WvpWmNb2eUiLHovqCRicEE1GuSW+2uRQp9A7hNCzADk7lfoQVidIiG29ADyva13EmNikq9Sv3otygKddOJiWJj9AzjDLATYsV+oJa0wTw1phBohb0v3rTNzOG6ztMYdzm9Affrqje+fzN1qkxeGZtTvlEUpZp2nlvHIDwwmwuzN8Lnj2RZEEpmT5jyn96IMLVogFzCsTLkWUNbDc/gOrQdYn9HLDGU4gFsM+KrGfU0THuttMkpx7zZcYJEadYnNkoQeVk7CpSKIT9HMi1ZMx7koH/soqtt8w/ydMFuHDuLQ/KEmwcv2gMc6H4tT3Fy57yY0cZWj98J0iSLsuHAZhbKF0gXYPxJtSo8mChUNMN9c0Pv2uQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(346002)(39860400002)(366004)(451199018)(66556008)(66476007)(66946007)(54906003)(83380400001)(8676002)(8936002)(5660300002)(316002)(6916009)(41300700001)(4326008)(6506007)(6512007)(2616005)(26005)(186003)(6486002)(478600001)(36756003)(86362001)(2906002)(38100700002)(7416002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dXFdnVO90MrkiX4wVuAGP3+4PGH+/KJ1iDLvXld2/E93XdNwEvNEx5X8iWV5?=
 =?us-ascii?Q?3pM1W+TklU075X25WPFlR4ydCwMZqyeKQcfBVXKV2B5lrpR6NdL8v/vtnc91?=
 =?us-ascii?Q?L6GqDb+MCYGnpJgecdWSaO+1pnCSnigXoOPrFK/IwCsN/ht0ZgLUQ/+UvxQS?=
 =?us-ascii?Q?CFVsD3hv2eCj8MsISA3GHhRLRPHjy7ct0QdALcf6jWiDbiQWzzweIq1sIhdo?=
 =?us-ascii?Q?iliPPmN8z0akV8hHJcHju8uVs/0/G0re/myHacSoQI7lE/Ce31ucFncabnve?=
 =?us-ascii?Q?5o3j5bM80jLqiW9dvGxONCA2m1R00Zt8sDGafMO+gYcrYkHSKPJj8+uYNBlM?=
 =?us-ascii?Q?PMR6Gxu5f5RDe9PWGCbPua9GbPTiZRKNNvjUxINTmR3jfA65bC/wej2YVUkF?=
 =?us-ascii?Q?eZgK3mVccQ0IYik5uOFcE/bbCM9RDjZbEZENf5gWEp1iCdygfgPQAFUwax7o?=
 =?us-ascii?Q?yQPM7NO+oWruMY0GSKavj1Vp9DFPOuoye9NxcTFblsrp/GyUhYo/CXSEqjXr?=
 =?us-ascii?Q?elCGpfYOohffkQJqyNEMsyrkwxVzmN4kalTN/UDEaqKeSyNbKHIPJ0Wu3gRu?=
 =?us-ascii?Q?psc5P1DnyZfdDbLA50U6u9+FNc4HRzFPGgfKUc5GRsQFXVuEBUSFegLmWeEl?=
 =?us-ascii?Q?t6TRMdofgNvCSuIDjvC0J4iW1BfiU9JJ4f8ahRLtX9nX6ocxrlW4G1aUEpWa?=
 =?us-ascii?Q?MExThloAYp7CKeDexFcHSWkkQo8Hu5zLkdgZ6bONnqSRQ9X5rMCM4dYyyU+L?=
 =?us-ascii?Q?BLKAiimH/P4oHnS+h6V3AmcLTjIegMynoY+Qz3UihQxT4WRKChq2CJL82ruG?=
 =?us-ascii?Q?BAkYirvcVGZYJ66/1kJGv9su9oUQa9dwMhi5C6Sdphi5w18EdjS2vDQZnrCT?=
 =?us-ascii?Q?itxw+T7i3ax2t9YQj1+38qQVrM3G0YBLNqyeRzaDdZkzOhlpGnEWkpaTVrWz?=
 =?us-ascii?Q?i5noytCElI0ctMrK9Ia+9eo5Q1CUdtYK1uPfZMqT4jUJNI1oVaGJOuos5+qQ?=
 =?us-ascii?Q?UptEpG9cbKrB1gF4/YgzKMVgwjvwQs0z7syDJQa6Ho95T6yPnuhS404MCSug?=
 =?us-ascii?Q?vG+rjOXxbMV1IXzHIcT3Q4CT8FDlhpjP7q7NJC4/8Ca488+2M1Icvn/v+BU4?=
 =?us-ascii?Q?M2t+63b9JinoL6r0G3ac4hMFHygjCsUCGheniXQ8C5Okl3W5DKCTAgxtH/G/?=
 =?us-ascii?Q?g3HWoxJZ/asFRSJoOrjRYOhqCQHZH6ww8V9XV/eKEejoF+5nRev/7zZAKK/S?=
 =?us-ascii?Q?zRGijIjStpPRbCZYxiuLOnSgpUJG+GdM5FyjLf4AfeFSAHMuWmVyG6X1mpYG?=
 =?us-ascii?Q?+dwMBSTL5rGR6FwFiKNpAKgOj8O8A8tGG3fvNYnXnwIXVLA9ft09I+CGgnvY?=
 =?us-ascii?Q?Ln2Psua4u0byAUu1swaXrlvgN34yvk6rzRbtdUoQldh+C2fYcZiN1LUctX8J?=
 =?us-ascii?Q?Ep/u6hkArMNgqsYt9b3pR8E8LKigZPLghl4BXEMvW/3OwrEH7UFviDgkoagi?=
 =?us-ascii?Q?X/xXCTsOSsOH5klDAyMZWF7noIgYRQwJ+15CLigwTGQ/nOHIqi7B1gAdk/iK?=
 =?us-ascii?Q?FcFhYPGNMGERPyqaxdnN6M1dxS3Yp4rfAt0Te6fF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f6b35d-3c29-4c67-9c8c-08db15a18906
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 13:26:13.7292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VLOaO6u0rvyb1cy5tGTE8UK+e/MiTohwR2dXGY0WmXrX2eHp8BQryMNj5RPRROS/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5820
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 11:01:33PM -0800, Brett Creeley wrote:
> > You have to remove the aux bus stuff also if you want this taken
> > seriously. Either aux for all or aux for none, I don't want drivers
> 
> Can you please expand on the "aux for all or aux for none" comment? It's not
> clear what you mean here.

You shouldn't be using aux at all for this, but if you do figure out
how to make it work right then all the drivers should be moved to use
it.

Jason
