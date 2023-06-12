Return-Path: <netdev+bounces-10006-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E88572BA89
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:28:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D5302810B5
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1990C11198;
	Mon, 12 Jun 2023 08:28:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05970E57E
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:28:11 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41881186
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 01:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686558464; x=1718094464;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3tk4aTf+uwJadCYivP9G92a0kf3CkM7kAd47/otQbyQ=;
  b=EQehsRJZk7Uy/tZETID+FEb5pMLgM4yQaZwbK6dnu/jK3ElFqnEvXN+a
   jPxP60Cl8VxDJQgRqc7F/kPJD3u/zT4qypjvH6bRx2NO0Kg33vOnf4RGt
   U8XwSPLwKD6u98QQYqHmgJ/aMcz+n/Tr3NywQDqQJ9Y5gehdjVMKH70iR
   olezaI9PvvnXtoBmZ0d/uFzn8xFlr5d43b8ezbZv1CE1J1XZZPZIoyq3D
   NUbQIRZD11kn09PDvStvLtKsibnngocr0HyqZsRWHRtGd9bFmEUqX/ThU
   qEQYXu9qOhrghouCDqIJ1C9DSVOPxaFXb+AYDSlg9EDQhy8AJK+leTCXt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="337614601"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="337614601"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 01:27:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="714317221"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="714317221"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 12 Jun 2023 01:27:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 01:27:42 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 01:27:42 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 01:27:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQyUYNkIOUfDtKO2NmEPQFTrIn8yu5RbFr7iqtNOCangypz1RVQm3sMCundAy+Kum0vd4aF54HUBDaoM6qSuFwdj8TsHXcjrOuLMZDOvnl6dhlx31pzoUwiNi80g12WVxASQHdQRp+KQGlRxc/hrHoj9b5AwaFMPUAc1uMdBlAa0/pu7hkbC4LGzWQpupVoxz9tJyBFSoP257rvVvUUn03h5bR9tc73DfIm3Ezi37Dx0sWIKYqHJKjJK/nhHCYES0SPkUYi3GohXTIMs0qfRRDYMckk+WyEJuPdeIPt26YZvJSFqN6O65Qx5uWI5HejGn2r0eYCorOKxDY1zSZgMmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zb0FXeXKeV5rvF/DonByDvG7FcrT1VZZeUJL9liE224=;
 b=jrZIDO9QAKrFCys+Cs87LhgrwYi8r2ZxUZMVGtPkJwbUew74n6Cz7XT2EiHAmm8aTVsORb+pEXAYRozhyqXRUs2i3dBhQ3tS1iJvA+6eqisC75Fkwv0h3dpjyJhNfK/5NsgMbZ6s8z1e3O0cqTba1ml/hQAwMJ6Ht3qxackNEz0YJUBZTBXnNwdm++tdf5WK2IogZtDHdCCfVZA+qCLshymloBOaZjeR7lecjC2V6dAwfAmsBcG5aeHmPlRgkiMthqYjBI/ndAuwpcLe5Qwzbbpc4goW3/J9pqR3iCvLOlbPOJpCyuOUDiFPwj4TSbkPM3R5T+sxGtnu0pNtP5rHHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by SN7PR11MB7114.namprd11.prod.outlook.com (2603:10b6:806:299::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Mon, 12 Jun
 2023 08:27:40 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe%5]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 08:27:40 +0000
Date: Mon, 12 Jun 2023 10:24:12 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Shannon Nelson <shannon.nelson@amd.com>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
	<brett.creeley@amd.com>, <drivers@pensando.io>, Nitya Sunkad
	<nitya.sunkad@amd.com>
Subject: Re: [PATCH v2 net-next] ionic: add support for ethtool extended stat
 link_down_count
Message-ID: <ZIbWLPcM+9Ov8wnA@lincoln>
References: <20230609055016.44008-1-shannon.nelson@amd.com>
 <ZIM68vWe0nRSTkBv@lincoln>
 <c9bcdfa6-81a9-8020-8760-f6fb2d59d828@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c9bcdfa6-81a9-8020-8760-f6fb2d59d828@amd.com>
