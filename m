Return-Path: <netdev+bounces-1183-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC1996FC83A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:52:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE88E1C20B74
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:52:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F23319501;
	Tue,  9 May 2023 13:52:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682E217ACF
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:52:46 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4363C33;
	Tue,  9 May 2023 06:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683640364; x=1715176364;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yT0Qf9oU1mfClbd/wqWLRrMOt3BKwcEKgF8G/8Fn4xE=;
  b=eaTTPZ8xX1KIjDW/qpkku97iMPXy1z3U9tF8BWB7c3bszS0V/XWrYcCD
   2yMca7bmIbFgOr2Wy1TWZgcyDXFA6BcC1DF6op5GkeG5PuloCqLx7/LBo
   AHUztVfyfmM0Od+GPEaR6ACH0SxDfaOnTpF2vBxDSj/Lm2f86wiWx4Rpg
   pbhJfgBNoE9q5Rr3XF6bX5b3fD2RDXbeZy4xQhmOiaa3daWxBhRJKm3LL
   mHGBAhQqItYY/5ACY6vZLa++YoZEdJ77OD1WQ5FhUyQrqkaW/NXnc5a8J
   Ij2q4uOGiSFizMCbT2dy+MRXNw787z2nIaMv1Dloe403kJ2TPjqOPvV13
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="436247068"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="436247068"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 06:52:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="693001283"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="693001283"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 09 May 2023 06:52:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 06:52:43 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 06:52:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 06:52:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 06:52:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9eUGw8yMHijOQelaVlmbIaY32br0V988tFf7+QFisU8l5ulOZWux9Zu6MUs9+YAbz5D1Ur4FBxKLaj9FhP8+Ch00xLm1ts9pW93rkqHGslkKGysUXvh19aAlz4K6Wu2VRXKtBCl9erbAI1FjKPeQi06N9Hqe8R8tHC8yFti9Yp7Gg0Eq5Q/i2krLqWr/tPcUqOL94cTiseL4x7/LpcPgmBkdq0zCW0Y9Ka/kkpra8PGh0ZQjlq8YSBmjfugfoxJZcg3UyIvnsilXXMEcqdYgKS947aBiZnFqx8oeQoaApVfGQ+N6Ry+1YoNsRUYPnjeH5maNVHcgK3d1X05gn2n3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jRFZHuMwmlnDXRW5lS+D38N7DePj1lcFTxSjCTyczjg=;
 b=QCNRZuE6c05bu29JP564ChuWerAUBpUqP9CDssmhxBD0Fl3acTWRuPYi4nnILWUYXwJUd6znwfz9OvCu1oPl6kVSV/EOuKsj1STvrPgWmy8umH9RsrxXwJTaSvKWnx08hkSM4nIYaIFFeqBjayJ69tfK9SicnsP6P4E27m1sixmJFOclWE8a5JVwgtOZIrl+koMMgW+AtsZ5iKMtsIHRExNeMcrZYfhMe1YhGDb2jtArBi7sYdF8++fXF7ifYkJx/pkBAU+dAMNU2JSMNi3r9PEJ6uodS4rBg84oaXpCXG3DBGfx16v/oYrflv06Rhkiu2w6BhW5DXerEH5rwHn2pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by SA0PR11MB4671.namprd11.prod.outlook.com (2603:10b6:806:9f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 13:52:40 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::ee76:10c6:9f42:9ed9%4]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 13:52:40 +0000
Date: Tue, 9 May 2023 15:52:23 +0200
From: Piotr Raczynski <piotr.raczynski@intel.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
CC: <netdev@vger.kernel.org>, <jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>, <mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>, <Jose.Abreu@synopsys.com>, <andrew@lunn.ch>,
	<hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>, <mengyuanlou@net-swift.com>
Subject: Re: [PATCH net-next v7 2/9] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <ZFpQF4hi0FciwQsj@nimitz>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com>
 <20230509022734.148970-3-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230509022734.148970-3-jiawenwu@trustnetic.com>
