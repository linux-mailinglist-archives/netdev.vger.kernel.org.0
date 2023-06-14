Return-Path: <netdev+bounces-10706-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0A972FE48
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:18:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9F6C1C20C9C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8208F64;
	Wed, 14 Jun 2023 12:18:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4EF8F54
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:18:10 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2064.outbound.protection.outlook.com [40.107.22.64])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3801BF9;
	Wed, 14 Jun 2023 05:18:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGL4xgRJFjyDohz8THTI6wDDMQ9YtOUwjsifj1eTFSor5zahUOvSkx3Eb4oS9pWP4OjOedgKue1DM4OmNk+DeG2m+1JlWNgK+CoFw2N4R5BoiRG5YIg0RV+VZQWZX9Li3oDdmQmSiMbPH3egM+XOFhLlcakojNHSm99cdti/YECvtAv6QjeXvfYd/2REo2txgy+yBAaDtKWxDpJnl4t7axIb9MOOTPdqLmAVw2cX3kIOXCwQB1ILgakMytjZ0IVnns637OTbzicFQPxVZ8i+lp1lyLN3+940keAyx9SzPQTIeVqhD1oy7EOiyCCOMGqFGdlN0jiMrS+rstVZzmbZnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5X5aMsn6MdBrJOP8SMja17jVJKBiRcZaoocLDArrQ54=;
 b=lEHRx2m5PIiYdOeaQxM3AP2vaWZQX8tKxNbBdTbVlZF1vB4ATJKlVIjhIDskurU7SGFZXVPA7aVNk8ISZh29aBQcmTp4drGqpi4MhOU+zYQpdzkFHKuTCLlHHRZbQrmVL4nW42589ae37hmXpRbPxFOzdWT33AyB/7lx18qO/wHXW8hvtRsPv6VE68WWPuSbPok+jfRfkuXdqdbFWSG1JgWoLOJRJQB24FzPFutwGJoO63uWIBWVR0h1avMBu982Ha8oj2Z9pJxdHMnAVp/0taZsAjAfWC2xyhqNzrt4hJoY4QDnVkh5Y36byuSVFYXirrdMKhV/GukvOZGt3GA8pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5X5aMsn6MdBrJOP8SMja17jVJKBiRcZaoocLDArrQ54=;
 b=iu8YpfXAVnde4rM0bX1viBPTAtta9kb0e4njB9z8xhRLWCHLKbzp7s8U/a45v3CCURleB1PkklOwqV4mbxqA+ABnQ4xX9N6USWopNv+VMzItMwwRNG9OJ73mAaF5Ns4kp1UByy1v7m/EaiPIfS81V7gG4nABQ3nfj2O5TcdWNkc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8322.eurprd04.prod.outlook.com (2603:10a6:20b:3e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 12:18:04 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 12:18:04 +0000
Date: Wed, 14 Jun 2023 15:17:59 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	UNGLinuxDriver@microchip.com,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: felix: fix taprio guard band overflow at
 10Mbps with jumbo frames
Message-ID: <20230614121759.riazt6xiskk74h6r@skbuf>
References: <20230613170907.2413559-1-vladimir.oltean@nxp.com>
 <ZIms+0/KDpU9dd3y@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIms+0/KDpU9dd3y@corigine.com>
X-ClientProxiedBy: AM0PR03CA0099.eurprd03.prod.outlook.com
 (2603:10a6:208:69::40) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8322:EE_
X-MS-Office365-Filtering-Correlation-Id: 1eea202c-0218-46a9-cc6f-08db6cd166f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lYJAN8HD7Tyez6tqSnu0l58KQqB3eZepk5r7CB5RDCLMolPGk5Cy6FFH10fT5P/izN+8yZ69xA+D8qzSDC6O3b/e9zWl7kxvmBlugfJ5NLDUw+G6seXD3Wwxj9VJ8i0gWz68aAAjHaDlKupblnA7hr3dbYljROgtc29uwcMX1Z+IJejbsEhDMyf65TDPJufGzrH4Jp2irjieAa8p8iCzloSZJ4A2EiyM0oRKvao0zy+3wLsxDEInZ4WaM84cBgl5sV/1zwwNK7BeFtxeQkO+xUUsSjI9L/1x1L2SzWtG7DCGgcH5AHrOe6Ah9X3mqABt/x1Fg4ooLorsF1x6RuPRWE+BfMCdAWROBUB5MwiCyox0S4IcmeV9v7EABIH8FU+e8o28H4pWjyPywrA22LFSGQ5SctmmSFoI/I3HbEwfKJjyFW2JqBozrCs0CROr6hIblR0+HEj2vLAj/ijsJ79HICeL+fLqqTWmlDyGvVda5P1wRo0SbknZMqMui7TLZeYYMET8bnFI505ykQmPQZ4xN06RZiPJ0YbZdBNHMJxmR4j2/fenmCs+lxXhowTGaJII
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(451199021)(6486002)(6666004)(86362001)(9686003)(83380400001)(38100700002)(33716001)(6512007)(6506007)(26005)(1076003)(186003)(2906002)(4744005)(54906003)(6916009)(7416002)(316002)(4326008)(44832011)(41300700001)(66476007)(5660300002)(66899021)(478600001)(66556008)(66946007)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JEysA1PoKslj64uVWw+4P4h/ZTY2Y2FSSpE3LsyQjZdj49te7YI9EYHoMcbj?=
 =?us-ascii?Q?SMzs+lODfXi7HUEWnXP1i0kGyRnc/uZot1n6oi7699UCAOw0X2HgFgLZzpmr?=
 =?us-ascii?Q?JGLNcivovIeibXStUFvtnEtyOOrHsGnmTz5atqXOCqXpmgaar0dAAnZVIwg4?=
 =?us-ascii?Q?ThYYL9b3IJiamIXRYDfXJ3MqjwVK4ySeIVlGx+McjVQljmoXyaFT4UezwM5x?=
 =?us-ascii?Q?aJzHE7zKyUWKDuN38MU7yF12JoaSQgLE0cWD2XwTkPSOvuWhmcytdPuq1crB?=
 =?us-ascii?Q?wAhTFDKnEj86G1ykKVEjwANq3f9UCjvt9kM+ofmKdRriOjXWTHsJRZ/dFgav?=
 =?us-ascii?Q?r776Tt8EhGjpOJnixMEtTSsc5G430lWu4OdSW/A/AnYwHzgoKuNgDF9ShfWK?=
 =?us-ascii?Q?Zyp6PFiUq/28NgrKLYpNq+rKt+3OwnNXr8x19PDfbuHD6vNXjTi6KB6mm+fV?=
 =?us-ascii?Q?fOyJkN+TuEhBq5BfCzq8f3h33PY9dKDexmZBbQkapn0IFZwtf+KZGFs2oWFz?=
 =?us-ascii?Q?JqhSL6m9Wg4n3DZ/NtRIsUrGNDaxW745fRGhdJz+JZcTm5YBmWlvRyX3O6ou?=
 =?us-ascii?Q?LnUbjpykmDXBZSnA3Al6xDuuWwMG53KTNlSwPjUGJkxy+yTcOLil+NPBcDos?=
 =?us-ascii?Q?QYkxFUbYyrL4cRmD+kWzL9Pr3P6rOHVh+EELmKZc3j//q5OVqGcSi0wcLI2F?=
 =?us-ascii?Q?zj4+y6h3+RtYCskRXVjpd+a5pT/x0osjNfeGnsvNagyzAnwjNIxs+zhwcN0i?=
 =?us-ascii?Q?ZF8xnnKt7SHkHYVcI5/FeEQVMu4REcAhNJHpNDjV1VI1+COEdPihQy8NoVeX?=
 =?us-ascii?Q?s5LfPWa1lJInPAk6U61w6biw9hzH+A/Xw2MkFgkSkb4JL9MXOdmfFWWHpCQh?=
 =?us-ascii?Q?y1PXKnccboSC+atuzDQ1VUCRYvb/4wtkz8Il6Nj6RyCcTfTUoRn2rk359zyv?=
 =?us-ascii?Q?nGFeAO9+rncyT0wyyiyB+Eqh46FLHo0hsctkwrNtP+c1RTeWda+GsH3yyJge?=
 =?us-ascii?Q?DTeG7UK1BX9ZHnqxLKoWICdRA4cH+ci7HXyYBWrzYTlbPBhRBfZal5njV+i3?=
 =?us-ascii?Q?GJ+tK9Wy6wd9fzPH+5K4t3L3Q6mW6xbmWVYvLnzyPtsMfVvvVA3esA5Sb830?=
 =?us-ascii?Q?gDk/T0GGVwv7loYEfswK13ih7iq0ChZpeBc6dhcxPFLc2BuvS6kE56GMeDlQ?=
 =?us-ascii?Q?qDtLFwokXSQu0xwSLvCiydijeqUpnwC74fZviwT+xpLT5iGG+92vnE0yOWTS?=
 =?us-ascii?Q?tWFqyt3wlWhZIbpRr0KW/HlwghYJqlgqfcrQIPYAdeN98HvAMWBTXLpAyeDP?=
 =?us-ascii?Q?r9bP3e6RS5trTTKsg6Uy3InctDP6W/vreWJa2OQrhnZyisArPX2I/F2O7R3I?=
 =?us-ascii?Q?ALYJoLnf07TS30vrb9mOeBxkAbWTzCk40F02VxPJw3JJEJt4cPm39YfUbUrJ?=
 =?us-ascii?Q?lJ3KgyDzhU8Z7A7l5POgWwH1bQHuPcpA8xeTZgtkKD2Z2lzqqAYkkM7yZhPU?=
 =?us-ascii?Q?zWCbPvZ4M9p/PkH2H1ZTLMd5e2pF8rnBqtpR6e8L+emp2j3BegR/DHRA/igG?=
 =?us-ascii?Q?4hlkDGQsNdfthlQtGhs4CleZ/G2mse+9KkCbOh+vbu4b5fXLpVj2ggerF0Y2?=
 =?us-ascii?Q?kg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eea202c-0218-46a9-cc6f-08db6cd166f3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:18:03.9177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PsuqnaHCSCZG0K7jFRFHKP6NNM7S6yi8/avTlPJrElI8QYTY9sKg5LYUAsL1R3HrJhf3MeWgRaTSYrZAju/VoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8322
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 02:05:15PM +0200, Simon Horman wrote:
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Thanks.

> In a similar vein, you may want to consider the following suggestion from
> Coccinelle.
> 
>   .../felix_vsc9959.c:1382:2-8: WARNING: do_div() does a 64-by-32 division, please consider using div64_u64 instead.
>

Yeah, but there, there's an earlier restriction for cycle_time to never
exceed NSEC_PER_SEC (1000000000L) which fits on 32 bits.

Nonetheless, it is a good reminder that there are too many disjoint
places in the kernel already that open-code the logic to advance a
taprio base time. It would indeed be good to consolidate all of those
into a static inline function offered by include/net/pkt_sched.h, which
is also warning-free.

