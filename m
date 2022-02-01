Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47CF4A53E7
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 01:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiBAALy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 19:11:54 -0500
Received: from mail-dm6nam11on2073.outbound.protection.outlook.com ([40.107.223.73]:12128
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230215AbiBAALx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 19:11:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMJ7V1TUvURvp+HcAA/F/gVNnwSk9bYCdzEt9Ypi9tnfuIF/XeQymSM0XJaphhLZRRlhnbnkAKzS/ktLKC35yg1aYAZRY7115sfJk/JH4V2x3r9haN2xjSDXBEPfW4mW+w37h0MfFCkeapwbWqVRhu/n+vdyVyGlhI2IH1VCKWaW4el+N19vdq1EhOIhIYj62Qrrf3LLed7qbcDvwtKX+l1cNF/SCZ7EVxFeHWwxX1eZyQo8gXk7WXvtvlah6bFZhl8I+hKtKbeSsYq3QtCHT+BZ/AjVk4Xx7elbkZz+zjyOMxilzzCyDWuiZ15lXTWvOIGXKdALrjDpjIIE01QMTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=boEGum0Z2VUpoJCSSK/oMyegBaLNtai7Wn265WWI+mE=;
 b=TlTj8jQ1MW5NVo3ADliKW/MOe2sgGZvwOgUthrWZaXX/yh1yXFRmRXtlgnK1EFoO6NyIzKIOhxtk8BAjmhfAGIv6HdfkQjFd/hG84C9Oe9rlF1Y8c8nVX0o3q6RzogJOquxJnCahkA2ikKf25eoV6VJ+VKi/Xsac07X8dFKeCxMGXhMSso6p7vG0Ll6dXbLdulzzM7cna8/4jFZIrz/hAMhrvesMpZZDuRiINqGWA5tzkvpDBtBJJpjNd7tsNiz5lHUHgA+cE65fm6rX4+0g2fbUfuBi9Xlb8qQuNcjKncA/N11kxtuuXUXR0i6wgfSs3OsqA6YmfQ0zOTfThyBvRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=boEGum0Z2VUpoJCSSK/oMyegBaLNtai7Wn265WWI+mE=;
 b=Etv7IvJl5cUZCVl2Z/r8M+VPw/1OfC5hbY6ENICmO0aSCsFe8wAIcI5f9boMYDhpmJB/CdKIp62ByX5WFIQAJz2HcrejNqBTKJy3ptLsBpm9yN6/frH0HzLzOan4o+5MZJF1QFh11GWGNEc5NZZln//mODrSfs/va0MkdrGx09JbdG1t0ErGvVuXi2gSGXb5gmU5POJA9vAr9divUos0Plbk2PwD9i+I8lrZycYRPc3y6HNpsbDHcmlAMeZPGusSFYq3x49wwLix7nHgL87mZVlQde8RWaC88H+ttsvP+D6kk16trbCaLGE2jm4yQxFzZJhuc1epZ9zKZNr6JCkvgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MW3PR12MB4361.namprd12.prod.outlook.com (2603:10b6:303:5a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Tue, 1 Feb
 2022 00:11:51 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 00:11:50 +0000
Date:   Mon, 31 Jan 2022 20:11:48 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 07/15] vfio: Have the core code decode the
 VFIO_DEVICE_FEATURE ioctl
Message-ID: <20220201001148.GY1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-8-yishaih@nvidia.com>
 <20220131164143.6c145fdb.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131164143.6c145fdb.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:208:32a::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eac45d81-2e52-4b30-b683-08d9e517715d
