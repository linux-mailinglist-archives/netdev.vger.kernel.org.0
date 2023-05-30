Return-Path: <netdev+bounces-6531-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43826716D74
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8ECB21C20CE5
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288062109C;
	Tue, 30 May 2023 19:23:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DF4206B3
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:23:02 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2119.outbound.protection.outlook.com [40.107.102.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6424DF7;
	Tue, 30 May 2023 12:23:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyScpGimzPc8qQnZ0L5LjtoKB5tZuZzCs/X8jFTPB9q8tZVgrShIGwlPV7ogQmW35BDLl/IOVMW6v/4S/cIr8jquVjtOtqht+4DY1J6aI/baHHctQh9yDbN4mKDIGTneBsRKfROUKH1l8IbXIcq8d2Xa7vY9lhY1P0D/pi0e3pW7eNwg5xhJtHDfxp1c2szp/eVd0blj1F/8rqMZ1YxGilkvQwajewHHum6QJ17dG7ZeQwTK7E/mahdHFG5emBwL/MRjxp2vNG3feXBZ9ozVxxAJYiiMJmi7SgKWmJcnGQL6N6ztG/czWoMjL4Hy5CXXFZIQ8PNvmGE4tqlG7MNT5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3f9cpqFe32YrHCB30nMmm6EjxTu4mpR59DlkBUy+poA=;
 b=Mi0386Son6FE5jCa6CnI90fboAE9adAzTKlEC+mFOgAIVY+pW2ljeDFPCZZ2ZDrwnKK9Vj/iFcY4tbD9Sog5Jj5p1UsiI0kVONJ52rpoMC5Lv2aEVCzIlUu5p+qJjUAlei0FN9sKUA6nJNDJh5Utpm8o8QI6EVpDBvrPsxedTe8uaIFEJM3LLBxVe1nbmW0wj7ayLnFvJlNfHr/4d0fTWmwgK9SPbkN8PRF32k0LkjQCgtz0Sfp1FQnt4O7GqUpyprP2Cmb6SgAqN9T164SnCi6C1JwAYtDSDqV4qlIY6sc9UIB+jK+8IhiHFkmEofHk2N26rYSuUdxGJcbFn/ErcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3f9cpqFe32YrHCB30nMmm6EjxTu4mpR59DlkBUy+poA=;
 b=SIspBymbIBIVwU/cx+lR3DoF5baM7vgV5e9oeQ8ClZgavqNw8Eic6ZAiOBn7pr3hiaLHJluBhj2cUt2DUayjj7wWqLnMzI53qfRMn+GncPzoLyeubzeBkJNE8SkV2Z9xvMssp7B1SJLmT4K1ASd82TwsN7i2N8hHl9W7qQ1Fjl8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5424.namprd13.prod.outlook.com (2603:10b6:510:12b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 19:22:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 19:22:55 +0000
Date: Tue, 30 May 2023 21:22:47 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Pranavi Somisetty <pranavi.somisetty@amd.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, nicolas.ferre@microchip.com,
	claudiu.beznea@microchip.com, git@amd.com, michal.simek@amd.com,
	harini.katakam@amd.com, radhey.shyam.pandey@amd.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/2] net: macb: Add support for partial store
 and forward
Message-ID: <ZHZNByAsuHt6qUMg@corigine.com>
References: <20230530095138.1302-1-pranavi.somisetty@amd.com>
 <20230530095138.1302-3-pranavi.somisetty@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530095138.1302-3-pranavi.somisetty@amd.com>
X-ClientProxiedBy: AM0PR02CA0025.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5424:EE_
X-MS-Office365-Filtering-Correlation-Id: 13310b6d-f2b9-43d1-4c90-08db6143450b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sx2izS01LoCduM/NW5ZdeFORzIYGBhLoOvHImIWOkZ/FR92MalK7dzkbmK8Z5YMZauwxpUVj1Da2E4VHl4qYQPpIneM0bFZ77zdzfU++Qyr5YQqVLXxnj2xKD49KbWf5UY4LnMueAXcXOlU/YbmbzZJLuCBRvJgGIwfUf9etkM3y8Qjnpq3EaoO4SOGsHLPYKaU/KSaSEUx+5SZKDjNgTf1shH/zeSqxayW9ll1+fuBZ964+DtpvWgW/FwXkXHA9qWaYtlTH/FTHSmdjwwle5zjK1530ox6IXcs6/mk2wMDsrmOAP1xlUDv353iDp+1FoG9EoGgbw24sAxD+Ci1hEHZkjbDuvqcCNSUWvt9aVFNsusDRo69aFvyYIpRfr+dBgxKbSshFON1925W2RjSiMKRNjd3ePtE+DjyW4rxs/e6ZNKvav8mEhlG5l4vwYScMtFB0JtyMORNZFlwpcHLXrZAx+imzgHqMb6wiEp1+noC8cvZZKKrFweGvGzOxxEYNeN7vAmsatXJBoqOKx7fzBM5hVaN91JvQ2paOzXovLEW1LJTOvV2omCceUgCJVZ1f
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(396003)(366004)(346002)(136003)(451199021)(478600001)(186003)(6506007)(6512007)(2906002)(5660300002)(8936002)(8676002)(2616005)(38100700002)(83380400001)(6486002)(41300700001)(86362001)(316002)(6666004)(4326008)(36756003)(44832011)(7416002)(66476007)(66556008)(66946007)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bxfNaUMgnR4RRRIYMhKiOCdvBG1pXA/LIoo3G1qvEdSly6rCp7XhBfQJo4UG?=
 =?us-ascii?Q?zt2zAM4zv0hcfY9aX7HOjMoB2iK1VCViWrKzxrDF85rg2bMs+8Kgu3xpErhD?=
 =?us-ascii?Q?c6V+NzPRjHuV4nGRGqevxm87jc4p2vx57AEEN3TIw8/gFzog5F2RVTHsKGKQ?=
 =?us-ascii?Q?eulvuT3f6PvjWmSn55gAvXC3RjSEbzxUXbVSR4VGOWA0Py3ThQUaoLhljpek?=
 =?us-ascii?Q?gjZ0fuC4vccmfzLXgVOu4o8H7/cPbreJeUyNaUeph9CM2yT1QltomMn9SYRi?=
 =?us-ascii?Q?fZC1P6Kv+rO/918Yw++sIPmGdohkh/vf5SyRQ/7FDgP+/KJPI9pO0smla9pA?=
 =?us-ascii?Q?hmGoxE8uWOvyXa+rp1XIDKeC507EiKXMd1Ynx/5Kmc4Kl9kH1AHU1BzMYtaz?=
 =?us-ascii?Q?41UwjE3tDQRR7ZMlYk3jojoHBK0nXtXihBuwC9s70RH1MSbQqX9JR0w/veJH?=
 =?us-ascii?Q?BjgfXIz0J+MXRu/nlB4AA/zMQa8uUAVC5j0daFs3jWwX2PnfXxQAo84AVZeq?=
 =?us-ascii?Q?FhwdOhWF/mwDLBBhNGvuXa6vokQeicsLTZ+6hcw9HbDpynVl8qcFaJ96neCD?=
 =?us-ascii?Q?hj460SvSxWCTjLtZGVpuSeEh5WoOZVatktGNDJwaDLU2Xqg1J/QomUOjMYEb?=
 =?us-ascii?Q?P5wdToTiSk6rusjWg8gpCi2NOV6T/1F5ePgVJU1OoD6UQWCnCVkS/BojMy/x?=
 =?us-ascii?Q?pWPTxB+KONUMH00JMJQxErKowX6iJEIQLO+BpknhLGfXA1Y2uDPvTOle2/j3?=
 =?us-ascii?Q?iUYzv9qTkmklFzqO5dL6TtEMMXUqDv9ZWbyhSoKmmedc1Hco9hPLnzWseHr2?=
 =?us-ascii?Q?PF8DdyPi6oVV+cDfbnokUEsUx08C19nlwG5YZv1VIqFwMkOx6ybKg+RWQf3Z?=
 =?us-ascii?Q?Q9hST1iDx6pJimLXjrjgr+1td+xxAegs/v4zmMx8N47qewcywpwwyd/DpG+7?=
 =?us-ascii?Q?11I09G41tL/icdxIILaQBVLm3qBbsCGcwb8SLLaMC0u/AxxbMJnGRaeoOAe3?=
 =?us-ascii?Q?sRS85tRfrSEDfmZ+Ii02QUvBnH7QtEN/wMbfPBbdV0UvtoWVDBQGVYBN7Sz6?=
 =?us-ascii?Q?wC+ivWMFa7qGULvnuOLNMPYYj+nmAm9SQjR+fE/eKhQqGwWzPcnH+ZwARUb1?=
 =?us-ascii?Q?K826wlfEahFiITVdAPYEMyCVMDhpplwNEY9sEX8+IdcL0ovIdi32nOzF/xDy?=
 =?us-ascii?Q?U/Ei5WOfAt87nht6N2ThMBSzCiaHe6K6U7JwpNGIT7UC6MENtW7h3gsmYT/G?=
 =?us-ascii?Q?qMfZUJ58EVKhHmhpHG20OexIXA1FrrLeAmXmQtvK9hzKMXID71T3sjpPuNZV?=
 =?us-ascii?Q?wONovr5Y6lbJ3VnkHRAQMsrp7/G/nTukzBtusQo3VrbBPvujRyFQvatCFm/4?=
 =?us-ascii?Q?p82/25679VGwVznR9wlFXe0BZ4XMwODJ/+TY4X0Xwrub1yW74cKYdwoaFX2S?=
 =?us-ascii?Q?08gly1wSkoewAsJnQWnAgdFGG2QmRvp3pS5H8QFx66KTK0aeq+SduonR70rx?=
 =?us-ascii?Q?XxWjBmKogT3mPRwe6r8X7HZKKjbtVSWWYFy8j+Vhssf/P/1NQ1GtZ6/xNkET?=
 =?us-ascii?Q?Dt67EXwACk4bE0/i26KICVepk+wlmMu3EE4JqJ2FBNP7q/159o6FyhbDhQB8?=
 =?us-ascii?Q?Hqot+E/U9z1uWX3/Vs3ET0H1WPlOboaunk+XaIvThNKq9kd2yem31SR2aRsy?=
 =?us-ascii?Q?XkPfSA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13310b6d-f2b9-43d1-4c90-08db6143450b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 19:22:55.4439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mfVA2SdyEIr373ngWmPl+cVkEhIrCpJMJ3HvbBbJf15dLv2VVpwazi/rEHkU+jdgDHqv59Ul0ewCmNODeZOEmnOSMweq/tDDSd/yF+B1w1I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5424
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 03:51:38AM -0600, Pranavi Somisetty wrote:
> From: Maulik Jodhani <maulik.jodhani@xilinx.com>
> 
> When the receive partial store and forward mode is activated, the
> receiver will only begin to forward the packet to the external AHB
> or AXI slave when enough packet data is stored in the packet buffer.
> The amount of packet data required to activate the forwarding process
> is programmable via watermark registers which are located at the same
> address as the partial store and forward enable bits. Adding support to
> read this rx-watermark value from device-tree, to program the watermark
> registers and enable partial store and forwarding.
> 
> Signed-off-by: Maulik Jodhani <maulik.jodhani@xilinx.com>
> Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>

...

> @@ -4995,6 +5003,27 @@ static int macb_probe(struct platform_device *pdev)
>  
>  	bp->usrio = macb_config->usrio;
>  
> +	/* By default we set to partial store and forward mode for zynqmp.
> +	 * Disable if not set in devicetree.
> +	 */
> +	if (GEM_BFEXT(PBUF_CUTTHRU, gem_readl(bp, DCFG6))) {
> +		err = of_property_read_u16(bp->pdev->dev.of_node,
> +					   "cdns,rx-watermark",
> +					   &bp->rx_watermark);
> +
> +		if (!err) {
> +			/* Disable partial store and forward in case of error or
> +			 * invalid watermark value
> +			 */
> +			wtrmrk_rst_val = (1 << (GEM_BFEXT(RX_PBUF_ADDR, gem_readl(bp, DCFG2)))) - 1;
> +			if (bp->rx_watermark > wtrmrk_rst_val || !bp->rx_watermark) {
> +				dev_info(&bp->pdev->dev, "Invalid watermark value\n");
> +				bp->rx_watermark = 0;
> +				return -EINVAL;

Hi Pranavi,

This appears to leak resources.
Perhaps:

				err = -EINVAL;
				goto err_out_free_netdev;

> +			}
> +			bp->rx_watermark &= wtrmrk_rst_val;
> +		}
> +	}
>  	spin_lock_init(&bp->lock);
>  
>  	/* setup capabilities */

