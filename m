Return-Path: <netdev+bounces-7344-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AD3871FCC8
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:55:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70CD21C20C12
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 640FB14286;
	Fri,  2 Jun 2023 08:54:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517F0168C0
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:54:59 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2120.outbound.protection.outlook.com [40.107.101.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87891725;
	Fri,  2 Jun 2023 01:54:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVG8iIaDdOPVkNy43iZjm2rUHVI2skylbrzpv+eFHvLD9adx+BjGzMeiUrmfCRJRnX/eqI5nwkSm+W6rIvDWde1Fyfu++Dq4W68UQkfam1CEb4DiYxC5B1JmBY/Rv3KUl0z1YNfhbdoNp5tIyzYg3qgyjtJ18p5zlIhnguiiH0bQVAyeW37feW29FBWoOiwBws+7MWIMNuphHxiXX4OeOe1TM6Zr+916FdYbchJTcqywFNFNVGzUGB7lF0IMjMTNP4EksW+Hm6frS1k1tygGrIFoer+NGUh3e6jYC1FG/q1lAP8UMKkQP8YVVwPmSbwvOB+vnqlnGOZwEYHbuQRB+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zj6Ei+ljIkxAf0K+7V8QQEKsXXHDWBv01Q5VDqle+Xo=;
 b=ilTuuoK/Rd7HXPAfkMm6YfV+k/0R7noW/5WOEFXWAEcaCbSMRni2dA76+jBjT/X5Gb9SXpXsQDN39CWXq1LQtO7sjdbuRvMhw8btRBXsdR17GE3Sujt3RIn5ro13SIim9WGfd8NiDc7zOZBxMo4eSFtImMWU9XoLiJZD47Vgi1upnpv0+JC1xfi7z8qej4iG4BcmvIXisykQ/wEi8vTpPRuFajvKTbrCQv2p9cD6R7pnt9PoP+uzeDZT4vOnT2DEsHRX2PPjV3ob0bTsxrIG+C+viXqZO8nhhetWQ67+1yNkTylhTskiC6u4bX+L3qVduWQ7Ir3vfUGq+8A4pPXQsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zj6Ei+ljIkxAf0K+7V8QQEKsXXHDWBv01Q5VDqle+Xo=;
 b=hnW2MidDOKtKdJmFRnxhAzO5mzA5mDF0T7qCSK+SYmYUyTYPX4LXG9JzGIdNLROBPHsxL2sqTYPDNTKOgP7nSnSMuI0j5p8AX1XNeVIbX+y+dpGJm1a3JlWUIrDlLlT2ChgFIwy4/Kp9OEPYsE7MmwdfzKpPamrnrz2J1d9h/LQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5174.namprd13.prod.outlook.com (2603:10b6:8:1::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.26; Fri, 2 Jun 2023 08:54:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.026; Fri, 2 Jun 2023
 08:54:31 +0000
Date: Fri, 2 Jun 2023 10:54:24 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, bcm-kernel-feedback-list@broadcom.com,
	florian.fainelli@broadcom.com,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] ethtool: ioctl: improve error checking for
 set_wol
Message-ID: <ZHmuQAeP82TuBssK@corigine.com>
References: <1685566429-2869-1-git-send-email-justin.chen@broadcom.com>
 <ZHi/aT6vxpdOryD8@corigine.com>
 <e7e49753-3ad6-9e03-44ff-945e66fca9a3@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7e49753-3ad6-9e03-44ff-945e66fca9a3@broadcom.com>
X-ClientProxiedBy: AS4P195CA0014.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5174:EE_
X-MS-Office365-Filtering-Correlation-Id: 93558371-107c-42e8-8460-08db6346fadb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0FKOOcMfpSAGBdMI039v3QSnBFgN5ug23z14BXe870WNxacWQnB3cF2IlrulHI+Bo0B8NJt4MpAxyLqUpzTg6ul/uFzmyBfsdCkooI6fu/IZooLAtWKZZb2B13s7yf3m9x4OXUmmEAetp7TUk6hRGlrw0cB18uqqrW/wBIeQ855UUO2tjfWwa7aM00qVSNeNeAiLia/SoD79bP6fykf4Bu2NCMnBgazfqESHKUHNXbLOt1voOOIoWB98HCgO9gcrEWyB2/ciWoVzC4dI4by6rsmoJTPELmTDDDYLKOQaUjOKUlhA1npyYPYkQpx0E5uRyTtiyBDU6rgUOItRPa7i8KXjZCfd5YsZKP9QG/2zHZb2PiXw0sJraEQ+L5GVasLdw159Sfpm9FLmtVELax+RqJ5IdaGHlBys6GEh15Lqzym7FvRpDIcmULbtetrFK0BmebyXmmWz4Zjd3wtpFcSAWz7WcFKuGC2cAUHaIEkg02orz7IRkxFokMPfmw5shSyRtteBEpsy/PLWjWqWUgbcZQ/I/4W39JWWwEXmvWyy4FR7QX8WmyZTkKzszQ6d8624/PyUsO5mt4gzJvFwvjTPb3vS1QNj2hiimT5C9beZ9MQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(396003)(376002)(366004)(346002)(451199021)(54906003)(5660300002)(8676002)(8936002)(478600001)(41300700001)(6486002)(86362001)(6666004)(316002)(4326008)(6916009)(53546011)(186003)(7416002)(66476007)(66556008)(66946007)(44832011)(6506007)(26005)(6512007)(2616005)(2906002)(83380400001)(36756003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DihTHN5m2/L8ibW/mxcyIuhugm44QEJVlczvc4wXpMcYG/iYhZe9VnxVH5uB?=
 =?us-ascii?Q?F2P20QDPc0XdTTLZ+mQ1qpsBH8lsLou3nRVF65nFh3GFifrUivQLiCkLK/ow?=
 =?us-ascii?Q?7ckoBwHKYf3ff26bZukp3Sv1OBZEYRGvKkxPXQTuLiSotCgVKwrGZj+nNwQv?=
 =?us-ascii?Q?zz46mftwNi06yHTV7epAqttXmaCoG1q0TgIATV83Jn6AZH+k9Z9uoWVCScEw?=
 =?us-ascii?Q?VS9Wp5Xmyp7XxVwDM9fQGOBlBznlJX0Cok1RaPhWgSSXLlbgnJ+kd2jKbDyk?=
 =?us-ascii?Q?ZeB/8bMFw9yHrQBkk08oAlxbtF92oYVQn7NUmChcn0zMyx/h89wG78y0uaW3?=
 =?us-ascii?Q?O4UbEhqOozrXkrdi92W1SJNWUQF248VJCho57XY2wgn46xJOJkyG6vMasr2h?=
 =?us-ascii?Q?H1kp/SVZVoBR91SUT3KisUurLRATGVt3TpLto6GkTyXZZ7Xxsft3lnjeWrJb?=
 =?us-ascii?Q?0SIRWD2OjJvg/QlwB/5/wPVWeXNceebYNVHXPirCavNVMzQVKX3GWrl1KjZq?=
 =?us-ascii?Q?7Ggz8ODnn4IVf03LD7NRLKKV4dYVxe1mUlWZgaBi6wYEOpPrt8b7/kDqhmkf?=
 =?us-ascii?Q?ml/p7186yvSUrS8x3mhaoGB8ndQxZOgc4Rja5y6qTKu9Sg3/JX5qFew+gGYK?=
 =?us-ascii?Q?GhFn8ifiq64VKMiRQ/s9plclkvS9UU2xQk9fqL5edMbeHD+/i/kpN2Gpv97N?=
 =?us-ascii?Q?N3WG/VTpBAiGWfOGgAYR9tH057H3ZZ5k7wzuZJud7RiDkdosyaB6rxbcJMsn?=
 =?us-ascii?Q?gtkMHeNVQ4he3y7rFTsWAxX7EkR3mLIc8UW8raSFaqmN08Xk/nLBFp9NVbTv?=
 =?us-ascii?Q?+dflnKTtrhFC2LBJ/G8vtVbEoIUr7XUHCwq/La5810zd5DZvUnBNf1XawyVz?=
 =?us-ascii?Q?qX8fiazPCMSx76rxzSaTTVrRNTK3nMn+dn1AoHyu+89vFp5dlbkj45OP46O6?=
 =?us-ascii?Q?09ntznz851VPhSjcCYrIyaVDUMRmFvlmmhuarYLA2QXGeiK7Io26184fUpCW?=
 =?us-ascii?Q?1qe1iXqDx/TkzDCnqIz4vbgSOhIYuWfWGzBqzzIOUoBfeoc04ab+ycdn9iM6?=
 =?us-ascii?Q?DztzNcGLX2z5EtShBGMb7DXqhQuB8WSFLnuyG6yWy1HVS+Upz54qE+JLXGe9?=
 =?us-ascii?Q?MBu4i3LzPf76bSpIzGriuOjZWR+T5NTSZYqC5MgRyIUdNYwR84HNuRamcBKj?=
 =?us-ascii?Q?/dzR5xU9kzalLyQpCauNx0Opkmnwhv05+wrDPJeDiScVSNu5FY5d9puuY2Ge?=
 =?us-ascii?Q?6hpjUFxwUHzCVuvi2UmARklwZSxUg+Ejisi3VTjEk4eaaU/TpfymgavyRhO9?=
 =?us-ascii?Q?8H2diX01/DB4oNjomICnNxmH/Sb/golSZc6+jTt70Bo94HIbYzak/mUVWxbW?=
 =?us-ascii?Q?utvCri0AHGi2h1DcQcxTR6LbmjaN5Gp4DO6komJqbTMIBAB0ajWGj4eSn3F9?=
 =?us-ascii?Q?f/duZT0TdR5CIWLKQsNxN1uwToF76+R1L9o2d3Dt+VqGeJkjYXiEG+ODQ9Hw?=
 =?us-ascii?Q?8VHKJhcu4Ww/FaQfBJuE7gUvGxAz3rFXX/CLiNtlbmLpc8gK2aCpJnIp+K2K?=
 =?us-ascii?Q?jlDQGC2YFjaR1bTI1dzsxXT9zS0N/orvmm2SkC5mGWOBN5Bzx7Ri4G+aCFsX?=
 =?us-ascii?Q?yQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93558371-107c-42e8-8460-08db6346fadb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 08:54:31.2609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57j6r1h5qPoC45YyVv+TPB7Wf8Kv7oH4ASbNY3++WEE0d+zKl8AR5jXzzXZ1YNnbU7KJ4y4iNCVjzqFTWZBA3F+UfE+zSwljdZciwrFXv4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5174
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 09:22:50AM -0700, Justin Chen wrote:
> 
> 
> On 6/1/2023 8:55 AM, Simon Horman wrote:
> > + Daniil Tatianin <d-tatianin@yandex-team.ru>, Andrew Lunn <andrew@lunn.ch>
> >    as per ./scripts/get_maintainer.pl --git-min-percent 25 net/ethtool/ioctl.c
> > 
> > On Wed, May 31, 2023 at 01:53:49PM -0700, Justin Chen wrote:
> > > The netlink version of set_wol checks for not supported wolopts and avoids
> > > setting wol when the correct wolopt is already set. If we do the same with
> > > the ioctl version then we can remove these checks from the driver layer.
> > 
> > Hi Justin,
> > 
> > Are you planning follow-up patches for the driver layer?
> > 
> 
> I was planning to for the Broadcom drivers since those I can test. But I
> could do it across the board if that is preferred.

I think that would be my suggestion.
But I'm unsure of the magnitude of change involved.
Or how risky it is in terms of introducing regressions.
In any case, perhaps it's best to start small.

> > > Signed-off-by: Justin Chen <justin.chen@broadcom.com>
> > > ---
> > >   net/ethtool/ioctl.c | 14 ++++++++++++--
> > >   1 file changed, 12 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> > > index 6bb778e10461..80f456f83db0 100644
> > > --- a/net/ethtool/ioctl.c
> > > +++ b/net/ethtool/ioctl.c
> > > @@ -1436,15 +1436,25 @@ static int ethtool_get_wol(struct net_device *dev, char __user *useraddr)
> > >   static int ethtool_set_wol(struct net_device *dev, char __user *useraddr)
> > >   {
> > > -	struct ethtool_wolinfo wol;
> > > +	struct ethtool_wolinfo wol, cur_wol;
> > >   	int ret;
> > > -	if (!dev->ethtool_ops->set_wol)
> > > +	if (!dev->ethtool_ops->get_wol || !dev->ethtool_ops->set_wol)
> > >   		return -EOPNOTSUPP;
> > 
> > Are there cases where (in-tree) drivers provide set_wol byt not get_wol?
> > If so, does this break their set_wol support?
> > 
> 
> My original thought was to match netlink set wol behavior. So drivers that
> do that won't work with netlink set_wol right now. I'll skim around to see
> if any drivers do this. But I would reckon this should be a driver fix.

It seems, from other discussion in a different sub-thread, that we are
likely clear there :)

As that was my only real reservation wrt this patch:

Reviewed-by: Simon Horman <simon.horman@corigine.com>




