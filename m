Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E28A585155
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 16:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbiG2OLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 10:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiG2OLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 10:11:52 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2047.outbound.protection.outlook.com [40.107.100.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D38422EB;
        Fri, 29 Jul 2022 07:11:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7Ld+7Bj+XcY7Bvx4UwiPkv21sny1vAotbHd9Qrq3uwFLTgeW9DNzNUOvOg5UcQ6Cja39qLTstNzt41u+0aE27mu+iWWjDMBw4zta8ARcLn6qIfz3Q0wGbs3hPtM78DDc2mgjcKk2BzJxKT03NA8kbmKdgW3JeuukwP/7algJsCsGw/8PJcu+oAmh4aSkjysML9A33VaxzQkg90w8dMtiwgwfJxB885sKn+DUr0KIXXFVcfyIi6u5q0qm4P1oDTe70LKZjFdBdEGtssrvx2Q9i7SHyJtW77zQXXpyh0qPKD3wxWGQA4fjVE4aOnOSdbOcwvFZqIXI+5iUcfbQ7xgMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/trnf414VIOJEPFey+vlqR1KXVJij0e5nbogN3OsT3c=;
 b=bMXZKyNEoXCifjwt6Fkm64oFWrM1ITCKfav74gGhhx4aKaCI4ffZfIPnH4QUB4KZXMyYmWu2++He78RtXZ+bOFq9tcdRoeH0h7WBJy8Gt52JLOdfEc4Sc4V++t+6OZqdl9+G6CsXT/86biiAhkJ1cmY0/FdN0muOBR0LMqi7uhGzUHsIOjoEWwL+JuRK1Y5Gzxlvnqk837ahvPBDqbLub0pfO2q2lzAxx+svYSMq/lq+FARke1b8jb88eg+DQ+DKhYjphcPU1z/lDHGXzIseKTLiXmiNRAQUwj5wulvZLIaWbQ+sN+dMWDXlmguGuHWvdzhsDE27mdv+WfKBTqxcCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/trnf414VIOJEPFey+vlqR1KXVJij0e5nbogN3OsT3c=;
 b=UZvn30oNC8g2TYDVkVv+RGeIds2qWk/DtF7l48hXckI4kvYtSvgXx7q51qQQjpouawYO/K+xr5SYdd3iI0l7V+5q/4XB0CthIU3KwJxn2z7piXCbHUP5e/OeEYDoHeEvXKReSeyIgCAuoKw7tw5RnRrfLan7xvjfxKYmXGBZUNdHEVJ6JIz0C1oRvFdkZLHv8pZ4FX4hCAKfud2z+Xg0pzslJfmMZQNiLyK5XBvBktfzH8YNF6QfzulePyCfMqXonvH+x2FO1xtvZsl/Xytyev5MxkPg799zwsw7bZ2viQGUVLAQX1uWAvVpxJ2r/p0UjOt1uQ7R2dYhyeFNyo0l3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB5199.namprd12.prod.outlook.com (2603:10b6:5:396::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 14:11:47 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58%8]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 14:11:47 +0000
Date:   Fri, 29 Jul 2022 11:11:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Message-ID: <YuPqokHRZrA6mlRU@nvidia.com>
References: <20220714081251.240584-4-yishaih@nvidia.com>
 <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <56bd06d3-944c-18da-86ed-ae14ce5940b7@nvidia.com>
 <BN9PR11MB5276BEDFBBD53A44C1525A118C959@BN9PR11MB5276.namprd11.prod.outlook.com>
 <eab568ea-f39e-5399-6af6-0518832dfc91@nvidia.com>
 <20220726080320.798129d5.alex.williamson@redhat.com>
 <20220726150452.GE4438@nvidia.com>
 <BN9PR11MB52766B673C70439A78E16B518C969@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YuJ7vpwCPqg2l8Nq@nvidia.com>
 <BN9PR11MB52763DDCBAB61A47693B83B38C999@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52763DDCBAB61A47693B83B38C999@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0335.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::10) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 102ae539-15e0-4178-ad62-08da716c45d9
