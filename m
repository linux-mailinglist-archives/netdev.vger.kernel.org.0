Return-Path: <netdev+bounces-3852-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BF5070925F
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:01:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3BA4281C0A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CF2D5698;
	Fri, 19 May 2023 09:01:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2783D388
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:01:20 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2103.outbound.protection.outlook.com [40.107.100.103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E667E56;
	Fri, 19 May 2023 02:01:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eaq5QfgqRYmgrt3VJke18xJLg8fDQYyT4Z4mB4n3hSNowdSluKaP3xBshWGXLQK4ESrK93Bw9MQSvg4XGLjzcMbsjzCkgtw/LV+LvYFz7mH7J9xPBlDn2JOeOdnmwv6DmxprLxafx6tPUC29fKaOHT5+vH1zW7xf50evEwgRt8FMujOmbwpmzeV9j1fNK7FjBrSbyGn9XreO4FeGEMRMNQOabnmYqNtu5dD8OHsJSJOi/jKhxpevkl3HKuyLhDo+TjSV8zdSaGKThoWAddfitwztIcWELQtWH/tMY92hiuEV0F4cYzydirk29f1lsEqSD2+vLh/RX+9M8V1jnoE+Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9cTXMQjxCbsf8OJ4PdCQtrzXacOYRxjN+ow4tfwd9MI=;
 b=eZ4quRo3fSjSZSGTZ/VJuUEn2HiZGmUGs4Kg0Pox+hwPDM1wYNxvptq9vou4J+e7Il2/yRf5JkD3od8PG5K+wnaKJdSPev5EzJCRxucrb9wydry0ZmHDddGz+xA0jkb1xbI2d6i+gx6z+1yUMK9l1Lzp4N0HeTySkrKZON+ESxXbMb91Ame8Z5Vi7OZU1tJ79KQMD85zNmME8kn576NptyOTo9jergJD0jfz+bGilD0CemteAa/Y9gYplXokML0NWKv5fy4e6Ehcl7rup98Qcp0VPByxSAzBdxVteLNQ8YjRl+fsUnzqKwn37uAP6BQqCiI3mFZqZLN8wDo+CG8kVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cTXMQjxCbsf8OJ4PdCQtrzXacOYRxjN+ow4tfwd9MI=;
 b=vCHT3Ub/kgzMluAv65m+O4K2kn68neWwahXqusrAosw7PtL89ZsrAJbXTDl7M/H7i+ebVpiH6tFWmQPKvBf71RsoA+JkcEAU02kemyJNicxD7uo0PTjSeFYrKjTEjCTkGahwgOQd81Px0IO5DjPkxLoKsXj8hmHx3pJSB8/7LE8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5169.namprd13.prod.outlook.com (2603:10b6:610:ea::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 09:01:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 09:01:15 +0000
Date: Fri, 19 May 2023 11:01:07 +0200
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
Subject: Re: [PATCH net-next v3 1/2] net: dsa: microchip: ksz8: Make flow
 control, speed, and duplex on CPU port configurable
Message-ID: <ZGc603g8Pjp4Umke@corigine.com>
References: <20230518092913.977705-1-o.rempel@pengutronix.de>
 <20230518092913.977705-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518092913.977705-2-o.rempel@pengutronix.de>
X-ClientProxiedBy: AS4P191CA0015.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5169:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aa84249-89f7-43e6-b71a-08db5847993a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6+pR6K7mfH3uEtLU3/zamEy0gjIReyQO/sEoObKS7rqxJQeogKVsGSiOqao/JsyZP+88LRvkhuXWakGg+KjduHhF4wEWJyI0r8SlBqJNDQdBsM7rI+fsUdPwfMre3tEV+AgqtZ9AkwBjm/BlrkYbM5iERaemPKW27jFn9XVZi30rjAXlOeMVikmsHjtzOABmI7Iayv56VnvZhgaIu09Bsgu2ccOYPCfuAzdd0wAxE2ffFWmJ3qUN7oPovUOHVdrFsWdG+U/jLrwEOh6MrU7LEwy+Ci/ZY1UmNFv6eJ7wxIK91tkp2StemuoOtdG3ERWea4rMhNMeJHwa8eLq4QfqX7FTC2VA+/8whvExqvsvfRGoBTY9hYPYh2VAThssWLhbSWhlYk0ZhTJ+Ft3q6rDBvg4nTJ38X0UpF0+vKvy/RXkmMQ5xTBxjaeE0SD0QLCAlB5musDHJRCAurKzaJmjMQwkH1xZ7fbMJARZc/WsaC6BdZVItw9e3iJVdFBJXJuo/n+g7bryfxRfbWOjI6x/QMVmF0c4CvifWmAKwiLzvcsj853Orer6GOmxdY7pmual8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(39840400004)(396003)(376002)(451199021)(4326008)(6916009)(66946007)(66556008)(66476007)(478600001)(54906003)(316002)(86362001)(36756003)(83380400001)(6512007)(6506007)(2616005)(186003)(41300700001)(5660300002)(8936002)(8676002)(7416002)(44832011)(6486002)(2906002)(6666004)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bnaslNdFfxDprebzc/Qc7cy6tcT600XZP4Qqm2k8p9m1Hub05wK55/Dlb3Rn?=
 =?us-ascii?Q?IywLGlHSOrvoJZYasq9S6SrzK/ZZTcc1hUdztte1boY/+jdlF/Ghq8FaJ4+Q?=
 =?us-ascii?Q?j4JDbBT3AqriqDF/fynCR7PHYXmpdPT5C93brbfQnV7DMxDg8RI61r0OQx+7?=
 =?us-ascii?Q?DIYfe0hYer/bcWmKZCtIGsA+RNLn57Zsia7EBCyCAtfnJ6s7JaELUrjzYE2b?=
 =?us-ascii?Q?UsZaRMSo5TQ2dK88whtXq+E8uufCY2iBPxdRRTmAv5OhlOMWu9G6ZmEoRWeQ?=
 =?us-ascii?Q?M0tBwEYBgK0PEJT3wJPfFiAe9KfVlSPlmmhKwJjA2LVxD0WaEX0JhueJLf7l?=
 =?us-ascii?Q?cGdyISCYRBDFgOzxVEpoQ+9ZXh6rHIMx54FJKo9HUG0C2/7MYQEevNy4BoAF?=
 =?us-ascii?Q?8O4UUHbpVVFsss6YYOmk37cA497xbI0MJretKJHfF6V63Hv+eEnnXpXB98Pb?=
 =?us-ascii?Q?6kfcLFmbM7FxApPvQpcKUxmeFurB0tDHZFBeQ8/u+vmolbJp2oUVx5LVPwHK?=
 =?us-ascii?Q?bFkx8Shc6Eaw7NLhv7dsOBuhfqWOiTREnXNrO0e12JGl30sQ8UcVxLdoFiEe?=
 =?us-ascii?Q?jfY0Du0ECeLxviuU4P9PUsle52xtbbJz947J2MWvULkbZr/S0Fg/J0APj+ST?=
 =?us-ascii?Q?FzVnqGws4Trf4iNLb7roa5q1NVIbk61fayUlIu28Zu63GZYo46gLGhoTYHzf?=
 =?us-ascii?Q?9Qo0DmrongXG2mxlOdvK+UuJaMdqEgethQ1dTEfZX9L/a+ECUXnvlW/M7WlJ?=
 =?us-ascii?Q?RktwHpwmN2WtzxomuM+Ef8jW2eKnI7YgHus0bHM61Bq6n6O2XQyQrPBslE0y?=
 =?us-ascii?Q?y/0a6+nU3IRa+eYZ3xbkD6Y/F5h4MZ0nTGjWLRX1y+DIJ9QQi83QvGu8RZK9?=
 =?us-ascii?Q?bXaf4DsZIQhFSLQni3j9f6etD+zX/ke3zNjgemIwsauPKwys9QqWqdS8DgsH?=
 =?us-ascii?Q?8fj5uhGTvn/KomFgGSh5cO9k4v3bwMzMfNEKyyf5SHI26eIBU1r110X/RxXd?=
 =?us-ascii?Q?qxiyWhVXNS2/J5BdvQbYxg/9j7YfMaVwu84Q+Z7awxQUgR7Bo2Qhhq8JarnZ?=
 =?us-ascii?Q?Dw9zjSWIeuxaqh+4MpQ4Et88rTNitBfZ4FCOXuDGY4wsl+HWc/5v2GCNhIvm?=
 =?us-ascii?Q?8OCsI1cQGjCabBx7HYJytSB7MgKyGppkgNl5ihO4O4HoUpamtdwJDuFQvb5v?=
 =?us-ascii?Q?ju9A8+5me1YsZwaQ6hTmD91/oaJi2uVnqKWz8kcc/bG4LmjiJBdN8I7tjnj2?=
 =?us-ascii?Q?eICcM0t0jFsWy92kym1R6py9rIw44QDkGgHY8MRS/9Q/xewUa3TXPSVnrb1w?=
 =?us-ascii?Q?gd4NOurfJHPMH9DdIEwQx6BjvqSckWgfADgVS2me/eBMk5r1efHdeIZ91ENY?=
 =?us-ascii?Q?2a5gm4ma1LxaKyWHMRknPVa3kqcf2DrUZYsPBauOL9tyq2PY6I83+ts2vSqC?=
 =?us-ascii?Q?O2p9kVB9/R0Juqe0VPgySStZsGJCqiYniQGhCkNsKURWZpbA8OqKCavocjB5?=
 =?us-ascii?Q?zvKRsRzoZkjeeOeKGjSKVIHCKXagLfesr2Fxmz/M4Kv97pC09jvTreuRUGKg?=
 =?us-ascii?Q?/fmpJNADWJFr3vnSo1H3E2Ut6KwV08byT1jrlS4GPlTzOvZ7Zpl4x7u/VH+a?=
 =?us-ascii?Q?H+BKVr9R+61PY9zVWv1TuhZfDhsyJpbE7o/vfEdjxNKNmB9RAUMbQAaHbEJb?=
 =?us-ascii?Q?30rTcg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa84249-89f7-43e6-b71a-08db5847993a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 09:01:15.1876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IFbRGvRcZbsMMeWN4F0vm5t0mEkCflhH7zkz90TZemPNLKxd4K8KAC4/1EeYpJ/aDIN+JUuyOb6RudvY2S4Kw/7juJJ8wtvDowYQe4co40U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5169
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 11:29:12AM +0200, Oleksij Rempel wrote:
> Allow flow control, speed, and duplex settings on the CPU port to be
> configurable. Previously, the speed and duplex relied on default switch
> values, which limited flexibility. Additionally, flow control was
> hardcoded and only functional in duplex mode. This update enhances the
> configurability of these parameters.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index f56fca1b1a22..9cfe343d2214 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -1371,6 +1371,55 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
>  	}
>  }
>  
> +/**
> + * ksz8_upstream_link_up - Configures the CPU/upstream port of the switch.
> + * @dev: The KSZ device instance.
> + * @port: The port number to configure.
> + * @speed: The desired link speed.
> + * @duplex: The desired duplex mode.
> + * @tx_pause: If true, enables transmit pause.
> + * @rx_pause: If true, enables receive pause.
> + *
> + * Description:
> + * The function configures flow control and speed settings for the CPU/upstream
> + * port of the switch based on the desired settings, current duplex mode, and
> + * speed.
> + */
> +static void ksz8_upstream_link_up(struct ksz_device *dev, int port, int speed,
+				 int duplex, bool tx_pause, bool rx_pause)

nit: there seems to be an off-by-one error in the indentation of the line
     above.

...

