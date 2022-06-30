Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF7B561BC1
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 15:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbiF3NtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 09:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbiF3Nsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 09:48:31 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D336556;
        Thu, 30 Jun 2022 06:48:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlUp7dC0La+S7socJYJHynON0EsXhjfvgWtIUPKH8em90QzbdfFuQP4k0tZtDPV5g+jDiXQFiMhEegVOWqqk8+3gz39DhXyUYcxpvOSlJ9z9itsf4xUz2MCLBeUMYE8tbuesOemxSnW4fN7FYM1JerZDnAqWAPFbRWmhF1iP12iEAeIcZwIBB0GMh8OmPA6bpsR1plJ312lsTxrlSJUwO+2NASabYxAvOwPa7ONReZgm+z4xCZERzOG9nXZp/t04qbshewiRE4DfuHGjIU6rTzVws9tiPqpgTEU2yVS54Rg3Jk4aNNLL6iALui53zBcfiOoLDaXpxCIiEtaY3bXuLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztHAXmvCJTitQ0huIxeK5rArLpUgqRGWEQHXOVVmtqM=;
 b=IXi7zXDQRdsrv6mygkUcg4PKJggCf7+OLfqx8RuCiMA/GH9c86qjZsdjUbyeWH8aMX/hjvLki+Ii2JqXsDeiClGOzZ1LHhizJgKj4r7LRHYeZhPxUxxb9Zdpy+5Q/0Qz5wVKsivISgVin4I9Du4qIReIu67hqCe7bL0rkbiT4ZfrAB94DuYjkFVcc29/XkapnzTjRh/qbomDCJfi2+f5QuB2jcY3UIL5fGrdMAfd4NLUtGcRTctRb9Wn5qmvSA/YrH2tpuMFMprjrZUcuIdtMRpxf1+spZzemmonPYYRbJK+ZcPkKqc7nWB08QrNUKrD51nkgM6ASWCrgFX1TBugIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztHAXmvCJTitQ0huIxeK5rArLpUgqRGWEQHXOVVmtqM=;
 b=ry5hWBSUBOhVHuiaFhTybTf4EFTbfJb19OoQO4AJkgla4GyGpvcMutPULgTMXSx/nnVF2xG5OjXLDtAeq434LlSgXRO1ocG72mzt8Gz09a6OFAO2d2sy9cSn/S2LJQrlMkUvejC3hKIk04iIt0W6yvcwtuWDG3veEBSIWQtC94XyUnxDemQ0wKP5xUvvcTSwMiuzkR4rYHVO00Zq5LYaokY2kBgp3tACwDxA4I9gUvOaO6M6wfJ9HN0jNltl3DKIqzDmowWIG61wfIyc8KsbBdduTu8jwB/MGSRmWQUK8NrX3B8ZWRtclxK0/4WhVLFH6DgJI4FAK+HdNxK6K0cisg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SJ0PR12MB5454.namprd12.prod.outlook.com (2603:10b6:a03:304::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 13:48:25 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5395.015; Thu, 30 Jun 2022
 13:48:25 +0000
Date:   Thu, 30 Jun 2022 10:48:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        kbuild-all@lists.01.org, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com
Subject: Re: [PATCH vfio 08/13] vfio: Introduce the DMA logging feature
 support
Message-ID: <20220630134824.GK693670@nvidia.com>
References: <20220630102545.18005-9-yishaih@nvidia.com>
 <202206302140.XlWYhlXa-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202206302140.XlWYhlXa-lkp@intel.com>
X-ClientProxiedBy: MN2PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:208:23a::9) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0dcdf5e0-ad6a-4925-dcce-08da5a9f3459
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5454:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n00hlrZ3YRJZeb6J0y3sE6PHGAhbCXpE8dQC5Wj0jfhuOZELMZMXL/HI4vzLtOpWy7RZapiVeDmCK/TY5qiiEG4/zQpqNmW4errCf9wkTT2fZMYp4TumiOgkllgXlxflf90uDvBwRnyhHu5ItEACdOB3fkIJvB6GJaMv+oViPb+ws44aroZU5iX2kBxZMF9nG60b1BKdrZ/ZHICdES8EqU6p+M0iURdqZ7YY2sQU2jrNz+hYhzi9qRY9bd2FlnEFP0jFBG8lXAzYojbal8Gs+CS+xJ3j7R5SJPevjcykr32Hg0JQl1MihJsRqloQiU1I86UFhR1nPon4MDxEEl0hrOpbSaMSlaEAO5tmCffawAgjEGluWyYut7zFnEGhe+A/oSb1X3CifUMMxvlqDJKC9jpUEQxR2ac84H5muadrv7K2kVjyA8u28EKxkhi/Pv/Hy5m6k2bcmD+obi7BVzScimctHFIc0d9DKrV1QUbwZ8RPZqWipMmPaHc8c6uR+ibGQ+yLu60uyqrrMeyNMhnEnc3KhA6Ey7hhYC4EkTLKHBcdSibsblIaM5cjzAd+Vi4VvCIogl10BpEFEbJrXGgmfYPVYoPRdrHJYRsriGlLnG+WjzybpcYlkd2Qd0e+igd7d6CyvYbsDzXT3Fn4njrusicnTrCq72znxWdohoydN2A/tlIcNlxgk/rK6AdbvsXZwfA3roeCGgEX6Tu865KEGtyZB2XORDqJQfLE35fxa41cKnnJxFAmjjqQC6pNNYgJSR2JcTM2nPGIz8sdZwFm4R1Un9JaA/9gOqQKfvj/E0HaPbq975ctvn3bV042Rc6l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(478600001)(6486002)(38100700002)(86362001)(41300700001)(6512007)(66946007)(6506007)(33656002)(26005)(36756003)(186003)(66476007)(6916009)(316002)(66556008)(2616005)(1076003)(8676002)(4744005)(8936002)(5660300002)(2906002)(4326008)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vsaBFhdsscqyteD8AO+0RnKZcm8ek32ALZ4lnq+e9tI3UYBv8ruidupH1Ufr?=
 =?us-ascii?Q?a0J3rZQYOHjfTn65B8WG4U4zXT/8c9Q1lfb/+v4U0bqKRUmStcrXRLjcVHpF?=
 =?us-ascii?Q?8j5ILTLoLBpRnzdy5o9I2fYobbbTM9DzIClqca+TQgIY8Y2wCUc7SoUiTwP6?=
 =?us-ascii?Q?DnlNbJ9CRHK2qi8K0eV/OAbDvsXdRsW/zMJMr2PQm3qezl6p3CZ/eaXAsOWt?=
 =?us-ascii?Q?9Wgz9oq6WMfc7/Udr3xu3tqr6BPhMVCqMO+LBZPXYNPcWfYKHoIz+06ZbXM4?=
 =?us-ascii?Q?eem58Udp3OQX2QyPhZzi9p63rD4m6PKCbLX+o5gShXDEp9Z5riiUZBUdt8P+?=
 =?us-ascii?Q?Kj4vpvEt4Vy0OYT3BIWIRJfdW2c/xTwEguJxZ5ifpnUYPPoUh6w4QA3Mgy+q?=
 =?us-ascii?Q?kx2hFR1ULNPYWxuhk6oqUXtxa/7RNvMw2gUo24dJy7hWKshGBYpL8sBLlNWi?=
 =?us-ascii?Q?urTgnWX8IPUBQ49gOF81vyVNxj/HVm7x4NryIn/weFqpLB3JsUROEwnYDK1z?=
 =?us-ascii?Q?U6TYpCIJsRNYRi1q7ghBXRhHsRelA3STqUDC7lFUjxlj3SPvKhbiO3h1qvuB?=
 =?us-ascii?Q?izNfkO2tEsoBO30SXypT/UcWeM00LGgAb0wexNTAGwfCvavfnkVN/oZVxfkT?=
 =?us-ascii?Q?p/VvzWEcWeVukntd0hXpRSry5Njr7Y+VMV8ELclemIr4veUkzED8DAICDyZu?=
 =?us-ascii?Q?OJeh4PQ/fs175ANnKeAZ8tXVDhdGMChle3JmR5AdPFREWRHM2XMgQwU9jXXa?=
 =?us-ascii?Q?tqDmv5GmtWWBO1qYzGsiG33U1SE6Z1DEEUH/MIOtagKGSKEGSveCG50ZRsAH?=
 =?us-ascii?Q?fmJsDZ1I/LkXjKDqFFZSM/yy3GHgUzF+IctHpnd7un7xfybSSWiON7PXzuzA?=
 =?us-ascii?Q?MuX52Y+3ECccRiWKlryBB5fF7UTMJsS8lhat7rmCDmszq8uY5A7nzCT0cCh6?=
 =?us-ascii?Q?z/rjoETJidSVK9i7jolICFCOfeO4F5CgRqzRqwfj/W+1D1Df3ExAKzGoSZQy?=
 =?us-ascii?Q?ogtLB5FgyJ0X/YC4pyUaTxFYGSSsURL16jtcHfBMYKML//BZ8aUIvOR3jADZ?=
 =?us-ascii?Q?MEJmHEC8AFX3iSiQi1sJf8si5019qDUsl4KUDuXCOg98k22fcpnxyK+XQ+51?=
 =?us-ascii?Q?iCRxCA4HtGuqKMKMl9iE6+j6GlhyKGkoburWXqI92mfiourG5oAfCtkDuUX+?=
 =?us-ascii?Q?GXFbCqbdCxzveUR2BY+Hx2qBhix/gNP/2GG4kl9boGGtWCTnWe2l+d3UWm7M?=
 =?us-ascii?Q?mJSkip5sgnyD+wcHaDsZoX/t/uKow0u7bnrde0C3B/vtron4okUboixBXxiQ?=
 =?us-ascii?Q?8/gAh0+r219cRdeTNy/kgRY0L2+i7oSk+6YpfNXtQrBjb61WmjqQruNZ+k9V?=
 =?us-ascii?Q?6V90bJrMqF95PHawd+AE934FX0iTbrtx1BEA2TQMJA/G+I3RbXCMkXIvz2zg?=
 =?us-ascii?Q?AMJFZXgzzKX+V1fteSWsm0iRE9TIlmJ+MCREVtLPEJ3MPMhFH0V8r767qElU?=
 =?us-ascii?Q?twl8paQEHHv4Hws8T0U9rngUX7PlZ1Y7yC7JifPKcs6PTu/FZs476FYC/rkj?=
 =?us-ascii?Q?GIIkqv4kXqeT+CjsZ/Ure4cxUCe7WHA5xUI+uR59?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dcdf5e0-ad6a-4925-dcce-08da5a9f3459
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 13:48:25.2044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m6OoNmXaOEDWZUw+TJwRK0eETw6xIXUazH6J5Q3uYMgbKnE8nq+fVFYOnyn2WEMS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5454
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 09:40:01PM +0800, kernel test robot wrote:

>   1636		nnodes = control.num_ranges;
>   1637		if (!nnodes || nnodes > LOG_MAX_RANGES)
>   1638			return -EINVAL;
>   1639	
> > 1640		ranges = (struct vfio_device_feature_dma_logging_range __user *)
>   1641									control.ranges;

Things like this should always use u64_to_user_ptr()

Jason
