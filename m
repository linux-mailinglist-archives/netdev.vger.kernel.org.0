Return-Path: <netdev+bounces-6071-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6451714A72
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 892231C209FB
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D12747D;
	Mon, 29 May 2023 13:35:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9356FD5
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 13:35:17 +0000 (UTC)
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2057.outbound.protection.outlook.com [40.107.14.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB368E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:35:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRQ1ixKupan8gPlzwyzjuogqfuHpOVjxTWeC/rWVBk/SCDOTNDZcrGAMqe8ZI+uVlc9t4hf53vSz0s2knVfSJw/fynAaI9ntkTS22JRueTgCu7n+uBdXnlycJ5bzyNzmg/i13MU+mgoZk4AKK12ODA54eM6d9qxNsg1p9pxus+TWuLKdQ5qvrwMi+n2zUY+PTUpCBphTFBzPEiauOTgHU4daS4t06eDdaJSR2brCLAYD3oxrBMqb4Ud8h1o7jyUKwUhRbeLD1oPqvB2QvGKucYVMxr/xzubAQuyYiuGb/VAjV5v53lvw7rYtEL+0dGfe/VQwabrIcHNDBMZZlqorKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvCKx6iAgXMZt8BbwwX5oY6fKga/bGxW+31F4NkHRSg=;
 b=cm+65foLVDXw0qJJF1NGdau+DsxrOvx/BwQvew8C0rn8HZOW1YNaa8xzAI1epUYIly0GFegrEBCdiJ7sd1JzEQIDfqXGRDv86AlLHjYnTB868fTSjvB8VgeJUeTZ+XrOHl7Qb8715xYwuiVhSu5risSoMsb7AzshYBg6gcn3RIKWQaShgc1GpPJiYXnmNfR0D46u29lafHXhCgMuiUD+szAa9VfPj9aqtRUYeV//Hiq7+I2mi0avKFXndWyM2HyGoSeufpbUL92Z2Lwu3+/p/9DDm+Qa/+eGzIvgUgedqOqmMtQzK+CYwdmjjyzhfVC+Dtbf/SCjIpt1QxDE+X/cAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvCKx6iAgXMZt8BbwwX5oY6fKga/bGxW+31F4NkHRSg=;
 b=X1tT94CAXnRu+gfUEqT7yNnJctx8HTTSLhgbsSla6CxAEDQhiVztA9ToKcodGvTwsGHWCodDxTWBbAuRqMOYyoSaAsomiDyYAZ1eZK7SwiVyg+4EiOSZKxF9TAcTAgTSzpTDOJOnfum4B1fslPUsPDdxkn86vz4O4GgoTGDsZaU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8224.eurprd04.prod.outlook.com (2603:10a6:102:1cb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 13:35:11 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 13:35:11 +0000
Date: Mon, 29 May 2023 16:35:07 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: shawnguo@kernel.org, s.hauer@pengutronix.de,
	Russell King <rmk+kernel@armlinux.org.uk>, arm@kernel.org,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: vf610: ZII: Add missing phy-mode and fixed
 links
Message-ID: <20230529133507.y7ph5x2u3drlt5zd@skbuf>
References: <20230525182606.3317923-1-andrew@lunn.ch>
 <20230525182606.3317923-1-andrew@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525182606.3317923-1-andrew@lunn.ch>
 <20230525182606.3317923-1-andrew@lunn.ch>
X-ClientProxiedBy: FR2P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8224:EE_
X-MS-Office365-Filtering-Correlation-Id: c2a467cb-c52a-4a48-206a-08db60498656
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v7QiP2g6B0evgR2TEg1Vj4+PW1DNa9RDwESyTdGXzgksvMPrVH/eapCc09nKlNCocXlP8EqsCH+Zu99yOOoeN5uy5oi7dSDYmZP5M82SGSMfCGFKgnn3Nsw2IzTumfpcABwNs4KCq3zDRSi2HIop+BQTd9aNRuVKzBGrdeVzv7lXXtwQ/CSBoeWPXXikJKNh+FKvGE/GAmRuNKWFYhVbf7uYoOClbX1LmOqJigBoiZlgWTLX/TxC9Kr9ah8pYK6GGhhKMVs8o0hKbn8QOwNNHssbGWVBQtwXRbcKqjc0ucN/YJiIlkrfVAhXo5jLri+utigYet9pi2YMRJFk4kxc/f+uoHtxkrUM2Q/ipoK1FlOf9OdaCIgIHPKWtgPZFO2wNtsbKyxgntALkTvk21yH5IvVnz4KuS3tvLDLF+I2HZ4+GVxsHVS78Xoo0Iv+YsiBckpOYTL2fiqSbpckxgeWKxvV5asL2fR+9TCs5W/wHQOgbfn0r4XW0dE8t0WPy3JR69YW33OrRd9wtmkBfqHaR4UEVAM+64Wr5J9Z0Mq7GK/lPU1eTnPhaXEB1hprehLu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199021)(38100700002)(478600001)(86362001)(33716001)(66946007)(66556008)(66476007)(54906003)(6916009)(4326008)(2906002)(6666004)(9686003)(6486002)(186003)(26005)(1076003)(6506007)(316002)(6512007)(41300700001)(44832011)(5660300002)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9m61GS2CIuRHxWwpAd680qziHUuCFk+phJ7zhWVMNMypz4wctYjr+dxtpqAl?=
 =?us-ascii?Q?Sm7WlkD7vjZXAbXKIiklrE5fmX4vgvizdbOTE5ZwkWSWCUtjp6gE+tcPNunN?=
 =?us-ascii?Q?bkLTnM/pvcnktGz9ll5DzWZxWPbnjARMzh+/a+jBP1e8V5diyx7PgF3dv7Tx?=
 =?us-ascii?Q?rfoZIP0DesrCbWzvhMj/acfwWjtqEGOkBhMkVyiT1SECMWeVrspbmyNcYd0m?=
 =?us-ascii?Q?fDvz407OZNMNYa4BA80qRHikp6smZ2qbN3sAsWlJ1/DXi4Zu7IqrazA7lKbC?=
 =?us-ascii?Q?SV2QOAUYYlK6zq3fZsgo7BfwW0pP/2qVC2LvW3fVN0puj8WaUGzYv7xu6vBR?=
 =?us-ascii?Q?KLCUcZ0KetLP+tqeByN7fLmiY6c2NfmVAXGQKxby/7SuVrq07PfeAcMY++lc?=
 =?us-ascii?Q?yxqo2QSxkUJ7YSCQT6H48NShOo10s9eqmwGsHdRk5e5VP5lKFm9EL5PKdk/y?=
 =?us-ascii?Q?w0V62+rlbvWMxRRAOEgwrTtckBPK1PC1qhnEYN5BgMYbrGnHdDtOGUAJ2TXN?=
 =?us-ascii?Q?LZkN+5RV7fuEfxEMy1aHGwB7E+baUskuz+EUJjfOrhuiRpGVxcoxFZsZHLEX?=
 =?us-ascii?Q?+dwfMtt0udJZDG+BjMq1ogBOpTH+xjFGHoV1OLFfG2c9O0RPBwKgqZPcaeu6?=
 =?us-ascii?Q?+1H4wJznV7GQE5SxeXEECO1dUaCYpDu/iyVv9qhss5JBtRenvcp4m6vWCDfy?=
 =?us-ascii?Q?Y1bbH7OSy1brE4Y5MXfPGtlR0SeY4rdEIRud950FRToxc3tgL666Psy7zVYZ?=
 =?us-ascii?Q?whzyXPAjf1a+6CmQVAfRZbR04qrYApvicDk9GGzUXwqso+J0zuGe4S7mkbRB?=
 =?us-ascii?Q?EhEn3O3J8srDbD4uLaS/j+GDENtSlMpH/0O34R8q30kHrfOMb2hIeBFHPnAE?=
 =?us-ascii?Q?h0V4w9HBoxbBYZpZw5nDFpObs8cUR0cwwOi4Z2DlK/OzrGq+4QuBFGGLC2gE?=
 =?us-ascii?Q?rr+J4eBza/kOa4ImilYtLhZyWrt7OtANfTw5SOH+SxHj7svgMf6z1RCj7TuS?=
 =?us-ascii?Q?RLDeYLEgcPHqZVw5zwP/MRgqG40EBQRVqR8Haa8i8FIrlJNkz2lfThirRyaS?=
 =?us-ascii?Q?KGBtIX9/TtAm8PauC9chmelj1Um8Qv6hd7nxtZmM2HbHb/FEoGQog1BC4fRv?=
 =?us-ascii?Q?esfpZdFfYfQ+c9nHwrN95xt0EqwtQimgt6CeBV91JUQ6De5zy+gaXA3+IxIr?=
 =?us-ascii?Q?j9FSEZqGt45M2lBoJlkJ4iKmVD+PgbNHQkE5MDaVnXfIpdnxVASU6x5ekyt0?=
 =?us-ascii?Q?Z/DjK9Y/nmpLyNOSS1OiPeuI7h4Ni7cysUEZu51M7ez516YzcSJPR8dqdxIX?=
 =?us-ascii?Q?Ry30rJHpWTpT0NgsNkAqMKIrq+srb1N91MMg6ek8i35bAtRIqHWh2e+M6+9m?=
 =?us-ascii?Q?aRk9XImD9wkR0Y5ggNMqUyFEv2AqxlVXYs3mnaC60mF7vSADdE+HTnPaUCV8?=
 =?us-ascii?Q?OX4HJEyhNrvfgOjRYtfYounDa92dF2u8Jhm4IKCLlSqE/GkMFIkvVzt1I0jF?=
 =?us-ascii?Q?hw2sbMZlb90EmoYDrKg4oh49L/dVEvKbr0woZokV5Tsy4g9ntFe8E6upUOYT?=
 =?us-ascii?Q?XP+Cd+wGIkF9y9HE3g06yWfEhM5Km3xWExNabSmX8XF1O1LRp/+71Q3X97Ch?=
 =?us-ascii?Q?Zw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a467cb-c52a-4a48-206a-08db60498656
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 13:35:10.8479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nov5utMJa/66For40VPsT4NQEneHTwu0BASi/fngKSjBQq8CkiCwXfA1g48uEXMdLze/jKEhOGeo1Z37hhPY2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8224
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 08:26:06PM +0200, Andrew Lunn wrote:
> diff --git a/arch/arm/boot/dts/vf610-zii-cfu1.dts b/arch/arm/boot/dts/vf610-zii-cfu1.dts
> index 96495d965163..1a19aec8957b 100644
> --- a/arch/arm/boot/dts/vf610-zii-cfu1.dts
> +++ b/arch/arm/boot/dts/vf610-zii-cfu1.dts
> @@ -202,7 +202,7 @@ port@5 {
>  
>  				port@6 {
>  					reg = <6>;
> -					label = "cpu";
> +					phy-mode = "rmii";
>  					ethernet = <&fec1>;
>  
>  					fixed-link {
> diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
> index 6280c5e86a12..6071eb6b33a0 100644
> --- a/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
> +++ b/arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
> @@ -75,7 +75,7 @@ fixed-link {
>  
>  					port@6 {
>  						reg = <6>;
> -						label = "cpu";
> +						phy-mode = "rmii";
>  						ethernet = <&fec1>;
>  
>  						fixed-link {
> diff --git a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> index c00d39562a10..6f9878f124c4 100644
> --- a/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> +++ b/arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> @@ -44,7 +44,7 @@ ports {
>  
>  					port@0 {
>  						reg = <0>;
> -						label = "cpu";
> +						phy-mode = "rmii";
>  						ethernet = <&fec1>;
>  
>  						fixed-link {
> diff --git a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
> index 7b3276cd470f..df1335492a19 100644
> --- a/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
> +++ b/arch/arm/boot/dts/vf610-zii-scu4-aib.dts
> @@ -59,7 +59,7 @@ ports {
>  
>  					port@0 {
>  						reg = <0>;
> -						label = "cpu";
> +						phy-mode = "rmii";
>  						ethernet = <&fec1>;
>  
>  						fixed-link {
> diff --git a/arch/arm/boot/dts/vf610-zii-spb4.dts b/arch/arm/boot/dts/vf610-zii-spb4.dts
> index 180acb0795b9..1461804ecaea 100644
> --- a/arch/arm/boot/dts/vf610-zii-spb4.dts
> +++ b/arch/arm/boot/dts/vf610-zii-spb4.dts
> @@ -140,7 +140,7 @@ ports {
>  
>  				port@0 {
>  					reg = <0>;
> -					label = "cpu";
> +					phy-mode = "rmii";
>  					ethernet = <&fec1>;
>  
>  					fixed-link {
> diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
> index 73fdace4cb42..463c2452b9b7 100644
> --- a/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
> +++ b/arch/arm/boot/dts/vf610-zii-ssmb-dtu.dts
> @@ -129,7 +129,7 @@ ports {
>  
>  				port@0 {
>  					reg = <0>;
> -					label = "cpu";
> +					phy-mode = "rmii";
>  					ethernet = <&fec1>;
>  
>  					fixed-link {
> diff --git a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> index 20beaa8433b6..f5ae0d5de315 100644
> --- a/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> +++ b/arch/arm/boot/dts/vf610-zii-ssmb-spu3.dts
> @@ -154,7 +154,7 @@ ports {
>  
>  				port@0 {
>  					reg = <0>;
> -					label = "cpu";
> +					phy-mode = "rmii";
>  					ethernet = <&fec1>;
>  
>  					fixed-link {

Shouldn't these have been rev-rmii to be consistent with what was done
for arm64?

