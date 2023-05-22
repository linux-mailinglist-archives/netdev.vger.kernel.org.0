Return-Path: <netdev+bounces-4227-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B018470BBF6
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69A52280F6E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 761BFD2E7;
	Mon, 22 May 2023 11:35:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AC4BA27
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:35:31 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2117.outbound.protection.outlook.com [40.107.223.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDE4100;
	Mon, 22 May 2023 04:35:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJC0tQBvXfHhvAVCPE6UhbU68Tu4edX1bmg6A1wFUzA2kgGra15N5McpGEhdCUJDLlQWm+fZm4EqD6zOVzlNahLmspL90UJmGq0gfSUOk+04zW3jr09cpIx+HItNKhReP05vIl77nW2w+5510qU1BQ1rgXOMF31c/a0uSU8mZ1g1X7DFinYvyRX0dJ+/wZr+Kg8vtao0p75yZh5of6CNPSlHzDm0tVJS3UcrzNQTzT0wRazL17fXHrnJaNdhUDwUkGkb/5XhWKDxPwruXaawA7WgMw+aUyuzfS0myCeMa+nZxlKqUZTCUYN6rQHjVY4EIHQtusiTmxTNueqWoGBdCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=df0e4ZTtmOsJVOfjKP/4uYCo4vovDtqHAcDNnmrBpyk=;
 b=MF/DUYKT8E9doimEq2elILM/r0x8nVjf91RDGRAjThL0yGoFyqBLR9ak7KvJlXRqWdPGZNSDOA5Y6p4VY+zuTyFAelUNYQdGlUYUU/TUC+g61hhK4b9u5/SohiHKPMAKSL9N3p24KQ2yODD72HCrsp+ImWJnKVv9PdBsPh6EvyDLlIAIJLXuzwLFIAmMTCKS0D11ZF1cSgDfYl8593rOR7e8bE+GO2gZmEfKd/8DCPUTSAIIqCsjlQkUKMhUtCHFqwwL/UQbkL18NfSJTr/oSiPFsoBGVOPRiGtDByiZiG+4Rj3Z2T3NI91R8nIUP+6z7aILGZfRtuWHk34tPZByPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=df0e4ZTtmOsJVOfjKP/4uYCo4vovDtqHAcDNnmrBpyk=;
 b=Ef/O3QuhKPKLSo2qnKE9/9l7rwuW8FRa7iiWo39my7/KfLrm2IP6fVx9oGYNYkH/nA6zXo/jzz/xd72eyXP/AJo8GHXErSK3kPrpJ/5/m27eP+lShvHI4cEeXGdawkez1864+STq4YFnMXAWMWCXFDK4KocduYycig8faNmX2+Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5176.namprd13.prod.outlook.com (2603:10b6:8:6::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Mon, 22 May 2023 11:35:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 11:35:01 +0000
Date: Mon, 22 May 2023 13:34:51 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com, justinpopo6@gmail.com,
	f.fainelli@gmail.com, davem@davemloft.net,
	florian.fainelli@broadcom.com, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
	andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	richardcochran@gmail.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com
Subject: Re: [PATCH net-next v3 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <ZGtTW1sNDT8si9/r@corigine.com>
References: <1684531184-14009-1-git-send-email-justin.chen@broadcom.com>
 <1684531184-14009-4-git-send-email-justin.chen@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684531184-14009-4-git-send-email-justin.chen@broadcom.com>
X-ClientProxiedBy: AS4PR09CA0019.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5176:EE_
X-MS-Office365-Filtering-Correlation-Id: d166d279-0e37-4591-ccf4-08db5ab8940e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QBLiH2YzfNex/7A0qWYgcUeGPbH9rLbGjr56HSAsSRhorj1VagbGavcNQoHZEn3vpWyrFQFcPuA8xqmp3NZK0LoNEExa6K+Jzn2EhO1KSFOaGAvOBiPxh8TRel4Qfcu2fJokwv8QLzgF0MuXTe7RyRctugiE5ZYCKhDzBMBjnII3KBwmj6p1TitHJg0vTX9Cabbc/iefMzd9eUVvXk2DVwbm3ol33yA1itrSB6NsNCyPelGBAdN3xAcbbk2WemYYOT4DNIfxso96s53zZ5AJ2VyL8jNMY4dyJFbUZ2LiGUhmLNGwkCVEnHStYkMeKAHDbaPriKrlxSgYoQYgT2M8yRvmfICKx5ycGtA9adPjh5Kz+yW8srhcDPTaDZppT7sGQShSpCQiplklNoo5jv1xWqIvNZPVPfQGIPfKzf8MXEXiDZTF+YYyIC5ymryEdT5ZPPchMfNFrJAQGZW8V6yKPPjkVj20I62n+Ri1Ua5dSTq5OPMcBNJgn0i+Eix/vYT8AlivgFNTGXuPw67nX406HrWsTXBGEYpiB2Geoc+4D6ezq3AeW+STJsfudrA3HZZrNffL4BeOdtFGn3NM4Z+dLOpzj7OrS5PQ480rCrUJWEU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39840400004)(396003)(366004)(346002)(451199021)(2906002)(5660300002)(44832011)(7416002)(8676002)(8936002)(41300700001)(316002)(66476007)(66556008)(66946007)(478600001)(6916009)(4326008)(36756003)(6666004)(6486002)(6506007)(6512007)(38100700002)(86362001)(2616005)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RvJ4BDMYilDy+dKJRBfGWo4/cq29YG31ogOJRJbfIJ5wHUQOSt8WX8nAlK0H?=
 =?us-ascii?Q?aUPXP4/rOWO3nvS6RUCrnRk+XD7QZhiNIR76TTEMzZR7IugqNQF1MBLM/gVL?=
 =?us-ascii?Q?WTOKAo/0M5Nwn866SQVMK9wo0LF1foUVwJbvj9YVyFvUbSnDKqsINprng4f8?=
 =?us-ascii?Q?jAd5iO46toMmbN3f2+5EgRSOiYE/AT5ZW0By8U1qucFkY+HYn4CpQzXywdQY?=
 =?us-ascii?Q?HuXxSV2JesKFUhRynl3+2kEJ8FyCyTXx/RiQB+j5LVr5e3/93MVd8XrM/Fo7?=
 =?us-ascii?Q?UTg6KVftuuwA/Pjz2FoHXkXMilGvnFR1ig8chvpPrUHBu4jrvXJGLN4PSwHn?=
 =?us-ascii?Q?p6PvIp5DPRRs1cMlvEadprhAj71i4jk5Jn4T+lOQIvylF7iMU6QCrMT6cIE7?=
 =?us-ascii?Q?TQq5MeDyUFwlOf+t+sH5Zjyje5IcMzgecuxsSXrF5gJRjroX6vvfWnNzlo0x?=
 =?us-ascii?Q?p0N6PX7nACqBa/FrtO2x2LhtiA/l+hb8Wiz1GO1e8nQWzspaBE8kdwifMgZt?=
 =?us-ascii?Q?O1IvE6Uupy+wReztTQX47+4HtZx7KKOQYNc3+a+MRYcJdao5ds7cFZAZNk/4?=
 =?us-ascii?Q?WlrBOiQGgs5M0/A10wtc9VhkmwlaSQI0gX9D7rBsQfsWJBF94FAVATlwz+ct?=
 =?us-ascii?Q?zImGdZ65MhN/lb5cnggM6xePB21tvzm9/tua3tIqQXJOkK5upi2u40k1Bgnt?=
 =?us-ascii?Q?3ValUyV6ZaH1wELG5GpYecETFtjt9hnuIDRrKpmDELxPdRI9DSzfifTPiXeV?=
 =?us-ascii?Q?MGf+xTk13bVcCsRyjkMXJbEaTmptV59UWaou2aucyMy/kkg5D3DUnwCg2QqM?=
 =?us-ascii?Q?wPl1EBLEAydoGIQER/vzMA9pcJaYHwtoqYR+LE3eNFOY2sGge8B2lDJcuUhq?=
 =?us-ascii?Q?EhGgCEJjfnuKGPJgEjSO6XuT+KKaHGWo1hf86MtcuzlzIYdD350DlvkTd7rI?=
 =?us-ascii?Q?UB81A+RMJSNVC2Xk4MnocjgspxZf9LCBqooGeQjnTgLQOCiu3I/IURFqwALG?=
 =?us-ascii?Q?1FNtwkTfFFe4Mp93wIExLfj9pSkA77bzqT87ejErqHgCkt0rh0qBa2D+4CR4?=
 =?us-ascii?Q?C8O9FI6S3xVIpTTdeDpffxjIWjaGAK1kYfFPxbVvzSQ3LM0XRKnvb4rcxVNU?=
 =?us-ascii?Q?xrG/k0JmN/B70Pq6QQPoiv+AsStZpLbzFxnUnJqwjTwBeiyjT6CnrB0l+Oi3?=
 =?us-ascii?Q?rCB8JCktJFo1MZAeGiCBkCezCleuMfd2qAviREFVtu/Zp+NHDdgq2sgLBZF2?=
 =?us-ascii?Q?0tRecPQa3VrF34iDH9zyIMIt69lXYGou0/gEglRn/pTMsN7ksfQc6BJ4mx0v?=
 =?us-ascii?Q?XjyMtrMD8HrpEgC+JoJYW/bRKA31uS1M7FTZa3GSbz2GMcWZO+rEee5VQ4PD?=
 =?us-ascii?Q?eo22o1hi2PYIs8xQNVWZi7fQsNR9tS1yqZotvfLliBL+upNQMPbO52zRW0Sw?=
 =?us-ascii?Q?mDai3zZKcS7f8r9fJ+uxMNHuWQFCG7Kw8c8w0RCimbkfEqaO5qKHC4thFczW?=
 =?us-ascii?Q?TzZeAe1sW5p6G2qB2Ah39cOqPvVLRXDSeQFfNpVhKtMsP02ZEakAgdgNimvW?=
 =?us-ascii?Q?hqCkXD3Yrq8wYOprftK3lOqRJ6dzq013s+t+TvOsJQd9HfE8lJ9la2GhpLlm?=
 =?us-ascii?Q?VTQlLvdUawrpq208u6mj8SZaSiUkasMeA9iMyU1z8+jQhoDIcIkSOFm4uKvD?=
 =?us-ascii?Q?+soO1A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d166d279-0e37-4591-ccf4-08db5ab8940e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 11:35:00.9243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1aAzN53XF683NTOmyymWa7C6e3F87HOeHb5GzzTuzJ1LZsVnQUB+ALxNTfq2IeIVMfhHZML2eGNIGSX3cpaRid2xTFSdAyhW5CsYPHMXrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5176
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 02:19:41PM -0700, Justin Chen wrote:
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

...

> +static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct bcmasp_intf *intf = netdev_priv(dev);
> +	struct device *kdev = &intf->parent->pdev->dev;
> +	int spb_index, nr_frags, ret, i, j;
> +	unsigned int total_bytes, size;
> +	struct bcmasp_tx_cb *txcb;
> +	dma_addr_t mapping, valid;
> +	struct bcmasp_desc *desc;
> +	bool csum_hw = false;
> +	skb_frag_t *frag;

Hi Justin,

Please use reverse xmas tree order - lognest line to shortest - for local
variables, even in cases of assignment such as this one.

In this case I would suggest splitting the declarations and assignment
of kdev. Something line this:

	struct bcmasp_intf *intf = netdev_priv(dev);
	int spb_index, nr_frags, ret, i, j;
	unsigned int total_bytes, size;
	struct bcmasp_tx_cb *txcb;
	dma_addr_t mapping, valid;
	struct bcmasp_desc *desc;
	bool csum_hw = false;
	struct device *kdev;
	skb_frag_t *frag;

	kdev = &intf->parent->pdev->dev;

...