X-MS-TrafficTypeDiagnostic: MW3PR12MB4361:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4361C38AFE8726825D1F2F98C2269@MW3PR12MB4361.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Qw070uzFGM1dUuRfC66PDXHafyKq4lDzvgdMYqWrgv/dFeleyzezcDUQoknraHpbpE0338C+q9EpYekTX646RMiNyyfVpryeKfC3D7NhTnApjVX5vF7ESrQ3twZ1MbYlddQurj98ZF0Ev3eI11s7otjFItXG7x0f2f04J/zNFN2uVzwG4msC7ZgSp0lmtClo4TGf9bKHdS9uJVY2TAE58NP3cTwWro0qkcFZpJVehdKuV+jVoO/Qjad1SKtOmB+WSA3yqG99i5gxSucdGw+8j1EJD6CQHwGO+8hCuDaIat954QgEiRYyrBVxV6fv87fakL4Hg+K+Kr05PumuD5IT1pEmtVGhocxmu7KyQBbLGTnacFod7ihnibPgUAtFl7iyv10azTVilfA6m0e2WSocIHS0BwnaQhZDSQa9JKvgTYja6EyUGHAIh9Jg9GmHmxwgZTZGXiNQc0H8cauCj7CR8Hr4i97eHW/vyB0z9ZySCPIrp1X3z/Dd3DNZq75D3QLmYiVP4ClrR6+EilKme+7ujO9j9x3aahHQACkoPPfOjuWn+JSBBSxze1o7CGXv0pZ6KZqQcA33kKDFv/7tlRbs0/z2rfvV8ZC1S7fZ7N7uoe3FOFSUSk/IqwuR7LoUNuDtgiNbU4MzeAByFHtohbxeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8676002)(6486002)(86362001)(508600001)(8936002)(66556008)(66476007)(66946007)(38100700002)(6916009)(316002)(5660300002)(6512007)(36756003)(2616005)(107886003)(26005)(33656002)(186003)(1076003)(2906002)(6506007)(83380400001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cz0ROUK4kAetnnhD1nzBPYG28mBSiO6ldwKh7Svr16tciEH0HcvtINuhzI9R?=
 =?us-ascii?Q?RfVk76fAM1enx+IADc/3SvJ29OjClhEeKin7aEM3Bz6E+yH3z5g9Pxi0E7AT?=
 =?us-ascii?Q?Do3UnfLyqduJW2euCSgE2y+NWQSIJRCDaMsNKq6QUjLetnKc1dc456dLsTGh?=
 =?us-ascii?Q?4hO/K4EroOQSON4tOHL7EthIuAqNWRhawrJITGBBosozL+oXPatME7BQnSZT?=
 =?us-ascii?Q?TbCM+nwN6VJqnPDKVrqMbVcphRUnqIswx6Wz7MF+kjFbyxLO7x6AW07EYqzr?=
 =?us-ascii?Q?NuRZ7ebNZ8YW3LIvp8tqaOonBumqCFdDscBFBOVShbxhzpLnc2WnkgZvaYOg?=
 =?us-ascii?Q?sVM8uYsp6VNUZgMe+/kHFqOheW1uo1oGM5kPpNvNuT+b8iBljPQTasqWKHab?=
 =?us-ascii?Q?6C4nAUVE4rsmzVoUfBFYqQumUca7nyB/o3anwjSsd7DzDSkPSzCoApRYM2gs?=
 =?us-ascii?Q?BSEYMVHl/5KveNwTcZuwJYJcQksVralDkKWhIxiP2k1JAXmGTjgZyneUT1pQ?=
 =?us-ascii?Q?T1VvGm6E2bhGEbrypr+CsYTZ5MyzJ0lGH16ULcFOGnAVMjQna6ucm9t1Lfs3?=
 =?us-ascii?Q?IKVsG1a3pJ7Ylag9BjQwaxsNvMGY7Pe6w4rSqIjLJuLYogc6YuM7CadahaK+?=
 =?us-ascii?Q?DqX8XAC8mbsJVAkHeiNIlV/z8+pXE5bV8Hz4xmSNqQ8dFitTfKHGZ63aC7uv?=
 =?us-ascii?Q?dmhLz/H0aGyF0gXcEv4kWSXl2rAZOgpnNJcD46qFwv+TB9e94fBjuV+San8z?=
 =?us-ascii?Q?XZAAiSnPT+RBqsnQrQAzL1MPqQCvpu7inLEZz00rRK0J/cq40gKAibr8djXy?=
 =?us-ascii?Q?ccClaWnNvBq/fnqZEip2sPg7enaSYLXvVRMLzCL7w5s+C8s7kEkCnFlz3JbO?=
 =?us-ascii?Q?BXNhmpEVy3dx2iyxGpWs7toJqla96QOnTfZgLl/OWXFDsg+PXBq5TnTgrhzN?=
 =?us-ascii?Q?d/HoyPB1w4wlbpmkUmLna9OYAgXC7GjutLQMmYTj7r01p0dDpqai62U+Sqif?=
 =?us-ascii?Q?kDYzh8GrDpRN81sLyN9gBOgc8UDeUyz414kjvQXNov1IYYvZPUidl5thj/U/?=
 =?us-ascii?Q?fwxDaz5EBfCTDU5i72L2ImxBS8J/63+4Lj/npgsQsAWLyatFPEIJ8CpDNE7n?=
 =?us-ascii?Q?2wrRLa1tiWsNyd2wC3XqRoHbQuNDDIU+WFtbW7srShm2nWOw7tbIDbLC+26O?=
 =?us-ascii?Q?iuKVQOq19YCbxedXRE2y/i+EKf6Gwjka8v+aZ2LVpJLSAVRpcHVFXYpoyXCP?=
 =?us-ascii?Q?26nuiAY6gJ0VSdJHVP+7dxz1Jq+mFcTNKncThluTrcUCkq2/MX3gA64fvXuz?=
 =?us-ascii?Q?6VuDX5OZbG0ffmUu6MsHQbY8oiMDvpPaOi2I6IBg2todfM/mN1vzGWUrzeh2?=
 =?us-ascii?Q?SmycppBGDAUeL/RgM4iKjy+Du8OtNA7nRcc+fp11H+g2JNnca3V2yOr7uqBh?=
 =?us-ascii?Q?OLF0R3qK17OyXcQXWNHJo6TpR6W9DGxTt79L0HOVvjmyyxaeSAb6TpvRgQ2N?=
 =?us-ascii?Q?pMgkePxxNlO2l2tnz7i+lH7FPFRUs5hUgJYzbrLp/tnN4zq0HqVKf7Edhw8z?=
 =?us-ascii?Q?lppGDV1ekud3zML8E7A=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eac45d81-2e52-4b30-b683-08d9e517715d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 00:11:49.9861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IPKswFiDD5/yaThQ+kOADBcFPWjB/AZWGIHOAFMIcsaL4pBO/IowTHgvJQzPBkdC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4361
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 04:41:43PM -0700, Alex Williamson wrote:
> > +int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
> > +				void __user *arg, size_t argsz)
> > +{
> > +	struct vfio_pci_core_device *vdev =
> > +		container_of(device, struct vfio_pci_core_device, vdev);
> > +	uuid_t uuid;
> > +	int ret;
> 
> Nit, should uuid at least be scoped within the token code?  Or token
> code pushed to a separate function?

Sure, it wasn't done before, but it would be nicer,.

> > +static inline int vfio_check_feature(u32 flags, size_t argsz, u32 supported_ops,
> > +				    size_t minsz)
> > +{
> > +	if ((flags & (VFIO_DEVICE_FEATURE_GET | VFIO_DEVICE_FEATURE_SET)) &
> > +	    ~supported_ops)
> > +		return -EINVAL;
> 
> These look like cases where it would be useful for userspace debugging
> to differentiate errnos.

I tried to keep it unchanged from what it was today.

> -EOPNOTSUPP?

This would be my preference, but it would also be the first use in
vfio

> > +	if (flags & VFIO_DEVICE_FEATURE_PROBE)
> > +		return 0;
> > +	/* Without PROBE one of GET or SET must be requested */
> > +	if (!(flags & (VFIO_DEVICE_FEATURE_GET | VFIO_DEVICE_FEATURE_SET)))
> > +		return -EINVAL;
> > +	if (argsz < minsz)
> > +		return -EINVAL;
>
> -ENOSPC?

Do you want to do all of these minsz then? There are lots..

Jason
