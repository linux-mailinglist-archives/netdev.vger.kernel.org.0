Return-Path: <netdev+bounces-4656-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF13370DB39
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A90C281015
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9BDD4A857;
	Tue, 23 May 2023 11:10:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07604A840
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 11:10:09 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2104.outbound.protection.outlook.com [40.107.244.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B40119;
	Tue, 23 May 2023 04:10:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihwEkkJJNlD8j+hq9Ugb5kFEjiQlOH5x65EaMpIDUMstwTg0W8Y2d/4ZUYGezCXeFf+IOQ2qcRdk7soi3snlwjUrjBzb7nuuq0wZPP5anzZ+3yJa4JNRefegeviLfxg7xL4W6/zJdBKCYcBEmQjMecARi4bVGLiG2ADxaTro/NGOjW2EgkY60EdBAH3av5lGihYFY8Hpeg4w8ch+naiGxnaYLqMLqo6p6iRBH8T3ecGOGKYMpvKOtpBVIppvogYUF84NJN1RZTh+wV8INc9bzdJ5VykzdaBDaQCP3P3Ui+GHqL2zUYyteObZSADZWLW06U5lth9Xweg87tnT17dgpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6s59GjltAUYNnWRiiEGGwpv+KFqtRweCmaR9ZVAD5M=;
 b=nCc6J2D2QjcoQve4yHX7c8NBe/CLqGGCOMUbs80KxmyP+PexxHYV4Hrj7/WbnzKPY1wXpXzOR0YwMHzsU+RQxXG2pdV1FHQ+TLdLFIJriIqL+idIu/rDg5cZnDYjYogc0quEXIlgb+URiNjtZtV1liyo2mQNxUM0MfK/yBoen4e9iulzZjQBCI/U6K3UWMqnqHqVcbIJcxF7GXTj+cih73/gpcKm1J3U04WYFfup3A9KCeNtHfIZiBwYyJt051pe1UY6uDgBDvAbzXyKh+F9q/OrNN/P6afaWdGNlqZdtIC3LRPueMxkJUupC4QN1I5mnl/Hml7CAEij+2naOlggWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6s59GjltAUYNnWRiiEGGwpv+KFqtRweCmaR9ZVAD5M=;
 b=JNdGKb+v9wqRIEewvJ6ioAjD8kJR7yg2EqiqD4hov2QWMXs7jaMz06ldchQzhRnJP2dGYv8GRNIrVMKfUiVFYzjXcIMiqlmhvxNDeUa1QQlv/1RN7YCQK66UcRvQZQZXkC1FnxrY6lmDYHyaDcNHLzOh2b+L/uLtB3mLWEb8BYo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4011.namprd13.prod.outlook.com (2603:10b6:303:2c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 11:10:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 11:10:01 +0000
Date: Tue, 23 May 2023 13:09:54 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Judith Mendez <jm@ti.com>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Schuyler Patton <spatton@ti.com>, Tero Kristo <kristo@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v7 2/2] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <ZGyfAhp8op4GMElN@corigine.com>
References: <20230523023749.4526-1-jm@ti.com>
 <20230523023749.4526-3-jm@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523023749.4526-3-jm@ti.com>
X-ClientProxiedBy: AM0PR03CA0074.eurprd03.prod.outlook.com
 (2603:10a6:208:69::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4011:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f333b16-cf49-43d0-508f-08db5b7e40d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	H6jyhQ08yBTl4wcEckTx4zSBYD0KEdCdie1n9ZPzJvUQog0+2ALSDbW7XOwU86+w5ysphJ4IWMIdXkWL5ea/PGzn2stBiKukoJmPkxS5vTpp6KvvC2TqT2p/3uMgH+IySilSGZvu9RkWoTb5CmLwsbtsSLb0ccjkjiVzP1tad5Utapz/mc9PsRKflnhiDAlaELmNkHDpUoutrvnLot4DZl4Oi8NzYu8rnsfIc9DpXZSoHbK83XiW15NPz+aFGzsfBghRp9kBPn8n+LfWCO3u1PSBPcNXzZ/VxlGYLjdDEUDAMMJn3tznMXwHjGzZHE6I8q1wv99X2t2q/ZhbTbdqZvy6PNOqhoqEJOq+r57Ns1G3Z1RprVAWg640MT+PpmaBhjOw/QUPs8EYjlvlzIM6pMv3zZlLMvO+Z8u42ErBQfbvjqECYjMVu7tsxNzGGx/4DMJFGbN27bDVX+oTGLWO7dXoTdUh46FsiRuawdf8ggCXWVCXry5uSOHcZyAqpSPHZHS5Hh2JcL0DqZdbfRM2x4JmIX+Ya+Lj8vThsWS5PJPnux3dy3LU2ZW1clqqQ3fLM3aFnXJRbC5FB6RaUDwd8RY7414dLwW+XRz+v+7E1dE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39840400004)(136003)(366004)(451199021)(86362001)(66946007)(66556008)(66476007)(6916009)(4326008)(478600001)(6486002)(41300700001)(54906003)(6666004)(966005)(316002)(5660300002)(8676002)(8936002)(38100700002)(44832011)(6506007)(6512007)(186003)(7416002)(83380400001)(2906002)(2616005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9vyS+DoBsLWf1yo1qVo1BJwimKqRaMzo877Mj0sBJVABa1fKISgkGsCNAMke?=
 =?us-ascii?Q?dBeuHUrbNItQjl4s5JXh4xd/3cyFlAPDO7qY30fqjxYBZ3+QQRG3isxsoGkl?=
 =?us-ascii?Q?m0yv3YZIRNxcQr3vVf2Y+5ccqX3Jgk32nhEab1LiWioRym7OyK9EVBvVgIrr?=
 =?us-ascii?Q?2OvvCidi2EduYzoImWJehJRNyeEi6FQVJU+QP9FM7XwUby/VpTmlaFBwrXoQ?=
 =?us-ascii?Q?ZnApNv/WRHFI1TnvU34yOK87z66oEFWezh2A4A5dUBX6eG6AYQEEiG004jGo?=
 =?us-ascii?Q?VcoUGMYyXUtqOpbi6XYZAukpw9GCMdVwAahCEv4Tt7Wm1x7MmXmZi9MoKqNB?=
 =?us-ascii?Q?u0MzxLb/1kWLAZxGh9RpxJCjAj+0kJUMEKG0n3GnRVFKK+x3N/OkgeJ3yg/z?=
 =?us-ascii?Q?jeHyS9GdoOh2LYywHezfw4YJVV+VSIgYHTR0OSzmEDbLmtXWhhYfB7PgwuAH?=
 =?us-ascii?Q?6RUD3nvl+xRCcZrY4NVVkfJn+6PTsJZPs1JBScosy064HsKLd+VafF+xxGgB?=
 =?us-ascii?Q?QxJxjo/xTv7XqkA0MJQ3mYnWJzD1uRomQbdvTPUkZj+T4kMtFGjJ5pij9WkN?=
 =?us-ascii?Q?K4kP1eK4H8Iq5Z2VItrT5+A4c4dkIj2OXcPy7RPoZ0XE0/Y/42oCURt7hpQO?=
 =?us-ascii?Q?I1bjf68YFHlLdjDiYFjQ4TqhAKcBfSFcyqFoJyVLqs93JYMBNab5Dc4H5LdO?=
 =?us-ascii?Q?FDwDYaNcI1dcrV5WKc2oAU90WYSpyrERVUpx2TlHjraHYyzITvORiXHV7xjd?=
 =?us-ascii?Q?pgCaNdPEqpL1LwTxnjqtaMhzW2tbsKt36BxajP8pcL9eDRYcN2Muzvt9ENIO?=
 =?us-ascii?Q?QObFJStci6CFs+80YuPMgGyyYPv5+BH3mt4c7fx19+c+Nh+Df//H+UFTo0Mp?=
 =?us-ascii?Q?n5+9OiRJHnEPFt/UFZuE1LF4fmAc9BBHQqGP5aJmCpqeFy2cKt/OHkq35fxp?=
 =?us-ascii?Q?Rl4VwFsnMjj/cGXg7Hp/o8oYkaSAjwE7VCgwXRB3yOESYBB6uhKNyulL4Aoq?=
 =?us-ascii?Q?ZRUnMCUZBKfwi5JUXq7fZF0Sq8FMEDtRlhSC0hrMSUEpMZSRmj8AEfaZZK5L?=
 =?us-ascii?Q?6pIzpk0hestCYyYCsES0ReE7lhIkNa6kh8JsQ4RpyiclyU+5apYPc9tZtnC7?=
 =?us-ascii?Q?3L9eiIfJB7VAucBU2YF29hGI5Zt6yMd80LLQ0BWv5Z/HyK+k/xHvilzeG+td?=
 =?us-ascii?Q?4xQvChTl9PA+FTo3Z6TErp8bUwdCbObBamKAs/qKz9H/t23J0QJiLUlSuDZd?=
 =?us-ascii?Q?tOhCg8vC3hrN8scbxDcBEPmyxvnlTmOz//JjCTVqLdjR1B7mzw8A0MzhG7Cq?=
 =?us-ascii?Q?UyhL3sGH9Z2dOV/6+vjZaNtUGw0q/pyIF2oVKj7lru6p9QNDT8TrageTqxYE?=
 =?us-ascii?Q?3z1FaIRUEwG+vVhtRmWM0FexKMZR2/dColvzrOF50k8/sm3gJIxNE2fJgwym?=
 =?us-ascii?Q?AffhoO+ifKgbkE4ZzfAzN/K4kw8iXwezt9QYu0gVmgtr/RpxQK4u6Er4tQIM?=
 =?us-ascii?Q?YuWQrTwwxfebJz0/oIiw+Y8574ankaCMOF1A10k43HFRY7Hluqf5XE7fx5RD?=
 =?us-ascii?Q?2mxhfQ1d8nQB77BssG/p5if1htn9BdChLDXq/tcCXKxLbaCPez5Ohv2q1qYf?=
 =?us-ascii?Q?Ph/8v5k6DLa1U7cjf44cDPs+PzR8MzOiMvn1vbD1Tt2ffDoFzXidn7v9WARc?=
 =?us-ascii?Q?STrdWw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f333b16-cf49-43d0-508f-08db5b7e40d3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 11:10:01.7195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1pLhXC1KjF168qqKZjrImcjgwzgW5oSkeEoTHGcdjUQFDEwyuR2c9ZKrtp9FFoSOeY4/3XqFAzS8v4b4DxMn18mB4DwatO6/yZ2d5pB6kA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4011
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 09:37:49PM -0500, Judith Mendez wrote:
> Add an hrtimer to MCAN class device. Each MCAN will have its own
> hrtimer instantiated if there is no hardware interrupt found in
> device tree M_CAN node.
> 
> The hrtimer will generate a software interrupt every 1 ms. In
> hrtimer callback, we check if there is a transaction pending by
> reading a register, then process by calling the isr if there is.
> 
> Signed-off-by: Judith Mendez <jm@ti.com>

...

> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
> index 94dc82644113..b639c9e645d3 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -5,6 +5,7 @@
>  //
>  // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
>  
> +#include <linux/hrtimer.h>
>  #include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
>  
> @@ -96,12 +97,30 @@ static int m_can_plat_probe(struct platform_device *pdev)
>  		goto probe_fail;
>  
>  	addr = devm_platform_ioremap_resource_byname(pdev, "m_can");
> -	irq = platform_get_irq_byname(pdev, "int0");
> -	if (IS_ERR(addr) || irq < 0) {
> -		ret = -EINVAL;
> +	if (IS_ERR(addr)) {
> +		ret = PTR_ERR(addr);
>  		goto probe_fail;
>  	}
>  
> +	if (device_property_present(mcan_class->dev, "interrupts") ||
> +	    device_property_present(mcan_class->dev, "interrupt-names")) {
> +		irq = platform_get_irq_byname(pdev, "int0");
> +		mcan_class->polling = false;
> +		if (irq == -EPROBE_DEFER) {
> +			ret = -EPROBE_DEFER;
> +			goto probe_fail;
> +		}
> +		if (irq < 0) {
> +			ret = -ENXIO;
> +			goto probe_fail;
> +		}
> +	} else {
> +		mcan_class->polling = true;
> +		dev_dbg(mcan_class->dev, "Polling enabled, initialize hrtimer");
> +		hrtimer_init(&mcan_class->hrtimer, CLOCK_MONOTONIC,
> +			     HRTIMER_MODE_REL_PINNED);
> +	}

Hi Judith,

it seems that with this change irq is only set in the first arm of
the above conditional. But later on it is used unconditionally.
That is, it may be used uninitialised.

Reported by gcc-12 as:

 drivers/net/can/m_can/m_can_platform.c: In function 'm_can_plat_probe':
 drivers/net/can/m_can/m_can_platform.c:150:30: warning: 'irq' may be used uninitialized [-Wmaybe-uninitialized]
   150 |         mcan_class->net->irq = irq;
       |         ~~~~~~~~~~~~~~~~~~~~~^~~~~
 drivers/net/can/m_can/m_can_platform.c:86:13: note: 'irq' was declared here
    86 |         int irq, ret = 0;
       |             ^~~

> +
>  	/* message ram could be shared */
>  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
>  	if (!res) {
> -- 
> 2.17.1
> 
> 

