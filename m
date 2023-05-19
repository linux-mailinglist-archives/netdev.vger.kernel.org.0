Return-Path: <netdev+bounces-3854-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E1CD709289
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:03:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C9A5280F65
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F156569C;
	Fri, 19 May 2023 09:03:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F1F5698
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:03:54 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9451C1988;
	Fri, 19 May 2023 02:03:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BW3+KX2guWyCvmem3Ep4CiQwNiw+JjvnRT0IcRIMs3toCNbucaf231wbiDIrwsCplgZlwKt46fwykIveoVheJAQw9vNIwKVQjPVNWW1anX1Eey9dO/XyGNw1lc83MSiAXrPD2+jSo8q7PdspO1K3iGP3hJWB3TLuI38M0NW0j39UtGtleLdH5WelEzqno6svWm9jAPdDyFD0IlEnqYOusnqCnYvZUfE8/Qg6zKrQeDQOhJsUQs4bmtYMw1BWIb5rSkpUEv0bE0aCj42ZTm4+26COqlhsXA9Ubj508w5kC85u2DPoaN0K4ZV839Yt4RVRsY6BWceWc8vYqg3/Xtz9pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRX/hUM7cCAzaLs+Ic2alsQ0rXC0oJcJ3f4NoNSmaUQ=;
 b=iWPTpEyUqJzEtVxlvNEjyL1fk8XdsTBjUPnzvUk3Fc+K9M0xXa4JkUihhCiIHWkIqNsj61gLQaBal8kPmykkj3e5sKLHDXbSBXF+x4WC20xIpcKAtiiUuJj4MDPjWOiugkEiC3z7mR34Lr3ZYBYHsh2/Z/fRKv2pjI5AUsu+sXWJbYRUwqoLccIWl4U9m8PDTrCHoB9unTZsMqDtGeGnT6OmnMvspCKjoTtIGVrzgQHKlU41dYqdVyW/jMrpCojatdkqooFRiBYMOFPj6O3+Qdh2C1tkDBFwqO7bxeXNbcXKpizb9vJHGGS730GQRgzCHfUzGV4S0PH2SDvj2DtjYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRX/hUM7cCAzaLs+Ic2alsQ0rXC0oJcJ3f4NoNSmaUQ=;
 b=SERMzXRgtZcgAVddnCpvcvhvXLx7isEwFGpmgnlx5rNwm/ueLlUk1DjPGVizbSMQm5szs1QuRfGlxgtaWlgTXYz839ILUIp9PzG8KNKKK5n0pWQSCofVPfHMr92cd5EBeB+/5eWC1J7nO+jBLFEFexqBynj47axcLju90CFNmIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB6541.namprd13.prod.outlook.com (2603:10b6:806:3a7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.6; Fri, 19 May
 2023 09:03:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 09:03:21 +0000
Date: Fri, 19 May 2023 11:03:07 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	kernel@pengutronix.de, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 2/2] net: dsa: microchip: ksz8: Add function
 to configure downstream ports for KSZ8xxx
Message-ID: <ZGc7S7hp5DMmNh2W@corigine.com>
References: <20230518092913.977705-1-o.rempel@pengutronix.de>
 <20230518092913.977705-3-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518092913.977705-3-o.rempel@pengutronix.de>
