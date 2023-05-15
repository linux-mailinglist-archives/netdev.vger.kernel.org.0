Return-Path: <netdev+bounces-2762-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29439703DF8
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:58:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C1FB1C20BD4
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 19:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 203711952B;
	Mon, 15 May 2023 19:57:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA0418C2B
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:57:57 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2130.outbound.protection.outlook.com [40.107.100.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0173D7
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:57:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4mPS/RTKi5vhgS0tfpAkGc18RbvTMVUJkvlEJmPQLRB8r14tX7jYhJO7U+ENCC/MrgQqtfiuA+hQPCGFkk1c41MKTOaCxsNPNxh9VR+ZsAsXucuvjlqlLRjv6C+E+/paX/TvQ3TwmB3sqENbrZZugvwMEjlaGiRxTFhVjB2nI/HxRKQUeNqBRb7PTiU3zB5Oxhu1WVf8GVIHQI526CkHbLo+QDm30oOwLaQ14SZZ+Ca58ITCDV9qgyGW15US3UI7K5/F/5RUVO5i9iRrdvgxSGOfx/tG0VZfMw2QJZBeowskZMz9QuejNOEc6Zf7Q0VQuZB/dpTp1tuCULXZ8OYPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWyejs6H76So/IWAKmStl1EK7ru7Hvma+71cg4VnMRc=;
 b=Yn0I+lLpW1WuPbHMj/X8JTs0Swp1NMPyLXLZoVvtzYKsZgg27yJW26yAPwdB1B8Zpan8L4wG4vP8xeUj5R0uAKe36haInS8o1MciepiceTvUvsJdueD7avPknSA4LdPwHJnrbNdNRXdqQ+RrT88OKs88WT409Ja7BVk/dkkVOGCW+53dEpmfSCbKcvBGBu/MtxkshIV/rX0QxTYXafX6Swy4pcc1CvVE+RC1zbtSWsxnlrkYTZBg9+DhUoVXVlkYuSEH6JqQMzz35j79f1maD+LGMOB9I9jpS1aDN1TJmak02jFam1m+WWBxPrurTyodBUldY/hDB4PSIJXMQoflmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWyejs6H76So/IWAKmStl1EK7ru7Hvma+71cg4VnMRc=;
 b=ZN1lHNM55yAFEtoU1hERyyLdXX2Z1vyYfG/bFOXbcjue3A3QVYaMycQBqx1c3z3cn4r5lgp+2wYVdXcuGOH9FrFNBp8nW1sZ1gSLrucpQPTrytfbgR+/uBmTrm1+CdviMhWZrmVU2Ho7AP6HhX2Tth66NRbNUYyYlhDTMWl5U2k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5232.namprd13.prod.outlook.com (2603:10b6:408:15b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 19:57:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 19:57:52 +0000
Date: Mon, 15 May 2023 21:57:41 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hao Lan <lanhao@huawei.com>
Cc: netdev@vger.kernel.org, yisen.zhuang@huawei.com, salil.mehta@huawei.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, richardcochran@gmail.com,
	wangpeiyang1@huawei.com, shenjian15@huawei.com,
	chenhao418@huawei.com, wangjie125@huawei.com, yuanjilin@cdjrlc.com,
	cai.huoqing@linux.dev, xiujianfeng@huawei.com
Subject: Re: [PATCH net-next 3/4] net: hns3: fix strncpy() not using dest-buf
 length as length issue
Message-ID: <ZGKOdijGtX03qV2p@corigine.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
 <20230515134643.48314-4-lanhao@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515134643.48314-4-lanhao@huawei.com>
X-ClientProxiedBy: AM0PR02CA0220.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5232:EE_
X-MS-Office365-Filtering-Correlation-Id: 41ce1967-5ed3-4cde-a0e8-08db557eaabb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aI5R6q1hGJRptE1U2L4qEjo1nbZXTO/WFbBcfL3Cw/IJeriIvMqiK9PmVYO6EXMxAQc0wiJGlwXV2cb4exrkcfTB3V+88G11r8XhU6FN8dBALKCGu4yVYfs4mDAm+T8+Oh+7Gwam24IAKnOzEI24u3oYZYTc8DQ0KLcaC0FQvYPxH9/6Pkh/josG/nEcDXCvRu4M3KS5kZZgwddwjBuCLnIgRFzmwCBRVlynE9QUg/vmvXDq9kR3WRsDsJVRCmV6NhJJ0F3U8VRzriL0enwmQRQzUchnc3GXNy4XfzKXxztX2QFksX1BnX9bBYfQZyF7SoRW1io0RzQk3tplAIM3PBCnUu96/6+Grm0btew6dfOHXw3hksxYEw2MMEYaZwN5rxWKkytb2ZIaZJah8PbX+U6aAN7KbrjZ1OoVSCoeya/7/9AesXjIeK4f/CZmnLH+k/44Bj+off2f89vi/nAw+vfcPCSFbO/AJYqiJDn8ASfVKj4jF7+92IyeP6clCwyFBPwmi5CJK2PiomJ84XFhMFaq5feDDlEonXVxPzG3jyA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39840400004)(366004)(451199021)(966005)(66946007)(66476007)(66556008)(478600001)(6916009)(4326008)(6486002)(86362001)(316002)(36756003)(83380400001)(186003)(2616005)(6512007)(6506007)(8936002)(5660300002)(8676002)(44832011)(7416002)(6666004)(2906002)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4OQe9A0l5kXf+h3bddiwjyvp518luZzp8wxxFrLsUbeDLwabN2i2MfP225Fv?=
 =?us-ascii?Q?5DEVxBN03HEFVCvFTv3uqbh9QFjNHVfXtSmagECfl1O9q+6qGkYmrc5s3Zv6?=
 =?us-ascii?Q?Lpla+78WE+C/5j7ri+mdoWmsn0it/QFVRNsRt1yIetcWn357CYx1nyWVgsic?=
 =?us-ascii?Q?v6rcrwdkn2u5jyVLX2OJ9J5DOZPESGPp6KNJ1R3nm83oHs96wF3VjSfy8ZWX?=
 =?us-ascii?Q?KG6kxM6x67zWOYT5t0nGAxiOcmbZHKwtgOvzFXG73OFwDT5JT91U88niJEud?=
 =?us-ascii?Q?rruT7FiFoBeEE0a4c0ijJ7hL/bozzd3+jiyxUkzxHBYDvd5FVPcc5DF+1xHE?=
 =?us-ascii?Q?GgKcF7unTsjrGI5YvKmPXX4SGt/s5N6TdWVexSrtjpwnlbLGiQqAXHznhOBi?=
 =?us-ascii?Q?xb01YQBtDMOcfFXYRD+vae4mmgHNmv1jbbH5XaggSB27k5oyTGug6fOxvLI0?=
 =?us-ascii?Q?wm3O9NpIlshjsR6wQAvdstEKNmW+PawtNUHfDHH+fEVToIiLFX0FJL2CiFKd?=
 =?us-ascii?Q?I670Pi2H5xQS/qv2UzHkKbsiG/FgUh8n/uvXLGXxwvE2TKpghtYdhm2lSfEq?=
 =?us-ascii?Q?vnsH0kVLj34zgDSVQqxRiOfNBDH9ZFVxnTKMB9yvIsVVNldnfFrBsKwcQXNP?=
 =?us-ascii?Q?Zs1rtQweC4NBpShyrQeDTDCZAbQR2oB7O0WEQNTGrxbfTli+2ReX80YiE+MS?=
 =?us-ascii?Q?Y6muNxVPRHB/FNGJ4m+0EgOvRzURWmJIUJF3K4Q6Z0uu4sKkUJxrAM/nnZld?=
 =?us-ascii?Q?g+7nwfkCBnMvWmDwJ1RCe6BgYHjmQXM90ctjzY0vewdh6/uwBiQGJzfbynL5?=
 =?us-ascii?Q?yaZ4433oQ2Df8ejp1ezzVe4rdxM2/a2WuTdaXEFo0HXnWnW5+xui/i4JrmVS?=
 =?us-ascii?Q?YHZW3Rist13BIWPLF37wwGVPgs/OUXfKXm896Hdgb4+etqQJED1Vwcq7TwhL?=
 =?us-ascii?Q?gidM3y5n73Kxisq6tkI9EysZpBIIUBqSWoHDRZqpCb2hSQ5EZSVTGTfsSKzL?=
 =?us-ascii?Q?7YdpPFxA0Nx4YOz9etBKWYeRIeZ4TvzvHj4yUylqvobhG8lWOmaXuoOiaeEU?=
 =?us-ascii?Q?orSWZ+pmxgtT6L2C44zC5cRiEtviWHqo31g4vyN9tIWVHrPOY4tMdAPmANPZ?=
 =?us-ascii?Q?EsCtlduRQ9ejBuqHLbkwf5AsXEkalnKO5CoPoMpbHGxqn4jPHVuCVN7G/rHe?=
 =?us-ascii?Q?46NzQ6dBPjdS4H5jWZuCfhc4b8ofoONRomtOKuzpBRiQ7R08bK2JyRi9HBoN?=
 =?us-ascii?Q?SXMQorpjlRtchSenHi3lH1uz0pArUsivrnQuttX3gD2mfiSxZ6XlYQ5uzlM7?=
 =?us-ascii?Q?Lc6cFnha1j//rdNqE3hJmlFF6nMhn70fGBJoNoTwvu9lxBJSW6DPVvk3D0ev?=
 =?us-ascii?Q?8hlh8xZxU/NFgXs6rlLCtVp/I/UcIJmglmYZLGeGnFN86Bv4C4g3PRlpiWo0?=
 =?us-ascii?Q?EaulsAqskqK9fNJ/efMIlfkBSFfSvgvhzeDPH0vXpkpcGq+MHpLj8HKZI+ZN?=
 =?us-ascii?Q?OhDReYBHvRM2Ab50xjha36zWXhwoaIojxh52POeS789iCkK/tC7HfaLu9SgN?=
 =?us-ascii?Q?AiSpAqRzQayuIBIeGHhIg/sEFUW1zhWwY0/qQgWn+m5RbrV2k4CNcbQhoVGF?=
 =?us-ascii?Q?6sBEBlCBohi/ypzNrDFiGAmQFvy2/H0wtSAK+IaIVVvgvBXGnQunBje+HQi7?=
 =?us-ascii?Q?VbPVNw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41ce1967-5ed3-4cde-a0e8-08db557eaabb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 19:57:52.5496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pZRbgg/BBJPAkaJ6cdE4X8wbjmdcrg/23CKUnRFHf960BueAdXZzFXUdm8zl8gZ/JArSR8oiwpV1IfWxJuc08Z6yi4j07s3DCKNgELqCB1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5232
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 09:46:42PM +0800, Hao Lan wrote:
> From: Hao Chen <chenhao418@huawei.com>
> 
> Now, strncpy() in hns3_dbg_fill_content() use src-length as copy-length,
> it may result in dest-buf overflow.
> 
> This patch is to fix intel compile warning for csky-linux-gcc (GCC) 12.1.0
> compiler.
> 
> The warning reports as below:
> 
> hclge_debugfs.c:92:25: warning: 'strncpy' specified bound depends on
> the length of the source argument [-Wstringop-truncation]
> 
> strncpy(pos, items[i].name, strlen(items[i].name));
> 
> hclge_debugfs.c:90:25: warning: 'strncpy' output truncated before
> terminating nul copying as many bytes from a string as its length
> [-Wstringop-truncation]
> 
> strncpy(pos, result[i], strlen(result[i]));
> 
> strncpy() use src-length as copy-length, it may result in
> dest-buf overflow.
> 
> So,this patch add some values check to avoid this issue.
> 
> Signed-off-by: Hao Chen <chenhao418@huawei.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/lkml/202207170606.7WtHs9yS-lkp@intel.com/T/
> Signed-off-by: Hao Lan <lanhao@huawei.com>
> ---
>  .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 31 ++++++++++++++-----
>  .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 29 ++++++++++++++---
>  2 files changed, 48 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> index 4c3e90a1c4d0..cf415cb37685 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
> @@ -438,19 +438,36 @@ static void hns3_dbg_fill_content(char *content, u16 len,
>  				  const struct hns3_dbg_item *items,
>  				  const char **result, u16 size)
>  {
> +#define HNS3_DBG_LINE_END_LEN	2
>  	char *pos = content;
> +	u16 item_len;
>  	u16 i;
>  
> +	if (!len) {
> +		return;
> +	} else if (len <= HNS3_DBG_LINE_END_LEN) {
> +		*pos++ = '\0';
> +		return;
> +	}
> +
>  	memset(content, ' ', len);
> -	for (i = 0; i < size; i++) {
> -		if (result)
> -			strncpy(pos, result[i], strlen(result[i]));
> -		else
> -			strncpy(pos, items[i].name, strlen(items[i].name));
> +	len -= HNS3_DBG_LINE_END_LEN;
>  
> -		pos += strlen(items[i].name) + items[i].interval;
> +	for (i = 0; i < size; i++) {
> +		item_len = strlen(items[i].name) + items[i].interval;
> +		if (len < item_len)
> +			break;
> +
> +		if (result) {
> +			if (item_len < strlen(result[i]))
> +				break;
> +			memcpy(pos, result[i], strlen(result[i]));
> +		} else {
> +			memcpy(pos, items[i].name, strlen(items[i].name));

Hi,

The above memcpy() calls share the same property as the warning that
is being addressed: the length copied depends on the source not the
destination.

With the reworked code this seems safe. Which is good. But I wonder if,
given all the checking done, it makes sense to simply call strcpy() here.
Using strlen() as a length argument seems odd to me.

> +		}
> +		pos += item_len;
> +		len -= item_len;
>  	}
> -
>  	*pos++ = '\n';
>  	*pos++ = '\0';
>  }
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
> index a0b46e7d863e..1354fd0461f7 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
> @@ -88,16 +88,35 @@ static void hclge_dbg_fill_content(char *content, u16 len,
>  				   const struct hclge_dbg_item *items,
>  				   const char **result, u16 size)
>  {
> +#define HCLGE_DBG_LINE_END_LEN	2
>  	char *pos = content;
> +	u16 item_len;
>  	u16 i;
>  
> +	if (!len) {
> +		return;
> +	} else if (len <= HCLGE_DBG_LINE_END_LEN) {
> +		*pos++ = '\0';
> +		return;
> +	}
> +
>  	memset(content, ' ', len);
> +	len -= HCLGE_DBG_LINE_END_LEN;
> +
>  	for (i = 0; i < size; i++) {
> -		if (result)
> -			strncpy(pos, result[i], strlen(result[i]));
> -		else
> -			strncpy(pos, items[i].name, strlen(items[i].name));
> -		pos += strlen(items[i].name) + items[i].interval;
> +		item_len = strlen(items[i].name) + items[i].interval;
> +		if (len < item_len)
> +			break;
> +
> +		if (result) {
> +			if (item_len < strlen(result[i]))
> +				break;
> +			memcpy(pos, result[i], strlen(result[i]));
> +		} else {
> +			memcpy(pos, items[i].name, strlen(items[i].name));
> +		}
> +		pos += item_len;
> +		len -= item_len;
>  	}
>  	*pos++ = '\n';
>  	*pos++ = '\0';
> -- 
> 2.30.0
> 
> 

