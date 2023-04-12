Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B2E6DF74E
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjDLNek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjDLNei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:34:38 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE5F83D0
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:34:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DV9S7AIepC1/Lsa/XCXuHUUSfR1Ge7RRhtjGeRjLy3ca0OWvvWgn21aDek4jqtjpG9g3YFI9OjOceHYsJdGKNwGKaT/DYEgbnnOo1enmGRdfcHAA2UqOU2g2SwuIbB8rX2mQHgxp1ZQIkF0ztZXgabcKv6uGkcf02MsmArmcPnMOByPdA3g0rRJSSyw2/MxwkCeGVgE4OuXgui6mDi9hSNVKmO7bmuTtSszPLC4Zzp/eRJb6mxfVKBip0AYvJncnwIValEzE0GGWYOUFkqYGFmtQ8By51FU5/wwe2bXoThdwLoiyD/Mz+t9ygnoyb3HL/OID03FnS7YnSY2F9Hs/BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8YR7YSfMnZRwvmfkEbtn6VTMJVoBUGY34SJBgBIpHGw=;
 b=DEcQBzCWWQQphBnH5FgNbxFUVzMwqHND3DW7pxsPcvcHQC8p6VXslIQTXiZfekYbHTW6oa+9620aKPzzF4AU8PKYbha+xtbAQl0DmKIMpxetGcSiwEoAV6jvR+xMgjp7pzDbe8/T1Jc/bP81lGUQJ5mgrDXTFiQj7HrZdht3x8X3HQaiRnoEdXFTlV11Wnj3YXvV4weQfar1nEKjuhIIcLyVRlnxbCfOiTSjTYhzS+cjrXG5pA2H9O6X1nGmwHNVyaXPpenC9Rc9Sd8i+g4aBTq+NmQLV90Jb7TgJHTRDD0kCvRUVUT9/Fj16+Z3K0jQiBs2/Ee/eYD4sh9Iv2q9Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YR7YSfMnZRwvmfkEbtn6VTMJVoBUGY34SJBgBIpHGw=;
 b=DOrtWMGU2JkuzaeR6AQ0/Uy8ZIFOyzwk1+J9dOrKl/P1mVuzbXZlw+nzhf2lSZx84depfSNfMJISvEVpOvgl4ttAvqJmFB4aRRIuvBSzzOH0XmYvdrwTjPBaNJ7vYiENtLMFPUeuzgWrC638CDIlcXXiKioCfdAjazf2XYKi6XnVRr3ByDiBSxCrOyyFgRZby1cy56NU5SS66HVx6DFxzfvwIXGihYxzmPlG09Wx5yWXHYqalz2RdOvvp/M7LGpmGE+xfatGIaOK4lzbEw9y9nG3H1M5RGXlLXBtTxPOrjCFpYGVy2CtZy+wna2d7ZnuICKGdZFENMDIJsFd32DKIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH8PR12MB7253.namprd12.prod.outlook.com (2603:10b6:510:226::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 13:34:06 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 13:34:06 +0000
Date:   Wed, 12 Apr 2023 16:34:00 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v3 net] net: ipv4/ipv6 addrconf: call
 igmp{,6}_group_dropped() while dev is still up
