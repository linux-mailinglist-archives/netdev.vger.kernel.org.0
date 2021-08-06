Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B2F3E2771
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244610AbhHFJjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:39:22 -0400
Received: from mail-dm6nam10on2119.outbound.protection.outlook.com ([40.107.93.119]:47529
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244234AbhHFJjV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 05:39:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0KnnuVUK3dzRnis8BJjdMIagzsOK2wHbUPBN9rabkNc61Q/gWwZcBLTbs/9l18I6/MxXERXlyB2aKJdJnZC+R+7EHZGdUScTyh+HyT1YwNqO4A8kpixTNO9Sm3ju+zYatS1K69LHfQo0wpWizOEztl41lHbMX1Vgx2Up6zyMbEdJgGc58EOgbSXLuH9yZFIMpzSp8BnvNpAjRnVsOq71ZGNV1yigp/fB4flmMVspOlt4w3fuTuOcVDe6fAeb8tKimqAtpnFtuoNuYN0SF8ISxrVQeR6fhgN9ST31M9h1t3m2dIZjqhX9VJPSl++/fOP5GpkPK1un7r1SjG+X/jF6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClLtM1gqHYYdjbxJVDvR3fgNciHctxJbS/5t1xhdLqI=;
 b=oey5+vii9VNkXjJzLxTZvdB/Kn7YR2zWNFr0d8GkevhGOL/iNPQszfkP6OEApFwPZcLTP8LrcVKqeEFNy++lh2K6PJzxo1uKO4+wbuspnDa4klIlyuWLZ+zHawhkV4myvbXZi8gZFQqpUyoxaz5s8w5//GqHNiumV4UrmX33O39+dCdP7aceKy3HGQqOh2ixjiaqdWGGrwpL8yYFaR9SJo9i3LMlq97lfLsGizTy9KPf7Jra7pvtiyuU/7arci956eQr8fFadGxp40uhYM+HlXnchmXt3tA7CfcoCTEQQQDq0N6Riylw8ZfLwi/xsEqp6lvFd6LH94oEuCjhbSyOMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClLtM1gqHYYdjbxJVDvR3fgNciHctxJbS/5t1xhdLqI=;
 b=PUHVAaHEwmVe0HWSmJFiqa3n/6DIdsDgCxC5ZxK4YnnXoTyOsKVM5efxI8OKaUuCrbucQBGHLtTDno1mJoulZlbcgTcKTSq4zhA0ghNpQY+QZZZJVL7DZrsGm61Ff6vZ7vy4QMokZVnsqC39R/qBurPKCxqyvD2rcvz2Dd4hjf0=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4908.namprd13.prod.outlook.com (2603:10b6:510:7b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.6; Fri, 6 Aug
 2021 09:39:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Fri, 6 Aug 2021
 09:39:03 +0000
Date:   Fri, 6 Aug 2021 11:38:57 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Fei Qin <fei.qin@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net] nfp: update ethtool reporting of pauseframe control
Message-ID: <20210806093856.GA28022@corigine.com>
References: <20210803103911.22639-1-simon.horman@corigine.com>
 <YQlaxfef22GxTF9r@lunn.ch>
 <20210803155023.GC17597@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803155023.GC17597@corigine.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: LO4P123CA0403.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by LO4P123CA0403.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:189::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 09:39:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5630ed6f-fc1c-4075-d918-08d958be0720
X-MS-TrafficTypeDiagnostic: PH0PR13MB4908:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4908F96079F43CCE64F77882E8F39@PH0PR13MB4908.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3pHML+NCvg9Nt+eVJ6bAz5EkZLNQzqvN5pZi0lmvG3QsTVbz1o+0UocWojk9iJMhleOPWrJVwIBVLidCUaXN+euZB4RM+pIb+TZmmHGkUjqhKmjECPj59sxcIlN181J9pHOCw/jAGriLuK1dlDF7ffihlOE86vQHZShDJtyB41FisBbdEY9Pwd+F0Rm/psn9dXQ4k4rs/r8V7VFc0Bu0Q2YnyS/cCV1UBImhVZ/kUQOGGkjgzOXOs9EviIRvSAsI2AWMGjguPHTXt2bSvH67swMW7tGGjeujN0QxGbzi8cmtdin9Cg5HZNzj7s/rhwK0aB3IMqsI1CpxfhmdtYed+iTdIbn3gRt//jKVIjcTS5DnV+g6R2WUxztDW5j4pCxeulnpKzw2V95+XFetcKjj3cBG1Vfb/lCPEDoGdCkVuwXW7+psVbf6YhizAgRyZMzCMpkJ1fHBZ4SRjqt2ZKsWdvBo+KC6OKekOYqITHUzAppgbVTD67InkjVmKAUr6ZpEHHzPm/PcPV1ucN7uZXUZRBdZFfD6NdYQ80SKq9nGcJHJRWXfHZtwfz7UWzqfz29W4j1sAWC2aMxPrKw5qe806T4DHhN9VF7IGp+di5z3xOPUsRijciBlzRAge4I225UMAMoMsMfc/6YVFu7VbiFJBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39830400003)(376002)(366004)(346002)(136003)(86362001)(1076003)(508600001)(55016002)(36756003)(316002)(6916009)(8886007)(38100700002)(54906003)(107886003)(2616005)(52116002)(66556008)(7696005)(66946007)(8676002)(5660300002)(44832011)(186003)(8936002)(33656002)(66476007)(4326008)(2906002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TK4hiMmomjn4g0770hQmAiDYSSTa6+FyIlfoLAPBsH3DR8+87fADh2y4HaRH?=
 =?us-ascii?Q?9u+JSIC6C2tLwWDpsM517o7xf4kSCfP+0gZJB3ya9Mps/3R6e8Sey9211jtd?=
 =?us-ascii?Q?0ItcaBN7b5b4yr6P5AmEb5z0Stgxsuo5oycwJE+zwPF6oIiGBxJoF67msV+a?=
 =?us-ascii?Q?EJ2uIz8XXeHCvz9mjpTngYxXIdYzVlWQLt8GpR/4Zi8G/W3xUrmh+b0axSDs?=
 =?us-ascii?Q?1LJ57Vajy+I4vxMhKZhGahh6SKtmdvAGloNQ4cVXQi5UF9qoQQ/nKNsW0e9f?=
 =?us-ascii?Q?i0sn0nWYO2IWHKayEIIj7FqlADMFg6cDRtrcxnow84TzWL8HBegqNdv6LYhG?=
 =?us-ascii?Q?GNfL7jwJsnBOmCcndZ9B2dM70RKXv+gG/X69YnCTzN7Y5mMdJVEW5+SmYneM?=
 =?us-ascii?Q?cXBD1iO17Snj6hpJzBIfKSpUUSGPZ+nr03n8jgBAgQNsH7TtTmbzwt5Vo/WT?=
 =?us-ascii?Q?KfaFIm/WTyiR0sFrRAAW59+r6Vv2jk0IJLt+qac3Y9BSlRAjIwW1sARomXAR?=
 =?us-ascii?Q?FvwEzVyR9a4lCZU0Z/y7AUkJlpOZo3NyK5XaDR5Y83qdAVaWbjA5BMNoC6RU?=
 =?us-ascii?Q?/seFulFlBeEpBYy/g3ieGCh1dT7l8VsRFh//kdh0ngaSsVgHfUhlKKnF/QXv?=
 =?us-ascii?Q?q55s/ztOA2VZYaRSJQ8WEvmSyoknG3ReJCQDFu5mUhhuqgJjgB+jM8BPTt9F?=
 =?us-ascii?Q?gX7DDzbAr5D3gIXdznW/MpyrlQuj26GGDpqPS9ZAzNB4T7hyvP0xCmgOPLjP?=
 =?us-ascii?Q?RR/vLJKd5Fitg3XLK4Zxlt+W3M8+/YFFprN1qPgXpmJC+PDdOcHJ3nrRn7qj?=
 =?us-ascii?Q?2ZkoEyiMVb6oxBAzsbd/5Z0Jf4auWF0RUkKnl6i1TK0kMuXyjegPH/iyRvgg?=
 =?us-ascii?Q?P7vjrmYgt04/DUOVUXKOx1nokABzZ0OSPCVPxKx3SBj8VwePGXxnoJRmGCmK?=
 =?us-ascii?Q?QzptgZ1iPE1dVIEnN+OQyESis2ahCZtf0C3oM3pC27Wd3dIMC06rJrpV5w04?=
 =?us-ascii?Q?h4nGFpfpd9Lv8mRC1d1daKoWt6K0P6NqQX5TP8Sz6bMrT1/L5cCV7QU9r1mB?=
 =?us-ascii?Q?88eAetmlD5nJFqTNSjAEfUfw5no9C9/H9n+3p/h34b+eoH1a7Jl95SbjH5aR?=
 =?us-ascii?Q?ZUechQvkx3MT7x02XoAmcgKwhZ1oCW5VDAPKLZ46SeTXGsiRX4ZNO+XYfV8D?=
 =?us-ascii?Q?H5mLzwZXeoKsUYvHpqNPhfDd/nAftxgEZxl7NVfHdC8W0KaWKe2sXddhSLSK?=
 =?us-ascii?Q?18xI/LRHcVyJDu4mXzPJBUm39+EfDgLqnBbDtWwKyx39UOc7uyT5bdD8urHV?=
 =?us-ascii?Q?fip4hbYNJ0lEACov8mHxiiYT+lvGAxMwYHI9KvSyPQ4ozGd4EKjUpkz/GrEr?=
 =?us-ascii?Q?hZSOzKGpQPbnKZ6tfWFC3M9a67or?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5630ed6f-fc1c-4075-d918-08d958be0720
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 09:39:03.7354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXx34bngC/QIHtpfLkBY/L8C+yFpRZedBTCAOS4yO1XBpuF/rhRh0TflTBo+bRjduJLsS0rJFgLgHSLC7vhSJyeypx1bTRTxhY9oltwpW6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4908
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 05:50:26PM +0200, Simon Horman wrote:
> On Tue, Aug 03, 2021 at 05:03:33PM +0200, Andrew Lunn wrote:
> > On Tue, Aug 03, 2021 at 12:39:11PM +0200, Simon Horman wrote:
> > > From: Fei Qin <fei.qin@corigine.com>
> > > 
> > > Pauseframe control is set to symmetric mode by default on the NFP.
> > > Pause frames can not be configured through ethtool now, but ethtool can
> > > report the supported mode.
> > > 
> > > Fixes: 265aeb511bd5 ("nfp: add support for .get_link_ksettings()")
> > > Signed-off-by: Fei Qin <fei.qin@corigine.com>
> > > Signed-off-by: Louis Peens <louis.peens@corigine.com>
> > > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > > ---
> > >  drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > > index 1b482446536d..8803faadd302 100644
> > > --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > > +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > > @@ -286,6 +286,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
> > >  
> > >  	/* Init to unknowns */
> > >  	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
> > > +	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
> > > +	ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
> > 
> > Hi Simon
> > 
> > Does it act on the results of the pause auto-neg? If the link peer
> > says it does not support pause, will it turn pause off?
> 
> Thanks Andrew,
> 
> I'll try and get an answer to that question for you.

Hi Andrew,

The simple answer to those questions is no.