X-ClientProxiedBy: LO4P123CA0072.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::23) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|SA0PR11MB4671:EE_
X-MS-Office365-Filtering-Correlation-Id: cbc27674-3060-48d1-87ec-08db5094a78e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pcTLjGb3b4cA36GSqgCsXeRdRThelzXa93wdbChzNnBV9uzqFQ/l/ThppVLI5Ssm8JXomAwPdyZr4aYipAcyPc5/CjlV2SI2uGTwC36xdcu6KSslcqVf/bQY+6fml/SFVtIyKeiTKHyrZyu+qA+Uw+Xe33+FtvW2E33mVqR0IshuD581fNt0qrEIg0eAODmxLk3bU3mOAzXXmD2nP44D7isS4d+pD2NaONrIYF9df2TQJaC01P283Ed935uH2ZssbHtUN5Uv4Sotmeuz9sWoiwaO7aHf5mR9DqoLdqM/wf4T1BV2IL+0uDGgZJpFIMx25M533K8p2vCq7zZBgPlxSiRTUAJKaJql4Ibrd0Lm9427mA5fEJkZcZygc2KVs20kV8T6ASZSHKaKk/5DcmfTLvm/lZCLYbGsACGCn08M7BfCNDZTvYrdS6RIUYQ+jXnqZsJZtq0IWPakhPoO1MSKsH9f5tZXRwPyqi6MO5jEjhX6ygL1q88pQjrP18IymgJKJAKKWjxPwFCRNPDSqAT641I63rHlz2e0D51ENnWi1embCOhWPhdzE69QnhsMl1N/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199021)(83380400001)(6486002)(478600001)(6512007)(9686003)(26005)(6506007)(186003)(8676002)(41300700001)(4326008)(6916009)(66946007)(66476007)(6666004)(66899021)(8936002)(66556008)(316002)(5660300002)(7416002)(2906002)(44832011)(38100700002)(86362001)(33716001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1+wSyq1f53/yGLrigZJXv3RY6QXTEMjupCYVO4EdOUnVPmuI775aBtHl2U6C?=
 =?us-ascii?Q?yxkKSoMdD3D7fOhJ+sSe9TckLnuJ+fxYdbespVstSW9cPblCQg1dvoFkixCB?=
 =?us-ascii?Q?Os5hoT5NNhYoodNhEMuslK4gb8PwecqcI9MvSccV8EvCO4+FGkmk5rXV+psY?=
 =?us-ascii?Q?7MU8efy9gOaOF4NzVaTpM1DBRcxbgaqt2KOwbfI0puwfPdnCpFsR1LTykUQz?=
 =?us-ascii?Q?Us9ghwcqDAyETQaK1N7piP0IMJgehkOS8D48ShKFt4jDqHDf3aq33uRviEg1?=
 =?us-ascii?Q?VICr18OnnPO37gJbCoxDCqXD2aD0rZnCZaFVhbdiybM8efmSAtvaF0PX468C?=
 =?us-ascii?Q?LlVcMq2WTD5pCZuWM25Tkz0zW0iFIRDxe6IJb2qSAwHXvHYLGHpAm2h8PduT?=
 =?us-ascii?Q?gZkUlG0efnH2x7uvRlT5zfTYXt6M0zDYpTdRbxuObviuwyVYWXVSixZ3gCDB?=
 =?us-ascii?Q?e+IHtwWp+1UJYbmpXFxyF4whnRfODp2YQ3eAxE6FjbupsHxwsKwI3bFIKAEy?=
 =?us-ascii?Q?FkFsaVVJZ6Isbq1pCSNQ9ptNddA8PlnfBQG/Jyf4PKDxUS8/TyRFJZkJgvV0?=
 =?us-ascii?Q?foogUmJrTLkqN6vPX77M1SFQp9XUvMm2Uevx+cIsJrskRCeYgAdS6iSKy0RT?=
 =?us-ascii?Q?oDKlDwWtCSjzi4a13NnndSPYTqvHj9HIZ3kLkZO6BEyjTg2lb9yEbow74IZ0?=
 =?us-ascii?Q?G3AtyAomIzqsqPsCl1hMUI925UxockjHiyyqut004VAL9QmEsi8BNj8ULytv?=
 =?us-ascii?Q?JIpphDCRnKNrMwwtcHrGDX2fO3M/+BeVfE+kOKXn48981PJY4FkQaCAdQ02r?=
 =?us-ascii?Q?c1F3c7cWrVv6eMykNxk1WT1KJBzPzaGC2fnPW1OXRX3PxeWPFWOuFWAFUzpX?=
 =?us-ascii?Q?s+H6KWT3qCMJKbIs4g1KMYZI3I4Zdlg4O0d85XMwOhU/b/FtJf1nxoW/3eX6?=
 =?us-ascii?Q?u4P9d2PRfzYjcKGQHP9LY061ppD55hIK3rLfVV7x5Dsz2mEvo2dLAuhGyrKs?=
 =?us-ascii?Q?MjBjPjwnIFm5FLo1gBN4pxmm4kcuvNEOb63cRN4g8Z93MAh8D7Q4yTeYWHQv?=
 =?us-ascii?Q?nZi4Pieo+JOpTE3kZtW9pBy6ZVz7Ul01Z5w0cddWWV89yKJfbqUXq8tUnkpm?=
 =?us-ascii?Q?5C6FnNMNQgXnHCCZDsXKHYCC1aWz4y+t599JFcKGiBOhhJ0SXpqyRkb78l7w?=
 =?us-ascii?Q?063iV7G4kyO2G9NcSTjIuu9n1JPCOiwnCVUKdStVS8wlnDreQ0R+FdKECQPE?=
 =?us-ascii?Q?odPSMPxWg24Bju7TqjnPq0vVnBr2TDzBpY+Tip2VbZtGwqt7D6oZBiAWv9TP?=
 =?us-ascii?Q?V8RDAr9Ni/in6xPz/67TtSrs3isnFRaCbX0iPOAaTiy2UvcqrigV89z/exYW?=
 =?us-ascii?Q?wqty0GF5qUSsNVhrKd6GuPehJqArDuRboeYWbkcFOFIxkqBH5YdZ83PXaYI7?=
 =?us-ascii?Q?WpT17YmavyZuKOw1uRW5yTVHrSCE9enRZXCl2/uGjR8YXBY9MkrEsxMvhyIW?=
 =?us-ascii?Q?vVGkc+I2W+wYrouBPwYZqBGosE9PY7gnDsBIMxKHXgZu4K7vGG/5sm8UhdsH?=
 =?us-ascii?Q?QVYAeVpzsoG8FEq2d3luqzjgw4qhr87ewYe7tA3kYN5NX4J9aEXMUb4EYWgs?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc27674-3060-48d1-87ec-08db5094a78e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 13:52:40.1424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3yP+018+nCaMp3mbPDsbRgLzdudW0uC3m3Lc701rZ8TdjGR8w0VhpM8ZpuEOD+foqO/xd/94IpdfQJfrp9NysPDirHeGrGhaMykB14R+Vs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4671
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 10:27:27AM +0800, Jiawen Wu wrote:
> Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> with SFP.
> 
> Introduce the property "snps,i2c-platform" to match device data for Wangxun
> in software node case. Since IO resource was mapped on the ethernet driver,
> add a model quirk to get regmap from parent device.
> 
> The exists IP limitations are dealt as workarounds:
> - IP does not support interrupt mode, it works on polling mode.
> - Additionally set FIFO depth address the chip issue.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>

I'm definitely not an i2c expert, a couple of nit picks below, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

> ---
>  drivers/i2c/busses/i2c-designware-common.c  |  8 ++
>  drivers/i2c/busses/i2c-designware-core.h    |  1 +
>  drivers/i2c/busses/i2c-designware-master.c  | 89 +++++++++++++++++++--
>  drivers/i2c/busses/i2c-designware-platdrv.c | 15 ++++
>  4 files changed, 108 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
> index 0dc6b1ce663f..a7c2e67ccbf6 100644
> --- a/drivers/i2c/busses/i2c-designware-common.c
> +++ b/drivers/i2c/busses/i2c-designware-common.c
> @@ -575,6 +575,14 @@ int i2c_dw_set_fifo_size(struct dw_i2c_dev *dev)
>  	unsigned int param;
>  	int ret;
>  
> +	/* DW_IC_COMP_PARAM_1 not implement for IP issue */
> +	if ((dev->flags & MODEL_MASK) == MODEL_WANGXUN_SP) {
> +		dev->tx_fifo_depth = 4;
I understand this is some kind of workaround but is the number chosen
empirically? Maybe a defined value would be clearer instead of magic
number.
> +		dev->rx_fifo_depth = 0;
> +
> +		return 0;
> +	}
> +
>  	/*
>  	 * Try to detect the FIFO depth if not set by interface driver,
>  	 * the depth could be from 2 to 256 from HW spec.
> diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
> index c5d87aae39c6..e2213b08d724 100644
> --- a/drivers/i2c/busses/i2c-designware-core.h
> +++ b/drivers/i2c/busses/i2c-designware-core.h
> @@ -303,6 +303,7 @@ struct dw_i2c_dev {
>  #define MODEL_MSCC_OCELOT			BIT(8)
>  #define MODEL_BAIKAL_BT1			BIT(9)
>  #define MODEL_AMD_NAVI_GPU			BIT(10)
> +#define MODEL_WANGXUN_SP			BIT(11)
>  #define MODEL_MASK				GENMASK(11, 8)
>  
>  /*
> diff --git a/drivers/i2c/busses/i2c-designware-master.c b/drivers/i2c/busses/i2c-designware-master.c
> index 55ea91a63382..3bfd7a2232db 100644
> --- a/drivers/i2c/busses/i2c-designware-master.c
> +++ b/drivers/i2c/busses/i2c-designware-master.c
> @@ -354,6 +354,68 @@ static int amd_i2c_dw_xfer_quirk(struct i2c_adapter *adap, struct i2c_msg *msgs,
>  	return 0;
>  }
>  
> +static int i2c_dw_poll_tx_empty(struct dw_i2c_dev *dev)
> +{
> +	u32 val;
> +
> +	return regmap_read_poll_timeout(dev->map, DW_IC_RAW_INTR_STAT, val,
> +					val & DW_IC_INTR_TX_EMPTY,
> +					100, 1000);
> +}
> +
> +static int i2c_dw_poll_rx_full(struct dw_i2c_dev *dev)
> +{
> +	u32 val;
> +
> +	return regmap_read_poll_timeout(dev->map, DW_IC_RAW_INTR_STAT, val,
> +					val & DW_IC_INTR_RX_FULL,
> +					100, 1000);
> +}
> +
> +static int txgbe_i2c_dw_xfer_quirk(struct i2c_adapter *adap, struct i2c_msg *msgs,
> +				   int num_msgs)
> +{
> +	struct dw_i2c_dev *dev = i2c_get_adapdata(adap);
> +	int msg_idx, buf_len, data_idx, ret;
> +	unsigned int val, stop = 0;
> +	u8 *buf;
> +
> +	dev->msgs = msgs;
> +	dev->msgs_num = num_msgs;
> +	i2c_dw_xfer_init(dev);
> +	regmap_write(dev->map, DW_IC_INTR_MASK, 0);
> +
> +	for (msg_idx = 0; msg_idx < num_msgs; msg_idx++) {
> +		buf = msgs[msg_idx].buf;
> +		buf_len = msgs[msg_idx].len;
> +
> +		for (data_idx = 0; data_idx < buf_len; data_idx++) {
> +			if (msg_idx == num_msgs - 1 && data_idx == buf_len - 1)
> +				stop |= BIT(9);
> +
> +			if (msgs[msg_idx].flags & I2C_M_RD) {
> +				regmap_write(dev->map, DW_IC_DATA_CMD, 0x100 | stop);
> +
> +				ret = i2c_dw_poll_rx_full(dev);
> +				if (ret)
> +					return ret;
> +
> +				regmap_read(dev->map, DW_IC_DATA_CMD, &val);
> +				buf[data_idx] = val;
> +			} else {
> +				ret = i2c_dw_poll_tx_empty(dev);
> +				if (ret)
> +					return ret;
> +
> +				regmap_write(dev->map, DW_IC_DATA_CMD,
> +					     buf[data_idx] | stop);
> +			}
> +		}
> +	}
> +
> +	return num_msgs;
> +}
> +
>  /*
>   * Initiate (and continue) low level master read/write transaction.
>   * This function is only called from i2c_dw_isr, and pumping i2c_msg
> @@ -559,13 +621,19 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
>  	pm_runtime_get_sync(dev->dev);
>  
>  	/*
> -	 * Initiate I2C message transfer when AMD NAVI GPU card is enabled,
> +	 * Initiate I2C message transfer when polling mode is enabled,
>  	 * As it is polling based transfer mechanism, which does not support
>  	 * interrupt based functionalities of existing DesignWare driver.
>  	 */
> -	if ((dev->flags & MODEL_MASK) == MODEL_AMD_NAVI_GPU) {
> +	switch (dev->flags & MODEL_MASK) {
> +	case MODEL_AMD_NAVI_GPU:
>  		ret = amd_i2c_dw_xfer_quirk(adap, msgs, num);
>  		goto done_nolock;
> +	case MODEL_WANGXUN_SP:
> +		ret = txgbe_i2c_dw_xfer_quirk(adap, msgs, num);
> +		goto done_nolock;
> +	default:
> +		break;
>  	}
Nit pick, when I first saw above code it looked a little weird, maybe it would be a
little clearer with:

	if (i2c_dw_is_model_poll(dev)) {
		switch (dev->flags & MODEL_MASK) {
		case MODEL_AMD_NAVI_GPU:
			ret = amd_i2c_dw_xfer_quirk(adap, msgs, num);
			break;
		case MODEL_WANGXUN_SP:
			ret = txgbe_i2c_dw_xfer_quirk(adap, msgs, num);
			break;
		default:
			break;
		}
		goto done_nolock;
	}

I do not insist though.

>  
>  	reinit_completion(&dev->cmd_complete);
> @@ -848,7 +916,7 @@ static int i2c_dw_init_recovery_info(struct dw_i2c_dev *dev)
>  	return 0;
>  }
>  
> -static int amd_i2c_adap_quirk(struct dw_i2c_dev *dev)
> +static int i2c_dw_poll_adap_quirk(struct dw_i2c_dev *dev)
>  {
>  	struct i2c_adapter *adap = &dev->adapter;
>  	int ret;
> @@ -862,6 +930,17 @@ static int amd_i2c_adap_quirk(struct dw_i2c_dev *dev)
>  	return ret;
>  }
>  
> +static bool i2c_dw_is_model_poll(struct dw_i2c_dev *dev)
> +{
> +	switch (dev->flags & MODEL_MASK) {
> +	case MODEL_AMD_NAVI_GPU:
> +	case MODEL_WANGXUN_SP:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>  int i2c_dw_probe_master(struct dw_i2c_dev *dev)
>  {
>  	struct i2c_adapter *adap = &dev->adapter;
> @@ -917,8 +996,8 @@ int i2c_dw_probe_master(struct dw_i2c_dev *dev)
>  	adap->dev.parent = dev->dev;
>  	i2c_set_adapdata(adap, dev);
>  
> -	if ((dev->flags & MODEL_MASK) == MODEL_AMD_NAVI_GPU)
> -		return amd_i2c_adap_quirk(dev);
> +	if (i2c_dw_is_model_poll(dev))
> +		return i2c_dw_poll_adap_quirk(dev);
>  
>  	if (dev->flags & ACCESS_NO_IRQ_SUSPEND) {
>  		irq_flags = IRQF_NO_SUSPEND;
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index 89ad88c54754..1bf50150386d 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -168,6 +168,15 @@ static inline int dw_i2c_of_configure(struct platform_device *pdev)
>  }
>  #endif
>  
> +static int txgbe_i2c_request_regs(struct dw_i2c_dev *dev)
> +{
> +	dev->map = dev_get_regmap(dev->dev->parent, NULL);
> +	if (!dev->map)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
>  static void dw_i2c_plat_pm_cleanup(struct dw_i2c_dev *dev)
>  {
>  	pm_runtime_disable(dev->dev);
> @@ -185,6 +194,9 @@ static int dw_i2c_plat_request_regs(struct dw_i2c_dev *dev)
>  	case MODEL_BAIKAL_BT1:
>  		ret = bt1_i2c_request_regs(dev);
>  		break;
> +	case MODEL_WANGXUN_SP:
> +		ret = txgbe_i2c_request_regs(dev);
> +		break;
>  	default:
>  		dev->base = devm_platform_ioremap_resource(pdev, 0);
>  		ret = PTR_ERR_OR_ZERO(dev->base);
> @@ -277,6 +289,9 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	dev->flags = (uintptr_t)device_get_match_data(&pdev->dev);
> +	if (device_property_present(&pdev->dev, "snps,i2c-platform"))
> +		dev->flags |= MODEL_WANGXUN_SP;
> +
>  	dev->dev = &pdev->dev;
>  	dev->irq = irq;
>  	platform_set_drvdata(pdev, dev);
> -- 
> 2.27.0
> 
> 

