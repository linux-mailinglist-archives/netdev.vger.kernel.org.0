Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739034CA7EA
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 15:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242872AbiCBOYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 09:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235384AbiCBOYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 09:24:43 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411F354FBA;
        Wed,  2 Mar 2022 06:24:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mC0WJuhHHFNzUfeDs9F37gzsIVCVWEIvxjLvjLCz0C9Pfzig1yJerq3nhqDDaq0BFHDMkSII132rwb8dtAujbh11SijdHlBgNMCP86GXD7OVVBiZKG0ZPVeNLaO/2Q6fQWke7i2pFMJRB7TMzYy2SGgEh/bQqtrpQgs28hHud4OB4N6/1jiP/z0FvgApdG+MWoPgr4U8Uu/T7Q9qc4cHbS9wDsh4R+49eyJ7uMJkn/XCFfsJFp98tYqWNWj7da5MG65SPeQn+chUh7IVZd0BuoQVSx7Yvmtp2c7ObZBw0gonnAr9xkkzpnP73kuATzHaeIZIPh2QvWbhupC5Mw/r2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=349cSiWJS3F+cDoPcJmf6lEVS/Ta8wFdyjM5tN4iIkk=;
 b=HKngKrSMRFeRKzNsi+JcXoIEVvT9vOUoe5CHQ0uy8x3KizQxvxHrMGHdu9DzqKYGm4FJg5bEhMfq4RUPW2doPEIKAHN0RyfXf/sRSyA0wckFtQHw74eefNFrDmTdiFMAiLF26tyWfCgBEoJWNz7kEEbKa5qKLPmo45JyQbgKdux4NAMk7aBtodOaZ/gQ5d99wbmqGWZENlM6XDySCcePZeMGrsZ6HsYuEsjOAK1y7CB8EWqI1JymkaZVS1pFzMS2lL50w33Jxjma/YwF9t/776FB9Njf9bwt/HNv2iKI5BgN6bSLGUYrBrzDmRD2vrqfFa1OtAEbVT2ojA9a7eozwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=349cSiWJS3F+cDoPcJmf6lEVS/Ta8wFdyjM5tN4iIkk=;
 b=aQiUBY/FAXSNGrdGazV2bKAfHwkdQhuJdNeAAlzsuqRkCm0W5HoJpNvtM1xOfFGVf7YmSGsx3DLLQjNSa9d3wAEOYkei9eAs3uBkHyyRYx2VIKcK2w9dicBNFfgtBrZLZgnss/Sc4Cwdefm4KraB8ZxVOTPN0kYdkrrDhGyGqvZ0Fog6buZQFTpsNg2sP1gFp3HqdSYs684QCDxTUCVU//mTqBwV+34ldvwCiYQ7XzcVoxOCZyemwoQPNVpA1NGqo8pya/tyS3L1EqMB0Lrsoo+oSsbQitXJYgKGCFvUJnfA8ZKb1KPR25pRHPnoQAbu7oB9nuLudjE4Q+jHj+C6YQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MW3PR12MB4442.namprd12.prod.outlook.com (2603:10b6:303:55::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 2 Mar
 2022 14:23:57 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.015; Wed, 2 Mar 2022
 14:23:57 +0000
Date:   Wed, 2 Mar 2022 10:23:55 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 08/15] vfio: Have the core code decode the
 VFIO_DEVICE_FEATURE ioctl
Message-ID: <20220302142355.GJ219866@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
 <20220224142024.147653-9-yishaih@nvidia.com>
 <87zgm8isif.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgm8isif.fsf@redhat.com>
