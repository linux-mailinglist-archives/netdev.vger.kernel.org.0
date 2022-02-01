Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FB24A5C9C
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbiBAMys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:54:48 -0500
Received: from mail-dm6nam10on2077.outbound.protection.outlook.com ([40.107.93.77]:4544
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229725AbiBAMyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 07:54:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YryBaoaB3oTUjJSg7I164lVnhz64ygxVXOoMavl/o0ir+Ml3zl4kYI/qqaQFR4px4X0BUbp4X9/LyuXDy/uK1v4eiq0C37vX8hHsvJ2pDxHicdVVPF23s2ouT/TsAa+iAIIpza2IHn06SCWnfc8N9fep7vMkFkKri2yyuuJtSAatnzBfsK67r9vk9svt/HIzldF5A80Wls+rHMhcQQqrubGuBGxDQQiuqB4t/fG+XcY6+mA9qlLcd/aEK2EC6mNmhuo9gbZFunjTXCYt4s3DjP04f1qrNNdnYrlb1H6kke05qdEbVgnOIKviWUZq8NfARedcmDmsUWZKo3hbaE1QSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qaUIseVgI8/9CqyWARRotR9FVkcKY7Cj288w18lF3Ec=;
 b=MfW7FXU4rfrXiNoAmYodQCapRrWqijYmYujr5hng46Yjn/dFo0uxQnstYzKnfV7njrHKwPGlWtO32Yk3yasy4DlWO8DMOvpWLDjF6Cm82pViAw+5lDMrfwCAmbSaapsKdq6GTfdxK2yF52kmH3P7EUx+/tlhKMDPxAC5vwg4JpvnoDzoZtkPaODEqXOJC+/QxacrCEKlCEZzrtmvgyEf4JPkW4cSydozNgN5b4Cop3686q4HuoVDcKNUMmW0JR1mQEGCtohAOcMHKpDDIhC0f1iwto5Ep6VYsjW6dxc8boMQaZtehqscdnVPz+dp5RzGm+zZw7MrNj3tR8M96qh0VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaUIseVgI8/9CqyWARRotR9FVkcKY7Cj288w18lF3Ec=;
 b=MFYqUYK2FnhFqGqzK1M1OksL6k3V9+txsnyGXrX2WkJhRh2+mW4en04+bTLQvVsjPw1XF/6zY2RgytgoB79sVpPgMfLu6vTm0VMkI9aWIUKlYMY3NE3fGYQWFBsDFIaj7Pk4dyJVff6n/X0USSYBEgxjJfeqMG40AiwkGoOe41nQZmEhmTff9d+rniHILOqY6RxkliJdlsJD3PaUPebW6aRuTjFOEczNBLHbHQC0Z3P+ClQH8gsWa6ejt1vlTSHpbLSLqfGebC5TTZiALbnYN/eX9lbFd4HihOlZUqrGKjB+6sIkJeeXtxUxXEZAI8+6vKoRdufpAI0RQHtyX94h0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR1201MB0151.namprd12.prod.outlook.com (2603:10b6:910:1e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 1 Feb
 2022 12:54:45 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 12:54:45 +0000
Date:   Tue, 1 Feb 2022 08:54:44 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 10/15] vfio: Remove migration protocol v1
Message-ID: <20220201125444.GE1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-11-yishaih@nvidia.com>
 <874k5izv8m.fsf@redhat.com>
 <20220201121325.GB1786498@nvidia.com>
 <87sft2yd50.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sft2yd50.fsf@redhat.com>
X-ClientProxiedBy: BL1P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c905e56-eb1f-4468-8a44-08d9e5820584
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0151:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB015108BF47BE215EE63FA682C2269@CY4PR1201MB0151.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Fsa21KuEkspfy6+wXEpejcqOHXRj14SseVLiRjNXfO+Fj4mF40CA3ti+HG+DJ5XnPiBnAmW2N66uQ5kTAgUY+v/MykdofTigORLX792A8xXGwbLmlsXP0qPd7KFDJyLFWsSbDk484WVSUOgcc2Q9Uarjb+aPQYT9axLcwQgIZ5/RY5LsY0q0JaXpwdUnNq42yU88rbjoEW+bA2xMtUejv9yidLU8DLccdBBWZG5FGJDDCZKj/NFv3PNOhW2SJaFVrgHgbFQLBLNJbhlntAz2Zs6vhjAsCuhdQzaD3EO0Yzdo0s/E74rMRS3zUplyocOyGGKG3riA0xGLlgsBfdUS6pEm6or6BjM5lLXA3N5dAEUM5IataqpPhmElRqB9oqnrRg21QMHpiSm0YkIyrtVNVktHl9MV4AsUzwwWPFFJ2DUnuZOedpaPBu3yQ1/5Sn+4J+yc+Ip5lXUAquafqqvDLWGTCFNqUFaRBE9SM42scffFGzgFEmpUsjK7tjXtZCUU4lZv7ATo727vsalhBGjgcS01pPy/+OR8U0ZFdy5DZgvW3dfy+26QBYfQLVA+Ekbzb9m7WgGTo9TKee181hFqQOh1pb3H5T//vJUWn16vCdxhvyx2UTi85sEAJ8jvugbsO9tNGENpvYpSg91pepLhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(8936002)(66556008)(4326008)(2906002)(86362001)(107886003)(66946007)(38100700002)(83380400001)(66476007)(6512007)(6506007)(26005)(6486002)(36756003)(33656002)(5660300002)(508600001)(316002)(186003)(1076003)(2616005)(6916009)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tFXNosLcBhCeEK3AsaF8UsLHnNRK+wHghJ8jpVwSOQYjyh8Xn8GpoOvn4YoB?=
 =?us-ascii?Q?A7oFI+LD75HtENf6dC3+nG7AE0JH0Oselau6og5K4/t82XFFbYx8TDQNHz4u?=
 =?us-ascii?Q?HUidar+f+jmC1f9t6Jg+8yCnqO1/FQRWvkwLapoiLlwtVxqGvnXkKEBI9fP/?=
 =?us-ascii?Q?bB2xKts4Q5bVgtiyLogrfAQJcLIGlbYsFXzdNw53Tz+GnHTIV/XRZ2DkHcuC?=
 =?us-ascii?Q?d4hXnSQSDz5ZrNcovZu4Jt2xdj6Hr2+5pAGfjuhMW53BMj5IddCnqFYz5leO?=
 =?us-ascii?Q?YjwGAaXxIv3UTsfzrkkCdusyGK7IEurbRrXcjq2+a3dAZueFy9/X12AONBiK?=
 =?us-ascii?Q?2/14593RwlxEluBBtS+c2rqVT6Ld3epyPLSolJFYCMYkLqJOG1cj5p1iJQtY?=
 =?us-ascii?Q?3yF0TZ47CRx5nFjfXKZCTO3Bh7XrWTfuJbz1d8AYGWQ5cYNb4q5g3A3j8bSs?=
 =?us-ascii?Q?8l4x/C+cM7JZjWDyTjY5BIHcyp8wi2jl1wDVWvy/L5z9Rp2jfZuaJBj3aK4D?=
 =?us-ascii?Q?LTz7KJuQHNVjIjasSmyEs13l8UwfAhY0CrF9trET/pbpVpFjWouvxIXhvwgE?=
 =?us-ascii?Q?RNxMfo6KMhBDUQhuSFkeGxjvQmbK3GjgB7iXVRV54RggazKNJ3gZy5X/RaEW?=
 =?us-ascii?Q?vyIeIxMFgyfn6lKlz08UdOKrYBqGbPpx2V8iVTHFhzciKcGVyHEuvfNwOTZn?=
 =?us-ascii?Q?3VD8krokKHYIBUjYjJJDJXNo7jDMgPB7bvQmhiJh4UA/sqUjYVB7ke9+R27A?=
 =?us-ascii?Q?Zl/pbBcKGIHqdYxZNVEWo0uBqmlJsiJ8ChvmSW1AIxlX0z0aYHKnmGXaNdNO?=
 =?us-ascii?Q?cqhE8yrRNYmNOrnzTxqH+jufrKaJrNRRezaJx1b0CYpOJGnzNrgBPZJPmytu?=
 =?us-ascii?Q?MrKPfqjNVgYHfw1xd9fzYAA0OzjirbNsjrLwBCKOxGTL+CUX/fg32FyVmfMt?=
 =?us-ascii?Q?u6ILUrV9ztpXHmmrQW03ZIlzKMZaDBTQquM5hYHhDhDvxzCS30ExCMtnONvW?=
 =?us-ascii?Q?7fV6oOsTLUMeh8hB7ddEDQbiB9wG/FnLKXtD2gKUmikuVk2q3mRvXAuTGz/u?=
 =?us-ascii?Q?xfoMGsUnHReKQhLw+FAUzB2uI8/MBz6o8GGuTJhNqqWNQPgGyu/zzQJrmr8R?=
 =?us-ascii?Q?Y8KWNYlQPF4/cflXHVev4lwD1724xIGpJuyCdkKdz8h0TiRZJ1SurriVFNZ0?=
 =?us-ascii?Q?BTAGdW1iy8z9P1gfmWkBq0jn6S9i30iKwNoFqf/Jicw68vYWzxRG7O+yRQOW?=
 =?us-ascii?Q?aK2Djvgb6blMcrInTqRh8tLmuL3YltNKSVuwrKA/OZ8eIb6vIzhlstZyrcPt?=
 =?us-ascii?Q?AY0lXnK9XQL5xpw6357n4EYfiQ49D2ftvcvz0RMk8Lut+vGZtipSXJc9Pehy?=
 =?us-ascii?Q?fc65evJ6URyqUxLBGaSIAbTaQlyb8iAFkwsp8m31+ioiA3fyVxhzc3SUhd9D?=
 =?us-ascii?Q?Xu0gee8mwN3Ae0+hfsVXxg3RsxRCIza+2TEhCptJ4HgeUwgrcQhK3HURrC+e?=
 =?us-ascii?Q?CCthvGzhZo/ZyAJfFeduaAA8WE9tyWgcd0hJGbSFo4d0JZ/K7KuxegyrYGQE?=
 =?us-ascii?Q?wj8toCyUe5WIM3Qhrrs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c905e56-eb1f-4468-8a44-08d9e5820584
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 12:54:45.2279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+RFg9YJWB5LLyVB/lSYFOQnj4JLy0q+G9JMsB9YPNZxTM3Zqv3H0476n6wngHUJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0151
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 01:39:23PM +0100, Cornelia Huck wrote:
> On Tue, Feb 01 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Feb 01, 2022 at 12:23:05PM +0100, Cornelia Huck wrote:
> >> On Sun, Jan 30 2022, Yishai Hadas <yishaih@nvidia.com> wrote:
> >> 
> >> > From: Jason Gunthorpe <jgg@nvidia.com>
> >> >
> >> > v1 was never implemented and is replaced by v2.
> >> >
> >> > The old uAPI definitions are removed from the header file. As per Linus's
> >> > past remarks we do not have a hard requirement to retain compilation
> >> > compatibility in uapi headers and qemu is already following Linus's
> >> > preferred model of copying the kernel headers.
> >> 
> >> If we are all in agreement that we will replace v1 with v2 (and I think
> >> we are), we probably should remove the x-enable-migration stuff in QEMU
> >> sooner rather than later, to avoid leaving a trap for the next
> >> unsuspecting person trying to update the headers.
> >
> > Once we have agreement on the kernel patch we plan to send a QEMU
> > patch making it support the v2 interface and the migration
> > non-experimental. We are also working to fixing the error paths, at
> > least least within the limitations of the current qemu design.
> 
> I'd argue that just ripping out the old interface first would be easier,
> as it does not require us to synchronize with a headers sync (and does
> not require to synchronize a headers sync with ripping it out...)

We haven't worked out the best way to organize the qemu patch series,
currently it is just one patch that updates everything together, but
that is perhaps a bit too big...

I have thought that a 3 patch series deleting the existing v1 code and
then readding it is a potential option, but we don't change
everything, just almost everything..

> > The v1 support should remain in old releases as it is being used in
> > the field "experimentally".
> 
> Of course; it would be hard to rip it out retroactively :)
> 
> But it should really be gone in QEMU 7.0.

Seems like you are arguing from both sides, we can't put the v2 in to
7.0 because Linus has not accepted it but we have to rip the v1 out
even though Linus hasn't accepted that?

We can certainly defer the kernels removal patch for a release if it
makes qemu's life easier?

> Considering adding the v2 uapi, we might get unlucky: The Linux 5.18
> merge window will likely be in mid-late March (and we cannot run a
> headers sync before the patches hit Linus' tree), while QEMU 7.0 will
> likely enter freeze in mid-late March as well. So there's a non-zero
> chance that the new uapi will need to be deferred to 7.1.

Usually in rdma land we start advancing the user side once the kernel
patches hit the kernel maintainer tree, not Linus's. I run a
non-rebasing tree so that gives a permanent git hash. It works well
enough and avoids these kinds of artificial delays.

Anyhow, it doesn't matter much for the kernel series, but the sooner
we can agree on this the better, I suppose.

Jason