X-ClientProxiedBy: FR0P281CA0218.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::14) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|SN7PR11MB7114:EE_
X-MS-Office365-Filtering-Correlation-Id: 87c122fd-2421-4c8e-3a9e-08db6b1ee2eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xUrdZudVk+0dPQK9Fq2+Li3XXbzOv0yqk5AxHyfuDp575MiFxGNuQn3pBlwR3k0VremCEJrGTyOY8GnX8dEuIbyLOLchvln9e2U3mh1Ow9QzWpqrx9GFacNqgVVFv2TuHp2lm4Mx+UOzgVEFdMrmV6itEHJRuWQ873vlswIi07mN+ORP6KzoAgBFyJClO9Ba0xmYtq84IbN0CDaqSiTAo01+DB1XwUhAoSOmFR+cApm1lmluqxl/OiOO7dLGrRKlnXWoFJhUfiX4lCgv+DzA6roglhO6fRx1ZcRLf7w4iRI4+G8CRmqSHNGK6a74+SmtidC4nvi7aQ3h5IYaikQkKNopYxhos2pekXqKb/zwmTjlgaMZFo9bbSVL5taeiyCu2ql+kbCjIc41jyew8d2DTI1KHvY+GEBDpia3LNTLvUlpIeHQ7cFStUCtXi91ddi8dwasGwHH+hQt9DmeiWTUyMiCufcqPHL2AcTSU9tGXr5vwt2tQujhT9ezdecMyaRZE2QQj8JONa8BMLle1yEOt/srKf5vQkghcSH/IDbxaPGvFCQhd/Ai7kFIwmZEbw6BIxembzqBSwZf6nmTFbq8pui4GDi1bFhjhf+NUeMU3B0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199021)(5660300002)(83380400001)(316002)(4326008)(66556008)(44832011)(66476007)(6916009)(38100700002)(33716001)(82960400001)(66946007)(86362001)(6512007)(478600001)(6506007)(53546011)(9686003)(26005)(8936002)(8676002)(966005)(41300700001)(6666004)(6486002)(2906002)(66899021)(186003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qwT4kSbwtBd0H4Yz5iVdvBH7mKH5IL7EtRkJd397n2dD3cigYMjw8/bBe+Jk?=
 =?us-ascii?Q?gqyqTot5zb6AtmSGQWUAUfLLNz7PWxRjX5W5gDAugdlYp7zt8cuYYkVUa5EK?=
 =?us-ascii?Q?LHXkhUY3v7zLf7zxdMKF+Qyerk+PH9g2gCQ4Ay8sjfI3YuNgDddTYUfbQMzO?=
 =?us-ascii?Q?EoPizXs7S32+7aHmITKmtgj0RclzcRL3IAwZ34JLlTIoE2sfdRrexDFaD6B9?=
 =?us-ascii?Q?VVGvU5dyDQ3GMUp2G1ksr55/kJ3NRLIsx64HoPPAGF6lVZsLlWj5lC38AM3O?=
 =?us-ascii?Q?EymHa8CVX9/1Xdgz7LpZzHmxP4PDVGcn993MixG+SWvj+lI65WXvmm0QCmhm?=
 =?us-ascii?Q?4VoM43ei5xocwXsFhV7e3FGwEq31Bpib5uXpDcta69VARh5kp2BLo6foPWj6?=
 =?us-ascii?Q?y4Ijjlwwplq+vng7+5jb8Slk+hCVM0DUiFdSzd7JVmYQA3w4O2kQzuQxZXQR?=
 =?us-ascii?Q?BarzU4qgOzvBAD2TS8LdZUcNGzCbxvBjWHea/CcaJWd4wCPJ7wqcjSZ+W1Up?=
 =?us-ascii?Q?Q+n/Q+KsbtmDDVBm7EBD4V0B0NWZApgYcxZ1oRqI+apiDC7SGsQ2ZbGgyN4B?=
 =?us-ascii?Q?6KS23/5Y5RcLvSlQtikLWIew8PmJIcxHA5YP5acueOKSRopQOA6XU++s7Ys8?=
 =?us-ascii?Q?fISQ42zVrFqP5h5ia3OJQRsweT7SoBJpB8VJtSX0HTaRFXKG+rl7r6P8LNxv?=
 =?us-ascii?Q?BxPxxJgcWP6ZmCH175MP7fsEit//n211n5CzMLjy2dwBrlcBCdpCG28eXNFR?=
 =?us-ascii?Q?nDrcnijP2d9m6996/Am5lo0cMIJdc0EmJvzy0JKcMf2Ops3D+A5BkhO1M3J/?=
 =?us-ascii?Q?AhUgG6cDBKG4CgnymDDBcMHuqH3IGkyUYLqPFPErg8KuvuLJuYQyZoYubHu1?=
 =?us-ascii?Q?Son9PfjEw0faTgaN5y68XSTEg5DaOvAw1bHkdhxNF4kexphiBr2gYbYQQh+E?=
 =?us-ascii?Q?VXdGNBY7HVyhBC1quL7ZSVy+8NOkp3Rfd28LM8/kUR+jBVqKNDox9/ihdEZ2?=
 =?us-ascii?Q?zpmqWjpRuShM5tWn2ALZPvQKlEVwfW6O1H1HzOPeNj73h2xhlht1MSdyWNFT?=
 =?us-ascii?Q?yCb0zjBcMdZuTBsTtHiZQu2XV6cfFhwaKsGRvn2WXMZoO7n+sSBBeXeoTwcL?=
 =?us-ascii?Q?n/y6zgBxhxtYfL5jqIIHgfpLvROSzpDZdBp57FW1t+umBjtCdEt3DyUK9V7s?=
 =?us-ascii?Q?0nRLNmjAaWQPEhzfNpOD7f4uywPI3OorihSQQMGEqk14XOQMHP0yr26e8f4W?=
 =?us-ascii?Q?DKdaS8kYc2NOrdjH9gXNRyGwsbQVfJuBQqHaOyUkrR1rUulEnQihZIulNBwm?=
 =?us-ascii?Q?yU6jnwL+VkkHUvfbILqoznmLLx8+8hR0aI4vFa9MH/fvk94liekW8roJF/DB?=
 =?us-ascii?Q?BcmgcZlR3BKWEuB1T8EcHbjk6qGPOROUI4/DvJaPhosWRLsLDTTHrGr6C8P6?=
 =?us-ascii?Q?2xjsK0CeclI05ywfxdExXZpC1N9sKR4/HUOa44NPCqmPKQgj2gEdRX8zcVr6?=
 =?us-ascii?Q?XMOviCr3IYla9gKupjlW0PIL+iToGpGDuPn4HrTuQfo1jlvnUTRitqO0LZy7?=
 =?us-ascii?Q?nwu0DvU3KZ123Z9rTXvzSMBjc2dGgx4NNUItFjb92wR5QMdvTS++gDOD5Ext?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c122fd-2421-4c8e-3a9e-08db6b1ee2eb
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 08:27:40.6143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fPbP3naEEDNIq1XXJHFgss4Gb3/QTSZ0V0U5OBpRKdy0qzkHcwCPVY1iA8NdQx9Ktj92IRu32mNhj3WyRpOeHDParftxm4PbH5+1aeTRIYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7114
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 10:54:47AM -0700, Shannon Nelson wrote:
> On 6/9/23 7:45 AM, Larysa Zaremba wrote:
> > 
> > On Thu, Jun 08, 2023 at 10:50:16PM -0700, Shannon Nelson wrote:
> > > From: Nitya Sunkad <nitya.sunkad@amd.com>
> > > 
> > > Following the example of 'commit 9a0f830f8026 ("ethtool: linkstate:
> > > add a statistic for PHY down events")', added support for link down
> > > events.
> > > 
> > > Added callback ionic_get_link_ext_stats to ionic_ethtool.c to support
> > > link_down_count, a property of netdev that gets reported exclusively
> > > on physical link down events.
> > 
> > Commit message hasn't changed since v1, despite the comment about usage of
> > "added" vs "add".
> 
> Sorry, missed that.  Not sure this is worth another spin by itself.
> 
> > 
> > > 
> > > Run ethtool -I <devname> to display the device link down count.
> > > 
> > > Signed-off-by: Nitya Sunkad <nitya.sunkad@amd.com>
> > > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> > > ---
> > > v2: Report link_down_count only on PF, not on VF
> > > 
> > >   drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 10 ++++++++++
> > >   drivers/net/ethernet/pensando/ionic/ionic_lif.c     |  1 +
> > >   drivers/net/ethernet/pensando/ionic/ionic_lif.h     |  1 +
> > >   3 files changed, 12 insertions(+)
> > > 
> > > diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> > > index 9b2b96fa36af..3a6b0a9bc241 100644
> > > --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> > > +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> > > @@ -104,6 +104,15 @@ static void ionic_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
> > >        memcpy_fromio(p + offset, lif->ionic->idev.dev_cmd_regs->words, size);
> > >   }
> > > 
> > > +static void ionic_get_link_ext_stats(struct net_device *netdev,
> > > +                                  struct ethtool_link_ext_stats *stats)
> > > +{
> > > +     struct ionic_lif *lif = netdev_priv(netdev);
> > > +
> > > +     if (lif->ionic->pdev->is_physfn)
> > 
> > Maybe
> > 
> > ionic->pdev->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF
> > 
> > from [0] would be a more reliable way to determine, whether we are dealing with
> > a PF?
> > 
> > [0] https://lore.kernel.org/netdev/20191212003344.5571-3-snelson@pensando.io/
> 
> Note that the indicated code was removed from later versions of that
> patchset and never actually made it into the driver.
> See commit fbb39807e9ae ('ionic: support sr-iov operations')
> 
> Also, using is_physfn will still work with no further changes if we ever add
> another PF device id.
> 
> Unless anyone else has a preference, I think this works fine as is.
> 
> sln
>

If you say so, I won't fight :)

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

> 
> > 
> > > +             stats->link_down_events = lif->link_down_count;
> > > +}
> > > +
> > >   static int ionic_get_link_ksettings(struct net_device *netdev,
> > >                                    struct ethtool_link_ksettings *ks)
> > >   {
> > > @@ -1074,6 +1083,7 @@ static const struct ethtool_ops ionic_ethtool_ops = {
> > >        .get_regs_len           = ionic_get_regs_len,
> > >        .get_regs               = ionic_get_regs,
> > >        .get_link               = ethtool_op_get_link,
> > > +     .get_link_ext_stats     = ionic_get_link_ext_stats,
> > >        .get_link_ksettings     = ionic_get_link_ksettings,
> > >        .set_link_ksettings     = ionic_set_link_ksettings,
> > >        .get_coalesce           = ionic_get_coalesce,
> > > diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> > > index 957027e546b3..6ccc1ea91992 100644
> > > --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> > > +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> > > @@ -168,6 +168,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
> > >                }
> > >        } else {
> > >                if (netif_carrier_ok(netdev)) {
> > > +                     lif->link_down_count++;
> > >                        netdev_info(netdev, "Link down\n");
> > >                        netif_carrier_off(netdev);
> > >                }
> > > diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> > > index c9c4c46d5a16..fd2ea670e7d8 100644
> > > --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> > > +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> > > @@ -201,6 +201,7 @@ struct ionic_lif {
> > >        u64 hw_features;
> > >        bool registered;
> > >        u16 lif_type;
> > > +     unsigned int link_down_count;
> > >        unsigned int nmcast;
> > >        unsigned int nucast;
> > >        unsigned int nvlans;
> > > --
> > > 2.17.1
> > > 
> > > 

