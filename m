Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3906D902B
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbjDFHJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbjDFHJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:09:04 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A3693F4;
        Thu,  6 Apr 2023 00:08:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=muGISZDlAcm9lb0dA+CVfuLMKo5VDmfoHNeuf+l9exag4EyRdH51BPRnAbKX9BBcN867z1e6cCkl+jalSRmzB96LSU8bk9Z28K78mV1vsEgT0EtBgWuFa7+kTBvi4RXf5QQ51/8Wys9RiSJTB2V+dCWVTB2qZUp+GhDqPsD/dH5anPSIDpkByk2yXCRv0GMwekZctLfZZxcEAEDNotYTVWxYrQbr7jWmOxh/7YFElWvg/eLUdNYtMl+eHL/UcLP08ceXcfzTgjIkm+CeQnD85T68HJCjD7ksciamrfXQxntGuA9e2Dz6eBwJB7tgxu8vzO2MWhxFhjFq7qkOnotFiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zSdnxbH2cFWAaXDpj8MSj2RL8909hcc/ymXHiPQRo74=;
 b=bx4x43COu6eyFca4wxySODkhsFs5kWsJKQ4cc5DAAyfaNYyCjh0lEK/FO5jHim7TvAVsnpAQXtnrF4Qi10EPKnBFf+va7Qpc35Sunbr1b9zseekd5DTdGr7sW3enerqTLazvvmqDMTa0HR1zIfdkPQtC7v1BmX4Sd0YLQMofP11umAExPZ3/Y1DdlnM0xa1Mg8Jg4XIvmuaDznquoMW00wq7wRz1ic4ghgJ2dXJ3w2spsFoWr98DAxlRURKsZSo5kAe9YyGcxzQ2lCAPGuGZ/ODv5tMAZ/bS5yx55ieAvPJMWOuVx/8fFxS2P0uAWeVdfzayPMiq8RmMD8xx1slNhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSdnxbH2cFWAaXDpj8MSj2RL8909hcc/ymXHiPQRo74=;
 b=yojEpk935J8/rOHJvHE3eo2gjWvckXesD0ccMJbbW3sxOoqPN/yVlYYnO4I8FPVoklu0k3y7DxyFEft1QFjDcIES+sQ+bSV78P2BIibuWCESv2KWuzsac9jjeSwlpwEo/fVgVKaGAfvK5w60F1GKgljhWR5MBtKsdJ8fS97/VCc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by DM4PR12MB8522.namprd12.prod.outlook.com (2603:10b6:8:18f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Thu, 6 Apr
 2023 07:08:12 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 07:08:12 +0000
Message-ID: <f436b6aa-3107-34c7-3f6c-59f36daa6205@amd.com>
Date:   Thu, 6 Apr 2023 12:37:58 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v3 13/13] sfc: register the vDPA device
Content-Language: en-US
To:     Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        jasowang@redhat.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230406065706.59664-1-gautam.dawar@amd.com>
 <20230406065706.59664-14-gautam.dawar@amd.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <20230406065706.59664-14-gautam.dawar@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0193.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::16) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|DM4PR12MB8522:EE_
