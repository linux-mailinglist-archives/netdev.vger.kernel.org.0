Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7695F69A3
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 16:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiJFOcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 10:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiJFOcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 10:32:41 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2082.outbound.protection.outlook.com [40.107.100.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C1583F0B
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 07:32:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjNgaxBx0EFIJczLevmWmKHNBv6yFk4ufkGi1GX+mqNYGq5LyJ5kx2im/iWqILYt0TxFsaSKVfP1IentJzMlAcHSIu3f+UmYTMj3HHcKfH6W60tC1tqepiwKBxr5oVPHNIsQHtsILQevVqUrSFBNSX/tyirMYmjT9LyFXe31BDflO8gaVHkhv2bNPEyJ0ENDyEZ1aVnwIpkxsy4e8aVcBsM0HVu7Z0VFzj69bdwazMNBcBc5P+iXkMBVPRJVgCnxuAMgo5nUV3R4W40AVFPCoY6FWCOMFABJJQ3w1RCVXctwmAeOGGyIIu7kqJuMI/1aikb4S2ubH2IGUOgHl2J9Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WdNWjp9j6uhvjS8P2HHT0emahu4lOi+QvObKxQ58Gek=;
 b=SElxyqgh+G0y0K/UCg/3AtHD+7gELQ1ePGX4z3pKiX/MrKnTBMSh0UCBwxi6l79OxV3MD0BxYRcnaTUywZNCGLjXcrVFtmuDGWbEyZXc904/v1BHWT+ZdT2dvPeLU3MHshoKzBeMrFbbTC7ywmRQjpSx17U1YBwdLOrp69mSAN2z2paeSQPaNdEoJOA7M0aTR1bk+Wgbo/PvWH+9XVghH8vev8bTrr19L/C5555YzFq/6HVW8dV/tghqj2itneo4DFkklTQk6f560AIv9/5eShuUabEukThelk5/pJPLFwQOE3Vcnq0lwduxNN0eKlZ4sQN3TkbwephTtC5z8qku7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdNWjp9j6uhvjS8P2HHT0emahu4lOi+QvObKxQ58Gek=;
 b=h5NDLu4JSRdRZxfkpS1+16Bmxx2sZDbBG3/Rz/jytdnCS4qVlAZtLKxP1zwx4SiLzK1JAVUVmCBu4+LIeRXHdJxKPCjvQchAePJ7Gwu2NAKEj2h5EhqTF42OcHao+H8ooK4REHEQg9jHQEtcMLYSDTPqvhxBUJLbm66ewIEtl6A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SN7PR12MB6888.namprd12.prod.outlook.com (2603:10b6:806:260::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Thu, 6 Oct
 2022 14:32:37 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396%4]) with mapi id 15.20.5676.036; Thu, 6 Oct 2022
 14:32:37 +0000
