Return-Path: <netdev+bounces-11564-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1731733A03
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:36:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BCEB281872
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC0061EA84;
	Fri, 16 Jun 2023 19:36:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2811B914
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 19:36:10 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2125.outbound.protection.outlook.com [40.107.92.125])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B85E35A8;
	Fri, 16 Jun 2023 12:35:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNV3NEwQ4zI5+v75xo+gZbGTamWjaZ9hz7/btChlPAn/kqvZc40eL4fG/23tx+BMnCaPgXzk1VxkodENYOKZm4kZtM/+v1byAlr1cZEIZsoXYW4V16GTh3gg+SGmN4/McQjjBmHXfCN7KVTbW0tQ/wYD8MovnZwjgpYWyMaT8o4jkoxKDpoUSIOFVFMPN8t6aFI1nAMB3d9UPPxqTJ7eFZogH2PUjBHy7e00bks3iR+vZQxSXSVJA8kXHemBqIP91aFVpFiaxFvVIc6hThNmfciB4CLiiqLXtuVBTwGK5DAIMqdBq58kBarGTnk4tskjpfIoFtZnt9/jyxtDrop5xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mlGP1opildznuglcn3sMdMZGvNJdVBccGIB1UXbjghE=;
 b=Oj/wUmM2lWF0B4bDZpKrtv14cT6wGU56PbLJquTTfYJ+En9lwv9k6jQjZNuqnev6uaQT//ff2wGC6ZpWe3lXsENwUgo7NhBHtVAuK+d71GgxULqCY1icT0I89yuurGSdOPUkJJuI9HIYm7klKzCW0LnkmA3Zn+HS3Gyj6kdJYvQBGV010LvhggitHA2einVXvT1aNRQo+0kdsrZqd6aHejR/ZdHiDAAWcT6+nN2WTru1H2yAIPplII6DAKoax6fx7mNWNg1qYSw9AonumUlltYwqahds9Enc6yzWaY/J3nM6rdpj/H5U0SQ38FrWgp39vzABWd5mCxZTjXnTjuu5MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlGP1opildznuglcn3sMdMZGvNJdVBccGIB1UXbjghE=;
 b=W/lhLg6Tg4oQjAeH9fI/FwE6HrWKFbbEofVJt/1kWdVbinFeG8jKK5uzDdLFz2ufvtLNDVSqtsLzkq5w5M2UBDQ7rMr9xd7ooRb1PmEuqzuRR2UEuNs1MXeaOxHYp9u1U0NZVPt5/DwFJKoaBEwqlAjYedQxePp04+fCIKyhsdg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3896.namprd13.prod.outlook.com (2603:10b6:610:95::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 19:35:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 19:35:48 +0000
Date: Fri, 16 Jun 2023 21:35:40 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, richardcochran@gmail.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, sebastian.tobuschat@nxp.com
Subject: Re: [PATCH net-next v1 05/14] net: phy: nxp-c45-tja11xx: prepare the
 ground for TJA1120
Message-ID: <ZIy5jBAS66rqXjAd@corigine.com>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-6-radu-nicolae.pirea@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616135323.98215-6-radu-nicolae.pirea@oss.nxp.com>
X-ClientProxiedBy: AM3PR07CA0136.eurprd07.prod.outlook.com
 (2603:10a6:207:8::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3896:EE_
X-MS-Office365-Filtering-Correlation-Id: e3247974-ce36-4ccf-c7fc-08db6ea0e248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kWf5oIYzGFEIYkfWFv4GyyarwUoCGMntyMZH19ZeKjwQ0bXLQGoGtz0wwJrD0mSgzxfTd34bD/P+5xj5TrVK/uQOyRPcuwn2NvQsI0Tv+zY9SDxzhxoUsKRaHjdvFd9CQ2F8cNP5gdS3HxG3knJpxqhwegf9mJeXoPL+PFA0UOimgF0H3mYy0YxB2rQyfgHqC/6xc7rt9ntH5KvRh2/BX1q0cen/L2EBwVmkgwG52bIm7UmD2V6MHtpwIucaKuGCqnt4+x4ZpdrNX7UeWy2/NAEIeZmmDgBjSLBOgZUe3IPizSpr1fveM9H/Drrhmstl1GpXY/S6SX0+Pn5E3xhXQbWecmxzUeKzvC19AdoHgm9t7Y3VQYv7Et8SimP04X6xBteEXGCvYV925NRkAR1lZCBlqpff/yuHwASOs/7g833DhMTzKZ9zyYCd4t71GssbSGoKYqL62yUhArrXVoRwSx+Y9Q+42W8sMxPyuvRe0HRwa5wlwkIlwLOeDAkqkKudE6+apgRUMZczpWnqyG93I83hr1WqZW9QORxvRCQI7oH6yqqWYMQbptcQFmV2Qa8eN747c9U1R7EomvoxEjvDUXQvS7Cw6+g+fpRnRsXPLZk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(366004)(39840400004)(396003)(451199021)(83380400001)(5660300002)(38100700002)(186003)(2616005)(66574015)(6506007)(2906002)(6512007)(44832011)(7416002)(478600001)(66946007)(6916009)(6666004)(8936002)(316002)(66556008)(66476007)(8676002)(6486002)(86362001)(41300700001)(36756003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AwO6JHs7wdqKQ1NM2NLIwv/NJ+sMI0v7tmi8avqIwMvi9e8ztxh3iv3I2eIS?=
 =?us-ascii?Q?D60EJijFVpeo8JHmMsmbD/M2pRyAPVXsaJFqgM+wf3AW395IQ9Pd/Pq9JBCs?=
 =?us-ascii?Q?Ptd38TXYsflcLK6CJ7dXF//MKEJ3rjRN0OUEiPm6E5nt6nXNfSCiodwui90U?=
 =?us-ascii?Q?N43KOkMUuT+NeXa48AGbKvhraAr1xB+/Elkk3kSCsxGowHcuby4iTftFRrgA?=
 =?us-ascii?Q?hlR4baJMs/hxnNTLhaaiHTG8fUSMUf0Oo9E1Do1oT7d18q3cOAXJfA0BGvsd?=
 =?us-ascii?Q?SVbdV0hIKvSb6bRmfF0wRcMEXU0I07T78JWUelX0YOSnwQeltnT5geim4e0X?=
 =?us-ascii?Q?Iv4Uy4D7tBwxHt5orrw/FofUcnCH+3TyRZNDF6u8Gg2b5ayLCGduE2TMSfOV?=
 =?us-ascii?Q?bbuOfPOd+XnEStk/WYPAWPWNxmsGukH0V53RvGIGDyqW8z1Jsudsh9UQFrk6?=
 =?us-ascii?Q?4WHAHOq3+SY86OHK3rYj8U4dG1DEHor44Dw3l+ZKlA5UX2iYiZ5FIXvXRIlZ?=
 =?us-ascii?Q?S92uu/YkwT+DdvTcO+b2V2qJGyrPRy585XrEZzJpG2NwOUJV4izDTQstxL6e?=
 =?us-ascii?Q?R0c6KrPajydDSW7x1aYRD5rl/xIloDBLytm6hd2Nbasfh8bvvinxBf2+v6C5?=
 =?us-ascii?Q?7IwhCbyO5SYN/uY4XTEp1qEXOAC6xO8T/rltoJDBLAg5yJWlirBU7ydSYad7?=
 =?us-ascii?Q?1HIW1j/ul6lBeBOB/LNHTmR0xRrPuJawFMGHaRPY9imjCdi0Pgw8sctGc5vF?=
 =?us-ascii?Q?iJKEE7Tu2drmrKZwjCStFiBuCiceCyKlWh3X04wJ3PoHRtEp3gOe+7aA0So5?=
 =?us-ascii?Q?Msme2eGRIn6puH6kONiJ1qJG5yiD5wf1zu5EE1WzXkKo51JN7o9ieb4L7iz/?=
 =?us-ascii?Q?UoY4fnR8p5CMD8uZsxl/w8V2umpe1Kb3qgwc7Bj6PKwnzpoiKpam87g+TplB?=
 =?us-ascii?Q?GvDI3+wdm+t2oswX0UEe9u0U3/jYGmX0vRXpxqnfPhoAbOPCB+R+zuEmwyDa?=
 =?us-ascii?Q?9v28WnNarryTtkrCyNNw3YCHhs/Xa+bIRBiAPY3joqkIWEqVLbGk3q/FnG/S?=
 =?us-ascii?Q?pbFglkfvVnYTOp09KmKkOjYXoxMDByVo+guEjtvzN82HCwBbv0E/+889ghBl?=
 =?us-ascii?Q?c5Y8in5AgXL9BKur++7assB/wIL6SPKuBBqj4wZKoK4yfxNpKpiMlAvCawVa?=
 =?us-ascii?Q?QVqXQBNQzQNBNnRFtEGCo8WCTmcXZD1bI9ERqAtw9lRPghi6cdu7KP65ks1R?=
 =?us-ascii?Q?VokX7cfaG00U0j0BrKaibsd4ILpHL6FY6ZUfDmOo8fd1+yClnoG65cjpUPve?=
 =?us-ascii?Q?pd52nOp73hI7AIX/jvHUgMGcnlMHNz9OcMU8ZZ8Ev9ZFzvfBkvvzyxfdIAj3?=
 =?us-ascii?Q?2u9KuAhMC4sCcFP820f4X9lrqzjo2jgikQ1kh9McGE2VHJNNqeKK1pqO2HfM?=
 =?us-ascii?Q?SbxqUlmLICEzIklysArwlAsdtb/GUXRiSMW8geCby7LOicNwaQ3p6rQUuRl8?=
 =?us-ascii?Q?DM5P6KiFn7hWqoFvYYyFhw69oJYgS5rcbohFVNv7g92whlXwRyRq51pDNf0A?=
 =?us-ascii?Q?uuKNS5cY1rDmXlaZJPmoyy3z7NJGlf/CE1Ya+nepI08t5CwHPf1N/b9RNsSJ?=
 =?us-ascii?Q?TKfI2sDSC6Ftw+U7xCOusbkfVMAuimDVoEBr3+SythUp+wrhHKNjVpwkDPM5?=
 =?us-ascii?Q?9V/I7w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3247974-ce36-4ccf-c7fc-08db6ea0e248
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 19:35:48.2692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vz1XCWAgwFRAbBbyJuR0QUJvHaKftVcce6fXDHdr31Q6caocNxFhP+7jLa5ft38hAr9qyE6hALMT1N3YlBBV69CZ1+4fQhlw386xRvrH+VA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3896
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 04:53:14PM +0300, Radu Pirea (NXP OSS) wrote:
> Remove the defined bits and register addresses that are not common
> between TJA1103 and TJA1120 and replace them with reg_fields and
> register addresses from phydev->drv->driver_data.
> 
> Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>

Hi Radu,

thanks for your patch-set.

Some minor points from my side.

> @@ -831,27 +862,26 @@ static int nxp_c45_hwtstamp(struct mii_timestamper *mii_ts,
>  	}
>  
>  	if (priv->hwts_rx || priv->hwts_tx) {
> -		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_EVENT_MSG_FILT,
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1,
> +			      data->regmap->vend1_event_msg_filt,
>  			      EVENT_MSG_FILT_ALL);
> -		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
> -				   VEND1_PORT_PTP_CONTROL,
> -				   PORT_PTP_CONTROL_BYPASS);
> +		if (data && data->ptp_enable)
> +			data->ptp_enable(phydev, true);

A check for data being null is made here before dereferencing.
But a few lines above data is dereferenced without such a guard.

This is flagged by Smatch as:

 .../nxp-c45-tja11xx.c:868 nxp_c45_hwtstamp() warn: variable dereferenced before check 'data' (see line 866)`

>  	} else {
> -		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_EVENT_MSG_FILT,
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1,
> +			      data->regmap->vend1_event_msg_filt,
>  			      EVENT_MSG_FILT_NONE);
> -		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PORT_PTP_CONTROL,
> -				 PORT_PTP_CONTROL_BYPASS);
> +		if (data && data->ptp_enable)
> +			data->ptp_enable(phydev, false);

Likewise here.

>  	}
>  
>  	if (nxp_c45_poll_txts(priv->phydev))
>  		goto nxp_c45_no_ptp_irq;
>  
>  	if (priv->hwts_tx)
> -		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
> -				 VEND1_PTP_IRQ_EN, PTP_IRQ_EGR_TS);
> +		nxp_c45_set_reg_field(phydev, &data->regmap->irq_egr_ts_en);
>  	else
> -		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
> -				   VEND1_PTP_IRQ_EN, PTP_IRQ_EGR_TS);
> +		nxp_c45_clear_reg_field(phydev, &data->regmap->irq_egr_ts_en);
>  
>  nxp_c45_no_ptp_irq:
>  	return copy_to_user(ifreq->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;

...

> +static void nxp_c45_ptp_init(struct phy_device *phydev)
> +{
> +	const struct nxp_c45_phy_data *data = nxp_c45_get_data(phydev);
> +
> +	phy_write_mmd(phydev, MDIO_MMD_VEND1,
> +		      data->regmap->vend1_ptp_clk_period,
> +		      data->ptp_clk_period);
> +	nxp_c45_clear_reg_field(phydev, &data->regmap->ltc_lock_ctrl);
> +
> +	if (data && data->ptp_init)
> +		data->ptp_init(phydev);

And here.

> +}
> +

...

