Return-Path: <netdev+bounces-8540-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC59B7247AF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:27:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61CFA28102D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460322DBDD;
	Tue,  6 Jun 2023 15:25:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E5037B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:25:31 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2112.outbound.protection.outlook.com [40.107.243.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA3F10D1
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:25:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4yXNvzWVkHFc9EYS6zhgw0n+x+7trLPk5/ISFfeArKbFBAp8/wToCg7rKEN8HzAk/iQ0goRj/XPm9cWZGhDW3aOEtGsYa8vMVnglSBis9vyJe93+eaB7fR13pmd7sQRFYrsnCjQFRQuBx0PsP8ANSC7rH7i7QmJFoy1ThB7vGf0tiWfS+tx7xTc8JiTzlh8hvjBICEgy//Z8Y280XHCXF6MJkwuwbLr7iaATqldApWVAk3nyYOzyW8Bxo9c3fXtmjHkY3HpZ3Ol2xQHq+G7caI5tXH3nmkI833iyCN9mcLEUXdKn3dmG5vT/GfUtEgAJ28HCNuMacrujwPYEat4Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TrL7IhnUNymw4cI5DEbDPnuuhoNxIqnsZnHCmP7Tel0=;
 b=f6xIawjIDDOwjYyzITgTRDeNrTClQhU/l5uNg0YdRZcF5rseZE58C4QrVpVyq15pFMnG/KMFUKAKXqpZ5a642XeyqwV2b/VjR8TiAWUv6lZaeKuriaVr4QTwYcPiWQO1kuMs+l/ApAP2am9XVDO95UNTV58uhtSviRm39xvegkXt7NA/jsGs2fkwslNWkHcm2HNIerpSZ/fMjvqjgg5BEr8cZ8AmaeZ7l6cmwkTOOhpEtFpTMFRnTNn4tAmQDDhlqO0es0bDLd9nt2CEVigm8xjYM91jP5+xV8Bszbv1enTwdo2jR3GYeGsx3x+YpnICmeVJZp3E4AsPfLarMEXbnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TrL7IhnUNymw4cI5DEbDPnuuhoNxIqnsZnHCmP7Tel0=;
 b=LNUb4PNk89cqMQVmvzH0GENUkUh6+f6EGs+hQL9JhMhK4ihtZtJpYvqYELnj6uMe2F2YEKlhaDe+o/qkoTs07kyeIcq192NvDbis8rwGhTKgPCzGj3ntULZ3QLvb4EK0SerLYi/nKSM70zkgLuIjOJ5T/rGWLE6eoyKuwKeCl24=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4627.namprd13.prod.outlook.com (2603:10b6:208:330::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 15:25:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 15:25:25 +0000
Date: Tue, 6 Jun 2023 17:25:18 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Marcin Szycik <marcin.szycik@linux.intel.com>,
	intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	wojciech.drewek@intel.com, michal.swiatkowski@linux.intel.com,
	alexandr.lobakin@intel.com, davem@davemloft.net, kuba@kernel.org,
	jiri@resnulli.us, pabeni@redhat.com, jesse.brandeburg@intel.com,
	idosch@nvidia.com
Subject: Re: [RFC PATCH iwl-next 2/6] ip_tunnel: convert __be16 tunnel flags
 to bitmaps
Message-ID: <ZH9P3hXDcEIWzGqQ@corigine.com>
References: <20230601131929.294667-1-marcin.szycik@linux.intel.com>
 <20230601131929.294667-3-marcin.szycik@linux.intel.com>
 <ZH2plrPDtUdmjL7w@corigine.com>
 <63ccadd7-316d-cb1f-b1d6-4f2911120959@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63ccadd7-316d-cb1f-b1d6-4f2911120959@intel.com>
X-ClientProxiedBy: AM0PR08CA0017.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4627:EE_
X-MS-Office365-Filtering-Correlation-Id: 0165b890-489e-4553-baaf-08db66a24031
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nxouR1Je/5Z9CMcxT3A8JNNF8QKzl8DDZrvufcGjEeQmG8rsJurV8KXYKxV2K0uzTUA+9wnNcELgh2JthhahDwL+erZXD8yqM7GP1OTc8+Lcj80Vpi7kLvJxgL1XXWr7u2ZpOahXz9sAshviZjnxBwhapV8h6sBW/sdX25BMWxSx8ItqflfHw4C21ZYkLrc33YfyLMTst44E0/OS+0qTKShqLgjn9nviqC8hFjjzt0+Nj7TcchKsL5206EWFj/6bDuIusEBKOPhT8B4sGKVPSDuloMNuxENYUsRbCUQZVSNqKUtlGHYUpHz7T1Mrl7auKS8cd7PM104o2F3+9udJ+WyaAtEqBk4TqXuUrSQJS+dLyXAw7ydg8EU93CWXgd2QfinCpikXhFLNTVjFy+Aef2scan0gQ4QbiSdQsJYOHwKseL8kJXZZppzJOPoiDpJFnBRZ1PoEc2uWszYbbS/jsDR5F5Gg+5KKJdJitUYh9gyJQJemHuG3Zfu31w0FE4MuAAaFzvGbwb1edaChMRvXfz87m4fpY0IXathePp+16PdLOwUSEM9KAcWJqt13Ie6rA4hJHXMW8yO8MbrLu6neRjIu/8+ynnuD4bdDus8dWT4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(366004)(396003)(376002)(136003)(451199021)(186003)(478600001)(6916009)(8676002)(8936002)(4326008)(41300700001)(66946007)(38100700002)(316002)(66556008)(66476007)(2616005)(83380400001)(6486002)(6666004)(6512007)(6506007)(86362001)(44832011)(5660300002)(7416002)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkVaQ1BMa2t6RWFHMnBvRXVESE9zcVBqSUhxUWNOblo1Rm0xZkdGMUt6MVpI?=
 =?utf-8?B?d2JKWWJLU2IvN1dIRmFvbGh6bmNrQUZVQTFVOXJrQVA3NXVHNFJ0eXFvcVQ0?=
 =?utf-8?B?K1k0QXZkeFFrZ3V1TGptaU02bVlmYytsRmQ0Z0J5NzJ1TzNZTisxRUpUT0FR?=
 =?utf-8?B?c2V3WE94Y1FGRmZEYzU0dlJ6MzdCWVNNQTVHVzNRNDB2aXJZaEZ0UnBVQlNF?=
 =?utf-8?B?SENRQ0IwcGdaT2dJNVM1aDc1emR6Z0YxZG1McHRXam5hcTRTQno0UVlxV09v?=
 =?utf-8?B?YVZ4UCt3bzB0c3hoL0RTUzhUaHlLUEN1M1dkMndSYXM4OE83dzQ3MncvcVFl?=
 =?utf-8?B?M2QyQWNnUHZ0dHU4T1pLYVU1VlMwRlBlYlZBTVE4ak5GRk1jTmZVb2ZhMDA4?=
 =?utf-8?B?M0FLWTNLN3FFQTVxYU94bFRsaWtreldFVHBFSzlZVnIwMlltckpNd3Ixc0ta?=
 =?utf-8?B?U0RKTnVRaHRiZmtZWEFLN1djYzFPTmU3V2tDclhzS3dnUFUvRmFjL3JvYlg2?=
 =?utf-8?B?U2lmRk9SaHRMNFlxTzRzcjR1M1BPV1NTQm5SZEdNR3J3dHg3cE5lZ3JkVVEx?=
 =?utf-8?B?SnV0c0V1NHdXV3E3M1NWWC9VNzRQNWVHcnRPeUNkZHJRTnovYXRvRGNQemNi?=
 =?utf-8?B?QnBxS3hMc2hFNWgxQXlXZlc4R1dvZlRtdXc0RmtBdVFlczg3by9TSzVKOEoy?=
 =?utf-8?B?NnQvelg3aUZJRjhIeEx2MjM0cFFNZjZuZzVndHBpQWgzck9SNXpoSU5MMVFx?=
 =?utf-8?B?Wm55Y1VDWjlpOWNwZGZIZTZpazVLTndKS1FlNDU2UzBLMWRnTHo3Y2tCb2ZH?=
 =?utf-8?B?TlJESWtTUTRHNVo2eHZhbG4yR1Q3UTJRTUlMVVZVRmJCbldRd2RuZXo5aHEr?=
 =?utf-8?B?Ri9HV2VQWHZvTU9TKzVYT1U5RmN6czVMR3o3dVhQWmVaZHhpb1RFb1FUOS94?=
 =?utf-8?B?eWpNQUlNVEZqTldyUmJjMUp1aFJ6bWtNWHFIRFFrTmo4SEtNaTUwUE1ENk1q?=
 =?utf-8?B?SDIyMGpZUUUvQi9ERmlGNC92a2dZWkdCbUtXNzBFZ2NiRmw2S3ArMWlINjl0?=
 =?utf-8?B?ZHFYVmlFa09XTkovOEF2aFA1dkpQY2VZU2xrdnFENG1SWWEyMHF2QXlCWExG?=
 =?utf-8?B?V1V3Um9KclQzUHF0dnJ0R3dTQkVuQlE0MFprZFMxUTlKY3Y1WmJYd1JlM3ZG?=
 =?utf-8?B?U09WeDBuN203Z2pWZVR4YnU5Y0g0bnVjUzRtd2VOTnFrcEJ2RTlxQzlMY3R6?=
 =?utf-8?B?TWp4UDd6ZUpMWEJSUXRzNGJEdlV6RDV3cEdNY1VOQi9LRUpyNW9nOVlZaFlD?=
 =?utf-8?B?cnBBd0YyOFdzY0YwbVlUa08yeFIwVmltMzB0Q0xOQWlFbmdOYXNpUkF4RjlG?=
 =?utf-8?B?MnJWeS9zQVZITmoyNlhRYnozSytlUzhLRTdKc2V1aTRVQU9XQ3A3VzZ6NFlJ?=
 =?utf-8?B?L3pCMTdRUEhzWXpZT3hBTlZCcHJNMmFyaXZGS3RmcHM4VHcyREJLSS9jbldH?=
 =?utf-8?B?NmQ1V2ZRZ1VyZWFUdi95VnVvSEM5MWZJZU9uNTRzemVyLytIRnpIS3plV1NJ?=
 =?utf-8?B?OFUrbnBzYWYva2hYT0JkT2EzYnR3K1VOQURGYUY4TFpEOVVmRlErUEtOQTE5?=
 =?utf-8?B?bG1EYkRROWJRNlRZYldnQzUwYkpQMmZyZDVUb201eFJsaDVvOENPWG1Bdllx?=
 =?utf-8?B?c25UUHdMTXZhTy96QUQ5R1lxVkJJdm80alFsZWhGWlVKUCtYbmtmY3Bsc0pl?=
 =?utf-8?B?YjZ4bERid1daL00xNEFaRWJXcTVGNnpqRUh1OHV4am5nak5VaWlRbE4vTlN0?=
 =?utf-8?B?QUJaK1ZqeVNTUTZFcXF4SjM0dTJFbkc2RDZnUjdQTTI4T0l0M1RJNUc2TENx?=
 =?utf-8?B?K0w4Z1dYZ28yUDNKamM3VTV1TjZZc2VpQXk3REhBMlQzWEdLV2NIUy94KzE0?=
 =?utf-8?B?OS9kc2dib2NIcU4xeDV6S3FnY2VZc1BWcXVnSUFIUi8wSnVrVi9ab1R2UWxP?=
 =?utf-8?B?Qmx6MVVkOS85UTY4M0xmNmg2YzNmQWxVSU9MdnF3YnlabXZabXkzbVp4bUFp?=
 =?utf-8?B?cXNGd2hMdzRiV1hNZzFYdjNiQjQwOXl1Yk51WVpsQitDb3RXWmtvdWhueE1G?=
 =?utf-8?B?TllGaGFGSW1ta3ZNWmJnSmZObU01ZGtEZzJoeDdnaUhGaVhuR25nUi9PMUM1?=
 =?utf-8?B?UnRIeXJrY0Mxd3FibHdpT3lqdHZ4djhNWVc5MVpsOXJIOTNJbTRKZE1LcUda?=
 =?utf-8?B?OUcrYW1oUE9pa2c4QUFhSTlra3pRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0165b890-489e-4553-baaf-08db66a24031
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 15:25:25.2223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gNQe6ft+IxgvKtTSVMkMnvy63Kf605mkNpXQLAvTcdNUzN/nQIbIeSxCQmDrXK+WL3BfWrHUBLFSTvkRmvxtUcaBa78naqK+TPGtgqs2pmg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4627
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 03:17:47PM +0200, Alexander Lobakin wrote:
> From: Simon Horman <simon.horman@corigine.com>
> Date: Mon, 5 Jun 2023 11:23:34 +0200
> 
> > On Thu, Jun 01, 2023 at 03:19:25PM +0200, Marcin Szycik wrote:
> >> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> 
> [...]
> 
> >>  net/ipv4/fou_bpf.c                            |   2 +-
> >>  net/ipv4/gre_demux.c                          |   2 +-
> >>  net/ipv4/ip_gre.c                             | 131 +++++++++++-------
> >>  net/ipv4/ip_tunnel.c                          |  51 ++++---
> >>  net/ipv4/ip_tunnel_core.c                     |  81 +++++++----
> >>  net/ipv4/ip_vti.c                             |  31 +++--
> >>  net/ipv4/ipip.c                               |  21 ++-
> >>  net/ipv4/udp_tunnel_core.c                    |   5 +-
> >>  net/ipv6/ip6_gre.c                            |  87 +++++++-----
> >>  net/ipv6/ip6_tunnel.c                         |  14 +-
> >>  net/ipv6/sit.c                                |   9 +-
> >>  net/netfilter/ipvs/ip_vs_core.c               |   6 +-
> >>  net/netfilter/ipvs/ip_vs_xmit.c               |  20 +--
> >>  net/netfilter/nft_tunnel.c                    |  45 +++---
> >>  net/openvswitch/flow_netlink.c                |  55 ++++----
> >>  net/psample/psample.c                         |  26 ++--
> >>  net/sched/act_tunnel_key.c                    |  39 +++---
> >>  net/sched/cls_flower.c                        |  27 ++--
> >>  40 files changed, 695 insertions(+), 392 deletions(-)
> > 
> > nit: this is a rather long patch
> I know, but you can't do anything with it. I'm changing the type of the
> fields from `__be16` to `unsigned long *` and they're accessed in a good
> ton of places around the kernel. This patch is atomic despite being
> huge, any separation would break compilation ¯\_(ツ)_/¯

Yes, I concede that it may well be the least worst option.