Message-ID: <7a1b3750-1b3d-a9b9-ebba-3258c90fff7e@amd.com>
Date:   Thu, 6 Oct 2022 09:32:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net 1/3] amd-xgbe: Yellow carp devices do not need rrc
To:     Raju Rangoju <Raju.Rangoju@amd.com>, Shyam-sundar.S-k@amd.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, rrangoju@amd.com
References: <20221006135440.3680563-1-Raju.Rangoju@amd.com>
 <20221006135440.3680563-2-Raju.Rangoju@amd.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221006135440.3680563-2-Raju.Rangoju@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR22CA0012.namprd22.prod.outlook.com
 (2603:10b6:208:238::17) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SN7PR12MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: 762a816b-eed9-4e5f-6dea-08daa7a79d7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2VfqgNG5C1pGVPPmiPUxicKK4qR1gNUL0r/PBu46J5B/2JaoupUNXoiUe/9SQSuKz1wTp+OQxi7ziKWQI5bj64TBhaMpSW4y9QXmJY9nkHHfeUCfSq0k3jqk1zW9dljx+hfi1XYQp1rh1BklfcPZooN+vPJlIbEfOmR6QTTW0jpTlY/72BJK/zCh5VCh5Fy4vb80tcWQmbVnOIwv+z3w58xO8ERDRTMGJmrvPKewXLRg5GA0Fu4/vPDH5bzS2EshAW3EmLkgRwFuQMiafA5osV9uqKiWW+PWOXMlWZ2kUdwr3PDE9oVCLPAbr5arG3mtcRVVWIMESdi98D/FdFC9GjYY4U20a89qW1w8W/DSvj4aNb3h7swaPHlqLoFzYNze0etKpluf0+R9cKdEs6M0L3Ju3080CILlIVn6pMHS5gPHuqlVkeSO2nBxpptRq1g1TZz45NbVk4bP9amXM1aclKu6Jr8qdLp4pEUJT6FRp8O6bfos37OCvT1PGFHemxJtq491P8G4RbTYewXNK6fmpTAq++y8AI5J5shc84e2kzhFKrKddbBBc3WQ0Fpk+n6wMfyy3or2Cs7i44/KhKuCuaYSU0YR6/6c+FTd9Q6xFhW7UH3z9WqeU6wXAOzv4mnCDXrOzJk3SQU1/OiP05+hvRXOiATfTxTbG7G97sQ9M+dwyFeWYh1B6oQ9Y04NTTKCPgpI1Xw/j9EDJxyHRGFCipwbMWYkItAcQmf/dogYMd0O+OIWZBUh3hBftoNkQL5xPk6T5MzgKjz/ZKIrwiYrk2Vif8AkjML80AVVhtyz5ao=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199015)(83380400001)(4326008)(8676002)(66556008)(66476007)(186003)(86362001)(6506007)(66946007)(31696002)(6486002)(6666004)(36756003)(53546011)(2616005)(41300700001)(2906002)(31686004)(38100700002)(478600001)(316002)(5660300002)(26005)(6512007)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTlraHJSclNYZUx1NFFzSnkyQ2V3K1JzNmREVXczaTZmU0RZd1hFdFFWUlpQ?=
 =?utf-8?B?bERTYmFWdkxpNVF5clM2MUs1MWk0MDhUZXFWdDhyYlFET2tuZjFsK21ocU9q?=
 =?utf-8?B?N2FXNUVoZFRTVFl3NDRpQS9iQjNCRWo4RVM0TFdaQXFFRHlNc2xBNEVFWVBl?=
 =?utf-8?B?L2c0ZWtYSDliMlpOREVEajg3ZzFCZVFTdndqT0hVMkNOQ25zc1Fuc0tNT1VS?=
 =?utf-8?B?blNlRWl6dG51SllWZ1F4Sy9XTEx0NDNTbnV4NGtqaDVVbXo4VVRNQXRvMFVT?=
 =?utf-8?B?bW5QdjhmNm4yaEVmcGVvOXlSSkxWMm9QOC9tVWJtdWNTVXdTK0NkU0pFVlpW?=
 =?utf-8?B?b0U3SHhOdnBzVm5YRjc4ZmhkbUpMNEE4RHM4VmF0RDNiUVM0cEd4SnN1Nzhl?=
 =?utf-8?B?ZE9LM1JveG1keUtOMytTbGJyMGtqN0p5ZlRPaG13NHNJMFJPZ2d0NmZyU2ZM?=
 =?utf-8?B?b05pWStyYzZOWVNReFhLNGR5Qld2cHhJSzl5aGNDY1F0ekl4YUhXeVQwT0dv?=
 =?utf-8?B?MnUwL0JWQ20zOUpzeHh0c2NUNHBSUU16Zmk0cExsd0VpZ21uRlBvQ1o1ZXVL?=
 =?utf-8?B?ZGNtTThTQnM4cFM1dTRBWEhVU0ZjOVRoeEJEMGdKdEc5bFN4L1prT2RrQUxv?=
 =?utf-8?B?RkZONlNrU3RpUXRlWDFZUU80cmRTV0JlZ2U1a3JkUFhzYXFlaWljcEgwQTRx?=
 =?utf-8?B?RnU2OEpSeDVTeWQ2VlBwbWZBRCtqSTJyQzZZSlF6MU1ZeE9nZmV0cmdBbmxQ?=
 =?utf-8?B?R202SnAzbE9JS3dkZnFTUFBvZHRIWGlUT2xyNld2bHBZdG5RcmV0MWhFYXNL?=
 =?utf-8?B?VWgvSTQyWkplNERZNlJlZk1BQk95b0xmajR2aUErVHEwNUN3a3RzMW9oRVBC?=
 =?utf-8?B?alp5czh4bllEZzd2WjVJQnByOU4vSTFySTFyVEpxaGpvdTU1dHJkbzdGaGtV?=
 =?utf-8?B?U0taS0prMVlBV2I3ZmlHc1N5RHdFeS8xYy9lRVZlK3Y0L2JUR1FvWTZmNTBs?=
 =?utf-8?B?d1VTOGthSHVsV1N3Q2l5Y2RZQkdpSEdKUVdnbWsrVkFwNGZxZGVHWFBhT3lW?=
 =?utf-8?B?UDVSV09PV0ZhL2hHbEUwU280NmpwR0xHeUN6SDBaQjM0OXN6a2t1MUNUdjRM?=
 =?utf-8?B?eXcva2xZYVZSNG5qbnBLUUFPNUZMbGFraUJUM3puaTZrVk1HK0Qya3VyOHE0?=
 =?utf-8?B?ZGpRWGVFVktBby9Ma3VxWktRUVB1cUdSdzlubUlRcE1uSnlYTnFScUVMcFk1?=
 =?utf-8?B?dlZzU09HakZNUklraEw3ejBMQWErMWgwcEY4d1lQMklEZTd3ZUQ1bDFWVVZO?=
 =?utf-8?B?aFUwSEZaZTlaTVFsM3RxYVNINWlkaEFDejR3Rjkya0Y0T04wTUJpa042cisv?=
 =?utf-8?B?OWNqVFZRNll6VE8rQmZQenlKb2RBc2xFVXJmRlZoMERZSjN5M0xHYkxrTjNl?=
 =?utf-8?B?LzRzT094aWVXbHZQa21WbDZSR2R5RVBqbEdxaHovRVpMdkt2R3JEbDYxMHRY?=
 =?utf-8?B?SElDNVdkZzhqMmhmQllHSEtVSGtiMHp0dmF5dnBXakUxRytFbWN2K2s4WVI0?=
 =?utf-8?B?c3ZQTTV2OHBRNGJ6M2FVc0dpQUVlSU9udm9ETk5lZmc3UjQwMlFtK1JUUkg5?=
 =?utf-8?B?UlhjeFVTVE00SWVCTUlDb1M4YnU4U2lNVmJnVnQ2bG5qcHBhQkk2c3dSQ3cw?=
 =?utf-8?B?RkVsTTVMNGJWM2dmQys2S2x6TVZObjJvcEo5UENmZzVzaTdCTjlUckxHSysw?=
 =?utf-8?B?eG1kKzZiWm5jMTA2Q1AwRmlkelQwSTRQQlBmK2xEZHRpamd6Z3Z6clFNRVd4?=
 =?utf-8?B?ZDV0blV2Z1VqWXE3eDh3eStkeVB0Y1YybEVBZ0doOEFoc1Bya2RNM3RlWWsz?=
 =?utf-8?B?ek1vSXFjZXBxN1c1azR1Qks2TVlDMUV5K1F0M2ZHWklYWHBWTnlZYWh3clZ5?=
 =?utf-8?B?dmU5NnpJUm51OVdwNzBVRUtqYS9rQ1JIbXY1c01MYkxUaHNtb0F2QXIralV6?=
 =?utf-8?B?WkxYdUhmdkpUL25DUms1MFJWN2g3SVVxQ2JvSkNsbmpjNkE2WGhLWFlmYjNJ?=
 =?utf-8?B?QVVjRXJLUExqakNObm5uZlBOQ1psZVV3N1ZwTGhMbk84WlByVnBmSktzdTVq?=
 =?utf-8?Q?5CbQWVyI63HTB+NRSSYKNud/0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 762a816b-eed9-4e5f-6dea-08daa7a79d7f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 14:32:37.2128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5bg1pAm//cPkbuRiVlr0sxcOrssYcWdBdIPxFETBvfSxxtLqyCBBDqxMEt+pL63/Iy1BAZWcilttPMt9N7jITQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6888
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/22 08:54, Raju Rangoju wrote:
> Yellow carp devices disables the CDR workaround path,
> receiver reset cycle is not needed in such cases.
> Hence, avoid issuing rrc on Yellow carp platforms.
> 
> Fixes: 47f164deab22 ("amd-xgbe: Add PCI device support")