X-MS-Office365-Filtering-Correlation-Id: 22f12f29-4adf-4841-5d2c-08db366daefc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /DCyIsS8zcxh3xmfCBOX9HRqxJ/0Hj13y25UZZk0x8L06owS0ijHzdESXXff7n4wFTJUdIxmHBA3iFMaZJmorE2gjKwL4RdPLpf5ti8pjZNCAKaJGGgiC/HYw55WnLI1n8S0BvBTHB3iUdNRbl4BK4er0/fIZCd4DFw7BvvL+HlQ9GuuClAXNUu7jTH4w1B7z7tKYHsfmAT3ErwDyVmW0a4/cmr5hoihXncIl1oI26yVFPJF9xmoz3ozV71kXtctrtIWaIff3OlNvbGrrTmVFVU9ffRyBWWYAQbOV3hinelDYVoNKGOZPGqEyGi+OEuPPd4uN/T0AZPi4WdtU5lmmzHU1n0wnPV9uYPn1uqb0amWVSLBXl2RPfqJacCb/5gOqODejlnEn9vyQ5Z5b3xFMS7ShxuAJRnzSJtffo1q5bO6hZQFQH6R4Q7On2LQk8wq0JbwDFv3h/wL9rpXYdNfXn4tmIp7ao6suv7SrHdzHG+plA0OLVoJgq4JjA/c1s8HoHF9nfA04pkbJ78pS3q5A8vz8UBIYJqbRGIRQuTYtP8unnu5qIgk5ZNbI+5YpYQDcpp3FYNfz6dYkBtKvhVe64iBHvwe5mT/5bbEwxtHojneBhvGtSNLyxHoghfeE3Qcz0M7qB2EI8R5/4aHbu03QiMCj3y5dTojmcuerhVec00=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(31686004)(31696002)(921005)(38100700002)(83380400001)(2906002)(26005)(110136005)(6666004)(478600001)(41300700001)(316002)(36756003)(6486002)(5660300002)(53546011)(6512007)(6506007)(7416002)(8676002)(66476007)(8936002)(66946007)(66556008)(186003)(2616005)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWd5MVl3b0Uvck9hL0FFR1o4MnFtbHpCSUdHdWRZd0pYMnRRMlo4RzJVNEcv?=
 =?utf-8?B?NXk2NmVjdWVheE5yRkpSUWExS1lKbFU1OENnY0kzeHpkd2pYMlo0M3NwS1pa?=
 =?utf-8?B?RFZsbFBSa2VlRGJiQ2pFSEl3VnFVdnhnYkVqVHlqUDNYYlNtU2pMU3NORGVD?=
 =?utf-8?B?cXVCY054Z1JHVXN3aU10QU41MHo2cW96eFBMVlhScTFRbVhXNzZvaXBzcGdl?=
 =?utf-8?B?WW04eGNiTkNHQU1EeGNTdjIzbjMrSDE0QTdzSm9SWjU0VmI2bFZmQ3V6YWNj?=
 =?utf-8?B?SHR0L2lIOFRFWTl0L3lWTFIzZVZTMEcwUGRIVUo3ODhpZ0wwWDZRY3d5SnVz?=
 =?utf-8?B?YWxhS3BwUTQ4OEdUTjhjaFNmbkJHRjA0SUd3Zlg3RVRLbUpGWG9rRW5KTTRo?=
 =?utf-8?B?aFFjNEpVWkpFWEQ5RDhZdm8zcGozWHFXZUIreEpFTDM1a0ZhZnZ5U1JDSllv?=
 =?utf-8?B?bjZDTzBYTmVXdlhUODFLRHdhQStMNUlNaDhTWXRTdzdDSHMzQUVCN2hJWGo4?=
 =?utf-8?B?Ry8wWFJxLzdON3RTVTBnMGhMQVp4ZUJabitWWnY2OGFPblNjSHJDQlh1S0xW?=
 =?utf-8?B?aXVCL2JLdnEzNjlLbWFETXl5TjBqdmpoUi8rYm4rOVRtenhqU1dzNXR0VG1p?=
 =?utf-8?B?NDFtdmdEcWpJdG4wMzJVZDZBNGFjdXlaU1ZzckI5RGVkZmZRZ3gvc2VxZlMx?=
 =?utf-8?B?T2ZWZUxBS1d4amw3VGh1SWFNMVhVM0NHaktKYXdNYWJtT3YvZkM5SERhTWE1?=
 =?utf-8?B?QTE1MHYyUU1GZjBPanU0aG5QTE9zZFl5ZW9iTEJsbGtxczZsVGN0MkExU3dB?=
 =?utf-8?B?dDVybFF4UmxScVNPdER4ZFg1OTNFVkhwZDYweVNYOUZJcUxwY1ljZHNJdjBH?=
 =?utf-8?B?emgrZ1VCZEFvOUFnamdvYmZ4U1BlOGw5dVI2cXJpaU5IaFQ3MWpuZENyVWdq?=
 =?utf-8?B?dWhqMXV1SEYvTDM0NVlaL0NPeFByYVF0dVlYMXZsZ0hvUDJXUlUwYXNjd0p1?=
 =?utf-8?B?NE5zeDg3ejhVS2wvMHVxakJWZ3I4QStZcmRTL2lKcUVhT29CTmJiVWJZUU56?=
 =?utf-8?B?VzdpUjhHWEV6dHN6V0FVSE04K3psQm12WGZaUE1DTCtlTGpsOHZLcGxxTWND?=
 =?utf-8?B?TFFybUlhWVJPWUc1NW11NDdKbk56WUQ0OHFTNUxqaTdVa3pJaDBIMzRwS3Fy?=
 =?utf-8?B?STdEK3JNSE1JM3YvMzEySTU1Z2JiWTdra2tHcEVSbmRna0pMK3ZidzJ2TmJC?=
 =?utf-8?B?ZnhsZDJ2MlZwK3B5R3Z5endiMnU4RE5wZEJoZzB6ZExsWHB0WkZIaE1zSTJi?=
 =?utf-8?B?UEp5bWw5RkhIMS9rQkVJZVl0ZDgrT2VKbitHdXFvQnhUQXZQSGVQMlFCKzZK?=
 =?utf-8?B?VjZoUU9rYWc4YnRWdmhQcjQ5QzNlMm1QdTZRK0ozOXhJNWM1T0xGN0ErTlZ6?=
 =?utf-8?B?NDRablBWUmhWTFVsS3VoeE1FWDRKVVlDVTNoNzM5SkdRUkhJaklmYUNLeXZZ?=
 =?utf-8?B?Tnp0RGJBYjZVODhjdEdKZlRvU0FYL2cyVVFiOWlTTWV0UmIvYVVNV0IxM253?=
 =?utf-8?B?YXJIaEhJUlRIK1Ztd3JZb2dqdkRuUHd6aXNjTjZEUlZ0c0RTQ3pWVmtJVDFL?=
 =?utf-8?B?VlgwMGFEYnZFNlNnVDdqQ2JBaXMyS2xhSFYrRm5XWkRIZ0xINUtoOTk2QlYw?=
 =?utf-8?B?YWR6RExnZmdJdEsyOGt6L3pscThCN0xyTzdhRkdxS1duRnQ1WnZydmhvdm4z?=
 =?utf-8?B?SHJJL25hSXRKKy9KZ3NPcFVRbjNXVjZ4clVHbEhsZC9nNTVRUlNLV25TMlRs?=
 =?utf-8?B?ZHdKK2NHUmx1MkdiRDVDVlhFMWRZM3Q3WW8yZ0FpR2YzZVUyeWNHelhIK0cw?=
 =?utf-8?B?cHViM2p1WU4xT3RJUDdXR0FYRVFPMXdWYTVSMGNtelV1aGtNZHBkUzlRcUI3?=
 =?utf-8?B?YWM2cnZmOTUwZDVVYktROTkzOTJCcFpESUVPUFo4d0xmYXdheWQwNW92VUlE?=
 =?utf-8?B?anBodVh4Mk9MNnhUbjMzRE10TnQyYk5ZWU5VNmZ2clMzQ0VlMjRMeVRtRWtU?=
 =?utf-8?B?S1k2SzFPVXpJWGFsZG9EWlNiQ0xpK2UzU1czU3BFWE11Y2V4WWdSRVUzOWE4?=
 =?utf-8?Q?WYF/IooRg5qt8KtCPwbGsdkZJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f12f29-4adf-4841-5d2c-08db366daefc
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:08:12.1745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KiBwzdrQpr6DgtVRI4z9W0CRw/IWhZYzNmcC3H5KZivch2WCVqWQRigkqbD6DbhO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8522
X-Spam-Status: No, score=-0.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pls ignore this patch. It seems to be a stale patch (may be from v1 or v2).

