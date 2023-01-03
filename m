Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8576465C43F
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 17:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbjACQxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 11:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238293AbjACQwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 11:52:09 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2058.outbound.protection.outlook.com [40.107.101.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEF412D3A;
        Tue,  3 Jan 2023 08:51:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RmUz6niUoKJOOxaK/cV2acnEoheslGX1KIYcD0ZeLMamWx/3OhWYBC1n8GC4EID7U7fpfOqD/copu8oUqeczExP16s6W1G1V4avhp+1RxnNXtO83lURU/FxILKjq+HepcCcCPQw1Iu9JRfAxWOJcSUj/7CditL5WXq0RovcsyKDGLJLCHGqhZtIuCDE141X+CL24X8U+q77WE3aTEx3U/sEqtsNXp95twHNKeBqKAZx1cnxMRMz9ItCxp7uVI6tBhI0iwZgWXbHZihnpNs8o6EVPz7GvgX2iibm2SuejjHMSKObMyuQK1EIc+Z4muUFi8m9RawOFv3nihQD3hueEIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L6RCz9oLBdpVNPGBdTs9FvQ5P+wqNEIrvtYzLy7XGc8=;
 b=BkgNkxHIj14HZCK6tiLWGHQsCnePUzb0sCcuI3XHRIlf/iVpI8IAj0236j4YdwrznHLY306SyEsWWokSgg2bZobH+uL9CowQgokAkttDML3MZBvEz/4h70Yx25BuqnQ0TUKoknCR1mSEgB1njMFWuWIOiWL/VY+6Q8iM4Zm3CjIEIwTktW+p6BMf8BoCsLTHjOcTaE9kfJAI0ZdYfE7lXkGFbTmkiWwgNoSjR8QBTS+ARTS6SkWl25i3Cb2NS6+IEonf6OvvgYLHMJFZiQt576AQu/l4+b/1kZ49kA64wPB73MxeqAKh1i48R9+bZzvq0HmdviIRLdCjBskBm7XETA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6RCz9oLBdpVNPGBdTs9FvQ5P+wqNEIrvtYzLy7XGc8=;
 b=zPPq862xJq2qXzm/82Am8lXTHz0NKJeO7N4AaFj+98JBWAPKRYnPyfFMUn0nJorltlL5wo1p2N0FPhMXAcVn2+X8OV29w1Vhuvh67YfqUTJK45f/SvN1CwIE0QnxM4Xrp9U2vR6thfcdPupxHeQFLAD7O/FWS65Pk2tII4RRVwU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH3PR12MB7571.namprd12.prod.outlook.com (2603:10b6:610:147::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 16:51:20 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%3]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 16:51:20 +0000
Message-ID: <1efe8317-ef7c-f636-71bc-02ceb28cf0fd@amd.com>
Date:   Tue, 3 Jan 2023 10:51:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] net: amd-xgbe: add missed tasklet_kill
Content-Language: en-US
To:     jiguang.xiao@windriver.com, Shyam-sundar.S-k@amd.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Prashant.Chikhalkar@windriver.com,
        zhaolong.zhang@windriver.com, Rick.Ilowite@windriver.com
