Return-Path: <netdev+bounces-7380-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9707B71FF68
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:34:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 265611C20F21
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F034C8466;
	Fri,  2 Jun 2023 10:34:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE63F1363
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:34:40 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on20620.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::620])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A461994;
	Fri,  2 Jun 2023 03:34:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFzUsU2mUkQz9n/WEvojU5MLIeCY2tdT0mutvD3u+jVPDq7ZqnMux3ufLSzaZ85xYM5mECtYUOX5s/pn7tokfAggH8wCYq13C0Ogk2wGLOEPdKeN8TUwH6NoCIbGwu7WXinLYsHR+b6IbmsBeYtfEqtdiwQD/1gzX6/c2Gt8EJhye25h2xg3jedZiM5QH+YGKYDsuZC/GVUcewsPyJ9gTmoasAQoZ3RNbEFrutZ3NcL8G7ixJLLisYtTYnylJ1xf+TB+3RxyiF79PWtP4NCl/AfVfTOLYCvyWP58dHND7QlqS8lMnFBcQTkGDqsRbcechx3Re0Is6es/V/H9JubuBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4PbERXUFCsAkI8UMJs8QSIfYr2PqbPdz76V1zVbWuYo=;
 b=JE2GEdpc1HFuBb8SzHqq50Okuc02CjzKHZ3ejCa7IGv4y/73Egnqy9J71bHVGYasLcysPo7MI7ZvvID3B+CBJY2EiN0QjeJA36TiuLL5gvaftzCF+0bCIpvePhnCWWRc/oB2mXKH1Vid+iYSTbHz8A5VN85I0BIUxuPbHNiIGWA3vtTsewh8diUB/Xwe3J7A5tmE/px8SvXqxOh2MQwc4b7yn0H6WkkTyt60C6gupJ3W8Zf5S19syjWQoR0jwWKVbHws6mf6La8GWFgRGGRjeOncglpWWjIs0BpbZbuv/f7K7YYEk3/fd6RFGXJBA7Gw8JLUTL57fw3M6XuAmuU4jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PbERXUFCsAkI8UMJs8QSIfYr2PqbPdz76V1zVbWuYo=;
 b=oPP5guhULvPpqEQRcF0GshVTFd+NFMkNf+OJDV14bpnDv2a0GPwaBeSUn/IJZdVYARAiVhhL6MGHMtXF5w9YtMJEEAVyPWbSnkNBspkwmt3g/DwniANftZtlq2dcNmXxvlTIsLS6a+aytm9ewAkoLeHqaQ30vmTLVltCQIYRd/k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB7502.eurprd04.prod.outlook.com (2603:10a6:102:ef::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Fri, 2 Jun
 2023 10:32:18 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::47e4:eb1:e83c:fa4a%4]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 10:32:17 +0000
Date: Fri, 2 Jun 2023 13:32:14 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: wei.fang@nxp.com
Cc: claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
	daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: enetc: correct rx_bytes statistics of XDP
Message-ID: <20230602103214.6uzugiwjrhjcs7wk@skbuf>
References: <20230602094659.965523-1-wei.fang@nxp.com>
 <20230602094659.965523-3-wei.fang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602094659.965523-3-wei.fang@nxp.com>