That is the wrong Fixes: tag. Yellow Carp support was added with commit

dbb6c58b5a61 ("net: amd-xgbe: Add Support for Yellow Carp Ethernet device")

However, the changes to allow updating the version data were made with

6f60ecf233f9 ("net: amd-xgbe: Disable the CDR workaround path for Yellow Carp Devices")

so that is the tag most likely needed should you want this to be able to
go to stable.

With a change to the Fixes: tag:

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-pci.c    | 5 +++++
>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 2 +-
>   drivers/net/ethernet/amd/xgbe/xgbe.h        | 1 +
>   3 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> index 2af3da4b2d05..f409d7bd1f1e 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
> @@ -285,6 +285,9 @@ static int xgbe_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   
>   		/* Yellow Carp devices do not need cdr workaround */
>   		pdata->vdata->an_cdr_workaround = 0;
> +
> +		/* Yellow Carp devices do not need rrc */
> +		pdata->vdata->enable_rrc = 0;
>   	} else {
>   		pdata->xpcs_window_def_reg = PCS_V2_WINDOW_DEF;
>   		pdata->xpcs_window_sel_reg = PCS_V2_WINDOW_SELECT;
> @@ -483,6 +486,7 @@ static struct xgbe_version_data xgbe_v2a = {
>   	.tx_desc_prefetch		= 5,
>   	.rx_desc_prefetch		= 5,
>   	.an_cdr_workaround		= 1,
> +	.enable_rrc			= 1,
>   };
>   
>   static struct xgbe_version_data xgbe_v2b = {
> @@ -498,6 +502,7 @@ static struct xgbe_version_data xgbe_v2b = {
>   	.tx_desc_prefetch		= 5,
>   	.rx_desc_prefetch		= 5,
>   	.an_cdr_workaround		= 1,
> +	.enable_rrc			= 1,
>   };
>   
>   static const struct pci_device_id xgbe_pci_table[] = {
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 2156600641b6..19b943eba560 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -2640,7 +2640,7 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
>   	}
>   
>   	/* No link, attempt a receiver reset cycle */
> -	if (phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
> +	if (pdata->vdata->enable_rrc && phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
>   		phy_data->rrc_count = 0;
>   		xgbe_phy_rrc(pdata);
>   	}
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
> index b875c430222e..49d23abce73d 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe.h
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
> @@ -1013,6 +1013,7 @@ struct xgbe_version_data {
>   	unsigned int tx_desc_prefetch;
>   	unsigned int rx_desc_prefetch;
>   	unsigned int an_cdr_workaround;
> +	unsigned int enable_rrc;
>   };
>   
>   struct xgbe_prv_data {
