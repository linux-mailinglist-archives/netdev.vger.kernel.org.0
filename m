Return-Path: <netdev+bounces-5559-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E51CF7121F4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92AE61C20FB8
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F4A2AD30;
	Fri, 26 May 2023 08:15:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BC4AD27
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:15:36 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2107.outbound.protection.outlook.com [40.107.244.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A642812C;
	Fri, 26 May 2023 01:15:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bq07JXGsGl8v3QNtOGJ2Q29M8hQFhPlAZ3tTrUe1PVKm+FqVz+ZSIQyUtY0d92wbRQx3gdXWvpu0b3kBo5uDYeOo6PKODD+c5OgwV1a7HioSWDhiFP9tXKA8r86gFtGtKxmkuFtMT9e9CMHOBla1QOQK4Zns43TUZqPIN6thsIqEgPC6/ufbLIH8zHGqcy71AcQPhURKmBwFCgqm64R/01FI08hij/l91Y2EJtrOhpIHdb93X24y9MoGx3EQ0pnojtgbO4weteMc95fgLdsyxMyCdN1Z2e7i9vxjVaGUN5vOyrIYgaDiVEpTIsDoeTVF08mpTwF+lncPE5WVGxPpFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HTNCMULXEK+VMvvjS4gsXY2kEtVxE7RhppCMh//NG0=;
 b=T+0tDKGwBt7Lw3DNJBHjuG10cPbr4HoySCZh/7HrZO7iRNr5YZQkqZWD4/iNmkNClcKU0iB7e+1dhHKfefsBM3r/kLP5YY8W3zvGPY15W2eYhfKiwO5d7vMixFPG8IcVIYMZ6kiYKsw2/7SLCzv4AWE0QGBLgpbuL3ywS+8Xri6xks6k/gGJDJnvI1G2jflhMZwXgCnXwCsdy8+tbUazOCqruoeu2Yzx94bEG8082y+ONv2Pp4aoEOzv888QuTBYHuJAeQcarWUuOXgi2WuRCsX923ojfXcxzVaC15NDt0hxw3QOrc3N9meEpPCgr6ULmM3esaS9e4b03M1g/PflRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HTNCMULXEK+VMvvjS4gsXY2kEtVxE7RhppCMh//NG0=;
 b=CE4VlYYqYvRL1ZzCtlvJBZE/w/hyNNhYOXg48oXVjOkuAmmdrFHCGN04Wfj+cudq4Ow2Wm0O5pYZgbhWYP6xh3gk5Cnm9EvCv2m3JJO0xy8ChbTY8PXP4BKB92BHF9EhkHc9POExScJOZ6Ss4oUJ5NZjBdFlF6SJdxXWJCao8Js=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3970.namprd13.prod.outlook.com (2603:10b6:5:2ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.19; Fri, 26 May
 2023 08:15:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:15:31 +0000
Date: Fri, 26 May 2023 10:15:23 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Shradha Gupta <shradhagupta@linux.microsoft.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH v3] hv_netvsc: Allocate rx indirection table size
 dynamically
Message-ID: <ZHBqm0fGHPMyN0vz@corigine.com>
References: <1685080949-18316-1-git-send-email-shradhagupta@linux.microsoft.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685080949-18316-1-git-send-email-shradhagupta@linux.microsoft.com>
X-ClientProxiedBy: AM0PR03CA0081.eurprd03.prod.outlook.com
 (2603:10a6:208:69::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3970:EE_
X-MS-Office365-Filtering-Correlation-Id: b213d2b5-c771-4bfe-47a1-08db5dc15f5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XeG/Z5zxgNHGbC2Jxp88vS0hsMcXgMoaSi68vEn5ZsQ1qsZ1emjqiCUOdHC3SX/8ZVPB+PBDP4EnU9AsvvP1SEBf5CPTPeScX7+y0GvTyC9FuKWIeBBLsQzkP3wGzA/rK25CYx9Al1ymRFaQZ+0JPzpbJG57Z40H3RET+0UVELoCNruB5dvH8SZdFRWJeGCHaZylr0fHvk+eqHOl/6r7DsQmYp79NFIDcepvbqg4f728GGUMpMMSU41+IrA2MWAAPrXiau2bPRb4XMp0rHIK7GZlH/ljle90o1wWcpwm1LtKDJAbJIq49Cm/G7b/d9+9pNrFYFfW7qYD4V0EppElIoKb7xGaqb1ncJcgN5Doj7Hi9MPtljIusbWmM+ro4LOnr+x56tDjTj4r/UR1LOX1nJn465Hb7mL2COOipxdm0aKNrorVYfCkAcd5lK7soBrSZbvprSSH+WrQ0AO/DUIxpgQkadZAG8slxYDprMnZE1X6dIhnWmzUTR2L1p6efgVwwTtbKgNU9k/yjYhHtlJW9fIGvcb1OBBtFATdP6bl2V3roYQWxuot24BNDLWY041MTKiVJGpfr1Z9+siBtNBiQPFT8iXycm5m45zWjcq22po=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(39840400004)(396003)(136003)(451199021)(54906003)(86362001)(83380400001)(478600001)(2616005)(186003)(2906002)(66946007)(44832011)(6512007)(6916009)(4326008)(66556008)(66476007)(6666004)(36756003)(7416002)(6506007)(316002)(6486002)(41300700001)(5660300002)(8676002)(8936002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mGe8ai8GQndydlCBmhZhBcEh+4JakDgkXJE38R6uETtGKDv9tFI2o1qv/gFr?=
 =?us-ascii?Q?r4ptjOIa6do3V8m5PuaXec0bxX/NTGUcgVpcwxXckI1+123IEQCp7Mu0CbwQ?=
 =?us-ascii?Q?w4fDv7s72VG98j3Ehh0eHd4GZhWDPuVpELoVihYHs0gz4TaHpjBXcdAguM98?=
 =?us-ascii?Q?YkEJ2VGVoqi7riv5wXG3MbYO0KMJSLPzfyZlRPcTaAncAueAF1i9Pnu7VYyO?=
 =?us-ascii?Q?siq4XpqXeTB4mKqzo9Fs77QjTMwpSl4s2xVKBk/jbqXB2kzWfQcgh60m9Qi+?=
 =?us-ascii?Q?SxmCVwFFbT6NZvxqGrLTzkD858ebZhrs2UxetiFiwWI1V1RXN0Fey5urnlms?=
 =?us-ascii?Q?UQfAYuHpqQZChDly8EnBLM9XQyRTijsDP8KWdRodhmh8kd8gw0hPJBeU5KEQ?=
 =?us-ascii?Q?yIdJEqXeGMe/Q1JlWNC7qMI50qQr7yithi43fqf47+xV12EN/aUUibfGbO/k?=
 =?us-ascii?Q?jUTL8OJcvp0A8wY9g3HCn9tsRLuFxKgjqn2PjD2t/ZxjZeqLiXnHrew9QF1s?=
 =?us-ascii?Q?Fp6u1GaZm/HJOYAkX1po6rWl/T2PJ0XXsOFI4XHa4VpfP0Nl04CuA/z5P+Vx?=
 =?us-ascii?Q?+pXyYSy0ys9u6PYen78KTgHS7fggrJ8hQ2jtSykOkSiDggMndazwwkr46N1p?=
 =?us-ascii?Q?SdfQblRrxYim5VyVnJzwUXW2KRGzjPqndX2GRJXYLNeSarKiKKWqOXr0CJLv?=
 =?us-ascii?Q?aC6w4jezoio7zlr7N30WTjYz9yDp8EC3RkhQXVg0TYwAPRZKCBOf32NPwCJx?=
 =?us-ascii?Q?WZ6XdniXc8I5a1HYqO8qPLtr+CDIyXNWSUjzcVgoC3G01yygtcvrtuNBFXdh?=
 =?us-ascii?Q?hPOAm3aVP8HpEaRnCyTxzrMLtIQ/xmXcf0Iyn9u4fxiCfCPbd04L/5n3+ya7?=
 =?us-ascii?Q?FSAYkGTHVeZkTE6Y6YMwBduXnufmJTAV6ozHZZhBkbQNyAHLFRs4i284nxmY?=
 =?us-ascii?Q?iaO/heYmqGZX++7qWPNKK7GKM/QWJSvR31LBNrhpjbROPIzq1EeGRAj8Db6F?=
 =?us-ascii?Q?jsnD29uLZOLPIqtBf+qAhgnHFX8mTRIMCrAANKL4fhgxaxBjPIIGLsRzkd8z?=
 =?us-ascii?Q?xNaFb+SkycIdGPdFacJTdXCOg9TuPk8BoFj2jQsk/Qh1iNIfYxgz/+qUenaX?=
 =?us-ascii?Q?/tToxw60MDptBxdJAuI5NqLgGkUOG7713L2ulVdLONEQ4fN/UWaetN2az8LP?=
 =?us-ascii?Q?TLvGs9FVXyQ2zFauVEyxNqI5u/pS2ffRV8a6lxQLi/7QhSBwF8yHlEXLp764?=
 =?us-ascii?Q?SGqel6VWeyNL/vCkHeywYKILnIYN0WkOoHsh+HI/nh8rhn2UssgWjMQz1Z0c?=
 =?us-ascii?Q?9wiXh6HQ2BiyaBMB9zWwlk4VFqLBHTOC0rbxgoETDjtE8ZJ/I3/RK89kngyK?=
 =?us-ascii?Q?lg7MtGNIRmxmtat4pn1p+uiBncykdy3vQWJwlhoNSMYwmELXFtceegbpJQRX?=
 =?us-ascii?Q?aimzy9mmFJHMIBWpRNQDHzECPWppWKZSuh1GW5o++nKiBVHvDBDnkJgdBJYT?=
 =?us-ascii?Q?/hvRVWVFclPeExiWBDvnmSMbzReX5pZMewamjFrT6xHPyIWb4/Mx93JLRvvM?=
 =?us-ascii?Q?0SAo1ftALs+gNo8DK1MM6y077jzZDPYqtqzb4O6CtTYx+JY/8CpPTSIHkiEh?=
 =?us-ascii?Q?PT5YSQesw120FywWtL985PO3yFdvuvs7bQ0aeErEykaWI2LNQXd2w2GaEZV+?=
 =?us-ascii?Q?PdfNXQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b213d2b5-c771-4bfe-47a1-08db5dc15f5d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:15:31.4453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TCX6yzmwFwlyiwzRw3Ih3C/WLl7WfRxgw3oeS9BPhr7ZAXdr9ZovNYRaJ4iIY2muQzSTXAr3zmXWh/+P/VGAfb6/P4ZkXxKDIk3Vd2X0cms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3970
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 11:02:29PM -0700, Shradha Gupta wrote:
> Allocate the size of rx indirection table dynamically in netvsc
> from the value of size provided by OID_GEN_RECEIVE_SCALE_CAPABILITIES
> query instead of using a constant value of ITAB_NUM.
> 
> Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>

> @@ -1548,6 +1549,17 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
>  	if (ret || rsscap.num_recv_que < 2)
>  		goto out;
>  
> +	if (rsscap.num_indirect_tabent &&
> +	    rsscap.num_indirect_tabent <= ITAB_NUM_MAX)
> +		ndc->rx_table_sz = rsscap.num_indirect_tabent;
> +	else
> +		ndc->rx_table_sz = ITAB_NUM;
> +
> +	ndc->rx_table = kcalloc(ndc->rx_table_sz, sizeof(u16),
> +				GFP_KERNEL);

nit: the above could fit on a single line.

> +	if (!ndc->rx_table)

I think you need to set ret to an error value here,
as err_dev_remv will call return ERR_PTR(ret).

> +		goto err_dev_remv;
> +
>  	/* This guarantees that num_possible_rss_qs <= num_online_cpus */
>  	num_possible_rss_qs = min_t(u32, num_online_cpus(),
>  				    rsscap.num_recv_que);
> @@ -1558,7 +1570,7 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
>  	net_device->num_chn = min(net_device->max_chn, device_info->num_chn);
>  
>  	if (!netif_is_rxfh_configured(net)) {
> -		for (i = 0; i < ITAB_NUM; i++)
> +		for (i = 0; i < ndc->rx_table_sz; i++)
>  			ndc->rx_table[i] = ethtool_rxfh_indir_default(
>  						i, net_device->num_chn);
>  	}
> @@ -1596,11 +1608,18 @@ void rndis_filter_device_remove(struct hv_device *dev,
>  				struct netvsc_device *net_dev)
>  {
>  	struct rndis_device *rndis_dev = net_dev->extension;
> +	struct net_device *net = hv_get_drvdata(dev);
> +	struct net_device_context *ndc = netdev_priv(net);

nit: Please use reverse xmas tree order - longest line to shortest -
     for local variable declaration sin networking code.

	struct rndis_device *rndis_dev = net_dev->extension;
	struct net_device *net = hv_get_drvdata(dev);
	struct net_device_context *ndc;

	ndc = netdev_priv(net);

>  
>  	/* Halt and release the rndis device */
>  	rndis_filter_halt_device(net_dev, rndis_dev);
>  
>  	netvsc_device_remove(dev);
> +
> +	ndc->rx_table_sz = 0;
> +	kfree(ndc->rx_table);
> +	ndc->rx_table = NULL;
> +
>  }
>  
>  int rndis_filter_open(struct netvsc_device *nvdev)

-- 
pw-bot: cr