X-MS-TrafficTypeDiagnostic: DM4PR12MB5199:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KOzkWbvas18g7zq5Jal/yDDK3lCkw1ndf45SZELIwZaDJC6Sqi2RVGM12gbhHMcrnI4tLLF+Xo0nZJzD+8B7My+pOgU2qOGTj2YZuuoHz0hon4PMdUOVuowLlACIgPJjgWbZoXJxTmLAEHRZXVLAlNQxayWCslZa2UkQIs38PER5AmCAjYnlsB1zxBWzutXBB0TFmKuRhkPhe6yZDt/LetYi/SHGembduJuO9zxbeBpngSJ0SGbNc0J/K4RLfUy8c8hgKqf4jRF7FxyArmWjWSRalLWiqLIgSPO87ZuCmpn0hYIS/mCT4yfvCLMnAz0qQ/mGVpHWp12oXFXPfMf+FazIuI0TxxNSDZZq9A6Z3FiQJYGC2yaGylqkRsbxfEcsx9KIRt4mIUynqtMW2xoSB4IlKA5WQFvDq8HAnAMhE1aObcySJoQoa7269zCuyOB/wjNMFjFlEhJKoSYhJ54+dhDNcX6Fr7nC3Js+90s42OVthC+6D7g8TLfN4zvkXEwdXNZ8zZWrHvTrnUbsc9Av8fWfY3Ud5A+5yYk/aa43fTUv5ggtm2lU9SWQvHWau5ODUFVRPXb9+Y0xuXzjpEhvPWpfyKtNPVJg4mysPAPQBRI6OMt8e6xa0sUNKQ8lK8/fAy/np9pEdRmls6ImB+KleE+NI/BFvfGmAyI1Z9TplHuSxPmN8LkZiN3fXpNLcoHFZOH/a0yn6PbaPNR2c2msIl3IMpyBA9E2UFT3KMOWyONbihTWFIqKAZpaP14SR18I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(86362001)(38100700002)(478600001)(8676002)(4326008)(66556008)(8936002)(6862004)(66476007)(5660300002)(6486002)(316002)(54906003)(66946007)(186003)(83380400001)(2616005)(41300700001)(2906002)(26005)(6512007)(6506007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E2IW7ZGfWs1ZUXsay20J9Ft2pgEM7eymLwq/KtylgbZ8fSoIWCJq/DbLpDUi?=
 =?us-ascii?Q?ySmUNPh6Xg0Fx0aHB9mC9nphYiry3zQHX7n0e5vptk8S++6HaYAKcecKn+27?=
 =?us-ascii?Q?PkxaWXCHGGoRGpH6WSWbbC6jqjJx87hBDz2tkEu0U0+Ki7AyosQ9WHRVNwQM?=
 =?us-ascii?Q?HSaJfDjrXoXiYzykAP3jriKSbHg+yin3wrxGXLGyGxD5JG0G9yZF7SkUm7TT?=
 =?us-ascii?Q?1IJEIL3aGdHSMtMoq7tzy6p5uIjRDGVHizYpI8d8MEdPcVx+tmceHtWiSbbE?=
 =?us-ascii?Q?b8x+jjsBbAewarujvtXdBjHfXu+NxQiAtOcAEmn2oCUvu0bEsj5qG4MwQCsf?=
 =?us-ascii?Q?I756SAx2Yj/4X8T8KfZMwKOINEXO2nWWFNo7QwLz/BJ8Is88lX3rzVwLf6f+?=
 =?us-ascii?Q?/lxY9QwbSjfurUHn6oUWDs4BvHvzTrOElVVZ/ySs/MUGmLMGy/mxAIIJVX8Y?=
 =?us-ascii?Q?yRm7MBWjkFCtdJQd8TJO1i+AnYosIcNWxRA7X8dvXFpWYfwPj5K20AYUclNN?=
 =?us-ascii?Q?hgkBL24r5Rbga3Qyfow6tZjB+SzXyp8W61YsJ1N8keXTVdINnXPDhklB6GLJ?=
 =?us-ascii?Q?4d0Ua7OHBVMZTs4J/uzun2/gGA9UQ7kYAQLVrfWY2IO3kHZqz9FmDhp5tnwz?=
 =?us-ascii?Q?vwcfjnPRiSoOB1In/4LRJEevz4RdEwaVBAMwz4ln5AmDPzapqJrU+7FLPfy1?=
 =?us-ascii?Q?DZxX8UwE/potjbmSYvpiE1FmLfrDk8MzR34PHgYOn+wI+UanIR7m6lhAZ2VT?=
 =?us-ascii?Q?IDw1+jU3MBCCaxpieSZKqn79HxChNKpIgYa0e9hC6VFGRtxQUicx2XNPN/BC?=
 =?us-ascii?Q?lyiZOCmGh5wPKnK4fJBKaJiVTzPkO/1KN3RUmNVYkOnjdgjGU0O7NpXMCjLa?=
 =?us-ascii?Q?8E2HUw+0U/zPOWzexGErTEHwcKHBY2L+AZxjncoT0GQptDxlkuC5UfwC7cP3?=
 =?us-ascii?Q?13QczhLmbpfiBB6LO7ZpzW+D8Sb1bRFS2JxQna6/gEZ81PC2Cg4N82KxoZUe?=
 =?us-ascii?Q?YAuxLBxzHv7p2Wdrm/l+HgHMhbQSa27jjHKyiYh0eHx7Eg3Vv+peeNX8X9qL?=
 =?us-ascii?Q?fgIHhNvbm1Du71jyvBPGicHKAmlLVXlWJyWOH3SQGGJw8ivcuUGos3FjzNzh?=
 =?us-ascii?Q?/j8H6lOIoZ+gheAaZXeEvSxu6snuDJcy/qeo2wntCx5ur90I5rIFPAzXRtve?=
 =?us-ascii?Q?fHsrOfbNcYfwIT+EhjjaiLb6K4pjHgqnYz0V6nqvcyIw7uIbs0Kkw/hdfyft?=
 =?us-ascii?Q?0JA0aefuRSb45HACdZjD7tcp/VVHt2KQh9j13iT/DIFw+s8yu7fUq3CVcRbT?=
 =?us-ascii?Q?RJCdunFGY1UWYMr5rJL1JyeBa6Y/SnRDAEsvSvbghOpgE22F+kh/wa8nbMcq?=
 =?us-ascii?Q?YhvAvcbu8+0bZkw5HDy0Gi+Oth4bznFNT9NRXv+PYngZ//HritWsnwJnKyu1?=
 =?us-ascii?Q?sZxJv75z7QkYzwhctHM9SQCtoarJMyw6glgRpNSaH02vP3g2zsPIt/Vt6NU/?=
 =?us-ascii?Q?oahKHXItGOcxt2jU8UnbLTVBFU0UOP5hSWl925aTYm+nqmSOrH5lrMSyFdG9?=
 =?us-ascii?Q?lQSkmLS2LJ0/ep16pb1gT1/TGfIEeB2lBBFh7erm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 102ae539-15e0-4178-ad62-08da716c45d9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 14:11:46.9900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QpcJK3lt5j+iY4nSv0OIYoSoK6t2l6KC+n+cDz5DTfXZhlV0utFQR4MJTb1z4BHa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5199
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 03:01:51AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, July 28, 2022 8:06 PM
> > 
> > On Thu, Jul 28, 2022 at 04:05:04AM +0000, Tian, Kevin wrote:
> > 
> > > > I think this is not correct, just because we made it discoverable does
> > > > not absolve the kernel of compatibility. If we change the limit, eg to
> > > > 1, and a real userspace stops working then we still broke userspace.
> > >
> > > iiuc Alex's suggestion doesn't conflict with the 'try and fail' model.
> > > By using the reserved field of vfio_device_feature_dma_logging_control
> > > to return the limit of the specified page_size from a given tracker,
> > > the user can quickly retry and adapt to that limit if workable.
> > 
> > Again, no it can't. The marshalling limit is not the device limit and
> > it will still potentially fail. Userspace does not gain much
> > additional API certainty by knowing this internal limit.
> 
> Why cannot the tracker return device limit here?

Because it is "complicated". mlx5 doesn't really have a limit in
simple terms of the number of ranges - it has other limits based on
total span and page size.

Jason