References: <20221228081447.3400369-1-jiguang.xiao@windriver.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221228081447.3400369-1-jiguang.xiao@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:610:b3::7) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CH3PR12MB7571:EE_
X-MS-Office365-Filtering-Correlation-Id: 66b4caee-b2f3-4df2-fa4e-08daedaabd1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XB2yxyM8ObAkPcXzsKxFKCnb0J4eJxELYelM0AHOWc8Mju/8mnQQNESdFQuAz+RbgzxbbMg9Cj7NCCv2SKIt8oBWYTMQwUF55oPnGtlFYHTj0UyCRtN7eC0uaM9pujPkG+BmA+qmloCzDWJ6553dmAOrQYi+T1xNsWes01fVUFsJS8j495lLeZViKWUxSkHz5k8RF7V8eSOXBv9j/IGo8Dt3f/gWtAkC6noO8khkh7DMTzVxCa6s92F5xw597hwAlbd90CmA4qBYDpduCMMiiCmPm2zj1lb6brByxH+vN1LZvLud4au+Nago1y4S7gj9lorVF966b50RapG2/1ai2rAtQCwP/tGZAZ5CgWQs8u10SF4EgbGOS0jZS1bXKd1domFdAOMbwNkmbHM1Vu3S6stlKx/Cm5c46XOm2+BOw8PiEW2NosnPSfAxYga7anFl94LzmKFSSxkRxtzFUa9Ne5pU8+q4ugWVC/xiPcgBrDK+NZgDK/DOggm6Rx6YtPQ4ztvcLNMlPIy3rK5LQYPnAjnJIQVP4doeufTzKSd75aSih1QQXutGcWIhW782XR1b1CGoUumbaLAjUdn74v9Z/pOpGm2xksJx/IAIikh+Zx/MwVtyVSC6y/CaRANbKWbQw7h0byVSt2Hya9KUN+ZQAM+QT4puT6TEAlArI1RunHhAZNmPLcoeKD0/Mmh1wO8/Fm9ZzUG7ygqF74SxMIxGMtciK71Qpe1+sHEv2GAAY7RvntIbcejGvv1+wQR1XQjTQ2QyBo4XIgW1bQF2xliVnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199015)(83380400001)(2616005)(86362001)(31696002)(38100700002)(36756003)(316002)(5660300002)(2906002)(6636002)(8936002)(4326008)(41300700001)(7416002)(31686004)(66556008)(8676002)(66946007)(66476007)(53546011)(186003)(26005)(6512007)(6486002)(478600001)(6666004)(6506007)(22166006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkM4TWZzM3o5TEdCNzVLZnJjQmtTREJWZHVPM1EyL1AvSTgrZFNpZUw5K1ps?=
 =?utf-8?B?TzdiSlUrUzhvemFMdms0eU03d1dkZ2t1d2hVVGp1SW9sZGUxQkFGMUg2S2cr?=
 =?utf-8?B?TDN3VEMzTG1rMjNpaUIyWHdmb0xNbmxqY2xVU3NzdXFoSVFTa01QNEFVYWhE?=
 =?utf-8?B?bnJ3R2N4cDFjZ1BXV1RiZWpKcVVHUE15Z0R6OEdONlZQVnJ1M2o0d1hDK1dU?=
 =?utf-8?B?ZDNTdEhjOVQwSCtPMERUR2lqZDV3ZFFCSmdjd0JjTDBmdEg5TmpudTJCQUt6?=
 =?utf-8?B?RHJDVHBGQWhOT3ZNNFJZay9obXd1VkJ5bTl6ejZ6Q2RsZDFEb3F5YnhMSzNZ?=
 =?utf-8?B?R2FYU2lsYkVHQU0xcm8yMmxlSFFIdHU4TTZ0aTNldnBFcklUdFZmNm9VQmRC?=
 =?utf-8?B?aFlmUUlMd0NyNHFvOE1jU3N6b21FSkVRZTlpQWRUd2dLWVRzMGlYK3FFcE9Y?=
 =?utf-8?B?SnVrcHB1RnNPcVgwMVlJRnZ5TlFWT0xGUmU2ZkdJZjk4dWlRNmk0c3hvbUxh?=
 =?utf-8?B?cHZrOHdLZ2YvK0h4OS83bEVSZkIybTdZL05kUDRtQW9NaDdKU1QySEt5b3B2?=
 =?utf-8?B?QmNNNTdGYUIxZ3JQcEQvZ1JUazlGNUN1cjRHbHdtTURwaGU0RDN0dzFxbldI?=
 =?utf-8?B?RUFkTmRpenNSZXZmL2I5WGtKWGkzdmlTbzdsaGEvVkNWMHNCQVBaYnpLYnFW?=
 =?utf-8?B?c1grQjZFYlRhS08yajlEakRjTlpuTXZoVzRrNGdiS001OEdod3lFajdmeWhZ?=
 =?utf-8?B?WEJqR3RibXJqZFdGM3pxRndUMTdWd1I5bHg5RitlY1V0KzBIUEdocEhVNmQy?=
 =?utf-8?B?d2wzMjQwOWtyZXhpT25jcjdKWlRwc2JKVFRQdzE2dzR5RGZYWnJES2Z4Q1dv?=
 =?utf-8?B?bHRWSUtHM0pwaU81UHg2TmF3YS9yWGd5aThyN21LdFpPTTRtT3F3M2hoZWQ2?=
 =?utf-8?B?dFdodUJlelgwYi9hMVVibGxCVUJIbk5sSDhjNlF1dnlrYU9vQ1hocnNvdDJs?=
 =?utf-8?B?NS9NbnBPNllDZXlHTDA3eVdhdklvY3N3dXMvT0laQzR4OFpWcFFSMzAvWFhN?=
 =?utf-8?B?RUEvSnlyanZ6ellPYXFpUGtTRndXYUVNbWxGL3dyQkZRWCtmSHRGTTYwVVZz?=
 =?utf-8?B?cFAxc0Z2VnZxeEFQeDhJV3VrNk9KQnh4MDdOeDhwTTZ5SVpyM1BRWVA1ZUJD?=
 =?utf-8?B?dVdoTjNhZi9vYjQ1QThnSFpFMElOK2pjeXhWaGx1TnAzdCtGaUVJTGdQVTRC?=
 =?utf-8?B?UzVqN2lNVHJOV0dvOHdCRUdLdzFqY2Rna3Y5ZkNZMklNRkhFNzVXRWt0NnEw?=
 =?utf-8?B?enFSQlp0dGJrTXNZTGJLbDFwcUhjL3ZpaUM4c25aWHJHZi9YRWpvdXN0OU1m?=
 =?utf-8?B?V1NOd01pdUxVUzN0akQwd0kwOFFqY2Y5R0d5UlUzVXlwQSthOEdRTThNZ3Zy?=
 =?utf-8?B?cFRWMlA1TEdGNEJFU1l2QTlRSjNtNlFKWDY0MTNyVzhxbU9BemFlNFBjVEhW?=
 =?utf-8?B?L0htM09IalZmemFzVUdXVlJqdUNvS3dxT3RUMWZwaVJyRU8xU1BtZ1FMM1Fk?=
 =?utf-8?B?Rm5vbVhyeUM3TzhkSjQxc2NBWmJkeTZCcE5zb2dubFB0a2ZLL1J0d3p0S0Js?=
 =?utf-8?B?NWcyUlJnYVNyQmUvZHVMeG5PNG55VDg2bDFoS1hsOEpDVTlOanlyUDV3elBs?=
 =?utf-8?B?UVVRR2ZoYVhMa3VKNHNWbWRLUFhOYUJ1Yzc2QzdiZytJRzJNQVp4OXZzZ1Iz?=
 =?utf-8?B?OHFKRlZNVit2d0wrM2JKalhjTVpyNTN3c1d5bW9DSmtxRDZETitvMTN4TU9v?=
 =?utf-8?B?UnhtajQ4a0dvdXNCUzI2Y1h6Zm91eG16dWFBZWtjTjdwRE9lV2lqTzZXNDF2?=
 =?utf-8?B?MU9pSFVXMCtVbTZETTVwcGN6bEc1WVNmV2cvOWtEZDhoM1hkbWVZWTB4emZr?=
 =?utf-8?B?cDhsbGw5WDRYUUdyRzltZUR6aGMrWU1SeHZrRDFHRytiQWMwTmNDZVlmY1Fr?=
 =?utf-8?B?bkt0emRsOWNMYVNjeGVTMUkrQ3ZKVGpRM0sxdVA2bjV2U1ROdDlwaDQ4SGtL?=
 =?utf-8?B?VGFYc051Ylo1ZHl4bUdCc1g2U3pQWC91WmlaMkc3TlI0ZHNmQU1ubjlob0Iy?=
 =?utf-8?Q?/AwbI7pHjpdZqeQjGZ+G35bnO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b4caee-b2f3-4df2-fa4e-08daedaabd1d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 16:51:20.1146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PhLL6Q+MFkrELhkHsIH+oILPyW8EQFcEaGiBOujkDtX5qxoxbE0LSRQyT1Rn6eAdpzjKwRpnX6lEHr8FXPFHlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7571
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/28/22 02:14, jiguang.xiao@windriver.com wrote:
> From: Jiguang Xiao <jiguang.xiao@windriver.com>
> 
> The driver does not call tasklet_kill in several places.
> Add the calls to fix it.
> 
> Fixes: 85b85c853401 (amd-xgbe: Re-issue interrupt if interrupt status
> not cleared)
> Signed-off-by: Jiguang Xiao <jiguang.xiao@windriver.com>
> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 3 +++
>   drivers/net/ethernet/amd/xgbe/xgbe-i2c.c  | 4 +++-
>   drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 4 +++-
>   3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> index 7b666106feee..614c0278419b 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
> @@ -1064,6 +1064,9 @@ static void xgbe_free_irqs(struct xgbe_prv_data *pdata)
>   
>   	devm_free_irq(pdata->dev, pdata->dev_irq, pdata);
>   
> +	tasklet_kill(&pdata->tasklet_dev);
> +	tasklet_kill(&pdata->tasklet_ecc);

Should this tasklet_kill() have been put after the devm_free_irq() for the 
ecc_irq?

Maybe both tasklet_kill() calls could have been moved down a few lines.

Thanks,
Tom

> +
>   	if (pdata->vdata->ecc_support && (pdata->dev_irq != pdata->ecc_irq))
>   		devm_free_irq(pdata->dev, pdata->ecc_irq, pdata);
>   
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
> index 22d4fc547a0a..a9ccc4258ee5 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
> @@ -447,8 +447,10 @@ static void xgbe_i2c_stop(struct xgbe_prv_data *pdata)
>   	xgbe_i2c_disable(pdata);
>   	xgbe_i2c_clear_all_interrupts(pdata);
>   
> -	if (pdata->dev_irq != pdata->i2c_irq)
> +	if (pdata->dev_irq != pdata->i2c_irq) {
>   		devm_free_irq(pdata->dev, pdata->i2c_irq, pdata);
> +		tasklet_kill(&pdata->tasklet_i2c);
> +	}
>   }
>   
>   static int xgbe_i2c_start(struct xgbe_prv_data *pdata)
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
> index 4e97b4869522..0c5c1b155683 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
> @@ -1390,8 +1390,10 @@ static void xgbe_phy_stop(struct xgbe_prv_data *pdata)
>   	/* Disable auto-negotiation */
>   	xgbe_an_disable_all(pdata);
>   
> -	if (pdata->dev_irq != pdata->an_irq)
> +	if (pdata->dev_irq != pdata->an_irq) {
>   		devm_free_irq(pdata->dev, pdata->an_irq, pdata);
> +		tasklet_kill(&pdata->tasklet_an);
> +	}
>   
>   	pdata->phy_if.phy_impl.stop(pdata);
>   
