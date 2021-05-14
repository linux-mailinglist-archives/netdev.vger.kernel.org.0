Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A142238042A
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 09:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbhENH2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 03:28:07 -0400
Received: from mail-mw2nam12on2081.outbound.protection.outlook.com ([40.107.244.81]:26273
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230326AbhENH2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 03:28:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCp/yIf9q+iNPwpZpyXcT/IYk1WKX1Fv5nmjUSoMHwRBEsyCtm34w+4Tf1vrg6ukkiHyAktoowTxLwhkdJqeJBNC3wx6vsqCmMXyb7HXWZDkyHNCC2/qC2y/wAGyKuT2J0RfmVJqSfNXDqBEc2KVwuY8BKfpGjwTgedGUFVmpY196vsq5M9o70gd+CQLMDjm2r3k6sCXPsNxbOVMVUBrkZllxJ5um/6SkijC6ROcv5MiIEMxRtyB5L7EylM4Jcq4SdAz5R3L2pqICGsz+SDzXnJxiWmCLkirfqLk7jyIfWLkF11IRt0WhM9V/y/GTI5DcRZWDGni4QEqrdO3xjzazg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJd9CnnDvjbfsGiwpgEsiZ8jkYU1UNb88H593dfukS4=;
 b=LsAAW1YC/1kzXuRK9XjOerEDiieLAhpl3o9LDhtQQh6GnrA21q0V+SlabWzfxMQgT5ZQnXnuSWRA9L6h3P4OtcLKCgI0BDz6G/obgI1j0kEliphmv4HpMn4722L+3Sr8vwHDoNFnxUOYoOF95F7fu3Z8HdzVXjB6Z9q6PO20CBafFWMkL3BvDjY44V4MwKXNqRpy8hZDExEsne9j+6Bk1T17+hirHr988PLrGsNdXPf/o5x4D49P0ogwzkFRHm0frRqyhwOE079LrvE3bGhthilfATmfzIttvJ60zA/dEY/TLTwPJeSV86ZgaJQHg4pZlUbT+VAmbPxdIrdCO4yClQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJd9CnnDvjbfsGiwpgEsiZ8jkYU1UNb88H593dfukS4=;
 b=Um1hYXOcdnLT6aerm5FVKRLziY5E6hNVjW7TzQ8zSqf0bRAxBNrUOu/0IMWwVwTA0ZReHItO4Vhuh36L3NOIG5Hr+xS4117zY7U3td7UJtFidLF6eNbSLCWrYMTjvwqR9SMZ4MVDw1o2xmio0uaDQGxjOUgZRwaX4HHlHy0e9SMRYKSFzgisqcM3inpLOvtQFXuoZTh5aRKllOzZh8y6TSBzq0OqdmELhIxBKB9DnrvJ+xoIJOHelFy80ESwXJKoc8rSUhunq2YxXIPypPwbyVe9Z9mhhdOPWuBHMy1VKLOrKVoR0aameqa2sPOBISSgALcQCZ5whjd1BHKS8SWYBg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5463.namprd12.prod.outlook.com (2603:10b6:8:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 07:26:54 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 07:26:53 +0000
Subject: Re: [PATCH net-next] net: bridge: fix build when IPv6 is disabled
To:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20210514015348.15448-1-mcroce@linux.microsoft.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <8c5129a9-1589-289e-b4cc-65c911144634@nvidia.com>
Date:   Fri, 14 May 2021 10:26:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210514015348.15448-1-mcroce@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0074.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::7) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0074.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Fri, 14 May 2021 07:26:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7dc931fc-19d3-4a5e-536a-08d916a9a539
X-MS-TrafficTypeDiagnostic: DM8PR12MB5463:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB5463F4ABDD86AA58EFA90532DF509@DM8PR12MB5463.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5/Eg2HO6pi65sdu4gVlYnvu3852Np93HiczJNaBvKnstJCcz/a6A/5gV8BRs+9RWvpYCmI/jIlbx6U6HoNKvZiSk9OxD7DsW55phxyHN/Hv6OVcr8UJ9bpb4Uk9l59aSgH2fVWiw+PNjgiNzbV90CAzWGmpuK1kaVyj+gpBDMuqtqMFqjV8C1230X7W7bbRn6e685Ixh2Hejz5GURw9b9tRfutx0oUylBVWrkEo2PquP97fqjUWe6AqiDdNgf+b01Prgs+gCX2lInSqPW4hFnvEipr7a+RgAiEUTejuOjWGdZjahBBwfsTxqpZjdhj0KlB0KWZPMNw14PqDj7uacieANOcr0vkdiWqLalHfAn+7Qut5jMz86txVpw6v9qqFzIThCw5JkAPSbmGLRADcnYSmtH1IKJjvzMg5JBAMW/IylRdl1Cy3LI+NANLmj6Ek60eFTMsGAVXia5JeXRcaaFBSDu+FqlwU7U290jQKmasFav8VCFzSNS7Pc9OeR633RQiGtV///Z8GhigQYHdaECc2vzX4+YfTaNpXsW6FIzfdfibYXVyUVdh9b/nYik7xRC38qfYek69v9pH5mHMI2WNqoF6Swozjhi1j1HJVCAWeyZF4hnziA2v0EW6KxzPSELuXomD+8S6CEgmmnye366pFGJhxMepY43JnDyHj3hexVNAxzBvjC7J2YLiVS/Ykd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(4326008)(31696002)(86362001)(36756003)(66574015)(83380400001)(45080400002)(478600001)(2906002)(956004)(6666004)(26005)(16576012)(38100700002)(6486002)(31686004)(2616005)(66946007)(5660300002)(186003)(66476007)(66556008)(16526019)(53546011)(316002)(110136005)(54906003)(8936002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S1owRTlyMDVYYXorYnB4bHVvS0Z2dTJFNGFzV050MHZ3eTh5Sml6L1dQZmNO?=
 =?utf-8?B?cTMrbU5QWTZ2SW5NOW1zYXdpeWtvckV4Z2QyUk8vTFNKNnhCTHppWXdWTkVa?=
 =?utf-8?B?Vk56djZMRzhuY25jVlJCd0RnNWZWeUdmTy8rU2tsL0FOVUlhVWZpRFRSbFhK?=
 =?utf-8?B?Z1p6Z3BRVy9SZzA4eU1iWjQ5Vkt4RjJ2RXo2U1p2RkdtbGxZbjlYZURRd0dx?=
 =?utf-8?B?VjMxSmVvNDlZQXJIYWtJd1RZY01va2c1cjdWSnJ4aHdvVmVHWVQrQ3NreFMw?=
 =?utf-8?B?Z00yVDJaT2xaM0N4bStRRWRBRUNMUVVmSExiRzh6OGNFYkRyNzAwSVNxejZX?=
 =?utf-8?B?MmlLbmVqRk9TbVZuQzREMTh1eFNLSXg0SjdoUDM1bHQ5MVVLWlpmejhrL3d2?=
 =?utf-8?B?dmZtU2hvcldoa1czZUhUVjVLQm5KdW9YOE52WjhFODhZUzFKU3RqRGlVdXVL?=
 =?utf-8?B?aEpnNUlzTlRBcVdBeHRlYS9VNHdCRWZvaWpySG9JWTY0VzFLc25qMm5ZdjFL?=
 =?utf-8?B?OHBNR0dSWUo4Uko3RmNTQmxlTm9pTEo4TE5Qcit3UnNVdlM4djFNcFkzdys0?=
 =?utf-8?B?WFBBYytTcnVTVWx2SVZBNHdnOFJTbVZaRm1YelJsQlFVODUyS1Z5NENZbFVL?=
 =?utf-8?B?TTBITEFlN3FrNjVITHozZ0t6eE0rVGZ1RjFDaUtObG9wazNOT3hQbFcxcDlo?=
 =?utf-8?B?SklLaWpnenFnUE9YZnQrZmxBWUl0OG0za25sQloyMGhxK2tEREdaWHBjM0pE?=
 =?utf-8?B?bHRuNWhDd0d5RHg5cDhLRXdhckV5UjBMSHdqdTlnb3FMc0djaThUaUhVK2V0?=
 =?utf-8?B?QVRoTHNNVzh0dVROV2VBcHJGZnVqbTdPT2ZKenJqaEN4cmZyR2IzRkJxblFG?=
 =?utf-8?B?OTVYVzAxL2lBZksvY2VaNmxVRy8yMGJCa2YvcUZuQ0FEdmcrVUZsWFRvN3Va?=
 =?utf-8?B?T2xrck5vaGdkUHZvcm9ISEJjcmdDTW1IcFgvSU16bE9HczNwRHBIYTRFUEtv?=
 =?utf-8?B?YUVyV05ESGU0YjFXeHA1WHBWNFc2WXBaRzdoOUJFL2UwVS9MV2RPSmNGRExO?=
 =?utf-8?B?SDhjZC9DWWYrWVdGZktybFoyNW41UHd0YXJDM1E1aEhEWkxGalpVcVJ4MzJS?=
 =?utf-8?B?MEhZcllrNXV0NzA0dzRZTFdNYi9CdW84K0x2SjNUVU94MGFlYTVWa3oyMmEr?=
 =?utf-8?B?SDJtY3BNU3VoQTljd0lCblVaeERFWUhWdzlGdEVQblJYRXIrYWowbnFSa2VJ?=
 =?utf-8?B?cEM2VWtjMnZvdW9rU1VsbWQzaXpXd2MxckNvVzZlSEx6bmhlN1A3SXRUMzF1?=
 =?utf-8?B?YVdqMUVUS2I3SDhnMkJBQXFjR0ROVWR2Yjh1OHZUVCtGWDJRd1dYdzV3RHY3?=
 =?utf-8?B?WTlHVEwrbC9EME42cTlLZjV4MDVvQlgxN1hoOWJjdVRXQzRwRzBDWFA3MG5V?=
 =?utf-8?B?L1FQWkp2UmJQRmZMRm11L1kxRFJ5cUZhVkxZZnUxNU5KZTRvc1NsRHlXeVJj?=
 =?utf-8?B?c1BtZWt0WHVPa0pMT09vbnRXaldBZmZQNFNyZ2FxTFFZLzB2TjhkVG9UU3VE?=
 =?utf-8?B?NGl6TVV3S2lOZ1M0MzFRblg0WWFIeldiaEh3MkpESzNMWmw3dnpiUGovYTVO?=
 =?utf-8?B?Yk0vN3grN2wwZmVBcVJNRXYvYjB6b2xoYitZUE5GZUF2REEvUUdnclJHZFlI?=
 =?utf-8?B?aU1ZeUYzajFxVi9tTVFzbERKYnEzOUJFT3A5d2k2eXB6K2Z1OFFkQ0xFeEMv?=
 =?utf-8?Q?RFGTUorZVPoeEAmEj3k+37U8UQnFxG0rZ7yC/p6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dc931fc-19d3-4a5e-536a-08d916a9a539
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 07:26:52.8769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KcCT8To6c1QxGe21P1tnLSM7p3zDYBRRuGx9tgxDasNRm+zf2iQijkIppibg5QnSoKw/g8k93XBZ/a88b4/lNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5463
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/05/2021 04:53, Matteo Croce wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> The br_ip6_multicast_add_router() prototype is defined only when
> CONFIG_IPV6 is enabled, but the function is always referenced, so there
> is this build error with CONFIG_IPV6 not defined:
> 
> net/bridge/br_multicast.c: In function ‘__br_multicast_enable_port’:
> net/bridge/br_multicast.c:1743:3: error: implicit declaration of function ‘br_ip6_multicast_add_router’; did you mean ‘br_ip4_multicast_add_router’? [-Werror=implicit-function-declaration]
>  1743 |   br_ip6_multicast_add_router(br, port);
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |   br_ip4_multicast_add_router
> net/bridge/br_multicast.c: At top level:
> net/bridge/br_multicast.c:2804:13: warning: conflicting types for ‘br_ip6_multicast_add_router’
>  2804 | static void br_ip6_multicast_add_router(struct net_bridge *br,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> net/bridge/br_multicast.c:2804:13: error: static declaration of ‘br_ip6_multicast_add_router’ follows non-static declaration
> net/bridge/br_multicast.c:1743:3: note: previous implicit declaration of ‘br_ip6_multicast_add_router’ was here
>  1743 |   br_ip6_multicast_add_router(br, port);
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix this build error by moving the definition out of the #ifdef.
> 
> Fixes: a3c02e769efe ("net: bridge: mcast: split multicast router state for IPv4 and IPv6")
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> ---
>  net/bridge/br_multicast.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 0703725527b3..53c3a9d80d9c 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -62,9 +62,9 @@ static void br_multicast_port_group_rexmit(struct timer_list *t);
>  
>  static void
>  br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted);
> -#if IS_ENABLED(CONFIG_IPV6)
>  static void br_ip6_multicast_add_router(struct net_bridge *br,
>  					struct net_bridge_port *port);
> +#if IS_ENABLED(CONFIG_IPV6)
>  static void br_ip6_multicast_leave_group(struct net_bridge *br,
>  					 struct net_bridge_port *port,
>  					 const struct in6_addr *group,
> 

There's one more issue from that patch-set, I'll send a fix in a minute.
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