Let me know if it is required to re-send the series without this patch 
and call it v4.


Regards,

Gautam

On 4/6/23 12:26, Gautam Dawar wrote:
> Register the vDPA device which results in adding the device
> to the vDPA bus which will be probed by either of the vDPA
> bus drivers: virtio_vdpa or vhost_vdpa.
>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>   drivers/net/ethernet/sfc/ef100_vdpa.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
> index 50c062b417aa..a6bf43d98939 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
> @@ -239,8 +239,7 @@ static void ef100_vdpa_delete(struct efx_nic *efx)
>   			}
>   		}
>   
> -		/* replace with _vdpa_unregister_device later */
> -		put_device(&vdpa_dev->dev);
> +		_vdpa_unregister_device(&efx->vdpa_nic->vdpa_dev);
>   	}
>   	efx_mcdi_free_vis(efx);
>   }
> @@ -375,7 +374,14 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>   	if (rc)
>   		goto err_put_device;
>   
> -	/* _vdpa_register_device when its ready */
> +	rc = _vdpa_register_device(&vdpa_nic->vdpa_dev,
> +				   (allocated_vis - 1) * 2);
> +	if (rc) {
> +		pci_err(efx->pci_dev,
> +			"vDPA device registration failed, vf: %u, rc: %d\n",
> +			nic_data->vf_index, rc);
> +		goto err_put_device;
> +	}
>   
>   	return vdpa_nic;
>   
