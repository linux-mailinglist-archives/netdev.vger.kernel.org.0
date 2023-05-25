Return-Path: <netdev+bounces-5346-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61107710E7B
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:41:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1826028122C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E619913AC3;
	Thu, 25 May 2023 14:41:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5066FC05
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:41:31 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20610.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::610])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ABA139
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 07:41:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6xpNwCvJ82sGqpq1aMTAtto7/GAFN64zvRGe1CodpAV1E0R8jeI+OZ+d+TCXULueGFPXAmEewW61i6boI/p++0mi2ztQqn7p1f6PlUOEv9KTDsf2e5CZMmiGR7noKLyGV5JxIXP/jywEXlGitZmvpWBC5dFctWB53PhiysrSk2+X3EDvdWCUIbLkPwvt2UaYcRD6GqsSJDHN+Au8wTDxqy7p8WeLdR6GRgvVhuzQuy19V+x6wdUioBgIc4wE1ePJFRXCS+YDFkq0Hw8Tgm5pfv7XOSGX39j0ys3lsR3LhKF0G6hmO6CZtZ4Chtu0omDh9bFng/WVugwxknICM9TCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hm4elB0ZF40BIn9+Ew14R6RNIhWIMR92UZDNVDnbaOk=;
 b=FUPp33SdjbW4rM9TVBFP7fzuOfYNG4mA3D9b4SQwmrIOAoDlRwTMPaB0dc5kFNUQOQY4WorXtxpmiBa2whAcs6s3dklqwKPho+n/EfysnibfKnLzEzpmNb2xV3kuurrKk683fa2+61Z0sMUTgZEddTNhw2ON/RqkBf+aOcsU8P9tq73e5Z+mS/U/ovVmp/QT9RfV/lwrUqBjZsmU1S7L6Mky7iQkmrl3cwSQLCkRW9+ExQF55hJfsRLbuREaQc4ivzr00P9m7e2CKJnM3h3jKPpo7pf9srrV9siMwX1v6Q1/2eI7+yXAgZs2pxx6mlMzwIq+FQWRirlqRyzHcy8NGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hm4elB0ZF40BIn9+Ew14R6RNIhWIMR92UZDNVDnbaOk=;
 b=0rWR7ZhK9VnZ3znUujNrQJSX4rl3SmTd1qhwXK+OofRH0uy3XDycQRWIR8PXwNeoXonZBugOJEEoCK+Wg1Tys+CwT5wdvu754/tH5/N8jsDKTny67Lxf/RRpdkq4zxecpDBgtJ55M+nPCEieSNCxF0Dc5gzBS2+6MjbrCN4uvvw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5399.namprd12.prod.outlook.com (2603:10b6:8:34::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.16; Thu, 25 May 2023 14:41:27 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::67e:11bb:a322:98e1]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::67e:11bb:a322:98e1%4]) with mapi id 15.20.6433.013; Thu, 25 May 2023
 14:41:27 +0000
Message-ID: <62beadfd-9de1-9fa8-f62f-b8eb8cf355b8@amd.com>
Date: Thu, 25 May 2023 09:41:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 net] amd-xgbe: fix the false linkup in xgbe_phy_status
To: Raju Rangoju <Raju.Rangoju@amd.com>, netdev@vger.kernel.org
Cc: Sudheesh Mavila <sudheesh.mavila@amd.com>,
 Simon Horman <simon.horman@corigine.com>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
References: <20230525101728.863971-1-Raju.Rangoju@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230525101728.863971-1-Raju.Rangoju@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0150.namprd03.prod.outlook.com
 (2603:10b6:408:fe::35) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DM8PR12MB5399:EE_
