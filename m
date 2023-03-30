Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57016CFF23
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjC3Ivr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjC3IvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:51:19 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A998A68;
        Thu, 30 Mar 2023 01:50:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhfRuW3I2Hqjm7XypU+eCxIrc0sYb35+nginsZAmIZzq2CBuHWW+mTZWvHvyDLbDmHBNRC6iynJxc4ww7U79l/zixEWfrpM6umjxS4m9zKSn7KJvwaMIeNlzDXE9BeQ6Jsc7YA5NgEB9x6ZdujnvMeLrNNmutKOsukxzwC/LhSu8G7AOyPCM345lodRyiP5fccLSL9kx43fRDH6kbhgGV+dHv36Z8dsWUSv8YBvHAZ8+EigNU7QzYfrIeH/JUOUl3jmVE+xdXw91pPpF7TjR3JiTp2zqLQRK5KWLnRGYXlUTbe8r0l+1f+awqjgTPqGWQ3rX84Ruz2ShaIOWG1LKFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eqi5fwaz6U5F0sKqTUnlzsZZmNZAeYTrv13W+R9aG3M=;
 b=b707w9ES3blBbk9/K6bIFdreXgMoq+xiyYHPzQMInLPi9UZH0wFbZm6JcDeDO8F/RgtbYqx4zxoproUl3uCEnl7BcmQAfmO33OAgNIQHfLW/x6VX7X4a3eVSR/GvLyPfcLy+FXwNaEvc6F17RsBQNVlWnyNHiRgAkcv24wlcNjMm/xRh7IK6aL+PGxwOTCKQH+KmwOUM8FN2mQW047F237bYsIXb1JOyQreoFdkY+zGFgT8vo9rRJxBfoLFRzSeEksPkUmViyk2+adDSO7jqi5jhbsXN/9JkIuoW+kUbgYypyISm8/RXCs+AEqMYtyt+PyVBD53PBQXI++zRAgLEaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eqi5fwaz6U5F0sKqTUnlzsZZmNZAeYTrv13W+R9aG3M=;
 b=Pdtp1F8U20ULqsm69jTBfmI++sQsQaIO/RppoPugIoR5zMyFFchxIcZpZvt+5jB+3GaGLjcsQqBzit7pDkTODGT2IlD6lJ+20GyOTzoDMOB5JCa0kDI4cuPEly5/59wB6NoP0sLoh6JRRm674vWEnxyzRRTpWhreP8NOXLv8oyrmh2Ake5gNpkkx/tQZ0oF2PoMcDWagbebKVLecrZhGu1TY9ExwPz8f7vYoR+ejt2eE92CfzPPG9u1kV07pC9Rbn5I8+Mh/5BR4SOtX9z7XnFTonju7nHbRcJIOxe521dxkIyzcKWU4NTxZpktdrDLOaVisOZ5pHIyk5afiCuLLMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 PH7PR12MB6587.namprd12.prod.outlook.com (2603:10b6:510:211::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 08:50:41 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::abe1:c2f2:c4bb:ba78]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::abe1:c2f2:c4bb:ba78%2]) with mapi id 15.20.6254.021; Thu, 30 Mar 2023
 08:50:41 +0000
Message-ID: <502523a9-9737-d9ce-8ee5-ca8d39fc0c52@nvidia.com>
Date:   Thu, 30 Mar 2023 09:50:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 4/5] serial: 8250_tegra: Add explicit include for of.h
To:     Rob Herring <robh@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20230329-acpi-header-cleanup-v1-0-8dc5cd3c610e@kernel.org>
 <20230329-acpi-header-cleanup-v1-4-8dc5cd3c610e@kernel.org>
