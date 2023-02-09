Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74FE690E1B
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjBIQOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBIQOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:14:30 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2114.outbound.protection.outlook.com [40.107.93.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4730F1F5C7;
        Thu,  9 Feb 2023 08:14:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7kQ/wi9tAYq3KA8AkEescJnyzrNZyPBYfQDmAZMZm3TJfrWoaz45jVXMgP0zgGcBqaEWPUc3ylM9eTvrYlvE2oABVizZeD+DsekCZiwQqoHLJYxxoCQFkrgEeAl4hMQWAaEuxXYpoqQkK4vDWDdoHe9CmKtfhg4UW4z3QxM6Ss+ZziRGbKbYZzUCM+vhDHSMO4VGx7tjyyR+QsU6/ddDsYQ7Kbza4qAWcVWaRfYXte2FEmYulDruTFGUHGQ76yDLK0UeIhWWC0N6+ntAY8pIKLfQUVHdahd9UiLoFSZg9Qj3FnDO5kv5KRZ2bhJkBReC+TFRp0tJ++Quu+h8gkYkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2J/A2lN11CnK81f1kKhwWwxGk8CTvIOhhC9VVszwCc=;
 b=ZqvwOVYBXb5VP//lzzrPEkqMzL/SDSyztivNNg9HsrDanXFfe0EaIB8LKDFOgjPaQvmlSaGN1UkHQF7tqS8GJn84uvuF6i43N/t1fWTRkzgps+yDdq3TolOflUIK6+YVlbEXSqvDNidL1FyHDtQFU4Wgw6M9/mjRnpimFzJOIfQa1o7EJmnbCnr08QE9yTBy5LqXuRO1jSC2RxmqYY6qXYySz+gBa+BspaUr8IEr1mySMN6YaRfVQCgjDuTvCa40V5jWSbil2r+n9T6jcBueQL3LedlEPHGW6Am5z93PLO44iMmnyMBnuE4tV5Z4pZKpOWRAvtZUeACe8JawyFZTzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2J/A2lN11CnK81f1kKhwWwxGk8CTvIOhhC9VVszwCc=;
 b=R1vCXS1pdL6+8vms5DJ5JQvvxAlwITqWa0o5iujHlFUMdtPn6ldKgh/M0pMQ5MBwT/VeHDx6OCzxEZSB19dttXyJdfokgf3S8nioeUSvmBcczWHZ4OPNqQYJXlN3y+CCVShrrUTytQAlnB6jOr7ktNnpTaxd0W9KQewS14L0EkM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3902.namprd13.prod.outlook.com (2603:10b6:208:1e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Thu, 9 Feb
 2023 16:14:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 16:14:24 +0000
Date:   Thu, 9 Feb 2023 17:14:04 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     wei.fang@nxp.com
Cc:     shenwei.wang@nxp.com, xiaoning.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: fec: add CBS offload support
Message-ID: <Y+UbzKvqbXwe9uxF@corigine.com>
References: <20230209092422.1655062-1-wei.fang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209092422.1655062-1-wei.fang@nxp.com>
X-ClientProxiedBy: AS4P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3902:EE_
X-MS-Office365-Filtering-Correlation-Id: b0076c75-7296-4563-5f9b-08db0ab8b58b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ccKpgYn93+807PM8nObXRWxW0p3PVLCkJhk4c9bEds3g/PMC53AyG5eBC6g2AQMvVA9S9P6sT6sTxEZmwszxm3pEGJFsuzlXPRzFzOFekdnZvMGiOvXnvYeXFxgHvqD7pfJj4vXVo77GfE/moXSYdrI5bGAfc6MfOCtr9rjZd/C0HneEbC3eO3I4c4fUTd//nqA/YHzfxcNheNONait56BsOk8g3m1Uxp9S2d2NH1FXt6TRXYBOwi4aeYcXj3m399sPsB6S1vG7/Ir3J9OBAiYJQX6SvEEXZm4ohGXcYORq+3lA/dV4+h/grartslKXz4RUwttCCagFNRBv4SpaprR0WgZ2TUOS3ufWs5GQmVqN5AmpdB3G+Z6v3f79WTNxKGM1P6qJ48MKifGhs05nGdIrfJy9a/FxNOogw0/0sY4C/dPfSwxxM4UAeaWaaIH0A//1MJPj68giD9hyM4K1dexQtsApiO3AWdu/Qxr8EUszalKnJb4Ajvr0UQ0KggRjwyfe/vgCYw4tWKQO3l64XaiS4yMMSK2BylkCklxwwnSf9h7IcVEdI71sneOUuGk0l4YiwuIHXP8r5gmnFAX3+irN/hAeGPRksGugqybt9Dllgu6ESMfI+YDSs+x5tI/BBMd3ZUo98t2AjfHBFVtiV4vdglDQ37YqYDkWBaOdQy0j4G8FkXBZVS4p5Bse8+Q64HOJAQfJjQFSVUpDRfZ9cK1m/tMWqUG5PLUYzyXapNlC/V9809+gOzMMS+OsPn1Fr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(396003)(136003)(376002)(39840400004)(451199018)(2616005)(316002)(44832011)(6666004)(6916009)(83380400001)(7416002)(186003)(36756003)(6512007)(4326008)(5660300002)(8676002)(8936002)(6506007)(38100700002)(66556008)(41300700001)(2906002)(66946007)(86362001)(66476007)(478600001)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uWVE3dIgGUMUOc4L9zmg13g6BcsslAcudcEDNM3lITyeV8Z6WV71QH6yFSXH?=
 =?us-ascii?Q?7qgmqgCAhO63/SBbbyn0a8EvO1NFDd0rljPlB+BXChcdm8n3dJDe/ilh4u97?=
 =?us-ascii?Q?o1QiCu0hjbgu442OY+v/A8QKmwylFLuCtm4xsrp+/4JqrqaIiMJSzUAF8GAy?=
 =?us-ascii?Q?BplQKhPhugB9TU0ibFIf+kj86tG7zu46dvNhroUlY12OlywkFu6/T/ZrLxnh?=
 =?us-ascii?Q?+zllAWRhMIxraLxY2Z8DXqIXf141ywzHCC8D+m1Y3moZPQuqzuh84CD1yYHt?=
 =?us-ascii?Q?KB+tFrYCAk07Fpb2sLgGxpybmIhYJfwf2EXcUpfq+eTKG1iNWoqV6Sh5Q2Zm?=
 =?us-ascii?Q?c0c1LX/ISbB04GsRgr+f4DcwC+FOp/T2hYO7rkh7ApyMb+vAMgWfiVZRD4yb?=
 =?us-ascii?Q?ZE36SZUQWLU/kiGMs6pIt4YunC+NiB7xNYZ4FvkE44RlnLMO2DB90EkGIsr+?=
 =?us-ascii?Q?0Zh3bMYD9ILsBfbtd/sHXEtn3Iz6HKtx0oq9ULIwzT1mp/xPfpcLG0sXpdR1?=
 =?us-ascii?Q?3Pkjzt0d8D2hYFa2dRFOKT0LKbjUBDu0+f30HE8Y3ndWaYnfEOyrhM+G0Imn?=
 =?us-ascii?Q?kAJhwTcVk5AioKVzIOidl+k/o9Rt1E4Pea7oyTvCyYme5z57g8mkluL3pVsJ?=
 =?us-ascii?Q?1yfPOFfHg09IN4F77u11g+HWdqkZdoa7mMaIOp8hYGAJt8APY47SWBCR2J6f?=
 =?us-ascii?Q?t10GaZZf6sGB04eu9qoozZCXnjK/0QZ9NJ7K+mqdFdB3XUaVPnEAjpPlhcE5?=
 =?us-ascii?Q?pgKMoT0Ym949vg7Hv5RqOAUtEZ1ESZ8Ued80M9ukPBj1iqxEeA/CXPuId2cR?=
 =?us-ascii?Q?TEMjRbpnMRkq+ZDndAa4jgL4lPGF5p5qrX0PsTuiGPOX86tkB6BUJjPUvPz7?=
 =?us-ascii?Q?Re9hTcRH1FL11tKFfu4aMZNCqEkxp3GEkZgxpDcehXNuxmfeL8OrX/MLWp2K?=
 =?us-ascii?Q?eVunt7eknZe/EirFeJg0oaqumgOCVZYplQF1lm+lF1rxzTtUnK5rkhJMyLuQ?=
 =?us-ascii?Q?JYDPbqrx6EIO6bAod0JDU9qKU6t8CEUjql18OM57KphW6rjE25ODAcbJvJCk?=
 =?us-ascii?Q?Z8cta1qbMBsArIujT2+SnufCiiv4Pe6c/Q7XELz4Bre6FDaDbmWvfGwAxre0?=
 =?us-ascii?Q?V43y9Gbwotm6SvS0GGvJfPW7u5cxKm8BFrlsQ678fMw/5uW8qN7+EsvinI78?=
 =?us-ascii?Q?iHaauMwr2zd8h5bMDdC3pzhxhBYBnAOCQ56eurDtFeQiEeZQ5uiJTcKKLan+?=
 =?us-ascii?Q?S020Q0q4ByP6ri6aHVnHAf5mrH3Tf9zzLQ2eta8Op3zunmhqjxh0nlSRIaCz?=
 =?us-ascii?Q?lQElcPZy6pT8+rLyXrSqCEJhDjqoPp7Tn4paCOMpZs+B0heJ1DcKCzYYP7uY?=
 =?us-ascii?Q?BIKqPrkaW//lC5AtUVioxtgfZLIMB+IKOIOSaJDbv9a40OiQRlc1pYHXrfZR?=
 =?us-ascii?Q?JnXYtq2fS2uQ2qSbkTM5IAyC7xxWTsSZHxgvIhT8Ex0n69F9wpeLB1NMLB9w?=
 =?us-ascii?Q?ho+tM0i80pKAnJsp6QAk53QdgEdXv+TGWcr4Qx+awvnFAUBMQnGtcSL3fvbh?=
 =?us-ascii?Q?cg6QMLDJ4c6X/Hu91u2Vtr8WBXTwRCXhTO4/Mf2r2J5VrLEf4sPSUiYxd6fn?=
 =?us-ascii?Q?LkZfXMciKCIAu2qZ+RUC2jo0qkM8ZZAMT6EruKgF0kvQ6eoDUo5ctXVjebIm?=
 =?us-ascii?Q?SszKmg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0076c75-7296-4563-5f9b-08db0ab8b58b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 16:14:24.5389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I/EDXEaHpPeiOQblzi13+QA+a6JO1jPUtYrDf6S1Fdr9euUVZUy7VlpFSbIMJy2Qv/BR6zmvhHw8+XupDafDJ8jIOidIhKOMov1JMI3h/xk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3902
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 05:24:22PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The FEC hardware supports the Credit-based shaper (CBS) which control
> the bandwidth distribution between normal traffic and time-sensitive
> traffic with respect to the total link bandwidth available.
> But notice that the bandwidth allocation of hardware is restricted to
> certain values. Below is the equation which is used to calculate the
> BW (bandwidth) fraction for per class:
> 	BW fraction = 1 / (1 + 512 / idle_slope)
> 
> For values of idle_slope less than 128, idle_slope = 2 ^ n, when n =
> 0,1,2,...,6. For values equal to or greater than 128, idle_slope =
> 128 * m, where m = 1,2,3,...,12.
> Example 1. idle_slope = 64, therefore BW fraction = 0.111.
> Example 2. idle_slope = 128, therefore BW fraction = 0.200.
> 
> Here is an example command to set 200Mbps bandwidth on 1000Mbps port
> for TC 2 and 111Mbps for TC 3.
> tc qdisc add dev eth0 parent root handle 100 mqprio num_tc 3 map \
> 0 0 2 1 0 0 0 0 0 0 0 0 0 0 0 0 queues 1@0 1@1 1@2 hw 0
> tc qdisc replace dev eth0 parent 100:2 cbs idleslope 200000 \
> sendslope -800000 hicredit 153 locredit -1389 offload 1
> tc qdisc replace dev eth0 parent 100:3 cbs idleslope 111000 \
> sendslope -889000 hicredit 90 locredit -892 offload 1
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec.h      |   4 +
>  drivers/net/ethernet/freescale/fec_main.c | 106 ++++++++++++++++++++++
>  2 files changed, 110 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> index 5ba1e0d71c68..ad5f968aa086 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -340,6 +340,10 @@ struct bufdesc_ex {
>  #define RCMR_CMP(X)		(((X) == 1) ? RCMR_CMP_1 : RCMR_CMP_2)
>  #define FEC_TX_BD_FTYPE(X)	(((X) & 0xf) << 20)
>  
> +#define FEC_QOS_TX_SHEME_MASK	GENMASK(2, 0)
> +#define CREDIT_BASED_SCHEME	0
> +#define ROUND_ROBIN_SCHEME	1
> +
>  /* The number of Tx and Rx buffers.  These are allocated from the page
>   * pool.  The code may assume these are power of two, so it it best
>   * to keep them that size.
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index c73e25f8995e..3bb3a071fa0c 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -66,6 +66,7 @@
>  #include <linux/mfd/syscon.h>
>  #include <linux/regmap.h>
>  #include <soc/imx/cpuidle.h>
> +#include <net/pkt_sched.h>
>  #include <linux/filter.h>
>  #include <linux/bpf.h>
>  
> @@ -3232,6 +3233,110 @@ static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
>  	return phy_mii_ioctl(phydev, rq, cmd);
>  }
>  
> +static u32 fec_enet_get_idle_slope(u8 bw)
> +{
> +	u32 idle_slope, quotient, msb;
> +
> +	/* Convert bw to hardware idle slope */
> +	idle_slope = (512 * bw) / (100 - bw);
> +
> +	if (idle_slope >= 128) {
> +		/* For values equal to or greater than 128, idle_slope = 128 * m,
> +		 * where m = 1, 2, 3, ...12. Here we use the rounding method.
> +		 */

	Perhaps the following would be clearer?

	 For values greater than or equal to 128,
	 idle_slope is rounded to the nearest multiple of 128.

> +		quotient = idle_slope / 128;
> +		if (idle_slope >= quotient * 128 + 64)
> +			idle_slope = 128 * (quotient + 1);
> +		else
> +			idle_slope = 128 * quotient;

	Maybe there is a helper that does this, but if
	not, perhaps:

	idle_slope = DIV_ROUND_CLOSEST(idle_slope, 128U) * 128U;


> +
> +		goto end;

Maybe return here

> +	}

Or an else here is nicer?

> +
> +	/* For values less than 128, idle_slope = 2 ^ n, where

	Perhaps the following would be clearer?

	 For values less than 128, idle_slope is rounded
	 to the nearest power of 2.

> +	 * n = 0, 1, 2, ...6. Here we use the rounding method.

         n is 7 for input idle_slope around 128 (2^7)

> +	 * So the minimum of idle_slope is 1.
> +	 */
> +	msb = fls(idle_slope);
> +
> +	if (msb == 0 || msb == 1) {
> +		idle_slope = 1;
> +		goto end;
> +	}

nit: maybe this is nicer

	if (msb <= 1)
		return 1;

> +
> +	msb -= 1;
> +	if (idle_slope >= (1 << msb) + (1 << (msb - 1)))
> +		idle_slope = 1 << (msb + 1);
> +	else
> +		idle_slope = 1 << msb;

	In the same vein as the suggestion for the >= 128 case, perhaps:

	u32 d;

	d = BIT(fls(idle_slope));
	idle_slope = DIV_ROUND_CLOSEST(idle_slope, d) * d;

> +
> +end:
> +	return idle_slope;
> +}
> +
> +static int fec_enet_setup_tc_cbs(struct net_device *ndev, void *type_data)
> +{
> +	struct fec_enet_private *fep = netdev_priv(ndev);
> +	struct tc_cbs_qopt_offload *cbs = type_data;
> +	int queue =  cbs->queue;

nit: extra space after '='

> +	u32 speed = fep->speed;
> +	u32 val, idle_slope;
> +	u8 bw;
> +
> +	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
> +		return -EOPNOTSUPP;
> +
> +	/* Queue 1 for Class A, Queue 2 for Class B, so the ENET must has

nit: s/has/have/

> +	 * three queues.
> +	 */
> +	if (fep->num_tx_queues != FEC_ENET_MAX_TX_QS)
> +		return -EOPNOTSUPP;
> +
> +	/* Queue 0 is not AVB capable */
> +	if (queue <= 0 || queue >= fep->num_tx_queues)
> +		return -EINVAL;
> +
> +	val = readl(fep->hwp + FEC_QOS_SCHEME);
> +	val &= ~FEC_QOS_TX_SHEME_MASK;
> +	if (!cbs->enable) {
> +		val |= ROUND_ROBIN_SCHEME;
> +		writel(val, fep->hwp + FEC_QOS_SCHEME);
> +
> +		return 0;
> +	}
> +
> +	val |= CREDIT_BASED_SCHEME;
> +	writel(val, fep->hwp + FEC_QOS_SCHEME);
> +
> +	/* cbs->idleslope is in kilobits per second. speed is the port rate
> +	 * in megabits per second. So bandwidth ratio bw = (idleslope /
> +	 * (speed * 1000)) * 100, the unit is percentage.
> +	 */

suggestion:

	/* cbs->idleslope is in kilobits per second.
	 * Speed is the port rate in megabits per second.
	 * So bandwidth the ratio, bw, is (idleslope / (speed * 1000)) * 100.
	 * The unit of bw is a percentage.
	 */

> +	bw = cbs->idleslope / (speed * 10UL);
> +	/* bw% can not >= 100% */
> +	if (bw >= 100)
> +		return -EINVAL;

nit: maybe the above calculation and check fits better inside
     fec_enet_get_idle_slope()

> +	idle_slope = fec_enet_get_idle_slope(bw);
> +
> +	val = readl(fep->hwp + FEC_DMA_CFG(queue));
> +	val &= ~IDLE_SLOPE_MASK;
> +	val |= idle_slope & IDLE_SLOPE_MASK;
> +	writel(val, fep->hwp + FEC_DMA_CFG(queue));
> +
> +	return 0;
> +}
> +
> +static int fec_enet_setup_tc(struct net_device *ndev, enum tc_setup_type type,
> +			     void *type_data)
> +{
> +	switch (type) {
> +	case TC_SETUP_QDISC_CBS:
> +		return fec_enet_setup_tc_cbs(ndev, type_data);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>  static void fec_enet_free_buffers(struct net_device *ndev)
>  {
>  	struct fec_enet_private *fep = netdev_priv(ndev);
> @@ -3882,6 +3987,7 @@ static const struct net_device_ops fec_netdev_ops = {
>  	.ndo_tx_timeout		= fec_timeout,
>  	.ndo_set_mac_address	= fec_set_mac_address,
>  	.ndo_eth_ioctl		= fec_enet_ioctl,
> +	.ndo_setup_tc	= fec_enet_setup_tc,
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	.ndo_poll_controller	= fec_poll_controller,
>  #endif
> -- 
> 2.25.1
> 