X-ClientProxiedBy: BE1P281CA0363.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:82::23) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB7502:EE_
X-MS-Office365-Filtering-Correlation-Id: c8f02f6f-6e24-4107-8d0f-08db6354a3ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2xHW8jMl0YAUydrXTfbjop2zh9zydnLXgcggp0WTj2LV5ATWWVjmkPFOfgMBc+0MYd73zq4Rq2qQlnX5C3qAnoDx/z0EXrzgSdqp1WjHhNLoHmtrHRdwlvvR3AGs3eCT9SffrnYqYLwwSBpMXCwzZvEpnvO1fG+F/BbB2s+5Hisj/nZRJviagVnO8BUZsmvBurtFqLLEYrCqDbsrajDajNrkIfqW5rvylafyCyszYVYHCQvJRwIFcKH67vnQbdu/2aMkdDhLUcdbmKqlDv3/5HhvRuOo0A5HHWLOiFAajU2uDIz9OZ4u3SbUYvpS2oPz4Iv3E/Yb2wGdqdURPhJtw82CwAdNyrdR/yjP0v7jPTaj7VS2IccdPqT8MclqMfoOHt696iwwvktNpVZbZdm6lyMK9Vai+XwCaJNzCdoZedNF3NLFT0n6td1ew0NRpcQ1aRcQIzZdF5fnpyAhWScn3kLu9uz7PXeBP57KU+X4fgzUGzSaWyBMccyExhcFFYM4q1yo6F06o6VaoOktcO7sFKlBDeJvm12H+BPYmWQ+qk2Ups73xvAMXu5uY53jXkAm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199021)(86362001)(7416002)(5660300002)(6666004)(6636002)(4326008)(66946007)(66556008)(66476007)(33716001)(8676002)(38100700002)(41300700001)(316002)(6486002)(8936002)(34206002)(6512007)(44832011)(2906002)(83380400001)(4744005)(6506007)(186003)(478600001)(9686003)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+QsLJgjnqFWnZ0ntDCoXFVEAiqA9P8IGiwyGKjULVVbAtzcgqHH+XcUMBp9W?=
 =?us-ascii?Q?UPjZbOepXE5NySAt4pt/AfXLyWz65Wa45s3EJFan42H1GhBSkydZiuWSnJuI?=
 =?us-ascii?Q?KdjGXry9YCYsze7qODUROPutpVMwxkYHyFIJsV/IwHgJBr/EeKjxCDLcw5ol?=
 =?us-ascii?Q?SXRRdwknaABE62esV+cOBuDYZwrEySUvkLa4yxL0PPSDRqfcPZ88FHlU9G1p?=
 =?us-ascii?Q?+NsSjPQSCNkc+bpK9m+SOSRCzB3gleYJfQh+dC0RDUhpp5zOxab1w7M8+0ty?=
 =?us-ascii?Q?+3KhSMSIqBEwrWcmq1dKMttf0kdVlcgJavAO4vxm8JY63cUNbTPynnvcoKpb?=
 =?us-ascii?Q?ViRZvyb1Tyw8vJ0uu+vPp9t6wVSzBJi8sVs/piaW/aKzpB3wRseofL5dZpzD?=
 =?us-ascii?Q?bCuSNKgXxpYojdSmnHtlD6oHgD22GBLSdyNdMvAYI4b17XK+yPl2oOJiZr3w?=
 =?us-ascii?Q?isMRUe/6Rhc+6Te211Psb0pXq2ptG2/JPaZjhvP4jblDG1GUj1YT+kXVw8WA?=
 =?us-ascii?Q?CsyHb3HZVZBRfqHMZemf4qxSUXRXOMbpX/NJGQ0Wx9zVHrZiCkbB00ruBr8l?=
 =?us-ascii?Q?CK9aY9TavMn6pWozsXa83r45rpZ1e6SWyGeNSID0G/AOm0O1hVGAZeAGUN5N?=
 =?us-ascii?Q?pbM8j1SitHuhPRjzTj1EUkLjcg5vYFU+zNZLPh6j1X8B5PEyyiAWDDhusEPT?=
 =?us-ascii?Q?PSu6QPxnmJoAKEKDW0TOqXaMoMVVtqr4cynsf0AJ5v/qMLaLYgz9u0QbUCOK?=
 =?us-ascii?Q?D9tZLawosvlKSVIGyL3wnI5BXowgOI1sAtGjn89b1CsZkwVB53+G5hx+LZvx?=
 =?us-ascii?Q?yadq2G/w2Nykbh6GXgaoJUfaKatdxlKIN3PO4Fgx14ZL9R0jA1dNOQT+2e2k?=
 =?us-ascii?Q?eVhRUjXIsb9ZRwTEqvPC/Sd0Xo0UB4FTSA7d1q2+WUi+vcjBTIjz8BJDu6be?=
 =?us-ascii?Q?TeQpnZc/vMs7rtMVWBye86MWYhB6zzMRrnIWTDfUBtbJ7WE/sauPQ1Vg2soU?=
 =?us-ascii?Q?jy9Wf8UVuIlXyzrsvuCBGNmPDOhspp8Z96cIMIYIysa/AX5cQmzU0S24yDfx?=
 =?us-ascii?Q?42/WFU7SBLOS9+or0EydTshmYx/hfL+IF+VrwM+iiBWZEUpRrdnZpl2qNJlX?=
 =?us-ascii?Q?1ICqTmAstWO57yE6eb4SiBiaQmTlX37S+p1K2w0i90dO4/PHP4Cf7Mll6aL+?=
 =?us-ascii?Q?AesT92RR3impfsA/Z318edZiRlki+OeKyygPxNdnVmTurfKfShZvtowumH1N?=
 =?us-ascii?Q?mGF25hMlRwxb94TLEMQVsRnnwyByEnRaJl0EKYuNsXKiun/bZ0ek+Tn7LO1G?=
 =?us-ascii?Q?3GefyzdE0D/WeIFJGDOBi/f9kqW0J5QOoxFY9/gkelRGwpOkeQg3Uhiv3w8v?=
 =?us-ascii?Q?K/qUMMmPY2oS//t+jg8XFyQidjn41jn124tvNBKDhjXFIwbF4Tj28jMIhiGN?=
 =?us-ascii?Q?EAQ4NrO5UmCl0irnGPDTrqlxTUQQSXwXcE3ReXz+jCP5esYtD3mmQP6TKv4T?=
 =?us-ascii?Q?UXPBUeqNgeWvKF/KexwdtT08aP6JG6tHFPnHuUcdfWnR4gfnVLyD4YrxvVRP?=
 =?us-ascii?Q?JScfCt8riiDN/+Ojy5IvDybE2qiD/w8qHIl1RENaMvnD5Ok7BwLnOEonEElB?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8f02f6f-6e24-4107-8d0f-08db6354a3ab
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 10:32:17.8756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqc5DYA0yxkVLDGZ0QLeXegOy7+KXj/3zYGci6SKu2axyF/5J6NVnyKxB3NsxCNntYHRhLbBExs7ldfY/s8BZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7502
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 05:46:59PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The rx_bytes statistics of XDP are always zero, because rx_byte_cnt
> is not updated after it is initialized to 0. So fix it.
> 
> Fixes: d1b15102dd16 ("net: enetc: add support for XDP_DROP and XDP_PASS")
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks!