X-ClientProxiedBy: AS4P192CA0018.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB6541:EE_
X-MS-Office365-Filtering-Correlation-Id: a805750f-8ef4-4c1d-e729-08db5847e4db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oOqfWESX/KZuUTp2r1CJdGqyhB4s5FydNimet6dZcGVnXZ5qux1qCiRsha11bn2qZjSGy80OFWNx98xHB4vAuv0OP8LIDducK5GsKmBI0v2In0vdt7eHMN1v5Cwkd2dyrk+/4ifLBTcjwcM2wN+06VfNRgOMbR3511Ww72eCXY/7rubbnIbBWRfXYb42BjGnM0Kq59ciqsKpgQSD4kTCYFBX7kTnILdDMuZmYt7EevK0OuYosIWuwnFwxFmp6Dfa+eyLi57Fw9OoYGdevRn5E1wx5bUYnc2dUcqGWxeIR+oeqIdn4WK43SooAC6jkG7WMHPQL8fzjYKHGLUmvB1S4UKFMN++3LVxsOm/Pp/dAOUgL8eIUyxhYjPfnw0Y8iT3u6wqHnizEyYXHQlHDnY4P2TNldpyEGnLLuKaRjdttmLZUfSm2UN0ZsYb9c51q+o8YnvKQuQj1iba6PVbbRECiZj/DbHexXRYX5zFMnHZr8TyM1tEKNcgNBsbsMF7nOqdiEfkg5xptBD7tw0xRvSpLTjN9mM6gxLmuaI2oj9Qi1K2rGNe49bc+aS86kZQE0u23Qr6moVk9I4uxvCDbTwka9haIAEWBBGkgPxap+O78/HGHDTeRfOon0BuDCwJAT8qLFhJufd8CpF6N1GHEnONQg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(366004)(39840400004)(376002)(451199021)(8936002)(316002)(2906002)(478600001)(41300700001)(6916009)(8676002)(4326008)(6486002)(54906003)(44832011)(7416002)(6666004)(66476007)(66946007)(66556008)(5660300002)(6512007)(6506007)(186003)(38100700002)(83380400001)(2616005)(86362001)(36756003)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L1HVEUUD3TVGlL6jXJYcLEHz3vJtAu138KcrwQVqD65eoULsaYjRHHfLQh4z?=
 =?us-ascii?Q?U6NLnRBukuyq/4inwmyxIUV4RBGIBYZOwwDZFIW8woo//DPd9U0wUNZOJ9qI?=
 =?us-ascii?Q?DG0P3SpeW8bcUSlJIGVZ4f9wa2Hp+XNvwgehedW9EYyvxgRKzEgz1d1A/qln?=
 =?us-ascii?Q?VHGvsYLQpo/FyNRezPrb1D9cBbm1fkqvD+Am79CPgyvHj0vQxi41t8iNV3wm?=
 =?us-ascii?Q?H/bTkpEWVMkXZe5LOIaGSJO5fojMF5FBuK0+RLV5l4VYDr9JGM1AHnYkBBdN?=
 =?us-ascii?Q?J1ZJrqRby3uVIcolp7vdRAMBZa0yCoPSlTntriUiOEO0TfOaIHq1f1E9bMXb?=
 =?us-ascii?Q?AponAwwhAY5mqD85Twq5EuFUpmBtGvdYH0Kcp169zpVRnoCD9N3bTfbvX+Kr?=
 =?us-ascii?Q?0x70GegObI7xffR64vnpy7fJVG/qYHJUsxGpzvwYNCb3l166Anu/7Ndkhjj6?=
 =?us-ascii?Q?L2kOkvAkHwsIBXg8LF7Hx+7lGEtcKNZxu4cHxg4Q8DKBsr66MZOmpmDjwdsV?=
 =?us-ascii?Q?YWl9bPaF1WppTzFtmMCmjWTWInVSNWYIm6rbtERqR6LgibmwK1u64vysCtUV?=
 =?us-ascii?Q?znS6KdJ813ynExuoZlLx4JEtJgBwzqhHT6vp+qkHstrf/XxH+Lk9jrPFzgOj?=
 =?us-ascii?Q?OMG8ZWtGYbdtd57gWth5LkCx4rzlmVman6cpD+98Yjy+4mNGJ/VX8jVi/3a4?=
 =?us-ascii?Q?fpzyZUq0+v6Qn3NfU9JhmzLJXOBzudhrZAReB5eSgjCf2IoOb+Ep3WFFqiOM?=
 =?us-ascii?Q?l11Mn2BKZTIA2Q75PxgVv6ASojmS9AEW98/V4Zi9Bhteu4BoxzvphUh7wr6U?=
 =?us-ascii?Q?T6LKJ4a4yoMB2v1T1fGmqdZKONtNOvWaznA4Mtt087XHXlEUXccXPkNLQqvF?=
 =?us-ascii?Q?K/3qZ2sYveymVCt6Ceonf92iXcMr/b6ByyqUizEeZy7HRvoQZt7dSGYK756q?=
 =?us-ascii?Q?fkMW45wzVWMOX4aHqKgTYBZy8vjKBPFD9ODY0JpBGhXk4FCc5Fo6JqtSUzRa?=
 =?us-ascii?Q?Ll1RbxONkk0ihfMQSj0geXV01yzy7P3adaC2yHP4AFb3oET17w4anxnuTfmb?=
 =?us-ascii?Q?iHwB6BVaI09lCgwTVAp3SUp3pIlEFQWHiomKx63w8L/0D/RZKMmKpYi35ukV?=
 =?us-ascii?Q?/YjswttDUINzQcfaGedxa/gYw/VLDxQkg5Jz2YRdUqPhqYjmmRtKJGNicfVh?=
 =?us-ascii?Q?8ta4yYglNnYqfuhJUBpshUrfiveZ+VWVKZ5zdJDBZ4X9kOn+GX6ay0kIBgFb?=
 =?us-ascii?Q?LfkktChaPYiS6hugsbbb1gbKL+5oS68T+pnphn60rpkekAO3M0/DvF3rcXcV?=
 =?us-ascii?Q?ByR7xgJlhA8QxMvpr+0GK1pC7TRYZybhR8kQy6KV98rOdoWK57rJau84fxSl?=
 =?us-ascii?Q?+PMAkZzN5Bt2o6hudFtyAX7VPZ/HEbOG3Ale/3uJTbLh6X/gVggytGFmP69p?=
 =?us-ascii?Q?MbyvCyg4AMWOslUdp+euI6QeGmlfRRidl0WFAzUX/MAKoYm0RMTmGYM+cTcV?=
 =?us-ascii?Q?av5TBpy1KFO0vn/dGSB62QNOm9ezxFIA//132FzDGpDgLWus+h9ss3pUMe2j?=
 =?us-ascii?Q?gzLfB4sxdhiK0WAHadRtHSOxMI71nJQ41Mf9nI28CLlscrY93nvx8yQqmuyv?=
 =?us-ascii?Q?JWEsP3IrcQljt+8T+6Ragrne37BN2irkr/BOUqyxXkMhUkURK8YVa0EQHVT4?=
 =?us-ascii?Q?MkyT8A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a805750f-8ef4-4c1d-e729-08db5847e4db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 09:03:20.9918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tP5AwSSGhHRTgacTpbbjuWS31uK827yBgS0fes5wyGQcpMajtaYSn9ye2PHOBlu8O7cbNSfjtGElilJVQhHYRrP42QP04XUksleWGUz8f/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB6541
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 11:29:13AM +0200, Oleksij Rempel wrote:
> This patch introduces the function 'ksz8_downstream_link_up' to the
> Microchip KSZ8xxx driver. This function configures the flow control settings
> for the downstream ports of the switch based on desired settings and the
> current duplex mode.
> 
> The KSZ8795 switch, unlike the KSZ8873, supports asynchronous pause control.
> However, a single bit controls both RX and TX pause, so we can't enforce
> asynchronous pause control. The flow control can be set based on the
> auto-negotiation process, depending on the capabilities of both link partners.
> 
> For the KSZ8873, the PORT_FORCE_FLOW_CTRL bit can be set by the hardware
> bootstrap, ignoring the auto-negotiation result. Therefore, even in
> auto-negotiation mode, we need to ensure that the PORT_FORCE_FLOW_CTRL bit is
> correctly set.
> 
> In the absence of auto-negotiation, we will enforce synchronous pause control
> for the KSZ8795 switch.
> 
> Note: It is currently not possible to force disable flow control on a port if
> we still advertise pause support. This configuration is not currently supported
> by Linux, and it may not make practical sense. However, it's essential to
> understand this limitation when working with the KSZ8873 and similar devices.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> +static void ksz8_downstream_link_up(struct ksz_device *dev, int port,
> +				   int duplex, bool tx_pause, bool rx_pause)
> +{
> +	const u16 *regs = dev->info->regs;
> +	u8 ctrl = 0;
> +	int ret;
> +
> +	/*
> +	 * The KSZ8795 switch differs from the KSZ8873 by supporting
> +	 * asynchronous pause control. However, since a single bit is used to
> +	 * control both RX and TX pause, we can't enforce asynchronous pause
> +	 * control - both TX and RX pause will be either enabled or disabled
> +	 * together.
> +	 *
> +	 * If auto-negotiation is enabled, we usually allow the flow control to
> +	 * be determined by the auto-negotiation process based on the
> +	 * capabilities of both link partners. However, for KSZ8873, the
> +	 * PORT_FORCE_FLOW_CTRL bit may be set by the hardware bootstrap,
> +	 * ignoring the auto-negotiation result. Thus, even in auto-negotiatio
> +	 * mode, we need to ensure that the PORT_FORCE_FLOW_CTRL bit is
> +	 * properly cleared.
> +	 *
> +	 * In the absence of auto-negotiation, we will enforce synchronous
> +	 * pause control for both variants of switches - KSZ8873 and KSZ8795.
> +	 */

nit: multi-line comments in networking code are like this:

	/* This is
	 * a wrap.
	 */

...

