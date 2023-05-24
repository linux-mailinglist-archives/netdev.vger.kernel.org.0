Return-Path: <netdev+bounces-4905-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C679870F200
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 007B5280F82
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00F3EC2DC;
	Wed, 24 May 2023 09:19:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04FDC15F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:19:49 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2096.outbound.protection.outlook.com [40.107.237.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB5A8E;
	Wed, 24 May 2023 02:19:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VI+k664UPmFfIZapjp+PnZey4ZulwOAuXwcaicd4MnhrZkdRdX4V7Eg672pPWzZTdmHLs6m7XUFvEImdAAIDjky2yXqaCs6QIZRlQ0KlW54GlkehqiYam3QxPrA+fmnFm3oO8iFZ5N3LuRezi3+6caokPXo0pBYZ9MI5lgQhYWyyElbGU28JGJVACzs52EUsPXrMrbyQv2jrES5gixL90PjPiIp+RDU47K5Zo7zEMiYJtOtHxh0E/HJ2v5WhFvqzn4+SF5XLNKAiHQBER4OTN0mUztGemMagv5UkwZRzbwpG4M81Arptv+DdCmYcqffhe57CfnwElU27veCw8U0lNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjysrcvpIysM4nTXMnOYFhEOXkbaTSCVxp780VDwaqo=;
 b=GLa3PF9kGJ4kzaKKYunFRXaQz2LEJMKzRBoXh32qLvOatDvI6aA6Cx5YqufmTRR+G/EsiEL6UJZKnsS9dAvLIDaBdPFJMeJuPae+BlbosXMJH6L+UqrqtiqS4Lh+BHfz66cbbSS4vqN0ZA1OQN4CRrDn59Xqil8yDFFCc8cKSaPZh0E8thveObPJEIwoh4xJWcvv7YGy+0hQvLqvAHtWw6YeG8jYoRUTsRGKfJr/R1+zzO8I1wxjcKx1YEvb0MhcssJ396WcjFy7vwtUZUFqTH7CEsoXpNoelylFwafOSLc4cg/tRg6JcbIteq2OJLgs9Oy3oJ50bExkoosnmh2c2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjysrcvpIysM4nTXMnOYFhEOXkbaTSCVxp780VDwaqo=;
 b=QZMz7gXH/Y1CIW0Gsf9SH1tcomfJIKNBtJ/qO6vLRO8v+ZuBoe2YPQceTvqwsdDBVAFN6ihc3P9FzXSTAvrlcmtyS4UJs5XMCmyO4XZsuwQXuv0z3dKDz8KlWMuFETKqsovIhqLCMd5xosHc2jWKAzK7IQnSRHJTYCuX007MGoo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3642.namprd13.prod.outlook.com (2603:10b6:5:24b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 09:19:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 09:19:44 +0000
Date: Wed, 24 May 2023 11:19:35 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com, justinpopo6@gmail.com,
	f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
	andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	richardcochran@gmail.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com, conor@kernel.org,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: Re: [PATCH net-next v4 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <ZG3Wp2HhwLrwpvHq@corigine.com>
References: <1684878827-40672-1-git-send-email-justin.chen@broadcom.com>
 <1684878827-40672-4-git-send-email-justin.chen@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684878827-40672-4-git-send-email-justin.chen@broadcom.com>
X-ClientProxiedBy: AS4P251CA0004.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3642:EE_
X-MS-Office365-Filtering-Correlation-Id: a532a5fb-dbac-47c3-dd71-08db5c3802df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6/HDXRdXjeRT+BBZWHeNgMXJCPnRcox2BM9mOWKfPTC75+SplE/4QNvAGn7X04p4c6ebHitDZV+naqXcDlbmgQ3x2GoJawkZw+CCYpvwz7acTc4UmgWidJ8eZHqGbDc32S2aDoMPOLJ+aN2Oe3K8eYOBBhPbxw1pmrOZ71rjc4O8DcRFo3x8txKUXHMhKsANeTcnSvUWNr+u3msCTCy+KbqickewMjSPzoFDItHFIHCE56cjEqX1tqkqDJWJ69N4ZGxrp2/+7xMG++YR73OXyAZj1XodSbcuX5TTstUHrfbcK7GTzDLr6Emw2yAUujcv5hWfgNEnLyNyT4XnJshKSrOmjufLSm8M8ZnaYYMFIVK094kMwcPNi8Phj+miiEZq/qQ0fngGWsZuTBt1mMvGFLpsgGudhO/asuedk0k3J6xJLEy70WqVOZ8qCPQv2eAyozV76KJMaOYlT5ILsuCxGIVuQnhGVWJjPxuhmR6vs7AxT4GrSpMTpUE/cKoklKDZauNFIqpJZ8enxtaGF339x62v1fQJBeXLTPbgINFV1YNhFupkiah7MKXz/Ji1VEq630Fve/B297iFqgOGO7iGSxp4RbPHrjB2+cb8DsUQ574=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(346002)(136003)(39830400003)(451199021)(83380400001)(8676002)(8936002)(7416002)(44832011)(5660300002)(6506007)(6512007)(86362001)(186003)(2616005)(38100700002)(6916009)(478600001)(6486002)(66946007)(66556008)(6666004)(41300700001)(4326008)(316002)(36756003)(66476007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ghITYONGQeCr9IMo/JR/w6i+oJ+spMJrn0Ha6W6Muo7JsrNl/7ih8gSIu1o5?=
 =?us-ascii?Q?uKu8MIexmnYD+6ZSMu8J6gqO4saX7+KgHY6nrMcHEReOHVotIvPgKQQQOpH6?=
 =?us-ascii?Q?LzBH1yx292ShVnd996UuZT7bBY0/J+z02keQl58jq3DXckFIOS5Gs3KJg899?=
 =?us-ascii?Q?VR5JMH65Bh6b+r4+H8TaCFBIEL474VglctFCYttgwpXy8hMT2taTVSq18FIR?=
 =?us-ascii?Q?QegWYYYut/G3nhH88MU96xL8kiHXnl/fUiOApu3bWTeZAdN+LGIQqU8ck/vD?=
 =?us-ascii?Q?Z9OWyTOAUvAA4J8JO//u3h676Unq0e16S0TwOF9DNevpnjcnisRHacD4eD7E?=
 =?us-ascii?Q?aE9KtzcTGamwxP1sbkIp8nLbpUGUYEPxTDEqxgWdEJSaAk7/G+4kyh9g21f5?=
 =?us-ascii?Q?nV4eDu5dvwJpfW5jUphBrxki6bt6whefVH85pVG3R8kgzyc1nuw3rC7DfR/X?=
 =?us-ascii?Q?b86P4eLEIwHj5s+RL5HXQfyPVYcawYn3GdNSqSORW8fN+0XJuiggQUYvL2Z8?=
 =?us-ascii?Q?5OLuA3wbjCD9dgFfbtrh9GumK2YU5gjgjlRaN4pNK+vGKRoJBnjgPtOigtng?=
 =?us-ascii?Q?erhkb591Gtn93tgvh2avXIORXjcZsmn3/jeU0CfjH7SWsq0CriLF+L8fTD8J?=
 =?us-ascii?Q?XrXpg9FqD8tNo1lkulaysrIc6BOnsa4QQBf2r5aAt4CiTIr1dcbJRNUmKLtS?=
 =?us-ascii?Q?OY25/8CSTYK08y0wKalEhsX+fbV1WOYpXMlv0eVEVaLdouqYpVzGApd6+V+3?=
 =?us-ascii?Q?0HGeJ++rwqosFbiH8ExwCfFFDAfqeHKMsMKGggL49bNppBGIhnN20JQs/DJW?=
 =?us-ascii?Q?ifrtszkmYSihBnzG6oOVOkWfszRqUzROsFzsixWlOdBSbWIQckwzxRtrwfoA?=
 =?us-ascii?Q?DqxmyOQ9Dx2E9I3WfCcpwe1/52VeNYS46xQao2WL5k/mE3ZtEKQrr7kMG14M?=
 =?us-ascii?Q?NSz27GBAP1xoQ5dMzOP271f83f8r2Un5l10wSyeEpjdsEBTLKen6HMG8yBp6?=
 =?us-ascii?Q?nLlO4DE6rnBvtNyNGzqBrUZZJzGcWpjoZwz2xkX5ekgON0ChOLGB+A9kPwqD?=
 =?us-ascii?Q?KmGyk4V2iVM2XvQeKRK6BrszXGkUEB1bvNqLWLhEFP17JJIHQyLWd/rE2fmq?=
 =?us-ascii?Q?Cc5/817vy3aIQwIe3R5EfBJ06uhP3cs1MPmp3eyR0yUEm2n79H35G1BcAzpx?=
 =?us-ascii?Q?uzaL/vFDnEPrOevvJGAr7srvO4Fb5dSRXabYcpJDUaImW6lCT2NYIAPwNjIi?=
 =?us-ascii?Q?vsE9DHZGkPmYqdQpx3U02gvZs2Hf5FWw1H6nWHqxwtFa0/g7hXVr1kgZFZuU?=
 =?us-ascii?Q?tj250NxKn6FkP5egKO8ILIo6KkkDbvzLxi0Qs0r4QVXAyVQVoZbLuEYG8nkh?=
 =?us-ascii?Q?bjs3gFKzCo6ADnqBA/zbqiwETToI4IWrMpyOY6kQdBw/ShpBTNsqS/4Ttau9?=
 =?us-ascii?Q?KYyRm6GqxBKn25Oj9ngjweTj12ISbEsBYAsBbzDhKkGXcUntvjkc/5VuPke3?=
 =?us-ascii?Q?5Fpi0wCNBXUqpoTKZlVHVwxMZWQfRpmMxlgDFjgeOJX9LWAEX7yinvdK+3rC?=
 =?us-ascii?Q?EajnnbIVy6loy4Qm4wgwD0K6mRMPMpMn9ISYqDMTLrO5+4caO9kd2vt289NZ?=
 =?us-ascii?Q?ow7j6D53F6U26pK3yygoiByQbGtVCJxSS+m4O7lZwav8sUuXuArMQvcWXTJN?=
 =?us-ascii?Q?lA8PQA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a532a5fb-dbac-47c3-dd71-08db5c3802df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 09:19:44.1080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j+UKJ4CfP4AVH2osVxIu4zUsZcxVUyY3HDmnTWatGC5jT3E5IIPqN3Yu1Ztek6fBvMTzoMDDAdkHwC6JpGlCdG8gvMcKtAxJmt+EPoC/vz0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3642
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 02:53:44PM -0700, Justin Chen wrote:
> Add support for the Broadcom ASP 2.0 Ethernet controller which is first
> introduced with 72165. This controller features two distinct Ethernet
> ports that can be independently operated.
> 
> This patch supports:
> 
> - Wake-on-LAN using magic packets
> - basic ethtool operations (link, counters, message level)
> - MAC destination address filtering (promiscuous, ALL_MULTI, etc.)
> 
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> Signed-off-by: Justin Chen <justin.chen@broadcom.com>

Hi Justin,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

As I see there will be a v5 I have added a few nits from my side.
Feel free to ignore them as you see fit.

...

> +int bcmasp_netfilt_check_dup(struct bcmasp_intf *intf,
> +			     struct ethtool_rx_flow_spec *fs)

nit: the return type of this function could be bool

> +{
> +	struct bcmasp_priv *priv = intf->parent;
> +	struct ethtool_rx_flow_spec *cur;
> +	size_t fs_size = 0;
> +	int i;
> +
> +	for (i = 0; i < NUM_NET_FILTERS; i++) {
> +		if (!priv->net_filters[i].claimed ||
> +		    priv->net_filters[i].port != intf->port)
> +			continue;
> +
> +		cur = &priv->net_filters[i].fs;
> +
> +		if (cur->flow_type != fs->flow_type ||
> +		    cur->ring_cookie != fs->ring_cookie)
> +			continue;
> +
> +		switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT)) {
> +		case ETHER_FLOW:
> +			fs_size = sizeof(struct ethhdr);
> +			break;
> +		case IP_USER_FLOW:
> +			fs_size = sizeof(struct ethtool_usrip4_spec);
> +			break;
> +		case TCP_V6_FLOW:
> +		case UDP_V6_FLOW:
> +			fs_size = sizeof(struct ethtool_tcpip6_spec);
> +			break;
> +		case TCP_V4_FLOW:
> +		case UDP_V4_FLOW:
> +			fs_size = sizeof(struct ethtool_tcpip4_spec);
> +			break;
> +		default:
> +			continue;
> +		}
> +
> +		if (memcmp(&cur->h_u, &fs->h_u, fs_size) ||
> +		    memcmp(&cur->m_u, &fs->m_u, fs_size))
> +			continue;
> +
> +		if (cur->flow_type & FLOW_EXT) {
> +			if (cur->h_ext.vlan_etype != fs->h_ext.vlan_etype ||
> +			    cur->m_ext.vlan_etype != fs->m_ext.vlan_etype ||
> +			    cur->h_ext.vlan_tci != fs->h_ext.vlan_tci ||
> +			    cur->m_ext.vlan_tci != fs->m_ext.vlan_tci ||
> +			    cur->h_ext.data[0] != fs->h_ext.data[0])
> +				continue;
> +		}
> +		if (cur->flow_type & FLOW_MAC_EXT) {
> +			if (memcmp(&cur->h_ext.h_dest,
> +				   &fs->h_ext.h_dest, ETH_ALEN) ||
> +			    memcmp(&cur->m_ext.h_dest,
> +				   &fs->m_ext.h_dest, ETH_ALEN))
> +				continue;
> +		}
> +
> +		return 1;
> +	}
> +
> +	return 0;
> +}

...

> +static int bcmasp_is_port_valid(struct bcmasp_priv *priv, int port)
> +{
> +	/* Quick sanity check
> +	 *   Ports 0/1 reserved for unimac
> +	 *   Max supported ports is 2
> +	 */
> +	return (port == 0 || port == 1);

nit: unnecessary parentheses

> +}

...