X-MS-Office365-Filtering-Correlation-Id: 18fe6a13-ee40-4761-65c9-08db5d2e1e43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RPr/rEd3FMXBLY3xiFYddl9rC9nV8hgegZF2mrnG4b9u2XuY1aKeDoQxzNBt8nxbrZeggAGGP9yil8q6Ky4IndcJiq/YFw2Fo9tXvCx0Xz14Wf0hAvvf5wmdTjERUMIdbccC6i4IK8cd8gjPmjH0jyfFf0eFAyCm0+wPPRlsKyzIb6FGP/6QHM2UbPTjGhCjiGKKtqvnmyPvYj+rt81eaDtNptc1bua5YQxr0Pr8AeYfEPamDNsGVovI/V/ONqytFYAH6sWNSsR1ATarTCznpZUr+o3umzNCC0O2OH0APCAIa1MF+P+Y+H7uCvsHu6ggN9u/gY/28ubsjB8807DN5RV/VC3jPlq91vRUs6TzXynsoGcrVuQ6owDHJ1aUXP1PWo6PMEi51prQy3bO07Av/cOQoZDBdVZw+4EEvXEdvQ9ePkf9hlja2E5CqHlUXcthgCph6i+VADsfyjPBqvkfECFKuIYdvO2HdTnlQJxLB/SmwviwsBmob5CkxS+AtFCFa7RtBQP1g1vFyqaL0dcirMmm8dWJfqyk0+PpLvX04MXqvRxoaj/Pqz0hwHRfCwQqK9uNnopx1vlFj4HyFCWmAeILcyIyJndGoQ+q16DRGMYPolNpKtsFSgbPY4R9RHjP+yznqHVN5OsEeLIPTlDxUA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199021)(6666004)(6486002)(41300700001)(26005)(6506007)(6512007)(8676002)(8936002)(38100700002)(5660300002)(53546011)(36756003)(2616005)(31696002)(83380400001)(2906002)(186003)(86362001)(4326008)(66946007)(66556008)(31686004)(66476007)(54906003)(478600001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEsreFozWEgvWHpxV1NWbTdzY3I5dVdIMFZub2JYNUNsYU9paCtUS1JSZHVn?=
 =?utf-8?B?SDVHN1hTSUhlK3pQSUd3bHRvQlR2aGRuMDV3eUhlR1BZVEFjeVJSNEFZZjNy?=
 =?utf-8?B?amkvZ0F0V2ZmZDNza2xLWHJwVS9JU2tnVldSVGZDYi9FWXVXOHhrdDlrYzVU?=
 =?utf-8?B?TWc4T2dKSTA4R051NnJHM1gvQlp4Q1RxamxSWDhlMytZQTF6ejBYWExCbDVh?=
 =?utf-8?B?ell2RFdBcFNNdThvN2VjaWZ2RXUrRFY0NGJtWkRWc3dkeitRcE5NM3cwazBl?=
 =?utf-8?B?RCt1bHpDMlNGNVBaaVk4dUJnM3k4UngrWGFtVnNsNnQrUE5CSERBWEF0em52?=
 =?utf-8?B?Vm1TZlhkZVNGVkJHTWRFOFFSeDFPK3duVzM1VWp4U205anNYNFRlQVk4YlZ4?=
 =?utf-8?B?akVEK2puS0RJYXBkZ0tja3FSVXk5MnFSdGlYN3kvbmpBSVQzRnA5QUN4TkIr?=
 =?utf-8?B?K2QxWHZhOUswWmFFbmwwNkF4NGk2WmFpRXByYzVmcHliK0Zsd1BlaTl4M3Bw?=
 =?utf-8?B?SDQ1Y1JoTnV6bllnL0diODZhSjdDbWVlbnpLZGxXYis5VmxHNDZ6WEJZaVU3?=
 =?utf-8?B?RzhoNHA4MjdKcWZjUi9tSEFXQnVONHFNY3BtcDZKZUpiUHlQN1JsOEpHODNm?=
 =?utf-8?B?akhkUC9nQlhoaGRqVmpQRGhWR1hoVkNmaWVBVkY0d3N4UDhSS2RTTXJ6TzBC?=
 =?utf-8?B?azQ5a2JYeXBmbytUSzJFUGgwMjZBWnk2aHpmYlh0c1pqQTRFQXRGWWF1bHVq?=
 =?utf-8?B?SlRBTStmYjF2cmRkUi83YVhTVE44S293SEpKTGVWK1AyWm1uQzU0SG0zUUV4?=
 =?utf-8?B?WWlZYW1UR0dZVmRzSUM5U0FMOHRFYnoyVVRlRy9PY01qYU95MTJpRFdkMFAx?=
 =?utf-8?B?M0RsUFgydTh6R2VrRERpQ3h1QlV3eFJvdlNpVnR0WnVWNCsrd0dqay94TFBJ?=
 =?utf-8?B?QjIxUEd3djRDaHExNzE5elNqZDRZam4wQ3FKc3kzTWdBUGM3ekl3NjhmalBv?=
 =?utf-8?B?Um1vblZod2MzMWtKWmdNSkszNURVNTZkUkl2TFpmeU5wbE9MUkcyNjNZckxS?=
 =?utf-8?B?VWlyOVZlbS96STMyTjRaQ3ljWlV4Z0NSaEIvZm5hM1R2QUE2V0F2NndyRjF1?=
 =?utf-8?B?RStwMS9wdkNPZ3NqSnNRMXRlUkl6S0JyaC9saThKTklPL0xlRjdhNEVWRW5M?=
 =?utf-8?B?aFBRVWpxUStIU2o4V2x6L3V6VzQ2alRmYmk5T2RCcDBhb08vdHFIWmh5RG92?=
 =?utf-8?B?ZW9pWkszMC9ucHdlcVJSMlU5UTF3YWhiMjBFTUtUVkdUY1RqV3k4b2ZQdmJC?=
 =?utf-8?B?SnB0eVpZb2FnMTJHdTVmS2h2dFdOTVNyQk9McWoyZnVkMGdBcDR6ekw5Z3Z2?=
 =?utf-8?B?SHZrSFgyTjBWNmVZaE5RQ3BSYVRBMU9XbkJMR2Qwc3ZtanhHOFE4RElXb2k2?=
 =?utf-8?B?eVNaMmNRSHEvbVFnRkhFY1dWcDBJLytkemJGVm15US95VDl5TEFmNmsxM21K?=
 =?utf-8?B?bjlycHNhbkk0N1VseXpzV0lmRndjWkpZN1prSE5ET0d2alVQWTFVMmlvZTJi?=
 =?utf-8?B?Qy82VFp6c2xaL2wyaHlXWTRGdEFHaXd3U0hQWVB5RWVyRCtac09rK2JUelZ5?=
 =?utf-8?B?a0VoV2MySUJQTDVDWnJ1Zk5XMTN2YXIxV2ZjODJLVlVWa0xnbDJEZllqNk56?=
 =?utf-8?B?YzJETjNOK04rT2VKeEpWVXhvZWFHV1ZxY3JSR2daRmhjMGVpTFZaT0tpZzdT?=
 =?utf-8?B?TDdRa095ZjNYcmtnN3ZQcm41WmkwYzhyenBpRVpqV2RQbVQxTkEyLzZiaENV?=
 =?utf-8?B?QnA1WmNRYVVsbU0ybU9CODRPZmVpWjZwZTFwNzJaWEVsd0VQMDVJTThNMm5s?=
 =?utf-8?B?K20vLzhIUzkvT2RzUmxJN0ludm1IdVpBZnMxS1hPVGcwbm1TSlk1QU9MRjla?=
 =?utf-8?B?dnhrVDM2WTNSVzJqalNpNnhXTVNycUdEbzNDRkZzTUFxaHVzUE1OZDNrbyto?=
 =?utf-8?B?Ti9LRUd0NG5RV0pYOVhUMWVkZnBjR3d3RkpDV2xOTDVLUVZKNTVtSXdQSGV0?=
 =?utf-8?B?Y1NEYjdMUmdHWTVGMVk4aHBZQXhUVzE3ajEvL3JlejE0S2pNRDBCOGJlL0NC?=
 =?utf-8?Q?gxjVvG9Qp+CSZbt6u0jgTOE3m?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18fe6a13-ee40-4761-65c9-08db5d2e1e43
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 14:41:26.8671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /vhe07b4fXod6lDPQKKuYamFRxnglucIcCUwZXfVgNwrORh5D+l+/l570tT/yr6ZWViTTiBdRrE7U4bd96o4oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5399
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/25/23 05:17, Raju Rangoju wrote:
> In the event of a change in XGBE mode, the current auto-negotiation
> needs to be reset and the AN cycle needs to be re-triggerred. However,
> the current code ignores the return value of xgbe_set_mode(), leading to
> false information as the link is declared without checking the status
> register.
> 
> Fix this by propagating the mode switch status information to
> xgbe_phy_status().
> 
> Fixes: e57f7a3feaef ("amd-xgbe: Prepare for working with more than one type of phy")
> Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> ---
> Changes since v1:
> - Fixed the warning "1 blamed authors not CCed"
> - Fixed spelling mistake
> 
>   drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
> index 33a9574e9e04..9822648747b7 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
> @@ -1329,7 +1329,7 @@ static enum xgbe_mode xgbe_phy_status_aneg(struct xgbe_prv_data *pdata)
>   	return pdata->phy_if.phy_impl.an_outcome(pdata);
>   }
>   
> -static void xgbe_phy_status_result(struct xgbe_prv_data *pdata)
> +static bool xgbe_phy_status_result(struct xgbe_prv_data *pdata)
>   {
>   	struct ethtool_link_ksettings *lks = &pdata->phy.lks;
>   	enum xgbe_mode mode;
> @@ -1367,8 +1367,13 @@ static void xgbe_phy_status_result(struct xgbe_prv_data *pdata)
>   
>   	pdata->phy.duplex = DUPLEX_FULL;
>   
> -	if (xgbe_set_mode(pdata, mode) && pdata->an_again)
> -		xgbe_phy_reconfig_aneg(pdata);
> +	if (xgbe_set_mode(pdata, mode)) {
> +		if (pdata->an_again)
> +			xgbe_phy_reconfig_aneg(pdata);
> +		return true;
> +	}
> +
> +	return false;

Just a nit (and only my opinion) for better code readability, but you can 
save some indentation and make this a bit cleaner by doing:

	if (!xgbe_set_mode(pdata, mode))
		return false;

	if (pdata->an_again)
		xgbe_phy_reconfig_aneg(pdata);

	return true;

Thanks,
Tom

>   }
>   
>   static void xgbe_phy_status(struct xgbe_prv_data *pdata)
> @@ -1398,7 +1403,8 @@ static void xgbe_phy_status(struct xgbe_prv_data *pdata)
>   			return;
>   		}
>   
> -		xgbe_phy_status_result(pdata);
> +		if (xgbe_phy_status_result(pdata))
> +			return;
>   
>   		if (test_bit(XGBE_LINK_INIT, &pdata->dev_state))
>   			clear_bit(XGBE_LINK_INIT, &pdata->dev_state);

