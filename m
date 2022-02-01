Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EE74A5C39
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbiBAM1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:27:37 -0500
Received: from mail-dm6nam10on2049.outbound.protection.outlook.com ([40.107.93.49]:30945
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237696AbiBAM1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 07:27:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMRqCRAhb+Sv06IWAKbyg/D+EpuVBJSfGaPBEjjH4HXmsUvAwZd1MTwT6MlmdwOPS+xcb9aHM20IcZ8ydsxkI/lGoIcZZybsjWYvkKNl/BxQ8HFzLygvSM5aJXUIsgRduvQwOD/Ll34UQlgN6AAgo/R0hVXu8uku1ziktqOEVDKb3Emk7v3uWy2UtiBgYOzAi1nL/lFwrvPP2PATXV5EX03CelHCZ7fUuTH/lGXCHFb3y7Scc+QFDe4GwXWsNATJElBwFBhkVJ0+YPETKpzIjOQSVzLJ1FjoUQDMwXFiVoOBz68cKxFelxbMoR53imzXn4NqLj/omG2ebcA1NKlXLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qg32LOJSGCZKPo5ZwJw05g87Ro0MHtDbon7+SY1vwCA=;
 b=KVb/SAdiQllj71ItXhoKIPoocuVOy720p+CHn9q14F30dH7l3rwvknimQBZUArZvM+TYvN3Xo8qdjyTk1zyqHmA3UAX6zbmP9pjaZ39R/dOuZCFqN6Tnw8JRFB2rSur/LDE+mhCi9EM3LFJaU9UIDQHSZ8/aemI45FN0uxHH71CfBZk2ehyO2KYEZ/PzrE7dsPwnyb7ZXLmjGb4aBzr3ncLgeKyd9rnoKFdnxHItIiNubf34CQkIfQ8r82z8so9Pig0f4p9+RgCYgJqPBwx4xjtG+q4QHVvzFk/vceOLoKSZzMAG6f9quTyZ6NC2N6pz55LmO29JZw+w4279dXWmtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qg32LOJSGCZKPo5ZwJw05g87Ro0MHtDbon7+SY1vwCA=;
 b=uKHkhUdgkY1/x9AAKLv9XpGk4n5ZTDKR5S00vfuAXHAZSwzqLdkYG2GFQEMsPhqXwy3e1jNOdhoMUZI1pOQ/aMnCvfTTl3jxEcYMkRSezW4ecf8DKPrCIncH/jE9zLvqsgM764rDgu68d8MSzQZY7jw27laLfYS1TDN/T+WB/J//GmtIqO+EZsXQBEYPo05YBOpxN5HNthcrmev70gOz4bevahW4GQouT16Cwjo68fhMah1ADtop9igIwftOc8KBTivo6EUY3j+6vE2QLroz0YbMXXShXiS+GwQU89DYVcgwkl7O+ruZb8UMkTwK9nPJtQkJGZBCf4Gp3rfEYQquQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4001.namprd12.prod.outlook.com (2603:10b6:a03:1ac::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Tue, 1 Feb
 2022 12:27:33 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 12:27:33 +0000
Date:   Tue, 1 Feb 2022 08:27:32 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220201122732.GD1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-9-yishaih@nvidia.com>
 <87y22uyen8.fsf@redhat.com>
 <20220201121041.GA1786498@nvidia.com>
 <87v8xyye3u.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8xyye3u.fsf@redhat.com>
X-ClientProxiedBy: MN2PR04CA0008.namprd04.prod.outlook.com
 (2603:10b6:208:d4::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26edabb2-adbb-47b8-2cb2-08d9e57e38d4
X-MS-TrafficTypeDiagnostic: BY5PR12MB4001:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4001C51C860418B9A56284F2C2269@BY5PR12MB4001.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g1rTXivt7WaI0GDJ6Ci+/0MUbE9TuMiGZfXWaXZjrN4TesJ7q1JLbWYl4/NisD97hWd1ow/lMZGbv9rtjSL6NfXsW6pQ2a/3bqv0KtuGeA2RNjTysHE5BEYihvMPuCtAxyt319RXtqNHfFoJoySdZEpOLXRaZQ42OyGvlQ6/svZ1c0Ydh0ghYAgwjtQZvY6NLJAJk/5qh3kDCg6pgQ60B/SRdy54zpi5NthQ6+u+xNCFcKW/Bbgvf6sFr4m+jXvfCn6RNMUC1mKKao1Ge2OjQeymTkGScVDyZ3NnsBNU20G8Kp88mQaJNfu7jZnDc4D8y8OQsknABEpyQ4X4kHclEEy2+s8hTbIK23D5zTEWKw8k3bCxdlWw63hiCRSNmoMmuodAApQulKx6kOamZUE7l90VvQK0YcyHGV6TYPB6teL0fWBHGgfQM3Vs5bAGL36IHFGHMeraPtpy4Qv1KaiOKiiuEKMtiz4fjyqwsJJ5664J1ACLS8oYEnYD+M7nF1/P34p9y83MK2Y2dm34FX2ZQm3A4UhrBwBBdThPQ8gMYo41TzokY04vHRYPpZEoLW/ffJYK3+6i6SkJuJ/EABzFyCJQJiTK8m0KVuQFWXl9wO4r965Xx2U3j1ka4sQz3kDRmagrEUbcWEHLaYHwijmOPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(66946007)(36756003)(86362001)(6506007)(5660300002)(6916009)(6486002)(38100700002)(508600001)(4326008)(66476007)(8676002)(66556008)(8936002)(6512007)(33656002)(1076003)(186003)(2906002)(2616005)(107886003)(83380400001)(26005)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bhZB3dU4VaA5PVatlV0ZGiL8AoglHkH3og9gNeEa0VjqDgwFkwdCtT3qZSNK?=
 =?us-ascii?Q?qf/Q3WtaFvu/2eP1nWiEP9CN8qacyXqzhl2b1ZO3KuamFi/ixo5xbFJYQoJE?=
 =?us-ascii?Q?GmoYvM1vJ7IGUPdVPtDrZhILPsd5tLd6ZTzBm988NP1cfgaP63u+/5mYQdKM?=
 =?us-ascii?Q?ezlsNF1HWQL7r7cB8g2ET9GDqwDLdA8h671zdx0yxDeEoOXxZ6Igos2pji0T?=
 =?us-ascii?Q?z4SEpVDJHsjdYWDNElG7NYGNF/wQeQab8cQgkwYDr+DV09P9Qnh/5lZL29aP?=
 =?us-ascii?Q?vxtColD+dA1mEW5Ku+L36utsJqIAO1c3DAuG1n5Z/e8j283ZA5KHs0M8A9ja?=
 =?us-ascii?Q?+3ib3Xa+nguRGcNGdm+LoAtTk4/0Y3R0WS+yxpQgnLnjyj1Al0tUKhS29YFO?=
 =?us-ascii?Q?0NUiaRZZa1rIywWVlhu1J17ik3xTCllT0pqILZI1kp83WqgYOj9ibTwVTsRL?=
 =?us-ascii?Q?HsYq02XGBDUxER6KkTUhVoVjiHRGCad3UB7l+iTsg8AaNQEaemhFfL2Se2lN?=
 =?us-ascii?Q?mAUxKwkuG2Hkj2Oj9TgtWAHX3QbFfVIxra4jW+LvP8boCKsIFPcjWWY65u4c?=
 =?us-ascii?Q?rdlbuUEumgs0yyrrh76OxAfBochDvF1aoJMYd3+r4T5nGpny9MMZ30nhovAv?=
 =?us-ascii?Q?8xSN3kpSaovIbU5fQwUlBTthzZZD8u4wSRUJXqg7GHrI5aj6asg36ySlSana?=
 =?us-ascii?Q?jWhYESjIuyiz1K9t+WNxwRov93OaIx0O442QNxjHweosg86g0tIPjmKqYA6c?=
 =?us-ascii?Q?NRi/kaHLOSUvrvOXMD75LYg/cOgr8XgpRvaaoV1lnwikksLREq/0ub0og37p?=
 =?us-ascii?Q?jg56ZN1gdy9GcOg6ox+pHv55JpbxKCivrK448Nm1XUL87UtOFZ4oDgMnFo1Z?=
 =?us-ascii?Q?bJCaW7vDapDoOBbKejH9MNYt5SNTvmSadSoKicaTGWtSpXUuvkzSjJW22Y/5?=
 =?us-ascii?Q?lM+dd8i+J2qcoFQMWLtw11ulO06JRjEdOK1e99ZxKIfDSWJJXjdUi3kZXenU?=
 =?us-ascii?Q?kdsmdXcQUeoRDjrYMbUlC34Tcg/lMcQub6RMnXGcOrOXT6W/HmYqqpqMHjvi?=
 =?us-ascii?Q?dGuf0yeXSRNAo2mIVg+SjWkeDez4aM5U/LxPGQZ9HxmGHuqkAbH7eQmJ1Jvm?=
 =?us-ascii?Q?EvNg2xX+Jv3zC1c+YkVmtHix/9EZmM0XKasZhpgAG2BSZl+sem6QkR5WIUdj?=
 =?us-ascii?Q?3pS42LwRuovcw94BTCff5K4lOLgxkvKrQAdK5tJwIHaO5VCuKeX2lwB0k5jr?=
 =?us-ascii?Q?qPMwZjN3e82A+wMoNdeqFdpEPVRF4d37s+sJ1BAxIb6x2/fUam2Qb98UJJ6S?=
 =?us-ascii?Q?F5PwB14lo6Fm/qR6tFwWDDxhC94m6/Lf9b52znueVd/0sBmhP8DtkIWiA+v3?=
 =?us-ascii?Q?wKXnY12F+cf9mk88xHO6QCbDiRB5ApXRTFABHWgRiYuGl9eIsABDfS3kdgMc?=
 =?us-ascii?Q?ndOu8yI626KywnpR3NM4GNiIHGiSnKmI/Jd0siYi+3Se7YLN5xcbQ3+dqPhY?=
 =?us-ascii?Q?A98yOWd/wuCrHAYGvSgsx/w7FsX83rYBr2KHiZA/OdOZwU9h4lPv4iWppluY?=
 =?us-ascii?Q?vF9wmoO4I+xtNPQ88SQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26edabb2-adbb-47b8-2cb2-08d9e57e38d4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 12:27:33.3111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gHpVlzTuBcXdopf2at7lXOHTHrhLU5oOgHIQsDlb/2GztX29pC38Lr5HkEinvU3F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 01:18:29PM +0100, Cornelia Huck wrote:
> On Tue, Feb 01 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Feb 01, 2022 at 01:06:51PM +0100, Cornelia Huck wrote:
> >> On Sun, Jan 30 2022, Yishai Hadas <yishaih@nvidia.com> wrote:
> >> 
> >> > @@ -1582,6 +1760,10 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
> >> >  		return -EINVAL;
> >> >  
> >> >  	switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
> >> > +	case VFIO_DEVICE_FEATURE_MIGRATION:
> >> > +		return vfio_ioctl_device_feature_migration(
> >> > +			device, feature.flags, arg->data,
> >> > +			feature.argsz - minsz);
> >> >  	default:
> >> >  		if (unlikely(!device->ops->device_feature))
> >> >  			return -EINVAL;
> >> > @@ -1597,6 +1779,8 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
> >> >  	struct vfio_device *device = filep->private_data;
> >> >  
> >> >  	switch (cmd) {
> >> > +	case VFIO_DEVICE_MIG_SET_STATE:
> >> > +		return vfio_ioctl_mig_set_state(device, (void __user *)arg);
> >> >  	case VFIO_DEVICE_FEATURE:
> >> >  		return vfio_ioctl_device_feature(device, (void __user *)arg);
> >> >  	default:
> >> 
> >> Not really a critique of this patch, but have we considered how mediated
> >> devices will implement migration?
> >
> > Yes
> >
> >> I.e. what parts of the ops will need to be looped through the mdev
> >> ops?
> >
> > I've deleted mdev ops in every driver except the intel vgpu, once
> > Christoph's patch there is merged mdev ops will be almost gone
> > completely.
> 
> Ok, if there's nothing left to do, that's fine. (I'm assuming that the
> Intel vgpu patch is on its way in? I usually don't keep track of things
> I'm not directly involved with.)

It is awaiting some infrastructure patches Intel is working on, but
progressing slowly.

In any event, it doesn't block other mdev drivers from using the new
ops scheme, it only blocks us from deleting the core code supporting
it.

Jason 