Message-ID: <ZDazSM5UsPPjQuKr@shredder>
References: <20230411144955.1604591-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411144955.1604591-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: VI1PR03CA0046.eurprd03.prod.outlook.com
 (2603:10a6:803:50::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH8PR12MB7253:EE_
X-MS-Office365-Filtering-Correlation-Id: c08046a3-1a74-45d4-a24c-08db3b5a968c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mRspDup4JAc6WfE1svZIL+n8J0P043Gx15FWcku9edspgJoqcxennvE9WdKWlVP9srVwedMW0iB23/wrrTCM6AjxR15v6l/j84wizyLgSjYdZ7gtTfPDcRisDKvqnOkrVdi8kB/jRAR5AGJersraDJZaekClb1o6H0J+bnBP9mbU9G0OX43/HX6rG3mvUcLx5EZPvXk2mR1LHlOB5U1FQdwhGqADO8SI0TdshmnTUJ4vajf/YRHPVZoKeGCbnCSo99r1WDoBWfLAK+AJMYRdcP9yGrqDoRvhQ1DJjBjXw9F//9xGs/nI4xwPjNuKbw6TiSP3Oj4STysg9PUPghvXxo8RiwCg31RD7hAIRsrg94U7YMpAvc4iKiMmyZ+bRG3Az6w0/qnX2f6GYHmcyEvrzqDHBJ9qNK0E/H2KfhejsX077BA0qp93HThsphGNM+5HVYt1hQpgV+OTl8fmCvvdou5S6dzyr1HGH0/Tz4zsmOG6gRT6j1RhhyyFU13eDMSHuVvhhn9tSgg77sBivyeM1Mgxddin67Nu1Kgu5KeWf/PEXD0cU7zBIBOAJOeECuU4i+eKMOmjXZBcfmCOqj6ytgnsnI5EZNFLV0xjNB/QhJo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199021)(9686003)(6666004)(83380400001)(54906003)(966005)(478600001)(186003)(6486002)(26005)(6506007)(6512007)(316002)(33716001)(2906002)(5660300002)(38100700002)(4326008)(41300700001)(66476007)(66556008)(66946007)(8936002)(6916009)(86362001)(8676002)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?65FashIW1PrOXry7CUX+UUk72E8zVf4gKJDHZNi9IPVw6F9QqxyLYDVtcgOo?=
 =?us-ascii?Q?VxruS99RfOANNba3zPKT9CoyKV7uM+XCHjaGmVgkNQC8AasmN+4OzQjOTJ8l?=
 =?us-ascii?Q?24NSIIKkKIFfi6Tc+M6VVSG0trBcXtRDVqbUAQXGlmEnwJj2/7lAG61W4Cxw?=
 =?us-ascii?Q?pTk951tN/K6PHGY9rf8eVK6easBLinDiWVrLULLmdL9pZI1jtUy+Z8HG9wQr?=
 =?us-ascii?Q?m9MHR1HR/vmi+lKzANSqHEnKr2gIntZKo2tSvqKNBMTS2xATyltLTl6G0V7O?=
 =?us-ascii?Q?zBoCGOUgtcKhZGDNZqr+yuUOTbSZob7QnAaFSgIOkXpeU/DR1H7DeexSi6x2?=
 =?us-ascii?Q?c1PnDNhL+v/XFSa59ashaEllA0tV6HW+GNSDj1DHUxEi3DMmP2uNqkQ+kHEU?=
 =?us-ascii?Q?oAEu/SrGYGRPXIUTFtMt7eKg2Pyi7sUhy7sr2eW9VY01Wti+PthOnglqzyCq?=
 =?us-ascii?Q?aAx4Mou+BKf0k0VRs8nAvNpTjDxNi3rF/UiYgQCkY4CjpEJ78Uu6fxbTNSOk?=
 =?us-ascii?Q?MFB74UweV4Uz5R3Gh77lRx6bC5+6FLOMLb55oPGnvzJJfPip+wGmVmZjmKU4?=
 =?us-ascii?Q?/K6al9f4FY/m06m9nhWFEropvSQXsMe5zbr0u+iXrUOoQ9NTk3pRsYU8TdoC?=
 =?us-ascii?Q?yDY3G2eVVNFZP4rbSW93KPtEAk29KGnOrrNx/a+O7tEwdBdmXWKk0nlQyEQK?=
 =?us-ascii?Q?dKMYaCSHhvxrTwGVJ0X7wX4yO7zZ6uofMU8OFNEKsZMajEURjdLvpsdVPRSQ?=
 =?us-ascii?Q?3Fehyaf+htfXumjG9zT4S5IyhursXHof04ktGNWrhAmXQhu/Xd4b8myaaCGT?=
 =?us-ascii?Q?Ombd5IVPXghnhqy80y4v+Uf4moo9iaJlR2V5lu2RhZVcbMQbTcUpMlzyG+m8?=
 =?us-ascii?Q?7Y4B/+yHk3gLp05duAr3nD+I1otbKGdJGx7iCjmWD65/c8+OlZPk8Gx+m/eB?=
 =?us-ascii?Q?HMbu62NidGvlHnzy9Tv+EuLhKjr+QIgCtacUwmQ2CgfFU/l5muRiX1Yd66F6?=
 =?us-ascii?Q?rns/U7Yxz5j2BJYC5RpWTNF8hny7TE2sVEkvshz6OEHNFknJniN4UmYd/VAy?=
 =?us-ascii?Q?mVhOV6cF9Czg/4rye4unOvNZ1eZnv8TJkUSPGErwUg9h18MRE86kENfQtg2y?=
 =?us-ascii?Q?sJucNhgGLOHd1miVDF2/VlliFefxhk+Eq1kpG2yP4GTB3wPmCqCM1LNqA9D+?=
 =?us-ascii?Q?l0eSIJDnyv5TG3MiHTOmgSIXdwUoxu2J+XG+n6ZTNnwclSWBFGUDG4CI8Mfp?=
 =?us-ascii?Q?hFMpeUx2khawuEldpIKD1ukgjHKXXvSDTLu8IWaAOgyFLR+Ee+eXRvhhMf4Y?=
 =?us-ascii?Q?t7aJANQNm79OD4XsdP7vDx1JwNIOZfV3neQEaAeJAHbPqpEIoLI4fy8rd8MC?=
 =?us-ascii?Q?IrPZznBqhYAwYKieNeBfox6xyZfHCuHMXn22Pdj2yVFgKG4zFJduKIBags40?=
 =?us-ascii?Q?LdQ9QmGKkwysF9quVEzNvMWc8VPxD1ZHGGGK/MZ4KAWRrWZBqNi9j5jsHUYf?=
 =?us-ascii?Q?1JggC7i5nisz5jjauJjjTa3M3KP01InOXpbWzWWU0zXCgpGd2ev6WkzhiWzU?=
 =?us-ascii?Q?SmhLYMZtG0JfijaLOdgJfWCFwcC1fRwEFKIA0OLc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08046a3-1a74-45d4-a24c-08db3b5a968c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 13:34:06.5652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L50Cqh1+er3d/Utnxs34FRrq9ATuKtvJajmLpbq13gfxO4alXKXeNSqauwFYuzIdtnop8JznoQ8ud0SP9tR6qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7253
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 05:49:55PM +0300, Vladimir Oltean wrote:
> ipv4 devinet calls ip_mc_down(), and ipv6 calls addrconf_ifdown(), and
> both of these eventually result in calls to dev_mc_del(), either through
> igmp_group_dropped() or igmp6_group_dropped().
> 
> The problem is that dev_mc_del() does call __dev_set_rx_mode(), but this
> will not propagate all the way to the ndo_set_rx_mode() of the device,
> because of this check:
> 
>         /* dev_open will call this function so the list will stay sane. */
>         if (!(dev->flags&IFF_UP))
>                 return;
> 
> and the NETDEV_DOWN notifier is emitted while the interface is already
> down. OTOH we have NETDEV_GOING_DOWN which is emitted a bit earlier -
> see:
> 
> dev_close_many()
> -> __dev_close_many()
>    -> call_netdevice_notifiers(NETDEV_GOING_DOWN, dev);
>    -> dev->flags &= ~IFF_UP;
> -> call_netdevice_notifiers(NETDEV_DOWN, dev);
> 
> Normally this oversight is easy to miss, because the addresses aren't
> lost, just not synced to the device until the next up event.
> 
> DSA does some processing in its dsa_slave_set_rx_mode(), and assumes
> that all addresses that were synced are also unsynced by the time the
> device is unregistered. Due to that assumption not being satisfied,
> the WARN_ON(!list_empty(&dp->mdbs)); from dsa_switch_release_ports()
> triggers, and we leak memory corresponding to the multicast addresses
> that were never synced.
> 
> Minimal reproducer:
> ip link set swp0 up
> ip link set swp0 down
> echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind

Even with the proposed fix, wouldn't you get the same leak with the
following reproducer?

ip link set dev swp0 up
bridge fdb add 01:02:03:04:05:06 dev swp0 self local
ip link set dev swp0 down
echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind

If so, I wonder how other drivers that allocate memory in their
ndo_set_rx_mode() deal with this problem. I would imagine that they
flush the addresses in their ndo_stop() or as part of device dismantle.

> 
> The proposal is to respond to that slightly earlier notifier with the
> IGMP address deletion, so that the ndo_set_rx_mode() of the device does
> actually get called.
> 
> Fixes: 5e8a1e03aa4d ("net: dsa: install secondary unicast and multicast addresses as host FDB/MDB")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3:
> Returned to the original strategy, with Ido's modification applied
> (to only touch the netdev notifier values, not the inetaddr notifier
> values).
> 
> v2 at:
> https://patchwork.kernel.org/project/netdevbpf/patch/20230410195220.1335670-1-vladimir.oltean@nxp.com/
> 
>  net/ipv4/devinet.c  | 2 +-
>  net/ipv6/addrconf.c | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index 5deac0517ef7..679c9819f25b 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -1588,7 +1588,7 @@ static int inetdev_event(struct notifier_block *this, unsigned long event,
>  		/* Send gratuitous ARP to notify of link change */
>  		inetdev_send_gratuitous_arp(dev, in_dev);
>  		break;
> -	case NETDEV_DOWN:
> +	case NETDEV_GOING_DOWN:
>  		ip_mc_down(in_dev);
>  		break;
>  	case NETDEV_PRE_TYPE_CHANGE:
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 3797917237d0..f4a3b2693d6a 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -3670,12 +3670,12 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
>  		}
>  		break;
>  
> -	case NETDEV_DOWN:
> +	case NETDEV_GOING_DOWN:
>  	case NETDEV_UNREGISTER:
>  		/*
>  		 *	Remove all addresses from this interface.
>  		 */
> -		addrconf_ifdown(dev, event != NETDEV_DOWN);
> +		addrconf_ifdown(dev, event != NETDEV_GOING_DOWN);
>  		break;
>  
>  	case NETDEV_CHANGENAME:
> @@ -6252,7 +6252,7 @@ static void dev_disable_change(struct inet6_dev *idev)
>  
>  	netdev_notifier_info_init(&info, idev->dev);
>  	if (idev->cnf.disable_ipv6)
> -		addrconf_notify(NULL, NETDEV_DOWN, &info);
> +		addrconf_notify(NULL, NETDEV_GOING_DOWN, &info);
>  	else
>  		addrconf_notify(NULL, NETDEV_UP, &info);
>  }
> -- 
> 2.34.1
> 
