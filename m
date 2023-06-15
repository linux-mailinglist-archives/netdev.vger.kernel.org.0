Return-Path: <netdev+bounces-11020-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC317311BF
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:07:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB7B92815E6
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D84C24433;
	Thu, 15 Jun 2023 08:07:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10101379
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:07:39 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2099.outbound.protection.outlook.com [40.107.101.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456231A1;
	Thu, 15 Jun 2023 01:07:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2PaaVEZq6+ZfXPouZCUN0rvvTCnpTIJeZDNJTdleb/QjhWVKqSlBegFHTdOPLEKh/V4b4pCrRdmjr6cDQmNHcoBMjF8Za9WAvS4r/++RZk+mkoaixwpNbruRSVTtu3B9Jf293Qzuc7NFLKy6YN2gDDWOg52drbDYdtMsLGq8+6uoXJb4zFcoD0R8SEcEFgzpvHh0MVlyKAWa586AOwKIMyL2TdyxF1mduLMCLDZ5oFsF3Qy+kyTbwGGb2YJnIC+NQlLQ/sTcN15OtecelLq1nuvIdiuziYqwCgF4ILpuevZG9bZbEe3grmvVmnXDhgKMkPTkURuVQUbioTr7xgKzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XkfC+Dyj23qdD+fs5BlA8PbuTB+ohE3p+fZORXQhTtw=;
 b=A4LmxOlJ5z5zfVF0TR/qaI0krIWidf7RNlJywh7Cykx/ngrZ+NI4G3J3RMloZbfv3L6Zf2a5s0SuIYIsx5MRtOzPBcYNEnGO/JAaGEDk1fIXIsOiCxKay7ELSnDCxEfpOybQvT2WcedhSTBW00Oal3Cd4qSrzks4wCLqd3KgJcZXpMr2+Pbvttw+O+c6ri/YrLG6ieiRHhLZLg1BtOWvPbOLD01oHRuS8ewLKADpK5DT/7h+uPmAAJec8Jmj+xMOEELjV869mrJA+PLDkHkquD6NflAYthh5f+C4GJ8AnhgQ9yGmUsczITNzIJEu2sQHDXH94Pe4wsiDNipoCqs/YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkfC+Dyj23qdD+fs5BlA8PbuTB+ohE3p+fZORXQhTtw=;
 b=nd/GBMA8tKTFKfCefgr5Ms+LDqvZIutM2BrsTImi0mu149AT+G1i4zU6QmgjdHTDzqLhzh0Ao878aGNhcZEO5wxo1pqgcHgNjaAypPm1ahA5z2/LTPletd1oS66jQkPDVn4i+koHcUm7Pta9W8CxamEJrXteWn2KUQmorln0/JI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6113.namprd13.prod.outlook.com (2603:10b6:510:2ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 08:07:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 08:07:34 +0000
Date: Thu, 15 Jun 2023 10:07:26 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com,
	florian.fainelli@broadcom.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org, opendmb@gmail.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk,
	richardcochran@gmail.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com
Subject: Re: [PATCH net-next v7 08/11] net: bcmasp: Add support for ethtool
 driver stats
Message-ID: <ZIrGvsesltAc+izQ@corigine.com>
References: <1686781820-832-1-git-send-email-justin.chen@broadcom.com>
 <1686781820-832-9-git-send-email-justin.chen@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1686781820-832-9-git-send-email-justin.chen@broadcom.com>
X-ClientProxiedBy: AM3PR07CA0131.eurprd07.prod.outlook.com
 (2603:10a6:207:8::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: 8369c2e8-f5ac-42bd-bf0c-08db6d77932a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DJRyRqD+tk8bYDAxbrIjZhZ+Gd12noxWcyAV9yPFR+Y/5RfEhXkWnxLK07re8k+VdjVfP+lve0XdnS8O1WXqtxeyn8s8ZKrjm+CqAvHsik+WY6gpway2a7nmGWdziP5XreXbLaQJND2gbWXHha6yUP/OdhJZCUw/6uehc7o3KMgqIP9IwjcvhrbdAfVXtpbmsT6UdHoulnSYeXiRbuN5SJlfEvtabOvXYBZQaPEBb/sDjNFK1JoHIILXa+MUYpCGPqI5dCyWOEb9JeF10BG6AYGE1sYa2kTUm7ElPZI0+sgCPzR63gqT3q3KHA0N+6LEp+sWqlCWxDxz6uxgX9nt49IwUC/CZkycB7i1+YhafgGLMdo1b4o9BVrinMgks/5ZfiZRTM2GJlRJeqUXjreoRaVDlDT55iC4tGfzKTewh0MhxDfPSX3fnh9P3hAsL2nRey3hKfeBX0yCMmNG+RBySzmKU2dOKt6wD8F0kvfel9kzIda9bLG7JeDMlBFKioxPIFQpB6wzhtfQTO2rwdN45rsMlKO2h63aPLEGcui3tXn8jJ2si9Fl3KneD23tUGLz3Y2lTqwqH82VHDr8B9VflxNWs41JMetMVQGlqThj9nZO51wtiGvXzYd4BpL3j6xi9CF65tOokU6fTFIVvGmsUpgOYrRloMRwIQKLvmNm5ZQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(376002)(39840400004)(451199021)(8676002)(41300700001)(86362001)(8936002)(6486002)(66556008)(6916009)(66946007)(66476007)(316002)(6666004)(36756003)(4326008)(478600001)(6512007)(44832011)(7416002)(5660300002)(6506007)(83380400001)(186003)(2906002)(38100700002)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e1+kRkfhOflWaGsnnKvCxi2xXs56whv9D8uj9Da0Fm2OcW+YoKoh2syZrmQU?=
 =?us-ascii?Q?x1lvV27RGVdg8C/WL8c+MJq7+pvrmiw3y45FySZ6LrGJRNRbnC8W4ajd7Mwb?=
 =?us-ascii?Q?m46jePE6lscbD9BbW2g7Lk0ITL1C5bwDnth8UysdVubZZ6+w4dbTrcbJPiRp?=
 =?us-ascii?Q?czSGPmQTYN+e1b0fpTAtdFBKg1Xq4n7A/Si/9duGP20viOxjnyWQDGh1GkB4?=
 =?us-ascii?Q?kRv9U7Npj5kg6o3Ct4jbeEO2s4Ac3j1RSQsUf8Dg45RN8APdkiiR2wHuWEd1?=
 =?us-ascii?Q?Lvg3aWT14jgZ8BjvB91q0+x36wymT5q0YLgVkh1F/XBOWCTqh1UouZQm0/tw?=
 =?us-ascii?Q?ZJu79+8vfJbq4Q+iXxoIeovwGsx4jSAW6YDAEXRMsL3BO3VyPmcGDRB0+cp8?=
 =?us-ascii?Q?+wuGnnwPTi6iX9mmovCSDHhdTv+1+XvD2WI86QGUD7GNgdJi+YX5GrCkAmT2?=
 =?us-ascii?Q?bXMMDCG6BRjsDKSL1AfiUPT7tMKa08zZVlAbsB78MgrWS++x5PLMGjje77yI?=
 =?us-ascii?Q?0SwGhgr3LrO280eiRU7W5Smr0ccFClx3CzZvn9R8m2cyPsgaKCwXchQy02Ks?=
 =?us-ascii?Q?2eLLo147a4+yOSAkxS2jY9ntue7U0RZZfX2zApJdN6/FxRcfDX93dmt20U7O?=
 =?us-ascii?Q?j6kkw14ZMfzO/2ciwRM4I3KL2kBZsz/1vmAiTiZzyQo0uBmQP9rb2oQGaHse?=
 =?us-ascii?Q?4JejA3MBvs85f3AfopfhIty3xTXFlkCUZkCi7uRhKtmw4SdYLUPPich2Vrz2?=
 =?us-ascii?Q?/mfJl3gUxQvBwSlkS+2RkVe/5nOP1c1x+gGFx71uw65bjvzYw9MtU8b1BUIY?=
 =?us-ascii?Q?Emr/aWaQm9c/DpFUQ1zOwZUq5joQH0BxiHvuFJQvTFMd4hm4ovnDTte5aIVL?=
 =?us-ascii?Q?Ds211f5ztp+S5PCH6KBaT0etrajXX+qezJtA1xdMAtFEL7oonsREO6TYLnWh?=
 =?us-ascii?Q?pkKtf7+nLb58kgo5m5YGeCWHUYmLiq1a2lhLAY98FFDQJ4515AWFJuj+c0pN?=
 =?us-ascii?Q?SuC6WvjAa1uXVS434m2xDZsgNaGw9foXpZyo4+JgMjj87yDkHnU76rnNcWcJ?=
 =?us-ascii?Q?LZGWJaEd/t8gI9zswO1PkyQDT/3figzBRzMytAQtbvxIrTBWhVZuFDFGAGFZ?=
 =?us-ascii?Q?FG0lsT2BoMvEw/dhzGzQ/YllbFRVDTBjfNlKfUKI1C+J3SeiLARgbVf/YIPh?=
 =?us-ascii?Q?/qNvrDHA12cCA7IS870hR8kezhYZuk3E3i0ZiOd88k4V2lp3yAFaU/HH/9o0?=
 =?us-ascii?Q?a2CoLbKLcgUnD4S65xqwghsioWfRrvHRpQ520TmhfBpbqf6l7a/Y4ehpewq8?=
 =?us-ascii?Q?EAnjBwU8RlbBKj+ZD53r7qLtq/p3Vi/8W9X83bzAm29NBmEkCJdOHsl4kHMh?=
 =?us-ascii?Q?sgNworlEi/lJH80BOG/O22uhNp3TWYhcdNuPnvZgaDOHwGBT1CxRAtJSyLVP?=
 =?us-ascii?Q?vWLZ7kfejtmJl7Q/YR6AlxsrmJxiNsar+johvpLrzZ/oPdvyXjgtbxu4TYz5?=
 =?us-ascii?Q?RKzVREeWp2h5Hamw2F1jnwsHwDqYReuCynh2mANmT8GZU8fO/k8ch0Ey03aR?=
 =?us-ascii?Q?1RQqAjAH2kCc/lxow4i4S82d1lCQZBy5xQm1rRF4iZpayUVrapXCsw1U++gP?=
 =?us-ascii?Q?0jpwv1Vnl1Gt9Z/XWE5BVmtSGgbwiWAkOovMEYeUL2e/rZveqL7+T6FLmIaW?=
 =?us-ascii?Q?3p8ZGw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8369c2e8-f5ac-42bd-bf0c-08db6d77932a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 08:07:34.2351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9s4hJFRj4+1bqvGsxhFWEEp3G/8O6MM2qNRPiGlQ7K8b7ARbiLrxIkRDcPeLZEPc9qzLQV11bK5FHerZomOv2qto4+xk6nP+Az5T/ppWI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6113
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 03:30:17PM -0700, Justin Chen wrote:

...

> +static void bcmasp_update_mib_counters(struct bcmasp_intf *intf)
> +{
> +	int i;
> +
> +	for (i = 0; i < BCMASP_STATS_LEN; i++) {
> +		const struct bcmasp_stats *s;
> +		u32 offset, val;
> +		char *p;
> +
> +		s = &bcmasp_gstrings_stats[i];
> +		offset = bcmasp_stat_fixup_offset(intf, s);
> +		switch (s->type) {
> +		case BCMASP_STAT_SOFT:
> +			continue;
> +		case BCMASP_STAT_RX_EDPKT:
> +			val = rx_edpkt_core_rl(intf->parent, offset);
> +			break;
> +		case BCMASP_STAT_RX_CTRL:
> +			val = rx_ctrl_core_rl(intf->parent, offset);
> +			break;
> +		case BCMASP_STAT_RX_CTRL_PER_INTF:
> +			offset += sizeof(u32) * intf->port;
> +			val = rx_ctrl_core_rl(intf->parent, offset);
> +			break;
> +		}
> +		p = (char *)(&intf->mib) + (i * sizeof(u32));
> +		put_unaligned(val, (u32 *)p);

Hi Justin,

GCC 12.2.0, in a W=1 build, warns that val may be used uninitialised here.

I think that, in theory, that can occur if s->type doesn't match
any of the case statements above. Perhaps in practice that cannot occur.
But, perhaps it would be worth adding a default case with some suitable
handling.

 In file included from drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c:4:
 ./include/asm-generic/unaligned.h: In function 'bcmasp_get_ethtool_stats':
 ./include/asm-generic/unaligned.h:19:19: warning: 'val' may be used uninitialized [-Wmaybe-uninitialized]
    19 |         __pptr->x = (val);                                                      \
       |                   ^
 drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c:125:29: note: 'val' was declared here
   125 |                 u32 offset, val;
       |  

> +	}
> +}

...