X-ClientProxiedBy: BLAP220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ac2b276-035a-4a0d-5153-08d9fc584946
X-MS-TrafficTypeDiagnostic: MW3PR12MB4442:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4442AE3C5E9D76100FB86FF6C2039@MW3PR12MB4442.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EuJqszG5HyPihKb9Fn4ikTzdIx2qJGNLNBurD+qYO3oUcSqspk9hgyDw3iO6KrDac2S66L26Br+Nx0SqUSgczTytWGJhgL3TI8lTL7KdDD7FDK9YyZY2NYkwKlGIwkYYnSFSMrSrEjG9C/5enWUX0l2SSdg5j2IVG35wK26F85l/bX9aQdy7uxixYd1uKBLYK3cnNrZa0UQMyYQRjgEXSkLzAunG5IEJMpDHcOcn4PiCuV5YaMVgq52QEbfboTVZ7WV/xMtYhOi+KMXwy6I1wYgUJ7I71H3vhGdGMAYz7PnA0FOHG6QREzTEnXvCSrQAz477jfmNAf/WOjB4hmgO4JUQ/HNqV+yNBd8lUWV2mTxDleGYTmEXQrS4cazVr3IbbiliF5VXcoWn+9e01fkdf8yKON2PSQk+wqb7bcGbo/BgJQRuD5FnHqG30CkYMOUrVjlcwYvWHhKQcgmSqJdgJ7cqL6dG0E5syWkSQmLEF2cnTvsADRg9YvHiPPPArFjfCvqM4A6LTYf8yowSPCtM1jQaE2BHp15fJwib8DikPLQIbqvsBclf2ifQfxbhfbkKd9o0xcN5EXzxH+xgIwHMsw2O2Xd+DYMgdbf8qtGIU8te2xjPUZzgFPeAkdb36frKlA5fB7v2viNc8v+d/Z033rr29ma0X4162P0bMYkt8TjdtynQ5moxNrz1Q3dgS2hmbbMDy8VnqvU9hBbt06cKfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(6512007)(83380400001)(5660300002)(38100700002)(36756003)(26005)(186003)(33656002)(2616005)(2906002)(1076003)(4326008)(66556008)(8676002)(66946007)(86362001)(508600001)(6916009)(6486002)(316002)(8936002)(6506007)(66476007)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KQiKwUOsbLUu+8cu2TUCW8UM+bGpeJ6d4pFqc9M5Qa5miXfp2M4k2QvOCXuf?=
 =?us-ascii?Q?kQtOV+oBNdlxTRwKsZwcHzz+/xpwwWJQeUcKqAvjPglmRLYQlCxVZOjb7kbs?=
 =?us-ascii?Q?XFnhSVOqUQcNjrmkRs2M4sT62nK+DBf6zbm4wxWMAY2SELmJz0Qu7Kh7Ot3F?=
 =?us-ascii?Q?yi3KRCF3jhxq9YVDZnjkgqiv1weYgzGgNUY9f3Rk8zIjxo90Jl1zJlaUca2X?=
 =?us-ascii?Q?/Qv/IfRcpsMEpomZBEnJDJAGPxzeRI9/hp84iYrAxxdMn6rlbVyCFQu6xUWF?=
 =?us-ascii?Q?gdIHto898M9uTaSxJ28VhSF8BblFVhfkYluj3+xdBZQQ+hTv8bcUuvE6AiGO?=
 =?us-ascii?Q?2Eflnc5wU6fQOUfk3Puy6xndyWfkNJrljbd315DrvQIVhEpKPUU4163i9V0h?=
 =?us-ascii?Q?kZf/E30vxzgP4z3iZNExhTV0K7Najx6n9jx3f6VyyO7xK9o7y5ATPb+QAmZU?=
 =?us-ascii?Q?yfe5ACH2fIjpVWS4CiOFXXvv2w44eR8xyya2lGyBgU7jmJiKYzKK1s+p4EEc?=
 =?us-ascii?Q?6EvSeMWY7UAO2rS2FgZ3e8g8hAR83ns36ANJghoSU8XhCRnWfewtdw2Yj/hQ?=
 =?us-ascii?Q?5wHf/+HYiFBAWQrRZVOzaD9Dd6aYW+Kv1kK1j/0xCKH6pllwXTKX2NmWLa/0?=
 =?us-ascii?Q?jD6Vl8WfuK0ysziL6ur4z+YRoBjYnYzjp4D9+daxsETnAQN2uw8SW8YLje2K?=
 =?us-ascii?Q?LTimEMOpXJJLcKV+DkaBxtJqjK+Cbi+HJrgnp3g9op2tw5Niq7uCkOzVCbUh?=
 =?us-ascii?Q?gY5MFm8cIxfB3B1s3SGo6b376YIy9fXDIsdQJZj5FUvbtL0VkbICVDyb4A/w?=
 =?us-ascii?Q?Gn5CCNevWZ4oZxpPmb5RYjHoBN1Z21579Nx+OJ93BQarBVziMRl4g+CU7IfV?=
 =?us-ascii?Q?9L+MHZAwncwXAwEuvD2kV5cxXUqa2bphdH4nTGyxI5E7Vwt7CEb5VolBNtv3?=
 =?us-ascii?Q?XzzKQSJgREiwTYknnH6THHVQRgA+iy1tkh8P+C1Po5vEfxeWEHrXcYe1NZob?=
 =?us-ascii?Q?QSWqsX5ajFuNkMeRfj+TlUHL0PK2gJ0KopFJhZPkHMsff8M27JYFMRP0fuXs?=
 =?us-ascii?Q?+SBVdC2X5Wojkf9Bp6aho65uV8sA03iVhLUJGpJDrq07mP3BcEZxhWTJd7av?=
 =?us-ascii?Q?lEG0RKpvGaQEqk0anczCPQvuIKtEy9DLtzkNbTe3VFPeerUN/ympBfQmXK5A?=
 =?us-ascii?Q?kIHOuLGXKD3/o+331mNNzjKWu6Jxt0wxP5vB3jS7ZGSIPec0NCAyCAVDXLiM?=
 =?us-ascii?Q?NI9C8LZjRgqvfPgzlOjB9XC5pCLc4pEylteudrHDq80gDmd1waV7pAefi6cp?=
 =?us-ascii?Q?3G2m4wxdVfSDwItvzD5WakQAJPfCj5Gic1dXmw1cz9cjDQOq181KjPljHDgM?=
 =?us-ascii?Q?a0qzcDi1Dd7Cyl1a53U/CPSlOiQH2e8zRcu5hZTFFJWJdxeD35TD7Kifsvjb?=
 =?us-ascii?Q?LaBWrNbRCmF7MBCd8v+vvdGVtGNTwiFGaLAGI5nbX5Dd9vCDOqGkN5OwiEwb?=
 =?us-ascii?Q?UGVHgvs64Yx0E+e8kCdge+aP4P/A7xWO4PcaCksapOwjbqt6dnxuy/YLxhNI?=
 =?us-ascii?Q?Y+m0I0OsWTdlnv6rPWI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac2b276-035a-4a0d-5153-08d9fc584946
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 14:23:56.8333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QouPzMBNqGvHUbrDg2jQGAB6jV7Iam6cDFBCBlw40WeVoN6n7VoloPmT0cYecbQU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4442
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 11:00:08AM +0100, Cornelia Huck wrote:
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 76191d7abed1..ca69516f869d 100644
> > +++ b/include/linux/vfio.h
> > @@ -55,6 +55,7 @@ struct vfio_device {
> >   * @match: Optional device name match callback (return: 0 for no-match, >0 for
> >   *         match, -errno for abort (ex. match with insufficient or incorrect
> >   *         additional args)
> > + * @device_feature: Fill in the VFIO_DEVICE_FEATURE ioctl
> >   */
> >  struct vfio_device_ops {
> >  	char	*name;
> > @@ -69,8 +70,39 @@ struct vfio_device_ops {
> >  	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
> >  	void	(*request)(struct vfio_device *vdev, unsigned int count);
> >  	int	(*match)(struct vfio_device *vdev, char *buf);
> > +	int	(*device_feature)(struct vfio_device *device, u32 flags,
> > +				  void __user *arg, size_t argsz);
> >  };
> 
> Is the expectation that most drivers will eventually implement
> ->device_feature()?

I would say probably no, but it depends on what future features are
designed. Maybe we will make a new all-driver one someday?

> migration; mostly asking because e.g. ->match() is explicitly marked as
> "optional". As the only callback every driver implements seems to be
> ->ioctl() (if we also include the samples), "optional" or not does not
> seem to be particularly relevant anyway.

The comment could have said optional here too, but it is also clear
from the code.

Thanks,
Jason