Content-Language: en-US
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20230329-acpi-header-cleanup-v1-4-8dc5cd3c610e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0417.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::21) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|PH7PR12MB6587:EE_
X-MS-Office365-Filtering-Correlation-Id: 887686ea-9cf4-437b-7f29-08db30fbd702
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q1uU3pHquNG8d1PGDl54KNmh62fhkxMPG+UGLMR2MTG6P0mgQmB7cRz6QiKsGL3N8T5dVIOwP4VSFI59ILDZ2Br0IWqVXnh4RsfoV+qRtrOpREGHxE6fl/wn3iCijiyhjN4Wi0+d2HzkHcXP2GGuztw+lJh5/mGBC/2eD8JvA4EEvG3USAp3VYFexBN0BR431RY2Z7PJeAhmNSDDqFsrrWc2qE7LNIWP5VGD2808uLDI7vy/4rlIrXke98MMZM00Nv/z2anGZ4Ar70cfPYVPitHnE81g6xKkuf9C8f0axfFffHOZzvgU6V2ERfmuCEp+mJCLRGQYv/tSV2VEC+1+wf2TCGWJdmzSFm7TMWt0Y+pKWOnweUx5Dhv6XZ5d4zGbB/i3WupyQV87MqWlpc0vvkR+kNjULme1IfEYon9Kr/Y7PF+z5Qbx9U7mj8OF/z6k8C2yRAmuFO+BcN71JcI5XGzZwoVR8NXPpxbpp17yenoE+vLpX3c3QkrxPUo12iUye57dNzzC5dIfXWH7jmCal48kmlQbt6D18CvB5z1w9d8233Key8C8Ud5FtgagTbX1sAipV0vfKNLP+J4+jBwMoFiZ2nY1Vl551SHuCNJEdXS3yX7Fp0dKNVkN48b8X+W81SNLlj+wux6c9WJaF6bS+vAgxdgpkpsvlPY4BXh7SsI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199021)(4744005)(2906002)(31686004)(41300700001)(2616005)(316002)(66556008)(6666004)(110136005)(7416002)(8936002)(6486002)(36756003)(8676002)(4326008)(66476007)(66946007)(478600001)(86362001)(31696002)(53546011)(921005)(55236004)(6512007)(6506007)(5660300002)(26005)(186003)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnExQkFHRkhuY0NZWTA3SU1xMExMNzFEbzNWSk1jNXMvYjVvNTJnS0FVeUM5?=
 =?utf-8?B?eWh5SWRqOUxVcU5ucHcwSjZSeTAxMzZyK3drNUdsR2k5VlRCNVVjNTNCbW04?=
 =?utf-8?B?aXNKNS9jbnB4ckExRUx5TFBNdUZEN3hyRWM4alNBZlh3QVlOR0JHTHdCSVRP?=
 =?utf-8?B?VTNIbEk5eTdmc1FJNGFMajA1Q1hoMG9RdVgrcm1hZ1ZjOU9VbytPaTFnZUVW?=
 =?utf-8?B?Mk1WQW41SzRrUU1qQ3dhbW8xSFJUN2RvdkRjZVV5eHJoU1F6VHN6NCtjZnRo?=
 =?utf-8?B?VVZacSttQzRCZ1dwczBZSmRNNXVEYXlLSXFYUWRpeGZTQ0dNMTZpNWtnU2Qx?=
 =?utf-8?B?dzU2aEZsMDE3YmJ3eW9aTFNKZDArQVRhMTFiekdzbXpYTG9tVGVFK0QzSGlB?=
 =?utf-8?B?S2hWU20wbUlLYmRIdDBxT2Y4b2lJZzM2YkRxalBqTmZqVDhiN3Zhdjh3WlhW?=
 =?utf-8?B?d3ZDbmNXWkRNM1laMng4QVdvbFJHci9USFJVN2praXJoV1YyUXZCcGNMKy8y?=
 =?utf-8?B?M3FmWjVoajdLYlNJVGE4dXZndEU4aFZDYUVJRkxkaXd4eEdtbGx0MCs3K1gz?=
 =?utf-8?B?UUhDREg2QVdobUgycjhKSkM1eW5rdW9OU2hrVGJmS285SEFlbU5EakdSUUl4?=
 =?utf-8?B?U1NIc1BSanBweUd5cld2am8vaC9XQzEyNlIyalpZLytDdHR5UG1FTDNhSVVV?=
 =?utf-8?B?ZmUySlNZNmZYRkMwN2xMMDdUTW83RWNqT0VOanY5elhwdHNQOVJlNHQ0MnRy?=
 =?utf-8?B?Sm0vMCs4ckw1UmNqOXhXM0RudWFMcnZMNVJhVnc1b0lxQUxXZEE4NFZ6UUtn?=
 =?utf-8?B?QW1CaEp4bTFVQXR6MzdqYWN2TlJpRnZTU3E2RkJpekQrZmUwc3ZKOXRuNHg4?=
 =?utf-8?B?Z2c3aWd4REYvTk1rNDhKSnV1UnFzR2NhVWxMMHRIUnRxOVdvclhTcUZHWXZ6?=
 =?utf-8?B?QjgzR1VIZUxCdENMeEMxY2UwNjF2T1VGcW5PYVFVYTlEWXVuVTljaVpUZzd2?=
 =?utf-8?B?cGVpZy85bkdmNDhadWlsQzJQWW02bmhIN09FclUzeFZjZFlpSkYvTlhDTkJU?=
 =?utf-8?B?dW5UcmgvemhTVnRJYUY0OElTNXQxQklHUUs4TVVmbkpPTjY3S0JJN2JyaTYv?=
 =?utf-8?B?Q3ZIcmhWOStYdkVSdGRQMmtPN1Y0aCtwRURRVng2ZzRtZVZOaXN3dmtzM1do?=
 =?utf-8?B?OXczS2ttU0htemhLcUxDdUJGc0dWNk9YL1JFTEx0RzE0cjBGNk5YV2Vzek03?=
 =?utf-8?B?RVNoWitoMGh4R1NEMzRpS0o5cWtOTHFyT0c1cTBYRWF6WkZtN1gzUWtFaWZV?=
 =?utf-8?B?UzBwS21HRTlKWkVzdE8xVTd1N1Evd2duZmwyQTZqNktPeVFTU1JJWVJHWHIz?=
 =?utf-8?B?cXByMjYrUDduaENpeGlCUGZqTUJNU2dZSEtnV1BDZVUrMlFtOGozRS8vMEwz?=
 =?utf-8?B?UXJEdjI4UThoVHo1NllObVpFd2d4dHJDSFRiNENtVUxPWmNKQWxoZVNWdXJT?=
 =?utf-8?B?LzhXbUhZTm5va1EvWUMvN1FCU3JjZmNVcG9XTEZVcDk0QXE2WmtWemRadmNO?=
 =?utf-8?B?VTlhOHg0RThyeEpqTys4T2dLUnBjODQvV2RIcVNYcDhEaWxHb0ZPVzJpTkRK?=
 =?utf-8?B?ZlJleExVb1pOQTJMeWxaT0t1K2llQkpBekQ0M1VxeUtNMXdmRG16RDZHSDFt?=
 =?utf-8?B?bzRzN1p2NEorR3ZmNHNVNVNRYUhEWTV3RVZ1Tll5VGN2ZHorQkt5MzdYcmwy?=
 =?utf-8?B?N1MxeHVoSG9uTU5TNG5WOEtmZHZlNWlBKzVqSTB0VmJKU0hQTy9JS01tNXFl?=
 =?utf-8?B?NVRtWlorcWlzRVFrZ2dURHVnYWtuSG1WOFVodTk2a0dQTVl3SVpYS2ptOTVy?=
 =?utf-8?B?eTJtVEV4MEpMak1lVjFZYVN3Q0IxeTA0U052cWJwckQzTWdpelp3T1BZdDFB?=
 =?utf-8?B?OFJtNEpiNEgxUmJ0RytPNHZuV1B4SlVtWjAzU1NESVNqOVhkRmswSUhyWDcw?=
 =?utf-8?B?T3dEV1J5aDJ2NmFXKzArcnE3eHhGZHBHSUFpZjkrZEc4ZXZueWFTRXNEMFpO?=
 =?utf-8?B?SHJiTGF2THdtYm84SHhTTnFBVnQ3L0t1N0xJeXllR3FIV0tJSjVBSDlMb3Qv?=
 =?utf-8?B?R3ZxNDFWNVVaUEFWVXdhUlJBa1BSY3RvdHlIMW1HWmIwdi9nKzNMSDhiRm9a?=
 =?utf-8?B?eVE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 887686ea-9cf4-437b-7f29-08db30fbd702
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 08:50:41.0173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1A2OHZBSMWyPnKRifX0I/YPxAxz5T31l2E/AOwMR1z0pFDa4v3N7k4UYyW7MjUg0TnwoPbLwZyazuL2lxmpIQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6587
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29/03/2023 22:20, Rob Herring wrote:
> With linux/acpi.h no longer implicitly including of.h, add an explicit
> include of of.h to fix the following error:
> 
> drivers/tty/serial/8250/8250_tegra.c:68:15: error: implicit declaration of function 'of_alias_get_id' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>   drivers/tty/serial/8250/8250_tegra.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/tty/serial/8250/8250_tegra.c b/drivers/tty/serial/8250/8250_tegra.c
> index e7cddeec9d8e..2509e7f74ccf 100644
> --- a/drivers/tty/serial/8250/8250_tegra.c
> +++ b/drivers/tty/serial/8250/8250_tegra.c
> @@ -11,6 +11,7 @@
>   #include <linux/delay.h>
>   #include <linux/io.h>
>   #include <linux/module.h>
> +#include <linux/of.h>
>   #include <linux/reset.h>
>   #include <linux/slab.h>
>   
> 


Reviewed-by: Jon Hunter <jonathanh@nvidia.com>

Thanks!
Jon

-- 
nvpublic
